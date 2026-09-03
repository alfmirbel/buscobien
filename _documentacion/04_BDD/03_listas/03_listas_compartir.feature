# language: es
Característica: Compartición de Listas y Propiedades
  Como usuario autenticado
  Quiero compartir mis listas y propiedades con conocidos o grupos
  Para colaborar y recomendar inmuebles a mi red de contactos

  Escenario: El usuario comparte una lista con hasta 5 conocidos
    Dado que el usuario está en la pestaña "Propias" de "Mis Listas"
    Y tiene al menos un conocido aceptado
    Cuando toca el botón "Compartir" en una lista
    Y selecciona hasta 5 conocidos del diálogo
    Y presiona "Enviar"
    Entonces el sistema debe crear un registro de lista compartida por cada destinatario
    Y debe mostrar un SnackBar con el texto "Lista compartida con X conocido(s)"
    Y si ya había compartido con alguno, debe indicar "(Y ya recibidas)"

  Escenario: El sistema previene compartir la misma lista dos veces con el mismo usuario
    Dado que el usuario ya compartió una lista con un conocido
    Cuando intenta compartir la misma lista con ese mismo conocido nuevamente
    Entonces el sistema debe detectar que la compartición ya existe
    Y debe retornar el código de duplicado sin crear un nuevo registro

  Escenario: Las propiedades de la lista se copian al compartir
    Dado que el usuario comparte una lista que contiene propiedades
    Cuando el sistema procesa la compartición exitosamente
    Entonces el sistema debe copiar todas las relaciones propiedad-lista a la base de datos de propiedades compartidas
    Y el destinatario debe ver las mismas propiedades en el detalle de la lista compartida

  Escenario: El destinatario recibe una notificación de lista compartida por chat
    Dado que el usuario compartió una lista con un conocido
    Cuando el sistema completa la creación del registro compartido
    Entonces el sistema debe enviar un mensaje de chat privado al destinatario
    Y el mensaje debe tener tipo "lista" y contener el nombre de la lista y el ID de la compartición

  Escenario: El usuario no puede compartir una lista si no tiene conocidos
    Dado que el usuario no tiene conocidos aceptados
    Cuando toca el botón "Compartir" en una lista
    Entonces el botón debe estar deshabilitado visualmente
    Y no debe abrirse el diálogo de selección de conocidos

  Escenario: El botón "Enviar" del diálogo de compartir está deshabilitado sin selección
    Dado que el usuario abrió el diálogo para compartir una lista
    Cuando no ha seleccionado ningún conocido
    Entonces el botón "Enviar" debe estar deshabilitado
    Y no debe ejecutar ninguna acción al presionarlo

  Escenario: El usuario comparte una propiedad con conocidos
    Dado que el usuario está viendo una propiedad
    Cuando selecciona "Compartir con conocido"
    Y elige hasta 5 conocidos
    Y presiona "Enviar"
    Entonces el sistema debe registrar la compartición de la propiedad en la base de datos
    Y debe enviar un mensaje de chat privado a cada conocido con tipo "propiedad"
    Y debe mostrar un SnackBar con el texto "Propiedad compartida con X conocido(s)"

  Escenario: El usuario comparte una propiedad con grupos
    Dado que el usuario está viendo una propiedad
    Cuando selecciona "Compartir con grupo"
    Y elige uno o más grupos
    Y presiona "Enviar"
    Entonces el sistema debe crear una publicación en cada grupo seleccionado
    Y debe enviar un mensaje al chat de cada grupo con tipo "propiedad"
    Y debe mostrar un SnackBar con el texto "Propiedad compartida en X grupo(s)"

  Escenario: El usuario no puede compartir si no tiene grupos
    Dado que el usuario no pertenece a ningún grupo
    Cuando navega a "Compartir con grupo"
    Entonces el sistema debe mostrar el mensaje "No perteneces a ningún grupo todavía."
    Y no debe mostrar la lista de selección de grupos

  Escenario: El usuario no puede compartir si no tiene conocidos
    Dado que el usuario no tiene conocidos aceptados
    Cuando navega a "Compartir con conocido"
    Entonces el sistema debe mostrar el mensaje "Aún no tienes conocidos aceptados."
    Y no debe mostrar la lista de selección de conocidos
