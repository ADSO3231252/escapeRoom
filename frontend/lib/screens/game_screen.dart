import 'package:flutter/material.dart';

class GameScreen extends StatelessWidget {
  final int levelId;

  const GameScreen({
    super.key,
    required this.levelId,
  });

  String get levelName {
    switch (levelId) {
      case 1:
        return 'LABORATORY';
      case 2:
        return 'CONTROL ROOM';
      case 3:
        return 'NEXUS-9 CORE';
      default:
        return 'UNKNOWN LEVEL';
    }
  }

  IconData get levelIcon {
    switch (levelId) {
      case 1:
        return Icons.science_outlined;
      case 2:
        return Icons.settings_input_component;
      case 3:
        return Icons.memory;
      default:
        return Icons.help_outline;
    }
  }

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

            // LÍNEA SUPERIOR
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 4,
                color: const Color(0xFF22CFFF),
              ),
            ),

            // CONTENIDO
            Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(25),
                child: Column(
                  children: [
                    const SizedBox(height: 15),

                    const Text(
                      'NEXUS-9 // MISSION',
                      style: TextStyle(
                        color: Color(0xFF55DFFF),
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 4,
                      ),
                    ),

                    const SizedBox(height: 15),

                    // ICONO
                    Container(
                      width: 105,
                      height: 105,
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
                      child: Center(
                        child: Icon(
                          levelIcon,
                          color: const Color(0xFF43D9FF),
                          size: 48,
                        ),
                      ),
                    ),

                    const SizedBox(height: 18),

                    Text(
                      'LEVEL ${levelId.toString().padLeft(2, '0')}',
                      style: const TextStyle(
                        color: Color(0xFF7893A5),
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 3,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      levelName,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 36,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 3,
                        shadows: [
                          Shadow(
                            color: Color(0xFF00CFFF),
                            blurRadius: 20,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 30),

                    // PANEL
                    Container(
                      width: double.infinity,
                      constraints: const BoxConstraints(
                        maxWidth: 500,
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
                                'MISSION CONTROL',
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
                                'READY',
                                style: TextStyle(
                                  color: Color(0xFF39E6B0),
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 25),

                          // INFORMACIÓN
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(18),
                            decoration: BoxDecoration(
                              color: const Color(0xFF081622),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: const Color(0xFF1D3B4F),
                              ),
                            ),
                            child: Column(
                              children: [
                                const Text(
                                  'CURRENT MISSION',
                                  style: TextStyle(
                                    color: Color(0xFF43D9FF),
                                    fontSize: 9,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 2,
                                  ),
                                ),

                                const SizedBox(height: 12),

                                Text(
                                  levelName,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 2,
                                  ),
                                ),

                                const SizedBox(height: 8),

                                Text(
                                  'NIVEL $levelId',
                                  style: const TextStyle(
                                    color: Color(0xFF657E8F),
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 2,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 18),

                          // ESTADO
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: const Color(0xFF0D2530),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: const Color(0xFF24505C),
                              ),
                            ),
                            child: const Row(
                              children: [
                                Icon(
                                  Icons.check_circle_outline,
                                  color: Color(0xFF39E6B0),
                                  size: 20,
                                ),
                                SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    'SYSTEM READY',
                                    style: TextStyle(
                                      color: Color(0xFF39E6B0),
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 2,
                                    ),
                                  ),
                                ),
                                Text(
                                  'ONLINE',
                                  style: TextStyle(
                                    color: Color(0xFF657E8F),
                                    fontSize: 9,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 20),

                          // INICIAR
                          SizedBox(
                            width: double.infinity,
                            height: 58,
                            child: ElevatedButton(
                              onPressed: () {},
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
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.play_arrow_rounded,
                                    size: 27,
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    'INICIAR MISIÓN',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 2,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(height: 12),

                          // VOLVER
                          SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: OutlinedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              style: OutlinedButton.styleFrom(
                                foregroundColor: const Color(0xFF8FA8B8),
                                side: const BorderSide(
                                  color: Color(0xFF29485C),
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text(
                                'VOLVER',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 2,
                                ),
                              ),
                            ),
                          ),
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
                        SizedBox(width: 35),
                        _Estado(
                          icon: Icons.bolt,
                          texto: 'ONLINE',
                        ),
                        SizedBox(width: 35),
                        _Estado(
                          icon: Icons.pets,
                          texto: 'LUNA',
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    const Text(
                      'LUNA // PLAYER 01',
                      style: TextStyle(
                        color: Color(0xFF536D7E),
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 3,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

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