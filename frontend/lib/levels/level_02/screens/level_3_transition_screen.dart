import 'package:flutter/material.dart';

import '../../level_03/level3_screen.dart';
import '../widgets/pixel_ui.dart';

class Level3TransitionScreen extends StatelessWidget {
  const Level3TransitionScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return PixelBackground(
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 680),
            child: PixelPanel(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'NIVEL 3',
                    style: TextStyle(
                      fontFamily: 'monospace',
                      color: Color(0xFF9FE7FF),
                      fontSize: 42,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 5,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const PixelTitle(text: 'THE TIME LABYRINTH'),
                  const SizedBox(height: 24),
                  Container(
                    height: 12,
                    decoration: BoxDecoration(
                      color: const Color(0xFF101C28),
                      border: Border.all(
                        color: const Color(0xFF38546C),
                        width: 2,
                      ),
                    ),
                    child: const Align(
                      alignment: Alignment.centerLeft,
                      child: FractionallySizedBox(
                        widthFactor: 1,
                        child: ColoredBox(color: Color(0xFF34D399)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 22),
                  const Text(
                    'NIVEL 3 DESBLOQUEADO',
                    style: TextStyle(
                      fontFamily: 'monospace',
                      color: Color(0xFF34D399),
                      fontWeight: FontWeight.w900,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 28),
                  PixelButton(
                    text: 'INICIAR NIVEL 3',
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const Level3Screen()),
                      );
                    },
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
