# language: es
Característica: Detalle de Grupo
  Como miembro de un grupo
  Quiero ver la información del grupo, publicaciones, miembros, chat y avisos
  Para participar activamente en la comunidad

  Antecedentes:
    Dado que el usuario ha iniciado sesión en la aplicación
    Y se encuentra en la pantalla de detalle de un grupo

  Escenario: Visualización de encabezado del grupo
    Dado que el usuario abre la pantalla de detalle de grupo
    Entonces el sistema deberá mostrar el nombre del grupo en el AppBar
    Y el número de miembros debajo del nombre

  Escenario: Acceso a información del grupo
    Dado que el usuario se encuentra en el detalle del grupo
    Cuando el usuario presiona el menú de opciones y selecciona "Info del grupo"
    Entonces el sistema deberá mostrar un diálogo con el objetivo, descripción, privacidad, participación y creador del grupo

  Escenario: Invitar miembros (solo administrador)
    Dado que el usuario es administrador del grupo
    Cuando el usuario presiona el ícono de invitar miembro en el AppBar
    Entonces el sistema deberá mostrar el diálogo de invitación de miembros

  Escenario: Menú de opciones para administrador
    Dado que el usuario es administrador del grupo
    Cuando el usuario presiona el menú de opciones
    Entonces el sistema deberá mostrar las opciones "Info del grupo" y "Editar grupo"

  Escenario: Menú de opciones para miembro
    Dado que el usuario es miembro (no administrador) del grupo
    Cuando el usuario presiona el menú de opciones
    Entonces el sistema deberá mostrar solo la opción "Info del grupo"
