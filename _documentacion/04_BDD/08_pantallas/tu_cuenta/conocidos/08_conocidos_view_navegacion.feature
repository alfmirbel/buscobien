# language: es
Característica: Navegación en la Vista de Conocidos
  Como usuario autenticado
  Quiero navegar entre Contactos, Invitaciones y Descubrir usuarios
  Para gestionar mi red de contactos dentro de BuscoBien

  Escenario: La vista muestra 3 destinos en la NavigationBar
    Dado que el usuario navega a la sección "Conocidos"
    Cuando se renderiza "ConocidosView"
    Entonces el sistema debe mostrar una "NavigationBar" con 3 destinos
    Y los destinos deben ser: "Contactos", "Invitaciones" y "Descubrir"
    Y cada destino debe tener un icono: people, mail y search respectivamente

  Escenario: La vista inicia en la pestaña Contactos por defecto
    Dado que el usuario acaba de navegar a "ConocidosView"
    Cuando se renderiza la pantalla por primera vez
    Entonces el sistema debe mostrar "PageMisContactos" como contenido inicial
    Y el índice seleccionado en la NavigationBar debe ser 0

  Escenario: El usuario cambia a la pestaña Invitaciones
    Dado que el usuario está en "ConocidosView"
    Cuando el usuario presiona el destino "Invitaciones" en la NavigationBar
    Entonces el sistema debe mostrar "PageInvitaciones" como contenido
    Y el índice seleccionado debe cambiar a 1

  Escenario: El usuario cambia a la pestaña Descubrir
    Dado que el usuario está en "ConocidosView"
    Cuando el usuario presiona el destino "Descubrir" en la NavigationBar
    Entonces el sistema debe mostrar "PageDescubrirUsuarios" como contenido
    Y el índice seleccionado debe cambiar a 2

  Escenario: La NavigationBar muestra el indicador de selección
    Dado que el usuario está en "ConocidosView"
    Cuando el usuario cambia de pestaña
    Entonces el sistema debe mostrar un indicador de color "appTheme.primary" en la pestaña seleccionada
    Y el indicador debe moverse al destino activo

  Escenario: La vista recibe currentUserId y currentUserName
    Dado que el usuario está autenticado con userId "user:123" y nombre "Juan"
    Cuando se renderiza "ConocidosView"
    Entonces el sistema debe pasar "currentUserId" a las 3 páginas hijas
    Y debe pasar "currentUserName" a "PageDescubrirUsuarios"
