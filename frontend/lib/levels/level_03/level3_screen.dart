import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'level3_controller.dart';
import 'level3_theme.dart';
import 'widgets/joystick_widget.dart';
import 'widgets/level3_completion_card.dart';
import 'widgets/level3_hud.dart';
import 'widgets/level3_welcome_widget.dart';
import 'widgets/reset_panel_overlay.dart';
import 'widgets/riddle_note_overlay.dart';
import 'widgets/scanline_overlay.dart';
import 'widgets/server_room_widget.dart';

/// Entry point widget for Level 3 — "The Servers".
///
/// Self-contained: creates and owns its own [Level3Controller], locks the
/// screen to landscape and hides the system bars while it is on screen,
/// and restores both when it is removed. Can be used as the `home` of the
/// standalone test app (level3_dev_main.dart) or returned from the shared
/// GameScreen when levelId == 3 (see INTEGRATION_game_screen.dart).
class Level3Screen extends StatefulWidget {
  const Level3Screen({super.key});

  @override
  State<Level3Screen> createState() => _Level3ScreenState();
}

class _Level3ScreenState extends State<Level3Screen> {
  late final Level3Controller _controller;

  @override
  void initState() {
    super.initState();
    _controller = Level3Controller()..init();
    // Phone-only settings (skipped when testing in Chrome).
    if (!kIsWeb) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    if (!kIsWeb) {
      SystemChrome.setPreferredOrientations(DeviceOrientation.values);
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _controller,
      child: Scaffold(
        backgroundColor: Level3Theme.background,
        body: Consumer<Level3Controller>(
          builder: (context, c, _) {
            final content = c.phase == Level3Phase.welcome
                ? Level3WelcomeWidget(
                    onStart: () => c.startGame(),
                    savedCompleted: c.savedCompleted,
                  )
                : const _PlayingLayer();

            return Stack(
              children: [
                Positioned.fill(child: SafeArea(child: content)),
                const Positioned.fill(child: ScanlineOverlay()),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _PlayingLayer extends StatelessWidget {
  const _PlayingLayer();

  @override
  Widget build(BuildContext context) {
    final c = context.watch<Level3Controller>();
    final free =
        c.phase == Level3Phase.playing && c.overlay == Level3Overlay.none;
    final target = c.nearbyInteractableId;

    return Stack(
      children: [
        const Positioned.fill(child: ServerRoomWidget()),
        const Positioned(top: 10, left: 12, child: Level3Hud()),
        Positioned(
          left: 0,
          right: 0,
          bottom: 18,
          child: Center(child: _Toast(controller: c)),
        ),
        if (free)
          Positioned(
            left: 18,
            bottom: 18,
            child: JoystickWidget(onChanged: c.setJoystickVector),
          ),
        if (free && target != null)
          Positioned(
            right: 22,
            bottom: 22,
            child: _ActionButton(targetId: target, onTap: c.interact),
          ),
        if (c.overlay == Level3Overlay.note) const RiddleNoteOverlay(),
        if (c.overlay == Level3Overlay.panel) const ResetPanelOverlay(),
        if (c.phase == Level3Phase.completed) const Level3CompletionCard(),
      ],
    );
  }
}

/// Short real-time message at the bottom of the screen.
class _Toast extends StatelessWidget {
  const _Toast({required this.controller});

  final Level3Controller controller;

  @override
  Widget build(BuildContext context) {
    final message = controller.toastMessage;
    final color = controller.toastColor;

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 250),
      transitionBuilder: (child, animation) => FadeTransition(
        opacity: animation,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 0.4),
            end: Offset.zero,
          ).animate(animation),
          child: child,
        ),
      ),
      child: message == null
          ? const SizedBox.shrink(key: ValueKey('no_toast'))
          : ConstrainedBox(
              key: ValueKey(controller.toastId),
              constraints: const BoxConstraints(maxWidth: 420),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xE60A1622),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: color, width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: color.withValues(alpha: 0.4),
                      blurRadius: 12,
                    ),
                  ],
                ),
                child: Text(
                  message,
                  textAlign: TextAlign.center,
                  style: Level3Theme.retro(
                    size: 13,
                    color: color,
                    weight: FontWeight.bold,
                    spacing: 1.5,
                  ),
                ),
              ),
            ),
    );
  }
}

/// Round contextual button: RECOGER / ABRIR / USAR.
class _ActionButton extends StatelessWidget {
  const _ActionButton({required this.targetId, required this.onTap});

  final String targetId;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final IconData icon;
    final String label;
    if (targetId == 'note') {
      icon = Icons.menu_book;
      label = 'ABRIR';
    } else if (targetId == 'panel') {
      icon = Icons.settings_input_antenna;
      label = 'USAR';
    } else {
      icon = Icons.pan_tool;
      label = 'RECOGER';
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 92,
        height: 92,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [
              Level3Theme.neonBlue.withValues(alpha: 0.35),
              Level3Theme.panelBackground.withValues(alpha: 0.92),
            ],
          ),
          border: Border.all(color: Level3Theme.neonBlue, width: 2.5),
          boxShadow: [
            BoxShadow(
              color: Level3Theme.neonBlue.withValues(alpha: 0.55),
              blurRadius: 18,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Level3Theme.neonBlue, size: 28),
            const SizedBox(height: 4),
            Text(
              label,
              style: Level3Theme.retro(size: 11, weight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
