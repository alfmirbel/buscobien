# Inventario de Elementos — Pantallas: Tu Cuenta > Conocidos (Red Social) (08_pantallas/tu_cuenta/conocidos)

**Directorio:** `lib\08_pantallas\tu_cuenta\conocidos\`
**Total archivos `.dart`:** 14 (10 fuente en raíz + 3 en `models/` [incluye 2 generados] + 1 en `providers/`)
**Total líneas aprox:** 1,957 (raíz 1,135 + models 557 + providers 250 + conocidos_view 71)
**Epic asociado:** [`02_Epics_EARS/08_pantallas_tu_cuenta_conocidos.md`](../../02_Epics_EARS/08_pantallas_tu_cuenta_conocidos.md)
**Features BDD:** [`03_Features_BDD/08_pantallas_tu_cuenta_conocidos/conocidos_red_social.feature`](../../03_Features_BDD/08_pantallas_tu_cuenta_conocidos/conocidos_red_social.feature) (13 escenarios)
**User Stories:** [`04_User_Stories/08_pantallas_tu_cuenta_conocidos.md`](../../04_User_Stories/08_pantallas_tu_cuenta_conocidos.md) (6 US)
**Fecha:** 2026-08-13
**Fuente:** Ingeniería inversa

---

## Tabla 1 — Resumen de componentes por rol funcional

| # | Componente | Ruta relativa | Tipo | Rol funcional | US-CON |
|---|-------------|---------------|------|----------------|--------|
| 1 | `ConocidosView` | `conocidos_view.dart` | ConsumerStatefulWidget | Hub 3 tabs (Contactos/Descubrir/Invitaciones) | US-CON-006 |
| 2 | `PageMisContactos`, `_PageMisContactosState` | `page_mis_contactos.dart` | ConsumerStatefulWidget | Tab 1 — lista mis contactos | US-CON-001 |
| 3 | `PageDescubrirUsuarios` | `page_descubrir_usuarios.dart` | ConsumerWidget | Tab 2 — búsqueda de usuarios para invitar | US-CON-002 |
| 4 | `PageInvitaciones` | `page_invitaciones.dart` | ConsumerWidget | Tab 3 — invitaciones recibidas (aceptar/rechazar) | US-CON-003 |
| 5 | `PagePerfilContacto` | `page_perfil_contacto.dart` | ConsumerWidget | Perfil de contacto con CTAs condicionales | US-CON-004 |
| 6 | `PageChatPrivado`, `_PageChatPrivadoState`, `_BurbujaPropiedad`, `_BurbujaLista` | `page_chat_privado.dart` | StatefulWidget + 2 sub-widgets | Chat 1:1 con texto/propiedad/lista | US-CON-005 |
| 7 | `MensajesChatNotifier` | `provider_mensajes.dart` | Riverpod Notifier | Estado reactivo de mensajes paginados | US-CON-005 |
| 8 | `InvitacionesNotifier` | `social_providers.dart` | Riverpod Notifier | Envío/aceptar/rechazar invitaciones | US-CON-002, 003 |
| 9 | `MensajeModel` | `mensaje_model.dart` | Modelo (json manual) | Tipado mensaje chat | US-CON-005 |
| 10 | `InvitacionModel` | `invitacion_model.dart` | Modelo (json manual) | Tipado invitación | US-CON-002, 003 |
| 11 | `Conocido` | `models/conocido.dart` | Modelo **Freezed** | Tipado contacto | US-CON-001, 004 |
| 12 | (generado) `conocido.freezed.dart` | `models/` | build_runner | Boilerplate Freezed | — |
| 13 | (generado) `conocido.g.dart` | `models/` | build_runner | Json serializable boilerplate | — |
| 14 | `ConocidosNotifier` | `providers/conocidos_notifier.dart` | Riverpod Notifier | Lista de conocidos del usuario | US-CON-001, 004 |

---

## Tabla 2 — Detalle por archivo fuente (excluye `.g.dart`/`.freezed.dart` generados)

| # | Ruta relativa | Clases / Funciones | Líneas | Dependencias clave | Estado | Comentario / Deuda |
|---|---------------|--------------------|--------|---------------------|--------|--------------------|
| 1 | `conocidos_view.dart` | `ConocidosView`, `_ConocidosViewState` | 71 | `flutter`, `flutter_riverpod`, `symbols`, `var_color_*`, `page_mis_contactos`, `page_descubrir_usuarios`, `page_invitaciones`, `social_providers` | ✓ ok | Hub bien modular (71 líneas). `TabController(length:3)` con `PageStorageKey` preserva scroll. Badge de invitaciones pendientes |
| 2 | `page_mis_contactos.dart` | `PageMisContactos`, `_PageMisContactosState` | 140 | `flutter`, `flutter_riverpod`, `symbols`, `var_color_*`, `providers/conocidos_notifier`, `models/conocido`, `page_perfil_contacto`, `app_routes` | ✓ ok | Tamaño razonable. Estado reactive con `ref.watch(conocidosNotifierProvider)` |
| 3 | `page_descubrir_usuarios.dart` | `PageDescubrirUsuarios` | 173 | `flutter_riverpod`, `symbols`, `var_color_*`, `dio`/`direccionip` (para search CouchDB), `social_providers` (InvitacionesNotifier), `provider_session`, `app_routes` | ✓ ok | Búsqueda por nombre/email. CTAs condicionales son conocidos / hay invitación pendiente / nuevo. Usa Dio implícitamente |
| 4 | `page_invitaciones.dart` | `PageInvitaciones` | 162 | `flutter_riverpod`, `symbols`, `social_providers`, `invitacion_model`, `var_color_*`, `provider_session` | ✓ ok | Lista invitations pendientes. Botones Aceptar/Rechazar invocan `aceptarInvitacion`/`rechazarInvitacion` |
| 5 | `page_perfil_contacto.dart` | `PagePerfilContacto` | 159 | `flutter_riverpod`, `symbols`, `var_color_*`, `provider_session`, `providers/conocidos_notifier`, `social_providers`, `provider_mensajes`, `app_routes` | ✓ ok | CTAs condicionales. Tamaño razonable. Deuda: privacidad datos mostrados (no controlado aún) |
| 6 | `page_chat_privado.dart` | `PageChatPrivado`, `_PageChatPrivadoState`, `_BurbujaPropiedad`, `_BurbujaLista` | 398 | `flutter_riverpod`, `symbols`, `var_color_*`, `provider_mensajes`, `mensaje_model`, `provider_session`, `future_builder_state_widgets`, `app_routes` (+ indirectas: `08_pantallas/propiedades`, `03_listas`) | ⚠ deuda | **`_BurbujaPropiedad` `/BurbujaLista` duplican** los sub-widgets de `page_chat_grupo.dart` (grupos) → refactor `60_global_widgets/burbuja_propiedad_lista.dart` reutilizable |
| 7 | `provider_mensajes.dart` | `MensajesChatNotifier` (Riverpod Notifier) | 225 | `flutter_riverpod`, `dio`, `direccionip`, `mensaje_model`, `provider_session`, `debugprint` | ⚠ deuda | Provider legacy `Notifier` (no `@riverpod` anotado). Migrar a Riverpod 3.x con annotation. Soporta tipos 'texto', 'propiedad', 'lista', 'sistema' |
| 8 | `social_providers.dart` | `InvitacionesNotifier` (Riverpod Notifier) | 217 | `flutter_riverpod`, `dio`, `direccionip`, `invitacion_model`, `provider_session`, `models/conocido`, `mensaje_model`, `debugprint` | ⚠ deuda | **`aceptarInvitacion` no transaccional** — riesgo de estado inconsistente si falla mid-batch (crea conocidos + mensaje). Refactor: `_bulk_docs`. Provider legacy sin `@riverpod` |
| 9 | `mensaje_model.dart` | `MensajeModel` | 61 | `dart:convert` | ⚠ deuda menor | Json manual (no Freezed) inconsistente con `models/conocido.dart` |
| 10 | `invitacion_model.dart` | `InvitacionModel` | 59 | `dart:convert` | ⚠ deuda menor | Json manual (no Freezed) |
| 11 | `models/conocido.dart` | `Conocido` (Freezed) | 26 | `freezed`, `json_serializable` | ✓ ok | Único Freezed del módulo — genere .freezed.dart (496 líneas) y .g.dart (35) |
| 12 | `providers/conocidos_notifier.dart` | `ConocidosNotifier` (Riverpod Notifier) | 250 | `flutter_riverpod`, `dio`, `direccionip`, `models/conocido`, `provider_session`, `debugprint` | ⚠ deuda | Provider legacy. CRUD de conocidos (fetch, delete bidireccional) |

---

## Notas críticas

- **Arquitectura de hub simple (`ConocidosView` 71 líneas)** con 3 pages separados — patrón opuesto a `tus_espacios`, bien modular.
- **Inconsistencia modelo Freezed/json-manual**: `models/conocido.dart` Freezed (único), el resto json manual. Migración pendiente para uniformidad.
- **Providers repartidos**: `provider_mensajes.dart` y `social_providers.dart` en raíz, `conocidos_notifier.dart` en `providers/`. Unificar a `providers/` consistentemente.
- **`_BurbujaPropiedad`/`_BurbujaLista` duplicados** con `page_chat_grupo.dart` (grupos) — refactor prioritario a `60_global_widgets/burbuja_propiedad_lista.dart` reutilizable.
- **Transaccionalidad `aceptarInvitacion` (REQ-CON-010)**: crea 2 docs `conocidos` + 1 mensaje en secuencia sin atomicidad. Si el mensaje falla, queda inconsistencia visible. Refactor: `_bulk_docs` CouchDB.
- **Providers legacy sin `@riverpod`**: `MensajesChatNotifier`, `InvitacionesNotifier`, `ConocidosNotifier` usan `Notifier` no-anotado. Riverpod 3.x deprecó uso no-typed; migración pendiente con `build_runner`.
- **Acoplamiento con `03_listas`** (`PageDetalleLista` navigation from `_BurbujaLista`) y `08_pantallas/propiedades` (`PaginaDetalleWidget` from `_BurbujaPropiedad`) — esperado y documentado.
- **Acoplamiento con `40_security`** (creds via `direccionip`) y `10_user_login` (`provider_session`) — esperado.
- **Sin tests** de ningún archivo (10 fuente + 3 modelos + 1 provider). Smoke global cubre arranque pero no funcionalidades sociales (invitaciones, chat, burbujas).
- **DBs CouchDB involucradas** (transversal con `06_Bases_de_Datos`): `buscobien_invitaciones`, `buscobien_conocidos_usuarios`, `buscobien_mensajes`, `buscobien_usuarios` (vía `provider_session`).
- **Privacidad perfil contacto** non-controlada — deuda de producto: datos públicos deberían ser subset configurable por el usuario.
- **`page_descubrir_usuarios` search substring**: probablemente case-sensitive exacto; deuda mejorar a Mango query `$regex` o `$text`.
