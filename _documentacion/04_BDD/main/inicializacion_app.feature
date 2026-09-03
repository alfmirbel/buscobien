# language: es
Característica: Inicialización de la Aplicación BuscoBien
  Como usuario final
  Quiero que la aplicación inicie correctamente en mi dispositivo
  Para acceder a las funcionalidades de la plataforma

  Escenario: Inicio exitoso de la aplicación
    Dado que el usuario abre la aplicación BuscoBien
    Cuando el sistema ejecuta `main()`
    Entonces el sistema inicializa el binding de Flutter
    Y configura URLs limpias en Web con `setPathUrlStrategy()`
    Y establece las orientaciones permitidas a vertical (portrait)
    Y inicializa el contador de debug `lcwc` en 0
    Y envuelve la aplicación en `ProviderScope` de Riverpod
    Y ejecuta `BuscoBienApp`

  Escenario: Orientación vertical por defecto
    Dado que el usuario abre la aplicación en cualquier dispositivo
    Cuando el sistema configura las orientaciones permitidas
    Entonces el sistema permite `DeviceOrientation.portraitUp`
    Y permite `DeviceOrientation.portraitDown`
    Y bloquea `DeviceOrientation.landscapeLeft`
    Y bloquea `DeviceOrientation.landscapeRight`

  Escenario: Inicialización de deep links después del primer frame
    Dado que la aplicación inicia correctamente
    Y el widget `BuscoBienApp` se crea
    Cuando el primer frame se completa
    Entonces el sistema ejecuta `initDeepLinkHandler(navigatorKey)`
    Y el handler de deep links queda activo para toda la sesión
