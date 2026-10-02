enum DoorColor { red, blue, green }

class Puzzle1Logic {
  static const int correctDoorIndex = 1;
  static const DoorColor correctDoor = DoorColor.blue;

  static bool isCorrect(int doorIndex) => doorIndex == correctDoorIndex;

  static String label(DoorColor color) {
    switch (color) {
      case DoorColor.red:
        return 'ROJA';
      case DoorColor.blue:
        return 'AZUL';
      case DoorColor.green:
        return 'VERDE';
    }
  }
}