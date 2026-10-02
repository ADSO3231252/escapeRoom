import 'package:flutter/material.dart';

/// Banner with the system message: "[SISTEMA] La sala está a oscuras..."
class SystemMessage extends StatelessWidget {
  const SystemMessage({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xF20B1220),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: const Color(0xFFCBD5E1), width: 2),
      ),
      child: Text.rich(
        TextSpan(
          style: const TextStyle(
            fontFamily: 'monospace',
            fontFamilyFallback: ['Courier'],
            fontSize: 13,
            color: Color(0xFFE2E8F0),
          ),
          children: [
            const TextSpan(
              text: '[SISTEMA] ',
              style: TextStyle(
                color: Color(0xFFFACC15),
                fontWeight: FontWeight.bold,
              ),
            ),
            TextSpan(text: text),
          ],
        ),
      ),
    );
  }
}

/// Label that blinks softly, for example "Toca la terminal".
class BlinkingHint extends StatefulWidget {
  const BlinkingHint({super.key, required this.text});

  final String text;

  @override
  State<BlinkingHint> createState() => _BlinkingHintState();
}

class _BlinkingHintState extends State<BlinkingHint>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 700),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: Tween<double>(begin: 0.35, end: 1).animate(_controller),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: const Color(0xFF111827),
          borderRadius: BorderRadius.circular(3),
          border: Border.all(color: const Color(0xFFFACC15), width: 2),
        ),
        child: Text(
          widget.text,
          style: const TextStyle(
            fontFamily: 'monospace',
            fontFamilyFallback: ['Courier'],
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: Color(0xFFFDE68A),
          ),
        ),
      ),
    );
  }
}
