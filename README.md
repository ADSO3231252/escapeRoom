# NEXUS-9: Escape Laboratory

## Game Levels Documentation

NEXUS-9: Escape Laboratory is a 2D educational escape-room game developed with Flutter and Dart. Players must explore laboratory environments, solve logic and programming challenges, collect keys, and unlock doors to progress through the game.

## Table of Contents

- [Overview](#overview)
- [Level 1: Starting Laboratory](#level-1-starting-laboratory)
- [Level 2: Control Room](#level-2-control-room)
- [Level 3: Logic Challenges](#level-3-logic-challenges)
- [Level 4: System Access Laboratory](#level-4-system-access-laboratory)
- [Level Progression](#level-progression)
- [Technologies](#technologies)
- [How to Run the Game](#how-to-run-the-game)

## Overview

The game combines exploration, problem-solving, logical reasoning, and educational programming challenges in a futuristic laboratory environment.

Each level introduces challenges that the player must complete to unlock the next stage.

### Main Objectives

- Solve interactive puzzles.
- Apply logical and computational thinking.
- Discover codes and system information.
- Collect keys and unlock doors.
- Complete the available levels in sequence.

## Level 1: Starting Laboratory

**Environment:** Initial laboratory.

**Objective:** Solve the initial challenges, obtain Key 1, and unlock the exit door.

### Challenges

1. **Terminal Puzzle:** Arrange the instructions in the correct order using the sequence `C → A → B → D`.
2. **Maintenance Box:** Enter the access code `0004`.
3. **Key Collection:** Obtain Key 1 after completing the required challenges.
4. **Exit Door:** Use the collected key to complete the level.

### Completion Conditions

The player must solve the terminal puzzle, enter the correct box code, obtain Key 1, and open the exit door.

### Progression

After completing the level, the game displays a completion dialog. Selecting **CONTINUAR** takes the player to Level 2.

## Level 2: Control Room

**Environment:** Laboratory control room.

**Objective:** Solve the level's challenges, obtain Key 2, and unlock the door leading to the next stage.

### Challenges

- Explore the control room and interact with its available elements.
- Solve the logic and programming challenges implemented in the level.
- Complete the required objectives to obtain Key 2.
- Unlock the exit door to continue the adventure.

### Completion Conditions

The player must obtain Key 2 before opening the exit door.

### Progression

When the exit requirements are satisfied, the game proceeds to the Level 3 transition screen.

## Level 3: Logic Challenges

**Environment:** A laboratory area connected to the NEXUS-9 facility.

**Objective:** Complete the level's logic challenges and proceed to Level 4.

### Challenges

- Complete the interactive activities provided by the level.
- Apply logical reasoning to solve the challenges.
- Complete the level objectives and reach the completion state.

### Game States

The level uses a controller to manage its gameplay phases, including:

- Welcome phase.
- Active gameplay.
- Completion phase.

### Progression

Once the level is completed, the player can continue to Level 4.

## Level 4: System Access Laboratory

**Environment:** A restricted laboratory containing security systems and encrypted information.

**Objective:** Solve the security challenges and gain access to the next stage.

### Implemented Challenge Components

The Level 4 implementation includes the following components:

- **Locked Terminal:** An initially restricted terminal.
- **Binary Message:** A challenge involving binary information.
- **Caesar Cipher:** A challenge based on Caesar cipher encoding.
- **Dark Room:** An interactive dark-room challenge.
- **Final Password:** The final password challenge.
- **Access Granted:** The component associated with granting access.

### Completion Conditions

The player must complete the required challenges and obtain access to the restricted system.

### Progression

After access is granted, the game displays a dialog announcing that Level 5 is coming soon. Selecting **ACEPTAR** returns the player to the main menu.

## Level Progression

The intended gameplay sequence is:

1. Main Menu
2. Global Tutorial
3. Level 1 — Starting Laboratory
4. Level 2 — Control Room
5. Level 3 — Logic Challenges
6. Level 4 — System Access Laboratory
7. Level 5 — Coming Soon
8. Return to Main Menu

Players progress through the levels sequentially rather than selecting a level from a level-selection menu during the normal playthrough.

## Technologies

| Technology | Purpose |
|---|---|
| Flutter | Cross-platform application framework |
| Dart | Game implementation language |
| Git | Version control |
| GitHub | Source code hosting and collaboration |
| Visual Studio Code | Development environment |
| Android Studio | Android development and emulator support |

## How to Run the Game

### Prerequisites

- Flutter SDK installed.
- Dart SDK compatible with the project's Flutter version.
- Visual Studio Code or another supported IDE.
- An available browser or configured Android device.

### Installation

Open a terminal in the `frontend` directory.

Download the project dependencies:

```bash
flutter pub get
```

### Run on the Web

```bash
flutter run -d chrome
```

### Run on Android

Check the available devices:

```bash
flutter devices
```

Run the application on a connected Android device or emulator:

```bash
flutter run -d <device-id>
```

Replace `<device-id>` with the identifier returned by `flutter devices`.

### Generate a Release APK

```bash
flutter build apk --release
```

The generated APK is located at:

```text
build/app/outputs/flutter-apk/app-release.apk
```

## Development Notes

- Preserve the existing level-specific implementations when integrating new features.
- Test the navigation between levels after modifying progression logic.
- Verify that keys, puzzles, and exit conditions work correctly.
- Run static analysis after code changes:

```bash
flutter analyze
```

- Run the automated tests:

```bash
flutter test
```

## Future Improvements

- Implement Level 5 and additional laboratory environments.
- Expand the educational programming challenges.
- Improve progress persistence across sessions.
- Add more gameplay feedback and accessibility improvements.
- Expand automated tests for puzzles, level completion, and navigation.

---

**Project:** NEXUS-9: Escape Laboratory  
**Type:** 2D Educational Escape Room  
**Frontend:** Flutter and Dart  
**Status:** Four levels documented; Level 5 announced as coming soon.
