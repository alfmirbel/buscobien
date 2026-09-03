# language: es
Característica: Inicialización Global de la Aplicación Buscobien

  Como usuario de la plataforma
  Quiero que la app inicie correctamente en cualquier plataforma
  Para acceder al catálogo inmobiliario y funcionalidades sociales

  Antecedentes:
    Dado que la aplicación se compila con --dart-define-from-file=defines.json
    Y las credenciales CouchDB y Google Maps están inyectadas vía String.fromEnvironment()

  Escenario: Arranque exitoso en Web/WASM con Path URL Strategy
    Dado que el usuario abre la app en navegador
    Cuando se ejecuta main()
    Entonces el sistema inicializa WidgetsFlutterBinding
    Y fuerza orientación portrait-only
    Y activa setPathUrlStrategy() para URLs limpias
    Y envuelve la app en ProviderScope de Riverpod
    Y configura MaterialApp con useMaterial3: true y appTheme global
    Y expone navigatorKey global para navegación programática
    Y muestra la pantalla Splash por 3 segundos mínimo

  Escenario: Manejo de Deep Link de recuperación de contraseña
    Dado que la app está instalada en Android/iOS o abierta en Web
    Cuando el usuario toca enlace "/recuperar?token=abc123&perfil=promotor"
    Entonces el sistema inicializa AppLinks en initDeepLinkHandler
    Y valida que token y perfil no estén vacíos
    Y navega programáticamente via navigatorKey a "/cambiopassword"
    Y pasa argumentos {token: "abc123", perfil: "promotor"}

  Escenario: Configuración de tema Material Design 3 obligatoria
    Dado que MaterialApp se construye
    Cuando se define el ThemeData
    Entonces useMaterial3: true
    Y NavigationBarThemeData usa appTheme para colores selected/unselected
    Y iconTheme usa appTheme.onPrimaryContainer
    Y NO hay Colors.xxx hardcoded (ver ui_exceptions.dart)

  Escenario: Fallo en inicialización critica
    Dado que WidgetsFlutterBinding.ensureInitialized() lanza excepción
    Cuando main() ejecuta
    Entonces el sistema no renderiza la app
    Y propaga la excepción (crash visible para diagnóstico)