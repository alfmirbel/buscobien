# Epic: Pantallas — Inicio y Catálogo de Propiedades (08_pantallas/inicio)

**Directorio:** `lib\08_pantallas\inicio\`
**Archivos fuente:** 11 `.dart` (4 adicionales `.g.dart` generados por build_runner) — **Total: 15**
**Subdirectorio padre:** [`02_Epics_EARS/02_principal_screen.md`](02_Epics_EARS/02_principal_screen.md)
**Fecha:** 2026-08-13
**Fuente:** Ingeniería inversa

---

## Impact Mapping

| Objetivo de Negocio | Actor | Impacto | Entregable |
|---------------------|-------|---------|------------|
| Mostrar propiedades destacadas en inicio | Usuario final | Ve catálogo paginado 10-en-10 con búsqueda por estado/CP, wrap de tarjetas y "Me Gusta" | `PaginaBuscaEspacios` + `WrapModernCardPropiedades` + providers |
| | Sistema | HTTPs a CouchDB via Node.js API, bulk fetch con mango queries y count del total | `http_find_propiedades_10en10`, `http_view_count_filter_propiedades` |

---

## User Story Mapping

```
Usuario entra a Inicio (sección 0 de principal_screen)
       │
       ▼
PaginaBuscaEspacios (ConsumerStateful)
   ├── build(): WrapModernCardPropiedades (cards)
   └── postFrame: providers config
       │
       ▼
inicioPropiedadesProviders (PaginacionBusqueda)
   - findPropiedadesEstadosde10en10Provider (FutureProvider.family)
   - viewCountFilterPropiedadesProvider
       │
       ▼
HTTP via API Node.js → CouchDB
   - find by estado/CP (skip limit)
   - count docs view
```

---

## Especificación SDD / EARS

**Prefijo IDs:** `REQ-INI-XXX`

| ID | Tipo EARS | Requerimiento | Evidencia | Estado |
|----|-----------|---------------|-----------|--------|
| REQ-INI-001 | **Ubicuo** | El sistema expondrá modelos `EspaciosCasa` (393 líneas, 6 clases), `EspaciosCasaGet`, `CountViewDoctos`, `VariablesViewQuery`, `BusquedaPaginacion`, `SearchTerm` para tipar propiedades y consultas. | `data_espacios_casas.dart`, `data_espacios_casas_get.dart`, `data_count_view_documentos.dart`, `data_get_valores_menus.dart`, `clase_busqueda_estado.dart` | En código |
| REQ-INI-002 | **Evento** | Cuando el usuario abra `PaginaBuscaEspacios`, el sistema leerá providers de menú (tipoEspacio, nivelGobierno, etc.) y consultará `findPropiedadesEstadosde10en10Provider` con paginación `paramSkip=0, limit=10`. | `pagina_inicio_busca_espacios.dart:1-100` | En código |
| REQ-INI-003 | **Estado** | Mientras el usuario hace scroll en las cards de inicio, el sistema cargará más propiedades (10-en-10) vía `PaginacionBusqueda.increment()` que actualiza `skip`. | `inicio_propiedades_providers.dart` `PaginacionBusqueda` | En código |
| REQ-INI-004 | **Evento** | Cuando el usuario toque "Me Gusta" en una card de propiedad, `WrapModernCardPropiedades` invocará `MeGustaNotifier.toggleMeGusta` con optimistic update local. | `widget_wrap_modern_card.dart`: `_MeGustaButton` | En código |
| REQ-INI-005 | **Ubicuo** | El sistema expondrá `WrapModernCardPropiedades` (StatefulWidget, 639 líneas) que renderiza `Wrap` de cards con: imagen miniatura, precio, ubicación, tipo transacción letrero (`widget_letrero_tipo_transaccion.dart`). | `widget_wrap_modern_card.dart` (ámbito inicio) | En código |
| REQ-INI-006 | **Complejo** | Mientras el catálogo de inicio requiera filtros avanzados (otras características: habitaciones, baños, antigüedad, estacionamiento), el sistema usará `catalogo_otras_caracteristicas.dart` que expone un mapa de opciones. | `catalogo_otras_caracteristicas.dart` (83 líneas) | En código |
| REQ-INI-007 | **Evento** | Cuando la respuesta HTTP falle (timeout/500), el sistema proveerá endpoints fallback en `http_view_count_filter_propiedades.dart` para mantener catálogo visible. | `http_view_count_filter_propiedades.dart` (502 líneas) | En código |
| REQ-INI-008 | **No Deseado** | Si los providers de menú están sin inicializar al abrir PaginaBuscaEspacios, el sistema hará una query con filtros undefined — vacío en catálogo. | `postFrameCallback` actual no valida | Deuda técnica |

---

## Trazabilidad a Código

| Componente | Archivo | Líneas |
|------------|---------|--------|
| `PaginaBuscaEspacios` (UI principal) | `pagina_inicio_busca_espacios.dart` | 515 |
| `WrapModernCardPropiedades` + `_MeGustaButton` | `widget_wrap_modern_card.dart` | 639 |
| `PaginacionBusqueda` provider (con `@riverpod`) | `inicio_propiedades_providers.dart` | 212 |
| `findPropiedades10en10` HTTP | `http_find_propiedades_10en10.dart` | 149 |
| `viewCountFilterPropiedades` HTTP (con fallback) | `http_view_count_filter_propiedades.dart` | 502 |
| Modelos: `EspaciosCasa`, `Fechadecasa`, `Ubicacioncasa`, `Datosadicionalescasa`, `Datosdelcontactocasa` | `data_espacios_casas.dart` | 393 |
| `EspaciosCasaGet`, `RowEspaciosCasaGet`, `ValueEspaciosCasaGet` | `data_espacios_casas_get.dart` | 90 |
| `CountViewDoctos`, `RowCountViewDoctos` | `data_count_view_documentos.dart` | 50 |
| `BusquedaPaginacion`, `SearchTerm` (Freezed) | `clase_busqueda_estado.dart` | 20 |
| `VariablesViewQuery` | `data_get_valores_menus.dart` | 14 |
| Catálogo otras características | `catalogo_otras_caracteristicas.dart` | 83 |

---

## Deuda Técnica

1. **Generados `.g.dart` mezclados con fuente**: 4 archivos `.g.dart` viven junto a los `.dart` — alineado con la convención Freezed/json_serializable pero `build_runner` los regenera en cada cambio modelo.
2. **`WrapModernCardPropiedades` 639 líneas**: monolito, contiene también `_MeGustaButton` (StatefulWidget anidado). Refactor pendiente.
3. **`http_view_count_filter_propiedades.dart` 502 líneas**: lógica HTTP extensa con fallbacks manuales. Debería migrar a un cliente Dio genérico con interceptor.
4. **No usa Freezed** para `EspaciosCasa` (modelo manual json_serializable clásico). Inconsistencia con otros modelos del proyecto.
5. **Sin tests**: 11 archivos fuente sin widget/provider tests.
