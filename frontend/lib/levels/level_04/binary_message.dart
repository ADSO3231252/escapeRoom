import 'package:flutter/material.dart';

import 'terminal_frame.dart';
import 'terminal_keypad.dart';

/// Level 4 - La Terminal Cifrada. View 3: binary message (puzzle 1 of 3).
///
/// Shows four groups of 8 bits. Each group is one letter in ASCII.
/// The player writes the word in the four boxes. The answer is LUNA.
/// - [onSolved] is called when the answer is right.
/// - [onClose] is called when the player taps the X button.
class BinaryMessage extends StatefulWidget {
  const BinaryMessage({super.key, this.onSolved, this.onClose});

  final VoidCallback? onSolved;
  final VoidCallback? onClose;

  @override
  State<BinaryMessage> createState() => _BinaryMessageState();
}

class _BinaryMessageState extends State<BinaryMessage> {
  static const String _answer = 'LUNA';
  static const List<String> _bits = [
    '01001100', // L
    '01010101', // U
    '01001110', // N
    '01000001', // A
  ];
  static const _green = Color(0xFF4ADE80);
  static const _yellow = Color(0xFFFACC15);

  String _typed = '';
  bool _wrong = false;
  // Hints shown one by one each time the player taps the ? button.
  static const List<String> _hints = [
    'CADA 8 BITS = 1 LETRA (ASCII)',
    'A=01000001  B=01000010  C=01000011',
    'SIGUE EN ORDEN: D, E, F... HASTA LA Z',
    'PRIMERA LETRA: 01001100 = L',
  ];
  int _hint = 0;

  /// A key of the terminal was tapped.
  void _onKey(String key) {
    // While the error shows, or with all the boxes full, keys do nothing.
    if (_wrong || _typed.length >= _answer.length) return;
    setState(() => _typed += key);
    if (_typed.length == _answer.length) _check();
  }

  void _onDelete() {
    if (_wrong || _typed.isEmpty) return;
    setState(() => _typed = _typed.substring(0, _typed.length - 1));
  }

  Future<void> _check() async {
    if (_typed == _answer) {
      widget.onSolved?.call();
      return;
    }
    // Wrong answer: boxes turn red and then get cleared.
    setState(() => _wrong = true);
    await Future<void>.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;
    setState(() {
      _typed = '';
      _wrong = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TerminalFrame(
      onClose: widget.onClose,
      onHint: () => setState(() {
        _hint = (_hint + 1) % _hints.length;
      }),
      keypad: TerminalKeypad(
        onKey: _onKey,
        onDelete: _onDelete,
      ),
      child: Stack(
        children: [
          // A little space on the sides so nothing touches the border.
          Positioned(
            left: 10,
            right: 10,
            top: 0,
            bottom: 0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _wrong ? 'ACCESS DENIED' : 'MENSAJE INTERCEPTADO · 1/3',
                  // Smaller text and tight lines so the title stays in one
                  // line and everything fits inside the screen.
                  style: terminalText(
                    size: 12,
                    color: _wrong ? TerminalColors.redText : TerminalColors.blue,
                  ).copyWith(height: 1.1),
                ),
                const SizedBox(height: 6),

                // The binary message, two groups per row.
                for (var row = 0; row < 2; row++)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _bits[row * 2],
                          style: terminalText(
                            size: 19,
                            color: _green,
                          ).copyWith(height: 1.1),
                        ),
                        const SizedBox(width: 22),
                        Text(
                          _bits[row * 2 + 1],
                          style: terminalText(
                            size: 19,
                            color: _green,
                          ).copyWith(height: 1.1),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 6),

                // Answer boxes. They fill up with the keys on the right.
                Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      for (var i = 0; i < _answer.length; i++)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: _LetterBox(
                            letter: i < _typed.length ? _typed[i] : '',
                            wrong: _wrong,
                          ),
                        ),
                    ],
                ),
                const SizedBox(height: 10),

                Text(
                  _hints[_hint],
                  textAlign: TextAlign.center,
                  style: terminalText(
                    size: 11,
                    color: _yellow,
                  ).copyWith(height: 1.2),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// One box of the answer.
class _LetterBox extends StatelessWidget {
  const _LetterBox({required this.letter, required this.wrong});

  final String letter;
  final bool wrong;

  @override
  Widget build(BuildContext context) {
    final color = wrong ? TerminalColors.red : TerminalColors.cyan;
    return Container(
      width: 34,
      height: 40,
      alignment: Alignment.center,
      decoration: BoxDecoration(border: Border.all(color: color, width: 2)),
      child: Text(
        letter,
        style: terminalText(
          size: 20,
          color: wrong ? TerminalColors.redText : TerminalColors.white,
          spacing: 0,
        ),
      ),
    );
  }
}
