# Inventario de Elementos — Pantallas: Ubicación y Búsqueda de Localidades (08_pantallas/ubicacion)

**Directorio:** `lib\08_pantallas\ubicacion\`
**Total archivos `.dart`:** 9 (7 fuente + 2 generados `.freezed.dart`/`.g.dart`)
**Total líneas aprox:** 1,400 (fuente) + 559 (generados) = ~1,960. `data_models/` solo contiene JSON.
**Epic asociado:** [`02_Epics_EARS/08_pantallas_ubicacion.md`](../../02_Epics_EARS/08_pantallas_ubicacion.md)
**Features BDD:** [`03_Features_BDD/08_pantallas_ubicacion/ubicacion_busqueda_localidades.feature`](../../03_Features_BDD/08_pantallas_ubicacion/ubicacion_busqueda_localidades.feature) (8 escenarios)
**User Stories:** [`04_User_Stories/08_pantallas_ubicacion.md`](../../04_User_Stories/08_pantallas_ubicacion.md) (4 US)
**Fecha:** 2026-08-13
**Fuente:** Ingeniería inversa

---

## Tabla 1 — Resumen de componentes por rol funcional

| # | Componente | Ruta | Tipo | Rol funcional | Líneas | US-UBIC |
|---|-------------|------|------|----------------|--------|---------|
| 1 | `PaginaPrincipalListaLocalidades`, `State` | `pagina_principal_localidades.dart` | ConsumerStatefulWidget | Hub: lista mis localidades + CTAs | 483 | US-UBIC-001 |
| 2 | `PaginaBuscaLocalidadGMaps`, `State` | `pagina_busca_localidades_gmaps.dart` | ConsumerStatefulWidget | Búsqueda por CP + Google Maps | 347 | US-UBIC-002 |
| 3 | `LocalidadesListScreen`, `State` | `screen_maestro_localidades.dart` | ConsumerStatefulWidget | Vista maestra SEPOMEX (duplicada) | 443 | US-UBIC-003 |
| 4 | `ClassLocalidadesNotifierProvider` | `provider_localidades_del_cp.dart` | AsyncNotifier (legacy) | Estado reactivo localidades por CP | 109 | US-UBIC-001, 002 |
| 5 | `FindLocalidadXcp`, `Doc` | `data_localidad_find.dart` | Modelo (json manual) | Mango query por CP | 42 | US-UBIC-004 |
| 6 | `LocalidadCp` (Freezed) | `data_sepomex_localidades.dart` | Modelo **Freezed** | Datos oficiales SEPOMEX | 23 | US-UBIC-002 |
| 7 | (generados) `data_sepomex_localidades.freezed.dart` / `.g.dart` | — | build_runner | Boilerplate Freezed | 559 | — |
| 8 | `LocalidadesGet`, `RowLocalidadesGet`, `ValueLocalidadesGet` | `data_sepomex_localidades_get_cp.dart` | Modelo (json manual) | Vista CouchDB por CP | 89 | US-UBIC-001 |
| 9 | `data_sepomex_id.json` | `data_models/data_sepomex_id.json` | JSON estático | Mapeo CP→ID SEPOMEX | 349 bytes | — |

---

## Tabla 2 — Detalle por archivo fuente (excluye generados y JSON)

| # | Archivo | Clases / Funciones | Líneas | Dependencias clave | Estado | Comentario / Deuda |
|---|---------|--------------------|--------|---------------------|--------|--------------------|
| 1 | `pagina_principal_localidades.dart` | `PaginaPrincipalListaLocalidades`, `_PaginaPrincipalListaLocalidadesState` | 483 | `flutter_riverpod`, `symbols`, `var_color_*`, `provider_localidades_del_cp`, `pagina_busca_localidades_gmaps`, `screen_maestro_localidades`, `app_routes`, `future_builder_state_widgets`, `debugprint` | ⚠ deuda | Hub funcional. **Duplicación con `screen_maestro_localidades`** (ver US-UBIC-003). CTAs: "Ver en mapa" → `PaginaBuscaLocalidadGMaps`; "Buscar propiedades" → filtra catálogo inicio |
| 2 | `pagina_busca_localidades_gmaps.dart` | `PaginaBuscaLocalidadGMaps`, `_PaginaBuscaLocalidadGMapsState` | 347 | `flutter_riverpod`, `symbols`, `var_color_*`, `data_sepomex_localidades`, `data_localidad_find`, `google_maps_flutter` (implícito), `direccionip` (API key), `app_routes`, `debugprint` | ⚠ deuda | **API Key Google Maps** debe venir de `defines.json` compile-time (`String.fromEnvironment`). Validación CP regex 5 dígitos. Fallback SEPOMEX → Google Geocoding |
| 3 | `screen_maestro_localidades.dart` | `LocalidadesListScreen`, `_LocalidadesListScreenState` | 443 | `flutter_riverpod`, `symbols`, `var_color_*`, `data_sepomex_localidades`, `data_localidad_find`, `pagina_busca_localidades_gmaps`, `debugprint` | ⚠ **deuda** | **Duplicación histórica** con `pagina_principal_localidades.dart`. Muestra lista maestra SEPOMEX completa + búsqueda por nombre. Refactor: unificar |
| 4 | `provider_localidades_del_cp.dart` | `ListaDeLocalidadesDelCP`, `ClassLocalidadesNotifierProvider` (AsyncNotifier) | 109 | `flutter_riverpod`, `dio`, `direccionip`, `data_sepomex_localidades_get_cp`, `provider_session`, `debugprint` | ⚠ deuda | Provider legacy `AsyncNotifier` sin `@riverpod`. Lista localidades del usuario + búsqueda por CP |
| 5 | `data_localidad_find.dart` | `FindLocalidadXcp`, `Doc` | 42 | `dart:convert` | ⚠ deuda menor | Json manual (no Freezed). Mango query builder: `{"selector": {"ubicacioncasa.cp": CP}}` |
| 6 | `data_sepomex_localidades.dart` | `LocalidadCp` (Freezed) | 23 | `freezed`, `json_serializable` | ✓ ok | **Único Freezed del módulo**. Campos: cp, asentamiento, municipio, estado, lat, lng. Genera 559 líneas boilerplate |
| 7 | `data_sepomex_localidades_get_cp.dart` | `LocalidadesGet`, `RowLocalidadesGet`, `ValueLocalidadesGet` | 89 | `dart:convert` | ⚠ deuda menor | Json manual. Respuesta vista CouchDB `buscobien_localidades_por_cp` |

---

## Notas críticas

- **Duplicación crítica `screen_maestro_localidades` (443) vs `pagina_principal_localidades` (483)** — ~926 líneas para funcionalidad 80% solapada. Refactor: unificar en `LocalidadesHub` con modo `user` (mis localidades) y `master` (todas SEPOMEX). Ahorro neto ~400 líneas.
- **Inconsistencia Freezed**: `data_sepomex_localidades.dart` es Freezed (genera 559 líneas); `data_sepomex_localidades_get_cp.dart` y `data_localidad_find.dart` son json manual. Migrar todo a Freezed.
- **Provider legacy**: `ClassLocalidadesNotifierProvider` usa `AsyncNotifier` sin `@riverpod` annotation. Riverpod 3.x deprecó. Migración con `build_runner`.
- **Google Maps API Key**: `pagina_busca_localidades_gmaps.dart` probablemente referencia `direccionip.dart` o `app_keys.dart` para `String.fromEnvironment('GOOGLE_MAPS_API_KEY')`. Confirmar que NO está hardcodeada.
- **`data_models/data_sepomex_id.json`**: archivo JSON suelto en `data_models/` — debería declararse como `asset` en `pubspec.yaml` y leerse via `rootBundle.loadString`, o provisto por provider `FutureProvider`.
- **Acoplamiento transversal**: 
  - `ubicacion` → `08_pantallas/inicio` (filtra catálogo por CP via `findPropiedadesEstadosde10en10Provider`).
  - `ubicacion` → `03_vistas/pagina_usuarios.dart` (usa mismo `codigoPostalBusquedaProvider`).
  - `14_geolocalizacion` (GMaps/Geocoding — ver US-GEO-002 dual platform).
- **Sin tests** de ninguno de los 7 archivos fuente.
- **DBs CouchDB involucradas** (transversal `06_Bases_de_Datos`): `buscobien_localidades_usuario`, `buscobien_localidades_por_cp` (vista SEPOMEX), `buscobien_propiedades_publicadas_*` (filtrado por CP).
