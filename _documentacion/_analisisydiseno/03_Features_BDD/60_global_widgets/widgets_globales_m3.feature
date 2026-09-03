# language: es
Característica: Widgets Globales Reutilizables Material Design 3

  Como desarrollador de Buscobien
  Quiero componentes base consistentes y tipados
  Para construir pantallas rápido sin repetir código

  Antecedentes:
    Dado que lib/60_global_widgets/ expone 6 utilidades/widget
    Y TODOS usan appTheme (ColorScheme global) — 0 Colors.xxx hardcoded
    Y iconografía usa material_symbols_icons (Symbols.xxx)

  Escenario: Botón primario estandarizado (MyButton)
    Dado que el desarrollador usa MyButton(texto: "Guardar")
    Cuando se renderiza
    Entonces es TextButton con Container 200x40
    Y elevation 5, color appTheme.primary
    Y texto appTheme.onPrimary, fuente Comfortaa

  Escenario: Campo de texto estandarizado (MyTextField)
    Dado que el desarrollador usa MyTextField(label: "Email", icon: Symbols.email)
    Cuando se renderiza
    Entonces OutlineInputBorder con appTheme.primary
    Y prefixIcon Symbols, colores tema
    Y label estilo Comfortaa

  Escenario: Campo password con toggle visibilidad (MyTextFieldPassword)
    Dado que el usuario interactúa con MyTextFieldPassword
    Cuando toca IconButton (Symbols.visibility/visibility_off)
    Entonces obscureText togglea
    PERO usa variables globales isHidden* compartidas (riesgo estado compartido)

  Escenario: Sistema de logging por 21 niveles (debugPrintLevels)
    Dado que debugPrintLevels(10, "mensaje") se invoca
    Cuando level10 = true
    Entonces imprime mensaje con prefijo nivel
    Y 21 booleanos level00-level20 controlan verbosidad

  Escenario: Estados FutureBuilder estandarizados
    Dado que un FutureBuilder usa stateWaiting()/stateError()/stateNone()
    Cuando connectionState cambia
    Entonces muestra CircularProgressIndicator / "Error: $e" / "Sin resultados"
    Y loggea via debugPrintLevels(9, ...)
    Y versiones FS (FullScreen) para pantallas completas

  Escenario: Formato moneda mexicana (generaCantidad/formatoCantidad)
    Dado que formatoCantidad(5003007) se invoca
    Cuando formatea
    Entonces retorna "5,003,007" (millones,miles,cientos con padding "00")

  Escenario: Copyright responsive (derechosReservadosClaro/Obscuro)
    Dado que se necesita footer legal
    Cuando se usa derechosReservadosClaro()
    Entonces retorna Column "© 2026 Buscobien®" size 10, colores appTheme.surface/onSurface