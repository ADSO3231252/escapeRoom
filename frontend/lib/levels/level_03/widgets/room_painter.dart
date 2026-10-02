import 'dart:math';

import 'package:flutter/material.dart';

import '../level3_controller.dart';
import '../level3_data.dart';
import '../level3_theme.dart';

// -----------------------------------------------------------------------------
// Shared drawing helpers
// -----------------------------------------------------------------------------

double _a(double v) => v < 0 ? 0 : (v > 1 ? 1 : v);

void _glowCircle(
  Canvas canvas,
  Offset center,
  Color color,
  double alpha,
  double radius,
) {
  if (alpha <= 0) return;
  final rect = Rect.fromCircle(center: center, radius: radius);
  canvas.drawCircle(
    center,
    radius,
    Paint()
      ..shader = RadialGradient(
        colors: [
          color.withValues(alpha: _a(alpha)),
          color.withValues(alpha: 0),
        ],
      ).createShader(rect),
  );
}

void _dashedCircle(
  Canvas canvas,
  Offset center,
  double radius,
  Color color,
  double rotation,
) {
  final rect = Rect.fromCircle(center: center, radius: radius);
  final paint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 4
    ..strokeCap = StrokeCap.round
    ..color = color;
  const dashes = 14;
  const sweep = 2 * pi / dashes;
  for (var i = 0; i < dashes; i++) {
    canvas.drawArc(rect, rotation + i * sweep, sweep * 0.55, false, paint);
  }
}

void _centeredText(
  Canvas canvas,
  String text,
  Offset center,
  TextStyle style,
) {
  final tp = TextPainter(
    text: TextSpan(text: text, style: style),
    textDirection: TextDirection.ltr,
  )..layout();
  tp.paint(canvas, center - Offset(tp.width / 2, tp.height / 2));
}

void _hazardStripes(Canvas canvas, Rect r) {
  canvas.save();
  canvas.clipRect(r);
  canvas.drawRect(r, Paint()..color = const Color(0xFF15120A));
  final stripe = Paint()
    ..color = const Color(0xFFFFC233)
    ..strokeWidth = 6;
  final span = r.width;
  for (double y = r.top - span; y < r.bottom + span; y += 16) {
    canvas.drawLine(Offset(r.left, y + span), Offset(r.right, y), stripe);
  }
  canvas.restore();
}

// -----------------------------------------------------------------------------
// Floor-level layer: everything Luna walks over or next to.
// -----------------------------------------------------------------------------

/// Draws the server room (walls, floor, servers, console, doors, lights,
/// note and cables) on a fixed 1600x760 logical canvas. Animations are
/// driven by [clock] (0..1 every 10 seconds) and [door] (0..1 opening).
class RoomPainter extends CustomPainter {
  RoomPainter({
    required this.clock,
    required this.door,
    required this.alarmStrong,
    required this.restored,
    required this.panelReady,
    required this.noteRead,
    required this.cablePositions,
    required this.revealedCables,
    required this.collectedCables,
  }) : super(repaint: Listenable.merge([clock, door]));

  final Animation<double> clock;
  final Animation<double> door;
  final bool alarmStrong;
  final bool restored;
  final bool panelReady;
  final bool noteRead;
  final Map<int, Offset> cablePositions;
  final Set<int> revealedCables;
  final Set<int> collectedCables;

  static const Rect interior = Rect.fromLTWH(56, 56, 1488, 648);

  static const List<Offset> _wallLights = [
    Offset(30, 190),
    Offset(30, 590),
    Offset(1570, 190),
    Offset(1570, 590),
  ];

  static const List<Offset> _lightPools = [
    Offset(96, 190),
    Offset(96, 590),
    Offset(1504, 190),
    Offset(1504, 590),
  ];

  /// Seconds, looping every 10 s. Every animation period used below
  /// divides 10 evenly, so the loop is seamless.
  double get _t => clock.value * 10.0;

  double _wave(double period, [double phase = 0]) =>
      0.5 + 0.5 * sin((_t / period + phase) * 2 * pi);

  @override
  void paint(Canvas canvas, Size size) {
    _drawWalls(canvas, size);
    _drawFloor(canvas);
    _drawFloorDecor(canvas);
    _drawAmbient(canvas);
    _drawWallLights(canvas);
    _drawExitLight(canvas);
    _drawDoor(
      canvas,
      left: true,
      open: 0,
      lamp: Level3Theme.amber,
      lampOn: 1,
    );
    _drawDoor(
      canvas,
      left: false,
      open: door.value,
      lamp: restored ? Level3Theme.neonGreen : Level3Theme.neonRed,
      lampOn: restored ? 1 : 0.4 + 0.6 * _wave(1),
    );
    _drawControlDesk(canvas);
    _drawServers(canvas);
    _drawConsole(canvas);
    _drawNote(canvas);
    _drawCables(canvas);
  }

  // ---- Structure ------------------------------------------------------------

  void _drawWalls(Canvas canvas, Size size) {
    final outer = Offset.zero & size;
    canvas.drawRect(outer, Paint()..color = const Color(0xFF050B12));

    final wall = outer.deflate(6);
    final wallRRect =
        RRect.fromRectAndRadius(wall, const Radius.circular(20));
    canvas.drawRRect(
      wallRRect,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF1E3650), Color(0xFF122338)],
        ).createShader(wall),
    );
    canvas.drawRRect(
      wallRRect,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3
        ..color = const Color(0xFF2E4D6B),
    );

    final seam = Paint()
      ..color = const Color(0xFF0B1826)
      ..strokeWidth = 2;
    final rivet = Paint()..color = const Color(0xFF45637F);

    for (double x = 120; x < size.width - 60; x += 120) {
      canvas.drawLine(Offset(x, 10), Offset(x, 52), seam);
      canvas.drawLine(
        Offset(x, size.height - 52),
        Offset(x, size.height - 10),
        seam,
      );
      canvas.drawCircle(Offset(x - 60, 22), 3, rivet);
      canvas.drawCircle(Offset(x - 60, size.height - 22), 3, rivet);
    }
    for (double y = 120; y < size.height - 60; y += 120) {
      canvas.drawLine(Offset(10, y), Offset(52, y), seam);
      canvas.drawLine(
        Offset(size.width - 52, y),
        Offset(size.width - 10, y),
        seam,
      );
    }

    canvas.drawRect(
      interior.inflate(5),
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 6
        ..color = const Color(0xFF0A1622),
    );
    canvas.drawRect(
      interior.inflate(2),
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..color = const Color(0xFF34597A),
    );
  }

  void _drawFloor(Canvas canvas) {
    canvas.save();
    canvas.clipRect(interior);
    canvas.drawRect(interior, Paint()..color = const Color(0xFF122840));

    const tile = 80.0;
    final darkTile = Paint()..color = const Color(0xFF17314C);
    final lightTile = Paint()..color = const Color(0xFF1A3653);
    final bevel = Paint()
      ..color = const Color(0x332E5A80)
      ..strokeWidth = 1.5;

    var col = 0;
    for (double x = interior.left; x < interior.right; x += tile) {
      var row = 0;
      for (double y = interior.top; y < interior.bottom; y += tile) {
        final r = Rect.fromLTWH(x, y, tile, tile);
        canvas.drawRect(r.deflate(2), (col + row).isEven ? lightTile : darkTile);
        canvas.drawLine(
          r.topLeft + const Offset(3, 3),
          r.topRight + const Offset(-3, 3),
          bevel,
        );
        row++;
      }
      col++;
    }
    canvas.restore();
  }

  void _drawFloorDecor(Canvas canvas) {
    _grate(canvas, const Rect.fromLTWH(752, 404, 96, 72));
    _grate(canvas, const Rect.fromLTWH(540, 612, 72, 52));
    _grate(canvas, const Rect.fromLTWH(1000, 612, 72, 52));

    final conduit = Paint()
      ..color = const Color(0xFF0D2033)
      ..strokeWidth = 12
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(const Offset(1196, 236), const Offset(1380, 236), conduit);

    // Warning strip in front of the exit door.
    _hazardStripes(canvas, const Rect.fromLTWH(1510, 316, 30, 136));
  }

  void _grate(Canvas canvas, Rect r) {
    final rr = RRect.fromRectAndRadius(r, const Radius.circular(4));
    canvas.drawRRect(rr, Paint()..color = const Color(0xFF0B1A29));
    canvas.drawRRect(
      rr,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..color = const Color(0xFF2F5373),
    );
    final slat = Paint()
      ..color = const Color(0xFF214160)
      ..strokeWidth = 3;
    for (double x = r.left + 10; x < r.right - 6; x += 10) {
      canvas.drawLine(Offset(x, r.top + 6), Offset(x, r.bottom - 6), slat);
    }
  }

  // ---- Lighting ---------------------------------------------------------------

  void _drawAmbient(Canvas canvas) {
    if (restored) {
      canvas.drawRect(
        interior,
        Paint()..color = Level3Theme.neonGreen.withValues(alpha: 0.05),
      );
      for (final c in _lightPools) {
        _glowCircle(canvas, c, Level3Theme.neonGreen, 0.22, 170);
      }
      return;
    }

    final intensity = alarmStrong ? 1.0 : 0.5;
    final p = _wave(1);
    canvas.drawRect(
      interior,
      Paint()
        ..color = Level3Theme.neonRed
            .withValues(alpha: _a((0.04 + 0.10 * p) * intensity)),
    );
    for (final c in _lightPools) {
      _glowCircle(canvas, c, Level3Theme.neonRed, 0.38 * p * intensity, 170);
    }
    _glowCircle(
      canvas,
      const Offset(795, 230),
      Level3Theme.neonRed,
      0.22 * p * intensity,
      320,
    );
  }

  void _drawWallLights(Canvas canvas) {
    final color = restored ? Level3Theme.neonGreen : Level3Theme.neonRed;
    final on = restored ? 1.0 : 0.35 + 0.65 * _wave(1);
    for (final c in _wallLights) {
      final rr = RRect.fromRectAndRadius(
        Rect.fromCenter(center: c, width: 12, height: 96),
        const Radius.circular(6),
      );
      canvas.drawRRect(
        rr,
        Paint()
          ..color = color.withValues(alpha: _a(0.7 * on))
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12),
      );
      canvas.drawRRect(rr, Paint()..color = color.withValues(alpha: _a(on)));
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(center: c, width: 3, height: 80),
          const Radius.circular(2),
        ),
        Paint()..color = Colors.white.withValues(alpha: _a(0.6 * on)),
      );
    }
  }

  void _drawExitLight(Canvas canvas) {
    final o = door.value;
    if (o <= 0) return;
    _glowCircle(canvas, const Offset(1500, 384), Level3Theme.neonGreen,
        0.45 * o, 290);
    _glowCircle(canvas, const Offset(1534, 384), Colors.white, 0.35 * o, 140);
  }

  // ---- Doors -----------------------------------------------------------------

  void _drawDoor(
    Canvas canvas, {
    required bool left,
    required double open,
    required Color lamp,
    required double lampOn,
  }) {
    final frame = left
        ? const Rect.fromLTWH(4, 296, 72, 176)
        : const Rect.fromLTWH(1524, 296, 72, 176);
    final frameRRect =
        RRect.fromRectAndRadius(frame, const Radius.circular(8));
    canvas.drawRRect(frameRRect, Paint()..color = const Color(0xFF0C1A28));
    canvas.drawRRect(
      frameRRect,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3
        ..color = const Color(0xFF46688A),
    );

    final opening = frame.deflate(10);

    if (open > 0) {
      canvas.drawRect(
        opening,
        Paint()
          ..shader = LinearGradient(
            begin: Alignment.centerRight,
            end: Alignment.centerLeft,
            colors: [
              Colors.white.withValues(alpha: _a(open)),
              Level3Theme.neonGreen.withValues(alpha: _a(0.75 * open)),
            ],
          ).createShader(opening),
      );
    }

    final slabHeight = opening.height * (1 - open);
    if (slabHeight > 1) {
      final slab = Rect.fromLTWH(
        opening.left,
        opening.top,
        opening.width,
        slabHeight,
      );
      canvas.drawRect(
        slab,
        Paint()
          ..shader = const LinearGradient(
            colors: [Color(0xFF3A5875), Color(0xFF223A52)],
          ).createShader(slab),
      );

      final groove = Paint()
        ..color = const Color(0xFF1A2E42)
        ..strokeWidth = 2;
      for (double y = slab.top + 18; y < slab.bottom - 6; y += 22) {
        canvas.drawLine(
          Offset(slab.left + 6, y),
          Offset(slab.right - 6, y),
          groove,
        );
      }

      final stripe = left
          ? Rect.fromLTWH(slab.right - 12, slab.top, 12, slab.height)
          : Rect.fromLTWH(slab.left, slab.top, 12, slab.height);
      _hazardStripes(canvas, stripe);

      if (slabHeight > 40) {
        final handleX = left ? slab.right - 24 : slab.left + 18;
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTWH(handleX, slab.center.dy - 14, 6, 28),
            const Radius.circular(3),
          ),
          Paint()..color = const Color(0xFF8FA8C2),
        );
      }
    }

    final lampCenter = Offset(frame.center.dx, frame.top - 16);
    canvas.drawCircle(
      lampCenter,
      15,
      Paint()
        ..color = lamp.withValues(alpha: _a(0.6 * lampOn))
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10),
    );
    canvas.drawCircle(
      lampCenter,
      7,
      Paint()..color = lamp.withValues(alpha: _a(lampOn)),
    );
    canvas.drawCircle(
      lampCenter,
      7,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..color = const Color(0xFF0C1A28),
    );
  }

  // ---- Furniture ---------------------------------------------------------------

  void _shadow(Canvas canvas, Rect r) {
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        r.shift(const Offset(0, 10)),
        const Radius.circular(8),
      ),
      Paint()
        ..color = Colors.black.withValues(alpha: 0.4)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8),
    );
  }

  void _metalBox(
    Canvas canvas,
    Rect r, {
    Color border = const Color(0xFF35607F),
    double radius = 8,
  }) {
    final rr = RRect.fromRectAndRadius(r, Radius.circular(radius));
    canvas.drawRRect(
      rr,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF2A4560), Color(0xFF15273B)],
        ).createShader(r),
    );
    canvas.drawRRect(
      rr,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..color = border,
    );
  }

  void _drawControlDesk(Canvas canvas) {
    const r = Rect.fromLTWH(84, 62, 154, 70);
    _shadow(canvas, r);
    _metalBox(canvas, r, border: const Color(0xFF3E6385));

    const screen = Rect.fromLTWH(96, 74, 74, 46);
    canvas.drawRRect(
      RRect.fromRectAndRadius(screen, const Radius.circular(4)),
      Paint()..color = const Color(0xFF051019),
    );

    final waveColor = restored ? Level3Theme.neonGreen : Level3Theme.neonRed;
    final wave = Path();
    for (double x = 0; x <= screen.width - 8; x += 2) {
      final y = screen.center.dy +
          sin(x / 10 + _t * 2 * pi) * (restored ? 6 : 12);
      if (x == 0) {
        wave.moveTo(screen.left + 4 + x, y);
      } else {
        wave.lineTo(screen.left + 4 + x, y);
      }
    }
    canvas.drawPath(
      wave,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..color = waveColor,
    );

    const buttonColors = [
      Level3Theme.amber,
      Level3Theme.neonGreen,
      Level3Theme.neonRed,
    ];
    for (var i = 0; i < 3; i++) {
      final on = _wave(i == 1 ? 2.0 : 1.0, i * 0.3) > 0.4;
      canvas.drawCircle(
        Offset(190 + i * 18.0, 84),
        5,
        Paint()..color = buttonColors[i].withValues(alpha: on ? 1 : 0.25),
      );
    }
    for (var i = 0; i < 4; i++) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(182 + i * 12.0, 104, 9, 14),
          const Radius.circular(2),
        ),
        Paint()..color = const Color(0xFF5B7A99),
      );
    }
  }

  void _drawServers(Canvas canvas) {
    final capColor = restored ? Level3Theme.neonGreen : Level3Theme.neonRed;
    final capOn = restored ? 1.0 : 0.4 + 0.6 * _wave(1);
    final palette = restored
        ? const [Level3Theme.neonGreen, Level3Theme.neonBlue, Color(0xFF8CFF6B)]
        : const [Level3Theme.neonRed, Level3Theme.amber, Color(0xFF4A5B6C)];

    for (final r in const [
      Rect.fromLTWH(410, 74, 54, 120),
      Rect.fromLTWH(1126, 74, 54, 120),
    ]) {
      _shadow(canvas, r);
      _metalBox(canvas, r, radius: 6);
      final light = RRect.fromRectAndRadius(
        Rect.fromLTWH(r.left + 12, r.top + 10, r.width - 24, 6),
        const Radius.circular(3),
      );
      canvas.drawRRect(
        light,
        Paint()
          ..color = Level3Theme.neonBlue
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5),
      );
      canvas.drawRRect(light, Paint()..color = Level3Theme.neonBlue);
      final line = Paint()
        ..color = const Color(0xFF0E1D2C)
        ..strokeWidth = 2;
      for (double y = r.top + 30; y < r.bottom - 8; y += 14) {
        canvas.drawLine(Offset(r.left + 10, y), Offset(r.right - 10, y), line);
      }
    }

    for (var i = 0; i < 5; i++) {
      final r = Rect.fromLTWH(480 + i * 130.0, 62, 110, 140);
      _shadow(canvas, r);
      _metalBox(canvas, r, radius: 6, border: const Color(0xFF3A6688));

      final cap = RRect.fromRectAndRadius(
        Rect.fromLTWH(r.left + 10, r.top + 7, r.width - 20, 6),
        const Radius.circular(3),
      );
      canvas.drawRRect(
        cap,
        Paint()
          ..color = capColor.withValues(alpha: _a(0.8 * capOn))
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6),
      );
      canvas.drawRRect(
        cap,
        Paint()..color = capColor.withValues(alpha: _a(capOn)),
      );

      for (var row = 0; row < 7; row++) {
        final slot = Rect.fromLTWH(r.left + 10, r.top + 22 + row * 16.0,
            r.width - 20, 10);
        canvas.drawRect(slot, Paint()..color = const Color(0xFF08131F));
        for (var k = 0; k < 5; k++) {
          final seed = ((i * 37 + row * 11 + k * 7) % 10) / 10.0;
          final period = (i + row + k).isEven ? 1.0 : 2.0;
          final on = ((_t / period + seed) % 1.0) > 0.35;
          final color = palette[(i + row + k) % 3];
          canvas.drawRect(
            Rect.fromLTWH(slot.left + 6 + k * 17.0, slot.top + 3, 9, 4),
            Paint()..color = color.withValues(alpha: on ? 1.0 : 0.15),
          );
        }
      }
    }
  }

  void _drawConsole(Canvas canvas) {
    const r = Rect.fromLTWH(1396, 62, 128, 142);
    final accent = restored ? Level3Theme.neonGreen : Level3Theme.neonBlue;

    if (panelReady && !restored) {
      final g = 0.3 + 0.7 * _wave(1);
      canvas.drawRRect(
        RRect.fromRectAndRadius(r.inflate(12), const Radius.circular(18)),
        Paint()
          ..color = Level3Theme.neonBlue.withValues(alpha: _a(0.65 * g))
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 22),
      );
    }

    _shadow(canvas, r);
    _metalBox(canvas, r, border: accent.withValues(alpha: 0.85));

    final plate = Rect.fromLTWH(r.left + 22, r.top + 9, r.width - 44, 22);
    canvas.drawRRect(
      RRect.fromRectAndRadius(plate, const Radius.circular(4)),
      Paint()..color = const Color(0xFF071420),
    );
    _centeredText(
      canvas,
      'RESET',
      plate.center,
      Level3Theme.retro(
        size: 15,
        color: accent,
        weight: FontWeight.bold,
        spacing: 3,
      ),
    );

    final screen = Rect.fromLTWH(r.left + 14, r.top + 38, r.width - 28, 54);
    final screenRRect =
        RRect.fromRectAndRadius(screen, const Radius.circular(5));
    canvas.drawRRect(
      screenRRect,
      Paint()
        ..color =
            restored ? const Color(0xFF06261C) : const Color(0xFF051019),
    );
    canvas.drawRRect(
      screenRRect,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..color = accent.withValues(alpha: 0.85),
    );

    const squares = [
      Level3Theme.neonRed,
      Level3Theme.neonBlue,
      Level3Theme.neonGreen,
    ];
    final squareAlpha = restored ? 1.0 : (panelReady ? 0.9 : 0.35);
    for (var i = 0; i < 3; i++) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(
            center: Offset(screen.left + 22 + i * 28.0, screen.center.dy),
            width: 16,
            height: 16,
          ),
          const Radius.circular(3),
        ),
        Paint()..color = squares[i].withValues(alpha: squareAlpha),
      );
    }

    for (var row = 0; row < 2; row++) {
      for (var col = 0; col < 4; col++) {
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTWH(
                r.left + 18 + col * 24.0, r.top + 100 + row * 18.0, 18, 12),
            const Radius.circular(2),
          ),
          Paint()..color = const Color(0xFF4F6E8E),
        );
      }
    }
  }

  // ---- Interactive objects -----------------------------------------------------

  void _drawNote(Canvas canvas) {
    const c = Level3Controller.notePosition;
    final glow = noteRead ? 0.2 : 0.35 + 0.45 * _wave(2);
    _glowCircle(canvas, c, Level3Theme.neonBlue, glow, 70);

    canvas.save();
    canvas.translate(c.dx, c.dy);
    canvas.rotate(-0.35);
    final paper = Rect.fromCenter(center: Offset.zero, width: 48, height: 36);
    canvas.drawRect(
      paper.shift(const Offset(3, 5)),
      Paint()..color = Colors.black.withValues(alpha: 0.35),
    );
    canvas.drawRect(paper, Paint()..color = const Color(0xFFD9ECFF));
    final line = Paint()
      ..color = const Color(0xFF7FA6CC)
      ..strokeWidth = 1.6;
    for (var i = 0; i < 4; i++) {
      final y = paper.top + 8 + i * 7.0;
      canvas.drawLine(Offset(paper.left + 6, y), Offset(paper.right - 8, y), line);
    }
    final corner = Path()
      ..moveTo(paper.right - 12, paper.bottom)
      ..lineTo(paper.right, paper.bottom - 12)
      ..lineTo(paper.right, paper.bottom)
      ..close();
    canvas.drawPath(corner, Paint()..color = const Color(0xFF9FC3E6));
    canvas.restore();
  }

  void _drawCables(Canvas canvas) {
    final spin = _t / 10 * 2 * pi;
    cablePositions.forEach((id, pos) {
      if (collectedCables.contains(id)) return;

      if (!revealedCables.contains(id)) {
        canvas.drawCircle(
          pos,
          38,
          Paint()..color = Colors.white.withValues(alpha: 0.05),
        );
        _dashedCircle(
          canvas,
          pos,
          38,
          Colors.white.withValues(alpha: 0.6),
          spin,
        );
        return;
      }

      final color =
          Level3Theme.colorFromName(Level3Data.cableColorNames[id] ?? '');
      _glowCircle(canvas, pos, color, 0.30 + 0.25 * _wave(1), 80);
      _dashedCircle(canvas, pos, 40, color.withValues(alpha: 0.9), spin);
      _drawCoil(canvas, pos, color);
    });
  }

  void _drawCoil(Canvas canvas, Offset c, Color color) {
    final dark = Color.lerp(color, Colors.black, 0.45)!;
    final light = Color.lerp(color, Colors.white, 0.35)!;

    canvas.save();
    canvas.translate(c.dx, c.dy);
    canvas.rotate(-0.4);
    for (var k = 0; k < 3; k++) {
      final rect = Rect.fromCenter(
        center: Offset(k * 3.0 - 3, k * 2.0 - 2),
        width: 46 - k * 7.0,
        height: 30 - k * 5.0,
      );
      canvas.drawOval(
        rect,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 6
          ..color = dark,
      );
      canvas.drawOval(
        rect,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3
          ..color = color,
      );
    }
    canvas.drawLine(
      const Offset(18, 6),
      const Offset(30, 18),
      Paint()
        ..strokeWidth = 5
        ..strokeCap = StrokeCap.round
        ..color = color,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(26, 14, 14, 10),
        const Radius.circular(2),
      ),
      Paint()..color = light,
    );
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant RoomPainter oldDelegate) => true;
}

// -----------------------------------------------------------------------------
// Top layer: drawn above Luna (labels, key, interaction arrow).
// -----------------------------------------------------------------------------

class RoomTopPainter extends CustomPainter {
  RoomTopPainter({
    required this.clock,
    required this.restored,
    required this.cablePositions,
    required this.revealedCables,
    required this.collectedCables,
    required this.indicator,
  }) : super(repaint: clock);

  final Animation<double> clock;
  final bool restored;
  final Map<int, Offset> cablePositions;
  final Set<int> revealedCables;
  final Set<int> collectedCables;
  final Offset? indicator;

  double get _t => clock.value * 10.0;

  double _wave(double period, [double phase = 0]) =>
      0.5 + 0.5 * sin((_t / period + phase) * 2 * pi);

  @override
  void paint(Canvas canvas, Size size) {
    for (final cable in Level3Data.cables) {
      if (collectedCables.contains(cable.id)) continue;
      if (!revealedCables.contains(cable.id)) continue;
      final pos = cablePositions[cable.id];
      if (pos == null) continue;
      final color = Level3Theme.colorFromName(
          Level3Data.cableColorNames[cable.id] ?? '');
      _drawLabel(canvas, cable.name, color, pos + const Offset(0, -70));
    }

    if (restored) _drawKey(canvas);

    final target = indicator;
    if (target != null) _drawIndicator(canvas, target);
  }

  void _drawLabel(
    Canvas canvas,
    String text,
    Color color,
    Offset center, {
    bool pointerUp = false,
  }) {
    final tp = TextPainter(
      text: TextSpan(
        text: text,
        style: Level3Theme.retro(
          size: 22,
          color: color,
          weight: FontWeight.bold,
          spacing: 2,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    final box = Rect.fromCenter(
      center: center,
      width: tp.width + 30,
      height: tp.height + 14,
    );
    final rr = RRect.fromRectAndRadius(box, const Radius.circular(8));

    canvas.drawRRect(
      rr.inflate(3),
      Paint()
        ..color = color.withValues(alpha: 0.35)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8),
    );
    canvas.drawRRect(rr, Paint()..color = const Color(0xF00A1622));
    canvas.drawRRect(
      rr,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5
        ..color = color,
    );

    final pointer = Path();
    if (pointerUp) {
      pointer
        ..moveTo(center.dx - 9, box.top)
        ..lineTo(center.dx + 9, box.top)
        ..lineTo(center.dx, box.top - 11)
        ..close();
    } else {
      pointer
        ..moveTo(center.dx - 9, box.bottom)
        ..lineTo(center.dx + 9, box.bottom)
        ..lineTo(center.dx, box.bottom + 11)
        ..close();
    }
    canvas.drawPath(pointer, Paint()..color = color);

    tp.paint(canvas, center - Offset(tp.width / 2, tp.height / 2));
  }

  void _drawKey(Canvas canvas) {
    final bob = sin(_t * 2 * pi / 2) * 8;
    final c = Level3Controller.keyPosition + Offset(0, bob);

    _glowCircle(canvas, c, Level3Theme.gold, 0.5, 95);

    for (var i = 0; i < 4; i++) {
      final angle = _t * 2 * pi / 5 + i * pi / 2;
      final p = c + Offset(cos(angle) * 50, sin(angle) * 32);
      _sparkle(canvas, p, 3 + 3 * _wave(1, i * 0.25));
    }

    canvas.save();
    canvas.translate(c.dx, c.dy);
    canvas.rotate(-0.55);
    final gold = Paint()..color = Level3Theme.gold;
    canvas.drawCircle(const Offset(-20, 0), 15, gold);
    canvas.drawCircle(
      const Offset(-20, 0),
      6,
      Paint()..color = const Color(0xFF3A2A05),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(-8, -4, 46, 8),
        const Radius.circular(2),
      ),
      gold,
    );
    canvas.drawRect(const Rect.fromLTWH(28, 4, 6, 11), gold);
    canvas.drawRect(const Rect.fromLTWH(17, 4, 5, 7), gold);
    canvas.drawCircle(
      const Offset(-20, 0),
      15,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..color = const Color(0xFFB8860B),
    );
    canvas.restore();

    _drawLabel(canvas, 'LLAVE 3', Level3Theme.gold, c + const Offset(0, 56),
        pointerUp: true);
  }

  void _sparkle(Canvas canvas, Offset c, double s) {
    final path = Path()
      ..moveTo(c.dx, c.dy - s * 2)
      ..lineTo(c.dx + s * 0.5, c.dy - s * 0.5)
      ..lineTo(c.dx + s * 2, c.dy)
      ..lineTo(c.dx + s * 0.5, c.dy + s * 0.5)
      ..lineTo(c.dx, c.dy + s * 2)
      ..lineTo(c.dx - s * 0.5, c.dy + s * 0.5)
      ..lineTo(c.dx - s * 2, c.dy)
      ..lineTo(c.dx - s * 0.5, c.dy - s * 0.5)
      ..close();
    canvas.drawPath(path, Paint()..color = const Color(0xFFFFF4C2));
  }

  void _drawIndicator(Canvas canvas, Offset target) {
    final tip = target + Offset(0, sin(_t * 2 * pi) * 6);
    final path = Path()
      ..moveTo(tip.dx - 15, tip.dy - 20)
      ..lineTo(tip.dx + 15, tip.dy - 20)
      ..lineTo(tip.dx, tip.dy)
      ..close();
    canvas.drawPath(
      path,
      Paint()
        ..color = Level3Theme.neonBlue.withValues(alpha: 0.85)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8),
    );
    canvas.drawPath(path, Paint()..color = Colors.white);
  }

  @override
  bool shouldRepaint(covariant RoomTopPainter oldDelegate) => true;
}
