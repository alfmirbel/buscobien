# language: es
Característica: Navegación automática desde el Splash Screen
  Como usuario final
  Quiero ser dirigido automáticamente a la pantalla principal después de la carga inicial
  Para comenzar a usar la aplicación sin intervención manual

  Escenario: Navegación exitosa a la pantalla principal con conexión a Internet
    Dado que el usuario está en el splash screen
    Y el sistema detecta conexión a Internet activa
    Cuando transcurre la duración mínima configurada del splash
    Entonces el sistema debe navegar a la pantalla principal (`principal`)
    Y la navegación debe reemplazar el splash screen en el historial
    Y el usuario no debe poder regresar al splash screen con el botón atrás

  Escenario: Navegación a pantalla de error sin conexión a Internet
    Dado que el usuario está en el splash screen
    Y el sistema no detecta conexión a Internet
    Cuando transcurre la duración mínima configurada del splash
    Entonces el sistema debe navegar a la pantalla sin conexión (`sinconeccion`)
    Y el sistema debe pasar el mensaje "No se detectó conexión a Internet."
    Y el usuario debe poder regresar al splash screen desde la pantalla de error

  Escenario: La navegación se previene hasta cumplir la duración mínima
    Dado que el usuario está en el splash screen
    Y el temporizador de duración mínima aún no ha finalizado
    Cuando el sistema evalúa si debe navegar
    Entonces el sistema debe permanecer en el splash screen
    Y no debe ejecutar ninguna navegación automática
