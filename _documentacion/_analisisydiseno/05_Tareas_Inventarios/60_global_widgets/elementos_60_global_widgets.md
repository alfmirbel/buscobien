# Inventario de Componentes — 60_global_widgets

**Directorio:** `lib/60_global_widgets/`  
**Archivos:** `bottom_fijo.dart`, `debugprint.dart`, `derechos_reservados.dart`, `dialogbox_mensaje_general.dart`, `future_builder_state_widgets.dart`, `genera_cantidad_monetaria.dart`  
**Fecha:** 2026-08-12

---

## Tabla 1: Componentes (por archivo)

| Subdirectorio | Nombre del archivo | Tipo de componente | Nombre del componente | Parámetros que requiere | Variables que utiliza | Variables internas | Estilos que le aplican |
|---------------|-------------------|-------------------|----------------------|------------------------|----------------------|-------------------|------------------------|
| 60_global_widgets | `bottom_fijo.dart` | StatelessWidget | `MyButton` | `String texto` | `appTheme`, `MaterialSymbols` | — | `TextButton`, `Container 200x40`, `Elevation 5` |
| 60_global_widgets | `bottom_fijo.dart` | StatelessWidget | `MyTextField` | `String label, IconData prefixIcon, TextEditingController? controller` | `appTheme`, `MaterialSymbols` | — | `TextField`, `OutlineInputBorder`, `Comfortaa` |
| 60_global_widgets | `bottom_fijo.dart` | StatelessWidget | `SquareTile` | `String imagePath` | `appTheme` | — | `Image.asset`, `Container 60x60`, `Border` |
| 60_global_widgets | `bottom_fijo.dart` | StatefulWidget | `MyTextFieldPassword` | `String label, IconData prefixIcon, TextEditingController? controller` | `appTheme`, `MaterialSymbols`, `isHidden*` (globals) | `_MyTextFieldPasswordState` | `TextField`, `IconButton` toggle visibility |
| 60_global_widgets | `debugprint.dart` | Variables + Función | `debugPrintLevels` | `int level, String mensaje` | `level00`–`level20` (21 bools), `lcwc` | — | `print()` condicional |
| 60_global_widgets | `derechos_reservados.dart` | Funciones top-level | `derechosReservadosClaro()`, `derechosReservadosObscuro()` | — | `appTheme` | — | `Column`, `Text`, `Comfortaa`, size 10 |
| 60_global_widgets | `dialogbox_mensaje_general.dart` | Función top-level | `showMessageDialog` | `context, title, message, color, alineacion, boton` | `appTheme` | — | `showDialog`, `AlertDialog`, `ElevatedButton` |
| 60_global_widgets | `future_builder_state_widgets.dart` | 8 Funciones top-level | `stateNone/Waiting/Active/Error/ErrorFormat` + `FS` variants | `w, l` (ancho/alto) o solo `error` | `appTheme`, `debugPrintLevels(9)` | — | `Container`, `Center`, `CircularProgressIndicator`, `Text` |
| 60_global_widgets | `genera_cantidad_monetaria.dart` | Funciones top-level | `generaCantidad`, `formatoCantidad` | `String cantidad, int min, int max` / `int monto` | `Random`, `debugPrintLevels` | — | `toString()`, `padLeft()` |

---

## Tabla 2: Elementos (por archivo)

| Subdirectorio | Nombre del archivo | Variables definidas en el archivo | Clases | Variables de la clase | Funciones o widgets definidos en la clase | Variables que utiliza | Llamadas a otras clases o widgets |
|---------------|-------------------|----------------------------------|--------|----------------------|------------------------------------------|----------------------|----------------------------------|
| 60_global_widgets | `bottom_fijo.dart` | `isHidden`, `isHiddenCampoUser`, `isHiddenValidaClave`, `isHiddenClaveUser` (globals mutables) | `MyButton` | `texto` | `build()` | `appTheme`, `Symbols` | `TextButton`, `Container`, `Text` |
| 60_global_widgets | `bottom_fijo.dart` | — | `MyTextField` | `label, prefixIcon, controller` | `build()` | `appTheme`, `Symbols` | `TextField`, `InputDecoration`, `OutlineInputBorder` |
| 60_global_widgets | `bottom_fijo.dart` | — | `SquareTile` | `imagePath` | `build()` | `appTheme` | `Image.asset`, `Container`, `Border` |
| 60_global_widgets | `bottom_fijo.dart` | — | `MyTextFieldPassword` | `label, prefixIcon, controller` | `createState()`, `_MyTextFieldPasswordState.build()`, `_toggleVisibility()` | `appTheme`, `Symbols`, `isHidden*` globals | `TextField`, `IconButton`, `setState()` |
| 60_global_widgets | `debugprint.dart` | `level00`–`level20` (21 bool), `lcwc` | — | — | `debugPrintLevels(int level, String mensaje)` | `levelXX` bools | `print()` |
| 60_global_widgets | `derechos_reservados.dart` | — | — | — | `derechosReservadosClaro()`, `derechosReservadosObscuro()` | `appTheme` | `Column`, `Text` |
| 60_global_widgets | `dialogbox_mensaje_general.dart` | — | — | — | `showMessageDialog(context, title, message, color, alineacion, boton)` | `appTheme` | `showDialog`, `AlertDialog`, `ElevatedButton`, `Navigator.pop()` |
| 60_global_widgets | `future_builder_state_widgets.dart` | — | — | — | `stateNone(w,l)`, `stateWaiting(w,l)`, `stateActive(w,l)`, `stateError(w,l,error)`, `stateErrorFormat(w,l,error)` + `FS` variants | `appTheme`, `debugPrintLevels(9)` | `Container`, `Center`, `CircularProgressIndicator`, `Text` |
| 60_global_widgets | `genera_cantidad_monetaria.dart` | — | — | — | `generaCantidad(cantidad, min, max)`, `formatoCantidad(monto)` | `Random`, `debugPrintLevels` | `toString()`, `padLeft(2,'0')`, `~/` (div entera) |

---

# Inventario de Componentes — 20_var_globales

**Directorio:** `lib/20_var_globales/`  
**Archivos:** 9 archivos  
**Fecha:** 2026-08-12

---

## Tabla 1: Componentes (por archivo)

| Subdirectorio | Nombre del archivo | Tipo de componente | Nombre del componente | Parámetros que requiere | Variables que utiliza | Variables internas | Estilos que le aplican |
|---------------|-------------------|-------------------|----------------------|------------------------|----------------------|-------------------|------------------------|
| 20_var_globales | `var_color_themes.dart` | Variable global + 18 const ColorScheme | `appTheme`, `lightPAN`, `darkPAN`, `lightINE`, `darkINE`... | — | `ColorScheme` (29 props c/u) | `appTheme = lightPAN` (mutable) | `TabBarThemeData tabBarTheme` |
| 20_var_globales | `var_color_widget.dart` | Variables + Funciones | Breakpoints M3, `isMobile/isTablet/isDesktop` | `double width` / `BuildContext` | `MediaQuery` | — | — |
| 20_var_globales | `variables_globales.dart` | 30+ const + 40+ vars mutables | `fontSizeMenuBar`, `navBarHeight`, `selectMenuNivelGobierno`, `showFiltros`, `boolEstado`... | — | — | 70+ variables top-level | — |
| 20_var_globales | `var_de_estilo_widgets.dart` | TextStyles + AppBar factories | `ButtonsTabBarLabelStyle`, `appBarSecondPage`, `appBarSecondPageBottons`, `appBarSecondPageActions` | `String titulo`, `TabBar?`, `List<Widget>?` | `variables_globales`, `var_elementos_menus`, `var_color_themes` | — | `TextStyle`, `AppBar`, `TabBar` |
| 20_var_globales | `var_elementos_menus.dart` | Clases + 150+ instancias | `ElementosMenus`, `ElementoSeleccionado` + listas por menú | `String etiqueta, IconData icono` | `MaterialSymbols` | 150+ objetos | — |
| 20_var_globales | `var_login.dart` | Constantes | `appName`, `iconNoUser`, `iconUser`, `userTooltip` | — | `MaterialSymbols` | — | — |
| 20_var_globales | `format_chat_timestamp.dart` | Función top-level | `formatChatTimestamp` | `String iso` | `DateTime`, `intl` implícito | — | — |
| 20_var_globales | `couchdb_errors.dart` | Clase + Maps | `CouchdbCodigo`, `codigoCouchDB`, `listaCodigosCouchDB`, `listaCodigosCouchDBEn` | `int codigo, String label, description` | — | 19 códigos HTTP | — |
| 20_var_globales | `ui_exceptions.dart` | Documentación + Constante | `loginPrimaryBrand = Color(0xFF415AA9)` | — | — | — | — |

---

## Tabla 2: Elementos (por archivo)

| Subdirectorio | Nombre del archivo | Variables definidas en el archivo | Clases | Variables de la clase | Funciones o widgets definidos en la clase | Variables que utiliza | Llamadas a otras clases o widgets |
|---------------|-------------------|----------------------------------|--------|----------------------|------------------------------------------|----------------------|----------------------------------|
| 20_var_globales | `var_color_themes.dart` | `appTheme`, 18 `ColorScheme` const, `tabBarTheme` | — | — | — | — | Consumido por TODA la UI |
| 20_var_globales | `var_color_widget.dart` | 8 breakpoints const, `screenWidth`, `screenHeight` | — | — | `isMobile(width)`, `isTablet(width)`, `isDesktop(width)`, `isMobile(context)`, `isTablet(context)`, `isDesktop(context)` | `MediaQuery.sizeOf(context)` | — |
| 20_var_globales | `variables_globales.dart` | 70+ variables top-level (const + mutables) | — | — | — | — | Estado global implícito compartido |
| 20_var_globales | `var_de_estilo_widgets.dart` | — | — | — | `ButtonsTabBarLabelStyle`, `ButtonsTabBarUnselectedLabelStyle`, `appBarSecondPage(titulo)`, `appBarSecondPageBottons(titulo,tabBar)`, `appBarSecondPageActions(titulo,actions)` | `variables_globales`, `var_elementos_menus`, `var_color_themes` | `TextStyle`, `AppBar`, `TabBar` |
| 20_var_globales | `var_elementos_menus.dart` | `ElementosMenus`, `ElementoSeleccionado` + 150+ instancias en listas | `ElementosMenus` | `etiqueta, icono` | Constructor | `MaterialSymbols` | Listas: `iconoInicio`, `iconoVerPropiedades`, `elementosMenuTipoDePropiedades`, `iconoNormales`... |
| 20_var_globales | `var_login.dart` | `appName`, `iconNoUser`, `iconUser`, `userTooltip` | — | — | — | `MaterialSymbols.no_accounts`, `account_circle` | — |
| 20_var_globales | `format_chat_timestamp.dart` | — | — | — | `formatChatTimestamp(String iso)` | `DateTime.parse`, `Duration` | — |
| 20_var_globales | `couchdb_errors.dart` | `codigoCouchDB` Map, 2 listas ES/EN | `CouchdbCodigo` | `codigo, label, description` | Constructor | — | — |
| 20_var_globales | `ui_exceptions.dart` | `loginPrimaryBrand` | — | — | Documentación reglas | — | — |

---

# Inventario de Componentes — 40_security

**Directorio:** `lib/40_security/`  
**Archivos:** 5 archivos  
**Fecha:** 2026-08-12

---

## Tabla 1: Componentes (por archivo)

| Subdirectorio | Nombre del archivo | Tipo de componente | Nombre del componente | Parámetros que requiere | Variables que utiliza | Variables internas | Estilos que le aplican |
|---------------|-------------------|-------------------|----------------------|------------------------|----------------------|-------------------|------------------------|
| 40_security | `direccionip.dart` | Constantes compile-time | `username`, `password`, `direccionip` | `String.fromEnvironment('COUCHDB_USER/PASSWORD/URL')` | `--dart-define-from-file=defines.json` | — | — |
| 40_security | `encriptar.dart` | Variables + Funciones @Deprecated | `key32`, `iv16`, `encrypter`, `ivString` + `encryptWithAES`, `decryptWithAES`, `initStringLocalStorage` | `encrypt` package, `shared_preferences` | `Key.fromSecureRandom(32)`, `IV.fromSecureRandom(16)` | `ivString` hardcoded | `Encrypter(AES)`, `SharedPreferences` |
| 40_security | `generate_hash.dart` | Funciones top-level | `generateMD5Hash`, `generateSHA1Hash`, `generateSHA256Hash`, `validaPassword` | `String input` / `password, hashPassword` | `crypto`, `dart:convert` | — | `md5.convert()`, `sha1.convert()`, `sha256.convert()` |
| 40_security | `generate_reset_token.dart` | Funciones top-level | `generateResetToken`, `generateTokenExpiry`, `isTokenValid` | — / `String tokenExpiry` | `crypto`, `dart:convert`, `uuid` | — | `Uuid().v4()`, `sha256.convert()`, `DateTime.parse()` |
| 40_security | `urls_endpoints_espacios.dart` | Maps top-level | `endpointsCaptura`, `endpointsPublicados` | — | 5 claves cada map | Nombres DB CouchDB | — |

---

## Tabla 2: Elementos (por archivo)

| Subdirectorio | Nombre del archivo | Variables definidas en el archivo | Clases | Variables de la clase | Funciones o widgets definidos en la clase | Variables que utiliza | Llamadas a otras clases o widgets |
|---------------|-------------------|----------------------------------|--------|----------------------|------------------------------------------|----------------------|----------------------------------|
| 40_security | `direccionip.dart` | `username`, `password`, `direccionip` (const String) | — | — | — | `String.fromEnvironment()` | — |
| 40_security | `encriptar.dart` | `key32`, `iv16`, `encrypter`, `ivString` | — | — | `encryptWithAES(key, plainText)`, `decryptWithAES(key, encryptedData)`, `initStringLocalStorage(varName, valueToSave)` @Deprecated | `encrypt`, `shared_preferences` | `Encrypter(AES(key32))`, `SharedPreferences.getInstance()` |
| 40_security | `generate_hash.dart` | — | — | — | `generateMD5Hash(input)`, `generateSHA1Hash(input)`, `generateSHA256Hash(input)`, `validaPassword(password, hashPassword)` | `crypto`, `convert` | `md5.convert()`, `sha1.convert()`, `sha256.convert()` |
| 40_security | `generate_reset_token.dart` | — | — | — | `generateResetToken()`, `generateTokenExpiry()`, `isTokenValid(tokenExpiry)` | `uuid`, `crypto`, `convert` | `Uuid().v4()`, `sha256.convert()`, `DateTime.now().toUtc().add(Duration(hours:1))` |
| 40_security | `urls_endpoints_espacios.dart` | `endpointsCaptura`, `endpointsPublicados` (Map<String,String>) | — | — | — | — | Consumido por providers de captura/publicación |