# User Stories — Pantallas: Ubicación y Búsqueda de Localidades (08_pantallas/ubicacion)

**Directorio:** `lib\08_pantallas\ubicacion\` (7 archivos `.dart` fuente + 2 generados + 1 JSON en `data_models/`)
**Epic asociado:** [`02_Epics_EARS/08_pantallas_ubicacion.md`](../02_Epics_EARS/08_pantallas_ubicacion.md)
**Feature BDD:** [`03_Features_BDD/08_pantallas_ubicacion/ubicacion_busqueda_localidades.feature`](../03_Features_BDD/08_pantallas_ubicacion/ubicacion_busqueda_localidades.feature) (8 escenarios)
**Inventario:** [`05_Tareas_Inventarios/08_pantallas_ubicacion/elementos_08_pantallas_ubicacion.md`](../05_Tareas_Inventarios/08_pantallas_ubicacion/elementos_08_pantallas_ubicacion.md)
**Fecha:** 2026-08-13
**Fuente:** Ingeniería inversa

---

## US-UBIC-001: Ver hub de mis localidades guardadas

### Card
**Como** usuario
**Quiero** ver una lista de mis localidades guardadas con CP, asentamiento y municipio
**Para** acceder rápidamente a buscar propiedades en cada zona.

### Conversation
- `PaginaPrincipalListaLocalidades` (`pagina_principal_localidades.dart`, 483 líneas, ConsumerStatefulWidget) es la pantalla raíz de "Ubicación" (sección 2).
- `ClassLocalidadesNotifierProvider` (`provider_localidades_del_cp.dart`, 109 líneas, AsyncNotifier) lista localidades del usuario (probablemente desde `buscobien_localidades_usuario` o vista CouchDB `buscobien_localidades_por_cp`).
- Cada fila muestra: CP, asentamiento, municipio, estado, coords (lat/lng).
- CTAs por fila: **"Ver en mapa"** (navega a `PaginaBuscaLocalidadGMaps` con CP preseleccionado) y **"Buscar propiedades"** (filtra catálogo por ese CP).
- **Comentario:** hay una pantalla duplicada `screen_maestro_localidades` (443 líneas) con funcionalidad muy similar — probable duplicación histórica. Ver US-UBIC-003.

### Confirmation
- ✓ Al abrir Ubicación, lista las localidades del usuario con datos SEPOMEX completos.
- ✓ Cada fila tiene CTAs "Ver en mapa" y "Buscar propiedades".
- ✓ Feature BDD: escenario "Hub de localidades del usuario".

**Trazabilidad:** `REQ-UBIC-004` · Archivos: `pagina_principal_localidades.dart`, `provider_localidades_del_cp.dart`

---

## US-UBIC-002: Buscar localidades por código postal y visualizar en Google Maps

### Card
**Como** usuario que quiere explorar una zona por CP
**Quiero** ingresar un código postal de 5 dígitos y ver los asentamientos correspondientes en Google Maps
**Para** identificar la ubicación exacta antes de buscar propiedades.

### Conversation
- `PaginaBuscaLocalidadGMaps` (`pagina_busca_localidades_gmaps.dart`, 347 líneas, ConsumerStatefulWidget) recibe CP vía parámetro o permite ingresarlo.
- `TextFormField` para CP con validación estricta: regex `^[0-9]{5}$` (México).
- Al buscar:
  1. Consulta local `data_sepomex_localidades` (Freezed) — datos oficiales SEPOMEX de México con CP, asentamiento, municipio, estado, lat, lng.
  2. Si CP no existe en datos locales, **fallback a Google Maps Geocoding API** (requiere API key en `defines.json` compile-time).
  3. Resultados: lista de asentamientos con coords.
- Seleccionar un asentamiento: navega a la misma pantalla con CP preseleccionado y muestra mapa centrado.
- **Comentario crítico de seguridad:** la API key de Google Maps debe inyectarse via `--dart-define-from-file=defines.json` (ver `14_geolocalizacion/app_keys.dart`). No hardcodeada.

### Confirmation
- ✓ Ingreso CP válido (5 dígitos) → retorna asentamientos con coords.
- ✓ Ingreso CP inválido → error "CP inválido: debe ser 5 dígitos".
- ✓ CP no en SEPOMEX → fallback a Google Maps Geocoding.
- ✓ Tocar "Ver en Google Maps" abre URL con coords correctas.
- ✓ Feature BDD: escenarios "Búsqueda por CP", "Selección de localidad", "CP inválido", "Localidad sin datos SEPOMEX", "Integración con Google Maps".

**Trazabilidad:** `REQ-UBIC-005`, `REQ-UBIC-007`, `REQ-UBIC-008` · Archivos: `pagina_busca_localidades_gmaps.dart`, `data_sepomex_localidades.dart`

---

## US-UBIC-003: Vista alternativa maestra de localidades (duplicación histórica)

### Card
**Como** arquitecto del sistema
**Quiero** documentar que `screen_maestro_localidades` (443 líneas) es duplicación histórica de `PaginaPrincipalListaLocalidades`
**Para** que el equipo planifique la unificación en un solo hub.

### Conversation
- `LocalidadesListScreen` (`screen_maestro_localidades.dart`, 443 líneas, ConsumerStatefulWidget) muestra lista maestra de localidades SEPOMEX (probablemente todas, no filtradas por usuario).
- Permite búsqueda por nombre/asentamiento en la lista completa.
- Al seleccionar, navega a búsqueda de propiedades con CP preseleccionado (misma acción que US-UBIC-001 "Buscar propiedades").
- **Análisis de duplicación:**
  - `PaginaPrincipalListaLocalidades`: lista localidades DEL USUARIO (guardadas) + CTAs mapa/buscar.
  - `screen_maestro_localidades`: lista TODAS las localidades SEPOMEX + búsqueda por nombre + misma navegación.
- **Refactor propuesto:** unificar en un solo widget `LocalidadesHub` con dos modos (usuario / maestra) y búsqueda unificada. Eliminar uno de los dos archivos (ahorro ~400 líneas netas).

### Confirmation
- ✓ `screen_maestro_localidades` renderiza lista maestra completa.
- ✓ Búsqueda por nombre filtra la lista maestra.
- ✓ Selección navega a búsqueda propiedades con CP.
- ✓ Documentado como deuda de duplicación histórica.

**Trazabilidad:** `REQ-UBIC-006` · Archivos: `screen_maestro_localidades.dart`, `pagina_principal_localidades.dart`

---

## US-UBIC-004: Filtrar catálogo de propiedades por CP seleccionado

### Card
**Como** usuario que seleccionó una localidad
**Quiero** que el catálogo de propiedades se filtre automáticamente por ese código postal
**Para** ver solo propiedades en esa zona.

### Conversation
- Desde `PaginaPrincipalListaLocalidades` o `screen_maestro_localidades`, al tocar "Buscar propiedades en esta zona":
  1. `data_localidad_find.FindLocalidadXcp` construye Mango query: `{"selector": {"ubicacioncasa.cp": CP}}`.
  2. Dispara `findPropiedadesEstadosde10en10Provider` (de `08_pantallas/inicio`) con el filtro CP.
  3. Navega a `PaginaBuscaEspacios` (inicio) con el filtro activo.
- El usuario ve el catálogo filtrado y puede limpiar el filtro desde la UI de inicio.
- **Comentario:** el puente entre `ubicacion` y `inicio` es vía provider global `codigoPostalBusquedaProvider` (ver `03_vistas/pagina_usuarios.dart`) — acoplamiento transversal documentado.

### Confirmation
- ✓ Al tocar "Buscar propiedades", el catálogo de inicio muestra solo propiedades del CP seleccionado.
- ✓ El filtro CP aparece activo en la UI de inicio (chip o indicador).
- ✓ Limpiar filtro restaura el catálogo completo.
- ✓ Feature BDD: escenario "Filtro de propiedades por CP seleccionado".

**Trazabilidad:** `REQ-UBIC-007` · Archivos: `data_localidad_find.dart`, interacciona con `08_pantallas/inicio/inicio_propiedades_providers.dart`

---

## Resumen matriz

| US | Epic Req | Escenarios BDD | Archivos principales |
|----|----------|----------------|----------------------|
| US-UBIC-001 (hub localidades usuario) | REQ-UBIC-004 | 1 | `pagina_principal_localidades.dart`, `provider_localidades_del_cp.dart` |
| US-UBIC-002 (buscar CP + Google Maps) | REQ-UBIC-005, 007, 008 | 4 | `pagina_busca_localidades_gmaps.dart`, `data_sepomex_localidades.dart` |
| US-UBIC-003 (vista maestra duplicada) | REQ-UBIC-006 | 1 | `screen_maestro_localidades.dart`, `pagina_principal_localidades.dart` |
| US-UBIC-004 (filtrar catálogo por CP) | REQ-UBIC-007 | 1 | `data_localidad_find.dart`, interacciona con `08_pantallas/inicio` |

---

## Notas de deuda técnica

1. **Duplicación `screen_maestro_localidades` vs `pagina_principal_localidades`** — unificar en `LocalidadesHub` con modos usuario/maestra.
2. **Inconsistencia Freezed/json manual**: `data_sepomex_localidades.dart` Freezed; `data_sepomex_localidades_get_cp.dart` y `data_localidad_find.dart` json manual. Migrar a Freezed.
3. **Provider legacy**: `ClassLocalidadesNotifierProvider` usa `AsyncNotifier` sin `@riverpod`.
4. **Google Maps API key**: debe inyectarse via `--dart-define-from-file=defines.json` — confirmar que no está hardcodeada en `pagina_busca_localidades_gmaps.dart`.
5. **`data_models/data_sepomex_id.json`** suelto — debería ser asset o provisto por provider.
6. **Sin tests** de ninguno de los 7 archivos fuente.
7. **Acoplamiento transversal**: `ubicacion` → `inicio` (catálogo filtrado) y `03_vistas/pagina_usuarios.dart` (códigoPostalBusquedaProvider).
