# language: es
Característica: Providers de Menús y SliverAppBars Dinámicos

  Como usuario de Buscobien
  Quiero filtrar propiedades por 5 dimensiones con tabs sincronizados
  Para encontrar exactamente lo que busco

  Antecedentes:
    Dado que 7 providers ClaseMenuX (StateNotifier) gestionan estado de menús
    Y cada uno tiene TabController sincronizado bidireccionalmente
    Y 5 SliverAppBars renderizan ButtonsTabBar consumiendo providers

  Escenario: 7 menús con items y roles diferenciados
    Dado que el usuario navega en principal
    Cuando ve menú Inicial
    Entonces 5 tabs: Inicio, Propiedades, Ubicación, Mi Cuenta, Perfil
    Cuando ve menú Principal
    Entonces 4 tabs: Todas, Casas, Departamentos, Otros
    Cuando ve menú Tipo Espacio
    Entonces 5 tabs: Normales, Destacados, Superdestacados, Oportunidades, Remates
    Cuando ve menú Tipo Transacción
    Entonces 5 tabs: Todas, Venta, Renta, Venta/Renta, Traspaso
    Cuando ve menú Nivel Gobierno
    Entonces 5 tabs: Nacional, Estado, Municipio, C.P., Tipo/Localidad (dinámicas)
    Cuando ve menú Tu Cuenta (Promotor)
    Entonces 4 tabs: Propiedades, Listas, Grupos, Conocidos
    Cuando ve menú Tu Cuenta (Usuario)
    Entonces 3 tabs: Listas, Grupos, Conocidos

  Escenario: Sincronización TabController ↔ Notifier bidireccional
    Dado que usuario toca tab en SliverAppBar
    Cuando ButtonsTabBar emite onTap(index)
    Entonces ClaseMenuX.asignaNuevaOpcionSeleccionada(ref, index) actualiza estado
    Y TabController.index sincroniza via listener
    Dado que homeNavigationProvider.indiceX cambia externamente
    Cuando listener en PrincipalSliversMenuInicial detecta
    Entonces llama ClaseMenuX.asignaNuevaOpcionSeleccionada para sync

  Escenario: ValueKey dinámica evita error AXTree
    Dado que ButtonsTabBar se reconstruye con nuevos tabs
    Cuando usa ValueKey('menuInicial-$index')
    Entonces Flutter no lanza error "Multiple elements with same key"

  Escenario: Menú Nivel Gobierno poblado desde SEPOMEX
    Dado que localidadesPorCodigoPostalProvider tiene datos
    Cuando MenuSuperiorPaginaInicioNivelGobierno construye tabs
    Entonces crea tab por cada localidad (CP → asentamientos)

  Escenario: Dropdown tipo inmueble actualiza variable global
    Dado que DropdownButtonPropiedad muestra lista tipos
    Cuando usuario selecciona "Departamentos"
    Entonces selectedDropDownMenuPrincipalValue = "Departamentos"
    Y onChangedCallback notifica a listeners

  Escenario: 7 TabControllers requieren dispose correcto
    Dado que usuario navega fuera de principal
    Cuando PrincipalSliversMenuInicial dispose()
    Entonces llama disposeController() en 7 notifiers
    PERO no verificado en todos los flujos (riesgo leaks)