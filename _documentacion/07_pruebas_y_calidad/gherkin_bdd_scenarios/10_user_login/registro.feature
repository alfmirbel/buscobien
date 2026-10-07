# language: es
Característica: Registro de Usuario en BuscoBien
  Como usuario nuevo
  Quiero crear una cuenta en BuscoBien
  Para acceder a las funcionalidades de la plataforma

  Antecedentes:
    Dado que el usuario se encuentra en la pantalla de "Registro"
    Y el formulario de registro está vacío

  Escenario: Visualización del formulario de registro
    Dado que el usuario abre la pantalla de registro
    Entonces el sistema deberá mostrar el título "Registro de [perfil]"
    Y el sistema deberá mostrar campos para:
      | campo                     |
      | Nombre de usuario         |
      | Clave de acceso           |
      | Valida clave de acceso    |
      | Correo electrónico        |
      | Número de celular         |
      | Nombres                   |
      | Apellido paterno          |
      | Apellido materno          |
    Y si el perfil es Promotor, el sistema deberá mostrar el campo RFC

  Escenario: Validación de contraseña coincidente
    Dado que el usuario ha ingresado una clave de acceso
    Y ha ingresado una confirmación de clave diferente
    Cuando el usuario intenta enviar el formulario
    Entonces el sistema deberá mostrar un error de validación
    Y el sistema deberá impedir el registro

  Escenario: Aceptación de términos y condiciones
    Dado que el usuario ha completado todos los campos del formulario
    Y no ha aceptado los términos y condiciones
    Y no ha aceptado el aviso de privacidad
    Cuando el usuario intenta enviar el formulario
    Entonces el sistema deberá impedir el registro
    Y los botones de envío deberán estar deshabilitados

  Escenario: Registro exitoso de usuario normal
    Dado que el usuario ha completado todos los campos obligatorios
    Y ha aceptado los términos y condiciones
    Y ha aceptado el aviso de privacidad
    Y ha seleccionado el perfil "Usuario"
    Cuando el usuario envía el formulario
    Entonces el sistema deberá crear el documento de usuario en CouchDB
    Y el sistema deberá marcar al usuario como comprador
    Y el sistema deberá mostrar un mensaje de éxito
    Y el sistema deberá navegar a la pantalla de login

  Escenario: Registro exitoso de promotor
    Dado que el usuario ha completado todos los campos obligatorios
    Y ha ingresado el RFC
    Y ha aceptado los términos y condiciones
    Y ha aceptado el aviso de privacidad
    Y ha seleccionado el perfil "Promotor"
    Cuando el usuario envía el formulario
    Entonces el sistema deberá crear el documento de usuario en CouchDB
    Y el sistema deberá marcar al usuario como promotor
    Y el sistema deberá incluir los datos de promotor (RFC, espacios contratados)
    Y el sistema deberá mostrar un mensaje de éxito
    Y el sistema deberá navegar a la pantalla de login

  Escenario: Registro con campos obligatorios vacíos
    Dado que el usuario deja campos obligatorios vacíos
    Cuando el usuario intenta enviar el formulario
    Entonces el sistema deberá mostrar mensajes de validación en los campos vacíos
    Y el sistema deberá impedir el envío del formulario

  Escenario: Registro con correo electrónico duplicado
    Dado que el correo electrónico ingresado ya está registrado
    Cuando el usuario intenta enviar el formulario
    Entonces el sistema deberá mostrar un mensaje de error
    Y el sistema deberá impedir el registro
