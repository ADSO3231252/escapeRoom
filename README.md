## 🕹️NEXUS-9: Escape Laboratory — [Level 2]

 ![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter) ![Dart](https://img.shields.io/badge/Dart-3.x-0175C2?logo=dart) ![Node.js](https://img.shields.io/badge/Node.js-20%2B-339933?logo=node.js) ![Express](https://img.shields.io/badge/Express.js-REST-000000?logo=express) ![PostgreSQL](https://img.shields.io/badge/PostgreSQL-Database-4169E1?logo=postgresql) ![GitHub](https://img.shields.io/badge/GitHub-Repository-181717?logo=github) ![Jira](https://img.shields.io/badge/Jira-Project-0052CC?logo=jira) ![Figma](https://img.shields.io/badge/Figma-UX%2FUI-F24E1E?logo=figma)

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

The project is initially designed as a **3-level MVP**, prioritizing a playable, clear, and functional experience.

## 🎯 Objective

Develop a 2D educational Escape Room game that allows players to learn and apply basic programming concepts through interactive challenges.

### Specific Objectives

- Design an educational and interactive experience.
- Apply basic programming concepts through puzzles.
- Implement a level system.
- Implement object interaction.
- Implement an inventory, timer, hints, and scoring system.
- Implement victory and defeat conditions.
- Develop a cross-platform application using Flutter.
- Create a REST API using Node.js and Express.
- Use PostgreSQL as the database system.
- Use Git and GitHub for version control.
- Manage the project using Jira.

## 🎮 Game Concept

**Genre:** 2D educational Escape Room.

**Style:** science fiction, technological laboratory, mystery, programming, and logic.

**Interaction:** click/tap, buttons, interactive objects, answer selection, inventory, and panels.

Complex free character movement is not required for the MVP.

## 📖 Story

K-9 wakes up in an unknown laboratory. The lights are off and several alarms begin to sound.

A message appears on a screen:


All doors are locked. K-9 must progress through different areas of the laboratory and solve the security systems to regain control of the facility.

Each area contains a different challenge. After completing all three levels, K-9 will be able to deactivate the containment protocol and escape.

## 🐕 Main Character: K-9

K-9 is a **female Jack Russell Terrier**.

Characteristics:

- Intelligent.
- Curious.
- Brave.
- Resourceful.

K-9 represents the player throughout the entire experience.

## 🕹️ Gameplay

```text
Explore
   ↓
Interact
   ↓
Find clues
   ↓
Solve puzzle
   ↓
Obtain reward
   ↓
Open door
   ↓
Advance to the next level
```

## 🔄 Game Flow

```text
MENU
 ↓
TUTORIAL
 ↓
LEVEL SELECTION
 ↓
LEVEL 1 → puzzle → reward
 ↓
LEVEL 2 → puzzle → reward
 ↓
LEVEL 3 → final puzzle → escape
 ↓
FINAL RESULT
```

# 🧩 Levels

## 🟢 Level 1 — Laboratory

**Difficulty:** Easy  
**Concept:** Sequences and instructions  
**Objective:** Restore power to the laboratory and obtain an access card.

### Objects

- Main computer.
- Maintenance box.
- Electrical panel.
- Locked door.

### Puzzle

```text
1. Conectar energía.
2. Encender computador.
3. Activar sistema.
4. Revisar sistema.
```

**Reward:** Access Card  
**Score:** +100

### Hints

- The computer needs power before it can start.
- You must connect the power first.

## 🟡 Level 2 — Control Room

**Difficulty:** Medium  
**Concept:** If/else conditionals  
**Objective:** Repair the logic system that controls the doors.

```text
if code == 927:
    opendoor()
else:
    keepDoorClosed()
```

**Reward:** Master Code 927  
**Score:** +200

### Hints

- Think about what happens when the condition is true.
- If the code is correct, the door should open.

## 🔴 Level 3 — NEXUS-9 Core

**Difficulty:** Hard  
**Concept:** Logic and patterns  
**Objective:** Deactivate the containment protocol and escape.

### Puzzle 1

```text
2 → 4 → 6 → 8 → ?
```

Answer: **10**

### 🧩 Puzzles and solutions

* **Puzzle 1 — Lights:** red off, blue on, green off. The clue says that the correct door has the light on.
* **Puzzle 2 — Conditions:** Red: \(5 > 10\); Blue: \(10 > 5\); Green: \(2 > 8\). Only the blue condition is true.
* **Puzzle 3 — Code:** 4, 7 and 2 appear. The clue indicates ordering them from lowest to highest: 247.

Answer: **9**

* **Reward:** 🗝️ KEY 2

* **End of level:** When entering 247, "CORRECT LOGIC" appears. Progress is saved and Level 3 opens.

> ⚙️ **Technical responsibility:** Design rules, clues, solutions, difficulty levels and feedback. Clearly document the correct answer for integration.

**Result:** The protocol is deactivated, the emergency door is unlocked, and K-9 escapes.

# ⚙️ Mechanics

- **Interaction:** select objects to obtain information or perform actions.
- **Inventory:** store obtained items.
- **Doors:** locked, unlocked, and opened.
- **Hints:** help the player and reduce the score.
- **Timer:** displays the remaining time for the level.
- **Levels:** completing the current level unlocks the next one.

### 📦 Example inventory

```text
INVENTORY

[Access Card]
[Master Code]
```

# 🏆 Scoring System

| Acción | Puntos |
|---|---:|
| Complete Level 1 | +100 |
| Complete Level 2 | +200 |
| Complete Level 3 | +300 |
| Finish quickly | +100 |
| Complete without hints | +50 |
| Use a hint | -25 |
| Incorrect answer | -10 |

**Base maximum score:** 600 points, before bonuses.

# 🚧 MVP Scope

Includes:

- Main menu.
- Tutorial.
- Level selection.
- Three levels.
- Object interaction.
- Puzzle system.
- Basic inventory.
- Timer.
- Hints.
- Scoring.
- Doors.
- Linear progression.
- Victory and defeat screens.
- Basic backend.
- Database.
- REST API.
- Git/GitHub.
- Documentation.

### Outside the MVP

The following will not be implemented initially:

- Multiplayer.
- Voice chat.
- Advanced online leaderboard.
- Complex AI.
- Advanced physics.
- 3D world.
- Complex animations.
- Advanced account system.
- Complex cloud saving.

# 🔮 Future Improvements

- More levels.
- More characters.
- More puzzles.
- Achievement system.
- Global leaderboard.
- Player profiles.
- Cloud saving.
- Dynamic music.
- Advanced sound effects.
- Animations.
- New laboratory areas.
- New difficulty levels.
- Multiplayer.
- Statistics.

# 🛠️ Technologies

| Area | Technology |
|---|---|
| Frontend | Flutter / Dart |
| Backend | Node.js / Express |
| Database | PostgreSQL |
| API | REST |
| Design | Figma / Canva |
| Management | Jira Software |
| Version control | Git / GitHub |
| API Testing | Postman |
| IDE | Visual Studio Code / Android Studio |

# 🏗️ Architecture

```text
                 ┌──────────────────┐
                 │      User     │
                 └────────┬─────────┘
                          ↓
                 ┌──────────────────┐
                 │ Flutter / Dart   │
                 │    Frontend      │
                 └────────┬─────────┘
                          ↓
                 ┌──────────────────┐
                 │    REST API      │
                 │ Node + Express   │
                 └────────┬─────────┘
                          ↓
                 ┌──────────────────┐
                 │   PostgreSQL     │
                 │    Database      │
                 └──────────────────┘
```

# 📁 Repository Structure

```text
NEXUS-9/
├── frontend/
│   ├── lib/
│   ├── assets/
│   ├── android/
│   ├── ios/
│   ├── web/
│   └── pubspec.yaml
├── backend/
│   ├── controllers/
│   ├── middleware/
│   ├── models/
│   ├── routes/
│   ├── services/
│   ├── config/
│   ├── utils/
│   └── server.js
├── database/
│   ├── scripts/
│   ├── migrations/
│   └── backups/
├── docs/
│   ├── requirements/
│   ├── architecture/
│   ├── diagrams/
│   ├── levels/
│   ├── testing/
│   └── manuals/
├── mockups/
│   ├── menu/
│   ├── tutorial/
│   ├── level-01/
│   ├── level-02/
│   ├── level-03/
│   └── ui-components/
├── README.md
├── .gitignore
└── LICENSE
```

# 📱 Flutter Structure

```text
frontend/
├── lib/
│   ├── screens/
│   │   ├── menu_screen.dart
│   │   ├── tutorial_screen.dart
│   │   ├── level_select_screen.dart
│   │   ├── game_screen.dart
│   │   └── result_screen.dart
│   ├── levels/
│   │   ├── level_01/
│   │   ├── level_02/
│   │   └── level_03/
│   ├── systems/
│   │   ├── game_manager.dart
│   │   ├── level_manager.dart
│   │   ├── puzzle_manager.dart
│   │   ├── timer_manager.dart
│   │   ├── inventory_manager.dart
│   │   ├── score_manager.dart
│   │   └── hint_manager.dart
│   ├── models/
│   │   ├── player.dart
│   │   ├── level.dart
│   │   ├── puzzle.dart
│   │   ├── item.dart
│   │   └── score.dart
│   └── services/
│       ├── api_service.dart
│       ├── score_service.dart
│       └── progress_service.dart
└── assets/
    ├── images/
    ├── backgrounds/
    ├── characters/
    ├── objects/
    ├── buttons/
    ├── icons/
    ├── audio/
    └── fonts/
```

# 👥 Team

## Scrum Master

**Juan Esteban Montoya Marín**

## Backend — 4

**Leader:** Thomas Vargas

- Thomas Vargas
- Daniela Tamayo
- Juan Esteban Villota
- Jhon Almario

## Game Design — 4

**Leader:** Leandro Calvo

- Leandro Calvo
- Juan Felipe Marín
- Sebastián Tapasco
- Samuel Correa

## Gameplay — 4

**Leader:** Michael Isaza

- Michael Isaza
- Santiago Galindo
- Cristians Marmolejo
- Dylan Hernández

## Flutter 1 — 4

**Leader:** Luiyer Gamaiel

- Luiyer Gamaiel
- Karen Herrera
- Jhoan Marín
- Johan Esteban Lemus

## Flutter 2 — 3

**Leader:** Michael Ocampo

- Michael Ocampo
- Julián Valencia
- Sebastián Sánchez

## UX/UI — 4

**Leader:** Joseph Gómez

- Joseph Gómez
- Juan David Vinasco
- Stiven Sánchez
- Samuel León

**Total: 24 members.**

# 👨‍💻 Responsibilities

### Backend

Node.js, Express, PostgreSQL, REST API, users, scores, progress, and integration.

### Game Design

Story, characters, levels, puzzles, objectives, difficulty, hints, rewards, and educational concepts.

### 📄 License

Mechanics, interactions, inventory, puzzles, timer, scoring, doors, and progression.

### Flutter 1

Flutter architecture, menu, tutorial, level selection, GameScreen, Level 1, and UI integration.

### Flutter 2

Levels 2 and 3, navigation, final screen, responsive design, integration, and testing.

### UX/UI

Figma, visual identity, colors, typography, wireframes, mockups, backgrounds, buttons, icons, K-9, objects, and HUD.

### Scrum Master

Scrum, Jira, planning, Daily Scrum, Review, retrospective, tracking, blockers, GitHub, integration, and delivery.

# 📋 Jira

## Epics

```text
EPIC 1 — Design and Planning
EPIC 2 — UX/UI and Assets
EPIC 3 — Core Game Systems
EPIC 4 — Level 1
EPIC 5 — Level 2
EPIC 6 — Level 3
EPIC 7 — Backend and Database
EPIC 8 — Integration
EPIC 9 — Testing and Quality
EPIC 10 — Documentation and Delivery
```

### Example

```text
EPIC — Level 1
  TASK — Design Level 1
    SUBTASK — Define story
    SUBTASK — Define objective
    SUBTASK — Define puzzle
    SUBTASK — Define reward
  TASK — UX/UI Level 1
    SUBTASK — Create background
    SUBTASK — Create objects
    SUBTASK — Create interface
  TASK — Implement Level 1
    SUBTASK — Create scenario
    SUBTASK — Add interactions
    SUBTASK — Add puzzle
    SUBTASK — Add reward
    SUBTASK — Add door
```

# 🌿 Git and GitHub

```text
main
└── develop
    ├── feature/menu
    ├── feature/tutorial
    ├── feature/level-01
    ├── feature/level-02
    ├── feature/level-03
    ├── feature/puzzle-system
    ├── feature/inventory
    ├── feature/timer
    ├── feature/score
    └── feature/backend-api
```

## Workflow

```text
Create branch → develop → test → commit → push
→ Pull Request → review → merge into develop
→ integration → testing → main
```

# 📝 Commit Convention

```bash
flutter pub get
flutter run