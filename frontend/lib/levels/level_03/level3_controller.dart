import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import '../../models/item.dart';
import '../../systems/inventory_manager.dart';
import '../../systems/puzzle_manager.dart';
import 'level3_data.dart';
import 'level3_theme.dart';
import 'services/level3_progress_service.dart';

/// Screens of Level 3: the welcome card, the playable room, and the
/// completion card (shown on top of the restored room).
enum Level3Phase { welcome, playing, completed }

/// Which panel is open on top of the room, if any.
enum Level3Overlay { none, note, panel }

/// Feedback state of the reset panel.
enum Level3PanelStatus { idle, wrong, correct }

/// Holds all the game-logic state for Level 3 ("The Servers").
///
/// Reuses the shared [InventoryManager] (collected cables) and
/// [PuzzleManager] (sequence validation) instead of custom classes.
class Level3Controller extends ChangeNotifier {
  // ---- Room layout (logical units, scaled to any screen) ---------------
  static const double roomWidth = 1600;
  static const double roomHeight = 760;
  static const double wallThickness = 56;
  static const double lunaRadius = 28;
  static const double lunaSpeed = 320;
  static const double interactionRadius = 105;
  static const double revealRadius = 125;

  static const Offset lunaStart = Offset(170, 385);
  static const Offset notePosition = Offset(1370, 650);
  static const Offset panelPosition = Offset(1460, 262);
  static const Offset keyPosition = Offset(1290, 290);

  /// Solid objects Luna collides with (she slides along their edges).
  static const List<Rect> obstacles = [
    Rect.fromLTWH(400, 40, 790, 172), // server row + side cabinets
    Rect.fromLTWH(76, 40, 170, 96), // control desk (top-left)
    Rect.fromLTWH(1386, 40, 148, 172), // reset console (top-right)
  ];

  /// Area in front of the exit door (right wall). Luna cannot walk
  /// through the wall, so she stops here even when the door is open.
  static const Rect exitDoorZone = Rect.fromLTWH(1470, 300, 80, 170);

  final InventoryManager inventory = InventoryManager();
  final PuzzleManager _puzzleManager = PuzzleManager();
  final Level3ProgressService _progressService = Level3ProgressService();

  Level3Phase phase = Level3Phase.welcome;
  Level3Overlay overlay = Level3Overlay.none;

  // Movement.
  Offset lunaPosition = lunaStart;
  double lunaAngle = 0;
  double walkPhase = 0;
  bool isMoving = false;
  Offset _joystickVector = Offset.zero;

  // Cables.
  final Map<int, Offset> cablePositions = {};
  final Set<int> revealedCables = {};

  // Progress.
  bool noteRead = false;
  bool levelCompleted = false;
  bool key3Obtained = false;
  bool systemRestored = false;
  bool savedCompleted = false;
  int wrongAttempts = 0;

  // Real-time alerts.
  bool alarmBannerExpanded = true;
  String? toastMessage;
  Color toastColor = Level3Theme.neonBlue;
  int toastId = 0;

  // Reset panel puzzle.
  List<int> slotCableIds = [-1, -1, -1];
  List<int> trayCableIds = [];
  Level3PanelStatus panelStatus = Level3PanelStatus.idle;

  // Timer.
  final Stopwatch _stopwatch = Stopwatch();
  int elapsedSeconds = 0;

  Timer? _loopTimer;
  DateTime? _lastTick;
  String? _lastTarget;
  int _sessionToken = 0;
  bool _disposed = false;
  bool _atExitDoor = false;

  Level3Controller() {
    _lastTick = DateTime.now();
    _loopTimer = Timer.periodic(
      const Duration(milliseconds: 16),
      (_) => _tick(),
    );
  }

  // ---- Getters ---------------------------------------------------------

  int get collectedCount => inventory.items.length;

  Set<int> get collectedCableIds =>
      inventory.items.map((item) => item.id).toSet();

  bool get allCablesFound =>
      Level3Data.cables.every((cable) => inventory.hasItem(cable.id));

  bool get allSlotsFilled => !slotCableIds.contains(-1);

  String get formattedTime {
    final minutes = (elapsedSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (elapsedSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  /// What Luna can interact with right now: 'note', 'panel' or
     /// `cable_<id>`. Null if nothing is in range.
  String? get nearbyInteractableId {
    if (phase != Level3Phase.playing || overlay != Level3Overlay.none) {
      return null;
    }

    for (final cable in Level3Data.cables) {
      if (inventory.hasItem(cable.id)) continue;
      if (!revealedCables.contains(cable.id)) continue;
      final pos = cablePositions[cable.id];
      if (pos != null && (pos - lunaPosition).distance < interactionRadius) {
        return 'cable_${cable.id}';
      }
    }

    if ((notePosition - lunaPosition).distance < interactionRadius) {
      return 'note';
    }

    if (!levelCompleted &&
        (panelPosition - lunaPosition).distance < interactionRadius) {
      return 'panel';
    }

    return null;
  }

  /// Where to draw the bouncing arrow above the nearby object.
  Offset? get indicatorPosition {
    final id = nearbyInteractableId;
    if (id == null) return null;
    if (id == 'note') return notePosition + const Offset(0, -34);
    if (id == 'panel') return const Offset(1460, 226);
    final cableId = int.tryParse(id.substring('cable_'.length));
    final pos = cableId == null ? null : cablePositions[cableId];
    return pos == null ? null : pos + const Offset(0, -104);
  }

  // ---- Lifecycle -------------------------------------------------------

  /// Loads any previously saved progress for this level.
  Future<void> init() async {
    final saved = await _progressService.loadProgress();
    if (_disposed || saved == null) return;

    savedCompleted = saved['completed'] as bool? ?? false;

    if (!savedCompleted) {
      noteRead = saved['noteRead'] as bool? ?? false;
      final foundIds = (saved['foundCables'] as List?)?.cast<int>() ?? <int>[];
      for (final id in foundIds) {
        final matches = Level3Data.cables.where((c) => c.id == id);
        if (matches.isNotEmpty) inventory.addItem(matches.first);
      }
    }

    notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    _loopTimer?.cancel();
    super.dispose();
  }

  /// Whether the player should be allowed into Level 3.
  ///
  /// TODO(integration): HU-01 says this should check that Level 2 is
  /// completed and Key 2 was obtained. Level 2 does not exist yet in this
  /// repository, so this always returns true so the level can be tested
  /// standalone. The integration team should replace this body once
  /// Level 2's completion state exists in the shared game state.
  bool canAccessLevel3() => true;

  // ---- Phase transitions ----------------------------------------------

  Future<void> startGame() async {
    if (savedCompleted || levelCompleted) {
      await _resetProgress();
    }
    if (_disposed) return;
    _beginPlaying();
  }

  Future<void> playAgain() async {
    await _resetProgress();
    if (_disposed) return;
    _beginPlaying();
  }

  Future<void> _resetProgress() async {
    inventory.clear();
    noteRead = false;
    levelCompleted = false;
    key3Obtained = false;
    systemRestored = false;
    savedCompleted = false;
    wrongAttempts = 0;
    await _progressService.clearProgress();
  }

  void _beginPlaying() {
    final token = ++_sessionToken;

    phase = Level3Phase.playing;
    overlay = Level3Overlay.none;
    panelStatus = Level3PanelStatus.idle;
    systemRestored = false;

    lunaPosition = lunaStart;
    lunaAngle = 0;
    walkPhase = 0;
    isMoving = false;
    _joystickVector = Offset.zero;

    revealedCables.clear();
    _placeCablesRandomly();
    slotCableIds = [-1, -1, -1];
    trayCableIds = [];

    alarmBannerExpanded = true;
    _stopwatch
      ..reset()
      ..start();
    elapsedSeconds = 0;

    notifyListeners();
    _showToast(
      'ENCUENTRA LOS 3 CABLES OCULTOS',
      Level3Theme.neonBlue,
      ms: 3400,
    );

    Future.delayed(const Duration(seconds: 4), () {
      if (_disposed || token != _sessionToken) return;
      alarmBannerExpanded = false;
      notifyListeners();
    });
  }

  // ---- Game loop -------------------------------------------------------

  void setJoystickVector(Offset vector) {
    final magnitude = vector.distance;
    _joystickVector = magnitude > 1 ? vector / magnitude : vector;
  }

  void _tick() {
    final now = DateTime.now();
    var dt = now.difference(_lastTick ?? now).inMicroseconds / 1000000.0;
    _lastTick = now;
    if (dt > 0.05) dt = 0.05;

    if (_disposed || phase != Level3Phase.playing) return;

    var changed = false;

    final secs = _stopwatch.elapsed.inSeconds;
    if (secs != elapsedSeconds) {
      elapsedSeconds = secs;
      changed = true;
    }

    if (overlay == Level3Overlay.none && _joystickVector != Offset.zero) {
      _move(dt);
      walkPhase += dt * 14;
      isMoving = true;
      changed = true;
    } else if (isMoving) {
      isMoving = false;
      changed = true;
    }

    if (_revealNearbyCables()) changed = true;

    final atExitDoor = systemRestored && exitDoorZone.contains(lunaPosition);
    if (atExitDoor && !_atExitDoor) _onReachedExitDoor();
    _atExitDoor = atExitDoor;

    final target = nearbyInteractableId;
    if (target != _lastTarget) {
      _lastTarget = target;
      changed = true;
    }

    if (changed) notifyListeners();
  }

  void _move(double dt) {
    final delta = _joystickVector * lunaSpeed * dt;
    const minX = wallThickness + lunaRadius;
    const maxX = roomWidth - wallThickness - lunaRadius;
    const minY = wallThickness + lunaRadius;
    const maxY = roomHeight - wallThickness - lunaRadius;

    // Each axis is resolved separately, so when Luna hits an obstacle
    // diagonally she slides along its edge instead of getting stuck.
    final nextX = _clampD(lunaPosition.dx + delta.dx, minX, maxX);
    if (!_collidesAt(Offset(nextX, lunaPosition.dy))) {
      lunaPosition = Offset(nextX, lunaPosition.dy);
    }

    final nextY = _clampD(lunaPosition.dy + delta.dy, minY, maxY);
    if (!_collidesAt(Offset(lunaPosition.dx, nextY))) {
      lunaPosition = Offset(lunaPosition.dx, nextY);
    }

    if (delta.distance > 0.01) {
      lunaAngle = atan2(delta.dy, delta.dx);
    }
  }

  bool _collidesAt(Offset point) {
    for (final o in obstacles) {
      final closest = Offset(
        _clampD(point.dx, o.left, o.right),
        _clampD(point.dy, o.top, o.bottom),
      );
      if ((closest - point).distance < lunaRadius) return true;
    }
    return false;
  }

  double _clampD(double value, double min, double max) {
    if (value < min) return min;
    if (value > max) return max;
    return value;
  }

  // ---- Cables ----------------------------------------------------------

  void _placeCablesRandomly() {
    final rng = Random();
    final placed = <Offset>[];
    const fallbackSpots = [
      Offset(430, 560),
      Offset(820, 470),
      Offset(1180, 600),
    ];

    for (var i = 0; i < Level3Data.cables.length; i++) {
      Offset? spot;
      for (var attempt = 0; attempt < 80; attempt++) {
        final candidate = Offset(
          220 + rng.nextDouble() * 1160,
          290 + rng.nextDouble() * 350,
        );
        final ok =
            placed.every((p) => (p - candidate).distance > 230) &&
            obstacles.every((o) => !o.inflate(70).contains(candidate)) &&
            (candidate - notePosition).distance > 170 &&
            (candidate - lunaStart).distance > 230 &&
            (candidate - panelPosition).distance > 180;
        if (ok) {
          spot = candidate;
          break;
        }
      }
      placed.add(spot ?? fallbackSpots[i % fallbackSpots.length]);
    }

    cablePositions.clear();
    for (var i = 0; i < Level3Data.cables.length; i++) {
      cablePositions[Level3Data.cables[i].id] = placed[i];
    }
  }

  /// Hidden cables become visible when Luna steps close to their circle.
  bool _revealNearbyCables() {
    var revealedAny = false;
    for (final cable in Level3Data.cables) {
      if (inventory.hasItem(cable.id)) continue;
      if (revealedCables.contains(cable.id)) continue;
      final pos = cablePositions[cable.id];
      if (pos == null) continue;
      if ((pos - lunaPosition).distance < revealRadius) {
        revealedCables.add(cable.id);
        revealedAny = true;
        _showToast('CABLE DE ${cable.name} ENCONTRADO', _cableColor(cable.id));
      }
    }
    return revealedAny;
  }

  Color _cableColor(int cableId) =>
      Level3Theme.colorFromName(Level3Data.cableColorNames[cableId] ?? '');

  void collectCable(Item cable) {
    if (levelCompleted || inventory.hasItem(cable.id)) return;
    inventory.addItem(cable);
    notifyListeners();
    _saveProgress();

    if (allCablesFound) {
      _showToast(
        'TODOS LOS CABLES  ·  VE AL PANEL DE REINICIO',
        Level3Theme.neonGreen,
        ms: 3400,
      );
    } else {
      _showToast(
        'RECOGISTE EL CABLE DE ${cable.name} ($collectedCount/3)',
        _cableColor(cable.id),
      );
    }
  }

  /// Performs the action of the contextual button.
  void interact() {
    final id = nearbyInteractableId;
    if (id == null) return;

    if (id == 'note') {
      openNote();
    } else if (id == 'panel') {
      openPanel();
    } else if (id.startsWith('cable_')) {
      final cableId = int.tryParse(id.substring('cable_'.length));
      final matches = Level3Data.cables.where((c) => c.id == cableId);
      if (matches.isNotEmpty) collectCable(matches.first);
    }
  }

  // ---- Note --------------------------------------------------------------

  void openNote() {
    _joystickVector = Offset.zero;
    overlay = Level3Overlay.note;
    if (!noteRead) {
      noteRead = true;
      _saveProgress();
    }
    notifyListeners();
  }

  // ---- Reset panel -------------------------------------------------------

  void openPanel() {
    _joystickVector = Offset.zero;
    trayCableIds = inventory.items.map((item) => item.id).toList()
      ..shuffle(Random());
    slotCableIds = [-1, -1, -1];
    panelStatus = Level3PanelStatus.idle;
    overlay = Level3Overlay.panel;
    notifyListeners();
  }

  void tapTray(int cableId) {
    if (panelStatus != Level3PanelStatus.idle) return;
    final emptyIndex = slotCableIds.indexOf(-1);
    if (emptyIndex == -1) return;
    slotCableIds[emptyIndex] = cableId;
    trayCableIds.remove(cableId);
    notifyListeners();
  }

  void tapSlot(int index) {
    if (panelStatus != Level3PanelStatus.idle) return;
    final cableId = slotCableIds[index];
    if (cableId == -1) return;
    trayCableIds.add(cableId);
    slotCableIds[index] = -1;
    notifyListeners();
  }

  void confirmSequence() {
    if (!allSlotsFilled || panelStatus != Level3PanelStatus.idle) return;

    final userAnswer = slotCableIds
        .map((id) => Level3Data.cableColorNames[id] ?? '')
        .join(',');
    final correctAnswer = Level3Data.correctSequence.join(',');

    final isCorrect = _puzzleManager.validateAnswer(
      userAnswer: userAnswer,
      correctAnswer: correctAnswer,
    );

    final token = _sessionToken;

    if (isCorrect) {
      _completeLevel(token);
      return;
    }

    wrongAttempts++;
    panelStatus = Level3PanelStatus.wrong;
    notifyListeners();

    Future.delayed(const Duration(milliseconds: 1600), () {
      if (_disposed || token != _sessionToken) return;
      if (panelStatus != Level3PanelStatus.wrong) return;
      trayCableIds = [...trayCableIds, ...slotCableIds.where((id) => id != -1)]
        ..shuffle(Random());
      slotCableIds = [-1, -1, -1];
      panelStatus = Level3PanelStatus.idle;
      notifyListeners();
    });
  }

  void closeOverlay() {
    overlay = Level3Overlay.none;
    notifyListeners();
  }

  // ---- Completion ----------------------------------------------------------

  /// "CONTINUAR" on the completion card: hides the card and gives control
  /// of Luna back in the restored room (open door, key, green lights).
  void continueExploring() {
    if (phase != Level3Phase.completed) return;
    phase = Level3Phase.playing;
    overlay = Level3Overlay.none;
    notifyListeners();
  }

  /// Called once each time Luna reaches the open exit door.
  ///
  /// The door is shown open, but Luna cannot cross it because Level 4 is
  /// not part of this repository.
  ///
  /// TODO(integration): this is the hook to move the player to Level 4.
  /// When the levels are joined, the integration team can navigate from
  /// here (for example through a callback passed from Level3Screen, or
  /// through the shared GameManager) to the Level 4 screen.
  void _onReachedExitDoor() {}

  void _completeLevel(int token) {
    panelStatus = Level3PanelStatus.correct;
    levelCompleted = true;
    key3Obtained = true;
    _stopwatch.stop();
    elapsedSeconds = _stopwatch.elapsed.inSeconds;
    notifyListeners();
    _saveProgress();

    // TODO(integration): this is where the integration team should notify
    // the shared GameManager that Level 3 is complete, so it can award
    // AppConfig.level3Score and unlock Level 4. Left as a hook on purpose,
    // since GameManager currently assumes only 3 total levels.
    // Example, once GameManager supports it:
    //   GameManager.instance.completeLevel(AppConfig.level3Score);

    // 1) "CORRECTO" is shown in the panel for ~3 seconds.
    Future.delayed(const Duration(seconds: 3), () {
      if (_disposed || token != _sessionToken) return;
      // 2) Back in the room: green lights, banner, key and open door.
      overlay = Level3Overlay.none;
      systemRestored = true;
      notifyListeners();
      _showToast('LLAVE 3 OBTENIDA', Level3Theme.gold, ms: 3200);

      // 3) Completion card on top of the restored room.
      Future.delayed(const Duration(milliseconds: 3800), () {
        if (_disposed || token != _sessionToken) return;
        phase = Level3Phase.completed;
        notifyListeners();
      });
    });
  }

  // ---- Helpers ---------------------------------------------------------------

  void _showToast(String message, Color color, {int ms = 2400}) {
    final id = ++toastId;
    toastMessage = message;
    toastColor = color;
    notifyListeners();
    Future.delayed(Duration(milliseconds: ms), () {
      if (_disposed || id != toastId) return;
      toastMessage = null;
      notifyListeners();
    });
  }

  Future<void> _saveProgress() async {
    await _progressService.saveProgress({
      'completed': levelCompleted,
      'key3Obtained': key3Obtained,
      'noteRead': noteRead,
      'foundCables': inventory.items.map((item) => item.id).toList(),
    });
  }
}
