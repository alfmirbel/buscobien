# language: es
Característica: Estilos de Widgets Reutilizables
  Como usuario final
  Quiero experimentar una interfaz consistente en todas las pantallas
  Para reconocer patrones visuales y navegar intuitivamente

  Escenario: AppBar en pantallas secundarias
    Dado que el usuario navega a una pantalla secundaria
    Y el título de la pantalla es "Propiedades"
    Cuando el sistema renderiza el AppBar
    Entonces el sistema crea un AppBar con altura de 40 píxeles (`socialAppBarHeight`)
    Y el título está centrado
    Y el espaciado del título es 0
    Y el color de fondo es `appTheme.primary`
    Y el icono de navegación tiene tamaño 14 y color `appTheme.onPrimary`
    Y el texto del título tiene color `appTheme.onPrimary`
    Y el peso de fuente es normal
    Y el tamaño de fuente es `fontSizeTituloPagina` (14)

  Escenario: AppBar secundario con botones de pestaña
    Dado que el usuario navega a una pantalla con pestañas
    Y el título de la pantalla es "Mis Propiedades"
    Y existe un TabBar con opciones
    Cuando el sistema renderiza el AppBar
    Entonces el sistema crea un AppBar con altura de 40 píxeles
    Y el color de fondo es `appTheme.primary`
    Y el título usa `fontSizeTituloPagina` (14)
    Y incluye el TabBar en la parte inferior del AppBar

  Escenario: AppBar secundario con acciones
    Dado que el usuario navega a una pantalla con acciones en el AppBar
    Y el título de la pantalla es "Configuración"
    Y existen botones de acción (búsqueda, notificaciones)
    Cuando el sistema renderiza el AppBar
    Entonces el sistema crea un AppBar con altura de 40 píxeles
    Y el color de fondo es `appTheme.primary`
    Y el título usa `fontSizeTituloPagina` (14)
    Y incluye las acciones en la sección de acciones del AppBar

  Escenario: Estilo de botones de pestaña no seleccionados
    Dado que el usuario visualiza un TabBar con múltiples pestañas
    Y la pestaña activa es "Propiedades"
    Y la pestaña inactiva es "Mis Listas"
    Cuando el sistema renderiza las etiquetas del TabBar
    Entonces la pestaña seleccionada muestra texto en `appTheme.onPrimary` con peso bold
    Y la pestaña no seleccionada muestra texto en `appTheme.primary` con peso normal
    Y ambas usan tamaño de fuente `menuTabLabelSize`

  Escenario: Consistencia de estilos en pantallas de landing
    Dado que el usuario navega entre diferentes landing pages
    Y cada landing page tiene su propio AppBar
    Cuando el sistema renderiza cada AppBar
    Entonces todos los AppBars secundarios usan la misma altura de 40 píxeles
    Y todos usan `appTheme.primary` como color de fondo
    Y todos centran el título
    Y todos usan el mismo tamaño de fuente para el título
