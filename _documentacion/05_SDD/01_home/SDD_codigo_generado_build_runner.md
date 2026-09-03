# SDD — `home_state.freezed.dart` + `home_navigation_provider.g.dart`
## Especificación Técnica: Código Generado por `build_runner`
**Módulos:** `lib/01_home/home_state.freezed.dart` · `lib/01_home/home_navigation_provider.g.dart`
**Patrón:** Código generado automáticamente — No editar manualmente
**Metodología:** EARS — Easy Approach to Requirements Syntax

---

## 1. Contexto y Propósito

Los archivos generados son artefactos de código producidos automáticamente por las herramientas `freezed` y `riverpod_generator` a través de `build_runner`. Su única fuente de verdad son los archivos fuente `home_state.dart` y `home_navigation_provider.dart`. Este documento especifica el comportamiento que dichos artefactos deben satisfacer.

```
home_state.dart          →  [build_runner + freezed]   →  home_state.freezed.dart
home_navigation_provider.dart  →  [build_runner + riverpod_generator]  →  home_navigation_provider.g.dart
```

---

## 2. Requerimientos Ubicuos (Ubiquitous)

> Activos en todo momento, independientemente del estado del sistema.

**SDD-GEN-001**
El sistema deberá garantizar que `home_state.freezed.dart` y `home_navigation_provider.g.dart` sean siempre consistentes con sus archivos fuente correspondientes; cualquier divergencia deberá resultar en un error de compilación.

**SDD-GEN-002**
El sistema deberá tratar los archivos generados como artefactos de solo lectura; ningún desarrollador deberá editar manualmente `*.freezed.dart` ni `*.g.dart`.

**SDD-GEN-003**
El sistema deberá incluir los archivos `*.freezed.dart` y `*.g.dart` en el control de versiones (git) como parte del repositorio, dado que su ausencia impediría la compilación en entornos sin `build_runner` configurado.

---

## 3. Requerimientos Controlados por Eventos (Event-Driven)

### 3.1 Generación del código Freezed (`home_state.freezed.dart`)

**SDD-GEN-010**
Cuando `build_runner` se ejecute (`dart run build_runner build`), el sistema deberá generar el mixin `_$HomeState` que implementa `copyWith`, `==`, `hashCode` y `toString` para la clase `HomeState`.

**SDD-GEN-011**
Cuando `build_runner` genere `home_state.freezed.dart`, el sistema deberá crear la clase concreta sellada `_HomeState` que implementa la interfaz definida por el constructor de fábrica `const factory HomeState(...)`.

**SDD-GEN-012**
Cuando se invoque `HomeState(...).copyWith(campo: nuevoValor)`, el sistema deberá retornar una nueva instancia de `_HomeState` con el campo modificado y todos los demás campos preservados desde la instancia original.

**SDD-GEN-013**
Cuando se comparen dos instancias de `HomeState` con el operador `==`, el sistema deberá retornar `true` únicamente si los ocho campos (`indiceInicial`, `indicePrincipal`, `indiceNivelGobierno`, `indiceTipoEspacio`, `indiceTipoTransaccion`, `indiceMiCuenta`, `indiceMiCuentaUsuario`, `version`) tienen valores iguales.

**SDD-GEN-014**
Cuando se calcule el `hashCode` de una instancia de `HomeState`, el sistema deberá combinar los valores de los ocho campos en un único hash entero determinístico, de modo que instancias iguales (`==`) produzcan el mismo `hashCode`.

**SDD-GEN-015**
Cuando se genere la interfaz `_$HomeStateCopyWith`, el sistema deberá exponer métodos tipados para cada campo de `HomeState`, garantizando seguridad de tipos en tiempo de compilación durante los `copyWith`.

### 3.2 Generación del provider Riverpod (`home_navigation_provider.g.dart`)

**SDD-GEN-020**
Cuando `build_runner` se ejecute, el sistema deberá generar la variable global `homeNavigationProvider` de tipo `HomeNavigationProvider`, que actuará como identificador único del provider en el árbol de Riverpod.

**SDD-GEN-021**
Cuando `build_runner` genere `home_navigation_provider.g.dart`, el sistema deberá crear la clase `HomeNavigationProvider` que extiende `NotifierProvider<HomeNavigation, HomeState>`, garantizando compatibilidad con la API de Riverpod 3.x.

**SDD-GEN-022**
Cuando un widget llame a `ref.watch(homeNavigationProvider)`, el sistema deberá retornar la instancia actual de `HomeState` y registrar al widget como dependiente del provider para recibir notificaciones de cambio.

**SDD-GEN-023**
Cuando un widget llame a `ref.read(homeNavigationProvider.notifier)`, el sistema deberá retornar la instancia de `HomeNavigation` que gestiona el estado, permitiendo la invocación de métodos de mutación.

**SDD-GEN-024**
Cuando se genere la clase abstracta `_$HomeNavigation`, el sistema deberá exponer el método abstracto `build()` que deberá ser implementado por la clase concreta `HomeNavigation` para proveer el estado inicial.

---

## 4. Requerimientos Controlados por Estados (State-Driven)

**SDD-GEN-030**
Mientras el provider `homeNavigationProvider` esté activo en el árbol de widgets, el sistema deberá mantener una única instancia de `HomeNavigation` por `ProviderContainer` (scope), garantizando que todos los widgets compartan el mismo estado de navegación.

**SDD-GEN-031**
Mientras `homeNavigationProvider` esté siendo observado por al menos un widget (`ref.watch`), el sistema deberá mantener el estado `HomeState` vivo en memoria y no descartarlo.

**SDD-GEN-032**
Mientras el hash de depuración `_$homeNavigationHash` no coincida con el hash calculado del archivo fuente, el sistema deberá emitir una advertencia en tiempo de desarrollo indicando que el código generado está desactualizado.

---

## 5. Requerimientos de Comportamiento No Deseado (Unwanted Behaviour)

**SDD-GEN-040**
Si `home_state.dart` es modificado (agregar/eliminar/renombrar campos) sin ejecutar `build_runner`, entonces el sistema deberá generar errores de compilación en `home_state.freezed.dart` por referencias a campos inexistentes.

**SDD-GEN-041**
Si `home_navigation_provider.dart` es modificado sin ejecutar `build_runner`, entonces el sistema deberá generar errores de compilación en `home_navigation_provider.g.dart` por inconsistencias en la clase abstracta `_$HomeNavigation`.

**SDD-GEN-042**
Si un desarrollador intenta instanciar directamente `_HomeState` (clase privada generada), entonces el sistema deberá generar un error de compilación dado que la clase es interna al archivo generado y no está exportada.

**SDD-GEN-043**
Si el comando `build_runner` se ejecuta sin la bandera `--delete-conflicting-outputs` y existen conflictos entre archivos previos y nuevos, entonces el sistema deberá detenerse y notificar al desarrollador el conflicto sin sobreescribir silenciosamente.

---

## 6. Requerimientos de Funciones Opcionales (Optional Feature)

**SDD-GEN-050**
Donde el proyecto configure `riverpod_generator` con el parámetro `keepAlive: true` en la anotación `@riverpod`, el sistema deberá generar un provider que no sea descartado cuando no haya suscriptores activos.

> **Nota:** En la implementación actual de `home_navigation_provider.dart`, no se especifica `keepAlive`, por lo que el comportamiento de descarte sigue la política por defecto de Riverpod.

**SDD-GEN-051**
Donde el entorno de desarrollo incluya la extensión de Flutter para VS Code o Android Studio, el sistema deberá soportar la ejecución de `build_runner watch` para regenerar automáticamente los archivos al detectar cambios en los archivos fuente.

---

## 7. Requerimientos Complejos (Combinados)

**SDD-GEN-060**
Mientras el proyecto esté en modo de desarrollo, cuando se ejecute `dart run build_runner build --delete-conflicting-outputs`, el sistema deberá:
1. Eliminar los archivos `*.freezed.dart` y `*.g.dart` en conflicto.
2. Regenerar `home_state.freezed.dart` a partir de `home_state.dart`.
3. Regenerar `home_navigation_provider.g.dart` a partir de `home_navigation_provider.dart`.
4. Completar la compilación sin errores.

**SDD-GEN-061**
Mientras la aplicación esté en producción (modo release), cuando un widget llame a `ref.watch(homeNavigationProvider)`, el sistema deberá retornar el estado actual de `HomeState` en tiempo O(1) sin overhead de reflexión o generación dinámica, dado que el código generado es estático y resuelto en tiempo de compilación.

---

## 8. Estructura de Artefactos Generados

### `home_state.freezed.dart`

| Artefacto | Tipo | Descripción |
|---|---|---|
| `_$HomeState` | Mixin | Implementa `copyWith`, `==`, `hashCode`, `toString` |
| `_HomeState` | Clase concreta | Implementación sellada del constructor de fábrica |
| `_$HomeStateCopyWith` | Interfaz | Contrato tipado del método `copyWith` |
| `_$_HomeStateCopyWith` | Implementación | Implementación concreta de `copyWith` |

### `home_navigation_provider.g.dart`

| Artefacto | Tipo | Descripción |
|---|---|---|
| `_$homeNavigationHash` | `String` | Hash de integridad entre fuente y código generado |
| `homeNavigationProvider` | `HomeNavigationProvider` | Variable global del provider (punto de acceso) |
| `HomeNavigationProvider` | `NotifierProvider` | Proveedor tipado `<HomeNavigation, HomeState>` |
| `_$HomeNavigation` | Clase abstracta | Base de `HomeNavigation` con `build()` abstracto |

---

## 9. Instrucción de Regeneración

```powershell
# Ejecutar desde la raíz del proyecto D:\buscobien
dart run build_runner build --delete-conflicting-outputs
```

> **Cuándo regenerar:**
> - Al agregar, eliminar o renombrar cualquier campo en `HomeState`
> - Al agregar, eliminar o renombrar cualquier método en `HomeNavigation`
> - Al cambiar la anotación `@riverpod` o `@freezed`
> - Al actualizar las versiones de `freezed_annotation`, `riverpod_annotation` o `riverpod_generator`

---

*Generado por ingeniería inversa — BuscoBien SDD v1.0 — 2026-08-06*
