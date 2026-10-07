# language: es

Característica: Búsqueda de Localidades y Geolocalización
  Como usuario de BuscoBien
  Quiero buscar propiedades por ubicación geográfica (código postal, municipio, estado)
  Para encontrar espacios disponibles en la zona que me interesa

  Antecedentes:
    Dado que la aplicación tiene acceso al módulo de localidades (SEPOMEX)

  # ---------------------------------------------------------------------------
  # DETECCIÓN AUTOMÁTICA DE UBICACIÓN
  # ---------------------------------------------------------------------------
  Escenario: El sistema detecta la ubicación GPS del usuario al iniciar
    Dado que la aplicación acaba de arrancar
    Cuando el sistema solicita permisos de ubicación al usuario
    Y el usuario concede el permiso
    Entonces el sistema debe obtener las coordenadas actuales del usuario
    Y debe determinar el código postal basado en las coordenadas
    Y debe llamar a "fetchLocalidadesCodigoPostal()" para obtener la localidad
    Cuando la API responde con código "200"
    Entonces el filtro de ámbito geográfico debe cambiar automáticamente a "C.P." (índice 3)
    Y las propiedades de la pantalla principal deben filtrarse por ese código postal

  Escenario: El usuario deniega el permiso de ubicación
    Dado que el sistema solicita permisos de ubicación
    Cuando el usuario niega el permiso
    Entonces el sistema NO debe mostrar un error bloqueante
    Y debe seguir funcionando con el filtro geográfico predeterminado
    Y el proceso de detección de ubicación debe terminar silenciosamente

  Escenario: Error al obtener la ubicación GPS
    Dado que el usuario concedió permisos de ubicación
    Cuando la obtención de coordenadas falla por cualquier motivo (error de hardware, timeout)
    Entonces el sistema debe capturar la excepción silenciosamente
    Y registrar el error en los logs de depuración ("debugPrintLevels")
    Y la aplicación debe continuar funcionando normalmente

  # ---------------------------------------------------------------------------
  # BÚSQUEDA MANUAL DE LOCALIDADES
  # ---------------------------------------------------------------------------
  Escenario: El usuario busca una localidad manualmente desde la sección Ubicación
    Dado que el usuario está en la pestaña "Ubicación" (indiceInicial = 2)
    Cuando accede a la pantalla "PaginaPrincipalListaLocalidades"
    Entonces debe poder buscar por código postal, municipio o estado
    Y el sistema debe mostrar una lista de resultados coincidentes

  Escenario: El usuario selecciona una localidad de los resultados de búsqueda
    Dado que la búsqueda de localidades muestra resultados
    Cuando el usuario selecciona una localidad de la lista
    Entonces el sistema debe actualizar el filtro de ubicación con la localidad seleccionada
    Y las propiedades deben refiltrarse según la nueva ubicación

  Escenario: El usuario busca una localidad por código postal en el mapa
    Dado que el usuario está en la sección de ubicación
    Cuando accede a la pantalla "PaginaBuscaLocalidadGMaps"
    Entonces el mapa debe mostrar la ubicación actual del usuario
    Y el usuario debe poder buscar por nombre de colonia, municipio o código postal
    Y al seleccionar una localidad el mapa debe centrar la vista en ella

  # ---------------------------------------------------------------------------
  # LISTA DE LOCALIDADES POR CÓDIGO POSTAL
  # ---------------------------------------------------------------------------
  Escenario: El sistema obtiene localidades para un código postal dado
    Dado que el código postal actual es "44100"
    Cuando el sistema llama a "fetchLocalidadesCodigoPostal()"
    Entonces la respuesta de la API debe retornar una lista de asentamientos para ese C.P.
    Y el estado "codigoPostal" del provider debe actualizarse con "44100"

  Escenario: No se encuentran localidades para el código postal
    Dado que el sistema busca localidades para el código postal "00000" (inexistente)
    Cuando la API responde sin resultados
    Entonces el sistema debe mostrar un mensaje indicando que no se encontraron localidades
    Y el filtro de ubicación debe quedar sin cambios

  # ---------------------------------------------------------------------------
  # MAPA DE PROPIEDADES
  # ---------------------------------------------------------------------------
  Escenario: El usuario visualiza las propiedades filtradas en el mapa
    Dado que hay una lista de propiedades filtradas visible
    Cuando el usuario selecciona la opción "Ver en mapa"
    Entonces el sistema debe navegar a la ruta "/mapapropiedades"
    Y pasar la lista de propiedades como argumento "EspaciosCasaGet"
    Y la pantalla "PaginaMapaPropiedades" debe mostrar marcadores para cada propiedad

  Escenario: El usuario toca un marcador en el mapa para ver detalles
    Dado que el usuario está en el mapa de propiedades
    Cuando toca el marcador de una propiedad
    Entonces el sistema debe mostrar una ventana informativa con los datos básicos de la propiedad
    Y debe haber una opción para ver el detalle completo de la propiedad

  # ---------------------------------------------------------------------------
  # NAVEGACIÓN ENTRE SECCIÓN UBICACIÓN Y PROPIEDADES
  # ---------------------------------------------------------------------------
  Escenario: La ubicación seleccionada se aplica como filtro en la búsqueda de propiedades
    Dado que el usuario seleccionó la localidad "Zapopan, Jalisco" en el módulo de ubicación
    Cuando regresa a la sección "Propiedades"
    Entonces las propiedades mostradas deben corresponder a la localidad "Zapopan, Jalisco"
    Y el filtro de nivel de gobierno debe reflejar la selección geográfica activa
