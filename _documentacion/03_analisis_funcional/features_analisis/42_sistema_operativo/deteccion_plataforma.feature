# language: es
Característica: Detección de Sistema Operativo y Plataforma

  Como desarrollador de Buscobien
  Quiero detectar la plataforma en tiempo de ejecución
  Para adaptar lógica de compresión, almacenamiento y UI

  Antecedentes:
    Dado que checaPlataformaProvider (StateProvider<ElementoPlataforma>) está disponible
    Y setCheckPlataformaProvider(ref) se invoca al iniciar app

  Escenario: Detección Web (kIsWeb = true)
    Dado que la app corre en navegador (WASM)
    Cuando setCheckPlataformaProvider ejecuta
    Entonces kIsWeb = true
    Y checaPlataformaProvider.nombrePlataforma = "web"
    Y plataformasCompressWeb = ["web"] activo

  @REQ-OS-003 @REQ-OS-005 @mapeo-auto
  Escenario: Detección Windows (defaultTargetPlatform)
    Dado que la app corre en Windows Desktop
    Cuando setCheckPlataformaProvider ejecuta
    Entonces kIsWeb = false
    Y defaultTargetPlatform = TargetPlatform.windows
    Y checaPlataformaProvider.nombrePlataforma = "windows"
    Y plataformasCompressWin = ["windows"] activo

  @REQ-OS-006 @mapeo-auto
  Escenario: Detección Android/iOS para secure storage
    Dado que la app corre en móvil
    Cuando setCheckPlataformaProvider ejecuta
    Entonces defaultTargetPlatform = android/ios
    Y checaPlataformaProvider.nombrePlataforma = "android"/"ios"
    Y SessionStorage factory retorna MobileSessionStorage (flutter_secure_storage)

  @REQ-OS-001 @REQ-OS-003 @mapeo-auto
  Escenario: Detección Linux/macOS/Fuchsia
    Dado que la app corre en plataformas desktop alternativas
    Cuando setCheckPlataformaProvider ejecuta
    Entonces mapea correctamente a nombrePlataforma correspondiente
    Y usa shared_preferences (WebSessionStorage)

  @REQ-OS-008 @mapeo-auto
  Escenario: Plataforma desconocida (futuro)
    Dado que defaultTargetPlatform retorna valor no cubierto
    Cuando switch en setCheckPlataformaProvider evalúa
    Entonces default case mantiene "Desconocido" y index = -1