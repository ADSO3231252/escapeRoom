import 'package:flutter/material.dart';

import 'config/app_config.dart';
import 'screens/loading_screen.dart';

void main() {
  runApp(const Nexus9App());
}

class Nexus9App extends StatelessWidget {
  const Nexus9App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: AppConfig.appName,
      theme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
      ),
      home: const LoadingScreen(),
    );
  }
}