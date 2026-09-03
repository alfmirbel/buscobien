# language: es
Característica: Integración con Riverpod y Variables Globales
  Como sistema
  Quiero mantener estado global y acceder a configuraciones globales
  Para garantizar consistencia en toda la aplicación

  Escenario: ProviderScope como wrapper de la aplicación
    Dado que la aplicación inicia
    Cuando el sistema ejecuta `runApp()`
    Entonces el sistema envuelve `BuscoBienApp` con `ProviderScope`
    Y todos los widgets pueden acceder a providers de Riverpod
    Y el estado global se mantiene durante toda la sesión

  Escenario: Acceso al tema global de colores
    Dado que cualquier widget necesita acceder a colores del tema
    Cuando el widget importa `var_color_themes.dart`
    Entonces el sistema expone `appTheme` como `ColorScheme`
    Y el widget puede usar `appTheme.primary`, `appTheme.onPrimary`, etc.

  Escenario: Acceso al nombre de la aplicación
    Dado que el sistema necesita mostrar el nombre de la app
    Cuando el widget importa `var_login.dart`
    Entonces el sistema expone `appName = "buscobien"`
    Y el widget puede mostrar el nombre en títulos o diálogos

  Escenario: Acceso a estilos de widgets globales
    Dado que el sistema necesita estilos consistentes para AppBar
    Cuando el widget importa `var_de_estilo_widgets.dart`
    Entonces el sistema expone funciones como `appBarSecondPage(titulo)`
    Y el widget puede crear AppBars con altura 40, centrado y colores del tema
