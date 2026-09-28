class HintManager {
  int hintsUsed = 0;

  void useHint() {
    hintsUsed++;
  }

  void reset() {
    hintsUsed = 0;
  }
}