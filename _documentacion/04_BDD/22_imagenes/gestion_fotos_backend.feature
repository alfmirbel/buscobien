# language: es
Característica: Operaciones de Fotos con el Backend
  Como usuario final
  Quiero que las fotos de mis propiedades se sincronicen con el servidor
  Para que estén disponibles en la nube y se muestren correctamente

  Escenario: Guardar nueva foto en CouchDB
    Dado que el usuario selecciona una imagen para subir
    Y la imagen ha sido comprimida exitosamente
    Y el usuario es propietario de la propiedad
    Cuando el sistema guarda la foto en CouchDB
    Entonces el sistema genera un ID único basado en SHA256 del usuario, nombre de archivo y timestamp
    Y envía una petición POST a `buscobien_propiedades_casas_fotos`
    Y envía autenticación Basic Auth en el encabezado
    Y la foto se guarda con metadatos: idFoto, idUsuario, idPropiedad, filaname, path, size, identifier, foto (base64), content_type, timestamp
    Y el sistema retorna código 201 si la foto se guardó exitosamente

  Escenario: Error al guardar foto por ID vacío
    Dado que el usuario intenta eliminar una foto
    Y el ID de la foto está vacío
    Cuando el sistema intenta eliminar la foto
    Entonces el sistema retorna código 400 (Bad Request) sin realizar la petición HTTP

  Escenario: Eliminar foto exitosamente
    Dado que el usuario confirma la eliminación de una foto
    Y la foto existe en CouchDB con revisión válida
    Cuando el sistema envía la petición DELETE
    Entonces el sistema envía DELETE a `buscobien_propiedades_casas_fotos/{id}?rev={rev}`
    Y retorna código 200, 202 o 404
    Y actualiza la lista de fotos en el provider
    Y actualiza la lista de orden de fotos
    Y recarga la UI

  Escenario: Error de conexión al eliminar foto
    Dado que el usuario intenta eliminar una foto
    Y el dispositivo no tiene conexión a Internet
    Cuando el sistema envía la petición DELETE
    Entonces el sistema captura la excepción de socket
    Y retorna código 503
    Y muestra el mensaje de error correspondiente del catálogo CouchDB

  Escenario: Recuperar foto por ID - Éxito
    Dado que existe una foto con ID "abc123" en CouchDB
    Cuando el sistema solicita la foto por ID
    Entonces el sistema consulta la vista `DDFOTO/_view/idFoto` con key "abc123"
    Y retorna el contenido base64 de la foto

  Escenario: Recuperar foto por ID - No encontrada
    Dado que no existe una foto con ID "xyz999" en CouchDB
    Cuando el sistema solicita la foto por ID
    Entonces el sistema consulta la vista y retorna lista vacía
    Y retorna cadena vacía como resultado

  Escenario: Recuperar foto por ID - ID vacío
    Dado que el sistema recibe un ID de foto vacío
    Cuando intenta recuperar la foto
    Entonces retorna cadena vacía sin realizar la petición HTTP

  Escenario: Contar fotos por usuario y propiedad
    Dado que el usuario tiene 7 fotos en la propiedad "prop123"
    Cuando el sistema consulta el contador de fotos
    Entonces el sistema consulta la vista `DDUSPR/_view/cuentaFotos` con key `["usuario","prop123"]`
    Y retorna el valor 7 en el campo `value`
    Y actualiza el título de la pantalla con "Número de fotos: 7"

  Escenario: Contar fotos cuando no hay fotos
    Dado que el usuario no tiene fotos en la propiedad
    Cuando el sistema consulta el contador de fotos
    Entonces el sistema retorna valor 0
    Y la pantalla muestra "Número de fotos: 0"

  Escenario: Recuperar todas las fotos de usuario y propiedad
    Dado que el usuario tiene fotos en una propiedad
    Cuando el sistema recupera todas las fotos
    Entonces el sistema consulta la vista `DDUSPR/_view/userproperty` con key `["idUsuario","idPropiedad"]`
    Y retorna la lista de fotos con todos sus metadatos
    Y actualiza el provider `getListaFotosCasaProviderId`

  Escenario: Recuperar IDs de fotos por usuario y propiedad
    Dado que el usuario tiene fotos en una propiedad
    Cuando el sistema recupera solo los IDs de las fotos
    Entonces el sistema consulta la vista `DDUSPR/_view/idUserPropiedadFoto` con key `["idUsuario","idPropiedad"]`
    Y retorna la lista de IDs de fotos

  Escenario: Recuperar IDs de fotos por propiedad
    Dado que una propiedad tiene fotos de varios usuarios
    Cuando el sistema recupera los IDs por propiedad
    Entonces el sistema consulta la vista `DDFOTO/_view/idFotoIdPropiedad` con key "idPropiedad"
    Y retorna los IDs de fotos de esa propiedad

  Escenario: Timeout en peticiones HTTP
    Dado que el servidor CouchDB está lento o no responde
    Cuando el sistema envía cualquier petición HTTP de fotos
    Entonces el sistema aplica un timeout de 10 segundos
    Y captura la excepción de timeout
    Y retorna código 500 para la mayoría de operaciones
    Y retorna código 503 para operaciones de eliminación
