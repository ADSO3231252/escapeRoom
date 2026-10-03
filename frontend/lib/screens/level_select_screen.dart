import 'package:flutter/material.dart';

import '../levels/level_02/screens/level_02_screen.dart';
import 'game_screen.dart';

class LevelSelectScreen extends StatelessWidget {
  const LevelSelectScreen({super.key});

  void _openLevel(BuildContext context, int levelId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GameScreen(
          levelId: levelId,
        ),
      ),
    );
  }

  void _openLevel2(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const Level02Screen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF07111C),
      body: SafeArea(
        child: Stack(
          children: [

            // --------------------------------------------------
            // FONDO
            // --------------------------------------------------

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

            // --------------------------------------------------
            // LÍNEA SUPERIOR
            // --------------------------------------------------

            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 4,
                color: const Color(0xFF22CFFF),
              ),
            ),

            // --------------------------------------------------
            // CONTENIDO
            // --------------------------------------------------

            Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(25),
                child: Column(
                  children: [

                    const SizedBox(height: 15),

                    // PEQUEÑO TÍTULO
                    const Text(
                      'NEXUS-9',
                      style: TextStyle(
                        color: Color(0xFF55DFFF),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 5,
                      ),
                    ),

                    const SizedBox(height: 8),

                    const Text(
                      'MISSION SELECT',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 34,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 4,
                        shadows: [
                          Shadow(
                            color: Color(0xFF00CFFF),
                            blurRadius: 18,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 8),

                    const Text(
                      'SELECCIONA TU MISIÓN',
                      style: TextStyle(
                        color: Color(0xFF7893A5),
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 3,
                      ),
                    ),

                    const SizedBox(height: 30),

                    // --------------------------------------------------
                    // PANEL PRINCIPAL
                    // --------------------------------------------------

                    Container(
                      width: double.infinity,
                      constraints: const BoxConstraints(
                        maxWidth: 500,
                      ),
                      padding: const EdgeInsets.all(20),
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

                          // CABECERA DEL PANEL
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

                          // --------------------------------------------------
                          // NIVEL 1
                          // --------------------------------------------------

                          _LevelButton(
                            numero: '01',
                            titulo: 'LABORATORY',
                            descripcion: 'BEGIN THE ESCAPE',
                            icono: Icons.science_outlined,
                            activo: true,
                            onPressed: () {
                              _openLevel(context, 1);
                            },
                          ),

                          const SizedBox(height: 12),

                          // --------------------------------------------------
                          // NIVEL 2
                          // --------------------------------------------------

                          _LevelButton(
                            numero: '02',
                            titulo: 'CONTROL ROOM',
                            descripcion: 'SYSTEM OVERRIDE',
                            icono: Icons.settings_input_component,
                            activo: true,
                            onPressed: () {
                              _openLevel2(context);
                            },
                          ),

                          const SizedBox(height: 12),

                          // --------------------------------------------------
                          // NIVEL 3
                          // --------------------------------------------------

                          _LevelButton(
                            numero: '03',
                            titulo: 'NEXUS-9 CORE',
                            descripcion: 'FINAL PROTOCOL',
                            icono: Icons.memory,
                            activo: true,
                            onPressed: () {
                              _openLevel(context, 3);
                            },
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 30),

                    // --------------------------------------------------
                    // ESTADOS
                    // --------------------------------------------------

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
                      'SELECT YOUR DESTINATION',
                      style: TextStyle(
                        color: Color(0xFF39E6B0),
                        fontSize: 9,
                        letterSpacing: 2,
                      ),
                    ),

                    const SizedBox(height: 15),
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


// ==========================================================
// BOTÓN DE NIVEL
// ==========================================================

class _LevelButton extends StatelessWidget {
  final String numero;
  final String titulo;
  final String descripcion;
  final IconData icono;
  final bool activo;
  final VoidCallback onPressed;

  const _LevelButton({
    required this.numero,
    required this.titulo,
    required this.descripcion,
    required this.icono,
    required this.activo,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 82,
      child: ElevatedButton(
        onPressed: activo ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF102638),
          foregroundColor: Colors.white,
          elevation: 8,
          shadowColor: const Color(0x4400CFFF),
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(9),
            side: const BorderSide(
              color: Color(0xFF29485C),
              width: 1.5,
            ),
          ),
        ),
        child: Row(
          children: [

            // NÚMERO
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: const Color(0xFF0A1A28),
                borderRadius: BorderRadius.circular(7),
                border: Border.all(
                  color: const Color(0xFF267B9C),
                ),
              ),
              child: Center(
                child: Text(
                  numero,
                  style: const TextStyle(
                    color: Color(0xFF43D9FF),
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ),

            const SizedBox(width: 15),

            // ICONO
            Icon(
              icono,
              color: const Color(0xFF43D9FF),
              size: 25,
            ),

            const SizedBox(width: 15),

            // TEXTO
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    titulo,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                    ),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    descripcion,
                    style: const TextStyle(
                      color: Color(0xFF6F8999),
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                    ),
                  ),
                ],
              ),
            ),

            // FLECHA
            const Icon(
              Icons.arrow_forward_ios_rounded,
              color: Color(0xFF43D9FF),
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}


// ==========================================================
// ESTADO
// ==========================================================

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