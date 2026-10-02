import 'package:flutter/material.dart';

import 'luna_sprite.dart';
import 'system_message.dart';

/// Level 4 - La Terminal Cifrada. View 1: dark room.
///
/// Shows the dark room with Luna, the lit terminal, the locked door
/// (red light) and the system message.
///
/// - The player taps the floor and Luna walks to that point.
/// - When Luna is close to the terminal, the hint "Toca la terminal"
///   starts blinking.
/// - If the player taps the terminal while Luna is close,
///   [onTerminalTap] is called (the terminal view uses it).
class DarkRoom extends StatefulWidget {
  const DarkRoom({super.key, this.onTerminalTap});

  /// Called when the player taps the terminal and Luna is in range.
  final VoidCallback? onTerminalTap;

  @override
  State<DarkRoom> createState() => _DarkRoomState();
}

class _DarkRoomState extends State<DarkRoom>
    with SingleTickerProviderStateMixin {
  // Base size of the scene. FittedBox scales it to any screen.
  static const double _width = 640;
  static const double _height = 360;

  // Floor area where Luna can walk.
  static const Rect _floor = Rect.fromLTWH(60, 90, 520, 180);

  // Terminal position (bottom center of the terminal).
  static const Offset _terminalPoint = Offset(320, 76);

  // How close Luna must be to use the terminal.
  static const double _interactionDistance = 90;

  // Luna position (center of the sprite).
  Offset _lunaPosition = const Offset(200, 230);
  bool _walking = false;
  bool _facingLeft = false;

  // The walk goes from [_walkStart] to [_walkEnd]. The controller says
  // how much of the way Luna has done (0 = start, 1 = arrived).
  Offset _walkStart = const Offset(200, 230);
  Offset _walkEnd = const Offset(200, 230);
  late final AnimationController _walk = AnimationController(vsync: this)
    ..addStatusListener(_onWalkStatus);

  // Where Luna is at this exact moment, even in the middle of a walk.
  Offset get _lunaNow => Offset.lerp(_walkStart, _walkEnd, _walk.value)!;

  void _onWalkStatus(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      setState(() {
        _lunaPosition = _walkEnd;
        _walking = false;
      });
    }
  }

  @override
  void dispose() {
    _walk.dispose();
    super.dispose();
  }

  bool get _lunaInRange =>
      (_lunaPosition - _terminalPoint).distance < _interactionDistance;

  void _moveLuna(TapUpDetails details) {
    const halfWidth = LunaSprite.spriteWidth / 2;
    const halfHeight = LunaSprite.spriteHeight / 2;

    // Keep the target inside the floor.
    final target = Offset(
      details.localPosition.dx
          .clamp(_floor.left + halfWidth, _floor.right - halfWidth)
          .toDouble(),
      details.localPosition.dy
          .clamp(_floor.top + halfHeight, _floor.bottom - halfHeight)
          .toDouble(),
    );

    // The distance is measured from where Luna really is right now,
    // so she keeps the same speed even if the player taps many times.
    final from = _walking ? _lunaNow : _lunaPosition;
    final gap = (target - from).distance;
    if (gap < 2) return;

    _walk.stop();
    setState(() {
      _facingLeft = target.dx < from.dx;
      _walkStart = from;
      _walkEnd = target;
      _lunaPosition = from;
      _walking = true;
    });
    // 4 ms per pixel = always the same speed (250 px per second).
    _walk.duration = Duration(milliseconds: (gap * 4).round());
    _walk.forward(from: 0);
  }

  void _tapTerminal() {
    // If Luna is far, nothing happens (US-L4-03).
    if (!_lunaInRange || _walking) return;
    widget.onTerminalTap?.call();
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: _Palette.background,
      child: Center(
        child: FittedBox(
          fit: BoxFit.contain,
          child: SizedBox(
            width: _width,
            height: _height,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTapUp: _moveLuna,
              child: Stack(
                clipBehavior: Clip.hardEdge,
                children: [
                  // 1. Walls
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        color: _Palette.wall,
                        border: Border.all(color: _Palette.border, width: 3),
                      ),
                    ),
                  ),

                  // 2. Floor with tiles
                  Positioned.fromRect(
                    rect: _floor,
                    child: CustomPaint(painter: _FloorPainter()),
                  ),

                  // 3. Cabinets on the top wall
                  for (final x in [70.0, 122.0, 476.0, 528.0])
                    Positioned(left: x, top: 16, child: const _Cabinet()),

                  // 4. Left door (decoration) and locked exit door
                  const Positioned(
                    left: 10,
                    top: 130,
                    child: _Door(locked: false),
                  ),
                  const Positioned(
                    right: 10,
                    top: 130,
                    child: _Door(locked: true),
                  ),

                  // 5. Darkness: everything dark except the terminal area
                  const Positioned.fill(
                    child: IgnorePointer(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: RadialGradient(
                            center: Alignment(0, -0.85),
                            radius: 0.9,
                            colors: [_Palette.terminalLight, _Palette.darkness],
                            stops: [0.0, 0.7],
                          ),
                        ),
                      ),
                    ),
                  ),

                  // 6. Terminal
                  Positioned(
                    left: _terminalPoint.dx - 66,
                    top: 12,
                    child: GestureDetector(
                      onTap: _tapTerminal,
                      child: const _Terminal(),
                    ),
                  ),

                  // 7. "Toca la terminal" hint when Luna is close
                  if (_lunaInRange && !_walking)
                    Positioned(
                      top: 82,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: GestureDetector(
                          onTap: _tapTerminal,
                          child: const BlinkingHint(text: 'Toca la terminal'),
                        ),
                      ),
                    ),

                  // 8. Luna. Only this part is redrawn while she walks.
                  AnimatedBuilder(
                    animation: _walk,
                    builder: (context, child) {
                      final p = _walking ? _lunaNow : _lunaPosition;
                      return Positioned(
                        left: p.dx - LunaSprite.spriteWidth / 2,
                        top: p.dy - LunaSprite.spriteHeight / 2,
                        child: child!,
                      );
                    },
                    child: RepaintBoundary(
                      child: LunaSprite(facingLeft: _facingLeft),
                    ),
                  ),

                  // 9. System message (bottom)
                  const Positioned(
                    left: 16,
                    right: 16,
                    bottom: 10,
                    child: SystemMessage(
                      text: 'La sala está a oscuras. Solo una terminal ilumina el lugar.',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Scene pieces
// ---------------------------------------------------------------------------

class _Terminal extends StatelessWidget {
  const _Terminal();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 132,
      height: 64,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: _Palette.metal,
        borderRadius: BorderRadius.circular(3),
        border: Border.all(color: _Palette.border, width: 3),
      ),
      child: Container(
        width: 104,
        height: 42,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: _Palette.redScreen,
          border: Border.all(color: _Palette.red, width: 2),
          boxShadow: const [
            BoxShadow(color: _Palette.redGlow, blurRadius: 16),
          ],
        ),
        child: const Text(
          'ACCESS DENIED\nENTER PASSWORD',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'monospace',
            fontFamilyFallback: ['Courier'],
            fontSize: 9,
            height: 1.2,
            fontWeight: FontWeight.bold,
            color: _Palette.redText,
          ),
        ),
      ),
    );
  }
}

class _Door extends StatelessWidget {
  const _Door({required this.locked});

  final bool locked;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 24,
      height: 96,
      alignment: Alignment.topCenter,
      padding: const EdgeInsets.only(top: 8),
      decoration: BoxDecoration(
        color: _Palette.door,
        border: Border.all(color: _Palette.border, width: 3),
      ),
      // The red light only shows on the locked exit door.
      child: locked
          ? Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: _Palette.red,
                boxShadow: [BoxShadow(color: _Palette.red, blurRadius: 8)],
              ),
            )
          : null,
    );
  }
}

class _Cabinet extends StatelessWidget {
  const _Cabinet();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 42,
      height: 58,
      decoration: BoxDecoration(
        color: _Palette.cabinet,
        border: Border.all(color: _Palette.cabinetBorder, width: 2),
      ),
    );
  }
}

/// Draws the floor with tile lines every 36 px.
class _FloorPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final background = Paint()..color = _Palette.floor;
    canvas.drawRect(Offset.zero & size, background);

    final line = Paint()
      ..color = _Palette.floorLine
      ..strokeWidth = 2;
    for (double y = 0; y <= size.height; y += 36) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), line);
    }
    for (double x = 0; x <= size.width; x += 36) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), line);
    }

    final border = Paint()
      ..color = _Palette.border
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawRect(Offset.zero & size, border);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Colors taken from the Level 4 mockup.
class _Palette {
  static const background = Color(0xFF050D1C);
  static const wall = Color(0xFF122742);
  static const border = Color(0xFF0A1A31);
  static const floor = Color(0xFF173256);
  static const floorLine = Color(0xFF10264A);
  static const cabinet = Color(0xFF0F2140);
  static const cabinetBorder = Color(0xFF26446E);
  static const door = Color(0xFF2A4670);
  static const metal = Color(0xFF1C3A63);
  static const red = Color(0xFFEF4444);
  static const redText = Color(0xFFFF7B7B);
  static const redScreen = Color(0xFF1A0508);
  static const redGlow = Color(0xBFEF4444);
  static const terminalLight = Color(0x24F87171);
  static const darkness = Color(0xCC030814);
}
