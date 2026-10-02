import '../models/level_02_state.dart';

/// Estructura del resultado de la validación
class Puzzle1ValidationResult {
  final bool isCorrect;
  final String statusText;
  final String hintMessage;
  final bool canAdvance;

  Puzzle1ValidationResult({
    required this.isCorrect,
    required this.statusText,
    required this.hintMessage,
    required this.canAdvance,
  });
}

/// Lógica de negocio y algoritmos de validación del Puzzle 1
class Puzzle1Logic {
  static const DoorColor targetDoor = DoorColor.blue;

  /// Retorna si el indicador visual de luz de la puerta debe estar encendido
  static bool isLightOn(DoorColor door) {
    return door == targetDoor;
  }

  /// Algoritmo principal de validación de la selección del jugador
  static Puzzle1ValidationResult validateDoorSelection(DoorColor? selectedDoor) {
    // Regla R1: Validar si no se ha seleccionado ninguna puerta
    if (selectedDoor == null) {
      return Puzzle1ValidationResult(
        isCorrect: false,
        statusText: 'SELECCIONA...',
        hintMessage: 'PISTA: LA LUZ ENCENDIDA INDICA LA PUERTA SEGURA',
        canAdvance: false,
      );
    }

    // Regla R2 & R4: Validar si la selección coincide con la puerta segura (Luz encendida)
    if (selectedDoor == targetDoor) {
      return Puzzle1ValidationResult(
        isCorrect: true,
        statusText: 'AZUL SEGURA',
        hintMessage: 'PISTA: LA LUZ ENCENDIDA INDICA LA PUERTA SEGURA',
        canAdvance: true,
      );
    }

    // Regla R3: Manejo de selecciones incorrectas (Puerta Roja o Verde)
    final String doorName = selectedDoor == DoorColor.red ? 'ROJA' : 'VERDE';
    return Puzzle1ValidationResult(
      isCorrect: false,
      statusText: '$doorName INSEGURA',
      hintMessage: 'INCORRECTO: ESA PUERTA NO TIENE LA LUZ ENCENDIDA',
      canAdvance: false,
    );
  }
}