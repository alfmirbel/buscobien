# SDD — Módulo 42_sistema_operativo (BuscoBien)
## Especificación de Requerimientos (EARS)
**Directorio fuente:** `lib/42_sistema_operativo`  
**Arquitectura:** Flutter + Riverpod + Foundation  
**Propósito:** Detección de sistema operativo y plataforma de ejecución, clasificación de plataformas para compresión de imágenes y pantalla informativa de sistema operativo

---

## 1. Requerimientos Ubicuos

### 1.1 Detección de Plataforma
- **REQ-OS-001:** El sistema deberá detectar la plataforma de ejecución de la aplicación.
- **REQ-OS-002:** El sistema deberá soportar detección de: Android, Fuchsia, iOS, Linux, macOS, Windows y Web.
- **REQ-OS-003:** El sistema deberá mantener un estado reactivo de la plataforma mediante Riverpod `StateProvider`.

### 1.2 Elementos de Estado de Plataforma
- **REQ-OS-004:** El sistema deberá mantener un índice de plataforma (0-6) para identificar la plataforma activa.
- **REQ-OS-005:** El sistema deberá mantener una etiqueta descriptiva de la plataforma ("android", "iOS", etc.).
- **REQ-OS-006:** El sistema deberá mantener un icono (`Symbols.android`, `Symbols.ios`, etc.) según la plataforma.
- **REQ-OS-007:** El sistema deberá mantener una lista de booleanos `buttonSelectOpcion` de 7 elementos para cada tipo de plataforma.
- **REQ-OS-008:** El sistema deberá mantener un nombre de plataforma legible ("Sin verificar conexión", "android", etc.).

### 1.3 Clasificación de Plataformas para Compresión
- **REQ-OS-009:** El sistema deberá clasificar Android, Fuchsia, iOS y Web como plataformas de compresión Web.
- **REQ-OS-010:** El sistema deberá clasificar Linux, macOS y Windows como plataformas de compresión Windows.

---

## 2. Requerimientos Controlados por Eventos

### 2.1 Inicialización de Detección
- **REQ-INIT-001:** Cuando el sistema ejecuta `setCheckPlataformaProvider`, el sistema deberá resetear todos los valores de `buttonSelectOpcion` a `false`.
- **REQ-INIT-002:** Cuando el sistema resetea el estado, el sistema deberá establecer el índice a 0.
- **REQ-INIT-003:** Cuando el sistema resetea el estado, el sistema deberá establecer la etiqueta al primer elemento de `elementosPlataforma`.

### 2.2 Detección de Web
- **REQ-DET-001:** Cuando `kIsWeb` es verdadero, el sistema deberá establecer `buttonSelectOpcion[6] = true`.
- **REQ-DET-002:** Cuando `kIsWeb` es verdadero, el sistema deberá establecer `nombrePlataforma = "Web u otro"`.
- **REQ-DET-003:** Cuando `kIsWeb` es verdadero, el sistema deberá establecer `index = 6`.

### 2.3 Detección de Android
- **REQ-DET-004:** Cuando `defaultTargetPlatform` es `TargetPlatform.android`, el sistema deberá establecer `buttonSelectOpcion[0] = true`.
- **REQ-DET-005:** Cuando `defaultTargetPlatform` es `TargetPlatform.android`, el sistema deberá establecer `nombrePlataforma = "android"`.
- **REQ-DET-006:** Cuando `defaultTargetPlatform` es `TargetPlatform.android`, el sistema deberá establecer `index = 0`.

### 2.4 Detección de Fuchsia
- **REQ-DET-007:** Cuando `defaultTargetPlatform` es `TargetPlatform.fuchsia`, el sistema deberá establecer `buttonSelectOpcion[1] = true`.
- **REQ-DET-008:** Cuando `defaultTargetPlatform` es `TargetPlatform.fuchsia`, el sistema deberá establecer `nombrePlataforma = "fuchsia"`.
- **REQ-DET-009:** Cuando `defaultTargetPlatform` es `TargetPlatform.fuchsia`, el sistema deberá establecer `index = 1`.

### 2.5 Detección de iOS
- **REQ-DET-010:** Cuando `defaultTargetPlatform` es `TargetPlatform.iOS`, el sistema deberá establecer `buttonSelectOpcion[2] = true`.
- **REQ-DET-011:** Cuando `defaultTargetPlatform` es `TargetPlatform.iOS`, el sistema deberá establecer `nombrePlataforma = "iOS"`.
- **REQ-DET-012:** Cuando `defaultTargetPlatform` es `TargetPlatform.iOS`, el sistema deberá establecer `index = 2`.

### 2.6 Detección de Linux
- **REQ-DET-013:** Cuando `defaultTargetPlatform` es `TargetPlatform.linux`, el sistema deberá establecer `buttonSelectOpcion[3] = true`.
- **REQ-DET-014:** Cuando `defaultTargetPlatform` es `TargetPlatform.linux`, el sistema deberá establecer `nombrePlataforma = "linux"`.
- **REQ-DET-015:** Cuando `defaultTargetPlatform` es `TargetPlatform.linux`, el sistema deberá establecer `index = 3`.

### 2.7 Detección de macOS
- **REQ-DET-016:** Cuando `defaultTargetPlatform` es `TargetPlatform.macOS`, el sistema deberá establecer `buttonSelectOpcion[4] = true`.
- **REQ-DET-017:** Cuando `defaultTargetPlatform` es `TargetPlatform.macOS`, el sistema deberá establecer `nombrePlataforma = "macOS"`.
- **REQ-DET-018:** Cuando `defaultTargetPlatform` es `TargetPlatform.macOS`, el sistema deberá establecer `index = 4`.

### 2.8 Detección de Windows
- **REQ-DET-019:** Cuando `defaultTargetPlatform` es `TargetPlatform.windows`, el sistema deberá establecer `buttonSelectOpcion[5] = true`.
- **REQ-DET-020:** Cuando `defaultTargetPlatform` es `TargetPlatform.windows`, el sistema deberá establecer `nombrePlataforma = "windows"`.
- **REQ-DET-021:** Cuando `defaultTargetPlatform` es `TargetPlatform.windows`, el sistema deberá establecer `index = 5`.

### 2.9 Visualización en Pantalla
- **REQ-PAN-001:** Cuando el usuario abre la pantalla de sistema operativo, el sistema deberá mostrar un AppBar con título "Sistema Operativo".
- **REQ-PAN-002:** Cuando el sistema renderiza la pantalla, el sistema deberá mostrar una lista de 7 plataformas con su estado de detección.
- **REQ-PAN-003:** Cuando el usuario presiona "Regresar", el sistema deberá navegar a `AppRoutes.principal`.

---

## 3. Requerimientos Controlados por Estados

### 3.1 Estado: Sin Verificar
- **REQ-SIN-VER-001:** Mientras el sistema no ha detectado la plataforma, el sistema deberá mostrar `nombrePlataforma = "Sin verificar conexión"`.
- **REQ-SIN-VER-002:** Mientras el sistema no ha detectado la plataforma, el sistema deberá mostrar todos los valores de `buttonSelectOpcion` en `false`.

### 3.2 Estado: Plataforma Detectada
- **REQ-DET-EST-001:** Mientras el sistema ha detectado una plataforma, el sistema deberá mostrar el nombre de la plataforma correspondiente.
- **REQ-DET-EST-002:** Mientras el sistema ha detectado una plataforma, el sistema deberá mostrar el icono correspondiente a la plataforma.
- **REQ-DET-EST-003:** Mientras el sistema ha detectado una plataforma, el sistema deberá mostrar solo el valor `true` en el índice correspondiente de `buttonSelectOpcion`.

### 3.3 Estado: Plataforma Web
- **REQ-WEB-EST-001:** Mientras la plataforma es Web, el sistema deberá mostrar `buttonSelectOpcion[6] = true`.
- **REQ-WEB-EST-002:** Mientras la plataforma es Web, el sistema deberá mostrar `nombrePlataforma = "Web u otro"`.

---

## 4. Requerimientos de Comportamiento No Deseado

### 4.1 Errores de Detección
- **REQ-FAL-001:** Si `defaultTargetPlatform` no coincide con ningún caso del switch, entonces el sistema deberá mantener el estado inicial sin verificar.
- **REQ-FAL-002:** Si `kIsWeb` es verdadero pero `defaultTargetPlatform` también está definido, entonces el sistema deberá priorizar `kIsWeb` y mostrar "Web u otro".

---

## 5. Requerimientos de Funciones Opcionales

### 5.1 Compresión de Imágenes
- **REQ-OPT-001:** Donde la plataforma sea Android, Fuchsia, iOS o Web, el sistema deberá usar la estrategia de compresión Web.
- **REQ-OPT-002:** Donde la plataforma sea Linux, macOS o Windows, el sistema deberá usar la estrategia de compresión Windows.

---

## 6. Requerimientos Complejos

### 6.1 Flujo de Detección Inicial
- **REQ-COM-001:** Mientras la aplicación inicia, cuando el sistema ejecuta `setCheckPlataformaProvider`, entonces deberá resetear el estado, verificar `kIsWeb`, y si no es Web, ejecutar el switch de `defaultTargetPlatform` para establecer la plataforma detectada.

### 6.2 Flujo de Clasificación para Compresión
- **REQ-COM-002:** Mientras el sistema necesita comprimir una imagen, cuando detecta la plataforma, entonces deberá verificar si está en `plataformasCompressWeb` o `plataformasCompressWin` para aplicar la estrategia de compresión correspondiente.

---

## 7. Modelos de Datos

### 7.1 ElementoPlataforma
| Campo | Tipo | Descripción |
|-------|------|-------------|
| `index` | int | Índice de la plataforma detectada (0-6) |
| `etiqueta` | String | Etiqueta descriptiva de la plataforma |
| `icono` | IconData | Icono Material Symbols de la plataforma |
| `buttonSelectOpcion` | List<bool> | Lista de 7 booleanos, solo uno activo según plataforma |
| `nombrePlataforma` | String | Nombre legible de la plataforma ("android", "iOS", etc.) |

### 7.2 Listas de Plataformas
| Lista | Contenido | Uso |
|-------|-----------|-----|
| `listaNombrePlataforma` | ["android", "fuchsia", "iOS", "linux", "macOS", "windows", "Web u otro"] | Nombres para mostrar en UI |
| `plataformasCompressWeb` | ["android", "fuchsia", "iOS", "Web u otro"] | Estrategia de compresión Web |
| `plataformasCompressWin` | ["linux", "macOS", "windows"] | Estrategia de compresión Windows |

---

## 8. Provider de Plataforma

### 8.1 checaPlataformaProvider
- **Tipo:** `StateProvider<ElementoPlataforma>`
- **Estado inicial:** `initialTiposElementoPlataforma`
- **Función de modificación:** `setCheckPlataformaProvider(WidgetRef ref)`
- **Comportamiento:** Resetea el estado y detecta la plataforma actual

### 8.2 Elementos de Plataforma (desde var_elementos_menus.dart)
| Índice | Etiqueta | Icono |
|--------|----------|-------|
| 0 | Android | `Symbols.android` |
| 1 | Fuchsia | `Symbols.computer` |
| 2 | iOS | `Symbols.ios` |
| 3 | Linux | `Symbols.laptop_windows` |
| 4 | macOS | `Symbols.ios` |
| 5 | Windows | `Symbols.window` |
| 6 | Web | `Symbols.web` |

---

## 9. Pantalla

### 9.1 PaginaDetectaPlataforma (`lib/42_sistema_operativo/detecta_os.dart`)
- **Propósito:** Pantalla informativa que muestra la plataforma de ejecución detectada
- **AppBar:** Color `appTheme.error`, título "Sistema Operativo", sin botón de retroceso
- **Contenido:** 
  - Título "Plataforma"
  - Lista de 7 plataformas con estado "Detectado" o "No"
  - Botón "Regresar" que navega a `AppRoutes.principal`
- **Estados:** Muestra indicador de carga mientras obtiene el estado

---

## 10. Reglas de Negocio

- **RN-001:** La detección de plataforma se realiza una vez al ejecutar `setCheckPlataformaProvider`.
- **RN-002:** Si `kIsWeb` es verdadero, se muestra "Web u otro" independientemente de `defaultTargetPlatform`.
- **RN-003:** El índice de `buttonSelectOpcion` corresponde directamente al índice de la plataforma en `listaNombrePlataforma`.
- **RN-004:** Solo una plataforma puede estar activa (`true`) en `buttonSelectOpcion` a la vez.
- **RN-005:** Las plataformas se clasifican en dos grupos de compresión: Web (Android, Fuchsia, iOS, Web) y Windows (Linux, macOS, Windows).
- **RN-006:** El estado inicial es "Sin verificar conexión" con todos los valores en `false`.

---

## 11. Estructura de Archivos

```
lib/42_sistema_operativo/
└── detecta_os.dart    # Detección de plataforma, provider Riverpod, pantalla de sistema operativo
```

---

## 12. Dependencias Técnicas

- **Foundation:** `package:flutter/foundation.dart` para `kIsWeb` y `defaultTargetPlatform`
- **Estado:** `flutter_riverpod` con `StateProvider`
- **UI:** Material Design 3, `AppBar`, `ListView`, `ElevatedButton`
- **Iconos:** `material_symbols_icons` para iconos de plataforma
- **Rutas:** `app_routes.dart` para navegación a `AppRoutes.principal`

---

## 13. Consideraciones de Plataforma

| Plataforma | Índice | Nombre | Compresión |
|------------|--------|--------|------------|
| Android | 0 | android | Web |
| Fuchsia | 1 | fuchsia | Web |
| iOS | 2 | iOS | Web |
| Linux | 3 | linux | Windows |
| macOS | 4 | macOS | Windows |
| Windows | 5 | windows | Windows |
| Web | 6 | Web u otro | Web |

---

## 14. Flujos de Usuario Principales

### 14.1 Flujo de Detección de Plataforma
1. Aplicación inicia
2. Se ejecuta `setCheckPlataformaProvider`
3. Se resetea el estado a valores iniciales
4. Se verifica `kIsWeb`
5. Si es Web, se establece "Web u otro"
6. Si no es Web, se evalúa `defaultTargetPlatform`
7. Se actualiza el provider con la plataforma detectada
8. La UI se actualiza automáticamente

### 14.2 Flujo de Visualización de Sistema Operativo
1. Usuario abre la pantalla de sistema operativo
2. Se muestra AppBar con título "Sistema Operativo"
3. Se muestra lista de 7 plataformas
4. La plataforma detectada muestra "Detectado"
5. Las otras muestran "No"
6. Usuario puede presionar "Regresar" para volver a la pantalla principal

### 14.3 Flujo de Clasificación para Compresión
1. Sistema necesita comprimir una imagen
2. Sistema detecta la plataforma actual
3. Sistema verifica si la plataforma está en `plataformasCompressWeb` o `plataformasCompressWin`
4. Sistema aplica la estrategia de compresión correspondiente
5. La imagen se comprime según la plataforma
