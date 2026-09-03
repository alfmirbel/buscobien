# Epic: Detección de Sistema Operativo y Plataforma (42_sistema_operativo)

**Directorio:** `lib\42_sistema_operativo\`  
**Archivo:** `detecta_os.dart`  
**Fecha:** 2026-08-12  
**Fuente:** Ingeniería inversa

---

## Impact Mapping

| Objetivo de Negocio | Actor | Impacto | Entregable |
|---------------------|-------|---------|------------|
| Experiencia nativa adaptativa (Web/WASM, Windows, Android, iOS, Linux, macOS, Fuchsia) | Usuario final | UI y capacidades adaptadas a su plataforma (compresión imágenes, navegación, almacenamiento) | Detección automática `kIsWeb` + `defaultTargetPlatform` |
| | Desarrollador | Lógica condicional por plataforma sin `if (kIsWeb)` disperso | Provider `checaPlataformaProvider` + `ElementoPlataforma` model |

---

## User Story Mapping

```
App inicia / Usuario navega a "Detectar Plataforma"
       │
       ▼
┌─────────────────────────────────────────┐
│ setCheckPlataformaProvider(ref)         │
│ - kIsWeb → ElementoPlataforma("Web")    │
│ - defaultTargetPlatform switch:         │
│   android, fuchsia, iOS, linux,         │
│   macOS, windows → etiqueta + icono     │
└──────────────┬──────────────────────────┘
               │
               ▼
┌─────────────────────────────────────────┐
│ checaPlataformaProvider (StateProvider) │
│ - Estado: ElementoPlataforma            │
│   (nombrePlataforma, index, icono,      │
│    buttonSelectOpcion[7])               │
└──────────────┬──────────────────────────┘
               │
    ┌──────────┼──────────┐
    ▼          ▼          ▼
 Compresión  Almacenam.  Navegación
 imágenes    JWT         (back button)
 Web/Win:    Mobile:     Platform-
 specífica  secure_storage adaptativa
```

---

## Especificación SDD / EARS

**Prefijo IDs:** `REQ-OS-XXX`

| ID | Tipo EARS | Requerimiento | Evidencia | Estado |
|----|-----------|---------------|-----------|--------|
| REQ-OS-001 | **Ubicuo** | El sistema definirá `ElementoPlataforma` con: `index`, `etiqueta`, `icono`, `List<bool> buttonSelectOpcion[7]`, `nombrePlataforma` (String: "android", "ios", "windows", "web", "linux", "macos", "fuchsia"). | `lib\42_sistema_operativo\detecta_os.dart:6-15` | En código |
| REQ-OS-002 | **Ubicuo** | El sistema expondrá `checaPlataformaProvider` (StateProvider<ElementoPlataforma>) con estado inicial `initialTiposElementoPlataforma` (etiqueta "Desconocido"). | `detecta_os.dart:45-50` | En código |
| REQ-OS-003 | **Evento** | Cuando se invoque `setCheckPlataformaProvider(ref)`, el sistema evaluará `kIsWeb` → si true, setea "Web"; si false, usa `defaultTargetPlatform` (switch: android/fuchsia/ios/linux/macos/windows) y actualiza provider. | `detecta_os.dart:52-80` | En código |
| REQ-OS-004 | **Estado** | Mientras `checaPlataformaProvider.nombrePlataforma == "web"`, el sistema usará lógica de compresión Web (`plataformasCompressWeb`) y `shared_preferences` para JWT. | `detecta_os.dart:35-38`, `lib\10_user_login\usuario_login\session_storage.dart` | En código |
| REQ-OS-005 | **Estado** | Mientras `checaPlataformaProvider.nombrePlataforma == "windows"`, el sistema usará lógica de compresión Windows (`plataformasCompressWin`). | `detecta_os.dart:40-42` | En código |
| REQ-OS-006 | **Estado** | Mientras `checaPlataformaProvider.nombrePlataforma` sea móvil (android/ios), el sistema usará `flutter_secure_storage` para JWT. | `session_storage.dart` (referenciado) | En código |
| REQ-OS-007 | **Ubicuo** | El sistema proveerá listas de plataformas con compresión específica: `plataformasCompressWeb` (["web"]) y `plataformasCompressWin` (["windows"]). | `detecta_os.dart:35-42` | En código |
| REQ-OS-008 | **No Deseado** | Si `defaultTargetPlatform` retorna valor no cubierto en switch (futura plataforma), el sistema mantendrá `nombrePlataforma = "Desconocido"` y `index = -1`. | `detecta_os.dart:65-75` default case | Parcial |
| REQ-OS-009 | **Opcional** | Donde exista UI de diagnóstico (`PaginaDetectaPlataforma`), el sistema mostrará lista con etiqueta/icono por plataforma y botón volver a `/principal`. | `detecta_os.dart:82-130` | En código |

---

## Trazabilidad a Código

| Componente | Archivo | Líneas |
|------------|---------|--------|
| `ElementoPlataforma` class | `detecta_os.dart` | 6-15 |
| `initialTiposElementoPlataforma` | `detecta_os.dart` | 17-25 |
| `checaPlataformaProvider` | `detecta_os.dart` | 45-50 |
| `setCheckPlataformaProvider(ref)` | `detecta_os.dart` | 52-80 |
| `plataformasCompressWeb` / `CompressWin` | `detecta_os.dart` | 35-42 |
| `PaginaDetectaPlataforma` widget | `detecta_os.dart` | 82-130 |
| `listaNombrePlataforma` (7 items) | `detecta_os.dart` | 27-33 |

---

## Notas

- **Integración crítica**: `session_storage.dart` (login) usa esta detección para elegir `flutter_secure_storage` (mobile) vs `shared_preferences` (web/desktop).
- **Compresión imágenes**: `lib\22_imagenes\tus_espacios_fotos_propiedad\manejo_de_fotos\fotos_de_la_propiedad\pagina_agrega_multiples_fotos.dart` consume `plataformasCompressWeb/Win`.
- **Material Symbols**: Usa `material_symbols_icons` (ej: `Symbols.computer`, `Symbols.phone_android`).