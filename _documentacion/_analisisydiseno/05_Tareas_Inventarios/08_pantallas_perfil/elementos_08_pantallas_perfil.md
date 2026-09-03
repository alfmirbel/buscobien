# Inventario de Elementos — Pantallas: Perfil de Usuario (08_pantallas/perfil)

**Directorio:** `lib\08_pantallas\perfil\`
**Total archivos `.dart` fuente:** 1
**Epic asociado:** [`02_Epics_EARS/08_pantallas_perfil.md`](../../02_Epics_EARS/08_pantallas_perfil.md)
**Features BDD:** [`03_Features_BDD/08_pantallas_perfil/perfil_usuario.feature`](../../03_Features_BDD/08_pantallas_perfil/perfil_usuario.feature) (7 escenarios)
**User Stories:** [`04_User_Stories/08_pantallas_perfil.md`](../../04_User_Stories/08_pantallas_perfil.md) (5 US)
**Fecha:** 2026-08-13
**Fuente:** Ingeniería inversa

---

## Tabla 1 — Resumen de componentes por rol funcional

| # | Componente | Archivo | Tipo | Rol funcional | US-PERF |
|---|-------------|---------|------|----------------|---------|
| 1 | `PaginaPerfilWidget` | `pagina_perfil.dart` | ConsumerStatefulWidget | Pantalla raíz del perfil | todas |
| 2 | `PaginaPerfilWidgetState` (State) | `pagina_perfil.dart` | State | Manejo de ciclo de vida + flags locales | US-PERF-001, 004 |
| 3 | `_buildNoUserView` (privado) | `pagina_perfil.dart:153-203` | Widget builder | Vista no-logueado con CTA login | US-PERF-001 |
| 4 | `_buildUserProfileView` (privado) | `pagina_perfil.dart:204-342` | Widget builder | Vista completa del perfil | US-PERF-001 |
| 5 | `_buildHeaderSection` (privado) | `pagina_perfil.dart:343-451` | Widget builder | Avatar + nombre + rol | US-PERF-001, 003 |
| 6 | `_buildInfoCard` (privado) | `pagina_perfil.dart:475-493` | Widget builder | Card con datos contacto | US-PERF-001 |
| 7 | `_buildProfileRow` (privado) | `pagina_perfil.dart:494-537` | Widget builder | Fila label + value (con icono) | US-PERF-001, 005 |
| 8 | `_buildSectionTitle` (privado) | `pagina_perfil.dart:452-474` | Widget builder | Título de sección | US-PERF-001 |
| 9 | `_buildDivider` (privado) | `pagina_perfil.dart:538` | Widget builder | Separador | UI |

---

## Tabla 2 — Detalle por archivo

| # | Archivo | Clases / Funciones | Líneas | Dependencias clave | Estado | Comentario / Deuda |
|---|---------|--------------------|--------|---------------------|--------|--------------------|
| 1 | `pagina_perfil.dart` | `PaginaPerfilWidget`, `PaginaPerfilWidgetState`,1 initState + didChange/Update/deactivate/dispose + build() + 6 métodos `_build*` privados | 698 | `flutter`, `flutter_riverpod`, `Symbols`, `var_color_themes` (`appTheme`), `provider_session` (`10_user_login`), `app_routes`, `recuperaDatosDelAvatar` (`10_user_login`), `Image.memory` (base64) | ⚠ deuda | **698 líneas en 1 archivo** con 6 builders privados → candidatos a widgets reutilizables en `60_global_widgets` (`ProfileHeader`, `ProfileInfoCard`, `ProfileRow`). `isUserLoggedIn` boolean de estado local que se sincroniza con provider; debería ser getter derivado |

---

## Notas críticas

- **Módulo más pequeño del hito 08**: 1 archivo, 698 líneas. Su simplicidad es engañosa: el widget es denso y referencea muchas partes del ecosistema (`provider_session`, `GestionAvatares`, `usuario_registro`, `AppRoutes/regresar`, `recuperaDatosDelAvatar`, `appTheme`).
- **6 builders privados**: `_buildHeaderSection, _buildInfoCard, _buildProfileRow, _buildSectionTitle, _buildDivider, _buildNoUserView, _buildUserProfileView`. Refactor: extraer a widgets públicos en `60_global_widgets` para reusarlos en otras pantallas (actualmente son exclusivos del perfil).
- **`isUserLoggedIn` como boolean local de State**: riesgoso — se sincroniza manualmente con `sessionProvider`. Debería ser getter derivado `bool get isUserLoggedIn => ref.read(sessionProvider).isAuth;`.
- **Acoplamiento transversal esperado**:
  - `10_user_login/provider_session.dart` → estado de sesión.
  - `10_user_login/usuario_registro*` → modo edición.
  - `10_user_login/usuario_avatar/GestionAvatares` → avatar.
  - `02_principal_screen` → usado en sección 4 del shell.
- **`_buildProfileRow` no valida null**: deuda menor.
- **`appTheme` exclusivamente** — cumple regla de no colores hardcoded.
- **Sin tests**: ninguna widget test del perfil.
