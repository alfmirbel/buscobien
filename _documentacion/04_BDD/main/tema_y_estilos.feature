# language: es
Característica: Tema y Estilos de la Aplicación
  Como usuario final
  Quiero experimentar una interfaz visualmente consistente
  Para navegar la aplicación con una experiencia uniforme

  Escenario: Tema claro por defecto con Material Design 3
    Dado que el usuario abre la aplicación
    Cuando el sistema aplica el tema
    Entonces el sistema usa `ThemeData` con `useMaterial3: true`
    Y establece el brillo a `Brightness.light`
    Y aplica el tema claro por defecto

  Escenario: Navegación inferior personalizada
    Dado que el usuario está en la pantalla principal
    Cuando el sistema renderiza la `NavigationBar`
    Entonces el sistema aplica `NavigationBarThemeData` personalizado
    Y cuando un item está seleccionado, el icono tiene color `appTheme.onPrimary`
    Y cuando un item no está seleccionado, el icono tiene color `appTheme.primary`
    Y el texto seleccionado tiene color `appTheme.primary`, negrita y tamaño `fontSizeMenuBar`
    Y el texto no seleccionado tiene color `appTheme.primary`, normal y tamaño `fontSizeMenuBar`

  Escenario: Tema global de iconos
    Dado que el usuario visualiza cualquier icono en la aplicación
    Cuando el sistema renderiza iconos
    Entonces el sistema aplica `IconThemeData` global
    Y el color de los iconos es `appTheme.onPrimaryContainer`
    Y el peso es 400
    Y el tamaño óptico es 24
    Y el tamaño es 24
