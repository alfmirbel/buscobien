# Epic: Estado Global de Navegación (01_home)

**Directorio:** `lib\01_home\`  
**Archivos:** `home_state.dart`, `home_navigation_provider.dart` (+ `.freezed.dart`, `.g.dart` generados)  
**Fecha:** 2026-08-12  
**Fuente:** Ingeniería inversa

---

## Impact Mapping

| Objetivo de Negocio | Actor | Impacto | Entregable |
|---------------------|-------|---------|------------|
| Navegación fluida entre secciones (Inicio, Principal, Gobierno, Espacio, Transacción, Mi Cuenta) | Usuario final | Cambia de tab/sección y el estado persiste reactivamente sin recargar | Estado global `HomeState` con 7 índices + versioning |
| | Desarrollador | Accede a navegación vía `ref.watch(homeNavigationProvider)` y muta vía `.notifier` | Provider Riverpod Generator tipado |

---

## User Story Mapping

```
Usuario interactúa con menús (NavigationBar, SliverAppBar, Drawer)
       │
       ▼
┌─────────────────────────────────────────────┐
│ HomeNavigation Provider (Riverpod Notifier) │
│ - build(): HomeState inicial (todos 0)      │
│ - actualizarX(index): copyWith + version++  │
│ - setX(index): copyWith simple              │
└────────────────┬────────────────────────────┘
                 │
       ┌─────────┼─────────┬─────────┬─────────┐
       ▼         ▼         ▼         ▼         ▼
   Inicial   Principal  Gobierno  Espacio  Transacción
   (indice)  (indice)   (indice)  (indice) (indice)
       │
       ▼
┌─────────────────────────────────────────────┐
│ UI reacciona: ref.watch(homeNavigationProvider)
│ select((s) => s.version) para rebuild granular
└─────────────────────────────────────────────┘
```

---

## Especificación SDD / EARS

**Prefijo IDs:** `REQ-HOME-XXX`

| ID | Tipo EARS | Requerimiento | Evidencia | Estado |
|----|-----------|---------------|-----------|--------|
| REQ-HOME-001 | **Ubicuo** | El sistema mantendrá un estado global inmutable (`HomeState` Freezed) con 7 índices de navegación (`indiceInicial`, `indicePrincipal`, `indiceNivelGobierno`, `indiceTipoEspacio`, `indiceTipoTransaccion`, `indiceMiCuenta`, `indiceMiCuentaUsuario`) y un contador `version`. | `lib\01_home\home_state.dart:12-22` | En código |
| REQ-HOME-002 | **Ubicuo** | El sistema inicializará `HomeState` con todos los índices en 0 y `version: 0`. | `home_state.dart:24` `const HomeState(indiceInicial: 0)` | En código |
| REQ-HOME-003 | **Evento** | Cuando un widget llame `actualizarInicial(index)` (u otro `actualizarX`), el sistema creará un nuevo `HomeState` con el índice actualizado **e incrementará `version` en 1**. | `home_navigation_provider.dart:35-65` | En código |
| REQ-HOME-004 | **Evento** | Cuando un widget llame `setInicial(index)` (u otro `setX`), el sistema actualizará el índice **sin incrementar `version`**. | `home_navigation_provider.dart:25-33` | En código |
| REQ-HOME-005 | **Estado** | Mientras un widget observe `ref.watch(homeNavigationProvider.select((s) => s.version))`, el sistema disparará rebuild **solo** cuando `version` cambie (invalidación granular). | `home_navigation_provider.dart` pattern | En código |
| REQ-HOME-006 | **Ubicuo** | El sistema expondrá el provider global `homeNavigationProvider` (Riverpod Generator) para acceso desde cualquier widget via `ref.watch`/`ref.read`. | `home_navigation_provider.dart:12` `@riverpod` | En código |
| REQ-HOME-007 | **No Deseado** | Si `state.copyWith()` falla (ej. tipo incorrecto), el sistema propagará la excepción (sin try-catch en notifier). | `home_navigation_provider.dart` sin manejo errores | Riesgo |
| REQ-HOME-008 | **Complejo** | Mientras la app esté en shell principal, cuando el usuario toque un tab del `NavigationBar`, el sistema llamará `actualizarInicial(nuevoIndex)` → `version++` → UI reconstruye tab activo. | `lib\02_principal_screen\principal_sliver_screen_menus_inicial.dart` consumo | En código |

---

## Trazabilidad a Código

| Componente | Archivo | Líneas |
|------------|---------|--------|
| `HomeState` (@freezed) | `home_state.dart` | 1-30 |
| `HomeNavigation` (@riverpod Notifier) | `home_navigation_provider.dart` | 1-70 |
| `actualizarX` methods (con version++) | `home_navigation_provider.dart` | 35-65 |
| `setX` methods (sin version++) | `home_navigation_provider.dart` | 25-33 |
| Generated: `home_state.freezed.dart` | `.freezed.dart` | codegen |
| Generated: `home_navigation_provider.g.dart` | `.g.dart` | codegen |

---

## Notas de Arquitectura

- **Freezed + Riverpod Generator**: Codegen obligatorio (`dart run build_runner build --delete-conflicting-outputs`).
- **Versioning pattern**: `version` incrementa en `actualizarX` (no en `setX`) → permite `select((s) => s.version)` para rebuilds granulares evitando rebuild de todo el árbol.
- **Logging**: `debugPrintLevels(10, "*************** ACTUALIZA PROVIDERS ...")` en cada `actualizarX`.
- **Getters en HomeState._()**: Lanzan `UnimplementedError` — placeholder para extensiones futuras (no usados actualmente).