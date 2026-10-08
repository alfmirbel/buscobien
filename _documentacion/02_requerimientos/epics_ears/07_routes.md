# Epic: Sistema de Rutas y Deep Links (07_routes)

**Directorio:** `lib\07_routes\`  
**Archivos:** `app_routes.dart`, `deep_link_handler.dart`, `pagina_route_error.dart`, `routes_parameters.dart`  
**Fecha:** 2026-08-12  
**Fuente:** Ingeniería inversa

---

## Impact Mapping

| Objetivo de Negocio | Actor | Impacto | Entregable |
|---------------------|-------|---------|------------|
| Navegación determinista sin GoRouter | Usuario final | URLs limpias en Web (`/principal`), deep links de recuperación password funcionan | Routing custom centralizado + App Links nativo |
| | Desarrollador | Una sola fuente de verdad para rutas y argumentos tipados | `AppRoutes` constants + `routeGenerate` switch + DTOs en `routes_parameters.dart` |

---

## User Story Mapping

```
App inicia
    │
    ▼
┌─────────────────────────────────────┐
│ AppRoutes (22 constantes)             │
└──────────────┬──────────────────────┘
               │
    ┌──────────┼──────────┐
    ▼          ▼          ▼
 Splash   Principal   Deep Link
  (/)       (/principal) (/recuperar)
    │          │          │
    ▼          ▼          ▼
┌─────────────────────────────────────┐
│ routeGenerate(RouteSettings)        │
│ switch(name) → MaterialPageRoute    │
│ con pantalla + args (settings.args) │
└──────────────┬──────────────────────┘
               │
    ┌──────────┼──────────┐
    ▼          ▼          ▼
  Pantalla  Argumentos   Error
  (Widget)  (DTOs/Map)  (fallback)
```

---

## Especificación SDD / EARS

**Prefijo IDs:** `REQ-ROUT-XXX`

| ID | Tipo EARS | Requerimiento | Evidencia | Estado |
|----|-----------|---------------|-----------|--------|
| REQ-ROUT-001 | **Ubicuo** | El sistema definirá en `AppRoutes` 22 constantes `static const String` de ruta, todas con `case` activo en `routeGenerate` (se eliminaron las 16 constantes que no tenían pantalla, MEJ-09). | `lib/07_routes/app_routes.dart` | En código |
| REQ-ROUT-002 | **Ubicuo** | El sistema usará `routeGenerate(RouteSettings)` como `onGenerateRoute` único de `MaterialApp`, con `initialRoute: AppRoutes.main`, mediante un `switch` sobre `settings.name`. | `lib/main.dart:95-98`, `app_routes.dart:103-252` | En código |
| REQ-ROUT-003 | **Evento** | Cuando `routeGenerate` reciba una ruta con `case`, el sistema construirá la pantalla con `navigateToRoute` (que registra el nombre con `debugPrintLevels(2)` y devuelve un `MaterialPageRoute` con los mismos `settings`), casteando `settings.arguments` al tipo esperado. | `app_routes.dart:89-100` | En código |
| REQ-ROUT-004 | **Evento** | Cuando la ruta sea `/cambiopassword`, el sistema hará `settings.arguments as Map<String, String>` y usará `args['token']!` y `args['perfil']!` para construir `PageCambioPassword`. La validación de que ambos no estén vacíos ocurre **antes**, en `deep_link_handler`; `routeGenerate` no la repite. | `app_routes.dart:244-249`, `deep_link_handler.dart:43-53` | En código |
| REQ-ROUT-005 | **Evento** | Cuando la ruta sea `/sinconeccion`, el sistema pasará `settings.arguments as String` como mensaje a `PaginaSinConeccion`; y para `/checaconeccion` pasará `settings.arguments as Map<String, dynamic>` a `PaginaChecaInternet`. | `app_routes.dart` (`case AppRoutes.sinconeccion` / `checaconeccion`) | En código |
| REQ-ROUT-006 | **No Deseado** | Si `routeGenerate` recibe un nombre sin `case`, devolverá `null` y `MaterialApp` usará `onUnknownRoute`, que muestra `PaginaDeError('Pantalla no encontrada: <ruta>')`. | `app_routes.dart` (`default: return null`), `lib/main.dart` (`onUnknownRoute`) | En código (MEJ-09) |
| REQ-ROUT-007 | **Evento** | Cuando llegue una URI cuyo `path` **contenga** `/recuperar` con parámetros `token` y `perfil` no vacíos, el sistema navegará con `navigatorKey.currentState?.pushNamed(AppRoutes.cambioPassword, arguments: {token, perfil})`; si falta alguno, ignorará el enlace en silencio. | `deep_link_handler.dart:38-55` | En código |
| REQ-ROUT-008 | **Estado** | Mientras la app no sea Web, el sistema atenderá el enlace inicial (`AppLinks().getInitialLink()`, arranque en frío) y escuchará `AppLinks().uriLinkStream` (arranque en caliente). En Web solo se evalúa `Uri.base` **una vez** al iniciar; los cambios posteriores de URL no se procesan. | `deep_link_handler.dart:9-36` | En código |
| REQ-ROUT-009 | **Ubicuo** | El sistema definirá en `routes_parameters.dart` clases de resultado (`ResultadoGuardaFoto`, `ResultSaveFoto`, `ArgumentsLocalidad`, `ArgumentsListaLocalidad`) y 11 variables globales de plantilla de argumentos (`parameterLocalidad`, `parametrosListaFotos`, `parameterEditaEspacio`, `parameterEditaFotos`, `inicializaValueGetCasa`, `parameterFotoPrincipal`, `parameterActualizaEspacio`, `parameterPaginaChecaConeccion`, `parameterCapturaFotosCasa`, `parameterPaginaMenuTipoTransaccion`, `parameterGestionFoto`). | `routes_parameters.dart:9-477` | En código |
| REQ-ROUT-010 | **No Deseado** | Si `settings.arguments` no coincide con el tipo esperado en un case (ej. `as ValueEspaciosCasaGet` falla), el sistema lanzará `TypeError` en runtime (sin validación previa). | `app_routes.dart` casts sin `is` check | Riesgo |
| REQ-ROUT-011 | **Complejo** | Mientras las plantillas globales mutables de `routes_parameters.dart` (p. ej. `parameterEditaEspacio`, `parameterEditaFotos`, `inicializaValueGetCasa`) se compartan entre pantallas —principalmente las de `22_imagenes` (≈100 referencias)—, el sistema mantendrá estado mutable compartido entre navegaciones. Los datos de contacto que contenían se vaciaron el 2026-10-07. | `routes_parameters.dart:37-133, 135-231, 256-352` | Deuda técnica |
| REQ-ROUT-012 | **Evento** | Cuando se muestre `PaginaDeError(letrero)` —por ruta desconocida (`onUnknownRoute`) o por falta de permiso de ubicación (`principal_02_page_appbar.dart`)—, el sistema mostrará `AppBar` con `appTheme.error`, el texto recibido y un botón «Salir» (`Navigator.pop`). | `pagina_route_error.dart`, `main.dart`, `principal_02_page_appbar.dart` | En código (MEJ-09) |
| REQ-ROUT-013 | **Evento** | Cuando la app inicie con `initialRoute: '/'` (`AppRoutes.main`) o se navegue a `/splash`, el sistema mostrará `SplashPage(3, duration: 3, goToPage: PrincipalSliversMenuInicial())`. | `app_routes.dart:109-129`, `main.dart:95` | En código |
| REQ-ROUT-014 | **Ubicuo** | El sistema expondrá un `GlobalKey<NavigatorState>` global (`navigatorKey`) asignado a `MaterialApp`, para navegar sin `BuildContext` desde los deep links. | `lib/main.dart:26,53` | En código |
| REQ-ROUT-015 | **Evento** | Cuando termine el primer frame de `BuscoBienApp`, el sistema invocará `initDeepLinkHandler(navigatorKey)` una sola vez (`addPostFrameCallback`). | `lib/main.dart:37-42` | En código |
| REQ-ROUT-016 | **No Deseado** | Si `settings.arguments` falta o no es del tipo del `case` (p. ej. `Map<String, String>` en `/cambiopassword`, `ValueEspaciosCasaGet` en `/editaespacio`), el sistema lanzará `TypeError`/`Null check` en tiempo de ejecución (casts con `as` y `!` sin comprobación previa). | `app_routes.dart` (todos los `as`), `:253-256` | Riesgo |
| REQ-ROUT-017 | **Ubicuo** | El sistema registrará en cada navegación el nombre y los argumentos de la ruta (`debugPrintLevels(1)` en `routeGenerate`, `(2)` en `navigateToRoute`). | `app_routes.dart:89-107` | En código |

---

## Trazabilidad a Código

La evidencia de cada requerimiento (archivo y líneas) está en la columna **Evidencia** de la tabla de requerimientos; no hay archivos adicionales que listar.

---

## Deuda Técnica Crítica (Hallazgos)

1. **`routes_parameters.dart`**: 477 líneas de variables top-level mutables (`Map<String,dynamic>`, instancias `ValueEspaciosCasaGet` duplicadas 4x, datos de contacto, vaciados el 2026-10-07). **Riesgo alto de bugs de shared state**.
2. **Ruta desconocida:** resuelta en MEJ-09 (`onUnknownRoute` + `PaginaDeError`). Quedan los casts sin validar (REQ-ROUT-016).
3. **Casts sin validación**: `settings.arguments as ValueEspaciosCasaGet` — `TypeError` en runtime si args incorrectos.
4. **No type-safe routing**: Argument passing vía `Map<String,dynamic>` sin Freezed/serialización.
5. ~~16 constantes de ruta sin `case`~~ — eliminadas en MEJ-09.
6. **Fecha de revisión de exactitud:** 2026-10-07 (contrastado línea a línea con `lib/07_routes/` y `lib/main.dart`).
