# language: es
Funcionalidad: Landing pages por actor / catálogos públicos

  Como visitante (potencial promotor, propietario, inmobiliaria, proveedor, etc.)
  Quiero una landing page adaptada a mi segmento que explique el valor de Buscobien
  Para decidir registrarme y publicar o buscar propiedades

  Antecedentes:
    Dado que el sistema expone 9 landing pages como ConsumerWidget en lib/03_vistas/
    Y cada página usa estructura común: AppBar (back condicional + título), SingleChildScrollView, secciones Hero/Features/Beneficios/Pasos/Footer + derechosReservadosObscuro()

  Escenario: Estructura común de toda landing
    Dado que el visitante llega a cualquier página (promotores, propietarios, hospedaje, usuarios, inmobiliarias, market, proveedores, servicios, asociaciones)
    Cuando la página se renderiza
    Entonces muestra AppBar con título del segmento y botón back si Navigator.canPop(context)
    Y un SingleChildScrollView con secciones Hero + Beneficios + Stats + Features + Pasos + Footer
    Y al final el widget derechosReservadosObscuro()

  Escenario: CTA funcional en Promotores
    Dado que el visitante está en pagina_promotores.dart
    Cuando toca "Prueba Gratis" / "Publicar"
    Entonces el sistema configura 4 providers (tipoEspacio, tipoTransaccion, tuCuenta, nivelGobierno) con valores predeterminados
    Y navega a AppRoutes.principal con pushReplacementNamed

  Escenario: CTA funcional en Propietarios
    Dado que el visitante está en pagina_propietarios.dart
    Cuando toca "Publicar Gratis Ahora"
    Entonces el sistema configura los 4 providers con valores de propietario
    Y navega a AppRoutes.principal con pushReplacementNamed

  Escenario: CTA funcional en Hospedaje
    Dado que el visitante está en pagina_hospedaje.dart
    Cuando toca "Aquí publicaras"
    Entonces el sistema configura 5 providers (incluyendo seleccionPrincipal) con valores de hospedaje
    Y navega a AppRoutes.principal con pushReplacementNamed

  Escenario: CTA "Buscar" en página Usuarios (híbrida landing + búsqueda)
    Dado que el visitante está en pagina_usuarios.dart
    Cuando ingresa un CP válido (5 dígitos) y toca "Buscar"
    Entonces el sistema valida CP y actualiza codigoPostalBusquedaProvider
    Y navega a búsqueda de localidades
    Y se renderiza la sección de carrusel con paginación 10-en-10 vía findPropiedadesEstadosde10en10Provider

  Escenario: Carrusel paginado en página Usuarios
    Dado que el visitante está desplazándose por el carrusel de propiedades en pagina_usuarios.dart
    Cuando llega al final de la página cargada (paramSkip offset)
    Entonces el sistema carga las siguientes 10 propiedades (paramSkip += 10)
    Y las nuevas tarjetas se añaden con fallback a endpoints alternativos si la principal falla

  Escenario: CTA deshabilitado / placeholder en Inmobiliarias, Market, Proveedores, Servicios, Asociaciones
    Dado que el visitante está en una de las 5 páginas placeholder
    Cuando lee el CTA
    Entonces muestra "PROXIMAMENTE..." o navega a registro sin lógica real
    Y onPressed es null o no configura providers

  Escenario: Botón back condicional
    Dado que la landing fue abierta vía ruta interna (Navigator tiene historial)
    Cuando Navigator.canPop(context) == true
    Entonces AppBar muestra el botón back
    Y al tap retrocede un nivel

  Escenario: Formulario de contacto en Inmobiliarias (parcial)
    Dado que el visitante está en pagina_inmobiliarias.dart
    Cuando ve el formulario de contacto
    Entonces hay TextFormFields con validación básica
    Y un botón submit no conectado a backend (.estado Parcial)

  Escenario: Color/branding propio por segmento (deuda UI)
    Dado que cada landing define su paleta propia
    Cuando la página se pinta
    Entonces usa Color(0xFF...) directo (no appTheme)
    Y esto viola la regla de ui_exceptions.dart (no documentadas como excepción)
