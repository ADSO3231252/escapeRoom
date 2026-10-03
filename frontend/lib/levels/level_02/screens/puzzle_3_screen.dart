import 'package:flutter/material.dart';

import '../logic/puzzle_3_logic.dart';
import '../models/level_02_state.dart';
import '../widgets/keypad.dart';
import '../widgets/pixel_ui.dart';
import 'level_02_screen.dart';

class Puzzle3Screen extends StatefulWidget {
  final Level02State state;

  const Puzzle3Screen({super.key, required this.state});

  @override
  State<Puzzle3Screen> createState() => _Puzzle3ScreenState();
}

class _Puzzle3ScreenState extends State<Puzzle3Screen> {
  String code = '';
  bool? result;
  bool _gameOverShown = false;

  void _addKey(String key) {
    if (code.length >= 3 || widget.state.timeExpired) return;
    setState(() {
      code += key;
      result = null;
    });
  }

  void _clear() {
    setState(() {
      code = '';
      result = null;
    });
  }

  void _showNote(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (_) => const _NoteDialog(
        title: 'NOTA DE LUNA // PISTA 03',
        lines: [
          'La consola recibió una secuencia de tres números.',
          'Reordena los números de menor a mayor.',
          'Escribe la nueva secuencia en el teclado y pulsa ENTER.',
        ],
      ),
    );
  }

  void _enter() {
    if (code.length != 3 || widget.state.timeExpired) return;

    final correct = Puzzle3Logic.isCorrect(code);

    setState(() {
      result = correct;
    });

    if (correct) {
      widget.state.stopTimer();
      widget.state.puzzle3Solved = true;
      // Al resolver el último puzzle, la KEY 2 aparece físicamente en la mesa.
      // El jugador todavía debe volver a la sala y pulsar COJER KEY 2.
      widget.state.key2Available = true;
      widget.state.key2Obtained = false;
      widget.state.notifyListeners();
      widget.state.completePuzzle(bonus: 100);

      Future.delayed(const Duration(milliseconds: 500), () {
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => Level02Screen.withState(state: widget.state),
          ),
        );
      });
    } else {
      widget.state.registerMistake();
    }
  }

  void _checkGameOver() {
    if (!mounted || !widget.state.timeExpired || _gameOverShown) return;
    _gameOverShown = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        showLevel02GameOver(context, widget.state, replaceWithLevel: true);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    widget.state.addListener(_checkGameOver);
  }

  @override
  void dispose() {
    widget.state.removeListener(_checkGameOver);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PixelBackground(child: Column(children: [
      AnimatedBuilder(
        animation: widget.state,
        builder: (context, _) => Container(
          padding: const EdgeInsets.fromLTRB(16, 7, 16, 7),
          decoration: const BoxDecoration(color: Color(0xFF080E17), border: Border(bottom: BorderSide(color: Color(0xFF29435B)))),
          child: Column(children: [
            const Align(alignment: Alignment.centerLeft, child: Text('NEXUS-9 // PUZZLE 03', style: TextStyle(fontFamily: 'monospace', color: Color(0xFF7DD3FC), fontWeight: FontWeight.w900, letterSpacing: 1.5))),
            const SizedBox(height: 5),
            Level02TimerBar(remainingSeconds: widget.state.remainingSeconds, progress: widget.state.timeProgress, timeText: widget.state.timeText),
          ]),
        ),
      ),
      Expanded(
        child: Center(
          child: SingleChildScrollView(
          padding: const EdgeInsets.all(12),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 760),
            child: PixelPanel(child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Text(
                      'REORDENA LOS NÚMEROS',
                      style: TextStyle(
                        fontSize: 27,
                        fontFamily: 'monospace',
                    fontWeight: FontWeight.w900,
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Align(
                      alignment: Alignment.centerRight,
                      child: SizedBox(
                        width: 180,
                        child: PixelButton(
                          text: 'NOTA DE LUNA',
                          onPressed: () => _showNote(context),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF07101B),
                        border: Border.all(color: const Color(0xFF33445E)),
                      ),
                      child: const Text(
                        'SECUENCIA RECIBIDA:  472',
                        style: TextStyle(color: Color(0xFF55D6FF), fontFamily: 'monospace',
                    fontWeight: FontWeight.w900, letterSpacing: 2),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Keypad(
                      value: code,
                      onKey: _addKey,
                      onClear: _clear,
                      onEnter: _enter,
                    ),
                    const SizedBox(height: 20),
                    if (result != null)
                      Text(
                        result! ? 'CORRECT LOGIC' : 'INCORRECT CODE',
                        style: TextStyle(
                          color: result!
                              ? const Color(0xFF34D399)
                              : const Color(0xFFEF4444),
                          fontFamily: 'monospace',
                    fontWeight: FontWeight.w900,
                          fontSize: 18,
                          letterSpacing: 2,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      ),
    ]));
  }
}


class _NoteDialog extends StatelessWidget {
  final String title;
  final List<String> lines;
  const _NoteDialog({required this.title, required this.lines});
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFF0B111B),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4), side: const BorderSide(color: Color(0xFF3B526D))),
      title: Row(children: const [Icon(Icons.sticky_note_2, color: Color(0xFFFACC15)), SizedBox(width: 10), Expanded(child: Text('NOTA DE LUNA'))]),
      content: SizedBox(width: 430, child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: const TextStyle(color: Color(0xFF55D6FF), fontFamily: 'monospace',
                    fontWeight: FontWeight.w900, letterSpacing: 1)),
        const SizedBox(height: 14),
        for (final line in lines) Padding(padding: const EdgeInsets.only(bottom: 9), child: Text('• $line', style: const TextStyle(color: Colors.white70, height: 1.35))),
      ])),
      actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('CERRAR'))],
    );
  }
}
