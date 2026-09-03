# User Stories — Pantallas: Tu Cuenta > Conocidos (Red Social) (08_pantallas/tu_cuenta/conocidos)

**Directorio:** `lib\08_pantallas\tu_cuenta\conocidos\` (14 archivos: 10 fuente en raíz + 1 modelo Freezed + 2 generados `.g.dart`/`.freezed.dart` + 1 provider en subcarpeta)
**Epic asociado:** [`02_Epics_EARS/08_pantallas_tu_cuenta_conocidos.md`](../02_Epics_EARS/08_pantallas_tu_cuenta_conocidos.md)
**Feature BDD:** [`03_Features_BDD/08_pantallas_tu_cuenta_conocidos/conocidos_red_social.feature`](../03_Features_BDD/08_pantallas_tu_cuenta_conocidos/conocidos_red_social.feature) (13 escenarios)
**Inventario:** [`05_Tareas_Inventarios/08_pantallas_tu_cuenta_conocidos/elementos_08_pantallas_tu_cuenta_conocidos.md`](../05_Tareas_Inventarios/08_pantallas_tu_cuenta_conocidos/elementos_08_pantallas_tu_cuenta_conocidos.md)
**Fecha:** 2026-08-13
**Fuente:** Ingeniería inversa

---

## US-CON-001: Ver mis contactos (lista de conocidos)

### Card
**Como** usuario
**Quiero** ver lista de mis contactos con avatar, nombre y acceso a su perfil
**Para** gestionar mi red social privada en Buscobien.

### Conversation
- `PageMisContactos` (`page_mis_contactos.dart`, 140 líneas, ConsumerStatefulWidget + State) es el tab 1 de `ConocidosView`.
- `conocidosNotifierProvider` (en `providers/conocidos_notifier.dart`) lista `Conocido[]` filtrado por `idUsuario == currentUser`.
- Cada tarjeta muestra avatar + nombre + (rol si es visible). Tap abre `PagePerfilContacto`.
- Barra de búsqueda por nombre (case insensitive) para filtrar visible localmente.
- `Conocido` es el primer modelo Freezed del módulo (`models/conocido.dart` con `.freezed.dart` + `.g.dart` generados).
- **Comentario:** los modelos `MensajeModel` e `InvitacionModel` NO son Freezed (json manual) — inconsistencia con `Conocido`. Deuda de uniformidad.

### Confirmation
- ✓ Al abrir el tab Mis Contactos, lista aparece filtrada por el usuario actual.
- ✓ Tap en una tarjeta navega a `PagePerfilContacto`.
- ✓ La búsqueda por nombre filtra visualmente.
- ✓ Feature BDD: escenario "Ver lista de Mis Contactos".

**Trazabilidad:** `REQ-CON-002`, `REQ-CON-003` · Archivos: `page_mis_contactos.dart`, `providers/conocidos_notifier.dart`, `models/conocido.dart`

---

## US-CON-002: Descubrir usuarios nuevos e invitarlos a ser mis conocidos

### Card
**Como** usuario que quiere ampliar su red
**Quiero** buscar usuarios por nombre o email e invitarlos a ser mis conocidos
**Para** coordinar la búsqueda de propiedades con más personas.

### Conversation
- `PageDescubrirUsuarios` (`page_descubrir_usuarios.dart`, 173 líneas) ofrece búsqueda de usuarios.
- Realiza Mango query contra CouchDB (vía API) con el término ingresado en el `TextFormField`.
- Cada resultado muestra tarjeta con avatar + nombre + rol. CTA condicional:
  - Si NO son conocidos: "Invitar" → `InvitacionesNotifier.enviar(usuarioDestinoId)` crea doc `buscobien_invitaciones` con estado `pendiente`.
  - Si YA son conocidos: "Chatear" → navega a `PageChatPrivado`.
- `InvitacionModel` (`invitacion_model.dart`, 59 líneas) tipa el documento en `buscobien_invitaciones` con campos: `idOrigen`, `idDestino`, `estado` (pendiente/aceptada/rechazada), `timestamp`.
- Tras enviar, SnackBar confirmación y el receptor recibe badge en su tab Invitaciones (escucha reactiva).
- **Comentario de deuda:** la búsqueda por email require Mango query case-insensitive — la implementación actual probablemente usa substring exacto. Deuda menor.

### Confirmation
- ✓ Al buscar por nombre/email, aparecen las coincidencias.
- ✓ Si el usuario no es mi conocido, el CTA "Invitar" está disponible.
- ✓ Si ya es mi conocido, el CTA cambia a "Chatear".
- ✓ Tras invitar, SnackBar confirma y el receptor ve badge en su tab.
- ✓ Feature BDD: escenarios "Descubrir usuarios", "Enviar invitación".

**Trazabilidad:** `REQ-CON-004`, `REQ-CON-005` · Archivos: `page_descubrir_usuarios.dart`, `social_providers.dart`, `invitacion_model.dart`

---

## US-CON-003: Aceptar o rechazar invitaciones recibidas (crear relación bidireccional)

### Card
**Como** usuario que recibe invitaciones
**Quiero** aceptarlas para crear relación bidireccional con el emisor o rechazarlas
**Para** controlar quién entra a mi red social privada.

### Conversation
- `PageInvitaciones` (`page_invitaciones.dart`, 162 líneas) es el tab 3 de `ConocidosView`.
- `InvitacionesNotifier` (`social_providers.dart`, 217 líneas) lista invitaciones recibidas filtrado por `idDestino == currentUser` AND `estado == "pendiente"`.
- **Aceptar:** `aceptarInvitacion(inv)`:
  1. Crea doc en `buscobien_conocidos_usuarios` con `_id = SHA1(origen+destino)` para el sentido origen→destino.
  2. Crea otro doc con el sentido inverso (bidireccional) para que ambos vean al otro en "Mis Contactos".
  3. Crea mensaje de bienvenida en `buscobien_mensajes` tipo `'sistema'` con texto "Ahora son conocidos en Buscobien".
  4. Actualiza la invitación a `estado = "aceptada"`.
  5. Ambos `conocidosNotifierProvider` (origen y destino) refrescan via listeners.
- **Rechazar:** `rechazarInvitacion(inv)` sólo actualiza `estado = "rechazada"` (no crea relación, no crea mensaje).
- **Comentario crítico de deuda (`REQ-CON-010`):** el flujo de aceptar es **no transaccional** — si falla la creación del mensaje en el paso 3 (timeout, red), los 2 docs `conocidos` quedan en DB pero el chat de bienvenida no. Resultado: la relación existe pero el mensaje no. **Refactor:** usar `_bulk_docs` CouchDB o saga.

### Confirmation
- ✓ Al tap "Aceptar", la invitación desaparece del tab y la relación bidireccional está creada en ambos sentidos.
- ✓ Ambos usuarios aparecen en sus respectivos Mis Contactos reactivamente.
- ✓ Mensaje de bienvenida aparece en PageChatPrivado (cuando abran el chat).
- ✓ Al tap "Rechazar", la invitación queda como "rechazada" y no crea relación.
- ✓ Feature BBD: escenarios "Aceptar invitación", "Rechazar invitación", "Transaccionalidad aceptar".

**Trazabilidad:** `REQ-CON-005`, `REQ-CON-006`, `REQ-CON-010` · Archivos: `page_invitaciones.dart`, `social_providers.dart`, `invitacion_model.dart`

---

## US-CON-004: Ver perfil de un contacto con CTAs condicionales

### Card
**Como** usuario que ve un contacto
**Quiero** ver su perfil público con nombre, avatar, rol y CTAs pertinentes
**Para** decidir si chatear, invitar o eliminar de mi red.

### Conversation
- `PagePerfilContacto` (`page_perfil_contacto.dart`, 159 líneas) recibe `userIdContacto` y muestra datos públicos del usuario.
- Lee sesión del contacto (no propia) vía `provider_session` o consulta CouchDB.
- CTAs condicionales según estado de relación:
  - **Son conocidos:** "Chatear" (navega a `PageChatPrivado`), "Eliminar de contactos" (DELETE bidireccional).
  - **No son conocidos, hay invitación pendiente:** muestra "Pendiente", CTAs deshabilitados.
  - **No son conocidos, no invitación:** "Invitar" (crea nueva invitación).
- **Eliminar:** confirmación + DELETE los 2 docs `buscobien_conocidos_usuarios` bidireccionales + SnackBar confirmación.
- **Comentario:** los datos públicos mostrados deben ser subset controlado del `User` (no mostrar email ni teléfono salvo si el usuario los configuró públicos — deuda de privacidad).

### Confirmation
- ✓ Al abrir perfil de un conocido, muestra avatar + nombre + CTA "Chatear" + CTA "Eliminar".
- ✓ Al abrir perfil de un no-conocido, muestra "Invitar".
- ✓ Si tengo invitación pendiente, muestra "Pendiente".
- ✓ Tras eliminar, el contacto desaparece de Mis Contactos reactivamente.
- ✓ Feature BDD: escenarios "Ver perfil de un contacto", "Eliminar contacto".

**Trazabilidad:** `REQ-CON-011` · Archivos: `page_perfil_contacto.dart`, interacciona con `providers/conocidos_notifier.dart`, `social_providers.dart`, `provider_mensajes.dart`

---

## US-CON-005: Chatear 1:1 con texto, propiedad o lista

### Card
**Como** usuario
**Quiero** chats 1:1 con un conocido que permitan texto simple + compartir propiedades y listas como burbujas especiales
**Para** coordinar la búsqueda de propiedades sin salir del chat.

### Conversation
- `PageChatPrivado` (`page_chat_privado.dart`, 398 líneas, StatefulWidget) recibe `(idUsuarioOrigen, idUsuarioDestino)`.
- `MensajesChatNotifier` (`provider_mensajes.dart`, 225 líneas) lista `MensajeModel[]` paginado por la pareja `(origen, destino)` usando vista CouchDB.
- Burbujas por tipo de mensaje:
  - **texto:** burbuja convencional (izquierda-blue/centro azul/der verde según emisor/receptor).
  - **propiedad:** `_BurbujaPropiedad` sub-widget con miniatura foto, precio, ubicación; tap → `PaginaDetalleWidget` de `08_pantallas/propiedades`.
  - **lista:** `_BurbujaLista` sub-widget con nombre de la lista + # propiedades; tap → `PageDetalleLista` de `03_listas`.
- Barra input permite escribir texto + 2 CTAs ("Compartir propiedad", "Compartir lista") que abren selectores.
- Envío de mensaje optimistic (aparece al instante en mi burbuja; si el POST falla, se revierte).
- **Comentario crítico de deuda:** `_BurbujaPropiedad` y `_BurbujaLista` son casi idénticos a los de `PageChatGrupo` (grupos) → **duplicación latente**. Refactor: extraer a `60_global_widgets/burbuja_propiedad_lista.dart` reutilizable en ambos chats (conocidos y grupos).

### Confirmation
- ✓ Abrir chat con un conocido muestra conversación paginada por la pareja (origen, destino).
- ✓ Enviar un mensaje de texto optimistic-actualiza la UI y luego persiste.
- ✓ Enviar una propiedad crea una _BurbujaPropiedad (mi emisor) que tap abre el detalle.
- ✓ Enviar una lista crea una _BurbujaLista con nombre y contador props.
- ✓ Feature BDD: escenarios "Chat 1:1", "Compartir propiedad", "Compartir lista", "Tap en burbuja propiedad/lista".

**Trazabilidad:** `REQ-CON-007`, `REQ-CON-008`, `REQ-CON-009` · Archivos: `page_chat_privado.dart`, `provider_mensajes.dart`, `mensaje_model.dart`, interacciona con `08_pantallas/propiedades` y `03_listas`

---

## US-CON-006: Hub ConocidosView con 3 tabs sincronizados

### Card
**Como** usuario
**Quiero** un hub con 3 tabs (Mis Contactos / Descubrir / Invitaciones) que muestre badge de pendientes
**Para** acceder a toda mi actividad social desde un punto central.

### Conversation
- `ConocidosView` (`conocidos_view.dart`, 71 líneas, ConsumerStatefulWidget) usa `TabController(length: 3)`.
- Tab 1 Mis Contactos → US-CON-001; Tab 2 Descubrir → US-CON-002; Tab 3 Invitaciones → US-CON-003.
- Badge en Tab 3 Invitaciones muestra cantidad pendiente (escucha reactiva de `InvitacionesNotifier` filtrado por pendiente).
- Cambio de tabpreserva scroll position (`PageStorageKey`).
- **Comentario:** el hub es simple (71 líneas) — bien modulado como orquestador de pages. Es el patrón opuesto a tus_espacios.

### Confirmation
- ✓ Hub muestra 3 tabs sincronizados con PageStorageKey.
- ✓ Badge de invitaciones pendientes se actualiza reactivamente.
- ✓ Cada tab carga su Page correspondiente.
- ✓ Feature BDD: cubierto implícito por escenarios por tab.

**Trazabilidad:** `REQ-CON-002` · Archivos: `conocidos_view.dart`

---

## Resumen matriz

| US | Epic Req | Escenarios BDD | Archivos principales |
|----|----------|----------------|----------------------|
| US-CON-001 (Mis Contactos) | REQ-CON-002, 003 | 1 | `page_mis_contactos.dart`, `providers/conocidos_notifier.dart`, `models/conocido.dart` |
| US-CON-002 (Descubrir + Invitar) | REQ-CON-004, 005 | 2 | `page_descubrir_usuarios.dart`, `social_providers.dart`, `invitacion_model.dart` |
| US-CON-003 (Aceptar/Rechazar) | REQ-CON-005, 006, 010 | 2 | `page_invitaciones.dart`, `social_providers.dart` |
| US-CON-004 (Perfil contacto) | REQ-CON-011 | 2 | `page_perfil_contacto.dart`, `providers/conocidos_notifier.dart` |
| US-CON-005 (Chat 1:1 + burbujas) | REQ-CON-007, 008, 009 | 4 | `page_chat_privado.dart`, `provider_mensajes.dart`, `mensaje_model.dart` |
| US-CON-006 (Hub 3 tabs) | REQ-CON-002 | implícito | `conocidos_view.dart` |

---

## Notas de deuda técnica

1. **Inconsistencia modelo:** `Conocido` Freezed, pero `MensajeModel` y `InvitacionModel` json manual. Homogenizar a Freezed.
2. **Inconsistencia estructura:** providers repartidos (`provider_mensajes.dart` en raíz, `social_providers.dart` en raíz, `conocidos_notifier.dart` en `providers/`). Unificar.
3. **Transaccionalidad `aceptarInvitacion`:** si falla la mitad, queda estado inconsistente. Refactor: `_bulk_docs` CouchDB o saga.
4. **`_BurbujaPropiedad` / `_BurbujaLista` duplicados** con `PageChatGrupo` (grupos). Refactor: extraer a `60_global_widgets/burbuja_propiedad_lista.dart` reutilizable.
5. **Providers legacy (`StateNotifier`, `Notifier`)** sin `@riverpod` annotation — Riverpod 3.x los deprecó.
6. **Privacidad perfil contacto:** datos públicos vs privados deben ser subset configurable — deuda de producto.
7. **Sin tests** de ningún archivo.
8. **Acoplamiento con `03_listas` y `08_pantallas/propiedades`** — esperado y documentado.
