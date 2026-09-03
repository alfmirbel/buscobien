# language: es
Característica: Descubrir Usuarios y Enviar Invitaciones
  Como usuario autenticado
  Quiero descubrir otros usuarios y promotores en la plataforma
  Para enviarles invitaciones de contacto y ampliar mi red

  Escenario: La pantalla carga promotores y usuarios al montar
    Dado que el usuario navega a "PageDescubrirUsuarios"
    Cuando se renderiza la pantalla
    Entonces el sistema debe cargar "usersPromotoresListProvider" y "usersListProvider"
    Y debe mostrar "CircularProgressIndicator" mientras carga

  Escenario: La pantalla muestra error si falla la carga de usuarios
    Dado que el usuario está en "PageDescubrirUsuarios"
    Cuando "usersPromotoresListProvider" o "usersListProvider" emite "error"
    Entonces el sistema debe mostrar el texto "Error: $err" centrado

  Escenario: La pantalla oculta al usuario actual de los resultados
    Dado que el usuario con id "user:123" está en "PageDescubrirUsuarios"
    Cuando se cargan los listados de usuarios y promotores
    Entonces el sistema debe filtrar y excluir al usuario con "id_usuario == currentUserId"
    Y no debe mostrarse a sí mismo en la lista de promotores ni de usuarios

  Escenario: La pantalla muestra sección "Promotores" cuando hay resultados
    Dado que hay promotores registrados en la plataforma
    Cuando se renderiza "PageDescubrirUsuarios"
    Entonces el sistema debe mostrar un header "Promotores" en SliverToBoxAdapter
    Y debe mostrar una lista de tarjetas de promotores

  Escenario: La pantalla muestra sección "Usuarios" cuando hay resultados
    Dado que hay usuarios registrados en la plataforma
    Cuando se renderiza "PageDescubrirUsuarios"
    Entonces el sistema debe mostrar un header "Usuarios" en SliverToBoxAdapter
    Y debe mostrar una lista de tarjetas de usuarios

  Escenario: El usuario puede enviar una invitación a un promotor
    Dado que el usuario está en "PageDescubrirUsuarios"
    Cuando presiona el botón "Invitar" de un promotor
    Entonces el sistema debe llamar a "conocidosProvider.notifier.enviarInvitacion"
    Y debe mostrar un SnackBar con "Enviada a {nombre}" en color primario si es exitoso
    Y debe mostrar un SnackBar con "Error al enviar" en color de error si falla

  Escenario: El usuario puede enviar una invitación a otro usuario
    Dado que el usuario está en "PageDescubrirUsuarios"
    Cuando presiona el botón "Invitar" de un usuario
    Entonces el sistema debe llamar a "conocidosProvider.notifier.enviarInvitacion"
    Y debe mostrar el SnackBar correspondiente según el resultado

  Escenario: Las tarjetas de usuarios muestran avatar con inicial
    Dado que el usuario está en "PageDescubrirUsuarios"
    Cuando se renderiza una tarjeta de usuario
    Entonces el sistema debe mostrar un "CircleAvatar" con la primera letra del nombre
    Y el avatar debe tener "backgroundColor: appTheme.secondary"

  Escenario: Las tarjetas tienen botón "Invitar" con estilo consistente
    Dado que el usuario está en "PageDescubrirUsuarios"
    Cuando se renderiza una tarjeta
    Entonces el botón "Invitar" debe tener "backgroundColor: appTheme.secondary"
    Y debe tener "foregroundColor: appTheme.onSecondary"
    Y debe tener icono "Symbols.mail" y texto "Invitar"
