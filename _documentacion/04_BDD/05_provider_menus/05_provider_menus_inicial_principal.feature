# language: es
Característica: Menú Inicial y Menú Principal
  Como usuario de BuscoBien
  Quiero navegar entre las secciones principales de la aplicación
  Para acceder rápidamente a Inicio, Propiedades, Ubicación, Mi Cuenta y Perfil

  Escenario: El menú inicial muestra 5 opciones al iniciar la app
    Dado que el usuario acaba de abrir la aplicación
    Cuando se renderiza el menú inicial
    Entonces el sistema debe mostrar 5 tabs: "Inicio", "Propiedades", "Ubicación", "Mi Cuenta" y "Perfil"
    Y cada tab debe tener un icono y una etiqueta de texto
    Y la opción "Inicio" debe estar seleccionada por defecto

  Escenario: El usuario cambia a la sección Propiedades
    Dado que el usuario está en la sección "Inicio"
    Cuando el usuario presiona el tab "Propiedades" en el menú inicial
    Entonces el sistema debe actualizar `menuInicialProvider` con `seleccionMenuInicial = 1`
    Y debe actualizar `homeNavigationProvider` con `indiceInicial = 1`
    Y debe mostrar el sub-menú "MenuSuperiorMenuPrincipal"

  Escenario: El usuario cambia a la sección Ubicación
    Dado que el usuario está en cualquier sección del menú inicial
    Cuando el usuario presiona el tab "Ubicación"
    Entonces el sistema debe actualizar `menuInicialProvider` con `seleccionMenuInicial = 2`
    Y debe actualizar `homeNavigationProvider` con `indiceInicial = 2`
    Y debe mostrar "PaginaPrincipalListaLocalidades"

  Escenario: El usuario cambia a la sección Mi Cuenta
    Dado que el usuario está en cualquier sección del menú inicial
    Cuando el usuario presiona el tab "Mi Cuenta"
    Entonces el sistema debe actualizar `menuInicialProvider` con `seleccionMenuInicial = 3`
    Y debe actualizar `homeNavigationProvider` con `indiceInicial = 3`

  Escenario: El usuario cambia a la sección Perfil
    Dado que el usuario está en cualquier sección del menú inicial
    Cuando el usuario presiona el tab "Perfil"
    Entonces el sistema debe actualizar `menuInicialProvider` con `seleccionMenuInicial = 4`
    Y debe actualizar `homeNavigationProvider` con `indiceInicial = 4`
    Y debe mostrar "PaginaPerfilWidget"

  Escenario: El menú inicial tiene pines en la parte superior
    Dado que el usuario está en la pantalla principal
    Cuando se renderiza el SliverAppBar del menú inicial
    Entonces el sistema debe mostrar el SliverAppBar con `pinned: true`
    Y debe mantener el menú visible al hacer scroll

  Escenario: El menú principal se muestra al seleccionar Propiedades
    Dado que el usuario navegó a la sección "Propiedades"
    Cuando se renderiza el sub-menú principal
    Entonces el sistema debe mostrar 4 tabs: "Todas", "Casas", "Departamentos" y "Otros inmuebles"
    Y la opción "Todas" debe estar seleccionada por defecto

  Escenario: El usuario filtra por tipo de propiedad Casas
    Dado que el usuario está en la sección "Propiedades"
    Cuando el usuario presiona el tab "Casas" en el menú principal
    Entonces el sistema debe actualizar `menuPrincipalProvider` con `seleccionMenuPrincipal = 1`
    Y debe actualizar `homeNavigationProvider` con `indicePrincipal = 1`

  Escenario: El usuario filtra por tipo de propiedad Departamentos
    Dado que el usuario está en la sección "Propiedades"
    Cuando el usuario presiona el tab "Departamentos"
    Entonces el sistema debe actualizar `menuPrincipalProvider` con `seleccionMenuPrincipal = 2`
    Y debe actualizar `homeNavigationProvider` con `indicePrincipal = 2`

  Escenario: El usuario filtra por Otros inmuebles
    Dado que el usuario está en la sección "Propiedades"
    Cuando el usuario presiona el tab "Otros inmuebles"
    Entonces el sistema debe actualizar `menuPrincipalProvider` con `seleccionMenuPrincipal = 3`
    Y debe actualizar `homeNavigationProvider` con `indicePrincipal = 3`

  Escenario: El menú principal flota al hacer scroll
    Dado que el usuario está en la sección "Propiedades"
    Cuando el usuario hace scroll hacia abajo y luego hacia arriba
    Entonces el SliverAppBar del menú principal debe reaparecer flotando
    Y no debe estar permanently fijado en la parte superior
