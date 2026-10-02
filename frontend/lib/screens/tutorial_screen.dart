import 'package:flutter/material.dart';

class TutorialScreen extends StatefulWidget {
  const TutorialScreen({super.key});

  @override
  State<TutorialScreen> createState() => _TutorialScreenState();
}

class _TutorialScreenState extends State<TutorialScreen> {
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
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    'assets/backgrounds/tutorial.png',
                    fit: BoxFit.fill,
                  ),

                  // VOLVER
                  Positioned(
                    left: 475 / 1664 * width,
                    top: 735 / 936 * height,
                    width: 250 / 1664 * width,
                    height: 72 / 936 * height,
                    child: _InteractiveArea(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),

                  // COMENZAR
                  Positioned(
                    left: 1015 / 1664 * width,
                    top: 735 / 936 * height,
                    width: 310 / 1664 * width,
                    height: 72 / 936 * height,
                    child: _InteractiveArea(
                      onTap: () {
                        // Próximo paso:
                        // navegar al Level 1.
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
}

class _InteractiveArea extends StatefulWidget {
  final VoidCallback onTap;

  const _InteractiveArea({required this.onTap});

  @override
  State<_InteractiveArea> createState() => _InteractiveAreaState();
}

class _InteractiveAreaState extends State<_InteractiveArea> {
  bool _hovering = false;
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) {
        setState(() {
          _hovering = true;
        });
      },
      onExit: (_) {
        setState(() {
          _hovering = false;
        });
      },
      child: GestureDetector(
        onTapDown: (_) {
          setState(() {
            _pressed = true;
          });
        },
        onTapUp: (_) {
          setState(() {
            _pressed = false;
          });
        },
        onTapCancel: () {
          setState(() {
            _pressed = false;
          });
        },
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          decoration: BoxDecoration(
            color: _pressed
                ? const Color(0xFF00D9FF).withValues(alpha: 0.12)
                : _hovering
                ? const Color(0xFF00D9FF).withValues(alpha: 0.06)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _hovering
                  ? const Color(0xFF00D9FF).withValues(alpha: 0.65)
                  : Colors.transparent,
              width: 2,
            ),
            boxShadow: _hovering
                ? [
                    BoxShadow(
                      color: const Color(0xFF00D9FF).withValues(alpha: 0.40),
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
