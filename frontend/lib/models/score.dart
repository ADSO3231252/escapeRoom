class Score {
  final int? id;
  final int playerId;
  final int levelId;
  final int points;

  Score({
    this.id,
    required this.playerId,
    required this.levelId,
    required this.points,
  });
}