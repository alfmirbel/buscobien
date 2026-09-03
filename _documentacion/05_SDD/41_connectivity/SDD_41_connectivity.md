# SDD — Módulo 41_connectivity (BuscoBien)
## Especificación de Requerimientos (EARS)
**Directorio fuente:** `lib/41_connectivity`  
**Arquitectura:** Flutter + Riverpod + connectivity_plus  
**Propósito:** Gestión de conectividad de red, detección de tipos de conexión, pantalla de error sin conexión y estado reactivo de conectividad

---

## 1. Requerimientos Ubicuos

### 1.1 Gestión de Conectividad
- **REQ-CON-001:** El sistema deberá monitorear el estado de conectividad de red en tiempo real.
- **REQ-CON-002:** El sistema deberá soportar detección de múltiples tipos de conexión: mobile, wifi, ethernet, vpn, bluetooth, other, satellite, none.
- **REQ-CON-003:** El sistema deberá mantener un estado reactivo de conectividad mediante Riverpod `AsyncNotifierProvider`.

### 1.2 Elementos de Estado
- **REQ-CON-004:** El sistema deberá mantener un índice de tipo de conexión (0-6) para identificar el tipo activo.
- **REQ-CON-005:** El sistema deberá mantener una etiqueta descriptiva ("Conectado" o "Sin conexión").
- **REQ-CON-006:** El sistema deberá mantener un icono (`wifi` o `wifi_off`) según el estado.
- **REQ-CON-007:** El sistema deberá mantener una lista de booleanos `boolEstadoConeccion` de 7 elementos para cada tipo de conexión.
- **REQ-CON-008:** El sistema deberá mantener una descripción textual del estado ("Uso de datos moviles.", "Uso de Wi-Fi.", etc.).
- **REQ-CON-009:** El sistema deberá mantener una variable global `rutaConectividad` para navegación condicional.

### 1.3 Pantalla de Error
- **REQ-CON-010:** El sistema deberá mostrar una pantalla de error cuando no hay conexión a Internet.
- **REQ-CON-011:** El sistema deberá cerrar automáticamente la pantalla de error cuando se recupera la conexión.

---

## 2. Requerimientos Controlados por Eventos

### 2.1 Inicialización de Conectividad
- **REQ-INIT-001:** Cuando el provider se construye por primera vez, el sistema deberá crear una instancia de `Connectivity`.
- **REQ-INIT-002:** Cuando el provider se construye, el sistema deberá suscribirse al stream `onConnectivityChanged`.
- **REQ-INIT-003:** Cuando el provider se construye, el sistema deberá ejecutar `checkConnectivity` para obtener el estado inicial.
- **REQ-INIT-004:** Cuando el provider se destruye, el sistema deberá cancelar la suscripción al stream.

### 2.2 Detección de Tipos de Conexión
- **REQ-DET-001:** Cuando el sistema detecta `ConnectivityResult.mobile`, el sistema deberá establecer etiqueta "Conectado", icono `wifi`, índice 0, descripción "Uso de datos moviles." y ruta "/principal".
- **REQ-DET-002:** Cuando el sistema detecta `ConnectivityResult.wifi`, el sistema deberá establecer etiqueta "Conectado", icono `wifi`, índice 1, descripción "Uso de Wi-Fi." y ruta "/principal".
- **REQ-DET-003:** Cuando el sistema detecta `ConnectivityResult.ethernet`, el sistema deberá establecer etiqueta "Conectado", icono `wifi`, índice 2, descripción "Uso de red." y ruta "/principal".
- **REQ-DET-004:** Cuando el sistema detecta `ConnectivityResult.vpn`, el sistema deberá establecer etiqueta "Conectado", icono `wifi`, índice 3, descripción "Uso de VPN." y ruta "/principal".
- **REQ-DET-005:** Cuando el sistema detecta `ConnectivityResult.bluetooth`, el sistema deberá establecer etiqueta "Conectado", icono `wifi`, índice 4, descripción "Uso de Bluetooth." y ruta "/principal".
- **REQ-DET-006:** Cuando el sistema detecta `ConnectivityResult.other`, el sistema deberá establecer etiqueta "Conectado", icono `wifi`, índice 5, descripción "Otro tipo de conexión." y ruta "/principal".
- **REQ-DET-007:** Cuando el sistema detecta `ConnectivityResult.satellite`, el sistema deberá establecer etiqueta "Conectado", icono `wifi`, índice 5, descripción "Uso de conexión satelital." y ruta "/principal".
- **REQ-DET-008:** Cuando el sistema detecta `ConnectivityResult.none`, el sistema deberá establecer etiqueta "Sin conexión", icono `wifi_off`, índice 6, descripción "Sin conexión." y ruta "/sinconeccion".

### 2.3 Actualización en Tiempo Real
- **REQ-ACT-001:** Cuando el stream `onConnectivityChanged` emite nuevos resultados, el sistema deberá procesar la lista y tomar el primer resultado.
- **REQ-ACT-002:** Cuando la conectividad cambia, el sistema deberá actualizar el estado del provider con el nuevo `ElementoDeConeccion`.
- **REQ-ACT-003:** Cuando la conectividad cambia, el sistema deberá notificar a todos los widgets que observan el provider.

### 2.4 Pantalla Sin Conexión
- **REQ-PAN-001:** Cuando el usuario navega a la pantalla sin conexión, el sistema deberá mostrar AppBar con título "buscobien: error en la aplicación".
- **REQ-PAN-002:** Cuando el usuario está en la pantalla sin conexión, el sistema deberá escuchar cambios en `checaConeccionesProvider`.
- **REQ-PAN-003:** Cuando la conexión se recupera, el sistema deberá cerrar la pantalla automáticamente con `Navigator.pop()`.

### 2.5 Pantalla de Diagnóstico
- **REQ-DIAG-001:** Cuando el usuario abre la pantalla de diagnóstico, el sistema deberá mostrar un indicador de carga mientras obtiene el estado.
- **REQ-DIAG-002:** Cuando el estado se carga, el sistema deberá mostrar una lista con 7 tipos de conexión y sus estados.
- **REQ-DIAG-003:** Cuando el usuario presiona "Regresar", el sistema deberá cerrar la pantalla con `Navigator.pop()`.

---

## 3. Requerimientos Controlados por Estados

### 3.1 Estado: Conectado
- **REQ-CON-EST-001:** Mientras el sistema detecta conexión activa, el sistema deberá mostrar etiqueta "Conectado" e icono `wifi`.
- **REQ-CON-EST-002:** Mientras el sistema está conectado, el sistema deberá establecer `rutaConectividad = "/principal"`.

### 3.2 Estado: Sin Conexión
- **REQ-SIN-EST-001:** Mientras el sistema detecta sin conexión, el sistema deberá mostrar etiqueta "Sin conexión" e icono `wifi_off`.
- **REQ-SIN-EST-002:** Mientras el sistema está sin conexión, el sistema deberá establecer `rutaConectividad = "/sinconeccion"`.
- **REQ-SIN-EST-003:** Mientras el usuario está en la pantalla sin conexión, el sistema deberá mostrar mensajes informativos sobre la necesidad de Internet.

### 3.3 Estado: Cargando
- **REQ-CAR-EST-001:** Mientras el provider carga el estado inicial, el sistema deberá mostrar `CircularProgressIndicator`.

### 3.4 Estado: Error
- **REQ-ERR-EST-001:** Mientras ocurre un error al cargar la conectividad, el sistema deberá mostrar el mensaje de error.

---

## 4. Requerimientos de Comportamiento No Deseado

### 4.1 Errores de Conectividad
- **REQ-FAL-001:** Si la lista de resultados de conectividad está vacía, entonces el sistema deberá usar `ConnectivityResult.none` como fallback.
- **REQ-FAL-002:** Si el stream de conectividad emite un error, entonces el sistema deberá manejarlo en el estado `AsyncError`.
- **REQ-FAL-003:** Si la detección de conectividad tarda más de lo esperado, entonces el sistema deberá mostrar el indicador de carga hasta obtener el resultado.

### 4.2 Errores de Navegación
- **REQ-FAL-004:** Si el contexto ya no está montado al intentar cerrar la pantalla sin conexión, entonces el sistema deberá evitar el error de navegación.
- **REQ-FAL-005:** Si el provider se usa después de disposed, entonces el sistema deberá cancelar la suscripción y no actualizar el estado.

---

## 5. Requerimientos de Funciones Opcionales

### 5.1 Pantalla de Diagnóstico
- **REQ-OPT-001:** Donde el usuario acceda a la pantalla de diagnóstico, el sistema deberá mostrar el estado detallado de cada tipo de conexión.
- **REQ-OPT-002:** Donde el usuario esté en la pantalla de diagnóstico, el sistema deberá actualizar la lista en tiempo real cuando cambie la conectividad.

### 5.2 Ruta Global
- **REQ-OPT-003:** Donde el sistema mantenga la variable global `rutaConectividad`, el sistema deberá usarla para determinar la navegación inicial.
- **REQ-OPT-004:** Donde la aplicación requiera redirección automática, el sistema deberá observar el estado de conectividad para decidir la ruta.

---

## 6. Requerimientos Complejos

### 6.1 Flujo de Detección y Navegación Automática
- **REQ-COM-001:** Mientras la aplicación inicia, cuando el provider detecta el estado de conectividad, entonces deberá actualizar `rutaConectividad` y dirigir al usuario a "/principal" o "/sinconeccion" según corresponda.

### 6.2 Flujo de Pantalla Sin Conexión con Recuperación
- **REQ-COM-002:** Mientras el usuario está en la pantalla sin conexión, cuando el stream detecta recuperación de conectividad, entonces deberá cerrar automáticamente la pantalla y regresar a la navegación normal.

### 6.3 Flujo de Diagnóstico en Tiempo Real
- **REQ-COM-003:** Mientras el usuario está en la pantalla de diagnóstico, cuando cambia la conectividad, entonces deberá actualizar la lista de estados sin necesidad de recargar la pantalla.

---

## 7. Modelos de Datos

### 7.1 ElementoDeConeccion
| Campo | Tipo | Descripción |
|-------|------|-------------|
| `index` | int | Índice del tipo de conexión (0=mobile, 1=wifi, 2=ethernet, 3=vpn, 4=bluetooth, 5=other/satellite, 6=none) |
| `etiqueta` | String | Etiqueta descriptiva ("Conectado" o "Sin conexión") |
| `icono` | IconData | Icono Material Symbols (`wifi` o `wifi_off`) |
| `boolEstadoConeccion` | List<bool> | Lista de 7 booleanos indicando estado de cada tipo de conexión |
| `estadoDeLaConeccion` | String | Descripción textual del estado ("Uso de Wi-Fi.", "Sin conexión.", etc.) |

### 7.2 ElementoDatos
| Campo | Tipo | Descripción |
|-------|------|-------------|
| `etiqueta` | String | Etiqueta del elemento de conexión |
| `icono` | IconData | Icono del elemento de conexión |

---

## 8. Variables Globales

### 8.1 Nombres de Conexiones
| Índice | Nombre | Descripción |
|--------|--------|-------------|
| 0 | mobile | Conexión móvil |
| 1 | wifi | Conexión Wi-Fi |
| 2 | ethernet | Conexión Ethernet |
| 3 | vpn | Conexión VPN |
| 4 | bluetooth | Conexión Bluetooth |
| 5 | otras | Otro tipo de conexión |
| 6 | ninguna | Sin conexión |
| 7 | No se pudo verificar | Estado de verificación fallida |

### 8.2 Elementos de Conexión a Internet
| Índice | Etiqueta | Icono |
|--------|----------|-------|
| 0 | Conectado | `Symbols.wifi` |
| 1 | Sin conexión | `Symbols.wifi_off` |

### 8.3 Ruta Global
| Variable | Valor por Defecto | Descripción |
|----------|-------------------|-------------|
| `rutaConectividad` | "" | Ruta de navegación según estado de conexión ("/principal" o "/sinconeccion") |

---

## 9. Pantallas

### 9.1 PaginaSinConeccion (`lib/41_connectivity/pagina_sin_coneccion.dart`)
- **Propósito:** Pantalla de error cuando no hay conexión a Internet
- **AppBar:** Color `appTheme.error`, título "buscobien: error en la aplicación", sin botón de retroceso
- **Contenido:** Mensajes informativos sobre necesidad de Internet, instrucciones para activar conexión
- **Comportamiento:** Se cierra automáticamente cuando se recupera la conexión
- **Parámetros:** Recibe un `letrero` personalizado para mostrar

### 9.2 PaginaChecaInternet (`lib/41_connectivity/connectivitycheck_provider.dart`)
- **Propósito:** Pantalla de diagnóstico de conectividad
- **AppBar:** Color `appTheme.error`, título "conexión"
- **Contenido:** Lista de 7 tipos de conexión con estados "Activada"/"Desctivada", descripción del estado, botón "Regresar"
- **Estados:** Muestra indicador de carga mientras obtiene el estado

---

## 10. Reglas de Negocio

- **RN-001:** La ruta global `rutaConectividad` se actualiza automáticamente según el tipo de conexión detectado.
- **RN-002:** Cuando hay cualquier tipo de conexión activa (mobile, wifi, ethernet, vpn, bluetooth, other, satellite), la ruta se establece en "/principal".
- **RN-003:** Cuando no hay conexión (`ConnectivityResult.none`), la ruta se establece en "/sinconeccion".
- **RN-004:** La pantalla sin conexión se cierra automáticamente al detectar recuperación de conexión.
- **RN-005:** El provider se suscribe al stream de conectividad para actualizaciones en tiempo real.
- **RN-006:** La suscripción al stream se cancela automáticamente cuando el provider se destruye.
- **RN-007:** Si la lista de resultados está vacía, se usa `ConnectivityResult.none` como fallback.
- **RN-008:** La lista `boolEstadoConeccion` tiene 7 elementos correspondientes a los 7 tipos de conexión principales.

---

## 11. Estructura de Archivos

```
lib/41_connectivity/
├── pagina_sin_coneccion.dart            # Pantalla de error sin conexión
├── connectivitycheck_provider.dart      # Provider Riverpod + widget de diagnóstico
```

---

## 12. Dependencias Técnicas

- **Conectividad:** `connectivity_plus` para detección de tipos de conexión
- **Estado:** `flutter_riverpod` con `AsyncNotifierProvider`
- **UI:** Material Design 3, `AppBar`, `ListView`, `ElevatedButton`, `CircularProgressIndicator`
- **Iconos:** `material_symbols_icons` para `wifi` y `wifi_off`

---

## 13. Consideraciones de Plataforma

| Plataforma | Tipos de Conexión Soportados |
|------------|------------------------------|
| Android | mobile, wifi, ethernet, vpn, bluetooth, other, none |
| iOS | mobile, wifi, ethernet, vpn, bluetooth, other, none |
| Web | wifi (limitado por navegador) |
| Desktop | ethernet, wifi, vpn, other |

---

## 14. Flujos de Usuario Principales

### 14.1 Flujo de Detección Inicial
1. Aplicación inicia y un widget observa `checaConeccionesProvider`
2. Provider crea instancia de `Connectivity`
3. Provider se suscribe al stream `onConnectivityChanged`
4. Provider ejecuta `checkConnectivity` para estado inicial
5. Provider procesa el resultado y actualiza el estado
6. UI se actualiza automáticamente

### 14.2 Flujo de Pérdida de Conexión
1. Usuario está navegando en la aplicación
2. Conexión se pierde (Wi-Fi apagado, datos móviles desactivados)
3. Stream emite `ConnectivityResult.none`
4. Provider actualiza estado: etiqueta "Sin conexión", ruta "/sinconeccion"
5. Si hay una pantalla de error abierta, se actualiza
6. Si no, se puede navegar a pantalla sin conexión

### 14.3 Flujo de Recuperación de Conexión
1. Usuario está en pantalla sin conexión
2. Usuario activa Wi-Fi o datos móviles
3. Stream emite nuevo resultado de conectividad
4. Provider actualiza estado: etiqueta "Conectado", ruta "/principal"
5. Pantalla sin conexión detecta el cambio
6. Pantalla se cierra automáticamente con `Navigator.pop()`
7. Usuario regresa a la pantalla anterior

### 14.4 Flujo de Diagnóstico
1. Usuario abre pantalla de diagnóstico
2. Sistema muestra indicador de carga
3. Provider retorna estado de conectividad
4. Sistema muestra lista de 7 tipos de conexión con estados
5. Si la conectividad cambia, la lista se actualiza en tiempo real
6. Usuario puede presionar "Regresar" para cerrar
