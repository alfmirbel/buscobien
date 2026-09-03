# language: es
Característica: Diseño Responsivo y Adaptación de Pantalla
  Como usuario final
  Quiero que la interfaz se adapte a mi dispositivo
  Para tener una experiencia de uso óptima en cualquier tamaño de pantalla

  Escenario: Detección de pantalla móvil
    Dado que el usuario abre la aplicación en un dispositivo móvil
    Y el ancho de pantalla es 375 píxeles
    Cuando el sistema evalúa el breakpoint responsivo
    Entonces el sistema clasifica el dispositivo como móvil (`isMobileWidth` = verdadero)
    Y el sistema oculta la navegación lateral (`NavigationRail`)
    Y el sistema muestra la barra de navegación inferior (`NavigationBar`)

  Escenario: Detección de pantalla tablet
    Dado que el usuario abre la aplicación en una tablet
    Y el ancho de pantalla es 800 píxeles
    Cuando el sistema evalúa el breakpoint responsivo
    Entonces el sistema clasifica el dispositivo como tablet (`isTabletWidth` = verdadero)
    Y el sistema muestra la navegación lateral (`NavigationRail`)
    Y el sistema oculta la barra de navegación inferior (`NavigationBar`)

  Escenario: Detección de pantalla desktop
    Dado que el usuario abre la aplicación en un monitor de escritorio
    Y el ancho de pantalla es 1920 píxeles
    Cuando el sistema evalúa el breakpoint responsivo
    Entonces el sistema clasifica el dispositivo como desktop (`isDesktopWidth` = verdadero)
    Y el sistema muestra la navegación lateral (`NavigationRail`)
    Y el sistema limita el ancho máximo del contenido a 1280 píxeles (`desktopContentMaxWidth`)

  Escenario: Limitación de ancho en desktop para tarjetas
    Dado que el usuario está en una pantalla desktop (1920px)
    Y el sistema muestra una cuadrícula de tarjetas de propiedades
    Cuando el sistema calcula el ancho de las columnas
    Entonces el ancho máximo de la columna principal es 1280 píxeles
    Y las tarjetas no se estiran indefinidamente

  Escenario: Dimensiones de ficha PAN en modo claro
    Dado que el usuario visualiza una ficha de propiedad
    Y el tema activo es `lightPAN`
    Cuando el sistema calcula las dimensiones de la ficha
    Entonces el ancho de la ficha es 250 píxeles (`widthFicha`)
    Y la altura de la ficha es 154.5 píxeles (`heightFicha` = widthFicha / 1.618)

  Escenario: Dimensiones de ficha chica
    Dado que el usuario visualiza una ficha compacta
    Cuando el sistema calcula las dimensiones de la ficha chica
    Entonces el ancho de la ficha chica es 50 píxeles (`widthFichaChica`)
    Y la altura de la ficha chica es 30.9 píxeles (`heightFichaChica` = widthFichaChica / 1.618)

  Escenario: Altura de barra de navegación inferior
    Dado que el usuario visualiza la barra de navegación inferior
    Cuando el sistema renderiza la `NavigationBar`
    Entonces la altura de la barra es 56 píxeles (`navBarHeight`)

  Escenario: Altura de AppBar social
    Dado que el usuario visualiza una pantalla social (grupos, conocidos)
    Cuando el sistema renderiza el AppBar de la pantalla
    Entonces la altura del AppBar es 40 píxeles (`socialAppBarHeight`)

  Escenario: Tamaño de texto en AppBar
    Dado que el usuario visualiza cualquier pantalla con AppBar
    Cuando el sistema renderiza el título del AppBar
    Entonces el tamaño de fuente del título es 18 píxeles (`textoSizeAppBar`)
