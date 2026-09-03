# language: es
Característica: Operaciones CRUD de Localidades de Usuario
  Como sistema de BuscoBien
  Quiero realizar operaciones CRUD sobre las localidades del usuario
  Para mantener actualizada la información de ubicación

  Antecedentes:
    Dado que el usuario ha iniciado sesión
    Y existe una localidad de prueba con asentamiento "Centro"

  Escenario: Obtener todas las localidades del usuario
    Dado que el usuario tiene ID "user-123"
    Cuando el sistema consulta sus localidades
    Entonces el sistema deberá realizar una petición GET a `buscobien_user_localidad/_design/DDUL/_view/vistaUserID`
    Y el sistema deberá retornar todas las localidades asociadas al usuario

  Escenario: Obtener una localidad específica por asentamiento
    Dado que el usuario tiene ID "user-123"
    Y tiene una localidad con asentamiento "Centro"
    Cuando el sistema consulta por ese asentamiento
    Entonces el sistema deberá realizar una petición GET con key `["user-123","Centro"]`
    Y el sistema deberá retornar la localidad específica

  Escenario: Guardar nueva localidad
    Dado que el usuario desea guardar una nueva localidad
    Cuando el sistema envía la solicitud de guardado
    Entonces el sistema deberá verificar que no exista una localidad duplicada para el mismo usuario y asentamiento
    Si la localidad no existe
    Entonces el sistema deberá crear un nuevo documento en CouchDB
    Y el sistema deberá retornar código 200
    Si la localidad ya existe
    Entonces el sistema deberá retornar código 409

  Escenario: Guardar localidad duplicada
    Dado que el usuario ya tiene una localidad con asentamiento "Centro"
    Cuando el sistema intenta guardar otra localidad con el mismo asentamiento
    Entonces el sistema deberá detectar el duplicado
    Y el sistema deberá retornar código 409 sin crear un nuevo documento

  Escenario: Eliminar localidad
    Dado que el usuario tiene una localidad con ID "localidad-123"
    Cuando el sistema elimina la localidad
    Entonces el sistema deberá obtener el `_rev` del documento
    Y el sistema deberá realizar una petición DELETE con el ID y revisión
    Y el sistema deberá retornar código 200 si la eliminación es exitosa

  Escenario: Eliminar localidad inexistente
    Dado que el usuario intenta eliminar una localidad con ID "inexistente"
    Cuando el sistema intenta eliminarla
    Entonces el sistema deberá retornar código 404
    Y el sistema deberá retornar `false` indicando que no se eliminó
