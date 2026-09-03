# User Stories — Pantallas: Inicio y Catálogo (08_pantallas/inicio)

**Directorio:** `lib\08_pantallas\inicio\` (15 archivos: 11 fuente + 4 generados `.g.dart`)
**Epic asociado:** [`02_Epics_EARS/08_pantallas_inicio.md`](../02_Epics_EARS/08_pantallas_inicio.md)
**Feature BDD:** [`03_Features_BDD/08_pantallas_inicio/catalogo_inicio_propiedades.feature`](../03_Features_BDD/08_pantallas_inicio/catalogo_inicio_propiedades.feature) (8 escenarios)
**Inventario:** [`05_Tareas_Inventarios/08_pantallas_inicio/elementos_08_pantallas_inicio.md`](../05_Tareas_Inventarios/08_pantallas_inicio/elementos_08_pantallas_inicio.md)
**Fecha:** 2026-08-13
**Fuente:** Ingeniería inversa

---

## US-INI-001: Ver catálogo paginado de propiedades destacadas en Inicio

### Card
**Como** usuario que entra al Inicio
**Quiero** ver un catálogo de propiedades destacadas con tarjetas M3 responsivas
**Para** explorar las opciones más relevantes del momento.

### Conversation
- `PaginaBuscaEspacios` (`pagina_inicio_busca_espacios.dart`, 515 líneas, ConsumerStatefulWidget) es la pantalla raíz de la sección Inicio en `PrincipalSliversMenuInicial`.
- En `postFrameCallback`: lee los providers de menú (`tipoEspacioProvider`, `nivelGobiernoProvider`, `tipoTransaccionProvider`) y dispara `findPropiedadesEstadosde10en10Provider.familia(skip:0, limit:10)`.
- `WrapModernCardPropiedades` (`widget_wrap_modern_card.dart`, 639 líneas, StatefulWidget) recibe `EspaciosCasaGet.rows[]` y construye un `Wrap` de tarjetas (responsivo: 1/2/3 columnas según breakpoints de `var_color_widget`).
- Cada tarjeta muestra:
  - Miniatura: usa `PaginaCarouselFotosMini` de `22_imagenes` (si la propiedad tiene fotos).
  - Precio: formateado (`generaCantidad`/`formatoCantidad` de `60_global_widgets` para mock; formato real para datos de API).
  - Ubicación: `ubicacioncasa.estado`, `ubicacioncasa.municipio`.
  - Tipo transacción: `widget_letrero_tipo_transaccion.dart` (de `widgets_comunes`) — un badge colored.
- `FutureBuilderStateWidgets` (`60_global_widgets`) maneja los 3 estados: loading spinner M3, error+retry, none (lista vacía).
- **Comentario crítico:** `WrapModernCardPropiedades` es **639 líneas** — contiene lógica de presentación + sub-stateful `_MeGustaButton` anidado. Refactor pendiente.

### Confirmation
- ✓ Al abrir Inicio, las 10 primeras propiedades se renderizan en cards M3 responsivas.
- ✓ Cada card muestra fotos miniatura, precio, ubicación y letrero de transacción.
- ✓ States vacío y error se muestran correctamente con `stateNone`/`stateErrorFS`.
- ✓ Feature BDD: escenario "Primera carga del catálogo con filtros por defecto".

**Trazabilidad:** `REQ-INI-002`, `REQ-INI-005` · Archivos: `pagina_inicio_busca_espacios.dart`, `widget_wrap_modern_card.dart`

---

## US-INI-002: Paginar propiedades 10-en-10 con scroll infinito

### Card
**Como** usuario que explora un catálogo grande
**Quiero** scroll infinito que cargue 10 propiedades adicionales cada vez
**Para** seguir descubriendo sin tener que tocar "siguiente página".

### Conversation
- `PaginacionBusqueda` (`inicio_propiedades_providers.dart`, 212 líneas, anotado con `@riverpod` via build_runner) modela el estado de paginación: `skip`, `limit=10`, `totalDocs`.
- `SearchTerm` y `BusquedaPaginacion` (Freezed) son los modelos de estado.
- `findPropiedadesEstadosde10en10Provider` es `FutureProvider.family<EspaciosCasaGet, ({int skip, ...filtros})>`.
- Al llegar al final del `Wrap` (detectado via `ScrollController.position.maxScrollExtent`), `PaginacionBusqueda.increment()` aumenta `skip += 10` y reevalúa la family con nuevos parámetros — las cards se añaden en lugar de reemplazar.
- `viewCountFilterPropiedadesProvider` (HTTP) consulta el count total en CouchDB (`data_count_view_documentos.dart` parsea `CountViewDoctos.rows[0].value`) — la UI muestra "Mostrando 10 de Y".
- **Comentario crítico de deuda:** la paginación manual (`ScrollController` + `increment`) **no usa `infinite_scroll_pagination` package** — riesgo de race conditions al hacer scroll rápido (peticiones se solapan, invalidación de respuestas antiguas). Deuda técnica.

### Confirmation
- ✓ Al hacer scroll al fondo del Wrap, las siguientes 10 propiedades aparecen al final.
- ✓ El contador "Mostrando X de Y" se actualiza conforme carga.
- ✓ Si skip > totalDocs, no se hacen más peticiones.
- ✓ Feature BDD: escenario "Paginación incremental con scroll".

**Trazabilidad:** `REQ-INI-001`, `REQ-INI-003` · Archivos: `inicio_propiedades_providers.dart`, `http_find_propiedades_10en10.dart`, `clase_busqueda_estado.dart`

---

## US-INI-003: Toggle Me Gusta en tarjeta de propiedad con optimistic update

### Card
**Como** usuario
**Quiero** un botón "Me Gusta" (corazón)en cada tarjeta de propiedad
**Para** marcar mis preferidas rápidamente mientras exploro el catálogo.

### Conversation
- `_MeGustaButton` (`widget_wrap_modern_card.dart`, StatefulWidget anidado) renderiza un `IconButton` con `Symbols.favorite` (outline) o `Symbols.favorite` (filled) según estado.
- Al tap, invoca `ref.read(meGustaProvider.notifier).toggleMeGusta(propertyId)` que:
  1. **Optimistic update local:** el corazón cambia visualmente al instante.
  2. **POST/DELETE** a `buscobien_megusta_propiedades` con `_id = SHA1(userId+propertyId)`.
  3. Si el POST falla, el corazón vuelve a su estado previo (rollback).
- **Side effect documentado en US-LIST-006 (03_listas):** el primer Me Gusta del usuario auto-crea la lista "Favoritas" y la propiedad queda dentro.
- Acoplamiento: el widget `_MeGustaButton` vive **dentro de `WrapModernCardPropiedades`** — 639 líneas mezclando card + button. Refactor pendiente.

### Confirmation
- ✓ Al tap del corazón, el ícono cambia visualmente de outline → filled.
- ✓ Si el POST falla (timeout/500), el corazón revierte al estado previo.
- ✓ Me Gusta repetido en la misma propiedad quita el me-gusta (idempotente).
- ✓ Feature BDD: escenario "Toggle Me Gusta en card de propiedad".

**Trazabilidad:** `REQ-INI-004` · Archivos: `widget_wrap_modern_card.dart` (con `provider_me_gusta.dart` en `03_listas/`)

---

## US-INI-004: Ver contador de propiedades totales con filtros activos

### Card
**Como** usuario
**Quiero** ver "Mostrando X de Y propiedades" mientras aplico filtros
**Para** entender el alcance de mi búsqueda y ajustarla si es muy limitada.

### Conversation
- `viewCountFilterPropiedadesProvider` (`http_view_count_filter_propiedades.dart`, 502 líneas) construye una Mango query de `count` sobre la vista CouchDB relevante (`data_count_view_documentos.dart` parsea el resultado).
- `CountViewDoctos` y `RowCountViewDoctos` modelos JSON manuales (no Freezed) modelan la respuesta.
- UI: `"Mostrando ${rows.length} de ${viewCount}"` junto al paginador. Si `viewCount == 0`, se muestra el estado `stateNone` con CTA "Limpiar filtros".
- `VariablesViewQuery` (`data_get_valores_menus.dart`) encapsula los filtros activos enviados al view CouchDB.
- **Comentario crítico:** el archivo `http_view_count_filter_propiedades.dart` (502 líneas) tiene **lógica fallback extensa** para múltiples endpoints — sostenido por el riesgo de que un endpoint principal esté caído. Deuda: encapsular en un cliente Dio genérico con interceptor de retry.

### Confirmation
- ✓ El contador aparece junto al paginado mostrando "Mostrando X de Y propiedades".
- ✓ Cambiar filtros (tipoEspacio, tipoTransaccion, etc) actualiza el count en la siguiente query.
- ✓ Si el count es 0, se muestra "Sin resultados" con CTA "Limpiar filtros".
- ✓ Feature BDD: escenario "Contador de documentos totales (view count)".

**Trazabilidad:** `REQ-INI-007` · Archivos: `http_view_count_filter_propiedades.dart`, `data_count_view_documentos.dart`, `data_get_valores_menus.dart`

---

## US-INI-005: Aplicar filtros avanzados del catálogo "Otras características"

### Card
**Como** usuario con preferencias específicas
**Quiero** filtrar por número de habitaciones, baños, antigüedad, estacionamiento
**Para** encontrar propiedades que cumplan mis criterios exactos.

### Conversation
- `catalogo_otras_caracteristicas.dart` (83 líneas) expone un listado de características adicionales (probablemente un mapa ` característica → valor` o similar) que alimentan los checkboxes del panel avanzado.
- El panel avanzado es invocado desde el UI de filtros del `PaginaBuscaEspacios` (visible arriba del `Wrap`).
- Al confirmar, los checkboxes elegidos se añaden al payload HTTP del `findPropiedades10en10` y `viewCountFilter`.
- Mango queries en CouchDB soportan operadores `$gte`, `$lte` para rangos (ej. `habitaciones: {$gte: 3}`).
- **Comentario crítico:** el catálogo es un archivo estático de opciones — no dinámico configurable. Deuda: si varían los campos frecuentemente, debería ser un provider Riverpod o venir de configuración CouchDB.

### Confirmation
- ✓ Al expandir "Otras características", aparecen todas las opciones documentadas en el catálogo.
- ✓ Al marcar (ej. "3+ habitaciones", "Estacionamiento") y confirmar, la query HTTP los incluye y la UI refresca.
- ✓ El catálogo de características es consistente entre sesiones (no cambia durante una sesión).
- ✓ Feature BDD: escenario "Catálogo con catálogo de características (otras)".

**Trazabilidad:** `REQ-INI-006` · Archivos: `catalogo_otras_caracteristicas.dart`

---

## US-INI-006: Recuperación de catálogo tras falla HTTP con endpoints fallback

### Card
**Como** usuario durante una falla parcial de la API
**Quiero** que el catálogo use un endpoint alternativo automáticamente
**Para** seguir viendo propiedades aunque el endpoint principal esté caído.

### Conversation
- `http_view_count_filter_propiedades.dart` (502 líneas) y `http_find_propiedades_10en10.dart` intentan primero el endpoint principal (con los filtros activos).
- Si falla (timeout ≥ N segundos, 500, 503), reintentan con un fallback configurado (probablemente derivado del cross-reference `endpointsCaptura`/`endpointsPublicados` de `40_security`).
- `FutureBuilderStateWidgets.stateErrorFS(error)` muestra el error si todos los fallbacks fallan, con botón Reintentar que reinicia el provider.
- **Comentario crítico:** el mecanismo fallback es **manual** (if-else de Dio.try/catch) — difficult de mantener cuando agregue nuevos endpoints. Refactor: usar un "EndpointResolver" que itere sobre una lista ordenada de endpoints y devuelva el primero exitoso.

### Confirmation
- ✓ Si el endpoint principal hace timeout, el catálogo se recarga desde un fallback.
- ✓ Si todos los fallbacks fallan, se muestra un error claro + botón reintentar.
- ✓ La UI no crashirea si el backend no responde.
- ✓ Feature BDD: escenario "Error HTTP con endpoints fallback".

**Trazabilidad:** `REQ-INI-007` · Archivos: `http_view_count_filter_propiedades.dart`, `http_find_propiedades_10en10.dart`

---

## Resumen matriz

| US | Epic Req | Escenarios BDD | Archivos principales |
|----|----------|----------------|----------------------|
| US-INI-001 (catálogo tarjetas) | REQ-INI-002, 005 | 1 | `pagina_inicio_busca_espacios.dart`, `widget_wrap_modern_card.dart` |
| US-INI-002 (paginación 10-en-10) | REQ-INI-001, 003 | 1 | `inicio_propiedades_providers.dart`, `http_find_propiedades_10en10.dart` |
| US-INI-003 (Me Gusta en card) | REQ-INI-004 | 1 | `widget_wrap_modern_card.dart` |
| US-INI-004 (contador total) | REQ-INI-007 | 1 | `http_view_count_filter_propiedades.dart`, `data_count_view_documentos.dart` |
| US-INI-005 (filtro otras características) | REQ-INI-006 | 1 | `catalogo_otras_caracteristicas.dart` |
| US-INI-006 (fallback HTTP) | REQ-INI-007 | 1 | `http_view_count_filter_propiedades.dart`, `http_find_propiedades_10en10.dart` |

---

## Notas de deuda técnica

1. **`WrapModernCardPropiedades` 639 líneas**: monolito card + `_MeGustaButton` sub-stateful. Refactor: extraer `_MeGustaButton` a `60_global_widgets/me_gusta_button.dart` reutilizable.
2. **`http_view_count_filter_propiedades.dart` 502 líneas**: lógica fallback extensa manual → refactor a `EndpointResolver` con lista.
3. **`EspaciosCasa` no usa Freezed**: modelo manual json_serializable. Inconsistencia con `BusquedaPaginacion` que sí es Freezed.
4. **Paginación manual**: sin `infinite_scroll_pagination` package → riesgo de race conditions.
5. **`catalogo_otras_caracteristicas.dart` estático**: configurable sólo con edición de código.
6. **`.g.dart` mezclados con fuente**: 4 archivos generated conviven con 11 fuente. Convención aceptada.
7. **Sin tests**.
