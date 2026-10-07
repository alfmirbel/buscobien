# language: es

Característica: Recuperación de Contraseña mediante Correo Electrónico
  Como usuario registrado en BuscoBien que olvidó su contraseña
  Quiero recibir un enlace de recuperación en mi correo electrónico
  Para poder establecer una nueva contraseña y retomar el acceso a mi cuenta

  Antecedentes:
    Dado que el usuario está en la pantalla "¿Olvidaste tu contraseña?"
    Y el formulario muestra los campos "Correo electrónico" y "Perfil"

  # ---------------------------------------------------------------------------
  # VALIDACIÓN DEL FORMULARIO DE SOLICITUD
  # ---------------------------------------------------------------------------
  Escenario: Intento de envío con correo vacío
    Dado que el campo "Correo electrónico" está vacío
    Cuando el usuario presiona el botón "Enviar enlace"
    Entonces el formulario no debe enviarse
    Y el campo "Correo electrónico" debe mostrar el mensaje de error "Escribe tu correo"
    Y el color del borde del TextField debe cambiar al color de error del M3 Color Scheme

  Escenario: Intento de envío con formato de correo inválido
    Dado que el campo "Correo electrónico" contiene el texto "noesuncorreo"
    Cuando el usuario presiona el botón "Enviar enlace"
    Entonces el formulario no debe enviarse
    Y el campo debe mostrar el mensaje de error "Formato de correo inválido"

  Escenario: Intento de envío con correo válido pero no registrado
    Dado que el campo "Correo electrónico" contiene "correo_no_registrado@ejemplo.com"
    Y el campo "Perfil" tiene seleccionado "Usuario"
    Cuando el usuario presiona el botón "Enviar enlace"
    Entonces el sistema debe mostrar un "CircularProgressIndicator"
    Y el sistema debe buscar la cuenta en la base de datos por correo y perfil
    Cuando no se encuentra ninguna cuenta con esos datos
    Entonces el sistema debe mostrar un diálogo con el título "Sin resultado"
    Y el mensaje debe decir "No se encontró una cuenta con ese correo y perfil."
    Y el usuario debe permanecer en la pantalla de recuperación

  # ---------------------------------------------------------------------------
  # FLUJO EXITOSO DE ENVÍO DE ENLACE
  # ---------------------------------------------------------------------------
  Escenario: Solicitud de recuperación exitosa
    Dado que el campo "Correo electrónico" contiene "usuario_valido@correo.com"
    Y el campo "Perfil" tiene seleccionado "Usuario"
    Cuando el usuario presiona el botón "Enviar enlace"
    Y la búsqueda en la base de datos encuentra la cuenta
    Entonces el sistema debe generar un token de recuperación único ("generateResetToken()")
    Y debe calcular la fecha de expiración del token ("generateTokenExpiry()" - 1 hora)
    Y debe persistir el token en la base de datos (CouchDB vía API)
    Y debe enviar el correo de recuperación con el enlace al usuario
    Cuando el correo se envía correctamente
    Entonces debe mostrar un diálogo con el título "Enlace enviado"
    Y el mensaje debe decir "Revisa tu correo. Si la cuenta existe, recibirás un enlace para restablecer tu contraseña (válido 1 hora)."
    Y al confirmar el diálogo el sistema debe regresar a la pantalla anterior (Navigator.pop)

  Escenario: Error al guardar el token en la base de datos
    Dado que la cuenta del usuario fue encontrada
    Cuando el sistema intenta persistir el token y la operación falla
    Entonces el sistema debe mostrar un diálogo con el título "Error"
    Y el mensaje debe decir "No fue posible procesar la solicitud. Intenta más tarde."
    Y el usuario debe permanecer en la pantalla de recuperación

  Escenario: Error al enviar el correo (token generado pero correo fallido)
    Dado que el token fue generado y persistido correctamente
    Cuando el envío del correo falla por error del servidor de correo
    Entonces el sistema debe mostrar un diálogo con el título "Advertencia"
    Y el mensaje debe indicar "El enlace fue generado pero no se pudo enviar el correo. Contacta a soporte."
    Y el color del botón debe usar "appTheme.secondary" del M3 Color Scheme

  # ---------------------------------------------------------------------------
  # SELECTOR DE PERFIL EN LA RECUPERACIÓN
  # ---------------------------------------------------------------------------
  Escenario: El usuario cambia el perfil en la pantalla de recuperación
    Dado que el Dropdown "Perfil" muestra "Usuario" como valor inicial
    Cuando el usuario selecciona "Promotor" del Dropdown
    Entonces la variable interna "_perfilSeleccionado" debe actualizarse a "Promotor"
    Y la búsqueda de cuenta se realizará en la colección de Promotores

  # ---------------------------------------------------------------------------
  # CAMBIO DE CONTRASEÑA (PageCambioPassword)
  # ---------------------------------------------------------------------------
  Escenario: El token de recuperación es válido al abrir el enlace
    Dado que el usuario hace clic en el enlace de recuperación recibido por correo
    Y el sistema extrae el "token" y el "perfil" de los parámetros del enlace
    Cuando la pantalla "PageCambioPassword" se abre
    Entonces el sistema debe validar el token contra la base de datos
    Y si el token es válido y no ha expirado debe mostrar el formulario de nueva contraseña

  Escenario: El token de recuperación es inválido o ha expirado
    Dado que el usuario abre un enlace de recuperación con un token expirado o inválido
    Cuando la pantalla "PageCambioPassword" valida el token
    Entonces el sistema debe mostrar un diálogo con el título "Enlace inválido"
    Y el mensaje debe decir "El enlace de recuperación no es válido o ya expiró. Solicita uno nuevo desde la pantalla de inicio de sesión."
    Y el sistema debe redirigir al usuario a la ruta "/login" eliminando el historial de navegación

  Escenario: El usuario establece una nueva contraseña exitosamente
    Dado que el token es válido y el formulario de nueva contraseña está visible
    Y el campo "Nueva contraseña" contiene "NuevaClave@2026"
    Y el campo "Confirmar contraseña" contiene "NuevaClave@2026"
    Cuando el usuario presiona el botón "Guardar"
    Entonces el sistema debe validar que ambas contraseñas coincidan
    Y debe generar el hash SHA-256 de la nueva contraseña
    Y debe actualizar la contraseña en la base de datos (actualizarPassword)
    Cuando la actualización es exitosa
    Entonces debe mostrar un diálogo con el título "Listo"
    Y el mensaje debe decir "Tu contraseña ha sido actualizada correctamente. Inicia sesión con tu nueva contraseña."
    Y el sistema debe redirigir al usuario a la ruta "/login"

  Escenario: La nueva contraseña no cumple el mínimo de seguridad
    Dado que el token de recuperación es válido
    Y el campo "Nueva contraseña" contiene "abc" (menos de 6 caracteres)
    Cuando el sistema evalúa la fortaleza de la contraseña
    Entonces el indicador de fortaleza debe mostrar el nivel "Muy corta"
    Y el color del indicador debe ser el color de error del M3 Color Scheme

  Esquema del escenario: Indicador de fortaleza de contraseña según criterios
    Dado que el usuario escribe "<contraseña>" en el campo de nueva contraseña
    Entonces el indicador debe mostrar el nivel "<nivel>"

    Ejemplos:
      | contraseña          | nivel      |
      | abc                 | Muy corta  |
      | abcdef              | Débil      |
      | Abcdef12            | Media      |
      | Abcdef12@!          | Fuerte     |
