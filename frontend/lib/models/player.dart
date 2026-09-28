class Player {
  final int? id;
  final String name;
  final int score;

  Player({
    this.id,
    required this.name,
    this.score = 0,
  });
}