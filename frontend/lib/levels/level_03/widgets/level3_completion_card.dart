import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../level3_controller.dart';
import '../level3_theme.dart';
import 'retro_button.dart';
import '../../level_04/level_04_screen.dart';

/// Shown on top of the restored room once the level is completed:
/// reward, stats, a replay button and a continue button.
class Level3CompletionCard extends StatelessWidget {
  const Level3CompletionCard({super.key});

  @override
  Widget build(BuildContext context) {
    final c = context.watch<Level3Controller>();

    return Positioned.fill(
      child: Container(
        color: Colors.black.withValues(alpha: 0.55),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Center(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Container(
                  width: 580,
                  padding: const EdgeInsets.all(28),
                  decoration: BoxDecoration(
                    color: const Color(0xF0081522),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Level3Theme.neonGreen,
                      width: 2.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Level3Theme.neonGreen.withValues(alpha: 0.45),
                        blurRadius: 30,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 84,
                        height: 84,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Level3Theme.gold.withValues(alpha: 0.12),
                          border: Border.all(color: Level3Theme.gold, width: 3),
                          boxShadow: [
                            BoxShadow(
                              color: Level3Theme.gold.withValues(alpha: 0.55),
                              blurRadius: 22,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.vpn_key,
                          color: Level3Theme.gold,
                          size: 40,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'NIVEL 3 COMPLETADO',
                        textAlign: TextAlign.center,
                        style: Level3Theme.retro(
                          size: 28,
                          color: Level3Theme.neonGreen,
                          weight: FontWeight.bold,
                          spacing: 3,
                          glow: true,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'LLAVE 3 OBTENIDA',
                        style: Level3Theme.retro(
                          size: 16,
                          color: Level3Theme.gold,
                          spacing: 4,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _Stat(label: 'TIEMPO', value: c.formattedTime),
                          const SizedBox(width: 18),
                          _Stat(label: 'FALLOS', value: '${c.wrongAttempts}'),
                          const SizedBox(width: 18),
                          const _Stat(label: 'PROGRESO', value: 'GUARDADO'),
                        ],
                      ),
                      const SizedBox(height: 18),
                      Text(
                        'La puerta hacia el Nivel 4 ya esta abierta.',
                        textAlign: TextAlign.center,
                        style: Level3Theme.retro(
                          size: 12,
                          color: Level3Theme.textSecondary,
                          height: 1.5,
                          weight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          RetroButton(
                            label: 'JUGAR DE NUEVO',
                            color: Level3Theme.neonBlue,
                            icon: Icons.replay,
                            onPressed: () => c.playAgain(),
                          ),
                          const SizedBox(width: 16),
                          RetroButton(
                            label: 'CONTINUAR',
                            color: Level3Theme.neonGreen,
                            icon: Icons.arrow_forward,
                            filled: true,
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const Level04Screen(),
                                ),
                              );
                            },
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
}

class _Stat extends StatelessWidget {
  const _Stat({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Level3Theme.panelBackground.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Level3Theme.neonBlue.withValues(alpha: 0.4)),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: Level3Theme.retro(
              size: 11,
              color: Level3Theme.textSecondary,
              spacing: 2,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: Level3Theme.retro(size: 18, weight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
