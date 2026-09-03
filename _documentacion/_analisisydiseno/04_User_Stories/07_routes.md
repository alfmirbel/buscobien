# User Stories — Sistema de Rutas (07_routes)

**Directorio:** `lib/07_routes/`  
**Fecha:** 2026-08-12

---

## US-ROUT-001: Navegación centralizada con argumentos tipados

**Card:**  
Como **desarrollador**  
Quiero **una sola fuente de verdad para 30+ rutas con argumentos**  
Para **navegar deterministamente entre pantallas**

**Conversation:**  
`AppRoutes` define 30+ `static const String` (ej: `/principal`, `/login`, `/mapapropiedades`). `routeGenerate(RouteSettings)` es switch único en `MaterialApp.onGenerateRoute`. Cada case castea `settings.arguments as TipoEsperado` y devuelve `MaterialPageRoute` con la pantalla correcta. DTOs en `routes_parameters.dart` proveen defaults/plantillas para edición de espacio, lista fotos, etc.

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
- [ ] Abrir enlace en Web ya abierta navega a `/cambiopassword`
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