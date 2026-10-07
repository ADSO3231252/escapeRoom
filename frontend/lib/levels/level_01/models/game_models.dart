enum Difficulty {
  easy,
  normal,
  hard,
}

extension DifficultyInfo on Difficulty {
  String get label {
    switch (this) {
      case Difficulty.easy:
        return 'FÁCIL';
      case Difficulty.normal:
        return 'NORMAL';
      case Difficulty.hard:
        return 'DIFÍCIL';
    }
  }

  int get minutes {
    switch (this) {
      case Difficulty.easy:
        return 90;
      case Difficulty.normal:
        return 60;
      case Difficulty.hard:
        return 40;
    }
  }

  String get hintsLabel {
    switch (this) {
      case Difficulty.easy:
        return 'Muchas pistas';
      case Difficulty.normal:
        return 'Pistas limitadas';
      case Difficulty.hard:
        return 'Muy pocas pistas';
    }
  }
}

class GameState {
  Difficulty difficulty;
  bool tutorialComplete;
  bool puzzle1Complete;
  bool boxOpened;
  bool key1Obtained;
  bool level1Complete;
  int elapsedSeconds;

  GameState({
    this.difficulty = Difficulty.normal,
    this.tutorialComplete = false,
    this.puzzle1Complete = false,
    this.boxOpened = false,
    this.key1Obtained = false,
    this.level1Complete = false,
    this.elapsedSeconds = 0,
  });

  int get totalSeconds => difficulty.minutes * 60;

  int get remainingSeconds {
    final remaining = totalSeconds - elapsedSeconds;
    return remaining < 0 ? 0 : remaining;
  }

  String get remainingText {
    final seconds = remainingSeconds;
    final h = seconds ~/ 3600;
    final m = (seconds % 3600) ~/ 60;
    final s = seconds % 60;
    if (h > 0) {
      return '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
    }
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  Map<String, dynamic> toMap() => {
        'difficulty': difficulty.index,
        'tutorialComplete': tutorialComplete,
        'puzzle1Complete': puzzle1Complete,
        'boxOpened': boxOpened,
        'key1Obtained': key1Obtained,
        'level1Complete': level1Complete,
        'elapsedSeconds': elapsedSeconds,
      };

  static GameState fromMap(Map<String, dynamic> map) {
    return GameState(
      difficulty: Difficulty.values[(map['difficulty'] as int?) ?? Difficulty.normal.index],
      tutorialComplete: map['tutorialComplete'] == true,
      puzzle1Complete: map['puzzle1Complete'] == true,
      boxOpened: map['boxOpened'] == true,
      key1Obtained: map['key1Obtained'] == true,
      level1Complete: map['level1Complete'] == true,
      elapsedSeconds: (map['elapsedSeconds'] as int?) ?? 0,
    );
  }
}
