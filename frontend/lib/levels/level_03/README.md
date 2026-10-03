# Level 3 — The Servers

Level 3 of NEXUS-9, built 100% in Dart/Flutter with no image assets: retro
neon style, real-time alerts inside the room, Luna moved with a virtual
joystick, hidden cables in random positions, and a reset panel with plugs.

## How to run it (without touching shared files)

```
flutter pub get
flutter run -t lib/levels/level_03/level3_dev_main.dart
```

Quick test in the browser:

```
flutter run -d chrome -t lib/levels/level_03/level3_dev_main.dart
```

On a phone or emulator the level locks the screen to landscape and hides
the system bars. Rotate the emulator to landscape if needed.

## Level flow

1. **Welcome screen**: level name, short story, objectives and controls.
2. **Room on alarm**: red flashing lights and the "ERROR 404" sign above
   the servers. Luna can already move.
3. **Exploration**: when Luna gets close to a dashed circle, the cable
   appears with its name. The "RECOGER" button collects it.
4. **Note**: "ABRIR" shows the riddle ("ATRAS" goes back to the room).
5. **Reset panel**: with the 3 cables the panel glows. "USAR" opens the
   console: the cables appear in random order, are plugged in by tapping
   them, and are validated with "CONFIRMAR".
6. **System restored**: "CORRECTO" for about 3 seconds, the room turns
   green, Key 3 appears, the exit door opens and progress is saved.
7. **Completion card**: time and failed attempts, with two options:
   - **JUGAR DE NUEVO** resets the level and starts again.
   - **CONTINUAR** hides the card and gives control of Luna back in the
     restored room. The exit door is shown open, but Luna cannot cross it
     yet (see the integration hooks below).

## Controls

| Control | Action |
|---|---|
| Joystick (bottom left) | Moves Luna. She slides along servers and walls instead of getting stuck. |
| Action button (bottom right) | Only appears near something interactive: RECOGER, ABRIR or USAR. |
| ATRAS | Closes the note or the reset panel without losing progress. |

## Files

| File | Purpose | User stories |
|---|---|---|
| `level3_screen.dart` | Main entry widget: landscape lock, layers, action button, messages | HU-01 |
| `level3_controller.dart` | Game logic: movement, collisions, cables, panel, completion | All |
| `level3_data.dart` | Cables, correct sequence, texts | — |
| `level3_theme.dart` | Colors and retro typography | — |
| `services/level3_progress_service.dart` | Local progress saving (`level3_` prefix) | HU-07 |
| `widgets/room_painter.dart` | Room drawing: walls, servers, doors, lights, cables, key | HU-02, HU-03, HU-06 |
| `widgets/luna_painter.dart` | Luna (Jack Russell Terrier), animated | HU-02 |
| `widgets/joystick_widget.dart` | Virtual joystick | HU-02 |
| `widgets/server_room_widget.dart` | Puts together the room, Luna and the neon signs | HU-02 |
| `widgets/neon_banner.dart` | Neon sign alerts | — |
| `widgets/riddle_note_overlay.dart` | The note with the riddle | HU-04 |
| `widgets/reset_panel_overlay.dart` | Reset console | HU-05, HU-06 |
| `widgets/level3_welcome_widget.dart` | Welcome screen | HU-01 |
| `widgets/level3_completion_card.dart` | Final summary with JUGAR DE NUEVO / CONTINUAR | HU-06, HU-08 |
| `widgets/level3_hud.dart` | Status bar (cables, note, time) | — |
| `widgets/retro_button.dart`, `widgets/scanline_overlay.dart` | Visual style | — |
| `level3_dev_main.dart` | Standalone entry point, for testing only | — |

## Independence rules

- Reuses the shared `Item`, `InventoryManager` and `PuzzleManager`.
- Does not modify `GameManager`, `lib/services/progress_service.dart`,
  `main.dart`, `game_screen.dart` or `pubspec.yaml` (no new packages).
- The elapsed time shown in the HUD only counts up and never makes the
  player lose. The game-wide countdown timer is a global system handled
  by the integration team.

## Integration hooks

All marked with `TODO(integration)` in `level3_controller.dart`:

| Method | What the integration team should do |
|---|---|
| `canAccessLevel3()` | Check that Level 2 was completed and Key 2 obtained. Today it always returns `true` so the level can run standalone. |
| `_completeLevel()` | Notify the shared `GameManager` that Level 3 is complete (score and progress). |
| `_onReachedExitDoor()` | Move the player to Level 4. It runs once each time Luna reaches the open exit door, and is empty for now. |

To plug the level into the full game, the shared `GameScreen` should
return `Level3Screen()` when `levelId == 3`.

## Responsive design

The room is drawn on a 1600x760 logical canvas and scaled with `FittedBox`.
The note, the reset panel, the welcome screen and the completion card have
a fixed design size and shrink with `BoxFit.scaleDown`, so they never
overflow. The controls (joystick, action button, HUD) use real screen
coordinates so they always keep a comfortable size for fingers.