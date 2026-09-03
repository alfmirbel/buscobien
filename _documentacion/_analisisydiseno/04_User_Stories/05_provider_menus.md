# User Stories — Menús Dinámicos y SliverAppBars (05_provider_menus)

**Directorio:** `lib/05_provider_menus/`
**Archivos:** 16 `.dart` (7 providers + 5 SliverAppBars consumer + 2 menus Tu Cuenta + 1 dropdown + variables constantes)
**Fecha:** 2026-08-12
**Formato:** 3 C's (Card, Conversation, Confirmation)

---

## US-MENU-001: 7 Menús con Tabs Sincronizados por 5 Dimensiones de Filtrado

**Card:**
Como **usuario buscando propiedades**
Quiero **filtrar simultáneamente por 5 dimensiones (menú Inicial, Principal, Tipo de Espacio, Tipo de Transacción, Nivel de Gobierno) con tabs sincronizados**
Para **encontrar exactamente el tipo de inmueble que busco sin filtros sueltos**

**Conversation:**
7 providers `ClaseMenuX extends StateNotifier<ElementosDelMenuX>` gestionan cada menú. Cada provider expone `inicializaController(TickerProvider)` (crea `TabController`), `asignaNuevaOpcionSeleccionada(ref, index)` (actualiza selección + array `buttonSelectOpcion`), `restableceOpcionActualSeleccionada(ref)` (sincroniza `TabController.index` desde `seleccionMenuX`) y `disposeController()`. Bindings bidireccionales: `ButtonsTabBar.onTap` → `asignaNuevaOpcionSeleccionada` + `homeNavigationProvider.actualizarX(index)` (propaga abajo); listener de `homeNavigationProvider.indiceX` → `asignaNuevaOpcionSeleccionada` (propaga arriba). Los 5 menús de filtrado son por dimensión independiente y no se afectan mutuamente.

**Confirmation:**
- [ ] 7 menús visibles en sus secciones respectivas del shell principal
- [ ] `menuInicial`: 5 tabs (Inicio, Propiedades, Ubicación, Mi Cuenta, Perfil)
- [ ] `menuPrincipal`: 4 tabs (Todas, Casas, Departamentos, Otros)
- [ ] `menuTipoEspacio`: 5 tabs (Normales, Destacados, Superdestacados, Oportunidades, Remates)
- [ ] `menuTipoTransaccion`: 5 tabs (Todas, Venta, Renta, Venta/Renta, Traspaso)
- [ ] `menuNivelGobierno`: 5 tabs (Nacional, Estado, Municipio, C.P., Tipo/Localidad — último dinámico)
- [ ] `menuTuCuenta` (Promotor): 4 tabs (Propiedades, Listas, Grupos, Conocidos)
- [ ] `menuTuCuentaUsuario`: 3 tabs (Listas, Grupos, Conocidos)
- [ ] Tap en un tab actualiza `buttonSelectOpcion` (exactly one `true`) y `seleccionMenuX`
- [ ] Cambio externo en `homeNavigationProvider.indiceX` sincroniza el `TabController.index`
- [ ] `disposeController()` se invoca al desmontar el shell (no deja listeners zombi)

---

## US-MENU-002: Menú "Nivel de Gobierno" con Tabs Dinámicos por Código Postal

**Card:**
Como **usuario que quiere filtrar por su zona**
Quiero **ver tabs de asentamientos correspondientes a mi código postal**
Para **elegir localidad específica sin tipear filtros manuales**

**Conversation:**
`MenuSuperiorPaginaInicioNivelGobierno` (ConsumerWidget en `appbar_sliver_menu_nivel_gobierno.dart`) consume **dos providers**: `menuNivelDeGobiernoProvider` (selección actual) y `localidadesPorCodigoPostalProvider` (asentamientos SEPOMEX para el CP activo). El `build()` recorre `localidadesPorCodigoPostalProvider` y construye `List<Tab>` dinámico. `ButtonsTabBar` consume `menuNivelDeGobierno.tabControllerMenuNivelDeGobierno` con `length` derivado del provider. Al cambiar el CP, los tabs se reconstruyen con `ValueKey` dinámico. Tap en una localidad invoca `asignaNuevaOpcionSeleccionada(ref, index)` y `homeNavigationProvider.actualizarNivelGobierno(index)`.

**Confirmation:**
- [ ] Con CP válido, los tabs en `MenuSuperiorPaginaInicioNivelGobierno` muestran las localidades SEPOMEX
- [ ] Sin CP o CP inválido, se muestran los 5 tabs base (Nacional, Estado, Municipio, C.P., Tipo/Localidad)
- [ ] Cambiar CP en la app provoca reconstrucción de tabs con `ValueKey` distinto (sin error "Multiple elements with same key")
- [ ] Tap en una localidad actualiza `seleccionMenuNivelDeGobierno` y propaga a `homeNavigationProvider.indiceNivelGobierno`
- [ ] Si `localidadesPorCodigoPostalProvider` emite `AsyncLoading` → se preservan los tabs previos (sin flasheo)
- [ ] Si `localidadesPorCodigoPostalProvider` emite `AsyncError` → se preservan los tabs base

---

## US-MENU-003: Menú "Tu Cuenta" Diferenciado por Rol (Promotor vs Usuario)

**Card:**
Como **promotor o usuario regular**
Quiero **que el menú "Mi Cuenta" muestre opciones según mi rol**
Para **acceder solo a las funciones que aplican a mí**

**Conversation:**
Dos SliverAppBars distintos: `MenuSuperiorPaginaTuCuenta` (Promotor, 4 tabs) y `MenuSuperiorPaginaTuCuentaUsuario` (Usuario, 3 tabs). `PrincipalSliversMenuInicial` decide cuál mostrar leyendo `sessionProvider.esPromotor`. Ambos SliverAppBars usan `toolbarHeight: 0` (sin título, solo tab bar) y `pinned: true`. `onTap` en un tab invoca `asignaN NuevaOpcionSeleccionada(ref, index)` + `homeNavigationProvider.actualizarMiCuenta(index)` (Promotor) o `actualizarMiCuentaUsuario(index)` (Usuario). Ambos usan `ValueKey('sliver_tu_cuenta_${index}')` para evitar error AXTree.

**Confirmation:**
- [ ] Con `sessionProvider.esPromotor == true` → se renderiza `MenuSuperiorPaginaTuCuenta` (4 tabs: Propiedades, Listas, Grupos, Conocidos)
- [ ] Con `esPromotor == false` → se renderiza `MenuSuperiorPaginaTuCuentaUsuario` (3 tabs: Listas, Grupos, Conocidos)
- [ ] Tap en tab → `asignaNuevaOpcionSeleccionada` + `actualizarMiCuenta` ó `actualizarMiCuentaUsuario` según rol
- [ ] `homeNavigationProvider.indiceMiCuenta` (Promotor) y `indiceMiCuentaUsuario` (Usuario) se mantienen independientes
- [ ] `SliverAppBar.toolbarHeight = 0` → no hay título encima del tab bar
- [ ] `ValueKey` dinámico evita duplicidad al cambiar tabs

---

## US-MENU-004: Dropdown de Tipo de Inmueble con Variable Global Compartida

**Card:**
Como **usuario filtrando propiedades**
Quiero **un dropdown estándar para seleccionar subtipo de inmueble (ej. "Departamento")**
Para **refinar la búsqueda más allá de los tabs principales**

**Conversation:**
`DropdownButtonPropiedad` (StatefulWidget en `dropdown_menu_principal_propiedades.dart`) recibe `WidgetRef ref`, `int index`, `String valorInicial`, `ValueChanged<String>? onChangedCallback` y `bool listaamostrar`. El constructor del state inicializa con `valorInicial` si no es vacío. Opciones provienen de `otrosTiposDeInmueble` (constante en `lib/08_pantallas/tu_cuenta/tus_espacios/tabla_tipopropiedad_vs_campos.dart`). Al seleccionar, actualiza la **variable global mutable** `selectedDropDownMenuPrincipalValue` (definida en `02_principal_screen/principal_sliver_screen_menus_inicio.dart`) e invoca `onChangedCallback(newValue)` si está provisto. Usa `DropdownButtonFormField<String>` con `appTheme` para estilos.

**Confirmation:**
- [ ] Dropdown muestra lista de `otrosTiposDeInmueble` filtrada por `listaamostrar`
- [ ] Selección actual visible como valor del campo
- [ ] Al seleccionar nuevo valor → `selectedDropDownMenuPrincipalValue = newValue`
- [ ] `onChangedCallback(newValue)` notifica al widget padre
- [ ] Estilos M3 usan `appTheme` (sin hardcoded)
- [ ] `valorInicial` se respeta si está provisto y es válido
- [ ] Si `valorInicial` es inválido → usa el primer item de la lista

---

## US-MENU-005: MenuInferiorTipoDeTransaccion — Tabs Estándar en el Cuerpo

**Card:**
Como **usuario en la pantalla de búsqueda de propiedades**
Quiero **un menú inferior de tipo de transacción (Todas, Venta, Renta, Venta/Renta, Traspaso)**
Para **cambiar el contexto de negocio inmobiliario de un vistazo**

**Conversation:**
`MenuInferiorTipoDeTransaccion` (StatefulWidget con `_MenuInferiorTipoDeTransaccionState` en `appbar_menu_tipo_transaccion_inferior.dart`) — a diferencia de los 5 SliverAppBars, este es un **widget standalone** que se renderiza en el cuerpo inferior de `PaginaBuscaEspacios` (no como sliver). Internamente usa `Container + ButtonsTabBar` consumiendo `menuTipoDeTransaccionProvider`. onTap invoca `asignaNuevaOpcionSeleccionada(ref, index)` y `homeNavigationProvider.actualizarTipoTransaccion(index)`.

**Confirmation:**
- [ ] Widget se renderiza en el cuerpo de `PaginaBuscaEspacios` (no como `SliverAppBar`)
- [ ] 5 tabs visibles: Todas, Venta, Renta, Venta/Renta, Traspaso
- [ ] Tap en tab → `menuTipoDeTransaccionProvider.seleccionMenuTipoDePublicacion` actualizado
- [ ] `homeNavigationProvider.indiceTipoTransaccion` sincronizado
- [ ] `Container` envuelve el `ButtonsTabBar` con estilos `appTheme`
- [ ] No usa `ValueKey` explícito porque length es fijo (no cambia)

---

## Notas

- Estas US complementan la Epic en `02_Epics_EARS/05_provider_menus.md` y los escenarios Gherkin en `03_Features_BDD/05_provider_menus/menus_dinamicos.feature`.
- Para detalles por archivo (16 archivos): ver `05_Tareas_Inventarios/05_provider_menus/elementos_05_provider_menus.md`.
- Las US previamente consolidadas en `04_User_Stories/03_listas.md` (US-MENU-001 y US-MENU-002) están ahora separadas en este archivo dedicado con formato 3 C's completo.
