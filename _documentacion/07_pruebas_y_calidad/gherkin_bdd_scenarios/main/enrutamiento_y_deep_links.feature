# language: es
Característica: Enrutamiento y Deep Links
  Como usuario final
  Quiero navegar por la aplicación usando rutas y enlaces profundos
  Para acceder directamente a secciones específicas

  @REQ-MAIN-007 @REQ-ROUT-017 @mapeo-auto
  Escenario: Generación de rutas personalizada
    Dado que el usuario navega a una pantalla de la aplicación
    Cuando el sistema necesita generar la ruta
    Entonces el sistema ejecuta `routeGenerate(route)`
    Y registra el evento en debug con el formato "3. BuscoBienApp onGenerateRoute(): [ruta]"
    Y retorna la ruta generada correspondiente

  @REQ-MAIN-005 @mapeo-auto
  Escenario: Manejo de deep links en inicialización
    Dado que la aplicación inicia con un deep link configurado
    Cuando el primer frame se completa
    Entonces el sistema ejecuta `initDeepLinkHandler(navigatorKey)`
    Y el navigatorKey se asocia al handler
    Y la aplicación puede navegar desde el deep link

  @REQ-MAIN-004 @mapeo-auto
  Escenario: Navegación programática con navigatorKey
    Dado que el usuario está en cualquier pantalla de la aplicación
    Y el sistema tiene acceso a `navigatorKey`
    Cuando el sistema necesita navegar programáticamente
    Entonces el sistema usa `navigatorKey.currentState?.pushNamed(...)`
    Y la navegación se ejecuta correctamente con la clave global
