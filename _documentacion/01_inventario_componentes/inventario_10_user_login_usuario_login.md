# Inventario de Componentes - Sección `usuario_login` (D:\buscobien\lib\10_user_login\usuario_login)

Este módulo implementa el flujo interactivo de autenticación de usuarios y promotores, incluyendo las interfaces de formulario de login (`LoginPage`), la ficha de acceso emergente (`dialogBoxFichaLogin`), la pantalla de registro completo con aceptación de términos y privacidad (`RegisterScreenUsers`), y la capa lógica de persistencia local (`FlutterSecureStorage`) y comunicación CouchDB.

---

## Tabla de Inventario de Componentes de Autenticación y Registro

| Subdirectorio | Nombre del archivo | Tipo de componentes | Nombre del componente | Parámetros que requiere | Variables que utiliza (externas/globales/Riverpod) | Variables internas / Estado | Estilos que le aplican |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| N/A | `data_session.dart` | Clase de Modelo de Datos | `SessionData` | Constructor normal / Fábrica `fromJson` | Ninguno | `key`, `varName`, `valueToSave`, `userId`, `userName`, `userPass`, flags de tipo de usuario en formato string y boolean | N/A |
| N/A | `dialogbox_login.dart` | Función Helper (Caja de Diálogo) | `dialogBoxFichaLogin` | `context` (BuildContext), `ref` (WidgetRef) | `warningApp`, `appTheme`, `sessionProvider` | Diálogo emergente interactivo que aloja a `LoginPage` | `appTheme.primary`, `appTheme.onPrimary`, `appTheme.surface` |
| N/A | `login_01_login_page.dart` | `ConsumerStatefulWidget` / `State` / `Dropdown` Widget | `LoginPage`, `_LoginPageState`, `DropdownTipoUsuario`, `_DropdownTipoUsuarioState` | Ninguno (para los widgets) | `sessionProvider`, `classUserAvatarProvider`, `appTheme`, `listaTipoUsuarios`, `AppRoutes` | `_isLoading`, `usernameController`, `passwordController`, `_selectedValue` | `appTheme.surface`, `appTheme.error`, `appTheme.secondary`, `appTheme.tertiary` |
| N/A | `login_03_form_register_user.dart` | `ConsumerStatefulWidget` / `State` / Widgets Auxiliares | `RegisterScreenUsers`, `RegisterScreenUsersState`, `CheckboxTerminoCondiciones`, `CheckboxTerminoCondicionesState` | Ninguno (para los widgets) / `etiqueta`, `nombreVariable`, `alineacion` para constructores de renglones | `sessionProvider`, `appTheme`, `codigoCouchDB`, `screenWidth`, `screenHeight`, `textoTerminosCondiciones`, `textoaAcuerdoPrivacidad` | `_validaclavedeacceso`, `codigopostal`, `rfc`, `_formKeyRegistroUsers`, variables globales de acuerdo (`aceptoTerminosCondiciones`, `aceptoAvisoPrivacidad`) | `appTheme.primary`, `appTheme.onPrimary`, `appTheme.secondary`, `appTheme.tertiary`, `appTheme.error` |
| N/A | `provider_session.dart` | Notificador de Estado (Riverpod) | `SessionNotifier` | Métodos con parámetros como `seccion`, `varName`, `campo`, `valor`, `loc` | `sessionRepositoryProvider`, `direccionip`, `username`, `password` | `_storage` (`FlutterSecureStorage`) y mapeo reactivo de `AuthState` | N/A |
| N/A | `provider_session.g.dart` | Código Autogenerado (Riverpod) | Providers autogenerados | Autogenerado por build_runner | Ninguno | Proveedores reactivos autogenerados | N/A |
| N/A | `session_repository.dart` | Clase de Repositorio de Datos | `SessionRepository`, `sessionRepositoryProvider` | `userName`, `nombrePerfil`, `authHeaders`, `userId`, `esPromotor`, `nvoUsuario` para métodos | `direccionip`, `generateSHA256Hash` | `database`, `encodedKey`, `url`, llamadas HTTP asíncronas | N/A |
| N/A | `session_repository.g.dart` | Código Autogenerado (Riverpod) | Providers autogenerados | Autogenerado por build_runner | Ninguno | Proveedores reactivos autogenerados | N/A |
| N/A | `textos_tc_ap.dart` | Listas de Datos Globales / `StatelessWidget` | `textoTerminosCondiciones`, `textoaAcuerdoPrivacidad`, `VisorTerminosWidget` | `textoTerminos` (para el visor) | `appTheme` | Renderización condicional según patrones RegExp de títulos, bullets y texto justificado legal | `appTheme.onPrimaryContainer` (Azul corporativo), `Colors.grey` |

---

## Análisis Técnico del Módulo de Sesión y Registro

1. **Flujo de Acceso Sincronizado (`login_01_login_page.dart`):**
   * El login valida los inputs del controlador e inicia una petición HTTP a CouchDB mediante `sessionNotifier.getUserIdNamePassByName()`. Una vez obtenido el código exitoso `200`, se dispara en paralelo la recuperación del avatar del usuario (`classUserAvatarProvider.notifier.recuperaDatosDelAvatar`) y se escribe la sesión en el almacenamiento local seguro (`Future.wait`) para minimizar bloqueos de UI.

2. **Registro Legal Interactuable (`login_03_form_register_user.dart`):**
   * El formulario de registro integra un control de validación estricto para términos y condiciones y aviso de privacidad (`aceptoTerminosCondiciones` y `aceptoAvisoPrivacidad`). Permite leerlos en pantalla mediante un visor personalizado (`VisorTerminosWidget`) que formatea el texto plano en tiempo real (identifica títulos, bullets de lista e incrementos), o bien descargar un archivo PDF del asset local (`open_filex` / `url_launcher`) en Web o móvil de forma inteligente (`kIsWeb`).

3. **Gestión de Criptografía de Contraseñas:**
   * La contraseña del usuario nunca se envía ni se almacena en texto plano en CouchDB. El repositorio `SessionRepository` y el widget de registro aplican `generateSHA256Hash` combinando el timestamp de creación de manera salada para asegurar la irreversibilidad antes de persistir los datos en base de datos.
