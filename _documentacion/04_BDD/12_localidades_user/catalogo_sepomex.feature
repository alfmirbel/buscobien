# language: es
Característica: Catálogo de Localidades SEPOMEX
  Como usuario de BuscoBien
  Quiero buscar localidades por código postal
  Para encontrar y seleccionar mi ubicación

  Antecedentes:
    Dado que el usuario se encuentra en el buscador de localidades

  Escenario: Buscar localidades por código postal
    Dado que el usuario ingresa un código postal válido
    Cuando el sistema consulta el catálogo SEPOMEX
    Entonces el sistema deberá realizar una petición GET a `codigospostales/_design/DDCP/_view/vistaCP?key=[cp]`
    Y el sistema deberá retornar la lista de localidades asociadas a ese código postal

  Escenario: Código postal sin resultados
    Dado que el usuario ingresa un código postal inexistente
    Cuando el sistema consulta el catálogo SEPOMEX
    Entonces el sistema deberá retornar una lista vacía
    Y el sistema deberá mostrar un mensaje indicando que no se encontraron localidades

  Escenario: Error al consultar código postal
    Dado que el usuario ingresa un código postal
    Cuando ocurre un error de red o el servidor no responde
    Entonces el sistema deberá retornar una lista vacía
    Y el sistema deberá manejar el error sin interrumpir la navegación
