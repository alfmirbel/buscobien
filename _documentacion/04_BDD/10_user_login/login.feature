# language: es
Característica: Inicio de Sesión en BuscoBien
  Como usuario de BuscoBien
  Quiero autenticarme en la aplicación
  Para acceder a las funcionalidades según mi perfil

  Antecedentes:
    Dado que el usuario se encuentra en la pantalla de "Inicio de Sesión"
    Y los campos de usuario y contraseña están vacíos

  Escenario: Validación de campos obligatorios
    Dado que el usuario está en la pantalla de "Login"
    Y el campo de "Nombre de usuario" está vacío
    Y el campo de "Clave de acceso" está vacío
    Cuando el usuario presiona el botón "Entrar"
    Entonces el sistema deberá mostrar un mensaje "Escriba usuario y contraseña"
    Y el sistema deberá mantener la pantalla de login visible

  Escenario: Login exitoso como Usuario
    Dado que el usuario ha ingresado un nombre de usuario válido
    Y ha ingresado una contraseña válida
    Y ha seleccionado el perfil "Usuario"
    Cuando el usuario presiona el botón "Entrar"
    Entonces el sistema deberá validar las credenciales contra CouchDB
    Y el sistema deberá obtener el ID y nombre del usuario
    Y el sistema deberá marcar la sesión como autenticada
    Y el sistema deberá guardar el userId, userName, nombrePerfil y hash SHA-256 de la contraseña en almacenamiento local
    Y el sistema deberá recuperar los datos completos del usuario por nombre y perfil
    Y el sistema deberá cerrar el diálogo de login con resultado exitoso

  Escenario: Login exitoso como Promotor
    Dado que el usuario ha ingresado un nombre de usuario válido
    Y ha ingresado una contraseña válida
    Y ha seleccionado el perfil "Promotor"
    Cuando el usuario presiona el botón "Entrar"
    Entonces el sistema deberá validar las credenciales contra CouchDB
    Y el sistema deberá marcar la sesión como autenticada
    Y el sistema deberá establecer el flag esPromotor en true
    Y el sistema deberá recuperar los datos del promotor incluyendo espacios contratados

  Escenario: Login exitoso como Propietario
    Dado que el usuario ha ingresado credenciales válidas
    Y ha seleccionado el perfil "Propietario"
    Cuando el usuario presiona "Entrar"
    Entonces el sistema deberá validar las credenciales contra CouchDB
    Y el sistema deberá marcar la sesión como autenticada
    Y el sistema deberá establecer el flag esPropietario en true

  Escenario: Login exitoso como Anfitrión
    Dado que el usuario ha ingresado credenciales válidas
    Y ha seleccionado el perfil "Anfitrión"
    Cuando el usuario presiona "Entrar"
    Entonces el sistema deberá validar las credenciales contra CouchDB
    Y el sistema deberá marcar la sesión como autenticada
    Y el sistema deberá establecer el flag esAnfrition en true

  Escenario: Login exitoso como Vendedor
    Dado que el usuario ha ingresado credenciales válidas
    Y ha seleccionado el perfil "Vendedor"
    Cuando el usuario presiona "Entrar"
    Entonces el sistema deberá validar las credenciales contra CouchDB
    Y el sistema deberá marcar la sesión como autenticada
    Y el sistema deberá establecer el flag esVendedor en true

  Escenario: Login exitoso como Especialista
    Dado que el usuario ha ingresado credenciales válidas
    Y ha seleccionado el perfil "Especialista"
    Cuando el usuario presiona "Entrar"
    Entonces el sistema deberá validar las credenciales contra CouchDB
    Y el sistema deberá marcar la sesión como autenticada
    Y el sistema deberá establecer el flag esEspecialista en true

  Escenario: Login exitoso como Proveedor
    Dado que el usuario ha ingresado credenciales válidas
    Y ha seleccionado el perfil "Proveedor"
    Cuando el usuario presiona "Entrar"
    Entonces el sistema deberá validar las credenciales contra CouchDB
    Y el sistema deberá marcar la sesión como autenticada
    Y el sistema deberá establecer el flag esProveedor en true

  Escenario: Login exitoso como Asociación
    Dado que el usuario ha ingresado credenciales válidas
    Y ha seleccionado el perfil "Asociación"
    Cuando el usuario presiona "Entrar"
    Entonces el sistema deberá validar las credenciales contra CouchDB
    Y el sistema deberá marcar la sesión como autenticada
    Y el sistema deberá establecer el flag esAsociacion en true

  Escenario: Login exitoso como Inmobiliaria
    Dado que el usuario ha ingresado credenciales válidas
    Y ha seleccionado el perfil "Inmobiliaria"
    Cuando el usuario presiona "Entrar"
    Entonces el sistema deberá validar las credenciales contra CouchDB
    Y el sistema deberá marcar la sesión como autenticada
    Y el sistema deberá establecer el flag esInmobiliaria en true

  Escenario: Credenciales incorrectas
    Dado que el usuario ha ingresado un nombre de usuario
    Y ha ingresado una contraseña incorrecta
    Cuando el usuario presiona el botón "Entrar"
    Entonces el sistema deberá mostrar un mensaje "Usuario o contraseña incorrectos"
    Y el sistema deberá mantener la sesión como no autenticada

  Escenario: Error inesperado durante login
    Dado que el usuario ha ingresado credenciales
    Cuando ocurre un error inesperado en el servidor
    Entonces el sistema deberá mostrar un mensaje "Error inesperado: [detalle]"
    Y el sistema deberá mantener la sesión como no autenticada

  Escenario: Estado de carga durante login
    Dado que el usuario ha presionado "Entrar"
    Cuando el sistema está procesando la autenticación
    Entonces el sistema deberá mostrar un indicador de progreso circular
    Y el sistema deberá ocultar el teclado

  Escenario: Navegación a recuperación de contraseña
    Dado que el usuario se encuentra en la pantalla de login
    Cuando el usuario presiona "¿Olvidaste tu clave?"
    Entonces el sistema deberá navegar a la pantalla de solicitud de recuperación de contraseña

  Escenario: Navegación a registro
    Dado que el usuario se encuentra en la pantalla de login
    Cuando el usuario presiona "Regístrate"
    Entonces el sistema deberá navegar a la pantalla de registro de usuario

  Escenario: Aviso importante antes de login
    Dado que el usuario abre el diálogo de login
    Y el flag de aviso importante está activo
    Entonces el sistema deberá mostrar un diálogo con el aviso de prueba y demostración
    Y el sistema deberá esperar a que el usuario presione "Enterado" para continuar
