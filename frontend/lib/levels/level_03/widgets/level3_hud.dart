import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../level3_controller.dart';
import '../level3_data.dart';
import '../level3_theme.dart';

/// Top-left status bar: collected cables, note status and elapsed time.
class Level3Hud extends StatelessWidget {
  const Level3Hud({super.key});

  @override
  Widget build(BuildContext context) {
    final c = context.watch<Level3Controller>();
    final noteColor =
        c.noteRead ? Level3Theme.neonGreen : Level3Theme.textSecondary;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Level3Theme.panelBackground.withValues(alpha: 0.88),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Level3Theme.neonBlue.withValues(alpha: 0.45),
          width: 1.5,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.cable, size: 16, color: Level3Theme.textSecondary),
          const SizedBox(width: 8),
          for (final cable in Level3Data.cables)
            _CableDot(
              color: Level3Theme.colorFromName(
                  Level3Data.cableColorNames[cable.id] ?? ''),
              filled: c.inventory.hasItem(cable.id),
            ),
          Text('${c.collectedCount}/3', style: Level3Theme.retro(size: 13)),
          const _HudDivider(),
          Icon(Icons.menu_book, size: 16, color: noteColor),
          const SizedBox(width: 6),
          Text(
            c.noteRead ? 'LEIDA' : '---',
            style: Level3Theme.retro(size: 12, color: noteColor),
          ),
          const _HudDivider(),
          const Icon(
            Icons.timer_outlined,
            size: 16,
            color: Level3Theme.textSecondary,
          ),
          const SizedBox(width: 6),
          Text(c.formattedTime, style: Level3Theme.retro(size: 13)),
        ],
      ),
    );
  }
}

class _CableDot extends StatelessWidget {
  const _CableDot({required this.color, required this.filled});

  final Color color;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 14,
      height: 14,
      margin: const EdgeInsets.only(right: 5),
      decoration: BoxDecoration(
        color: filled ? color : Colors.transparent,
        borderRadius: BorderRadius.circular(3),
        border: Border.all(color: color.withValues(alpha: 0.8), width: 1.5),
        boxShadow: filled
            ? [BoxShadow(color: color.withValues(alpha: 0.6), blurRadius: 6)]
            : null,
      ),
    );
  }
}

class _HudDivider extends StatelessWidget {
  const _HudDivider();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 16,
      margin: const EdgeInsets.symmetric(horizontal: 10),
      color: Level3Theme.textSecondary.withValues(alpha: 0.4),
    );
  }
}