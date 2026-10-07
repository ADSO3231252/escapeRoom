import '../../models/item.dart';

/// Static design data for Level 3 ("The Servers").
///
/// Cables are modeled as the shared [Item] class (lib/models/item.dart)
/// instead of a custom class, and "collecting" a cable just means adding
/// it to the shared InventoryManager.
class Level3Data {
  Level3Data._();

  /// Correct order to connect the cables in the reset panel:
  /// Energy (red) -> Data (blue) -> Security (green).
  static const List<String> correctSequence = ['red', 'blue', 'green'];

  /// Maps each cable's id to its color.
  static const Map<int, String> cableColorNames = {
    301: 'red',
    302: 'blue',
    303: 'green',
  };

  /// The three collectible cables of this level.
  static final List<Item> cables = [
    Item(id: 301, name: 'ENERGIA', description: 'Cable rojo de energia.'),
    Item(id: 302, name: 'DATOS', description: 'Cable azul de datos.'),
    Item(id: 303, name: 'SEGURIDAD', description: 'Cable verde de seguridad.'),
  ];

  /// Short description shown on the welcome screen.
  static const String welcomeDescription =
      'Una alarma ha cortado la conexion de los servidores de NEXUS-9. '
      'Guia a Luna por la sala, encuentra los cables perdidos, descifra la '
      'nota y restaura el sistema para conseguir la Llave 3.';

  /// Riddle text found on the note. Gives the correct order by function,
  /// without naming any colors, on purpose.
  static const String riddleText =
      'Primero despierta la chispa que da vida,\n'
      'luego viaja la informacion escondida,\n'
      'y al final se cierra la puerta protegida.';
}
