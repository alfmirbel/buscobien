# language: es
Característica: Estado Global de Navegación Home

  Como usuario de Buscobien
  Quiero que mi posición en menús y tabs persista al navegar
  Para tener experiencia fluida sin perder contexto

  Antecedentes:
    Dado que HomeNavigation provider está inicializado con HomeState (todos índices 0, version 0)
    Y la app usa Riverpod Generator (@riverpod)

  Escenario: Actualización de índice con version bump para rebuild granular
    Dado que el usuario toca tab "Propiedades" en NavigationBar
    Cuando la UI llama actualizarPrincipal(1)
    Entonces el sistema crea nuevo HomeState con indicePrincipal = 1
    E incrementa version de 0 a 1
    Y notifica a listeners de ref.watch(homeNavigationProvider.select((s) => s.version))

  Escenario: Actualización simple sin version bump (setX)
    Dado que un widget interno necesita sincronizar índice
    Cuando se llama setPrincipal(2)
    Entonces el sistema actualiza indicePrincipal = 2
    PERO NO incrementa version
    Y widgets que escuchan version NO reconstruyen

  Escenario: Estado inicial por defecto
    Dado que la app inicia por primera vez
    Cuando HomeNavigation.build() ejecuta
    Entonces retorna HomeState con todos los 7 índices en 0
    Y version = 0

  Escenario: Siete dimensiones de navegación independientes
    Dado que el usuario navega por la app
    Cuando cambia cualquier índice (Inicial, Principal, NivelGobierno, TipoEspacio, TipoTransaccion, MiCuenta, MiCuentaUsuario)
    Entonces el sistema mantiene cada dimensión independiente
    Y version incrementa solo en actualizarX() (no en setX())

  Escenario: Logging de debug en actualizaciones
    Dado que debugPrintLevels level 10 está activo
    Cuando se llama cualquier actualizarX()
    Entonces el sistema loggea "*************** ACTUALIZA PROVIDERS [SECCIÓN] ***************"