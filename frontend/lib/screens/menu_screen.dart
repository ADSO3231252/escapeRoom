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
      backgroundColor: const Color(0xFF07111C),

      body: SafeArea(
        child: Stack(
          children: [

            // FONDO
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF0B1B2B),
                    Color(0xFF07111C),
                    Color(0xFF03080D),
                  ],
                ),
              ),
            ),

            // DECORACIÓN SUPERIOR
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 4,
                color: const Color(0xFF22CFFF),
              ),
            ),
          ),
        );
      },
    );
  }
}

            // CONTENIDO
            Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(25),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    // PEQUEÑO TEXTO
                    const Text(
                      'NEXUS-9',
                      style: TextStyle(
                        color: Color(0xFF55DFFF),
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 5,
                      ),
                    ),

                    const SizedBox(height: 10),

                    // LUNA
                    Container(
                      width: 110,
                      height: 110,
                      decoration: BoxDecoration(
                        color: const Color(0xFF102638),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xFF267B9C),
                          width: 2,
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x5500CFFF),
                            blurRadius: 25,
                            spreadRadius: 3,
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Text(
                          '🐶',
                          style: TextStyle(
                            fontSize: 58,
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

                    const Text(
                      'LUNA',
                      style: TextStyle(
                        color: Color(0xFF9FB6C7),
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 3,
                      ),
                    ),

                    const SizedBox(height: 25),

                    // TÍTULO
                    const Text(
                      'NEXUS-9',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 52,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 7,
                        shadows: [
                          Shadow(
                            color: Color(0xFF00CFFF),
                            blurRadius: 20,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 8),

                    const Text(
                      'ESCAPE LABORATORY',
                      style: TextStyle(
                        color: Color(0xFF7893A5),
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 4,
                      ),
                    ),

                    const SizedBox(height: 35),

                    // PANEL
                    Container(
                      width: double.infinity,
                      constraints: const BoxConstraints(
                        maxWidth: 450,
                      ),
                      padding: const EdgeInsets.all(22),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0C1C2B),
                        border: Border.all(
                          color: const Color(0xFF24465D),
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x44000000),
                            blurRadius: 20,
                            offset: Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [

                          const Row(
                            children: [
                              Icon(
                                Icons.terminal,
                                color: Color(0xFF43D9FF),
                                size: 18,
                              ),
                              SizedBox(width: 10),
                              Text(
                                'CONTROL ROOM',
                                style: TextStyle(
                                  color: Color(0xFFB5C8D6),
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 2,
                                ),
                              ),
                              Spacer(),
                              Icon(
                                Icons.circle,
                                color: Color(0xFF39E6B0),
                                size: 8,
                              ),
                              SizedBox(width: 5),
                              Text(
                                'ONLINE',
                                style: TextStyle(
                                  color: Color(0xFF39E6B0),
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 20),

                          // NUEVA PARTIDA
                          SizedBox(
                            width: double.infinity,
                            height: 62,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const TutorialScreen(),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF079AC7),
                                foregroundColor: Colors.white,
                                elevation: 10,
                                shadowColor: const Color(0xFF00CFFF),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.play_arrow_rounded,
                                    size: 28,
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    'NUEVA PARTIDA',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 2,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(height: 12),
                        ],
                      ),
                    ),

                    const SizedBox(height: 30),

                    // ESTADOS
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _Estado(
                          icon: Icons.shield_outlined,
                          texto: 'SECURE',
                        ),
                        SizedBox(width: 30),
                        _Estado(
                          icon: Icons.bolt,
                          texto: 'ONLINE',
                        ),
                        SizedBox(width: 30),
                        _Estado(
                          icon: Icons.pets,
                          texto: 'LUNA',
                        ),
                      ],
                    ),

                    const SizedBox(height: 25),

                    const Text(
                      'LUNA // PLAYER 01',
                      style: TextStyle(
                        color: Color(0xFF536D7E),
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 3,
                      ),
                    ),

                    const SizedBox(height: 8),

                    const Text(
                      'SYSTEM READY',
                      style: TextStyle(
                        color: Color(0xFF39E6B0),
                        fontSize: 9,
                        letterSpacing: 2,
                      ),
                    ),
                  ],
                ),
              ),
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


// ----------------------------------------------------------
// ESTADO
// ----------------------------------------------------------

class _Estado extends StatelessWidget {
  final IconData icon;
  final String texto;

  const _Estado({
    required this.icon,
    required this.texto,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          icon,
          color: const Color(0xFF43D9FF),
          size: 19,
        ),
        const SizedBox(height: 5),
        Text(
          texto,
          style: const TextStyle(
            color: Color(0xFF657E8F),
            fontSize: 8,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
      ],
    );
  }
}
