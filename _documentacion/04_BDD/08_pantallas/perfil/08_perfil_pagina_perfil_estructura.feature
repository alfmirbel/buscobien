# language: es
Característica: Estructura y Contenido del Perfil de Usuario
  Como usuario autenticado o invitado
  Quiero ver mi información personal, dirección y datos profesionales en la pantalla de perfil
  Para consultar y gestionar mi cuenta dentro de BuscoBien

  Escenario: El perfil muestra la vista de invitado cuando no hay sesión
    Dado que el usuario no ha iniciado sesión (userId vacío)
    Cuando navega a la sección "Perfil" (indiceInicial = 4)
    Entonces el sistema debe mostrar "_buildNoUserView()"
    Y debe mostrar el icono "Symbols.person_off_rounded" en color primario
    Y debe mostrar el texto "No has iniciado sesión"
    Y debe mostrar el botón "Iniciar Sesión" que abre "dialogBoxFichaLogin"

  Escenario: El perfil carga los datos del usuario desde caché si ya fueron precargados
    Dado que el usuario ya inició sesión
    Y "sessionProvider.isUserDataLoaded" es true
    Cuando navega a la sección "Perfil"
    Entonces el sistema no debe llamar a "getUserDataByNameInSessionData()"
    Y debe mostrar el perfil inmediatamente usando los datos en caché

  Escenario: El perfil carga los datos del usuario desde el servidor si no hay caché
    Dado que el usuario ya inició sesión
    Y "sessionProvider.isUserDataLoaded" es false
    Cuando navega a la sección "Perfil"
    Entonces el sistema debe llamar a "getUserDataByNameInSessionData()"
    Y debe mostrar "stateWaiting" mientras se cargan los datos

  Escenario: El perfil muestra un indicador de carga mientras obtiene los datos
    Dado que el usuario navegó a "Perfil"
    Y "getUserDataByNameInSessionData()" está en progreso
    Cuando se renderiza el FutureBuilder
    Entonces el sistema debe mostrar "stateWaiting" con "widthCuadroFotoPropiedad" y "heightCuadroFotoPropiedad"
    Y no debe mostrar información personal ni botones de acción

  Escenario: El perfil muestra error si falla la carga de datos
    Dado que "getUserDataByNameInSessionData()" retorna error
    Cuando el FutureBuilder recibe el resultado
    Entonces el sistema debe mostrar "stateErrorFormat" con el mensaje de error
    Y no debe mostrar las secciones de información personal

  Escenario: El perfil muestra estado vacío cuando no hay datos de usuario
    Dado que la carga fue exitosa
    Y "sessionProvider.userData.rows" está vacío
    Cuando se renderiza la vista de perfil
    Entonces el sistema debe mostrar "_buildNoUserView()"
    Y debe mostrar el mensaje de no sesión

  Escenario: El perfil muestra el header con avatar y nombre de usuario
    Dado que el usuario tiene datos cargados en "sessionProvider.userData.rows[0]"
    Cuando se renderiza "_buildUserProfileView"
    Entonces el sistema debe mostrar un header con fondo "appTheme.primary" y bordes redondeados inferior
    Y debe mostrar el avatar en "CircleAvatar" de radio 55
    Y debe mostrar el nombre completo: "nombres apellidopaterno apellidomaterno"
    Y debe mostrar el rol en un chip con fondo blanco alpha 0.2

  Escenario: El avatar muestra imagen si existe, o icono por defecto si no
    Dado que el usuario tiene avatar guardado en "classUserAvatarProvider.rows[0].avatar"
    Cuando se renderiza el header del perfil
    Entonces el sistema debe mostrar "MemoryImage" con la imagen del avatar
    Y debe mostrar el icono "Symbols.edit" en botón circular para editar
    Y al presionar el botón debe navegar a "AppRoutes.gestionavatar"

  Escenario: El avatar muestra icono por defecto si no hay imagen guardada
    Dado que el usuario no tiene avatar guardado
    Cuando se renderiza el header del perfil
    Entonces el sistema debe mostrar "Icon(Symbols.person)" en color gris
    Y no debe mostrar imagen de fondo en el CircleAvatar

  Escenario: El perfil muestra la sección de Información Personal
    Dado que el usuario está autenticado y tiene datos cargados
    Cuando se renderiza "_buildUserProfileView"
    Entonces el sistema debe mostrar la sección "Información Personal"
    Y debe mostrar "Nombre Usuario" con "userRow.nombreusuario"
    Y debe mostrar "Correo" con "userRow.correoelectronico"
    Y debe mostrar "Celular" con "userRow.numerocelular"
    Y debe mostrar "Fecha Nacimiento" formateada como "dia/mes/anio"

  Escenario: Los campos vacíos o con valor 0 muestran "No registrado"
    Dado que el usuario tiene "numerocelular" vacío o "0"
    Cuando se renderiza la fila de perfil correspondiente
    Entonces el sistema debe mostrar "No registrado" en lugar del valor vacío

  Escenario: El perfil muestra la sección de Dirección Registrada
    Dado que el usuario está autenticado y tiene datos de ubicación
    Cuando se renderiza "_buildUserProfileView"
    Entonces el sistema debe mostrar la sección "Dirección Registrada"
    Y debe mostrar "Estado / Municipio" con "estado, municipio"
    Y debe mostrar "Colonia / Asentamiento" con "asentamiento (CP: cp)"
    Y debe mostrar "Calle y Número" con "userRow.ubicacionUserData.calle"

  Escenario: El perfil muestra la sección profesional solo para promotores
    Dado que el usuario tiene perfil "Promotor" ("sessionData.esPromotor = true")
    Cuando se renderiza "_buildUserProfileView"
    Entonces el sistema debe mostrar la sección "Perfil Profesional"
    Y debe mostrar "Inmobiliaria" o "Independiente" si está vacío
    Y debe mostrar "RFC" con "userRow.datospromotor.rfc"
    Y debe mostrar "No. Cliente" con "userRow.datospromotor.numerodecliente"

  Escenario: El perfil oculta la sección profesional para usuarios no promotores
    Dado que el usuario tiene perfil "Usuario" o "Propietario"
    Cuando se renderiza "_buildUserProfileView"
    Entonces el sistema no debe mostrar la sección "Perfil Profesional"
    Y no debe mostrar los campos de RFC, inmobiliaria o número de cliente
