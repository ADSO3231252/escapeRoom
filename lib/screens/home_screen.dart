import 'package:flutter/material.dart';
import '../models/game_models.dart';
import '../services/save_service.dart';
import '../widgets/neon_widgets.dart';
import 'tutorial_screen.dart';
import 'level1_screen.dart';

class HomeScreen extends StatefulWidget {
  final GameState? restoredState;

  const HomeScreen({super.key, this.restoredState});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Difficulty selected = Difficulty.normal;
  final SaveService save = SaveService();

  @override
  void initState() {
    super.initState();
    if (widget.restoredState != null) {
      selected = widget.restoredState!.difficulty;
    }
  }

  Future<void> start() async {
    final state = GameState(difficulty: selected);
    await save.save(state);
    if (!mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => TutorialScreen(state: state)),
    );
  }

  Future<void> continueGame() async {
    final state = await save.load();
    if (!mounted) return;
    if (state == null) {
      start();
      return;
    }

    if (state.level1Complete) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => Level1Screen(state: state)),
      );
    } else if (state.tutorialComplete) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => Level1Screen(state: state)),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => TutorialScreen(state: state)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScanlineBackground(
      child: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const SizedBox(height: 25),
                  const NeonText('PROTOCOLO DE EMERGENCIA ACTIVADO', size: 10),
                  const SizedBox(height: 8),
                  const NeonText('NEXUS-9', size: 44, weight: FontWeight.w800),
                  const NeonText('PROYECTO K-9', size: 14, color: whiteBlue),
                  const SizedBox(height: 4),
                  const NeonText('ESCAPE ROOM • NIVEL 1: EL DESPERTAR', size: 10, color: muted),
                  const SizedBox(height: 35),
                  GlassPanel(
                    child: Column(
                      children: const [
                        NeonText(
                          '"PROTOCOLO DE EMERGENCIA ACTIVADO. TODAS LAS SALIDAS HAN SIDO BLOQUEADAS. PARA ESCAPAR, DEBES COMPLETAR LOS 6 SECTORES DEL LABORATORIO."',
                          size: 11,
                          color: whiteBlue,
                          align: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),
                  const NeonText('SELECCIONA DIFICULTAD', size: 11, color: muted),
                  const SizedBox(height: 12),
                  ...Difficulty.values.map(_difficultyCard),
                  const SizedBox(height: 15),
                  SizedBox(
                    width: double.infinity,
                    child: NeonButton(
                      label: 'INICIAR MISIÓN →',
                      icon: Icons.play_arrow,
                      filled: true,
                      onPressed: start,
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: NeonButton(
                      label: 'CONTINUAR PARTIDA',
                      icon: Icons.restore,
                      onPressed: continueGame,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const NeonText(
                    'La dificultad modifica el tiempo y las pistas. La historia mantiene el mismo orden.',
                    size: 9,
                    color: muted,
                    align: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _difficultyCard(Difficulty d) {
    final active = selected == d;
    return GestureDetector(
      onTap: () => setState(() => selected = d),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
        decoration: BoxDecoration(
          color: active ? cyan.withOpacity(.08) : panel.withOpacity(.82),
          border: Border.all(
            color: active ? cyan : cyan.withOpacity(.18),
          ),
          boxShadow: active
              ? [BoxShadow(color: cyan.withOpacity(.13), blurRadius: 16)]
              : [],
        ),
        child: Row(
          children: [
            Icon(
              active ? Icons.radio_button_checked : Icons.radio_button_unchecked,
              color: active ? cyan : muted,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: NeonText(
                d.label,
                size: 14,
                color: active ? cyan : whiteBlue,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                NeonText('${d.minutes} min', size: 12, color: whiteBlue),
                NeonText(d.hintsLabel, size: 9, color: muted),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
