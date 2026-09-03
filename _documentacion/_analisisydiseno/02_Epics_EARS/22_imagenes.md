# Epic: Gestión de Imágenes y Fotos (22_imagenes)

**Directorio:** `lib\22_imagenes\`
**Subdirectorios:** `data_models/` (4), `inicio_fotos_usuario/` (2), `tus_espacios_fotos_propiedad/` (22 archivos en 5 subcarpetas) — **Total: 28 archivos `.dart`**
**Fecha:** 2026-08-12
**Fuente:** Ingeniería inversa

---

## Impact Mapping

| Objetivo de Negocio | Actor | Impacto | Entregable |
|---------------------|-------|---------|------------|
| Gestión visual completa de propiedades | Usuario final (comprador/arrendatario) | Ve fotos de propiedades en carousel responsivo en catálogo y detalle | `PaginaCarouselFotosUsuario` + `PaginaCarouselFotosMini` |
| | Promotor/Propietario | Sube, ordena, lista y gestiona fotos de sus propiedades (hasta N fotos) | Menú 3 vistas (Carousel/Cuadros/Listado) + subida múltiple + compresión + reorden |
| | Sistema | Comprime imágenes antes de subir; persiste IDs ordenados en CouchDB | `funciones_compress_image.dart` + `provider_get_lista_fotos_ordenadas` |

---

## User Story Mapping

```
┌─────────────────────────────────────────────────────────────────────────┐
│                    GESTIÓN DE FOTOS (22_imagenes)                       │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                         │
│  ┌──────────────────────────┐     ┌────────────────────────────────┐  │
│  │ 1. CAROUSEL USUARIO      │     │ 2. GESTIÓN FOTOS PROPIEDAD     │  │
│  │ (inicio_fotos_usuario)   │     │ (tus_espacios_fotos_propiedad) │  │
│  ├──────────────────────────┤     ├────────────────────────────────┤  │
│  │ PaginaCarouselFotosUsuario   │     │ PaginaFotosPropiedad (tabs): │  │
│  │ - Recibe ValueEspaciosCasaGet│     │  1. Carousel (pagina_lista_  │  │
│  │ - CarouselSlider (5.0+)     │     │      fotos_carousel.dart)    │  │
│  │ - Controller programático   │     │  2. Cuadros (pagina_lista_   │  │
│  │ - Mini version (PaginaCarousel│     │      fotos_cuadros.dart)    │  │
│  │   FotosMini)                │     │  3. Listado (pagina_lista_   │  │
│  │ - Compartir/Guardar/Detalle │     │      fotos_listado.dart)     │  │
│  └──────────────────────────┘     │                                │  │
│                                   │ Sub-features:                    │  │
│  Modelos:                         │ - Subida múltiple                │  │
│  - FotosCasa / FotosCasaGet       │   (pagina_agrega_multiples_      │  │
│  - FotosOrdenadas (orden custom)  │    fotos.dart)                  │  │
│  - ListaIds (IDs para orden)      │ - Compresión (funciones_         │  │
│                                   │   compress_image.dart)           │  │
│                                   │ - Ordenamiento drag&drop         │  │
│                                   │   (lista_fotos_ordenadas)        │  │
│                                   │ - Menú opciones (compartir,      │  │
│                                   │   guardar en lista, editar)      │  │
│                                   └────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────────────────┘
```

---

## Especificación SDD / EARS

**Prefijo IDs:** `REQ-IMG-XXX`

| ID | Tipo EARS | Requerimiento | Evidencia | Estado |
|----|-----------|---------------|-----------|--------|
| REQ-IMG-001 | **Ubicuo** | El sistema definirá modelos `@freezed` para fotos: `FotosCasa` (documento), `FotosCasaGet` (respuesta vista), `FotosOrdenadas` (orden custom), `ListaFotosOrdenadasGetIdPropiedad` (GET orden), `CouchDbReturnValue` (POST response). | `lib\22_imagenes\data_models\*.dart` | En código |
| REQ-IMG-002 | **Ubicuo** | El sistema expondrá `PaginaCarouselFotosUsuario` (ConsumerStatefulWidget) que recibe `ValueEspaciosCasaGet`, usa `CarouselSlider` v5+ con `CarouselSliderController`, muestra fotos en loop con indicador página, y permite navegar a detalle/compartir/guardar en lista. | `lib\22_imagenes\inicio_fotos_usuario\pagina_carousel_fotos_usuario.dart` | En código |
| REQ-IMG-003 | **Ubicuo** | El sistema expondrá `PaginaCarouselFotosMini` versión compacta para listados (grid/listado de propiedades), sin controles completos, solo preview visual. | `lib\22_imagenes\inicio_fotos_usuario\pagina_carousel_fotos_usuario_mini.dart` | En código |
| REQ-IMG-004 | **Evento** | Cuando el usuario acceda a gestión de fotos de una propiedad (`PaginaFotosPropiedad`), el sistema inicializará `TabController` con 3 tabs (Carousel, Cuadros, Listado) y cargará IDs de fotos vía `future_recupera_ids_fotos_propiedad` + orden custom vía `provider_get_lista_fotos_ordenadas`. | `pagina_fotos_menu_opciones.dart:45-80` | En código |
| REQ-IMG-005 | **Estado** | Mientras el usuario esté en `PaginaFotosPropiedad`, el sistema mantendrá 3 vistas sincronizadas bajo `TabController`: **Carousel** (fullscreen swipe), **Cuadros** (grid 2-3 cols con reorder), **Listado** (ReorderableListView con drag handle). | `pagina_lista_fotos_carousel.dart`, `pagina_lista_fotos_cuadros.dart`, `pagina_lista_fotos_listado.dart` | En código |
| REQ-IMG-006 | **Evento** | Cuando el usuario toque "Agregar fotos" en menú, el sistema navegará a `AgregaMultiplesFotos` (StatefulWidget) que usa `FilePicker` multi-selección, `funciones_compress_image.compressImage()` (calidad 70%, max 1920px), y sube a CouchDB vía `http_funciones_gestion_foto.uploadMultiplePhotos()`. | `pagina_agrega_multiples_fotos.dart`, `funciones_compress_image.dart` | En código |
| REQ-IMG-007 | **Evento** | Cuando el usuario reordene fotos en vista **Listado** (`ReorderableListView.onReorder`), el sistema actualizará `ListaFotosOrdenadas.fotosOrden` y persistirá vía `future_put_fotos_orden.dart` / `future_update_fotos_orden.dart` (PUT a CouchDB). | `pagina_lista_fotos_listado.dart`, `future_put_fotos_orden.dart` | En código |
| REQ-IMG-008 | **Evento** | Cuando el usuario seleccione foto en cualquier vista, el sistema mostrará menú contextual (`PopupMenuButton`) con: Ver detalle, Compartir con Conocido/Grupo, Agregar a lista, Editar/Eliminar. | `pagina_lista_fotos_listado.dart:PopupMenuButton`, `page_compartir_con_*.dart` | En código |
| REQ-IMG-009 | **Ubicuo** | El sistema comprimirá **todas** las imágenes antes de subir: `compressImage(File, {quality=70, maxWidth=1920, maxHeight=1080})` → `Uint8List` base64 → POST multipart a Node.js API → CouchDB attachment. | `funciones_compress_image.dart`, `http_funciones_gestion_foto.dart` | En código |
| REQ-IMG-010 | **No Deseado** | Si `FilePicker` retorna null (usuario cancela) o compresión falla, el sistema mostrará SnackBar y no navegará/subirá. | `pagina_agrega_multiples_fotos.dart` try-catch | Parcial |
| REQ-IMG-011 | **Complejo** | Mientras el usuario gestione fotos, cuando cambie de tab (Carousel ↔ Cuadros ↔ Listado), el sistema preservará `idFoto` seleccionado y scroll position vía `PageStorageKey` y estado en `PaginaFotosPropiedadState`. | `pagina_fotos_menu_opciones.dart` `tabControllerOpcionesFotos` listener | En código |
| REQ-IMG-012 | **Ubicuo** | El sistema usará `variables_imagenes.dart` para constantes: `fotoPlaceholder`, `maxFotosPorPropiedad`, `calidadCompresion=70`, `maxDimension=1920`. | `variables_imagenes.dart` | En código |

---

## Trazabilidad a Código

| Componente | Archivo | Función |
|------------|---------|---------|
| **Modelos** | `data_models/data_fotos_casa.dart` | `FotosCasa`, `FotosCasaClass` (doc CouchDB) |
| | `data_models/data_fotos_casa_get.dart` | `FotosCasaGet`, `ValueFotosCasaGet` (vista) |
| | `data_models/data_fotos_casa_get_ids.dart` | `FotosCasaGetIDs`, `ValueFotosCasaGetIDs` (IDs) |
| | `data_models/data_fotos_ordenadas.dart` | `ListaFotosOrdenadas`, `FotosOrden` (orden custom) |
| **Carousel Usuario** | `inicio_fotos_usuario/pagina_carousel_fotos_usuario.dart` | `PaginaCarouselFotosUsuario` (full) |
| | `inicio_fotos_usuario/pagina_carousel_fotos_usuario_mini.dart` | `PaginaCarouselFotosMini` (compacta) |
| **Gestión Propiedad** | `tus_espacios_fotos_propiedad/manejo_de_fotos/opciones_menu_fotos/pagina_fotos_menu_opciones.dart` | `PaginaFotosPropiedad` (tabs 3 vistas) |
| | `.../pagina_lista_fotos_carousel.dart` | Vista Carousel (swipe fullscreen) |
| | `.../pagina_lista_fotos_cuadros.dart` | Vista Cuadros (grid + reorder) |
| | `.../pagina_lista_fotos_listado.dart` | Vista Listado (ReorderableListView) |
| | `.../fotos_de_la_propiedad/pagina_agrega_multiples_fotos.dart` | `AgregaMultiplesFotos` (subida múltiple) |
| | `.../futures_y_providers/future_funciones_fotos.dart` | Helpers: `base64ToFile`, `getMimeType` |
| | `.../futures_y_providers/future_get_fotos_by_idpr_orden.dart` | GET fotos ordenadas |
| | `.../futures_y_providers/future_recupera_ids_fotos_propiedad.dart` | GET IDs fotos propiedad |
| | `.../futures_y_providers/http_funciones_gestion_foto.dart` | HTTP: upload, delete, update |
| | `.../futures_y_providers/provider_get_fotos_ids_user_propiedad.dart` | `ClassListaFotosCasaNotifierProvider` (AsyncNotifier) |
| | `.../lista_fotos_ordenadas/clase_listas_fotos_propiedad.dart` | `ListasFotosPropiedad` (helper orden) |
| | `.../lista_fotos_ordenadas/data_fotos_ordenadas_get_idpropiedad.dart` | `ListaFotosOrdenadasGetIdPropiedad` (GET orden) |
| | `.../lista_fotos_ordenadas/future_put_fotos_orden.dart` | PUT crear orden |
 | | `.../lista_fotos_ordenadas/future_update_fotos_orden.dart` | PUT actualizar orden |
| | `.../lista_fotos_ordenadas/provider_get_lista_fotos_ordenadas.dart` | `ClassListaFotosCasaNotifierProvider` (orden) |
| | `.../lista_ids_fotos/data_fotos_get_ids_fotos_user_prop.dart` | `GetIdsFotosUserProp` (IDs) |
| **Utilidades** | `funciones_compress_image.dart` | `compressImage()` (quality 70%, max 1920px) |
| | `image_file_structure.dart` | `PlatformFileNoFinal` (wrapper FilePicker) |
| | `variables_imagenes.dart` | Constantes globales |
| | `datos_fotos/data_couchdb_post_return.dart` | `CouchDbReturnValue` (POST response) |
| | `datos_fotos/data_cuenta_fotos.dart` | `CuentaFotos` (contador) |
| | `datos_fotos/data_fotos_lista_fotos_iduser_idprop.dart` | `ListaFotosIdsPropiedadGet` (lista IDs) |

---

## Deuda Técnica

1. **22 archivos en `tus_espacios_fotos_propiedad`** — estructura muy profunda (5 niveles de subcarpetas) dificulta navegación y testing.
2. **Dos providers `ClassListaFotosCasaNotifierProvider`** con mismo nombre en `futures_y_providers/` y `lista_fotos_ordenadas/` — colisión de nombres (diferente funcionalidad: uno para IDs, otro para orden).
3. **`funciones_compress_image.dart`** usa `flutter_image_compress` (nativo) — no disponible en Web (requiere fallback o `web` package).
4. **`CarouselSlider` v5+** — breaking change `CarouselController` → `CarouselSliderController`; código comenta ambas versiones.
5. **Sin tests** de compresión, subida, reorden, ni carousel.
6. **Manejo de errores HTTP** genérico (SnackBar) sin diferenciar tipos (red, auth, server, quota).