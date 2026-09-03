# language: es
Característica: Menú Lateral (Drawer)
  Como usuario de BuscoBien
  Quiero acceder a funciones secundarias desde el menú lateral
  Para gestionar preferencias, información de la app y salir de la aplicación

  Escenario: El menú lateral se abre desde el botón de menú
    Dado que el usuario está en la pantalla principal
    Cuando el usuario toca el botón de menú (ícono hamburguesa) en la barra superior
    Entonces el sistema debe abrir el "Drawer" desde el lateral izquierdo
    Y el ancho del drawer debe ser de 250 píxeles

  Escenario: La opción "Salir" cierra la aplicación
    Dado que el menú lateral está abierto
    Cuando el usuario toca "Salir"
    Entonces el sistema debe cerrar la aplicación
    Y no debe navegar a ninguna otra pantalla

  Escenario: La opción "Principal" cierra el menú lateral
    Dado que el menú lateral está abierto
    Cuando el usuario toca "Principal"
    Entonces el sistema debe cerrar el drawer
    Y debe permanecer en la pantalla principal sin cambiar de sección

  Escenario: La opción "Preferencias" navega a la pantalla de preferencias
    Dado que el menú lateral está abierto
    Cuando el usuario toca "Preferencias"
    Entonces el sistema debe navegar a la ruta "AppRoutes.preferencias"
    Y el drawer debe cerrarse automáticamente

  Escenario: La opción "Configuración" detecta el sistema operativo
    Dado que el menú lateral está abierto
    Cuando el usuario toca "Configuración"
    Entonces el sistema debe ejecutar "setCheckPlataformaProvider" para detectar el OS
    Y debe navegar a la ruta "AppRoutes.plataforma"

  Escenario: La opción "Acerca de..." muestra la versión de la aplicación
    Dado que el menú lateral está abierto
    Cuando el usuario toca "Acerda de..."
    Entonces el sistema debe mostrar un diálogo con el título "Acerca de buscobien"
    Y el mensaje debe incluir "Plataforma de promoción inmobiliaria" y el número de versión actual

  Escenario: La opción "Contacto" muestra la información de contacto
    Dado que el menú lateral está abierto
    Cuando el usuario toca "Contacto"
    Entonces el sistema debe mostrar un diálogo con el título "Contacto"
    Y el mensaje debe contener el correo "contacto@buscobien.info"
    Y debe contener la cuenta de X "@buscobien"

  Escenario: Las opciones "Favoritos" y "Ver después" no tienen acción definida
    Dado que el menú lateral está abierto
    Cuando el usuario toca "Favoritos" o "Ver después"
    Entonces el sistema debe cerrar el drawer
    Y no debe navegar a ninguna pantalla ni mostrar errores
