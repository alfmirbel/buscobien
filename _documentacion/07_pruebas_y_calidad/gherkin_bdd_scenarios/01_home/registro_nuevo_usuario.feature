# language: es

Característica: Registro de Nuevo Usuario
  Como persona que desea usar BuscoBien
  Quiero registrarme en la plataforma seleccionando mi perfil
  Para acceder a las funciones disponibles según mi rol (Usuario comprador, Promotor, etc.)

  Antecedentes:
    Dado que el usuario está en la pantalla de "Registro"
    Y el sistema ha preseleccionado el perfil correspondiente al que se eligió en la pantalla de Login
    Y los campos del formulario están vacíos

  # ---------------------------------------------------------------------------
  # CAMPOS DEL FORMULARIO
  # ---------------------------------------------------------------------------
  Escenario: Visualización de campos requeridos para un Usuario comprador
    Dado que el perfil seleccionado es "Usuario"
    Cuando el usuario accede a la pantalla de registro
    Entonces el formulario debe mostrar los campos:
      | Campo              |
      | Nombre de usuario  |
      | Clave de acceso    |
      | Valida clave       |
      | Correo electrónico |
      | Número de celular  |
      | Nombres            |
      | Apellido paterno   |
      | Apellido materno   |
    Y el campo "RFC" NO debe ser visible

  Escenario: Visualización del campo RFC para un Promotor
    Dado que el perfil seleccionado es "Promotor"
    Cuando el usuario accede a la pantalla de registro
    Entonces el formulario debe mostrar todos los campos del Usuario
    Y adicionalmente debe mostrar el campo "RFC"

  # ---------------------------------------------------------------------------
  # VALIDACIÓN DE TÉRMINOS Y CONDICIONES
  # ---------------------------------------------------------------------------
  Escenario: El botón de envío está deshabilitado si no se aceptan Términos y Condiciones
    Dado que el usuario llenó todos los campos del formulario
    Y el checkbox "Términos y Condiciones" NO está marcado
    Cuando intenta presionar el botón de registro
    Entonces el botón debe estar deshabilitado (onPressed = null)
    Y el formulario no debe enviarse

  Escenario: El botón de envío está deshabilitado si no se acepta el Aviso de Privacidad
    Dado que el usuario llenó todos los campos del formulario
    Y el checkbox "Términos y Condiciones" SÍ está marcado
    Y el checkbox "Aviso de Privacidad" NO está marcado
    Cuando intenta presionar el botón de registro
    Entonces el botón debe estar deshabilitado
    Y el formulario no debe enviarse

  Escenario: El botón de registro se habilita al aceptar ambos documentos
    Dado que el usuario llenó todos los campos del formulario correctamente
    Y el checkbox "Términos y Condiciones" SÍ está marcado
    Y el checkbox "Aviso de Privacidad" SÍ está marcado
    Cuando el usuario presiona el botón de registro
    Entonces el sistema debe validar el formulario con "_formKeyRegistroUsers.validate()"
    Y si la validación pasa debe enviar el registro al servidor

  # ---------------------------------------------------------------------------
  # VALIDACIÓN DE CONTRASEÑA
  # ---------------------------------------------------------------------------
  Escenario: Las contraseñas no coinciden
    Dado que el usuario escribe "miClave123" en el campo "Clave de acceso"
    Y escribe "miClave456" en el campo "Valida clave de acceso"
    Cuando el usuario presiona el botón de registro
    Entonces el formulario debe mostrar un error de validación en el campo "Valida clave"
    Y el mensaje de error debe indicar que las contraseñas no coinciden
    Y el registro no debe enviarse al servidor

  # ---------------------------------------------------------------------------
  # TÍTULO DINÁMICO SEGÚN PERFIL
  # ---------------------------------------------------------------------------
  Escenario: El AppBar muestra el perfil seleccionado en el título
    Dado que el perfil activo en el sessionProvider es "Promotor"
    Cuando el usuario está en la pantalla de registro
    Entonces el AppBar debe mostrar el título "Registro de Promotor"

  Esquema del escenario: El AppBar adapta su título al perfil activo
    Dado que el perfil activo es "<perfil>"
    Entonces el AppBar debe mostrar "Registro de <perfil>"

    Ejemplos:
      | perfil       |
      | Usuario      |
      | Promotor     |
      | Propietario  |
      | Especialista |

  # ---------------------------------------------------------------------------
  # REGISTRO EXITOSO
  # ---------------------------------------------------------------------------
  Escenario: Registro exitoso de un nuevo Usuario comprador
    Dado que todos los campos están completos y válidos
    Y se han aceptado los Términos y Condiciones y el Aviso de Privacidad
    Cuando el usuario presiona el botón de registro
    Entonces el sistema debe generar el hash SHA-256 de la contraseña
    Y debe enviar los datos al servidor (writeUserToCouchDB)
    Cuando el servidor responde con código "201" (creado)
    Entonces el sistema debe mostrar un diálogo de confirmación de registro exitoso
    Y el usuario debe poder navegar al Login para iniciar sesión

  Escenario: El nombre de usuario ya existe en la base de datos
    Dado que todos los campos están completos y válidos
    Cuando el usuario presiona el botón de registro
    Y el servidor responde con un error de "usuario duplicado"
    Entonces el sistema debe mostrar un diálogo de error con el mensaje correspondiente
    Y el usuario debe permanecer en la pantalla de registro para corregir el dato
