import 'package:flutter/material.dart';
import 'models/game_models.dart';
import 'screens/home_screen.dart';
import 'services/save_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final save = SaveService();
  final restored = await save.load();

  runApp(Nexus9App(restoredState: restored));
}

class Nexus9App extends StatelessWidget {
  final GameState? restoredState;

  const Nexus9App({super.key, this.restoredState});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'NEXUS-9 — Nivel 1',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF030B14),
        fontFamily: 'monospace',
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF00D9FF),
          brightness: Brightness.dark,
        ),
      ),
      home: HomeScreen(restoredState: restoredState),
    );
  }
}
