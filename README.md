# NEXUS-9 — Escape Room — Nivel 1

Implementación en Flutter + Dart del Nivel 1 "El Despertar", basada en los mockups de Document 14 y en el Documento Maestro K-9.

## Flujo

1. Selección de dificultad.
2. Tutorial interactivo.
3. Guided Tour.
4. Nivel 1 — El Despertar.
5. Puzzle 1: ordenar instrucciones `C → A → B → D`.
6. Puzzle 2: caja de seguridad con código `0004`.
7. Obtención de `LLAVE 1`.
8. Apertura de la puerta.
9. Pantalla `NIVEL 1 COMPLETADO`.
10. Autosave y estado preparado para desbloquear Nivel 2.

## Dificultades

- Fácil: 90 minutos.
- Normal: 60 minutos.
- Difícil: 40 minutos.

El documento fuente indica que la historia y el orden son iguales y que la dificultad modifica tiempo, pistas y complejidad. En esta implementación la lógica del Nivel 1 mantiene el mismo puzzle y deja el sistema de pistas preparado para ampliarlo.

## Ejecutar

```bash
flutter pub get
flutter run
```

Para Android:

```bash
flutter build apk
```

## Nota

Los mockups no entregan archivos de arte separados. Por eso el mapa 2D está construido con widgets y `CustomPainter` en Dart, manteniendo la composición visual: laboratorio, cama, servidores, terminal, caja, puerta, Luna, HUD y paneles cian/neón.
