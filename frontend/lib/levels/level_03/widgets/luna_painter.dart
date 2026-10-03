import 'dart:math';

import 'package:flutter/material.dart';

import '../level3_theme.dart';

/// Paints Luna, the player's female Jack Russell Terrier, from a top-down
/// view, entirely in code. Faces [angle] (radians, 0 = right), moves her
/// paws while [moving], and wags her tail using [clock].
class LunaPainter extends CustomPainter {
  LunaPainter({
    required this.angle,
    required this.walkPhase,
    required this.moving,
    required this.clock,
  }) : super(repaint: clock);

  final double angle;
  final double walkPhase;
  final bool moving;
  final Animation<double> clock;

  static const Color _white = Color(0xFFF8F3EA);
  static const Color _tan = Color(0xFFC98240);
  static const Color _brown = Color(0xFF7A3F1D);
  static const Color _outline = Color(0xFF3B2416);
  static const Color _collar = Color(0xFF2F80FF);
  static const Color _dark = Color(0xFF1E1410);

  @override
  void paint(Canvas canvas, Size size) {
    final t = clock.value * 10;
    final scale = size.width / 96;

    canvas.save();
    canvas.translate(size.width / 2, size.height / 2);
    canvas.rotate(angle);
    canvas.scale(scale);

    final outline = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..color = _outline;

    // Shadow.
    canvas.drawOval(
      Rect.fromCenter(center: const Offset(0, 8), width: 66, height: 36),
      Paint()
        ..color = Colors.black.withValues(alpha: 0.35)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4),
    );

    // Paws (diagonal pairs move together while walking).
    final step = moving ? sin(walkPhase) * 6 : 0.0;
    final paws = [
      Offset(14 + step, -14),
      Offset(14 - step, 14),
      Offset(-18 - step, -14),
      Offset(-18 + step, 14),
    ];
    for (final p in paws) {
      final r = Rect.fromCenter(center: p, width: 13, height: 10);
      canvas.drawOval(r, Paint()..color = _white);
      canvas.drawOval(r, outline);
    }

    // Tail (wags faster while walking). 3 Hz and 1.5 Hz both loop
    // seamlessly with the 10-second clock.
    final wag = sin(t * 2 * pi * (moving ? 3.0 : 1.5)) * 0.55;
    canvas.save();
    canvas.translate(-26, 0);
    canvas.rotate(pi + wag);
    final tail = RRect.fromRectAndRadius(
      const Rect.fromLTWH(0, -3.5, 20, 7),
      const Radius.circular(4),
    );
    canvas.drawRRect(tail, Paint()..color = _white);
    canvas.drawRRect(tail, outline);
    canvas.drawCircle(const Offset(18, 0), 3.5, Paint()..color = _brown);
    canvas.restore();

    // Body with the typical Jack Russell tan saddle.
    final body = Rect.fromCenter(
      center: const Offset(-4, 0),
      width: 50,
      height: 30,
    );
    canvas.drawOval(body, Paint()..color = _white);
    canvas.drawOval(
      Rect.fromCenter(center: const Offset(-9, -3), width: 24, height: 18),
      Paint()..color = _tan,
    );
    canvas.drawOval(
      Rect.fromCenter(center: const Offset(-20, 5), width: 9, height: 7),
      Paint()..color = _brown,
    );
    canvas.drawOval(body, outline);

    // Collar with a little gold tag.
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: const Offset(15, 0), width: 6, height: 24),
        const Radius.circular(3),
      ),
      Paint()..color = _collar,
    );
    canvas.drawCircle(const Offset(17, 11), 3, Paint()..color = Level3Theme.gold);

    // Head with tan face patches.
    const head = Offset(27, 0);
    canvas.drawCircle(head, 14, Paint()..color = _white);
    canvas.drawOval(
      Rect.fromCenter(center: const Offset(25, -7), width: 13, height: 10),
      Paint()..color = _tan,
    );
    canvas.drawOval(
      Rect.fromCenter(center: const Offset(25, 7), width: 13, height: 10),
      Paint()..color = _tan,
    );
    canvas.drawCircle(head, 14, outline);

    // Folded ears.
    for (final sign in const [-1.0, 1.0]) {
      final ear = Rect.fromCenter(
        center: Offset(21, 14 * sign),
        width: 12,
        height: 9,
      );
      canvas.drawOval(ear, Paint()..color = _brown);
      canvas.drawOval(ear, outline);
    }

    // Muzzle and nose.
    final muzzle = Rect.fromCenter(
      center: const Offset(38, 0),
      width: 14,
      height: 12,
    );
    canvas.drawOval(muzzle, Paint()..color = _white);
    canvas.drawOval(
      muzzle,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5
        ..color = _outline,
    );
    canvas.drawCircle(const Offset(44, 0), 3.4, Paint()..color = _dark);

    // Eyes with a tiny shine.
    for (final sign in const [-1.0, 1.0]) {
      canvas.drawCircle(Offset(31, 5.5 * sign), 2.4, Paint()..color = _dark);
      canvas.drawCircle(
        Offset(31.6, 5.5 * sign - 0.8),
        0.8,
        Paint()..color = Colors.white,
      );
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant LunaPainter oldDelegate) => true;
}