# User Stories — Pantalla Splash (01_splash_screen)

**Directorio:** `lib/01_splash_screen/`  
**Fecha:** 2026-08-12

---

## US-SPLASH-001: Splash con Timer Mínimo y Gate de Conectividad

**Card:**  
Como **usuario que abre la app**  
Quiero **ver branding profesional por al menos 3 segundos mientras se verifica conectividad**  
Para **saber que la app carga correctamente antes de entrar**

**Conversation:**  
`SplashPage` (ConsumerStatefulWidget) recibe `duration=3` y `goToPage=PrincipalSliversMenuInicial()`. Inicia timer (`_minDurationPassed`) y suscribe a `checaConeccionesProvider` reactivamente. Solo navega a principal cuando **AMBAS** condiciones se cumplen: timer completado Y conectividad = "Conectado". Si timer completa pero no hay red → navega a `/sinconeccion`. Inicialización GPS comentada (diferida a background).

**Confirmation:**
- [ ] Splash visible mínimo 3 segundos aunque haya red inmediata
- [ ] Si red disponible antes de 3s → espera timer
- [ ] Si timer completa pero sin red → navega a `/sinconeccion` con mensaje
- [ ] Si red recupera en `/sinconeccion` → auto `Navigator.pop()`
- [ ] Versión actual (`versionActual` de `versiones.dart`) visible en esquina
- [ ] 6 formas glassmorphism animadas de fondo (`glass_objects.dart`)

---

## US-SPLASH-002: Historial de Versiones Inmutable

**Card:**  
Como **equipo de desarrollo/soporte**  
Quiero **fuente única de verdad de versión desplegada con changelog**  
Para **diagnosticar issues reportados por usuarios**

**Conversation:**  
`versiones.dart` define `AppVersion` (const, inmutable: version, titulo, fecha, cambios[], esCritica) y `historialDeVersiones` (57 entradas desde Beta 0.00.000 2025-12-18 hasta Beta 0.07.053 2026-05-24). `versionActual = historialDeVersiones[0].version` usada en splash y diagnósticos.

**Confirmation:**
- [ ] `versionActual` coincide con `defines.json` / build metadata
- [ ] Historial inmutable (const) — no modificable en runtime
- [ ] Cada versión tiene: título, fecha, lista cambios, flag crítica
- [ ] Splash muestra `V.$versionActual` correctamente