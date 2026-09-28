class AppConfig {
  // Información general
  static const String appName = 'NEXUS-9: Escape Laboratory';

  // Configuración de la API
  static const String apiBaseUrl = 'http://localhost:3000/api';

  // Configuración del juego
  static const int totalLevels = 3;

  // Puntuación de los niveles
  static const int level1Score = 100;
  static const int level2Score = 200;
  static const int level3Score = 300;

  // Penalizaciones
  static const int hintPenalty = 25;
  static const int wrongAnswerPenalty = 10;

  // Bonificaciones
  static const int fastCompletionBonus = 100;
  static const int noHintBonus = 50;
}