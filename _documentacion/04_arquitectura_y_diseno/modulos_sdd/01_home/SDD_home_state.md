# SDD — `home_state.dart`
## Especificación Técnica: Modelo de Estado de Navegación (`HomeState`)
**Módulo:** `lib/01_home/home_state.dart`
**Patrón:** Freezed Immutable Data Class (Riverpod 3.x)
**Metodología:** EARS — Easy Approach to Requirements Syntax

---

## 1. Contexto y Propósito

`HomeState` es el **modelo de datos inmutable** que representa en todo momento el índice de menú activo en cada nivel de la jerarquía de navegación de la aplicación BuscoBien. No contiene lógica de negocio ni efectos secundarios. Es generado parcialmente por `freezed` + `build_runner`.

```
HomeState (Freezed)
├── indiceInicial         → Pestaña activa del menú de nivel superior
├── indicePrincipal       → Sub-pestaña activa en el flujo Propiedades
├── indiceNivelGobierno   → Filtro activo de ámbito geográfico
├── indiceTipoEspacio     → Categoría de espacio activa (Normal, Destacado…)
├── indiceTipoTransaccion → Tipo de transacción activa (Venta, Renta…)
├── indiceMiCuenta        → Sub-pestaña de Mi Cuenta (Promotor)
├── indiceMiCuentaUsuario → Sub-pestaña de Mi Cuenta (Usuario)
└── version               → Contador de versión (fuerza reactividad)
```

---

## 2. Requerimientos Ubicuos (Ubiquitous)

> Activos en todo momento, independientemente del estado del sistema.

**SDD-HS-001**
El sistema deberá representar el estado de navegación completo de la aplicación mediante una única instancia inmutable de `HomeState`.

**SDD-HS-002**
El sistema deberá inicializar todos los índices de `HomeState` con el valor `0` (cero) como valor por defecto (`@Default(0)`), garantizando un estado de arranque determinístico.

**SDD-HS-003**
El sistema deberá garantizar que ningún componente externo pueda mutar directamente las propiedades de `HomeState`; toda actualización deberá realizarse mediante el método `copyWith()` generado por Freezed.

**SDD-HS-004**
El sistema deberá implementar los operadores `==` y `hashCode` de forma que dos instancias de `HomeState` con los mismos valores de campo sean consideradas iguales, optimizando la detección de cambios en Riverpod.

**SDD-HS-005**
El sistema deberá exponer `HomeState` como una clase inmutable sellada (`@freezed`), de modo que no sea posible crear subclases externas no autorizadas.

**SDD-HS-006**
El sistema deberá proporcionar un método `toString()` que represente legiblemente todos los campos del estado para facilitar el diagnóstico y los logs de depuración.

---

## 3. Requerimientos Controlados por Eventos (Event-Driven)

> Se activan cuando y solo cuando ocurre un evento específico.

**SDD-HS-010**
Cuando el `HomeNavigation` notifier actualice cualquier índice de navegación, el sistema deberá producir una nueva instancia inmutable de `HomeState` mediante `state.copyWith(...)`, sin modificar el estado anterior.

**SDD-HS-011**
Cuando el campo `version` sea incrementado, el sistema deberá garantizar que Riverpod detecte el cambio de estado y notifique a todos los widgets que observan `homeNavigationProvider`, incluso si los demás campos permanecen sin cambios.

**SDD-HS-012**
Cuando `build_runner` sea ejecutado, el sistema deberá regenerar automáticamente los archivos `home_state.freezed.dart` y `home_navigation_provider.g.dart` reflejando cualquier cambio estructural en `HomeState`.

---

## 4. Requerimientos Controlados por Estados (State-Driven)

> Activos solo mientras el sistema se encuentra en un estado específico.

**SDD-HS-020**
Mientras `indiceInicial == 0`, el sistema deberá considerar la sección activa como "Inicio" (Landing Pages) y excluir el menú secundario `menuSuperiorMenuPrincipal` de la interfaz.

**SDD-HS-021**
Mientras `indiceInicial == 1`, el sistema deberá considerar la sección activa como "Propiedades" e incluir el sub-menú `menuSuperiorMenuPrincipal` para el filtrado por tipo de propiedad.

**SDD-HS-022**
Mientras `indiceInicial == 2`, el sistema deberá considerar la sección activa como "Ubicación" y mostrar `PaginaPrincipalListaLocalidades`.

**SDD-HS-023**
Mientras `indiceInicial == 3`, el sistema deberá considerar la sección activa como "Mi Cuenta" y delegar la vista al perfil de usuario activo (promotor, usuario comprador o invitado).

**SDD-HS-024**
Mientras `indiceInicial == 4`, el sistema deberá considerar la sección activa como "Perfil" y mostrar `PaginaPerfilWidget`.

---

## 5. Requerimientos de Comportamiento No Deseado (Unwanted Behaviour)

**SDD-HS-030**
Si algún componente intenta mutar directamente una propiedad de `HomeState` (por ejemplo, `state.indiceInicial = 2`), entonces el sistema deberá generar un error de compilación, dado que las propiedades Freezed son `final` y no admiten asignación directa.

**SDD-HS-031**
Si `build_runner` detecta conflictos entre el archivo fuente `home_state.dart` y el archivo generado `home_state.freezed.dart`, entonces el sistema deberá utilizar la bandera `--delete-conflicting-outputs` para resolver el conflicto automáticamente sin pérdida de datos del archivo fuente.

**SDD-HS-032**
Si el valor de `version` desborda el rango de `int` de Dart (extremadamente improbable), entonces el sistema deberá manejar el desbordamiento de forma silenciosa según el comportamiento nativo de Dart para enteros de 64 bits.

---

## 6. Requerimientos de Funciones Opcionales (Optional Feature)

**SDD-HS-040**
Donde el modelo `HomeState` requiera serialización JSON (por ejemplo, para persistir el estado de navegación en `SharedPreferences`), el sistema deberá incluir la anotación `@JsonSerializable` y regenerar `home_state.g.dart` con `build_runner`.

> **Nota:** En la versión actual, `HomeState` no implementa serialización JSON. El estado se reconstruye desde el almacenamiento local a través de `sessionProvider`.

---

## 7. Requerimientos Complejos (Combinados)

**SDD-HS-050**
Mientras el sistema esté en ejecución, cuando `HomeNavigation.actualizarNivelGobierno(index)` sea invocado, el sistema deberá producir una nueva instancia de `HomeState` con `indiceNivelGobierno = index` y `version = version + 1`, garantizando que todos los widgets suscritos se reconstruyan con el nuevo filtro geográfico.

**SDD-HS-051**
Mientras la sesión del usuario esté autenticada (`isAuthenticated = true`) y `indiceInicial == 3`, cuando el sistema determine que `nombrePerfil == "Promotor"`, el sistema deberá interpretar `indiceMiCuenta` como el índice activo del sub-menú de promotor (Espacios=0, Listas=1, Grupos=2, Conocidos=3).

**SDD-HS-052**
Mientras la sesión del usuario esté autenticada y `indiceInicial == 3`, cuando el sistema determine que `nombrePerfil == "Usuario"`, el sistema deberá interpretar `indiceMiCuentaUsuario` como el índice activo del sub-menú de usuario comprador (Listas=0, Grupos=1, Conocidos=2).

---

## 8. Especificación de Campos

| Campo | Tipo | Default | Rango válido | Descripción |
|---|---|---|---|---|
| `indiceInicial` | `int` | `0` | `0–4` | Sección principal activa del menú de nivel 1 |
| `indicePrincipal` | `int` | `0` | `0–3` | Sub-sección activa en el flujo de Propiedades |
| `indiceNivelGobierno` | `int` | `0` | `0–3` | Filtro geográfico (Federal/Estatal/Municipal/C.P.) |
| `indiceTipoEspacio` | `int` | `0` | `0–4` | Categoría de espacio (Normal/Destacado/Super/Oport./Remate) |
| `indiceTipoTransaccion` | `int` | `0` | `0–4` | Tipo de transacción (Todas/Venta/Renta/V-R/Traspaso) |
| `indiceMiCuenta` | `int` | `0` | `0–3` | Sub-sección de Mi Cuenta para perfil Promotor |
| `indiceMiCuentaUsuario` | `int` | `0` | `0–2` | Sub-sección de Mi Cuenta para perfil Usuario |
| `version` | `int` | `0` | `0–∞` | Contador de invalidación de caché reactiva |

---

## 9. Dependencias y Restricciones

| Concepto | Detalle |
|---|---|
| **Generador** | `freezed_annotation` + `build_runner` |
| **Archivo generado** | `home_state.freezed.dart` (no editar manualmente) |
| **Restricción de mutabilidad** | Todas las propiedades son `final`; no se permite mutación directa |
| **Convención de actualización** | Siempre usar `state.copyWith(campo: nuevoValor, version: state.version + 1)` |
| **Dependiente** | `home_navigation_provider.dart` (único consumidor del modelo) |

---

*Generado por ingeniería inversa — BuscoBien SDD v1.0 — 2026-08-06*
