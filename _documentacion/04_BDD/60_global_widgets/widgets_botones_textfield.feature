# language: es
Característica: Botones y Campos de Texto Personalizados
  Como usuario final
  Quiero interactuar con botones y campos de texto consistentes
  Para tener una experiencia de entrada uniforme en toda la aplicación

  Escenario: Botón personalizado MyButton
    Dado que el sistema necesita mostrar un botón de acción
    Y la etiqueta es "Iniciar Sesión"
    Y el callback `onTap` está definido
    Cuando el sistema renderiza `MyButton`
    Entonces el sistema muestra un `TextButton` con elevación 6.0
    Y el botón tiene ancho 200 y altura 40
    Y el botón tiene radio de borde 8
    Y el fondo del botón es `appTheme.primary`
    Y el texto tiene color `appTheme.onSecondary`, tamaño 14 y negrita
    Y al presionar, ejecuta el callback `onTap`

  Escenario: Campo de texto personalizado MyTextField
    Dado que el sistema necesita mostrar un campo de texto
    Y el hint es "Correo electrónico"
    Y el icono es `Symbols.email`
    Y el controlador está definido
    Cuando el sistema renderiza `MyTextField`
    Entonces el sistema muestra una columna con label y campo
    Y el label tiene color `appTheme.onPrimaryContainer` y tamaño 12
    Y el campo tiene ancho 200 y altura 40
    Y el campo tiene icono de prefijo de tamaño 16 y color `appTheme.onPrimaryContainer`
    Y el borde del campo es `appTheme.secondary`
    Y el fondo del campo es `appTheme.onSecondary`
    Y el texto ingresado tiene color `appTheme.secondary` y tamaño 14

  Escenario: Campo de contraseña MyTextFieldPassword
    Dado que el sistema necesita mostrar un campo de contraseña
    Y el hint es "Contraseña"
    Y el icono es `Symbols.lock`
    Y el controlador está definido
    Cuando el sistema renderiza `MyTextFieldPassword`
    Entonces el sistema muestra una columna con label y campo
    Y el campo tiene icono de prefijo de tamaño 18
    Y el campo muestra icono de visibilidad `visibility_off` por defecto
    Y el campo tiene el texto oculto (`obscureText: true`)
    Cuando el usuario presiona el icono de visibilidad
    Entonces el sistema cambia el estado de `isHidden`
    Y el icono cambia a `visibility`
    Y el texto del campo se hace visible

  Escenario: Tile de imagen SquareTile
    Dado que el sistema necesita mostrar una imagen cuadrada
    Y la ruta de la imagen es "assets/imagen.png"
    Cuando el sistema renderiza `SquareTile`
    Entonces el sistema muestra un contenedor con borde de color `appTheme.onPrimary`
    Y el contenedor tiene radio de borde 8
    Y el fondo del contenedor es `appTheme.onPrimary`
    Y muestra la imagen con altura 100
