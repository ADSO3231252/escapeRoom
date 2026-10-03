import 'package:flutter/material.dart';

import 'level_select_screen.dart';

class TutorialScreen extends StatelessWidget {
  const TutorialScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF07111C),
      body: SafeArea(
        child: Container(
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
          child: Column(
            children: [
              Container(
                height: 4,
                color: const Color(0xFF22CFFF),
              ),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      const SizedBox(height: 15),

                      const Text(
                        'NEXUS-9',
                        style: TextStyle(
                          color: Color(0xFF43D9FF),
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 6,
                        ),
                      ),

                      const SizedBox(height: 5),

                      const Text(
                        'MISSION BRIEFING',
                        style: TextStyle(
                          color: Color(0xFF718A9B),
                          fontSize: 11,
                          letterSpacing: 3,
                        ),
                      ),

                      const SizedBox(height: 25),

                      Container(
                        width: 110,
                        height: 110,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFF102638),
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
                            style: TextStyle(fontSize: 60),
                          ),
                        ),
                      ),

                      const SizedBox(height: 8),

                      const Text(
                        'LUNA',
                        style: TextStyle(
                          color: Color(0xFF43D9FF),
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 3,
                        ),
                      ),

                      const SizedBox(height: 25),

                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(22),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0C1C2B),
                          border: Border.all(
                            color: const Color(0xFF24465D),
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            const Row(
                              children: [
                                Icon(
                                  Icons.terminal,
                                  color: Color(0xFF43D9FF),
                                  size: 20,
                                ),
                                SizedBox(width: 10),
                                Text(
                                  'HOW TO PLAY',
                                  style: TextStyle(
                                    color: Color(0xFFB8D5E5),
                                    fontSize: 13,
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

                            const Text(
                              'Explora el laboratorio.\n\n'
                              'Interactúa con los objetos.\n\n'
                              'Encuentra pistas.\n\n'
                              'Resuelve los puzzles.\n\n'
                              'Escapa del laboratorio.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color(0xFFB5C8D6),
                                fontSize: 15,
                                height: 1.5,
                              ),
                            ),

                            const SizedBox(height: 25),

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
                                    Icons.pets,
                                    color: Color(0xFF43D9FF),
                                    size: 22,
                                  ),
                                  SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      'LUNA TE ACOMPAÑARÁ DURANTE LA MISIÓN.',
                                      style: TextStyle(
                                        color: Color(0xFF9FB6C7),
                                        fontSize: 9,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 20),

                            SizedBox(
                              width: double.infinity,
                              height: 55,
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const LevelSelectScreen(),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      const Color(0xFF079AC7),
                                  foregroundColor: Colors.white,
                                  elevation: 10,
                                  shadowColor: const Color(0xFF00CFFF),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: const Text(
                                  'COMENZAR MISIÓN',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 2,
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 12),

                            SizedBox(
                              width: double.infinity,
                              height: 48,
                              child: OutlinedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                style: OutlinedButton.styleFrom(
                                  foregroundColor:
                                      const Color(0xFF8FA8B8),
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

                      const SizedBox(height: 20),

                      const Text(
                        'LUNA // PLAYER 01',
                        style: TextStyle(
                          color: Color(0xFF496272),
                          fontSize: 9,
                          letterSpacing: 2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
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
            color: Color(0xFF607B8C),
            fontSize: 8,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
      ],
    );
  }
}