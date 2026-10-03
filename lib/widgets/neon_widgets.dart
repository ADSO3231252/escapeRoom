import 'package:flutter/material.dart';

const Color bg = Color(0xFF030B14);
const Color panel = Color(0xFF071727);
const Color panel2 = Color(0xFF0A1D30);
const Color cyan = Color(0xFF00D9FF);
const Color cyanDark = Color(0xFF087D9A);
const Color whiteBlue = Color(0xFFD9F7FF);
const Color muted = Color(0xFF7393A5);
const Color danger = Color(0xFFFF3E61);
const Color success = Color(0xFF38E28A);

class NeonText extends StatelessWidget {
  final String text;
  final double size;
  final Color color;
  final FontWeight weight;
  final TextAlign align;

  const NeonText(
    this.text, {
    super.key,
    this.size = 14,
    this.color = cyan,
    this.weight = FontWeight.w600,
    this.align = TextAlign.left,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: align,
      style: TextStyle(
        color: color,
        fontSize: size,
        fontWeight: weight,
        letterSpacing: 1.0,
        shadows: [
          Shadow(color: color.withOpacity(.65), blurRadius: 10),
        ],
      ),
    );
  }
}

class NeonButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool filled;

  const NeonButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.filled = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 46,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: icon == null
            ? const SizedBox.shrink()
            : Icon(icon, size: 17, color: onPressed == null ? muted : cyan),
        label: NeonText(
          label,
          size: 12,
          color: onPressed == null ? muted : cyan,
        ),
        style: OutlinedButton.styleFrom(
          backgroundColor: filled ? cyan.withOpacity(.12) : Colors.transparent,
          side: BorderSide(
            color: onPressed == null ? muted.withOpacity(.25) : cyan.withOpacity(.75),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }
}

class GlassPanel extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;

  const GlassPanel({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(18),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: panel.withOpacity(.96),
        border: Border.all(color: cyan.withOpacity(.22)),
        boxShadow: [
          BoxShadow(
            color: cyan.withOpacity(.06),
            blurRadius: 20,
            spreadRadius: 1,
          ),
        ],
      ),
      child: child,
    );
  }
}

class ScanlineBackground extends StatelessWidget {
  final Widget child;

  const ScanlineBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      body: Stack(
        children: [
          Positioned.fill(
            child: CustomPaint(painter: _GridPainter()),
          ),
          child,
        ],
      ),
    );
  }
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = cyan.withOpacity(.025)
      ..strokeWidth = 1;

    const step = 32.0;
    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }

    final glow = Paint()
      ..shader = RadialGradient(
        colors: [cyan.withOpacity(.08), Colors.transparent],
      ).createShader(
        Rect.fromCircle(
          center: Offset(size.width * .5, size.height * .45),
          radius: size.width * .7,
        ),
      );
    canvas.drawRect(Offset.zero & size, glow);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
