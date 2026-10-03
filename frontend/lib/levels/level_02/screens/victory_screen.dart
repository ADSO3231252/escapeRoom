import 'package:flutter/material.dart';
import '../models/level_02_state.dart';
import 'level_02_screen.dart';
import '../widgets/pixel_ui.dart';

class VictoryScreen extends StatelessWidget {
  final Level02State state;
  const VictoryScreen({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return PixelBackground(
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 650),
            child: PixelPanel(
              padding: const EdgeInsets.all(30),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                const Text('★ ★ ★', style: TextStyle(fontFamily: 'monospace', color: Color(0xFFFACC15), fontSize: 22, letterSpacing: 7)),
                const SizedBox(height: 16),
                const PixelTitle(text: 'KEY 2 DISPONIBLE', subtitle: 'VUELVE A LA SALA Y CÓGELA DE LA MESA'),
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(color: const Color(0xFF0A1620), border: Border.all(color: const Color(0xFF34D399), width: 2)),
                  child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Text('[ KEY 2 // TABLE ]', style: TextStyle(fontFamily: 'monospace', color: Color(0xFFFACC15), fontSize: 22, fontWeight: FontWeight.w900, letterSpacing: 2)),
                  ]),
                ),
                const SizedBox(height: 18),
                Text('SCORE ${state.score}', style: const TextStyle(fontFamily: 'monospace', color: Color(0xFF7DD3FC), fontWeight: FontWeight.w900, letterSpacing: 2)),
                const SizedBox(height: 26),
                PixelButton(text: 'VOLVER AL CONTROL ROOM', onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => Level02Screen.withState(state: state)))),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
