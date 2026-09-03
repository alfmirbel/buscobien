# Epic: Widgets Globales Reutilizables M3 (60_global_widgets)

**Directorio:** `lib\60_global_widgets\`  
**Archivos:** `bottom_fijo.dart`, `debugprint.dart`, `derechos_reservados.dart`, `dialogbox_mensaje_general.dart`, `future_builder_state_widgets.dart`, `genera_cantidad_monetaria.dart`  
**Fecha:** 2026-08-12  
**Fuente:** Ingeniería inversa

---

## Impact Mapping

| Objetivo de Negocio | Actor | Impacto | Entregable |
|---------------------|-------|---------|------------|
| Consistencia visual M3 y productividad dev | Desarrollador | Reutiliza widgets base (botones, inputs, dialogs, estados FutureBuilder) sin repetir código | 6 widgets/utilidades globales tipadas |
| | Usuario final | Experiencia visual coherente (colores `appTheme`, Material Symbols) en toda la app | Widgets que consumen `appTheme` obligatoriamente |

---

## User Story Mapping

```
Desarrollador construye pantalla
       │
       ▼
┌─────────────────────────────────────────┐
│ Importa de lib\60_global_widgets\       │
│ - MyButton / MyTextField (forms)        │
│ - SquareTile (social login)             │
│ - showMessageDialog (alerts)            │
│ - stateWaiting/stateError/stateNone     │
│   (FutureBuilder states)                │
│ - generaCantidad (montos formateados)   │
│ - derechosReservadosClaro/Obscuro       │
└──────────────┬──────────────────────────┘
               │
               ▼
┌─────────────────────────────────────────┐
│ Widgets usan appTheme (ColorScheme)     │
│ No hay Colors.xxx hardcoded             │
│ Icons = Symbols.xxx (Material Symbols)  │
└─────────────────────────────────────────┘
```

---

## Especificación SDD / EARS

**Prefijo IDs:** `REQ-GW-XXX`

| ID | Tipo EARS | Requerimiento | Evidencia | Estado |
|----|-----------|---------------|-----------|--------|
| REQ-GW-001 | **Ubicuo** | El sistema proveerá `MyButton` (Stateless) como `TextButton` con `Container` 200x40, `Elevation 5`, color `appTheme.primary`, texto `appTheme.onPrimary`, fuente `Comfortaa`. | `lib\60_global_widgets\bottom_fijo.dart:10-35` | En código |
| REQ-GW-002 | **Ubicuo** | El sistema proveerá `MyTextField` (Stateless) con `OutlineInputBorder`, `prefixIcon` (Symbols), colores `appTheme.primary`/`onPrimary`, label `Comfortaa`. | `bottom_fijo.dart:37-70` | En código |
| REQ-GW-003 | **Ubicuo** | El sistema proveerá `SquareTile` (Stateless) para botones sociales: `Image.asset` en `Container` 60x60 con border `appTheme.outline`. | `bottom_fijo.dart:72-95` | En código |
| REQ-GW-004 | **Estado** | Mientras `MyTextFieldPassword` (Stateful) esté en foco, el sistema toggleará `obscureText` vía `IconButton` (Symbols.visibility / visibility_off) usando variables globales `isHidden*`. | `bottom_fijo.dart:97-160` | En código |
| REQ-GW-005 | **Ubicuo** | El sistema proveerá `debugPrintLevels(int level, String msg)` con 21 niveles booleanos (`level00`-`level20`) configurables para logging granular sin recompilar. | `lib\60_global_widgets\debugprint.dart:1-50` | En código |
| REQ-GW-006 | **Ubicuo** | El sistema proveerá `derechosReservadosClaro()` y `derechosReservadosObscuro()` retornando `Column` con copyright "© 2026 Buscobien®" tamaño 10, colores `appTheme.surface`/`onSurface`. | `lib\60_global_widgets\derechos_reservados.dart` | En código |
| REQ-GW-007 | **Evento** | Cuando se invoque `showMessageDialog(context, title, msg, color, align, btnText)`, el sistema mostrará `AlertDialog` personalizado (fondo `color`, título/msg con `appTheme`, botón `ElevatedButton` `btnText` que hace `Navigator.pop`). | `lib\60_global_widgets\dialogbox_mensaje_general.dart` | En código |
| REQ-GW-008 | **Estado** | Mientras un `FutureBuilder` esté en `ConnectionState.none/waiting/active/done(error)/done(data)`, el sistema proveerá widgets de estado estandarizados: `stateNone`, `stateWaiting` (CircularProgressIndicator), `stateActive`, `stateError`, `stateErrorFormat` — versiones normal y `FS` (FullScreen). | `lib\60_global_widgets\future_builder_state_widgets.dart` | En código |
| REQ-GW-009 | **Ubicuo** | El sistema proveerá `generaCantidad(String cantidad, int min, int max)` que genera monto aleatorio en rango y `formatoCantidad(int monto)` que formatea entero como "X,XXX,XXX" (millones,miles,cientos con padding "00"). | `lib\60_global_widgets\genera_cantidad_monetaria.dart` | En código |
| REQ-GW-010 | **No Deseado** | Si `MyTextFieldPassword` usa variables globales `isHidden*` mutables compartidas, el sistema **compartirá estado de visibilidad** entre múltiples instancias (bug de UX). | `bottom_fijo.dart:100-110` variables top-level | Deuda técnica |
| REQ-GW-011 | **Ubicuo** | El sistema **prohibirá** uso de `Colors.xxx` o `Color(0xFF...)` hardcoded en widgets globales — solo `appTheme` (ver `ui_exceptions.dart` para excepciones documentadas). | `lib\20_var_globales\ui_exceptions.dart` | En código |

---

## Trazabilidad a Código

| Componente | Archivo | Líneas |
|------------|---------|--------|
| `MyButton` / `MyTextField` / `SquareTile` | `bottom_fijo.dart` | 10-95 |
| `MyTextFieldPassword` (globals `isHidden*`) | `bottom_fijo.dart` | 97-160 |
| `debugPrintLevels` + 21 level flags | `debugprint.dart` | 1-50 |
| `derechosReservadosClaro/Obscuro` | `derechos_reservados.dart` | 1-20 |
| `showMessageDialog` | `dialogbox_mensaje_general.dart` | 1-40 |
| `state*` FutureBuilder helpers (8 funcs) | `future_builder_state_widgets.dart` | 1-100 |
| `generaCantidad` / `formatoCantidad` | `genera_cantidad_monetaria.dart` | 1-40 |

---

## Deuda Técnica

1. **`MyTextFieldPassword` variables globales**: `isHidden`, `isHiddenCampoUser`, `isHiddenValidaClave`, `isHiddenClaveUser` son top-level mutables → **estado compartido entre instancias**. Deben moverse a `State` del widget.
2. **`debugprint.dart` 21 booleanos**: Configuración manual propensa a errores; considerar `Logger` package o `log` con niveles.
3. **`generaCantidad` aleatorio**: Usa `Random()` sin seed — no determinístico para tests.