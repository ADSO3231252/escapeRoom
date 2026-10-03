import 'package:flutter/material.dart';

import 'level3_screen.dart';
import 'level3_theme.dart';

/// Standalone entry point to test Level 3 in isolation, WITHOUT touching
/// the shared lib/main.dart or lib/screens/game_screen.dart.
///
/// Run it with:
///   flutter run -t lib/levels/level_03/level3_dev_main.dart
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const Level3DevApp());
}

class Level3DevApp extends StatelessWidget {
  const Level3DevApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'NEXUS-9 - Level 3 (Dev)',
      theme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
        scaffoldBackgroundColor: Level3Theme.background,
      ),
      home: const Level3Screen(),
    );
  }
}
