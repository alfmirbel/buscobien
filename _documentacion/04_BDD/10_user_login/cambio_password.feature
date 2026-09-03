# language: es
Característica: Cambio de Contraseña
  Como usuario de BuscoBien
  Quiero restablecer mi contraseña usando un enlace de recuperación
  Para recuperar el acceso a mi cuenta

  Antecedentes:
    Dado que el usuario ha recibido un enlace de recuperación de contraseña
    Y ha abierto el enlace en la aplicación

  Escenario: Validación de token exitoso
    Dado que el usuario abre el enlace de recuperación con un token válido
    Y el token no ha expirado
    Entonces el sistema deberá validar el token contra CouchDB
    Y el sistema deberá mostrar el formulario de nueva contraseña
    Y el sistema deberá mostrar el texto "Crea una contraseña segura para tu cuenta"

  Escenario: Token inválido o expirado
    Dado que el usuario abre un enlace con token inválido o expirado
    Entonces el sistema deberá mostrar un mensaje "El enlace de recuperación no es válido o ya expiró. Solicita uno nuevo desde la pantalla de inicio de sesión"
    Y el sistema deberá navegar a la pantalla de login

  Escenario: Visualización de indicador de fortaleza de contraseña
    Dado que el usuario se encuentra en la pantalla de cambio de contraseña
    Cuando el usuario escribe una contraseña de 5 caracteres
    Entonces el sistema deberá mostrar "Muy corta" en color de error
    Cuando el usuario escribe una contraseña de 7 caracteres con solo letras minúsculas
    Entonces el sistema deberá mostrar "Débil" en color de error
    Cuando el usuario escribe una contraseña de 8 caracteres con mayúsculas y números
    Entonces el sistema deberá mostrar "Media" en color secundario
    Cuando el usuario escribe una contraseña de 12 caracteres con mayúsculas, números y caracteres especiales
    Entonces el sistema deberá mostrar "Fuerte" en color verde

  Escenario: Cambio de contraseña exitoso
    Dado que el usuario ha ingresado una nueva contraseña válida
    Y ha confirmado la nueva contraseña correctamente
    Cuando el usuario presiona "Guardar"
    Entonces el sistema deberá validar que las contraseñas coincidan
    Y el sistema deberá generar el hash SHA-256 de la nueva contraseña
    Y el sistema deberá actualizar la contraseña en CouchDB
    Y el sistema deberá mostrar un mensaje "Tu contraseña ha sido actualizada correctamente. Inicia sesión con tu nueva contraseña"
    Y el sistema deberá navegar a la pantalla de login

  Escenario: Error al actualizar contraseña
    Dado que el usuario ha ingresado una nueva contraseña válida
    Cuando ocurre un error al actualizar la contraseña en CouchDB
    Entonces el sistema deberá mostrar un mensaje "No fue posible actualizar la contraseña. Intenta de nuevo"

  Escenario: Validación de contraseñas no coincidentes
    Dado que el usuario ha ingresado una nueva contraseña
    Y la confirmación de contraseña es diferente
    Cuando el usuario intenta guardar
    Entonces el sistema deberá mostrar un error de validación
    Y el sistema deberá impedir el cambio de contraseña

  Escenario: Estado de carga durante cambio de contraseña
    Dado que el usuario ha presionado "Guardar"
    Cuando el sistema está procesando el cambio
    Entonces el sistema deberá mostrar un indicador de progreso circular
