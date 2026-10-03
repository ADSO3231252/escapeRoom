import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../level3_controller.dart';
import '../level3_data.dart';
import '../level3_theme.dart';
import 'neon_banner.dart';
import 'retro_button.dart';

/// Shown when Luna opens the note: an open, glowing book with the riddle
/// (HU-04). Designed at a fixed size and scaled down to fit any screen.
class RiddleNoteOverlay extends StatelessWidget {
  const RiddleNoteOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.read<Level3Controller>();

    return Positioned.fill(
      child: Container(
        color: Colors.black.withValues(alpha: 0.75),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Center(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: SizedBox(
                  width: 640,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const NeonBanner(
                        text: 'NOTA ENCONTRADA',
                        color: Level3Theme.neonBlue,
                        icon: Icons.menu_book,
                        fontSize: 18,
                      ),
                      const SizedBox(height: 22),
                      Transform.rotate(
                        angle: -0.025,
                        child: const _OpenBook(),
                      ),
                      const SizedBox(height: 22),
                      RetroButton(
                        label: 'ATRAS',
                        color: Level3Theme.textPrimary,
                        icon: Icons.arrow_back,
                        onPressed: controller.closeOverlay,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _OpenBook extends StatelessWidget {
  const _OpenBook();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 580,
      height: 280,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        gradient: const LinearGradient(
          colors: [Color(0xFFCFE3F7), Color(0xFFE6F2FD), Color(0xFFCFE3F7)],
          stops: [0, 0.5, 1],
        ),
        border: Border.all(color: const Color(0xFF9CC4EA), width: 2),
        boxShadow: [
          BoxShadow(
            color: Level3Theme.neonBlue.withValues(alpha: 0.55),
            blurRadius: 34,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Stack(
        children: [
          // Center crease of the book.
          Center(
            child: Container(
              width: 14,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.transparent,
                    const Color(0xFF7FA6CC).withValues(alpha: 0.6),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          // Folded corner.
          Positioned(
            right: 0,
            bottom: 0,
            child: CustomPaint(
              size: const Size(34, 34),
              painter: _CornerPainter(),
            ),
          ),
          const Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 44),
              child: Text(
                Level3Data.riddleText,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'serif',
                  fontFamilyFallback: ['Georgia', 'Times New Roman'],
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1B2F4A),
                  fontSize: 22,
                  height: 1.7,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CornerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..moveTo(0, size.height)
      ..lineTo(size.width, 0)
      ..lineTo(size.width, size.height)
      ..close();
    canvas.drawPath(path, Paint()..color = const Color(0xFF9FC3E6));
  }

  @override
  bool shouldRepaint(covariant _CornerPainter oldDelegate) => false;
}