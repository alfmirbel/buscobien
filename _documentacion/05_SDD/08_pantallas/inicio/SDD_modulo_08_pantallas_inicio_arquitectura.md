# SDD — Módulo `lib/08_pantallas/inicio` — Especificación de Arquitectura
## Especificación General del Módulo de Pantalla de Búsqueda de Propiedades
**Módulo:** `lib/08_pantallas/inicio/`
**Versión:** 1.0
**Metodología:** EARS — Easy Approach to Requirements Syntax
**Fecha:** 2026-08-07

---

## 1. Inventario de Archivos del Módulo

| Archivo | Tipo | Rol |
|---|---|---|
| `pagina_inicio_busca_espacios.dart` | Fuente — Widget con Estado (`ConsumerStatefulWidget`) | Pantalla principal de búsqueda de propiedades; orquesta filtros, paginación, grid de resultados y navegación reactiva |
| `clase_busqueda_estado.dart` | Fuente — Riverpod `@riverpod` | Define providers `BusquedaPaginacion` y `SearchTerm` para gestión de paginación y término de búsqueda |
| `clase_busqueda_estado.g.dart` | Generado | Código generado por `riverpod_annotation` para `clase_busqueda_estado.dart` |
| `inicio_propiedades_providers.dart` | Fuente — Riverpod `@riverpod` | Define providers `PaginacionBusqueda` y `currentQuery`; consolida valores de menús en `VariablesViewQuery` |
| `inicio_propiedades_providers.g.dart` | Generado | Código generado por `riverpod_annotation` para `inicio_propiedades_providers.dart` |
| `http_find_propiedades_10en10.dart` | Fuente — Riverpod `@riverpod` | Provider que ejecuta la consulta HTTP a CouchDB para obtener propiedades paginadas (10 en 10) |
| `http_find_propiedades_10en10.g.dart` | Generado | Código generado por `riverpod_annotation` |
| `http_view_count_filter_propiedades.dart` | Fuente — Riverpod `@riverpod` | Provider que obtiene el conteo total de propiedades que coinciden con los filtros actuales |
| `http_view_count_filter_propiedades.g.dart` | Generado | Código generado por `riverpod_annotation` |
| `widget_wrap_modern_card.dart` | Fuente — Widget | Renderiza cada propiedad como tarjeta moderna en el grid `Wrap` |
| `data_espacios_casas.dart` | Fuente — Modelo de Datos | Define el modelo `EspaciosCasaGet` y `RowGetEspaciosCasa` para respuesta de propiedades |
| `data_espacios_casas_get.dart` | Fuente — Modelo de Datos | Define `DataGetValoresMenus` y estructuras relacionadas para valores de menú |
| `data_count_view_documentos.dart` | Fuente — Modelo de Datos | Modelo para el conteo de documentos/propiedades |
| `data_get_valores_menus.dart` | Fuente — Modelo de Datos | Define `VariablesViewQuery` y estructuras para consolidar filtros de menú |
| `catalogo_otras_caracteristicas.dart` | Fuente — Datos/Constantes | Catálogo de características adicionales para propiedades |

---

## 2. Requerimientos Ubicuos (Ubiquitous)

> Aplican al módulo completo en todo momento mientras la pantalla de búsqueda esté activa.

**SDD-INI-001**
El sistema deberá renderizar `PaginaBuscaEspacios` como pantalla de búsqueda de propiedades, orquestando la consulta paginada, los filtros y la presentación en grid.

**SDD-INI-002**
El sistema deberá gestionar el estado de búsqueda exclusivamente mediante Riverpod (`currentQueryProvider`, `findPropiedadesEstadosde10en10Provider`, `viewCountFilterPropiedadesProvider`, `busquedaPaginacionProvider`/`PaginacionBusqueda`), garantizando reactividad automática ante cambios en filtros.

**SDD-INI-003**
El sistema deberá mantener `paramSkip` como variable de paginación, sincronizada con el provider de paginación, para controlar el offset de la consulta HTTP.

**SDD-INI-004**
El sistema deberá escuchar `homeNavigationProvider` mediante `ref.listen` para detectar cambios en `indicePrincipal`, `indiceNivelGobierno`, `indiceTipoEspacio` e `indiceTipoTransaccion`, invalidando providers y reseteando paginación.

**SDD-INI-005**
El sistema deberá presentar las propiedades en un grid `Wrap` utilizando `WrapModernCardPropiedades`, adaptándose a diferentes tamaños de pantalla.

---

## 3. Requerimientos Controlados por Eventos (Event-Driven)

**SDD-INI-010**
Cuando `PaginaBuscaEspacios` se monte (`initState`), el sistema deberá crear `controllerSearch = TextEditingController()` y ejecutar `ref.read(busquedaPaginacionProvider.notifier).reset()` en un post-frame callback.

**SDD-INI-011**
Cuando el usuario presione el botón de página anterior en el paginador, el sistema deberá disminuir `paramSkip` en `numerodefichas` y ejecutar `setState(() {})` para disparar la recarga de propiedades.

**SDD-INI-012**
Cuando el usuario presione el botón de página siguiente en el paginador, el sistema deberá aumentar `paramSkip` en `numerodefichas` y ejecutar `setState(() {})` para disparar la recarga de propiedades.

**SDD-INI-013**
Cuando el usuario presione el FAB de mapa, el sistema deberá navegar a `AppRoutes.mapapropiedades` con `listaPropiedadesVar` como argumento, siempre que `mostrarmapa == true`.

**SDD-INI-014**
Cuando el usuario seleccione una transacción en el `NavigationRail` (pantallas anchas), el sistema deberá actualizar `menuTipoDeTransaccionProvider` y `homeNavigationProvider.actualizarTipoTransaccion(index)` dentro de `setState`.

**SDD-INI-015**
Cuando el usuario seleccione una transacción en `MenuInferiorTipoDeTransaccion` (pantallas cortas), el sistema deberá actualizar `menuTipoDeTransaccionProvider` y `homeNavigationProvider.actualizarTipoTransaccion(index)`.

**SDD-INI-016**
Cuando el usuario seleccione un tipo de propiedad en el dropdown "Otros", el sistema deberá actualizar `selectedDropDownMenuPrincipalValue`, ejecutar `_resetPaginacion()` y disparar una nueva consulta filtrada.

**SDD-INI-017**
Cuando `homeNavigationProvider` detecte un cambio en cualquier índice de filtro, el sistema deberá invalidar `viewCountFilterPropiedadesProvider`, `currentQueryProvider` y `findPropiedadesEstadosde10en10Provider`, y resetear `paramSkip` a 0.

**SDD-INI-018**
Cuando `viewCountFilterPropiedadesProvider` emita un nuevo valor, el sistema deberá actualizar el conteo total de propiedades y recalcular el estado de los botones de paginación.

**SDD-INI-019**
Cuando `currentQueryProvider` se invalide, el sistema deberá recalcular `VariablesViewQuery` con los valores actuales de todos los menús y proveer la nueva consulta a `findPropiedadesEstadosde10en10Provider`.

---

## 4. Requerimientos Controlados por Estados (State-Driven)

**SDD-INI-020**
Mientras `esPantallaCorta == true` y `indicePrincipal` está entre 0 y 3, el sistema deberá mostrar `MenuInferiorTipoDeTransaccion` como `bottomNavigationBar` y ocultar el `NavigationRail`.

**SDD-INI-021**
Mientras `esPantallaCorta == false` y `indicePrincipal` está entre 0 y 3, el sistema deberá mostrar `navigationRailTipoTransaccion()` en el lado izquierdo y ocultar el `bottomNavigationBar`.

**SDD-INI-022**
Mientras `indicePrincipal` esté entre 0 y 3, el sistema deberá mostrar `MenuSuperiorPaginaInicioNivelGobierno` y `MenuSuperiorPaginaTipoDeEspacios` en el `CustomScrollView`.

**SDD-INI-023**
Mientras `indicePrincipal == 3` ("Otros"), el sistema deberá mostrar `_buildDropdownOtros()` para permitir seleccionar el tipo específico de propiedad.

**SDD-INI-024**
Mientras `totalDoctos > 0`, el sistema deberá mostrar el paginador superior e inferior con los botones de navegación y el texto de rango.

**SDD-INI-025**
Mientras `listaDatos.rows.isEmpty`, el sistema deberá mostrar `_buildSinPropiedades()` con el texto "No hay propiedades que mostrar" y ocultar el FAB de mapa.

**SDD-INI-026**
Mientras `listaDatos.rows.isNotEmpty`, el sistema deberá mostrar `_buildGrid(listaPropiedadesVar)` con las tarjetas de propiedades y habilitar el FAB de mapa.

**SDD-INI-027**
Mientras `countAsync` esté en estado `loading`, el sistema deberá mostrar un `CircularProgressIndicator` centrado como contenido principal.

**SDD-INI-028**
Mientras `listaAsync` esté en estado `loading`, el sistema deberá mostrar un `LinearProgressIndicator` con `padding: EdgeInsets.all(20)` dentro del cuerpo.

**SDD-INI-029**
Mientras el usuario esté en la primera página (`paramSkip == 0`), el botón de página anterior debe estar deshabilitado (`onPressed: null`).

**SDD-INI-030**
Mientras el usuario esté en la última página (`paramSkip + numerodefichas >= total`), el botón de página siguiente debe estar deshabilitado (`onPressed: null`).

---

## 5. Requerimientos de Comportamiento No Deseado (Unwanted Behaviour)

**SDD-INI-030**
Si `viewCountFilterPropiedadesProvider` emite un estado `error`, entonces el sistema deberá mostrar `Center(child: Text("Error: $err"))` y no intentar cargar la lista de propiedades.

**SDD-INI-031**
Si `findPropiedadesEstadosde10en10Provider` emite un estado `error`, entonces el sistema deberá mostrar `Text("Error al cargar lista: $e")` y no mostrar tarjetas de propiedades.

**SDD-INI-032**
Si el usuario presiona el botón de página siguiente cuando ya está en la última página, entonces el sistema no debe incrementar `paramSkip` ni realizar una nueva petición HTTP.

**SDD-INI-033**
Si el usuario presiona el botón de página anterior cuando está en la primera página, entonces el sistema no debe disminuir `paramSkip` ni realizar una nueva petición HTTP.

**SDD-INI-034**
Si `localidadesPorCodigoPostalProvider` no tiene datos cuando se construye `currentQueryProvider`, entonces el sistema deberá manejar el caso sin lanzar excepciones, posiblemente usando valores por defecto o queries vacías.

**SDD-INI-035**
Si el usuario cambia filtros mientras una consulta HTTP está en progreso, entonces el sistema deberá cancelar o ignorar la respuesta anterior y priorizar la nueva consulta.

**SDD-INI-036**
Si `selectedDropDownMenuPrincipalValue` es null o vacío en la categoría "Otros", entonces el sistema no debe ejecutar la consulta y debe mostrar un estado de error o vacío.

---

## 6. Requerimientos de Funciones Opcionales (Optional Feature)

**SDD-INI-040**
Donde el usuario presione el FAB de mapa, el sistema deberá navegar a `PaginaMapaPropiedades` pasando `listaPropiedadesVar` como argumento para mostrar marcadores en el mapa.

**SDD-INI-041**
Donde el usuario esté en una pantalla ancha, el sistema deberá mostrar el `NavigationRail` lateral con íconos de tipos de transacción y labels expandidos.

**SDD-INI-042**
Donde el usuario esté en una pantalla corta, el sistema deberá mostrar el `MenuInferiorTipoDeTransaccion` en la parte inferior con íconos compactos.

**SDD-INI-043**
Donde `indicePrincipal == 3` ("Otros"), el sistema deberá mostrar el `DropdownButtonPropiedad` con `listaamostrar: false` para filtrar por tipos específicos de inmueble.

**SDD-INI-044**
Donde el usuario haga scroll en la lista de propiedades, el sistema deberá mantener los filtros `MenuSuperiorPaginaInicioNivelGobierno` y `MenuSuperiorPaginaTipoDeEspacios` visibles mediante `SliverAppBar` con `floating: true`.

**SDD-INI-045**
Donde `busquedaPaginacionProvider` esté disponible, el sistema deberá utilizarlo para gestionar el estado de paginación de forma reactiva, en lugar de manejar `paramSkip` exclusivamente con `setState`.

---

## 7. Requerimientos Complejos (Combinados)

**SDD-INI-050**
Mientras el usuario esté en `PaginaBuscaEspacios` con `esPantallaCorta == true` y `indicePrincipal` entre 0 y 3, cuando seleccione un tipo de transacción en `MenuInferiorTipoDeTransaccion`, el sistema deberá actualizar el provider de menú, sincronizar `homeNavigationProvider`, invalidar los providers de consulta y recargar la lista de propiedades desde la primera página.

**SDD-INI-051**
Mientras el usuario esté en `PaginaBuscaEspacios` con `esPantallaCorta == false` y `indicePrincipal` entre 0 y 3, cuando seleccione una transacción en `NavigationRail`, el sistema deberá actualizar el provider de menú, sincronizar `homeNavigationProvider`, invalidar `currentQueryProvider`, resetear `paramSkip` a 0 y recargar la lista.

**SDD-INI-052**
Mientras el usuario esté en `PaginaBuscaEspacios` con `indicePrincipal == 3`, cuando seleccione un tipo de propiedad en el dropdown "Otros", el sistema deberá actualizar `selectedDropDownMenuPrincipalValue`, ejecutar `_resetPaginacion()`, invalidar `currentQueryProvider` y `findPropiedadesEstadosde10en10Provider`, y mostrar la primera página del nuevo filtro.

**SDD-INI-053**
Mientras el usuario esté navegando por las páginas de resultados, cuando cambie cualquier filtro (nivel de gobierno, tipo de espacio, tipo de transacción), el sistema deberá resetear `paramSkip` a 0, invalidar todos los providers de datos y mostrar la primera página del nuevo resultado filtrado.

**SDD-INI-054**
Mientras `viewCountFilterPropiedadesProvider` esté cargando y `findPropiedadesEstadosde10en10Provider` esté cargando, cuando ambos completen exitosamente, el sistema deberá mostrar el paginador superior e inferior, el grid de propiedades y habilitar el FAB de mapa.

---

## 8. Diagrama de Flujo de Datos

```
┌─────────────────────────────────────────────────────────────────┐
│                    PaginaBuscaEspacios                          │
│                                                                 │
│  ┌─────────────┐    ┌──────────────┐    ┌──────────────────┐  │
│  │ initState   │    │  ref.listen  │    │  Conditional UI  │  │
│  │             │    │              │    │                  │  │
│  │ - Controller│    │ homeNav:     │    │  esPantallaCorta │  │
│  │   Search    │    │ invalida 3   │    │  → MenuInferior  │  │
│  │ - reset()   │    │ providers    │    │  !corta → Rail  │  │
│  │             │    │   + reset    │    │                  │  │
│  │             │    │   paramSkip  │    │  indicePrincipal │  │
│  │             │    │              │    │  ≤3 → Slivers    │  │
│  │             │    │              │    │  =3 → Dropdown   │  │
│  └─────────────┘    └──────────────┘    └──────────────────┘  │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
              ┌───────────────────────────────┐
              │        currentQuery            │
              │  ┌─────────────────────────┐  │
              │  │ VariablesViewQuery      │  │
              │  │ - etiquetaMenuPrincipal │  │
              │  │ - queryMenuPrincipal    │  │
              │  │ - etiquetaNivelGobierno │  │
              │  │ - queryNivelGobierno    │  │
              │  │ - etiquetaTipoDeEspacio │  │
              │  │ - queryTipoDeEspacio    │  │
              │  │ - etiquetaTipoTransac   │  │
              │  │ - queryTipoTransac      │  │
              │  │ - codigoPostal          │  │
              │  └─────────────────────────┘  │
              └───────────────────────────────┘
                              │
              ┌───────────────┼───────────────┐
              ▼               ▼               ▼
      ┌─────────────┐ ┌─────────────┐ ┌─────────────┐
      │viewCountFilte│ │findPropiedad│ │PaginacionBusq│
      │rProvider     │ │es10en10Provi│ │Provider      │
      │ (countAsync) │ │der          │ │ (paramSkip)  │
      │ totalDoctos  │ │ (listaAsync)│ │              │
      └─────────────┘ └─────────────┘ └──────────────┘
                              │
                              ▼
              ┌───────────────────────────────┐
              │     Widgets de Filtros         │
              │  ┌─────────────────────────┐  │
              │  │ MenuSuperiorPaginaInicio│  │
              │  │ NivelGobierno           │  │
              │  │ (SliverAppBar)          │  │
              │  ├─────────────────────────┤  │
              │  │ MenuSuperiorPaginaTipo  │  │
              │  │ DeEspacios              │  │
              │  │ (SliverAppBar)          │  │
              │  ├─────────────────────────┤  │
              │  │ DropdownButtonPropiedad │  │
              │  │ (si indicePrincipal=3)  │  │
              │  └─────────────────────────┘  │
              └───────────────────────────────┘
                              │
                              ▼
              ┌───────────────────────────────┐
              │     Paginadores                │
              │  ┌─────────────────────────┐  │
              │  │ Superior: IconButton    │  │
              │  │ ← + "X-Y de Z" + →     │  │
              │  │ Inferior: IconButton    │  │
              │  │ ← + "X-Y de Z" + →     │  │
              │  └─────────────────────────┘  │
              └───────────────────────────────┘
                              │
                              ▼
              ┌───────────────────────────────┐
              │     Grid de Propiedades        │
              │  ┌─────────────────────────┐  │
              │  │ WrapModernCardPropiedades│ │
              │  │ (index, lista)          │ │
              │  │ spacing: 6.0            │ │
              │  │ runSpacing: 6.0         │ │
              │  └─────────────────────────┘  │
              └───────────────────────────────┘
```

---

## 9. Mapa de Correspondencia Elemento → Comportamiento

### Pantalla Principal de Búsqueda

| Elemento | Archivo | Comportamiento |
|---|---|---|
| `PaginaBuscaEspacios` | `pagina_inicio_busca_espacios.dart` | `ConsumerStatefulWidget` que recibe `HomeState posicionNueva` |
| `initState` | `pagina_inicio_busca_espacios.dart` | Inicializa `controllerSearch`, resetea paginación en post-frame callback |
| `ref.listen(homeNavigationProvider)` | `pagina_inicio_busca_espacios.dart` | Detecta cambios en filtros, invalida providers y resetea `paramSkip` |
| `FloatingActionButton` | `pagina_inicio_busca_espacios.dart` | Navega a mapa si `mostrarmapa == true` |
| `NavigationRail` | `pagina_inicio_busca_espacios.dart` | Filtro lateral de transacción en pantallas anchas |
| `MenuInferiorTipoDeTransaccion` | `pagina_inicio_busca_espacios.dart` | Filtro inferior de transacción en pantallas cortas |
| `CustomScrollView` | `pagina_inicio_busca_espacios.dart` | Contenedor principal con slivers de filtros y contenido |
| `MenuSuperiorPaginaInicioNivelGobierno` | `pagina_inicio_busca_espacios.dart` | Sliver con tabs de nivel de gobierno |
| `MenuSuperiorPaginaTipoDeEspacios` | `pagina_inicio_busca_espacios.dart` | Sliver con tabs de tipo de espacio |
| `_buildDropdownOtros` | `pagina_inicio_busca_espacios.dart` | Dropdown para tipo de propiedad "Otros" |
| `_buildPaginador` | `pagina_inicio_busca_espacios.dart` | Paginador superior e inferior con botones y rango |
| `_buildGrid` | `pagina_inicio_busca_espacios.dart` | Grid `Wrap` de propiedades |
| `_buildSinPropiedades` | `pagina_inicio_busca_espacios.dart` | Estado vacío "No hay propiedades que mostrar" |

### Providers de Datos

| Provider | Archivo | Tipo | Comportamiento |
|---|---|---|---|
| `currentQuery` | `inicio_propiedades_providers.dart` | `@riverpod` | Consolida filtros de menús en `VariablesViewQuery` con queries Mango |
| `PaginacionBusqueda` | `inicio_propiedades_providers.dart` | `@riverpod` | Gestiona `paramSkip` con métodos `avanzar`, `retroceder`, `reset` |
| `BusquedaPaginacion` | `clase_busqueda_estado.dart` | `@riverpod` | Alternativa de paginación con `setSkip` y `reset` |
| `SearchTerm` | `clase_busqueda_estado.dart` | `@riverpod` | Gestiona término de búsqueda (opcional) |
| `findPropiedadesEstadosde10en10Provider` | `http_find_propiedades_10en10.dart` | `@riverpod` | Ejecuta consulta HTTP paginada a CouchDB |
| `viewCountFilterPropiedadesProvider` | `http_view_count_filter_propiedades.dart` | `@riverpod` | Obtiene conteo total de propiedades filtradas |

### Modelos de Datos

| Modelo | Archivo | Campos |
|---|---|---|
| `EspaciosCasaGet` | `data_espacios_casas.dart` | `offset`, `totalRows`, `rows: List<RowGetEspaciosCasa>` |
| `RowGetEspaciosCasa` | `data_espacios_casas.dart` | Datos de una propiedad individual |
| `VariablesViewQuery` | `data_get_valores_menus.dart` | `etiquetaMenuPrincipal`, `queryMenuPrincipal`, `etiquetaNivelGobierno`, `queryNivelGobierno`, `etiquetaTipoDeEspacio`, `queryTipoDeEspacio`, `etiquetaTipoDeTransaccion`, `queryTipoDeTransaccion`, `codigoPostal` |

---

## 10. Decisiones de Diseño Documentadas

| ID | Decisión | Justificación |
|---|---|---|
| DD-01 | `ConsumerStatefulWidget` para `PaginaBuscaEspacios` | Requiere `setState` para paginación (`paramSkip`) y actualización de `mostrarmapa` |
| DD-02 | `ref.listen` en lugar de `ref.watch` para `homeNavigationProvider` | Permite ejecutar lógica de invalidación de providers como side-effect sin causar rebuilds innecesarios |
| DD-03 | Dos providers de paginación (`PaginacionBusqueda` y `BusquedaPaginacion`) | `PaginacionBusqueda` está en uso; `BusquedaPaginacion` es una alternativa o versión anterior |
| DD-04 | `paramSkip` como variable local + `setState` | Combina reactividad de Riverpod con control manual del offset para paginación |
| DD-05 | `_resetPaginacion()` invalida 3 providers | Garantiza que cambios de filtro disparen consultas completamente nuevas |
| DD-06 | `currentQueryProvider` consolida filtros en `VariablesViewQuery` | Centraliza la lógica de construcción de queries Mango en un solo lugar |
| DD-07 | `Wrap` en lugar de `GridView` para propiedades | Permite layout más flexible y responsivo sin restricciones de columnas fijas |
| DD-08 | Paginador superior e inferior | Mejora la UX permitiendo navegación sin scroll hasta el final |
| DD-09 | `mostrarmapa` como booleano local | Controla la visibilidad del FAB de mapa sin necesidad de provider adicional |
| DD-10 | `esPantallaCorta` determinada por `MediaQuery` | Decide entre `NavigationRail` y `MenuInferiorTipoDeTransaccion` según ancho de pantalla |
| DD-11 | `ConstrainedBox` con `desktopContentMaxWidth` | Limita el ancho del contenido en pantallas grandes para mantener legibilidad |
| DD-12 | `SliverAppBar` flotante para filtros | Maximiza espacio de contenido; los filtros reaparecen al deslizar hacia arriba |
| DD-13 | `countAsync.when` para estados de carga/error | Patrón nativo de Riverpod para manejo de estados asíncronos |
| DD-14 | `selectedDropDownMenuPrincipalValue` global | Mantiene compatibilidad con lógica existente de dropdown de tipos de propiedad |
| DD-15 | `AddPostFrameCallback` en `initState` para reset de paginación | Evita modificar providers durante el ciclo de vida de inicialización del widget |

---

*Generado por ingeniería inversa — BuscoBien SDD v1.0 — 2026-08-07*
