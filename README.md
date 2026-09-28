# 🧪 NEXUS-9: Escape Laboratory

![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter) ![Dart](https://img.shields.io/badge/Dart-3.x-0175C2?logo=dart) ![Node.js](https://img.shields.io/badge/Node.js-20%2B-339933?logo=node.js) ![Express](https://img.shields.io/badge/Express.js-REST-000000?logo=express) ![PostgreSQL](https://img.shields.io/badge/PostgreSQL-Database-4169E1?logo=postgresql) ![GitHub](https://img.shields.io/badge/GitHub-Repository-181717?logo=github) ![Jira](https://img.shields.io/badge/Jira-Project-0052CC?logo=jira) ![Figma](https://img.shields.io/badge/Figma-UX%2FUI-F24E1E?logo=figma)

> **Proyecto académico — SENA ADSO / Centro de Diseño Tecnológico e Innovación**

---

## 📌 Descripción

**NEXUS-9: Escape Laboratory** es un videojuego educativo 2D de tipo **Escape Room**, desarrollado como proyecto académico para el programa **Análisis y Desarrollo de Software (ADSO) del SENA**.

El jugador controla a **K-9**, una perrita Jack Russell Terrier que despierta atrapada dentro de un laboratorio de alta tecnología. Para escapar deberá explorar diferentes zonas, interactuar con objetos y resolver retos relacionados con secuencias, instrucciones, condicionales, lógica y patrones.

El proyecto está diseñado inicialmente como un **MVP de 3 niveles**, priorizando una experiencia jugable, clara y funcional.

## 🎯 Objetivo

Desarrollar un videojuego educativo 2D de tipo Escape Room que permita al jugador aprender y aplicar conceptos básicos de programación mediante retos interactivos.

### Objetivos específicos

- Diseñar una experiencia educativa e interactiva.
- Aplicar conceptos básicos de programación mediante puzzles.
- Implementar un sistema de niveles.
- Implementar interacción con objetos.
- Implementar inventario, temporizador, pistas y puntuación.
- Implementar condiciones de victoria y derrota.
- Desarrollar una aplicación multiplataforma mediante Flutter.
- Crear una API REST mediante Node.js y Express.
- Utilizar PostgreSQL como sistema de base de datos.
- Aplicar Git y GitHub para control de versiones.
- Gestionar el proyecto mediante Jira.

## 🎮 Concepto del juego

**Género:** Escape Room educativo 2D.

**Estilo:** ciencia ficción, laboratorio tecnológico, misterio, programación y lógica.

**Interacción:** click/tap, botones, objetos interactivos, selección de respuestas, inventario y paneles.

No se requiere movimiento libre complejo del personaje para el MVP.

## 📖 Historia

K-9 despierta en un laboratorio desconocido. Las luces están apagadas y varias alarmas comienzan a sonar.

En una pantalla aparece:

> **NEXUS-9 CONTAINMENT PROTOCOL ACTIVATED**

Todas las puertas están bloqueadas. K-9 deberá avanzar por diferentes zonas del laboratorio y resolver los sistemas de seguridad para recuperar el control del lugar.

Cada zona contiene un reto diferente. Al completar los tres niveles, K-9 podrá desactivar el protocolo de contención y escapar.

## 🐕 Personaje principal: K-9

K-9 es una **Jack Russell Terrier hembra**.

Características:

- Inteligente.
- Curiosa.
- Valiente.
- Resolutiva.

K-9 representa al jugador durante toda la experiencia.

## 🕹️ Gameplay

```text
Explorar
   ↓
Interactuar
   ↓
Encontrar pistas
   ↓
Resolver puzzle
   ↓
Obtener recompensa
   ↓
Abrir puerta
   ↓
Avanzar de nivel
```

## 🔄 Flujo del juego

```text
MENÚ
 ↓
TUTORIAL
 ↓
SELECCIÓN DE NIVEL
 ↓
NIVEL 1 → puzzle → recompensa
 ↓
NIVEL 2 → puzzle → recompensa
 ↓
NIVEL 3 → puzzle final → escape
 ↓
RESULTADO FINAL
```

# 🧩 Niveles

## 🟢 Nivel 1 — Laboratory

**Dificultad:** Fácil  
**Concepto:** Secuencias e instrucciones  
**Objetivo:** Restaurar la energía del laboratorio y conseguir una tarjeta de acceso.

### Objetos

- Computador principal.
- Caja de mantenimiento.
- Panel eléctrico.
- Puerta bloqueada.

### Puzzle

```text
1. Conectar energía.
2. Encender computador.
3. Activar sistema.
4. Revisar sistema.
```

**Recompensa:** Access Card  
**Puntuación:** +100

### Pistas

- El computador necesita energía antes de iniciar.
- Primero debes conectar la energía.

## 🟡 Nivel 2 — Control Room

**Dificultad:** Media  
**Concepto:** Condicionales if/else  
**Objetivo:** Reparar el sistema lógico que controla las puertas.

```text
if code == 927:
    openDoor()
else:
    keepDoorClosed()
```

**Recompensa:** Master Code 927  
**Puntuación:** +200

### Pistas

- Piensa qué ocurre cuando la condición es verdadera.
- Si el código es correcto, la puerta debe abrirse.

## 🔴 Nivel 3 — NEXUS-9 Core

**Dificultad:** Difícil  
**Concepto:** Lógica y patrones  
**Objetivo:** Desactivar el protocolo de contención y escapar.

### Puzzle 1

```text
2 → 4 → 6 → 8 → ?
```

Respuesta: **10**

### Puzzle 2

```text
1 → 3 → 5 → 7 → ?
```

Respuesta: **9**

### Código final

```text
9 - 2 - 7
```

**Puntuación:** +300

**Resultado:** El protocolo se desactiva, la puerta de emergencia se desbloquea y K-9 escapa.

# ⚙️ Mecánicas

- **Interacción:** seleccionar objetos para obtener información o ejecutar acciones.
- **Inventario:** almacenar objetos obtenidos.
- **Puertas:** bloqueadas, desbloqueadas y abiertas.
- **Pistas:** ayudan al jugador y reducen puntuación.
- **Temporizador:** muestra el tiempo restante del nivel.
- **Niveles:** completar el nivel actual desbloquea el siguiente.

## 📦 Inventario de ejemplo

```text
INVENTARIO

[Access Card]
[Master Code]
```

# 🏆 Sistema de puntuación

| Acción | Puntos |
|---|---:|
| Completar Nivel 1 | +100 |
| Completar Nivel 2 | +200 |
| Completar Nivel 3 | +300 |
| Finalizar rápidamente | +100 |
| Completar sin pistas | +50 |
| Usar una pista | -25 |
| Respuesta incorrecta | -10 |

**Puntuación máxima base:** 600 puntos, antes de bonificaciones.

# 🚧 Alcance del MVP

Incluye:

- Menú principal.
- Tutorial.
- Selección de nivel.
- Tres niveles.
- Interacción con objetos.
- Sistema de puzzles.
- Inventario básico.
- Temporizador.
- Pistas.
- Puntuación.
- Puertas.
- Progresión lineal.
- Pantallas de victoria y derrota.
- Backend básico.
- Base de datos.
- API REST.
- Git/GitHub.
- Documentación.

### Fuera del MVP

No se implementará inicialmente:

- Multiplayer.
- Chat de voz.
- Ranking online avanzado.
- IA compleja.
- Física avanzada.
- Mundo 3D.
- Animaciones complejas.
- Sistema de cuentas avanzado.
- Guardado en la nube complejo.

# 🔮 Mejoras futuras

- Más niveles.
- Más personajes.
- Más puzzles.
- Sistema de logros.
- Ranking global.
- Perfiles de jugador.
- Guardado en la nube.
- Música dinámica.
- Efectos de sonido avanzados.
- Animaciones.
- Nuevas zonas del laboratorio.
- Nuevas dificultades.
- Multiplayer.
- Estadísticas.

# 🛠️ Tecnologías

| Área | Tecnología |
|---|---|
| Frontend | Flutter / Dart |
| Backend | Node.js / Express |
| Base de datos | PostgreSQL |
| API | REST |
| Diseño | Figma / Canva |
| Gestión | Jira Software |
| Control de versiones | Git / GitHub |
| Pruebas API | Postman |
| IDE | Visual Studio Code / Android Studio |

# 🏗️ Arquitectura

```text
                 ┌──────────────────┐
                 │      Usuario     │
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

# 📁 Estructura del repositorio

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

# 📱 Estructura Flutter

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

# 👥 Equipo

## Scrum Master

**Juan Esteban Montoya Marín**

## Backend — 4

**Líder:** Thomas Vargas

- Thomas Vargas
- Daniela Tamayo
- Juan Esteban Villota
- Jhon Almario

## Game Design — 4

**Líder:** Leandro Calvo

- Leandro Calvo
- Juan Felipe Marín
- Sebastián Tapasco
- Samuel Correa

## Gameplay — 4

**Líder:** Michael Isaza

- Michael Isaza
- Santiago Galindo
- Cristians Marmolejo
- Dylan Hernández

## Flutter 1 — 4

**Líder:** Luiyer Gamaiel

- Luiyer Gamaiel
- Karen Herrera
- Jhoan Marín
- Johan Esteban Lemus

## Flutter 2 — 3

**Líder:** Michael Ocampo

- Michael Ocampo
- Julián Valencia
- Sebastián Sánchez

## UX/UI — 4

**Líder:** Joseph Gómez

- Joseph Gómez
- Juan David Vinasco
- Stiven Sánchez
- Samuel León

**Total: 24 integrantes.**

# 👨‍💻 Responsabilidades

### Backend

Node.js, Express, PostgreSQL, REST API, usuarios, puntuaciones, progreso e integración.

### Game Design

Historia, personajes, niveles, puzzles, objetivos, dificultad, pistas, recompensas y conceptos educativos.

### Gameplay

Mecánicas, interacciones, inventario, puzzles, temporizador, puntuación, puertas y progresión.

### Flutter 1

Arquitectura Flutter, menú, tutorial, selección de niveles, GameScreen, Nivel 1 e integración UI.

### Flutter 2

Niveles 2 y 3, navegación, pantalla final, responsive, integración y pruebas.

### UX/UI

Figma, identidad visual, colores, tipografía, wireframes, mockups, fondos, botones, iconos, K-9, objetos y HUD.

### Scrum Master

Scrum, Jira, planificación, Daily Scrum, Review, retrospectiva, seguimiento, bloqueos, GitHub, integración y entrega.

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

### Ejemplo

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

# 🌿 Git y GitHub

```text
main
│
└── develop
    │
    ├── team/backend
    │   ├── feature/backend-auth
    │   ├── feature/backend-api
    │   ├── feature/backend-database
    │   └── feature/backend-scores
    │
    ├── team/game-design
    │   ├── feature/story
    │   ├── feature/level-01
    │   ├── feature/level-02
    │   └── feature/level-03
    │
    ├── team/gameplay
    │   ├── feature/puzzle-system
    │   ├── feature/inventory
    │   ├── feature/timer
    │   └── feature/score
    │
    ├── team/flutter-1
    │   ├── feature/menu
    │   ├── feature/tutorial
    │   ├── feature/level-01-ui
    │   └── feature/navigation
    │
    ├── team/flutter-2
    │   ├── feature/level-02
    │   ├── feature/level-03
    │   ├── feature/result-screen
    │   └── feature/responsive
    │
    └── team/ux-ui
        ├── feature/main-menu-design
        ├── feature/level-01-design
        ├── feature/level-02-design
        └── feature/level-03-design
```

## Flujo

```text
Crear rama → desarrollar → probar → commit → push
→ Pull Request → revisión → merge a develop
→ integración → pruebas → main
```

# 📝 Convención de commits

```bash
feat: add level 1 puzzle
fix: correct level 2 navigation
ui: update main menu
docs: update level 1 documentation
test: validate puzzle answers
refactor: improve level manager
```

# 📚 Documentación

La documentación oficial estará disponible en GitHub Wiki y `docs/`.

1. Acta de constitución.
2. Requisitos.
3. Alcance.
4. Historias de usuario.
5. Product Backlog.
6. Sprint Backlog.
7. Game Design Document.
8. Historia.
9. Diseño de niveles.
10. Diseño de puzzles.
11. UX/UI.
12. Arquitectura.
13. Diagramas UML.
14. Base de datos.
15. API REST.
16. Git/GitHub.
17. Plan de pruebas.
18. Manual de instalación.
19. Manual de usuario.
20. Manual de mantenimiento.
21. Evidencias y entregables.

# 📅 Plan de trabajo — 1 semana

| Día | Actividades |
|---|---|
| Día 1 y 2 | Planeación, Jira, GitHub, arquitectura y niveles |
| Día 3 | Sistemas principales y UI base |
| Día 3 | Implementación del Nivel 1 |
| Día 4 | Implementación de Niveles 2 y 3 |
| Día 4 | Integración frontend/backend/database |
| Día 5 | Testing y corrección de errores |
| Día 5 | Documentación, evidencias y entrega |

# 🧪 Pruebas

Se realizarán pruebas:

- Funcionales.
- De integración.
- De API mediante Postman.
- De UI.
- De navegación.
- De puzzles.
- De puntuación.
- De orientación horizontal.
- De plataforma.

Flujo de integración:

```text
Flutter → REST API → Node.js → PostgreSQL
```

# 🚀 Instalación

## Requisitos

- Git.
- Flutter.
- Dart.
- Node.js.
- PostgreSQL.
- Visual Studio Code.
- Android Studio para Android.
- Xcode para iOS.

## Clonar

```bash
git clone https://github.com/ORGANIZACION/escapeRoom.git
cd escapeRoom

```

## Frontend

```bash
cd frontend
flutter pub get
flutter run
```

Para Web:

```bash
flutter run -d chrome
```

## Backend

```bash
cd backend
npm install
npm run dev
```

o, según la configuración:

```bash
npm start
```

## PostgreSQL

```sql
CREATE DATABASE nexus9;
```

Después ejecutar los scripts de `database/scripts/`.

# 🔐 Variables de entorno

Crear `.env` en el backend:

```env
PORT=3000

DB_HOST=localhost
DB_PORT=5432
DB_NAME=nexus9
DB_USER=postgres
DB_PASSWORD=your_password

JWT_SECRET=your_secret
```

No subir `.env` a GitHub.

Ejemplo de `.gitignore`:

```text
.env
node_modules/
build/
.dart_tool/
```

# ✅ Criterios de aceptación del MVP

- [ ] El proyecto compila correctamente.
- [ ] El menú funciona.
- [ ] El tutorial funciona.
- [ ] Se puede iniciar una partida.
- [ ] Los tres niveles son accesibles.
- [ ] Cada nivel tiene un puzzle.
- [ ] Las respuestas correctas permiten avanzar.
- [ ] Las respuestas incorrectas generan penalización.
- [ ] El inventario funciona.
- [ ] Las puertas funcionan.
- [ ] El temporizador funciona.
- [ ] Las pistas funcionan.
- [ ] La puntuación funciona.
- [ ] Existen pantallas de victoria y derrota.
- [ ] El backend recibe información.
- [ ] PostgreSQL almacena la información requerida.
- [ ] La API REST funciona.
- [ ] El código está en GitHub.
- [ ] Jira contiene las tareas.
- [ ] La documentación está completa.
- [ ] Existen evidencias de pruebas.
- [ ] Se puede realizar una demostración del juego.

# 📊 Estado del proyecto

**Estado:** MVP en desarrollo.

### Prioridades

1. Finalizar arquitectura.
2. Configurar repositorio.
3. Configurar Jira.
4. Crear estructura Flutter.
5. Implementar sistemas principales.
6. Implementar Nivel 1.
7. Implementar Nivel 2.
8. Implementar Nivel 3.
9. Integrar backend.
10. Probar.
11. Documentar.
12. Preparar entrega.

# 📄 Licencia

Proyecto desarrollado con fines académicos para el programa:

**Análisis y Desarrollo de Software — ADSO**  
**SENA — Centro de Diseño Tecnológico e Innovación**

---

## 🧪 NEXUS-9

> **Explore. Think. Solve. Escape.**

**Proyecto académico — SENA ADSO**
