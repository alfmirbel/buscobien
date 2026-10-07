# User Stories — Inicialización Global (main)

**Directorio:** `lib/main.dart`  
**Fecha:** 2026-08-12  
**Formato:** 3 C's (Card, Conversation, Confirmation)

---

## US-MAIN-001: Arranque Multiplataforma M3

**Card:**  
Como **usuario de cualquier plataforma (Web/WASM, Windows, Android, iOS)**  
Quiero **que la app inicie con Material Design 3 nativo y URLs limpias**  
Para **tener experiencia visual consistente y navegable por URL directa**

**Conversation:**  
La app debe inicializar `WidgetsFlutterBinding`, forzar orientación portrait, activar `setPathUrlStrategy()` (path strategy, no hash), envolver en `ProviderScope` Riverpod, y configurar `MaterialApp` con `useMaterial3: true`, tema basado en `appTheme` global, `NavigationBarThemeData` personalizado, `navigatorKey` global, y `routeGenerate` como `onGenerateRoute`. El punto de entrada es `AppRoutes.main` (splash).

**Confirmation (Criterios de Aceptación):**
- [ ] `flutter run -d chrome --wasm` muestra URLs tipo `/principal` (no `#/principal`)
- [ ] `flutter run -d windows` usa M3 widgets (`NavigationBar`, `FilledButton`)
- [ ] `flutter run` (Android/iOS) usa `flutter_secure_storage` para JWT
- [ ] `flutter analyze` reporta 0 warnings de colores hardcoded
- [ ] `navigatorKey.currentState` disponible para deep links

---

## US-MAIN-002: Deep Link Recuperación Contraseña

**Card:**  
Como **usuario que olvidó su contraseña**  
Quiero **abrir enlace de recuperación en la app directamente**  
Para **cambiar mi contraseña sin salir de la app**

**Conversation:**  
Al recibir App Link `/recuperar?token=X&perfil=Y` (Android App Link, iOS Universal Link, o Web URI), `initDeepLinkHandler` valida `token` y `perfil` no vacíos, y navega programáticamente via `navigatorKey.pushNamed(AppRoutes.cambioPassword, arguments: {token, perfil})`. Funciona en cold start y warm start.

**Confirmation:**
- [ ] Deep link en Android abre app y navega a `/cambiopassword`
- [ ] Deep link en iOS abre app y navega a `/cambiopassword`
- [ ] Deep link en Web (ya abierta) navega a `/cambiopassword`
- [ ] Token y perfil llegan como argumentos a `PageCambioPassword`
- [ ] Si token/perfil vacíos → no navega, loggea error

---

## US-MAIN-003: Logging Granular por 21 Niveles

**Card:**  
Como **desarrollador diagnosticando issues**  
Quiero **controlar verbosidad de logs por nivel sin recompilar**  
Para **filtrar ruido en producción y ver detalle en debug**

**Conversation:**  
`debugPrintLevels(int level, String msg)` en `lib/60_global_widgets/debugprint.dart` usa 21 booleanos `level00`–`level20` top-level. Niveles usados: 1=lifecycle, 3=tu cuenta, 5=tus espacios, 6=imágenes, 9=FutureBuilder, 10=general/providers, 12=general, 20=general. Cambiar booleanos en código controla output.

**Confirmation:**
- [ ] `level10=true` muestra logs de providers (`actualizarInicial`, etc.)
- [ ] `level9=true` muestra estados FutureBuilder (waiting/error/none)
- [ ] `level1=true` muestra `main.dart` lifecycle prints
- [ ] Cambiar booleanos no requiere rebuild (hot reload suficiente)