# Epic: Providers de Menús y SliverAppBars Dinámicos (05_provider_menus)

**Directorio:** `lib\05_provider_menus\`  
**Archivos:** 7 providers (`provider_menu_*.dart`), 5 SliverAppBars (`appbar_*.dart`), `dropdown_menu_principal_propiedades.dart`, `variables_menus.dart`  
**Fecha:** 2026-08-12  
**Fuente:** Ingeniería inversa

---

## Impact Mapping

| Objetivo de Negocio | Actor | Impacto | Entregable |
|---------------------|-------|---------|------------|
| Navegación por facetas (gobierno, espacio, transacción, cuenta) | Usuario final | Filtra propiedades por 5 dimensiones simultáneas con tabs sincronizados | 7 providers `ClaseMenuX` + 5 SliverAppBars con `ButtonsTabBar` |
| | Desarrollador | Un patrón único para todos los menús (StateNotifier + TabController) | Patrón repetido 7x con variaciones de items |

---

## User Story Mapping

```
Usuario en PrincipalSliversMenuInicial
       │
       ▼
┌─────────────────────────────────────────────────────────────┐
│ 7 Providers de Menú (StateNotifier pattern idéntico):       │
│ 1. menuInicial (5 tabs: Inicio, Props, Ubic, Cuenta, Perfil)│
│ 2. menuPrincipal (4: Todas, Casas, Deptos, Otros)           │
│ 3. menuTipoEspacio (5: Norm, Dest, Super, Oport, Remate)    │
│ 4. menuTipoTransaccion (5: Todas, Venta, Renta, V/R, Trasp) │
│ 5. menuNivelGobierno (5: Nacional, Edo, Mun, CP, Tipo/Loc)  │
│ 6. menuTuCuenta Promotor (4: Props, Listas, Grupos, Conoc)  │
│ 7. menuTuCuenta Usuario (3: Listas, Grupos, Conocidos)      │
│                                                              │
│ Cada provider: State class + Notifier + TabController       │
└────────────────────────┬────────────────────────────────────┘
                         │
       ┌─────────────────┼─────────────────┐
       ▼                 ▼                 ▼
  SliverAppBar       SliverAppBar      Dropdown
  (pinned/floating)  (pinned/floating)  (tipo inmueble)
  ValueKey dinámica  tabs condicionales  callback global
```

---

## Especificación SDD / EARS

**Prefijo IDs:** `REQ-MENU-XXX`

| ID | Tipo EARS | Requerimiento | Evidencia | Estado |
|----|-----------|---------------|-----------|--------|
| REQ-MENU-001 | **Ubicuo** | El sistema definirá **7 providers de menú** (`provider_menu_inicial.dart` ... `provider_menu_tu_cuenta_usuario.dart`) siguiendo patrón idéntico: `ElementosDelMenuX` (state) + `ClaseMenuX extends StateNotifier` + `StateNotifierProvider`. | `lib\05_provider_menus\provider_menu_*.dart` (7 archivos) | En código |
| REQ-MENU-002 | **Ubicuo** | Cada `ClaseMenuX` expondrá: `inicializaController(TickerProvider)` (crea TabController), `asignaNuevaOpcionSeleccionada(ref, index)` (actualiza selección + boolean array), `restableceOpcionActualSeleccionada(ref)` (sync TabController), `disposeController()`. | Patrón común en 7 archivos | En código |
| REQ-MENU-003 | **Estado** | Mientras un `TabController` esté activo, el sistema sincronizará `seleccionMenuX` (index) con `TabController.index` bidireccionalmente (notifier → controller y controller → notifier via listener). | `asignaNuevaOpcionSeleccionada` + `restableceOpcionActualSeleccionada` | En código |
| REQ-MENU-004 | **Ubicuo** | El sistema proveerá **5 SliverAppBars** que renderizan `ButtonsTabBar` consumiendo providers correspondientes: `menuSuperiorMenuInicial` (pinned), `menuSuperiorMenuPrincipal` (floating), `MenuSuperiorPaginaTipoDeEspacios` (GlobalKey), `MenuSuperiorPaginaInicioNivelGobierno` (dinámico), `MenuSuperiorPaginaTuCuenta` / `...Usuario` (pinned). | `lib\05_provider_menus\appbar_*.dart` (5 archivos) | En código |
| REQ-MENU-005 | **Evento** | Cuando `MenuSuperiorPaginaTuCuenta` / `...Usuario` se construya, el sistema notificará a `homeNavigationProvider.actualizarMiCuenta(index)` / `actualizarMiCuentaUsuario(index)` para sincronizar navegación global. | `appbar_menu_tu_cuenta.dart:30-40` | En código |
| REQ-MENU-006 | **Estado** | Mientras `MenuSuperiorPaginaInicioNivelGobierno` esté visible, el sistema consumirá `localidadesPorCodigoPostalProvider` para poblar tabs dinámicamente (CP → localidades). | `appbar_sliver_menu_nivel_gobierno.dart:50-90` | En código |
| REQ-MENU-007 | **Ubicuo** | El sistema usará `ValueKey('menuInicial-$index')` (y variantes) en `ButtonsTabBar` para evitar error AXTree al cambiar tabs dinámicamente. | `appbar_sliver_menu_inicial.dart:25` | En código |
| REQ-MENU-008 | **Ubicuo** | El sistema expondrá `DropdownButtonPropiedad` (ConsumerStatefulWidget) para selección de tipo de inmueble, actualizando variable global `selectedDropDownMenuPrincipalValue` y callback opcional. | `dropdown_menu_principal_propiedades.dart` | En código |
| REQ-MENU-009 | **No Deseado** | Si `TabController` no se dispose correctamente, el sistema acumulará listeners y `TickerProvider` leaks (7 controllers × n navegaciones). | `disposeController()` existe pero no verificado en todos los flujos | Riesgo |
| REQ-MENU-010 | **Complejo** | Mientras el usuario navegue entre secciones, cuando `homeNavigationProvider.indiceX` cambie, el sistema actualizará `menuXProvider` via `asignaNuevaOpcionSeleccionada` y viceversa (binding bidireccional). | `principal_sliver_screen_menus_inicio.dart` listeners | En código |

---

## Trazabilidad a Código

| Provider | Items (etiquetas) | TabController | SliverAppBar |
|----------|-------------------|---------------|--------------|
| `menuInicial` | Inicio, Propiedades, Ubicación, Mi Cuenta, Perfil | Sí | `appbar_sliver_menu_inicial.dart` |
| `menuPrincipal` | Todas, Casas, Departamentos, Otros | Sí | `appbar_sliver_menu_principal.dart` |
| `menuTipoEspacio` | Normales, Destacados, Superdestacados, Oportunidades, Remates | Sí | `appbar_sliver_menu_tipo_espacio.dart` |
| `menuTipoTransaccion` | Todas, Venta, Renta, Venta/Renta, Traspaso | Sí | (integrado en principal) |
| `menuNivelGobierno` | Nacional, Estado, Municipio, C.P., Tipo/Localidad | Sí | `appbar_sliver_menu_nivel_gobierno.dart` |
| `menuTuCuenta` (Promotor) | Propiedades, Listas, Grupos, Conocidos | Sí | `appbar_menu_tu_cuenta.dart` |
| `menuTuCuentaUsuario` | Listas, Grupos, Conocidos | Sí | `appbar_menu_tu_cuenta_usuario.dart` |

---

## Deuda Técnica

1. **7x copy-paste**: Patrón idéntico replicado 7 veces — candidata a `MenuProviderBase` genérico.
2. **Variables globales**: `selectedDropDownMenuPrincipalValue` (top-level mutable) en `dropdown_menu_principal_propiedades.dart`.
3. **Tabs condicionales hardcoded**: `MenuSuperiorPaginaInicioNivelGobierno` usa `localidadesPorCodigoPostalProvider` pero lógica de tabs en UI, no en provider.
4. **No tests**: Ningún test de sincronización `TabController ↔ Notifier`.