# User Stories — Landing Pages por Actor / Catálogos Públicos (03_vistas)

**Directorio:** `lib\03_vistas\` (9 archivos `.dart`, 9 landings por actor)
**Epic asociado:** [`02_Epics_EARS/03_vistas.md`](../02_Epics_EARS/03_vistas.md)
**Feature BDD:** [`03_Features_BDD/03_vistas/landing_pages_por_actor.feature`](../03_Features_BDD/03_vistas/landing_pages_por_actor.feature) (10 escenarios)
**Fecha:** 2026-08-12
**Fuente:** Ingeniería inversa

---

## US-VIST-001: Ver una landing page por segmento con estructura M3 común

### Card
**Como** visitante (potencial cliente de un segmento inmobiliario)
**Quiero** una landing page adaptada a mi rol que explique de qué trata Buscobien
**Para** decidir si me registro o sigo navegando el catálogo público.

### Conversation
- 9 landings como `ConsumerWidget` en `lib\03_vistas/`: `pagina_asociaciones.dart`, `pagina_hospedaje.dart`, `pagina_inmobiliarias.dart`, `pagina_market.dart`, `pagina_promotores.dart`, `pagina_propietarios.dart`, `pagina_proveedores.dart`, `pagina_servicios.dart`, `pagina_usuarios.dart`.
- **Estructura común (patrón copy-paste):** `AppBar` con título del segmento, botón back condicional (`Navigator.canPop(context)`), `SingleChildScrollView`, secciones Hero + Beneficios + Stats + Features + Pasos + Footer, `derechosReservadosObscuro()` al pie.
- Cada landing define **paleta de colores y branding propio** vía `Color(0xFF...)` directo en Containers/Gradients: burdeos/dorado asociaciones, azul/ámbar hospedaje, steel blue/green inmobiliarias, violeta/ámbar market, navy/gold promotores, azul/rojo propietarios, púrpura/magenta proveedores, teal/naranja servicios, azul/ámbar usuarios.
- Iconografía: `material_symbols_icons` (`Symbols.*`) en toda la página — cumple regla rango 0xe000-0xe900.
- **Comentario crítico:** los colores `Color(0xFF...)` hardcoded **violan `ui_exceptions.dart`** (no están registrados como excepciones). Deuda técnica UI priorizada para refactor: extraer paleta de landings a ColorScheme dedicados o usar el `appTheme` global, pero entretanto se documenta como excepción.

### Confirmation
- ✓ Cada segmento tiene su landing con la estructura común completa (Hero + secciones + Footer + derechos reservados).
- ✓ AppBar muestra título del segmento y botón back cuando `Navigator.canPop == true`.
- ✓ La iconografía usa exclusivamente `Symbols.*` del rango M3.
- ✓ Feature BDD: `landing_pages_por_actor.feature`, escenario "Estructura común de toda landing".

**Trazabilidad:** `REQ-VIST-001`, `REQ-VIST-002`, `REQ-VIST-007`

---

## US-VIST-002: Convertirme en promotor / propietario / hospedaje con un solo CTA funcional

### Card
**Como** visitante decidido a publicar una propiedad
**Quiero** un CTA claro en la landing de Promotores, Propietarios u Hospedaje que me lleve directamente al flujo de publicación
**Para** empezar a publicar sin pasos intermedios.

### Conversation
- Sólo **4 de 9 landings tienen CTA funcional**. El resto son placeholders ("PROXIMAMENTE...").
- **Promotores** (`pagina_promotores.dart`): CTA "Prueba Gratis" / "Publicar" — al tap configura 4 providers de menú con valores predeterminados:
  - `tipoEspacio`: apartamento / casa / terreno (según CTA)
  - `tipoTransaccion`: venta / renta
  - `tuCuenta`: promotor
  - `nivelGobierno`: nacional / estatal / municipal (según segmento)
  - Luego `Navigator.pushReplacementNamed(context, AppRoutes.principal)`.
- **Propietarios** (`pagina_propietarios.dart`): CTA "Publicar Gratis Ahora" — configura los mismos 4 providers con valores del segmento propietario y navega a principal con `pushReplacementNamed`.
- **Hospedaje** (`pagina_hospedaje.dart`): CTA "Aquí publicaras" — configura 5 providers (incluyendo `seleccionPrincipal`) con valores de hospedaje y navega a principal.
- El `pushReplacementNamed` reemplaza la landing en el stack — el back no regresa a la landing, evita ciclos.
- **Comentario:** los providers configurados son globales mutables (deuda de `variables_globales.dart` y `05_provider_menus`). La lógica de configuración batch (4-5 providers por CTA) debería ser un único `FutureProvider` o acción de `NotifierProvider` que inicialice el estado.

### Confirmation
- ✓ Al tocar "Publicar" en Promotores, los 4 providers quedan con los valores del segmento.
- ✓ El navegador reemplaza la landing con `/principal` (no vuelve a landing con back).
- ✓ La pantalla principal abre el menú correcto (tuCuenta=promotor, tipoEspacio configurado).
- ✓ Feature BDD: escenarios "CTA funcional en Promotores/Propietarios/Hospedaje".

**Trazabilidad:** `REQ-VIST-003`

---

## US-VIST-003: Buscar propiedades viales por código postal desde la landing Usuarios

### Card
**Como** visitante comprador/arrendatario sin cuenta
**Quiero** ingresar código postal y ver propiedades disponibles en esa zona
**Para** evaluar Buscobien antes de registrarme.

### Conversation
- `pagina_usuarios.dart` es una **landing híbrida**: describe el valor para compradores y a la vez ofrece búsqueda en vivo conectada a CouchDB.
- **CTA "Buscar":** un `TextFormField` para código postal (CP, México = 5 dígitos). Al tap:
  1. Valida el CP (regex 5 dígitos).
  2. Actualiza `codigoPostalBusquedaProvider` con el CP.
  3. Navega a la pantalla de búsqueda de localidades (`AppRoutes` correspondiente).
- **Carrusel de propiedades:** consume `findPropiedadesEstadosde10en10Provider` (paginado 10-en-10). Renderiza cards en scroll horizontal infinito con `paramSkip` acumulador.
- **Paginación incremental:** al llegar al final del carrusel, se incrementa `paramSkip += 10` y se cargan las siguientes propiedades. Fallback a endpoints alternativos si el principal falla (404, timeout).
- **Comentario:** el estado del CP vive en un provider Riverpod (ya no en variable global) —例外. La paginación no usa `infinite_scroll` package sino lógica custom; deuda: puede tener race conditions al hacer scroll muy rápido.

### Confirmation
- ✓ CP inválido (no 5 dígitos) muestra error de validación.
- ✓ CP válido guarda en `codigoPostalBusquedaProvider` y navega a localidades.
- ✓ El carrusel muestra 10 propiedades iniciales y carga más al hacer scroll.
- ✓ Si el endpoint principal falla, se usa el fallback y el carrusel sigue funcionando.
- ✓ Feature BDD: escenarios "CTA Buscar en página Usuarios" y "Carrusel paginado en página Usuarios".

**Trazabilidad:** `REQ-VIST-004`, `REQ-VIST-005`, `REQ-VIST-009`

---

## US-VIST-004: Ver placeholder informativo en Inmobiliarias / Market / Proveedores / Servicios / Asociaciones

### Card
**Como** visitante interesado en uno de los 5 segmentos no lanzados
**Quiero** ver una landing informativa que diga que la funcionalidad está próxima
**Para** no perderme y saber cuándo volver.

### Conversation
- 5 landings **placeholder** sin CTA funcional: `pagina_inmobiliarias.dart`, `pagina_market.dart`, `pagina_proveedores.dart`, `pagina_servicios.dart`, `pagina_asociaciones.dart`.
- El CTA principal muestra "PROXIMAMENTE..." o "PRÓXIMAMENTE REGISTRO" y no navega a ninguna parte (o lo hace a registro sin lógica de segmento).
- **Inmobiliarias** es la única con un formulario de contacto parcial: `TextFormField` con validación básica y botón submit **no conectado a backend** (`onPressed` placeholder).
- **Sección Hero y Beneficios** preservadas: describen el caso de uso y aclaran que el flujo está en desarrollo.
- **Comentario:** los 5 placeholders son copy-paste de una página activa (probablemente `pagina_promotores.dart`) con texto cambiado — deuda de refactor cuando se activen: debería haber un widget base paramétrico `LandingTemplate(config: ...)` que reduzca los 9 archivos a 1.

### Confirmation
- ✓ Las 5 landings muestran CTA "PROXIMAMENTE..." y no ejecutan navegación real.
- ✓ La estructura (Hero + secciones + Footer) sigue siendo visible aunque no funcional.
- ✓ Inmobiliarias muestra el formulario aunque submit no persiste.
- ✓ Feature BDD: escenario "CTA deshabilitado / placeholder".

**Trazabilidad:** `REQ-VIST-006`, `REQ-VIST-008`

---

## Resumen matriz

| US | Epic Req | Escenarios BDD | Landings implicadas |
|----|----------|----------------|---------------------|
| US-VIST-001 (estructrura común) | REQ-VIST-001, 002, 007 | 2 | 9 landings |
| US-VIST-002 (CTA funcional promotor/propietario/hospedaje) | REQ-VIST-003 | 3 | promotores, propietarios, hospedaje |
| US-VIST-003 (búsqueda CP + carrusel) | REQ-VIST-004, 005, 009 | 2 | pagina_usuarios |
| US-VIST-004 (5 placeholders) | REQ-VIST-006, 008 | 2 | inmobiliarias, market, proveedores, servicios, asociaciones |

---

## Notas de deuda técnica (del Epic + análisis)

1. **9 páginas, 1 patrón**: copy-paste intensivo. Refactor a `LandingTemplate(config)`.
2. **Sólo 4/9 landings funcionales**: 5 son placeholders. Product backlog para activar segmentos.
3. **Colores `Color(0xFF...)` hardcoded**: violan `ui_exceptions.dart` (no registrados). Excepción pendiente de documentar.
4. **Lógica de inicialización batch de 4-5 providers** desde el CTA — debería ser una acción de NotifierProvider.
5. **`findPropiedadesEstadosde10en10Provider` puede tener race conditions** con scroll rápido (invalidación de páginas antiguas).
6. **Form Inmobiliarias sin backend**: desconectado.
7. **Sin tests**: ningún widget test de las 9 landings. Smoke test global cubre inicialización pero no el detalle de cada landing.
