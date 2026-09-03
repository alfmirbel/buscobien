# language: es
Característica: Inicialización silenciosa durante el Splash Screen
  Como usuario final
  Quiero que la aplicación prepare los servicios necesarios en segundo plano
  Para que la experiencia en la pantalla principal sea inmediata y fluida

  Escenario: Detección de plataforma durante el splash
    Dado que el usuario acaba de abrir la aplicación
    Cuando el splash screen se monta por primera vez
    Entonces el sistema debe detectar el sistema operativo del dispositivo
    Y esta detección no debe interrumpir la visualización del splash screen
    Y el usuario no debe observar ningún indicador visible de esta inicialización

  Escenario: Restauración de sesión en segundo plano
    Dado que el usuario tiene una sesión previa guardada localmente
    Cuando el splash screen está activo
    Entonces el sistema debe restaurar el estado de sesión de forma asíncrona
    Y esta restauración no debe bloquear la visualización del splash screen
    Y el usuario debe ser llevado directamente a su contenido tras la navegación

  Escenario: Inicialización de controladores de navegación
    Dado que el usuario está en el splash screen
    Cuando el splash finaliza y navega a la pantalla principal
    Entonces el sistema debe tener listos los controladores de menú y pestañas
    Y el usuario debe observar la interfaz de navegación completamente funcional
