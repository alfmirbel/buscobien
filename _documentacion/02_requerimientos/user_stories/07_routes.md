# User Stories — Sistema de Rutas (07_routes)

**Directorio:** `lib/07_routes/`  
**Fecha:** 2026-08-12

---

## US-ROUT-001: Navegación centralizada con argumentos tipados

**Card:**  
Como **desarrollador**  
Quiero **una sola fuente de verdad para las 22 rutas con pantalla (38 constantes) y sus argumentos**  
Para **navegar deterministamente entre pantallas**

**Conversation:**  
`AppRoutes` define 38 `static const String` (22 con `case` activo; ej: `/principal`, `/registro`, `/mapapropiedades`). `routeGenerate(RouteSettings)` es switch único en `MaterialApp.onGenerateRoute`. Cada case castea `settings.arguments as TipoEsperado` y devuelve `MaterialPageRoute` con la pantalla correcta. DTOs en `routes_parameters.dart` proveen defaults/plantillas para edición de espacio, lista fotos, etc.

**Confirmation:**
- [ ] `Navigator.pushNamed(context, AppRoutes.editaespacio, arguments: espaciocasaGet)` abre `PaginaEditaEspacio`
- [ ] `Navigator.pushNamed(context, AppRoutes.mapapropiedades, arguments: espaciosCasaGet)` abre `PaginaMapaPropiedades`
- [ ] `routeGenerate` loggea cada navegación vía `debugPrintLevels(1-3, ...)`
- [ ] Rutas sin argumentos funcionan (`/principal`, `/login`)

---

## US-ROUT-002: Deep Link recuperación contraseña multiplataforma

**Card:**  
Como **usuario que olvidé mi contraseña**  
Quiero **abrir enlace `/recuperar?token=X&perfil=Y` y cambiar mi contraseña**  
Para **recuperar acceso sin pedir soporte**

**Conversation:**  
`initDeepLinkHandler(navigatorKey)` en `main.dart` postFrame. Web: usa `Uri.base`. Android/iOS: usa `app_links` package (`getInitialLink` cold start + `uriLinkStream` warm start). Si path contiene `/recuperar` y `token`+`perfil` no vacíos → `navigatorKey.currentState?.pushNamed(AppRoutes.cambioPassword, arguments: {token, perfil})`.

**Confirmation:**
- [ ] Email enviado contiene enlace `/recuperar?token=abc&perfil=promotor`
- [ ] Abrir enlace en Android (App Link) abre app y navega a `/cambiopassword`
- [ ] Abrir enlace en iOS (Universal Link) idem
- [ ] Abrir la app en Web con la URL `/recuperar?token=…&perfil=…` navega a `/cambiopassword` (la URL solo se evalúa al arrancar; no se atiende en una pestaña ya abierta)
- [ ] Si token/perfil vacíos → no navega, loggea error
- [ ] Si `navigatorKey.currentState == null` → no navega (prevención crash)

---

## US-ROUT-003: Manejo de errores de navegación

**Card:**  
Como **usuario**  
Quiero **ver feedback claro si la navegación falla**  
Para **no quedar en pantalla en blanco**

**Conversation:**  
`PaginaDeError` muestra `AppBar` rojo + mensaje + botón "Salir". Default case en `routeGenerate` retorna `null` — **riesgo de pantalla negra sin fallback explícito**. Argumentos incorrectos lanzan `TypeError` en cast sin `is` check previo.

**Confirmation:**
- [ ] Navegar a ruta inexistente idealmente → `PaginaDeError` (PENDIENTE implementar fallback en default case)
- [ ] Actualmente default case retorna `null` (mejora propuesta)
- [ ] Si `arguments` tipo incorrecto → `TypeError` runtime (mejora propuesta: añadir `is` check)

---

## Historias incorporadas en la revisión de exactitud (2026-10-07)

Cubren requerimientos añadidos a la Epic tras contrastarla con el código.

---

## US-ROUT-004: Arranque con splash y enlace inicial

**Card:**  
Como **usuario**  
Quiero **que la app abra con un splash de 3 segundos y atienda el enlace con el que fue abierta**  
Para **llegar a la pantalla correcta sin pasos manuales**

**Conversation:**  
`initialRoute` es `/`; `routeGenerate` construye `SplashPage(duration: 3)` que termina en `PrincipalSliversMenuInicial`. Tras el primer frame, `main.dart` invoca una sola vez `initDeepLinkHandler(navigatorKey)`; el `navigatorKey` global permite navegar sin `BuildContext`. Cada navegación se registra con `debugPrintLevels`.

**Confirmation:**
- [ ] Abrir la app en `/` muestra el splash 3 s y luego la pantalla principal
- [ ] `initDeepLinkHandler` se invoca una sola vez después del primer frame
- [ ] El deep link navega usando `navigatorKey.currentState?.pushNamed`
- [ ] `routeGenerate` registra nombre y argumentos de cada ruta

**Trazabilidad:** `REQ-ROUT-013`, `REQ-ROUT-014`, `REQ-ROUT-015`, `REQ-ROUT-017` · Escenarios: `07_routes/catalogo_de_rutas.feature, deep_link_recuperacion.feature`
