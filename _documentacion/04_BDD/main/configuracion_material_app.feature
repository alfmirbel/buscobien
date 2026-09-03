# language: es
Característica: Configuración de MaterialApp
  Como usuario final
  Quiero acceder a la aplicación con una configuración consistente
  Para navegar por las pantallas con experiencia Material Design 3

  Escenario: MaterialApp con navegador global
    Dado que la aplicación ha iniciado
    Cuando el sistema construye `BuscoBienApp`
    Entonces el sistema crea un `MaterialApp`
    Y asigna un `GlobalKey<NavigatorState>` como `navigatorKey`
    Y permite navegación programática desde cualquier punto de la app

  Escenario: Ocultar banner de debug
    Dado que la aplicación está en modo release o profile
    Cuando el sistema construye `MaterialApp`
    Entonces el sistema oculta el banner de debug checked con `debugShowCheckedModeBanner: false`

  Escenario: Título de la aplicación
    Dado que el usuario visualiza la aplicación en el sistema operativo
    Cuando el sistema construye `MaterialApp`
    Entonces el sistema establece el título de la app como "buscobien"

  Escenario: Ruta inicial de la aplicación
    Dado que el usuario abre la aplicación por primera vez
    Cuando el sistema construye `MaterialApp`
    Entonces el sistema establece la ruta inicial como `AppRoutes.main`
    Y el usuario navega directamente a la pantalla principal
