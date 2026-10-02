import 'package:flutter/material.dart';

import '../models/level_02_state.dart';
import 'puzzle_2_screen.dart';

/// Puzzle 1 is the three-door challenge in Level02Screen.
/// This screen remains only as a compatibility fallback for existing imports.
class Puzzle1Screen extends StatelessWidget {
  final Level02State state;

  const Puzzle1Screen({
    super.key,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF080A0F),
      appBar: AppBar(
        title: const Text('LEVEL 02 / PUZZLE 1'),
        backgroundColor: const Color(0xFF0D1118),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 620),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Container(
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                color: const Color(0xFF0B111B),
                border: Border.all(
                  color: const Color(0xFF33445E),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.door_front_door_outlined,
                    size: 58,
                    color: Color(0xFF55D6FF),
                  ),
                  const SizedBox(height: 18),
                  const Text(
                    'PUZZLE 1 — LAS PUERTAS',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'La puerta correcta es la que tiene la luz encendida.\n\n'
                    'Luna debe entrar por ella para continuar.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white70,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 22),
                  FilledButton.icon(
                    onPressed: state.puzzle1Solved
                        ? () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) => Puzzle2Screen(
                                  state: state,
                                ),
                              ),
                            );
                          }
                        : null,
                    icon: const Icon(Icons.arrow_forward),
                    label: const Text('CONTINUAR AL PUZZLE 2'),
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