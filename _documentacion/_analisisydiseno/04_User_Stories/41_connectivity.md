# User Stories — Conectividad Reactiva (41_connectivity)

**Directorio:** `lib\41_connectivity\` (2 archivos `.dart`)
**Epic asociado:** [`02_Epics_EARS/41_connectivity.md`](../02_Epics_EARS/41_connectivity.md)
**Feature BDD:** [`03_Features_BDD/41_connectivity/conectividad_reactiva.feature`](../03_Features_BDD/41_connectivity/conectividad_reactiva.feature)
**Inventario:** [`05_Tareas_Inventarios/41_connectivity/elementos_41_connectivity.md`](../05_Tareas_Inventarios/41_connectivity/elementos_41_connectivity.md)
**Fecha:** 2026-08-12
**Fuente:** Ingeniería inversa

> **Nota de corrección:** este archivo fue reescrito el 2026-08-12. Anteriormente estaba contaminado dentro del consolidado `03_listas.md`. Este archivo documenta únicamente `41_connectivity`.

---

## US-CONN-001: Detección reactiva de conectividad (WiFi/Mobile/Ethernet/None)

### Card
**Como** usuario
**Quiero** que la app detecte mi estado de red en tiempo real y muestre feedback inmediato
**Para** saber cuándo puedo usar funciones online y cuándo no.

### Conversation
- `connectivitycheck_provider.dart` (430 líneas) expone `ChecaConeccionesNotifier` — un `Notifier`/`StateNotifier` que envuelve `connectivity_plus.Connectivity().onConnectivityChanged`.
- Estado observable (vía `ref.watch(checaConeccionesProvider)`):
  - `ElementoDeConeccion(icono: Symbols.wifi, estado: "Conectado")` → WiFi.
  - `ElementoDeConeccion(icono: Symbols.cell_tower, estado: "Conectado")` → Mobile.
  - `ElementoDeConeccion(icono: Symbols.lan, estado: "Conectado")` → Ethernet/VPN.
  - `ElementoDeConeccion(icono: Symbols.wifi_off, estado: "Sin conexión")` → `ConnectivityResult.none`.
- `PaginaChecaInternet` (`PaginaChecaInternetState`) muestra visualmente el estado en pantalla de debug/acceso.
- Variable global `rutaConectividad` (mutable top-level) se actualiza a `"/principal"` (online) o `"/sinconeccion"` (offline) para que el enrutador redirija.
- **Comentario crítico:** la conexión física a la red NO implica conexión a la API/CouchDB — el `ConnectivityResult.wifi` puede estar pero el backend caído. Deuda: añadir healthcheck HTTP además del `connectivity_plus`.

### Confirmation
- ✓ Al conectar WiFi → UI muestra icono `Symbols.wifi` + "Conectado".
- ✓ Al pasar a Mobile → `Symbols.cell_tower` + "Conectado".
- ✓ Al desconectar todo → `Symbols.wifi_off` + "Sin conexión" redirige a `/sinconeccion`.
- ✓ Los cambios se propagan reactivamente a los widgets via `ref.watch`.
- ✓ `rutaConectividad` global se actualiza y `AppRoutes` redirige en el siguiente build.

**Trazabilidad:** `REQ-CONN-001` ~ `02_Epics_EARS/41_connectivity.md` · Archivos: `connectivitycheck_provider.dart`

---

## US-CONN-002: Pantalla sin conexión con auto-recovery al volver la red

### Card
**Como** usuario sin red temporalmente
**Quiero** una pantalla que me indique que no hay conexión y vuelva automáticamente al recuperar
**Para** no quedarme atascado y tener que navegar manualmente.

### Conversation
- `pagina_sin_coneccion.dart` (169 líneas) expone `PaginaSinConeccion` (StatefulWidget).
- Renderiza:
  - Ícono grande `Symbols.wifi_off` con `appTheme.colorScheme.errorContainer`.
  - Mensaje "Sin conexión a Internet" + sub-mensaje "Verifica tu WiFi o datos móviles".
  - Bullet list de troubleshooting (activar WiFi, reiniciar router, etc).
  - Spinner pequeño indicando "Esperando conexión...".
- En `initState` hace `ref.listen(checaConeccionesProvider)` con callback: cuando el estado cambia a "Conectado", `Navigator.pop(context)` automáticamente — el usuario no necesita tocar nada.
- **Comentario crítico:** el `Navigator.pop` puede fallar si la ruta de sin-conexión es la primera en el stack (no hay nada atrás). Deuda: validar `Navigator.canPop` antes de pop, y si no, `pushReplacementNamed('/principal')`.

### Confirmation
- ✓ Al perder red, el usuario ve la pantalla con icono + mensaje + troubleshooting.
- ✓ Al volver la red, el `ref.listen` dispara `Navigator.pop` automáticamente.
- ✓ No requiere acción manual del usuario para volver a la pantalla anterior.
- ✓ En primer arranque sin red, el redirect inicial lleva a `/sinconeccion`.

**Trazabilidad:** `REQ-CONN-002` · Archivos: `pagina_sin_coneccion.dart`, interacciona con `connectivitycheck_provider.dart`

---

## Resumen matriz

| US | Escenarios BDD | Archivos principales |
|----|----------------|---------------------|
| US-CONN-001 (detección reactiva) | 4 estados de conectividad | `connectivitycheck_provider.dart` |
| US-CONN-002 (pantalla + auto-recovery) | 1 flujo offline/online | `pagina_sin_coneccion.dart` |

---

## Notas de deuda técnica

1. **`rutaConectividad` variable global mutable** — debería ser `Provider<String>` que escuche a `checaConeccionesProvider`.
2. **Sin healthcheck HTTP**: `connectivity_plus` sólo detecta capa física, no disponibilidad del backend. Deuda: hacer un `HEAD /healthz` periódico.
3. **`Navigator.pop` sin `canPop` check** — puede fallar en caso de ser la ruta raíz.
4. **430 líneas en `connectivitycheck_provider.dart`** — poca separación entre modelo (`ElementoDeConeccion`, `ElementoDatos`) y el Notifier. Refactor: extraer modelos a `models/`.
5. **Sin tests** del Notifier ni de `PaginaSinConeccion`.
