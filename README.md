## 🕹️NEXUS-9: Escape Laboratory — [Level 2]

 ![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter) ![Dart](https://img.shields.io/badge/Dart-3.x-0175C2?logo=dart) ![Node.js](https://img.shields.io/badge/Node.js-20%2B-339933?logo=node.js) ![Express](https://img.shields.io/badge/Express.js-REST-000000?logo=express) ![PostgreSQL](https://img.shields.io/badge/PostgreSQL-Database-4169E1?logo=postgresql) ![GitHub](https://img.shields.io/badge/GitHub-Repository-181717?logo=github) ![Jira](https://img.shields.io/badge/Jira-Project-0052CC?logo=jira) ![Figma](https://img.shields.io/badge/Figma-UX%2FUI-F24E1E?logo=figma)

> **Academic project** — SENA ADSO / Centro de Diseño Tecnológico e Innovación

* **Members:** 
  * [Juan Felipe Marin Restrepo] (Scrum Master)
  * [Dylan Yesid Cardona Posada]
  * [Juan David Vinasco Perez]
  * [Karen Daniela Tamayo]


### 🎰 Game concept

**Gender:** Escape Room educativo 2D.

**Style:** science fiction, technological laboratory, mystery, programming and logic.

**Interaction:** click/tap, buttons, interactive objects, response selection, inventory and panels.

No complex character free movement is required for the MVP.

### 📌 Description of Level 2

**Level 2• The Logic Room** represents the second area of the escape room MVP, where the protagonist K-9 enters a circular room with three doors (red, blue and green) and a screen that announces: "ONLY ONE DOOR IS SAFE ". 

To advance, the player must explore the environment, interact with indicator lights, a conditions panel, and a numeric keypad to solve logic-based and conditional puzzles.

### 🎯 Level Objective

Overcome logical room challenges to crack the correct code, unlock the secure door and get the **2** Key.

### Level-specific objectives:
* **Analyze clues:** Identify the state of the lights in the lighting puzzle.
* **Evaluate conditions:** Solve logical operations (such as \(5 > 10\), \(10 > 5\), \(2 > 8\)).
* **Sort sequences:** Organize the digits obtained from smallest to largest to obtain the numerical key (247).
* **System validation:** Correctly enter the code to activate the "CORRECT LOGIC" response, save the progress and enable the pass to Level 3.


### 🦮 Main character: K-9

K-9 is a female **Jack Russell Terrier**.

Features:

- Smart.
- Curious.
- Brave.
- Resolute.

K-9 represents the player throughout the experience.


### 🎮 Gameplay

```text
Explore
   ↓
Interact
   ↓
Find clues
   ↓
Solve puzzle
   ↓
Get reward
   ↓
Open door
   ↓
Advance level
```


### 🚪 Level 2 • The Logic Room

* **History:** Luna enters a circular room with three doors: red, blue and green. A screen announces: "ONLY ONE DOOR IS SECURE".
* **Goal:** Solve the logic puzzles and get Key 2.
* **Objects and elements:** Three doors, colored lights, conditions panel, numbers and keyboard.
  

### ◽ Level 2 — Control Room

**Difficulty:** Medium  
**Concept:** If/else conditionals  
**Objective:** Repair the logical system that controls the doors.

```text
if code == 927:
    opendoor()
else:
    keepDoorClosed()
```


### 🧩 Puzzles and solutions

* **Puzzle 1 — Lights:** red off, blue on, green off. The clue says that the correct door has the light on.
* **Puzzle 2 — Conditions:** Red: \(5 > 10\); Blue: \(10 > 5\); Green: \(2 > 8\). Only the blue condition is true.
* **Puzzle 3 — Code:** 4, 7 and 2 appear. The clue indicates ordering them from lowest to highest: 247.


* **Reward:** 🗝️ KEY 2

* **End of level:** When entering 247, "CORRECT LOGIC" appears. Progress is saved and Level 3 opens.

> ⚙️ **Technical responsibility:** Design rules, clues, solutions, difficulty levels and feedback. Clearly document the correct answer for integration.


### ⚙️ Mechanics

- **Interaction:** select objects to obtain information or execute actions.
- **Inventory:** store obtained objects.
- **Doors:** locked, unlocked and open.
- **Tracks:** help the player and reduce score.
- **Timer:** shows the remaining time of the level.
- **Levels:** completing the current level unlocks the next one.

### 📦 Example inventory

```text
INVENTORY

[Access Card]
[Master Code]
```

### 🛠️ Technologies

| Area | Technology |
|---|---|
| Frontend | Flutter / Dart |
| Backend | Node.js /Express |
| Database | PostgreSQL |
| API | REST |
| Design | Figma /Canva |
| Management | Jira Software |
| Version control | Git /GitHub |
| API testing | Postman |
| IDE | Visual Studio Code /Android Studio |


### 📄 License

Project developed for academic purposes for the program:

**Software Analysis and Development — ADSO**  
**SENA — Center for Technological Design and Innovation**

---
