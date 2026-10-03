import 'dart:math';

import 'package:flutter/material.dart';

import '../level3_theme.dart';

/// Retro-styled virtual joystick. Reports a direction vector (length 0
/// to 1) through [onChanged]; it knows nothing about the room or
/// collisions — that is handled by Level3Controller.
class JoystickWidget extends StatefulWidget {
  const JoystickWidget({
    super.key,
    required this.onChanged,
    this.size = 128,
  });

  final ValueChanged<Offset> onChanged;
  final double size;

  @override
  State<JoystickWidget> createState() => _JoystickWidgetState();
}

class _JoystickWidgetState extends State<JoystickWidget> {
  Offset _knob = Offset.zero;
  bool _active = false;

  double get _baseRadius => widget.size / 2;
  double get _knobRadius => widget.size * 0.21;

  void _update(Offset localPosition) {
    final center = Offset(_baseRadius, _baseRadius);
    var vector = localPosition - center;
    final maxDistance = _baseRadius - _knobRadius * 0.6;
    if (vector.distance > maxDistance) {
      vector = vector / vector.distance * maxDistance;
    }
    setState(() {
      _knob = vector;
      _active = true;
    });
    widget.onChanged(vector / maxDistance);
  }

  void _reset() {
    setState(() {
      _knob = Offset.zero;
      _active = false;
    });
    widget.onChanged(Offset.zero);
  }

  @override
  void dispose() {
    widget.onChanged(Offset.zero);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onPanStart: (d) => _update(d.localPosition),
      onPanUpdate: (d) => _update(d.localPosition),
      onPanEnd: (_) => _reset(),
      onPanCancel: _reset,
      child: SizedBox(
        width: widget.size,
        height: widget.size,
        child: Stack(
          children: [
            Positioned.fill(
              child: CustomPaint(
                painter: _JoystickBasePainter(active: _active),
              ),
            ),
            Center(
              child: Transform.translate(
                offset: _knob,
                child: Container(
                  width: _knobRadius * 2,
                  height: _knobRadius * 2,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const RadialGradient(
                      colors: [
                        Color(0xFF9BE6FF),
                        Level3Theme.neonBlue,
                        Color(0xFF1C6E9C),
                      ],
                      stops: [0, 0.55, 1],
                    ),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.6),
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Level3Theme.neonBlue.withValues(alpha: 0.6),
                        blurRadius: 14,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _JoystickBasePainter extends CustomPainter {
  _JoystickBasePainter({required this.active});

  final bool active;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.width / 2;

    canvas.drawCircle(
      center,
      radius - 2,
      Paint()..color = Level3Theme.panelBackground.withValues(alpha: 0.6),
    );
    canvas.drawCircle(
      center,
      radius - 2,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3
        ..color = Level3Theme.neonBlue.withValues(alpha: active ? 0.9 : 0.45),
    );
    canvas.drawCircle(
      center,
      radius * 0.62,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5
        ..color = Level3Theme.neonBlue.withValues(alpha: 0.25),
    );

    final tick = Paint()
      ..color = Level3Theme.neonBlue.withValues(alpha: 0.5)
      ..strokeWidth = 2;
    for (var i = 0; i < 8; i++) {
      final angle = i * pi / 4;
      final dir = Offset(cos(angle), sin(angle));
      canvas.drawLine(
        center + dir * (radius - 12),
        center + dir * (radius - 5),
        tick,
      );
    }

    final arrow = Paint()
      ..color = Level3Theme.textSecondary.withValues(alpha: 0.7);
    for (var i = 0; i < 4; i++) {
      final angle = i * pi / 2;
      final dir = Offset(cos(angle), sin(angle));
      final normal = Offset(-dir.dy, dir.dx);
      final tip = center + dir * (radius - 16);
      final base = center + dir * (radius - 26);
      final path = Path()
        ..moveTo(tip.dx, tip.dy)
        ..lineTo(base.dx + normal.dx * 6, base.dy + normal.dy * 6)
        ..lineTo(base.dx - normal.dx * 6, base.dy - normal.dy * 6)
        ..close();
      canvas.drawPath(path, arrow);
    }
  }

  @override
  bool shouldRepaint(covariant _JoystickBasePainter oldDelegate) =>
      oldDelegate.active != active;
}