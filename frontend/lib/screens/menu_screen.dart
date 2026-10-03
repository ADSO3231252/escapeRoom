import 'package:flutter/material.dart';

import 'tutorial_screen.dart';

import 'tutorial_screen.dart';
import 'options_screen.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  bool _showSoundPanel = false;

  double _musicVolume = 0.70;
  double _effectsVolume = 0.85;

  double _previousMusicVolume = 0.70;
  double _previousEffectsVolume = 0.85;

  bool _isMuted = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: AspectRatio(
          aspectRatio: 16 / 9,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth;
              final height = constraints.maxHeight;

              final scale = width / 1920;

              // ==========================================================
              // PANEL DE SONIDO
              // ==========================================================
              //
              // El panel es pequeño en pantallas grandes y se adapta
              // proporcionalmente en pantallas pequeñas.
              //
              final panelWidth = (width * 0.19).clamp(180.0, 360.0);

              final panelHeight = (height * 0.23).clamp(155.0, 250.0);

              return Stack(
                children: [
                  // ==================================================
                  // IMAGEN COMPLETA DEL MAIN MENU
                  // ==================================================

                  Positioned.fill(
                    child: Image.asset(
                      'assets/backgrounds/menu_game.png',
                      fit: BoxFit.fill,
                    ),
                  ),

                  // ==================================================
                  // NUEVA PARTIDA
                  // ==================================================
                  Positioned(
                    left: 130 / 1920 * width,
                    top: 332 / 1080 * height,
                    width: 428 / 1920 * width,
                    height: 80 / 1080 * height,
                    child: _InteractiveArea(
                      glowColor: const Color(0xFF00D9FF),
                      onTap: () {
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            transitionDuration: const Duration(
                              milliseconds: 900,
                            ),
                            reverseTransitionDuration: const Duration(
                              milliseconds: 900,
                            ),
                            pageBuilder:
                                (context, animation, secondaryAnimation) {
                                  return const TutorialScreen();
                                },
                            transitionsBuilder:
                                (
                                  context,
                                  animation,
                                  secondaryAnimation,
                                  child,
                                ) {
                                  final curvedAnimation = CurvedAnimation(
                                    parent: animation,
                                    curve: Curves.easeInOutCubic,
                                  );

                                  return FadeTransition(
                                    opacity: curvedAnimation,
                                    child: SlideTransition(
                                      position: Tween<Offset>(
                                        begin: const Offset(0.08, 0),
                                        end: Offset.zero,
                                      ).animate(curvedAnimation),
                                      child: child,
                                    ),
                                  );
                                },
                          ),
                        );
                      },
                    ),
                  ),

                  // ==================================================
                  // CONTINUAR
                  // ==================================================
                  Positioned(
                    left: 130 / 1920 * width,
                    top: 427 / 1080 * height,
                    width: 428 / 1920 * width,
                    height: 80 / 1080 * height,
                    child: _InteractiveArea(
                      glowColor: const Color(0xFF00D9FF),
                      onTap: () {},
                    ),
                  ),

                  // ==================================================
                  // RANKING
                  // ==================================================
                  Positioned(
                    left: 130 / 1920 * width,
                    top: 527 / 1080 * height,
                    width: 428 / 1920 * width,
                    height: 80 / 1080 * height,
                    child: _InteractiveArea(
                      glowColor: const Color(0xFF00D9FF),
                      onTap: () {},
                    ),
                  ),

                  // ==================================================
                  // OPCIONES
                  // ==================================================
                  Positioned(
                    left: 130 / 1920 * width,
                    top: 627 / 1080 * height,
                    width: 428 / 1920 * width,
                    height: 80 / 1080 * height,
                    child: _InteractiveArea(
                      glowColor: const Color(0xFF00D9FF),
                      onTap: () {},
                    ),
                  ),

                  // ==================================================
                  // SALIR
                  // ==================================================
                  Positioned(
                    left: 130 / 1920 * width,
                    top: 725 / 1080 * height,
                    width: 428 / 1920 * width,
                    height: 80 / 1080 * height,
                    child: _InteractiveArea(
                      glowColor: const Color(0xFFFF3030),
                      onTap: () {
                        _showExitDialog(context);
                      },
                    ),
                  ),

                  // ==================================================
                  // AUDIO
                  // ==================================================
                  Positioned(
                    left: 1635 / 1920 * width,
                    top: 47 / 1080 * height,
                    width: 90 / 1920 * width,
                    height: 90 / 1080 * height,
                    child: _InteractiveArea(
                      glowColor: const Color(0xFF00D9FF),
                      borderRadius: 12,
                      onTap: () {
                        setState(() {
                          _showSoundPanel = !_showSoundPanel;
                        });
                      },
                    ),
                  ),

                  // ==================================================
                  // PANEL DE SONIDO
                  // ==================================================
                  if (_showSoundPanel)
                    Positioned(
                      right: 20 * scale,
                      top: 125 * scale,
                      width: panelWidth,
                      height: panelHeight,
                      child: AnimatedOpacity(
                        duration: const Duration(milliseconds: 300),
                        opacity: _showSoundPanel ? 1.0 : 0.0,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12 * scale,
                            vertical: 10 * scale,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF07131C)
                                .withValues(alpha: 0.97),
                            borderRadius: BorderRadius.circular(12 * scale),
                            border: Border.all(
                              color: const Color(0xFF00D9FF),
                              width: 1.5,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF00D9FF)
                                    .withValues(alpha: 0.22),
                                blurRadius: 15,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // ------------------------------------------
                              // TÍTULO
                              // ------------------------------------------

                              Text(
                                'SONIDO',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: (panelWidth * 0.055).clamp(
                                    14.0,
                                    20.0,
                                  ),
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.2,
                                ),
                              ),

                              SizedBox(height: 7 * scale),

                              // ------------------------------------------
                              // MÚSICA
                              // ------------------------------------------
                              Row(
                                children: [
                                  Icon(
                                    Icons.music_note,
                                    color: const Color(0xFF00D9FF),
                                    size: (panelWidth * 0.055).clamp(
                                      14.0,
                                      18.0,
                                    ),
                                  ),

                                  SizedBox(width: 6 * scale),

                                  Expanded(
                                    child: Text(
                                      'Música',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: (panelWidth * 0.035).clamp(
                                          9.0,
                                          13.0,
                                        ),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),

                                  Text(
                                    '${(_musicVolume * 100).round()}%',
                                    style: TextStyle(
                                      color: const Color(0xFF00D9FF),
                                      fontSize: (panelWidth * 0.032).clamp(
                                        9.0,
                                        12.0,
                                      ),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),

                              // ------------------------------------------
                              // SLIDER MÚSICA
                              // ------------------------------------------
                              SizedBox(height: 2 * scale),

                              SizedBox(
                                height: 22,
                                child: SliderTheme(
                                  data: SliderTheme.of(context).copyWith(
                                    activeTrackColor: const Color(0xFF00D9FF),
                                    inactiveTrackColor: Colors.white24,
                                    thumbColor: const Color(0xFF00D9FF),
                                    overlayColor: const Color(0xFF00D9FF)
                                        .withValues(alpha: 0.12),
                                    trackHeight: 3,
                                    thumbShape: const RoundSliderThumbShape(
                                      enabledThumbRadius: 5,
                                    ),
                                  ),
                                  child: Slider(
                                    value: _musicVolume,
                                    min: 0,
                                    max: 1,
                                    divisions: 100,
                                    onChanged: (value) {
                                      setState(() {
                                        _musicVolume = value;
                                      });
                                    },
                                  ),
                                ),
                              ),

                              SizedBox(height: 6 * scale),

                              // ------------------------------------------
                              // EFECTOS
                              // ------------------------------------------
                              Row(
                                children: [
                                  Icon(
                                    Icons.volume_up,
                                    color: const Color(0xFF00D9FF),
                                    size: (panelWidth * 0.055).clamp(
                                      14.0,
                                      18.0,
                                    ),
                                  ),

                                  SizedBox(width: 6 * scale),

                                  Expanded(
                                    child: Text(
                                      'Efectos de sonido',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: (panelWidth * 0.032).clamp(
                                          8.0,
                                          12.0,
                                        ),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),

                                  Text(
                                    '${(_effectsVolume * 100).round()}%',
                                    style: TextStyle(
                                      color: const Color(0xFF00D9FF),
                                      fontSize: (panelWidth * 0.032).clamp(
                                        9.0,
                                        12.0,
                                      ),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),

                              // ------------------------------------------
                              // SLIDER EFECTOS
                              // ------------------------------------------
                              SizedBox(height: 2 * scale),

                              SizedBox(
                                height: 22,
                                child: SliderTheme(
                                  data: SliderTheme.of(context).copyWith(
                                    activeTrackColor: const Color(0xFF00D9FF),
                                    inactiveTrackColor: Colors.white24,
                                    thumbColor: const Color(0xFF00D9FF),
                                    overlayColor: const Color(0xFF00D9FF)
                                        .withValues(alpha: 0.12),
                                    trackHeight: 3,
                                    thumbShape: const RoundSliderThumbShape(
                                      enabledThumbRadius: 5,
                                    ),
                                  ),
                                  child: Slider(
                                    value: _effectsVolume,
                                    min: 0,
                                    max: 1,
                                    divisions: 100,
                                    onChanged: (value) {
                                      setState(() {
                                        _effectsVolume = value;
                                      });
                                    },
                                  ),
                                ),
                              ),

                              SizedBox(height: 7 * scale),

                              // ------------------------------------------
                              // SILENCIAR TODO
                              // ------------------------------------------
                              SizedBox(
                                width: double.infinity,
                                height: (panelHeight * 0.14).clamp(28.0, 36.0),
                                child: OutlinedButton.icon(
                                  onPressed: () {
                                    setState(() {
                                      if (_isMuted) {
                                        _musicVolume = _previousMusicVolume;
                                        _effectsVolume = _previousEffectsVolume;
                                        _isMuted = false;
                                      } else {
                                        _previousMusicVolume = _musicVolume;
                                        _previousEffectsVolume = _effectsVolume;

                                        _musicVolume = 0;
                                        _effectsVolume = 0;

                                        _isMuted = true;
                                      }
                                    });
                                  },
                                  label: Text(
                                    _isMuted
                                        ? 'ACTIVAR SONIDO'
                                        : 'SILENCIAR TODO',
                                    style: TextStyle(
                                      fontSize: (panelWidth * 0.028).clamp(
                                        8.0,
                                        11.0,
                                      ),
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    padding: EdgeInsets.zero,
                                    side: const BorderSide(
                                      color: Color(0xFF00D9FF),
                                      width: 1.2,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                  // ==================================================
                  // CONFIGURACIÓN
                  // ==================================================
                  Positioned(
                    left: 1771 / 1920 * width,
                    top: 47 / 1080 * height,
                    width: 90 / 1920 * width,
                    height: 90 / 1080 * height,
                    child: _InteractiveArea(
                      glowColor: const Color(0xFF00D9FF),
                      borderRadius: 12,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const OptionsScreen(),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  // ================================================================
  // CONFIRMACIÓN PARA SALIR
  // ================================================================

  static void _showExitDialog(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Exit',
      barrierColor: Colors.black.withValues(alpha: 0.75),
      transitionDuration: const Duration(milliseconds: 500),
      pageBuilder: (context, animation, secondaryAnimation) {
        return const SizedBox.shrink();
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
          reverseCurve: Curves.easeInCubic,
        );

        return FadeTransition(
          opacity: curvedAnimation,
          child: ScaleTransition(
            scale: Tween<double>(
              begin: 0.85,
              end: 1.0,
            ).animate(curvedAnimation),
            child: Center(
              child: Container(
                width: 500,
                padding: const EdgeInsets.all(30),
                decoration: BoxDecoration(
                  color: const Color(0xFF07131C),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: const Color(0xFFFF3030), width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFFF3030).withValues(alpha: 0.30),
                      blurRadius: 30,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.warning_amber_rounded,
                        color: Color(0xFFFF3030),
                        size: 52,
                      ),

                      const SizedBox(height: 18),

                      const Text(
                        'SALIR DEL JUEGO',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                        ),
                      ),

                      const SizedBox(height: 14),

                      const Text(
                        '¿Estás seguro de que quieres salir del juego?',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white70, fontSize: 16),
                      ),

                      const SizedBox(height: 30),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // CANCELAR
                          SizedBox(
                            width: 170,
                            height: 50,
                            child: OutlinedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              style: OutlinedButton.styleFrom(
                                foregroundColor: const Color(0xFF00D9FF),
                                side: const BorderSide(
                                  color: Color(0xFF00D9FF),
                                  width: 2,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: const Text(
                                'CANCELAR',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(width: 20),

                          // SALIR
                          SizedBox(
                            width: 170,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);

                                // El cierre real de la aplicación
                                // se implementará según la plataforma.
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFFF3030),
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: const Text(
                                'SALIR',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

// ==================================================================
// ZONA INTERACTIVA
// ==================================================================

class _InteractiveArea extends StatefulWidget {
  final Color glowColor;
  final double borderRadius;
  final VoidCallback onTap;

  const _InteractiveArea({
    required this.glowColor,
    required this.onTap,
    this.borderRadius = 8,
  });

  @override
  State<_InteractiveArea> createState() => _InteractiveAreaState();
}

class _InteractiveAreaState extends State<_InteractiveArea> {
  bool _isHovered = false;
  bool _isPressed = false;

  bool get _isActive => _isHovered || _isPressed;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,

      // ============================================================
      // MOUSE ENTRA
      // ============================================================
      onEnter: (_) {
        setState(() {
          _isHovered = true;
        });
      },

      // ============================================================
      // MOUSE SALE
      // ============================================================
      onExit: (_) {
        setState(() {
          _isHovered = false;
        });
      },

      child: GestureDetector(
        // ============================================================
        // PRESIONAR
        // ============================================================

        onTapDown: (_) {
          setState(() {
            _isPressed = true;
          });
        },

        // ============================================================
        // SOLTAR
        // ============================================================
        onTapUp: (_) {
          setState(() {
            _isPressed = false;
          });
        },

        // ============================================================
        // CANCELAR
        // ============================================================
        onTapCancel: () {
          setState(() {
            _isPressed = false;
          });
        },

        // ============================================================
        // CLICK
        // ============================================================
        onTap: widget.onTap,

        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          curve: Curves.easeOut,

          decoration: BoxDecoration(
            color: _isActive
                ? widget.glowColor.withValues(alpha: 0.08)
                : Colors.transparent,

            borderRadius: BorderRadius.circular(widget.borderRadius),

            // ========================================================
            // BORDE
            // ========================================================
            border: Border.all(
              color: _isActive
                  ? widget.glowColor.withValues(alpha: 0.65)
                  : Colors.transparent,
              width: _isActive ? 2 : 0,
            ),

            // ========================================================
            // BRILLO
            // ========================================================
            boxShadow: _isActive
                ? [
                    BoxShadow(
                      color: widget.glowColor.withValues(alpha: 0.40),
                      blurRadius: 16,
                      spreadRadius: 1,
                    ),
                  ]
                : [],
          ),
        ),
      ),
    );
  }
}
