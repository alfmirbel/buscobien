# language: es
Característica: Selección de Esquema de Colores
  Como usuario final
  Quiero cambiar el esquema de colores de la aplicación
  Para personalizar la apariencia visual según mi preferencia

  Escenario: La pantalla de colores muestra 9 opciones de esquema
    Dado que el usuario abre la pantalla de preferencias de colores
    Cuando se renderiza "PaginaColores"
    Entonces el sistema debe mostrar 9 opciones de esquema de colores
    Y cada opción debe tener un radio button y una etiqueta descriptiva
    Y las opciones deben ser: Rosa, Naranja, Guinda, Azul, Amarillo, Rojo, Rojo Fuerte, Verde y Obscuro

  Escenario: El radio button de la opción seleccionada está marcado al abrir la pantalla
    Dado que el usuario tiene seleccionado el esquema "Azul" (índice 3)
    Cuando se renderiza "PaginaColores"
    Entonces el radio button correspondiente a "Azul" debe estar marcado
    Y los demás radio buttons deben estar desmarcados

  Escenario: El usuario cambia el esquema de colores a Rosa
    Dado que el usuario está en la pantalla de colores
    Cuando el usuario presiona el radio button de "Opción 1: Rosa"
    Entonces el sistema debe actualizar `coloresProvider` con `color = 0`
    Y debe cambiar `appTheme` a `lightINE`
    Y la interfaz de la aplicación debe reflejar el nuevo esquema de colores

  Escenario: El usuario cambia el esquema de colores a Naranja
    Dado que el usuario está en la pantalla de colores
    Cuando el usuario presiona el radio button de "Opción 2: Naranja"
    Entonces el sistema debe actualizar `coloresProvider` con `color = 1`
    Y debe cambiar `appTheme` a `lightMC`

  Escenario: El usuario cambia el esquema de colores a Guinda
    Dado que el usuario está en la pantalla de colores
    Cuando el usuario presiona el radio button de "Opción 3: Guinda"
    Entonces el sistema debe actualizar `coloresProvider` con `color = 2`
    Y debe cambiar `appTheme` a `lightMOR`

  Escenario: El usuario cambia el esquema de colores a Azul
    Dado que el usuario está en la pantalla de colores
    Cuando el usuario presiona el radio button de "Opción 4: Azul"
    Entonces el sistema debe actualizar `coloresProvider` con `color = 3`
    Y debe cambiar `appTheme` a `lightPAN`

  Escenario: El usuario cambia el esquema de colores a Amarillo
    Dado que el usuario está en la pantalla de colores
    Cuando el usuario presiona el radio button de "Opción 5: Amarillo"
    Entonces el sistema debe actualizar `coloresProvider` con `color = 4`
    Y debe cambiar `appTheme` a `lightPRD`

  Escenario: El usuario cambia el esquema de colores a Rojo
    Dado que el usuario está en la pantalla de colores
    Cuando el usuario presiona el radio button de "Opción 6: Rojo"
    Entonces el sistema debe actualizar `coloresProvider` con `color = 5`
    Y debe cambiar `appTheme` a `lightPRI`

  Escenario: El usuario cambia el esquema de colores a Rojo Fuerte
    Dado que el usuario está en la pantalla de colores
    Cuando el usuario presiona el radio button de "Opción 7: Rojo Fuerte"
    Entonces el sistema debe actualizar `coloresProvider` con `color = 6`
    Y debe cambiar `appTheme` a `lightPT`

  Escenario: El usuario cambia el esquema de colores a Verde
    Dado que el usuario está en la pantalla de colores
    Cuando el usuario presiona el radio button de "Opción 8: Verde"
    Entonces el sistema debe actualizar `coloresProvider` con `color = 7`
    Y debe cambiar `appTheme` a `lightPVEM`

  Escenario: El usuario cambia el esquema de colores a Obscuro
    Dado que el usuario está en la pantalla de colores
    Cuando el usuario presiona el radio button de "Opción 9: Obscuro"
    Entonces el sistema debe actualizar `coloresProvider` con `color = 8`
    Y debe cambiar `appTheme` a `darkINE`

  Escenario: El botón Regresar cierra la pantalla de preferencias
    Dado que el usuario está en la pantalla de preferencias de colores
    Cuando el usuario presiona el botón "Regresar"
    Entonces el sistema debe ejecutar `Navigator.of(context).pop()`
    Y debe regresar a la pantalla anterior

  Escenario: La AppBar muestra el título "Esquema de Colores" con fondo de error
    Dado que el usuario abre la pantalla de preferencias de colores
    Cuando se renderiza la AppBar
    Entonces el sistema debe mostrar el título "Esquema de Colores"
    Y el fondo de la AppBar debe ser `appTheme.error`
    Y el color del texto debe ser `appTheme.onError`

  Escenario: La pantalla muestra el texto de instrucción
    Dado que el usuario está en la pantalla de preferencias de colores
    Cuando se renderiza el contenido
    Entonces el sistema debe mostrar el texto "Selecciona el esquema de colores"
    Y el texto debe estar centrado y en color `appTheme.primary`
