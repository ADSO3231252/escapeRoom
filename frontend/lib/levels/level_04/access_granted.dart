import 'package:flutter/material.dart';

import 'luna_sprite.dart';

/// Level 4 - La Terminal Cifrada. View 6: access granted.
///
/// The room is lit, the terminal is green and the exit door is open.
/// - The player taps the floor and Luna walks there.
/// - When Luna walks over the key, she picks up Key 4 and the
///   "PROGRESO GUARDADO" notice shows for a moment.
/// - With the key, walking to the open door calls [onContinue].
class AccessGranted extends StatefulWidget {
  const AccessGranted({super.key, this.onContinue});

  /// Called when Luna leaves through the door with Key 4.
  final VoidCallback? onContinue;

  static const _wall = Color(0xFF1B3157);
  static const _border = Color(0xFF0E1E3A);
  static const _floor = Color(0xFF24477A);
  static const _floorLine = Color(0xFF1B3966);
  static const _cabinet = Color(0xFF16305A);
  static const _cabinetBorder = Color(0xFF35619C);
  static const _green = Color(0xFF4ADE80);
  static const _greenDark = Color(0xFF052E16);
  static const _yellow = Color(0xFFFACC15);

  @override
  State<AccessGranted> createState() => _AccessGrantedState();
}

class _AccessGrantedState extends State<AccessGranted>
    with SingleTickerProviderStateMixin {
  // Same base size as the other views. FittedBox scales it.
  static const double _width = 640;
  static const double _height = 360;

  // Floor area where Luna can walk.
  static const Rect _floorArea = Rect.fromLTWH(60, 90, 520, 180);

  // Where the key is on the floor and how close Luna must get.
  static const Offset _keyPoint = Offset(330, 200);
  static const double _pickUpDistance = 34;

  // Luna leaves when she reaches the right side, in front of the door.
  static const double _exitX = 530;
  static const double _doorTop = 130;
  static const double _doorBottom = 226;

  Offset _lunaPosition = const Offset(160, 230);
  bool _walking = false;
  bool _facingLeft = false;
  bool _hasKey = false;
  bool _savedNotice = false;
  bool _left = false;

  Offset _walkStart = const Offset(160, 230);
  Offset _walkEnd = const Offset(160, 230);
  late final AnimationController _walk = AnimationController(vsync: this)
    ..addListener(_checkLuna)
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

  /// Runs on every step: picks up the key and checks the door.
  void _checkLuna() {
    final p = _lunaNow;

    if (!_hasKey && (p - _keyPoint).distance < _pickUpDistance) {
      setState(() {
        _hasKey = true;
        _savedNotice = true;
      });
      // The notice goes away by itself.
      Future<void>.delayed(const Duration(seconds: 2), () {
        if (mounted) setState(() => _savedNotice = false);
      });
    }

    final atDoor = p.dx >= _exitX && p.dy >= _doorTop && p.dy <= _doorBottom;
    if (_hasKey && atDoor && !_left) {
      _left = true;
      widget.onContinue?.call();
    }
  }

  void _moveLuna(TapUpDetails details) {
    if (_left) return;
    const halfWidth = LunaSprite.spriteWidth / 2;
    const halfHeight = LunaSprite.spriteHeight / 2;

    final target = Offset(
      details.localPosition.dx
          .clamp(_floorArea.left + halfWidth, _floorArea.right - halfWidth)
          .toDouble(),
      details.localPosition.dy
          .clamp(_floorArea.top + halfHeight, _floorArea.bottom - halfHeight)
          .toDouble(),
    );

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

  @override
  void dispose() {
    _walk.dispose();
    super.dispose();
  }

  static TextStyle _text(double size, Color color, {double spacing = 1}) {
    return TextStyle(
      fontFamily: 'monospace',
      fontFamilyFallback: const ['Courier'],
      fontSize: size,
      fontWeight: FontWeight.bold,
      letterSpacing: spacing,
      color: color,
    );
  }

  Widget _label(String text, Color color, Color background, double size) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: background,
        border: Border.all(color: color, width: 2),
      ),
      child: Text(text, style: _text(size, color)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: const Color(0xFF050D1C),
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
                  // Walls (lit)
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        color: AccessGranted._wall,
                        border: Border.all(
                          color: AccessGranted._border,
                          width: 3,
                        ),
                      ),
                    ),
                  ),

                  // Floor
                  Positioned.fromRect(
                    rect: _floorArea,
                    child: CustomPaint(painter: _FloorPainter()),
                  ),

                  // Cabinets
                  for (final x in [70.0, 122.0, 476.0, 528.0])
                    Positioned(
                      left: x,
                      top: 16,
                      child: Container(
                        width: 42,
                        height: 58,
                        decoration: BoxDecoration(
                          color: AccessGranted._cabinet,
                          border: Border.all(
                            color: AccessGranted._cabinetBorder,
                            width: 2,
                          ),
                        ),
                      ),
                    ),

                  // Left door (closed)
                  Positioned(
                    left: 10,
                    top: _doorTop,
                    child: Container(
                      width: 24,
                      height: _doorBottom - _doorTop,
                      decoration: BoxDecoration(
                        color: const Color(0xFF2A4670),
                        border: Border.all(
                          color: AccessGranted._border,
                          width: 3,
                        ),
                      ),
                    ),
                  ),

                  // Exit door (open, light coming in)
                  Positioned(
                    right: 10,
                    top: _doorTop,
                    child: Container(
                      width: 24,
                      height: _doorBottom - _doorTop,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE2E8F0),
                        border: Border.all(
                          color: AccessGranted._border,
                          width: 3,
                        ),
                        boxShadow: const [
                          BoxShadow(color: Color(0x99E2E8F0), blurRadius: 24),
                        ],
                      ),
                    ),
                  ),

                  // Terminal (green)
                  Positioned(
                    left: 254,
                    top: 12,
                    child: Container(
                      width: 132,
                      height: 64,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: const Color(0xFF1C3A63),
                        border: Border.all(
                          color: AccessGranted._border,
                          width: 3,
                        ),
                      ),
                      child: Container(
                        width: 104,
                        height: 42,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: AccessGranted._greenDark,
                          border: Border.all(
                            color: AccessGranted._green,
                            width: 2,
                          ),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0xBF4ADE80),
                              blurRadius: 16,
                            ),
                          ],
                        ),
                        child: Text(
                          'ACCESS\nGRANTED',
                          textAlign: TextAlign.center,
                          style: _text(10, AccessGranted._green),
                        ),
                      ),
                    ),
                  ),

                  // Message
                  Positioned(
                    left: 0,
                    right: 0,
                    top: 94,
                    child: Center(
                      child: _label(
                        'ACCESO AL NÚCLEO AUTORIZADO',
                        AccessGranted._green,
                        AccessGranted._greenDark,
                        14,
                      ),
                    ),
                  ),

                  // Key 4 on the floor, until Luna picks it up
                  if (!_hasKey)
                    Positioned(
                      left: _keyPoint.dx - 33,
                      top: _keyPoint.dy - 15,
                      child: CustomPaint(
                        size: const Size(66, 30),
                        painter: _KeyPainter(),
                      ),
                    ),

                  // Luna. Only this part is redrawn while she walks.
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

                  // What to do next (bottom)
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 46,
                    child: Center(
                      child: _label(
                        _hasKey
                            ? 'LLAVE 4 OBTENIDA. SAL POR LA PUERTA'
                            : 'RECOGE LA LLAVE 4',
                        AccessGranted._yellow,
                        const Color(0xFF111827),
                        12,
                      ),
                    ),
                  ),

                  // Progress saved: shows for two seconds
                  if (_savedNotice)
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 12,
                      child: Center(
                        child: _label(
                          'PROGRESO GUARDADO',
                          AccessGranted._green,
                          AccessGranted._greenDark,
                          11,
                        ),
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

/// Floor with tile lines every 36 px.
class _FloorPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
      Offset.zero & size,
      Paint()..color = AccessGranted._floor,
    );
    final line = Paint()
      ..color = AccessGranted._floorLine
      ..strokeWidth = 2;
    for (double y = 0; y <= size.height; y += 36) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), line);
    }
    for (double x = 0; x <= size.width; x += 36) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), line);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Key drawn in pixel art on a 22 x 10 grid.
class _KeyPainter extends CustomPainter {
  // (x, y, width, height) in grid pixels.
  static const _pixels = [
    (0, 1, 8, 2), // top of the ring
    (0, 7, 8, 2), // bottom of the ring
    (0, 1, 2, 8), // left of the ring
    (6, 1, 2, 8), // right of the ring
    (8, 4, 14, 2), // shaft
    (16, 6, 2, 3), // first tooth
    (20, 6, 2, 3), // second tooth
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.width / 22;
    final brush = Paint()..color = AccessGranted._yellow;
    for (final (x, y, w, h) in _pixels) {
      canvas.drawRect(
        Rect.fromLTWH(x * scale, y * scale, w * scale, h * scale),
        brush,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
