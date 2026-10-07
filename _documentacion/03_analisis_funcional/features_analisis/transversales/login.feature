# language: es
Característica: Inicio de sesión y selección de perfil
  Como usuario registrado
  Quiero autenticarme con credenciales y perfil
  Para acceder a mi sesión en Buscobien

  Escenario: Flujo básico de login con usuario y contraseña
    Dado que el usuario está en la pantalla de Login
    Y el campo de usuario está vacío
    Y el campo de contraseña está vacío
    Cuando el usuario presiona "Iniciar Sesión"
    Entonces el sistema muestra retroalimentación visual de error
    Y el foco permanece en el primer campo inválido

  Escenario: Selección de perfil durante autenticación
    Dado que el usuario ingresó credenciales válidas
    Y el sistema soporta perfiles como Usuario, Promotor y Propietario
    Cuando el usuario selecciona un perfil
    Entonces la autenticación se ejecuta contra la base correspondiente al perfil

  Escenario: Sesión persistente al abrir la aplicación otra vez
    Dado que el usuario cerró la aplicación con sesión activa
    Cuando vuelve a abrir Buscobien
    Entonces el sistema restaura la sesión sin pedir login nuevamente

  Escenario: Cierre de sesión
    Dado que el usuario tiene una sesión activa
    Cuando el usuario solicita cerrar sesión
    Entonces el sistema elimina los datos almacenados localmente
    Y navega al login
