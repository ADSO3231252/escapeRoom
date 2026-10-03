import 'package:flutter/material.dart';

import '../level3_theme.dart';

/// Neon sign-style banner used for the real-time alerts (ERROR 404,
/// SISTEMA RESTAURADO, panel feedback). Can flicker like a failing light.
class NeonBanner extends StatefulWidget {
  const NeonBanner({
    super.key,
    required this.text,
    required this.color,
    this.icon,
    this.flicker = false,
    this.fontSize = 18,
  });

  final String text;
  final Color color;
  final IconData? icon;
  final bool flicker;
  final double fontSize;

  @override
  State<NeonBanner> createState() => _NeonBannerState();
}

class _NeonBannerState extends State<NeonBanner>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1400),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.color;
    final size = widget.fontSize;

    final banner = Container(
      padding: EdgeInsets.symmetric(
        horizontal: size * 1.1,
        vertical: size * 0.55,
      ),
      decoration: BoxDecoration(
        color: Color.lerp(
          const Color(0xFF05080C),
          color,
          0.14,
        )!.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color, width: 2.5),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.55),
            blurRadius: 18,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.icon != null) ...[
            Icon(widget.icon, color: color, size: size * 1.35),
            SizedBox(width: size * 0.6),
          ],
          Flexible(
            child: Text(
              widget.text,
              textAlign: TextAlign.center,
              style: Level3Theme.retro(
                size: size,
                color: color,
                weight: FontWeight.bold,
                spacing: 2,
                glow: true,
              ),
            ),
          ),
        ],
      ),
    );

    if (!widget.flicker) return banner;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final v = _controller.value;
        final dim =
            (v > 0.08 && v < 0.12) ||
            (v > 0.46 && v < 0.50) ||
            (v > 0.53 && v < 0.56);
        return Opacity(opacity: dim ? 0.35 : 1, child: child);
      },
      child: banner,
    );
  }
}
