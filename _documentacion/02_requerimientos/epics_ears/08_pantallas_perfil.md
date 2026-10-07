# Epic: Pantallas — Perfil de Usuario (08_pantallas/perfil)

**Directorio:** `lib\08_pantallas\perfil\`
**Archivos fuente:** 1 (`.dart`) — `pagina_perfil.dart`
**Fecha:** 2026-08-13
**Fuente:** Ingeniería inversa

---

## Impact Mapping

| Objetivo de Negocio | Actor | Impacto | Entregable |
|---------------------|-------|---------|------------|
| Identidad del usuario en la app | Usuario | Ve su avatar, nombre, rol y datos de contacto; acceso a editar | `PaginaPerfilWidget` (698 líneas) |
| | Sistema | Lee sesión desde `provider_session`, valida auth, renderiza condicionalmente usuario/no-usuario | `_buildUserProfileView` / `_buildNoUserView` |

---

## User Story Mapping

```
Sección "Perfil" de PrincipalSliversMenuInicial (índice 4)
       │
       ▼
PaginaPerfilWidget (ConsumerStatefulWidget)
   ├── didChangeDependencies: valida sesión con provider_session
   └── build():
       ├── isUserLoggedIn == false → _buildNoUserView (CTA login)
       └── isUserLoggedIn == true  → _buildUserProfileView:
           ├── _buildHeaderSection (avatar + nombre + rol)
           ├── _buildInfoCard: datos contacto (email, celular, RFC)
           ├── _buildProfileRow por cada campo
           └── CTAs: editar perfil, gestión avatar
```

---

## Especificación SDD / EARS

**Prefijo IDs:** `REQ-PERF-XXX`

| ID | Tipo EARS | Requerimiento | Evidencia | Estado |
|----|-----------|---------------|-----------|--------|
| REQ-PERF-001 | **Ubicuo** | El sistema expondrá `PaginaPerfilWidget` (ConsumerStatefulWidget, 698 líneas) como pantalla del hub perfil desde la sección 4 de `PrincipalSliversMenuInicial`. | `pagina_perfil.dart:1-698` | En código |
| REQ-PERF-002 | **Estado** | Mientras `isUserLoggedIn == false`, el sistema mostrará `_buildNoUserView` con icono `Symbols.person`, mensaje "Inicia sesión" y CTA a `AppRoutes.login`. | `pagina_perfil.dart:153-203` (`_buildNoUserView`) | En código |
| REQ-PERF-003 | **Estado** | Mientras `isUserLoggedIn == true`, el sistema mostrará `_buildUserProfileView` con: avatar (base64 → Image.memory), nombre, rol, datos contacto (email/celular/RFC), CTAs a edición y gestión avatar. | `pagina_perfil.dart:204-342` (`_buildUserProfileView`) | En código |
| REQ-PERF-004 | **Evento** | Cuando el usuario toque CTA "Editar perfil", el sistema navegará a la pantalla de edición correspondiente (de `10_user_login/usuario_registro` con datos pre-cargados). | `pagina_perfil.dart` (CTAs) | En código |
| REQ-PERF-005 | **Evento** | Cuando el usuario toque CTA "Gestión avatar", el sistema navegará a `GestionAvatares` (de `10_user_login`). | (CTA en `_buildHeaderSection`) | En código |
| REQ-PERF-006 | **Complejo** | Mientras la app esté en cualquier estado (logged-in/no-logged-in), el `PaginaPerfilWidget` escuchará cambios en `provider_session` (Riverpod) y reconstruirá al detectar login/logout. | `ConsumerStatefulWidget` + `ref.watch(sessionProvider)` | En código |
| REQ-PERF-007 | **No Deseado** | Si `recuperaDatosDelAvatar()` falla o el avatar está vacío, el sistema mostrará `CircleAvatar` con `Symbols.person` por defecto (sin crash). | `_buildHeaderSection.tieneAvatar` fallback | En código |
| REQ-PERF-008 | **Ubicuo** | El sistema usará `appTheme` (ColorScheme) para todos los colores — ningún `Color(0xFF...)` hardcoded. | build() completo | En código |

---

## Trazabilidad a Código

| Componente | Archivo | Líneas |
|------------|---------|--------|
| `PaginaPerfilWidget` (State) | `pagina_perfil.dart` | 1-698 |
| `initState` (PostFrameCallback con `recuperaDatosDelAvatar`) | `pagina_perfil.dart:42-62` | 42-62 |
| `_buildNoUserView` | `pagina_perfil.dart` | 153-203 |
| `_buildUserProfileView` | `pagina_perfil.dart` | 204-342 |
| `_buildHeaderSection (nombre, rol, avatar)` | `pagina_perfil.dart` | 343-451 |
| `_buildInfoCard / _buildProfileRow / _buildSectionTitle / _buildDivider` | `pagina_perfil.dart` | 452-538 |

---

## Deuda Técnica

1. **698 líneas en 1 archivo**: aunque sólo es 1 widget, contiene 6 builders privados que podrían ser widgets reutilizables en `60_global_widgets` (ej. `ProfileRow`, `ProfileHeader`, `ProfileInfoCard`).
2. **Lógica de sesión en ConsumerStatefulWidget**: el `provider_session` se consume con `ref.watch` pero la mutación se hace desde `10_user_login`. Acoplamiento transversal esperado.
3. **Sin tests**: ningún widget test del perfil.
4. **Sin validación de datos de sessión**: si el `sessionProvider` está en estado parcial (ej. nombre null), los `_buildProfileRow` no validan y podrían mostrar "null" como string.
