# language: es
Característica: Recuperación de Contraseña
  Como usuario de BuscoBien
  Quiero recuperar mi contraseña olvidada
  Para poder acceder nuevamente a mi cuenta

  Antecedentes:
    Dado que el usuario se encuentra en la pantalla de "Recuperación de Contraseña"

  Escenario: Visualización de la pantalla de recuperación
    Dado que el usuario abre la pantalla de recuperación
    Entonces el sistema deberá mostrar el título "¿Olvidaste tu contraseña?"
    Y el sistema deberá mostrar el texto explicativo sobre el enlace de recuperación
    Y el sistema deberá mostrar un campo de "Correo electrónico"
    Y el sistema deberá mostrar un dropdown de "Perfil"
    Y el sistema deberá mostrar un botón "Enviar enlace"

  Escenario: Envío de enlace de recuperación exitoso
    Dado que el usuario ha ingresado un correo electrónico registrado
    Y ha seleccionado el perfil correcto
    Cuando el usuario presiona "Enviar enlace"
    Entonces el sistema deberá buscar el usuario por correo y perfil en CouchDB
    Y el sistema deberá generar un token único de recuperación
    Y el sistema deberá calcular la fecha de expiración (1 hora)
    Y el sistema deberá guardar el token en CouchDB
    Y el sistema deberá enviar un correo con el enlace de recuperación
    Y el sistema deberá mostrar un mensaje "Revisa tu correo. Si la cuenta existe, recibirás un enlace para restablecer tu contraseña (válido 1 hora)"

  Escenario: Correo no registrado
    Dado que el usuario ha ingresado un correo electrónico no registrado
    Y ha seleccionado un perfil
    Cuando el usuario presiona "Enviar enlace"
    Entonces el sistema deberá mostrar un mensaje "No se encontró una cuenta con ese correo y perfil. Verifica los datos e intenta de nuevo"

  Escenario: Error al guardar token
    Dado que el usuario ha ingresado un correo válido
    Cuando ocurre un error al guardar el token en CouchDB
    Entonces el sistema deberá mostrar un mensaje "No fue posible procesar la solicitud. Intenta más tarde"

  Escenario: Error al enviar correo
    Dado que el token se generó y guardó exitosamente
    Cuando ocurre un error al enviar el correo electrónico
    Entonces el sistema deberá mostrar un mensaje "El enlace fue generado pero no se pudo enviar el correo. Contacta a soporte"

  Escenario: Validación de correo vacío
    Dado que el usuario no ha ingresado un correo electrónico
    Cuando el usuario presiona "Enviar enlace"
    Entonces el sistema deberá mostrar un mensaje de validación
    Y el sistema deberá impedir el envío
