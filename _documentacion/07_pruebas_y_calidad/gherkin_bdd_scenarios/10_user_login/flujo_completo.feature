# language: es
Característica: Flujos Completos de Autenticación
  Como usuario de BuscoBien
  Quiero completar los flujos de autenticación completos
  Para acceder y gestionar mi cuenta de forma segura

  Antecedentes:
    Dado que el usuario "Juan Pérez" desea interactuar con BuscoBien
    Y su correo es "juan@example.com"
    Y su contraseña es "MiClaveSegura123"

  Escenario: Flujo completo de registro y primer acceso
    Dado que Juan no tiene cuenta en BuscoBien
    Cuando Juan navega a la pantalla de registro
    Y completa el formulario:
      | campo               | valor                  |
      | Nombre de usuario   | juanperez              |
      | Clave de acceso     | MiClaveSegura123       |
      | Valida clave        | MiClaveSegura123       |
      | Correo electrónico  | juan@example.com       |
      | Número de celular   | 5555555555             |
      | Nombres             | Juan                   |
      | Apellido paterno    | Pérez                  |
      | Apellido materno    | López                  |
    Y acepta los términos y condiciones
    Y acepta el aviso de privacidad
    Y selecciona el perfil "Usuario"
    Y envía el formulario
    Entonces el sistema deberá crear su cuenta en CouchDB
    Y el sistema deberá navegar a la pantalla de login
    Cuando Juan inicia sesión con sus credenciales
    Entonces el sistema deberá autenticarlo exitosamente
    Y el sistema deberá mostrar la pantalla principal

  Escenario: Flujo de recuperación y cambio de contraseña
    Dado que Juan tiene una cuenta pero olvidó su contraseña
    Cuando Juan navega a "¿Olvidaste tu clave?"
    Y ingresa su correo "juan@example.com"
    Y selecciona su perfil "Usuario"
    Y presiona "Enviar enlace"
    Entonces el sistema deberá generar un token de recuperación
    Y el sistema deberá enviar un correo a juan@example.com
    Cuando Juan abre el enlace de recuperación
    Entonces el sistema deberá validar el token
    Y el sistema deberá mostrar el formulario de nueva contraseña
    Cuando Juan ingresa una nueva contraseña segura
    Y confirma la nueva contraseña
    Y presiona "Guardar"
    Entonces el sistema deberá actualizar la contraseña en CouchDB
    Y el sistema deberá navegar a la pantalla de login
    Cuando Juan inicia sesión con la nueva contraseña
    Entonces el sistema deberá autenticarlo exitosamente

  Escenario: Flujo de login con selección de perfil
    Dado que Juan tiene cuenta como Usuario y como Promotor
    Cuando Juan inicia la aplicación
    Y abre el diálogo de login
    Y selecciona el perfil "Promotor"
    Y ingresa sus credenciales de Promotor
    Y presiona "Entrar"
    Entonces el sistema deberá autenticar al Promotor
    Y el sistema deberá establecer esPromotor en true
    Y el sistema deberá permitir acceso a funcionalidades de promotor

  Escenario: Flujo de logout y cierre de sesión
    Dado que Juan ha iniciado sesión como Promotor
    Y se encuentra en la pantalla principal
    Cuando Juan cierra sesión
    Entonces el sistema deberá eliminar los datos de sesión locales
    Y el sistema deberá marcar isAuthenticated en false
    Y el sistema deberá resetear todos los flags de rol
    Y el sistema deberá navegar a la pantalla de login
