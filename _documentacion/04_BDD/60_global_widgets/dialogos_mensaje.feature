# language: es
Característica: Diálogos de Mensaje General
  Como usuario final
  Quiero ver mensajes emergentes claros y consistentes
  Para confirmar acciones o recibir avisos de la aplicación

  Escenario: Mostrar diálogo de mensaje con título y mensaje
    Dado que el sistema necesita mostrar un mensaje al usuario
    Y el título es "Aviso"
    Y el mensaje es "Se eliminó la foto correctamente"
    Y el color de fondo es `appTheme.primary`
    Y la alineación es `TextAlign.center`
    Y el botón dice "Salir"
    Cuando el sistema ejecuta `showMessageDialog`
    Entonces el sistema muestra un `AlertDialog` con elevación 6
    Y el diálogo tiene bordes redondeados de radio 3
    Y el título tiene fuente "Comfortaa" tamaño 12, negrita, color `appTheme.onPrimary`
    Y el contenido tiene fondo `appTheme.onSecondary`
    Y el mensaje se muestra centrado
    Y el botón tiene fondo `appTheme.surface` y texto color `appTheme.onPrimaryContainer`

  Escenario: Cierre de diálogo al presionar botón
    Dado que el usuario está viendo un diálogo de mensaje
    Cuando el usuario presiona el botón "Salir"
    Entonces el sistema cierra el diálogo con `Navigator.pop()`

  Escenario: Diálogo con color de fondo personalizado
    Dado que el sistema necesita mostrar un mensaje de error
    Y el color de fondo es `appTheme.error`
    Y el título es "Error"
    Y el mensaje es "No se pudo eliminar la foto"
    Cuando el sistema ejecuta `showMessageDialog`
    Entonces el sistema muestra el diálogo con fondo `appTheme.error`
    Y el título tiene color `appTheme.onPrimary`
    Y el contenido se muestra correctamente sobre el fondo de error
