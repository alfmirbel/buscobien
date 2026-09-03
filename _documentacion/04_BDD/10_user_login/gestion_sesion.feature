# language: es
Característica: Gestión de Sesión de Usuario
  Como sistema de BuscoBien
  Quiero gestionar la sesión del usuario de forma segura
  Para mantener el estado de autenticación y datos del usuario

  Antecedentes:
    Dado que el usuario ha interactuado con el sistema de autenticación

  Escenario: Cierre de sesión
    Dado que el usuario ha iniciado sesión
    Cuando el usuario cierra sesión
    Entonces el sistema deberá eliminar todos los datos de sesión locales
    Y el sistema deberá resetear el estado de sesión en Riverpod
    Y el sistema deberá establecer isAuthenticated en false
    Y el sistema deberá navegar a la pantalla de login

  Escenario: Persistencia de sesión en almacenamiento local
    Dado que el usuario ha iniciado sesión exitosamente
    Cuando el sistema guarda la sesión
    Entonces el sistema deberá almacenar userId en almacenamiento local
    Y el sistema deberá almacenar userName en almacenamiento local
    Y el sistema deberá almacenar nombrePerfil en almacenamiento local
    Y el sistema deberá almacenar userPassHash (SHA-256) en almacenamiento local
    Y el sistema no deberá almacenar la contraseña en texto plano

  Escenario: Recuperación de sesión al iniciar la aplicación
    Dado que el usuario cerró la aplicación sin cerrar sesión
    Cuando el usuario vuelve a abrir la aplicación
    Entonces el sistema deberá leer los datos de sesión desde almacenamiento local
    Y si existen datos válidos, el sistema deberá marcar isAuthenticated en true
    Y el sistema deberá restaurar el perfil del usuario
    Y el sistema deberá establecer los flags de rol según el perfil recuperado

  Escenario: Actualización de perfil de usuario
    Dado que el usuario ha iniciado sesión como "Usuario"
    Cuando el usuario cambia el perfil a "Promotor"
    Entonces el sistema deberá actualizar nombrePerfil en el estado
    Y el sistema deberá establecer esPromotor en true
    Y el sistema deberá establecer esUsuario en false
    Y el sistema deberá actualizar los flags de sesión correspondientes

  Escenario: Establecimiento de variables de sesión
    Dado que el usuario ha iniciado sesión
    Cuando el sistema necesita guardar datos en la sesión
    Entonces el sistema deberá permitir guardar userId, userName, userPass
    Y el sistema deberá permitir guardar flags de rol (esUsuarioComprador, esUsuarioPromotor, etc.)
    Y el sistema deberá mantener la inmutabilidad del estado de Riverpod

  Escenario: Obtención de variables de sesión
    Dado que la sesión tiene datos almacenados
    Cuando el sistema solicita una variable de sesión
    Entonces el sistema deberá retornar el valor correspondiente según el nombre de variable
    Y si la variable no existe, el sistema deberá retornar null

  Escenario: Actualización de datos de usuario en sesión
    Dado que el usuario ha iniciado sesión
    Cuando el sistema actualiza un campo del usuario
    Entonces el sistema deberá permitir modificar cualquier campo del usuario
    Y el sistema deberá mantener la inmutabilidad del estado
    Y el sistema deberá reflejar los cambios en la UI
