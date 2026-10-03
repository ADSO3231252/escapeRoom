import 'dart:async';
import 'package:flutter/material.dart';
import '../models/game_models.dart';
import '../services/save_service.dart';
import '../widgets/neon_widgets.dart';

class Level1Screen extends StatefulWidget {
  final GameState state;

  const Level1Screen({super.key, required this.state});

  @override
  State<Level1Screen> createState() => _Level1ScreenState();
}

class _Level1ScreenState extends State<Level1Screen> {
  final SaveService save = SaveService();
  Timer? timer;
  bool paused = false;
  bool terminalSolved = false;
  int hintsUsed = 0;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    timer?.cancel();
    timer = Timer.periodic(const Duration(seconds: 1), (_) async {
      if (!mounted || paused || widget.state.level1Complete) return;

      setState(() {
        widget.state.elapsedSeconds++;
      });

      if (widget.state.remainingSeconds <= 0) {
        timer?.cancel();
        await save.save(widget.state);
        if (mounted) _showTimeOut();
        return;
      }

      if (widget.state.elapsedSeconds % 10 == 0) {
        await save.save(widget.state);
      }
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future<void> autosave() => save.save(widget.state);

  void _showTimeOut() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        backgroundColor: panel,
        title: const NeonText('TIEMPO AGOTADO', size: 17, color: danger),
        content: const Text(
          'El protocolo de emergencia ha finalizado la misión.',
          style: TextStyle(color: whiteBlue),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const NeonText('VOLVER AL INICIO', size: 11),
          ),
        ],
      ),
    );
  }

  Future<void> _completeLevel() async {
    widget.state.key1Obtained = true;
    widget.state.level1Complete = true;
    await autosave();

    if (!mounted) return;
    timer?.cancel();

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        backgroundColor: panel,
        title: const NeonText('✓ NIVEL 1 COMPLETADO', size: 18, color: success, align: TextAlign.center),
        content: const Text(
          'La puerta se abre.\n\nLLAVE 1 obtenida.\n\nEl progreso fue guardado y el Nivel 2 queda desbloqueado.',
          textAlign: TextAlign.center,
          style: TextStyle(color: whiteBlue, height: 1.6),
        ),
        actions: [
          Center(
            child: NeonButton(
              label: 'CONTINUAR',
              filled: true,
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
    );

    if (!mounted) return;
    setState(() {});
  }

  Future<void> _openPuzzle1() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (_) => const _OrderPuzzleDialog(),
    );

    if (result == true) {
      setState(() {
        widget.state.puzzle1Complete = true;
      });
      await autosave();

      if (!mounted) return;
      _feedback('PROTOCOLO CORRECTO', 'Orden C → A → B → D aceptado. La caja ya puede ser abierta.');
    }
  }

  Future<void> _openBox() async {
    if (!widget.state.puzzle1Complete) {
      _feedback('CAJA BLOQUEADA', 'Primero debes completar el protocolo de instrucciones de la computadora.');
      return;
    }

    final result = await showDialog<bool>(
      context: context,
      builder: (_) => _CodeDialog(),
    );

    if (result == true) {
      setState(() {
        widget.state.boxOpened = true;
        widget.state.key1Obtained = true;
      });
      await autosave();

      if (!mounted) return;
      _feedback('CAJA ABIERTA', 'LLAVE 1 obtenida. Ahora puedes abrir la puerta del Sector 1.');
    }
  }

  void _interactTerminal() {
    if (!widget.state.puzzle1Complete) {
      _openPuzzle1();
      return;
    }
    _feedback('TERMINAL', terminalSolved ? 'Protocolo ya completado.' : 'Sistema preparado. La secuencia ya fue validada.');
  }

  Future<void> _door() async {
    if (!widget.state.key1Obtained) {
      _feedback('SALIDA BLOQUEADA', 'Necesitas la LLAVE 1 para abrir esta puerta.');
      return;
    }
    await _completeLevel();
  }

  void _feedback(String title, String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: panel,
        title: NeonText(title, size: 16),
        content: Text(message, style: const TextStyle(color: whiteBlue, height: 1.5)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const NeonText('ENTENDIDO', size: 11),
          ),
        ],
      ),
    );
  }

  void _hint() {
    final hints = [
      'Las cuatro instrucciones tienen un orden específico. La solución es C → A → B → D.',
      'La caja pide un código relacionado con la cantidad de instrucciones necesarias.',
      'Hay cuatro instrucciones, por eso el código de la caja es 0004.',
    ];

    final maxHints = widget.state.difficulty == Difficulty.easy
        ? 3
        : widget.state.difficulty == Difficulty.normal
            ? 2
            : 1;

    if (hintsUsed >= maxHints) {
      _feedback('SIN PISTAS DISPONIBLES', 'La dificultad seleccionada limita las pistas de esta partida.');
      return;
    }

    _feedback('PISTA ${hintsUsed + 1}', hints[hintsUsed]);
    setState(() => hintsUsed++);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Column(
          children: [
            _hud(),
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return Stack(
                    children: [
                      Positioned.fill(
                        child: CustomPaint(
                          painter: LaboratoryPainter(
                            puzzleSolved: widget.state.puzzle1Complete,
                            boxOpened: widget.state.boxOpened,
                            keyObtained: widget.state.key1Obtained,
                          ),
                        ),
                      ),
                      _objectButton(
                        left: constraints.maxWidth * .05,
                        top: constraints.maxHeight * .12,
                        width: constraints.maxWidth * .22,
                        height: constraints.maxHeight * .25,
                        label: 'CAMA',
                        icon: Icons.bed,
                        onTap: () => _feedback('CAMA', 'Luna despertó aquí. No parece haber nada más que hacer.'),
                      ),
                      _objectButton(
                        left: constraints.maxWidth * .39,
                        top: constraints.maxHeight * .10,
                        width: constraints.maxWidth * .22,
                        height: constraints.maxHeight * .19,
                        label: 'SERVIDORES',
                        icon: Icons.dns,
                        onTap: () => _feedback('SERVIDORES', 'Los servidores están activos, pero no puedes manipularlos todavía.'),
                      ),
                      _objectButton(
                        left: constraints.maxWidth * .67,
                        top: constraints.maxHeight * .12,
                        width: constraints.maxWidth * .24,
                        height: constraints.maxHeight * .22,
                        label: 'TERMINAL',
                        icon: Icons.desktop_windows,
                        onTap: _interactTerminal,
                      ),
                      _objectButton(
                        left: constraints.maxWidth * .10,
                        top: constraints.maxHeight * .58,
                        width: constraints.maxWidth * .26,
                        height: constraints.maxHeight * .20,
                        label: widget.state.boxOpened ? 'CAJA ABIERTA' : 'CAJA',
                        icon: widget.state.boxOpened ? Icons.inventory_2 : Icons.lock,
                        onTap: _openBox,
                      ),
                      _objectButton(
                        left: constraints.maxWidth * .82,
                        top: constraints.maxHeight * .40,
                        width: constraints.maxWidth * .15,
                        height: constraints.maxHeight * .38,
                        label: 'SALIDA',
                        icon: Icons.door_front_door,
                        onTap: _door,
                        danger: !widget.state.key1Obtained,
                      ),
                      Positioned(
                        left: constraints.maxWidth * .48,
                        top: constraints.maxHeight * .48,
                        child: _luna(),
                      ),
                      Positioned(
                        left: constraints.maxWidth * .43,
                        top: constraints.maxHeight * .33,
                        child: GestureDetector(
                          onTap: () => _feedback('LUNA', 'Luna está lista para escapar de NEXUS-9.'),
                          child: Container(
                            width: 42,
                            height: 42,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: cyan.withOpacity(.08),
                              border: Border.all(color: cyan.withOpacity(.28)),
                              boxShadow: [BoxShadow(color: cyan.withOpacity(.15), blurRadius: 15)],
                            ),
                            child: const Icon(Icons.pets, color: cyan, size: 22),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 10,
                        left: 12,
                        right: 12,
                        child: _inventory(),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _hud() {
    return Container(
      height: 58,
      decoration: BoxDecoration(
        color: const Color(0xFF04111D),
        border: Border(bottom: BorderSide(color: cyan.withOpacity(.18))),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              NeonText('NIVEL 1 — LABORATORIO DE INICIO', size: 10),
              NeonText('OBJETIVO: OBTÉN LA LLAVE 1 Y ESCAPA', size: 8, color: muted),
            ],
          ),
          const Spacer(),
          NeonText(widget.state.remainingText, size: 19, color: whiteBlue, weight: FontWeight.w800),
          const SizedBox(width: 14),
          IconButton(
            tooltip: 'Pista',
            onPressed: _hint,
            icon: const Icon(Icons.lightbulb_outline, color: cyan, size: 19),
          ),
          IconButton(
            tooltip: 'Pausa',
            onPressed: () => setState(() => paused = !paused),
            icon: Icon(paused ? Icons.play_arrow : Icons.pause, color: cyan, size: 19),
          ),
        ],
      ),
    );
  }

  Widget _objectButton({
    required double left,
    required double top,
    required double width,
    required double height,
    required String label,
    required IconData icon,
    required VoidCallback onTap,
    bool danger = false,
  }) {
    return Positioned(
      left: left,
      top: top,
      width: width,
      height: height,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: panel.withOpacity(.48),
            border: Border.all(color: (danger ? dangerColor : cyan).withOpacity(.18)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: danger ? dangerColor : cyan.withOpacity(.7), size: 27),
              const SizedBox(height: 6),
              NeonText(label, size: 8, color: danger ? dangerColor : muted, align: TextAlign.center),
              const SizedBox(height: 5),
              NeonText('E  INTERACTUAR', size: 7, color: muted),
            ],
          ),
        ),
      ),
    );
  }

  Color get dangerColor => danger;

  Widget _luna() {
    return Container(
      width: 58,
      height: 58,
      decoration: BoxDecoration(
        color: cyan.withOpacity(.08),
        shape: BoxShape.circle,
        border: Border.all(color: cyan.withOpacity(.3)),
      ),
      child: const Icon(Icons.pets, color: whiteBlue, size: 30),
    );
  }

  Widget _inventory() {
    return Container(
      height: 58,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: panel.withOpacity(.94),
        border: Border.all(color: cyan.withOpacity(.2)),
      ),
      child: Row(
        children: [
          const NeonText('INVENTARIO', size: 9, color: muted),
          const SizedBox(width: 12),
          _slot(
            widget.state.key1Obtained ? Icons.vpn_key : Icons.lock_outline,
            widget.state.key1Obtained ? 'LLAVE 1' : '—',
          ),
          const Spacer(),
          const NeonText('W A S D  MOVER   •   E  INTERACTUAR', size: 8, color: muted),
        ],
      ),
    );
  }

  Widget _slot(IconData icon, String label) {
    return Row(
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: widget.state.key1Obtained ? cyan.withOpacity(.12) : Colors.black26,
            border: Border.all(color: cyan.withOpacity(.22)),
          ),
          child: Icon(icon, color: widget.state.key1Obtained ? cyan : muted, size: 18),
        ),
        const SizedBox(width: 6),
        NeonText(label, size: 8, color: widget.state.key1Obtained ? cyan : muted),
      ],
    );
  }
}

class LaboratoryPainter extends CustomPainter {
  final bool puzzleSolved;
  final bool boxOpened;
  final bool keyObtained;

  LaboratoryPainter({
    required this.puzzleSolved,
    required this.boxOpened,
    required this.keyObtained,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()..style = PaintingStyle.fill;
    final stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    p.color = const Color(0xFF061525);
    canvas.drawRect(Offset.zero & size, p);

    final grid = Paint()
      ..color = cyan.withOpacity(.045)
      ..strokeWidth = .7;

    const step = 28.0;
    for (double x = 0; x <= size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), grid);
    }
    for (double y = 0; y <= size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), grid);
    }

    stroke.color = cyan.withOpacity(.16);
    canvas.drawRect(
      Rect.fromLTWH(10, 10, size.width - 20, size.height - 20),
      stroke,
    );

    _drawBed(canvas, size);
    _drawServers(canvas, size);
    _drawTerminal(canvas, size);
    _drawBox(canvas, size);
    _drawDoor(canvas, size);

    final circles = [
      Offset(size.width * .40, size.height * .38),
      Offset(size.width * .55, size.height * .60),
    ];
    final ring = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..color = cyan.withOpacity(.18);
    for (final c in circles) {
      canvas.drawCircle(c, 22, ring);
      canvas.drawCircle(c, 12, ring);
    }
  }

  void _drawBed(Canvas canvas, Size s) {
    final r = Rect.fromLTWH(s.width * .06, s.height * .12, s.width * .22, s.height * .20);
    final fill = Paint()..color = const Color(0xFF10273A);
    final line = Paint()
      ..color = cyan.withOpacity(.32)
      ..style = PaintingStyle.stroke;
    canvas.drawRect(r, fill);
    canvas.drawRect(r, line);

    final pillow = Paint()..color = const Color(0xFFE2F6F8).withOpacity(.9);
    canvas.drawRect(
      Rect.fromLTWH(r.left + 10, r.top + 12, r.width * .30, r.height - 24),
      pillow,
    );

    final stripe = Paint()..color = const Color(0xFF8D2E3B);
    canvas.drawRect(
      Rect.fromLTWH(r.left + r.width * .35, r.top, r.width * .08, r.height),
      stripe,
    );
  }

  void _drawServers(Canvas canvas, Size s) {
    final start = Offset(s.width * .38, s.height * .08);
    final paint = Paint()..color = const Color(0xFF091C2D);
    final line = Paint()
      ..color = cyan.withOpacity(.28)
      ..style = PaintingStyle.stroke;

    for (int row = 0; row < 3; row++) {
      for (int col = 0; col < 4; col++) {
        final rect = Rect.fromLTWH(
          start.dx + col * 26,
          start.dy + row * 30,
          20,
          23,
        );
        canvas.drawRect(rect, paint);
        canvas.drawRect(rect, line);
        final led = Paint()..color = cyan.withOpacity(.55);
        canvas.drawCircle(Offset(rect.left + 5, rect.top + 6), 1.5, led);
      }
    }
  }

  void _drawTerminal(Canvas canvas, Size s) {
    final r = Rect.fromLTWH(s.width * .66, s.height * .10, s.width * .27, s.height * .22);
    final fill = Paint()..color = const Color(0xFF091B2C);
    final line = Paint()
      ..color = cyan.withOpacity(.28)
      ..style = PaintingStyle.stroke;
    canvas.drawRect(r, fill);
    canvas.drawRect(r, line);

    final screen = Rect.fromLTWH(r.left + 12, r.top + 12, r.width - 24, r.height * .35);
    canvas.drawRect(screen, line);

    final txt = TextPainter(
      text: TextSpan(
        text: puzzleSolved ? 'READY' : 'PUZZLE',
        style: TextStyle(color: puzzleSolved ? success : cyan, fontSize: 8),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    txt.paint(canvas, Offset(screen.left + 10, screen.top + 8));
  }

  void _drawBox(Canvas canvas, Size s) {
    final r = Rect.fromLTWH(s.width * .10, s.height * .56, s.width * .25, s.height * .18);
    final fill = Paint()..color = const Color(0xFF091B2C);
    final line = Paint()
      ..color = (boxOpened ? success : cyan).withOpacity(.35)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawRRect(RRect.fromRectAndRadius(r, const Radius.circular(3)), fill);
    canvas.drawRRect(RRect.fromRectAndRadius(r, const Radius.circular(3)), line);

    final text = TextPainter(
      text: TextSpan(
        text: boxOpened ? 'OPEN' : '0000',
        style: TextStyle(color: boxOpened ? success : cyan, fontSize: 9),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    text.paint(canvas, Offset(r.center.dx - text.width / 2, r.center.dy - text.height / 2));
  }

  void _drawDoor(Canvas canvas, Size s) {
    final r = Rect.fromLTWH(s.width * .83, s.height * .38, s.width * .13, s.height * .35);
    final fill = Paint()..color = const Color(0xFF30101C);
    final line = Paint()
      ..color = (keyObtained ? success : danger).withOpacity(.75)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawRect(r, fill);
    canvas.drawRect(r, line);

    final tp = TextPainter(
      text: TextSpan(
        text: keyObtained ? 'OPEN' : 'SECTOR 1',
        style: TextStyle(color: keyObtained ? success : danger, fontSize: 8),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, Offset(r.center.dx - tp.width / 2, r.top + 10));
  }

  @override
  bool shouldRepaint(covariant LaboratoryPainter oldDelegate) {
    return oldDelegate.puzzleSolved != puzzleSolved ||
        oldDelegate.boxOpened != boxOpened ||
        oldDelegate.keyObtained != keyObtained;
  }
}

class _OrderPuzzleDialog extends StatefulWidget {
  const _OrderPuzzleDialog();

  @override
  State<_OrderPuzzleDialog> createState() => _OrderPuzzleDialogState();
}

class _OrderPuzzleDialogState extends State<_OrderPuzzleDialog> {
  final items = <String>[
    'A — Abrir sistema',
    'B — Introducir código',
    'C — Encender computadora',
    'D — Presionar botón',
  ];

  void validate() {
    final letters = items.map((e) => e[0]).join();
    if (letters == 'CABD') {
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Orden incorrecto. Revisa las instrucciones.'),
          backgroundColor: Color(0xFF5B1725),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: panel,
      title: const NeonText('TERMINAL — PROTOCOLO', size: 15),
      content: SizedBox(
        width: 420,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Ordena las instrucciones para completar el protocolo.',
              style: TextStyle(color: whiteBlue, fontSize: 12),
            ),
            const SizedBox(height: 14),
            ReorderableListView(
              shrinkWrap: true,
              children: [
                for (final item in items)
                  Container(
                    key: ValueKey(item),
                    margin: const EdgeInsets.only(bottom: 7),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: panel2,
                      border: Border.all(color: cyan.withOpacity(.18)),
                    ),
                    child: Text(item, style: const TextStyle(color: whiteBlue, fontSize: 11)),
                  ),
              ],
              onReorder: (oldIndex, newIndex) {
                setState(() {
                  if (newIndex > oldIndex) newIndex--;
                  final item = items.removeAt(oldIndex);
                  items.insert(newIndex, item);
                });
              },
            ),
            const SizedBox(height: 12),
            const NeonText('SOLUCIÓN DEL DOCUMENTO: C → A → B → D', size: 9, color: muted),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const NeonText('CERRAR', size: 10, color: muted),
        ),
        TextButton(
          onPressed: validate,
          child: const NeonText('VALIDAR', size: 10),
        ),
      ],
    );
  }
}

class _CodeDialog extends StatefulWidget {
  @override
  State<_CodeDialog> createState() => _CodeDialogState();
}

class _CodeDialogState extends State<_CodeDialog> {
  String code = '';

  void press(String value) {
    if (code.length < 4) {
      setState(() => code += value);
    }
  }

  void validate() {
    if (code == '0004') {
      Navigator.pop(context, true);
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Código incorrecto.'),
        backgroundColor: Color(0xFF5B1725),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: panel,
      title: const NeonText('CAJA DE SEGURIDAD — N°01', size: 14),
      content: SizedBox(
        width: 300,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const NeonText('PISTA: NÚMERO DE INSTRUCCIONES', size: 9, color: muted),
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 13),
              decoration: BoxDecoration(
                color: Colors.black26,
                border: Border.all(color: cyan.withOpacity(.25)),
              ),
              child: NeonText(
                code.padRight(4, '—'),
                size: 20,
                align: TextAlign.center,
              ),
            ),
            const SizedBox(height: 14),
            GridView.count(
              shrinkWrap: true,
              crossAxisCount: 3,
              childAspectRatio: 1.5,
              children: [
                for (int i = 1; i <= 9; i++) _key('$i'),
                _key('←', onTap: () {
                  if (code.isNotEmpty) setState(() => code = code.substring(0, code.length - 1));
                }),
                _key('0'),
                _key('OK', onTap: validate),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _key(String value, {VoidCallback? onTap}) {
    return Padding(
      padding: const EdgeInsets.all(3),
      child: OutlinedButton(
        onPressed: onTap ?? () => press(value),
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: cyan.withOpacity(.25)),
        ),
        child: NeonText(value, size: 10),
      ),
    );
  }
}
