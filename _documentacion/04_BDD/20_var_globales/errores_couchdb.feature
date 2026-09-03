# language: es
Característica: Mensajes de Error del Backend (CouchDB)
  Como usuario final
  Quiero recibir mensajes de error comprensibles
  Para entender qué salió mal cuando el servidor falla

  Escenario: Operación exitosa
    Dado que el usuario realiza una operación en la aplicación
    Y el servidor responde con código HTTP 200
    Cuando el sistema procesa la respuesta
    Entonces el sistema muestra "Solicitud completada correctamente."

  Escenario: Documento creado exitosamente
    Dado que el usuario crea un nuevo documento en la aplicación
    Y el servidor responde con código HTTP 201
    Cuando el sistema procesa la respuesta
    Entonces el sistema muestra "Creado"
    Y muestra la descripción "Documento creado con éxito."

  Escenario: Solicitud aceptada pero operación en segundo plano
    Dado que el usuario inicia una operación de mantenimiento
    Y el servidor responde con código HTTP 202
    Cuando el sistema procesa la respuesta
    Entonces el sistema muestra "Aceptado"
    Y muestra la descripción sobre operaciones en segundo plano como compactación de base de datos

  Escenario: Contenido no modificado
    Dado que el usuario consulta información cacheada
    Y el servidor responde con código HTTP 304
    Cuando el sistema procesa la respuesta
    Entonces el sistema muestra "No modificado"
    Y muestra la descripción sobre contenido no actualizado

  Escenario: Solicitud con estructura incorrecta
    Dado que el usuario envía datos con formato inválido
    Y el servidor responde con código HTTP 400
    Cuando el sistema procesa la respuesta
    Entonces el sistema muestra "Solicitud errónea"
    Y muestra la descripción sobre mala estructura de solicitud

  Escenario: Acceso no autorizado
    Dado que el usuario intenta acceder a un recurso protegido
    Y el servidor responde con código HTTP 401
    Cuando el sistema procesa la respuesta
    Entonces el sistema muestra "No autorizado"
    Y muestra la descripción sobre autorización no proporcionada o inválida

  Escenario: Operación prohibida
    Dado que el usuario intenta realizar una operación sin permisos
    Y el servidor responde con código HTTP 403
    Cuando el sistema procesa la respuesta
    Entonces el sistema muestra "Prohibido"
    Y muestra la descripción sobre artículo u operación prohibida

  Escenario: Recurso no encontrado
    Dado que el usuario busca un documento que no existe
    Y el servidor responde con código HTTP 404
    Cuando el sistema procesa la respuesta
    Entonces el sistema muestra "No encontrado"
    Y muestra la descripción sobre contenido solicitado no disponible

  Escenario: Método HTTP no permitido
    Dado que el cliente envía un tipo de solicitud incorrecto
    Y el servidor responde con código HTTP 405
    Cuando el sistema procesa la respuesta
    Entonces el sistema muestra "Método no permitido"
    Y muestra la descripción sobre tipo de solicitud HTTP inválido

  Escenario: Conflicto de actualización
    Dado que el usuario intenta modificar un documento desactualizado
    Y el servidor responde con código HTTP 409
    Cuando el sistema procesa la respuesta
    Entonces el sistema muestra "Conflicto"
    Y muestra la descripción sobre conflicto de actualización

  Escenario: Documento demasiado grande
    Dado que el usuario intenta subir un documento muy grande
    Y el servidor responde con código HTTP 413
    Cuando el sistema procesa la respuesta
    Entonces el sistema muestra "Entidad de solicitud demasiado grande"
    Y muestra la descripción sobre límite de tamaño de documento

  Escenario: Error interno del servidor
    Dado que el servidor experimenta un error interno
    Y el servidor responde con código HTTP 500
    Cuando el sistema procesa la respuesta
    Entonces el sistema muestra "Código del servidor interno"
    Y muestra la descripción sobre JSON inválido o información inválida

  Escenario: Servicio no disponible
    Dado que el servidor está en mantenimiento o sobrecargado
    Y el servidor responde con código HTTP 503
    Cuando el sistema procesa la respuesta
    Entonces el sistema muestra "Servicio no disponible"
    Y muestra la descripción sobre servicio sobrecargado o en mantenimiento
