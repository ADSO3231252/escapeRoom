import 'package:flutter/material.dart';

class OptionsScreen extends StatefulWidget {
  const OptionsScreen({super.key});

  @override
  State<OptionsScreen> createState() => _OptionsScreenState();
}

class _OptionsScreenState extends State<OptionsScreen> {
  double _musicVolume = 0.70;
  double _effectsVolume = 0.85;
  bool _showHints = true;
  bool _subtitles = true;
  String _language = 'Español';

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
                  // FONDO
                  // ==================================================

                  Positioned.fill(
                    child: Image.asset(
                      'assets/backgrounds/options_game.png',
                      fit: BoxFit.fill,
                    ),
                  ),

                  // ==================================================
                  // SLIDER DE MÚSICA
                  // ==================================================
                  Positioned(
                    left: 930 / 1920 * width,
                    top: 400 / 1080 * height,
                    width: 270 / 1920 * width,
                    height: 45 / 1080 * height,
                    child: SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        activeTrackColor: const Color(0xFF00D9FF),
                        inactiveTrackColor: const Color(0xFF123746),
                        thumbColor: Colors.white,
                        overlayColor: const Color(0x3300D9FF),
                        trackHeight: 6,
                        thumbShape: const RoundSliderThumbShape(
                          enabledThumbRadius: 8,
                        ),
                      ),
                      child: Slider(
                        value: _musicVolume,
                        min: 0,
                        max: 1,
                        onChanged: (value) {
                          setState(() {
                            _musicVolume = value;
                          });
                        },
                      ),
                    ),
                  ),

                  // ==================================================
                  // SLIDER DE EFECTOS DE SONIDO
                  // ==================================================
                  Positioned(
                    left: 930 / 1920 * width,
                    top: 455 / 1080 * height,
                    width: 270 / 1920 * width,
                    height: 45 / 1080 * height,
                    child: SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        activeTrackColor: const Color(0xFF00D9FF),
                        inactiveTrackColor: const Color(0xFF123746),
                        thumbColor: Colors.white,
                        overlayColor: const Color(0x3300D9FF),
                        trackHeight: 6,
                        thumbShape: const RoundSliderThumbShape(
                          enabledThumbRadius: 8,
                        ),
                      ),
                      child: Slider(
                        value: _effectsVolume,
                        min: 0,
                        max: 1,
                        onChanged: (value) {
                          setState(() {
                            _effectsVolume = value;
                          });
                        },
                      ),
                    ),
                  ),

                  // ==================================================
                  // PORCENTAJE DE EFECTOS
                  // ==================================================
                  Positioned(
                    left: 1215 / 1920 * width,
                    top: 455 / 1080 * height,
                    width: 80 / 1920 * width,
                    height: 40 / 1080 * height,
                    child: Center(
                      child: Text(
                        '${(_effectsVolume * 100).round()}%',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18 / 1920 * width,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  // ==================================================
                  // MOSTRAR PISTAS
                  // ==================================================
                  Positioned(
                    left: 970 / 1920 * width,
                    top: 590 / 1080 * height,
                    width: 90 / 1920 * width,
                    height: 45 / 1080 * height,
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _showHints = !_showHints;
                          });
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 180),
                          width: 90 / 1920 * width,
                          height: 45 / 1080 * height,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                              25 / 1920 * width,
                            ),
                            color: _showHints
                                ? const Color(0xFF00D9FF)
                                : const Color(0xFF123746),
                          ),
                          child: AnimatedAlign(
                            duration: const Duration(milliseconds: 180),
                            alignment: _showHints
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                            child: Container(
                              width: 30 / 1920 * width,
                              height: 30 / 1080 * height,
                              margin: EdgeInsets.symmetric(
                                horizontal: 7 / 1920 * width,
                              ),
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // ==================================================
                  // SUBTÍTULOS
                  // ==================================================
                  Positioned(
                    left: 970 / 1920 * width,
                    top: 645 / 1080 * height,
                    width: 90 / 1920 * width,
                    height: 45 / 1080 * height,
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _subtitles = !_subtitles;
                          });
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 180),
                          width: 90 / 1920 * width,
                          height: 45 / 1080 * height,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                              25 / 1920 * width,
                            ),
                            color: _subtitles
                                ? const Color(0xFF00D9FF)
                                : const Color(0xFF123746),
                          ),
                          child: AnimatedAlign(
                            duration: const Duration(milliseconds: 180),
                            alignment: _subtitles
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                            child: Container(
                              width: 30 / 1920 * width,
                              height: 30 / 1080 * height,
                              margin: EdgeInsets.symmetric(
                                horizontal: 7 / 1920 * width,
                              ),
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // ==================================================
                  // IDIOMA
                  // ==================================================
                  Positioned(
                    left: 960 / 1920 * width,
                    top: 705 / 1080 * height,
                    width: 180 / 1920 * width,
                    height: 50 / 1080 * height,
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _language = _language == 'Español'
                                ? 'English'
                                : 'Español';
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.white,
                              width: 2 / 1920 * width,
                            ),
                            borderRadius: BorderRadius.circular(
                              4 / 1920 * width,
                            ),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            _language,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 17 / 1920 * width,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // ==================================================
                  // PORCENTAJE
                  // ==================================================
                  Positioned(
                    left: 1215 / 1920 * width,
                    top: 400 / 1080 * height,
                    width: 80 / 1920 * width,
                    height: 40 / 1080 * height,
                    child: Center(
                      child: Text(
                        '${(_musicVolume * 100).round()}%',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18 / 1920 * width,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  // ==================================================
                  // VOLVER
                  // ==================================================
                  Positioned(
                    left: 835 / 1920 * width,
                    top: 890 / 1080 * height,
                    width: 250 / 1920 * width,
                    height: 70 / 1080 * height,
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(color: Colors.transparent),
                      ),
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
}
