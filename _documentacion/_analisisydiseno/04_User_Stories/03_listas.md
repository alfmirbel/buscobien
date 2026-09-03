# User Stories — Listas de Favoritos y Compartidas (03_listas)

**Directorio:** `lib\03_listas\` (17 archivos `.dart` en `models/` y raíz)
**Epic asociado:** [`02_Epics_EARS/03_listas.md`](../02_Epics_EARS/03_listas.md)
**Feature BDD:** [`03_Features_BDD/03_listas/listas_favoritos_compartir.feature`](../03_Features_BDD/03_listas/listas_favoritos_compartir.feature) (7 escenarios)
**Fecha:** 2026-08-12
**Fuente:** Ingeniería inversa

> **Nota de corrección:** este archivo fue reescrito el 2026-08-12. Anteriormente estaba contaminado/consolidado con US de 12 subdirectorios (04_provider, 20_var_globales, 40_security, 41_connectivity, 42_sistema_operativo, 60_global_widgets, 02_principal_screen, 03_vistas, 05_provider_menus, 10_user_login, 12_localidades_user, 14_geolocalizacion). Esas US viven ahora en archivos dedicados por subdirectorio. **Este archivo documenta únicamente 03_listas.**

---

## US-LIST-001: Ver hub central de Listas con 3 pestañas (Propias / Recibidas / Enviadas)

### Card
**Como** usuario autenticado
**Quiero** un único punto con mis listas propias, las listas recibidas de otros usuarios y las que yo envié
**Para** gestionar todas mis colecciones en un solo lugar.

### Conversation
- `PageMisListas` (`pagina_mis_listas.dart`, 1,222 líneas) es el hub central, Stateful, con un `TabBar(length:3)`.
- **Tab 1 — Propias:** consume `userListsProvider` (`UserListsNotifier`), filtra `idUsuario == currentUser`. Cada item admite: crear, ver detalle (`PageDetalleLista`), borrar (`Dismissible` con confirmación), compartir (→ US-LIST-004), editar nombre.
- **Tab 2 — Recibidas:** consume `listasCompartidasProvider` (`ListasCompartidasNotifier`) filtra `usuarioDestinoId == currentUser`. Cada item abre `PageDetalleListaCompartida`.
- **Tab 3 — Enviadas:** mismo provider filtra `usuarioOrigenId == currentUser`. Permite cancelar/ocultar una compartición (DELETE en `buscobien_listas_compartidas`).
- **Comentario crítico:** `PageMisListas` acumula 1,222 líneas (2-3x lo normal) por incluir la lógica de creación y borrado inline — debería extraerse a métodos en el Notifier correspondiente. Deuda de refactor.

### Confirmation
- ✓ Las 3 pestañas muestran datos distintos filtrando por el usuario actual: `idUsuario` / `usuarioDestinoId` / `usuarioOrigenId`.
- ✓ Swiping entre tabs (y tap) actualiza reactivamente cuando un provider notifica.
- ✓ Tab Propias permite crear una nueva lista, abrirla, borrarla (`Dismissible`) y comparterla.
- ✓ Tab Recibidas muestra listas que otros me han compartido con badge de cantidad pendiente.
- ✓ Feature BDD: escenario "Hub central Listas con 3 tabs".

**Trazabilidad:** `provider_user_lists.dart`, `provider_listas_compartidas.dart`, `pagina_mis_listas.dart`

---

## US-LIST-002: Crear una lista propia con ID SHA1 determinista

### Card
**Como** usuario
**Quiero** crear una nueva lista (de favoritos, comparación, alertas…) con un identificador único
**Para** organizar y etiquetar propiedades de la manera que más me sirva.

### Conversation
- En Tab Propias, el usuario toca FAB "Crear lista" → `AlertDialog` con `TextField` (nombre).
- Al confirmar, `UserListsNotifier.crearLista(nombre)` construye el payload:
  - `_id = SHA1(userId + timestamp + random_string)` (anti-falsos positivos en cluster)
  - `idUsuario`, `nombreLista`, `tipo` (default "general", otros: "favoritos", "comparación", "alerta")
  - `fechaCreacion` ISO 8601 UTC
- POST via API a CouchDB `buscobien_listas_usuario`. `UserListsNotifier.notifier` refresca su `state` automáticamente en éxito.
- Validación: nombre no vacío, no duplicado para el mismo usuario (case-insensitive).
- El `tipo` se usa para auto-crear la lista "Favoritas" en US-LIST-006 y para iconos diferenciadores.
- **Comentario:** la APIpostId (SHA1) garantiza unicidad sin consultar primero — reduce una ronda de red.

### Confirmation
- ✓ Al crear una lista, aparece inmediatamente en el Tab Propias.
- ✓ El `_id` CouchDB del documento es `SHA1(userId + timestamp + random)` en hex.
- ✓ No permite crear una lista con nombre duplicado para el mismo usuario.
- ✓ Feature BDD: escenario "Crear lista propia con ID SHA1".

**Trazabilidad:** `provider_user_lists.dart` (`UserListsNotifier.crearLista`)

---

## US-LIST-003: Agregar o quitar una propiedad a una lista existente vía Dialog selector

### Card
**Como** usuario
**Quiero** guardar una propiedad en una o varias de mis listas (`DialogSelectorListas`) y deseleccionar las que ya no apliquen
**Para** conservar propiedades interesantes organizadas.

### Conversation
- `DialogSelectorListas` (`lista_select_lista_save_propiedad.dart`, 492 líneas) es un diálogo abierto desde la tarjeta/detalle de propiedad.
- Recibe `propertyId` y muestra `ListView` con `CheckboxListTile` por cada lista del usuario (`userListsProvider` filtrado por `idUsuario == currentUser`).
- Las listas que ya contienen esa propiedad arrancan marcadas (fetch previo desde `provider_listas_propiedades`).
- Al confirmar, ejecuta un **diff** entre el estado-checked-inicial y el estado-checked-final:
  - Para cada nuevo check, `ClassListaPropiedadesProvider.addPropiedadALista(listId, propertyId)` crea un doc `listaPropiedad:<listaPropiedad_id>` en `buscobien_listas_propiedades`. Anti-duplicado: NO existe ya `listaId + propertyId` en vista CouchDB.
  - Para cada uncheck, `removePropiedadDeLista(listId, propertyId)` DELETE con `_rev` (`_rev` obtenido vía primera consulta).
- Confirmación: SnackBar "Guardado en N listas" con conteo y `action` *Deshacer* opcional.
- **Comentario crítico:** el diff evita POST/DELETE innecesarios y respeta el principio `anti-duplicado` de la convención Buscobien. La atomicidad del diff NO es transaccional — si una operación falla, se confirma lo completado y se muestra en el SnackBar (podría dejar estado parcial si la red cae a la mitad).

### Confirmation
- ✓ Al abrir el diálogo, las listas que ya contienen `propertyId` aparecen marcadas.
- ✓ Al confirmar, sólo se hacen POST/DELETE por los cambios delta.
- ✓ Repetir el mismo POST (mismo `listaId + propertyId`) NO duplica — anti-duplicado vía check previo.
- ✓ Al cerrar el diálogo, la próxima apertura refleja los cambios.
- ✓ Feature BDD: escenario "Agregar propiedad a lista (Dialog selector checkboxes)".

**Trazabilidad:** `provider_listas_propiedades.dart` (`ClassListaPropiedadesProvider.addPropiedadALista`), `lista_select_lista_save_propiedad.dart` (`DialogSelectorListas`)

---

## US-LIST-004: Compartir una lista con hasta 5 conocidos/grupos + notificación chat

### Card
**Como** usuario
**Quiero** compartir una de mis listas con máximo 5 conocidos o grupos para colaborar en la búsqueda
**Para** que otros vean las propiedades que estoy considerando.

### Conversation
- `ListasCompartidasNotifier.compartirLista(listaOrigenId, usuariosDestinoIds[], mensaje?)` en `provider_listas_compartidas.dart`.
- **Limite:** máximo 5 destinatarios (`CheckboxListTile` multi-select guardado en `Set<String>` con length check). Validación UI antes de confirmar.
- Acciones realizadas como una "operación" lógica (no transaccional en CouchDB):
  1. Copia las propiedades de la lista origen a `buscobien_listas_compartidas_usuarios` con nuevo `_id = UUID()` (`tipo:'lista'`).
  2. Crea un documento de referencia en `buscobien_listas_compartidas` con `{ listaOrigenId, usuarioOrigenId, usuarioDestinoId, timestamp }`.
  3. `mensajesChatProvider.enviar(tipo:'lista', payloadDoc)` larga un mensaje de notificación a cada destinatario.
- **Anti-duplicado:** antes de insertar, chequea que no exista combinación idéntica `listaOrigenId + usuarioDestinoId` en `buscobien_listas_compartidas`. Si existe, **silent skip** (no falla el batch, sigue con otros destinatarios).
- **Comentario:** el batch no es atómico — si falla 3/5 destinatarios, los 2 exitosos están guardados y sólo esos reciben notificación. El SnackBar de confirmación detalla "Compartido con 2 de 5". Se planea introducir `_bulk_docs` de CouchDB para atomicidad.

### Confirmation
- ✓ No se puede seleccionar más de 5 destinatarios (UI bloquea el 6º check).
- ✓ Compartir con el mismo destinatario dos veces no crea duplicado (silent skip).
- ✓ Cada destinatario recibe un mensaje de chat `tipo:'lista'` con referencia al documento compartido.
- ✓ El tab Recibidas de cada destinatario muestra la lista nueva automaticamente.
- ✓ Feature BDD: escenario "Compartir lista con máx 5 contactos + notificación chat".

**Trazabilidad:** `provider_listas_compartidas.dart` (`ListasCompartidasNotifier`), `provider_propiedades_compartidas_conocidos.dart` (parcial), `mensajesChatProvider` (en `08_pantallas/tu_cuenta/...`)

---

## US-LIST-005: Compartir una propiedad individual a un Conocido o a un Grupo + chat

### Card
**Como** usuario
**Quiero** compartir una propiedad específica con uno o varios conocidos (máx 5) o con grupos completos
**Para** pedir opinión o coordinar una visita.

### Conversation
- `PageCompartirConConocido` (`page_compartir_con_conocido.dart`, 241 líneas) recibe `propertyId` y muestra `CheckboxListTile` de mis Conocidos. Máx 5 seleccionados.
- Al confirmar, `PropiedadesCompartidasConocidosNotifier.compartirPropiedad(propertyId, usuariosDestinoIds[], mensaje?)`:
  - Crea un doc por destinatario en `buscobien_propiedades_compartidas_conocidos` con `_id = UUID()` (NO SHA1; el contenido puede repetirse).
  - `mensajesChatProvider.enviar(tipo:'propiedad', payloadDoc)` notifica con referencia al documento.
- `PageCompartirConGrupo` (`page_compartir_con_grupo.dart`, 206 líneas) muestra `CheckboxListTile` de grupos a los que pertenezco. Al confirmar:
  - `publicacionesGrupoProvider.compartirPropiedad(propertyId, grupoIds[], mensaje?)` `POST` por grupo a `buscobien_publicaciones_grupo` (DB transversal con `06_Bases_de_Datos`).
  - `mensajesGrupoProvider.enviar()` envía un mensaje al chat del grupo con la referencia.
- Validación UI: destinatario no vacío, mensaje ≤ 500 chars.
- **Comentario:** los IDs de las propiedades compartidas son `UUID()` (no SHA1 como US-LIST-002) porque una misma propiedad puede compartirse múltiples veces. La unicidad relacional (propiedad + destinatario) se garantiza con validación previa + idempotencia mental del usuario (no exigimos anti-dup estricto aquí).

### Confirmation
- ✓ En `PageCompartirConConocido`, no se pueden seleccionar más de 5 conocidos.
- ✓ Tras compartir, el chat con cada conocido recibe un mensaje `tipo:'propiedad'`.
- ✓ En `PageCompartirConGrupo`, los grupos seleccionados aparecen en su chat con un mensaje `tipo:'propiedad'`.
- ✓ Feature BDD: escenario "Compartir propiedad individual con conocido/grupo + chat".

**Trazabilidad:** `page_compartir_con_conocido.dart`, `page_compartir_con_grupo.dart`, `provider_propiedades_compartidas_conocidos.dart`, `publicacionesGrupoProvider` (en `08_pantallas/tu_cuenta/grupos/`), `mensajesChatProvider`, `mensajesGrupoProvider`

---

## US-LIST-006: Marcar Me Gusta en una propiedad y auto-crear lista "Favoritas"

### Card
**Como** usuario
**Quiero** un botón "Me Gusta" (corazón) en cada propiedad que guarde mis preferidas en una lista Favoritas automática
**Para** construir mi colección sin tener que gestionar listas manualmente.

### Conversation
- `MeGustaNotifier` (`provider_me_gusta.dart`, 276 líneas) expone `toggleMeGusta(propertyId)` con optimista local + corrección post-PUT.
- Doc en `buscobien_megusta_propiedades` con `_id = SHA1(userId + propertyId)` (anti-duplicado implícito — sobre-escritura idempotente).
- La primera vez que un usuario hace Me Gusta (su colección no tiene aún lista "Favoritas"), `UserListsNotifier.crearLista("Favoritas", tipo:"favoritos")` se ejecuta automáticamente como parte de toggle:
  1. Consulta usuario.listaFavoritasId (si null/empty).
  2. Crea la lista con `tipo:"favoritos"`.
  3. `_agregarPropiedadAFavoritas(propertyId)` anti-duplicado en `buscobien_listas_propiedades`.
  4. Actualiza `listaFavoritasId` en el perfil del usuario (PUT en `buscobien_usuarios`).
- `_agregarMeGusta` / `_quitarMeGusta` son optimistic update: la UI cambia al instante y, si el PUT del API falla, se revierte más tarde con SnackBar.
- **Comentario:** el flujo *"primer me-gusta → auto-crea Favoritas"* es un patrón de diseño stealth-UX muy útil pero tiene un riesgo: si el paso 3 (actualizar perfil) falla, el usuario queda con un me-gusta registrado pero sin lista Favoritas asociada. Tolerable porque los me-gusta se pueden consultar directamente.

### Confirmation
- ✓ Toggle Me Gusta visible en detalle y tarjetas de propiedad.
- ✓ El primer me-gusta de un usuario crea la lista "Favoritas" automáticamente y la propiedad queda dentro.
- ✓ Repetir toggle quita el me-gusta (borrado `SHA1(userId+propertyId)`) pero NO elimina la lista Favoritas.
- ✓ Si el PUT falla, el corazón visual vuelve a su estado previo.
- ✓ Feature BDD: escenario "Toggle Me Gusta → auto-crea lista Favoritas".

**Trazabilidad:** `provider_me_gusta.dart` (`MeGustaNotifier.toggleMeGusta`), `provider_user_lists.dart`, `provider_listas_propiedades.dart`

---

## US-LIST-007: Ver detalle de una lista (propia o compartida) con bulk fetch `$in` Mango query

### Card
**Como** usuario
**Quiero** abrir una lista y ver todas sus propiedades renderizadas en una sola llamada BD
**Para** revisarlas rápidamente sin esperas de paginación.

### Conversation
- `PageDetalleLista` (`pagina_detalle_listas.dart`, 415 líneas) y `PageDetalleListaCompartida` (`pagina_detalle_lista_compartida.dart`, 156 líneas) reciben `listaId` y cargan las N propiedades asociadas.
- `propertiesDetailsProvider` es un `FutureProvider.family<List<PropiedadDoc>, List<String>>` que toma la lista de `propertyId[]` y hace un **Mango query** `{"selector": {"_id": {"$in": propertyIds}}}` → 1 sola petición que trae N documentos completos.
- El widget `FutureBuilderStateWidgets` (ver `60_global_widgets/future_builder_state_widgets.dart`) maneja los 3 estados: `stateWaiting` (spinner), `stateError` (mensaje+retry), `stateNone` (mensaje "Lista vacía").
- `WrapModernCardPropiedades` (componente global de `60_global_widgets`) recibe las propiedades e itera por tipo de espacio con tarjetas estilizadas M3.
- **Fallback endpoints:** si la query principal falla en `buscobien_propiedades_publicadas_*` se reintenta en `buscobien_propiedades_publicados_*` (según `endpointsCaptura`/`endpointsPublicados` de `40_security`), conocidas convenciones de Buscobien.
- En `PageDetalleListaCompartida`, el usuario puede "Guardar en mis listas" la lista recibida (crea una nueva propia con copia de los IDs).
- **Comentario:** el `$in` evita N requests GET (uno por propiedad) — ahorra latencia. Si la lista tiene >50 propiedades, debería paginarse en Mango con `limit: 50 + bookmark` para no degradar la UI, pero en código actual hace 1 GET masivo — deuda técnica para listas grandes.

### Confirmation
- ✓ Abrir una lista con 20 propiedades hace 1 sola petición a CouchDB (vía API) y renderiza todas las tarjetas.
- ✓ Lista vacía muestra mensaje "Lista vacía" + CTA "Agrega propiedades" (sólo propias).
- ✓ Error de red muestra mensaje y botón reintentar; al tapar reintenta el `FutureProvider`.
- ✓ Lista compartida permite copiar las propiedades a una nueva lista propia con un solo tap.
- ✓ Feature BDD: escenario "Detalle lista con bulk fetch $in Mango".

**Trazabilidad:** `pagina_detalle_listas.dart` (`PageDetalleLista`), `pagina_detalle_lista_compartida.dart` (`PageDetalleListaCompartida`), `provider_listas_propiedades.dart`, `60_global_widgets/future_builder_state_widgets.dart` (no parte de 03_listas pero consumido)

---

## Resumen matriz US vs Requirements (mapear cuando el Epic se enriquezca)

| US | Acción principal | DBs CouchDB afectadas |
|----|-----------------|----------------------|
| US-LIST-001 (Hub 3 tabs) | Read usuarios recibidos/enviados | `buscobien_listas_usuario`, `buscobien_listas_compartidas` |
| US-LIST-002 (Crear lista) | POST lista propia | `buscobien_listas_usuario` |
| US-LIST-003 (Selector guardar) | diff post/delete | `buscobien_listas_propiedades` |
| US-LIST-004 (Compartir lista) | Batch crear + notificar | `buscobien_listas_compartidas`, `buscobien_listas_compartidas_usuarios`, `buscobien_mensajes` (chat) |
| US-LIST-005 (Comp. propiedad) | Post conocidos y grupos | `buscobien_propiedades_compartidas_conocidos`, `buscobien_publicaciones_grupo`, `buscobien_mensajes`, `buscobien_mensajes_grupos` |
| US-LIST-006 (Me gusta) | Post/DELETE idempotente + auto-crea Favoritas | `buscobien_megusta_propiedades`, `buscobien_listas_usuario`, `buscobien_listas_propiedades`, `buscobien_usuarios` |
| US-LIST-007 (Detalle lista) | Mango `$in` bulk fetch | `buscobien_propiedades_publicadas_*`, `buscobien_propiedades_publicados_*` (fallback) |

---

## Notas de deuda técnica

1. **`PageMisListas` tiene 1,222 líneas** — excede 2-3x el tamaño normal. La lógica de creación/borrado inline debería migrarse a los notifiers correspondientes.
2. **Diferencias de ID entre operaciones:** US-LIST-002 (SHA1 anti-dup), US-LIST-005 (UUID permitido reintentos). Documentado pero podría confundir a nuevos desarrolladores — debería homogeneizarse.
3. **Operación de compartir (US-LIST-004) no atómica:** si falla parte del batch, queda estado parcial. Promoted: usar `_bulk_docs` CouchDB.
4. **Sin anti-duplicado estricto en US-LIST-005:** se aceptan recomparticiones idénticas. Podría causar chat spam si usuario repite.
5. **Auto-creación de lista Favoritas (US-LIST-006):** el PUT al perfil del usuario (guardar `listaFavoritasId`) es el eslabón débil — si falla, queda inconsistente, aunque recuperable con consultas.
6. **`propertiesDetailsProvider.family` sin paginar:** el `$in` sin `limit` puede ser lento para listas grandes. Deuda técnica.
7. **Múltiples DBs cross-reference:** US-LIST-004 y US-LIST-005 tocan DBs de módulos de chat (en `08_pantallas/tu_cuenta/conocidos/grupos/`) — acoplamiento.
8. **Sin tests**: ninguna US-LIST tiene widget test. Sólo smoke global.
