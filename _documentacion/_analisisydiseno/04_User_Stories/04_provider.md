# User Stories — Preferencias de Usuario y Tema de Color (04_provider)

**Directorio:** `lib\04_provider\` (2 archivos `.dart`)
**Epic asociado:** [`02_Epics_EARS/04_provider.md`](../02_Epics_EARS/04_provider.md)
**Feature BDD:** [`03_Features_BDD/04_provider/preferencias_tema.feature`](../03_Features_BDD/04_provider/preferencias_tema.feature)
**Inventario:** [`05_Tareas_Inventarios/04_provider/elementos_04_provider.md`](../05_Tareas_Inventarios/04_provider/elementos_04_provider.md)
**Fecha:** 2026-08-12
**Fuente:** Ingeniería inversa

> **Nota de corrección:** este archivo fue reescrito el 2026-08-12. Anteriormente estaba contaminado dentro del consolidado `03_listas.md`. Este archivo documenta únicamente `04_provider`.

---

## US-PROV-001: Seleccionar tema de color M3 con cambio inmediato reactivo

### Card
**Como** usuario autenticado
**Quiero** elegir entre 9 temas de color M3 predefinidos y ver toda la app actualizada al instante
**Para** personalizar la experiencia visual a mi preferencia política/estética.

### Conversation
- `PaginaColores` (`pagina_colores.dart`, ConsumerStatefulWidget) abre desde la ruta `/preferencias` (también accesible desde el menú "Tu Cuenta").
- Construye 9 `RadioListTile<({int index, String etiqueta})>` correspondientes a: `lightINE` (verde INE), `lightMC` (naranja MC), `lightMOR` (morado MOR), `lightPAN` (rosa PAN, default), `lightPRD` (ámbar PRD), `lightPRI` (rojo PRI), `lightPT` (rojo PT), `lightPVEM` (verde PVEM), `darkINE` (dark verde).
- Cada `RadioListTile` muestra un `CircleAvatar` con el `ColorScheme.primary` del tema + el nombre (`etiqueta`) y un check al activarse.
- Al seleccionar, `ref.read(coloresProvider.notifier).state = SelectColorProvider(color: index, etiqueta: etiqueta)` actualiza el `StateProvider<SelectColorProvider>` (en `provider_preferencias.dart`).
- `appTheme = temasDisponibles[index]` muta la variable global en `var_color_themes.dart` (deuda: `appTheme` es top-level mutable, no `Provider<ColorScheme>` real).
- Todos los widgets que llaman `appTheme.xxx` dentro de su `build()` reconstruyen automáticamente al regenerarse el árbol (Flutter reactive framework). No es óptimo: la dependencia se detecta porque los widgets leen `appTheme` en build, pero el rebuild se dispara por `setState` de PaginaColores al cambiar el provider.
- **Comentario crítico de implementación:** hay una sutileza: `appTheme` es `ColorScheme` top-level mutable. Mientras Riverpod notifica y los `ConsumerWidget` re-build, los `StatelessWidget` no consumidores que lean `appTheme` solo se actualizan si un padre consumer re-build indirectamente los invalida. En la práctica funciona porque `PaginaColores` está dentro de `MaterialApp` que re-build por `coloresProvider`, pero no es honestamente reactivo.

### Confirmation
- ✓ Al abrir `/preferencias` aparecen los 9 `RadioListTile` con un `CircleAvatar` preview del `primary` de cada tema.
- ✓ El tema actual (`lightPAN` por defecto) aparece seleccionado al cargar.
- ✓ Al tap de otro radio, el `coloresProvider.state.color` se actualiza al índice del tema.
- ✓ `appTheme` global muta al `ColorScheme` del tema seleccionado.
- ✓ Toda la app (appBars, botones, tarjetas, iconos) se repinta con la nueva paleta — porque el árbol re-build desde `MaterialApp`.
- ✓ Feature BDD: `preferencias_tema.feature` casos "Cambio de tema global reactivo".

**Trazabilidad:** `REQ-PROV-001`, `REQ-PROV-003`, `REQ-PROV-004` · Archivos: `pagina_colores.dart`, `provider_preferencias.dart`, `var_color_themes.dart`

---

## US-PROV-002: Tema por defecto `lightPAN` (rosa) para usuarios nuevos

### Card
**Como** usuario nuevo sin preferencia configurada
**Quiero** un tema visual agradable por defecto al abrir la app por primera vez
**Para** no tener que configurar nada antes de empezar a explorar Buscobien.

### Conversation
- `iniciaColor` (`provider_preferencias.dart:14`) construye el estado inicial del `coloresProvider` con `color=0, etiqueta="Rosa"` (corresponde a `lightPAN` en `temasDisponibles[]`).
- `var_color_themes.dart:63` inicializa `ColorScheme appTheme = lightPAN` (variable top-level mutable).
- **Sin persistencia:** el estado de `coloresProvider` NO se guarda en `flutter_secure_storage` ni `shared_preferences`. Al reiniciar la app, vuelve a `lightPAN` siempre.
- **Comentario:** es una decisión de UX deliberada (carga inicial estable y predecible) pero también una deuda de producto: usuarios que configuran un tema favorito deben re-configurar cada sesión. Roadmap: añadir un `SharedPreferences` key `temaSeleccionadoIndex` leído en el arranque de `main.dart`.

### Confirmation
- ✓ Primera vez que abre la app, la UI se ve con paleta PAN (rosa/azulado como ColorScheme M3 estándar).
- ✓ El radio 0 ("Rosa") aparece seleccionado al abrir `/preferencias` por primera vez.
- ✓ Al cerrar y re-abrir la app, vuelve al tema `lightPAN` aunque el usuario antes haya elegido otro.

**Trazabilidad:** `REQ-PROV-005`, `REQ-PROV-007` · Archivos: `provider_preferencias.dart`, `var_color_themes.dart`

---

## US-PROV-003: Persistencia ausente del tema (deuda técnica registrada)

### Card
**Como** arquitecto del sistema
**Quiero** documentar que la selección de tema no persiste entre sesiones (solo memoria)
**Para** que el equipo sepa que es una deuda conocida y planificar su resolución.

### Conversation
- `StateProvider<SelectColorProvider>` (`coloresProvider`) vive en el `ProviderScope` de la app — al matar el proceso, se pierde.
- `main.dart` no lee ningún `SharedPreferences` para restaurar tema. El estado inicial es hardcoded en `iniciaColor`.
- **Impacto UX:** Las apps móviles nativas generalmente persisten la preferencia de tema — los usuarios de Buscobien la re-pierden tras cada reinicio.
- **Alternativas de fix:**
  1. **Quick:** `SharedPreferences` (simple, cross-platform, suficiente para Web/WASM/Windows/Android/iOS salvo iOS Secure Storage que es overkill para un entero 0-8).
  2. **Más limpio:** migrar `appTheme` a `Provider<ColorScheme>` real (Notifier) que escuche el `coloresProvider`, con `AppStartupProvider` para cargar preferencia persisted al arrancar — reflejar el patrón Riverpod 3.x.

### Confirmation
- ✓ El estado de `coloresProvider` es el inicial (`lightPAN`) tras cada arranque en frío.
- ✓ No hay `shared_preferences`/`flutter_secure_storage` write/read de tema en `main.dart` ni `provider_preferencias.dart`.
- ✓ Se documenta como deuda técnica prioritaria para backlog.

**Trazabilidad:** `REQ-PROV-006` (riesgo `ProviderNotFoundException` si falta ProviderScope; mitigado por `main.dart` que envuelve con `ProviderScope`)

---

## Resumen matriz

| US | Epic Req | Escenarios BDD | Archivos principales |
|----|----------|----------------|-----------------------|
| US-PROV-001 (selección 9 temas) | REQ-PROV-001, 003, 004 | 1-2 | `pagina_colores.dart`, `provider_preferencias.dart` |
| US-PROV-002 (default lightPAN) | REQ-PROV-005, 007 | 1 | `provider_preferencias.dart`, `var_color_themes.dart` |
| US-PROV-003 (deuda persistencia) | REQ-PROV-006 | — | (transversal con `main.dart`) |

---

## Notas de deuda técnica

1. **`appTheme` es top-level mutable**: el cambio reactivo funciona por re-build cascada desde `MaterialApp`, no por suscripción honesta a un `Provider<ColorScheme>`. Migración pendiente a `appThemeProvider` real.
2. **Sin persistencia de tema:** el usuario re-pierde su selección tras cada reinicio. Roadmap quick fix: `SharedPreferences` key `temaSeleccionadoIndex`.
3. **`ProviderNotFoundException` si falta `ProviderScope`** — riesgo mínimo porque `main.dart` envuelve la app, pero documentado como EARS "No Deseado".
4. **Sólo 9 temas expuestos en UI** (todos light + `darkINE`); `darkMC`, `darkMOR` etc definidos en `var_color_themes.dart` pero no accesibles desde `PaginaColores`. Deuda de producto: añadir radio o toggle light/dark.
5. **Sin tests** del `coloresProvider` ni de `PaginaColores`.
