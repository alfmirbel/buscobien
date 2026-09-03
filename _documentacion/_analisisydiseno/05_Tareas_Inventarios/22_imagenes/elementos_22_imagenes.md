# Inventario de Elementos — Gestión de Imágenes y Fotos (22_imagenes)

**Directorio:** `lib\22_imagenes\`
**Total archivos `.dart` fuente:** 28 (sin `.g.dart` ni `.freezed.dart` — todos son código fuente)
**Epic asociado:** [`02_Epics_EARS/22_imagenes.md`](../../02_Epics_EARS/22_imagenes.md)
**Features BDD:** [`03_Features_BDD/22_imagenes/`](../../03_Features_BDD/22_imagenes/) (4 archivos)
**User Stories:** [`04_User_Stories/22_imagenes.md`](../../04_User_Stories/22_imagenes.md) (5 US)
**Fecha:** 2026-08-12
**Fuente:** Ingeniería inversa

---

## Tabla 1 — Resumen de componentes por rol funcional

| # | Componente | Archivo(s) | Tipo | Rol funcional | US-IMG |
|---|------------|------------|------|---------------|--------|
| 1 | `FotosCasa` / `FotosCasaClass` | `data_models/data_fotos_casa.dart` | Modelo (Freezed) | Documento CouchDB foto | US-IMG-005 |
| 2 | `FotosCasaGet` / `ValueFotosCasaGet` | `data_models/data_fotos_casa_get.dart` | Modelo (Freezed) | Respuesta vista fotosPorPropiedad | US-IMG-005 |
| 3 | `FotosCasaGetIDs` / `ValueFotosCasaGetIDs` | `data_models/data_fotos_casa_get_ids.dart` | Modelo (Freezed) | Vista optimizada (IDs) | US-IMG-005 |
| 4 | `ListaFotosOrdenadas` / `FotosOrden` | `data_models/data_fotos_ordenadas.dart` | Modelo (Freezed) | Orden custom persistible | US-IMG-004, US-IMG-005 |
| 5 | `PaginaCarouselFotosUsuario` | `inicio_fotos_usuario/pagina_carousel_fotos_usuario.dart` | ConsumerStatefulWidget | Carousel full (catálogo/detalle) | US-IMG-001 |
| 6 | `PaginaCarouselFotosMini` | `inicio_fotos_usuario/pagina_carousel_fotos_usuario_mini.dart` | ConsumerStatefulWidget | Carousel mini (listados) | US-IMG-001 |
| 7 | `PaginaFotosPropiedad` | `tus_espacios_fotos_propiedad/.../pagina_fotos_menu_opciones.dart` | ConsumerStatefulWidget (+Ticker) | Contenedor 3 tabs sincronizados | US-IMG-002 |
| 8 | Vista Carousel (gestión) | `.../pagina_lista_fotos_carousel.dart` | ConsumerStatefulWidget | Tab 1 — fullscreen swipe | US-IMG-002 |
| 9 | Vista Cuadros (gestión) | `.../pagina_lista_fotos_cuadros.dart` | ConsumerStatefulWidget | Tab 2 — grid responsivo | US-IMG-002 |
| 10 | Vista Listado (gestión) | `.../pagina_lista_fotos_listado.dart` | ConsumerStatefulWidget | Tab 3 — ReorderableListView | US-IMG-002, US-IMG-004 |
| 11 | `AgregaMultiplesFotos` | `.../fotos_de_la_propiedad/pagina_agrega_multiples_fotos.dart` | StatefulWidget | Subida múltiple FilePicker | US-IMG-003 |
| 12 | `compressImage` | `funciones_compress_image.dart` | Función | Compresión flutter_image_compress | US-IMG-003 |
| 13 | `PlatformFileNoFinal` | `image_file_structure.dart` | Wrapper | Envoltorio FilePicker | US-IMG-003 |
| 14 | Constantes imagen | `variables_imagenes.dart` | Constantes | `maxFotosPorPropiedad`, `calidadCompresion`, `fotoPlaceholder` | US-IMG-003 |
| 15 | `uploadMultiplePhotos` / HTTP gestion | `.../futures_y_providers/http_funciones_gestion_foto.dart` | Función + http | POST/PUT/DELETE a Node.js API | US-IMG-003 |
| 16 | `base64ToFile`, `getMimeType` | `.../futures_y_providers/future_funciones_fotos.dart` | Helpers | Conversión formatos | US-IMG-003 |
| 17 | `future_get_fotos_by_idpr_orden` | `.../futures_y_providers/future_get_fotos_by_idpr_orden.dart` | Future | GET fotos ordenadas | US-IMG-004 |
| 18 | `future_recupera_ids_fotos_propiedad` | `.../futures_y_providers/future_recupera_ids_fotos_propiedad.dart` | Future | GET IDs fotos propiedad | US-IMG-001, US-IMG-002 |
| 19 | `ClassListaFotosCasaNotifierProvider` (IDs) | `.../futures_y_providers/provider_get_fotos_ids_user_propiedad.dart` | AsyncNotifierProvider | Provider IDs (nombre colisión!) | US-IMG-002 |
| 20 | `ListasFotosPropiedad` | `.../lista_fotos_ordenadas/clase_listas_fotos_propiedad.dart` | Helper class | Lógica de orden/diff | US-IMG-004 |
| 21 | `ListaFotosOrdenadasGetIdPropiedad` | `.../lista_fotos_ordenadas/data_fotos_ordenadas_get_idpropiedad.dart` | Modelo | Respuesta GET orden por idPropiedad | US-IMG-004 |
| 22 | `future_put_fotos_orden` | `.../lista_fotos_ordenadas/future_put_fotos_orden.dart` | Future | PUT crear doc orden | US-IMG-004 |
| 23 | `future_update_fotos_orden` | `.../lista_fotos_ordenadas/future_update_fotos_orden.dart` | Future | PUT actualizar doc orden (_rev) | US-IMG-004 |
| 24 | `ClassListaFotosCasaNotifierProvider` (orden) | `.../lista_fotos_ordenadas/provider_get_lista_fotos_ordenadas.dart` | AsyncNotifierProvider | Provider orden (nombre colisión!) | US-IMG-004 |
| 25 | `GetIdsFotosUserProp` | `.../lista_ids_fotos/data_fotos_get_ids_fotos_user_prop.dart` | Modelo | Parseo IDs fotos por user/prop | US-IMG-002 |
| 26 | `CouchDbReturnValue` | `.../datos_fotos/data_couchdb_post_return.dart` | Modelo | Respuesta POST upload | US-IMG-003 |
| 27 | `CuentaFotos` | `.../datos_fotos/data_cuenta_fotos.dart` | Modelo | Contador por propiedad (validación límite) | US-IMG-003 |
| 28 | `ListaFotosIdsPropiedadGet` | `.../datos_fotos/data_fotos_lista_fotos_iduser_idprop.dart` | Modelo | Lista IDs por user/propiedad | US-IMG-005 |

---

## Tabla 2 — Detalle por archivo (alcance estricto, sin `.g.dart`/`.freezed.dart`)

| # | Ruta relativa (desde `lib\22_imagenes\`) | Clases / Funciones principales | Líneas aprox. | Dependencias clave (import) | Estado | Comentario / Deuda técnica |
|---|------------------------------------------|--------------------------------|---------------|------------------------------|--------|----------------------------|
| 1 | `data_models/data_fotos_casa.dart` | `FotosCasa`, `FotosCasaClass` | ~60 | `freezed`, `json_serializable` | ✓ ok | Modelo documento CouchDB foto |
| 2 | `data_models/data_fotos_casa_get.dart` | `FotosCasaGet`, `ValueFotosCasaGet` | ~80 | `data_fotos_casa.dart` | ✓ ok | Modelo vista fotos por propiedad |
| 3 | `data_models/data_fotos_casa_get_ids.dart` | `FotosCasaGetIDs`, `ValueFotosCasaGetIDs` | ~70 | `freezed` | ✓ ok | Vista optimizada (sólo IDs) |
| 4 | `data_models/data_fotos_ordenadas.dart` | `ListaFotosOrdenadas`, `FotosOrden` | ~80 | `freezed` | ✓ ok | Modelo orden custom |
| 5 | `inicio_fotos_usuario/pagina_carousel_fotos_usuario.dart` | `PaginaCarouselFotosUsuario`, `PaginaCarouselFotosUsuarioState` | ~250 | `carousel_slider`, `08_pantallas`, `03_listas`, `provider_session`, `future_builder_state_widgets`, `debugprint` | ✓ ok | CarouselSlider v5+ con `CarouselSliderController`; overlay glass-morphism con datos propiedad; transición a detalle via Hero. Importa `PaginaDetallePropiedad` (potencial import cíclico) |
| 6 | `inicio_fotos_usuario/pagina_carousel_fotos_usuario_mini.dart` | `PaginaCarouselFotosMini` | ~120 | `carousel_slider`, `app_routes` | ✓ ok | Versión mini height~150px para lisView/GridView de resultados |
| 7 | `tus_espacios_fotos_propiedad/funciones_compress_image.dart` | `compressImage(File, {quality, maxWidth, maxHeight})` | ~80 | `flutter_image_compress`, `image_file_structure` | ⚠ advertencia | `flutter_image_compress` es **nativo** — Web/WASM no soportado. Deuda técnica documentada |
| 8 | `tus_espacios_fotos_propiedad/image_file_structure.dart` | `PlatformFileNoFinal` | ~40 | `file_picker` | ✓ ok | Wrapper en torno a `PlatformFile` para evitar estado final |
| 9 | `tus_espacios_fotos_propiedad/manejo_de_fotos/datos_fotos/data_couchdb_post_return.dart` | `CouchDbReturnValue` | ~30 | — | ✓ ok | Respuesta POST upload (`ok, id, rev, error?`) |
| 10 | `tus_espacios_fotos_propiedad/manejo_de_fotos/datos_fotos/data_cuenta_fotos.dart` | `CuentaFotos` | ~25 | — | ✓ ok | Contador fotos/propiedad para validar `maxFotosPorPropiedad` |
| 11 | `tus_espacios_fotos_propiedad/manejo_de_fotos/datos_fotos/data_fotos_lista_fotos_iduser_idprop.dart` | `ListaFotosIdsPropiedadGet` | ~50 | — | ✓ ok | Lista IDs por (idUsuario, idPropiedad) |
| 12 | `tus_espacios_fotos_propiedad/manejo_de_fotos/fotos_de_la_propiedad/pagina_agrega_multiples_fotos.dart` | `AgregaMultiplesFotos` | ~200 | `file_picker`, `funciones_compress_image`, `http_funciones_gestion_foto`, `variables_imagenes`, `debugprint` | ✓ ok | Subida múltiple: `FilePicker.pickFiles(allowMultiple:true)` → `compressImage` → POST multipart. Manejo try-catch por archivo. Validación límite `maxFotosPorPropiedad` |
| 13 | `tus_espacios_fotos_propiedad/manejo_de_fotos/futures_y_providers/future_funciones_fotos.dart` | `base64ToFile`, `getMimeType` | ~40 | `dart:convert`, `path` | ✓ ok | Helpers conversión formatos |
| 14 | `tus_espacios_fotos_propiedad/manejo_de_fotos/futures_y_providers/future_get_fotos_by_idpr_orden.dart` | `future_get_fotos_by_idpr_orden` | ~70 | `dio`, `direccionip`, `provider_session` | ✓ ok | GET orden custom para un idPropiedad |
| 15 | `tus_espacios_fotos_propiedad/manejo_de_fotos/futures_y_providers/future_recupera_ids_fotos_propiedad.dart` | `future_recupera_ids_fotos_propiedad` | ~70 | `dio`, `direccionip`, `provider_session` | ✓ ok | GET IDs fotos vista CouchDB |
| 16 | `tus_espacios_fotos_propiedad/manejo_de_fotos/futures_y_providers/http_funciones_gestion_foto.dart` | `uploadMultiplePhotos`, `deletePhoto`, `updatePhoto` | ~150 | `dio`, `direccionip`, `data_couchdb_post_return`, `debugprint` | ✓ ok | HTTP PUT/POST/DELETE a Node.js API. Manejo errores genérico (SnackBar) — deuda: diferenciar red/auth/server/quota |
| 17 | `tus_espacios_fotos_propiedad/manejo_de_fotos/futures_y_providers/provider_get_fotos_ids_user_propiedad.dart` | `ClassListaFotosCasaNotifierProvider` | ~60 | `riverpod`, `future_recupera_ids_fotos_propiedad` | ⚠ colisión | Provider IDs. **Colisión de nombres** con #24 (mismo nombre, distinta funcionalidad) |
| 18 | `tus_espacios_fotos_propiedad/manejo_de_fotos/lista_fotos_ordenadas/clase_listas_fotos_propiedad.dart` | `ListasFotosPropiedad` | ~80 | — | ✓ ok | Helper lógica diff/orden entre listas |
| 19 | `tus_espacios_fotos_propiedad/manejo_de_fotos/lista_fotos_ordenadas/data_fotos_ordenadas_get_idpropiedad.dart` | `ListaFotosOrdenadasGetIdPropiedad` | ~50 | — | ✓ ok | Modelo respuesta GET orden por idPropiedad |
| 20 | `tus_espacios_fotos_propiedad/manejo_de_fotos/lista_fotos_ordenadas/future_put_fotos_orden.dart` | `future_put_fotos_orden` | ~70 | `dio`, `direccionip`, `data_fotos_ordenadas` | ✓ ok | PUT crear doc `fotosordenadas:<idPropiedad>`. Maneja 409 Conflict con SnackBar + GET |
| 21 | `tus_espacios_fotos_propiedad/manejo_de_fotos/lista_fotos_ordenadas/future_update_fotos_orden.dart` | `future_update_fotos_orden` | ~70 | `dio`, `direccionip`, `data_fotos_ordenadas` | ✓ ok | PUT actualizar orden (con `_rev`). Misma lógica de 409 |
| 22 | `tus_espacios_fotos_propiedad/manejo_de_fotos/lista_fotos_ordenadas/provider_get_lista_fotos_ordenadas.dart` | `ClassListaFotosCasaNotifierProvider` | ~80 | `riverpod`, `future_get_fotos_by_idpr_orden` | ⚠ colisión | Provider orden. **Colisión de nombres** con #17 |
| 23 | `tus_espacios_fotos_propiedad/manejo_de_fotos/lista_ids_fotos/data_fotos_get_ids_fotos_user_prop.dart` | `GetIdsFotosUserProp` | ~80 | — | ✓ ok | Parseo IDs fotos por user/prop (rows totalRows offset) |
| 24 | `tus_espacios_fotos_propiedad/manejo_de_fotos/opciones_menu_fotos/pagina_fotos_menu_opciones.dart` | `PaginaFotosPropiedad`, `PaginaFotosPropiedadState` | ~300 | `riverpod`, `tabController`, `pagina_lista_fotos_carousel/cuadros/listado`, `data_espacios_casas_get`, `debugprint` | ✓ ok | Contenedor 3 tabs con `TabController(length:3)` + `_handleTabSelection`. Initial state `buttonSelectOpcionFotos = [true,false,false]` debería ser provider (deuda) |
| 25 | `tus_espacios_fotos_propiedad/manejo_de_fotos/opciones_menu_fotos/pagina_lista_fotos_carousel.dart` | Vista Carousel gestión | ~150 | `carousel_slider`, `page_compartir_con_*` | ✓ ok | Tab 1 fullscreen swipe con `PageStorageKey` |
| 26 | `tus_espacios_fotos_propiedad/manejo_de_fotos/opciones_menu_fotos/pagina_lista_fotos_cuadros.dart` | Vista Cuadros gestión | ~150 | `var_color_widget` (breakpoints), `page_compartir_con_*` | ✓ ok | Tab 2 GridView responsivo con `crossAxisCount` dinámico |
| 27 | `tus_espacios_fotos_propiedad/manejo_de_fotos/opciones_menu_fotos/pagina_lista_fotos_listado.dart` | Vista Listado gestión | ~200 | `ReorderableListView`, `provider_get_lista_fotos_ordenadas`, `future_put/update_fotos_orden`, `page_compartir_con_*` | ✓ ok | Tab 3 con `ReorderableListView.onReorder` + `ReorderableDragStartListener`. PopupMenuButton por foto (5 acciones). Manejo 409 |
| 28 | `variables_imagenes.dart` | `maxFotosPorPropiedad`, `calidadCompresion=70`, `maxDimension=1920`, `fotoPlaceholder` | ~30 | — | ✓ ok | Constantes globales del módulo |

---

## Notas críticas

- **Colisión de nombres en providers (#17 vs #24):** Ambos definen `ClassListaFotosCasaNotifierProvider` con distinta funcionalidad (IDs vs orden). Diferenciar explícitamente al referenciar o renombrar (`ClassFotosIdsProvider` vs `ClassFotosOrdenProvider`).
- **Import cíclico potencial:** `pagina_carousel_fotos_usuario.dart` importa `PaginaDetallePropiedad` (de `08_pantallas/propiedades/`) y este probablemente importa al carousel. En práctica no causa loop por delegación a `AppRoutes.routeGenerate()`.
- **`flutter_image_compress` nativo:** No soportado en Web/WASM — el flujo Web cae a `bytes` sin compresión, aumenta ancho de banda. Deuda documentada.
- **`ReorderableListView` + 409 conflict:** Verificar que todas las ramas de error muestren SnackBar y rehagan GET (no dejen al usuario en estado roto).
- **Manejo de errores genérico:** `http_funciones_gestion_foto` responde con SnackBar genérico — diferenciar red/auth/server/quota mejorará UX.
- **5 niveles de subcarpetas** en `tus_espacios_fotos_propiedad/manejo_de_fotos/` dificultan navegación y testing.
- **Sin tests:** Ningún test unitario/widget de compresión, subida, reorden o carousel. Sólo existe el smoke test global.
