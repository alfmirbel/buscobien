# SDD — Módulo main (BuscoBien)
## Especificación de Requerimientos (EARS)
**Archivo fuente:** `lib/main.dart`  
**Arquitectura:** Flutter + Material Design 3 + Riverpod + url_strategy  
**Propósito:** Punto de entrada de la aplicación, configuración global de tema, rutas, deep links y estado Riverpod

---

## 1. Requerimientos Ubicuos

### 1.1 Inicialización de la Aplicación
- **REQ-MAIN-001:** El sistema deberá ejecutar `WidgetsFlutterBinding.ensureInitialized()` antes de cualquier operación de UI.
- **REQ-MAIN-002:** El sistema deberá ejecutar `setPathUrlStrategy()` para habilitar URLs limpias en Web.
- **REQ-MAIN-003:** El sistema deberá establecer las orientaciones permitidas a `DeviceOrientation.portraitUp` y `DeviceOrientation.portraitDown`.
- **REQ-MAIN-004:** El sistema deberá inicializar el contador global `lcwc` en 0.
- **REQ-MAIN-005:** El sistema deberá envolver la aplicación en `ProviderScope` de Riverpod.
- **REQ-MAIN-006:** El sistema deberá crear un `GlobalKey<NavigatorState>` como `navigatorKey` para navegación programática.
- **REQ-MAIN-007:** El sistema deberá ejecutar `runApp(const ProviderScope(child: BuscoBienApp()))` para iniciar el widget raíz.

### 1.2 Configuración de MaterialApp
- **REQ-MAIN-008:** El sistema deberá crear un `MaterialApp` como widget raíz de la aplicación.
- **REQ-MAIN-009:** El sistema deberá asignar `navigatorKey` al `MaterialApp`.
- **REQ-MAIN-010:** El sistema deberá ocultar el banner de debug con `debugShowCheckedModeBanner: false`.
- **REQ-MAIN-011:** El sistema deberá establecer el título de la aplicación como `appName`.
- **REQ-MAIN-012:** El sistema deberá establecer la ruta inicial como `AppRoutes.main` (`"/"`).
- **REQ-MAIN-013:** El sistema deberá registrar `routeGenerate` como generador de rutas personalizado en `onGenerateRoute`.

### 1.3 Configuración de Tema
- **REQ-MAIN-014:** El sistema deberá usar `ThemeData` con `useMaterial3: true`.
- **REQ-MAIN-015:** El sistema deberá establecer el brillo del tema a `Brightness.light`.
- **REQ-MAIN-016:** El sistema deberá aplicar `NavigationBarThemeData` personalizado para la barra de navegación inferior.
- **REQ-MAIN-017:** El sistema deberá aplicar `IconThemeData` global con color `appTheme.onPrimaryContainer`.
- **REQ-MAIN-018:** El sistema deberá usar `appTheme` (ColorScheme) como fuente de colores global.

### 1.4 Sistema de Debug
- **REQ-MAIN-019:** El sistema deberá registrar eventos de inicialización en el sistema de debug con `debugPrintLevels(1, ...)`.
- **REQ-MAIN-020:** El sistema deberá registrar eventos de generación de rutas con `debugPrintLevels(1, ...)`.

---

## 2. Requerimientos Controlados por Eventos

### 2.1 Inicialización de la Aplicación
- **REQ-INIT-001:** Cuando el usuario ejecuta la aplicación, el sistema deberá inicializar bindings de Flutter.
- **REQ-INIT-002:** Cuando el usuario abre la aplicación en Web, el sistema deberá configurar URLs limpias.
- **REQ-INIT-003:** Cuando el usuario abre la aplicación, el sistema deberá bloquear orientaciones landscape.
- **REQ-INIT-004:** Cuando el sistema inicia, el sistema deberá resetear el contador de debug `lcwc`.

### 2.2 Configuración de Navegación
- **REQ-NAV-001:** Cuando el sistema necesita navegar a una ruta, el sistema deberá ejecutar `routeGenerate(route)`.
- **REQ-NAV-002:** Cuando el sistema genera una ruta, el sistema deberá registrar el nombre de la ruta en debug.
- **REQ-NAV-003:** Cuando el usuario accede a la aplicación, el sistema deberá mostrar la ruta inicial `AppRoutes.main`.

### 2.3 Inicialización de Deep Links
- **REQ-DEEP-001:** Cuando el primer frame se completa, el sistema deberá ejecutar `initDeepLinkHandler(navigatorKey)`.
- **REQ-DEEP-002:** Cuando la aplicación se ejecuta en Web, el sistema deberá parsear la URL base con `Uri.base`.
- **REQ-DEEP-003:** Cuando la aplicación se ejecuta en Mobile/Desktop, el sistema deberá escuchar enlaces entrantes con `AppLinks`.
- **REQ-DEEP-004:** Cuando se recibe un enlace de recuperación, el sistema deberá extraer `token` y `perfil` de los query parameters.
- **REQ-DEEP-005:** Cuando el enlace contiene `/recuperar`, el sistema deberá navegar a `AppRoutes.cambioPassword` con los argumentos.

### 2.4 Navegación por Items de Barra
- **REQ-NAV-006:** Cuando un item de `NavigationBar` está seleccionado, el sistema deberá aplicar color `appTheme.onPrimary` al icono.
- **REQ-NAV-007:** Cuando un item de `NavigationBar` no está seleccionado, el sistema deberá aplicar color `appTheme.primary` al icono.
- **REQ-NAV-008:** Cuando un item está seleccionado, el sistema deberá aplicar estilo bold y tamaño `fontSizeMenuBar` al texto.
- **REQ-NAV-009:** Cuando un item no está seleccionado, el sistema deberá aplicar estilo normal y tamaño `fontSizeMenuBar` al texto.

---

## 3. Requerimientos Controlados por Estados

### 3.1 Estado: Modo Claro (Light Theme)
- **REQ-LIGHT-001:** Mientras la aplicación está en modo claro, el sistema deberá usar `Brightness.light`.
- **REQ-LIGHT-002:** Mientras la aplicación está en modo claro, el sistema deberá usar `appTheme` con `lightPAN` como base.
- **REQ-LIGHT-003:** Mientras la aplicación está en modo claro, el sistema deberá mostrar iconos con color `appTheme.onPrimaryContainer`.

### 3.2 Estado: Modo Oscuro (Dark Theme)
- **REQ-DARK-001:** Mientras la aplicación está en modo oscuro, el sistema debería usar `Brightness.dark`.
- **REQ-DARK-002:** Mientras la aplicación está en modo oscuro, el sistema debería usar un `ColorScheme` oscuro (actualmente comentado en código).
- **REQ-DARK-003:** Mientras la aplicación está en modo oscuro, el sistema debería mostrar iconos con color `appTheme.onPrimaryContainer`.

### 3.3 Estado: Selección de Navegación
- **REQ-SEL-001:** Mientras un item está seleccionado, el sistema deberá mostrar el icono con `appTheme.onPrimary`.
- **REQ-SEL-002:** Mientras un item no está seleccionado, el sistema deberá mostrar el icono con `appTheme.primary`.
- **REQ-SEL-003:** Mientras un item está seleccionado, el sistema deberá mostrar el texto en bold.
- **REQ-SEL-004:** Mientras un item no está seleccionado, el sistema deberá mostrar el texto en normal.

### 3.4 Estado: Session Activa
- **REQ-SESSION-001:** Mientras la aplicación está corriendo, el sistema deberá mantener `ProviderScope` activo.
- **REQ-SESSION-002:** Mientras la aplicación está corriendo, el sistema deberá mantener `navigatorKey` disponible para navegación programática.

---

## 4. Requerimientos de Comportamiento No Deseado

### 4.1 Errores de Inicialización
- **REQ-ERR-001:** Si `WidgetsFlutterBinding.ensureInitialized()` falla, entonces el sistema deberá detener la ejecución.
- **REQ-ERR-002:** Si `setPathUrlStrategy()` no está disponible, entonces el sistema deberá continuar sin URLs limpias (no crítico en móvil).
- **REQ-ERR-003:** Si la ruta solicitada no existe en `routeGenerate`, entonces el sistema deberá retornar `null`.

### 4.2 Errores de Deep Links
- **REQ-ERR-004:** Si el deep link no contiene `/recuperar`, entonces el sistema deberá ignorar el enlace.
- **REQ-ERR-005:** Si el deep link no contiene `token` o `perfil`, entonces el sistema deberá ignorar el enlace.
- **REQ-ERR-006:** Si `navigatorKey.currentState` es nulo, entonces el sistema no podrá navegar programáticamente.

### 4.3 Errores de Rutas
- **REQ-ERR-007:** Si `settings.name` no coincide con ninguna ruta conocida, entonces el sistema deberá retornar `null` desde `routeGenerate`.
- **REQ-ERR-008:** Si `settings.arguments` no se puede castear al tipo esperado, entonces el sistema deberá lanzar una excepción de casteo.

---

## 5. Requerimientos de Funciones Opcionales

### 5.1 Deep Links en Web
- **REQ-OPT-001:** Donde la aplicación se ejecuta en Web, el sistema deberá habilitar el manejo de deep links mediante `Uri.base`.
- **REQ-OPT-002:** Donde la aplicación se ejecuta en Mobile, el sistema deberá habilitar el manejo de deep links mediante `app_links`.

### 5.2 URLs Limpias en Web
- **REQ-OPT-003:** Donde la aplicación se ejecuta en Web, el sistema deberá usar `setPathUrlStrategy()` para eliminar el `#` de las URLs.
- **REQ-OPT-004:** Donde la aplicación se ejecuta en Mobile, el sistema deberá ignorar `setPathUrlStrategy()`.

### 5.3 Sistema de Debug
- **REQ-OPT-005:** Donde se requiere depuración, el sistema deberá usar `debugPrintLevels` para registrar eventos.
- **REQ-OPT-006:** Donde se requiere tracing de inicialización, el sistema deberá activar nivel 1 con prefijo "LYFECYCLE".

---

## 6. Requerimientos Complejos

### 6.1 Flujo de Inicialización de la Aplicación
- **REQ-COM-001:** Mientras el usuario ejecuta la aplicación, cuando el sistema inicia `main()`, entonces deberá inicializar bindings, configurar URLs limpias, establecer orientaciones verticales, resetear contador de debug, envolver en `ProviderScope` y ejecutar `BuscoBienApp`.

### 6.2 Flujo de Configuración de Tema y Navegación
- **REQ-COM-002:** Mientras el sistema construye `MaterialApp`, cuando aplica el tema, entonces deberá configurar `ThemeData` con M3, brillo claro, `NavigationBarThemeData` personalizado, `IconThemeData` global y título de la app.

### 6.3 Flujo de Navegación Inicial
- **REQ-COM-003:** Mientras el usuario abre la aplicación, cuando `MaterialApp` se construye, entonces deberá establecer ruta inicial `AppRoutes.main`, generar la ruta con `routeGenerate` y mostrar `SplashPage` que navega a `PrincipalSliversMenuInicial`.

### 6.4 Flujo de Deep Links
- **REQ-COM-004:** Mientras la aplicación se ejecuta, cuando el usuario abre un deep link de recuperación, entonces deberá detectar la plataforma, parsear el enlace, extraer token y perfil, y navegar a `cambioPassword` con los argumentos.

---

## 7. Modelos de Datos y Estructuras

### 7.1 Argumentos de Ruta
| Ruta | Tipo de Argumento | Descripción |
|------|-------------------|-------------|
| `AppRoutes.sinconeccion` | `String` | Mensaje de conexión |
| `AppRoutes.checaconeccion` | `Map<String, dynamic>` | Datos de verificación de conexión |
| `AppRoutes.listalocalidades` | `int` | ID de localidad |
| `AppRoutes.editaespacio` | `ValueEspaciosCasaGet` | Datos del espacio a editar |
| `AppRoutes.preferencias` | `String` | Parámetros de preferencias |
| `AppRoutes.carouselfotospropiedad` | `ValueEspaciosCasaGet` | Datos del espacio para carousel |
| `AppRoutes.fotospropiedad` | `ValueEspaciosCasaGet` | Datos del espacio para fotos |
| `AppRoutes.fotospropiedadpaginada` | `ValueEspaciosCasaGet` | Datos del espacio para fotos paginadas |
| `AppRoutes.agregamultiplesfotos` | `Map<String, dynamic>` | Datos para agregar fotos |
| `AppRoutes.mapapropiedades` | `EspaciosCasaGet` | Lista de propiedades para mapa |
| `AppRoutes.cambioPassword` | `Map<String, String>` | Token y perfil para cambio de contraseña |

### 7.2 Estructura de Navegación
```
MaterialApp
├── navigatorKey: GlobalKey<NavigatorState>
├── initialRoute: AppRoutes.main ("/")
├── onGenerateRoute: routeGenerate
│   ├── "/" → SplashPage → PrincipalSliversMenuInicial
│   ├── "/splash" → SplashPage → PrincipalSliversMenuInicial
│   ├── "/principal" → PrincipalSliversMenuInicial
│   ├── "/login" → LoginScreen
│   ├── "/loginuser" → LoginUser
│   ├── "/registro" → RegisterScreenUsers
│   ├── "/perfil" → PaginaPerfilWidget
│   ├── "/preferencias" → PaginaColores
│   ├── ... (30+ rutas)
│   └── default → null
└── Deep Link Handler
    ├── Web: Uri.base → /recuperar?token=X&perfil=Y
    └── Mobile: AppLinks → /recuperar?token=X&perfil=Y
```

---

## 8. Widgets y Componentes Documentados

### 8.1 BuscoBienApp (StatefulWidget)
| Propiedad | Tipo | Descripción |
|-----------|------|-------------|
| `navigatorKey` | `GlobalKey<NavigatorState>` | Clave global para navegación programática |
| `initState()` | `void` | Inicializa `initDeepLinkHandler` post-frame |
| `build()` | `Widget` | Construye `MaterialApp` con tema y rutas |

### 8.2 MaterialApp
| Propiedad | Valor | Descripción |
|-----------|-------|-------------|
| `navigatorKey` | `navigatorKey` | Navegador global |
| `debugShowCheckedModeBanner` | `false` | Oculta banner debug |
| `theme.useMaterial3` | `true` | Habilita Material Design 3 |
| `theme.brightness` | `Brightness.light` | Tema claro por defecto |
| `theme.navigationBarTheme` | Personalizado | Estilos de NavigationBar |
| `theme.iconTheme` | `appTheme.onPrimaryContainer` | Color global de iconos |
| `title` | `appName` | Nombre de la app |
| `initialRoute` | `AppRoutes.main` | Ruta inicial |
| `onGenerateRoute` | `routeGenerate` | Generador de rutas personalizado |

---

## 9. Reglas de Negocio

- **RN-MAIN-001:** La aplicación siempre inicia en orientación vertical, independientemente del dispositivo.
- **RN-MAIN-002:** El contador `lcwc` se resetea a 0 en cada inicio de aplicación.
- **RN-MAIN-003:** El tema por defecto es claro (`Brightness.light`) con la paleta `lightPAN`.
- **RN-MAIN-004:** La barra de navegación inferior usa `appTheme.primary` para items no seleccionados y `appTheme.onPrimary` para el item seleccionado.
- **RN-MAIN-005:** Los iconos globales usan `appTheme.onPrimaryContainer` como color por defecto.
- **RN-MAIN-006:** El título de la app en el sistema operativo es "buscobien".
- **RN-MAIN-007:** La ruta inicial siempre es "/" (AppRoutes.main), que muestra SplashPage.
- **RN-MAIN-008:** Los deep links de recuperación solo se procesan si contienen `/recuperar` en el path.
- **RN-MAIN-009:** Los deep links requieren tanto `token` como `perfil` en query parameters para ser válidos.
- **RN-MAIN-010:** El sistema de debug registra eventos de inicialización y navegación con nivel 1 y prefijo "LYFECYCLE".

---

## 10. Estructura de Archivos

```
lib/
├── main.dart                          # Punto de entrada y configuración global
├── 07_routes/
│   ├── app_routes.dart                # Constantes de rutas y routeGenerate
│   └── deep_link_handler.dart         # Manejo de deep links (Web + Mobile)
├── 20_var_globales/
│   ├── var_color_themes.dart          # ColorSchemes (lightPAN, darkPAN, lightINE, etc.)
│   ├── var_login.dart                 # appName, iconos de usuario
│   ├── variables_globales.dart        # Constantes de tamaño, fuente, flags
│   └── var_de_estilo_widgets.dart     # Estilos de AppBar, TabBar
└── 60_global_widgets/
    └── debugprint.dart                # Sistema de debug por niveles 0-20
```

---

## 11. Dependencias Técnicas

- **Flutter:** `MaterialApp`, `SystemChrome`, `DeviceOrientation`, `debugPrint`, `WidgetsFlutterBinding`
- **Flutter Riverpod:** `ProviderScope`
- **url_strategy:** `setPathUrlStrategy()`
- **app_links:** `AppLinks` para deep links en Mobile
- **BuscoBien Modules:**
  - `07_routes/app_routes.dart` — `AppRoutes`, `routeGenerate`
  - `07_routes/deep_link_handler.dart` — `initDeepLinkHandler`
  - `20_var_globales/var_color_themes.dart` — `appTheme`
  - `20_var_globales/var_login.dart` — `appName`
  - `20_var_globales/variables_globales.dart` — `fontSizeMenuBar`, `socialAppBarHeight`, `fontSizeTituloPagina`
  - `20_var_globales/var_de_estilo_widgets.dart` — `appBarSecondPage()`
  - `60_global_widgets/debugprint.dart` — `lcwc`, `debugPrintLevels`

---

## 12. Consideraciones de UI

### 12.1 Tema de Navegación Inferior
| Estado del Item | Color de Icono | Estilo de Texto |
|-----------------|----------------|-----------------|
| Seleccionado | `appTheme.onPrimary` | Bold, `fontSizeMenuBar` (12.0) |
| No seleccionado | `appTheme.primary` | Normal, `fontSizeMenuBar` (12.0) |

### 12.2 Tema Global de Iconos
| Propiedad | Valor |
|-----------|-------|
| Color | `appTheme.onPrimaryContainer` |
| Fill | 0 |
| Weight | 400 |
| Optical Size | 24 |
| Size | 24 |

### 12.3 Orientación
| Orientación | Estado |
|-------------|--------|
| Portrait Up | Permitida |
| Portrait Down | Permitida |
| Landscape Left | Bloqueada |
| Landscape Right | Bloqueada |

---

## 13. Flujos de Usuario Principales

### 13.1 Flujo de Inicio de la Aplicación
1. Usuario ejecuta la aplicación
2. `main()` inicializa bindings de Flutter
3. `main()` configura URLs limpias (Web)
4. `main()` establece orientación vertical
5. `main()` resetea contador de debug
6. `main()` envuelve en `ProviderScope`
7. `runApp()` ejecuta `BuscoBienApp`
8. `BuscoBienApp.build()` construye `MaterialApp`
9. `MaterialApp` muestra ruta inicial `/` (SplashPage)
10. SplashPage navega a `PrincipalSliversMenuInicial`

### 13.2 Flujo de Navegación
1. Usuario interactúa con la interfaz
2. Sistema ejecuta `Navigator.pushNamed()` via `navigatorKey`
3. `MaterialApp.onGenerateRoute` recibe la ruta
4. Sistema registra la ruta en debug
5. `routeGenerate()` mapea la ruta al widget correspondiente
6. Sistema muestra la pantalla destino

### 13.3 Flujo de Deep Links
1. Usuario hace clic en un enlace de recuperación
2. Sistema detecta la plataforma (Web/Mobile)
3. Web: parsea `Uri.base`; Mobile: escucha `AppLinks`
4. Sistema verifica que el path contenga `/recuperar`
5. Sistema extrae `token` y `perfil` de query parameters
6. Sistema navega a `cambioPassword` con los argumentos
7. Usuario visualiza la pantalla de cambio de contraseña
