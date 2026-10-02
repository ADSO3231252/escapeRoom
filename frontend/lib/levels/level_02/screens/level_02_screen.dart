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
    setState(() {});
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
              final roomWidth = math.min(constraints.maxWidth - 32, 1180.0);
              final roomHeight = math.min(constraints.maxHeight - 104, 700.0);

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
                          onLevel3DoorTap: _openLevel3Door,
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
  final VoidCallback onLevel3DoorTap;

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
    required this.onLevel3DoorTap,
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

              // Clue strip, matching the mockup's HUD style.
              Positioned(
                top: c.maxHeight * .035,
                left: c.maxWidth * .27,
                right: c.maxWidth * .27,
                child: _ClueStrip(
                  text: 'PISTA 01  •  LA PUERTA CON LA LUZ ENCENDIDA ES LA CORRECTA',
                ),
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

              // Left terminal.
              Positioned(
                left: c.maxWidth * .08,
                top: c.maxHeight * .51,
                child: const _Terminal(label: 'ACCESS'),
              ),

              // Central logic console.
              Positioned(
                left: c.maxWidth * .50 - 72,
                top: c.maxHeight * .50,
                child: const _LogicConsole(),
              ),

              // Right terminal.
              Positioned(
                left: c.maxWidth * .83,
                top: c.maxHeight * .51,
                child: const _Terminal(label: 'NEXUS'),
              ),

              // Small floor markings.
              Positioned(
                left: c.maxWidth * .43,
                top: c.maxHeight * .82,
                child: const Text(
                  'LUNA // PLAYER 01',
                  style: TextStyle(
                    color: Color(0xFF52647C),
                    fontSize: 10,
                    letterSpacing: 2,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              // Puerta de salida al Nivel 3. Al inicio permanece bloqueada;
              // después de obtener KEY 2 se ilumina y permite continuar.
              Positioned(
                right: c.maxWidth * .025,
                top: c.maxHeight * .38,
                width: 170,
                height: 220,
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: onLevel3DoorTap,
                  child: _Level3ExitDoor(
                    unlocked: level3Unlocked,
                    pulse: walkAnimation.value,
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
            ],
          );
        },
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

class _Terminal extends StatelessWidget {
  final String label;
  const _Terminal({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 92,
      height: 58,
      decoration: BoxDecoration(
        color: const Color(0xFF0A111D),
        border: Border.all(color: const Color(0xFF33445E)),
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
      width: 144,
      height: 86,
      decoration: BoxDecoration(
        color: const Color(0xFF07101B),
        border: Border.all(color: const Color(0xFF31465F)),
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
    final p = Paint()..isAntiAlias = false;
    p.color = const Color(0xFF101A28);
    canvas.drawRect(Offset.zero & size, p);

    // Back wall: clean repeating pixel tiles.
    const tileW = 56.0;
    const tileH = 36.0;
    final wallTop = 0.0;
    final wallBottom = size.height * .48;
    for (double y = wallTop; y < wallBottom; y += tileH) {
      for (double x = 0; x < size.width; x += tileW) {
        final odd = ((x / tileW).floor() + (y / tileH).floor()) % 2 == 0;
        p.color = odd ? const Color(0xFF1B2A3C) : const Color(0xFF162437);
        canvas.drawRect(Rect.fromLTWH(x + 1, y + 1, tileW - 2, tileH - 2), p);
      }
    }

    // Floor: large square metal tiles, with a central walkway.
    p.color = const Color(0xFF0A121D);
    canvas.drawRect(Rect.fromLTWH(0, wallBottom, size.width, size.height - wallBottom), p);
    for (double y = wallBottom; y < size.height; y += 42) {
      for (double x = 0; x < size.width; x += 70) {
        final odd = ((x / 70).floor() + ((y - wallBottom) / 42).floor()) % 2 == 0;
        p.color = odd ? const Color(0xFF142436) : const Color(0xFF102033);
        canvas.drawRect(Rect.fromLTWH(x + 2, y + 2, 66, 38), p);
      }
    }

    final seam = Paint()..color = const Color(0xFF07101A)..strokeWidth = 2..isAntiAlias = false;
    for (double x = 0; x <= size.width; x += 70) canvas.drawLine(Offset(x, wallBottom), Offset(x, size.height), seam);
    for (double y = wallBottom; y <= size.height; y += 42) canvas.drawLine(Offset(0, y), Offset(size.width, y), seam);

    // Back wall base trim.
    p.color = const Color(0xFF263B52);
    canvas.drawRect(Rect.fromLTWH(0, wallBottom - 10, size.width, 10), p);
    p.color = const Color(0xFF0A111B);
    canvas.drawRect(Rect.fromLTWH(0, wallBottom - 4, size.width, 4), p);

    // Central floor lane: makes the room read as a room instead of a giant platform.
    final lane = Rect.fromLTWH(size.width * .36, wallBottom + 4, size.width * .28, size.height - wallBottom - 8);
    p.color = const Color(0xFF182B3E);
    canvas.drawRect(lane, p);
    final laneEdge = Paint()..color = const Color(0xFF31506B)..style = PaintingStyle.stroke..strokeWidth = 3..isAntiAlias = false;
    canvas.drawRect(lane, laneEdge);
    final stripe = Paint()..color = const Color(0xFF2D4A63)..isAntiAlias = false;
    for (double y = lane.top + 18; y < lane.bottom; y += 54) {
      canvas.drawRect(Rect.fromLTWH(lane.left + 14, y, lane.width - 28, 5), stripe);
    }

    // Side control stations.
    _drawStation(canvas, Offset(size.width * .06, size.height * .55), 112, 78);
    _drawStation(canvas, Offset(size.width * .78, size.height * .55), 112, 78);

    // Central console pedestal.
    final console = Rect.fromLTWH(size.width * .43, size.height * .60, size.width * .14, 70);
    p.color = const Color(0xFF20384F);
    canvas.drawRect(console, p);
    p.color = const Color(0xFF0B1521);
    canvas.drawRect(Rect.fromLTWH(console.left + 7, console.top + 7, console.width - 14, console.height - 14), p);

    // Ceiling lights: three simple pixel strips.
    for (var i = 0; i < 5; i++) {
      final lx = size.width * (.14 + i * .18);
      p.color = i == 2 ? const Color(0xFF3D9EC3) : const Color(0xFF2B3E52);
      canvas.drawRect(Rect.fromLTWH(lx, 12, 42, 6), p);
      if (i == 2) {
        p.color = const Color(0xFF75D9F5);
        canvas.drawRect(Rect.fromLTWH(lx + 7, 14, 28, 2), p);
      }
    }
  }

  void _drawStation(Canvas canvas, Offset o, double w, double h) {
    final p = Paint()..isAntiAlias = false;
    p.color = const Color(0xFF0A1420);
    canvas.drawRect(Rect.fromLTWH(o.dx, o.dy, w, h), p);
    p.color = const Color(0xFF3A5872);
    p.style = PaintingStyle.stroke;
    p.strokeWidth = 3;
    canvas.drawRect(Rect.fromLTWH(o.dx, o.dy, w, h), p);
    p.style = PaintingStyle.fill;
    p.color = const Color(0xFF14283B);
    canvas.drawRect(Rect.fromLTWH(o.dx + 12, o.dy + 12, w - 24, 30), p);
    p.color = const Color(0xFF55D6FF);
    canvas.drawRect(Rect.fromLTWH(o.dx + 18, o.dy + 19, 42, 4), p);
    p.color = const Color(0xFF34D399);
    canvas.drawRect(Rect.fromLTWH(o.dx + w - 30, o.dy + 18, 7, 7), p);
    p.color = const Color(0xFF4A627A);
    canvas.drawRect(Rect.fromLTWH(o.dx + 14, o.dy + 52, w - 28, 5), p);
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
    final outer = Paint()..color = const Color(0xFF070C14)..isAntiAlias = false;
    final frame = Paint()..color = color.withOpacity(.70)..style = PaintingStyle.stroke..strokeWidth = 4..isAntiAlias = false;
    final inner = Paint()..color = color.withOpacity(correct ? (.18 + pulse * .10) : .07)..isAntiAlias = false;

    final door = Rect.fromLTWH(17, 8, size.width - 34, size.height - 16);
    canvas.drawRect(door, outer);
    canvas.drawRect(door, frame);
    canvas.drawRect(Rect.fromLTWH(24, 15, door.width - 14, door.height - 22), inner);

    // Chunky door panels.
    final panel = Paint()..color = color.withOpacity(correct ? .18 : .08)..isAntiAlias = false;
    for (var i = 0; i < 3; i++) {
      canvas.drawRect(Rect.fromLTWH(29, 27 + i * 17.0, door.width - 24, 10), panel);
    }

    // Only the correct door gets a visible light.
    if (correct) {
      final glow = Paint()..color = color.withOpacity(.20 + pulse * .12)..isAntiAlias = false;
      canvas.drawRect(Rect.fromLTWH(size.width / 2 - 11, 0, 22, 8), glow);
      final lamp = Paint()..color = color.withOpacity(.70 + pulse * .30)..isAntiAlias = false;
      canvas.drawRect(Rect.fromLTWH(size.width / 2 - 5, 2, 10, 4), lamp);
      canvas.drawRect(Rect.fromLTWH(size.width / 2 - 9, 0, 18, 2), lamp);
    }

    if (opening) {
      final dark = Paint()..color = const Color(0xFF02050A)..isAntiAlias = false;
      canvas.drawRect(Rect.fromLTWH(30, 20, door.width - 26, door.height - 34), dark);
    }
  }

  @override
  bool shouldRepaint(covariant _DoorPainter oldDelegate) =>
      oldDelegate.opening != opening || oldDelegate.color != color || oldDelegate.correct != correct || oldDelegate.pulse != pulse;
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
