# language: es
Característica: Menú Mi Cuenta (Promotor y Usuario)
  Como usuario autenticado
  Quiero navegar entre las secciones de mi cuenta
  Para acceder a mis espacios, listas, grupos y conocidos

  Escenario: El menú Mi Cuenta de promotor muestra 4 opciones
    Dado que el usuario ha iniciado sesión como promotor
    Cuando navega a la sección "Mi Cuenta"
    Entonces el sistema debe mostrar el menú "MenuSuperiorPaginaTuCuenta"
    Y debe mostrar 4 tabs: "Espacios", "Listas", "Grupos" y "Conocidos"
    Y la opción "Espacios" debe estar seleccionada por defecto

  Escenario: El promotor navega a Listas
    Dado que el promotor está en la sección "Mi Cuenta"
    Cuando el usuario presiona el tab "Listas"
    Entonces el sistema debe actualizar `menuTuCuentaProvider` con `seleccionMenuTuCuenta = 1`
    Y debe actualizar `homeNavigationProvider` con `indiceMiCuenta = 1`
    Y debe mostrar "PageMisListas"

  Escenario: El promotor navega a Grupos
    Dado que el promotor está en la sección "Mi Cuenta"
    Cuando el usuario presiona el tab "Grupos"
    Entonces el sistema debe actualizar `menuTuCuentaProvider` con `seleccionMenuTuCuenta = 2`
    Y debe actualizar `homeNavigationProvider` con `indiceMiCuenta = 2`
    Y debe mostrar "GruposView"

  Escenario: El promotor navega a Conocidos
    Dado que el promotor está en la sección "Mi Cuenta"
    Cuando el usuario presiona el tab "Conocidos"
    Entonces el sistema debe actualizar `menuTuCuentaProvider` con `seleccionMenuTuCuenta = 3`
    Y debe actualizar `homeNavigationProvider` con `indiceMiCuenta = 3`
    Y debe mostrar "ConocidosView"

  Escenario: El menú Mi Cuenta de usuario muestra 3 opciones
    Dado que el usuario ha iniciado sesión como usuario (comprador)
    Cuando navega a la sección "Mi Cuenta"
    Entonces el sistema debe mostrar el menú "MenuSuperiorPaginaTuCuentaUsuario"
    Y debe mostrar 3 tabs: "Listas", "Grupos" y "Conocidos"
    Y la opción "Listas" debe estar seleccionada por defecto

  Escenario: El usuario navega a Grupos
    Dado que el usuario comprador está en la sección "Mi Cuenta"
    Cuando el usuario presiona el tab "Grupos"
    Entonces el sistema debe actualizar `menuTuCuentaUsuarioProvider` con `seleccionMenuTuCuentaUsuario = 1`
    Y debe actualizar `homeNavigationProvider` con `indiceMiCuentaUsuario = 1`
    Y debe mostrar "GruposView"

  Escenario: El usuario navega a Conocidos
    Dado que el usuario comprador está en la sección "Mi Cuenta"
    Cuando el usuario presiona el tab "Conocidos"
    Entonces el sistema debe actualizar `menuTuCuentaUsuarioProvider` con `seleccionMenuTuCuentaUsuario = 2`
    Y debe actualizar `homeNavigationProvider` con `indiceMiCuentaUsuario = 2`
    Y debe mostrar "ConocidosView"

  Escenario: El menú Mi Cuenta de promotor está fijo en la parte superior
    Dado que el usuario está en la sección "Mi Cuenta" como promotor
    Cuando se renderiza el SliverAppBar del menú
    Entonces el sistema debe mostrar el SliverAppBar con `pinned: true`
    Y debe mantener el menú visible al hacer scroll

  Escenario: El menú Mi Cuenta de usuario está fijo en la parte superior
    Dado que el usuario está en la sección "Mi Cuenta" como comprador
    Cuando se renderiza el SliverAppBar del menú
    Entonces el sistema debe mostrar el SliverAppBar con `pinned: true`
    Y debe mantener el menú visible al hacer scroll

  Escenario: Los tabs del menú Mi Cuenta usan colores del tema M3
    Dado que el usuario está en la sección "Mi Cuenta"
    Cuando se renderiza el ButtonsTabBar
    Entonces el sistema debe mostrar los tabs con `backgroundColor: appTheme.primary`
    Y los tabs no seleccionados deben tener `unselectedBackgroundColor: appTheme.onInverseSurface`
    Y el borde debe ser `appTheme.primary` con `borderWidth: 1`
