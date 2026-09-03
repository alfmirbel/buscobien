# User Stories — Pantallas: Perfil de Usuario (08_pantallas/perfil)

**Directorio:** `lib\08_pantallas\perfil\` (1 archivo `.dart`)
**Epic asociado:** [`02_Epics_EARS/08_pantallas_perfil.md`](../02_Epics_EARS/08_pantallas_perfil.md)
**Feature BDD:** [`03_Features_BDD/08_pantallas_perfil/perfil_usuario.feature`](../03_Features_BDD/08_pantallas_perfil/perfil_usuario.feature) (7 escenarios)
**Inventario:** [`05_Tareas_Inventarios/08_pantallas_perfil/elementos_08_pantallas_perfil.md`](../05_Tareas_Inventarios/08_pantallas_perfil/elementos_08_pantallas_perfil.md)
**Fecha:** 2026-08-13
**Fuente:** Ingeniería inversa

---

## US-PERF-001: Ver mi perfil con avatar, rol y datos de contacto

### Card
**Como** usuario autenticado
**Quiero** una pantalla con mi avatar, nombre, rol y datos de contacto
**Para** visualizar y gestionar mi identidad pública en Buscobien.

### Conversation
- `PaginaPerfilWidget` (`pagina_perfil.dart`, 698 líneas, ConsumerStatefulWidget) es la pantalla de la sección 4 de `PrincipalSliversMenuInicial`.
- `initState` dispara `postFrameCallback` con `recuperaDatosDelAvatar(userId)` para refrescar avatar base64 desde CouchDB (vía API).
- `build()` consulta `sessionProvider` con `ref.watch`:
  - `isUserLoggedIn == false` → `_buildNoUserView` (icono `Symbols.person` + mensaje "Inicia sesión" + CTA "Ingresar" → `AppRoutes.login`).
  - `isUserLoggedIn == true` → `_buildUserProfileView`:
    - `_buildHeaderSection(nombre, rol, avatar)`: avatar base64 → `Image.memory` si `tieneAvatar`, fallback `CircleAvatar` con `Symbols.person`.
    - `_buildInfoCard`: lista de `_buildProfileRow(icon, label, value)` con datos contacto (email, celular, RFC si rol promotor, etc).
    - CTAs: "Editar perfil" (navega a registro en modo edición), "Gestión avatar" (navega a `GestionAvatares`).
- **Reglas M3:** usa `appTheme.colorScheme` exclusivamente. Iconos `Symbols.*` en rango 0xe000-0xe900. Sin `Color(0xFF...)` hardcoded.
- **Comentario crítico de deuda:** 698 líneas en 1 archivo con 6 builders privados (`_buildHeaderSection`, `_buildInfoCard`, `_buildProfileRow`, etc) — candidatos a ser widgets reutilizables en `60_global_widgets` (ProfileHeader, ProfileInfoCard, ProfileRow).

### Confirmation
- ✓ Al iniciar sesión, la sección 4 muestra avatar + nombre + rol + datos contacto.
- ✓ Si no hay sesión, muestra el CTA "Ingresar" → navega a `AppRoutes.login`.
- ✓ Si el avatar base64 falla o está vacío, fallback a `CircleAvatar` con `Symbols.person`.
- ✓ `appTheme` se usa exclusivamente (sin Colors hardcodeados).
- ✓ Feature BDD: escenarios "Usuario no logueado", "Usuario logueado", "Recuperación avatar".

**Trazabilidad:** `REQ-PERF-001`, `REQ-PERF-002`, `REQ-PERF-003`, `REQ-PERF-007`, `REQ-PERF-008` · Archivos: `pagina_perfil.dart`

---

## US-PERF-002: Editar mis datos de perfil (nombre, email, celular, RFC)

### Card
**Como** usuario que necesita actualizar su información de contacto
**Quiero** un CTA "Editar perfil" que me lleve al formulario con datos precargados
**Para** corregir información desactualizada o agregar faltante.

### Conversation
- CTA "Editar perfil" en `_buildUserProfileView` invoca `AppRoutes.routeGenerate` con parámetros que indican modo edición (`routes_parameters.dart`).
- Navega a la pantalla de registro en `10_user_login/usuario_registro` — reutiliza el mismo formulario pero precarga datos.
- Tras guardar, regresa a `PaginaPerfilWidget`. `sessionProvider` actualiza el state y `ref.watch` dispara el rebuild con los nuevos datos.
- **Comentario crítico:** el modo edición no se testea explícitamente — el flujo es implícito (los campos son los mismos que en registro pero con `_initialValue`). Deuda: tests específicos de modo edición.

### Confirmation
- ✓ Al tap "Editar perfil", navega al formulario con datos precargados.
- ✓ Al guardar y regresar, el perfil muestra los nuevos valores inmediatamente (vía `ref.watch`).
- ✓ Feature BDD: escenario "CTA Editar perfil".

**Trazabilidad:** `REQ-PERF-004` · Archivos: `pagina_perfil.dart` (CTA `AppRoutes`), `10_user_login/usuario_registro`

---

## US-PERF-003: Gestionar mi avatar (subir/preview/guardar)

### Card
**Como** usuario
**Quiero** un CTA "Gestión avatar" que abra el flujo de subir, previsualizar y guardar mi foto de perfil
**Para** personalizar mi identidad pública.

### Conversation
- CTA "Gestión avatar" navega a `GestionAvatares` (`10_user_login/usuario_avatar` o similar).
- Flujo de `GestionAvatares`: `FilePicker.platform.pickFiles(type: image)` → preview local → `base64.encode` → PUT a CouchDB via API → actualiza el `avatarBase64` en el `sessionProvider`.
- Al regresar a `PaginaPerfilWidget`, el `_buildHeaderSection` muestra el nuevo avatar vía `Image.memory`.
- **Comentario:** el avatar también se muestra en el `AppBar` de `PrincipalSliversMenuInicial` (sección 02_principal_screen) — flujo de actualización debe propagarse a ambos lugares vía `sessionProvider`.

### Confirmation
- ✓ Al tap "Gestión avatar", navega al flujo de subida.
- ✓ Al regresar con un avatar nuevo, el header del perfil lo muestra correctamente.
- ✓ Si el flujo se cancela (sin avatar nuevo), el perfil permanece con el avatar anterior.
- ✓ Feature BDD: escenario "CTA Gestión Avatar".

**Trazabilidad:** `REQ-PERF-005` · Archivos: `pagina_perfil.dart` (CTA), `10_user_login/usuario_avatar` (`GestionAvatares`)

---

## US-PERF-004: Reactividad del perfil a login/logout

### Card
**Como** usuario que hace login o logout en cualquier momento
**Quiero** que la pantalla Perfil reaccione inmediatamente sin necesidad de tap manual o restart
**Para** tener feedback visual del cambio de sesión.

### Conversation
- `PaginaPerfilWidget` consume `ref.watch(sessionProvider)` en su `build()`. Cualquier `sessionProvider.notifier.setUser(...)` / `sessionProvider.notifier.logout()` dispara rebuild automático.
- Los listeners `didChangeDependencies`, `didUpdateWidget` en el State manejan edge cases (rotación, deep-link resume, etc).
- El reuse vía `ConsumerStatefulWidget` asegura que el estado local (ej. flags temporales) y el estado Riverpod coexisten correctamente.
- **Comentario crítico:** el logout suele venir desde otra pantalla (ej. el drawer de `02_principal_screen`), no desde el propio perfil — pero la reactividad garantiza estado consistente al navegar de vuelta.

### Confirmation
- ✓ Tras logout (desde cualquier pantalla), al regresar al perfil se ve `_buildNoUserView`.
- ✓ Tras login (desde cualquier flujo), al regresar al perfil se ven los nuevos datos.
- ✓ `ref.watch` reactivo — sin necesidad de `setState` manual.
- ✓ Feature BDD: escenario "Logout actualiza perfil".

**Trazabilidad:** `REQ-PERF-006` · Archivos: `pagina_perfil.dart`, interacciona con `10_user_login/provider_session.dart`

---

## US-PERF-005: Deuda de sesión parcial (campos null como string)

### Card
**Como** arquitecto del sistema
**Quiero** documentar que las filas de perfil pueden mostrar "null" como string si el sessionProvider queda en estado parcial
**Para** que el equipo corrija la validación y planifique el fix.

### Conversation
- `_buildProfileRow(icon, label, value)` no valida `value == null` — si el sessionProvider retorna un dato en null, se concatena como cadena "null".
- Caso típico: usuario que no completó RFC al registrarse (campo opcional) → vería "null" en lugar de "—" o "Sin dato".
- **Fix trivial:** `_buildProfileRow` debe normalizar `value ?? "Sin dato"` antes de pasar al `Text`.

### Confirmation
- ✓ Se documenta como deuda menor y como escenario BDD "Sesión en estado parcial".
- ✓ Fix uno-a-uno: cada `_buildProfileRow` valida null y muestra placeholder.

**Trazabilidad:** `REQ-PERF-007` (parcialmente, alterno — avatar fallback OK, otros campos no) · Archivos: `pagina_perfil.dart`

---

## Resumen matriz

| US | Epic Req | Escenarios BDD | Archivos principales |
|----|----------|----------------|-----------------------|
| US-PERF-001 (ver perfil completo) | REQ-PERF-001 a 003, 007, 008 | 3 | `pagina_perfil.dart` |
| US-PERF-002 (editar perfil) | REQ-PERF-004 | 1 | `pagina_perfil.dart` (CTA) + `10_user_login/usuario_registro` |
| US-PERF-003 (gestión avatar) | REQ-PERF-005 | 1 | `pagina_perfil.dart` (CTA) + `10_user_login/usuario_avatar` |
| US-PERF-004 (reactividad login/logout) | REQ-PERF-006 | 1 | `pagina_perfil.dart` (ConsumerStatefulWidget) |
| US-PERF-005 (deuda sesión parcial) | REQ-PERF-007 (parcial) | 1 | `pagina_perfil.dart` |

---

## Notas de deuda técnica

1. **698 líneas en 1 archivo** con 6 builders privados. Refactor: extraer `ProfileHeader`, `ProfileInfoCard`, `ProfileRow` a `60_global_widgets`.
2. **`_buildProfileRow` no valida null** — deuda menor, fix trivial `value ?? "Sin dato"`.
3. **`recuperaDatosDelAvatar` en `initState`**: debería migrar a un `FutureProvider.family` para evitar llamadas imperativas y aprovechar caching Riverpod.
4. **Acoplamiento con `10_user_login`** vía `provider_session` y navegación a `usuario_registro`/`GestionAvatares` — esperado y documentado.
5. **Sin tests**: ningún widget test del perfil.
