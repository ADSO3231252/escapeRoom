import 'dart:async';

import 'package:flutter/foundation.dart';

class Level02State extends ChangeNotifier {
  bool puzzle1Solved;
  bool puzzle2Solved;
  bool puzzle3Solved;
  bool key2Obtained;
  bool key2Available;
  int score;
  int mistakes;

  static const int startingSeconds = 90;
  int remainingSeconds;
  Timer? _timer;

  Level02State({
    this.puzzle1Solved = false,
    this.puzzle2Solved = false,
    this.puzzle3Solved = false,
    this.key2Obtained = false,
    this.key2Available = false,
    this.score = 200,
    this.mistakes = 0,
    this.remainingSeconds = startingSeconds,
  });

  bool get levelCompleted =>
      puzzle1Solved && puzzle2Solved && puzzle3Solved && key2Obtained;

  bool get timeExpired => remainingSeconds <= 0;

  double get timeProgress =>
      (remainingSeconds / startingSeconds).clamp(0.0, 1.0).toDouble();

  String get timeText {
    final minutes = remainingSeconds ~/ 60;
    final seconds = remainingSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  void reset() {
    stopTimer();
    puzzle1Solved = false;
    puzzle2Solved = false;
    puzzle3Solved = false;
    key2Obtained = false;
    key2Available = false;
    score = 200;
    mistakes = 0;
    remainingSeconds = startingSeconds;
    startTimer();
    notifyListeners();
  }

  void startTimer() {
    if (_timer != null || timeExpired) return;

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (remainingSeconds <= 1) {
        remainingSeconds = 0;
        _timer?.cancel();
        _timer = null;
      } else {
        remainingSeconds--;
      }
      notifyListeners();
    });
    notifyListeners();
  }

  void stopTimer() {
    _timer?.cancel();
    _timer = null;
  }

  void addTime(int seconds) {
    remainingSeconds = (remainingSeconds + seconds)
        .clamp(0, startingSeconds)
        .toInt();
    notifyListeners();
  }

  void penalizeTime({int seconds = 10}) {
    remainingSeconds = (remainingSeconds - seconds).clamp(0, startingSeconds).toInt();
    notifyListeners();
  }

  void registerMistake({int penalty = 10, int timePenalty = 10}) {
    mistakes++;
    score = (score - penalty).clamp(0, 999999);
    penalizeTime(seconds: timePenalty);
  }

  void completePuzzle({int bonus = 0}) {
    score += bonus;
    notifyListeners();
  }

  @override
  void dispose() {
    stopTimer();
    super.dispose();
  }
}
