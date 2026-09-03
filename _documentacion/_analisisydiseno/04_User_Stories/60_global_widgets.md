# User Stories — Widgets Globales Reutilizables M3 (60_global_widgets)

**Directorio:** `lib\60_global_widgets\` (6 archivos `.dart`)
**Epic asociado:** [`02_Epics_EARS/60_global_widgets.md`](../02_Epics_EARS/60_global_widgets.md)
**Feature BDD:** [`03_Features_BDD/60_global_widgets/widgets_globales_m3.feature`](../03_Features_BDD/60_global_widgets/widgets_globales_m3.feature)
**Inventario:** [`05_Tareas_Inventarios/60_global_widgets/elementos_60_global_widgets.md`](../05_Tareas_Inventarios/60_global_widgets/elementos_60_global_widgets.md)
**Fecha:** 2026-08-12
**Fuente:** Ingeniería inversa

> **Nota de corrección:** este archivo fue reescrito el 2026-08-12. Anteriormente estaba contaminado dentro del consolidado `03_listas.md`. Este archivo documenta únicamente `60_global_widgets`.

---

## US-GW-001: Componentes base M3 para formularios y botones

### Card
**Como** desarrollador
**Quiero** widgets base reutilizables (botón, text fields, social tile) ya estilizados con `appTheme`
**Para** construir pantallas rápidamente sin repetir código de UI.

### Conversation
- `MyButton` (`bottom_fijo.dart`, StatelessWidget): `TextButton` envuelto en `Container` 200x40 con `Elevation 5`, color `appTheme.primary`, texto `appTheme.onPrimary`, fuente `Comfortaa`. Resultado: botón estilizado M3 sin que el desarrollador toque nada.
- `MyTextField` (Stateless): `OutlineInputBorder` con `appTheme.primary`, `prefixIcon` (Material Symbols pasado por parámetro), label `Comfortaa`. Cualquier formulario (login, registro, edición) lo reutiliza.
- `MyTextFieldPassword` (Stateful): como MyTextField + `IconButton` (toggle `obscureText`) que intercambia `Symbols.visibility` ↔ `Symbols.visibility_off`. Usa variables **globales top-level** `isHidden*` para guardar estado (ver US-GW-004 — deuda).
- `SquareTile` (Stateless): `Image.asset` en `Container` 60x60 con border `appTheme.outline`. Usado para botones de login social (Google, Apple, etc).
- **Regla de oro:**ningún widget global usa `Colors.xxx` directo — todo vía `appTheme` (ColorScheme global). Excepción documentada: `loginPrimaryBrand` en `var_login.dart`.

### Confirmation
- ✓ `MyButton("Guardar")` produce un TextButton 200x40 color primary + texto onPrimary.
- ✓ `MyTextField(label, icon)` renderiza con OutlineInputBorder y prefixIcon.
- ✓ `MyTextFieldPassword` permite alternar visibilidad con el IconButton (vigila `isHidden`).
- ✓ `SquareTile(imagePath, onTap)` renderiza una tile social 60x60.
- ✓ Feature BDD: `widgets_globales_m3.feature` escenarios de cada widget.

**Trazabilidad:** `REQ-GW-001`, `REQ-GW-002`, `REQ-GW-003`, `REQ-GW-011` · Archivos: `bottom_fijo.dart`

---

## US-GW-002: Estado estandarizado de FutureBuilder (carga / error / vacío / activo)

### Card
**Como** desarrollador
**Quiero** helpers de estado para FutureBuilder (`stateWaiting`, `stateError`, `stateNone`, etc.) que respeten M3
**Para** no reimplementar spinners y mensajes de error en cada pantalla.

### Conversation
- `future_builder_state_widgets.dart` (147 líneas) expone **8 funciones** retornando `Widget`:
  - `stateNone()` / `stateNoneFS()`: mensaje "Sin resultados" + ícono `Symbols.search_off` con `appTheme.onSurfaceVariant`.
  - `stateWaiting()` / `stateWaitingFS()`: `CircularProgressIndicator` con `appTheme.colorScheme.primary`, centrado.
  - `stateActive()` / `stateActiveFS()`: Spinner + texto "Cargando..." para `ConnectionState.active`.
  - `stateError(error)` / `stateErrorFS(error)`: mensaje de error con `Symbols.error` + botón reintentar + texto de `error.toString()`.
  - `stateErrorFormatFS(error)`: variante de error formateada (multiline, etc).
- Versión **FS (FullScreen)**: ocupa toda la pantalla con `Center` + `Column`; la normal se incrusta dentro de un ListView/Column ya existente.
- Consumidores típicos: `PaginaCarouselFotosUsuario`, `PageDetalleLista`, `PageMisListas`, etc — revisan `snapshot.connectionState` en el `FutureBuilder.builder` y retornan el helper apropiado.
- **Comentario de deuda:** las 8 funciones no son configurables (no aceptan callback `onRetry` personalizado) — `stateError` usa `onRetry: () => ref.refresh(provider)` hardcodeado en algunos casos. Debería exponer `onRetry: VoidCallback`.

### Confirmation
- ✓ Al pasar `ConnectionState.waiting` retorna un spinner M3 (CircularProgressIndicator centrado).
- ✓ Al pasar `ConnectionState.done` con error, muestra ícono + texto + botón Reintentar.
- ✓ Lista vacía retorna "Sin resultados" con ícono search_off.
- ✓ Versiones FS ocupan toda la pantalla en lugar de incrustarse.
- ✓ Feature BDD: `widgets_globales_m3.feature`.

**Trazabilidad:** `REQ-GW-008` · Archivos: `future_builder_state_widgets.dart`

---

## US-GW-003: Logging granular con 21 niveles controlable sin recompilar

### Card
**Como** desarrollador en producción depurando un incidente
**Quiero** un sistema de logging con 21 niveles booleanos controlables desde un único archivo
**Para** filtrar el ruido sin tener que recompilar para activar/desactivar logs.

### Conversation
- `debugprint.dart` (140 líneas) expone `debugPrintLevels(int level, String mensaje)` que imprime `mensaje` sólo si `levelNN = true` (variable top-level para ese nivel).
- **21 niveles** (`level00` a `level20`), cada uno un booleano top-level. Convención informal documentada en las US:
  - `level01` = lifecycle (initState/didChangeDependencies)
  - `level09` = FutureBuilder state changes
  - `level10` = provider state (Riverpod builds)
  - `level20` = diagnóstico avanzado / resultados completos de DB
- Contador `lcwc` acumula el total de prints y aparece en cada línea — útil para contar llamadas en una sesión.
- López en debug quickly: cambiar `level09 = false` silencia toda la verbosidad de FutureBuilder sin tocar nada más.
- **Comentario crítico de deuda:** las 21 variables son top-level mutables, **no config-driven** (no se pueden cambiar runtime con un botón). El desarrollador debe recompilar siempre — contradice parcialmente el Espíritu de "sin recompilar". Alternativa: usar `package:logging` o `dart:developer` con jerarquía.

### Confirmation
- ✓ `debugPrintLevels(10, "Mensaje")` imprime sólo si `level10 = true`.
- ✓ Cambiar `level10 = false` en el archivo silencia todos los logs de nivel 10.
- ✓ El contador `lcwc` se incrementa en cada print y se incluye en la salida.
- ✓ Feature BDD: escenario "Logging granular".

**Trazabilidad:** `REQ-GW-005` · Archivos: `debugprint.dart`

---

## US-GW-004: Mostrar diálogo modal con `showMessageDialog` estilizado M3

### Card
**Como** desarrollador
**Quiero** una función helper que muestre un `AlertDialog` con fondo color, título/mensaje y botón customizable
**Para** estandarizar los avisos modales de la app sin repetir `showDialog` en cada pantalla.

### Conversation
- `dialogbox_mensaje_general.dart` (75 líneas) expone `showMessageDialog(context, title, msg, color, align, btnText)` que invoca `showDialog` con `AlertDialog`:
  - `backgroundColor: color` (pasado por parámetro — rompe parcialmente la regla `appTheme` pero está pensado para usarse con `appTheme.primary`, `appTheme.error`, etc).
  - Título y mensaje con `TextStyle` `Comfortaa`, alineación `align` (`TextAlign.center` por defecto).
  - Único botón `ElevatedButton(btnText)` que ejecuta `Navigator.pop(context)`.
- Usado para éxitos/errores generic (ej. "Propiedad guardada", "Error de red") en validaciones de formularios y resultados de PUT/POST.
- **Comentario:** la firma es larga (6 params), algunos son optativos default. Refactor: usar un `ShowMessageConfig` dataclass con defaults.

### Confirmation
- ✓ Al invocar `showMessageDialog(ctx, "Ok", "Guardado", appTheme.primary, ...)`, aparece un modal con fondo del color primario y botón cerrar.
- ✓ El tap del botón cierra el modal.
- ✓ Alineación y texto del botón son configurables.

**Trazabilidad:** `REQ-GW-007` · Archivos: `dialogbox_mensaje_general.dart`

---

## US-GW-005: Footer de derechos reservados en toda la app

### Card
**Como** propietario de Buscobien
**Quiero** un widget consistente "© 2026 Buscobien®" insertable en el pie de cada pantalla
**Para** cumplir con la atribución de marca en todas las vistas.

### Conversation
- `derechos_reservados.dart` (29 líneas) expone 2 funciones:
  - `derechosReservadosClaro()` → `Column` con texto "© 2026 Buscobien®" tamaño 10, color `appTheme.surface` (texto claro sobre fondo oscuro).
  - `derechosReservadosObscuro()` → idem con color `appTheme.onSurface` (texto oscuro sobre fondo claro).
- Se consumen en el pie de las 9 landings (`03_vistas/pagina_*.dart`) y en pantallas principales (`02_principal_screen`).
- El año "2026" será hardcoded — debería derivarse `DateTime.now().year` (deuda).

### Confirmation
- ✓ Insertar `derechosReservadosObscuro()` al final de un scaffold produce el footer con copyright tamaño 10.
- ✓ En landings con fondo claro se ve con color obscuro (onSurface).
- ✓ En landings con fondo oscuro se usa la versión clara (surface).

**Trazabilidad:** `REQ-GW-006` · Archivos: `derechos_reservados.dart`

---

## US-GW-006: Generar y formatear montos de demostración

### Card
**Como** desarrollador trabajando en el catálogo de demostración
**Quiero** una utilidad que genere montos aleatorios en un rango y los formatee con separadores de miles
**Para** mostrar precios realistas en propiedades sin tener datos reales.

### Conversation
- `genera_cantidad_monetaria.dart` (174 líneas):
  - `generaCantidad(String cantidad, int minimo, int maximo)` → monto aleatorio entre min y max. Devuelve cadena con separadores de miles.
  - `formatoCantidad(int monto)` → convierte entero a "X,XXX,XXX" (millones, miles, cientos) con `padLeft` "00" para mantener longitud consistente.
- Se usa en los textos de precio de propiedades de demostración (mock data) cuando no hay conexión a la API.
- **Comentario crítico:** usa `Random()` sin seed — no determinístico, **no testeable** sin `Random(seed)`. Deuda: exposición de `Random` por parámetro o usar `Random.secure()` si los montos afectan ordenamiento.

### Confirmation
- ✓ `generaCantidad("", 100000, 500000)` retorna una cadena entre 100K-500K con separadores de miles.
- ✓ `formatoCantidad(1500000)` retorna "1,500,000".
- ✓ `formatoCantidad(42)` retorna "42" o "0,042" con padding según impl.

**Trazabilidad:** `REQ-GW-009` · Archivos: `genera_cantidad_monetaria.dart`

---

## US-GW-007: Deuda de estado compartido en `MyTextFieldPassword` (no deseado)

### Card
**Como** arquitecto del sistema
**Quiero** documentar que `MyTextFieldPassword` comparte estado de visibilidad entre instancias vía variables globales
**Para** que el equipo sepa que es una deuda crítica de UX y planificar el fix.

### Conversation
- Las variables `isHidden`, `isHiddenCampoUser`, `isHiddenValidaClave`, `isHiddenClaveUser` son **top-level mutables** (`bottom_fijo.dart:100-110`).
- Si se instancian 2 `MyTextFieldPassword` en la misma pantalla (ej. login con contraseña + confirmar contraseña), el toggle de uno afecta al otro porque comparten la misma variable global.
- **Fix propuesto:** convertir `isHidden*` a `bool _isHidden = true` dentro del `State<MyTextFieldPassword>` para que cada instancia tenga su propio estado. Migración trivial (~5 líneas).

### Confirmation
- ✓ Se documenta como "no deseado" en EARS (`REQ-GW-010`).
- ✓ Migración planificada en backlog.
- ✓ En la práctica, los formularios actuales sólo usan un `MyTextFieldPassword` por pantalla — el bug no se manifiesta UX, pero está latente.

**Trazabilidad:** `REQ-GW-010` · Archivos: `bottom_fijo.dart` (Scope: variables top-level)

---

## Resumen matriz

| US | Epic Req | Escenarios BDD | Archivos principales |
|----|----------|----------------|----------------------|
| US-GW-001 (form widgets base) | REQ-GW-001, 002, 003, 011 | varios | `bottom_fijo.dart` |
| US-GW-002 (FutureBuilder states) | REQ-GW-008 | loader/error/empty | `future_builder_state_widgets.dart` |
| US-GW-003 (logging 21 niveles) | REQ-GW-005 | 1 | `debugprint.dart` |
| US-GW-004 (showMessageDialog) | REQ-GW-007 | 1 | `dialogbox_mensaje_general.dart` |
| US-GW-005 (footer derechos) | REQ-GW-006 | 1 | `derechos_reservados.dart` |
| US-GW-006 (montos demo) | REQ-GW-009 | 1 | `genera_cantidad_monetaria.dart` |
| US-GW-007 (deuda isHidden*) | REQ-GW-010 | — | `bottom_fijo.dart` |

---

## Notas de deuda técnica

1. **Variables globales `isHidden*`** en `MyTextFieldPassword`: afectan múltiples instancias. Fix trivial: mover a `State`.
2. **21 booleanos de `debugprint.dart`**: no config-drive; requieren recompilar. Migrar a `package:logging` jerárquico.
3. **`generaCantidad` no determinístico**: sin `Random.seed` → no testeable.
4. **`showMessageDialog` firma larga (6 params)**: refactor a `config` dataclass.
5. **`derechosReservados` año "2026" hardcoded**: debería derivarse `DateTime.now().year`.
6. **`stateError` callback `onRetry` no expuesto**: hardcodeado en consumidores. Deuda de API.
7. **Sin tests** para ninguno de los 6 archivos/8 widgets globales.
