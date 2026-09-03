# User Stories — Gestión de Imágenes y Fotos (22_imagenes)

**Directorio:** `lib\22_imagenes\` (28 archivos `.dart` en 4 subcarpetas)
**Epic asociado:** [`02_Epics_EARS/22_imagenes.md`](../02_Epics_EARS/22_imagenes.md)
**Features BDD:** [`03_Features_BDD/22_imagenes/`](../03_Features_BDD/22_imagenes/) (4 archivos)
**Fecha:** 2026-08-12
**Fuente:** Ingeniería inversa

---

## US-IMG-001: Ver fotos de una propiedad en carousel responsivo

### Card
**Como** comprador/arrendatario navegando Buscobien
**Quiero** ver las fotos de una propiedad en un carousel responsivo dentro del catálogo, detalle y tarjetas de resultados
**Para** evaluar visualmente la propiedad antes de contactar al promotor.

### Conversation
- El carousel completo (`PaginaCarouselFotosUsuario`) recibe un `ValueEspaciosCasaGet` y carga los IDs de fotos vía `future_recupera_ids_fotos_propiedad` (Mango query contra CouchDB). Usa `CarouselSlider` v5+ con `CarouselSliderController`: `autoPlay=false`, `enableInfiniteScroll=true`, indicador de página actual en estado `_current`. Overlay inferior en glass-morphism muestra datos de la propiedad (precio, título, ubicación).
- Botones de acción rápidas: **Ver detalle** → `PaginaDetallePropiedad` (Hero animation), **Guardar en lista** → `lista_select_lista_save_propiedad`, **Compartir con Conocido/Grupo** → `page_compartir_con_*`.
- La versión mini (`PaginaCarouselFotosMini`) se usa dentro de `ListView` y `GridView` de resultados: height ~150px, sin controles completos, sólo preview con tap-to-detail.
- Si la propiedad no tiene fotos (`fotoprincipal == ""`, lista vacía): muestra `fotoPlaceholder` centrado y oculta el overlay de acciones.
- `FutureBuilderStateWidgets` maneja `ConnectionState.waiting` (spinner M3 con `appTheme.colorScheme.primary`) y errores (mensaje + botón reintentar).
- **Comentario crítico de implementación:** existe dependencia circular potencial — el carousel importa pantallas de `08_pantallas` y éstas podrían importar el carousel; hay una rutas con `AppRoutes.routeGenerate()` que rompe el ciclo.

### Confirmation
- ✓ Dado un `ValueEspaciosCasaGet` con 5 fotos, al renderizar `PaginaCarouselFotosUsuario` aparece un `CarouselSlider` con 5 páginas navegables manualmente (swipe o flechas).
- ✓ Al cambiar de foto, el indicador "Foto X de N" se actualiza con el índice correcto.
- ✓ En `PaginaCarouselFotosMini`, el height es compacto (~150px), el tap navega a detalle.
- ✓ Si no hay fotos, el placeholder reemplaza el carousel y no hay botones de acción.
- ✓ Feature BDD: `03_Features_BDD/22_imagenes/carousel_usuario.feature` (6 escenarios).

**Trazabilidad:** `REQ-IMG-002`, `REQ-IMG-003` · Archivos: `pagina_carousel_fotos_usuario.dart`, `pagina_carousel_fotos_usuario_mini.dart`

---

## US-IMG-002: Gestionar fotos de una propiedad en tres vistas sincronizadas

### Card
**Como** promotor/propietario
**Quiero** ver y gestionar las fotos de mis propiedades en 3 vistas alternativas (Carousel / Cuadros / Listado) sincronizadas
**Para** elegir la visualización más cómoda según el dispositivo y contexto.

### Conversation
- `PaginaFotosPropiedad` (ConsumerStatefulWidget + `TickerProviderStateMixin`) crea un `TabController(length:3)` con listener `_handleTabSelection` que detecta tanto taps como swipes.
- Las 3 vistas comparten `idFoto`, `idUsuario`, `idPropiedad` desde `PaginaFotosPropiedadState` (estado declarado en el tab-container, no en las hijas), por eso el cambio de vista preserva la selección.
- `PageStorageKey` por tab preserva scroll position al cambiar de pestaña (cada `ListView`/`GridView` usa su propia key derivada del `idPropiedad`).
- **Vista Carousel** (`pagina_lista_fotos_carousel.dart`): fullscreen swipe, igual al US-IMG-001 pero ligado a la gestión.
- **Vista Cuadros** (`pagina_lista_fotos_cuadros.dart`): `GridView` responsivo, `crossAxisCount` depende de `isMobile/isTablet/isDesktop(context)` → 2/3/4 columnas. Long-press abre menú contextual.
- **Vista Listado** (`pagina_lista_fotos_listado.dart`): `ReorderableListView` con `ReorderableDragStartListener` por ítem (handle visible onHover).
- Menú contextual (PopupMenuButton) por foto: *Ver detalle, Compartir con Conocido/Grupo, Agregar a lista, Marcar como principal, Editar/Eliminar*. Navega a través de `AppRoutes.routeGenerate()`.
- **Comentario:** `buttonSelectOpcionFotos = [true, false, false]` es estado que debería estar en un provider (deuda técnica planificada para migrar).

### Confirmation
- ✓ Al cambiar de tab (tap o swipe), la foto seleccionada y scroll position se mantienen en la nueva vista.
- ✓ GridView en Cuadros muestra 2 columnas en móvil y 3-4 en tablet/desktop (basado en `var_color_widget.dart` breakpoints).
- ✓ PopupMenuButton por foto incluye las 5 acciones documentadas.
- ✓ Feature BDD: `03_Features_BDD/22_imagenes/gestion_fotos_propiedad.feature` (6 escenarios).

**Trazabilidad:** `REQ-IMG-004`, `REQ-IMG-005`, `REQ-IMG-008`, `REQ-IMG-011` · Archivos: `pagina_fotos_menu_opciones.dart`, `pagina_lista_fotos_carousel.dart`, `pagina_lista_fotos_cuadros.dart`, `pagina_lista_fotos_listado.dart`

---

## US-IMG-003: Subir múltiples fotos comprimidas a una propiedad

### Card
**Como** promotor/propietario
**Quiero** agregar varias fotos a la vez usando el selector nativo del dispositivo, ya comprimidas antes de subir
**Para** mantener un catálogo visual completo sin consumir ancho de banda excesivo.

### Conversation
- El usuario toca "Agregar fotos" en `PaginaFotosPropiedad` y navega a `AgregaMultiplesFotos` (StatefulWidget).
- Invoca `FilePicker.platform.pickFiles(allowMultiple:true, type:image)`. El resultado es `List<PlatformFile>` con `path`, `name`, `size`, `bytes` (en web, `path` puede ser null y se usa `bytes`).
- Cada archivo se comprime con `funciones_compress_image.compressImage(File, {quality:70, maxWidth:1920, maxHeight:1080})` usando `flutter_image_compress`. Retorna `Uint8List` base64. **Plataforma:** esto NO funciona en Web (flutter_image_compress es nativo) — deuda documentada, en Web se cae al flujo de `bytes` sin compresión.
- `http_funciones_gestion_foto.uploadMultiplePhotos()` envía `POST` multipart a Node.js API con `idUsuario,idPropiedad,archivo`. La API crea documentos `foto:<uuid>` y `_attachments` en CouchDB (DB `buscobien_propiedades` o específica de fotos).
- Respuesta por foto: `CouchDbReturnValue { ok, id, rev, error? }`. El agregado se muestra como SnackBar de éxito/fallo.
- Validación de límite: `maxFotosPorPropiedad` en `variables_imagenes.dart`. Si la propiedad ya tiene el máximo, se bloquea la subida.
- Manejo de errores: si `FilePicker` retorna null, SnackBar "Selección cancelada"; si la compresión falla para un archivo, try-catch por archivo (no aborta el batch); las fotos válidas se suben.

### Confirmation
- ✓ Se pueden seleccionar N fotos desde la galería nativa y todas aparecen como thumbnails antes de subir.
- ✓ Cada foto >1MB se reduce a <500KB (calidad 70%, máximo 1920px en lado mayor).
- ✓ POST a Node.js API crea `foto:<uuid>` + attachment en CouchDB y retorna `CouchDbReturnValue`.
- ✓ Si la selección se cancela, no se sube nada y aparece SnackBar informativo.
- ✓ Si una foto del batch falla al comprimir, las demás se suben correctamente.
- ✓ Feature BDD: `03_Features_BDD/22_imagenes/subida_multiple_fotos.feature` (6 escenarios).

**Trazabilidad:** `REQ-IMG-006`, `REQ-IMG-009`, `REQ-IMG-010`, `REQ-IMG-012` · Archivos: `pagina_agrega_multiples_fotos.dart`, `funciones_compress_image.dart`, `http_funciones_gestion_foto.dart`, `image_file_structure.dart`, `variables_imagenes.dart`, `data_couchdb_post_return.dart`, `data_cuenta_fotos.dart`

---

## US-IMG-004: Reordenar fotos con drag & drop y persistir el orden en CouchDB

### Card
**Como** propietario
**Quiero** arrastrar y reordenar las fotos para que la más representativa aparezca primero en el catálogo
**Para** mejorar la primera impresión visual de mis propiedades.

### Conversation
- En vista **Listado** (`pagina_lista_fotos_listado.dart`), el `ReorderableListView.onReorder` callback actualiza `fotosOrden` con `list.removeAt(oldIndex) → list.insert(newIndex, item)`.
- El estado de orden se mantiene en `provider_get_lista_fotos_ordenadas.ClassListaFotosCasaNotifierProvider` (AsyncNotifier). Tras el reorden local, el notificador actualiza `state.data.value` para que Carousel y Cuadros refresquen automáticamente (consumers).
- **Persistencia:** si es la primera vez (no existe doc `fotosordenadas:<idPropiedad>` en CouchDB), se hace `future_put_fotos_orden.dart` (POST → PUT nuevo). Si ya existe, `future_update_fotos_orden.dart` actualiza con `_rev` actual.
- El payload incluye `idListaFotos, idUsuario, idPropiedad, fotosOrden[] (lista de IDs), timestamp` (ISO 8601).
- **Conflicto (409):** si dos dispositivos editan simultáneamente y el `_rev` enviado ya fue reemplazado, CouchDB responde `409 Conflict`. El sistema muestra SnackBar "Conflicto, recarga lista" y hace un nuevo GET vía `future_get_fotos_by_idpr_orden`.
- SnackBar de confirmación tras éxito con acción *Deshacer* opcional (no implementado en código actual — deuda).

### Confirmation
- ✓ El usuario arrastra una foto de posición 3 a posición 1; la lista se reorganiza inmediatamente.
- ✓ Las vistas Carousel y Cuadros reflejan el nuevo orden al siguiente render.
- ✓ Tras soltar, el sistema hace PUT a CouchDB y muestra SnackBar con resultado.
- ✓ Si el doc no existía, se crea `fotosordenadas:<idPropiedad>` con el orden inicial.
- ✓ Si el PUT responde 409, se recarga la lista y se notifica conflicto.
- ✓ Feature BDD: `03_Features_BDD/22_imagenes/ordenamiento_fotos.feature` (5 escenarios).

**Trazabilidad:** `REQ-IMG-007` · Archivos: `pagina_lista_fotos_listado.dart`, `provider_get_lista_fotos_ordenadas.dart`, `future_put_fotos_orden.dart`, `future_update_fotos_orden.dart`, `data_fotos_ordenadas.dart`, `clase_listas_fotos_propiedad.dart`, `data_fotos_ordenadas_get_idpropiedad.dart`

---

## US-IMG-005: Modelar datos de fotos y orden con Freezed/json_serializable

### Card
**Como** desarrollador
**Quiero** modelos tipados e inmutables para fotos, respuestas de vistas y ordenadores
**Para** garantizar seguridad de tipos en el flujo completo de gestión de imágenes.

### Conversation
- `data_fotos_casa.dart` define el documento CouchDB de una foto: `FotosCasa { _id, _rev, idUsuario, idPropiedad, fechaSubida, ... }` + `FotosCasaClass` (clase envoltorio del value).
- `data_fotos_casa_get.dart` modela la **vista CouchDB** de fotos por propiedad: `FotosCasaGet { total_rows, offset, rows: List<ValueFotosCasaGet> }`. Cada `ValueFotosCasaGet` tiene `id, value: FotosCasaClass`.
- `data_fotos_casa_get_ids.dart` modela la **vista de IDs** (sin cuerpo de la foto, optimizada): `FotosCasaGetIDs { total_rows, offset, rows: List<ValueFotosCasaGetIDs> }`.
- `data_fotos_ordenadas.dart` define el orden custom persistible: `ListaFotosOrdenadas { idListaFotos, idUsuario, idPropiedad, fotosOrden: List<FotosOrden>, timestamp }`.
- `data_couchdb_post_return.dart` envuelve respuestas POST: `CouchDbReturnValue { ok, id, rev, error? }`.
- `data_cuenta_fotos.dart` cuenta fotos por propiedad para validación del límite máximo.
- `data_fotos_lista_fotos_iduser_idprop.dart` y otros modelos auxiliares completan la serialización.
- Todos los modelos usan `@freezed` + `json_serializable` y generan `.freezed.dart` + `.g.dart` via build_runner.

### Confirmation
- ✓ Cada modelo se serializa/deserializa sin excepciones con `fromJson/toJson` simétricos.
- ✓ `FotosCasaGet` parsea correctamente respuestas de vistas CouchDB (`total_rows, offset, rows`).
- ✓ `ListaFotosOrdenadas` sobrevive un round-trip a CouchDB (PUT → GET) con `_rev` cambiando correctamente.
- ✓ Sin excepciones de tipo en el flujo completo (selección → compresión → subida → persistencia → reorden → display).

**Trazabilidad:** `REQ-IMG-001` · Archivos: `data_fotos_casa.dart`, `data_fotos_casa_get.dart`, `data_fotos_casa_get_ids.dart`, `data_fotos_ordenadas.dart`, `data_couchdb_post_return.dart`, `data_cuenta_fotos.dart`, `data_fotos_lista_fotos_iduser_idprop.dart`, `data_fotos_get_ids_fotos_user_prop.dart`, `data_fotos_ordenadas_get_idpropiedad.dart`

---

## Resumen de criterios de aceptación (matriz)

| US | Epic Req | Features BDD | Archivos principales |
|----|----------|--------------|----------------------|
| US-IMG-001 (carousel visualización) | REQ-IMG-002, 003 | carousel_usuario.feature | `pagina_carousel_fotos_usuario.dart`, `pagina_carousel_fotos_usuario_mini.dart` |
| US-IMG-002 (3 vistas sincronizadas) | REQ-IMG-004, 005, 008, 011 | gestion_fotos_propiedad.feature | `pagina_fotos_menu_opciones.dart` + 3 vistas |
| US-IMG-003 (subida múltiple + compresión) | REQ-IMG-006, 009, 010, 012 | subida_multiple_fotos.feature | `pagina_agrega_multiples_fotos.dart`, `funciones_compress_image.dart`, `http_funciones_gestion_foto.dart` |
| US-IMG-004 (reorden drag&drop) | REQ-IMG-007 | ordenamiento_fotos.feature | `pagina_lista_fotos_listado.dart`, `provider_get_lista_fotos_ordenadas.dart`, `future_put/update_fotos_orden.dart` |
| US-IMG-005 (modelos Freezed) | REQ-IMG-001 | (transversal) | `data_models/*.dart` |

---

## Notas de deuda técnica (consolidadas del Epic)

1. **5 niveles de subcarpetas** en `tus_espacios_fotos_propiedad` dificultan navegación y testing.
2. **Dos providers `ClassListaFotosCasaNotifierProvider`** con mismo nombre en `futures_y_providers/` y `lista_fotos_ordenadas/` — colisión de nombres (uno IDs, otro orden).
3. **`flutter_image_compress` es nativo** — no funciona en Web/WASM; el flujo Web es fallback sin compresión (deuda).
4. **`CarouselSlider` v5+** — breaking change `CarouselController` → `CarouselSliderController`.
5. **Sin tests** de compresión, subida, reorden ni carousel — la única prueba existente es el smoke test.
6. **Manejo de errores HTTP** genérico (SnackBar) sin diferenciar tipos (red, auth, server, quota).
7. **`buttonSelectOpcionFotos`** estado local mutable que debería ser provider Riverpod.
