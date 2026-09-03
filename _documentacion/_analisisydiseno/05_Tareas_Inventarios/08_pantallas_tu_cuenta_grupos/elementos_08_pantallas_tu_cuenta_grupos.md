# Inventario de Elementos — Pantallas: Tu Cuenta > Grupos (Red Comunitaria) (08_pantallas/tu_cuenta/grupos)

**Directorio:** `lib\08_pantallas\tu_cuenta\grupos\`
**Total archivos `.dart`:** 19 (6 en raíz [views/pages] + 8 en `models/` [incluye 2 generados] + 5 en `providers/`)
**Total líneas aprox:** 4,170 (raíz 2,651 + models 1,525 + providers 1,030). Modelos generados: +829 líneas en `.freezed.dart` y `.g.dart`.
**Epic asociado:** [`02_Epics_EARS/08_pantallas_tu_cuenta_grupos.md`](../../02_Epics_EARS/08_pantallas_tu_cuenta_grupos.md)
**Features BDD:** [`03_Features_BDD/08_pantallas_tu_cuenta_grupos/grupos_red_comunitaria.feature`](../../03_Features_BDD/08_pantallas_tu_cuenta_grupos/grupos_red_comunitaria.feature) (16 escenarios)
**User Stories:** [`04_User_Stories/08_pantallas_tu_cuenta_grupos.md`](../../04_User_Stories/08_pantallas_tu_cuenta_grupos.md) (7 US)
**Fecha:** 2026-08-13
**Fuente:** Ingeniería inversa

---

## Tabla 1 — Resumen de componentes por rol funcional

| # | Componente | Ruta | Tipo | Rol funcional | Líneas | US-GPU |
|---|-------------|------|------|----------------|--------|--------|
| 1 | `GruposView` (3 tabs hub) | `grupos_view.dart` | ConsumerStatefulWidget | Hub central | 101 | US-GPU-007 |
| 2 | `PageMisGrupos`, `_PageMisGruposState`, `_GrupoCard` | `page_mis_grupos.dart` | ConsumerStatefulWidget + sub-widget | Tab 1 — lista de mis grupos | 482 | US-GPU-001 |
| 3 | `PageDescubrirGrupos`, `_GrupoDescubrirCard` | `page_descubrir_grupos.dart` | ConsumerWidget + sub-widget | Tab 2 — descubre grupos para unirse | 325 | US-GPU-003 |
| 4 | `PageInvitacionesGrupo`, 4 sub-widgets (`_ListaInvitaciones`, `_InvitacionCard`, `_StatusBadge`) | `page_invitaciones_grupo.dart` | ConsumerStatefulWidget + 4 sub | Tab 3 — aceptar/rechazar invitaciones | 352 | US-GPU-003 |
| 5 | `PageDetalleGrupo`, `_PageDetalleGrupoState`, `_TabPublicaciones`, `_TarjetaPublicacion`, `_TabMiembros`, `_TabAvisos`, `_TabAvisosState`, `_TarjetaAviso`, `_InfoRow` | `page_detalle_grupo.dart` | ConsumerStatefulWidget + 7 sub-widgets | Detalle 4 tabs | 993 | US-GPU-002, 005, 006 |
| 6 | `PageChatGrupo`, `_PageChatGrupoState`, `_BurbujaMensaje`, `_BurbujaPropiedad`, `_BurbujaLista`, `_BarraInput`, `ChatGrupoEmbebido`, `_ChatGrupoEmbebidoState` | `page_chat_grupo.dart` | StatefulWidget + 6 sub-widgets | Chat grupal | 358 | US-GPU-004 |
| 7 | `Grupo` (Freezed), `MiembroGrupo` (Freezed) | `models/grupo.dart` | Modelo Freezed | Grupo + miembros | 34 | todas |
| 8 | (generado) `grupo.freezed.dart` | `models/` | build_runner | Boilerplate Freezed (Grupo + MiembroGrupo) | 782 | — |
| 9 | (generado) `grupo.g.dart` | `models/` | build_runner | Json serializable | 47 | — |
| 10 | `GrupoModel`, `MiembroGrupoModel` | `models/grupo_model.dart` | Modelo json manual | Duplica funcionalidad de Grupo Freezed | 111 | ⚠ deuda |
| 11 | `InvitacionGrupoModel` | `models/invitacion_grupo_model.dart` | Modelo json manual | Tipado invitación | 69 | US-GPU-003 |
| 12 | `MensajeGrupoModel` | `models/mensaje_grupo_model.dart` | Modelo json manual | Tipado mensaje chat | 69 | US-GPU-004 |
| 13 | `PublicacionGrupoModel` | `models/publicacion_grupo_model.dart` | Modelo json manual | Tipado publicación propiedad en grupo | 61 | US-GPU-006 |
| 14 | `AvisoGrupoModel` | `models/aviso_grupo_model.dart` | Modelo json manual | Tipado aviso | 52 | US-GPU-005 |
| 15 | `GruposNotifier` | `providers/grupos_notifier.dart` | AsyncNotifier | CRUD grupos + miembros | 249 | US-GPU-001, 003 |
| 16 | `GruposInvitacionesNotifier` | `providers/grupos_invitaciones_provider.dart` | AsyncNotifier | Invitaciones / requests (enviar, aceptar, rechazar) | 280 | US-GPU-003 |
| 17 | `MensajesGrupoNotifier` | `providers/grupos_mensajes_provider.dart` | AsyncNotifier | Lista paginada mensajes + envío | 200 | US-GPU-004 |
| 18 | `PublicacionesGrupoNotifier` | `providers/publicaciones_grupo_provider.dart` | AsyncNotifier | Lista publicaciones + publicación nueva | 168 | US-GPU-006 |
| 19 | `AvisosGrupoNotifier` | `providers/avisos_grupo_provider.dart` | AsyncNotifier | Lista avisos + creación (sólo admin) | 133 | US-GPU-005 |

---

## Tabla 2 — Detalle por archivo fuente (excluye generados)

| # | Ruta relativa | Clases / Sub-widgets | Líneas | Dependencias clave | Estado | Comentario / Deuda |
|---|---------------|----------------------|--------|---------------------|--------|--------------------|
| 1 | `grupos_view.dart` | `GruposView`, `_GruposViewState` | 101 | `flutter_riverpod`, `symbols`, `var_color_*`, `page_mis_grupos`, `page_descubrir_grupos`, `page_invitaciones_grupo`, `grupos_invitaciones_provider` | ✓ ok | Hub bien modular (101 líneas). Patrón opuesto a tus_espacios |
| 2 | `page_mis_grupos.dart` | `PageMisGrupos`, `_PageMisGruposState`, `_GrupoCard` | 482 | `flutter_riverpod`, `symbols`, `var_color_*`, `grupos_notifier`, `models/grupo`, `page_detalle_grupo`, `app_routes` | ✓ ok + deuda | `_GrupoCard` duplica `_GrupoDescubrirCard` visualmente (refactor: factor common) |
| 3 | `page_descubrir_grupos.dart` | `PageDescubrirGrupos`, `_GrupoDescubrirCard` | 325 | `flutter_riverpod`, `symbols`, `var_color_*`, `grupos_notifier`, `grupos_invitaciones_provider`, `models/grupo`, `models/invitacion_grupo_model` | ✓ ok | CTA condicional según público/privado |
| 4 | `page_invitaciones_grupo.dart` | `PageInvitacionesGrupo`, `_PageInvitacionesGrupoState`, `_ListaInvitaciones`, `_InvitacionCard`, `_StatusBadge` | 352 | `flutter_riverpod`, `symbols`, `var_color_*`, `grupos_invitaciones_provider`, `models/invitacion_grupo_model`, `provider_session` | ✓ ok | 4 sub-widgets — bien separados, aunque podrían vivir en archivo propio |
| 5 | `page_detalle_grupo.dart` | `PageDetalleGrupo`, `_PageDetalleGrupoState`, `_TabPublicaciones`, `_TarjetaPublicacion`, `_TabMiembros`, `_TabAvisos`, `_TabAvisosState`, `_TarjetaAviso`, `_InfoRow` | 993 | `flutter_riverpod`, `symbols`, `var_color_*`, `grupos_notifier`, `publicaciones_grupo_provider`, `avisos_grupo_provider`, `grupos_mensajes_provider`, `page_chat_grupo`, `page_mis_grupos`, `08_pantallas/propiedades` (PaginaDetalleWidget via routing), `03_listas` (PageDetalleLista via routing), `future_builder_state_widgets`, `app_routes`, `provider_session` | ⚠ **deuda crítica** | **993 líneas con 7 sub-widgets anidados**. Refactor urgente: extraer cada `_TabX` a `tabs/tab_*.dart` independiente |
| 6 | `page_chat_grupo.dart` | `PageChat Grupo`, `_PageChatGrupoState`, `_BurbujaMensaje`, `_BurbujaPropiedad`, `_BurbujaLista`, `_BarraInput`, `ChatGrupoEmbebido`, `_ChatGrupoEmbebidoState` | 358 | `flutter_riverpod`, `symbols`, `var_color_*`, `grupos_mensajes_provider`, `models/mensaje_grupo_model`, `provider_session`, `format_chat_timestamp` (`20_var_globales`), `future_builder_state_widgets`, `app_routes` | ⚠ deuda | **`_BurbujaPropiedad`/`_BurbujaLista` DUPLICAN** `page_chat_privado.dart` (conocidos). Refactor `60_global_widgets/burbuja_propiedad_lista.dart` reutilizable. **`ChatGrupoEmbebido` buen patrón reutilizable** — candidato a `60_global_widgets/chat_embebido.dart` para futuros módulos |
| 7 | `models/grupo.dart` | `Grupo` (Freezed), `MiembroGrupo` (Freezed) | 34 | `freezed`, `json_serializable` | ✓ ok | Único Freezed del módulo — genera `.freezed` (782) + `.g` (47) |
| 8 | `models/grupo_model.dart` | `GrupoModel`, `MiembroGrupoModel` | 111 | `dart:convert` | ⚠ deuda | **Duplica funcionalidad de `models/grupo.dart`** (Freezed) — inconsistencia. Unificar a una sola representación |
| 9 | `models/invitacion_grupo_model.dart` | `InvitacionGrupoModel` | 69 | `dart:convert` | ⚠ deuda menor | Json manual (no Freezed). Como el resto de modelos del módulo |
| 10 | `models/mensaje_grupo_model.dart` | `MensajeGrupoModel` | 69 | `dart:convert` | ⚠ deuda menor | Json manual |
| 11 | `models/publicacion_grupo_model.dart` | `PublicacionGrupoModel` | 61 | `dart:convert` | ⚠ deuda menor | Json manual |
| 12 | `models/aviso_grupo_model.dart` | `AvisoGrupoModel` | 52 | `dart:convert` | ⚠ deuda menor | Json manual |
| 13 | `providers/grupos_notifier.dart` | `GruposNotifier` (AsyncNotifier) | 249 | `flutter_riverpod`, `dio`, `direccionip`, `models/grupo`, `models/grupo_model`, `provider_session`, `grupos_mensajes_provider`, `debugprint` | ⚠ deuda | Provider legacy `AsyncNotifier` no `@riverpod` anotado. CRUD + membprefs del usuario |
| 14 | `providers/grupos_invitaciones_provider.dart` | `GruposInvitacionesNotifier` (AsyncNotifier) | 280 | `flutter_riverpod`, `dio`, `direccionip`, `models/invitacion_grupo_model`, `models/grupo`, `grupos_notifier`, `grupos_mensajes_provider`, `provider_session`, `debugprint` | ⚠ deuda | Provider legacy. Envío/aceptar/rechazar invitaciones. Sin atomicidad en `aceptarInvitacion` (deuda transaccional) |
| 15 | `providers/grupos_mensajes_provider.dart` | `MensajesGrupoNotifier` (AsyncNotifier) | 200 | `flutter_riverpod`, `dio`, `direccionip`, `models/mensaje_grupo_model`, `models/grupo_model`, `provider_session`, `debugprint` | ⚠ deuda | Provider legacy. Lista paginada + envío (texto/propiedad/lista/sistema) |
| 16 | `providers/publicaciones_grupo_provider.dart` | `PublicacionesGrupoNotifier` (AsyncNotifier) | 168 | `flutter_riverpod`, `dio`, `direccionip`, `models/publicacion_grupo_model`, `inicio/data_espacios_casas_get`, `provider_session`, `debugprint` | ⚠ deuda | Provider legacy. **Acoplado con inicio** (data_espacios_casas_get) — esperar por consulta de propiedad |
| 17 | `providers/avisos_grupo_provider.dart` | `AvisosGrupoNotifier` (AsyncNotifier) | 133 | `flutter_riverpod`, `dio`, `direccionip`, `models/aviso_grupo_model`, `provider_session`, `debugprint` | ⚠ deuda | Provider legacy. Filtra por expiry implícito con Mixin query (?, deuda: debería verificar `fechaExpiracion > now` en código ) |

---

## Notas críticas

- **Módulo más grande de `08_pantallas/tu_cuenta`** (19 archivos + 829 generados = total >5,000 líneas), pero mejor organizado que `tus_espacios` (sin archivos gigantescos excepto `page_detalle_grupo.dart` 993).
- **Duplicidad `Grupo` (Freezed) vs `GrupoModel` (json manual)** — importante deuda de representación. Refactor: mantener `Grupo` Freezed, eliminar `GrupoModel` y actualizar consumidores.
- **`_BurbujaPropiedad`/`_BurbujaLista` duplicados** con `page_chat_privado.dart` (conocidos) — refactor prioritario a `60_global_widgets/burbuja_propiedad_lista.dart` reutilizable en ambos chats.
- **`ChatGrupoEmbebido` patrón reutilizable** bien diseñado — promovedor a `60_global_widgets/chat_embebido.dart` para futuros módulos (transacciones, tutoriales, etc.).
- **Todos los providers (5) son `AsyncNotifier` legacy** sin `@riverpod` annotation. Migración pendiente con `build_runner`. Riverpod 3.x lo deprecó.
- **`PublicacionesGrupoProvider` acoplado con inicio** (`data_espacios_casas_get`) — arrastrar datos de propiedad por publicación. Acoplamiento delicado.
- **Sin tests** de ningún archivo (6 pages + 8 models + 5 providers). Crítico por la naturaleza social del módulo.
- **Acoplamiento transversal esperado:**
  - `08_pantallas/propiedades` (`PaginaDetalleWidget` desde burbujas y publicaciones).
  - `03_listas` (`PageDetalleLista` desde burbujas; y `03_listas/page_compartir_con_grupo.dart` ya usa `publicacionesGrupoProvider` + `buscobien_publicaciones_grupo` — ver US-LIST-005 de 03_listas, dualidad).
  - `40_security` (creds via `direccionip`).
  - `10_user_login` (`provider_session`).
  - `20_var_globales` (`format_chat_timestamp`, `var_color_*`).
- **DBs CouchDB involucradas** (transversal `06_Bases_de_Datos`): `buscobien_grupos`, `buscobien_grupos_miembros`, `buscobien_invitaciones_grupos`, `buscobien_mensajes_grupos`, `buscobien_publicaciones_grupo`, `buscobien_avisos_grupo`.
- **Sin atomicidad en `aceptarInvitacion`** de `GruposInvitacionesNotifier` (crea doc miembro + mensaje de sistema en secuencia sin `_bulk_docs`) — deuda transaccional.
- **`page_detalle_grupo.dart` 993 líneas** con 7 sub-widgets anidados — refactor urgente extraer a `tabs/tab_*.dart`.
- **Inconsistencia de layout de subcarpetas**:
  - `conocidos/` tiene `Conocido` modelo Freezed en `models/` pero `MensajeModel` e `InvitacionModel` en raíz (json manual).
  - `grupos/` tiene mejor estructura: todos los modelos en `models/` (1 Freezed + 5 json manual + 2 generados), todos los providers en `providers/`.
  - Las páginas\views viven en raíz — patrón esperado.
- **Deuda no documentada en el código: filtrar expirados en avisos** — `AvisosGrupoNotifier` debería chequear `fechaExpiracion > now` en el listado; deuda de implementación.
