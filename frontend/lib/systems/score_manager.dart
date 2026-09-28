class ScoreManager {
  int score = 0;

  void addPoints(int points) {
    score += points;
  }

  void subtractPoints(int points) {
    score -= points;

    if (score < 0) {
      score = 0;
    }
  }

  void reset() {
    score = 0;
  }
}