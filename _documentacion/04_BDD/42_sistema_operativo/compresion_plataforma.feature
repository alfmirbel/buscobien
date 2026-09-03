# language: es
Característica: Compresión de Imágenes por Plataforma
  Como sistema
  Quiero aplicar diferentes estrategias de compresión según la plataforma
  Para optimizar el rendimiento y compatibilidad de las imágenes

  Escenario: Compresión en plataformas Web (Android, Fuchsia, iOS, Web)
    Dado que el usuario está en una plataforma de compresión Web
    Y la plataforma es Android, Fuchsia, iOS o Web
    Cuando el sistema necesita comprimir una imagen
    Entonces el sistema aplica la lógica de compresión para plataformas Web
    Y utiliza el paquete de compresión compatible con Web

  Escenario: Compresión en plataformas Windows (Linux, macOS, Windows)
    Dado que el usuario está en una plataforma de compresión Windows
    Y la plataforma es Linux, macOS o Windows
    Cuando el sistema necesita comprimir una imagen
    Entonces el sistema aplica la lógica de compresión para plataformas Windows
    Y utiliza el paquete de compresión compatible con Windows

  Escenario: Filtrado de plataformas para compresión Web
    Dado que el sistema necesita determinar la estrategia de compresión
    Y la lista de plataformas Web es ["android", "fuchsia", "iOS", "Web u otro"]
    Cuando el sistema verifica si la plataforma actual está en la lista
    Entonces si la plataforma es Android, el sistema usa compresión Web
    Y si la plataforma es iOS, el sistema usa compresión Web
    Y si la plataforma es Web, el sistema usa compresión Web
    Y si la plataforma es Windows, el sistema NO usa compresión Web

  Escenario: Filtrado de plataformas para compresión Windows
    Dado que el sistema necesita determinar la estrategia de compresión
    Y la lista de plataformas Windows es ["linux", "macOS", "windows"]
    Cuando el sistema verifica si la plataforma actual está en la lista
    Entonces si la plataforma es Windows, el sistema usa compresión Windows
    Y si la plataforma es macOS, el sistema usa compresión Windows
    Y si la plataforma es Linux, el sistema usa compresión Windows
    Y si la plataforma es Android, el sistema NO usa compresión Windows
