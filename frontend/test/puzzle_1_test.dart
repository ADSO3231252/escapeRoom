import 'package:flutter_test/flutter_test.dart';

// Rutas relativas exactas para tu estructura actual:
import 'package:frontend/levels/level_02/logic/puzzle_1_logic.dart';
import 'package:frontend/levels/level_02/models/level_02_state.dart';
void main() {
  group('KAN-36: Pruebas Algorítmicas de Puzzle 1', () {
    test('R2: La puerta azul debe ser la única identificada con luz encendida', () {
      expect(Puzzle1Logic.isLightOn(DoorColor.blue), isTrue);
      expect(Puzzle1Logic.isLightOn(DoorColor.red), isFalse);
      expect(Puzzle1Logic.isLightOn(DoorColor.green), isFalse);
    });

    test('R1: Debe retornar estado deshabilitado si la selección es nula', () {
      final result = Puzzle1Logic.validateDoorSelection(null);
      expect(result.isCorrect, isFalse);
      expect(result.canAdvance, isFalse);
      expect(result.statusText, 'SELECCIONA...');
    });

    test('R3: Seleccionar puerta Roja o Verde debe fallar la validación', () {
      final resultRed = Puzzle1Logic.validateDoorSelection(DoorColor.red);
      expect(resultRed.isCorrect, isFalse);
      expect(resultRed.canAdvance, isFalse);

      final resultGreen = Puzzle1Logic.validateDoorSelection(DoorColor.green);
      expect(resultGreen.isCorrect, isFalse);
      expect(resultGreen.canAdvance, isFalse);
    });

    test('R4: Seleccionar la puerta Azul valida con éxito y autoriza el avance', () {
      final result = Puzzle1Logic.validateDoorSelection(DoorColor.blue);
      expect(result.isCorrect, isTrue);
      expect(result.canAdvance, isTrue);
      expect(result.statusText, 'AZUL SEGURA');
    });
  });
}