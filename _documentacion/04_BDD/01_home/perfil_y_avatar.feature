# language: es

Característica: Perfil de Usuario y Gestión de Avatar
  Como usuario autenticado en BuscoBien (cualquier perfil)
  Quiero ver y editar mi perfil personal y gestionar mi foto de avatar
  Para que mi información esté actualizada en la plataforma

  Antecedentes:
    Dado que el usuario está autenticado
    Y el sessionProvider tiene "isAuthenticated = true"

  # ---------------------------------------------------------------------------
  # VISUALIZACIÓN DEL PERFIL
  # ---------------------------------------------------------------------------
  Escenario: El usuario accede a su perfil desde el menú principal
    Dado que el usuario está en la pantalla principal
    Cuando presiona la pestaña "Perfil" (indiceInicial = 4)
    Entonces el sistema debe mostrar "PaginaPerfilWidget"
    Y la pantalla debe pre-cargar los datos del usuario desde el sessionProvider

  Escenario: El perfil muestra los datos del usuario cargados en caché
    Dado que "isUserDataLoaded = true" en el sessionProvider
    Cuando el usuario navega a su perfil
    Entonces el sistema NO debe realizar una nueva petición HTTP
    Y debe mostrar los datos ya disponibles en el estado de Riverpod

  Escenario: El perfil carga datos del usuario desde el servidor si no están en caché
    Dado que "isUserDataLoaded = false"
    Cuando el usuario navega a su perfil
    Entonces el sistema debe llamar a "getUserDataByNameInSessionData()"
    Y mostrar un indicador de carga mientras espera la respuesta de la API
    Y al recibir los datos mostrarlos en el formulario de perfil

  # ---------------------------------------------------------------------------
  # EDICIÓN DEL PERFIL
  # ---------------------------------------------------------------------------
  Escenario: El usuario actualiza su número de celular
    Dado que el usuario está en la pantalla de perfil
    Cuando edita el campo "Número de celular" y guarda
    Entonces el sistema debe enviar la actualización al servidor vía API
    Y el estado local "userData" del sessionProvider debe reflejar el nuevo número

  Escenario: El usuario actualiza su ubicación (código postal y localidad)
    Dado que el usuario está en la pantalla de perfil
    Cuando presiona el botón de "Cambiar localidad"
    Entonces el sistema debe navegar a la búsqueda de localidades
    Y al seleccionar una localidad debe actualizar el estado con "updateLocalidadEnSesion(loc)"
    Y los datos de localidad (estado, municipio, ciudad, C.P.) deben actualizarse en el perfil

  # ---------------------------------------------------------------------------
  # GESTIÓN DE AVATAR
  # ---------------------------------------------------------------------------
  Escenario: El usuario accede a la gestión de su avatar
    Dado que el usuario está en cualquier sección autenticada
    Cuando accede a la opción "Cambiar foto de perfil"
    Entonces el sistema debe navegar a la ruta "/gestionavatar"
    Y la pantalla "GestionAvatares" debe mostrar la foto actual del usuario (si existe)

  Escenario: La app carga el avatar del usuario al iniciar sesión
    Dado que el login fue exitoso y se obtuvo el "userId" del usuario
    Cuando el sistema completa el proceso de autenticación
    Entonces debe llamar a "recuperaDatosDelAvatar(currentUserId)" en segundo plano
    Y el avatar debe estar disponible en la UI sin bloquear la navegación principal

  Escenario: La app restaura el avatar del usuario al recuperar la sesión
    Dado que la app recupera una sesión guardada con "userId = 'user:abc'"
    Cuando "getSessionValuesFromLocalStorage()" determina que "isAuthenticated = true"
    Entonces el sistema debe llamar a "recuperaDatosDelAvatar('user:abc')
    Y el avatar debe cargarse de forma asíncrona en segundo plano

  # ---------------------------------------------------------------------------
  # CAMBIO DE PREFERENCIAS Y COLORES
  # ---------------------------------------------------------------------------
  Escenario: El usuario accede a las preferencias de color de la aplicación
    Dado que el usuario está en la sección de configuración
    Cuando selecciona la opción "Preferencias"
    Entonces el sistema debe navegar a la ruta "/preferencias"
    Y la pantalla "PaginaColores" debe mostrar las opciones de tema disponibles

  # ---------------------------------------------------------------------------
  # DATOS DEL PROMOTOR EN EL PERFIL
  # ---------------------------------------------------------------------------
  Escenario: El perfil del promotor muestra información adicional de negocio
    Dado que el usuario autenticado tiene perfil "Promotor"
    Cuando accede a su perfil
    Entonces el formulario debe mostrar campos adicionales:
      | Campo                   |
      | RFC                     |
      | Número de cliente       |
      | Inmobiliaria            |
      | Espacios normales       |
      | Espacios destacados     |
      | Espacios superdestacados|
      | Espacios oportunidad    |
      | Espacios remate         |
