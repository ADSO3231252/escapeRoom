import 'dart:math' as math;

import 'package:flutter/material.dart';

class Keypad extends StatelessWidget {
  final String value;
  final ValueChanged<String> onKey;
  final VoidCallback onClear;
  final VoidCallback onEnter;

  const Keypad({super.key, required this.value, required this.onKey, required this.onClear, required this.onEnter});

  @override
  Widget build(BuildContext context) {
    const keys = ['7','8','9','4','5','6','1','2','3','CLR','0','ENT'];
    return LayoutBuilder(builder: (context, c) {
      final w = math.min(306.0, c.maxWidth);
      return Column(mainAxisSize: MainAxisSize.min, children: [
      Container(
        width: math.min(270.0, w),
        height: 58,
        alignment: Alignment.center,
        decoration: BoxDecoration(color: const Color(0xFF050A10), border: Border.all(color: const Color(0xFF45637E), width: 3), boxShadow: const [BoxShadow(color: Color(0x99000000), offset: Offset(4,4), blurRadius: 0)]),
        child: Text(value.isEmpty ? '---' : value.padRight(3, '_'), style: const TextStyle(fontFamily: 'monospace', fontSize: 27, fontWeight: FontWeight.w900, letterSpacing: 9, color: Color(0xFF74E2FF))),
      ),
      const SizedBox(height: 14),
      SizedBox(width: w, child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: keys.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, mainAxisSpacing: 7, crossAxisSpacing: 7, childAspectRatio: 1.5),
        itemBuilder: (_, i) {
          final key = keys[i];
          return ElevatedButton(
            onPressed: () => key == 'CLR' ? onClear() : key == 'ENT' ? onEnter() : onKey(key),
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF16273A), foregroundColor: Colors.white, elevation: 0, side: const BorderSide(color: Color(0xFF4A6882), width: 2), shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero)),
            child: Text(key, style: const TextStyle(fontFamily: 'monospace', fontWeight: FontWeight.w900)),
          );
        },
      )),
      ]);
    });
  }
}
