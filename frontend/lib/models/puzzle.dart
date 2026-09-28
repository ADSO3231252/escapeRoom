class Puzzle {
  final int id;
  final int levelId;
  final String question;
  final String answer;
  final String hint;

  Puzzle({
    required this.id,
    required this.levelId,
    required this.question,
    required this.answer,
    required this.hint,
  });
}