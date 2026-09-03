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
│ AppRoutes (constantes de 30+ rutas) │
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
| REQ-ROUT-001 | **Ubicuo** | El sistema definirá constantes `static const String` para **todas** las rutas activas (30+) en `AppRoutes` (ej: `main="/", principal="/principal", login="/login", mapapropiedades="/mapapropiedades", cambiopassword="/cambiopassword"`). | `lib\07_routes\app_routes.dart:10-50` | En código |
| REQ-ROUT-002 | **Ubicuo** | El sistema usará `routeGenerate(RouteSettings)` como `onGenerateRoute` único en `MaterialApp`, con switch exhaustivo sobre `settings.name`. | `lib\main.dart:97-99`, `app_routes.dart:55-300` | En código |
| REQ-ROUT-003 | **Evento** | Cuando `routeGenerate` reciba una ruta conocida, el sistema instanciará la pantalla correspondiente vía `MaterialPageRoute` pasando `settings.arguments` casteados al tipo esperado. | `app_routes.dart:55-300` cases | En código |
| REQ-ROUT-004 | **Evento** | Cuando la ruta sea `/cambiopassword` con `arguments: {token, perfil}`, el sistema validará ambos no vacíos y navegará a `PageCambioPassword(token, perfil)`. | `app_routes.dart:200-210`, `deep_link_handler.dart:40-50` | En código |
| REQ-ROUT-005 | **Evento** | Cuando la ruta sea `/sinconeccion`, el sistema pasará `settings.arguments as String` como mensaje a `PaginaSinConeccion`. | `app_routes.dart:85-90` | En código |
| REQ-ROUT-006 | **No Deseado** | Si `routeGenerate` recibe una ruta **no declarada** en el switch, el sistema retornará `null` (flutter muestra pantalla negra / error genérico) — **sin fallback explícito**. | `app_routes.dart:295` `default: return null` | Riesgo |
| REQ-ROUT-007 | **Evento** | Cuando la app reciba un App Link (Android/iOS) o URI Web con path `/recuperar` y query params `token` + `perfil`, el sistema navegará programáticamente via `navigatorKey` a `/cambiopassword`. | `lib\07_routes\deep_link_handler.dart:15-55` | En código |
| REQ-ROUT-008 | **Estado** | Mientras la app esté en foreground/background, el sistema escuchará `AppLinks().uriLinkStream` para deep links en warm start. | `deep_link_handler.dart:35-40` | En código |
| REQ-ROUT-009 | **Ubicuo** | El sistema definirá DTOs/plantillas de argumentos en `routes_parameters.dart` para: edición de espacio, lista fotos, compra espacios, mapa propiedades, chequeo conexión, captura fotos, etc. | `lib\07_routes\routes_parameters.dart` (400+ líneas) | En código |
| REQ-ROUT-010 | **No Deseado** | Si `settings.arguments` no coincide con el tipo esperado en un case (ej. `as ValueEspaciosCasaGet` falla), el sistema lanzará `TypeError` en runtime (sin validación previa). | `app_routes.dart` casts sin `is` check | Riesgo |
| REQ-ROUT-011 | **Complejo** | Mientras `parameterEditaEspacio` (global mutable) sea usado como default en múltiples rutas, el sistema **compartirá estado mutado** entre navegaciones (data race lógico). | `routes_parameters.dart:100-120` duplicates | Deuda técnica |
| REQ-ROUT-012 | **Opcional** | Donde se use `PaginaDeError` (route no implementada), el sistema mostrará `AppBar` rojo + mensaje + botón "Salir" (`Navigator.pop`). | `lib\07_routes\pagina_route_error.dart` | Parcial (no usada) |

---

## Trazabilidad a Código

| Componente | Archivo | Líneas |
|------------|---------|--------|
| `AppRoutes` constants | `app_routes.dart` | 10-50 |
| `routeGenerate` switch | `app_routes.dart` | 55-300 |
| `navigateToRoute` wrapper | `app_routes.dart` | 52-54 |
| `initDeepLinkHandler` | `deep_link_handler.dart` | 15-30 |
| `_handleWebInitialUri` / `_handleMobileDeepLinks` | `deep_link_handler.dart` | 32-45 |
| `_navigateIfRecovery` (token+perfil) | `deep_link_handler.dart` | 47-55 |
| `PaginaDeError` | `pagina_route_error.dart` | 1-40 |
| DTOs globales mutables | `routes_parameters.dart` | 1-450 |

---

## Deuda Técnica Crítica (Hallazgos)

1. **`routes_parameters.dart`**: 400+ líneas de variables top-level mutables (`Map<String,dynamic>`, instancias `ValueEspaciosCasaGet` duplicadas 4x, datos hardcoded de contacto real). **Riesgo alto de bugs de shared state**.
2. **Default case retorna `null`**: Flutter 3.x muestra pantalla en blanco en ruta desconocida — debería redirigir a `PaginaDeError` o `AppRoutes.sinconeccion`.
3. **Casts sin validación**: `settings.arguments as ValueEspaciosCasaGet` — `TypeError` en runtime si args incorrectos.
4. **No type-safe routing**: Argument passing vía `Map<String,dynamic>` sin Freezed/serialización.