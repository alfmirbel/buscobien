# language: es
Característica: Lista de Localidades por Código Postal
  Como usuario de BuscoBien
  Quiero ver las localidades disponibles para un código postal específico
  Para seleccionar mi zona de interés y guardarla en mi lista

  Escenario: La pantalla carga las localidades para un código postal
    Dado que el usuario navega a "LocalidadesListScreen" con código postal "44100"
    Cuando el provider "getLocalidadesDelCPFutureProvider" completa la carga
    Entonces el sistema debe mostrar la lista de localidades del CP 44100
    Y el AppBar debe mostrar el título "Localidades del CP 44100"

  Escenario: La pantalla muestra un indicador de carga mientras obtiene localidades
    Dado que el usuario acaba de navegar a "LocalidadesListScreen"
    Cuando "getLocalidadesDelCPFutureProvider" está en estado "loading"
    Entonces el sistema debe mostrar un "CircularProgressIndicator" centrado

  Escenario: La pantalla muestra error si falla la carga de localidades
    Dado que el usuario está en "LocalidadesListScreen"
    Cuando "getLocalidadesDelCPFutureProvider" emite un estado "error"
    Entonces el sistema debe mostrar "PaginaSinConeccion" con el mensaje "No se pueden obtener las localidades."

  Escenario: Cada localidad muestra todos sus datos en una tarjeta
    Dado que el usuario está en la lista de localidades de un CP
    Cuando se renderiza una tarjeta de localidad
    Entonces el sistema debe mostrar Localidad, Código Postal, Estado, Municipio, Ciudad, Zona y Tipo
    Y cada dato debe estar en color "appTheme.onPrimaryContainer"
    Y la tarjeta debe tener elevación 10 y sombra en "appTheme.surface"

  Escenario: El usuario selecciona una localidad sin sesión iniciada
    Dado que el usuario no ha iniciado sesión
    Cuando presiona una localidad en la lista
    Entonces el sistema debe actualizar la sesión con "updateLocalidadEnSesion(localidadCp)"
    Y debe navegar a "AppRoutes.principal" con pushReplacementNamed
    Y no debe mostrar el diálogo de guardado

  Escenario: El usuario selecciona una localidad ya guardada
    Dado que el usuario ha iniciado sesión
    Y la localidad seleccionada ya está en su lista ("gdtLocalidadUsuario" retorna 200)
    Cuando presiona la localidad
    Entonces el sistema debe mostrar un SnackBar con "'{asentamiento}' ya está en tu lista de localidades."
    Y el SnackBar debe tener fondo "appTheme.secondary"
    Y después de 3 segundos debe navegar a "AppRoutes.principal"

  Escenario: El usuario selecciona una localidad nueva y la guarda
    Dado que el usuario ha iniciado sesión
    Y la localidad seleccionada no está en su lista ("gdtLocalidadUsuario" retorna 404)
    Cuando presiona la localidad
    Entonces el sistema debe mostrar el diálogo "Mis Localidades" con la pregunta "¿Deseas agregar esta localidad a tu lista?"
    Y si el usuario presiona "Sí, guardar" debe llamar a "writeUserLocalidadToCouchDB"
    Y si el resultado es 200 debe refrescar "fetchLocalidadesDeUsuario"
    Y debe navegar a "AppRoutes.principal"

  Escenario: El usuario cancela el guardado de una localidad
    Dado que el diálogo "Mis Localidades" está abierto
    Cuando el usuario presiona "No"
    Entonces el sistema debe navegar a "AppRoutes.principal" sin guardar
    Y la localidad no debe agregarse a la lista del usuario

  Escenario: El mapa se actualiza con la localidad seleccionada
    Dado que el usuario está en la pantalla de búsqueda de localidades
    Cuando selecciona una localidad de la lista
    Entonces el sistema debe actualizar "localidadesPorCodigoPostalProvider" con la localidad seleccionada
    Y el mapa debe centrarse en la nueva localidad
    Y los marcadores deben actualizarse para reflejar la selección
