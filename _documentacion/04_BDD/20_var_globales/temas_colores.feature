# language: es
Característica: Temas y Colores de la Aplicación
  Como usuario final
  Quiero experimentar una interfaz visualmente consistente
  Para navegar la aplicación con una experiencia de marca uniforme

  Escenario: Tema claro por defecto al iniciar la aplicación
    Dado que el usuario abre la aplicación por primera vez
    Cuando el sistema carga los temas visuales
    Entonces el sistema aplica el esquema de color `lightPAN` como tema activo
    Y el color primario de la interfaz es `#415AA9`
    Y el color de fondo de las superficies es `#E2E1EC`
    Y el color del texto principal sobre superficie es `#000096`

  Escenario: Cambio a tema oscuro PAN
    Dado que el usuario activa el modo oscuro en la configuración
    Y el perfil de marca seleccionado es PAN
    Cuando el sistema carga los temas visuales
    Entonces el sistema aplica el esquema de color `darkPAN` como tema activo
    Y el color primario de la interfaz es `#B5C4FF`
    Y el color de fondo de las superficies es `#1B1B1F`
    Y el color del texto principal sobre superficie es `#E4E2E6`

  Escenario: Aplicación de tema de marca INE en modo claro
    Dado que el usuario selecciona el tema de marca INE
    Y el modo de visualización es claro
    Cuando el sistema carga los temas visuales
    Entonces el sistema aplica el esquema de color `lightINE` como tema activo
    Y el color primario de la interfaz es `#BC004B`
    Y el contenedor primario es `#FFD9DE`
    Y el texto sobre contenedor primario es `#400014`

  Escenario: Aplicación de tema de marca INE en modo oscuro
    Dado que el usuario selecciona el tema de marca INE
    Y el modo de visualización es oscuro
    Cuando el sistema carga los temas visuales
    Entonces el sistema aplica el esquema de color `darkINE` como tema activo
    Y el color primario de la interfaz es `#FFB2BE`
    Y el contenedor primario es `#900038`
    Y el texto sobre contenedor primario es `#FFD9DE`

  Escenario: Aplicación de tema de marca MC en modo claro
    Dado que el usuario selecciona el tema de marca MC
    Y el modo de visualización es claro
    Cuando el sistema carga los temas visuales
    Entonces el sistema aplica el esquema de color `lightMC` como tema activo
    Y el color primario de la interfaz es `#954A00`

  Escenario: Aplicación de tema de marca MORENA en modo oscuro
    Dado que el usuario selecciona el tema de marca MORENA
    Y el modo de visualización es oscuro
    Cuando el sistema carga los temas visuales
    Entonces el sistema aplica el esquema de color `darkMOR` como tema activo
    Y el color primario de la interfaz es `#FFB2BB`

  Escenario: Aplicación de tema de marca PRD en modo claro
    Dado que el usuario selecciona el tema de marca PRD
    Y el modo de visualización es claro
    Cuando el sistema carga los temas visuales
    Entonces el sistema aplica el esquema de color `lightPRD` como tema activo
    Y el color primario de la interfaz es `#775A00`

  Escenario: Aplicación de tema de marca PRI en modo oscuro
    Dado que el usuario selecciona el tema de marca PRI
    Y el modo de visualización es oscuro
    Cuando el sistema carga los temas visuales
    Entonces el sistema aplica el esquema de color `darkPRI` como tema activo
    Y el color primario de la interfaz es `#FFB4A8`

  Escenario: Aplicación de tema de marca PT en modo claro
    Dado que el usuario selecciona el tema de marca PT
    Y el modo de visualización es claro
    Cuando el sistema carga los temas visuales
    Entonces el sistema aplica el esquema de color `lightPT` como tema activo
    Y el color primario de la interfaz es `#BF0028`

  Escenario: Aplicación de tema de marca PVEM en modo oscuro
    Dado que el usuario selecciona el tema de marca PVEM
    Y el modo de visualización es oscuro
    Cuando el sistema carga los temas visuales
    Entonces el sistema aplica el esquema de color `darkPVEM` como tema activo
    Y el color primario de la interfaz es `#04E600`

  Escenario: Aplicación de tema oscuro genérico
    Dado que el usuario activa el modo oscuro sin selección de marca específica
    Cuando el sistema carga los temas visuales
    Entonces el sistema aplica el esquema de color `darkALL` como tema activo
    Y el color primario de la interfaz es `#373737`

  Escenario: Estilo de TabBar con tema activo
    Dado que el usuario visualiza una pantalla con pestañas
    Y el tema activo es `lightPAN`
    Cuando el sistema renderiza el TabBar
    Entonces el indicador de pestaña seleccionada tiene color `appTheme.primary`
    Y la etiqueta seleccionada tiene color negro
    Y la etiqueta no seleccionada tiene color `appTheme.outlineVariant`
    Y el tamaño de fuente de la etiqueta es 12
    Y el peso de fuente seleccionado es bold
    Y el tamaño del indicador es `TabBarIndicatorSize.tab`
