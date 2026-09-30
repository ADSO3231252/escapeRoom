import 'dart:async';

import 'package:flutter/material.dart';

import 'menu_screen.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  double _progress = 0.0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startLoading();
  }

  void _startLoading() {
    const totalSteps = 100;
    var currentStep = 0;

    _timer = Timer.periodic(const Duration(milliseconds: 40), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }

      currentStep++;

      setState(() {
        _progress = currentStep / totalSteps;
      });

      if (currentStep >= totalSteps) {
        timer.cancel();
        _goToMenu();
      }
    });
  }

  void _goToMenu() {
    Future.delayed(const Duration(milliseconds: 300), () {
      if (!mounted) return;

      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (_) => const MenuScreen()));
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final percentage = (_progress * 100).round();

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Imagen completa de la pantalla de carga.
          Image.asset(
            'assets/backgrounds/loading_screen.png',
            fit: BoxFit.cover,
          ),

          // Oscurecimiento muy ligero para mejorar la lectura
          // de los elementos dinámicos.
          Container(color: Colors.black.withValues(alpha: 0.08)),

          // Elementos dinámicos de Flutter.
          SafeArea(
            child: Align(
              alignment: const Alignment(0, 0.62),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 140),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Container(
                        height: 34,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: const Color(0xFF00D9FF),
                            width: 3,
                          ),
                          borderRadius: BorderRadius.circular(9),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 7,
                          vertical: 6,
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: _progress,
                            minHeight: 16,
                            backgroundColor: Colors.transparent,
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              Color(0xFF00D9FF),
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 18),

                    Text(
                      '$percentage%',
                      style: const TextStyle(
                        color: Color(0xFF00D9FF),
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
