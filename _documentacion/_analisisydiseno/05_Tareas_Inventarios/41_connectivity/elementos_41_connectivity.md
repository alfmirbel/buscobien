# Inventario de Elementos — Conectividad Reactiva (41_connectivity)

**Directorio:** `lib\41_connectivity\`
**Total archivos `.dart` fuente:** 2
**Epic asociado:** [`02_Epics_EARS/41_connectivity.md`](../../02_Epics_EARS/41_connectivity.md)
**Features BDD:** [`03_Features_BDD/41_connectivity/conectividad_reactiva.feature`](../../03_Features_BDD/41_connectivity/conectividad_reactiva.feature)
**User Stories:** [`04_User_Stories/41_connectivity.md`](../../04_User_Stories/41_connectivity.md) (2 US)
**Fecha:** 2026-08-12
**Fuente:** Ingeniería inversa

> **Nota de corrección:** este archivo fue reescrito el 2026-08-12. Anteriormente estaba contaminado con contenido de `04_provider` y `42_sistema_operativo`. Este archivo documenta únicamente `41_connectivity`.

---

## Tabla 1 — Resumen de componentes por rol funcional

| # | Componente | Archivo | Tipo | Rol funcional | US-CONN |
|---|-------------|---------|------|----------------|---------|
| 1 | `ElementoDeConeccion` (dataclass) | `connectivitycheck_provider.dart` | Modelo | Estado de conexión (icono + texto) | US-CONN-001 |
| 2 | `ElementoDatos` (dataclass) | `connectivitycheck_provider.dart` | Modelo | Datos complementarios del estado | US-CONN-001 |
| 3 | `ChecaConeccionesNotifier` (Notifier) | `connectivitycheck_provider.dart` | Riverpod Notifier | Detecta cambios y emite `ElementoDeConeccion` reactivo | US-CONN-001 |
| 4 | `checaConeccionesProvider` (provider) | `connectivitycheck_provider.dart` | Provider entry-point | Expone el Notifier a la app | US-CONN-001, 002 |
| 5 | `PaginaChecaInternet`, `PaginaChecaInternetState` | `connectivitycheck_provider.dart` | StatefulWidget | Vista de diagnóstico del estado | US-CONN-001 |
| 6 | `PaginaSinConeccion` | `pagina_sin_coneccion.dart` | StatelessWidget | Pantalla offline + auto-recovery | US-CONN-002 |

---

## Tabla 2 — Detalle por archivo

| # | Archivo | Clases / Funciones | Líneas | Dependencias | Estado | Comentario / Deuda |
|---|---------|--------------------|--------|---------------|--------|--------------------|
| 1 | `connectivitycheck_provider.dart` | `ElementoDeConeccion`, `ElementoDatos`, `ChecaConeccionesNotifier`, `checaConeccionesProvider`, `PaginaChecaInternet`, `PaginaChecaInternetState` | 430 | `flutter_riverpod`, `riverpod/legacy.dart`, `connectivity_plus`, `Symbols`, `var_color_themes`, `var_color_widget`, `var_elementos_menus`, `debugprint`, `app_routes` | ⚠ deuda | **3 roles en 1 archivo** (model + notifier + UI). Refactor pendiente: split en `models/elemento_coneccion.dart`, `providers/checa_conecciones_provider.dart`, `pages/pagina_checa_internet.dart`. La variable global muta `rutaConectividad` para que el AppRoutes redirija — debería ser `Provider<String>` derivado del Notifier |
| 2 | `pagina_sin_coneccion.dart` | `PaginaSinConeccion` | 169 | `flutter`, `flutter_riverpod`, `Symbols`, `var_color_themes`, `var_color_widget`, `connectivitycheck_provider` (relative) | ⚠ deuda menor | StatefulWidget que escucha `checaConeccionesProvider` en `initState` (no `ref.listen`). El `Navigator.pop` puede fallar si la ruta de sin-conexión es raíz del stack — validar `Navigator.canPop` antes, si no, `pushReplacementNamed('/principal')` |

---

## Notas críticas

- **3 roles en 1 archivo** (`connectivitycheck_provider.dart`, 430 líneas): mezcla modelo + notifier + UI. Refactor crítico para mantenibilidad.
- **`rutaConectividad` global mutable**: el notifier la muta y `AppRoutes` la lee — no reactivo honestamente. Migrar a `Provider<String>` derivado que escuche `checaConeccionesProvider`.
- **Sin healthcheck HTTP**: `connectivity_plus` detecta capa física, no disponibilidad del backend Node.js/CouchDB. Deuda: añadir `HEAD ${direccionip}/healthz` ping periódico para confirmar que el backend está + respuesta 200.
- **Auto-recovery sin guard de Navigator**: `PaginaSinConeccion.Navigator.pop` sin `canPop` — puede fallar si la ruta es raíz. Refactor menor.
- **Dependencia `Legacy.dart`**: `flutter_riverpod/legacy.dart` importa `StateProvider`/`StateNotifier` legacy — Riverpod 3.x los deprecó. Migración a `Notifier` con `@riverpod` annotation pendiente.
- **Sin tests** del Notifier (cómo reacciona a cambios de estado de conectividad), ni de la UI de `PaginaSinConeccion`.
- **Acoplamiento con `app_routes`**: el módulo importa `app_routes.dart` para obtener el path `/sinconeccion`. Mejor: el AppRoutes debería consumir `checaConeccionesProvider` y `Provider<String>` para redirigir, no al revés.
