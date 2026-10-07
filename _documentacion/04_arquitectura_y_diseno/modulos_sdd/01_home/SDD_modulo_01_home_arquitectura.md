# SDD — Módulo `lib/01_home` — Especificación de Arquitectura
## Especificación General del Módulo de Navegación Principal
**Módulo:** `lib/01_home/`
**Versión:** 1.0
**Metodología:** EARS — Easy Approach to Requirements Syntax
**Fecha:** 2026-08-06

---

## 1. Inventario de Archivos del Módulo

| Archivo | Tipo | Rol |
|---|---|---|
| `home_state.dart` | Fuente — Modelo Freezed | Define la estructura de datos inmutable del estado de navegación |
| `home_navigation_provider.dart` | Fuente — Riverpod Notifier | Define la lógica de mutación del estado de navegación |
| `home_state.freezed.dart` | Generado — Freezed | Implementaciones `copyWith`, `==`, `hashCode`, `toString` |
| `home_navigation_provider.g.dart` | Generado — Riverpod Generator | Provider global `homeNavigationProvider` y clase abstracta `_$HomeNavigation` |
| `inventario_01_home.md` | Documentación | Inventario técnico de componentes (mantenido por el equipo) |

---

## 2. Requerimientos Ubicuos (Ubiquitous)

> Aplican al módulo completo en todo momento.

**SDD-MOD-001**
El sistema deberá gestionar el estado de navegación completo de la aplicación BuscoBien mediante el módulo `01_home`, que actúa como la única fuente de verdad (`Single Source of Truth`) para los índices de menú activos en todos los niveles de la jerarquía de navegación.

**SDD-MOD-002**
El sistema deberá implementar el patrón de gestión de estado **Riverpod Notifier + Freezed**, garantizando inmutabilidad del estado, reactividad automática y testabilidad de cada componente de forma independiente.

**SDD-MOD-003**
El sistema deberá separar estrictamente las responsabilidades del módulo en dos capas:
- **Modelo de Datos** (`HomeState`): Estructura inmutable, sin lógica de negocio.
- **Notifier** (`HomeNavigation`): Lógica de mutación y efectos secundarios (logs).

**SDD-MOD-004**
El sistema deberá garantizar que ningún widget de la capa de presentación acceda o modifique el estado de navegación sin pasar por `homeNavigationProvider`.

**SDD-MOD-005**
El sistema deberá mantener el módulo `01_home` sin dependencias circulares; este módulo solo puede depender de:
- `freezed_annotation` (modelo)
- `riverpod_annotation` (provider)
- `lib/60_global_widgets/debugprint.dart` (utilidad de log)

---

## 3. Requerimientos Controlados por Eventos (Event-Driven)

**SDD-MOD-010**
Cuando un widget de la capa de presentación necesite leer el índice de menú activo, el sistema deberá usar exclusivamente `ref.watch(homeNavigationProvider)` para obtener el `HomeState` actual.

**SDD-MOD-011**
Cuando un widget de la capa de presentación necesite actualizar el índice de menú activo, el sistema deberá usar exclusivamente `ref.read(homeNavigationProvider.notifier).actualizar*(index)` para mutar el estado.

**SDD-MOD-012**
Cuando el módulo `01_home` sea importado por primera vez en la sesión de la aplicación, el sistema deberá inicializar `homeNavigationProvider` con el estado `HomeState(indiceInicial: 0)` y propagar ese estado a todos los widgets suscritos antes del primer frame de renderizado.

**SDD-MOD-013**
Cuando el comando `dart run build_runner build --delete-conflicting-outputs` sea ejecutado, el sistema deberá regenerar `home_state.freezed.dart` y `home_navigation_provider.g.dart` reflejando el estado actual de los archivos fuente.

---

## 4. Requerimientos Controlados por Estados (State-Driven)

**SDD-MOD-020**
Mientras la aplicación esté en ejecución, el sistema deberá mantener exactamente una instancia activa de `HomeNavigation` por `ProviderScope`, garantizando consistencia global del estado de navegación.

**SDD-MOD-021**
Mientras cualquier widget esté suscrito a `homeNavigationProvider`, el sistema deberá mantener el estado `HomeState` vivo en el `ProviderContainer` y no lo descartará por inactividad.

**SDD-MOD-022**
Mientras el sistema esté en modo de depuración (`kDebugMode`), el sistema deberá activar los logs de nivel 10 en los métodos `actualizar*()` para facilitar el rastreo del flujo de navegación.

---

## 5. Requerimientos de Comportamiento No Deseado (Unwanted Behaviour)

**SDD-MOD-030**
Si se detecta que un desarrollador ha editado manualmente `home_state.freezed.dart` o `home_navigation_provider.g.dart`, entonces el sistema (mediante la revisión de código) deberá revertir los cambios y regenerar los archivos con `build_runner`, dado que las ediciones manuales serán sobreescritas en la siguiente generación.

**SDD-MOD-031**
Si se agrega un nuevo campo a `HomeState` sin ejecutar `build_runner`, entonces el sistema deberá generar errores de compilación en todos los archivos que dependan de `HomeState`, alertando al desarrollador de la necesidad de regenerar el código.

**SDD-MOD-032**
Si el módulo `01_home` adquiere dependencias de capas superiores (por ejemplo, importar widgets de `02_principal_screen`), entonces el sistema deberá rechazar la modificación mediante revisión de código, para prevenir dependencias circulares.

---

## 6. Requerimientos de Funciones Opcionales (Optional Feature)

**SDD-MOD-040**
Donde el proyecto requiera pruebas unitarias del estado de navegación, el sistema deberá permitir la creación de un `ProviderContainer` independiente con `homeNavigationProvider.overrideWith(...)` para inicializar el provider con un estado de prueba predefinido.

**SDD-MOD-041**
Donde se requiera persistir el estado de navegación entre sesiones (guardar la última sección visitada), el sistema deberá extender `HomeState` con la anotación `@JsonSerializable` y agregar la lógica de lectura/escritura en `FlutterSecureStorage` o `SharedPreferences`.

> **Nota:** Esta funcionalidad no está implementada en la versión actual.

---

## 7. Requerimientos Complejos (Combinados)

**SDD-MOD-050**
Mientras la aplicación esté en ejecución y el módulo de geolocalización esté activo (`_locationRequested == true`), cuando la API de SEPOMEX responda con código `200` para un código postal detectado, el sistema deberá llamar a `homeNavigationProvider.notifier.actualizarNivelGobierno(3)` para sincronizar el filtro geográfico con la ubicación real del usuario, garantizando que el contenido de propiedades refleje inmediatamente el contexto geográfico local.

**SDD-MOD-051**
Mientras el usuario esté autenticado (`isAuthenticated = true` en `sessionProvider`) y navegue a la sección "Mi Cuenta" (`indiceInicial == 3`), cuando el perfil del usuario sea "Promotor" (`esPromotor == true`), el sistema deberá interpretar `indiceMiCuenta` como el índice del sub-menú de promotor y renderizar el widget correspondiente (`PaginaTusEspacios`, `PageMisListas`, `GruposView` o `ConocidosView`) pasando `userId` y `userName` como parámetros desde el `sessionProvider`.

---

## 8. Diagrama de Flujo de Datos

```
┌─────────────────────────────────────────────────────────┐
│                  UI (PrincipalSliversMenuInicial)        │
│                                                          │
│  ref.watch(homeNavigationProvider)  ──────────────────┐ │
│  ref.read(homeNavigationProvider.notifier).actualizar* │ │
└───────────────────────────────────┬───────────────────┘ │
                                    │                      │
                    ┌───────────────▼──────────────────┐  │
                    │   HomeNavigation (Notifier)        │  │
                    │   home_navigation_provider.dart    │  │
                    │                                    │  │
                    │   actualizar*(index) {             │  │
                    │     debugPrintLevels(10, ...)      │  │
                    │     state = state.copyWith(        │  │
                    │       campo: index,                │  │
                    │       version: version + 1         │  │
                    │     )                              │  │
                    │   }                                │  │
                    └───────────────┬──────────────────┘  │
                                    │                      │
                    ┌───────────────▼──────────────────┐  │
                    │   HomeState (Freezed Model)        │  │
                    │   home_state.dart                  │  │
                    │                                    │  │
                    │   indiceInicial: int (0)           │  │
                    │   indicePrincipal: int (0)         │  │
                    │   indiceNivelGobierno: int (0)     │  │
                    │   indiceTipoEspacio: int (0)       │  │
                    │   indiceTipoTransaccion: int (0)   │  │
                    │   indiceMiCuenta: int (0)          │  │
                    │   indiceMiCuentaUsuario: int (0)   │  │
                    │   version: int (0)                 │  │
                    └───────────────┬──────────────────┘  │
                                    │                      │
                    Riverpod notifica nuevo estado ────────┘
```

---

## 9. Mapa de Correspondencia Índice → Vista

### Menú Inicial (`indiceInicial`)

| Índice | Sección | Widget Renderizado |
|---|---|---|
| 0 | Inicio | `PageInicio` |
| 1 | Propiedades | `menuSuperiorMenuPrincipal` + `PaginaBuscaEspacios` |
| 2 | Ubicación | `PaginaPrincipalListaLocalidades` |
| 3 | Mi Cuenta | Depende del perfil (ver tabla inferior) |
| 4 | Perfil | `PaginaPerfilWidget` |

### Mi Cuenta — Promotor (`indiceMiCuenta`)

| Índice | Sección | Widget Renderizado |
|---|---|---|
| 0 | Mis Espacios | `PaginaTusEspacios` |
| 1 | Mis Listas | `PageMisListas` |
| 2 | Mis Grupos | `GruposView` |
| 3 | Mis Conocidos | `ConocidosView` |

### Mi Cuenta — Usuario (`indiceMiCuentaUsuario`)

| Índice | Sección | Widget Renderizado |
|---|---|---|
| 0 | Mis Listas | `PageMisListas` |
| 1 | Mis Grupos | `GruposView` |
| 2 | Mis Conocidos | `ConocidosView` |

### Nivel de Gobierno / Ámbito Geográfico (`indiceNivelGobierno`)

| Índice | Ámbito |
|---|---|
| 0 | Federal |
| 1 | Estatal |
| 2 | Municipal |
| 3 | Código Postal (C.P.) — activado automáticamente por GPS |

---

## 10. Decisiones de Diseño Documentadas

| ID | Decisión | Justificación |
|---|---|---|
| DD-01 | Separación entre `set*()` y `actualizar*()` | Los métodos `set*()` son para actualizaciones rápidas sin overhead de log; `actualizar*()` incluyen log nivel 10 para trazabilidad en desarrollo. |
| DD-02 | Incremento de `version` solo en `actualizar*()` | Los métodos `set*()` no incrementan `version` para evitar reconstrucciones de widgets en actualizaciones silenciosas. |
| DD-03 | Un único provider global | La navegación es un estado global de la app; no tiene sentido tener múltiples instancias del estado de navegación principal. |
| DD-04 | Sin lógica de validación de rango en el Notifier | La validación de qué índices son válidos es responsabilidad de los widgets de menú, no del Notifier, para mantener la separación de capas. |
| DD-05 | `debugPrintLevels` con nivel 10 | El nivel 10 es el más detallado; solo se activa cuando el desarrollador necesita trazar el flujo completo de navegación. |

---

*Generado por ingeniería inversa — BuscoBien SDD v1.0 — 2026-08-06*
