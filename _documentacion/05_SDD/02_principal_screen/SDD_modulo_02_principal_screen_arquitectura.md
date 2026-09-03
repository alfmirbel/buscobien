# SDD — Módulo `lib/02_principal_screen` — Especificación de Arquitectura
## Especificación General del Módulo de Pantalla Principal
**Módulo:** `lib/02_principal_screen/`
**Versión:** 1.0
**Metodología:** EARS — Easy Approach to Requirements Syntax
**Fecha:** 2026-08-06

---

## 1. Inventario de Archivos del Módulo

| Archivo | Tipo | Rol |
|---|---|---|
| `principal_sliver_screen_menus_inicio.dart` | Fuente — Widget con Estado Reactivo (`ConsumerStatefulWidget`) | Widget raíz de la pantalla principal; gestiona la navegación por `HomeState`, listeners de conectividad, inicialización síncrona de controladores, carga de sesión y ubicación en segundo plano |
| `principal_00_inicio.dart` | Fuente — Widget con Estado (`ConsumerStatefulWidget`) | Página de inicio / landing page; renderiza fondo con imagen, degradado, encabezado y grid de tarjetas de opciones con navegación a landing pages |
| `principal_02_page_appbar.dart` | Fuente — Función de Widget y Widgets Auxiliares | Construye la `AppBar` principal con botones de conectividad, localización, filtros, búsqueda, notificaciones, ayuda y usuario; incluye diálogo de login y navegación por perfil |
| `principal_03_page_drawer.dart` | Fuente — Widget con Estado (`ConsumerWidget`) | Implementa el menú lateral (`Drawer`) con opciones de salir, navegación, preferencias, configuración, acerca de y contacto |
| `00_principales_opciones.dart` | Fuente — Modelo de Datos y Datos Estáticos | Define el modelo `MenuOption`, la lista `menuOpciones` y la lista `listaLandingPages` que alimentan la página de inicio |

---

## 2. Requerimientos Ubicuos (Ubiquitous)

> Aplican al módulo completo en todo momento mientras la pantalla principal esté activa.

**SDD-PRI-001**
El sistema deberá renderizar `PrincipalSliversMenuInicial` como contenedor raíz de la pantalla principal, orquestando la `AppBar`, el `Drawer` y el cuerpo de navegación dinámica.

**SDD-PRI-002**
El sistema deberá gestionar el estado de navegación exclusivamente mediante `homeNavigationProvider` y el estado de sesión mediante `sessionProvider`, garantizando reactividad automática ante cambios en `indiceInicial`, `indicePrincipal`, `indiceNivelGobierno`, `indiceTipoEspacio`, `indiceTipoTransaccion`, `indiceMiCuenta` e `indiceMiCuentaUsuario`.

**SDD-PRI-003**
El sistema deberá mantener el `ScrollController` vivo durante todo el ciclo de vida del widget, disponiéndolo en `dispose()` para evitar fugas de memoria.

**SDD-PRI-004**
El sistema deberá separar estrictamente las responsabilidades del módulo en cuatro capas:
- **Navegación y ciclo de vida** (`principal_sliver_screen_menus_inicio.dart`): estado principal, listeners, inicialización.
- **Landing page de inicio** (`principal_00_inicio.dart`): presentación de opciones y grid de tarjetas.
- **Barra de aplicación** (`principal_02_page_appbar.dart`): acciones superiores, conectividad y usuario.
- **Menú lateral** (`principal_03_page_drawer.dart`): navegación secundaria y metadatos de la app.

**SDD-PRI-005**
El sistema deberá garantizar que ningún archivo del módulo `02_principal_screen` importe widgets o lógica de capas de detalle inferiores que representen pantallas completas (`08_pantallas/*`), limitándose a importar providers, modelos y widgets compartidos.

---

## 3. Requerimientos Controlados por Eventos (Event-Driven)

**SDD-PRI-010**
Cuando `PrincipalSliversMenuInicial` se monte (`initState`), el sistema deberá invocar `_inicializarSoloControladores()` de forma síncrona para inicializar los `TabController` de los siete providers de menú: `menuInicialProvider`, `menuPrincipalProvider`, `menuNivelDeGobiernoProvider`, `menuTipoEspaciosProvider`, `menuTipoDeTransaccionProvider`, `menuTuCuentaProvider` y `menuTuCuentaUsuarioProvider`.

**SDD-PRI-011**
Cuando el post-frame callback se ejecute tras el primer render, el sistema deberá invocar `getSessionValuesFromLocalStorage()` y, si `isAuthenticated == true`, cargar `getUserDataByNameInSessionData()` y `recuperaDatosDelAvatar(currentUserId)` en segundo plano sin bloquear la UI.

**SDD-PRI-012**
Cuando el post-frame callback ejecute `_inicializarLogicaDeNegocio()`, el sistema deberá restablecer la opción seleccionada de cada menú llamando a `asignaNuevaOpcionSeleccionada(ref, estadoActual)` y `restableceOpcionActualSeleccionada(ref)` para los siete providers de menú.

**SDD-PRI-013**
Cuando `initState` invoque `_triggerLocationUpdate()`, el sistema deberá determinar permisos de ubicación, obtener la ubicación actual, extraer el código postal, consultar `localidadesPorCodigoPostalProvider` y, si el resultado es `200`, llamar a `actualizarNivelGobierno(3)` para fijar el ámbito geográfico en Código Postal.

**SDD-PRI-014**
Cuando el usuario seleccione una tarjeta de opción en `PageInicio` y `index < listaLandingPages.length`, el sistema deberá navegar a la landing page correspondiente mediante `Navigator.push` con `PageRouteBuilder` y transición `FadeTransition` de 400 ms.

**SDD-PRI-015**
Cuando el usuario seleccione una tarjeta sin landing page asociada, el sistema deberá mostrar un `SnackBar` con el texto "Próximamente disponible." y color de fondo `appTheme.secondary`.

**SDD-PRI-016**
Cuando el usuario presione el botón de usuario en la `AppBar` sin sesión iniciada, el sistema deberá abrir `dialogBoxFichaLogin` y, según el resultado, navegar a "Mi Cuenta" (`actualizarInicial(3)`) si el login es exitoso, o a "Propiedades" (`actualizarInicial(1)` + `actualizarPrincipal(0)`) si se cancela.

**SDD-PRI-017**
Cuando el usuario presione el botón de usuario con sesión activa, el sistema deberá navegar a "Perfil" (`actualizarInicial(4)`) y sincronizar el `menuInicialProvider` con `restableceOpcionActualSeleccionada(ref)`.

**SDD-PRI-018**
Cuando el usuario abra el `Drawer` y seleccione "Salir", el sistema deberá invocar `ServicesBinding.instance.exitApplication(AppExitType.required)` para cerrar la aplicación.

**SDD-PRI-019**
Cuando el usuario seleccione "Configuración" en el `Drawer`, el sistema deberá ejecutar `setCheckPlataformaProvider(ref)` y navegar a `AppRoutes.plataforma`.

**SDD-PRI-020**
Cuando el usuario seleccione "Acerca de..." en el `Drawer`, el sistema deberá mostrar un diálogo con el título "Acerca de buscobien", el mensaje "Plataforma de promoción inmobiliaria\n$versionActual" y botón "Salir".

**SDD-PRI-021**
Cuando el `ref.listen` de `homeNavigationProvider` detecte un cambio en cualquier índice de navegación, el sistema deberá ejecutar `_scrollController.jumpTo(0)` para regresar al inicio del contenido.

**SDD-PRI-022**
Cuando el `ref.listen` de `checaConeccionesProvider` detecte un estado `data` con `etiqueta != "Conectado"` y `_isErrorPageOpen == false`, el sistema deberá navegar a `AppRoutes.sinconeccion` con el mensaje "Se perdió la conexión a Internet." y establecer `_isErrorPageOpen = true`.

**SDD-PRI-023**
Cuando el `ref.listen` de `checaConeccionesProvider` detecte un estado `error`, el sistema deberá invocar `_navigateToErrorPage()` para navegar a `AppRoutes.sinconeccion` con el mensaje "No se detectó conexión a Internet.".

---

## 4. Requerimientos Controlados por Estados (State-Driven)

**SDD-PRI-020**
Mientras `navState.indiceInicial == 0`, el sistema deberá mostrar `PageInicio` como contenido principal dentro de un `SliverFillRemaining` con `hasScrollBody: false`.

**SDD-PRI-021**
Mientras `navState.indiceInicial == 1`, el sistema deberá mostrar `menuSuperiorMenuPrincipal` como sub-menú y, si `navState.indicePrincipal` está entre `0` y `3`, mostrar `PaginaBuscaEspacios(navState)` como contenido.

**SDD-PRI-022**
Mientras `navState.indiceInicial == 2`, el sistema deberá mostrar `PaginaPrincipalListaLocalidades` como contenido principal.

**SDD-PRI-023**
Mientras `navState.indiceInicial == 3` y `userSession.nombrePerfil == ""`, el sistema deberá mostrar la vista `_vistaSinUsuario()` con el mensaje "Crea listas, grupos o contactos" y el botón "Ingresa de acuerdo a tu perfil".

**SDD-PRI-024**
Mientras `navState.indiceInicial == 3` y `userSession.esPromotor == true`, el sistema deberá mostrar `MenuSuperiorPaginaTuCuenta` y, según `indiceMiCuenta`, renderizar:
- `0` → `PaginaTusEspacios()` (`hasScrollBody: true`)
- `1` → `PageMisListas()` (`hasScrollBody: false`)
- `2` → `GruposView` con `currentUserId` y `currentUserName`
- `3` → `ConocidosView` con `currentUserId` y `currentUserName`

**SDD-PRI-025**
Mientras `navState.indiceInicial == 3` y `userSession.esUsuario == true`, el sistema deberá mostrar `MenuSuperiorPaginaTuCuentaUsuario` y, según `indiceMiCuentaUsuario`, renderizar:
- `0` → `PageMisListas()` (`hasScrollBody: false`)
- `1` → `GruposView` con `currentUserId` y `currentUserName`
- `2` → `ConocidosView` con `currentUserId` y `currentUserName`

**SDD-PRI-026**
Mientras `navState.indiceInicial == 4`, el sistema deberá mostrar `PaginaPerfilWidget` dentro de un `SliverFillRemaining` con `hasScrollBody: false`.

**SDD-PRI-027**
Mientras `screenWidth > smallScreenMin` (600.0 px), el sistema deberá mostrar los botones de `Filters` y `Search` en la `AppBar`; mientras `screenWidth <= smallScreenMin`, estos botones deben estar ausentes.

**SDD-PRI-028**
Mientras el `Drawer` esté abierto y el usuario no tenga sesión iniciada, el sistema deberá mostrar `Icon(iconNoUser)` en el botón de usuario de la barra; mientras tenga sesión y avatar, deberá mostrar `CircleAvatar` con la imagen base64; en cualquier otro caso, `Icon(iconUser)`.

**SDD-PRI-029**
Mientras `navState.indiceInicial != 1`, el sistema deberá mostrar `menuSuperiorMenuInicial` en los slivers de la `CustomScrollView`.

---

## 5. Requerimientos de Comportamiento No Deseado (Unwanted Behaviour)

**SDD-PRI-030**
Si el usuario pierde conexión intermitentemente mientras la pantalla de error ya está abierta (`_isErrorPageOpen == true`), entonces el sistema no deberá abrir una segunda pantalla de error, ignorando los eventos adicionales de desconexión hasta que el usuario regrese.

**SDD-PRI-031**
Si el usuario regresa de la pantalla de error (`Navigator.pop`), entonces el sistema deberá restablecer `_isErrorPageOpen = false` para permitir futuras detecciones de pérdida de conexión.

**SDD-PRI-032**
Si el `post-frame callback` intenta ejecutar lógica de negocio después de que el widget haya sido descartado (`!mounted`), entonces el sistema deberá abortar las operaciones asíncronas y no actualizar el estado.

**SDD-PRI-033**
Si el usuario toca una tarjeta de opción en `PageInicio` cuyo índice es mayor o igual a `listaLandingPages.length`, entonces el sistema deberá mostrar el `SnackBar` "Próximamente disponible." y no intentar navegar a una página inexistente.

**SDD-PRI-034**
Si la imagen de fondo especificada en `menuOpciones[0].imagePath` no existe en los assets, entonces el sistema deberá fallback a `'assets/images/default_bg.jpg'` para mantener la integridad visual de `PageInicio`.

**SDD-PRI-035**
Si el avatar del usuario en base64 está corrupto o vacío, entonces el sistema debera mostrar el icono de usuario por defecto (`Icon(iconUser)`) en lugar de un `CircleAvatar` roto o una excepción visual.

**SDD-PRI-036**
Si `ubicacionState.permisodelocalizacion == 0` al presionar el botón de localización en la `AppBar`, entonces el sistema deberá mostrar `PaginaDeError("Activa los permisos de ubicación")` en lugar de navegar a localidades.

---

## 6. Requerimientos de Funciones Opcionales (Optional Feature)

**SDD-PRI-040**
Donde el módulo `02_principal_screen` incluya la página de inicio (`PageInicio`), el sistema deberá exponer los providers `codigoPostalBusquedaProvider` y `warningApp` para que pantallas descendentes puedan leer y escribir el código postal de búsqueda y el estado de advertencia.

**SDD-PRI-041**
Donde `PageInicio` renderice tarjetas con efecto hover, el sistema deberá mantener la clase `_HoverScaleCard` con `AnimationController` de 150 ms y rango `0.0` a `0.04`, aplicando `Transform.scale` solo en dispositivos con puntero (web/desktop).

**SDD-PRI-042**
Donde `PrincipalSliversMenuInicial` renderice el contenido dinámico, el sistema deberá envolver el `CustomScrollView` en un `Scrollbar` con `thumbVisibility: true` para soportar scroll visual en Web/Desktop.

---

## 7. Requerimientos Complejos (Combinados)

**SDD-PRI-050**
Mientras la pantalla principal esté montada y el usuario haya navegado a una sección diferente, cuando cualquier índice de `homeNavigationProvider` cambie, el sistema deberá ejecutar `_scrollController.jumpTo(0)` y notificar al listener de navegación para sincronizar el scroll con la nueva sección.

**SDD-PRI-051**
Mientras el usuario no tenga sesión iniciada, cuando intente acceder a "Mi Cuenta" (índice 3) o presione el botón de usuario en la `AppBar`, el sistema deberá mostrar la vista de invitado y el diálogo de login respectivamente, sin exponer sub-vistas de promotor ni de usuario.

**SDD-PRI-052**
Mientras el usuario tenga sesión iniciada como promotor, cuando navegue a "Mi Cuenta", el sistema deberá mostrar `MenuSuperiorPaginaTuCuenta` y, al cambiar `indiceMiCuenta`, renderizar la sub-vista correspondiente propagando `currentUserId` y `currentUserName` desde `sessionProvider`.

**SDD-PRI-053**
Mientras el usuario tenga sesión iniciada como usuario (comprador), cuando navegue a "Mi Cuenta", el sistema deberá mostrar `MenuSuperiorPaginaTuCuentaUsuario` y, al cambiar `indiceMiCuentaUsuario`, renderizar la sub-vista correspondiente propagando `currentUserId` y `currentUserName` desde `sessionProvider`.

**SDD-PRI-054**
Mientras `checaConeccionesProvider` emita cambios en la `AppBar`, cuando el estado pase de conectado a no conectado, el sistema deberá cambiar el icono a `Symbols.signal_wifi_bad`, el color a `appTheme.error` y el tooltip al texto de la etiqueta; mientras esté cargando, deberá mostrar `CircularProgressIndicator` de color primario.

**SDD-PRI-055**
Mientras el usuario esté en `PageInicio` y el ancho de pantalla sea menor a `smallScreenMin`, cuando se construya la grid de opciones, el sistema deberá renderizar tarjetas adaptadas manteniendo la legibilidad de textos e imágenes sin recortes, y mientras esté en pantallas anchas, deberá mostrar los botones de Filtros y Buscar en la `AppBar`.

---

## 8. Diagrama de Flujo de Datos

```
┌─────────────────────────────────────────────────────────────────┐
│              PrincipalSliversMenuInicial (build)                │
│                                                                 │
│  ┌─────────────┐    ┌──────────────┐    ┌──────────────────┐  │
│  │ initState   │    │  Listeners   │    │  Conditional UI  │  │
│  │             │    │              │    │                  │  │
│  │ _inicializar│    │ homeNav:     │    │  indiceInicial:  │  │
│  │ SoloControl │    │ jumpTo(0)    │    │  0 → PageInicio  │  │
│  │ adores()    │    │              │    │  1 → Propiedades │  │
│  │             │    │ checaConex:  │    │  2 → Ubicación   │  │
│  │ Post-frame: │    │ nav sinconecc│    │  3 → Mi Cuenta   │  │
│  │ - Session   │    │              │    │  4 → Perfil      │  │
│  │ - UserData  │    │              │    │                  │  │
│  │ - Avatar    │    │              │    │                  │  │
│  │ - Negocio   │    │              │    │                  │  │
│  │ - Location  │    │              │    │                  │  │
│  └─────────────┘    └──────────────┘    └──────────────────┘  │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
              ┌───────────────────────────────┐
              │     homeNavigationProvider     │
              │  ┌─────────────────────────┐  │
              │  │ HomeState (Freezed)     │  │
              │  │ indiceInicial: int      │  │
              │  │ indicePrincipal: int    │  │
              │  │ indiceNivelGobierno: int│  │
              │  │ indiceTipoEspacio: int  │  │
              │  │ indiceTipoTransaccion:  │  │
              │  │ indiceMiCuenta: int     │  │
              │  │ indiceMiCuentaUsuario:  │  │
              │  │ version: int            │  │
              │  └─────────────────────────┘  │
              └───────────────────────────────┘
                              │
              ┌───────────────┼───────────────┐
              ▼               ▼               ▼
      ┌─────────────┐ ┌─────────────┐ ┌─────────────┐
      │ sessionProv │ │checaConexProv│ │ubicacionActProv│
      │ isAuth      │ │etiqueta     │ │permisos      │
      │ nombrePerfil│ │icono        │ │codigoPostal  │
      │ esPromotor  │ │             │ │              │
      │ esUsuario   │ │             │ │              │
      └─────────────┘ └─────────────┘ └─────────────┘
                              │
                              ▼
              ┌───────────────────────────────┐
              │    appBarPrincipal()           │
              │  ┌─────────────────────────┐  │
              │  │ Botones condicionales:  │  │
              │  │ - Conexión (icono/color)│  │
              │  │ - Localización          │  │
              │  │ - Filtros/Buscar (>=600)│  │
      │  │ - Notificaciones/Ayuda   │  │
      │  │ - Usuario (avatar/login) │  │
      │  └─────────────────────────┘  │
      └───────────────────────────────┘
                              │
                              ▼
              ┌───────────────────────────────┐
              │     PageInicio                 │
              │  ┌─────────────────────────┐  │
              │  │ Fondo: menuOpciones[0]  │  │
      │  │ Degradado oscuro         │  │
      │  │ Grid: Wrap(cards)        │  │
      │  │ Navegación: listaLandingP│  │
      │  │ ages o SnackBar "Próx."  │  │
      │  │ Hover: _HoverScaleCard   │  │
      │  └─────────────────────────┘  │
      └───────────────────────────────┘
                              │
                              ▼
              ┌───────────────────────────────┐
              │     MenuDrawer                 │
              │  ┌─────────────────────────┐  │
      │  │ Header: logo + nombre    │  │
      │  │ Salir (exitApp)          │  │
      │  │ Principal (pop drawer)   │  │
      │  │ Favoritos / Ver después  │  │
      │  │ Preferencias             │  │
      │  │ Configuración (OS detect)│  │
      │  │ Acerca de (versión)      │  │
      │  │ Contacto (email + X)     │  │
      │  └─────────────────────────┘  │
      └───────────────────────────────┘
```

---

## 9. Mapa de Correspondencia Elemento → Comportamiento

### Pantalla Principal y Navegación

| Elemento | Archivo | Comportamiento |
|---|---|---|
| `PrincipalSliversMenuInicial` | `principal_sliver_screen_menus_inicio.dart` | Widget raíz; renderiza `Scaffold` con `AppBar`, `Drawer` y `CustomScrollView` condicional |
| Inicialización síncrona | `principal_sliver_screen_menus_inicio.dart` | `_inicializarSoloControladores()` crea 7 `TabController` antes del primer frame |
| Post-frame callback | `principal_sliver_screen_menus_inicio.dart` | Restaura sesión, carga datos de usuario, avatar y lógica de negocio después del render |
| Trigger de ubicación | `principal_sliver_screen_menus_inicio.dart` | `_triggerLocationUpdate()` solicita permisos, obtiene CP y actualiza `indiceNivelGobierno` a 3 |
| ScrollController | `principal_sliver_screen_menus_inicio.dart` | Se dispone en `dispose()`; salta al inicio al cambiar de sección |
| Bandera `_isErrorPageOpen` | `principal_sliver_screen_menus_inicio.dart` | Previene apertura múltiple de pantalla de error |

### Secciones por Índice

| Índice | Sección | Contenido | Sub-vistas |
|---|---|---|---|
| 0 | Inicio | `PageInicio` | Grid de `MenuOption` |
| 1 | Propiedades | `menuSuperiorMenuPrincipal` + `PaginaBuscaEspacios` | `indicePrincipal` 0–3 |
| 2 | Ubicación | `PaginaPrincipalListaLocalidades` | — |
| 3 | Mi Cuenta | Depende del perfil | Ver tabla inferior |
| 4 | Perfil | `PaginaPerfilWidget` | — |

### Mi Cuenta — Promotor

| Índice | Sub-vista | Scroll |
|---|---|---|
| 0 | `PaginaTusEspacios` | Habilitado |
| 1 | `PageMisListas` | Deshabilitado |
| 2 | `GruposView` + userId/userName | Habilitado |
| 3 | `ConocidosView` + userId/userName | Habilitado |

### Mi Cuenta — Usuario

| Índice | Sub-vista | Scroll |
|---|---|---|
| 0 | `PageMisListas` | Deshabilitado |
| 1 | `GruposView` + userId/userName | Habilitado |
| 2 | `ConocidosView` + userId/userName | Habilitado |

### Barra de Aplicación

| Botón | Ícono | Condición | Acción |
|---|---|---|---|
| Conexión | `coneccion.icono` / `signal_wifi_bad` / loading | Reactivo a `checaConeccionesProvider` | Navega a `/checaconeccion` |
| Localización | `Symbols.pin_drop` | Siempre visible | Navega a `/localidades` o muestra error si `permisodelocalizacion == 0` |
| Filtros | `Symbols.filter_list` | Solo `screenWidth > smallScreenMin` | Sin acción (`() {}`) |
| Notificaciones | `Symbols.notifications` | Siempre visible | Sin acción (`() {}`) |
| Buscar | `Symbols.search` | Solo `screenWidth > smallScreenMin` | Sin acción (`() {}`) |
| Ayuda | `Symbols.help_outline` | Siempre visible | Sin acción (`() {}`) |
| Usuario | `iconNoUser` / `CircleAvatar` / `iconUser` | Según sesión y avatar | Login dialog o navegación a Perfil/Mi Cuenta |

### Drawer

| Ítem | Ícono | Acción |
|---|---|---|
| Salir | `Symbols.exit_to_app` | `exitApp()` |
| Principal | `Symbols.home` | `Navigator.pop()` |
| Favoritos | `Symbols.star` | `Navigator.pop()` (sin acción) |
| Ver después | `Symbols.bookmark` | `Navigator.pop()` (sin acción) |
| Preferencias | `Symbols.manage_accounts` | `AppRoutes.preferencias` |
| Configuración | `Symbols.settings` | `setCheckPlataformaProvider` + `AppRoutes.plataforma` |
| Acerca de... | Logo BuscoBien | Diálogo con `versionActual` |
| Contacto | `Symbols.forum` | Diálogo con email y X |

---

## 10. Decisiones de Diseño Documentadas

| ID | Decisión | Justificación |
|---|---|---|
| DD-01 | Inicialización de controladores en `initState` síncrono | Evita `LateInitializationError`; los `TabController` deben estar listos antes del primer build que los necesite |
| DD-02 | Lógica de negocio en post-frame callback | Previene conflictos de estado durante el primer render; garantiza que el widget esté montado antes de mutar providers |
| DD-03 | `_triggerLocationUpdate()` en `initState` sin `await` | No bloquea la inicialización de la UI; la geolocalización corre en paralelo con la carga del menú |
| DD-04 | `_isErrorPageOpen` como bandera booleana | Previene duplicación de pantallas de error ante parpadeos de conectividad |
| DD-05 | `ScrollController.jumpTo(0)` en listener de navegación | Sincroniza la posición del scroll con cambios de sección sin animación |
| DD-06 | `hasScrollBody` condicional por sub-vista | Optimiza el comportamiento de scroll: `true` para contenido largo (Espacios, Grupos, Conocidos), `false` para pantallas ajustadas |
| DD-07 | Navegación a "Mi Cuenta" o "Propiedades" según resultado de login | Si el usuario ingresa, va directamente a su cuenta; si cancela, lo envía al flujo de propiedades por defecto |
| DD-08 | Filtros y Buscar ocultos en pantallas pequeñas | Preserva espacio en móviles; estas funciones son menos críticas que la navegación principal |
| DD-09 | `exitApp()` en Drawer en lugar de `Navigator.pop` | Cierra la aplicación completamente, no solo el drawer, cumpliendo la expectativa del usuario |
| DD-10 | `listaLandingPages` y `menuOpciones` en archivo separado | Separa los datos de configuración del widget de presentación; facilita mantenimiento y pruebas |
| DD-11 | Tarjetas con `_HoverScaleCard` y animación de 150 ms | Proporciona feedback visual inmediato sin retraso perceptible; el rango `0.04` es sutil pero notable |
| DD-12 | Transición `FadeTransition` de 400 ms para landing pages | Transición suave que no distrae del contenido pero diferencia la navegación a secciones especiales |
| DD-13 | `AppRoutes.sinconeccion` con mensaje diferente al splash | En pantalla principal el mensaje es "Se perdió la conexión a Internet."; en splash es "No se detectó conexión a Internet." |

---

*Generado por ingeniería inversa — BuscoBien SDD v1.0 — 2026-08-06*
