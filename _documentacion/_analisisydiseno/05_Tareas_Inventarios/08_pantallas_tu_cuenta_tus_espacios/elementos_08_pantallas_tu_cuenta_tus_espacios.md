# Inventario de Elementos — Pantallas: Tus Espacios (08_pantallas/tu_cuenta/tus_espacios)

**Directorio:** `lib\08_pantallas\tu_cuenta\tus_espacios\`
**Total archivos `.dart` fuente:** 10 (6 en raíz + 4 en `compra_espacios/`)
**Total líneas aprox:** ~17,800 (incluye 3 archivos gigantescos — *el módulo más pesado del proyecto*)
**Epic asociado:** [`02_Epics_EARS/08_pantallas_tu_cuenta_tus_espacios.md`](../../02_Epics_EARS/08_pantallas_tu_cuenta_tus_espacios.md)
**Features BDD:** [`03_Features_BDD/08_pantallas_tu_cuenta_tus_espacios/tus_espacios_captura_publicacion.feature`](../../03_Features_BDD/08_pantallas_tu_cuenta_tus_espacios/tus_espacios_captura_publicacion.feature) (10 escenarios)
**User Stories:** [`04_User_Stories/08_pantallas_tu_cuenta_tus_espacios.md`](../../04_User_Stories/08_pantallas_tu_cuenta_tus_espacios.md) (6 US)
**Fecha:** 2026-08-13
**Fuente:** Ingeniería inversa

---

## Tabla 1 — Resumen de componentes por rol funcional

| # | Componente | Archivo | Tipo | Rol funcional | Líneas | US-TUS |
|---|-------------|---------|------|----------------|--------|--------|
| 1 | `PaginaTusEspacios` | `pagina_tus_espacios.dart` | ConsumerStatefulWidget | Hub central de propiedades del usuario | 442 | US-TUS-001 |
| 2 | `ListaEspaciosCasa`, `ClassCompraEspaciosNotifierProvider` | `provider_espacios_casa_get.dart` | AsyncNotifier | Estado reactivo de lista de espacios del usuario + fetch | 3,865 | US-TUS-001, 004 |
| 3 | `ConceptoEspacioRow`, `UbicacionEspacioRow`, `CreaFichaCapturaPropiedad` | `form_crea_ficha_captura_propiedad.dart` | StatefulWidget | Alta de propiedad (wizard lineal sin separar steps) | 4,692 | US-TUS-002 |
| 4 | `PaginaEditaEspacio`, `PaginaEditaEspacioState` | `form_update_espacio_comprado.dart` | StatefulWidget | Edición de propiedad (precargada) | 6,689 | US-TUS-004 |
| 5 | `upsertEspacioPublicadoToCouchDB` | `http_publica_propiedad.dart` | Función async | POST/PUT + manejo 409 + timestamps | 767 | US-TUS-003, 004 |
| 6 | 30+ `List<String>` const (matriz campos por tipo) | `tabla_tipopropiedad_vs_campos.dart` | Constantes | Configuración de campos visibles según tipo inmueble | 544 | US-TUS-002, 006 |
| 7 | `CompraEspacio`, `FechaDe` | `compra_espacios/data_compra_espacios.dart` | Modelo (json manual) | Documento CouchDB transferencia compra | 138 | US-TUS-005 |
| 8 | `CompraEspacioGet`, `RowCompraEspacio`, `ValueCompraEspacio` | `compra_espacios/data_compra_espacios_get.dart` | Modelo (json manual) | Vista paginada de compras | 89 | US-TUS-005 |
| 9 | `PaginaCompraEspacios`, `PaginaCompraEspaciosState` | `compra_espacios/form_compra_espacios.dart` | ConsumerStatefulWidget | UI de sub-feature "comprar espacios" | 521 | US-TUS-005 |
| 10 | `ClassCompraEspaciosNotifierProvider` | `compra_espacios/provider_compra_espacios.dart` | AsyncNotifier | Estado reactivo de compras | 675 | US-TUS-005 |

---

## Tabla 2 — Detalle por archivo

| # | Ruta relativa | Clases / Funciones | Líneas | Dependencias clave | Estado | Comentario / Deuda |
|---|---------------|--------------------|--------|---------------------|--------|--------------------|
| 1 | `pagina_tus_espacios.dart` | `PaginaTusEspacios`, `PaginaTipoEspaciosState` | 442 | `flutter`, `flutter_riverpod`, `22_imagenes/variables_imagenes`, `05_provider_menus/appbar_sliver_menu_tipo_espacio`, `05_provider_menus/provider_menu_tipo_espacio`, `app_routes`, `10_user_login/provider_session`, `10_user_login/usuario_login/dialogbox_login`, `provider_espacios_casa_get`, `form_crea_ficha_captura_propiedad`, `var_color_themes`, `var_elementos_menus`, `variables_globales`, `future_builder_state_widgets`, `var_color_widget`, `debugprint` | ✓ ok | Hub funcional. Acoplamiento con `provider_menu_tipo_espacio` para sincronizar tabs. CTA Editar abre `PaginaEditaEspacio`, CTA Crear abre `CreaFichaCapturaPropiedad` |
| 2 | `provider_espacios_casa_get.dart` | `ListaEspaciosCasa` (modelo), `ClassCompraEspaciosNotifierProvider` (AsyncNotifier con fetch + filtrado) | 3,865 | `flutter_riverpod`, `dio`, `direccionip`, `inicio/data_espacios_casas*`, `urls_endpoints_espacios`, `provider_session`, `debugprint` | ⚠ **deuda crítica** | **3,865 líneas AsyncNotifier monolítico**. `ListaEspaciosCasa` no Freezed. Refactor: split en master list, by type, by user, count, current-edit. Sin tests |
| 3 | `form_crea_ficha_captura_propiedad.dart` | `ConceptoEspacioRow`, `UbicacionEspacioRow`, `CreaFichaCapturaPropiedad`, `_CreaFichaCapturaPropiedadState` (visible 3x en grep — probablemente refactoring incompleto) | 4,692 | `flutter`, `flutter_riverpod`, `22_imagenes/*`, `12_localidades_user/*`, `14_geolocalizacion/*`, `40_security/urls_endpoints_espacios`, `provider_espacios_casa_get`, `tabla_tipopropiedad_vs_campos`, `http_publica_propiedad`, `var_color_*`, `future_builder_state_widgets`, `debugprint` | ⚠ **deuda crítica** | **4,692 líneas en 1 StatefulWidget**: wizard lineal sin separar steps. Lógica + UI + validación + persistencia. Refactor urgente a 7 StepWidgets. Testeabilidad cercana a 0 |
| 4 | `form_update_espacio_comprado.dart` | `PaginaEditaEspacio`, `PaginaEditaEspacioState` | 6,689 | `flutter`, `flutter_riverpod`, todas las deps de form_crea + provider_session + manejo de precarga | ⚠ **deuda crítica** | **ARCHIVO MÁS GRANDE DEL PROYECTO (6,689 líneas)**. Duplica masivamente form_crea + añade lógica precarga. Refactor: **WIZARD COMPARTIDO CON FORM_CREA** vía sub-widgets Steps reutilizables. Testeabilidad 0 |
| 5 | `http_publica_propiedad.dart` | `upsertEspacioPublicadoToCouchDB(tipoDeEspacio, datosPropiedadPublicar)` async + try-catch con manejo 409 | 767 | `http` (paquete barato, no dio?), `couchdb_errors`, `direccionip`, `urls_endpoints_espacios`, `debugprint`, `inicio/data_espacios_casas*` | ⚠ deuda | función fat (767 líneas). Refactor: extract funciones puras (constructPayload, validateFotoprincipal, sendPut, sendPost, handle409, syncToPublished). Notar que usa `package:http/http.dart` (no dio) — inconsistencia con resto del proyecto |
| 6 | `tabla_tipopropiedad_vs_campos.dart` | 30+ `List<String>` top-level const: `listaTiposDeTransaccion`, `otrosTiposDeInmueble`, `listaTipoInmuebles`, `nombredelapropiedadMatriz`, `inmobiliariaMatriz`, `inmobiliariaimagenMatriz`, `linkinmobiliariaMatriz`, `sloganinmobiliariaMatriz`, `ubicaciongeneralMatriz`, `descripcionMatriz`, `letreropromocionalMatriz`, `metrosdeterrenoMatriz`, `metrosconstruidosMatriz`, `recamarasMatriz`, `banosMatriz`, `mediosbanosMatriz`, `cuartosdeservicioMatriz`, `estacionamientos*Matriz`, `elementosadicionalescasaMatriz`, `precioventa*Matriz`, `preciorenta*Matriz`, `mantenimientoMatriz`, `monedaMatriz`, `niveldeprioridadMatriz` | 544 | — | ⚠ deuda | **30+ List hardcoded** define campos por tipo inmueble. Costo alto de cambio. Migrar a provider Riverpod tipado o config CouchDB. Sin A/B ni localización |
| 7 | `compra_espacios/data_compra_espacios.dart` | `CompraEspacio`, `FechaDe` | 138 | `dart:convert` | ⚠ deuda menor | Json manual, no Freezed. Documento CouchDB transferencia compra |
| 8 | `compra_espacios/data_compra_espacios_get.dart` | `CompraEspacioGet`, `RowCompraEspacio`, `ValueCompraEspacio` | 89 | `dart:convert` | ✓ ok | Vista paginada compras |
| 9 | `compra_espacios/form_compra_espacios.dart` | `PaginaCompraEspacios`, `PaginaCompraEspaciosState` | 521 | `flutter`, `flutter_riverpod`, `provider_compra_espacios`, `data_compra_espacios*`, `var_color_*`, `future_builder_state_widgets`, `debugprint` | ✓ ok | UI de sub-feature "comprar espacios". Tamaño razonable |
| 10 | `compra_espacios/provider_compra_espacios.dart` | `ClassCompraEspaciosNotifierProvider` (AsyncNotifier) | 675 | `flutter_riverpod`, `dio`, `direccionip`, `data_compra_espacios*`, `provider_session`, `debugprint` | ⚠ deuda menor | Aunque 675 líneas, contiene lógica CRUD + estado reactivo. Refactor: split CRUD vs view-state |

---

## Notas críticas

- **Módulo más pesado del proyecto** — ~17,800 líneas concentradas en 3 archivos gigantescos (`form_update_espacio_comprado.dart` 6,689, `form_crea_ficha_captura_propiedad.dart` 4,692, `provider_espacios_casa_get.dart` 3,865). Together = 15,246 líneas, ~86% del módulo.
- **Deuda crítica 1 — Wizard compartido:** `form_crea` y `form_update` son **conceptualmente el mismo wizard** con 2 modos (alta/edición). Refactor: extraer 7 `StepWidget`s (TipoInmueble, Ubicacion, Caracteristicas, Precio, Fotos, Contacto, Resumen) comunes. Reduciría ~10,000 líneas a ~3,500.
- **Deuda crítica 2 — provider_espacios_casa_get:** 3,865 líneas de AsyncNotifier contiene lógica de fetch + parseo + filtrado + estado. Split en `masterListProvider`, `localidadesFilterProvider`, `countProvider`, `currentEditProvider`.
- **Deuda crítica 3 — tabla_tipopropiedad_vs_campos:** 30+ List const hardcoded — añadir nuevo tipo inmueble o cambiar label requiere build+deploy. Migrar a config CouchDB con `FutureProvider.family` caching.
- **`http_publica_propiedad` usa `package:http`** (no `dio`), inconsistencia con resto del proyecto que usa Dio con interceptor JWT. Migrar a Dio para uniformidad + interceptor.
- **`ListaEspaciosCasa` y `CompraEspacio` no Freezed**: inconsistencia con `clase_busqueda_estado.dart` (Freezed) en inicio. Migración pendiente.
- **Sub-feature `compra_espacios/` mezclada en `tus_espacios`** — "comprar" un espacio no es "tus espacios" propiamente. Deuda arquitectura — mover a módulo `08_pantallas/transferencias/`.
- **Acoplamiento transversal esperado y documentado:**
  - `22_imagenes` (subida fotos, PaginaCarouselFotosUsuario para preview).
  - `12_localidades_user` (ubicación, validation CP).
  - `14_geolocalizacion` (LatLng capture).
  - `40_security` (urls_endpoints_espacios para DBs correctas).
  - `10_user_login/provider_session` (validación session).
  - `60_global_widgets` (state widgets, debugprint, monto).
- **Manejo 409 Conflict:** flujo documentado en `http_publica_propiedad` — try-catch + GET para refrescar `_rev`. Manejado correctamente.
- **Sin tests**: ninguno de los 10 archivos tiene test widget/unit. **El módulo de máxima criticidad del producto (captura + publicación del catálogo) tiene cero cobertura.** Top priority.
- **`menuTipoEspaciosProvider` + `provider_espacios_casa_get` sincronización:** el provider del menú configura filtros y el provider de espacios reacciona. Documentado en 05_provider_menus (deuda ya capturada allí).
- **`tabla_tipopropiedad_vs_campos.dart` matrices** referenciadas por índice numérico (`Matriz[0]`, `Matriz[1]`...) — alto riesgo de off-by-one. Refactor: usar `enum TipoInmueble { departamento, casa, terreno, ... }` + `Map<TipoInmueble, String>`.
