# language: es
Característica: Búsqueda de Localidades por Código Postal y Mapa
  Como usuario de BuscoBien
  Quiero buscar localidades por código postal y visualizarlas en el mapa
  Para encontrar la zona exacta donde quiero buscar propiedades

  Escenario: La pantalla muestra el formulario de búsqueda por CP
    Dado que el usuario navega a "PaginaBuscaLocalidadGMaps"
    Cuando se renderiza la pantalla
    Entonces el sistema debe mostrar un AppBar con título "Busca ubicación por Código Postal"
    Y debe mostrar un formulario con un campo "Código Postal"
    Y el campo debe aceptar solo números con máximo 5 caracteres
    Y debe mostrar un botón "Busca ubicaciones"

  Escenario: El campo de CP tiene validación de formulario
    Dado que el usuario está en la pantalla de búsqueda de localidades
    Cuando el usuario presiona "Busca ubicaciones" con el campo vacío
    Entonces el sistema debe mostrar el mensaje de error "Proporciona un código postal"
    Y no debe navegar a la lista de localidades

  Escenario: El usuario busca localidades por código postal válido
    Dado que el usuario ingresa "44100" en el campo de CP
    Cuando presiona "Busca ubicaciones"
    Entonces el sistema debe validar el formulario
    Y debe actualizar "localidadesPorCodigoPostalProvider" con el CP 44100
    Y debe refrescar "getLocalidadesDelCPFutureProvider"
    Y debe navegar a "AppRoutes.listalocalidades" con el CP como argumento

  Escenario: La pantalla muestra la ubicación actual del usuario
    Dado que el usuario está en "PaginaBuscaLocalidadGMaps"
    Cuando se renderiza el contenido
    Entonces el sistema debe mostrar "Ubicación actual: {addressGM}" desde "ubicacionActualProvider"
    Y debe mostrar "Latitud: {latitud}, Longitud: {longitud}"

  Escenario: La pantalla muestra el mapa de Google Maps
    Dado que el usuario está en "PaginaBuscaLocalidadGMaps"
    Cuando se renderiza el mapa
    Entonces el sistema debe mostrar un "GoogleMap" en un contenedor de 300x300
    Y el mapa debe tener "myLocationEnabled: true"
    Y el mapa debe tener "compassEnabled: true"
    Y el mapa debe mostrar la "initialCameraPosition" de "ubicacionActualProvider"
    Y el mapa debe mostrar los "markers" de "ubicacionActualProvider"

  Escenario: El mapa se inicializa correctamente al crear la pantalla
    Dado que el usuario navega a "PaginaBuscaLocalidadGMaps"
    Cuando el mapa se crea ("onMapCreated")
    Entonces el sistema debe llamar a "ubicacionActualProvider.notifier.onMapCreated(mapController)"
    Y debe guardar el controlador del mapa en el provider

  Escenario: El CP se inicializa desde el provider de búsqueda o de localidades
    Dado que el usuario navega a "PaginaBuscaLocalidadGMaps"
    Cuando se ejecuta "initState"
    Entonces el sistema debe leer "codigoPostalBusquedaProvider"
    Y si es null, debe usar "localidadesPorCodigoPostalProvider.codigoPostal"
    Y si no es null, debe usar el valor del provider de búsqueda

  Escenario: El campo de CP muestra el valor inicial del provider
    Dado que "valorActualProvider" es 44100
    Cuando se renderiza "buildCP"
    Entonces el TextFormField debe mostrar "44100" como initialValue
    Y el campo debe estar enfocado y listo para editar

  Escenario: El campo de CP no muestra valor inicial si es 0
    Dado que "valorActualProvider" es 0
    Cuando se renderiza "buildCP"
    Entonces el TextFormField debe tener "initialValue: null"
    Y el campo debe estar vacío

  Escenario: El formulario guarda el CP al escribir
    Dado que el usuario escribe "55000" en el campo de CP
    Cuando el formulario se guarda ("onSaved")
    Entonces el sistema debe convertir el valor a entero con "int.tryParse"
    Y debe actualizar "valorActualProvider" a 55000
