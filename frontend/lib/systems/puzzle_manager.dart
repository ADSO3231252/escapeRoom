class PuzzleManager {
  bool validateAnswer({
    required String userAnswer,
    required String correctAnswer,
  }) {
    return userAnswer.trim().toLowerCase() ==
        correctAnswer.trim().toLowerCase();
  }
}