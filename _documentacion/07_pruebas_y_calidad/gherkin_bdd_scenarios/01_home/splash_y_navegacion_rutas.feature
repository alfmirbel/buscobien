# language: es

Característica: Splash Screen y Arranque de la Aplicación
  Como usuario de BuscoBien
  Quiero que la aplicación arranque de forma fluida con una pantalla de presentación
  Para tener una experiencia de inicio profesional mientras se cargan los recursos

  # ---------------------------------------------------------------------------
  # FLUJO DE SPLASH SCREEN
  # ---------------------------------------------------------------------------
  Escenario: La app muestra el Splash Screen al arrancar por primera vez
    Dado que el usuario abre la aplicación por primera vez
    Cuando la aplicación se inicializa en la ruta "/"
    Entonces el sistema debe mostrar "SplashPage" durante 3 segundos
    Y el Splash debe mostrar el logo y nombre de "BuscoBien"
    Y al finalizar el tiempo de espera debe navegar automáticamente a "PrincipalSliversMenuInicial"

  Escenario: Navegación directa al splash desde cualquier punto
    Dado que el sistema navega a la ruta "/splash"
    Entonces debe mostrar "SplashPage" con una duración de 3 segundos
    Y al terminar debe navegar a "PrincipalSliversMenuInicial"

  Escenario: Inicialización de controladores de menú durante el splash
    Dado que el "SplashPage" está visible
    Cuando termina de cargar y navega a "PrincipalSliversMenuInicial"
    Entonces el sistema debe inicializar de forma sincrónica todos los "TabControllers":
      | TabController                     |
      | menuInicialProvider               |
      | menuPrincipalProvider             |
      | menuNivelDeGobiernoProvider       |
      | menuTipoEspaciosProvider          |
      | menuTipoDeTransaccionProvider     |
      | menuTuCuentaProvider              |
      | menuTuCuentaUsuarioProvider       |
    Y debe recuperar la sesión guardada del almacenamiento local de forma asíncrona
    Y debe iniciar la detección de ubicación GPS en segundo plano

  # ---------------------------------------------------------------------------
  # PANTALLA DE PLATAFORMA / DETECCIÓN DE OS
  # ---------------------------------------------------------------------------
  Escenario: El sistema detecta la plataforma en la que corre la app
    Dado que la aplicación arranca en un dispositivo
    Cuando el sistema navega a la ruta "/plataforma"
    Entonces "PaginaDetectaPlataforma" debe identificar el sistema operativo
    Y debe adaptar la interfaz según las convenciones de la plataforma detectada

  # ---------------------------------------------------------------------------
  # RUTAS DE NAVEGACIÓN GLOBALES
  # ---------------------------------------------------------------------------
  Esquema del escenario: Navegación a rutas conocidas de la aplicación
    Dado que la aplicación está corriendo
    Cuando el sistema navega a la ruta "<ruta>"
    Entonces debe mostrar la pantalla "<pantalla>" sin errores

    Ejemplos:
      | ruta                    | pantalla                          |
      | /                       | SplashPage → PrincipalSliversMenuInicial |
      | /splash                 | SplashPage                        |
      | /principal              | PrincipalSliversMenuInicial       |
      | /registro               | RegisterScreenUsers               |
      | /perfil                 | PaginaPerfilWidget                |
      | /gestionavatar          | GestionAvatares                   |
      | /compraespacios         | PaginaCompraEspacios              |
      | /mapapropiedades        | PaginaMapaPropiedades             |
      | /listaspropiedades      | PageMisListas                     |
      | /solicitarrecuperacion  | PageSolicitarRecuperacion         |
      | /localidades            | PaginaBuscaLocalidadGMaps         |

  Escenario: Ruta desconocida no produce un crash
    Dado que el sistema intenta navegar a una ruta no definida "/rutainexistente"
    Cuando "routeGenerate" recibe la ruta
    Entonces el switch-case debe retornar "null" para la ruta desconocida
    Y la aplicación no debe mostrar una pantalla de error ni un crash

  # ---------------------------------------------------------------------------
  # URLs LIMPIAS EN WEB (setPathUrlStrategy)
  # ---------------------------------------------------------------------------
  Escenario: La aplicación web usa URLs limpias sin el símbolo "#"
    Dado que la aplicación corre en el navegador web
    Cuando el usuario navega a cualquier ruta de la app
    Entonces la URL en el navegador debe mostrarse sin el fragmento "#"
    Y debe ser una URL limpia (e.g., "/perfil" en lugar de "/#/perfil")
