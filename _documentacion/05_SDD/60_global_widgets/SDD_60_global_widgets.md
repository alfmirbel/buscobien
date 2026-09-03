# SDD — Módulo 60_global_widgets (BuscoBien)
## Especificación de Requerimientos (EARS)
**Directorio fuente:** `lib/60_global_widgets`  
**Arquitectura:** Flutter + Material Design 3 + Riverpod  
**Propósito:** Widgets reutilizables globales, formateo de cantidades monetarias, estados de FutureBuilder, diálogos de mensaje, sistema de debug y componentes de UI personalizados

---

## 1. Requerimientos Ubicuos

### 1.1 Formateo de Cantidades Monetarias
- **REQ-GLOB-001:** El sistema deberá formatear cantidades monetarias con formato "X,XXX,XXX" (millones,miles,cientos).
- **REQ-GLOB-002:** El sistema deberá generar cantidades aleatorias dentro de un rango mínimo y máximo.
- **REQ-GLOB-003:** El sistema deberá clasificar montos en: millones (>999999), miles (>999), cientos (<=999).
- **REQ-GLOB-004:** El sistema deberá rellenar con ceros las partes de miles y cientos cuando sea necesario.

### 1.2 Estados de FutureBuilder
- **REQ-GLOB-005:** El sistema deberá proporcionar widgets de estado para FutureBuilder: `stateNone`, `stateWaiting`, `stateActive`, `stateError`, `stateErrorFormat`.
- **REQ-GLOB-006:** El sistema deberá proporcionar versiones fullscreen de los widgets de estado: `stateNoneFS`, `stateWaitingFS`, `stateActiveFS`, `stateErrorFS`, `stateErrorFormatFS`.
- **REQ-GLOB-007:** El sistema deberá usar `appTheme.primaryContainer` para estados none.
- **REQ-GLOB-008:** El sistema deberá usar `appTheme.surface` para estados waiting, active y error.
- **REQ-GLOB-009:** El sistema deberá usar `appTheme.onPrimaryContainer` para el texto de estados.

### 1.3 Diálogos de Mensaje
- **REQ-GLOB-010:** El sistema deberá proporcionar una función `showMessageDialog` para mostrar mensajes emergentes.
- **REQ-GLOB-011:** El sistema deberá usar `AlertDialog` con elevación 6 y bordes redondeados de radio 3.
- **REQ-GLOB-012:** El sistema deberá usar fuente "Comfortaa" para títulos y botones de diálogos.

### 1.4 Derechos Reservados
- **REQ-GLOB-013:** El sistema deberá mostrar el texto "© 2026 Buscobien®. Todos los derechos reservados." en modo claro.
- **REQ-GLOB-014:** El sistema deberá mostrar el texto "© 2026 Buscobien®. Todos los derechos reservados." en modo oscuro.

### 1.5 Sistema de Debug
- **REQ-GLOB-015:** El sistema deberá proporcionar un sistema de debug por niveles del 0 al 20.
- **REQ-GLOB-016:** El sistema deberá mantener un contador global de llamadas `lcwc`.
- **REQ-GLOB-017:** El sistema deberá imprimir mensajes solo si el nivel correspondiente está activo.

### 1.6 Widgets Personalizados
- **REQ-GLOB-018:** El sistema deberá proporcionar `MyButton` como botón personalizado con elevación.
- **REQ-GLOB-019:** El sistema deberá proporcionar `MyTextField` como campo de texto personalizado.
- **REQ-GLOB-020:** El sistema deberá proporcionar `MyTextFieldPassword` como campo de contraseña con toggle de visibilidad.
- **REQ-GLOB-021:** El sistema deberá proporcionar `SquareTile` como widget de imagen cuadrada.

---

## 2. Requerimientos Controlados por Eventos

### 2.1 Formateo de Cantidades
- **REQ-FOR-001:** Cuando el sistema recibe "millones", el sistema deberá generar un monto entre minimo y maximo, y formatear como "X,XXX,XXX".
- **REQ-FOR-002:** Cuando el sistema recibe "miles", el sistema deberá generar un monto entre minimo y maximo, y formatear como "XXX,XXX".
- **REQ-FOR-003:** Cuando el sistema recibe "cientos", el sistema deberá generar un monto entre minimo y maximo, y formatear como "XXX".
- **REQ-FOR-004:** Cuando el monto es mayor a 999999, el sistema deberá clasificar como "millones".
- **REQ-FOR-005:** Cuando el monto es mayor a 999 y menor a 999999, el sistema deberá clasificar como "miles".
- **REQ-FOR-006:** Cuando el monto es menor o igual a 999, el sistema deberá clasificar como "cientos".

### 2.2 Estados de FutureBuilder
- **REQ-FUT-001:** Cuando el FutureBuilder está en estado `ConnectionState.none`, el sistema deberá mostrar `stateNone` con texto "Sin resultados".
- **REQ-FUT-002:** Cuando el FutureBuilder está en estado `ConnectionState.waiting`, el sistema deberá mostrar `stateWaiting` con `CircularProgressIndicator`.
- **REQ-FUT-003:** Cuando el FutureBuilder está en estado `ConnectionState.active`, el sistema deberá mostrar `stateActive` con texto "Esperando datos".
- **REQ-FUT-004:** Cuando el FutureBuilder completa con error, el sistema deberá mostrar `stateError` o `stateErrorFormat` con el mensaje de error.

### 2.3 Diálogos de Mensaje
- **REQ-DIA-001:** Cuando el sistema ejecuta `showMessageDialog`, el sistema deberá mostrar un `AlertDialog` con título, mensaje y botón.
- **REQ-DIA-002:** Cuando el usuario presiona el botón del diálogo, el sistema deberá cerrar el diálogo con `Navigator.pop()`.

### 2.4 Toggle de Visibilidad de Contraseña
- **REQ-PAS-001:** Cuando el usuario presiona el icono de visibilidad en `MyTextFieldPassword`, el sistema deberá cambiar `isHidden` de `true` a `false` o viceversa.
- **REQ-PAS-002:** Cuando `isHidden` es `true`, el sistema deberá mostrar el icono `visibility_off`.
- **REQ-PAS-003:** Cuando `isHidden` es `false`, el sistema deberá mostrar el icono `visibility`.

### 2.5 Sistema de Debug
- **REQ-DEB-001:** Cuando el sistema ejecuta `debugPrintLevels(nivel, mensaje)`, el sistema deberá verificar si el nivel está activo.
- **REQ-DEB-002:** Cuando el nivel 1 está activo, el sistema deberá imprimir con prefijo "LYFECYCLE".
- **REQ-DEB-003:** Cuando el nivel es mayor a 20, el sistema deberá usar el caso default e imprimir sin prefijo.

---

## 3. Requerimientos Controlados por Estados

### 3.1 Estado: Modo Claro
- **REQ-CLARO-001:** Mientras la aplicación está en modo claro, el sistema deberá usar `derechosReservadosClaro()` con color `appTheme.surface`.

### 3.2 Estado: Modo Oscuro
- **REQ-OSCURO-001:** Mientras la aplicación está en modo oscuro, el sistema deberá usar `derechosReservadosObscuro()` con color `appTheme.onSurface`.

### 3.3 Estado: Campo de Contraseña
- **REQ-PASS-001:** Mientras `isHidden` es `true`, el sistema deberá mostrar el texto del campo como `obscureText: true`.
- **REQ-PASS-002:** Mientras `isHidden` es `false`, el sistema deberá mostrar el texto del campo como `obscureText: false`.

### 3.4 Estado: Niveles de Debug Activos
- **REQ-DEBUG-001:** Mientras `level00` es verdadero, el sistema deberá imprimir mensajes del nivel 0.
- **REQ-DEBUG-002:** Mientras `level01` es verdadero, el sistema deberá imprimir mensajes del nivel 1 con prefijo "LYFECYCLE".
- **REQ-DEBUG-003:** Mientras `level10` es verdadero, el sistema deberá imprimir mensajes del nivel 10.
- **REQ-DEBUG-004:** Mientras `level12` es verdadero, el sistema deberá imprimir mensajes del nivel 12.

---

## 4. Requerimientos de Comportamiento No Deseado

### 4.1 Errores de Formateo
- **REQ-FAL-001:** Si el tipo de cantidad no es "millones", "miles" o "cientos", entonces el sistema deberá retornar cadena vacía.
- **REQ-FAL-002:** Si el monto es negativo, entonces el sistema deberá formatear como "0" o manejar el caso especial.

### 4.2 Errores de FutureBuilder
- **REQ-FAL-003:** Si el FutureBuilder tiene un error, entonces el sistema deberá mostrar `stateError` con el mensaje de error.
- **REQ-FAL-004:** Si el FutureBuilder está en estado `ConnectionState.none`, entonces el sistema deberá mostrar `stateNone` con "Sin resultados".

### 4.3 Errores de Debug
- **REQ-FAL-005:** Si el nivel de debug es mayor a 20, entonces el sistema deberá usar el caso default del switch.
- **REQ-FAL-006:** Si `lcwc` excede el rango de int, entonces el sistema podría tener overflow (no manejado).

---

## 5. Requerimientos de Funciones Opcionales

### 5.1 Widgets de Estado Fullscreen
- **REQ-OPT-001:** Donde se requiera mostrar estados sin dimensiones específicas, el sistema deberá usar las versiones FS de los widgets de estado.

### 5.2 Sistema de Debug
- **REQ-OPT-002:** Donde se requiera depuración avanzada, el sistema deberá activar niveles específicos de debug.
- **REQ-OPT-003:** Donde se requiera tracing de ciclo de vida, el sistema deberá activar el nivel 1 con prefijo "LYFECYCLE".

### 5.3 Formateo de Cantidades
- **REQ-OPT-004:** Donde se requiera mostrar precios aleatorios, el sistema deberá usar `generaCantidad` con el tipo correspondiente.
- **REQ-OPT-005:** Donde se requiera formatear un monto específico, el sistema deberá usar `formatoCantidad` con el valor numérico.

---

## 6. Requerimientos Complejos

### 6.1 Flujo de Formateo de Cantidad Monetaria
- **REQ-COM-001:** Mientras el sistema necesita formatear una cantidad, cuando recibe el tipo "millones", entonces deberá generar un monto aleatorio en el rango, dividirlo en millones/miles/cientos, rellenar con ceros y retornar el formato "X,XXX,XXX".

### 6.2 Flujo de Estados de FutureBuilder
- **REQ-COM-002:** Mientras el sistema usa un FutureBuilder, cuando cambia el estado del future, entonces debera mostrar el widget correspondiente: none (sin resultados), waiting (indicador de carga), active (esperando datos), error (mensaje de error).

### 6.3 Flujo de Diálogo de Mensaje
- **REQ-COM-003:** Mientras el sistema necesita mostrar un mensaje, cuando ejecuta `showMessageDialog`, entonces deberá crear un AlertDialog con título, mensaje, botón y colores del tema, y mostrarlo hasta que el usuario presione el botón.

---

## 7. Modelos de Datos

### 7.1 ElementoPlataforma (no aplica directamente en este módulo, se usa desde 42_sistema_operativo)
No aplica.

### 7.2 Estructura de Cantidad Monetaria
| Campo | Tipo | Descripción |
|-------|------|-------------|
| `millones` | int | Parte de millones del monto |
| `miles` | int | Parte de miles del monto |
| `cientos` | int | Parte de cientos del monto |
| `resultado` | String | Cadena formateada "X,XXX,XXX" |

---

## 8. Widgets y Funciones Documentadas

### 8.1 Generación de Cantidades (`genera_cantidad_monetaria.dart`)
| Función | Entrada | Salida | Descripción |
|---------|---------|--------|-------------|
| `generaCantidad(cantidad, minimo, maximo)` | String, int, int | String | Genera cantidad aleatoria formateada |
| `formatoCantidad(monto)` | int | String | Formatea un monto específico |

### 8.2 Estados de FutureBuilder (`future_builder_state_widgets.dart`)
| Función | Entrada | Salida | Descripción |
|---------|---------|--------|-------------|
| `stateNone(w, l)` | double, double | Container | Estado none con dimensiones |
| `stateWaiting(w, l)` | double, double | Center | Estado waiting con indicador |
| `stateActive(w, l)` | double, double | Container | Estado active con texto |
| `stateError(w, l, error)` | double, double, dynamic | Container | Estado error con mensaje |
| `stateErrorFormat(w, l, error)` | double, double, dynamic | Container | Estado error formateado |
| `stateNoneFS()` | - | Center | Estado none fullscreen |
| `stateWaitingFS()` | - | Center | Estado waiting fullscreen |
| `stateActiveFS()` | - | Center | Estado active fullscreen |
| `stateErrorFS(error)` | dynamic | Center | Estado error fullscreen |
| `stateErrorFormatFS(error)` | dynamic | Center | Estado error formateado fullscreen |

### 8.3 Diálogo de Mensaje (`dialogbox_mensaje_general.dart`)
| Función | Entrada | Salida | Descripción |
|---------|---------|--------|-------------|
| `showMessageDialog(context, title, message, color, alineacion, boton)` | BuildContext, String, String, Color, TextAlign, String | Future<void> | Muestra AlertDialog genérico |

### 8.4 Derechos Reservados (`derechos_reservados.dart`)
| Función | Entrada | Salida | Descripción |
|---------|---------|--------|-------------|
| `derechosReservadosClaro()` | - | Column | Widget derechos reservados modo claro |
| `derechosReservadosObscuro()` | - | Column | Widget derechos reservados modo oscuro |

### 8.5 Debug (`debugprint.dart`)
| Variable | Tipo | Descripción |
|----------|------|-------------|
| `level00` a `level20` | bool | Flags de activación por nivel |
| `lcwc` | int | Contador de llamadas |
| `debugPrintLevels(level, mensaje)` | int, String | void | Imprime mensaje si nivel activo |

### 8.6 Botones y Campos (`bottom_fijo.dart`)
| Widget | Entrada | Salida | Descripción |
|---------|---------|--------|-------------|
| `MyButton(etiqueta, onTap)` | String, Function | TextButton | Botón personalizado con elevación |
| `MyTextField(controller, hintText, obscureText, icono)` | TextEditingController, String, bool, IconData | Column | Campo de texto personalizado |
| `MyTextFieldPassword(controller, hintText, icono)` | TextEditingController, String, IconData | StatefulWidget | Campo de contraseña con toggle visibilidad |
| `SquareTile(imagePath)` | String | Container | Widget de imagen cuadrada |

---

## 9. Reglas de Negocio

- **RN-001:** El formato de cantidad monetaria debe usar comas como separadores de miles.
- **RN-002:** Los montos menores a 1000 se formatean como "cientos" sin ceros de relleno.
- **RN-003:** Los montos entre 1000 y 999999 se formatean como "miles" con cero de relleno en cientos si es necesario.
- **RN-004:** Los montos mayores a 999999 se formatean como "millones" con ceros de relleno en miles y cientos.
- **RN-005:** Los widgets de estado FutureBuilder deben usar `appTheme` para colores consistentes.
- **RN-006:** El sistema de debug usa prefijo "LYFECYCLE" exclusivamente para nivel 1.
- **RN-007:** El contador `lcwc` se incrementa en cada llamada a `debugPrintLevels`.
- **RN-008:** El botón de visibilidad en `MyTextFieldPassword` usa `Symbols.visibility_off` y `Symbols.visibility`.
- **RN-009:** Los diálogos de mensaje usan fuente "Comfortaa" en título y botón.
- **RN-010:** Los derechos reservados usan `appTheme.surface` en modo claro y `appTheme.onSurface` en modo oscuro.

---

## 10. Estructura de Archivos

```
lib/60_global_widgets/
├── genera_cantidad_monetaria.dart     # Formateo y generación de cantidades monetarias
├── future_builder_state_widgets.dart  # Widgets de estado para FutureBuilder (con y sin dimensiones)
├── dialogbox_mensaje_general.dart     # Función showMessageDialog para AlertDialog genérico
├── derechos_reservados.dart           # Widgets de copyright claro y oscuro
├── debugprint.dart                    # Sistema de debug por niveles 0-20
├── bottom_fijo.dart                   # MyButton, MyTextField, MyTextFieldPassword, SquareTile
```

---

## 11. Dependencias Técnicas

- **Flutter Material:** `Container`, `Center`, `Text`, `CircularProgressIndicator`, `AlertDialog`, `TextButton`, `TextField`, `Column`, `Row`, `Image.asset`
- **Riverpod:** `WidgetRef` usado en `bottom_fijo.dart` para `MyTextFieldPassword`
- **Material Symbols Icons:** `Symbols.visibility`, `Symbols.visibility_off`
- **Tema Global:** `appTheme` desde `var_color_themes.dart`
- **Debug:** `debugPrint` de Flutter para logging

---

## 12. Consideraciones de UI

### 12.1 Colores por Estado
| Estado | Color de Fondo | Color de Texto |
|--------|---------------|----------------|
| None | `appTheme.primaryContainer` | `appTheme.onPrimaryContainer` |
| Waiting | `appTheme.surface` | `appTheme.onPrimaryContainer` |
| Active | `appTheme.surface` | `appTheme.onPrimaryContainer` |
| Error | `appTheme.surface` | `appTheme.onPrimaryContainer` |

### 12.2 Dimensiones por Componente
| Componente | Ancho | Alto | Radio |
|------------|-------|------|-------|
| MyButton | 200 | 40 | 8 |
| MyTextField | 200 | 40 | - |
| MyTextFieldPassword | 200 | 40 | - |
| SquareTile | - | 100 | 8 |
| stateWaiting (w-3, l-3) | w-3 | l-3 | - |

---

## 13. Flujos de Usuario Principales

### 13.1 Flujo de Formateo de Cantidad
1. Sistema necesita mostrar un monto monetario
2. Si el monto es fijo, usa `formatoCantidad(monto)`
3. Si el monto es aleatorio, usa `generaCantidad(tipo, minimo, maximo)`
4. Sistema clasifica el monto en millones/miles/cientos
5. Sistema divide y rellena con ceros
6. Sistema retorna formato "X,XXX,XXX"

### 13.2 Flujo de Estados de FutureBuilder
1. Widget inicia un future
2. FutureBuilder muestra `stateNone` antes de iniciar
3. FutureBuilder muestra `stateWaiting` mientras carga
4. FutureBuilder muestra `stateActive` cuando hay datos parciales
5. FutureBuilder muestra `stateError` si hay error
6. Cada estado usa colores del tema global

### 13.3 Flujo de Diálogo de Mensaje
1. Sistema necesita mostrar un mensaje
2. Sistema ejecuta `showMessageDialog` con parámetros
3. Sistema crea AlertDialog con estilos del tema
4. Usuario ve el mensaje
5. Usuario presiona el botón
6. Sistema cierra el diálogo con `Navigator.pop()`
