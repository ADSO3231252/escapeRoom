import 'package:flutter/material.dart';

class GameScreen extends StatelessWidget {
  final int levelId;

  const GameScreen({
    super.key,
    required this.levelId,
  });

  String get levelName {
    switch (levelId) {
      case 1:
        return 'LABORATORY';

      case 2:
        return 'CONTROL ROOM';

      case 3:
        return 'NEXUS-9 CORE';

      default:
        return 'UNKNOWN LEVEL';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nivel $levelId — $levelName'),
      ),
      body: Center(
        child: Text(
          'NIVEL $levelId\n\n$levelName',
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}