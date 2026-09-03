# language: es
Característica: Grupos y chat grupal
  Como usuario
  Quiero crear grupos, invitar miembros y comunicarme por chat grupal
  Para coordinar intereses inmobiliarios o comunitarios

  Escenario: Crear grupo y asignar administrador
    Dado que el usuario está autenticado
    Cuando crea un nuevo grupo con nombre y descripción
    Entonces el sistema crea el grupo
    Y el usuario se convierte en administrador

  Escenario: Invitar y aceptar miembro
    Dado que existe un grupo con administrador
    Y el administrador invita a otro usuario
    Cuando el usuario invitado acepta la invitación
    Entonces el usuario pasa a ser miembro del grupo

  Escenario: Publicar aviso y propiedad en el grupo
    Dado que el usuario es miembro del grupo
    Cuando publica un aviso shorter a 250 caracteres
    Entonces la publicación aparece en el chat grupal
