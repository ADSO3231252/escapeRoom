import 'package:flutter/material.dart';

import '../level3_theme.dart';

/// Neon, retro-styled button used across Level 3.
class RetroButton extends StatelessWidget {
  const RetroButton({
    super.key,
    required this.label,
    required this.color,
    required this.onPressed,
    this.icon,
    this.filled = false,
    this.fontSize = 16,
  });

  final String label;
  final Color color;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool filled;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null;
    final mainColor = enabled
        ? color
        : Level3Theme.textSecondary.withValues(alpha: 0.45);
    final foreground = filled && enabled ? const Color(0xFF04121C) : mainColor;

    return Material(
      color: Colors.transparent,
      child: Ink(
        decoration: BoxDecoration(
          color: filled && enabled
              ? mainColor
              : mainColor.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: mainColor, width: 2),
          boxShadow: enabled
              ? [
                  BoxShadow(
                    color: mainColor.withValues(alpha: 0.45),
                    blurRadius: 14,
                  ),
                ]
              : null,
        ),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(10),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: fontSize * 1.4,
              vertical: fontSize * 0.75,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null) ...[
                  Icon(icon, color: foreground, size: fontSize * 1.25),
                  SizedBox(width: fontSize * 0.5),
                ],
                Text(
                  label,
                  style: Level3Theme.retro(
                    size: fontSize,
                    color: foreground,
                    weight: FontWeight.bold,
                    spacing: 2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
