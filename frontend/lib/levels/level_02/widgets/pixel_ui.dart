import 'package:flutter/material.dart';
import '../models/level_02_state.dart';
import '../screens/level_02_screen.dart';

class PixelBackground extends StatelessWidget {
  final Widget child;
  const PixelBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF05070C),
      body: Stack(
        children: [
          Positioned.fill(child: CustomPaint(painter: _PixelBgPainter())),
          SafeArea(child: child),
        ],
      ),
    );
  }
}

class PixelPanel extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;
  const PixelPanel({super.key, required this.child, this.padding = const EdgeInsets.all(22)});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: const Color(0xFF0B111B),
        border: Border.all(color: const Color(0xFF425975), width: 2),
        boxShadow: const [BoxShadow(color: Color(0x99000000), offset: Offset(6, 6), blurRadius: 0)],
      ),
      child: child,
    );
  }
}

class PixelButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  const PixelButton({super.key, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF15263A),
          foregroundColor: const Color(0xFFE5F4FF),
          disabledBackgroundColor: const Color(0xFF111923),
          disabledForegroundColor: const Color(0xFF53657A),
          elevation: 0,
          side: const BorderSide(color: Color(0xFF4E7394), width: 2),
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        ),
        child: Text(text, style: const TextStyle(fontFamily: 'monospace', fontWeight: FontWeight.w900, letterSpacing: 1.2)),
      ),
    );
  }
}

class PixelTitle extends StatelessWidget {
  final String text;
  final String? subtitle;
  const PixelTitle({super.key, required this.text, this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(text, textAlign: TextAlign.center, style: const TextStyle(fontFamily: 'monospace', color: Color(0xFFDDF3FF), fontSize: 25, fontWeight: FontWeight.w900, letterSpacing: 2)),
        if (subtitle != null) ...[
          const SizedBox(height: 8),
          Text(subtitle!, textAlign: TextAlign.center, style: const TextStyle(fontFamily: 'monospace', color: Color(0xFF7890A8), fontSize: 11, letterSpacing: 1)),
        ],
      ],
    );
  }
}

class Level02TimerBar extends StatelessWidget {
  final int remainingSeconds;
  final double progress;
  final String timeText;

  const Level02TimerBar({
    super.key,
    required this.remainingSeconds,
    required this.progress,
    required this.timeText,
  });

  @override
  Widget build(BuildContext context) {
    final timeColor = remainingSeconds <= 20
        ? const Color(0xFFEF4444)
        : remainingSeconds <= 45
            ? const Color(0xFFFACC15)
            : const Color(0xFF34D399);

    const segments = 18;
    final filledSegments = (progress * segments).ceil().clamp(0, segments);

    return Row(
      children: [
        const Text(
          'TIME',
          style: TextStyle(
            fontFamily: 'monospace',
            color: Colors.white54,
            fontSize: 11,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Container(
            height: 16,
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: const Color(0xFF090F18),
              border: Border.all(color: const Color(0xFF33445E), width: 2),
            ),
            child: Row(
              children: List.generate(segments, (index) {
                final filled = index < filledSegments;
                return Expanded(
                  child: Container(
                    margin: EdgeInsets.only(right: index == segments - 1 ? 0 : 2),
                    decoration: BoxDecoration(
                      color: filled ? timeColor : const Color(0xFF182333),
                      border: filled
                          ? Border.all(color: timeColor, width: 1)
                          : null,
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
        const SizedBox(width: 10),
        SizedBox(
          width: 52,
          child: Text(
            timeText,
            textAlign: TextAlign.right,
            style: TextStyle(
              fontFamily: 'monospace',
              color: timeColor,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ],
    );
  }
}

void showLevel02GameOver(
  BuildContext context,
  Level02State state, {
  bool replaceWithLevel = false,
  VoidCallback? onRetry,
}) {
  showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (dialogContext) => AlertDialog(
      backgroundColor: const Color(0xFF080E17),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
        side: BorderSide(color: Color(0xFFEF4444), width: 2),
      ),
      title: const Text(
        'GAME OVER',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Color(0xFFEF4444),
          fontFamily: 'monospace',
          fontWeight: FontWeight.w900,
          letterSpacing: 2,
        ),
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        PixelButton(
          text: 'REINTENTAR',
          onPressed: () {
            Navigator.of(dialogContext).pop();
            state.reset();
            onRetry?.call();
            if (replaceWithLevel) {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => Level02Screen()),
                (route) => route.isFirst,
              );
            }
          },
        ),
      ],
    ),
  );
}

class _PixelBgPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()..isAntiAlias = false;
    p.color = const Color(0xFF070B12);
    canvas.drawRect(Offset.zero & size, p);
    p.color = const Color(0xFF0C1521);
    for (double y = 0; y < size.height; y += 32) {
      canvas.drawRect(Rect.fromLTWH(0, y, size.width, 16), p);
    }
    final grid = Paint()..color = const Color(0xFF101E2D)..strokeWidth = 1..isAntiAlias = false;
    for (double x = 0; x < size.width; x += 32) canvas.drawLine(Offset(x, 0), Offset(x, size.height), grid);
    for (double y = 0; y < size.height; y += 32) canvas.drawLine(Offset(0, y), Offset(size.width, y), grid);
    final scan = Paint()..color = const Color(0x182A9BC7)..isAntiAlias = false;
    for (double y = 18; y < size.height; y += 72) canvas.drawRect(Rect.fromLTWH(0, y, size.width, 2), scan);
  }
  @override
  bool shouldRepaint(covariant _PixelBgPainter oldDelegate) => false;
}
