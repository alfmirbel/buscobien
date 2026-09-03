# language: es
Característica: Barra de Aplicación y Acciones del Usuario
  Como usuario de BuscoBien
  Quiero ver mi estado de conexión y acceder a funciones rápidas desde la barra superior
  Para controlar la navegación y mi sesión sin salir de la pantalla actual

  Escenario: La barra muestra el título de la aplicación
    Dado que el usuario está en la pantalla principal
    Cuando se renderiza la barra de aplicación
    Entonces el título debe mostrar "buscobien"
    Y la fuente debe ser "Comfortaa" en negrita
    Y el color del texto debe ser el color primario del tema M3

  Escenario: El botón de conexión indica estado conectado
    Dado que el dispositivo tiene conexión a Internet
    Y el proveedor "checaConeccionesProvider" emite "Conectado"
    Cuando se renderiza el botón de conexión
    Entonces el sistema debe mostrar un icono de señal en color primario
    Y el tooltip debe decir "Conectado"

  Escenario: El botón de conexión indica estado sin conexión
    Dado que el dispositivo no tiene conexión a Internet
    Y el proveedor "checaConeccionesProvider" emite un estado no conectado
    Cuando se renderiza el botón de conexión
    Entonces el sistema debe mostrar "Symbols.signal_wifi_bad" en color de error M3
    Y el tooltip debe reflejar el estado de desconexión

  Escenario: El botón de conexión muestra carga mientras verifica
    Dado que el proveedor "checaConeccionesProvider" está en estado de carga
    Cuando se renderiza el botón de conexión
    Entonces el sistema debe mostrar un "CircularProgressIndicator" de color primario
    Y el tooltip debe indicar "Error al verificar conexión" si hay error

  Escenario: El botón de usuario abre el diálogo de login si no hay sesión
    Dado que el usuario no ha iniciado sesión (userId vacío)
    Cuando el usuario toca el botón de usuario en la barra
    Entonces el sistema debe abrir "dialogBoxFichaLogin"
    Y si el login es exitoso debe navegar a "Mi Cuenta" (índice 3)
    Y si el login es cancelado debe navegar a "Propiedades" (índice 1)

  Escenario: El botón de usuario navega al perfil si hay sesión activa
    Dado que el usuario ha iniciado sesión
    Cuando el usuario toca el botón de usuario en la barra
    Entonces el sistema debe cambiar el menú a la sección "Perfil" (índice 4)
    Y no debe abrir ningún diálogo de login

  Escenario: El botón de usuario muestra avatar si está disponible
    Dado que el usuario tiene una sesión activa
    Y existe una imagen de avatar guardada en base64
    Cuando se renderiza el botón de usuario
    Entonces el sistema debe mostrar un "CircleAvatar" con la imagen del avatar
    Y si no hay avatar debe mostrar el icono de usuario por defecto

  Escenario: Los botones de filtro y buscar solo aparecen en pantallas anchas
    Dado que el usuario abre la aplicación en una tablet o escritorio
    Cuando se renderiza la barra de aplicación
    Entonces el sistema debe mostrar el botón de filtros "(des)Activar filtros"
    Y debe mostrar el botón de búsqueda "Buscar"
    Y en pantallas pequeñas estos botones deben estar ausentes
