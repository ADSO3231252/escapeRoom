# Guía de contribución

Gracias por contribuir al proyecto.

## Estrategia de ramas

El proyecto utiliza la siguiente estructura de ramas:

- `main` — Versión estable de producción.
- `develop` — Rama principal de integración.
- `release` — Preparación de lanzamientos.
- `team-backend` — Equipo de backend.
- `team-game-design` — Equipo de diseño de juego.
- `team-gameplay` — Equipo de jugabilidad.
- `team-unity-1` — Equipo de Unity 1.
- `team-unity-2` — Equipo de Unity 2.
- `team-ux-ui` — Equipo de UX/UI.

## Reglas de desarrollo

1. No subir cambios directamente a `main`.

2. El trabajo debe estar relacionado con una tarea de Jira.
3. Utiliza una rama de funcionalidad (*feature branch*) personal para tareas individuales.
4. Es obligatorio crear *Pull Requests* al integrar cambios.
5. El código debe revisarse antes de realizar la fusión (*merge*).
6. No incluir contraseñas, *tokens* ni archivos `.env` en los *commits*.
7. Mantén la documentación actualizada.
8. Prueba los cambios antes de crear un *Pull Request*.
9. Mantén los *commits* pequeños y significativos.

## Convención de *commits*

Utiliza mensajes descriptivos para los *commits*.

Ejemplos:

```text
feat: añadir controlador del jugador
fix: corregir error en la tabla de clasificación
docs: actualizar guía de instalación
refactor: mejorar servicio de base de datos
chore: actualizar dependencias
test: añadir pruebas de autenticación