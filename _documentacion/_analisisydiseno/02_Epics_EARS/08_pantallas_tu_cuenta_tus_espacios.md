# Epic: Pantallas — Tus Espacios (Captura y Publicación de Propiedades) (08_pantallas/tu_cuenta/tus_espacios)

**Directorio:** `lib\08_pantallas\tu_cuenta\tus_espacios\`
**Archivos fuente:** 10 `.dart` (6 en raíz + 4 en `compra_espacios/`)
**Total líneas aprox:** ~17,000 — el formulario `form_update_espacio_comprado.dart` tiene 6,689 líneas y `form_crea_ficha_captura_propiedad.dart` 4,692 líneas; el provider `provider_espacios_casa_get.dart` 3,865 líneas. **Modular de mayor deuda técnica del proyecto.**
**Fecha:** 2026-08-13
**Fuente:** Ingeniería inversa

---

## Impact Mapping

| Objetivo de Negocio | Actor | Impacto | Entregable |
|---------------------|-------|---------|------------|
| Promotores capturan y publican propiedades | Promotor / Propietario | Hub central (`PaginaTusEspacios`) de sus propiedades + alta (`CreaFichaCapturaPropiedad` 4,692 líneas) + edición (`PaginaEditaEspacio` 6,689 líneas) | 3 formularios gigantes |
| | Sistema | PUT/POST a CouchDB via Node.js API con tipos de espacio (5 categorías), publicación selectiva | `http_publica_propiedad.dart` (767 líneas) + provider AsyncNotifier de espacios |
| Datos config por tipo inmueble | Sistema (código) | Tabla matriz de campos por tipo (departamento, casa, terreno, etc) — describe qué campos aplican a cada inmueble | `tabla_tipopropiedad_vs_campos.dart` (544 líneas, 30+ `List<String>` const) |
| Sub-feature "comprar/ocurrir un espacio" | Promotor | CRUD `CompraEspacio` (compra ya publicada por otro) | `compra_espacios/` subcarpeta (4 archivos) |

---

## User Story Mapping

```
Sección "Tu Cuenta > Tus Espacios" de PrincipalSliversMenuInicial
   │
   ▼
PaginaTusEspacios (ConsumerStatefulWidget)
   ├── postFrame: inicializa menuTipoEspaciosProvider
   ├── lista EspaciosCasa (provider_espacios_casa_get)
   └── CTAs:
       ├── Alta → CreaFichaCapturaPropiedad (form_crea_ficha, 4692 líneas)
       │      ├── tipos inmueble (tabla matriz)
       │      ├── fotos, ubicación, características, contacto
       │      └── Submit → http_publica_propiedad.upsert
       ├── Editar → PaginaEditaEspacio (form_update_espacio_comprado, 6689)
       └── Comprar/Transferir → compra_espacios/ subcarpeta
```

---

## Especificación SDD / EARS

**Prefijo IDs:** `REQ-ESP-XXX`

| ID | Tipo EARS | Requerimiento | Evidencia | Estado |
|----|-----------|---------------|-----------|--------|
| REQ-ESP-001 | **Ubicuo** | El sistema expondrá `PaginaTusEspacios` (ConsumerStatefulWidget, 442 líneas) como hub de "Tus Espacios" (propiedades capturadas por el usuario) — lista con CTAs de alta, edición, compra. | `pagina_tus_espacios.dart:1-442` | En código |
| REQ-ESP-002 | **Estado** | Mientras el usuario esté en `PaginaTusEspacios`, el sistema mantendrá el estado reactivo de su lista de propiedades vía `provider_espacios_casa_get.ClassCompraEspaciosNotifierProvider` (3,865 líneas AsyncNotifier) — filtra `idUsuario == currentUser` y aplica tipoEspacio/nivel. | `provider_espacios_casa_get.dart` | En código |
| REQ-ESP-003 | **Evento** | Cuando el usuario toque CTA "Crear ficha de captura", el sistema navegará a `CreaFichaCapturaPropiedad` (4,692 líneas) — formulario extenso con todos los campos de una propiedad: tipo inmueble, ubicación, características, fotos, contacto, precio. | `form_crea_ficha_captura_propiedad.dart` | En código |
| REQ-ESP-004 | **Evento** | Cuando el usuario toque CTA "Editar" en una de sus propiedades, el sistema navegará a `PaginaEditaEspacio` (6,689 líneas) — mismo formulario precargado para editar y volver a publicar. | `form_update_espacio_comprado.dart` | En código |
| REQ-ESP-005 | **Ubicuo** | El sistema expondrá `tabla_tipopropiedad_vs_campos.dart` (544 líneas) con 30+ `List<String>` const que describen qué campos aplican a cada tipo de inmueble: recamaras, banos, metrosdeterreno, precioventa, descripción, ubicaciongeneral, etc. | `tabla_tipopropiedad_vs_campos.dart` | En código |
| REQ-ESP-006 | **Evento** | Cuando el usuario submita alta/edición, el sistema invocará `upsertEspacioPublicadoToCouchDB(tipoDeEspacio, datosPropiedadPublicar)` (767 líneas) que POST/PUT a CouchDB (vía Node.js API) con validaciones (fotoprincipal, fechas, endpoint correcto por tipo). | `http_publica_propiedad.dart` | En código |
| REQ-ESP-007 | **Ubicuo** | El sistema expondrá `ListaEspaciosCasa` modelo de estado para `ClassCompraEspaciosNotifierProvider` (no usa Freezed, json serializable dentro del provider). | `provider_espacios_casa_get.dart.ListaEspaciosCasa` | En código |
| REQ-ESP-008 | **Complejo** | Mientras el usuario gestione "compra" de espacios (subcarpeta `compra_espacios/`), el sistema manejará 4 archivos: `data_compra_espacios.dart` (138), `data_compra_espacios_get.dart` (89), `form_compra_espacios.dart` (521), `provider_compra_espacios.dart` (675). | `compra_espacios/` (4 archivos) | En código |
| REQ-ESP-009 | **No Deseado** | Si `form_crea/form_update` mantienen 4,692/6,689 líneas con lógica business y UI en mismo archivo (sin split en steps/wizards), el sistema será **difícil de mantener y testear**. | `form_*.dart` | Deuda técnica crítica |
| REQ-ESP-010 | **No Deseado** | Si `tabla_tipopropiedad_vs_campos.dart` (30+ `List<String>` const) está hardcoded, será **caro** añadir/modificar tipos de inmueble o renombrar campos, sin posibilidad de configuración runtime o A/B. | `tabla_tipopropiedad_vs_campos.dart` | Deuda técnica |

---

## Trazabilidad a Código

| Componente | Archivo | Líneas |
|------------|---------|--------|
| `PaginaTusEspacios`, `PaginaTipoEspaciosState` | `pagina_tus_espacios.dart` | 442 |
| `ConceptoEspacioRow`, `UbicacionEspacioRow`, `CreaFichaCapturaPropiedad` (Stateful) | `form_crea_ficha_captura_propiedad.dart` | 4,692 |
| `PaginaEditaEspacio`, `PaginaEditaEspacioState` | `form_update_espacio_comprado.dart` | 6,689 |
| `upsertEspacioPublicadoToCouchDB` | `http_publica_propiedad.dart` | 767 |
| `ListaEspaciosCasa`, `ClassCompraEspaciosNotifierProvider` (AsyncNotifier) | `provider_espacios_casa_get.dart` | 3,865 |
| 30+ `List<String>` const (matriz campos por tipo) | `tabla_tipopropiedad_vs_campos.dart` | 544 |
| `CompraEspacio`, `FechaDe` | `compra_espacios/data_compra_espacios.dart` | 138 |
| `CompraEspacioGet`, `RowCompraEspacio`, `ValueCompraEspacio` | `compra_espacios/data_compra_espacios_get.dart` | 89 |
| `PaginaCompraEspacios`, `PaginaCompraEspaciosState` | `compra_espacios/form_compra_espacios.dart` | 521 |
| `ClassCompraEspaciosNotifierProvider` | `compra_espacios/provider_compra_espacios.dart` | 675 |

---

## Deuda Técnica Crítica

1. **`form_update_espacio_comprado.dart` 6,689 líneas**: probablemente el archivo más pesado del proyecto. Lógica de negocio + UI + validación en un mismo widget Stateful. Refactor urgente a wizard con 5-7 pasos (`TipoInmuebleStep`, `UbicacionStep`, `CaracteristicasStep`, `FotosStep`, `ContactoStep`, `PrecioStep`, `ResumenStep`).
2. **`form_crea_ficha_captura_propiedad.dart` 4,692 líneas**: similar al anterior — refactor a wizard con steps reutilizables.
3. **`provider_espacios_casa_get.dart` 3,865 líneas**: AsyncNotifier gigante. Debería separarse en N providers (list, filtered list, by type, by nivel, etc.), no en uno con 50 campos.
4. **`tabla_tipopropiedad_vs_campos.dart` hardcoded**: config sin runtime/A/B. Deuda de producto - migrar a provider Riverpod o config CouchDB.
5. **No usa Freezed** para `ListaEspaciosCasa` y `CompraEspacio` — inconsistencia con el resto del proyecto.
6. **`http_publica_propiedad.dart` 767 líneas**: función fat con PUT, POST, manejo 409 conflict, timestamp updates — refactor a N funciones puras.
7. **Sin tests** de ningún archivo. Tested sólo por smoke global — módulo de máxima criticidad sin cobertura.
8. **Acoplamiento transversal**: 22_imagenes (subida fotos), 12_localidades_user (ubicación), 14_geolocalizacion (coords), 40_security (endpoints/espacios), 0_progressive widgets (state, debugprint). Esperado y documentable.
9. **Sub-feature `compra_espacios/` mezclada en mismo módulo** — el "comprar" un espacio no es "tus espacios" propiamente; debería vivir en una sección separada (transferencias / mercado secundario) — deuda de arquitectura.
