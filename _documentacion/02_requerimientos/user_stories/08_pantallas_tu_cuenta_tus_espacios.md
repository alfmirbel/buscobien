# User Stories — Pantallas: Tus Espacios (Captura y Publicación) (08_pantallas/tu_cuenta/tus_espacios)

**Directorio:** `lib\08_pantallas\tu_cuenta\tus_espacios\` (10 archivos `.dart`, ~17,000 líneas totales)
**Epic asociado:** [`02_requerimientos/epics_ears/08_pantallas_tu_cuenta_tus_espacios.md`](../epics_ears/08_pantallas_tu_cuenta_tus_espacios.md)
**Feature BDD:** [`03_analisis_funcional/features_analisis/tus_espacios_captura_publicacion.feature`](../../03_analisis_funcional/features_analisis/08_pantallas_tu_cuenta_tus_espacios/tus_espacios_captura_publicacion.feature) (10 escenarios)
**Inventario:** [`05_desarrollo_y_especificaciones_tecnicas/inventario_elementos/elementos_08_pantallas_tu_cuenta_tus_espacios.md`]()
**Fecha:** 2026-08-13
**Fuente:** Ingeniería inversa

> **Advertencia de criticidad:** tras MEJ-14/15 los formularios ya no superan 800 líneas (`form_update_espacio_comprado.dart` 666, `ficha_propiedad_card.dart` 722 más sus dos archivos `part`); el AsyncNotifier más pesado es `provider_espacios_casa_get.dart` (1.127 líneas).

---

## US-TUS-001: Ver hub central de "Tus Espacios" (mis propiedades)

### Card
**Como** promotor/propietario
**Quiero** un hub que liste todas mis propiedades capturadas y publicadas
**Para** verlas, editarlas, publicarlas o eliminarlas en un mismo lugar.

### Conversation
- `PaginaTusEspacios` (`pagina_tus_espacios.dart`, 438 líneas, ConsumerStatefulWidget con `TickerProviderStateMixin`) es la pantalla raíz de "Tu Cuenta > Tus Espacios".
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

## US-TUS-002: Alta de propiedad (compra de espacios) y ficha de captura por tipo de inmueble

> **Nota de exactitud:** Revisión de código 2026-10-07: `FichaPropiedadCard` es la **tarjeta (ficha) de cada propiedad** en la lista de «Tus Espacios» (se instancia en `pagina_tus_espacios.dart` con `context`, índice, datos y callback); **no es un formulario de alta** y no contiene campos de captura. Las propiedades se crean al **comprar espacios** (`compra_espacios/`), que genera los documentos con `idPropiedad` y `clavedelapropiedad`, y se capturan después con el `Stepper` de `PaginaEditaEspacio`.

### Card
**Como** promotor
**Quiero** un formulario de alta con todos los campos, ajustados dinámicamente al tipo de inmueble (departamento, casa, terreno, etc)
**Para** capturar mi propiedad correctamente y publicarla al catálogo.

### Conversation
- `FichaPropiedadCard` (`ficha_propiedad_card.dart`, 722 líneas) es la tarjeta de cada propiedad; los campos por tipo de inmueble se capturan en el `Stepper` de `PaginaEditaEspacio`.
- Secciones (implícitamente un wizard lineal sin separar en widgets Steps):
  1. **Tipo de inmueble** + **Tipo de transacción** (venta/renta).
  2. **Ubicación**: estado, municipio, calle, CP, entre calles — values derivados de `tabla_tipopropiedad_vs_campos.dart` matrices (`ubicaciongeneralMatriz`).
  3. **Características**: recámaras, baños, medios baños, metros de terreno, metros construidos, estacionamientos, edad, elementos adicionales.
  4. **Precio**: venta/renta, moneda, mantenimiento, prioridad.
  5. **Fotos**: subida múltiple (vía `22_imagenes/pagina_agrega_multiples_fotos` o handler interno).
  6. **Contacto**: teléfono, email, nombre de contacto.
- `tabla_tipopropiedad_vs_campos.dart` (544 líneas) define ~30 `List<String>` const (matrices por atributo). Las listas indexan por tipo inmueble, ej. `recamarasMatriz[0]` aplica a "Departamento", `recamarasMatriz[2]` podría ser vacío para "Terreno". Los campos no aplicables se ocultan en runtime.
- `ConceptoEspacioRow` y `UbicacionEspacioRow` son clases anidadas para organizar sub-rows del formulario (concepto = descripción; ubicación = dirección + coords geográficas).
- **Deuda reducida (MEJ-15):** la tarjeta pasó de 1.510 a 722 líneas con diálogos y filas en archivos `part of`. Sigue pendiente extraer la lógica de publicación a un servicio y probarla.

### Confirmation
- ✓ Al tocar "Crear ficha", el formulario abre con campos dinámicos según tipo inmueble.
- ✓ No se muestran campos que no aplican a ese tipo (ej. `recamaras` oculto en Terreno).
- ✓ El campo "Departamento" requiere recámaras, baños, metros construidos (mínimos validados).
- ✓ "Terreno" oculta recámaras y requiere metros de terreno como principal.
- ✓ La subida de fotos embebe el flujo `22_imagenes`.
- ✓ Feature BDD: escenario "Crear ficha de captura", "Tabla matriz de campos por tipo inmueble".

**Trazabilidad:** `REQ-ESP-003`, `REQ-ESP-005` · Archivos: `ficha_propiedad_card.dart`, `tabla_tipopropiedad_vs_campos.dart`

---

## US-TUS-003: Publicar propiedad a CouchDB vía API con manejo 409

### Card
**Como** promotor
**Quiero** que al submitir la ficha, la app persista en CouchDB con validación de fotoprincipal y timestamps correctos
**Para** que la propiedad quede visible en el catálogo.

### Conversation
- `upsertEspacioPublicadoToCouchDB(tipoDeEspacio, datosPropiedadPublicar)` (`http_publica_propiedad.dart`, 456 líneas) construye el payload:
  - `_id = fotoprincipal` si ya existe (update), o nuevo UUID si es alta.
  - `tipodeanuncio`: el tipo de transacción (venta/renta).
  - `fechadepublicacioncasa.dia/mes/anio`: actualizado al `DateTime.now()`.
  - Validación previa: `fotoprincipal` no puede estar vacío (debe tener foto marcada → US-IMG-007).
- Hace HTTP PUT/POST a Node.js API, quien lo enruta a la DB CouchDB correcta según `tipoDeEspacio`:
  - `buscobien_casas_comprados_normal` para tipo "Normales" — captura (borrador).
  - `buscobien_casas_comprados_destacado` para "Destacados", etc (5 categorías × DBs `endpointsCaptura` de `40_security`).
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
- `PaginaEditaEspacio` (`form_update_espacio_comprado.dart`, 666 líneas) es el formulario de edición — el **archivo más grande del proyecto**.
- En `initState`, fetcha el doc `EspaciosCasa` por `_id` (vía `provider_espacios_casa_get`) y precarga todos los `TextEditingController` / `StatefulWidget` state con valores existentes.
- El wizard es idéntico a US-TUS-002 pero en modo edición (los campos activos dependen del tipo de inmueble original).
- Tras submit, `upsertEspacioPublicadoToCouchDB` con el `_rev` actual; refleja cambios. Si el doc ya estaba publicado, también actualiza la DB publicados (sincronía via el mismo upsert).
- `PaginaEditaEspacioState` mantiene state local (no ref watch) para evitar rebuild cascada mientras el usuario escribe.
- **Deuda reducida (MEJ-14):** 666 líneas (antes 6.689 → 2.175). Campos declarativos con validación por tipo (`CampoTexto`/`Validadores`); solo `nombredelapropiedad` es obligatorio para no bloquear registros antiguos.

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

## Notas de deuda técnica (priorizadas)

1. **`form_update_espacio_comprado.dart` 666 líneas** — refactor hecho en MEJ-14 (campos declarativos); quedan pruebas de widget por paso.
2. **`ficha_propiedad_card.dart` 722 líneas** — dividido en MEJ-15; queda mover publicar/despublicar a un servicio.
3. **`provider_espacios_casa_get.dart` 3,865 líneas** — AsyncNotifier monolítico. Split en master-list, filtered-by-type, count, current-edit, etc.
4. **`tabla_tipopropiedad_vs_campos.dart` hardcoded**: 30+ List const. Migrar a provider o config external.
6. **`http_publica_propiedad.dart` 456 líneas** — función fat. Refactor a funciones puras (constructPayload, validate, sendPut, handle409, syncToPublished).
8. **Sin tests** — módulo de máxima criticidad (captura + publicación del catálogo) sin cobertura widget/unit. Refactor urgente prioritario.
10. **`menuTipoEspaciosProvider` TabController sincronizado bidireccional** — también aplicable aquí (deuda ya documentada en `05_provider_menus`).

---

> Las demás notas de deuda técnica están en la Epic del módulo (`../epics_ears/08_pantallas_tu_cuenta_tus_espacios.md`).

## Historias incorporadas en la revisión de exactitud (2026-10-07)

Cubren requerimientos añadidos a la Epic tras contrastarla con el código.

---

## US-TUS-007: Vista de Tus Espacios según el tipo de usuario

**Card:**  
Como **visitante, usuario o promotor**  
Quiero **ver en «Tus Espacios» el contenido adecuado a mi tipo de usuario**  
Para **saber qué puedo hacer sin confundirme**

**Conversation:**  
El invitado ve «No hay propiedades que mostrar» y dos botones que abren el login; el usuario normal ve «Propiedades guardadas [tipo]»; el promotor ve el menú de tipo de espacio, el botón «Compra de espacios» y su lista.

**Confirmation:**
- [ ] Invitado: mensaje y 2 botones que abren el diálogo de login
- [ ] Usuario normal: título «Propiedades guardadas»
- [ ] Promotor: menú de tipo de espacio y botón «Compra de espacios»

**Trazabilidad:** `REQ-ESP-011` · Escenarios: `08_pantallas/tu_cuenta/tus_espacios/`

---

## US-TUS-008: Ficha de propiedad con estado y acciones

**Card:**  
Como **promotor**  
Quiero **ver cada propiedad con su estado (PUBLICADA / SIN PUBLICAR) y sus acciones**  
Para **administrar mis anuncios desde una sola lista**

**Conversation:**  
La tarjeta muestra tipo, nombre, ubicación, precio y foto principal («Agrega fotos» si no hay). Acciones: Modificar, Publicar, Dejar de publicar y Eliminar; no se elimina una propiedad activa sin dejar de publicarla.

**Confirmation:**
- [ ] `activa = 1` muestra «PUBLICADA» y `activa = 0` «SIN PUBLICAR»
- [ ] Eliminar una propiedad activa muestra «Para borrar el espacio debes dejar de publicarlo»
- [ ] Sin foto principal se muestra «Agrega fotos»

**Trazabilidad:** `REQ-ESP-012` · Escenarios: `08_pantallas/tu_cuenta/tus_espacios/`

---

## US-TUS-009: Editar la propiedad en cinco pasos

**Card:**  
Como **promotor**  
Quiero **editar mi propiedad en un asistente de cinco pasos (Propiedad, Precio, Ubicación, Adicionales, Contacto)**  
Para **capturar los datos de forma ordenada y validada**

**Conversation:**  
El `Stepper` muestra u oculta campos según el tipo de propiedad y de transacción; al guardar valida el formulario y confirma con «Se actualizó correctamente».

**Confirmation:**
- [ ] Siguiente/Anterior/pasos directos navegan entre pasos
- [ ] El tipo de transacción muestra los campos de precio que corresponden
- [ ] Guardar con campos obligatorios vacíos muestra errores de validación

**Trazabilidad:** `REQ-ESP-013` · Escenarios: `08_pantallas/tu_cuenta/tus_espacios/`

---

## US-TUS-010: Publicar y dejar de publicar una propiedad

**Card:**  
Como **promotor**  
Quiero **publicar mi propiedad o retirarla del catálogo**  
Para **controlar cuándo es visible para otros usuarios**

**Conversation:**  
Publicar crea (o actualiza) el documento en la base de publicados del tipo de anuncio, pone `activa = 1` y guarda el id en `fotoprincipal`; dejar de publicar elimina ese documento y pone `activa = 0`. Si falla la actualización de la propiedad, se revierte la publicación.

**Confirmation:**
- [ ] Publicar una propiedad sin publicar crea el documento de publicación
- [ ] Dejar de publicar elimina el documento y limpia `fotoprincipal`
- [ ] Si falla la actualización tras publicar, la publicación se elimina

**Trazabilidad:** `REQ-ESP-014` · Escenarios: `08_pantallas/tu_cuenta/tus_espacios/`
