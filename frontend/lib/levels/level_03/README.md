# Level 3 — The Servers

Nivel 3 completo, 100% en Dart/Flutter (sin imágenes): estilo retro neón,
alertas en tiempo real dentro de la sala, Luna animada con joystick,
cables ocultos en posiciones aleatorias y panel de reinicio con enchufes.

## Cómo probarlo SIN tocar archivos compartidos

```
flutter pub get
flutter run -t lib/levels/level_03/level3_dev_main.dart
```

Prueba rápida en Chrome:

```
flutter run -d chrome -t lib/levels/level_03/level3_dev_main.dart
```

En el emulador, gíralo a horizontal (el nivel bloquea la orientación y
oculta las barras del sistema).

## Flujo

1. **Bienvenida**: nombre del nivel, historia, objetivos y controles.
2. **Sala en alarma**: luces rojas parpadeando y el aviso "ERROR 404"
   encima de los servidores. Luna ya se puede mover.
3. **Exploración**: al acercarse a un círculo punteado aparece el cable con
   su nombre; el botón "RECOGER" lo guarda.
4. **Nota**: "ABRIR" muestra el acertijo (botón "ATRAS" para volver).
5. **Panel**: con los 3 cables el panel brilla. "USAR" abre la consola: los
   cables salen en orden aleatorio; se tocan para enchufarlos y se confirma.
6. **Restaurado**: "CORRECTO" ~3 s, la sala pasa a verde, aparece la Llave 3,
   se abre la puerta de salida, se guarda el progreso y sale el resumen.

## Archivos

| Archivo | Qué hace | HU |
|---|---|---|
| `level3_screen.dart` | Orquesta las capas, orientación horizontal, botón de acción, avisos | HU-01 |
| `level3_controller.dart` | Lógica: movimiento, colisiones, cables, panel, finalización | Todas |
| `level3_data.dart` | Cables, secuencia correcta, textos | — |
| `level3_theme.dart` | Colores y tipografía retro | — |
| `services/level3_progress_service.dart` | Guardado local (prefijo `level3_`) | HU-07 |
| `widgets/room_painter.dart` | Dibujo de la sala, luces, puertas, cables, llave | HU-02, HU-03, HU-06 |
| `widgets/luna_painter.dart` | Luna (Jack Russell) animada | HU-02 |
| `widgets/joystick_widget.dart` | Joystick virtual | HU-02 |
| `widgets/server_room_widget.dart` | Une la sala, Luna y los avisos neón | HU-02 |
| `widgets/neon_banner.dart` | Avisos tipo letrero neón | — |
| `widgets/riddle_note_overlay.dart` | La nota con el acertijo | HU-04 |
| `widgets/reset_panel_overlay.dart` | Consola de reinicio | HU-05, HU-06 |
| `widgets/level3_welcome_widget.dart` | Pantalla de bienvenida | HU-01 |
| `widgets/level3_completion_card.dart` | Resumen final | HU-06, HU-08 |
| `widgets/level3_hud.dart` | Barra de estado (cables, nota, tiempo) | — |
| `widgets/retro_button.dart`, `widgets/scanline_overlay.dart` | Estilo visual | — |
| `level3_dev_main.dart` | Solo para pruebas | — |

## Reglas de independencia

- Reutiliza `Item`, `InventoryManager` y `PuzzleManager` del proyecto.
- No toca `GameManager`, `lib/services/progress_service.dart`, `main.dart`
  ni `pubspec.yaml` (no agrega paquetes nuevos).
- `TODO(integration)` en `level3_controller.dart`: `canAccessLevel3()`
  (acceso desde el Nivel 2) y `_completeLevel()` (desbloqueo del Nivel 4).

## Responsive

La sala se dibuja en un lienzo lógico de 1600x760 y se escala con
`FittedBox`. La nota, el panel, la bienvenida y el resumen tienen tamaño de
diseño fijo y se reducen con `BoxFit.scaleDown`, así nunca se desbordan.
Los controles (joystick, botón, HUD) están en coordenadas de pantalla para
mantener siempre un tamaño cómodo para el dedo.
