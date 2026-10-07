# SDD — `home_navigation_provider.dart`
## Especificación Técnica: Notifier de Navegación Principal (`HomeNavigation`)
**Módulo:** `lib/01_home/home_navigation_provider.dart`
**Patrón:** Riverpod 3.x `@riverpod` Notifier con estado inmutable Freezed
**Metodología:** EARS — Easy Approach to Requirements Syntax

---

## 1. Contexto y Propósito

`HomeNavigation` es el **Riverpod Notifier** central que gestiona el estado de navegación de la aplicación BuscoBien. Actúa como capa de mutación sobre `HomeState`: expone métodos nombrados que crean nuevas instancias inmutables del estado. Es el único componente autorizado para escribir sobre `homeNavigationProvider`.

```
HomeNavigation (Riverpod Notifier)
│
├── Estado: HomeState (inmutable, Freezed)
│
├── Métodos directos (sin log):
│   ├── setInicial(int i)
│   ├── setPrincipal(int i)
│   ├── setGobierno(int i)
│   ├── setEspacio(int i)
│   ├── setTransaccion(int i)
│   ├── setMiCuenta(int i)
│   └── setMiCuentaUsuario(int i)
│
└── Métodos con log de depuración (nivel 10):
    ├── actualizarInicial(int index)
    ├── actualizarPrincipal(int index)
    ├── actualizarNivelGobierno(int index)
    ├── actualizarTipoEspacio(int index)
    ├── actualizarTipoTransaccion(int index)
    ├── actualizarMiCuenta(int index)
    └── actualizarMiCuentaUsuario(int index)
```

---

## 2. Requerimientos Ubicuos (Ubiquitous)

> Activos en todo momento, independientemente del estado del sistema.

**SDD-HNP-001**
El sistema deberá garantizar que `HomeNavigation` sea el único punto de escritura autorizado sobre el estado de navegación global `homeNavigationProvider`.

**SDD-HNP-002**
El sistema deberá inicializar el estado de `HomeNavigation` con `HomeState(indiceInicial: 0)` al momento de la primera suscripción al provider, representando la sección "Inicio" como pantalla por defecto.

**SDD-HNP-003**
El sistema deberá producir, en cada actualización de estado, una nueva instancia inmutable de `HomeState` mediante `state.copyWith(...)`, preservando los valores previos de todos los campos no modificados.

**SDD-HNP-004**
El sistema deberá mantener el provider `homeNavigationProvider` disponible en el árbol de widgets durante toda la vida útil de la aplicación, dado que es observado por `PrincipalSliversMenuInicial` desde el arranque.

**SDD-HNP-005**
El sistema deberá garantizar que todas las actualizaciones de estado sean síncronas y que Riverpod propague los cambios a los widgets observadores en el mismo frame de renderizado.

---

## 3. Requerimientos Controlados por Eventos (Event-Driven)

> Se activan cuando y solo cuando ocurre un evento específico.

### 3.1 Métodos directos (sin log)

**SDD-HNP-010**
Cuando un widget llame a `setInicial(int i)`, el sistema deberá actualizar el campo `indiceInicial` de `HomeState` con el valor `i`, sin incrementar `version` ni emitir trazas de depuración.

**SDD-HNP-011**
Cuando un widget llame a `setPrincipal(int i)`, el sistema deberá actualizar el campo `indicePrincipal` de `HomeState` con el valor `i`.

**SDD-HNP-012**
Cuando un widget llame a `setGobierno(int i)`, el sistema deberá actualizar el campo `indiceNivelGobierno` de `HomeState` con el valor `i`.

**SDD-HNP-013**
Cuando un widget llame a `setEspacio(int i)`, el sistema deberá actualizar el campo `indiceTipoEspacio` de `HomeState` con el valor `i`.

**SDD-HNP-014**
Cuando un widget llame a `setTransaccion(int i)`, el sistema deberá actualizar el campo `indiceTipoTransaccion` de `HomeState` con el valor `i`.

**SDD-HNP-015**
Cuando un widget llame a `setMiCuenta(int i)`, el sistema deberá actualizar el campo `indiceMiCuenta` de `HomeState` con el valor `i`.

**SDD-HNP-016**
Cuando un widget llame a `setMiCuentaUsuario(int i)`, el sistema deberá actualizar el campo `indiceMiCuentaUsuario` de `HomeState` con el valor `i`.

### 3.2 Métodos con log de depuración

**SDD-HNP-020**
Cuando un widget llame a `actualizarInicial(int index)`, el sistema deberá:
1. Emitir una traza de depuración con nivel 10: `"ACTUALIZA PROVIDERS MENU INICIAL {index}"`.
2. Actualizar `indiceInicial = index` y `version = version + 1` en una sola operación `copyWith`.

**SDD-HNP-021**
Cuando un widget llame a `actualizarPrincipal(int index)`, el sistema deberá:
1. Emitir una traza de depuración con nivel 10: `"ACTUALIZA PROVIDERS MENU PRINCIPAL {index}"`.
2. Actualizar `indicePrincipal = index` y `version = version + 1`.

**SDD-HNP-022**
Cuando un widget llame a `actualizarNivelGobierno(int index)`, el sistema deberá:
1. Emitir una traza de depuración con nivel 10: `"ACTUALIZA PROVIDERS NIVEL GOBIERNO {index}"`.
2. Actualizar `indiceNivelGobierno = index` y `version = version + 1`.

**SDD-HNP-023**
Cuando un widget llame a `actualizarTipoEspacio(int index)`, el sistema deberá:
1. Emitir una traza de depuración con nivel 10: `"ACTUALIZA PROVIDERS TIPO ESPACIO {index}"`.
2. Actualizar `indiceTipoEspacio = index` y `version = version + 1`.

**SDD-HNP-024**
Cuando un widget llame a `actualizarTipoTransaccion(int index)`, el sistema deberá:
1. Emitir una traza de depuración con nivel 10: `"ACTUALIZA PROVIDERS TIPO TRANSACCIÓN {index}"`.
2. Actualizar `indiceTipoTransaccion = index` y `version = version + 1`.

**SDD-HNP-025**
Cuando un widget llame a `actualizarMiCuenta(int index)`, el sistema deberá:
1. Emitir una traza de depuración con nivel 10: `"ACTUALIZA PROVIDERS MI CUENTA {index}"`.
2. Actualizar `indiceMiCuenta = index` y `version = version + 1`.

**SDD-HNP-026**
Cuando un widget llame a `actualizarMiCuentaUsuario(int index)`, el sistema deberá:
1. Emitir una traza de depuración con nivel 10: `"ACTUALIZA PROVIDERS MI CUENTA USUARIO {index}"`.
2. Actualizar `indiceMiCuentaUsuario = index` y `version = version + 1`.

### 3.3 Propagación reactiva

**SDD-HNP-030**
Cuando el campo `version` sea incrementado, el sistema (Riverpod) deberá notificar a todos los widgets que observen `homeNavigationProvider` mediante `ref.watch(homeNavigationProvider)`, forzando su reconstrucción con el nuevo estado.

**SDD-HNP-031**
Cuando `PrincipalSliversMenuInicial` reciba una notificación de cambio de `homeNavigationProvider`, el sistema deberá ejecutar `_scrollController.jumpTo(0)` para reiniciar la posición de scroll al inicio del contenido de la nueva sección.

---

## 4. Requerimientos Controlados por Estados (State-Driven)

> Activos solo mientras el sistema se encuentra en un estado específico.

**SDD-HNP-040**
Mientras `indiceInicial != 1`, el sistema deberá mantener el menú `menuSuperiorMenuInicial` visible y excluir `menuSuperiorMenuPrincipal` del árbol de widgets.

**SDD-HNP-041**
Mientras `indiceInicial == 1` y `indicePrincipal` esté en el rango `[0, 3]`, el sistema deberá mantener activo el widget `PaginaBuscaEspacios` pasando el estado de navegación como argumento.

**SDD-HNP-042**
Mientras `indiceInicial == 3` y `nombrePerfil == "Promotor"`, el sistema deberá mantener activo el sub-menú `MenuSuperiorPaginaTuCuenta` con cuatro pestañas (Espacios, Listas, Grupos, Conocidos).

**SDD-HNP-043**
Mientras `indiceInicial == 3` y `nombrePerfil == "Usuario"`, el sistema deberá mantener activo el sub-menú `MenuSuperiorPaginaTuCuentaUsuario` con tres pestañas (Listas, Grupos, Conocidos).

**SDD-HNP-044**
Mientras `indiceInicial == 3` y `nombrePerfil == ""` (usuario invitado), el sistema deberá mantener visible el panel de invitación con el botón "Ingresa de acuerdo a tu perfil".

---

## 5. Requerimientos de Comportamiento No Deseado (Unwanted Behaviour)

**SDD-HNP-050**
Si un widget intenta modificar el estado de navegación directamente (sin pasar por el notifier), entonces el sistema deberá generar un error de compilación, dado que el acceso de escritura solo está disponible mediante `ref.read(homeNavigationProvider.notifier)`.

**SDD-HNP-051**
Si `debugPrintLevels` no está disponible en el entorno de importación, entonces el sistema deberá fallar en tiempo de compilación antes de permitir la ejecución de los métodos `actualizar*()`, garantizando que los logs de depuración sean siempre funcionales.

**SDD-HNP-052**
Si `actualizarNivelGobierno()` es invocado con un índice fuera del rango `[0, 3]`, entonces el sistema deberá aceptar el valor y actualizar el estado sin lanzar excepción, delegando la validación de rango a la lógica de negocio del menú correspondiente.

> **Nota de diseño:** La validación de rango no está implementada en el notifier; se recomienda agregar una aserción defensiva en una versión futura.

---

## 6. Requerimientos de Funciones Opcionales (Optional Feature)

**SDD-HNP-060**
Donde el entorno de ejecución tenga el nivel de log configurado en `>= 10`, el sistema deberá emitir las trazas de depuración completas de los métodos `actualizar*()` incluyendo el índice actualizado.

**SDD-HNP-061**
Donde el entorno de ejecución tenga el nivel de log configurado en `< 10`, el sistema deberá suprimir todas las trazas de los métodos `actualizar*()` sin afectar la actualización de estado.

---

## 7. Requerimientos Complejos (Combinados)

**SDD-HNP-070**
Mientras la aplicación esté en la sección "Propiedades" (`indiceInicial == 1`), cuando el sistema de geolocalización determine el código postal del usuario y la API de localidades responda con código `200`, el sistema deberá llamar a `actualizarNivelGobierno(3)` para establecer el filtro de Código Postal como el ámbito geográfico activo.

**SDD-HNP-071**
Mientras la sesión del usuario esté autenticada y la sección activa sea "Mi Cuenta" (`indiceInicial == 3`), cuando el usuario cambie de pestaña en el sub-menú de promotor, el sistema deberá llamar a `actualizarMiCuenta(index)` emitiendo la traza de depuración nivel 10 y propagando el nuevo `indiceMiCuenta` a todos los widgets suscritos.

**SDD-HNP-072**
Mientras la aplicación esté en cualquier sección, cuando el `checaConeccionesProvider` emita un estado con `etiqueta != "Conectado"` y `_isErrorPageOpen == false`, el sistema deberá navegar a la ruta `/sinconeccion` sin actualizar el estado de `homeNavigationProvider`, preservando la posición de navegación para restaurarla al recuperar la conexión.

---

## 8. Tabla de Métodos y Contratos

| Método | Tipo | Campos modificados | Incrementa `version` | Emite log (nivel) |
|---|---|---|---|---|
| `setInicial(i)` | Directo | `indiceInicial` | ❌ | ❌ |
| `setPrincipal(i)` | Directo | `indicePrincipal` | ❌ | ❌ |
| `setGobierno(i)` | Directo | `indiceNivelGobierno` | ❌ | ❌ |
| `setEspacio(i)` | Directo | `indiceTipoEspacio` | ❌ | ❌ |
| `setTransaccion(i)` | Directo | `indiceTipoTransaccion` | ❌ | ❌ |
| `setMiCuenta(i)` | Directo | `indiceMiCuenta` | ❌ | ❌ |
| `setMiCuentaUsuario(i)` | Directo | `indiceMiCuentaUsuario` | ❌ | ❌ |
| `actualizarInicial(index)` | Con log | `indiceInicial`, `version` | ✅ | 10 |
| `actualizarPrincipal(index)` | Con log | `indicePrincipal`, `version` | ✅ | 10 |
| `actualizarNivelGobierno(index)` | Con log | `indiceNivelGobierno`, `version` | ✅ | 10 |
| `actualizarTipoEspacio(index)` | Con log | `indiceTipoEspacio`, `version` | ✅ | 10 |
| `actualizarTipoTransaccion(index)` | Con log | `indiceTipoTransaccion`, `version` | ✅ | 10 |
| `actualizarMiCuenta(index)` | Con log | `indiceMiCuenta`, `version` | ✅ | 10 |
| `actualizarMiCuentaUsuario(index)` | Con log | `indiceMiCuentaUsuario`, `version` | ✅ | 10 |

---

## 9. Dependencias y Restricciones

| Concepto | Detalle |
|---|---|
| **Anotación** | `@riverpod` (riverpod_annotation) |
| **Archivo generado** | `home_navigation_provider.g.dart` (no editar manualmente) |
| **Modelo de estado** | `HomeState` (`home_state.dart`) |
| **Dependencia de log** | `debugPrintLevels` de `lib/60_global_widgets/debugprint.dart` |
| **Regeneración** | `dart run build_runner build --delete-conflicting-outputs` |
| **Restricción de acceso de escritura** | Solo mediante `ref.read(homeNavigationProvider.notifier)` |
| **Restricción de acceso de lectura** | `ref.watch(homeNavigationProvider)` para widgets reactivos |

---

*Generado por ingeniería inversa — BuscoBien SDD v1.0 — 2026-08-06*
