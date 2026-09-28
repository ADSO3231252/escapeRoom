class GameManager {
  int currentLevel = 1;
  int totalScore = 0;

  bool gameStarted = false;
  bool gameCompleted = false;

  void startGame() {
    gameStarted = true;
    gameCompleted = false;
    currentLevel = 1;
    totalScore = 0;
  }

  void completeLevel(int score) {
    totalScore += score;

    if (currentLevel < 3) {
      currentLevel++;
    } else {
      gameCompleted = true;
    }
  }

  void resetGame() {
    currentLevel = 1;
    totalScore = 0;
    gameStarted = false;
    gameCompleted = false;
  }
}