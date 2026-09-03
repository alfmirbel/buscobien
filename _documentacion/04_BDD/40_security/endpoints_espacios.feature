# language: es
Característica: Configuración de Endpoints por Tipo de Espacio
  Como sistema
  Quiero mapear tipos de espacios a endpoints de CouchDB
  Para enrutar las operaciones CRUD a la base de datos correcta

  Escenario: Mapeo de espacios normales a endpoint
    Dado que el sistema necesita operar con espacios "Normales"
    Cuando el sistema consulta `endpointsCaptura["Normales"]`
    Entonces el sistema obtiene el endpoint `buscobien_casas_comprados_normal`

  Escenario: Mapeo de espacios destacados a endpoint
    Dado que el sistema necesita operar con espacios "Destacados"
    Cuando el sistema consulta `endpointsCaptura["Destacados"]`
    Entonces el sistema obtiene el endpoint `buscobien_casas_comprados_destacado`

  Escenario: Mapeo de espacios superdestacados a endpoint
    Dado que el sistema necesita operar con espacios "Superdestacados"
    Cuando el sistema consulta `endpointsCaptura["Superdestacados"]`
    Entonces el sistema obtiene el endpoint `buscobien_casas_comprados_super`

  Escenario: Mapeo de espacios oportunidades a endpoint
    Dado que el sistema necesita operar con espacios "Oportunidades"
    Cuando el sistema consulta `endpointsCaptura["Oportunidades"]`
    Entonces el sistema obtiene el endpoint `buscobien_casas_comprados_oportunidad`

  Escenario: Mapeo de espacios remates a endpoint
    Dado que el sistema necesita operar con espacios "Remates"
    Cuando el sistema consulta `endpointsCaptura["Remates"]`
    Entonces el sistema obtiene el endpoint `buscobien_casas_comprados_remate`

  Escenario: Mapeo de publicaciones normales
    Dado que el sistema necesita publicar espacios "normales"
    Cuando el sistema consulta `endpointsPublicados["normales"]`
    Entonces el sistema obtiene el endpoint `buscobien_publicados_normal`

  Escenario: Mapeo de publicaciones destacadas
    Dado que el sistema necesita publicar espacios "destacados"
    Cuando el sistema consulta `endpointsPublicados["destacados"]`
    Entonces el sistema obtiene el endpoint `buscobien_publicados_destacado`

  Escenario: Mapeo de publicaciones superdestacadas
    Dado que el sistema necesita publicar espacios "superdestacados"
    Cuando el sistema consulta `endpointsPublicados["superdestacados"]`
    Entonces el sistema obtiene el endpoint `buscobien_publicados_super`

  Escenario: Mapeo de publicaciones oportunidades
    Dado que el sistema necesita publicar espacios "oportunidades"
    Cuando el sistema consulta `endpointsPublicados["oportunidades"]`
    Entonces el sistema obtiene el endpoint `buscobien_publicados_oportunidad`

  Escenario: Mapeo de publicaciones remates
    Dado que el sistema necesita publicar espacios "remates"
    Cuando el sistema consulta `endpointsPublicados["remates"]`
    Entonces el sistema obtiene el endpoint `buscobien_publicados_remate`

  Escenario: Endpoint desconocido retorna null
    Dado que el sistema consulta un tipo de espacio no definido
    Cuando el sistema consulta `endpointsCaptura["Inexistente"]`
    Entonces el sistema retorna `null`
    Y el sistema no puede operar con ese tipo de espacio
