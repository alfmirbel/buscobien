# Iniciativa — OKRs (Objetivos y Resultados Clave)

**Fecha:** 2026-08-12  
**Fuente:** Ingeniería inversa de `D:\buscobien\lib` + contexto de negocio de `AGENTS.md`  
**Alcance:** Definición estratégica de la iniciativa Buscobien a partir del código existente (no especulación de producto).

---

## Contexto de Negocio (resumen)

Buscobien es una **plataforma de promoción inmobiliaria para México** (Flutter + Riverpod 3.x + Freezed + Dio + Google Maps) que conecta a **promotores, propietarios, inmobiliarias, proveedores, asociaciones, hospedaje, market y servicios** con compradores/arrendatarios. La arquitectura es **Flutter App → Node.js API (repo separado) → CouchDB** (`buscobien_*` en `https://citigov.cloud:6984`). Flutter **nunca** accede a CouchDB directamente; todo pasa por la API con JWT. La app es multiplataforma (Web/WASM, Windows, Android, iOS) con Material Design 3 obligatorio (`appTheme` en `lib/20_var_globales/var_color_themes.dart`).

El código cubre: **catálogo de propiedades** (búsqueda, filtrado por nivel gobierno/tipo espacio/tipo transacción, paginación 10-en-10, detalle + PDF), **motor social** (Conocidos: contactos, chat privado, invitaciones; Grupos: descubrimiento, chat, avisos, publicaciones), **listas de favoritos compartibles**, **geolocalización** (Google Maps + localidades SEPOMEX por CP), **gestión de fotos** (carousel, listado, subida múltiple, ordenamiento), **autenticación JWT** (login, registro, recuperación password, avatar), **detección OS/conectividad** y **widgets globales M3 reutilizables**.

---

## Objetivo (Iniciativa)

> **Consolidar Buscobien como la plataforma de referencia en México para la promoción, descubrimiento y gestión colaborativa de inmuebles, integrando catálogo geo-referenciado, motor social y herramientas de productividad para profesionales inmobiliarios, todo bajo una experiencia multiplataforma nativa Material Design 3.**

---

## Resultados Clave (Key Results) — 5 KRs medibles

| KR | Descripción | Métrica objetivo | Evidencia en código |
|----|-------------|------------------|---------------------|
| **KR1** | **Cobertura funcional completa del catálogo de propiedades** | 100% de flujos críticos (búsqueda → filtro → paginación → detalle → PDF → mapa) operativos y testeados | `lib/08_pantallas/inicio/*` (15 archivos), `lib/08_pantallas/propiedades/*` (3), `lib/14_geolocalizacion/*` (4), `lib/03_vistas/*` (9 catálogos por actor) |
| **KR2** | **Motor Social funcional: Conocidos + Grupos** | ≥ 80% de casos de uso sociales (invitaciones, chat 1:1, chat grupal, avisos, publicaciones, descubrimiento) implementados | `lib/08_pantallas/tu_cuenta/conocidos/` (12 archivos), `lib/08_pantallas/tu_cuenta/grupos/` (21 archivos), models Freezed + providers Riverpod |
| **KR3** | **Experiencia multiplataforma nativa (Web/WASM, Windows, Android, iOS) con M3** | 100% de widgets usan `appTheme` (sin colores hardcoded), `NavigationBar`/`FilledButton`, iconos rango `0xe000-0xe900`, `if (!mounted) return;` tras todo `await` | `lib/main.dart` (M3 theme), `lib/20_var_globales/var_color_themes.dart` (`appTheme`), `lib/60_global_widgets/*` (7 widgets globales), `lib/42_sistema_operativo/detecta_os.dart` |
| **KR4** | **Gestión de medios (fotos) completa para propiedades y usuario** | Subida múltiple, compresión, carousel, listado (cuadrícula/lista), reordenamiento, persistencia IDs | `lib/22_imagenes/` (28 archivos): `tus_espacios_fotos_propiedad/manejo_de_fotos/` (5 subcarpetas funcionales), `inicio_fotos_usuario/` (2) |
| **KR5** | **Arquitectura desacoplada y segura: Flutter ↔ API ↔ CouchDB** | 0 credenciales CouchDB en Flutter; JWT en secure storage (móvil) / shared_preferences (web); endpoints centralizados; encriptación AES para datos sensibles | `lib/40_security/` (5 archivos: `direccionip.dart` creds por env, `encriptar.dart`, `generate_hash.dart`, `urls_endpoints_espacios.dart`), `lib/10_user_login/usuario_login/session_storage.dart` (abstracción plataforma), `lib/10_user_login/usuario_login/session_repository.dart` |

---

## Métricas de seguimiento (leading indicators)

| Métrica | Frecuencia | Responsable | Fuente |
|---------|------------|-------------|--------|
| % de flujos catálogo con test de humo (`flutter test`) | Sprint | QA | `test/widget_test.dart` |
| Cobertura de providers Riverpod con `build_runner` sin errores | Push | Dev | `dart run build_runner build --delete-conflicting-outputs` |
| Alertas `flutter analyze` (estilo, `mounted`, M3) | CI | Dev | `flutter analyze` |
| Tiempo de build web WASM (`flutter build web --wasm`) | Release | DevOps | Pipeline |
| Latencia API Node.js → CouchDB (p95) | Continuo | Backend | APM externo |

---

## Notas de trazabilidad

- Estos OKRs derivan **exclusivamente** de la ingeniería inversa del código en `D:\buscobien\lib` (218 archivos `.dart`).
- No incluyen especulación de roadmap futuro; reflejan lo que **ya está implementado** en el código.
- Cada KR referencia evidencia concreta (rutas de archivo con backslash, convención del repo).
- Documento complementario: `02_Lean_Canvas.md` para desglose de modelo de negocio y ROI.