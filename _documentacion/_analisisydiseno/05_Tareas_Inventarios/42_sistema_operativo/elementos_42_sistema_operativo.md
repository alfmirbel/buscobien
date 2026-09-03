# Inventario de Elementos — Detección de Plataforma OS (42_sistema_operativo)

**Directorio:** `lib\42_sistema_operativo\`
**Total archivos `.dart` fuente:** 1
**Epic asociado:** [`02_Epics_EARS/42_sistema_operativo.md`](../../02_Epics_EARS/42_sistema_operativo.md)
**Features BDD:** [`03_Features_BDD/42_sistema_operativo/deteccion_plataforma.feature`](../../03_Features_BDD/42_sistema_operativo/deteccion_plataforma.feature)
**User Stories:** [`04_User_Stories/42_sistema_operativo.md`](../../04_User_Stories/42_sistema_operativo.md) (1 US)
**Fecha:** 2026-08-12
**Fuente:** Ingeniería inversa

> **Nota de corrección:** este archivo fue reescrito el 2026-08-12. Anteriormente estaba contaminado con contenido de `04_provider`. Este archivo documenta únicamente `42_sistema_operativo`.

---

## Tabla 1 — Resumen de componentes por rol funcional

| # | Componente | Archivo | Tipo | Rol funcional | US-OS |
|---|-------------|---------|------|----------------|-------|
| 1 | `ElementoPlataforma` (dataclass) | `detecta_os.dart` | Modelo | Estado + flags de plataforma detectada | US-OS-001 |
| 2 | `listaNombrePlataforma` (const) | `detecta_os.dart` | `List<String>` | 7 nombres canónicos de plataforma | US-OS-001 |
| 3 | `plataformasCompressWeb` (const) | `detecta_os.dart` | `List<String>` | Plataformas donde `flutter_image_compress` falla → fallback bytes | US-OS-001 |
| 4 | `plataformasCompressWin` (const) | `detecta_os.dart` | `List<String>` | Plataformas dónde compresión nativa funciona (windows/linux/mac) | US-OS-001 |
| 5 | `checaPlataformaProvider` | `detecta_os.dart` | `StateProvider<ElementoPlataforma>` | Expone el estado reactivo a la app | US-OS-001 |
| 6 | `initialTiposElementoPlataforma` | `detecta_os.dart` | `ElementoPlataforma` | Estado inicial `Sin verificar conexión` | US-OS-001 |
| 7 | `setCheckPlataformaProvider(ref)` | `detecta_os.dart` | Función | Evalúa `kIsWeb` + `defaultTargetPlatform` y muta el provider | US-OS-001 |
| 8 | `PaginaDetectaPlataforma` | `detecta_os.dart` | StatelessWidget | UI de diagnóstico de plataforma | US-OS-001 |

---

## Tabla 2 — Detalle por archivo

| # | Archivo | Símbolos | Líneas | Dependencias | Estado | Comentario / Deuda |
|---|---------|----------|--------|---------------|--------|--------------------|
| 1 | `detecta_os.dart` | `ElementoPlataforma`, `listaNombrePlataforma`, `plataformasCompressWeb`, `plataformasCompressWin`, `checaPlataformaProvider`, `initialTiposElementoPlataforma`, `setCheckPlataformaProvider`, `PaginaDetectaPlataforma`, (+ `elementosPlataforma` referenciado) | 283 | `flutter_riverpod`, `riverpod/legacy.dart`, `flutter/foundation.dart` (`kIsWeb`, `defaultTargetPlatform`), `Symbols`, `app_routes`, `var_color_themes`, `var_elementos_menus` | ⚠ deuda | **1 archivo, 4 roles** (modelo + provider + función mutadora + UI). Refactor pendiente: split en `models/elemento_plataforma.dart`, `providers/detecta_platform_provider.dart`, `pages/pagina_detecta_plataforma.dart`. Usa `defaultTargetPlatform` (foundation) — correcto para WASM donde `dart:io` falla |

---

## Notas críticas

- **1 archivo, 4 roles** (283 líneas): modelo + 3 const + provider + función setCheck + UI. Refactor para mantenibilidad.
- **`setCheckPlataformaProvider(ref)` muta `ref.read()` directamente**: patrón anti-Riverpod 3.x. Debería ser un método del Notifier, no función externa que muta el state vía `ref.read`.
- **`buttonSelectOpcion` como `List<bool>` mutable** (7 elementos en dataclass): propenso a errores por índice. Refactor: cambiar a campos bool nominados (`bool android`, `bool ios`, etc.) o `Map<String, bool>`.
- **`listaNombrePlataforma`, `plataformasCompressWeb/Win` top-level**: no son `const` — deberían serlo para claridad y performance.
- **`initialTiposElementoPlataforma`**: typo histórico (`Tipos` vs `Tipo` singular), nominalmente corregido — historial de deuda.
- **`PaginaDetectaPlataforma` en el mismo archivo que providers**: alt coupling. Extraer.
- **`legacy.dart` importado**: `StateProvider` está deprecado en Riverpod 3.x. Migrar a `Notifier` con `@riverpod` annotation.
- **Sin tests** de `setCheckPlataformaProvider` — difícil por dependencia de `defaultTargetPlatform` que es const en runtime, pero se puede mock con `debugDefaultTargetPlatformOverride`.
