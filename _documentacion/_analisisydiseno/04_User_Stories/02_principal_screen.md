# User Stories — Pantalla Principal / Shell de Navegación (02_principal_screen)

**Directorio:** `lib/02_principal_screen/`
**Archivos:** `00_principales_opciones.dart`, `principal_00_inicio.dart`, `principal_02_page_appbar.dart`, `principal_03_page_drawer.dart`, `principal_sliver_screen_menus_inicio.dart`
**Fecha:** 2026-08-12
**Formato:** 3 C's (Card, Conversation, Confirmation)

---

## US-PRIN-001: Shell Principal con 5 Secciones y Slivers Condicionales

**Card:**
Como **usuario autenticado o invitado**
Quiero **un shell central que orqueste Inicio, Propiedades, Ubicación, Mi Cuenta y Perfil mediante un único `CustomScrollView`**
Para **cambiar de sección sin perder el contexto de navegación y con transiciones suaves**

**Conversation:**
`PrincipalSliversMenuInicial` (ConsumerStatefulWidget con `TickerProviderStateMixin`) inicializa en `initState` 7 `TabController` síncronos (inicial, principal, nivelGobierno, tipoEspacio, tipoTransaccion, tuCuenta, tuCuentaUsuario) llamando a `inicializaController(this)` en cada `menuXProvider`. Tras `postFrameCallback`: (1) `getSessionValuesFromLocalStorage()` restaura la sesión, (2) si `isAuthenticated`, precarga `getUserDataByNameInSessionData()` y `recuperaDatosDelAvatar(currentUserId)`, (3) `_inicializarLogicaDeNegocio()` asigna la opción seleccionada por defecto. `build()` arma un `CustomScrollView` con slivers condicionales según `homeNavigationProvider.indiceInicial` (0=Inicio, 1=Propiedades, 2=Ubicación, 3=Mi Cuenta, 4=Perfil). Ubicación se dispara en background vía `_triggerLocationUpdate()`.

**Confirmation:**
- [ ] Al abrir la app y validar splash, se navega a `/principal` y se renderiza el shell completo
- [ ] Cambiar `indiceInicial` de 0 a 4 reemplaza el sliver visible sin reconstruir todo el árbol
- [ ] Los 7 `TabController` se inicializan sincrónicamente en `initState` (evita `LateInitializationError`)
- [ ] Tras postFrame, la sesión persistida se restaura y `PaginaPerfilWidget` encuentra datos cacheados (`isUserDataLoaded=true`)
- [ ] `dispose()` libera los 7 controladores y el `ScrollController`
- [ ] `ScrollController` habilita `Scrollbar` funcional en Web/Desktop

---

## US-PRIN-002: AppBar Dinámico según Estado de Sesión

**Card:**
Como **usuario con o sin sesión**
Quiero **que el `AppBar` muestre avatar si estoy logueado o botón Login si no lo estoy**
Para **acceder directamente a mi cuenta o iniciar sesión sin buscar el botón**

**Conversation:**
`appBarPrincipal(context, onMenuPressed, titulo, ref)` (función top-level en `principal_02_page_appbar.dart`) retorna un `AppBar` con `_buildUserButton(ref)`: si `sessionProvider.loginExitoso == true`, muestra `CircleAvatar` con `imageBytes` del `classUserAvatarProvider` (toca → navega a `/perfil` o `/micuenta` según perfil); si no, muestra `IconButton` con `iconNoUser` y tooltip `userTooltip` ("Sin usuario") que abre `dialogBoxFichaLogin`. Adicionalmente, incluye botones `botonAccion` para favoritos, búsqueda y notificaciones, todos condicionales al estado de sesión. Usa `appTheme` para colores (sin hardcoded).

**Confirmation:**
- [ ] Con sesión válida → `CircleAvatar` muestra imagen del avatar recuperada
- [ ] Sin sesión → `IconButton` muestra `iconNoUser` con tooltip "Sin usuario"
- [ ] Tocar avatar navega a `/perfil` si `nombrePerfil == "Usuario"` o a `/micuenta` en otro caso
- [ ] Tocar botón "Login" invoca `dialogBoxFichaLogin` con formulario de autenticación
- [ ] Todos los colores provienen de `appTheme` (sin `Color(0xFFxxxxxx)` hardcoded)
- [ ] `Tooltip` envuelve cada `IconButton` para accesibilidad Web/Desktop

---

## US-PRIN-003: Drawer Lateral con 11 Items y Navegación

**Card:**
Como **usuario que quiere acceder a funciones secundarias**
Quiero **un menú lateral con items agrupados (Salir, Principal, Favoritos, Preferencias, Configuración, Acerca de, Contacto)**
Para **navegar a funciones no principales sin saturar el `AppBar`**

**Conversation:**
`MenuDrawer` (ConsumerWidget) construye `Drawer` con `ListView` y `_createHeader()` (cabecera con branding) + `_createDrawerItem()` por cada item. Items funcionales navegan vía `Navigator.pushReplacementNamed(AppRoutes.xxx)` (principal, preferencias, perfil, listaspropiedades). Items "Próximamente" (Ver después, Configuración, Contacto) muestran etiqueta pero `onTap: () {}` vacío. `_createDrawerAbout()` muestra versión actual (`versionActual` de `01_splash_screen/versiones.dart`).

**Confirmation:**
- [ ] Abrir drawer muestra 11 items con icono + etiqueta + separadores
- [ ] Item "Principal" navega a `/principal` con `pushReplacementNamed`
- [ ] Item "Preferencias" navega a `/preferencias` (tema M3)
- [ ] Items "Próximamente" muestran etiqueta pero no navegan
- [ ] Cabecera muestra logo + nombre app (`appName`)
- [ ] Footer muestra "Versión: Beta 0.07.053" (dinámico desde `versionActual`)
- [ ] Cada `ListTile` usa `var_elementos_menus` para icono (rango `0xe000-0xe900`)

---

## US-PRIN-004: Inicio con Hero, 3 Tarjetas Responsivas y Hover Animado

**Card:**
Como **usuario que entra al shell principal por primera vez**
Quiero **una landing con hero image, grid de 3 tarjetas (Buscar, Promotores, Propietarios) y feedback hover**
Para **descubrir las acciones principales y entender qué puedo hacer**

**Conversation:**
`PageInicio` (ConsumerStatefulWidget) renderiza hero con `Image.asset` + gradient overlay, luego un `Wrap` o `GridView.count` con 3 `_HoverScaleCard` (StatefulWidget con `AnimationController`). Cada tarjeta invoca `onTap` que actualiza `homeNavigationProvider.indicePrincipal` y navega. `_HoverScaleCard` usa `Transform.scale` con `Tween<double>(begin: 1.0, end: 1.05)` activado por `onEnter`/`onExit` events. En pantallas chicas, el grid colapsa a 1 columna vía `MediaQuery`. Footer muestra `derechosReservadosObscuro()`.

**Confirmation:**
- [ ] Hero muestra imagen deProperties + overlay con título y CTA
- [ ] Grid muestra 3 tarjetas (Buscar, Promotores, Propietarios) con icono + título + descripción
- [ ] Hover en Web/Desktop escala la tarjeta a 1.05x y la reduce al salir
- [ ] Tap en tarjeta ejecuta `onTap` y navega a la sección correspondiente
- [ ] En pantallas < 600px, el grid se reorganiza a 1 columna
- [ ] Footer muestra derechos reservados con estilo `derechosReservadosObscuro()`
- [ ] Animación respeta `TickerProvider` y libera `AnimationController` en `dispose()`

---

## US-PRIN-005: Listener Reactivo de Conectividad Integrado

**Card:**
Como **usuario que pierde conexión mientras navega el shell**
Quiero **que la app me avise automáticamente y regrese al flujo al recuperar red**
Para **no tener que verificar manualmente el estado de red**

**Conversation:**
`_PrincipalSliversMenuInicialState` registra un `ref.listen(checaConeccionesProvider)` en `build()` que evalúa el `AsyncValue<ElementoDatos>`. Al detectar etiqueta "Sin conexión", invoca `Navigator.pushNamed(AppRoutes.sinconeccion)`. En `PaginaSinConeccion`, otro `ref.listen` detecta "Conectado" y ejecuta `Navigator.pop()` automáticamente. El listener está activo sólo mientras el shell está montado (se libera con el widget).

**Confirmation:**
- [ ] Perder conexión mientras se navega en `/principal` → auto-navega a `/sinconeccion`
- [ ] Recuperar conexión en `/sinconeccion` → `Navigator.pop()` regresa al shell
- [ ] El listener no persiste tras `dispose()` del shell (no provoca navegaciones zombi)
- [ ] `if (!mounted) return;` se respeta antes de cualquier `Navigator.push`
- [ ] El estado `AsyncValue.loading` no dispara navegación (solo `data` con etiqueta distinta)

---

## Notas

- Estas User Stories complementan la Epic `02_Epics_EARS/02_principal_screen.md` y los escenarios BDD en `03_Features_BDD/02_principal_screen/pantalla_principal_landings.feature`.
- Para detalles técnicos por archivo, ver `05_Tareas_Inventarios/02_principal_screen/elementos_02_principal_screen.md`.
- ParaEnterprise de landing pages (9 vistas en `03_vistas/`), ver el subdirectorio correspondiente y su documentación dedicada.
