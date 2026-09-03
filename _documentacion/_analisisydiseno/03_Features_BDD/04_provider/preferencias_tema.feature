# language: es
Característica: Selector de Tema de Color M3

  Como usuario de Buscobien
  Quiero personalizar el tema visual de la app
  Para adaptar la experiencia a mi preferencia

  Antecedentes:
    Dado que coloresProvider (StateProvider<SelectColorProvider>) está inicializado con color=0 ("Rosa"/lightPAN)
    Y appTheme global en var_color_themes.dart es la única fuente de ColorScheme

  Escenario: Usuario selecciona nuevo tema en Preferencias
    Dado que el usuario navega a "/preferencias" (PaginaColores)
    Cuando toca Radio button "Verde" (index 2 → lightINE)
    Entonces coloresProvider.state.color = 2
    Y appTheme = lightINE (ColorScheme completo M3)
    Y TODOS los widgets que leen appTheme reconstruyen con nuevos colores

  Escenario: 9 temas light predefinidos disponibles
    Dado que PaginaColores muestra 9 RadioListTiles
    Cuando el usuario ve la lista
    Entonces ve opciones: INE, MC, MOR, PAN, PRD, PRI, PT, PVEM, INE Dark
    Y cada opción tiene etiqueta y color representativo

  Escenario: Persistencia solo en memoria (sin disco)
    Dado que el usuario selecciona tema "Azul" (lightPRI)
    Cuando cierra y vuelve a abrir la app
    Entonces el tema vuelve a "Rosa" (lightPAN default)
    Y NO hay persistencia en SharedPreferences/SecureStorage

  Escenario: Excepción de color documentada para login
    Dado que var_login.dart usa loginPrimaryBrand = Color(0xFF415AA9)
    Cuando ui_exceptions.dart registra esta excepción
    Entonces es la ÚNICA excepción permitida a "NO Colors.xxx hardcoded"
    Y está documentada con fecha 2026-07-13