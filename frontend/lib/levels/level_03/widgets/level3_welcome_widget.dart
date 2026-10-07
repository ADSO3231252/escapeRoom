import 'package:flutter/material.dart';

import '../level3_data.dart';
import '../level3_theme.dart';
import 'retro_button.dart';

/// First screen of Level 3: title, short story, the 3 objectives, controls
/// hint and a pulsing start button. Designed at a fixed size and scaled
/// down to fit any landscape screen.
class Level3WelcomeWidget extends StatelessWidget {
  const Level3WelcomeWidget({
    super.key,
    required this.onStart,
    this.savedCompleted = false,
  });

  final VoidCallback onStart;
  final bool savedCompleted;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(child: CustomPaint(painter: _GridPainter())),
        Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: SizedBox(
                width: 780,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Level3Theme.neonBlue.withValues(alpha: 0.6),
                        ),
                      ),
                      child: Text(
                        'NEXUS-9  //  SECTOR 3',
                        style: Level3Theme.retro(
                          size: 13,
                          color: Level3Theme.neonBlue,
                          spacing: 4,
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    Text(
                      'NIVEL 3',
                      style: Level3Theme.retro(
                        size: 20,
                        color: Level3Theme.textSecondary,
                        spacing: 10,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'LOS SERVIDORES',
                      textAlign: TextAlign.center,
                      style: Level3Theme.retro(
                        size: 54,
                        color: Level3Theme.neonBlue,
                        weight: FontWeight.bold,
                        spacing: 6,
                        glow: true,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      width: 340,
                      height: 3,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.transparent,
                            Level3Theme.neonBlue,
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: 640,
                      child: Text(
                        Level3Data.welcomeDescription,
                        textAlign: TextAlign.center,
                        style: Level3Theme.retro(
                          size: 16,
                          spacing: 0.5,
                          height: 1.5,
                          weight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(height: 22),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _ObjectiveCard(
                          icon: Icons.cable,
                          title: '1. EXPLORA',
                          text: 'Encuentra los 3 cables ocultos en la sala',
                        ),
                        SizedBox(width: 16),
                        _ObjectiveCard(
                          icon: Icons.menu_book,
                          title: '2. DESCIFRA',
                          text: 'Lee la nota y deduce el orden correcto',
                        ),
                        SizedBox(width: 16),
                        _ObjectiveCard(
                          icon: Icons.settings_input_antenna,
                          title: '3. RESTAURA',
                          text: 'Conecta los cables en el panel de reinicio',
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.gamepad,
                          color: Level3Theme.textSecondary,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Joystick para moverte  ·  Boton de accion para interactuar',
                          style: Level3Theme.retro(
                            size: 13,
                            color: Level3Theme.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    if (savedCompleted) ...[
                      const SizedBox(height: 12),
                      Text(
                        'Ya completaste este nivel. Al comenzar se reinicia el progreso.',
                        style: Level3Theme.retro(
                          size: 13,
                          color: Level3Theme.amber,
                        ),
                      ),
                    ],
                    const SizedBox(height: 24),
                    _PulsingStartButton(onStart: onStart),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ObjectiveCard extends StatelessWidget {
  const _ObjectiveCard({
    required this.icon,
    required this.title,
    required this.text,
  });

  final IconData icon;
  final String title;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Level3Theme.panelBackground.withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Level3Theme.neonBlue.withValues(alpha: 0.45),
          width: 1.5,
        ),
      ),
      child: Column(
        children: [
          Icon(icon, color: Level3Theme.neonBlue, size: 32),
          const SizedBox(height: 8),
          Text(
            title,
            style: Level3Theme.retro(
              size: 14,
              weight: FontWeight.bold,
              spacing: 2,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            text,
            textAlign: TextAlign.center,
            style: Level3Theme.retro(
              size: 12,
              color: Level3Theme.textSecondary,
              height: 1.35,
              weight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _PulsingStartButton extends StatefulWidget {
  const _PulsingStartButton({required this.onStart});

  final VoidCallback onStart;

  @override
  State<_PulsingStartButton> createState() => _PulsingStartButtonState();
}

class _PulsingStartButtonState extends State<_PulsingStartButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) => Transform.scale(
        scale: 1 + _controller.value * 0.05,
        child: child,
      ),
      child: RetroButton(
        label: 'COMENZAR',
        color: Level3Theme.neonBlue,
        icon: Icons.play_arrow,
        filled: true,
        fontSize: 20,
        onPressed: widget.onStart,
      ),
    );
  }
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    canvas.drawRect(
      rect,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF0B1C2E), Color(0xFF050B12)],
        ).createShader(rect),
    );

    final grid = Paint()
      ..color = Level3Theme.neonBlue.withValues(alpha: 0.06)
      ..strokeWidth = 1;
    for (double x = 0; x < size.width; x += 40) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), grid);
    }
    for (double y = 0; y < size.height; y += 40) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), grid);
    }

    final glowRect = Rect.fromCircle(
      center: Offset(size.width / 2, size.height * 0.35),
      radius: size.width * 0.45,
    );
    canvas.drawRect(
      rect,
      Paint()
        ..shader = RadialGradient(
          colors: [
            Level3Theme.neonBlue.withValues(alpha: 0.10),
            Colors.transparent,
          ],
        ).createShader(glowRect),
    );
  }

  @override
  bool shouldRepaint(covariant _GridPainter oldDelegate) => false;
}