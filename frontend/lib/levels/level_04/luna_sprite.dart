import 'package:flutter/material.dart';

/// Luna (the Jack Russell) drawn in pixel art.
///
/// The drawing is an 18 x 13 grid of "pixels" scaled x4.
/// When the final sprites are ready, replace this widget with an
/// image (Image.asset) of the same size.
class LunaSprite extends StatelessWidget {
  const LunaSprite({super.key, this.facingLeft = false});

  static const double spriteWidth = 72;
  static const double spriteHeight = 52;

  /// Flips Luna when she walks to the left.
  final bool facingLeft;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: spriteWidth,
      height: spriteHeight + 6,
      child: Stack(
        children: [
          // Shadow on the floor
          Positioned(
            left: 8,
            bottom: 0,
            child: Container(
              width: 58,
              height: 10,
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.45),
                borderRadius: const BorderRadius.all(Radius.elliptical(29, 5)),
              ),
            ),
          ),
          Positioned(
            left: 0,
            top: 0,
            child: Transform.flip(
              flipX: facingLeft,
              child: CustomPaint(
                size: const Size(spriteWidth, spriteHeight),
                painter: _LunaPainter(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LunaPainter extends CustomPainter {
  static const _white = Color(0xFFF5F0E6);
  static const _brown = Color(0xFF8B5A2B);
  static const _black = Color(0xFF111111);
  static const _collar = Color(0xFF2563EB);

  // (x, y, width, height, color) in "pixels" of the 18 x 13 grid.
  static const _pixels = [
    (1, 3, 2, 1, _brown), // tail
    (2, 4, 1, 1, _brown),
    (3, 5, 8, 4, _white), // body
    (5, 5, 3, 2, _brown), // spot
    (11, 2, 5, 5, _white), // head
    (11, 1, 2, 3, _brown), // ear
    (13, 2, 2, 2, _brown), // eye spot
    (14, 3, 1, 1, _black), // eye
    (16, 4, 1, 2, _white), // snout
    (17, 4, 1, 1, _black), // nose
    (10, 5, 2, 3, _collar), // blue collar
    (4, 9, 1, 3, _white), // legs
    (6, 9, 1, 3, _white),
    (9, 9, 1, 3, _white),
    (11, 7, 1, 5, _white),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.width / 18;
    final brush = Paint();
    for (final (x, y, w, h, color) in _pixels) {
      brush.color = color;
      canvas.drawRect(
        Rect.fromLTWH(x * scale, y * scale, w * scale, h * scale),
        brush,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
