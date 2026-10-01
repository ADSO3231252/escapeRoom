import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'dark_room.dart';

/// Entry screen of Level 4 - La Terminal Cifrada.
///
/// For now it only shows the dark room (view 1). The terminal view
/// will be opened from [DarkRoom.onTerminalTap] when it is ready.
class Level04Screen extends StatefulWidget {
  const Level04Screen({super.key});

  @override
  State<Level04Screen> createState() => _Level04ScreenState();
}

class _Level04ScreenState extends State<Level04Screen> {
  @override
  void initState() {
    super.initState();
    // The level is played in landscape.
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  @override
  void dispose() {
    // Give the orientation back to the rest of the app.
    SystemChrome.setPreferredOrientations(DeviceOrientation.values);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF050D1C),
      body: SafeArea(
        child: DarkRoom(
          onTerminalTap: () => ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Abriendo terminal...')),
          ),
        ),
      ),
    );
  }
}
