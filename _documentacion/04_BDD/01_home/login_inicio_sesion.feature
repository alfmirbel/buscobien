# language: es

Característica: Inicio de Sesión con Material Design 3
  Como usuario registrado en BuscoBien
  Quiero poder autenticarme con mi nombre de usuario y contraseña
  Para acceder a las funciones personalizadas de la plataforma (Mi Cuenta, Mis Espacios, Listas, Grupos)

  Antecedentes:
    Dado que el usuario está en la pantalla de "Login"
    Y los campos "Nombre de usuario" y "Clave de acceso" están vacíos
    Y el Dropdown "Perfil" tiene seleccionado el primer valor ("Usuario")

  # ---------------------------------------------------------------------------
  # VALIDACIÓN DE CAMPOS
  # ---------------------------------------------------------------------------
  Escenario: Intento de login con campos vacíos
    Dado que el usuario está en la pantalla de "Login"
    Y el campo "Nombre de usuario" está vacío
    Y el campo "Clave de acceso" está vacío
    Cuando el usuario presiona el botón "Entrar"
    Entonces el sistema debe mostrar un SnackBar con el mensaje "Escriba usuario y contraseña"
    Y el fondo del SnackBar debe usar el color "appTheme.error" del M3 Color Scheme
    Y el botón "Entrar" no debe disparar ninguna petición HTTP

  Escenario: Intento de login solo con usuario, sin contraseña
    Dado que el campo "Nombre de usuario" tiene el valor "juan123"
    Y el campo "Clave de acceso" está vacío
    Cuando el usuario presiona el botón "Entrar"
    Entonces el sistema debe mostrar un SnackBar con el mensaje "Escriba usuario y contraseña"
    Y no debe realizarse ninguna petición HTTP al servidor

  # ---------------------------------------------------------------------------
  # FLUJO DE AUTENTICACIÓN EXITOSA
  # ---------------------------------------------------------------------------
  Escenario: Login exitoso como Usuario (comprador)
    Dado que el campo "Nombre de usuario" contiene "juan_comprador"
    Y el campo "Clave de acceso" contiene una contraseña válida
    Y el Dropdown "Perfil" tiene seleccionado "Usuario"
    Cuando el usuario presiona el botón "Entrar"
    Entonces el sistema debe mostrar un indicador "CircularProgressIndicator" en lugar del botón
    Y el teclado virtual debe ocultarse
    Y el sistema realiza una petición HTTP a la API con las credenciales
    Cuando la API responde con código HTTP "200"
    Entonces el sistema debe guardar en almacenamiento local "userId", "userName", "nombrePerfil" y "userPassHash" (SHA-256)
    Y el sistema debe cargar el avatar del usuario en segundo plano
    Y la sesión debe marcarse como "isAuthenticated = true"
    Y el sistema debe navegar de regreso a la pantalla principal (Navigator.pop(true))
    Y la pestaña "Mi Cuenta" debe mostrar el contenido correspondiente al perfil "Usuario"

  Escenario: Login exitoso como Promotor
    Dado que el campo "Nombre de usuario" contiene "promotor_norte"
    Y el campo "Clave de acceso" contiene una contraseña válida
    Y el Dropdown "Perfil" tiene seleccionado "Promotor"
    Cuando el usuario presiona el botón "Entrar"
    Y la API responde con código HTTP "200"
    Entonces la sesión debe tener "esPromotor = true" y "esUsuario = false"
    Y en la sección "Mi Cuenta" deben aparecer las pestañas "Espacios", "Listas", "Grupos" y "Conocidos"

  # ---------------------------------------------------------------------------
  # FLUJO DE AUTENTICACIÓN FALLIDA
  # ---------------------------------------------------------------------------
  Escenario: Login con credenciales incorrectas
    Dado que el campo "Nombre de usuario" contiene "usuario_incorrecto"
    Y el campo "Clave de acceso" contiene "clave_erronea"
    Cuando el usuario presiona el botón "Entrar"
    Y la API responde con un código diferente a "200"
    Entonces el sistema debe mostrar un AlertDialog con el título "Error de Ingreso"
    Y el mensaje debe ser "Usuario o contraseña incorrectos."
    Y el botón del diálogo debe decir "Intentar de nuevo"
    Y la sesión debe permanecer como "isAuthenticated = false"
    Y el sistema debe regresar a la pantalla de Login para un nuevo intento

  Escenario: Error de red durante el inicio de sesión
    Dado que el campo "Nombre de usuario" contiene "usuario_valido"
    Y el campo "Clave de acceso" contiene "clave_valida"
    Cuando el usuario presiona el botón "Entrar"
    Y la conexión a Internet falla durante la petición
    Entonces el sistema debe capturar la excepción
    Y mostrar un SnackBar con el mensaje "Error inesperado: [descripción del error]"
    Y el fondo del SnackBar debe usar el color "appTheme.error"
    Y el botón "Entrar" debe restablecerse (dejar de mostrar el CircularProgressIndicator)

  # ---------------------------------------------------------------------------
  # SELECTOR DE PERFIL
  # ---------------------------------------------------------------------------
  Escenario: El usuario cambia el perfil en el Dropdown antes de ingresar
    Dado que el Dropdown "Perfil" muestra "Usuario" como valor inicial
    Cuando el usuario despliega el selector y elige "Promotor"
    Entonces el estado del sessionProvider debe actualizarse con "nombrePerfil = Promotor"
    Y las flags del proveedor deben ajustarse: "esPromotor = true", "esUsuario = false"
    Y el Dropdown debe mostrar "Promotor" como la opción seleccionada
    Y el widget no debe reconstruirse innecesariamente si se elige el mismo valor

  Esquema del escenario: Validación de perfiles disponibles en el Dropdown
    Dado que el usuario está en la pantalla de "Login"
    Cuando el usuario abre el selector "Perfil"
    Entonces el selector debe contener la opción "<perfil>"

    Ejemplos:
      | perfil        |
      | Usuario       |
      | Promotor      |
      | Propietario   |
      | Anfitrión     |
      | Vendedor      |
      | Especialista  |
      | Proveedor     |
      | Asociación    |
      | Inmobiliaria  |

  # ---------------------------------------------------------------------------
  # NAVEGACIÓN DESDE LA PANTALLA DE LOGIN
  # ---------------------------------------------------------------------------
  Escenario: El usuario navega a "Registro" desde la pantalla de Login
    Dado que el usuario está en la pantalla de "Login"
    Cuando presiona el botón "Regístrate"
    Entonces el sistema debe navegar a la ruta "/registro"
    Y la pantalla de registro debe mostrar el título "Registro de [perfil seleccionado]"

  Escenario: El usuario accede a la recuperación de contraseña
    Dado que el usuario está en la pantalla de "Login"
    Cuando presiona el enlace "¿Olvidaste tu clave?"
    Entonces el sistema debe navegar a la ruta "/solicitarrecuperacion"
    Y la pantalla de recuperación debe mostrarse con el AppBar de color primario M3

  # ---------------------------------------------------------------------------
  # CIERRE DE TECLADO AL TOCAR FUERA DEL FORMULARIO
  # ---------------------------------------------------------------------------
  Escenario: El teclado se cierra al tocar fuera de un campo de texto
    Dado que el foco está en el campo "Nombre de usuario" o "Clave de acceso"
    Y el teclado virtual está visible
    Cuando el usuario toca cualquier área de la pantalla fuera de los campos
    Entonces el sistema debe llamar a "FocusScope.unfocus()"
    Y el teclado virtual debe ocultarse

  # ---------------------------------------------------------------------------
  # PERSISTENCIA DE SESIÓN (SESIÓN RESTAURADA AL REINICIAR LA APP)
  # ---------------------------------------------------------------------------
  Escenario: La sesión se restaura automáticamente al reiniciar la app
    Dado que el usuario previamente inició sesión con éxito
    Y los datos "userId", "userName", "nombrePerfil" y "userPassHash" están en el almacenamiento local
    Cuando la aplicación se reinicia
    Entonces el sistema debe leer los datos del almacenamiento local en "getSessionValuesFromLocalStorage()"
    Y el estado debe marcarse como "isAuthenticated = true"
    Y el sistema debe cargar los datos completos del usuario en segundo plano
    Y el usuario debe ver directamente su sección "Mi Cuenta" sin necesidad de ingresar sus credenciales
