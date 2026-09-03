# Inventario de Componentes — 01_home

**Directorio:** `lib/01_home/`  
**Archivos:** `home_state.dart`, `home_navigation_provider.dart` (+ `.freezed.dart`, `.g.dart` generados)  
**Fecha:** 2026-08-12

---

## Tabla 1: Componentes (por archivo)

| Subdirectorio | Nombre del archivo | Tipo de componente | Nombre del componente | Parámetros que requiere | Variables que utiliza | Variables internas | Estilos que le aplican |
|---------------|-------------------|-------------------|----------------------|------------------------|----------------------|-------------------|------------------------|
| 01_home | `home_state.dart` | Clase modelo (@freezed) | `HomeState` | Constructor factory con 8 `@Default(0)`: `indiceInicial`, `indicePrincipal`, `indiceNivelGobierno`, `indiceTipoEspacio`, `indiceTipoTransaccion`, `indiceMiCuenta`, `indiceMiCuentaUsuario`, `version` | `freezed_annotation` | 8 propiedades inmutables (getters) | — |
| 01_home | `home_state.dart` | Clase privada | `_HomeState` | — | `freezed_annotation` | Getters override lanzan `UnimplementedError` | — |
| 01_home | `home_navigation_provider.dart` | Notifier (@riverpod) | `HomeNavigation` extends `_$HomeNavigation` | — | `HomeState`, `debugPrintLevels` | `state` (HomeState heredado) | `state.copyWith()`, `debugPrintLevels(10, ...)` |
| 01_home | `home_state.freezed.dart` | Código generado | Mixin `_$HomeState`, Clase `_HomeState`, Copiadores | Autogenerado | `freezed_annotation` | `copyWith`, `toString`, `==`, `hashCode` | — |
| 01_home | `home_navigation_provider.g.dart` | Código generado | `homeNavigationProvider`, `HomeNavigationProvider`, `_$HomeNavigation` | Autogenerado | `riverpod_annotation`, `HomeNavigation`, `HomeState` | Hash debug, `create`, `runBuild`, `overrideWithValue` | — |

---

## Tabla 2: Elementos (por archivo)

| Subdirectorio | Nombre del archivo | Variables definidas en el archivo | Clases | Variables de la clase | Funciones o widgets definidos en la clase | Variables que utiliza | Llamadas a otras clases o widgets |
|---------------|-------------------|----------------------------------|--------|----------------------|------------------------------------------|----------------------|----------------------------------|
| 01_home | `home_state.dart` | — | `HomeState` (con `@freezed`) | `indiceInicial`, `indicePrincipal`, `indiceNivelGobierno`, `indiceTipoEspacio`, `indiceTipoTransaccion`, `indiceMiCuenta`, `indiceMiCuentaUsuario`, `version` (todos `int` `@Default(0)`) | Constructor factory `HomeState()`, constructor privado `HomeState._()` | `freezed_annotation` | `copyWith` (generado), `==`, `hashCode`, `toString` (generados) |
| 01_home | `home_navigation_provider.dart` | — | `HomeNavigation` (@riverpod) | `state` (HomeState) | `build() → HomeState(indiceInicial: 0)`, `setInicial(i)`, `setPrincipal(i)`, `setGobierno(i)`, `setEspacio(i)`, `setTransaccion(i)`, `setMiCuenta(i)`, `setMiCuentaUsuario(i)`, `actualizarInicial(index)`, `actualizarPrincipal(index)`, `actualizarNivelGobierno(index)`, `actualizarTipoEspacio(index)`, `actualizarTipoTransaccion(index)`, `actualizarMiCuenta(index)`, `actualizarMiCuentaUsuario(index)` | `HomeState`, `debugPrintLevels` | `state.copyWith()`, `debugPrintLevels(10, "*************** ACTUALIZA PROVIDERS ...")` |