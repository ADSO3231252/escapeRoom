import 'package:flutter/material.dart';

import '../logic/puzzle_2_logic.dart';

class ConditionRow extends StatelessWidget {
  final ConditionColor color;
  final bool selected;
  final bool? result;
  final VoidCallback onTap;

  const ConditionRow({
    super.key,
    required this.color,
    required this.selected,
    required this.result,
    required this.onTap,
  });

  Color get accent {
    switch (color) {
      case ConditionColor.red:
        return const Color(0xFFEF4444);
      case ConditionColor.blue:
        return const Color(0xFF38BDF8);
      case ConditionColor.green:
        return const Color(0xFF34D399);
    }
  }

  @override
  Widget build(BuildContext context) {
    final expression = Puzzle2Logic.expressions[color]!;
    return InkWell(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: selected ? accent.withOpacity(.12) : const Color(0xFF171B23),
          border: Border.all(
            color: selected ? accent : const Color(0xFF353B48),
            width: selected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: accent,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(color: accent.withOpacity(.55), blurRadius: 8),
                ],
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                '${Puzzle2Logic.label(color)}:  $expression',
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1,
                ),
              ),
            ),
            if (result != null)
              Icon(
                result! ? Icons.check_circle : Icons.cancel,
                color: result! ? const Color(0xFF34D399) : const Color(0xFFEF4444),
              ),
          ],
        ),
      ),
    );
  }
}
