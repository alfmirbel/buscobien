# language: es
Característica: Miembros del Grupo
  Como miembro de un grupo
  Quiero ver la lista de miembros del grupo
  Para conocer a los participantes y sus roles

  Antecedentes:
    Dado que el usuario se encuentra en la pestaña "Miembros" del detalle de grupo

  @REQ-GPU-015 @REQ-GPU-018 @mapeo-auto
  Escenario: Visualización de lista de miembros
    Dado que el grupo tiene miembros registrados
    Cuando el usuario abre la pestaña "Miembros"
    Entonces el sistema deberá mostrar una lista con todos los miembros
    Y cada miembro deberá mostrar su nombre y rol

  @REQ-GPU-018 @mapeo-auto
  Escenario: Estado vacío de miembros
    Dado que el grupo no tiene miembros registrados
    Cuando el usuario abre la pestaña "Miembros"
    Entonces el sistema deberá mostrar el mensaje "No hay miembros registrados."

  @REQ-GPU-015 @REQ-GPU-018 @mapeo-auto
  Escenario: Indicador de administrador
    Dado que el grupo tiene un administrador
    Cuando el usuario visualiza la lista de miembros
    Entonces el sistema deberá mostrar un ícono de estrella junto al administrador
    Y el texto "Administrador" como subtítulo

  Escenario: Indicador de miembro regular
    Dado que el grupo tiene un miembro regular
    Cuando el usuario visualiza la lista de miembros
    Entonces el sistema deberá mostrar el texto "Miembro" como subtítulo
    Y no deberá mostrar el ícono de estrella

  @REQ-GPU-015 @mapeo-auto
  Escenario: Indicador de usuario actual
    Dado que el usuario se encuentra en la pestaña "Miembros"
    Cuando el usuario visualiza su propio nombre en la lista
    Entonces el sistema deberá mostrar un chip con el texto "Tú"

  @REQ-GPU-018 @mapeo-auto
  Escenario: Avatar con inicial del miembro
    Dado que el usuario visualiza la lista de miembros
    Cuando observa el avatar de un miembro
    Entonces el sistema deberá mostrar un CircleAvatar con la inicial del nombre del miembro
