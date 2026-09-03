# User Stories — Pantallas: Tus Espacios (Captura y Publicación) (08_pantallas/tu_cuenta/tus_espacios)

**Directorio:** `lib\08_pantallas\tu_cuenta\tus_espacios\` (10 archivos `.dart`, ~17,000 líneas totales)
**Epic asociado:** [`02_Epics_EARS/08_pantallas_tu_cuenta_tus_espacios.md`](../02_Epics_EARS/08_pantallas_tu_cuenta_tus_espacios.md)
**Feature BDD:** [`03_Features_BDD/08_pantallas_tu_cuenta_tus_espacios/tus_espacios_captura_publicacion.feature`](../03_Features_BDD/08_pantallas_tu_cuenta_tus_espacios/tus_espacios_captura_publicacion.feature) (10 escenarios)
**Inventario:** [`05_Tareas_Inventarios/08_pantallas_tu_cuenta_tus_espacios/elementos_08_pantallas_tu_cuenta_tus_espacios.md`](../05_Tareas_Inventarios/08_pantallas_tu_cuenta_tus_espacios/elementos_08_pantallas_tu_cuenta_tus_espacios.md)
**Fecha:** 2026-08-13
**Fuente:** Ingeniería inversa

> **Advertencia de criticidad:** contiene los 2 archivos más grandes del proyecto (`form_update_espacio_comprado.dart` 6,689 líneas y `form_crea_ficha_captura_propiedad.dart` 4,692 líneas) y el AsyncNotifier más pesado (`provider_espacios_casa_get.dart` 3,865 líneas). Refactor urgente.

---

## US-TUS-001: Ver hub central de "Tus Espacios" (mis propiedades)

### Card
**Como** promotor/propietario
**Quiero** un hub que liste todas mis propiedades capturadas y publicadas
**Para** verlas, editarlas, publicarlas o eliminarlas en un mismo lugar.

### Conversation
- `PaginaTusEspacios` (`pagina_tus_espacios.dart`, 442 líneas, ConsumerStatefulWidget con `TickerProviderStateMixin`) es la pantalla raíz de "Tu Cuenta > Tus Espacios".
- `initState` dispara `postFrameCallback` que inicializa `menuTipoEspaciosProvider` con el `TickerProvider` y el `menuTipoEspaciosProvider.notifier` (instancia el `TabController` con 5 categorías: Normales, Destacados, Superdestacados, Oportunidades, Remates).
- `provider_espacios_casa_get.ClassCompraEspaciosNotifierProvider` (AsyncNotifier, 3,865 líneas) lista `EspaciosCasa[]` filtrado por `idUsuario == currentUser` y `tipoEspacio` activo.
- Cada tarjeta muestra foto principal (vía `22_imagenes` mini), precio, ubicación y estado (Pendiente publicación / Publicada / Vendida).
- CTAs por propiedad: **Editar**, **Eliminar**, **Publicar** (si está pendiente).
- CTA global "Crear nueva ficha de captura" → US-TUS-002.
- CTA "Comprar espacios" → US-TUS-005 (sub-feature `compra_espacios/`).
- **Comentario crítico de deuda:** `provider_espacios_casa_get` 3,865 líneas es enorme; contiene lógica de fetch, parseo, filtrado y estado. Refactor: split en N providers (master list, filtered by type, count, etc).

### Confirmation
- ✓ Al abrir "Tus Espacios"列表 las propiedades del usuario, filtradas por el tab activo.
- ✓ Cambiar de tab (Destacados / Oportunidades) refiltera las propiedades reactivamente.
- ✓ CTAs Editar y Eliminar están disponibles por tarjeta.
- ✓ CTA "Crear nueva ficha" siempre visible.
- ✓ Feature BDD: escenarios "Hub central", "Filtrar por tipo".

**Trazabilidad:** `REQ-ESP-001`, `REQ-ESP-002`, `REQ-ESP-007` · Archivos: `pagina_tus_espacios.dart`, `provider_espacios_casa_get.dart`

---

## US-TUS-002: Crear ficha de captura (alta de propiedad) usando wizard con campos por tipo inmueble

### Card
**Como** promotor
**Quiero** un formulario de alta con todos los campos, ajustados dinámicamente al tipo de inmueble (departamento, casa, terreno, etc)
**Para** capturar mi propiedad correctamente y publicarla al catálogo.

### Conversation
- `CreaFichaCapturaPropiedad` (`form_crea_ficha_captura_propiedad.dart`, 4,692 líneas, StatefulWidget) es el formulario extenso de alta.
- Secciones (implícitamente un wizard lineal sin separar en widgets Steps):
  1. **Tipo de inmueble** + **Tipo de transacción** (venta/renta).
  2. **Ubicación**: estado, municipio, calle, CP, entre calles — values derivados de `tabla_tipopropiedad_vs_campos.dart` matrices (`ubicaciongeneralMatriz`).
  3. **Características**: recámaras, baños, medios baños, metros de terreno, metros construidos, estacionamientos, edad, elementos adicionales.
  4. **Precio**: venta/renta, moneda, mantenimiento, prioridad.
  5. **Fotos**: subida múltiple (vía `22_imagenes/pagina_agrega_multiples_fotos` o handler interno).
  6. **Contacto**: teléfono, email, nombre de contacto.
- `tabla_tipopropiedad_vs_campos.dart` (544 líneas) define ~30 `List<String>` const (matrices por atributo). Las listas indexan por tipo inmueble, ej. `recamarasMatriz[0]` aplica a "Departamento", `recamarasMatriz[2]` podría ser vacío para "Terreno". Los campos no aplicables se ocultan en runtime.
- `ConceptoEspacioRow` y `UbicacionEspacioRow` son clases anidadas para organizar sub-rows del formulario (concepto = descripción; ubicación = dirección + coords geográficas).
- **Comentario crítico de deuda extrema:** 4,692 líneas en un único StatefulWidget. Lógica de validación + UI + persistencia + estado en un solo archivo. Testeabilidad cercana a cero. Refactor urgente a wizard con 7 `StepWidget`s separados — cada uno con test propio.

### Confirmation
- ✓ Al tocar "Crear ficha", el formulario abre con campos dinámicos según tipo inmueble.
- ✓ No se muestran campos que no aplican a ese tipo (ej. `recamaras` oculto en Terreno).
- ✓ El campo "Departamento" requiere recámaras, baños, metros construidos (mínimos validados).
- ✓ "Terreno" oculta recámaras y requiere metros de terreno como principal.
- ✓ La subida de fotos embebe el flujo `22_imagenes`.
- ✓ Feature BDD: escenario "Crear ficha de captura", "Tabla matriz de campos por tipo inmueble".

**Trazabilidad:** `REQ-ESP-003`, `REQ-ESP-005` · Archivos: `form_crea_ficha_captura_propiedad.dart`, `tabla_tipopropiedad_vs_campos.dart`

---

## US-TUS-003: Publicar propiedad a CouchDB vía API con manejo 409

### Card
**Como** promotor
**Quiero** que al submitir la ficha, la app persista en CouchDB con validación de fotoprincipal y timestamps correctos
**Para** que la propiedad quede visible en el catálogo.

### Conversation
- `upsertEspacioPublicadoToCouchDB(tipoDeEspacio, datosPropiedadPublicar)` (`http_publica_propiedad.dart`, 767 líneas) construye el payload:
  - `_id = fotoprincipal` si ya existe (update), o nuevo UUID si es alta.
  - `tipodeanuncio`: el tipo de transacción (venta/renta).
  - `fechadepublicacioncasa.dia/mes/anio`: actualizado al `DateTime.now()`.
  - Validación previa: `fotoprincipal` no puede estar vacío (debe tener foto marcada → US-IMG-007).
- Hace HTTP PUT/POST a Node.js API, quien lo enruta a la DB CouchDB correcta según `tipoDeEspacio`:
  - `buscobien_casas_comprados_normales` para tipo "Normales" — captura (borrador).
  - `buscobien_casas_comprados_destacados` para "Destacados", etc (5 categorías × DBs `endpointsCaptura` de `40_security`).
  - Para **publicar** (visible en catálogo): copia a la DB publicados correspondiente (`buscobien_propiedades_publicados_*`), vía el OperationType `Upsert` (el nombre "EspacioPUBLICADO" sugiere que es publicación desde captura).
- **Manejo 409 Conflict:** si dos sesiones editan el mismo `_id` en paralelo, el `_rev` enviado queda viejo y CouchDB responde 409. El `try-catch` lo captura y muestra SnackBar "Conflicto, recarga", junto con un nuevo GET para refrescar el `_rev`.
- **Comentario:** la función está en un solo archivo de 767 líneas — debería separarse en N funciones puras (constructPayload, validatePayload, sendPut, sendPost, handle409, syncToPublished). Deuda de multicapa.

### Confirmation
- ✓ Al submitir con fotoprincipal válida, el payload se construye correctamente y POSTea a la DB correspondiente.
- ✓ Sin fotoprincipal → SnackBar "Debes marcar una foto principal antes de publicar" y no se publica.
- ✓ Tras POST exitoso, la propiedad aparece en "Tus Espacios" reactivamente (provider refresca).
- ✓ Tras POST 409, SnackBar + GET para refrescar `_rev`.
- ✓ Feature BDD: escenarios "Submit exitoso", "Conflicto 409", "Validación fotoprincipal".

**Trazabilidad:** `REQ-ESP-006` · Archivos: `http_publica_propiedad.dart`, interacciona con `40_security/urls_endpoints_espacios.dart`, `provider_espacios_casa_get.dart`

---

## US-TUS-004: Editar ficha existente precargada

### Card
**Como** promotor que necesita actualizar precios, fotos o detalles de una propiedad ya capturada
**Quiero** un formulario de edición con todos los campos precargados desde CouchDB
**Para** corregir y republicar sin recapturar todo.

### Conversation
- `PaginaEditaEspacio` (`form_update_espacio_comprado.dart`, 6,689 líneas) es el formulario de edición — el **archivo más grande del proyecto**.
- En `initState`, fetcha el doc `EspaciosCasa` por `_id` (vía `provider_espacios_casa_get`) y precarga todos los `TextEditingController` / `StatefulWidget` state con valores existentes.
- El wizard es idéntico a US-TUS-002 pero en modo edición (los campos activos dependen del tipo de inmueble original).
- Tras submit, `upsertEspacioPublicadoToCouchDB` con el `_rev` actual; refleja cambios. Si el doc ya estaba publicado, también actualiza la DB publicados (sincronía via el mismo upsert).
- `PaginaEditaEspacioState` mantiene state local (no ref watch) para evitar rebuild cascada mientras el usuario escribe.
- **Comentario crítico de deuda extrema:** 6,689 líneas — probablemente duplicación masiva de la lógica de alta (`form_crea_ficha`) además de lógica adicional de precarga. Debería compartir componentes con el wizard de alta. Refactor urgente y crítico.

### Confirmation
- ✓ Al tocar "Editar", el formulario abre con todos los campos precargados del doc CouchDB.
- ✓ Modificar un campo y submitir lo persiste correctamente.
- ✓ El `_rev` se usa para evitar pisar cambios de otros editores concurrentes.
- ✓ Feature BDD: escenarios "Editar propiedad", "Submit exitoso", "Conflicto 409".

**Trazabilidad:** `REQ-ESP-004`, `REQ-ESP-006` · Archivos: `form_update_espacio_comprado.dart`, `http_publica_propiedad.dart`, `provider_espacios_casa_get.dart`

---

## US-TUS-005: Comprar un espacio / adquirir propiedad de mercado secundario

### Card
**Como** usuario interesado en una propiedad publicada por otro
**Quiero** un flujo de "comprar espacio" que me transfiera la propiedad a "Tus Espacios"
**Para** gestionarla como mía (editar, republicar, o dar de baja).

### Conversation
- Subcarpeta `compra_espacios/` (4 archivos, ~1,423 líneas total):
  - `data_compra_espacios.dart` (138) — modelo `CompraEspacio` + `FechaDe` (doc CouchDB de transferencia).
  - `data_compra_espacios_get.dart` (89) — modelo `CompraEspacioGet` + `RowCompraEspacio` + `ValueCompraEspacio` (vista paginada).
  - `form_compra_espacios.dart` (521) — UI `PaginaCompraEspacios` para listar y comprar.
  - `provider_compra_espacios.dart` (675) — `ClassCompraEspaciosNotifierProvider` (AsyncNotifier).
- Flujo: el usuario abre `PaginaCompraEspacios`, ve una lista de propiedades publicadas por otros, y al tap "Comprar":
  1. Crea un doc en `buscobien_compras_espacios` (probablemente) con `{ idUsuarioComprador, idPropiedad, idUsuarioVendedor, fechaCompra, timestamp }`.
  2. La propiedad aparece en su lista `provider_espacios_casa_get` con rol actualizado (comprador).
- **Comentario:** la "compra" no es una transacción financiera real — es una transferencia administrativa para que el comprador gestione. Deuda de producto: si el vendedor vende elRIGHT real de la propiedad, esto requiere acuerdo externo. Documentado.

### Confirmation
- ✓ Al abrir "Comprar espacios", el usuario ve propiedades disponibles.
- ✓ Al tap "Comprar", se crea el doc de transferencia y la propiedad aparece en "Tus Espacios" del comprador.
- ✓ El vendedor original ve que la propiedad fue transferida (probablemente con badge).
- ✓ Feature BDD: escenario "Sub-feature CompraEspacios".

**Trazabilidad:** `REQ-ESP-008` · Archivos: `compra_espacios/data_*.dart`, `form_compra_espacios.dart`, `provider_compra_espacios.dart`

---

## US-TUS-006: Configuración hardcoded de campos por tipo inmueble (deuda)

### Card
**Como** arquitecto del sistema
**Quiero** documentar que `tabla_tipopropiedad_vs_campos.dart` (30+ `List<String>` const hardcoded) define los campos por tipo inmueble
**Para** que el equipo sepa que es deuda incapaz de cambio runtime y planifique migración.

### Conversation
- `tabla_tipopropiedad_vs_campos.dart` (544 líneas) define ~30 `List<String>` const, cada una describe un atributo (recamaras, banos, precioventa, etc) indexado por tipo inmueble:
  - `recamarasMatriz[0] = "Recámaras"`, `[1] = "Habitaciones"`, `[2] = ""` (no aplica a Terreno), etc.
  - `metrosdeterrenoMatriz`, `metrosconstruidosMatriz`, `precioventaMatriz`, `preciorentaMatriz`, `monedaMatriz`, `niveldeprioridadMatriz`, etc.
  - `inmobiliariaMatriz`, `inmobiliariaimagenMatriz`, `linkinmobiliariaMatriz`, `sloganinmobiliariaMatriz` para branding del promotor.
- **Mantenibilidad:** cualquier cambio (añadir nuevo tipo inmueble, cambiar label, habilitar campo nuevo) requiere build+deploy completo. No A/B ni localización.
- **Refactor propuesto:**
  1. Quick: Migrar a provider Riverpod tipado, con fallback a archivo ini.
  2. Limpio: Persistir en CouchDB (doc `config:campos_tipoinmueble`) y cachear local via `FutureProvider.family`.
- Comparación con `var_elementos_menus` en `20_var_globales` — similar deuda hardcoded.

### Confirmation
- ✓ El código actual define 30+ `List<String>` const para configuración UI de campos por tipo.
- ✓ Documentado como deuda crítica de mantenibilidad.
- ✓ Planean migración a provider/config external.

**Trazabilidad:** `REQ-ESP-005`, `REQ-ESP-010` · Archivos: `tabla_tipopropiedad_vs_campos.dart`

---

## Resumen matriz

| US | Epic Req | Escenarios BDD | Archivos principales | Líneas |
|----|----------|----------------|----------------------|--------|
| US-TUS-001 (hub) | REQ-ESP-001, 002, 007 | 2 | `pagina_tus_espacios.dart`, `provider_espacios_casa_get.dart` | 442 + 3865 |
| US-TUS-002 (alta) | REQ-ESP-003, 005 | 2 | `form_crea_ficha_captura_propiedad.dart`, `tabla_tipopropiedad_vs_campos.dart` | 4,692 + 544 |
| US-TUS-003 (publicar) | REQ-ESP-006 | 3 | `http_publica_propiedad.dart` | 767 |
| US-TUS-004 (editar) | REQ-ESP-004, 006 | 2 | `form_update_espacio_comprado.dart` | 6,689 |
| US-TUS-005 (comprar) | REQ-ESP-008 | 1 | `compra_espacios/` (4 archivos) | ~1,423 |
| US-TUS-006 (deuda config) | REQ-ESP-005, 010 | 1 | `tabla_tipopropiedad_vs_campos.dart` | 544 |

---

## Notas de deuda técnica (priorizadas)

1. **`form_update_espacio_comprado.dart` 6,689 líneas** — **más grande del proyecto**. Refactorcrítico: extraer en wizard con 7 StepWidgets y compartirlos con US-TUS-002.
2. **`form_crea_ficha_captura_propiedad.dart` 4,692 líneas** — refactor al mismo wizard compartido con US-TUS-004.
3. **`provider_espacios_casa_get.dart` 3,865 líneas** — AsyncNotifier monolítico. Split en master-list, filtered-by-type, count, current-edit, etc.
4. **`tabla_tipopropiedad_vs_campos.dart` hardcoded**: 30+ List const. Migrar a provider o config external.
5. **No usa Freezed** para `ListaEspaciosCasa`, `CompraEspacio`. Inconsistencia con el resto.
6. **`http_publica_propiedad.dart` 767 líneas** — función fat. Refactor a funciones puras (constructPayload, validate, sendPut, handle409, syncToPublished).
7. **Sub-feature `compra_espacios/` mezclada en `tus_espacios`** — debería vivir en módulo de transferencias / mercado secundario. Deuda arquitectura.
8. **Sin tests** — módulo de máxima criticidad (captura + publicación del catálogo) sin cobertura widget/unit. Refactor urgente prioritario.
9. **Acoplamiento transversal:** `22_imagenes` (subida fotos), `12_localidades_user` (ubicación), `14_geolocalizacion` (coords), `40_security` (endpoints/espacios), `60_global_widgets` (state, debugprint, monto). Documentado.
10. **`menuTipoEspaciosProvider` TabController sincronizado bidireccional** — también aplicable aquí (deuda ya documentada en `05_provider_menus`).
