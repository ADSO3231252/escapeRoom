import 'package:flutter/material.dart';

import 'game_screen.dart';

class LevelSelectScreen extends StatelessWidget {
  const LevelSelectScreen({super.key});

  void _openLevel(BuildContext context, int levelId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GameScreen(
          levelId: levelId,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Selección de nivel'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'SELECCIONA UN NIVEL',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 30),

            ElevatedButton(
              onPressed: () => _openLevel(context, 1),
              child: const Text('NIVEL 1 — LABORATORY'),
            ),

            const SizedBox(height: 15),

            ElevatedButton(
              onPressed: () => _openLevel(context, 2),
              child: const Text('NIVEL 2 — CONTROL ROOM'),
            ),

            const SizedBox(height: 15),

            ElevatedButton(
              onPressed: () => _openLevel(context, 3),
              child: const Text('NIVEL 3 — NEXUS-9 CORE'),
            ),
          ],
        ),
      ),
    );
  }
}