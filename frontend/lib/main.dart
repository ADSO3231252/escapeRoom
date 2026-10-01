import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'config/app_config.dart';
import 'screens/loading_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // NEXUS-9 funciona únicamente en horizontal.
await SystemChrome.setPreferredOrientations([
  DeviceOrientation.landscapeLeft,
  DeviceOrientation.landscapeRight,
]);

  // Pantalla completa.
  await SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.immersiveSticky,
  );

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