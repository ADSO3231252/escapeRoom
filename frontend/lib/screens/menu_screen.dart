import 'package:flutter/material.dart';

import 'tutorial_screen.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

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
                            transitionDuration:
                                const Duration(milliseconds: 900),
                            reverseTransitionDuration:
                                const Duration(milliseconds: 900),
                            pageBuilder:
                                (context, animation, secondaryAnimation) {
                              return const TutorialScreen();
                            },
                            transitionsBuilder: (
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
                      onTap: () {},
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
                      onTap: () {},
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
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Salir'),
          content: const Text(
            '¿Estás seguro de que quieres salir del juego?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('CANCELAR'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('SALIR'),
            ),
          ],
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
            // ========================================================
            // NORMAL → INVISIBLE
            // HOVER / CLICK → LIGERO BRILLO
            // ========================================================

            color: _isActive
                ? widget.glowColor.withValues(alpha: 0.08)
                : Colors.transparent,

            borderRadius: BorderRadius.circular(
              widget.borderRadius,
            ),

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