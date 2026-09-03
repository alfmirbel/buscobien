# language: es

Característica: Gestión del Estado de Sesión (SessionProvider)
  Como sistema de autenticación de BuscoBien
  Quiero mantener el estado de la sesión del usuario de forma segura e inmutable
  Para garantizar que la interfaz refleje siempre el estado real de autenticación y el perfil del usuario

  # ---------------------------------------------------------------------------
  # ESTADO INICIAL DE SESIÓN
  # ---------------------------------------------------------------------------
  Escenario: Estado inicial de sesión al arrancar la app sin sesión previa
    Dado que no hay datos de sesión en el almacenamiento local
    Cuando la aplicación arranca y llama a "getSessionValuesFromLocalStorage()"
    Entonces el estado "isAuthenticated" debe ser "false"
    Y el estado "nombrePerfil" debe ser una cadena vacía ""
    Y el estado "esUsuario", "esPromotor" y todos los flags de rol deben ser "false"
    Y el estado "isUserDataLoaded" debe ser "false"

  # ---------------------------------------------------------------------------
  # RESTAURACIÓN DE SESIÓN DESDE ALMACENAMIENTO LOCAL
  # ---------------------------------------------------------------------------
  Escenario: Restauración exitosa de sesión previamente guardada
    Dado que el almacenamiento local contiene los datos:
      | Clave        | Valor                     |
      | userId       | "user:abc123"             |
      | userName     | "maria_garcia"            |
      | nombrePerfil | "Promotor"                |
      | userPassHash | "sha256hashxxxxxxx"       |
    Cuando la aplicación llama a "getSessionValuesFromLocalStorage()"
    Entonces el estado "isAuthenticated" debe ser "true"
    Y el estado "sessionUserData.userId" debe ser "user:abc123"
    Y el estado "sessionUserData.userName" debe ser "maria_garcia"
    Y el estado "nombrePerfil" debe ser "Promotor"
    Y el sistema debe llamar a "setPerfilUsuarioByNombrePerfil()" para activar los flags de rol

  Escenario: El almacenamiento local está vacío (primera instalación)
    Dado que el almacenamiento local no contiene "userId" ni "userName"
    Cuando la aplicación llama a "getSessionValuesFromLocalStorage()"
    Entonces el método debe retornar sin hacer ningún cambio de estado
    Y "isAuthenticated" debe permanecer como "false"

  # ---------------------------------------------------------------------------
  # FLAGS DE ROL POR PERFIL
  # ---------------------------------------------------------------------------
  Esquema del escenario: Activación correcta de flags de rol según perfil
    Dado que el sessionProvider tiene "nombrePerfil = <perfil>"
    Cuando el sistema llama a "setPerfilUsuarioByNombrePerfil()"
    Entonces el flag "<flag>" debe ser "true"
    Y todos los demás flags de rol deben ser "false"

    Ejemplos:
      | perfil       | flag           |
      | Usuario      | esUsuario      |
      | Promotor     | esPromotor     |
      | Propietario  | esPropietario  |
      | Anfitrión    | esAnfrition    |
      | Vendedor     | esVendedor     |
      | Especialista | esEspecialista |
      | Proveedor    | esProveedor    |
      | Asociación   | esAsociacion   |
      | Inmobiliaria | esInmobiliaria |

  # ---------------------------------------------------------------------------
  # ACTUALIZACIÓN DE VARIABLES DE SESIÓN
  # ---------------------------------------------------------------------------
  Escenario: Actualización del nombre de usuario en la sesión
    Dado que el estado de sesión está activo
    Cuando el sistema llama a "setSessionVarValue('userName', 'nuevo_usuario')"
    Entonces el estado "sessionUserData.userName" debe ser "nuevo_usuario"
    Y el objeto "sessionUserData" debe ser una nueva instancia inmutable (copyWith)
    Y el estado anterior no debe ser mutado

  Escenario: El estado de Riverpod se actualiza de forma inmutable
    Dado que el estado actual de "sessionUserData" tiene "userId = 'user:001'"
    Cuando el sistema aplica "setSessionVarValue('userName', 'juan')"
    Entonces el estado resultante debe contener tanto "userId = 'user:001'" como "userName = 'juan'"
    Y la actualización debe ser atómica (un solo "state = state.copyWith(...)")

  # ---------------------------------------------------------------------------
  # CIERRE DE SESIÓN Y LIMPIEZA
  # ---------------------------------------------------------------------------
  Escenario: Cierre de sesión y limpieza de datos locales
    Dado que el usuario tiene una sesión activa
    Cuando el sistema llama a "deleteLocalSessionData()"
    Entonces todos los datos del almacenamiento local deben eliminarse ("storage.deleteAll()")
    Y el método debe retornar "true"

  Escenario: Reset completo del estado al cerrar sesión (sección 0)
    Dado que el usuario tiene una sesión activa con datos cargados
    Cuando el sistema llama a "resetInitialUserData(0)"
    Entonces el estado "isAuthenticated" debe ser "false"
    Y el estado "isUserDataLoaded" debe ser "false"
    Y todos los flags de rol deben ser "false"
    Y los campos de "sessionUserData" deben resetearse a valores vacíos
    Y "nombrePerfil" debe ser una cadena vacía ""

  # ---------------------------------------------------------------------------
  # GUARDADO EN ALMACENAMIENTO LOCAL
  # ---------------------------------------------------------------------------
  Escenario: Guardado seguro del hash de contraseña
    Dado que el login fue exitoso
    Cuando el sistema llama a "saveVarValueToLocalStorage('userPassHash', hashSha256)"
    Entonces el valor guardado debe ser el hash SHA-256 de la contraseña
    Y la contraseña en texto plano NUNCA debe guardarse en el almacenamiento local

  # ---------------------------------------------------------------------------
  # CACHÉ DE DATOS DE USUARIO
  # ---------------------------------------------------------------------------
  Escenario: Los datos completos del usuario se cargan una sola vez
    Dado que "isUserDataLoaded = false"
    Cuando el sistema llama a "getUserDataByNameInSessionData()" y la API responde con "200"
    Entonces el estado "isUserDataLoaded" debe cambiar a "true"
    Y los datos completos del usuario deben quedar disponibles en "userData"

  Escenario: Los datos del usuario no se recargan si ya están en caché
    Dado que "isUserDataLoaded = true"
    Y los datos del usuario ya están en el estado "userData"
    Cuando la pantalla de perfil se abre
    Entonces el sistema NO debe realizar una nueva petición HTTP al servidor
    Y debe usar los datos ya almacenados en el estado de Riverpod
