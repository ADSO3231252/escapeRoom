import 'package:flutter/material.dart';

import '../level_02/screens/level_02_screen.dart';

class Level01Screen extends StatelessWidget {
  const Level01Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF050B12),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            final height = constraints.maxHeight;

            // Escala basada principalmente en el ancho disponible.
            final scale = (width / 1280).clamp(0.75, 1.25);

            final panelWidth = (width * 0.58).clamp(400.0, 760.0);
            final horizontalPadding = 32.0 * scale;
            final verticalPadding = 30.0 * scale;

            final titleSize = 32.0 * scale;
            final mainTextSize = 20.0 * scale;
            final secondaryTextSize = 15.0 * scale;
            final iconSize = 65.0 * scale;

            final buttonWidth = (width * 0.30).clamp(280.0, 380.0);
            final buttonHeight = (height * 0.10).clamp(50.0, 64.0);

            return Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: 20 * scale,
                  vertical: 16 * scale,
                ),
                child: Container(
                  width: panelWidth,
                  constraints: BoxConstraints(
                    minHeight: 300,
                    maxHeight: height * 0.90,
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: horizontalPadding,
                    vertical: verticalPadding,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0B1724),
                    borderRadius: BorderRadius.circular(20 * scale),
                    border: Border.all(
                      color: const Color(0xFF00D9FF),
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF00D9FF).withValues(
                          alpha: 0.20,
                        ),
                        blurRadius: 30 * scale,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // ICONO
                      Icon(
                        Icons.lock_outline,
                        color: const Color(0xFF00D9FF),
                        size: iconSize,
                      ),

                      SizedBox(height: 18 * scale),

                      // TÍTULO
                      Text(
                        'NIVEL 1',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: const Color(0xFF00D9FF),
                          fontSize: titleSize,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 4 * scale,
                        ),
                      ),

                      SizedBox(height: 18 * scale),

                      // MENSAJE PRINCIPAL
                      Text(
                        'Este nivel todavía no está disponible.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: mainTextSize,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      SizedBox(height: 12 * scale),

                      // DESCRIPCIÓN
                      Text(
                        'Aún no me han pasado este nivel, '
                        'por eso todavía no se puede jugar '
                        '- ATT Juka',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: secondaryTextSize,
                          height: 1.5,
                        ),
                      ),

                      SizedBox(height: 25 * scale),

                      // BOTÓN
                      SizedBox(
                        width: buttonWidth,
                        height: buttonHeight,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const Level02Screen(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF00D9FF),
                            foregroundColor: Colors.black,
                            padding: EdgeInsets.symmetric(
                              horizontal: 15 * scale,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                10 * scale,
                              ),
                            ),
                          ),
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              'CONTINUAR AL NIVEL 2',
                              style: TextStyle(
                                fontSize: 16 * scale,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}