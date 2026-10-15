# AGENTS.md — reglas del proyecto Estante

Este archivo lo leen los agentes de código (Claude Code, Codex, Antigravity…) al abrir esta carpeta. Es el **archivo de contexto** del proyecto: lo que un agente nuevo necesita saber para trabajar bien aquí. Se mantiene corto y concreto.

## Qué es el proyecto

Estante es una app Flutter (Android) para llevar una biblioteca personal: libros organizados en repisas, detalle con marcapáginas, sello «Leído», buscador por título o autor y un mapa de lecturas con pines en Loja. Estado con GetX, datos remotos con `dio` contra el backend `biblioteca-personal` (con inicio de sesión), token en `flutter_secure_storage`, caché sin conexión con `shared_preferences` y mapa con `flutter_map`. Textos en español con traducción al inglés (GetX).

## Dónde está cada cosa

- `lib/` — código de la app: controladores GetX, servicios y repositorios, pantallas, widgets y modelos.
- `test/` — pruebas con repositorios falsos (no necesitan el backend ni el emulador).
- `assets/` — íconos de la app.

## Cómo verificar (siempre, antes de dar un cambio por terminado)

```bash
flutter analyze
flutter test
```

Los dos deben terminar sin errores. Si fallan, corrige el código; no desactives el análisis ni borres pruebas para que pasen.

## Convenciones

- El estado compartido vive en un controlador GetX; las pantallas no llaman directamente al backend.
- Todo texto visible para la persona va en español, con su traducción al inglés.
- Cada pantalla con datos cubre los tres estados: cargando, vacío y error.
- Cambios pequeños y enfocados: una funcionalidad a la vez, con una prueba por cada comportamiento nuevo.

## Prohibido

- Escribir claves, tokens o contraseñas en el código, en los registros o en este archivo. No leer ni modificar `.env`.
- Agregar dependencias nuevas sin avisar antes y explicar por qué hacen falta.
- Ejecutar `git push` o crear etiquetas: eso lo hace la persona después de revisar el cambio.

## Reglas del estudiante

- Los nombres de clases, funciones y variables van en español, igual que en el resto del código.
- Antes de crear un widget nuevo, revisa si ya existe uno parecido en `lib/`.
