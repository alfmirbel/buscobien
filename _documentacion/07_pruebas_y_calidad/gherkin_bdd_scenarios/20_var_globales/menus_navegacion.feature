# language: es
Característica: Navegación y Elementos de Menú
  Como usuario final
  Quiero ver opciones de navegación claras con iconos reconocibles
  Para moverme fácilmente por las secciones de la aplicación

  Escenario: Menú de navegación principal
    Dado que el usuario abre el menú de navegación principal
    Cuando el sistema renderiza las opciones disponibles
    Entonces el sistema muestra la opción "Inicio" con icono `home`
    Y muestra la opción "Propiedades" con icono `person_search`
    Y muestra la opción "Propietarios" con icono `co_present`
    Y muestra la opción "Anfitriones" con icono `key`
    Y muestra la opción "Promotores" con icono `real_estate_agent`
    Y muestra la opción "Tienda" con icono `shopping_bag`
    Y muestra la opción "Servicios" con icono `handyman`
    Y muestra la opción "Proveedores" con icono `storefront`
    Y muestra la opción "Inmobiliarias" con icono `domain`

  Escenario: Submenú de tipo de propiedades
    Dado que el usuario abre el filtro de tipo de propiedad
    Cuando el sistema renderiza las opciones disponibles
    Entonces el sistema muestra "Casas" con icono `house`
    Y muestra "Departamentos" con icono `apartment`
    Y muestra "Oficinas" con icono `business`
    Y muestra "Locales" con icono `warehouse`
    Y muestra "Terrenos" con icono `layers`
    Y muestra "Otros" con icono `warehouse`

  Escenario: Submenú de transacciones
    Dado que el usuario abre el filtro de tipo de transacción
    Cuando el sistema renderiza las opciones disponibles
    Entonces el sistema muestra "Todas" con icono `real_estate_agent`
    Y muestra "Venta" con icono `sell`
    Y muestra "Renta" con icono `key`
    Y muestra "Venta/Renta" con icono `flip`
    Y muestra "Traspaso" con icono `swap_horizontal_circle`

  Escenario: Submenú de Mi Cuenta
    Dado que el usuario abre la sección "Mi cuenta"
    Cuando el sistema renderiza las opciones disponibles
    Entonces el sistema muestra "Mis Espacios" con icono `account_circle`
    Y muestra "Mis Listas" con icono `list`
    Y muestra "Mis Grupos" con icono `group`
    Y muestra "Mis Conocidos" con icono `person`

  Escenario: Submenú de solicitudes
    Dado que el usuario abre la sección de solicitudes
    Cuando el sistema renderiza las opciones disponibles
    Entonces el sistema muestra "Solicitudes a Grupos" con icono `groups_2`
    Y muestra "Invitaciones de Grupos" con icono `group`
    Y muestra "Solicitudes" con icono `contact_mail`
    Y muestra "Invitaciones" con icono `mail_outline`

  Escenario: Indicador de conectividad a Internet
    Dado que el usuario abre la pantalla de estado de conexión
    Y el dispositivo tiene conexión a Internet activa
    Cuando el sistema evalúa el estado de red
    Entonces el sistema muestra "Conectado" con icono `wifi`
    Cuando el dispositivo pierde la conexión a Internet
    Entonces el sistema muestra "Sin conexión" con icono `wifi_off`

  Escenario: Indicador de plataforma del dispositivo
    Dado que el usuario abre la sección de información del sistema
    Cuando el sistema detecta la plataforma de ejecución
    Entonces el sistema muestra "Android" con icono `android`, o
    Y puede mostrar "iOS" con icono `ios`, o
    Y puede mostrar "Windows" con icono `window`, o
    Y puede mostrar "Web" con icono `web`, o
    Y puede mostrar "Linux" con icono `laptop_windows`, o
    Y puede mostrar "macOS" con icono `ios`, o
    Y puede mostrar "Fuchsia" con icono `computer`

  Escenario: Niveles de gobierno en filtros de ubicación
    Dado que el usuario abre los filtros de nivel de gobierno
    Cuando el sistema renderiza las opciones de ubicación
    Entonces el sistema muestra "Colonia" con icono `location_on`
    Y muestra "C.P." con icono `markunread_mailbox`
    Y muestra "Municipio" con icono `account_balance`
    Y muestra "Estado" con icono `outlined_flag`
    Y muestra "País" con icono `flag_circle`

  Escenario: Opciones de acciones en listas
    Dado que el usuario abre el menú de acciones de una lista
    Cuando el sistema renderiza las opciones disponibles
    Entonces el sistema muestra "Favoritos" con icono `star`
    Y muestra "Ver despúes" con icono `bookmark`
    Y muestra "Buscar" con icono `manage_search`
    Y muestra "Ayuda" con icono `help`
    Y muestra "Contacto" con icono `forum`
