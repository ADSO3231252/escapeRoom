import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../level3_controller.dart';
import '../level3_theme.dart';
import 'luna_painter.dart';
import 'neon_banner.dart';
import 'room_painter.dart';

/// The playable room. Everything is drawn on a fixed 1600x760 logical
/// canvas and scaled with [FittedBox] to fit any phone in landscape,
/// without ever overflowing.
class ServerRoomWidget extends StatefulWidget {
  const ServerRoomWidget({super.key});

  @override
  State<ServerRoomWidget> createState() => _ServerRoomWidgetState();
}

class _ServerRoomWidgetState extends State<ServerRoomWidget>
    with TickerProviderStateMixin {
  late final AnimationController _clock = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 10),
  )..repeat();

  late final AnimationController _door = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1600),
  );

  bool _doorTriggered = false;

  @override
  void dispose() {
    _clock.dispose();
    _door.dispose();
    super.dispose();
  }

  void _syncDoor(bool restored) {
    if (restored && !_doorTriggered) {
      _doorTriggered = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _door.forward(from: 0);
      });
    } else if (!restored && _doorTriggered) {
      _doorTriggered = false;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _door.value = 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = context.watch<Level3Controller>();
    _syncDoor(c.systemRestored);

    final collected = c.collectedCableIds;

    return Container(
      color: Level3Theme.background,
      child: Center(
        child: FittedBox(
          fit: BoxFit.contain,
          child: SizedBox(
            width: Level3Controller.roomWidth,
            height: Level3Controller.roomHeight,
            child: Stack(
              clipBehavior: Clip.hardEdge,
              children: [
                Positioned.fill(
                  child: CustomPaint(
                    painter: RoomPainter(
                      clock: _clock,
                      door: _door,
                      alarmStrong: c.alarmBannerExpanded,
                      restored: c.systemRestored,
                      panelReady: c.allCablesFound,
                      noteRead: c.noteRead,
                      cablePositions: c.cablePositions,
                      revealedCables: c.revealedCables,
                      collectedCables: collected,
                    ),
                  ),
                ),
                Positioned(
                  left: c.lunaPosition.dx - 48,
                  top: c.lunaPosition.dy - 48,
                  child: SizedBox(
                    width: 96,
                    height: 96,
                    child: CustomPaint(
                      painter: LunaPainter(
                        angle: c.lunaAngle,
                        walkPhase: c.walkPhase,
                        moving: c.isMoving,
                        clock: _clock,
                      ),
                    ),
                  ),
                ),
                Positioned.fill(
                  child: CustomPaint(
                    painter: RoomTopPainter(
                      clock: _clock,
                      restored: c.systemRestored,
                      cablePositions: c.cablePositions,
                      revealedCables: c.revealedCables,
                      collectedCables: collected,
                      indicator: c.indicatorPosition,
                    ),
                  ),
                ),
                Positioned(
                  top: 14,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 450),
                      transitionBuilder: (child, animation) => FadeTransition(
                        opacity: animation,
                        child: ScaleTransition(scale: animation, child: child),
                      ),
                      child: _buildBanner(c),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBanner(Level3Controller c) {
    if (c.systemRestored) {
      return const NeonBanner(
        key: ValueKey('restored'),
        text: 'SISTEMA RESTAURADO',
        color: Level3Theme.neonGreen,
        icon: Icons.check_circle,
        fontSize: 34,
      );
    }
    if (c.alarmBannerExpanded) {
      return const NeonBanner(
        key: ValueKey('alarm'),
        text: 'ERROR 404 - CONEXION DEL\nSERVIDOR INTERRUMPIDA',
        color: Level3Theme.neonRed,
        icon: Icons.warning_amber_rounded,
        flicker: true,
        fontSize: 30,
      );
    }
    return const NeonBanner(
      key: ValueKey('offline'),
      text: 'SERVIDOR OFFLINE',
      color: Level3Theme.neonRed,
      icon: Icons.wifi_off,
      fontSize: 20,
    );
  }
}
