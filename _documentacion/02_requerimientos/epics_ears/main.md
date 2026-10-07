# Epic: Inicialización y Configuración Global de la Aplicación (main)

**Directorio:** `lib/main.dart`  
**Fecha:** 2026-08-12  
**Fuente:** Ingeniería inversa de `lib/main.dart`

---

## Impact Mapping

| Objetivo de Negocio (Iniciativa) | Actor | Impacto (Cambio de Comportamiento) | Entregable (Epic) |
|----------------------------------|-------|------------------------------------|-------------------|
| Consolidar Buscobien como plataforma de referencia inmobiliaria en México | Usuario final (comprador/arrendatario) | Accede a la app desde cualquier plataforma (Web/WASM, Windows, Android, iOS) con experiencia nativa consistente | Inicialización y configuración global multiplataforma |
| | Promotor/Inmobiliaria/Propietario | Inicia sesión/recupera password vía deep link sin fricción | Manejo de deep links para recuperación de contraseña |
| | Equipo de desarrollo | Depura y monitorea ciclos de vida de la app con logging granular | Sistema de debug por niveles (`debugPrintLevels`) |

---

## User Story Mapping (User Journey simplificado)

```
Usuario abre la app
       │
       ▼
┌──────────────────┐
│ 1. Splash (3s)   │──► Verifica conectividad
│    + Deep Links  │     │
└────────┬─────────┘     │
         │               ▼
         │        ┌──────────────┐
         │        │ Conectado?   │── No ──► Pantalla Sin Conexión (auto-retry)
         │        └──────┬───────┘
         │               │ Sí
         ▼               ▼
┌────────────────────────────────────┐
│ 2. Shell Principal (M3 Theme)      │
│ - NavigationBar (5 tabs)           │
│ - AppBar contextual                │
│ - ProviderScope (Riverpod)         │
│ - navigatorKey global              │
└────────────────────────────────────┘
       │
       ▼
┌──────────────────┐
│ 3. Navegación    │──► Rutas centralizadas (AppRoutes + routeGenerate)
│    por Estado    │
└──────────────────┘
```

**Grandes pasos = Epics:**
1. **Arranque y Splash** (ver `01_splash_screen.md`)
2. **Configuración Global M3** (este epic: `main.md`)
3. **Routing y Deep Links** (ver `07_routes.md`)
4. **Estado de Navegación Global** (ver `01_home.md`)

---

## Especificación SDD / EARS

**Prefijo IDs:** `REQ-MAIN-XXX`  
**Evidencia:** Rutas con backslash (convención repo)

| ID | Tipo EARS | Requerimiento | Evidencia | Estado |
|----|-----------|---------------|-----------|--------|
| REQ-MAIN-001 | **Ubicuo** | El sistema inicializará `WidgetsFlutterBinding`, forzará orientación portrait-only y activará `setPathUrlStrategy()` antes de renderizar la app. | `lib\main.dart:14-20` | En código |
| REQ-MAIN-002 | **Ubicuo** | El sistema envolverá la app en `ProviderScope` de Riverpod para inyección de dependencias y estado global. | `lib\main.dart:24` | En código |
| REQ-MAIN-003 | **Ubicuo** | El sistema configurará `MaterialApp` con `useMaterial3: true`, tema basado en `appTheme` (ColorScheme global) y `NavigationBarThemeData` personalizado. | `lib\main.dart:52-93` | En código |
| REQ-MAIN-004 | **Ubicuo** | El sistema expondrá un `GlobalKey<NavigatorState>` global (`navigatorKey`) para navegación programática desde deep links y providers. | `lib\main.dart:27` | En código |
| REQ-MAIN-005 | **Evento** | Cuando la app inicie (`initState`), el sistema inicializará el manejador de deep links (`initDeepLinkHandler`) usando `navigatorKey`. | `lib\main.dart:38-42` | En código |
| REQ-MAIN-006 | **Evento** | Cuando se reciba un deep link de recuperación (`/recuperar?token=X&perfil=Y`), el sistema navegará a `/cambiopassword` con argumentos `token` y `perfil`. | `lib\07_routes\deep_link_handler.dart` | En código |
| REQ-MAIN-007 | **Estado** | Mientras la app esté ejecutándose, el sistema usará `routeGenerate` (de `app_routes.dart`) como `onGenerateRoute` para resolver todas las rutas nombradas. | `lib\main.dart:97-99` | En código |
| REQ-MAIN-008 | **No Deseado** | Si falla la inicialización de `WidgetsFlutterBinding` o `setPathUrlStrategy`, el sistema no renderizará la app y propagará la excepción (crash visible). | `lib\main.dart:14-16` (sin try-catch) | Riesgo |
| REQ-MAIN-009 | **No Deseado** | Si `navigatorKey.currentState` es null al procesar deep link, el sistema no navegará y loggeará error (silencioso si nivel debug desactivado). | `lib\07_routes\deep_link_handler.dart:45-47` | Parcial |
| REQ-MAIN-010 | **Complejo** | Mientras la app esté en primer plano, cuando ocurra un cambio de conectividad detectado por `checaConeccionesProvider`, el sistema reaccionará según el estado (ver epic `41_connectivity.md`). | `lib\41_connectivity\connectivitycheck_provider.dart` | En código |

---

## Trazabilidad a Código

| Componente | Archivo | Línea |
|------------|---------|-------|
| `main()` entry point | `lib\main.dart` | 14-25 |
| `BuscoBienApp` widget | `lib\main.dart` | 29-103 |
| `_BuscoBienAppState.initState` | `lib\main.dart` | 36-43 |
| `MaterialApp` config M3 | `lib\main.dart` | 52-93 |
| `navigatorKey` global | `lib\main.dart` | 27 |
| `lcwc` debug counter | `lib\main.dart` | 21 |

---

## Notas de Arquitectura

- **No hay GoRouter ni Navigator 2.0**: Routing custom vía `AppRoutes.routeGenerate()` (`lib\07_routes\app_routes.dart`).
- **Path URL Strategy**: `setPathUrlStrategy()` activo → URLs limpias en Web (`/principal` no `#/principal`).
- **Riverpod Generator**: Providers usan `@riverpod` + codegen (`.g.dart`).
- **Debug Levels**: 21 niveles (`level00`-`level20`) en `lib\60_global_widgets\debugprint.dart` controlan verbosidad.