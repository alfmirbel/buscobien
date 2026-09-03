# language: es
Característica: Estructura Común de las Landing Pages
  Como usuario final
  Quiero que cada landing page tenga una estructura clara y consistente
  Para navegar fácilmente por las diferentes secciones de BuscoBien

  Escenario: Toda landing page muestra una AppBar con título y botón de regreso
    Dado que el usuario abre cualquier landing page desde el menú de inicio
    Cuando se renderiza la AppBar de la landing page
    Entonces el sistema debe mostrar el título correspondiente a la sección ("Buscar", "Promotores", "Propietarios", etc.)
    Y el título debe incluir el icono definido en "menuOpciones"
    Y debe mostrar un botón de regresar solo si "indiceInicial == 0"

  Escenario: El botón de regresar navega a la pantalla anterior
    Dado que el usuario está en una landing page con "indiceInicial == 0"
    Cuando el usuario toca el botón de regresar
    Entonces el sistema debe ejecutar "Navigator.pop()"
    Y debe regresar a la pantalla anterior sin cambiar el estado de navegación

  Escenario: El botón de regresar está oculto fuera del menú de inicio
    Dado que el usuario navegó a una landing page desde otra sección diferente a "Inicio"
    Cuando se renderiza la AppBar
    Entonces el sistema no debe mostrar el botón de regresar
    Y el leading de la AppBar debe ser nulo

  Escenario: Toda landing page muestra una sección Hero con imagen de fondo
    Dado que el usuario abre cualquier landing page
    Cuando se renderiza la sección principal
    Entonces el sistema debe mostrar una imagen de fondo desde "menuOpciones[index].imagePath"
    Y debe aplicar un filtro de color oscuro para legibilidad del texto
    Y debe mostrar un título principal en color blanco

  Escenario: El footer de las landing pages muestra el copyright
    Dado que el usuario hace scroll hasta el final de cualquier landing page
    Cuando se renderiza el footer
    Entonces el sistema debe mostrar el texto "© 2026 Buscobien. Todos los derechos reservados."
    Y el texto debe tener el color primario del tema y tamaño de fuente 12
