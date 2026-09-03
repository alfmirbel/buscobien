# SDD — Módulo `lib/05_provider_menus` — Especificación de Arquitectura
## Especificación General del Módulo de Menús y Navegación
**Módulo:** `lib/05_provider_menus/`
**Versión:** 1.0
**Metodología:** EARS — Easy Approach to Requirements Syntax
**Fecha:** 2026-08-07

---

## 1. Inventario de Archivos del Módulo

| Archivo | Tipo | Rol |
|---|---|---|
| `variables_menus.dart` | Fuente — Constantes | Define dimensiones globales de menús: `menuToolbarHeight`, `menuTabIconSize`, `menuTabLabelSize`, etc. |
| `provider_menu_inicial.dart` | Fuente — Riverpod `StateNotifierProvider` | Gestiona el menú inicial (Inicio, Propiedades, Ubicación, Mi Cuenta, Perfil) con 5 tabs |
| `provider_menu_principal.dart` | Fuente — Riverpod `StateNotifierProvider` | Gestiona el sub-menú de Propiedades (Todas, Casas, Departamentos, Otros) con 4 tabs |
| `provider_menu_nivel_gobierno.dart` | Fuente — Riverpod `StateNotifierProvider` | Gestiona el filtro de nivel de gobierno (Nacional, Estado, Municipio, C.P., Localidad) con 5 tabs |
| `provider_menu_tipo_espacio.dart` | Fuente — Riverpod `StateNotifierProvider` | Gestiona el filtro de tipo de espacio (Normales, Destacados, Superdestacados, Oportunidades, Remates) con 5 tabs |
| `provider_menu_tipo_de_transaccion.dart` | Fuente — Riverpod `StateNotifierProvider` | Gestiona el filtro de tipo de transacción (Todas, Venta, Renta, Venta/Renta, Traspaso) con 5 tabs |
| `provider_menu_tu_cuenta.dart` | Fuente — Riverpod `StateNotifierProvider` | Gestiona el menú de Mi Cuenta para promotores (Espacios, Listas, Grupos, Conocidos) con 4 tabs |
| `provider_menu_tu_cuenta_usuario.dart` | Fuente — Riverpod `StateNotifierProvider` | Gestiona el menú de Mi Cuenta para usuarios (Listas, Grupos, Conocidos) con 3 tabs |
| `appbar_sliver_menu_inicial.dart` | Fuente — Widget (`SliverAppBar`) | Renderiza el menú inicial como `SliverAppBar` con `ButtonsTabBar`, `pinned: true` |
| `appbar_sliver_menu_principal.dart` | Fuente — Widget (`SliverAppBar`) | Renderiza el sub-menú de Propiedades como `SliverAppBar` con `ButtonsTabBar`, `pinned: false, floating: true` |
| `appbar_sliver_menu_nivel_gobierno.dart` | Fuente — Widget (`ConsumerWidget` + `SliverAppBar`) | Renderiza el menú de nivel de gobierno con etiquetas dinámicas de localidad |
| `appbar_sliver_menu_tipo_espacio.dart` | Fuente — Widget (`ConsumerWidget` + `SliverAppBar`) | Renderiza el menú de tipo de espacio como `SliverAppBar` con `ButtonsTabBar`, `floating: true` |
| `appbar_menu_tu_cuenta.dart` | Fuente — Widget (`ConsumerWidget` + `SliverAppBar`) | Renderiza el menú de Mi Cuenta para promotores, `pinned: true` |
| `appbar_menu_tu_cuenta_usuario.dart` | Fuente — Widget (`ConsumerWidget` + `SliverAppBar`) | Renderiza el menú de Mi Cuenta para usuarios, `pinned: true` |
| `appbar_menu_tipo_transaccion_inferior.dart` | Fuente — Widget con Estado (`ConsumerStatefulWidget`) | Renderiza el menú inferior de tipo de transacción en un `Container` con `ButtonsTabBar` |
| `dropdown_menu_principal_propiedades.dart` | Fuente — Widget con Estado (`ConsumerStatefulWidget`) | Renderiza un `DropdownButton` para seleccionar tipo de propiedad, con lista completa o reducida |

---

## 2. Requerimientos Ubicuos (Ubiquitous)

> Aplican al módulo completo en todo momento mientras la pantalla principal esté activa.

**SDD-MEN-001**
El sistema deberá gestionar el estado de todos los menús exclusivamente mediante `StateNotifierProvider` de Riverpod, garantizando reactividad automática ante cambios en las selecciones.

**SDD-MEN-002**
El sistema deberá sincronizar cada cambio de selección de menú con `homeNavigationProvider`, actualizando el índice correspondiente (`indiceInicial`, `indicePrincipal`, `indiceNivelGobierno`, `indiceTipoEspacio`, `indiceTipoTransaccion`, `indiceMiCuenta`, `indiceMiCuentaUsuario`).

**SDD-MEN-003**
El sistema deberá mantener un `TabController` por cada menú, inicializado en `inicializaController` y dispuesto en `disposeController` para evitar fugas de memoria.

**SDD-MEN-004**
El sistema deberá utilizar `ButtonsTabBar` como componente visual de tabs en todos los menús, con estilos consistentes definidos en `variables_menus.dart` y `var_de_estilo_widgets.dart`.

**SDD-MEN-005**
El sistema deberá mantener la separación entre la lógica de estado (`provider_menu_*.dart`) y la presentación (`appbar_*.dart`), sin mezclar responsabilidades de negocio en la capa de UI.

---

## 3. Requerimientos Controlados por Eventos (Event-Driven)

**SDD-MEN-010**
Cuando el usuario presione un tab en el `ButtonsTabBar` del menú inicial, el sistema deberá invocar `asignaNuevaOpcionSeleccionada(ref, index)` y `actualizarInicial(index)`.

**SDD-MEN-011**
Cuando el usuario presione un tab en el `ButtonsTabBar` del menú principal, el sistema deberá invocar `asignaNuevaOpcionSeleccionada(ref, index)` y `actualizarPrincipal(index)`.

**SDD-MEN-012**
Cuando el usuario presione un tab en el `ButtonsTabBar` del menú de nivel de gobierno, el sistema deberá invocar `asignaNuevaOpcionSeleccionada(ref, index)` y `actualizarNivelGobierno(index)`.

**SDD-MEN-013**
Cuando el usuario presione un tab en el `ButtonsTabBar` del menú de tipo de espacio, el sistema deberá invocar `asignaNuevaOpcionSeleccionada(ref, index)` y `actualizarTipoEspacio(index)`.

**SDD-MEN-014**
Cuando el usuario presione un tab en el `ButtonsTabBar` del menú inferior de tipo de transacción, el sistema deberá invocar `asignaNuevaOpcionSeleccionada(ref, index)` y `actualizarTipoTransaccion(index)`.

**SDD-MEN-015**
Cuando el usuario presione un tab en el `ButtonsTabBar` del menú de Mi Cuenta (promotor), el sistema deberá invocar `asignaNuevaOpcionSeleccionada(ref, index)` y `actualizarMiCuenta(index)`.

**SDD-MEN-016**
Cuando el usuario presione un tab en el `ButtonsTabBar` del menú de Mi Cuenta (usuario), el sistema deberá invocar `asignaNuevaOpcionSeleccionada(ref, index)` y `actualizarMiCuentaUsuario(index)`.

**SDD-MEN-017**
Cuando `MenuSuperiorPaginaInicioNivelGobierno` se monte, el sistema deberá escuchar `localidadesPorCodigoPostalProvider` y construir etiquetas dinámicas para los tabs de nivel de gobierno según la localidad seleccionada.

**SDD-MEN-018**
Cuando `MenuInferiorTipoDeTransaccion` se monte (`initState`), el sistema deberá invocar `inicializaController(this)`, `asignaNuevaOpcionSeleccionada(ref, seleccionMenuTipoDePublicacion)` y `restableceOpcionActualSeleccionada(ref)`.

**SDD-MEN-019**
Cuando `DropdownButtonPropiedad` se cree (`createState`), el sistema deberá ejecutar `debugPrintLevels` para registrar la creación en modo debug.

**SDD-MEN-020**
Cuando el usuario seleccione un valor en `DropdownButtonPropiedad`, el sistema deberá actualizar `_currentValue`, `selectedDropDownMenuPrincipalValue` y ejecutar `widget.onChangedCallback(newValue)`.

**SDD-MEN-021**
Cuando `valorInicial` cambie en `DropdownButtonPropiedad`, el sistema deberá detectar el cambio en `didUpdateWidget` y actualizar `_currentValue` al nuevo valor.

---

## 4. Requerimientos Controlados por Estados (State-Driven)

**SDD-MEN-020**
Mientras se renderiza el menú inicial, el sistema deberá mostrar un `SliverAppBar` con `pinned: true`, `backgroundColor: appTheme.surface`, `toolbarHeight: 0` y un `ButtonsTabBar` con 5 tabs.

**SDD-MEN-021**
Mientras se renderiza el menú principal, el sistema deberá mostrar un `SliverAppBar` con `pinned: false`, `floating: true`, `snap: false` y un `ButtonsTabBar` con 4 tabs.

**SDD-MEN-022**
Mientras se renderiza el menú de nivel de gobierno, el sistema deberá mostrar un `SliverAppBar` con `pinned: false`, `floating: true` y etiquetas dinámicas: "México", estado, municipio, C.P., localidad.

**SDD-MEN-023**
Mientras se renderiza el menú de tipo de espacio, el sistema deberá mostrar un `SliverAppBar` con `pinned: false`, `floating: true` y 5 tabs con íconos y etiquetas de espacio.

**SDD-MEN-024**
Mientras se renderiza el menú inferior de tipo de transacción, el sistema deberá mostrar un `Container` con `height: menuToolbarHeight * 1.8` y un `ButtonsTabBar` con 5 tabs.

**SDD-MEN-025**
Mientras se renderiza el menú de Mi Cuenta (promotor), el sistema deberá mostrar un `SliverAppBar` con `pinned: true` y 4 tabs: Espacios, Listas, Grupos, Conocidos.

**SDD-MEN-026**
Mientras se renderiza el menú de Mi Cuenta (usuario), el sistema deberá mostrar un `SliverAppBar` con `pinned: true` y 3 tabs: Listas, Grupos, Conocidos.

**SDD-MEN-027**
Mientras `homeNavigationProvider` emita cambios, el sistema deberá actualizar los `TabController` de todos los menús mediante `restableceOpcionActualSeleccionada(ref)`.

**SDD-MEN-028**
Mientras el usuario interactúe con cualquier `ButtonsTabBar`, el sistema deberá mantener el `buttonSelectOpcion` sincronizado: solo el tab seleccionado tiene `true`, los demás `false`.

**SDD-MEN-029**
Mientras `localidadesPorCodigoPostalProvider` tenga datos, el sistema deberá mostrar las etiquetas dinámicas del menú de nivel de gobierno: estado, municipio, C.P., asentamiento.

**SDD-MEN-030**
Mientras `listaamostrar` sea `true` en `DropdownButtonPropiedad`, el sistema deberá mostrar `listaTipoInmuebles`; mientras sea `false`, deberá mostrar `otrosTiposDeInmueble`.

---

## 5. Requerimientos de Comportamiento No Deseado (Unwanted Behaviour)

**SDD-MEN-030**
Si el usuario presiona un tab con índice fuera del rango válido del menú, entonces el sistema deberá ignorar el evento y no actualizar el provider ni `homeNavigationProvider`.

**SDD-MEN-031**
Si `TabController` no está inicializado cuando se intenta cambiar de tab, entonces el sistema deberá ignorar la solicitud y no lanzar excepciones.

**SDD-MEN-032**
Si `localidadesPorCodigoPostalProvider` retorna `rows.isEmpty`, entonces el sistema deberá mostrar "Sin Estado", "Sin Municipio", "Sin C.P.", "Sin localidad" en las etiquetas del menú de nivel de gobierno.

**SDD-MEN-033**
Si `localidadesPorCodigoPostalProvider` retorna `codigoPostal == 0`, entonces el sistema deberá mostrar "Sin C.P." en la etiqueta correspondiente.

**SDD-MEN-034**
Si `DropdownButtonPropiedad` recibe `newValue == null` en `onChanged`, entonces el sistema no debe actualizar `_currentValue` ni ejecutar el callback.

**SDD-MEN-035**
Si `valorInicial` cambia a un valor que no existe en `listaDeTiposDeInmueble`, entonces el sistema deberá mantener `_currentValue` con el valor anterior válido.

**SDD-MEN-036**
Si `ButtonTabBar` recibe un `controller` con `length` diferente al número de tabs generados, entonces el sistema deberá lanzar una excepción de Flutter; se previene garantizando que ambos valores sean consistentes.

---

## 6. Requerimientos de Funciones Opcionales (Optional Feature)

**SDD-MEN-040**
Donde el menú de nivel de gobierno incluya la opción "Zona", el sistema deberá agregar un sexto tab con etiqueta dinámica de zona, actualizando `listNivelesDeGobierno` y `elementosMenuNivelDeGobierno`.

**SDD-MEN-041**
Donde el menú de tipo de transacción incluya "Preventa", el sistema deberá agregar un sexto tab con icono `iconoPreventa` y etiqueta correspondiente.

**SDD-MEN-042**
Donde `DropdownButtonPropiedad` se utilice en modo edición, el sistema deberá exponer el parámetro `valorInicial` para pre-seleccionar el tipo de propiedad existente.

**SDD-MEN-043**
Donde `MenuSuperiorPaginaInicioNivelGobierno` se renderice, el sistema deberá utilizar un `GlobalKey` para prevenir errores de AXTree al cambiar de pestañas.

**SDD-MEN-044**
Donde `MenuSuperiorPaginaTipoDeEspacios` se renderice, el sistema deberá envolver el `ButtonsTabBar` en un `ExcludeSemantics` para mejorar la accesibilidad.

---

## 7. Requerimientos Complejos (Combinados)

**SDD-MEN-050**
Mientras el usuario esté en la pantalla principal y cambie de sección mediante el menú inicial, cuando seleccione "Propiedades", el sistema deberá actualizar `menuInicialProvider`, `homeNavigationProvider.indiceInicial`, mostrar `menuSuperiorMenuPrincipal` y restablecer los filtros de nivel de gobierno, tipo de espacio y tipo de transacción a sus valores por defecto.

**SDD-MEN-051**
Mientras el usuario esté en la sección "Propiedades" y aplique filtros de nivel de gobierno, tipo de espacio y tipo de transacción, cuando cambie cualquiera de estos filtros, el sistema deberá actualizar el provider correspondiente, sincronizar `homeNavigationProvider` y disparar la consulta de propiedades filtradas.

**SDD-MEN-052**
Mientras el usuario esté en la sección "Mi Cuenta" como promotor, cuando cambie entre Espacios, Listas, Grupos y Conocidos, el sistema deberá actualizar `menuTuCuentaProvider`, sincronizar `homeNavigationProvider.indiceMiCuenta` y mostrar la sub-vista correspondiente.

**SDD-MEN-053**
Mientras el usuario esté en la sección "Mi Cuenta" como usuario, cuando cambie entre Listas, Grupos y Conocidos, el sistema deberá actualizar `menuTuCuentaUsuarioProvider`, sincronizar `homeNavigationProvider.indiceMiCuentaUsuario` y mostrar la sub-vista correspondiente.

**SDD-MEN-054**
Mientras el usuario esté en el menú de nivel de gobierno y seleccione una localidad específica, cuando `localidadesPorCodigoPostalProvider` se actualice con nuevos datos, el sistema deberá reconstruir las etiquetas de los tabs con la información de estado, municipio, C.P. y asentamiento.

---

## 8. Diagrama de Flujo de Datos

```
┌─────────────────────────────────────────────────────────────────┐
│                    homeNavigationProvider                       │
│  ┌─────────────────────────────────────────────────────────┐  │
│  │ HomeState                                               │  │
│  │ - indiceInicial: int                                    │  │
│  │ - indicePrincipal: int                                  │  │
│  │ - indiceNivelGobierno: int                              │  │
│  │ - indiceTipoEspacio: int                                │  │
│  │ - indiceTipoTransaccion: int                            │  │
│  │ - indiceMiCuenta: int                                   │  │
│  │ - indiceMiCuentaUsuario: int                            │  │
│  └─────────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│              Providers de Estado de Menús                       │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐            │
│  │menuInicial  │  │menuPrincipal│  │menuNivelGov │            │
│  │Provider     │  │Provider     │  │Provider     │            │
│  └──────┬──────┘  └──────┬──────┘  └──────┬──────┘            │
│  ┌──────┴──────┐  ┌──────┴──────┐  ┌──────┴──────┐            │
│  │menuTipoEsp  │  │menuTipoTrans│  │menuTuCuenta │            │
│  │Provider     │  │Provider     │  │Provider     │            │
│  └──────────────┘  └──────────────┘  └──────────────┘            │
│  ┌──────────────┐  ┌──────────────┐                             │
│  │menuTuCuenta  │  │ Dropdown     │                             │
│  │UsuarioProv   │  │ PropertyType │                             │
│  └──────────────┘  └──────────────┘                             │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│                      Widgets de Menús                            │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐            │
│  │menuSuperior │  │menuSuperior │  │MenuSuperior │            │
│  │MenuInicial  │  │MenuPrincipal│  │PaginaInicio │            │
│  │ (pinned)    │  │(floating)   │  │NivelGobierno│            │
│  └──────┬──────┘  └──────┬──────┘  └──────┬──────┘            │
│  ┌──────┴──────┐  ┌──────┴──────┐  ┌──────┴──────┐            │
│  │MenuSuperior │  │MenuInferior │  │MenuSuperior │            │
│  │PaginaTipo   │  │TipoTransac  │  │PaginaTuCuenta│           │
│  │Espacios     │  │cion         │  │ (promotor)  │            │
│  └──────────────┘  └──────────────┘  └──────────────┘            │
│  ┌──────────────┐  ┌──────────────┐                             │
│  │MenuSuperior │  │ Dropdown     │                             │
│  │PaginaTuCuenta│  │ButtonPropied │                             │
│  │Usuario      │  │ad            │                             │
│  └──────────────┘  └──────────────┘                             │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│                     ButtonsTabBar / Dropdown                     │
│  ┌─────────────────────────────────────────────────────────┐  │
│  │ - backgroundColor: appTheme.primary                      │  │
│  │ - unselectedBackgroundColor: appTheme.onInverseSurface   │  │
│  │ - borderColor: appTheme.primary                          │  │
│  │ - labelStyle / unselectedLabelStyle                      │  │
│  │ - onTap: asignaNuevaOpcionSeleccionada + actualizar*    │  │
│  └─────────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────────┘
```

---

## 9. Mapa de Correspondencia Elemento → Comportamiento

### Providers de Estado

| Provider | Archivo | Estado | Tabs | Índice Home |
|---|---|---|---|---|
| `menuInicialProvider` | `provider_menu_inicial.dart` | `ElementosDelMenuInicial` | 5 (Inicio, Propiedades, Ubicación, Mi Cuenta, Perfil) | `indiceInicial` |
| `menuPrincipalProvider` | `provider_menu_principal.dart` | `ElementosDelMenuPrincipal` | 4 (Todas, Casas, Departamentos, Otros) | `indicePrincipal` |
| `menuNivelDeGobiernoProvider` | `provider_menu_nivel_gobierno.dart` | `ElementosDelMenuNivelDeGobierno` | 5 (Nacional, Estado, Municipio, C.P., Localidad) | `indiceNivelGobierno` |
| `menuTipoEspaciosProvider` | `provider_menu_tipo_espacio.dart` | `ElementosDelMenuTipoEspacios` | 5 (Normales, Destacados, Superdestacados, Oportunidades, Remates) | `indiceTipoEspacio` |
| `menuTipoDeTransaccionProvider` | `provider_menu_tipo_de_transaccion.dart` | `ElementosDelMenuTipoDePublicacion` | 5 (Todas, Venta, Renta, Venta/Renta, Traspaso) | `indiceTipoTransaccion` |
| `menuTuCuentaProvider` | `provider_menu_tu_cuenta.dart` | `ElementosDelMenuTuCuenta` | 4 (Espacios, Listas, Grupos, Conocidos) | `indiceMiCuenta` |
| `menuTuCuentaUsuarioProvider` | `provider_menu_tu_cuenta_usuario.dart` | `ElementosDelMenuTuCuentaUsuario` | 3 (Listas, Grupos, Conocidos) | `indiceMiCuentaUsuario` |

### Widgets de Menú

| Widget | Archivo | Tipo | Comportamiento |
|---|---|---|---|
| `menuSuperiorMenuInicial` | `appbar_sliver_menu_inicial.dart` | Función widget | `SliverAppBar` con `ButtonsTabBar`, `pinned: true`, `onTap` actualiza `menuInicialProvider` + `homeNavigationProvider` |
| `menuSuperiorMenuPrincipal` | `appbar_sliver_menu_principal.dart` | Función widget | `SliverAppBar` con `ButtonsTabBar`, `pinned: false, floating: true`, `onTap` actualiza `menuPrincipalProvider` + `homeNavigationProvider` |
| `MenuSuperiorPaginaInicioNivelGobierno` | `appbar_sliver_menu_nivel_gobierno.dart` | `ConsumerWidget` | `SliverAppBar` con etiquetas dinámicas de localidad, `GlobalKey` para AXTree |
| `MenuSuperiorPaginaTipoDeEspacios` | `appbar_sliver_menu_tipo_espacio.dart` | `ConsumerWidget` | `SliverAppBar` con `ExcludeSemantics`, `floating: true` |
| `MenuSuperiorPaginaTuCuenta` | `appbar_menu_tu_cuenta.dart` | `ConsumerWidget` | `SliverAppBar` con `pinned: true`, estilos de label diferenciados para seleccionado/no seleccionado |
| `MenuSuperiorPaginaTuCuentaUsuario` | `appbar_menu_tu_cuenta_usuario.dart` | `ConsumerWidget` | `SliverAppBar` con `pinned: true`, estilos de label diferenciados |
| `MenuInferiorTipoDeTransaccion` | `appbar_menu_tipo_transaccion_inferior.dart` | `ConsumerStatefulWidget` | `Container` con `ButtonsTabBar`, inicializa controller en `initState` |
| `DropdownButtonPropiedad` | `dropdown_menu_principal_propiedades.dart` | `ConsumerStatefulWidget` | `DropdownButton<String>` con lista de tipos de inmueble, callback `onChangedCallback` |

### Constantes Comunes

| Constante | Valor | Uso |
|---|---|---|
| `menuToolbarHeight` | `32.0` | Altura de `ButtonsTabBar` |
| `menuToolbarDoubleHeight` | `56.0` | Altura doble para ciertos menús |
| `menuBorderRadiusCircular` | `12.0` | Radio de borde |
| `menuTabHeight` | `20.0` | Altura de tabs |
| `menuTabIconSize` | `16.0` | Tamaño de iconos en tabs |
| `menuTabIconWeight` | `400.0` | Peso de iconos |
| `menuTabLabelSize` | `12.0` | Tamaño de texto en tabs |
| `menuTabSmallLabelSize` | `9.0` | Tamaño pequeño de texto |

---

## 10. Decisiones de Diseño Documentadas

| ID | Decisión | Justificación |
|---|---|---|
| DD-01 | Uso de `StateNotifierProvider` en lugar de `StateProvider` | Los menús requieren métodos personalizados (`asignaNuevaOpcionSeleccionada`, `restableceOpcionActualSeleccionada`, `inicializaController`) que justifican un `StateNotifier` |
| DD-02 | `ButtonsTabBar` de la librería `buttons_tabbar` | Proporciona tabs con bordes redondeados y estilos personalizados que coinciden con el diseño M3 |
| DD-03 | `SliverAppBar` con `pinned: true` para menús principales | Mantiene los menús de navegación principal visibles durante scroll para acceso constante |
| DD-04 | `SliverAppBar` con `pinned: false, floating: true` para filtros | Los filtros desaparecen al hacer scroll y reaparecen al deslizar hacia arriba, maximizando espacio de contenido |
| DD-05 | `ValueKey` dinámica en `SliverAppBar` | Previene errores de AXTree en accesibilidad cuando cambia el índice del tab |
| DD-06 | `GlobalKey` en `MenuSuperiorPaginaInicioNivelGobierno` | Garantiza unicidad en el árbol de accesibilidad para el menú de nivel de gobierno |
| DD-07 | Etiquetas dinámicas en nivel de gobierno | Muestra datos reales de localidad (estado, municipio, C.P.) en lugar de texto estático |
| DD-08 | `ExcludeSemantics` en `MenuSuperiorPaginaTipoDeEspacios` | Mejora la accesibilidad evitando anuncios redundantes del lector de pantalla |
| DD-09 | `TickerProviderStateMixin` en `MenuInferiorTipoDeTransaccion` | Necesario para crear `TabController` con `vsync` |
| DD-10 | Estilos de label diferenciados en `MenuSuperiorPaginaTuCuenta` | Mejora la legibilidad usando `appTheme.onPrimary` para seleccionado y `appTheme.onSurfaceVariant` para no seleccionado |
| DD-11 | `restableceOpcionActualSeleccionada` en post-frame callback | Garantiza que los `TabController` se sincronicen con el estado después de cada rebuild |
| DD-12 | `DropdownButtonPropiedad` con `ConsumerStatefulWidget` | Requiere `setState` para actualizar el valor seleccionado localmente |
| DD-13 | `didUpdateWidget` en `DropdownButtonPropiedad` | Sincroniza el valor inicial si el padre lo modifica después de la creación |
| DD-14 | Constantes de menú en `variables_menus.dart` | Centraliza las dimensiones y estilos para facilitar mantenimiento y cambios globales |
| DD-15 | `onChangedCallback` en `DropdownButtonPropiedad` | Permite comunicación con el padre sin acoplamiento directo a providers específicos |

---

*Generado por ingeniería inversa — BuscoBien SDD v1.0 — 2026-08-07*
