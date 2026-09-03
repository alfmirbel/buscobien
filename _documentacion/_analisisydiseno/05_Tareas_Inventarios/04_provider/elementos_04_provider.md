# Inventario de Componentes — 04_provider

**Directorio:** `lib/04_provider/`
**Archivos:** `pagina_colores.dart`, `provider_preferencias.dart`
**Fecha:** 2026-08-12

---

## Tabla 1: Componentes (por archivo)

| Subdirectorio | Nombre del archivo | Tipo de componente | Nombre del componente | Parámetros que requiere | Variables que utiliza | Variables internas | Estilos que le aplican |
|---------------|-------------------|-------------------|----------------------|------------------------|----------------------|-------------------|------------------------|
| 04_provider | `provider_preferencias.dart` | Clase modelo | `SelectColorProvider` | `int color`, `String etiqueta` | — | `color`, `etiqueta` (`final`) | — |
| 04_provider | `provider_preferencias.dart` | StateProvider | `coloresProvider` | `StateProvider<SelectColorProvider>` | `iniciaColor` (instancia default) | — | — |
| 04_provider | `provider_preferencias.dart` | Instancia default | `iniciaColor` | `SelectColorProvider(color: 0, etiqueta: "Rosa")` | — | — | — |
| 04_provider | `pagina_colores.dart` | ConsumerStatefulWidget | `PaginaColores` | `String backpage` | `coloresProvider`, `appTheme`, `debugPrintLevels` | `_PaginaColoresState` | `appTheme` (ColorScheme global), `RadioListTile`, `ListTileTheme` |
| 04_provider | `pagina_colores.dart` | ConsumerState | `PaginaColoresState` (`_PaginaColoresState`) | — | `coloresProvider`, `appTheme`, `temaSeleccionado[index]` | — | `build()` con `Scaffold`, `AppBar`, `ListView` + 9 `RadioListTile` |

---

## Tabla 2: Elementos (por archivo)

| Subdirectorio | Nombre del archivo | Variables definidas en el archivo | Clases | Variables de la clase | Funciones o widgets definidos en la clase | Variables que utiliza | Llamadas a otras clases o widgets |
|---------------|-------------------|----------------------------------|--------|----------------------|------------------------------------------|----------------------|----------------------------------|
| 04_provider | `provider_preferencias.dart` | `coloresProvider` (`StateProvider<SelectColorProvider>`), `iniciaColor` (`SelectColorProvider(color:0, etiqueta:"Rosa")`) | `SelectColorProvider` | `color: int`, `etiqueta: String` (ambos `final`) | Constructor | — | — |
| 04_provider | `pagina_colores.dart` | — | `PaginaColores` (ConsumerStatefulWidget) | `backpage: String` | `createState() → PaginaColoresState` | `coloresProvider`, `appTheme` | `RadioListTile`, `ListTileTheme`, `ListView`, `AppBar` |
| 04_provider | `pagina_colores.dart` | — | `PaginaColoresState` (ConsumerState) | — | `build()` | `ref`, `coloresProvider`, `appTheme`, `temaSeleccionado` | `RadioListTile` (9 items), `ref.read(coloresProvider.notifier).state = SelectColorProvider(...)`, `appTheme = temaSeleccionado[index]` |

---

## Notas

- **Alcance**: Este archivo documenta exclusivamente los 2 archivos de `lib/04_provider/`: `provider_preferencias.dart` (provider de estado del tema) y `pagina_colores.dart` (pantalla de preferencias visuales con 9 temas).
- **Modelo de estado**: `SelectColorProvider` es clase plana (no Freezed) con dos campos `final`; instancia inmutable vía constructor.
- **Provider**: `coloresProvider` es `StateProvider<SelectColorProvider>` (Riverpod clásico, sin codegen). Estado inicial: `iniciaColor` (color=0 → "Rosa" → `lightPAN`).
- **Mecánica de cambio de tema**: al seleccionar un `RadioListTile`, el callback hace dos asignaciones — (1) actualiza `ref.read(coloresProvider.notifier).state` con un nuevo `SelectColorProvider(color, etiqueta)`, y (2) muta la variable global `appTheme` en `lib/20_var_globales/var_color_themes.dart` con `temaSeleccionado[index]`. La UI que lee `appTheme` reconstruye con el nuevo `ColorScheme` M3.
- **Persistencia**: **no hay** — el tema seleccionado se pierde al reiniciar la app (solo en memoria vía Riverpod). Default: `lightPAN`.
- **Acceso**: `PaginaColores` recibe `String backpage` para saber a qué ruta regresar tras la selección; usa `Navigator.pushReplacementNamed(backpage)` desde el `AppBar`.
- **9 temas disponibles** (definidos en `var_color_themes.dart`): 8 light (`lightINE`, `lightMC`, `lightMOR`, `lightPAN`, `lightPRD`, `lightPRI`, `lightPT`, `lightPVEM`) + 1 dark (`darkINE`); además hay `dark*` variants y `darkALL` no expuestos en la UI.
- **Dependencias cruzadas**: este subdirectorio **depende de** `lib/20_var_globales/var_color_themes.dart` (donde se define `appTheme` y los `ColorScheme` const) y de `lib/60_global_widgets/debugprint.dart` (logging).
