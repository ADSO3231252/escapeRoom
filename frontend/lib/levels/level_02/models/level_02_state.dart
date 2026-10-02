/// Enumeración para identificar las puertas disponibles en el puzle 1
enum DoorColor { red, blue, green }

//Manejo del estado centralizado del Nivel 2
class Level02State {
  DoorColor? selectedDoor;
  bool isPuzzle1Solved;
  bool isPuzzle2Solved;
  bool isPuzzle3Solved;
  int currentPuzzleIndex; // 1, 2 o 3

  Level02State({
    this.selectedDoor,
    this.isPuzzle1Solved = false,
    this.isPuzzle2Solved = false,
    this.isPuzzle3Solved = false,
    this.currentPuzzleIndex = 1,
  });

  //Reinicia el estado del primer puzle
  void resetPuzzle1() {
    selectedDoor = null;
    isPuzzle1Solved = false;
  }
}