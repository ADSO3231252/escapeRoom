import 'package:flutter/material.dart';

import '../logic/puzzle_2_logic.dart';
import '../models/level_02_state.dart';
import '../widgets/pixel_ui.dart';
import 'puzzle_3_screen.dart';

class Puzzle2Screen extends StatefulWidget {
  final Level02State state;
  const Puzzle2Screen({super.key, required this.state});

  @override
  State<Puzzle2Screen> createState() => _Puzzle2ScreenState();
}

class _Puzzle2ScreenState extends State<Puzzle2Screen> {
  ConditionColor? selected;
  bool? result;
  bool validating = false;
  bool _gameOverShown = false;

  void _select(ConditionColor color) {
    if (widget.state.puzzle2Solved || validating) return;
    setState(() {
      selected = color;
      result = null;
    });
  }

  Future<void> _validate() async {
    if (selected == null || widget.state.puzzle2Solved || validating || widget.state.timeExpired) return;
    final answer = selected!;
    final correct = Puzzle2Logic.evaluate(answer);
    setState(() {
      validating = true;
      result = correct;
    });
    await Future<void>.delayed(const Duration(milliseconds: 400));
    if (!mounted) return;
    if (correct) {
      widget.state.puzzle2Solved = true;
      widget.state.completePuzzle(bonus: 50);
    } else {
      widget.state.registerMistake();
    }
    setState(() => validating = false);
  }

  void _next() {
    if (!widget.state.puzzle2Solved) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => Puzzle3Screen(state: widget.state)),
    );
  }

  void _note() {
    showDialog<void>(
      context: context,
      builder: (_) => const _NoteDialog(
        lines: [
          'Una condición verdadera debe cumplirse exactamente como está escrita.',
          'Lee cada comparación antes de elegir.',
          'Selecciona una sola opción y pulsa VERIFICAR.',
          'Una respuesta falsa no abre el siguiente acceso.',
        ],
      ),
    );
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
    return PixelBackground(
      child: Column(
        children: [
          AnimatedBuilder(
            animation: widget.state,
            builder: (context, _) => Container(
              padding: const EdgeInsets.fromLTRB(16, 7, 16, 7),
              decoration: const BoxDecoration(color: Color(0xFF080E17), border: Border(bottom: BorderSide(color: Color(0xFF29435B)))),
              child: Column(
                children: [
                  const Align(alignment: Alignment.centerLeft, child: Text('NEXUS-9 // PUZZLE 02', style: TextStyle(fontFamily: 'monospace', color: Color(0xFF7DD3FC), fontWeight: FontWeight.w900, letterSpacing: 1.5))),
                  const SizedBox(height: 5),
                  Level02TimerBar(remainingSeconds: widget.state.remainingSeconds, progress: widget.state.timeProgress, timeText: widget.state.timeText),
                ],
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 850),
                  child: PixelPanel(
                    child: Padding(
                      padding: const EdgeInsets.all(26),
                      child: Column(
                        children: [
                          const Text(
                            'ENCUENTRA LA CONDICIÓN VERDADERA',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 26,
                              fontFamily: 'monospace',
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1.7,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Solo una de estas comparaciones es verdadera.',
                            style: TextStyle(color: Colors.white54),
                          ),
                          const SizedBox(height: 12),
                          Align(
                            alignment: Alignment.centerRight,
                            child: PixelButton(
                              text: 'NOTA DE LUNA',
                              onPressed: _note,
                            ),
                          ),
                          const SizedBox(height: 22),
                          for (final color in ConditionColor.values)
                            _ConditionButton(
                              color: color,
                              selected: selected == color,
                              result: selected == color ? result : null,
                              enabled: !widget.state.puzzle2Solved && !validating,
                              onTap: () => _select(color),
                            ),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: 270,
                            child: PixelButton(
                              text: validating ? 'VALIDANDO...' : 'VERIFICAR CONDICION',
                              onPressed: selected == null ||
                                      widget.state.puzzle2Solved ||
                                      validating ||
                                      widget.state.timeExpired
                                  ? null
                                  : _validate,
                            ),
                          ),
                          if (result != null) ...[
                            const SizedBox(height: 16),
                            Text(
                              result!
                                  ? 'CONDICIÓN VERDADERA — ACCESO DESBLOQUEADO'
                                  : 'CONDICIÓN FALSA — INTENTA OTRA VEZ',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: result!
                                    ? const Color(0xFF34D399)
                                    : const Color(0xFFEF4444),
                                fontFamily: 'monospace',
                                fontWeight: FontWeight.w900,
                                letterSpacing: 1.2,
                              ),
                            ),
                          ],
                          if (widget.state.puzzle2Solved) ...[
                            const SizedBox(height: 18),
                            PixelButton(
                              text: 'CONTINUAR AL PUZZLE 3',
                              onPressed: _next,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ConditionButton extends StatelessWidget {
  final ConditionColor color;
  final bool selected;
  final bool? result;
  final bool enabled;
  final VoidCallback onTap;

  const _ConditionButton({
    required this.color,
    required this.selected,
    required this.result,
    required this.enabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final accent = color == ConditionColor.red
        ? const Color(0xFFEF4444)
        : color == ConditionColor.blue
            ? const Color(0xFF38BDF8)
            : const Color(0xFF34D399);
    final border = result == true
        ? const Color(0xFF34D399)
        : result == false
            ? const Color(0xFFEF4444)
            : selected
                ? accent
                : const Color(0xFF353B48);

    return InkWell(
      onTap: enabled ? onTap : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
        decoration: BoxDecoration(
          color: selected ? accent.withOpacity(.10) : const Color(0xFF171B23),
          border: Border.all(
            color: border,
            width: selected || result != null ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(width: 14, height: 14, color: accent),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                '${Puzzle2Logic.label(color)}    ${Puzzle2Logic.expressions[color]}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1,
                ),
              ),
            ),
            if (result != null)
              Text(
                result! ? '[OK]' : '[X]',
                style: TextStyle(
                  fontFamily: 'monospace',
                  color: result!
                      ? const Color(0xFF34D399)
                      : const Color(0xFFEF4444),
                  fontWeight: FontWeight.w900,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _NoteDialog extends StatelessWidget {
  final List<String> lines;
  const _NoteDialog({required this.lines});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFF0B111B),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
        side: BorderSide(color: Color(0xFF3B526D), width: 2),
      ),
      title: const Row(
        children: [
          Icon(Icons.sticky_note_2, color: Color(0xFFFACC15)),
          SizedBox(width: 10),
          Expanded(child: Text('NOTA DE LUNA')),
        ],
      ),
      content: SizedBox(
        width: 430,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (final line in lines)
              Padding(
                padding: const EdgeInsets.only(bottom: 9),
                child: Text(
                  '• $line',
                  style: const TextStyle(color: Colors.white70, height: 1.35),
                ),
              ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('CERRAR'),
        ),
      ],
    );
  }
}
