enum ConditionColor { red, blue, green }

class Puzzle2Logic {
  static const ConditionColor correctCondition = ConditionColor.blue;

  static const Map<ConditionColor, String> expressions = {
    ConditionColor.red: '5 > 10',
    ConditionColor.blue: '10 > 5',
    ConditionColor.green: '2 > 5',
  };

  static bool isCorrect(ConditionColor selected) {
    return selected == correctCondition;
  }

  static bool evaluate(ConditionColor color) {
    switch (color) {
      case ConditionColor.red:
        return 5 > 10;
      case ConditionColor.blue:
        return 10 > 5;
      case ConditionColor.green:
        return 2 > 5;
    }
  }

  static String label(ConditionColor color) {
    switch (color) {
      case ConditionColor.red:
        return 'ROJO';
      case ConditionColor.blue:
        return 'AZUL';
      case ConditionColor.green:
        return 'VERDE';
    }
  }
}