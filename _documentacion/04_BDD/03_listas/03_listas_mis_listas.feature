# language: es
Característica: Gestión de Mis Listas
  Como usuario autenticado o invitado
  Quiero ver y administrar mis listas de propiedades
  Para organizar los inmuebles de interés y compartirlos con otros usuarios

  Escenario: Un usuario sin sesión ve la vista de invitado en Mis Listas
    Dado que el usuario no ha iniciado sesión (userId vacío)
    Cuando navega a la sección "Mis Listas"
    Entonces el sistema debe mostrar el mensaje "No hay listas que mostrar"
    Y debe mostrar un botón con el texto "Ingresa como usuario o promotor para crear listas"
    Y al tocar el botón debe abrirse el diálogo de login "dialogBoxFichaLogin"

  Escenario: La pantalla muestra tres pestañas al tener sesión iniciada
    Dado que el usuario ha iniciado sesión
    Cuando navega a "Mis Listas"
    Entonces el sistema debe mostrar el TabBar con las pestañas "Propias", "Recibidas" y "Enviadas"
    Y la pestaña "Propias" debe estar activa por defecto

  Escenario: Las listas propias se cargan al iniciar la pantalla
    Dado que el usuario tiene listas creadas previamente
    Cuando se renderiza la pestaña "Propias"
    Entonces el sistema debe mostrar cada lista en una tarjeta con su nombre
    Y la lista "Favoritas" debe aparecer siempre en la primera posición
    Y cada tarjeta debe mostrar los botones de "Compartir" y "Borrar"

  Escenario: El usuario crea una nueva lista exitosamente
    Dado que el usuario está en la pestaña "Propias"
    Cuando toca el botón "Crea lista"
    Y escribe un nombre válido en el campo de texto
    Y presiona "Crear"
    Entonces el sistema debe crear la lista en la base de datos
    Y debe mostrar un SnackBar con el texto "Lista creada" en color primario
    Y la nueva lista debe aparecer en la parte superior de la pestaña "Propias"

  Escenario: El usuario no puede crear una lista sin nombre
    Dado que el usuario está en el diálogo "Nueva Lista"
    Cuando deja el campo de texto vacío
    Y presiona "Crear"
    Entonces el sistema debe mostrar un SnackBar con el texto "Escribe el nombre de la lista." en color de error
    Y no debe cerrar el diálogo

  Escenario: El usuario elimina una lista con confirmación
    Dado que el usuario toca el botón de eliminar en una lista propia
    Cuando aparece el diálogo "Borrar lista"
    Y presiona "Eliminar"
    Entonces el sistema debe eliminar la lista de la base de datos
    Y debe mostrar un SnackBar con el texto "Lista eliminada" en color primario
    Y la lista debe desaparecer de la pestaña "Propias"

  Escenario: El usuario cancela la eliminación de una lista
    Dado que el usuario toca el botón de eliminar en una lista propia
    Cuando aparece el diálogo "Borrar lista"
    Y presiona "Cancelar"
    Entonces el sistema debe mantener la lista en la pestaña "Propias"
    Y no debe mostrar ningún mensaje de error

  Escenario: Las listas recibidas se filtran por usuario destino
    Dado que el usuario ha recibido listas compartidas de otros usuarios
    Cuando se renderiza la pestaña "Recibidas"
    Entonces el sistema debe mostrar solo las listas donde "usuarioDestinoId" coincide con el usuario actual
    Y cada tarjeta debe mostrar el nombre del usuario origen en el subtítulo

  Escenario: Las listas enviadas se filtran por usuario origen
    Dado que el usuario ha compartido listas con otros usuarios
    Cuando se renderiza la pestaña "Enviadas"
    Entonces el sistema debe mostrar solo las listas donde "usuarioOrigenId" coincide con el usuario actual
    Y cada tarjeta debe mostrar "Para [nombre del destinatario]" en el subtítulo

  Escenario: El usuario puede dejar de compartir una lista recibida
    Dado que el usuario está en la pestaña "Recibidas"
    Cuando toca el botón "Dejar de compartir" en una lista recibida
    Y confirma en el diálogo de confirmación
    Entonces el sistema debe eliminar el registro de compartición
    Y debe mostrar un SnackBar con el texto "Lista dejada de compartir"
    Y la lista debe desaparecer de la pestaña "Recibidas"

  Escenario: El usuario puede dejar de compartir una lista enviada
    Dado que el usuario está en la pestaña "Enviadas"
    Cuando toca el botón "Dejar de compartir" en una lista enviada
    Y confirma en el diálogo de confirmación
    Entonces el sistema debe eliminar el registro de compartición
    Y debe mostrar un SnackBar con el texto "Lista dejada de compartir"
    Y la lista debe desaparecer de la pestaña "Enviadas"

  Escenario: La pantalla se actualiza al regresar del detalle de una lista
    Dado que el usuario abre el detalle de una lista propia
    Cuando regresa a "Mis Listas"
    Entonces el sistema debe recargar las listas del usuario
    Y los cambios realizados en el detalle deben reflejarse en la pestaña "Propias"
