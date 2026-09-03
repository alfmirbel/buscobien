# Inventario de Elementos — Pantallas: Inicio y Catálogo (08_pantallas/inicio)

**Directorio:** `lib\08_pantallas\inicio\`
**Total archivos `.dart`:** 15 (11 fuente + 4 generados `.g.dart` por build_runner)
**Epic asociado:** [`02_Epics_EARS/08_pantallas_inicio.md`](../../02_Epics_EARS/08_pantallas_inicio.md)
**Features BDD:** [`03_Features_BDD/08_pantallas_inicio/catalogo_inicio_propiedades.feature`](../../03_Features_BDD/08_pantallas_inicio/catalogo_inicio_propiedades.feature) (8 escenarios)
**User Stories:** [`04_User_Stories/08_pantallas_inicio.md`](../../04_User_Stories/08_pantallas_inicio.md) (6 US)
**Fecha:** 2026-08-13
**Fuente:** Ingeniería inversa

---

## Tabla 1 — Resumen de componentes por rol funcional

| # | Componente | Archivo | Tipo | Rol funcional | US-INI |
|---|-------------|---------|------|----------------|--------|
| 1 | `EspaciosCasa` + clases anidadas | `data_espacios_casas.dart` | Modelo (json manual) | Documento CouchDB propiedad + datos contacto + ubicación + extras | US-INI-001 |
| 2 | `EspaciosCasaGet`, `RowEspaciosCasaGet`, `ValueEspaciosCasaGet` | `data_espacios_casas_get.dart` | Modelo (json manual) | Respuesta vista paginada 10-en-10 | US-INI-001, 002 |
| 3 | `CountViewDoctos`, `RowCountViewDoctos` | `data_count_view_documentos.dart` | Modelo (json manual) | Respuesta count total | US-INI-004 |
| 4 | `VariablesViewQuery` | `data_get_valores_menus.dart` | Modelo (json manual) | Filtros activos enviados al view | US-INI-004, 005 |
| 5 | `BusquedaPaginacion`, `SearchTerm` | `clase_busqueda_estado.dart` | Modelo (Freezed) | Estado paginación + término búsqueda | US-INI-002 |
| 6 | `findPropiedades10en10` (HTTP) | `http_find_propiedades_10en10.dart` | Función + dio | HTTP GET paginado 10 props | US-INI-002, 006 |
| 7 | `viewCountFilterPropiedades` (HTTP con fallback) | `http_view_count_filter_propiedades.dart` | Función + dio | HTTP count con múltiples fallbacks | US-INI-004, 006 |
| 8 | `PaginacionBusqueda` provider (con `@riverpod`) | `inicio_propiedades_providers.dart` | Riverpod Notifier | Estado paginación + disparar queries | US-INI-002 |
| 9 | `PaginaBuscaEspacios` (UI) | `pagina_inicio_busca_espacios.dart` | ConsumerStatefulWidget | Pantalla principal del catálogo inicio | US-INI-001, 002, 004 |
| 10 | `WrapModernCardPropiedades` + `_MeGustaButton` | `widget_wrap_modern_card.dart` | StatefulWidget + sub-stateful | Renderiza tarjetas con foto+precio+ubicación+Me Gusta | US-INI-001, 003 |
| 11 | Catálogo otras características | `catalogo_otras_caracteristicas.dart` | Constantes | Filtros avanzados (habitaciones, baños, etc) | US-INI-005 |
| 12 | (generado) `http_find_propiedades_10en10.g.dart` | — | build_runner | Serialización anotada | — |
| 13 | (generado) `http_view_count_filter_propiedades.g.dart` | — | build_runner | Serialización anotada | — |
| 14 | (generado) `inicio_propiedades_providers.g.dart` | — | build_runner | Provider boilerplate generado | — |
| 15 | (generado) `clase_busqueda_estado.g.dart` | — | build_runner | Freezed+json boilerplate | — |

---

## Tabla 2 — Detalle por archivo fuente (excluye `.g.dart` generados)

| # | Archivo | Clases / Funciones | Líneas | Dependencias clave | Estado | Comentario / Deuda |
|---|---------|--------------------|--------|---------------------|--------|--------------------|
| 1 | `data_espacios_casas.dart` | `EspaciosCasa`, `Datosadicionalescasa`, `Datosdelcontactocasa`, `Fechadecasa`, `Ubicacioncasa` (+ métodos fromJson/toJson) | 393 | `dart:convert` | ⚠ deuda | **No usa Freezed**: json_serializable manual. 5 clases en 1 archivo — campo de refactor importante. Inconsistencia con `clase_busqueda_estado.dart` que sí usa Freezed |
| 2 | `data_espacios_casas_get.dart` | `EspaciosCasaGet`, `RowEspaciosCasaGet`, `ValueEspaciosCasaGet` | 90 | `data_espacios_casas.dart`, `dart:convert` | ✓ ok | Modelo vista paginada. Consumido por `WrapModernCardPropiedades` |
| 3 | `data_count_view_documentos.dart` | `CountViewDoctos`, `RowCountViewDoctos` | 50 | `dart:convert` | ✓ ok | Respuesta CouchDB view count. Muy compacto |
| 4 | `data_get_valores_menus.dart` | `VariablesViewQuery` | 14 | — | ✓ ok | Modelo pequeño para filtros. Revisar si debe ser Freezed también |
| 5 | `clase_busqueda_estado.dart` | `BusquedaPaginacion` (Freezed), `SearchTerm` (Freezed) | 20 | `freezed`, `json_serializable` | ✓ ok | Único archivo Freezed de 08_pantallas/inicio. Genera `.g.dart` correspondiente |
| 6 | `http_find_propiedades_10en10.dart` | `findPropiedades10en10(params)` | 149 | `dio`, `direccionip` (`40_security`), `provider_session` (`10_user_login`), `data_espacios_casas_get`, `debugprint` | ✓ ok | HTTP con skip/limit y filtros en params. Genera `.g.dart` por anotaciones |
| 7 | `http_view_count_filter_propiedades.dart` | `viewCountFilterPropiedades(params)`, múltiples fallbacks | 502 | `dio`, `direccionip`, `provider_session`, `data_count_view_documentos`, `data_get_valores_menus`, `urls_endpoints_espacios` (`40_security`), `debugprint` | ⚠ deuda | **502 líneas**: lógica fallback manual extensa. Refactor: `EndpointResolver` con lista ordenada. Genera `.g.dart` |
| 8 | `inicio_propiedades_providers.dart` | `PaginacionBusqueda` (Notifier con `@riverpod`) | 212 | `flutter_riverpod`, `riverpod_annotation`, `clase_busqueda_estado`, `http_find_propiedades_10en10`, `http_view_count_filter_propiedades` | ✓ ok | Provider con anotación → genera `.g.dart`. Estado reactivo para paginación |
| 9 | `pagina_inicio_busca_espacios.dart` | `PaginaBuscaEspacios`, `_PaginaBuscaEspaciosState` | 515 | `flutter`, `flutter_riverpod`, `Symbols`, `var_color_themes`, `var_color_widget`, `var_elementos_menus`, `inicio_propiedades_providers`, `widget_wrap_modern_card`, `60_global_widgets` (state widgets, debugprint, monto), `future_builder_state_widgets` | ⚠ deuda | 515 líneas. `postFrameCallback` no valida providers de menú sin inicializar — puede resultar en catálogo vacío (REQ-INI-008 deuda) |
| 10 | `widget_wrap_modern_card.dart` | `WrapModernCardPropiedades`, `_MeGustaButton`, `_MeGustaButtonState` | 639 | `flutter`, `flutter_riverpod`, `Symbols`, `var_color_themes`, `var_color_widget`, `provider_me_gusta` (`03_listas`), `22_imagenes` (PaginaCarouselFotosMini), `genera_cantidad_monetaria` (`60_global_widgets`), `widget_letrero_tipo_transaccion` (`08_pantallas/widgets_comunes`), `future_builder_state_widgets` | ⚠ deuda | **639 líneas**: monolito. Refactor: extraer `_MeGustaButton` a `60_global_widgets`, separar card-body de wrap-container |
| 11 | `catalogo_otras_caracteristicas.dart` | (constantes) | 83 | — | ✓ ok | Estático (no configurable). Deuda: mover a provider Riverpod para hotter-reload |

---

## Notas críticas

- **3 roles en archivos distintos cumplen convención** (data/, providers/, pages/ no se aplica — todos mezclados en raíz `inicio/`). Refactor futuro a subcarpetas.
- **`.g.dart` conviven con fuente** (4 archivos generados): patrón Freezed/json_serializable. `dart run build_runner build --delete-conflicting-outputs` los regenera.
- **Sólo `clase_busqueda_estado.dart` usa Freezed**: inconsistencia con el resto de modelos del módulo (`data_espacios_casas.dart` y otros son json manuales). Migración pendiente para uniformidad y seguridad de tipos.
- **`WrapModernCardPropiedades` 639 líneas + `PaginaBuscaEspacios` 515 líneas + `http_view_count_filter_propiedades.dart` 502 líneas** = 3 archivos pesados. Refactor prioritario para mantenibilidad.
- **Acoplamiento con 03_listas**: `WrapModernCardPropiedades` importa `provider_me_gusta.dart` desde `03_listas/` para el toggle Me Gusta. Acoplamiento transversal esperado (colaboración entre módulos), documentado.
- **Acoplamiento con 22_imagenes**: `PaginaCarouselFotosMini` se usa para miniatura. Acoplamiento fino esperado.
- **Acoplamiento con `08_pantallas/widgets_comunes`**: `widget_letrero_tipo_transaccion.dart` se usa para el badge de tipo transacción en cada card. Revisa hito `08_pantallas/widgets_comunes` aparte.
- **`postFrameCallback` sin validación de providers** en `PaginaBuscaEspacios`: si los providers de menú no están inicializados, el catálogo puede quedar vacío (REQ-INI-008 — deuda). Fix: validar y configurar defaults.
- **Paginación manual sin `infinite_scroll_pagination` package**: riesgo de race conditions en scroll rápido. Deuda técnica documentada.
- **`catalogo_otras_caracteristicas.dart` estático**: opciones hardcodeadas. Para añadir nuevas opciones se necesita build+deploy.
- **Sin tests**: ninguno de los 11 archivos fuente tiene widget/provider test. Smoke global cubre arranque pero no el catálogo.
