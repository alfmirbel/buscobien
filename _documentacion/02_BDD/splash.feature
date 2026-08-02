# language: es
Característica: Splash y arranque inicial
  Como visitante o usuario
  Quiero ver una pantalla de carga inicial y navegar al flujo principal
  Para confirmar conectividad y continuar con la sesión

  Escenario: Navegación a principal cuando hay conexión
    Dado que el usuario acaba de abrir la aplicación
    Y el sistema muestra la pantalla Splash
    Y la conectividad está disponible
    Cuando transcurre la duración mínima del splash
    Entonces el sistema navega a la pantalla principal

  Escenario: Navegación a pantalla sin conexión
    Dado que el usuario acaba de abrir la aplicación
    Y el sistema muestra la pantalla Splash
    Y no hay conexión a Internet
    Cuando el sistema detecta indisponibilidad de red
    Entonces el usuario ve la pantalla sin conexión
