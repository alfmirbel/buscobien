# Epic: Pantalla Principal / Shell de Navegación (02_principal_screen)

**Directorio:** `lib\02_principal_screen\`  
**Archivos:** `00_principales_opciones.dart`, `principal_00_inicio.dart`, `principal_02_page_appbar.dart`, `principal_03_page_drawer.dart`, `principal_sliver_screen_menus_inicio.dart`  
**Fecha:** 2026-08-12  
**Fuente:** Ingeniería inversa

---

## Impact Mapping

| Objetivo de Negocio | Actor | Impacto | Entregable |
|---------------------|-------|---------|------------|
| Shell central con navegación por secciones | Usuario final | Accede a Inicio, Propiedades, Ubicación, Mi Cuenta, Perfil desde una UI unificada con SliverAppBar + NavigationBar | `PrincipalSliversMenuInicial` orquestador + 7 menús sincronizados |
| | Promotor/Propietario | Publica espacios desde landing pages con pre-configuración de providers | 9 Landing pages (`PageInicio` + vistas) que setean providers y navegan |
| | Sistema | Estado de sesión, avatar, conectividad, navegación reactivos en un solo lugar | `PrincipalSliversMenuInicial.initState` + listeners |

---

## User Story Mapping

```
App navega a /principal
       │
       ▼
┌─────────────────────────────────────────────────────────────┐
│ PrincipalSliversMenuInicial (ConsumerStatefulWidget)        │
│ - Inicializa 7 providers de menú (TabControllers + estado)  │
│ - PostFrame: restaura sesión + usuario + avatar             │
│ - Listeners: homeNavigationProvider (scroll), conectividad  │
└────────────────────────┬────────────────────────────────────┘
                         │
       ┌─────────────────┼─────────────────┬─────────────────┐
       ▼                 ▼                 ▼                 ▼
   indInicial=0     indInicial=1      indInicial=2      indInicial=3
  ┌──────────┐    ┌──────────┐      ┌──────────┐      ┌──────────┐
  │ PageInicio│   │ Propiedades│    │ Ubicación │    │ Mi Cuenta│
  │ (Hero +   │   │ (filtros +│    │ (SEPOMEX  │    │ (Grupos/ │
  │  3 cards) │   │  paginación)│   │  + GMaps) │    │ Conocidos)│
  └──────────┘    └──────────┘      └──────────┘      └──────────┘
       │
       ▼
┌─────────────────────────────────────────────────────────────┐
│ AppBar dinámico (appBarPrincipal) + Drawer (MenuDrawer)     │
│ - Botones: Login/Perfil, Avatar, Favoritos, Búsqueda, etc.  │
│ - Condicional por sesión (usuario vs invitado)              │
└─────────────────────────────────────────────────────────────┘
```

---

## Especificación SDD / EARS

**Prefijo IDs:** `REQ-PRIN-XXX`

| ID | Tipo EARS | Requerimiento | Evidencia | Estado |
|----|-----------|---------------|-----------|--------|
| REQ-PRIN-001 | **Ubicuo** | El sistema definirá `PrincipalSliversMenuInicial` como shell principal que orquesta navegación por 5 secciones (índiceInicial 0-4) vía `CustomScrollView` con slivers condicionales. | `lib\02_principal_screen\principal_sliver_screen_menus_inicio.dart:80-250` | En código |
| REQ-PRIN-002 | **Evento** | Cuando `PrincipalSliversMenuInicial` haga `initState`, el sistema creará **7 TabControllers síncronos** (inicial, principal, nivelGobierno, tipoEspacio, tipoTransaccion, tuCuenta, tuCuentaUsuario) y disparará `postFrameCallback` para restaurar sesión completa. | `principal_sliver_screen_menus_inicio.dart:90-180` | En código |
| REQ-PRIN-003 | **Evento** | Cuando el `postFrameCallback` ejecute, el sistema hará en secuencia: 1) `getSessionValuesFromLocalStorage()` 2) `getUserDataByNameInSessionData()` 3) `recuperaDatosDelAvatar()` 4) lógica de negocio (filtros, mapas). | `principal_sliver_screen_menus_inicio.dart:140-180` | En código |
| REQ-PRIN-004 | **Estado** | Mientras `homeNavigationProvider.indiceInicial` cambie, el sistema reconstruirá el `CustomScrollView` con el sliver correspondiente (0=Inicio, 1=Propiedades, 2=Ubicación, 3=Mi Cuenta, 4=Perfil). | `principal_sliver_screen_menus_inicio.dart:200-250` | En código |
| REQ-PRIN-005 | **Estado** | Mientras exista sesión válida, el `appBarPrincipal` mostrará botón avatar (toca → navega a perfil/mi cuenta); si no hay sesión, mostrará botón "Login" que abre `dialogBoxFichaLogin`. | `lib\02_principal_screen\principal_02_page_appbar.dart:40-90` | En código |
| REQ-PRIN-006 | **Evento** | Cuando el usuario toque item del `MenuDrawer`, el sistema navegará a ruta correspondiente (`/principal`, `/listaspropiedades`, `/perfil`, `/preferencias`, etc.) y cerrará drawer. | `principal_03_page_drawer.dart:50-120` | En código |
| REQ-PRIN-007 | **Ubicuo** | El sistema expondrá `PageInicio` como landing con hero image, gradient overlay y grid 3 tarjetas responsivas (Buscar, Promotores, Propietarios) que navegan a secciones pre-configurando providers. | `principal_00_inicio.dart:30-150` | En código |
| REQ-PRIN-008 | **Evento** | Cuando una landing page (ej. `pagina_hospedaje.dart`) invoque `_irAPublicar()`, el sistema configurará 4-5 providers de menú (tipoEspacio, tipoTransaccion, tuCuenta, nivelGobierno) y navegará a `/principal` con `pushReplacementNamed`. | `lib\03_vistas\pagina_hospedaje.dart:180-220` | En código |
| REQ-PRIN-009 | **No Deseado** | Si `getSessionValuesFromLocalStorage()` falla (storage corrupto), el sistema continuará sin sesión (usuario invitado) sin crash — `catch` vacío en `dialogBoxFichaLogin`. | `principal_02_page_appbar.dart` / `dialogbox_login.dart` | Parcial |
| REQ-PRIN-010 | **Complejo** | Mientras la app esté en shell principal, cuando `checaConeccionesProvider` emita "Sin conexión", el sistema hará `Navigator.pushNamed(AppRoutes.sinconeccion)`; al recuperar, hará `pop()` automático. | `principal_sliver_screen_menus_inicio.dart:190-195` listener | En código |

---

## Trazabilidad a Código

| Componente | Archivo | Líneas |
|------------|---------|--------|
| `PrincipalSliversMenuInicial` | `principal_sliver_screen_menus_inicio.dart` | 1-350 |
| 7 TabControllers init | `principal_sliver_screen_menus_inicio.dart` | 90-120 |
| PostFrame secuencia sesión | `principal_sliver_screen_menus_inicio.dart` | 140-180 |
| `appBarPrincipal` function | `principal_02_page_appbar.dart` | 10-130 |
| `MenuDrawer` widget | `principal_03_page_drawer.dart` | 1-150 |
| `PageInicio` landing | `principal_00_inicio.dart` | 1-200 |
| `listaLandingPages` + `menuOpciones` | `00_principales_opciones.dart` | 1-50 |

---

## Notas de Arquitectura

- **Orquestador único**: `PrincipalSliversMenuInicial` es el único widget que inicializa TODOS los providers de menú y restaura sesión.
- **7 menús sincronizados**: Cada menú tiene su `TabController` + provider `ClaseMenuX` + SliverAppBar con `ButtonsTabBar`.
- **Landing pages pre-configuran**: 9 vistas (`03_vistas`) setean providers y navegan a principal — patrón "configurar → navegar".
- **Drawer estático**: 11 items hardcoded; algunos "Próximamente" sin navegación real.