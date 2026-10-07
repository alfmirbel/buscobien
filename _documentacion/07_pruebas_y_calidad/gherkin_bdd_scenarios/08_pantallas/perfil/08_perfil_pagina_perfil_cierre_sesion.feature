# language: es
Característica: Cierre de Sesión desde el Perfil
  Como usuario autenticado
  Quiero cerrar mi sesión desde la pantalla de perfil
  Para salir de la aplicación de forma segura

  Escenario: El usuario ve el botón de cerrar sesión en la parte inferior
    Dado que el usuario está autenticado
    Cuando se renderiza "_buildUserProfileView"
    Entonces el sistema debe mostrar un botón "ElevatedButton.icon" en la parte inferior
    Y el botón debe tener el texto "Cerrar Sesión Actual"
    Y el icono debe ser "Symbols.logout" en color blanco
    Y el fondo del botón debe ser "appTheme.error"

  Escenario: El usuario abre el diálogo de confirmación de cierre de sesión
    Dado que el usuario está en la pantalla de perfil
    Cuando presiona el botón "Cerrar Sesión Actual"
    Entonces el sistema debe mostrar "_showLogoutDialog"
    Y el diálogo debe tener el título "Termina sesión"
    Y el mensaje debe decir "¿Quiéres salir de la sesión?"
    Y debe mostrar dos botones: "No" y "Si"

  Escenario: El usuario cancela el cierre de sesión
    Dado que el diálogo de confirmación está abierto
    Cuando el usuario presiona "No"
    Entonces el sistema debe cerrar el diálogo con "Navigator.pop()"
    Y el usuario debe permanecer en la pantalla de perfil
    Y la sesión debe permanecer activa

  Escenario: El usuario confirma el cierre de sesión
    Dado que el diálogo de confirmación está abierto
    Cuando el usuario presiona "Si"
    Entonces el sistema debe ejecutar "deleteLocalSessionData()"
    Y debe ejecutar "resetInitialUserData(0)"
    Y debe ejecutar "resetclassUserAvatarProvider()"
    Y debe resetear los providers de menú a sus valores por defecto
    Y debe navegar a "AppRoutes.principal" con "pushReplacementNamed"

  Escenario: El cierre de sesión restablece la navegación a Inicio y Propiedades
    Dado que el usuario confirma el cierre de sesión
    Cuando se ejecuta el reset de navegación
    Entonces "menuInicialProvider" debe tener "seleccionMenuInicial = 1"
    Y "homeNavigationProvider.indiceInicial" debe ser 1
    Y "menuPrincipalProvider" debe tener "seleccionMenuPrincipal = 0"
    Y "homeNavigationProvider.indicePrincipal" debe ser 0
    Y "menuNivelDeGobiernoProvider" debe tener "seleccionMenuNivelDeGobierno = 0"
    Y "menuTipoDeTransaccionProvider" debe tener "seleccionMenuTipoDePublicacion = 0"

  Escenario: El cierre de sesión limpia el avatar del usuario
    Dado que el usuario tenía un avatar guardado
    Cuando confirma el cierre de sesión
    Entonces el sistema debe llamar a "resetclassUserAvatarProvider()"
    Y el avatar debe quedar vacío en el estado global
    Y al regresar a la pantalla de perfil debe mostrar el icono por defecto

  Escenario: El cierre de sesión navega a la pantalla principal reemplazando el historial
    Dado que el usuario confirma el cierre de sesión
    Cuando se ejecuta la navegación final
    Entonces el sistema debe usar "pushReplacementNamed" hacia "AppRoutes.principal"
    Y el usuario no debe poder regresar al perfil con el botón atrás
    Y la pantalla principal debe mostrar la sección "Propiedades" con filtros por defecto
