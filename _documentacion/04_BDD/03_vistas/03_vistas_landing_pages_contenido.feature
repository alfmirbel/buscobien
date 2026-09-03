# language: es
Característica: Contenido y Secciones de las Landing Pages
  Como usuario final
  Quiero ver contenido relevante y atractivo en cada landing page
  Para entender los beneficios de cada perfil de usuario

  Escenario: La landing page de Búsqueda muestra un buscador de Código Postal
    Dado que el usuario abre la landing page de "Buscar"
    Cuando se renderiza la sección Hero
    Entonces el sistema debe mostrar un campo de texto con placeholder "Código Postal (Ej. 06600)..."
    Y el campo debe aceptar solo números con máximo 5 dígitos
    Y debe mostrar un botón "Buscar" para ejecutar la búsqueda

  Escenario: La búsqueda valida que el Código Postal sea de 5 dígitos
    Dado que el usuario está en la landing page de "Buscar"
    Cuando el usuario ingresa un código postal con menos de 4 dígitos
    Y presiona "Buscar"
    Entonces el sistema debe mostrar un SnackBar con el texto "El Código Postal debe ser de 5 dígitos."
    Y el SnackBar debe tener color de error

  Escenario: La landing page de Búsqueda muestra propiedades destacadas
    Dado que el usuario está en la landing page de "Buscar"
    Cuando se carga el carrusel de propiedades
    Entonces el sistema debe mostrar tarjetas horizontales con foto, precio, título y ubicación
    Y cada tarjeta debe mostrar los íconos de características (m², recámaras, baños, estacionamientos)
    Y debe mostrar un botón "Ver todas" que navega a la sección de Propiedades

  Escenario: La landing page de Búsqueda muestra categorías rápidas
    Dado que el usuario está en la landing page de "Buscar"
    Cuando se renderiza la sección de categorías
    Entonces el sistema debe mostrar 4 categorías: "Casas", "Depas", "Locales" y "Terrenos"
    Y cada categoría debe tener un ícono en un CircleAvatar con color secundario

  Escenario: La landing page de Promotores muestra herramientas profesionales
    Dado que el usuario abre la landing page de "Promotores"
    Cuando se renderiza la sección de herramientas
    Entonces el sistema debe mostrar un grid con las herramientas: Analítica, Gestión de Leads, Posicionamiento, Perfil Verificado y API & XML
    Y cada herramienta debe tener un ícono, título y descripción

  Escenario: La landing page de Propietarios muestra un testimonio
    Dado que el usuario abre la landing page de "Propietarios"
    Cuando se renderiza la sección de testimonio
    Entonces el sistema debe mostrar un texto de testimonio entre comillas
    Y debe mostrar el nombre y ubicación del testimonio (ej. "- Laura G., Propietaria en CDMX")

  Escenario: La landing page de Servicios muestra categorías de servicios
    Dado que el usuario abre la landing page de "Servicios"
    Cuando se renderiza la sección de categorías
    Entonces el sistema debe mostrar tarjetas con servicios como Mudanzas, Remodelación, Interiorismo, Mantenimiento, Carpintería y Limpieza
    Y cada tarjeta debe tener un ícono, título y subtítulo

  Escenario: La landing page de Proveedores muestra estrategia "Shop the Look"
    Dado que el usuario abre la landing page de "Proveedores"
    Cuando se renderiza la sección de estrategia
    Entonces el sistema debe mostrar una imagen con etiquetas de compra superpuestas (ej. "$ Sofá", "$ Lámpara")
    Y debe mostrar texto explicativo sobre publicidad contextual

  Escenario: La landing page de Asociaciones muestra aliados estratégicos
    Dado que el usuario abre la landing page de "Asociaciones"
    Cuando se renderiza la sección de aliados
    Entonces el sistema debe mostrar logos de asociaciones (AMPI, APCI, UPIM, MIO, SUMA)
    Y cada logo debe estar dentro de un Container circular con sombra

  Escenario: La landing page de Inmobiliarias muestra beneficios para agencias
    Dado que el usuario abre la landing page de "Inmobiliarias"
    Cuando se renderiza la sección de beneficios
    Entonces el sistema debe mostrar tarjetas con: Gestión de Agentes, Micrositio, Carga Masiva
    Y cada tarjeta debe tener ícono, título y descripción

  Escenario: Las landing pages se adaptan a pantallas pequeñas
    Dado que el usuario abre cualquier landing page en un dispositivo móvil
    Cuando se renderiza el grid de beneficios o herramientas
    Entonces el sistema debe mostrar una sola columna
    Y los textos deben mantenerse legibles sin recortes
