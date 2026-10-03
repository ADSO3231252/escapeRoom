import 'package:flutter/material.dart';

/// Subtle CRT scanlines + vignette on top of everything, for the retro
/// look. Ignores touches, so it never blocks the controls.
class ScanlineOverlay extends StatelessWidget {
  const ScanlineOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: RepaintBoundary(
        child: CustomPaint(painter: _ScanlinePainter()),
      ),
    );
  }
}

class _ScanlinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final line = Paint()..color = Colors.black.withValues(alpha: 0.10);
    for (double y = 0; y < size.height; y += 4) {
      canvas.drawRect(Rect.fromLTWH(0, y, size.width, 1.2), line);
    }

    final rect = Offset.zero & size;
    canvas.drawRect(
      rect,
      Paint()
        ..shader = RadialGradient(
          radius: 1.4,
          colors: [
            Colors.transparent,
            Colors.black.withValues(alpha: 0.35),
          ],
          stops: const [0.6, 1.0],
        ).createShader(rect),
    );
  }

  @override
  bool shouldRepaint(covariant _ScanlinePainter oldDelegate) => false;
}
