import 'package:flutter/material.dart';

import '../logic/puzzle_1_logic.dart';

class DoorCard extends StatelessWidget {
  final DoorColor color;
  final VoidCallback onTap;
  final bool enabled;

  const DoorCard({
    super.key,
    required this.color,
    required this.onTap,
    this.enabled = true,
  });

  Color get mainColor {
    switch (color) {
      case DoorColor.red:
        return const Color(0xFFEF4444);
      case DoorColor.blue:
        return const Color(0xFF38BDF8);
      case DoorColor.green:
        return const Color(0xFF34D399);
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: enabled ? onTap : null,
      borderRadius: BorderRadius.circular(8),
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 200),
        opacity: enabled ? 1 : .45,
        child: Container(
          width: 150,
          height: 210,
          decoration: BoxDecoration(
            color: const Color(0xFF171B23),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: mainColor, width: 2),
            boxShadow: [
              BoxShadow(
                color: mainColor.withOpacity(.20),
                blurRadius: 18,
              ),
            ],
          ),
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Container(
                height: 132,
                decoration: BoxDecoration(
                  color: mainColor.withOpacity(.14),
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: mainColor.withOpacity(.65)),
                ),
                child: Center(
                  child: Container(
                    width: 54,
                    height: 76,
                    decoration: BoxDecoration(
                      color: mainColor.withOpacity(.22),
                      border: Border.all(color: mainColor, width: 2),
                      borderRadius: BorderRadius.circular(3),
                    ),
                    child: Icon(Icons.door_front_door, color: mainColor, size: 36),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                Puzzle1Logic.label(color),
                style: TextStyle(
                  color: mainColor,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'PUERTA',
                style: TextStyle(
                  color: Colors.white54,
                  fontSize: 11,
                  letterSpacing: 1.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
