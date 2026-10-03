import 'package:flutter/material.dart';
import '../models/game_models.dart';
import '../services/save_service.dart';
import '../widgets/neon_widgets.dart';
import 'level1_screen.dart';

class TutorialStep {
  final String title;
  final String body;
  final IconData icon;

  const TutorialStep(this.title, this.body, this.icon);
}

class TutorialScreen extends StatefulWidget {
  final GameState state;

  const TutorialScreen({super.key, required this.state});

  @override
  State<TutorialScreen> createState() => _TutorialScreenState();
}

class _TutorialScreenState extends State<TutorialScreen> {
  final SaveService save = SaveService();
  int index = 0;

  final steps = const [
    TutorialStep('PROTOCOLO DE INICIO', 'Eres Luna, una Jack Russell Terrier atrapada en el laboratorio secreto NEXUS-9. El sistema de emergencia se ha activado. Debes escapar.', Icons.pets),
    TutorialStep('MOVIMIENTO — WASD', 'Usa W, A, S y D para mover a Luna por el laboratorio. En computador también puedes usar Shift para correr.', Icons.keyboard),
    TutorialStep('EXPLORACIÓN 2D', 'Recorre el laboratorio desde una perspectiva central. Acércate a los elementos para descubrir cuáles son interactivos.', Icons.grid_view),
    TutorialStep('INTERACCIÓN — TECLA E', 'Acércate a un objeto hasta que aparezca el indicador de interacción. Luego usa E para interactuar.', Icons.key),
    TutorialStep('SISTEMA DE INVENTARIO', 'Los objetos que recojas aparecen en el inventario. La Llave 1 será necesaria para abrir la salida.', Icons.backpack),
    TutorialStep('TEMPORIZADOR', 'El tiempo corre desde el inicio de la misión. Según la dificultad tienes 90, 60 o 40 minutos.', Icons.timer),
    TutorialStep('OBJETIVO — SECTOR 1', 'Luna despierta en el laboratorio. Hay una cama, una computadora, una caja de seguridad y una puerta bloqueada. Consigue la Llave 1 y escapa.', Icons.lock),
    TutorialStep('TOUR COMPLETADO', 'HUD superior: tiempo y pistas. Centro: el laboratorio 2D. Inferior: inventario y controles. Tu misión comienza ahora, Luna.', Icons.check_circle),
  ];

  Future<void> next() async {
    if (index < steps.length - 1) {
      setState(() => index++);
      return;
    }
    widget.state.tutorialComplete = true;
    await save.save(widget.state);
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => Level1Screen(state: widget.state)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final step = steps[index];
    final progress = (index + 1) / steps.length;

    return ScanlineBackground(
      child: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 650),
            child: Padding(
              padding: const EdgeInsets.all(22),
              child: Column(
                children: [
                  Row(
                    children: [
                      const NeonText('TUTORIAL INTERACTIVO', size: 10),
                      const Spacer(),
                      NeonText('${index + 1} / ${steps.length}', size: 10, color: muted),
                    ],
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: progress,
                    minHeight: 3,
                    backgroundColor: panel2,
                    valueColor: const AlwaysStoppedAnimation(cyan),
                  ),
                  const Spacer(),
                  GlassPanel(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        Icon(step.icon, color: cyan, size: 54),
                        const SizedBox(height: 18),
                        NeonText(step.title, size: 17, align: TextAlign.center),
                        const SizedBox(height: 16),
                        Text(
                          step.body,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: whiteBlue,
                            fontSize: 12,
                            height: 1.7,
                          ),
                        ),
                        const SizedBox(height: 22),
                        SizedBox(
                          width: double.infinity,
                          child: NeonButton(
                            label: index == steps.length - 1 ? 'INICIAR NIVEL 1 →' : 'CONTINUAR →',
                            filled: true,
                            onPressed: next,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () async {
                      widget.state.tutorialComplete = true;
                      await save.save(widget.state);
                      if (!mounted) return;
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => Level1Screen(state: widget.state)),
                      );
                    },
                    child: const Text('saltar tutorial', style: TextStyle(color: muted, fontSize: 11)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
