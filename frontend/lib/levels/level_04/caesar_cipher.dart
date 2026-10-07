import 'package:flutter/material.dart';

import 'terminal_frame.dart';
import 'terminal_keypad.dart';

/// Level 4 - La Terminal Cifrada. View 4: Caesar cipher (puzzle 2 of 3).
///
/// Shows the coded word NWPC. The player moves each letter two
/// positions back in the alphabet and writes the result: LUNA.
/// - [onSolved] is called when the answer is right.
/// - [onClose] is called when the player taps the X button.
class CaesarCipher extends StatefulWidget {
  const CaesarCipher({super.key, this.onSolved, this.onClose});

  final VoidCallback? onSolved;
  final VoidCallback? onClose;

  @override
  State<CaesarCipher> createState() => _CaesarCipherState();
}

class _CaesarCipherState extends State<CaesarCipher> {
  static const String _coded = 'NWPC';
  static const String _answer = 'LUNA';
  static const int _shift = 2;
  static const _green = Color(0xFF4ADE80);
  static const _yellow = Color(0xFFFACC15);

  // Hints shown one by one each time the player taps the ? button.
  static const List<String> _hints = [
    'PISTA: RETROCEDE DOS POSICIONES',
    'EJEMPLO: C -> B -> A',
    'PRIMERA LETRA: N -> M -> L',
  ];
  int _hint = 0;

  String _typed = '';
  bool _wrong = false;

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
                  _wrong ? 'ACCESS DENIED' : 'MENSAJE CIFRADO · 2/3',
                  style: terminalText(
                    size: 13,
                    color: _wrong ? TerminalColors.redText : TerminalColors.blue,
                  ),
                ),
                const SizedBox(height: 8),

                // One column per letter: coded letter, arrow, answer box.
                Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      for (var i = 0; i < _coded.length; i++)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _CodedBox(letter: _coded[i]),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 4,
                                ),
                                child: Text(
                                  '-$_shift',
                                  style: terminalText(
                                    size: 11,
                                    color: TerminalColors.blue,
                                    spacing: 0,
                                  ),
                                ),
                              ),
                              _LetterBox(
                                letter: i < _typed.length ? _typed[i] : '',
                                wrong: _wrong,
                                okColor: _green,
                              ),
                            ],
                          ),
                        ),
                    ],
                ),
                const SizedBox(height: 10),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: _yellow, width: 2),
                  ),
                  child: Text(
                    _hints[_hint],
                    textAlign: TextAlign.center,
                    style: terminalText(size: 11, color: _yellow),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Box with one letter of the coded word.
class _CodedBox extends StatelessWidget {
  const _CodedBox({required this.letter});

  final String letter;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 34,
      height: 36,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: const Color(0xFF1D3F7A),
        border: Border.all(color: TerminalColors.blue, width: 2),
      ),
      child: Text(letter, style: terminalText(size: 18, spacing: 0)),
    );
  }
}

/// One box of the answer.
class _LetterBox extends StatelessWidget {
  const _LetterBox({
    required this.letter,
    required this.wrong,
    required this.okColor,
  });

  final String letter;
  final bool wrong;
  final Color okColor;

  @override
  Widget build(BuildContext context) {
    final filled = letter.isNotEmpty;
    final color = wrong
        ? TerminalColors.red
        : (filled ? okColor : TerminalColors.dimBlue);
    return Container(
      width: 34,
      height: 36,
      alignment: Alignment.center,
      decoration: BoxDecoration(border: Border.all(color: color, width: 2)),
      child: Text(
        letter,
        style: terminalText(
          size: 18,
          color: wrong ? TerminalColors.redText : okColor,
          spacing: 0,
        ),
      ),
    );
  }
}
