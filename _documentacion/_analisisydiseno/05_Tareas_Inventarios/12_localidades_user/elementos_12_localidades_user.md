# Inventario de Componentes — 12_localidades_user

**Directorio:** `lib/12_localidades_user/`  
**Archivos:** 4 (+ generados)  
**Fecha:** 2026-08-12

---

## Tabla 1: Componentes (por archivo)

| Subdirectorio | Nombre del archivo | Tipo de componente | Nombre del componente | Parámetros que requiere | Variables que utiliza | Variables internas | Estilos que le aplican |
|---------------|-------------------|-------------------|----------------------|------------------------|----------------------|-------------------|------------------------|
| 12_localidades_user | `data_user_localidad.dart` | Modelo @freezed | `UsuarioLocalidades` | `idCodigopostal, idUsuario, pais, localidadCp, calle, seccionine, latitud, longitud, timestamp` | `freezed_annotation` | 9 campos inmutables | — |
| 12_localidades_user | `data_user_localidad_get.dart` | Modelos respuesta @freezed | `UsuarioLocalidadesGet`, `RowsUserLocal` | Wrapper respuesta CouchDB | `freezed_annotation` | Nested | — |
| 12_localidades_user | `localidades_repository.dart` | Clase HTTP puro | `LocalidadesRepository` | — | `http`, `dart:convert` | — | `fetchUserLocalidades`, `fetchUserLocalidad`, `saveUserLocalidad` (anti-dup), `deleteUserLocalidad`, `fetchByCodigoPostal` |
| 12_localidades_user | `provider_get_localidades_usuario.dart` | Notifier + FutureProvider | `ClassUserLocalNotifierProvider`, `getUserLocalidadesFutureProvider` | — | `LocalidadesRepository`, `UsuarioLocalidades` | `state` | `fetchLocalidadesDeUsuario`, `writeUserLocalidadToCouchDB`, `deleteUserLocalidadFromCouchDB`, `setLocalidadSeleccionada`, `addLocalidad2UserLocalidad`, `reset...` |

---

## Tabla 2: Elementos (por archivo)

| Subdirectorio | Nombre del archivo | Variables definidas en el archivo | Clases | Variables de la clase | Funciones o widgets definidos en la clase | Variables que utiliza | Llamadas a otras clases o widgets |
|---------------|-------------------|----------------------------------|--------|----------------------|------------------------------------------|----------------------|----------------------------------|
| 12_localidades_user | `data_user_localidad.dart` | — | `UsuarioLocalidades` (@freezed) | `idCodigopostal, idUsuario, pais, localidadCp, calle, seccionine, latitud, longitud, timestamp` | Constructor factory, `copyWith` (generado) | `freezed_annotation` | — |
| 12_localidades_user | `data_user_localidad_get.dart` | — | `UsuarioLocalidadesGet`, `RowsUserLocal` (@freezed) | `totalRows, offset, rows[]`, `id, key, value` | Constructores, `copyWith` (generado) | `freezed_annotation` | — |
| 12_localidades_user | `localidades_repository.dart` | — | `LocalidadesRepository` | — | `fetchUserLocalidades(userId)`, `fetchUserLocalidad(userId, asentamiento)`, `saveUserLocalidad(localidad)` (GET previo anti-dup), `deleteUserLocalidad(docId, rev)`, `fetchByCodigoPostal(cp)` | `http`, `dart:convert` | `http.get()`, `http.post()`, `http.put()`, `jsonDecode()` |
| 12_localidades_user | `provider_get_localidades_usuario.dart` | `ClassUserLocalNotifierProvider`, `getUserLocalidadesFutureProvider` | `ClassUserLocalNotifierProvider` | `state` | `fetchLocalidadesDeUsuario(userId)`, `gdtLocalidadUsuario()`, `writeUserLocalidadToCouchDB()`, `deleteUserLocalidadFromCouchDB()`, `setLocalidadSeleccionada()`, `setUserLocalSelectedFromLocalidades()`, `setUserLocalFromUserLocalGet()`, `resetUsuarioLocalidadesGet()`, `resetlistaLocalidadesUsuario()`, `addLocalidad2UserLocalidad()` | `LocalidadesRepository`, `UsuarioLocalidades` | `LocalidadesRepository.saveUserLocalidad()`, `deleteUserLocalidad()`, `fetchByCodigoPostal()` |

---

# Inventario de Componentes — 14_geolocalizacion

**Directorio:** `lib/14_geolocalizacion/`  
**Archivos:** 4  
**Fecha:** 2026-08-12

---

## Tabla 1: Componentes (por archivo)

| Subdirectorio | Nombre del archivo | Tipo de componente | Nombre del componente | Parámetros que requiere | Variables que utiliza | Variables internas | Estilos que le aplican |
|---------------|-------------------|-------------------|----------------------|------------------------|----------------------|-------------------|------------------------|
| 14_geolocalizacion | `app_keys.dart` | Constantes compile-time | `GOOGLE_KEY`, `GOOGLE_MAPS_KEY` | `String.fromEnvironment()` | `--dart-define-from-file=defines.json` | — | — |
| 14_geolocalizacion | `google_map_mapa_propiedades.dart` | ConsumerStatefulWidget | `PaginaMapaPropiedades` | `EspaciosCasaGet` (arguments) | `google_maps_flutter`, `geolocator`, `geocoding`, `EspaciosCasaGet` | `_PaginaMapaPropiedadesState` | `GoogleMap`, `Marker`, `BitmapDescriptor`, `Canvas` (custom marker) |
| 14_geolocalizacion | `google_map_place_data.dart` | Clases modelo (manual) | `GooglemapPlace`, `PlusCode`, `Result`, `AddressComponent`, `Geometry`, `Viewport`, `NortheastClass`, `NavigationPoint` | JSON Geocoding API | — | Nested classes | — |
| 14_geolocalizacion | `provider_actual_place.dart` | Notifier + State class | `DatosDeLaUbicacionActual`, `ClassLocalidadesNotifierProvider` | — | `geolocator`, `geocoding`, `http` (REST), `MaterialSymbols` | `state` (DatosDeLaUbicacionActual) | `determinePermisosUbicacion`, `getAddressFromLatLng`, `getPlaceFromCoordinates` (REST), `determinaUbicacion` (platform switch), `_procesarResultadoGeocodingAPI`, `_notify` |

---

## Tabla 2: Elementos (por archivo)

| Subdirectorio | Nombre del archivo | Variables definidas en el archivo | Clases | Variables de la clase | Funciones o widgets definidos en la clase | Variables que utiliza | Llamadas a otras clases o widgets |
|---------------|-------------------|----------------------------------|--------|----------------------|------------------------------------------|----------------------|----------------------------------|
| 14_geolocalizacion | `app_keys.dart` | `GOOGLE_KEY`, `GOOGLE_MAPS_KEY` | — | — | — | `String.fromEnvironment()` | — |
| 14_geolocalizacion | `google_map_mapa_propiedades.dart` | — | `PaginaMapaPropiedades` | `espaciosCasaGet` (EspaciosCasaGet) | `createState()`, `_PaginaMapaPropiedadesState.initState()`, `_cargarMarcadores()`, `_createCustomMarkerBitmap()`, `_ajustarCamaraPorNombreNivelGobierno()`, `build()` | `google_maps_flutter`, `geolocator`, `geocoding` | `GoogleMapController`, `Marker()`, `BitmapDescriptor.fromBytes()`, `Canvas.drawRect()`, `Canvas.drawText()`, `animateCamera()` |
| 14_geolocalizacion | `google_map_place_data.dart` | — | 8 clases anidadas | Campos según JSON Geocoding API | Constructores manuales (fromJson implícito) | — | — |
| 14_geolocalizacion | `provider_actual_place.dart` | `ClassLocalidadesNotifierProvider` | `DatosDeLaUbicacionActual` | `marcadores, postalCode, addressGM, permisosUbicacion, latitud, longitud, placemarks, mapController` | `determinePermisosUbicacion()`, `getAddressFromLatLng()`, `getPlaceFromCoordinates()`, `determinaUbicacion()` (switch: Web/Win→REST, Android/iOS→nativo), `_procesarResultadoGeocodingAPI()`, `_notify()` (recrea estado) | `geolocator`, `geocoding`, `http`, `MaterialSymbols` | `Geolocator.requestPermission()`, `Geolocator.getCurrentPosition()`, `placemarkFromCoordinates()`, `http.get(maps.googleapis.com)`, `state = DatosDeLaUbicacionActual(...)` |

---

# Inventario de Componentes — 03_listas

**Directorio:** `lib/03_listas/`  
**Archivos:** 15 raíz + 2 models + 1 providers = 18 archivos  
**Fecha:** 2026-08-12

---

## Tabla 1: Componentes (por archivo - resumen)

| Subdirectorio | Nombre del archivo | Tipo de componente | Nombre del componente | Parámetros que requiere | Variables que utiliza | Variables internas | Estilos que le aplican |
|---------------|-------------------|-------------------|----------------------|------------------------|----------------------|-------------------|------------------------|
| 03_listas | `data_lista_propiedad.dart` | Modelos | `ListaPropertyListModel`, `Listapropiedad`, `RowListaProperty` | `listapropiedadId, userId, listaId, propertyId, tipodeespacio, type, timestamp` | — | DTOs | — |
| 03_listas | `data_lista_propiedad_get.dart` | Modelo respuesta | `GetListaPropertyListModel` | `totalRows, offset, rows[]` | — | Wrapper | — |
| 03_listas | `data_user_list_model.dart` | Modelos | `UserPropertyListModel`, `Lista`, `RowGetUserPropertyList` | `listaId, userId, listName, type, timestamp` | — | DTOs | — |
| 03_listas | `data_user_list_model_get.dart` | Modelo respuesta | `GetUserPropertyListModel` | `totalRows, offset, rows[]` | — | Wrapper | — |
| 03_listas | `models/lista_compartida_model.dart` | Modelo | `ListaCompartidaModel` | `id, rev, listaOrigenId, listaNombre, usuarioOrigenId/Nombre, usuarioDestinoId/Nombre, timestamp, type` | — | — | — |
| 03_listas | `models/me_gusta_model.dart` | Modelo | `MeGustaModel` | `id, rev, usuarioId, propiedadId, timestamp, type` | — | — | — |
| 03_listas | `lista_select_lista_save_propiedad.dart` | ConsumerStatefulWidget | `DialogSelectorListas` | `List<String> propertyIds` | `userListsProvider`, `listaPropiedadesProvider` | `_DialogSelectorListasState` | `AlertDialog`, `TabBar`, `CheckboxListTile`, `TextField` (nueva lista) |
| 03_listas | `page_compartir_con_conocido.dart` | ConsumerStatefulWidget | `PageCompartirConConocido` | `String propertyId` | `conocidosProvider`, `propiedadesCompartidasConocidosProvider`, `mensajesChatProvider` | `_PageCompartirConConocidoState` | `CheckboxListTile` (máx 5), `ElevatedButton` |
| 03_listas | `page_compartir_con_grupo.dart` | ConsumerStatefulWidget | `PageCompartirConGrupo` | `String propertyId` | `gruposProvider`, `publicacionesGrupoProvider`, `mensajesGrupoProvider` | `_PageCompartirConGrupoState` | `CheckboxListTile`, `ElevatedButton` |
| 03_listas | `pagina_detalle_lista_compartida.dart` | ConsumerStatefulWidget | `PageDetalleListaCompartida` | `ListaCompartidaModel` | `listasCompartidasProvider`, `WrapModernCardPropiedades` | `_PageDetalleListaCompartidaState` | `FutureBuilder`, `_getPropiedad()` fallback endpoints |
| 03_listas | `pagina_detalle_listas.dart` | ConsumerStatefulWidget | `PageDetalleLista` | `Lista` | `provider_listas_propiedades`, `propertiesDetailsProvider`, `WrapModernCardPropiedades` | `_PageDetalleListaState` | `Dismissible`, `FutureBuilder`, `_getPropiedadFallback()` |
| 03_listas | `pagina_mis_listas.dart` | ConsumerStatefulWidget | `PageMisListas` | — | `userListsProvider`, `listasCompartidasProvider`, `provider_listas_propiedades`, `provider_propiedades_compartidas_conocidos`, `mensajesChatProvider`, `publicacionesGrupoProvider` | `_PageMisListasState` | `TabBar` (3 tabs), `_tabPropias()`, `_tabRecibidas()`, `_tabEnviadas()`, dialogs crear/compartir |
| 03_listas | `provider_listas_compartidas.dart` | AsyncNotifier | `ListasCompartidasNotifier` | — | `http`, `uuid` | `state` | `fetchListasCompartidas`, `compartirLista` (anti-dup, copia props, notifica chat), `dejarDeCompartir`, `fetchPropiedadesListaCompartida` |
| 03_listas | `provider_listas_propiedades.dart` | Notifier | `ClassListaPropiedadesProvider` | — | `http` | `state` | `getListaPropiedad`, `addPropiedadALista`, `borrarPropiedadDeLista`, `borrarListapropiedadPorId`, `getPropiedadesDetallesPorListaId` (bulk $in) |
| 03_listas | `provider_me_gusta.dart` | AsyncNotifier | `MeGustaNotifier` | — | `http`, `uuid`, `UserListsNotifier` | `state` | `init(userId)`, `toggleMeGusta` (auto-crea Favoritas), `_agregarMeGusta`, `_quitarMeGusta`, `_agregarPropiedadAFavoritas` |
| 03_listas | `provider_propiedades_compartidas_conocidos.dart` | Notifier | `PropiedadesCompartidasConocidosNotifier` | — | `http`, `uuid` | `state` | `fetchPropiedadesCompartidas`, `compartirPropiedad` (UUID + PUT) |
| 03_listas | `provider_user_lists.dart` | Notifier + FutureProvider.family | `UserListsNotifier`, `propertiesDetailsProvider` | — | `http` | `state` | `fetchUserLists` (vista, Favoritas primero), `createList` (SHA1 hash ID), `deleteLista` (GET _rev + PUT _deleted) |

---

## Tabla 2: Elementos (resumen providers clave)

| Subdirectorio | Nombre del archivo | Variables definidas en el archivo | Clases | Variables de la clase | Funciones o widgets definidos en la clase | Variables que utiliza | Llamadas a otras clases o widgets |
|---------------|-------------------|----------------------------------|--------|----------------------|------------------------------------------|----------------------|----------------------------------|
| 03_listas | `provider_listas_compartidas.dart` | `listasCompartidasProvider` | `ListasCompartidasNotifier` (AsyncNotifier) | `state` | `fetchListasCompartidas(userId)`, `compartirLista(lista, destinos)` (anti-dup: mismo origen+destino → skip), `dejarDeCompartir(id)`, `fetchPropiedadesListaCompartida(id)` | `http`, `uuid`, `mensajesChatProvider` | `http.get/post/put`, `Uuid().v4()`, `mensajesChatProvider.enviar(tipo:'lista')` |
| 03_listas | `provider_listas_propiedades.dart` | `listaPropiedadesProvider` | `ClassListaPropiedadesProvider` | `state` | `getListaPropiedad(listaId)`, `addPropiedadALista(listaId, propertyId)`, `borrarPropiedadDeLista(listaId, propertyId)`, `borrarListapropiedadPorId(id)`, `getPropiedadesDetallesPorListaId(listaId)` (Mango $in) | `http` | `http.get/put`, Mango query `$in` |
| 03_listas | `provider_me_gusta.dart` | `meGustaProvider` | `MeGustaNotifier` (AsyncNotifier) | `state` | `init(userId)`, `toggleMeGusta(propiedadId)` (crea/borra en buscobien_megusta_propiedades, auto-crea lista Favoritas si primera vez), `_agregarMeGusta`, `_quitarMeGusta`, `_agregarPropiedadAFavoritas` (anti-dup) | `http`, `uuid`, `UserListsNotifier` | `http.get/post/put`, `Uuid().v4()`, `UserListsNotifier._agregarPropiedadAFavoritas()` |
| 03_listas | `provider_user_lists.dart` | `userListsProvider`, `propertiesDetailsProvider` | `UserListsNotifier` | `state` | `fetchUserLists(userId)` (vista CouchDB, Favoritas primero), `createList(nombre)` (SHA1 hash ID), `deleteLista(docId, userId)` (GET _rev + PUT _deleted) | `http` | `http.get/put`, `sha1.convert(utf8.encode(...))`, Mango `$in` en `propertiesDetailsProvider` |