import 'package:flutter/material.dart';

class Level2Window extends StatelessWidget {
  final String title;
  final Widget child;
  final VoidCallback? onClose;

  const Level2Window({
    super.key,
    required this.title,
    required this.child,
    this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF101318),
        border: Border.all(color: const Color(0xFF596273), width: 1.5),
        boxShadow: const [BoxShadow(color: Colors.black87, blurRadius: 0, spreadRadius: 3)],
      ),
      child: Column(
        children: [
          Container(
            height: 44,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: const BoxDecoration(
              color: Color(0xFF202633),
              border: Border(
                bottom: BorderSide(color: Color(0xFF596273)),
              ),
            ),
            child: Row(
              children: [
                const Icon(Icons.terminal, size: 18, color: Color(0xFF9FE7FF)),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
                if (onClose != null)
                  IconButton(
                    onPressed: onClose,
                    icon: const Icon(Icons.close, size: 18),
                    tooltip: 'Cerrar',
                  ),
              ],
            ),
          ),
          child,
        ],
      ),
    );
  }
}
