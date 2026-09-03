# language: es
Característica: Página de Inicio y Landing Pages
  Como usuario final
  Quiero ver opciones claras de navegación desde la pantalla de inicio
  Para acceder rápidamente al servicio que necesito

  Escenario: La página de inicio muestra el fondo con la primera opción del menú
    Dado que el usuario está en la sección "Inicio"
    Y la lista "menuOpciones" tiene al menos una opción
    Cuando se renderiza "PageInicio"
    Entonces el sistema debe mostrar la imagen de fondo de "menuOpciones[0]"
    Y debe aplicar un degradado oscuro sobre la imagen para legibilidad del texto

  Escenario: La página de inicio muestra el encabezado de bienvenida
    Dado que el usuario está en la página de inicio
    Cuando se renderiza el encabezado
    Entonces el sistema debe mostrar el título "Bienvenido"
    Y debe mostrar el subtítulo "Selecciona el perfil que mejor se adapte a tus necesidades"
    Y ambos textos deben estar centrados y en color blanco

  Escenario: Las tarjetas de opción navegan a su landing page correspondiente
    Dado que el usuario está en la página de inicio
    Y la opción "Buscar" tiene una landing page asociada
    Cuando el usuario toca la tarjeta "Buscar"
    Entonces el sistema debe navegar a "LandingBusquedaPage" con una transición de fade
    Y no debe mostrar ningún mensaje de "Próximamente disponible"

  Escenario: Las tarjetas sin landing page muestran aviso de disponibilidad
    Dado que el usuario está en la página de inicio
    Y la opción seleccionada no tiene landing page asociada
    Cuando el usuario toca esa tarjeta
    Entonces el sistema debe mostrar un "SnackBar" con el texto "Próximamente disponible."
    Y el SnackBar debe tener el color secundario del tema M3

  Escenario: Las tarjetas responden al hover en dispositivos con puntero
    Dado que el usuario está en una pantalla con ratón o trackpad
    Cuando el usuario pasa el cursor sobre una tarjeta de opción
    Entonces la tarjeta debe escalar ligeramente hacia arriba
    Y al quitar el cursor debe regresar a su tamaño original

  Escenario: Las tarjetas se adaptan a pantallas pequeñas
    Dado que el usuario abre la aplicación en un dispositivo móvil
    Y el ancho de pantalla es menor a "smallScreenMin"
    Cuando se renderiza la cuadrícula de opciones
    Entonces el sistema debe mostrar tarjetas adaptadas a ancho completo
    Y los textos deben permanecer legibles sin recortes
