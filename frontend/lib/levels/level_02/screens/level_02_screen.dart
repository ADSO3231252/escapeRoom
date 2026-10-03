import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../logic/puzzle_1_logic.dart';
import '../models/level_02_state.dart';
import '../widgets/pixel_ui.dart';
import 'puzzle_2_screen.dart';
import 'level_3_transition_screen.dart';

class _Level2Colors {
  static const cyan = Color(0xFF55D6FF);
  static const panel = Color(0xFF0A111D);
  static const border = Color(0xFF33445E);
}

class Level02Screen extends StatefulWidget {
  final Level02State? initialState;

  const Level02Screen({super.key}) : initialState = null;

  Level02Screen.withState({super.key, required Level02State state}) : initialState = state;

  @override
  State<Level02Screen> createState() => _Level02ScreenState();
}

class _Level02ScreenState extends State<Level02Screen>
    with SingleTickerProviderStateMixin {
  late final Level02State state;
  final FocusNode _focusNode = FocusNode();
  final Set<LogicalKeyboardKey> _keys = <LogicalKeyboardKey>{};

  Timer? _moveTimer;
  late final AnimationController _walkController;

  // Coordinates are percentages of the room: 0..1.
  double _x = .50;
  double _y = .73;
  double _targetX = .50;
  double _targetY = .73;
  bool _walking = false;
  bool _openingDoor = false;
  bool _gameOverShown = false;
  int? _nearDoor;
  bool _nearKey = false;
  bool _nearLevel3Door = false;
  Offset _joystick = Offset.zero;
  static const double _joystickRadius = 52;


  // The three doors from the mockup: red, blue and green.
  final List<_DoorSpot> _doors = const [
    _DoorSpot(x: .20, y: .20, color: Color(0xFFEF4444), label: 'A'),
    _DoorSpot(x: .50, y: .20, color: Color(0xFF38BDF8), label: 'B'),
    _DoorSpot(x: .80, y: .20, color: Color(0xFF22C55E), label: 'C'),
  ];

  @override
  void initState() {
    super.initState();
    state = widget.initialState ?? Level02State();
    state.addListener(_checkGameOver);
    state.startTimer();
    _walkController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 260),
    )..repeat(reverse: true);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _focusNode.requestFocus();
    });
  }

  void _checkGameOver() {
    if (!mounted || !state.timeExpired || _gameOverShown) return;
    _gameOverShown = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        showLevel02GameOver(
          context,
          state,
          onRetry: () => _gameOverShown = false,
        );
      }
    });
  }

  @override
  void dispose() {
    state.removeListener(_checkGameOver);
    _moveTimer?.cancel();
    _walkController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _startMoving(LogicalKeyboardKey key) {
    _keys.add(key);
    _walking = true;
    _moveTimer ??= Timer.periodic(const Duration(milliseconds: 32), (_) {
      _movePlayer();
    });
    _movePlayer();
  }

  void _stopMoving(LogicalKeyboardKey key) {
    _keys.remove(key);
    if (_keys.isEmpty) {
      _moveTimer?.cancel();
      _moveTimer = null;
      if (mounted) setState(() => _walking = false);
    }
  }

  KeyEventResult _handleKey(FocusNode node, KeyEvent event) {
    final key = event.logicalKey;
    final movementKey = key == LogicalKeyboardKey.arrowUp ||
        key == LogicalKeyboardKey.arrowDown ||
        key == LogicalKeyboardKey.arrowLeft ||
        key == LogicalKeyboardKey.arrowRight ||
        key == LogicalKeyboardKey.keyW ||
        key == LogicalKeyboardKey.keyA ||
        key == LogicalKeyboardKey.keyS ||
        key == LogicalKeyboardKey.keyD;

    if (!movementKey) return KeyEventResult.ignored;

    if (event is KeyDownEvent || event is KeyRepeatEvent) {
      _startMoving(key);
    } else if (event is KeyUpEvent) {
      _stopMoving(key);
    }
    return KeyEventResult.handled;
  }

  void _movePlayer() {
    if (!mounted) return;

    double dx = 0;
    double dy = 0;

    if (_keys.contains(LogicalKeyboardKey.arrowLeft) ||
        _keys.contains(LogicalKeyboardKey.keyA)) dx -= .010;
    if (_keys.contains(LogicalKeyboardKey.arrowRight) ||
        _keys.contains(LogicalKeyboardKey.keyD)) dx += .010;
    if (_keys.contains(LogicalKeyboardKey.arrowUp) ||
        _keys.contains(LogicalKeyboardKey.keyW)) dy -= .010;
    if (_keys.contains(LogicalKeyboardKey.arrowDown) ||
        _keys.contains(LogicalKeyboardKey.keyS)) dy += .010;

    if (dx != 0 && dy != 0) {
      dx *= .72;
      dy *= .72;
    }

    _x = (_x + dx).clamp(.07, .93).toDouble();
    _y = (_y + dy).clamp(.24, .86).toDouble();

    _targetX = _x;
    _targetY = _y;
    _checkDoorDistance();
    _checkKeyDistance();
    _checkLevel3DoorDistance();
    setState(() {});
  }

  void _moveWithVector(double dx, double dy, {double speed = .016}) {
    if (!mounted) return;
    final length = math.sqrt(dx * dx + dy * dy);
    if (length < .05) return;
    // dx/dy ya vienen normalizados desde el joystick. Conservamos la magnitud
    // para que haya control analógico: cerca del centro = lento, borde = rápido.
    final amount = math.min(length, 1.0) * speed;
    _x = (_x + dx * amount).clamp(.07, .93).toDouble();
    _y = (_y + dy * amount).clamp(.24, .86).toDouble();
    _targetX = _x;
    _targetY = _y;
    _walking = true;
    _checkDoorDistance();
    _checkKeyDistance();
    _checkLevel3DoorDistance();
    setState(() {});
  }

  void _joystickChanged(Offset localPosition, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    var delta = localPosition - center;
    if (delta.distance > _joystickRadius) {
      delta = Offset.fromDirection(delta.direction, _joystickRadius);
    }
    setState(() {
      _joystick = delta;
    });
    _moveWithVector(delta.dx / _joystickRadius, delta.dy / _joystickRadius);
  }

  void _joystickReleased() {
    if (!mounted) return;
    setState(() {
      _joystick = Offset.zero;
      _walking = false;
    });
  }

  void _checkKeyDistance() {
    if (!state.key2Available || state.key2Obtained) {
      _nearKey = false;
      return;
    }
    const keyX = .36;
    const keyY = .63;
    final distance = math.sqrt(math.pow(_x - keyX, 2) + math.pow(_y - keyY, 2));
    _nearKey = distance < .13;
  }

  void _collectKey2() {
    if (!state.key2Available || state.key2Obtained || !_nearKey) return;
    state.key2Available = false;
    state.key2Obtained = true;
    state.completePuzzle(bonus: 75);
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(const SnackBar(content: Text('KEY 2 OBTENIDA — LA PUERTA DEL NIVEL 3 ESTÁ DESBLOQUEADA.')));
    setState(() {});
  }

  void _checkLevel3DoorDistance() {
    const doorX = .94;
    const doorY = .66;
    final distance = math.sqrt(math.pow(_x - doorX, 2) + math.pow(_y - doorY, 2));
    _nearLevel3Door = distance < .12;
  }

  void _interact() {
    if (_nearKey && state.key2Available && !state.key2Obtained) {
      _collectKey2();
      return;
    }
    if (_nearDoor != null) {
      _goToDoor(_nearDoor!);
      return;
    }
    if (_nearLevel3Door) {
      _openLevel3Door();
      return;
    }
    // El botón permanece visible como control fijo; fuera de rango no hace nada.
  }

  void _checkDoorDistance() {
    int? closest;
    var closestDistance = .095;

    for (var i = 0; i < _doors.length; i++) {
      final d = _doors[i];
      final distance = math.sqrt(math.pow(_x - d.x, 2) + math.pow(_y - d.y, 2));
      if (distance < closestDistance) {
        closest = i;
        closestDistance = distance;
      }
    }

    _nearDoor = closest;
  }

  void _openLevel3Door() {
    if (!state.key2Obtained) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(
            content: Text('PUERTA BLOQUEADA — NECESITAS LA KEY 2.'),
            duration: Duration(milliseconds: 1500),
          ),
        );
      return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const Level3TransitionScreen()),
    );
  }

  Future<void> _goToDoor(int index) async {
    if (_openingDoor) return;

    // Only the illuminated/correct door can be entered.
    // Wrong doors stay closed and Luna does not transition to the puzzle.
    if (!Puzzle1Logic.isCorrect(index)) {
      if (state.timeExpired) return;
      state.registerMistake();
      if (!mounted) return;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(
            content: Text('ACCESS DENIED — ESA PUERTA NO TIENE LA LUZ ENCENDIDA.'),
            duration: Duration(milliseconds: 1500),
          ),
        );
      return;
    }

    final door = _doors[index];
    setState(() {
      _openingDoor = true;
      _walking = true;
      _targetX = door.x;
      _targetY = .27;
    });

    // Smooth approach animation to the illuminated door.
    final startX = _x;
    final startY = _y;
    const steps = 24;
    for (var i = 1; i <= steps; i++) {
      if (!mounted) return;
      await Future<void>.delayed(const Duration(milliseconds: 24));
      setState(() {
        final t = Curves.easeOut.transform(i / steps);
        _x = startX + (door.x - startX) * t;
        _y = startY + (.27 - startY) * t;
      });
    }

    if (!mounted) return;
    setState(() => _walking = false);
    await Future<void>.delayed(const Duration(milliseconds: 350));

    if (!mounted) return;
    setState(() => _openingDoor = false);

    state.puzzle1Solved = true;
    state.completePuzzle(bonus: 50);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => Puzzle2Screen(state: state),
      ),
    ).then((_) {
      if (mounted) {
        _focusNode.requestFocus();
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF03050A),
      body: SafeArea(
        child: Focus(
          autofocus: true,
          focusNode: _focusNode,
          onKeyEvent: _handleKey,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final roomWidth = math.min(1180.0, math.max(0.0, constraints.maxWidth - 16));
              final availableHeight = math.max(220.0, constraints.maxHeight - 104);
              // On phones keep a compact landscape-like playfield so the complete room
              // stays visible instead of pushing scenery outside the viewport.
              final roomHeight = math.min(availableHeight, math.min(700.0, roomWidth * .62));

              return Column(
                children: [
                  AnimatedBuilder(
                    animation: state,
                    builder: (context, _) => _TopHud(
                      score: state.score,
                      key2: state.key2Obtained,
                      remainingSeconds: state.remainingSeconds,
                      timeProgress: state.timeProgress,
                      timeText: state.timeText,
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: SizedBox(
                        width: roomWidth,
                        height: roomHeight,
                        child: _Room(
                          x: _x,
                          y: _y,
                          walking: _walking,
                          nearDoor: _nearDoor,
                          openingDoor: _openingDoor,
                          walkAnimation: _walkController,
                          doors: _doors,
                          onDoorTap: _goToDoor,
                          level3Unlocked: state.key2Obtained,
                          key2Available: state.key2Available,
                          nearKey: _nearKey,
                          nearLevel3Door: _nearLevel3Door,
                          onCollectKey2: _collectKey2,
                          joystick: _joystick,
                          onJoystickChanged: _joystickChanged,
                          onJoystickReleased: _joystickReleased,
                          onLevel3DoorTap: _openLevel3Door,
                          onInteract: _interact,
                        ),
                      ),
                    ),
                  ),
                  _BottomHelp(nearDoor: _nearDoor),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _TopHud extends StatelessWidget {
  final int score;
  final bool key2;
  final int remainingSeconds;
  final double timeProgress;
  final String timeText;

  const _TopHud({required this.score, required this.key2, required this.remainingSeconds, required this.timeProgress, required this.timeText});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
      decoration: const BoxDecoration(
        color: Color(0xFF080C15),
        border: Border(bottom: BorderSide(color: Color(0xFF26344A))),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              const Text('NIVEL 2  //  NEXUS-9 CONTROL ROOM', style: TextStyle(color: Color(0xFFDCE8F8), fontFamily: 'monospace', fontWeight: FontWeight.w900, letterSpacing: 1.5)),
              const Spacer(),
              Text('SCORE $score', style: const TextStyle(color: Color(0xFF7DD3FC), fontFamily: 'monospace', fontWeight: FontWeight.bold)),
              const SizedBox(width: 18),
              Icon(Icons.key, size: 18, color: key2 ? const Color(0xFF34D399) : const Color(0xFF64748B)),
              const SizedBox(width: 5),
              Text(key2 ? 'KEY 2' : 'KEY --', style: TextStyle(color: key2 ? const Color(0xFF34D399) : Colors.white54, fontFamily: 'monospace', fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 6),
          Level02TimerBar(remainingSeconds: remainingSeconds, progress: timeProgress, timeText: timeText),
        ],
      ),
    );
  }
}

class _Room extends StatelessWidget {
  final double x;
  final double y;
  final bool walking;
  final bool openingDoor;
  final int? nearDoor;
  final Animation<double> walkAnimation;
  final List<_DoorSpot> doors;
  final ValueChanged<int> onDoorTap;
  final bool level3Unlocked;
  final bool key2Available;
  final bool nearKey;
  final bool nearLevel3Door;
  final VoidCallback onCollectKey2;
  final Offset joystick;
  final void Function(Offset, Size) onJoystickChanged;
  final VoidCallback onJoystickReleased;
  final VoidCallback onLevel3DoorTap;
  final VoidCallback onInteract;

  const _Room({
    required this.x,
    required this.y,
    required this.walking,
    required this.openingDoor,
    required this.nearDoor,
    required this.walkAnimation,
    required this.doors,
    required this.onDoorTap,
    required this.level3Unlocked,
    required this.key2Available,
    required this.nearKey,
    required this.nearLevel3Door,
    required this.onCollectKey2,
    required this.joystick,
    required this.onJoystickChanged,
    required this.onJoystickReleased,
    required this.onLevel3DoorTap,
    required this.onInteract,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF101827),
        border: Border.all(color: const Color(0xFF6E89A8), width: 4),
        boxShadow: const [BoxShadow(color: Colors.black87, blurRadius: 0, spreadRadius: 5)],
      ),
      child: LayoutBuilder(
        builder: (context, c) {
          return Stack(
            children: [
              Positioned.fill(child: CustomPaint(painter: _RoomPainter())),

              // Pista principal del Puzzle 1. Se mantiene arriba y limpia.
              Positioned(
                top: c.maxHeight * .055,
                left: c.maxWidth * .27,
                right: c.maxWidth * .27,
                child: const _ClueStrip(text: 'PISTA: LA PUERTA CORRECTA ALUMBRA.'),
              ),

              // Three doors.
              for (var i = 0; i < doors.length; i++)
                Positioned(
                  left: c.maxWidth * doors[i].x - 48,
                  top: c.maxHeight * doors[i].y - 42,
                  width: 96,
                  height: 100,
                  child: GestureDetector(
                    onTap: () => onDoorTap(i),
                    child: _AnimatedDoor(
                      color: doors[i].color,
                      label: doors[i].label,
                      selected: nearDoor == i,
                      opening: openingDoor && nearDoor == i,
                      correct: i == 1,
                      pulse: walkAnimation.value,
                    ),
                  ),
                ),

              // Salida al Nivel 3: integrada en el muro derecho, como una puerta
              // real de servicio, separada de las tres puertas del Puzzle 1.
              Positioned(
                right: -2,
                top: c.maxHeight * .25,
                width: math.min(142, math.max(108, c.maxWidth * .20)),
                height: math.min(178, math.max(148, c.maxHeight * .30)),
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: onLevel3DoorTap,
                  child: _Level3ExitDoor(
                    unlocked: level3Unlocked,
                    pulse: walkAnimation.value,
                  ),
                ),
              ),

              if (key2Available)
                Positioned(
                  left: c.maxWidth * .36,
                  top: c.maxHeight * .63,
                  child: const _KeyTable(),
                ),

              // Mobile joystick. It is intentionally large and translucent so it can be used
              // comfortably with a thumb without hiding the puzzle room.
              Positioned(
                left: 18,
                bottom: 18,
                width: math.min(142, c.maxWidth * .24),
                height: math.min(142, c.maxWidth * .24),
                child: LayoutBuilder(
                  builder: (context, jc) => GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onPanStart: (details) => onJoystickChanged(details.localPosition, jc.biggest),
                    onPanUpdate: (details) => onJoystickChanged(details.localPosition, jc.biggest),
                    onPanEnd: (_) => onJoystickReleased(),
                    onPanCancel: onJoystickReleased,
                    child: _Joystick(thumb: joystick),
                  ),
                ),
              ),

              // Botón de interacción fijo: siempre visible en el lado derecho.
              // Se ilumina cuando Luna está cerca de la llave o de una puerta.
              Positioned(
                right: 18,
                bottom: 18,
                width: math.min(142, c.maxWidth * .24),
                height: math.min(142, c.maxWidth * .24),
                child: Material(
                  type: MaterialType.transparency,
                  child: _InteractButton(
                    onPressed: onInteract,
                  active: nearKey || nearDoor != null || nearLevel3Door,
                  label: nearKey ? 'COGER' : (nearDoor != null || nearLevel3Door ? 'USAR' : 'INTERACT'),
                  ),
                ),
              ),

              // Luna.
              Positioned(
                left: c.maxWidth * x - 30,
                top: c.maxHeight * y - 34,
                width: 60,
                height: 68,
                child: AnimatedBuilder(
                  animation: walkAnimation,
                  builder: (context, child) {
                    final bob = walking
                        ? math.sin(walkAnimation.value * math.pi * 2) * 2.0
                        : 0.0;
                    return Transform.translate(
                      offset: Offset(0, bob),
                      child: CustomPaint(
                        painter: _LunaPainter(
                          walking: walking,
                          phase: walkAnimation.value,
                        ),
                      ),
                    );
                  },
                ),
              ),

              if (nearDoor != null && !openingDoor)
                Positioned(
                  left: c.maxWidth * doors[nearDoor!].x - 80,
                  top: c.maxHeight * doors[nearDoor!].y + 58,
                  width: 160,
                  child: const IgnorePointer(
                    child: Text(
                      'PULSA ENTER O HAZ CLIC',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFF7DD3FC),
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.1,
                      ),
                    ),
                  ),
                ),

              if (key2Available && nearKey)
                Positioned(
                  left: c.maxWidth * .36 - 70,
                  top: c.maxHeight * .63 - 56,
                  width: 140,
                  child: const IgnorePointer(
                    child: Text(
                      'KEY 2 // INTERACTÚA',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFFFACC15),
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _KeyTable extends StatelessWidget {
  const _KeyTable();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 178, height: 126,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(left: 12, right: 12, bottom: 8, height: 48, child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: const LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Color(0xFF9A673E), Color(0xFF3B2114)]),
              borderRadius: BorderRadius.circular(7),
              border: Border.all(color: const Color(0xFFD19A63), width: 2),
              boxShadow: const [BoxShadow(color: Colors.black87, blurRadius: 7, offset: Offset(0, 5))],
            ),
          )),
          Positioned(left: 18, right: 18, bottom: 43, height: 14, child: DecoratedBox(
            decoration: BoxDecoration(color: const Color(0xFFC28651), borderRadius: BorderRadius.circular(5), border: Border.all(color: const Color(0xFFE1B27D))),
          )),
          Positioned(left: 24, bottom: 0, child: _TableLeg()),
          Positioned(right: 24, bottom: 0, child: _TableLeg()),
          Positioned(left: 51, top: 24, child: Transform.rotate(
            angle: -.18,
            child: Container(
              width: 54, height: 42,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(9),
                gradient: const LinearGradient(colors: [Color(0xFFFFE98A), Color(0xFFF2B91C)]),
                border: Border.all(color: const Color(0xFFFFF8C9), width: 2),
                boxShadow: [BoxShadow(color: const Color(0xFFFACC15).withOpacity(.75), blurRadius: 20, spreadRadius: 3)],
              ),
              child: const Icon(Icons.key_rounded, color: Color(0xFF6B4300), size: 28),
            ),
          )),
          const Positioned(left: 39, top: 1, right: 39, child: Text('KEY 2', textAlign: TextAlign.center, style: TextStyle(color: Color(0xFFFFE78A), fontFamily: 'monospace', fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 1.5))),
        ],
      ),
    );
  }
}

class _TableLeg extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(width: 10, height: 35, decoration: BoxDecoration(color: const Color(0xFF25140C), border: Border.all(color: const Color(0xFF5A341E))));
}

class _InteractButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool active;
  final String label;

  const _InteractButton({required this.onPressed, this.active = false, this.label = 'COGER'});

  @override
  Widget build(BuildContext context) {
    final accent = active ? const Color(0xFFFACC15) : const Color(0xFF7890A8);
    return Semantics(
      button: true,
      label: active ? label : 'Interactuar',
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onPressed,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: active
                  ? const [Color(0xFF263344), Color(0xDD0B111A)]
                  : const [Color(0xFF1B2634), Color(0xCC080D14)],
            ),
            border: Border.all(color: accent, width: active ? 3 : 2),
            boxShadow: [
              const BoxShadow(color: Colors.black87, blurRadius: 0, spreadRadius: 3),
              if (active) BoxShadow(color: accent.withOpacity(.38), blurRadius: 24, spreadRadius: 3),
            ],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 58, height: 58,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: accent.withOpacity(.35)),
                  color: const Color(0xFF07101A),
                ),
                child: Icon(active ? Icons.pan_tool_alt_rounded : Icons.touch_app_rounded, color: accent, size: 30),
              ),
              Positioned(
                bottom: 13,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xF2071018),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: accent.withOpacity(.65)),
                  ),
                  child: Text(
                    active ? label : 'INTERACT',
                    style: TextStyle(color: accent, fontFamily: 'monospace', fontSize: 9, fontWeight: FontWeight.w900, letterSpacing: .9),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Joystick extends StatelessWidget {
  final Offset thumb;
  const _Joystick({required this.thumb});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xAA07101B),
        border: Border.all(color: const Color(0xFF55D6FF), width: 2),
        boxShadow: const [BoxShadow(color: Colors.black87, blurRadius: 0, spreadRadius: 2)],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          const Icon(Icons.add, color: Color(0xFF35506B), size: 48),
          Transform.translate(
            offset: thumb,
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xDD55D6FF),
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: const Icon(Icons.gamepad, color: Color(0xFF06101A), size: 22),
            ),
          ),
        ],
      ),
    );
  }
}

class _Level3ExitDoor extends StatelessWidget {
  final bool unlocked;
  final double pulse;

  const _Level3ExitDoor({required this.unlocked, required this.pulse});

  @override
  Widget build(BuildContext context) {
    final accent = unlocked ? const Color(0xFF34D399) : const Color(0xFF64748B);
    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
      decoration: BoxDecoration(
        color: const Color(0xFF080F18),
        border: Border.all(color: accent, width: 3),
        boxShadow: [
          const BoxShadow(color: Colors.black87, blurRadius: 0, spreadRadius: 3),
          if (unlocked)
            BoxShadow(
              color: accent.withOpacity(.45 + pulse * .15),
              blurRadius: 22,
              spreadRadius: 2,
            ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'SALIDA // NIVEL 3',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: accent,
              fontFamily: 'monospace',
              fontSize: 12,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 5),
          Expanded(
            child: Stack(
              alignment: Alignment.center,
              children: [
                Positioned.fill(
                  child: CustomPaint(
                    painter: _ExitDoorPainter(color: accent, unlocked: unlocked),
                  ),
                ),
                Icon(
                  unlocked ? Icons.lock_open : Icons.lock,
                  size: 25,
                  color: accent,
                ),
              ],
            ),
          ),
          const SizedBox(height: 5),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 5),
            decoration: BoxDecoration(
              color: unlocked
                  ? const Color(0xFF123226)
                  : const Color(0xFF111923),
              border: Border.all(color: accent),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.key, size: 16, color: unlocked ? const Color(0xFFFACC15) : accent),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    unlocked ? 'USAR KEY 2' : 'KEY 2 REQUERIDA',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: unlocked ? const Color(0xFFFACC15) : accent,
                      fontFamily: 'monospace',
                      fontSize: 9,
                      fontWeight: FontWeight.w900,
                      letterSpacing: .7,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 6),
          Text(
            unlocked ? 'TOCA PARA ENTRAR' : 'PUERTA SELLADA',
            style: TextStyle(
              color: unlocked ? const Color(0xFF7DD3FC) : Colors.white38,
              fontFamily: 'monospace',
              fontSize: 9,
              fontWeight: FontWeight.w900,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }
}

class _ExitDoorPainter extends CustomPainter {
  final Color color;
  final bool unlocked;

  const _ExitDoorPainter({required this.color, required this.unlocked});

  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()..style = PaintingStyle.stroke..strokeWidth = 3..color = color;
    final door = Rect.fromLTWH(size.width * .20, size.height * .12, size.width * .60, size.height * .76);
    canvas.drawRect(door, p);
    canvas.drawLine(Offset(door.center.dx, door.top), Offset(door.center.dx, door.bottom), p);
    canvas.drawCircle(Offset(door.left + door.width * .78, door.center.dy), 4, Paint()..color = color);
    if (unlocked) {
      final glow = Paint()..color = color.withOpacity(.55);
      canvas.drawRect(Rect.fromLTWH(door.left + 8, door.top + 8, door.width - 16, 7), glow);
    }
  }

  @override
  bool shouldRepaint(covariant _ExitDoorPainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.unlocked != unlocked;
}

class _AnimatedDoor extends StatelessWidget {
  final Color color;
  final String label;
  final bool selected;
  final bool opening;
  final bool correct;
  final double pulse;

  const _AnimatedDoor({
    required this.color,
    required this.label,
    required this.selected,
    required this.opening,
    required this.correct,
    required this.pulse,
  });

  @override
  Widget build(BuildContext context) {
    final glow = correct ? (0.45 + pulse * 0.25) : 0.0;
    return AnimatedScale(
      scale: selected ? 1.08 : 1,
      duration: const Duration(milliseconds: 160),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            decoration: BoxDecoration(
              color: color.withOpacity(opening ? .35 : .12),
              border: Border.all(color: color, width: selected || correct ? 3 : 2),
              boxShadow: [
                if (selected) BoxShadow(color: color.withOpacity(.55), blurRadius: 18),
                if (correct) BoxShadow(color: color.withOpacity(glow), blurRadius: 24, spreadRadius: 3),
              ],
            ),
            child: Stack(
              children: [
                Positioned.fill(
                  child: CustomPaint(
                    painter: _DoorPainter(color: color, opening: opening, correct: correct, pulse: pulse),
                  ),
                ),
              ],
            ),
          ),
          // Solo se muestra la luz de estado; no hay textos OPEN/LOCKED.

        ],
      ),
    );
  }
}

class _ClueStrip extends StatelessWidget {
  final String text;
  const _ClueStrip({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 38,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: const Color(0xE607101B),
        border: Border.all(color: const Color(0xFF35506D)),
        borderRadius: BorderRadius.zero,
        boxShadow: const [
          BoxShadow(color: Colors.black54, blurRadius: 10, offset: Offset(0, 3)),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              color: const Color(0xFFFACC15).withOpacity(.10),
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFFFACC15).withOpacity(.55)),
            ),
            child: const Icon(Icons.lightbulb_outline, size: 13, color: Color(0xFFFACC15)),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              text,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Color(0xFFC7D6E8), fontSize: 8.5, fontWeight: FontWeight.w800, letterSpacing: .7),
            ),
          ),
        ],
      ),
    );
  }
}

class _RoomSign extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 34,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0xD9081018),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: const Color(0xFF38516A)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.warning_amber_rounded, size: 14, color: Color(0xFFFACC15)),
          SizedBox(width: 7),
          Text('CONTROL ROOM 02  •  NEXUS', style: TextStyle(color: Color(0xFFB8C9DC), fontFamily: 'monospace', fontSize: 9, fontWeight: FontWeight.w900, letterSpacing: 1.2)),
        ],
      ),
    );
  }
}

class _Terminal extends StatelessWidget {
  final String label;
  const _Terminal({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 112,
      height: 72,
      decoration: BoxDecoration(
        gradient: const LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Color(0xFF1B2A3B), Color(0xFF080F17)]),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF48627C), width: 2),
        boxShadow: const [BoxShadow(color: Colors.black87, blurRadius: 8, offset: Offset(0, 5))],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF8CA6C5),
              fontSize: 9,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.4,
            ),
          ),
          const SizedBox(height: 7),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (var i = 0; i < 4; i++)
                Container(
                  width: 9,
                  height: 4,
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  color: i == 1 ? const Color(0xFF34D399) : const Color(0xFF33445E),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _LogicConsole extends StatelessWidget {
  const _LogicConsole();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 168,
      height: 98,
      decoration: BoxDecoration(
        gradient: const LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Color(0xFF24384C), Color(0xFF08111B)]),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFF52718E), width: 2),
        boxShadow: const [BoxShadow(color: Colors.black87, blurRadius: 10, offset: Offset(0, 6))],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Text(
            'NEXUS LOGIC',
            style: TextStyle(
              color: Color(0xFF6F89A7),
              fontSize: 9,
              letterSpacing: 1.8,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          Text(
            '2  >  1  >  3',
            style: TextStyle(
              color: Color(0xFF55D6FF),
              fontSize: 16,
              fontWeight: FontWeight.w900,
              letterSpacing: 2,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'SYSTEM ONLINE',
            style: TextStyle(color: Color(0xFF34D399), fontSize: 8),
          ),
        ],
      ),
    );
  }
}

class _BottomHelp extends StatelessWidget {
  final int? nearDoor;
  const _BottomHelp({required this.nearDoor});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 18),
      decoration: const BoxDecoration(
        color: Color(0xFF080C15),
        border: Border(top: BorderSide(color: Color(0xFF26344A))),
      ),
      child: Row(
        children: [
          const Text(
            'MOVIMIENTO:',
            style: TextStyle(color: Color(0xFF64748B), fontSize: 10, fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 8),
          _Key('W'), _Key('A'), _Key('S'), _Key('D'),
          const SizedBox(width: 8),
          const Text('o', style: TextStyle(color: Colors.white38)),
          const SizedBox(width: 8),
          _Key('↑'), _Key('←'), _Key('↓'), _Key('→'),
          const Spacer(),
          Text(
            nearDoor == null ? 'LUNA: EXPLORA LA SALA' : 'LUNA: PUERTA DETECTADA',
            style: TextStyle(
              color: nearDoor == null ? const Color(0xFF64748B) : const Color(0xFF7DD3FC),
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }
}

class _Key extends StatelessWidget {
  final String text;
  const _Key(this.text);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 22,
      height: 22,
      margin: const EdgeInsets.only(right: 3),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: const Color(0xFF111B2A),
        border: Border.all(color: const Color(0xFF354861)),
      ),
      child: Text(text, style: const TextStyle(fontSize: 9, color: Color(0xFFB8C7D9), fontWeight: FontWeight.bold)),
    );
  }
}

class _RoomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()..isAntiAlias = true;
    final wallBottom = size.height * .47;

    // Clean, open room: keep only the architectural surfaces so the doors,
    // puzzle elements and key table remain the visual focus.
    p.color = const Color(0xFF0B1320);
    canvas.drawRect(Offset.zero & size, p);

    // Back wall.
    p.color = const Color(0xFF182638);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, wallBottom), p);
    p.color = const Color(0xFF263B52);
    canvas.drawRect(Rect.fromLTWH(0, wallBottom - 14, size.width, 14), p);
    p.color = const Color(0xFF0A111A);
    canvas.drawRect(Rect.fromLTWH(0, wallBottom - 4, size.width, 4), p);

    // Simple floor with subtle seams.
    p.color = const Color(0xFF0A121C);
    canvas.drawRect(Rect.fromLTWH(0, wallBottom, size.width, size.height - wallBottom), p);
    p.style = PaintingStyle.stroke;
    p.strokeWidth = 1;
    p.color = const Color(0xFF17283A);
    for (var i = 1; i < 4; i++) {
      final y = wallBottom + (size.height - wallBottom) * i / 4;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), p);
    }
    for (var i = 1; i < 5; i++) {
      final x = size.width * i / 5;
      canvas.drawLine(Offset(x, wallBottom), Offset(x, size.height), p);
    }
    p.style = PaintingStyle.fill;

    // A restrained central path gives orientation without clutter.
    p.color = const Color(0xFF101D2B);
    final path = Rect.fromLTWH(size.width * .40, wallBottom, size.width * .20, size.height - wallBottom);
    canvas.drawRect(path, p);
    p.color = const Color(0xFF1B3044);
    canvas.drawRect(Rect.fromLTWH(path.left, wallBottom, 2, path.height), p);
    canvas.drawRect(Rect.fromLTWH(path.right - 2, wallBottom, 2, path.height), p);
  }

  @override
  bool shouldRepaint(covariant _RoomPainter oldDelegate) => false;
}

class _DoorPainter extends CustomPainter {
  final Color color;
  final bool opening;
  final bool correct;
  final double pulse;

  const _DoorPainter({required this.color, required this.opening, required this.correct, required this.pulse});

  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()..isAntiAlias = true;
    final frame = RRect.fromRectAndRadius(Rect.fromLTWH(9, 6, size.width - 18, size.height - 10), const Radius.circular(5));
    p.color = const Color(0xFF050A11); canvas.drawRRect(frame, p);
    p.style = PaintingStyle.stroke; p.strokeWidth = 3; p.color = color.withOpacity(.85); canvas.drawRRect(frame, p);
    p.style = PaintingStyle.fill;

    final inner = Rect.fromLTWH(17, 15, size.width - 34, size.height - 27);
    p.color = color.withOpacity(correct ? .18 + pulse * .08 : .06); canvas.drawRect(inner, p);
    p.style = PaintingStyle.stroke; p.strokeWidth = 2; p.color = color.withOpacity(.45); canvas.drawRect(inner, p); p.style = PaintingStyle.fill;

    // Heavy vertical door ribs and center seam.
    p.color = color.withOpacity(.20);
    for (var i = 0; i < 4; i++) canvas.drawRect(Rect.fromLTWH(inner.left + 7 + i * (inner.width - 14) / 4, inner.top + 5, 3, inner.height - 10), p);
    p.color = color.withOpacity(.55); canvas.drawRect(Rect.fromLTWH(inner.center.dx - 1, inner.top, 2, inner.height), p);

    // Door control panel.
    p.color = const Color(0xFF080F17); canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(inner.right - 19, inner.center.dy - 13, 10, 26), const Radius.circular(2)), p);
    p.color = correct ? color : const Color(0xFF4B5A6A); canvas.drawCircle(Offset(inner.right - 14, inner.center.dy - 5), 2.5, p);
    p.color = const Color(0xFF26384A); canvas.drawRect(Rect.fromLTWH(inner.right - 17, inner.center.dy + 3, 6, 2), p);

    // Top status light.
    if (correct) {
      p.color = color.withOpacity(.28 + pulse * .18); canvas.drawRect(Rect.fromLTWH(size.width * .30, 0, size.width * .40, 7), p);
      p.color = color.withOpacity(.9); canvas.drawRect(Rect.fromLTWH(size.width * .40, 2, size.width * .20, 3), p);
    }

    if (opening) {
      p.color = const Color(0xFF02050A); canvas.drawRect(inner, p);
      p.color = color.withOpacity(.35); canvas.drawRect(Rect.fromLTWH(inner.center.dx - 2, inner.top, 4, inner.height), p);
    }
  }

  @override
  bool shouldRepaint(covariant _DoorPainter oldDelegate) => oldDelegate.opening != opening || oldDelegate.color != color || oldDelegate.correct != correct || oldDelegate.pulse != pulse;
}

class _LunaPainter extends CustomPainter {
  final bool walking;
  final double phase;

  const _LunaPainter({required this.walking, required this.phase});

  @override
  void paint(Canvas canvas, Size size) {
    // Luna is intentionally drawn with hard-edged blocks instead of curves
    // to give the character a small 16-bit/pixel-art silhouette.
    final fur = const Color(0xFFE8D0A8);
    final dark = const Color(0xFF7A5038);
    final outline = const Color(0xFF1A1720);
    final cyan = const Color(0xFF38BDF8);
    final gold = const Color(0xFFFACC15);
    final leg = walking ? (phase < .5 ? 2.0 : -2.0) : 0.0;

    Paint box(Color c) => Paint()..color = c;

    // Pixel shadow.
    canvas.drawRect(const Rect.fromLTWH(9, 59, 42, 5), box(const Color(0x66000000)));

    // Tail: blocky stepped shape.
    canvas.drawRect(const Rect.fromLTWH(47, 34, 8, 7), box(outline));
    canvas.drawRect(const Rect.fromLTWH(53, 27, 6, 10), box(outline));
    canvas.drawRect(const Rect.fromLTWH(51, 24, 7, 7), box(dark));
    canvas.drawRect(const Rect.fromLTWH(45, 34, 10, 7), box(dark));

    // Body outline + body.
    canvas.drawRect(const Rect.fromLTWH(11, 30, 40, 27), box(outline));
    canvas.drawRect(const Rect.fromLTWH(15, 33, 32, 20), box(fur));
    canvas.drawRect(const Rect.fromLTWH(18, 29, 25, 5), box(fur));

    // Legs.
    canvas.drawRect(Rect.fromLTWH(15, 49 + leg, 9, 13), box(outline));
    canvas.drawRect(Rect.fromLTWH(17, 49 + leg, 5, 11), box(dark));
    canvas.drawRect(Rect.fromLTWH(36, 49 - leg, 9, 13), box(outline));
    canvas.drawRect(Rect.fromLTWH(38, 49 - leg, 5, 11), box(dark));

    // Head outline and face.
    canvas.drawRect(const Rect.fromLTWH(12, 10, 33, 28), box(outline));
    canvas.drawRect(const Rect.fromLTWH(16, 12, 25, 24), box(fur));
    canvas.drawRect(const Rect.fromLTWH(20, 9, 17, 4), box(fur));

    // Ears.
    canvas.drawRect(const Rect.fromLTWH(12, 7, 10, 9), box(outline));
    canvas.drawRect(const Rect.fromLTWH(15, 9, 6, 7), box(dark));
    canvas.drawRect(const Rect.fromLTWH(35, 7, 10, 9), box(outline));
    canvas.drawRect(const Rect.fromLTWH(36, 9, 6, 7), box(dark));

    // Eyes and muzzle.
    canvas.drawRect(const Rect.fromLTWH(20, 21, 5, 5), box(outline));
    canvas.drawRect(const Rect.fromLTWH(34, 21, 5, 5), box(outline));
    canvas.drawRect(const Rect.fromLTWH(26, 25, 8, 7), box(const Color(0xFFF1DFC4)));
    canvas.drawRect(const Rect.fromLTWH(28, 27, 4, 3), box(outline));

    // Collar + tag.
    canvas.drawRect(const Rect.fromLTWH(15, 35, 32, 4), box(cyan));
    canvas.drawRect(const Rect.fromLTWH(27, 38, 5, 5), box(gold));
  }

  @override
  bool shouldRepaint(covariant _LunaPainter oldDelegate) =>
      oldDelegate.walking != walking || oldDelegate.phase != phase;
}

class _DoorSpot {
  final double x;
  final double y;
  final Color color;
  final String label;

  const _DoorSpot({
    required this.x,
    required this.y,
    required this.color,
    required this.label,
  });
}
