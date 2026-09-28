class Level {
  final int id;
  final String name;
  final String description;
  final String difficulty;
  final bool locked;

  Level({
    required this.id,
    required this.name,
    required this.description,
    required this.difficulty,
    this.locked = true,
  });
}