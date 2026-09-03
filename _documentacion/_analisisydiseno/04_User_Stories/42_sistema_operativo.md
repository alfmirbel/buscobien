# User Stories — Detección de Plataforma OS (42_sistema_operativo)

**Directorio:** `lib\42_sistema_operativo\` (1 archivo `.dart`)
**Epic asociado:** [`02_Epics_EARS/42_sistema_operativo.md`](../02_Epics_EARS/42_sistema_operativo.md)
**Feature BDD:** [`03_Features_BDD/42_sistema_operativo/deteccion_plataforma.feature`](../03_Features_BDD/42_sistema_operativo/deteccion_plataforma.feature)
**Inventario:** [`05_Tareas_Inventarios/42_sistema_operativo/elementos_42_sistema_operativo.md`](../05_Tareas_Inventarios/42_sistema_operativo/elementos_42_sistema_operativo.md)
**Fecha:** 2026-08-12
**Fuente:** Ingeniería inversa

> **Nota de corrección:** este archivo fue reescrito el 2026-08-12. Anteriormente estaba contaminado dentro del consolidado `03_listas.md`. Este archivo documenta únicamente `42_sistema_operativo`.

---

## US-OS-001: Detectar plataforma en runtime para elegir estrategia

### Card
**Como** sistema operativo interno
**Quiero** detectar la plataforma en runtime (`kIsWeb`, `defaultTargetPlatform`) y exponer vía Riverpod el resultado
**Para** elegir estrategia de storage (secure vs shared prefs), compresión (nativa vs web) y presentación de la UI.

### Conversation
- `detecta_os.dart` (283 líneas) expone:
  - `ElementoPlataforma` dataclass con `index`, `etiqueta`, `icono`, `buttonSelectOpcion` (lista de 7 bools), `nombrePlataforma`.
  - `listaNombrePlataforma`: ["android", "fuchsia", "iOS", "linux", "macOS", "windows", "Web u otro"].
  - `plataformasCompressWeb`: plataformas para las que `flutter_image_compress` NO está disponible → cae a `bytes` sin compresión (Web, Android, fuchsia, iOS).
  - `plataformasCompressWin`: ["linux", "macOS", "windows"].
  - `checaPlataformaProvider` (`StateProvider<ElementoPlataforma>`) con estado inicial `Sin verificar conexión`.
  - `setCheckPlataformaProvider(ref)` — función que evalúa en runtime:
    - `kIsWeb == true` → `nombrePlataforma = "web"`, activa `buttonSelectOpcion[6]`, sigue rutas Web (compresión vía `bytes`, storage `shared_preferences`).
    - `defaultTargetPlatform == TargetPlatform.android` → `nombrePlataforma = "android"`, activa `buttonSelectOpcion[0]`, secure storage.
    - `defaultTargetPlatform == TargetPlatform.iOS` → `nombrePlataforma = "iOS"`, activa `buttonSelectOpcion[2]`, secure storage.
    - `defaultTargetPlatform == TargetPlatform.windows` → `nombrePlataforma = "windows"`, shared prefs.
  - `PaginaDetectaPlataforma` (StatefulWidget) — vista de diagnóstico que muestra el status de la verificación.

### Conversation — dependencias y casos de uso
- Caso de uso **compresión imágenes (`22_imagenes/funciones_compress_image.dart`)**: si `nombrePlataforma` está en `plataformasCompressWeb`, usa `bytes` sin `flutter_image_compress`; si está en `plataformasCompressWin`, usa compresión nativa.
- Caso de uso **storage JWT (`10_user_login/usuario_login/session_storage.dart`)**: móvil → `flutter_secure_storage`; Web/Windows → `shared_preferences`.
- Caso de uso **deep links / file system**: Web usa url_launcher; móvil usa `open_filex` y file paths reales.
- **Comentario crítico de implementación:** usa `defaultTargetPlatform` (síncrono, no requiere `Platform.isAndroid` del `dart:io`). En WASM, `dart:io` falla — `defaultTargetPlatform` es safe porque está en `flutter/foundation.dart`. Es la estrategia correcta para Web/WASM.

### Confirmation
- ✓ En Web/WASM, `kIsWeb == true` → `nombrePlataforma = "web"`, `buttonSelectOpcion[6]` = true.
- ✓ En Android, `nombrePlataforma = "android"`, `buttonSelectOpcion[0]` = true.
- ✓ En iOS, `nombrePlataforma = "iOS"`, `buttonSelectOpcion[2]` = true.
- ✓ En Windows, `nombrePlataforma = "windows"`, `buttonSelectOpcion[5]` = true.
- ✓ `checaPlataformaProvider` expone reactivamente el dato para que otros módulos (`22_imagenes`, `10_user_login`) lo lean vía `ref.watch`.
- ✓ Feature BDD: `deteccion_plataforma.feature` escenarios.

**Trazabilidad:** `REQ-OS-001` ~ `02_Epics_EARS/42_sistema_operativo.md` · Archivos: `detecta_os.dart`

---

## Resumen matriz

| US | Escenarios BDD | Archivos principales |
|----|----------------|----------------------|
| US-OS-001 (detección runtime) | 4 plataformas + web | `detecta_os.dart` |

---

## Notas de deuda técnica

1. **`setCheckPlataformaProvider(ref)` muta el estado del `StateProvider` directamente vía `ref.read`**: debería ser un método del Notifier / nuevo provider. Patrón mutación-flush anti-Riverpod 3.x.
2. **Listas `plataformasCompress*` como top-level mutables**: riesgos si alguien hace `.add()` accidentalmente.
3. **`buttonSelectOpcion` como `List<bool>` mutable** en dataclass: usar `Map<String, bool>` con claves nombradas, o una dataclass `EstadoPlataforma` con campos bool separados.
4. **`PaginaDetectaPlataforma` incluida en el mismo archivo** que los providers — extraer a widget separado sigue siendo deuda (el archivo tiene 283 líneas con modelo + provider + UI).
5. **`initialTiposElementaPlataforma` tiene un typo** en el nombre (faltaba `o`) — corregido en código a `initialTiposElementoPlataforma` pero documentar la deuda.
6. **Sin tests** de la detección por plataforma.
