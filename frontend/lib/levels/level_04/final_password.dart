import 'package:flutter/material.dart';

import 'terminal_frame.dart';
import 'terminal_keypad.dart';

/// Level 4 - La Terminal Cifrada. View 5: final password (puzzle 3 of 3).
///
/// The terminal shows "LUNA + 4". The player writes the password LUNA4.
/// A wrong password shows ACCESS DENIED with the attempt number, the
/// boxes turn red and then get cleared. There is no limit of attempts.
/// - [onSolved] is called when the password is right.
/// - [onClose] is called when the player taps the X button.
class FinalPassword extends StatefulWidget {
  const FinalPassword({super.key, this.onSolved, this.onClose});

  final VoidCallback? onSolved;
  final VoidCallback? onClose;

  @override
  State<FinalPassword> createState() => _FinalPasswordState();
}

class _FinalPasswordState extends State<FinalPassword> {
  static const String _answer = 'LUNA4';
  static const _yellow = Color(0xFFFACC15);

  // Hints shown one by one each time the player taps the ? button.
  static const List<String> _hints = [
    'PISTA: PALABRA + NÚMERO DEL SECTOR',
    'LA PALABRA ES LA DE LOS PUZZLES',
    'ESTÁS EN EL SECTOR 4',
  ];
  int _hint = 0;

  String _typed = '';
  bool _wrong = false;

  // How many wrong passwords the player has sent.
  int _attempts = 0;

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
    // Wrong password: count the attempt, show the error, then clear.
    setState(() {
      _wrong = true;
      _attempts++;
    });
    await Future<void>.delayed(const Duration(milliseconds: 1400));
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
        digits: true,
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
                Text('LUNA + 4', style: terminalText(size: 18, spacing: 3)),
                const SizedBox(height: 12),

                // Password boxes. They fill up with the keys on the right.
                Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      for (var i = 0; i < _answer.length; i++)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: _PasswordBox(
                            letter: i < _typed.length ? _typed[i] : '',
                            wrong: _wrong,
                          ),
                        ),
                      // Red X next to the boxes when the password is wrong.
                      if (_wrong)
                        Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Container(
                            width: 34,
                            height: 34,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: TerminalColors.red,
                                width: 3,
                              ),
                            ),
                            child: Text(
                              'X',
                              style: terminalText(
                                size: 16,
                                color: TerminalColors.red,
                                spacing: 0,
                              ),
                            ),
                          ),
                        ),
                    ],
                ),
                const SizedBox(height: 10),

                // Status line
                Text(
                  _wrong
                      ? 'ACCESS DENIED · INTENTO $_attempts'
                      : 'ENTER PASSWORD · 3/3',
                  style: terminalText(
                    size: 13,
                    color: _wrong ? TerminalColors.redText : TerminalColors.blue,
                  ),
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

/// One box of the password.
class _PasswordBox extends StatelessWidget {
  const _PasswordBox({required this.letter, required this.wrong});

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
