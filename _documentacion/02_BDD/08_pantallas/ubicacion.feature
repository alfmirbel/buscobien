# language: es
Característica: Búsqueda de localidades y mapas
  Como usuario
  Quiero buscar localidades por código postal y ubicación geo
  Para seleccionar una ubicación precisa en mis búsquedas

  Escenario: Búsqueda por código postal
    Dado que el usuario accede al flujo de búsqueda de localidades
    Y escribe un código postal válido
    Cuando confirma la búsqueda
    Entonces el sistema muestra las localidades asociadas

  Escenario: Selección desde Google Maps
    Dado que el usuario abrió el selector por mapa
    Cuando el usuario selecciona una ubicación en el mapa
    Entonces el sistema captura la localidad asociada

  Escenario: Maestro de localidades
    Dado que el usuario abre el maestro de localidades
    Cuando consulta o selecciona una localidad existente
    Entonces el sistema lista las localidades disponibles
