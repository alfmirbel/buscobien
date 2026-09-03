# Epic: Pantallas — Ubicación y Búsqueda de Localidades (08_pantallas/ubicacion)

**Directorio:** `lib\08_pantallas\ubicacion\`
**Archivos fuente:** 7 `.dart` (5 en raíz + 1 en `data_models/` [solo JSON] + 2 generados `.g.dart`/`.freezed.dart`)
**Total líneas aprox:** 1,400 (excluyendo generados y JSON)
**Fecha:** 2026-08-13
**Fuente:** Ingeniería inversa

---

## Impact Mapping

| Objetivo de Negocio | Actor | Impacto | Entregable |
|---------------------|-------|---------|------------|
| Búsqueda de propiedades por ubicación | Usuario | Busca localidades por CP (código postal) y ve resultados con datos SEPOMEX | `PaginaBuscaLocalidadGMaps`, `provider_localidades_del_cp` |
| Catálogo de localidades con mapa | Usuario | Ve lista maestra de localidades y selecciona para filtrar propiedades | `PaginaPrincipalListaLocalidades`, `screen_maestro_localidades` |
| Integración con Google Maps | Usuario | Visualiza la localidad seleccionada en mapa (GMaps) | `pagina_busca_localidades_gmaps.dart` |

---

## User Story Mapping

```
Usuario accede a "Ubicación" (sección 2 de PrincipalSliversMenuInicial)
   │
   ▼
PaginaPrincipalListaLocalidades (consumer, 483 líneas)
   ├── lista todas las localidades del usuario (provider_localidades_del_cp)
   ├── CTA "Buscar por CP" → PaginaBuscaLocalidadGMaps
   └── CTA "Ver mapa" → Google Maps embed
       │
       ▼
screen_maestro_localidades (443 líneas) — vista alternativa de lista maestra
   │
   ▼
provider_localidades_del_cp (AsyncNotifier, 109 líneas) — datos SEPOMEX por CP
```

---

## Especificación SDD / EARS

**Prefijo IDs:** `REQ-UBIC-XXX`

| ID | Tipo EARS | Requerimiento | Evidencia | Estado |
|----|-----------|---------------|-----------|--------|
| REQ-UBIC-001 | **Ubicuo** | El sistema expondrá modelos `FindLocalidadXcp`, `Doc` para tipar búsqueda por CP (Mango query). | `data_localidad_find.dart` (42 líneas) | En código |
| REQ-UBIC-002 | **Ubicuo** | El sistema expondrá `LocalidadCp` (Freezed, `data_sepomex_localidades.dart` 23 líneas) para tipar datos SEPOMEX (CP, asentamiento, municipio, estado, coords). | `data_sepomex_localidades.dart` + generados | En código |
| REQ-UBIC-003 | **Ubicuo** | El sistema expondrá `LocalidadesGet`, `RowLocalidadesGet`, `ValueLocalidadesGet` para respuesta de vista CouchDB `buscobien_localidades_por_cp`. | `data_sepomex_localidades_get_cp.dart` (89 líneas) | En código |
| REQ-UBIC-004 | **Evento** | Cuando el usuario acceda a "Ubicación", `PaginaPrincipalListaLocalidades` (483 líneas) listará sus localidades guardadas vía `ClassLocalidadesNotifierProvider` (109 líneas). | `pagina_principal_localidades.dart`, `provider_localidades_del_cp.dart` | En código |
| REQ-UBIC-005 | **Evento** | Cuando el usuario toque "Buscar por CP", `PaginaBuscaLocalidadGMaps` (347 líneas) permitirá ingresar CP y consultará SEPOMEX local (data_sepomex) y/o Google Maps Geocoding. | `pagina_busca_localidades_gmaps.dart` | En código |
| REQ-UBIC-006 | **Estado** | Mientras `screen_maestro_localidades` (443 líneas) muestre la lista maestra, el sistema permitirá seleccionar una localidad para navegar a `PaginaBuscaLocalidadGMaps` con CP preseleccionado. | `screen_maestro_localidades.dart` | En código |
| REQ-UBIC-007 | **Complejo** | Cuando el usuario seleccione una localidad en resultados, el sistema usará `data_localidad_find.FindLocalidadXcp` para Mango query contra `buscobien_propiedades` filtrando por `ubicacioncasa.cp == CP`. | `data_localidad_find.dart` | En código |
| REQ-UBIC-008 | **Ubicuo** | El sistema usará `data_sepomex_localidades` (Freezed) con CP, asentamiento, municipio, estado, latitud, longitud — datos oficiales SEPOMEX de México. | `data_sepomex_localidades.dart` (Freezed) | En código |

---

## Trazabilidad a Código

| Componente | Archivo | Líneas |
|------------|---------|--------|
| `PaginaPrincipalListaLocalidades`, `State` | `pagina_principal_localidades.dart` | 483 |
| `PaginaBuscaLocalidadGMaps`, `State` | `pagina_busca_localidades_gmaps.dart` | 347 |
| `LocalidadesListScreen`, `State` | `screen_maestro_localidades.dart` | 443 |
| `ClassLocalidadesNotifierProvider` (AsyncNotifier) | `provider_localidades_del_cp.dart` | 109 |
| `FindLocalidadXcp`, `Doc` | `data_localidad_find.dart` | 42 |
| `LocalidadCp` (Freezed) | `data_sepomex_localidades.dart` | 23 |
| (generados) `data_sepomex_localidades.freezed.dart`, `.g.dart` | — | 559 |
| `LocalidadesGet`, `RowLocalidadesGet`, `ValueLocalidadesGet` | `data_sepomex_localidades_get_cp.dart` | 89 |

---

## Deuda Técnica

1. **Dos pantallas de lista de localidades** (`PaginaPrincipalListaLocalidades` 483 + `screen_maestro_localidades` 443) con funcionalidad muy similar — probable duplicación histórica. Refactor: unificar en una.
2. **`data_sepomex_localidades.dart` (23 líneas) es Freezed** pero `data_sepomex_localidades_get_cp.dart` (89) y `data_localidad_find.dart` (42) son json manual — inconsistencia. Migrar todo a Freezed.
3. **`provider_localidades_del_cp` 109 líneas** usa `AsyncNotifier` legacy (no `@riverpod`).
4. **`pagina_busca_localidades_gmaps`** integra con Google Maps Geocoding API — verificar uso de API key segura (compile-time via `defines.json`).
5. **Sin tests** de ningún archivo.
6. **`data_models/data_sepomex_id.json`** suelto en carpeta — debería ser `asset` en `pubspec.yaml` o proveído por provider.
