# language: es
Característica: Detección de Plataforma y Sistema Operativo
  Como usuario final
  Quiero que la aplicación detecte mi sistema operativo y dispositivo
  Para adaptar la experiencia y funcionalidades según mi plataforma

  Escenario: Detección de plataforma Web
    Dado que el usuario abre la aplicación desde un navegador web
    Y `kIsWeb` es verdadero
    Cuando el sistema detecta la plataforma
    Entonces el sistema establece el índice 6 en `buttonSelectOpcion`
    Y establece `nombrePlataforma` como "Web u otro"
    Y establece la etiqueta correspondiente a "Web u otro"
    Y establece el icono correspondiente a la plataforma web

  Escenario: Detección de plataforma Android
    Dado que el usuario abre la aplicación en un dispositivo Android
    Y `defaultTargetPlatform` es `TargetPlatform.android`
    Cuando el sistema detecta la plataforma
    Entonces el sistema establece el índice 0 en `buttonSelectOpcion`
    Y establece `nombrePlataforma` como "android"
    Y establece la etiqueta correspondiente a "android"
    Y establece el icono correspondiente a Android

  Escenario: Detección de plataforma iOS
    Dado que el usuario abre la aplicación en un dispositivo iOS
    Y `defaultTargetPlatform` es `TargetPlatform.iOS`
    Cuando el sistema detecta la plataforma
    Entonces el sistema establece el índice 2 en `buttonSelectOpcion`
    Y establece `nombrePlataforma` como "iOS"
    Y establece la etiqueta correspondiente a "iOS"
    Y establece el icono correspondiente a iOS

  Escenario: Detección de plataforma Windows
    Dado que el usuario abre la aplicación en Windows
    Y `defaultTargetPlatform` es `TargetPlatform.windows`
    Cuando el sistema detecta la plataforma
    Entonces el sistema establece el índice 5 en `buttonSelectOpcion`
    Y establece `nombrePlataforma` como "windows"
    Y establece la etiqueta correspondiente a "windows"
    Y establece el icono correspondiente a Windows

  Escenario: Detección de plataforma Linux
    Dado que el usuario abre la aplicación en Linux
    Y `defaultTargetPlatform` es `TargetPlatform.linux`
    Cuando el sistema detecta la plataforma
    Entonces el sistema establece el índice 3 en `buttonSelectOpcion`
    Y establece `nombrePlataforma` como "linux"
    Y establece la etiqueta correspondiente a "linux"
    Y establece el icono correspondiente a Linux

  Escenario: Detección de plataforma macOS
    Dado que el usuario abre la aplicación en macOS
    Y `defaultTargetPlatform` es `TargetPlatform.macOS`
    Cuando el sistema detecta la plataforma
    Entonces el sistema establece el índice 4 en `buttonSelectOpcion`
    Y establece `nombrePlataforma` como "macOS"
    Y establece la etiqueta correspondiente a "macOS"
    Y establece el icono correspondiente a macOS

  Escenario: Detección de plataforma Fuchsia
    Dado que el usuario abre la aplicación en Fuchsia
    Y `defaultTargetPlatform` es `TargetPlatform.fuchsia`
    Cuando el sistema detecta la plataforma
    Entonces el sistema establece el índice 1 en `buttonSelectOpcion`
    Y establece `nombrePlataforma` como "fuchsia"
    Y establece la etiqueta correspondiente a "fuchsia"
    Y establece el icono correspondiente a Fuchsia

  Escenario: Reset de estado de plataforma antes de detectar
    Dado que el sistema va a detectar la plataforma
    Cuando el sistema ejecuta `setCheckPlataformaProvider`
    Entonces el sistema resetea todos los valores de `buttonSelectOpcion` a `false`
    Y resetea el índice a 0
    Y resetea la etiqueta al valor inicial
    Y resetea el icono al valor inicial

  Escenario: Estado inicial sin verificar
    Dado que la aplicación se inicia por primera vez
    Cuando el sistema inicializa el provider de plataforma
    Entonces el sistema establece `index` en 0
    Y establece `etiqueta` en "Android" (primer elemento de `elementosPlataforma`)
    Y establece `nombrePlataforma` en "Sin verificar conexión"
    Y todos los valores de `buttonSelectOpcion` están en `false`
