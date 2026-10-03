import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../level3_controller.dart';
import '../level3_data.dart';
import '../level3_theme.dart';
import 'neon_banner.dart';
import 'retro_button.dart';

/// Reset panel puzzle (HU-05, HU-06): collected cables appear in random
/// order in the tray; tap one to plug it into the next free socket, tap a
/// socket to unplug it, then press CONFIRMAR. Designed at a fixed size and
/// scaled down so it always fits the screen.
class ResetPanelOverlay extends StatelessWidget {
  const ResetPanelOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    final c = context.watch<Level3Controller>();
    final idle = c.panelStatus == Level3PanelStatus.idle;

    return Positioned.fill(
      child: Container(
        color: Colors.black.withValues(alpha: 0.72),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Center(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: SizedBox(
                  width: 680,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 250),
                        child: _statusBanner(c),
                      ),
                      const SizedBox(height: 16),
                      _ConsoleFrame(
                        child: _PanelScreen(controller: c),
                      ),
                      const SizedBox(height: 18),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          RetroButton(
                            label: 'ATRAS',
                            color: Level3Theme.textPrimary,
                            icon: Icons.arrow_back,
                            onPressed: idle ? c.closeOverlay : null,
                          ),
                          const SizedBox(width: 18),
                          RetroButton(
                            label: 'CONFIRMAR',
                            color: Level3Theme.neonGreen,
                            icon: Icons.power_settings_new,
                            filled: true,
                            onPressed: idle && c.allSlotsFilled
                                ? c.confirmSequence
                                : null,
                          ),
                        ],
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

  Widget _statusBanner(Level3Controller c) {
    switch (c.panelStatus) {
      case Level3PanelStatus.wrong:
        return const NeonBanner(
          key: ValueKey('wrong'),
          text: 'SECUENCIA INCORRECTA',
          color: Level3Theme.neonRed,
          icon: Icons.cancel,
          flicker: true,
          fontSize: 20,
        );
      case Level3PanelStatus.correct:
        return const NeonBanner(
          key: ValueKey('correct'),
          text: 'CORRECTO',
          color: Level3Theme.neonGreen,
          icon: Icons.check_circle,
          fontSize: 22,
        );
      case Level3PanelStatus.idle:
        if (c.collectedCount < 3) {
          return NeonBanner(
            key: ValueKey('missing_${c.collectedCount}'),
            text: 'FALTAN CABLES: ${c.collectedCount}/3',
            color: Level3Theme.amber,
            icon: Icons.warning_amber_rounded,
            fontSize: 18,
          );
        }
        return const NeonBanner(
          key: ValueKey('idle'),
          text: 'CONECTA LOS CABLES EN ORDEN',
          color: Level3Theme.neonBlue,
          icon: Icons.cable,
          fontSize: 18,
        );
    }
  }
}

/// Metal console frame with screws and side vents, like the mockup.
class _ConsoleFrame extends StatelessWidget {
  const _ConsoleFrame({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF2C4560), Color(0xFF1A2C40)],
        ),
        border: Border.all(color: const Color(0xFF4A6A8A), width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.5),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const _Vents(),
              const SizedBox(width: 16),
              child,
              const SizedBox(width: 16),
              const _Vents(),
            ],
          ),
          const Positioned(top: -14, left: -14, child: _Screw()),
          const Positioned(top: -14, right: -14, child: _Screw()),
          const Positioned(bottom: -14, left: -14, child: _Screw()),
          const Positioned(bottom: -14, right: -14, child: _Screw()),
        ],
      ),
    );
  }
}

class _Vents extends StatelessWidget {
  const _Vents();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        6,
        (_) => Container(
          width: 24,
          height: 6,
          margin: const EdgeInsets.symmetric(vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFF0B1724),
            borderRadius: BorderRadius.circular(3),
          ),
        ),
      ),
    );
  }
}

class _Screw extends StatelessWidget {
  const _Screw();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 12,
      height: 12,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xFF6F8BA7),
        border: Border.all(color: const Color(0xFF243A50), width: 2),
      ),
    );
  }
}

/// Inner neon screen: sockets on top, collected-cable tray below.
class _PanelScreen extends StatelessWidget {
  const _PanelScreen({required this.controller});

  final Level3Controller controller;

  @override
  Widget build(BuildContext context) {
    final c = controller;
    final correct = c.panelStatus == Level3PanelStatus.correct;
    final accent = correct ? Level3Theme.neonGreen : Level3Theme.neonBlue;

    return Container(
      width: 500,
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
      decoration: BoxDecoration(
        color: const Color(0xFF06121D),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: accent.withValues(alpha: 0.85), width: 2),
        boxShadow: [
          BoxShadow(color: accent.withValues(alpha: 0.3), blurRadius: 16),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'RESET',
            style: Level3Theme.retro(
              size: 24,
              color: accent,
              weight: FontWeight.bold,
              spacing: 8,
              glow: true,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(3, (index) {
              return _Socket(
                index: index,
                cableId: c.slotCableIds[index],
                onTap: () => c.tapSlot(index),
              );
            }),
          ),
          const SizedBox(height: 10),
          Container(
            height: 1,
            color: Level3Theme.textSecondary.withValues(alpha: 0.3),
          ),
          const SizedBox(height: 10),
          Text(
            'CABLES RECOGIDOS',
            style: Level3Theme.retro(
              size: 12,
              color: Level3Theme.textSecondary,
              spacing: 3,
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 84,
            child: c.trayCableIds.isEmpty
                ? Center(
                    child: Text(
                      c.allSlotsFilled ? 'LISTO PARA CONFIRMAR' : 'SIN CABLES',
                      style: Level3Theme.retro(
                        size: 13,
                        color: c.allSlotsFilled
                            ? Level3Theme.neonGreen
                            : Level3Theme.textSecondary,
                        spacing: 2,
                      ),
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: c.trayCableIds.map((id) {
                      return _TrayCable(
                        cableId: id,
                        onTap: () => c.tapTray(id),
                      );
                    }).toList(),
                  ),
          ),
        ],
      ),
    );
  }
}

Color _colorOf(int cableId) =>
    Level3Theme.colorFromName(Level3Data.cableColorNames[cableId] ?? '');

String _labelOf(int cableId) {
  final matches = Level3Data.cables.where((c) => c.id == cableId);
  return matches.isEmpty ? '' : matches.first.name;
}

class _Socket extends StatelessWidget {
  const _Socket({
    required this.index,
    required this.cableId,
    required this.onTap,
  });

  final int index;
  final int cableId;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final filled = cableId != -1;
    final color = filled ? _colorOf(cableId) : Level3Theme.textSecondary;

    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 120,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${index + 1}',
              style: Level3Theme.retro(
                size: 13,
                color: Level3Theme.textSecondary,
              ),
            ),
            const SizedBox(height: 6),
            Container(
              width: 76,
              height: 62,
              decoration: BoxDecoration(
                color: const Color(0xFF0A1824),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: filled ? color : color.withValues(alpha: 0.5),
                  width: 2,
                ),
                boxShadow: filled
                    ? [
                        BoxShadow(
                          color: color.withValues(alpha: 0.5),
                          blurRadius: 12,
                        ),
                      ]
                    : null,
              ),
              child: Center(
                child: filled
                    ? _PlugHead(color: color)
                    : Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _hole(),
                          const SizedBox(width: 14),
                          _hole(),
                        ],
                      ),
              ),
            ),
            // Cable hanging from the socket, like the mockup.
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 8,
              height: 30,
              decoration: BoxDecoration(
                color: filled ? color : Colors.transparent,
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(4),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _hole() => Container(
        width: 8,
        height: 20,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(2),
        ),
      );
}

class _PlugHead extends StatelessWidget {
  const _PlugHead({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 46,
      height: 36,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color.lerp(color, Colors.white, 0.35)!, color],
        ),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.3),
          width: 1.5,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _prong(),
          const SizedBox(width: 10),
          _prong(),
        ],
      ),
    );
  }

  Widget _prong() => Container(
        width: 6,
        height: 14,
        decoration: BoxDecoration(
          color: const Color(0xFFE6EEF5),
          borderRadius: BorderRadius.circular(1),
        ),
      );
}

class _TrayCable extends StatelessWidget {
  const _TrayCable({required this.cableId, required this.onTap});

  final int cableId;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = _colorOf(cableId);

    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                boxShadow: [
                  BoxShadow(
                    color: color.withValues(alpha: 0.55),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: _PlugHead(color: color),
            ),
            Container(width: 6, height: 14, color: color),
            const SizedBox(height: 4),
            Text(
              _labelOf(cableId),
              style: Level3Theme.retro(
                size: 11,
                color: color,
                weight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
