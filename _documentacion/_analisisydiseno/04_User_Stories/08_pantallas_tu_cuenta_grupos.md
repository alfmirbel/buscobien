# User Stories — Pantallas: Tu Cuenta > Grupos (Red Social Comunitaria) (08_pantallas/tu_cuenta/grupos)

**Directorio:** `lib\08_pantallas\tu_cuenta\grupos\` (19 archivos: 6 pages/views + 8 models + 5 providers)
**Epic asociado:** [`02_Epics_EARS/08_pantallas_tu_cuenta_grupos.md`](../02_Epics_EARS/08_pantallas_tu_cuenta_grupos.md)
**Feature BDD:** [`03_Features_BDD/08_pantallas_tu_cuenta_grupos/grupos_red_comunitaria.feature`](../03_Features_BDD/08_pantallas_tu_cuenta_grupos/grupos_red_comunitaria.feature) (16 escenarios)
**Inventario:** [`05_Tareas_Inventarios/08_pantallas_tu_cuenta_grupos/elementos_08_pantallas_tu_cuenta_grupos.md`](../05_Tareas_Inventarios/08_pantallas_tu_cuenta_grupos/elementos_08_pantallas_tu_cuenta_grupos.md)
**Fecha:** 2026-08-13
**Fuente:** Ingeniería inversa

---

## US-GPU-001: Ver Mis Grupos (lista de miembros)

### Card
**Como** miembro de uno o más grupos
**Quiero** ver lista de mis grupos con rol (# miembros, nombre, descripción)
**Para** acceder a cada grupo y mi actividad comunitaria.

### Conversation
- `PageMisGrupos` (`page_mis_grupos.dart`, 482 líneas, ConsumerStatefulWidget) es tab 1 de `GruposView`.
- `GruposNotifier` (`providers/grupos_notifier.dart`, 249 líneas, AsyncNotifier) lista `Grupo[]` filtrado por `miembros[]` contains `currentUser`.
- Cada tarjeta usa sub-widget `_GrupoCard` con avatar del grupo, nombre, descripción breve, # miembros, rol del currentUser ("Admin" o "Miembro").
- Tap tarjeta → navega a `PageDetalleGrupo`.
- Barra de búsqueda por nombre para filtrar visible localmente.
- **Comentario:** el sub-widget `_GrupoCard` es local al archivo — podría ser reutilizable en `PageDescubrirGrupos` (donde existe `_GrupoDescubrirCard` similar) — refactor menor.

### Confirmation
- ✓ Al abrir Mis Grupos, lista los grupos donde el usuario es miembro.
- ✓ Cada tarjeta muestra rol (Admin/Miembro).
- ✓ Tap tarjeta navega a PageDetalleGrupo.
- ✓ Feature BDD: escenarios "Ver Mis Grupos", "Hub central".

**Trazabilidad:** `REQ-GPU-002`, `REQ-GPU-003` · Archivos: `page_mis_grupos.dart`, `providers/grupos_notifier.dart`

---

## US-GPU-002: Ver detalle completo de un grupo (Publicaciones / Miembros / Avisos / Chat)

### Card
**Como** miembro de un grupo
**Quiero** una página con 4 sub-tabs que muestre publicaciones, miembros, avisos y acceso al chat
**Para** tener una vista 360° de la actividad del grupo.

### Conversation
- `PageDetalleGrupo` (`page_detalle_grupo.dart`, **993 líneas**, ConsumerStatefulWidget) — el archivo más grande del módulo.
- 4 sub-tabs mediante `TabController(length:4)`:
  1. **`_TabPublicaciones`** (`_TarjetaPublicacion` anidado): consume `PublicacionesGrupoNotifier` (`providers/publicaciones_grupo_provider.dart`, 168 líneas) que lista las propiedades compartidas en el grupo (`PublicacionGrupoModel`).
  2. **`_TabMiembros`** (`_InfoRow` auxiliar): lista miembros con avatar, nombre y rol. Si currentUser es admin: CTAs eliminar miembro, cambiar rol.
  3. **`_TabAvisos`** (`_TabAvisosState` + `_TarjetaAviso` anidado): consume `AvisosGrupoNotifier` (`providers/avisos_grupo_provider.dart`, 133 líneas) que lista avisos. Si admin: CTA "Crear aviso".
  4. **Chat** (CTA): botón "Abrir chat completo" → navega a `PageChatGrupo`.
- InfoRow superior: nombre, descripción, # miembros.
- **Comentario crítico de deuda:** 993 líneas con 6 sub-widgets anidados. Refactor: extraer cada `_TabX` a archivo propio (ej. `tabs/tab_publicaciones.dart`, `tab_miembros.dart`, `tab_avisos.dart`) subordinados a `PageDetalleGrupo` que sólo orquesta.

### Confirmation
- ✓ Al abrir un grupo, las 4 sub-tabs aparecen con contenido cargado.
- ✓ Tab Miembros muestra rol del currentUser y estados (admin/miembro).
- ✓ Tab Avisos diferencia visibilidad CTAs según rol.
- ✓ Feature BDD: escenarios "Detalle del grupo", "Tab Publicaciones", "Tab Miembros", "Admin crea aviso", "Miembro solo ve avisos".

**Trazabilidad:** `REQ-GPU-004`, `REQ-GPU-005`, `REQ-GPU-006` · Archivos: `page_detalle_grupo.dart`, `providers/publicaciones_grupo_provider.dart`, `providers/avisos_grupo_provider.dart`, `models/publicacion_grupo_model.dart`, `models/aviso_grupo_model.dart`

---

## US-GPU-003: Administrar membresías (invitar / aceptar / unirse / eliminar)

### Card
**Como** admin o usuario que descubre grupos
**Quiero** invitar a conocidos, aceptar invitaciones recibidas, unirse a públicos, eliminar miembros
**Para** gestionar la membresía de cada grupo.

### Conversation
- **Invitar (admin):** Desde `PageDetalleGrupo._TabMiembros`, admin selecciona CTAs "Invitar conocidos" → `GruposInvitacionesNotifier.enviarInvitacion(grupoId, usuariosIds[])` crea docs en `buscobien_invitaciones_grupos` con estado `pendiente`.
- **Aceptar / Rechazar (receptor):** Tab 3 Invitaciones (`PageInvitacionesGrupo` 352 líneas) lista invitaciones pendientes filtradas por `currentUser` y `estado='pendiente'`. Aceptar crea doc en `buscobien_grupos_miembros` con rol; crea mensaje de sistema en el chat (tipo `'sistema'`); marca invitación `aceptada`.
- **Unirse (grupo público):** `PageDescubrirGrupos` muestra grupos públicos con CTA "Unirse" → `GruposNotifier.unirseAlGrupo(grupoId)` crea doc miembro con rol `miembro` (sin aprobación).
- **Unirse (grupo privado):** CTA "Solicitar unirse" crea `invitacion_grupo` tipo `request` con estado pendiente → el admin ve la solicitud en tab Invitaciones y decide.
- **Eliminar miembro (admin):** Desde `_TabMiembros`, CTA "Eliminar" + confirmación → `GruposNotifier.eliminarMiembro` DELETE en `buscobien_grupos_miembros` + mensaje de sistema.
- `InvitacionGrupoModel` (`models/invitacion_grupo_model.dart`, 69 líneas) tipa el documento con: `idGrupo`, `idOrigen`, `idDestino`, `estado` (pendiente/aceptada/rechazada/request), `timestamp`, `tipo` (invitacion/request).

### Confirmation
- ✓ Admin puede invitar a conocidos y ver sus invitaciones pendientes/aceptadas.
- ✓ Receptor puede aceptar/rechazar invitaciones y al aceptar queda en Mis Grupos.
- ✓ Usuario puede unirse a públicos sin admin.
- ✓ Usuario puede solicitar unirse a privados; el admin decide.
- ✓ Admin puede eliminar miembros con confirmación.
- ✓ Feature BDD: escenarios "Invitaciones a grupo (admin invita)", "Aceptar invitación", "Descubrir grupos", "Unirse a público/privado", "Eliminar miembro".

**Trazabilidad:** `REQ-GPU-007`, `REQ-GPU-008` · Archivos: `page_descubrir_grupos.dart`, `page_invitaciones_grupo.dart`, `providers/grupos_invitaciones_provider.dart`, `providers/grupos_notifier.dart`, `models/invitacion_grupo_model.dart`

---

## US-GPU-004: Chatear en el grupo (grupal con propiedad/lista)

### Card
**Como** miembro de un grupo
**Quiero** un chat grupal que reciba mensajes de texto + propiedad + lista + aviso como burbujas especiales
**Para** coordinar la búsqueda/compra/renta con múltiples miembros simultáneamente.

### Conversation
- `PageChatGrupo` (`page_chat_grupo.dart`, 358 líneas, StatefulWidget) recibe `grupoId`.
- `MensajesGrupoNotifier` (`providers/grupos_mensajes_provider.dart`, 200 líneas) lista `MensajeGrupoModel[]` paginados por `grupoId`.
- Burbujas por tipo:
  - **texto:** burbuja normal con avatar autor + nombre + timestamp.
  - **propiedad:** `_BurbujaPropiedad` (sub-widget duplicado de `page_chat_privado.dart` en conocidos) — tarjeta miniatura foto, precio, ubicación; tap → `PaginaDetalleWidget`.
  - **lista:** `_BurbujaLista` (sub-widget duplicado) — tarjeta nombre de la lista + # propiedades; tap → `PageDetalleLista`.
  - **sistema:** burbuja informativa (azul sin autor) — "Nuevo miembro se unió", "XY fue eliminado", etc.
- Barra input `_BarraInput` sub-widget con cámara/adjunto/CTA compartir propiedad/lista.
- `ChatGrupoEmbebido` + `_ChatGrupoEmbebidoState` sub-widget reutilizable para embeber chat en otras pantallas (ej. en `PageDetalleGrupo` tab Chat si es necesario).
- **Comentario crítico de deuda:** `_BurbujaPropiedad` y `_BurbujaLista` en `page_chat_grupo.dart` DUPLICAN los de `page_chat_privado.dart` (conocidos). Refactor urgente a `60_global_widgets/burbuja_propiedad_lista.dart` reusable.

### Confirmation
- ✓ Abrir `PageChatGrupo` con `grupoId` muestra conversación paginada.
- ✓ Enviar texto crea burbuja autor + mensaje persiste en DB.
- ✓ Compartir propiedad crea `_BurbujaPropiedad` visible para todos.
- ✓ Compartir lista crea `_BurbujaLista` con nombre + contador.
- ✓ Mensajes del sistema (nuevo miembro, etc.) se renderizan diferenciados.
- ✓ `ChatGrupoEmbebido` permite embeber chat en otras pantallas.
- ✓ Feature BDD: escenarios "Chat grupal", "Compartir propiedad/lista en chat", "ChatGrupoEmbebido".

**Trazabilidad:** `REQ-GPU-009`, `REQ-GPU-010`, `REQ-GPU-012` · Archivos: `page_chat_grupo.dart`, `providers/grupos_mensajes_provider.dart`, `models/mensaje_grupo_model.dart`

---

## US-GPU-005: Publicar y recibir avisos internos del grupo (sólo admin crea)

### Card
**Como** admin del grupo
**Quiero** crear avisos internos que notifiquen a todos los miembros
**Para** comunicar decisiones, eventos próximos, recordatorios importantes sin recurrir al chat eager.

### Conversation
- `_TabAvisos` (`page_detalle_grupo.dart`) consume `AvisosGrupoNotifier` (`providers/avisos_grupo_provider.dart`, 133 líneas) que lista `AvisoGrupoModel[]` por `grupoId`.
- `AvisoGrupoModel` (`models/aviso_grupo_model.dart`, 52 líneas) tipa el documento: `idGrupo`, `idUsuarioAutor`, `titulo`, `contenido`, `timestamp`, `fechaExpiracion` (opcional).
- Admin: CTA "Crear aviso" → formulario simple (título + contenido + expiry opcional) → al submitir, `creaAviso` persiste en `buscobien_avisos_grupo` y dispara mensaje_grupo tipo `'aviso'` con payload (sin título completo, sólo referencia al aviso).
- Miembros: ven la lista de avisos + badge cuando hay nuevo. No pueden crear (CTA oculto). Pueden marcar como leído (opcional).
- Aviso con `fechaExpiracion`: pasada la fecha, se oculta (deuda: el notifier debería filtrar expiry < now).

### Confirmation
- ✓ Admin puede crear avisos con título + contenido.
- ✓ Miembros ven avisos listados y reciben notificación en el chat (mensaje tipo aviso).
- ✓ Miembros no-admin NO ven el CTA "Crear aviso".
- ✓ Feature BDD: escenarios "Admin crea aviso", "Miembro solo ve avisos".

**Trazabilidad:** `REQ-GPU-006` · Archivos: `page_detalle_grupo.dart` (`_TabAvisos`), `providers/avisos_grupo_provider.dart`, `models/aviso_grupo_model.dart`

---

## US-GPU-006: Compartir propiedades en el grupo (PublicacionesGrupo)

### Card
**Como** miembro del grupo
**Quiero** compartir propiedades de "Tus Espacios" al feed de Publicaciones del grupo
**Para** que todos los miembros vean opciones de catálogo relevantes para el grupo (ej. grupo "Casa Baja California" recibe propiedades de BC).

### Conversation
- `_TabPublicaciones` consume `PublicacionesGrupoNotifier` (`providers/publicaciones_grupo_provider.dart`, 168 líneas) que lista propiedades compartidas en el grupo (`PublicacionGrupoModel[]`).
- `PublicacionGrupoModel` (`models/publicacion_grupo_model.dart`, 61 líneas): `idGrupo`, `idPropiedad`, `idUsuarioCompartidor`, `timestamp`.
- Cualquier miembro puede publicar (no restringido a admin): CTA "Compartir propiedad" en `_TabPublicaciones`.
- Anti-duplicado: si `idGrupo + idPropiedad` ya existe, silent skip.
- `_TarjetaPublicacion` sub-widget renderiza la tarjeta con miniatura + precio + ubicación + nombre del compartidor.
- Tap tarjeta → `PaginaDetalleWidget`.
- **Comentario:** la DB `buscobien_publicaciones_grupo` es la misma referenciada en `03_listas/page_compartir_con_grupo.dart` (US-LIST-005 de 03_listas, donde se comparte propiedad a grupo vía chat). Aquí es una publicación permanente en la tab Publicaciones (vs el chat que es efímera). Documentado para claridad.

### Confirmation
- ✓ Cualquier miembro puede publicar una propiedad al grupo.
- ✓ Repetir el POST no duplica (anti-dup).
- ✓ Las publicaciones aparecen en `_TabPublicaciones` ordenadas por timestamp descendente.
- ✓ Tap tarjeta publicada abre detalle de propiedad.
- ✓ Feature BDD: escenario "Tab Publicaciones del grupo".

**Trazabilidad:** `REQ-GPU-005` · Archivos: `page_detalle_grupo.dart` (`_TabPublicaciones`), `providers/publicaciones_grupo_provider.dart`, `models/publicacion_grupo_model.dart`

---

## US-GPU-007: Hub GruposView 3 tabs con badge

### Card
**Como** usuario
**Quiero** un hub con Mis Grupos / Descubrir / Invitaciones sincronizado con badges de pendientes
**Para** gestionar toda mi actividad comunitaria desde un punto central.

### Conversation
- `GruposView` (`grupos_view.dart`, 101 líneas, ConsumerStatefulWidget) usa `TabController(length:3)`.
- Tab 1 Mis Grupos → US-GPU-001; Tab 2 Descubrir → US-GPU-003 (parcial — descubre grupos); Tab 3 Invitaciones → US-GPU-003 (aceptar/rechazar).
- Badge en Tab 3 Invitaciones muestra cantidad pendiente (escucha reactiva de `GruposInvitacionesNotifier` filtrado por pendiente + currentUser).
- Cambio de tab preserva scroll position (`PageStorageKey`).

### Confirmation
- ✓ Hub muestra 3 tabs sincronizados.
- ✓ Badge de invitaciones pendientes se actualiza reactivamente.
- ✓ Cada tab carga su page correspondiente con PageStorageKey.
- ✓ Feature BDD: escenario "Hub central GruposView".

**Trazabilidad:** `REQ-GPU-002` · Archivos: `grupos_view.dart`

---

## Resumen matriz

| US | Epic Req | Escenarios BDD | Archivos principales |
|----|----------|----------------|----------------------|
| US-GPU-001 (Mis Grupos) | REQ-GPU-002, 003 | 2 | `page_mis_grupos.dart`, `providers/grupos_notifier.dart` |
| US-GPU-002 (Detalle 4 tabs) | REQ-GPU-004, 005, 006 | 5 | `page_detalle_grupo.dart` (993 lines) |
| US-GPU-003 (Membresías) | REQ-GPU-007, 008 | 5 | `page_descubrir_grupos.dart`, `page_invitaciones_grupo.dart`, `providers/grupos_invitaciones_provider.dart` |
| US-GPU-004 (Chat grupal burbujas) | REQ-GPU-009, 010, 012 | 3 | `page_chat_grupo.dart`, `providers/grupos_mensajes_provider.dart` |
| US-GPU-005 (Avisos admin) | REQ-GPU-006 | 2 | `page_detalle_grupo.dart` `_TabAvisos`, `providers/avisos_grupo_provider.dart` |
| US-GPU-006 (PublicacionesGrupo) | REQ-GPU-005 | 1 | `page_detalle_grupo.dart` `_TabPublicaciones`, `providers/publicaciones_grupo_provider.dart` |
| US-GPU-007 (Hub 3 tabs) | REQ-GPU-002 | 1 | `grupos_view.dart` |

---

## Notas de deuda técnica

1. **`PageDetalleGrupo` 993 líneas** con 6 sub-widgets anidados. Refactor: extraer cada `_TabX` a archivo propio `tabs/tab_*.dart` subordinados.
2. **Duplicación `_BurbujaPropiedad`/`_BurbujaLista`** con `page_chat_privado.dart` (conocidos). Refactor: `60_global_widgets/burbuja_propiedad_lista.dart` reutilizable. Documentado en US-CON-005.
3. **2 modelos para Grupo**: `Grupo` (Freezed) y `GrupoModel` (json manual) — duplicidad de representación. Unificar.
4. **`ChatGrupoEmbebido` buen patrón reutilizable** — candidato a `60_global_widgets/chat_embebido.dart` para futuros módulos.
5. **Providers legacy** sin `@riverpod` annotation (GruposNotifier, GruposInvitacionesNotifier, MensajesGrupoNotifier, AvisosGrupoNotifier, PublicacionesGrupoNotifier). Riverpod 3.x deprecó. Migración con `build_runner` pendiente.
6. **Sin tests** de ningún archivo (6 pages + 8 models + 5 providers).
7. **Acoplamiento con `03_listas`** (`page_compartir_con_grupo.dart` ya usa `publicacionesGrupoProvider` y `buscobien_publicaciones_grupo` — ver US-LIST-005 de 03_listas). Documentado.
8. **Acoplamiento con `08_pantallas/propiedades`** (`PaginaDetalleWidget` navigation desde `_BurbujaPropiedad` y `_TarjetaPublicacion`).
9. **DBs CouchDB involucradas** (transversal `06_Bases_de_Datos`): `buscobien_grupos`, `buscobien_grupos_miembros`, `buscobien_invitaciones_grupos`, `buscobien_mensajes_grupos`, `buscobien_publicaciones_grupo`, `buscobien_avisos_grupo`.
10. **Sincronía tab Invitaciones badge**: requiere `GruposInvitacionesNotifier` count de pendientes reactivamente — implementado via `ref.watch` del AsyncNotifier.
