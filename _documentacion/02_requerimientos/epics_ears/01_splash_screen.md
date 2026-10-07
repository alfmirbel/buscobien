# Epic: Pantalla Splash y Arranque Condicional (01_splash_screen)

**Directorio:** `lib\01_splash_screen\`  
**Archivos:** `splash_page.dart`, `glass_objects.dart`, `versiones.dart`  
**Fecha:** 2026-08-12  
**Fuente:** Ingeniería inversa

---

## Impact Mapping

| Objetivo de Negocio | Actor | Impacto | Entregable |
|---------------------|-------|---------|------------|
| App nativa multiplataforma con arranque robusto | Usuario final | Ve branding profesional mientras la app verifica conectividad y carga recursos críticos | Splash con timer 3s + glassmorphism UI |
| | Sistema | No avanza a shell principal sin conectividad confirmada | Gate de conectividad reactiva (`checaConeccionesProvider`) |
| | Desarrollo | Rastrea versión exacta desplegada | `versiones.dart` con historial 57 versiones |

---

## User Story Mapping

```
Usuario lanza app
       │
       ▼
┌─────────────────────────────┐
│ Splash Screen (3s mínimo)   │
│ - Logo + Branding           │
│ - Glassmorphism shapes      │
│ - Versión actual (Beta X.Y.Z)│
└──────────────┬──────────────┘
               │
       ┌───────┴───────┐
       ▼               ▼
┌─────────────┐ ┌─────────────┐
│ Conectado   │ │ Sin conex.  │
│ + timer OK  │ │ (auto-retry)│
└──────┬──────┘ └──────┬──────┘
       │               │
       ▼               ▼
┌─────────────────────────────┐
│ Shell Principal (/principal)│
└─────────────────────────────┘
```

---

## Especificación SDD / EARS

**Prefijo IDs:** `REQ-SPLASH-XXX`

| ID | Tipo EARS | Requerimiento | Evidencia | Estado |
|----|-----------|---------------|-----------|--------|
| REQ-SPLASH-001 | **Ubicuo** | El sistema mostrará una pantalla de splash con branding (logo, textos glassmorphism, versión) durante al menos 3 segundos en arranque en frío. | `lib\01_splash_screen\splash_page.dart:23` (duration), `versiones.dart:63` | En código |
| REQ-SPLASH-002 | **Ubicuo** | El sistema renderizará formas decorativas con efecto glassmorphism (blur + gradient) usando imágenes de assets como fondo. | `lib\01_splash_screen\glass_objects.dart:14-120` | En código |
| REQ-SPLASH-003 | **Estado** | Mientras el timer de 3s no haya completado, el sistema **no** navegará al shell principal aunque haya conectividad. | `splash_page.dart:54-58` `_minDurationPassed` flag | En código |
| REQ-SPLASH-004 | **Estado** | Mientras no haya conectividad confirmada (`checaConeccionesProvider != "Conectado"`), el sistema **no** navegará al shell principal aunque el timer haya completado. | `splash_page.dart:60-68` `_attemptNavigation()` | En código |
| REQ-SPLASH-005 | **Evento** | Cuando se cumplan **ambas** condiciones (timer completado + conectividad), el sistema navegará a `AppRoutes.principal` vía `Navigator.pushReplacementNamed`. | `splash_page.dart:60-68` | En código |
| REQ-SPLASH-006 | **Evento** | Cuando el proveedor de conectividad emita estado de error/desconectado tras el timer, el sistema navegará a `AppRoutes.sinconeccion` con mensaje contextual. | `splash_page.dart:70-78` `_navigateToErrorPage()` | En código |
| REQ-SPLASH-007 | **Evento** | Cuando la conectividad se recupere en pantalla de error, el sistema cerrará automáticamente la pantalla de error (`Navigator.pop()`). | `lib\41_connectivity\pagina_sin_coneccion.dart:25-30` | En código |
| REQ-SPLASH-008 | **No Deseado** | Si la inicialización de ubicación falla o tarda demasiado, el sistema **no** bloqueará el splash (ubicación diferida a background — código comentado). | `splash_page.dart:45-47` (comentado `_triggerLocationUpdate`) | En código |
| REQ-SPLASH-009 | **Complejo** | Mientras el splash esté visible, cuando `checaConeccionesProvider` cambie a "Conectado" Y `_minDurationPassed == true`, el sistema navegará a principal; si cambia a error ANTES del timer, esperará al timer. | `splash_page.dart:54-78` dual condition | En código |
| REQ-SPLASH-010 | **Ubicuo** | El sistema expondrá `versionActual` (String) como única fuente de verdad de versión desplegada, consumida por splash y diagnósticos. | `versiones.dart:63` `versionActual` | En código |

---

## Trazabilidad a Código

| Componente | Archivo | Líneas Clave |
|------------|---------|--------------|
| `SplashPage` (ConsumerStatefulWidget) | `splash_page.dart` | 23-180 |
| `_SplashPageState._startSplashTimer` | `splash_page.dart` | 50-58 |
| `_attemptNavigation` / `_navigateToErrorPage` | `splash_page.dart` | 60-78 |
| `build` con `ref.listen` reactivo | `splash_page.dart` | 80-130 |
| `GlassMorphismContainer2` / `GlassBox` | `glass_objects.dart` | 122-220 |
| `buildBackgroundShapes` (6 imágenes) | `glass_objects.dart` | 14-120 |
| `AppVersion` model + `historialDeVersiones` | `versiones.dart` | 6-63 |

---

## Notas de Arquitectura

- **Patrón dual**: Timer visual + conectividad reactiva (`ref.listen` sobre `AsyncValue`).
- **No bloquea por GPS**: Inicialización de ubicación comentada; se carga en background tras navegar.
- **Glassmorphism**: `BackdropFilter(ImageFilter.blur)` + gradientes — requiere `dart:ui`.
- **Versiones**: Historial inmutable (`const AppVersion`), 57 entradas desde 2025-12-18.