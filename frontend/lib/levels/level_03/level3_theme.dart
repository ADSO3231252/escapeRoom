import 'package:flutter/material.dart';

/// Colors and text styles for Level 3 — a retro, neon, sci-fi look
/// inspired by the Figma/mockup references.
class Level3Theme {
  Level3Theme._();

  static const Color background = Color(0xFF070F18);
  static const Color panelBackground = Color(0xFF102235);

  static const Color neonRed = Color(0xFFFF4D5E);
  static const Color neonBlue = Color(0xFF45C8FF);
  static const Color neonGreen = Color(0xFF3DFFA8);
  static const Color gold = Color(0xFFFFD34D);
  static const Color amber = Color(0xFFFFB347);

  static const Color textPrimary = Color(0xFFE8F1F8);
  static const Color textSecondary = Color(0xFF8FA8C2);

  /// Monospace font available on Android, iOS and web without adding any
  /// package — gives the retro "terminal" feel.
  static const String retroFont = 'monospace';
  static const List<String> retroFallback = ['Courier New', 'Courier', 'Menlo'];

  /// Returns the themed color for a cable color name ('red', 'blue',
  /// 'green'). Falls back to [textPrimary].
  static Color colorFromName(String name) {
    switch (name) {
      case 'red':
        return neonRed;
      case 'blue':
        return neonBlue;
      case 'green':
        return neonGreen;
      default:
        return textPrimary;
    }
  }

  /// Retro monospace text style, optionally with a neon glow.
  static TextStyle retro({
    double size = 14,
    Color color = textPrimary,
    FontWeight weight = FontWeight.w600,
    double spacing = 1.2,
    double height = 1.2,
    bool glow = false,
  }) {
    return TextStyle(
      fontFamily: retroFont,
      fontFamilyFallback: retroFallback,
      fontSize: size,
      color: color,
      fontWeight: weight,
      letterSpacing: spacing,
      height: height,
      shadows: glow
          ? [
              Shadow(
                color: color.withValues(alpha: 0.85),
                blurRadius: size * 0.6,
              ),
            ]
          : null,
    );
  }
}
