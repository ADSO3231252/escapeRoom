# NEXUS-9 — Escape Room — Level 1

Flutter + Dart implementation of Level 1 "The Awakening" (El Despertar), based on the mockups from Document 14 and the K-9 Master Document.

## Game Flow

1. Difficulty selection.
2. Interactive tutorial.
3. Guided Tour.
4. Level 1 — The Awakening.
5. Puzzle 1: Sort instructions in sequence `C → A → B → D`.
6. Puzzle 2: Safe box with code `0004`.
7. Obtain `KEY 1` (LLAVE 1).
8. Unlock the door.
9. `LEVEL 1 COMPLETED` screen.
10. Autosave and state prepared to unlock Level 2.

## Difficulty Levels

- Easy: 90 minutes.
- Normal: 60 minutes.
- Hard: 40 minutes.

According to the source document, the storyline and sequence remain identical across all difficulties, while difficulty settings adjust time limits, hints, and complexity. In this implementation, Level 1 retains the same core puzzles and leaves the hint system ready for future expansion.

## Running the Project

```bash
flutter pub get
flutter run