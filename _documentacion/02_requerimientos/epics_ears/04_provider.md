# Epic: Preferencias de Usuario y Tema de Color (04_provider)

**Directorio:** `lib\04_provider\`  
**Archivos:** `pagina_colores.dart`, `provider_preferencias.dart`  
**Fecha:** 2026-08-12  
**Fuente:** Ingeniería inversa

---

## Impact Mapping

| Objetivo de Negocio | Actor | Impacto | Entregable |
|---------------------|-------|---------|------------|
| Personalización visual M3 por usuario | Usuario final | Selecciona tema de color (9 opciones light + dark) y la app aplica `appTheme` global inmediato | Selector de 9 temas con Radio buttons + persistencia |
| | Sistema | Un solo `ColorScheme` global (`appTheme`) usado por **todos** los widgets M3 | `StateProvider<SelectColorProvider>` + `var_color_themes.dart` |

---

## User Story Mapping

```
Usuario abre Preferencias (/preferencias)
       │
       ▼
┌────────────────────────────────────┐
│ PaginaColores (ConsumerStateful)   │
│ - 9 RadioListTiles (temas)         │
│ - coloresProvider (StateProvider)  │
└──────────────┬─────────────────────┘
               │ Usuario selecciona
               ▼
┌────────────────────────────────────┐
│ coloresProvider.color = index      │
│ appTheme = temaSeleccionado[index] │
│ (reactivo: todos los widgets M3    │
│  reconstruyen con nuevo ColorScheme)│
└────────────────────────────────────┘
```

---

## Especificación SDD / EARS

**Prefijo IDs:** `REQ-PROV-XXX`

| ID | Tipo EARS | Requerimiento | Evidencia | Estado |
|----|-----------|---------------|-----------|--------|
| REQ-PROV-001 | **Ubicuo** | El sistema expondrá un `StateProvider<SelectColorProvider>` global (`coloresProvider`) con estado inicial `color=0` ("Rosa" / `lightPAN`). | `lib\04_provider\provider_preferencias.dart:10-15` | En código |
| REQ-PROV-002 | **Ubicuo** | El sistema definirá `SelectColorProvider` con campos `int color` (índice 0-8) y `String etiqueta` (nombre tema). | `provider_preferencias.dart:6-9` | En código |
| REQ-PROV-003 | **Evento** | Cuando el usuario seleccione un Radio button en `PaginaColores`, el sistema actualizará `coloresProvider.state.color` y asignará `appTheme = temaSeleccionado[nuevoIndex]`. | `lib\04_provider\pagina_colores.dart:35-55` | En código |
| REQ-PROV-004 | **Estado** | Mientras `appTheme` cambie, **todos** los widgets que lean `appTheme` (ColorScheme global en `var_color_themes.dart`) reconstruirán con nuevos colores M3. | `lib\20_var_globales\var_color_themes.dart:63` `appTheme = lightPAN` | En código |
| REQ-PROV-005 | **Ubicuo** | El sistema proveerá 9 temas predefinidos: `lightINE`, `lightMC`, `lightMOR`, `lightPAN`, `lightPRD`, `lightPRI`, `lightPT`, `lightPVEM`, `darkINE` (más `dark*` y `darkALL` en `var_color_themes.dart`). | `var_color_themes.dart:5-60` | En código |
| REQ-PROV-006 | **No Deseado** | Si `coloresProvider` no está inicializado (ProviderScope ausente), el sistema lanzará `ProviderNotFoundException` al acceder a `ref.watch(coloresProvider)`. | Riverpod behavior | Riesgo |
| REQ-PROV-007 | **Opcional** | Donde el usuario no haya seleccionado tema, el sistema usará `lightPAN` como default (hardcoded en `var_color_themes.dart` y `iniciaColor`). | `var_color_themes.dart:63`, `provider_preferencias.dart:14` | En código |

---

## Trazabilidad a Código

| Componente | Archivo | Líneas |
|------------|---------|--------|
| `SelectColorProvider` class | `provider_preferencias.dart` | 6-9 |
| `coloresProvider` (StateProvider) | `provider_preferencias.dart` | 11-15 |
| `iniciaColor` default | `provider_preferencias.dart` | 14 |
| `PaginaColores` widget | `pagina_colores.dart` | 1-80 |
| `build()` con 9 RadioListTiles | `pagina_colores.dart` | 35-55 |
| `appTheme` global (consumidor) | `var_color_themes.dart` | 63 |

---

## Notas

- **Persistencia**: No hay persistencia en disco del tema seleccionado (solo en memoria vía Riverpod). Al reiniciar app, vuelve a `lightPAN`.
- **M3 Compliance**: `appTheme` es **la única** fuente de color permitida (ver `ui_exceptions.dart` — excepción solo `loginPrimaryBrand`).
- **9 temas light + dark variants**: `var_color_themes.dart` define 18 `ColorScheme` const + `darkALL`.