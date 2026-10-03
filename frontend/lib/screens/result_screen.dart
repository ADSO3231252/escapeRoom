import 'package:flutter/material.dart';

class ResultScreen extends StatelessWidget {
  final int score;

  const ResultScreen({
    super.key,
    required this.score,
  });

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
                child: Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
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
                          'MISSION COMPLETE',
                          style: TextStyle(
                            color: Color(0xFF718A9B),
                            fontSize: 11,
                            letterSpacing: 3,
                          ),
                        ),

                        const SizedBox(height: 30),

                        Container(
                          width: 120,
                          height: 120,
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
                                blurRadius: 30,
                                spreadRadius: 4,
                              ),
                            ],
                          ),
                          child: const Center(
                            child: Text(
                              '🐶',
                              style: TextStyle(
                                fontSize: 65,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 10),

                        const Text(
                          'LUNA',
                          style: TextStyle(
                            color: Color(0xFF43D9FF),
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 3,
                          ),
                        ),

                        const SizedBox(height: 30),

                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(25),
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
                                    Icons.emoji_events_outlined,
                                    color: Color(0xFF43D9FF),
                                    size: 22,
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    'FINAL REPORT',
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
                                    'COMPLETE',
                                    style: TextStyle(
                                      color: Color(0xFF39E6B0),
                                      fontSize: 8,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 30),

                              const Text(
                                'RESULTADO FINAL',
                                style: TextStyle(
                                  color: Color(0xFF718A9B),
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 3,
                                ),
                              ),

                              const SizedBox(height: 15),

                              Text(
                                '$score',
                                style: const TextStyle(
                                  color: Color(0xFF43D9FF),
                                  fontSize: 60,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 4,
                                  shadows: [
                                    Shadow(
                                      color: Color(0x8800CFFF),
                                      blurRadius: 20,
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 5),

                              const Text(
                                'PUNTOS',
                                style: TextStyle(
                                  color: Color(0xFF8FA8B8),
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 3,
                                ),
                              ),

                              const SizedBox(height: 25),

                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(15),
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
                                        'LUNA // MISIÓN FINALIZADA',
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

                              const SizedBox(height: 25),

                              SizedBox(
                                width: double.infinity,
                                height: 55,
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(context);
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
                                    'VOLVER',
                                    style: TextStyle(
                                      fontSize: 12,
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