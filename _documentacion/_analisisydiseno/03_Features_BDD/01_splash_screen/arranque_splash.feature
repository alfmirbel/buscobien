# language: es
Característica: Pantalla Splash con Verificación de Conectividad

  Como usuario de Buscobien
  Quiero ver branding profesional mientras la app verifica conectividad
  Para tener confianza de que la app funciona correctamente

  Antecedentes:
    Dado que la app acaba de iniciar
    Y checaConeccionesProvider está escuchando connectivity_plus stream

  Escenario: Splash completa con conectividad y timer
    Dado que el usuario abre la app
    Cuando se renderiza SplashPage con duration=3 segundos
    Entonces el sistema muestra logo con textos glassmorphism
    Y muestra versión actual (ej. "Beta 0.07.053")
    Y renderiza 6 formas decorativas con efecto glassmorphism (blur + gradient)
    Y inicia timer de 3 segundos (_minDurationPassed = false → true)
    Y suscribe a checaConeccionesProvider reactivamente
    Y cuando timer completa Y conectividad = "Conectado"
    Entonces navega a AppRoutes.principal con pushReplacementNamed

  Escenario: Splash espera timer aunque haya conectividad inmediata
    Dado que la conectividad está disponible desde el inicio
    Cuando el timer de 3 segundos no ha completado
    Entonces el sistema NO navega a principal
    Y espera a _minDurationPassed = true

  Escenario: Splash navega a pantalla sin conexión si no hay red
    Dado que el timer de 3 segundos completó
    Y checaConeccionesProvider emite estado "Sin conexión"
    Cuando _attemptNavigation() evalúa condiciones
    Entonces el sistema navega a AppRoutes.sinconeccion con mensaje contextual
    Y NO navega a principal

  Escenario: Pantalla sin conexión se cierra auto al recuperar red
    Dado que el usuario está en PaginaSinConeccion
    Cuando checaConeccionesProvider emite "Conectado"
    Entonces el sistema ejecuta Navigator.pop() automáticamente
    Y el usuario vuelve al flujo anterior sin acción manual

  Escenario: Inicialización de ubicación diferida (no bloquea splash)
    Dado que el código de _triggerLocationUpdate() está comentado
    Cuando splash navega a principal
    Entonces la ubicación se carga en background tras navegar
    Y NO bloquea la navegación del splash