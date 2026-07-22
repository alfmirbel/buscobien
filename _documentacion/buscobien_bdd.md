# Especificación de Requerimientos — BuscoBien
**Versión:** 0.2.0  
**Clase de documento:** BDD (Behavior-Driven Design)  
**Estándar:** EARS  
**Scope:** reverse-engineered desde `/mnt/buscobien/lib`  
**Fecha:** 2025-07-18  

---
## Criterios de pruebas
- **PL** . Plataforma host  
  Valid values: `android` | `ios` | `web` | `windows` | `macos` | `linux`  
  Default: `android`

- **PERFIL** . Perfil de visita en landing y registro  
  Valid values: `usuario` | `promotor` | `propietario` | `anfitrion` | `vendedor` | `especialista` | `proveedor` | `asociacion` | `inmobiliaria`  
  Default: `usuario`

- **ESTADO_SESION** . Estado de sesión observable  
  Valid values: `activa` | `inactiva` | `vencida` | `bloqueada`

- **CONEXION** . Disponibilidad de red  
  Valid values: `en_linea` | `fuera_de_linea`

## Notación EARS aplicada
| Sigla | Uso |
|--------|-----|
| Ubiquitous | aplica siempre, sin condición |
| Event-driven | cuando ocurre un evento |
| State-driven | mientras un estado sea verdadero |
| Unwanted | debe evitarse / nunca |

---
## REQ-SPL-001 — Splash inicial
**Ubicación:** `lib/01_splash_screen/splash_page.dart`  
**Actor:** Visitante

- **REQ-SPL-001.1** Ubiquitous  
  The system SHALL display a splash screen with app branding and version on every cold start.

- **REQ-SPL-001.2** Event-driven  
  When `CONEXION == en_linea`, The system SHALL navigate to `principal`.

- **REQ-SPL-001.3** Event-driven  
  When `CONEXION == fuera_de_linea`, The system SHALL navigate to `sinconeccion`.

- **REQ-SPL-001.4** State-driven  
  While `ESTADO_SESION == activa`, The system MAY resume session without prompting login.

- **REQ-SPL-001.5** Event-driven  
  When connectivity listener changes, The system SHALL re-evaluate navigation immediately.

- **REQ-SPL-001.6** Unwanted  
  The system SHALL NOT expose DB credentials during splash initialization.

**Acceptance criteria**
- `FC-001` Splash shows version `V.<versionActual>`
- `FC-002` Navigation branch by connectivity state is deterministic

---
## REQ-AUTH-001 — Login con selección de perfil
**Ubicación:** `lib/10_user_login/usuario_login/login_01_login_page.dart`  
**Actor:** Usuario registrado

- **REQ-AUTH-001.1** Ubiquitous  
  The system SHALL provide username and password inputs.

- **REQ-AUTH-001.2** State-driven  
  When `PERFIL != usuario`, The system SHALL send profile-aware login request.

- **REQ-AUTH-001.3** Event-driven  
  On successful auth, The system SHALL store session using platform-appropriate secure storage.

- **REQ-AUTH-001.4** Unwanted  
  The system SHALL NOT store plain-text passwords in storage.

**Acceptance criteria**
- `FC-001` Dropdown exposes at least 9 profiles
- `FC-002` Storage backend depends on PL

---
## REQ-AUTH-002 — Sesión persistente y cierre
**Ubicación:** `lib/10_user_login/usuario_login/provider_session.dart`, `session_storage.dart`  
**Actor:** Sistema

- **REQ-AUTH-002.1** Ubiquitous  
  The system SHALL restore session on app relaunch.

- **REQ-AUTH-002.2** Event-driven  
  When logout is requested, The system SHALL clear platform-specific storage and reset `AuthState`.

- **REQ-AUTH-002.3** State-driven  
  While `ESTADO_SESION == vencida`, The system SHALL redirect to login.

- **REQ-AUTH-002.4** Ubiquitous  
  The system SHALL derive role flags from profile name reactively via copyWith.

**Acceptance criteria**
- `FC-001` Session recovery reads userId, userName, nombrePerfil, userPassHash

---
## REQ-AUTH-003 — Registro de usuario
**Ubicación:** `lib/10_user_login/usuario_login/login_03_form_register_user.dart`  
**Actor:** Visitante

- **REQ-AUTH-003.1** Ubiquitous  
  The system SHALL capture full name, email, password and birth date.

- **REQ-AUTH-003.2** Event-driven  
  On submit, The system SHALL POST a new document to CouchDB.

- **REQ-AUTH-003.3** Unwanted  
  The system SHALL NOT allow duplicate email in `buscobien_usuarios`.

**Acceptance criteria**
- `FC-001` Validation error returns structured message before HTTP call

---
## REQ-AUTH-004 — Recuperación de contraseña
**Ubicación:** `lib/10_user_login/usuario_login/page_solicitar_recuperacion.dart`, `page_cambio_password.dart`, `lib/07_routes/deep_link_handler.dart`  
**Actor:** usuario olvidado

- **REQ-AUTH-004.1** Ubiquitous  
  The system SHALL allow requesting a password reset via email token.

- **REQ-AUTH-004.2** Event-driven  
  When deep link `/recuperar?token=&perfil=` is opened, The system SHALL navigate to password change.

- **REQ-AUTH-004.3** Unwanted  
  The system SHALL NOT reuse expired tokens.

**Acceptance criteria**
- `FC-001` Token validation happens server-side before password update
- `FC-002` Deep link parsing does not crash malformed URLs

---
## REQ-CAT-001 — Feed paginado de propiedades
**Ubicación:** `lib/08_pantallas/inicio/pagina_inicio_busca_espacios.dart`  
**Actor:** usuario autenticado o anónimo

- **REQ-CAT-001.1** Ubiquitous  
  The system SHALL show a paged feed of property documents.

- **REQ-CAT-001.2** State-driven  
  While user has not reached page bottom, The system SHALL load next 10 documents.

- **REQ-CAT-001.3** Event-driven  
  When filter parameters change, The system SHALL invalidate current providers and reload.

**Acceptance criteria**
- `FC-001` Page size is exactly 10 documents

---
## REQ-CAT-002 — Filtros de catálogo
**Ubicación:** `lib/08_pantallas/inicio/clase_busqueda_estado.dart`, `http_view_count_filter_propiedades.dart`  
**Actor:** usuario

- **REQ-CAT-002.1** State-driven  
  While filters are active, The system SHALL compose queries by nivelGobierno, tipoEspacio and tipoTransaccion.

- **REQ-CAT-002.2** Ubiquitous  
  The system SHALL expose result counts per active filter.

---
## REQ-CAT-003 — Detalle de propiedad y PDF
**Ubicación:** `lib/08_pantallas/propiedades/pagina_detalle_propiedad.dart`, `pagina_detalle_propiedad_pdf.dart`  
**Actor:** usuario

- **REQ-CAT-003.1** Ubiquitous  
  The system SHALL display technical data, location and contact info.

- **REQ-CAT-003.2** Ubiquitous  
  The system SHALL support like and save-to-list actions from detail.

- **REQ-CAT-003.3** Event-driven  
  On PDF request, The system SHALL generate a file with main image and limited gallery.

**Acceptance criteria**
- `FC-001` PDF generation reads remote images as base64
- `FC-002` Gallery limit enforced in PDF composition

---
## REQ-CAT-004 — Publicación de propiedad
**Ubicación:** `lib/08_pantallas/tu_cuenta/tus_espacios/form_crea_ficha_captura_propiedad.dart`  
**Actor:** propietario/agente

- **REQ-CAT-004.1** Ubiquitous  
  The system SHALL allow creating property documents with media and location data.

- **REQ-CAT-004.2** Unwanted  
  The system SHALL NOT bypass required fields: tipoEspacio, tipoTransaccion, locality, images.

**Acceptance criteria**
- `FC-001` Publication path switches between crear/editar by `_editando`

---
## REQ-CAT-005 — Tus Espacios y compra
**Ubicación:** `lib/08_pantallas/tu_cuenta/tus_espacios/`  
**Actor:** propietario/agente/promotor

- **REQ-CAT-005.1** Ubiquitous  
  The system SHALL list user-owned properties.

- **REQ-CAT-005.2** Ubiquitous  
  The system SHALL allow purchase-space flow and editing of purchased space.

- **REQ-CAT-005.3** State-driven  
  While owner spaces exist, The system SHALL expose edit and delete actions.

---
## REQ-SOC-001 — Mis Conocidos
**Ubicación:** `lib/08_pantallas/tu_cuenta/conocidos/`  
**Actor:** usuario autenticado

- **REQ-SOC-001.1** Ubiquitous  
  The system SHALL allow discovering users and sending invitations.

- **REQ-SOC-001.2** Event-driven  
  When invitation is accepted, The system SHALL add contact to user list.

- **REQ-SOC-001.3** Ubiquitous  
  The system SHALL provide 1-to-1 chat with message persistence.

- **REQ-SOC-001.4** State-driven  
  While discovery query is empty, The system SHALL expose empty-discover state.

---
## REQ-SOC-002 — Mis Grupos
**Ubicación:** `lib/08_pantallas/tu_cuenta/grupos/`  
**Actor:** usuario autenticado

- **REQ-SOC-002.1** Ubiquitous  
  The system SHALL list user groups and allow discovery.

- **REQ-SOC-002.2** Ubiquitous  
  The system SHALL allow group invitations.

- **REQ-SOC-002.3** Ubiquitous  
  The system SHALL allow group chat with message persistence.

- **REQ-SOC-002.4** Ubiquitous  
  The system SHALL expose group notices and publications.

---
## REQ-LOC-001 — Búsqueda por CP, colonia, municipio
**Ubicación:** `lib/08_pantallas/ubicacion/`, `lib/12_localidades_user/`  
**Actor:** usuario

- **REQ-LOC-001.1** Ubiquitous  
  The system SHALL resolve postal code to SEPOMEX locality entries.

- **REQ-LOC-001.2** Event-driven  
  On location selection, The system SHALL persist user localidad association.

- **REQ-LOC-001.3** Ubiquitous  
  The system SHALL expose GMaps-based locality search.

**Acceptance criteria**
- `FC-001` SEPOMEX lookup routes through localidades_repository
- `FC-002` User locations are reactive via provider_get_localidades_usuario

---
## REQ-MAP-001 — Mapa de propiedades y place actual
**Ubicación:** `lib/14_geolocalizacion/`, `lib/08_pantallas/ubicacion/`  
**Actor:** usuario

- **REQ-MAP-001.1** Ubiquitous  
  The system SHALL render property markers on Google Maps.

- **REQ-MAP-001.2** State-driven  
  While location permission is denied, The system SHALL not attempt geolocation.

- **REQ-MAP-001.3** Unwanted  
  The system SHALL NOT hardcode API keys in repository.

**Acceptance criteria**
- `FC-001` Google Maps API key injected via `--dart-define`
- `FC-002` Permission state is handled per PL

---
## REQ-IM-001 — Imágenes y galería
**Ubicación:** `lib/22_imagenes/`  
**Actor:** propietario/agente, usuario visitante

- **REQ-IM-001.1** Ubiquitous  
  The system SHALL pick or capture images via platform picker.

- **REQ-IM-001.2** Ubiquitous  
  The system SHALL compress images before upload.

- **REQ-IM-001.3** State-driven  
  While data is loading, The system SHALL show shimmer placeholder.

- **REQ-IM-001.4** Ubiquitous  
  The system SHALL support ordered photo lists and multi-upload.

**Acceptance criteria**
- `FC-001` Image paths generated by image_file_structure
- `FC-002` Order mutations update CouchDB via FuturePut

---
## REQ-CON-001 — Conectividad y offline
**Ubicación:** `lib/41_connectivity/connectivitycheck_provider.dart`  
**Actor:** sistema

- **REQ-CON-001.1** State-driven  
  While `CONEXION == fuera_de_linea`, The system SHALL show offline screen.

- **REQ-CON-001.2** Event-driven  
  When connectivity returns, The system SHALL allow navigation retry.

- **REQ-CON-001.3** Unwanted  
  The system SHALL NOT silently fail without state change.

---
## REQ-NAV-001 — Navegación y deep links
**Ubicación:** `lib/07_routes/app_routes.dart`, `deep_link_handler.dart`  
**Actor:** sistema

- **REQ-NAV-001.1** Ubiquitous  
  The system SHALL expose typed route parameters for property, locality and auth flows.

- **REQ-NAV-001.2** Event-driven  
  When deep link `/recuperar?token=&perfil=` is received, The system SHALL route to password change.

- **REQ-NAV-001.3** Ubiquitous  
  The system SHALL use `setPathUrlStrategy` for clean URLs on Web.

---
## REQ-THEME-001 — UX y tokens visuales M3
**Ubicación:** `lib/20_var_globales/var_color_themes.dart`, widget rules  
**Actor:** usuario

- **REQ-THEME-001.1** Ubiquitous  
  The system SHALL use M3 tokens from `appTheme`, not hardcoded values.

- **REQ-THEME-001.2** Ubiquitous  
  The system SHALL use `NavigationBar` and `FilledButton` patterns where required.

- **REQ-THEME-001.3** Event-driven  
  When preference page updates, The system SHALL reflect changes reactively.

---
## REQ-SEC-001 — Seguridad y credenciales
- **REQ-SEC-001.1** Unwanted  
  The system SHALL NOT commit `.env`, secrets or API keys.

- **REQ-SEC-001.2** Ubiquitous  
  Sensitive values SHALL be injected via `--dart-define-from-file=defines.json`.

- **REQ-SEC-001.3** Ubiquitous  
  Passwords SHALL be hashed before transmission or persistent storage.

- **REQ-SEC-001.4** Event-driven  
  On logout, The system SHALL delete all platform storage entries.

---
## REQ-BCK-001 — Backend y datos
**Ubicación:** `lib/40_security/urls_endpoints_espacios.dart`, `direccionip.dart`  
**Actor:** sistema

- **REQ-BCK-001.1** Ubiquitous  
  Client code SHALL communicate through configured service URLs.

- **REQ-BCK-001.2** Unwanted  
  Client code SHALL NOT embed raw backend credentials in UI layers.

- **REQ-BCK-001.3** Ubiquitous  
  Database IDs SHALL follow semantic prefixes for documents, lists and groups.

**Acceptance criteria**
- `FC-001` Endpoints are centralized in urls_endpoints_espacios
- `FC-002` CouchDB error mapping exposed via couchdb_errors

---
## REQ-OS-001 — Detección de plataforma
**Ubicación:** `lib/42_sistema_operativo/detecta_os.dart`  
**Actor:** sistema

- **REQ-OS-001.1** Ubiquitous  
  The system SHALL detect host platform and expose platform-specific behavior.

- **REQ-OS-001.2** State-driven  
  While PL == web, The system SHALL apply Web-specific storage constraints.

---
## REQ-LST-001 — Listas de usuario
**Ubicación:** `lib/03_listas/`  
**Actor:** usuario autenticado

- **REQ-LST-001.1** Ubiquitous  
  The system SHALL create, delete and reorder user lists, with "Favoritas" first.

- **REQ-LST-001.2** Ubiquitous  
  The system SHALL add and remove properties from lists.

- **REQ-LST-001.3** State-driven  
  While list becomes empty after remove, The system SHALL reflect empty state.

---
## REQ-LST-002 — Likes y favoritos
- **REQ-LST-002.1** Ubiquitous  
  The system SHALL toggle me gusta with optimistic UI feedback.

- **REQ-LST-002.2** Event-driven  
  When first like happens and "Favoritas" does not exist, The system SHALL create it.

---
## REQ-LST-003 — Compartir
**Ubicación:** `lib/03_listas/page_compartir_con_conocido.dart`, `page_compartir_con_grupo.dart`  
**Actor:** usuario autenticado

- **REQ-LST-003.1** State-driven  
  While share target is known, The system SHALL allow sharing up to 5 known users or groups.

- **REQ-LST-003.2** Event-driven  
  On confirm, The system SHALL persist share records and notify target.

- **REQ-LST-003.3** Unwanted  
  The system SHALL NOT allow sharing without explicit confirmation.

---
## REQ-VST-001 — Vistas por perfil
**Ubicación:** `lib/03_vistas/`  
**Actor:** visitante autenticado

- **REQ-VST-001.1** State-driven  
  While viewing landing for PERFIL, The system SHALL present matching page variant.

- **REQ-VST-001.2** Ubiquitous  
  The system SHALL keep view routes accessible from principal menu.

---
## RNF-001 — Multiplataforma
The system SHALL run on Android, iOS, Web WASM and Windows with shared business logic.

## RNF-002 — Estado reactivo
The system SHALL use Riverpod and Freezed for predictable state transitions.

## RNF-003 — Deep links recuperación
The system SHALL support `/recuperar?token=&perfil=` deep link flow.

## RNF-004 — Google Maps integrado
The system SHALL integrate Google Maps for property and locality workflows.

## RNF-005 — Sesión diferenciada
The system SHALL store sessions on secure/non-secure storage based on platform.

## RNF-006 — PDF propiedad
The system SHALL generate downloadable PDFs for property details.
