# Iniciativa OKRs & Lean Canvas — BuscoBien (01_Iniciativa_OKRs_LeanCanvas)

**Proyecto:** BuscoBien — Plataforma de promoción inmobiliaria, México  
**Fecha:** 2026-09-05  
**Versión del plan:** Fase 1 (PLAN_DE_TRABAJO_FASE1.md)  
**Stack:** Flutter 3.x + Riverpod 3.x + Freezed + Dio + Google Maps + CouchDB (via Node.js API) + Material Design 3

---

## OKRs (Objectives and Key Results)

### Objetivo O1: Documentar completamente la arquitectura existente para nuevos desarrolladores

| KR | Descripción | Métrica | Estado |
|----|-------------|---------|--------|
| KR1.1 | Documentar todos los subdirectorios de `lib/` con Epic + Feature BDD + US + Inventario | 100% cobertura (todos los subdirs del `PLAN_DE_TRABAJO_FASE1.md`) | 🔄 En progreso |
| KR1.2 | Generar modelos Freezed + json_serializable para todas las entidades con `build_runner` | 100% modelos Freezed | ✅ En código |
| KR1.3 | Documentar todas las 19 bases de datos CouchDB con diccionario de datos + Mango queries | 19/19 DBs documentadas | ✅ Completado |

### Objetivo O2: Eliminar deuda técnica documentada en la app

| KR | Descripción | Métrica | Estado |
|----|-------------|---------|--------|
| KR2.1 | Migrar `MyTextFieldPassword` variables globales a estado interno del widget | 0 variables `isHidden*` globales | 🔄 Documentado como deuda |
| KR2.2 | Migrar `encriptar.dart` de AES-256 hardcoded (deprecated) a `flutter_secure_storage` | 0 funciones `@Deprecated` activas | 🔄 Documentado como riesgo |
| KR2.3 | Eliminar duplicación `_BurbujaPropiedad` / `_BurbujaLista` entre conocidos y grupos | 1 componente reutilizado | 🔄 Documentado |
| KR2.4 | Eliminar `MD5` / `SHA1` disponibles en `generate_hash.dart` — solo `SHA-256` | 1 algoritmo aprobado | 🔄 Documentado como riesgo |
| KR2.5 | Migrar persistencia de tema de Riverpod-only a `shared_preferences` / `flutter_secure_storage` | Tema persiste al reiniciar | 🔄 Documentado como deuda |

### Objetivo O3: Estabilizar la arquitectura de navegación y rutas

| KR | Descripción | Métrica | Estado |
|----|-------------|---------|--------|
| KR3.1 | Validar que `setPathUrlStrategy()` funciona en Web + Windows | URL limpia sin `#` | ✅ En código |
| KR3.2 | Verificar que `AppRoutes.routeGenerate()` maneja todos los parámetros de navegación | Sin rutas rotas | ✅ En código |

### Objetivo O4: Cumplir Material Design 3 en toda la app

| KR | Descripción | Métrica | Estado |
|----|-------------|---------|--------|
| KR4.1 | Eliminar todos los colores hardcoded `Colors.xxx` | 0 excepciones | ✅ `ui_exceptions.dart` documentado |
| KR4.2 | Migrar `BottomNavigationBar` → `NavigationBar` (ya completado) | Navegación M3 | ✅ En código |
| KR4.3 | Verificar iconos en rango `0xe000`–`0xe900` | Sin `_outlined` variants | ✅ En código |

---

## Lean Canvas por Subdirectorio

### 01_splash_screen

| Dimensión | Hallazgo |
|-----------|----------|
| **Problema** | Usuario necesita tiempo de carga mientras app inicializa JWT + verifica sesión |
| **Solución** | Splash con PostFrameCallback → verifica token almacenado → redirige a home/principal |
| **Cliente** | Usuario final (comprador, vendedor, inquilino) |
| **Propuesta** | Pantalla de bienvenida sin lógica de negocio |
| **Canal** | App store / APK directo / Web |
| **Costos** | Mantenimiento de estado splash (1 archivo, ~100 líneas) |
| **KPIs** | Tiempo de carga < 2s, cero crash en splash |

### 02_principal_screen (home)

| Dimensión | Hallazgo |
|-----------|----------|
| **Problema** | Usuario llega a home pero no sabe qué hacer si no está logueado |
| **Solución** | Build condicional: logged-in → principal normal; no-logged → login |
| **Cliente** | Usuario no autenticado |
| **Propuesta** | Navegación bifurcada por sesión |
| **Canal** | `lib/02_principal_screen/` |
| **Costos** | Estado de sesión en Riverpod |
| **KPIs** | Redirección correcta 100% de las veces |

### 03_vistas (9 landing pages)

| Dimensión | Hallazgo |
|-----------|----------|
| **Problema** | Diferentes actores (Promotores, Propietarios, Hospedaje, etc.) necesitan landing pages M3 distintas |
| **Solución** | 9 landing pages con estructura común M3 + colores `appTheme` |
| **Cliente** | Agentes inmobiliarios, propietarios, hospedajes, usuarios genéricos |
| **Propuesta** | Estructura reusable con CTA funcionales |
| **Canal** | `lib/03_vistas/` |
| **Costos** | 9 archivos (LandingAgentesPage, LandingPropietariosPage, etc.) |
| **KPIs** | CTA clickeable, búsqueda CP funcional |

### 03_listas (Hub central listas)

| Dimensión | Hallazgo |
|-----------|----------|
| **Problema** | Usuario necesita organizar propiedades en listas (propias/recibidas/enviadas) |
| **Solución** | Hub central 3 tabs con create/list/share/bulk |
| **Cliente** | Usuario logueado |
| **Propuesta** | IDs SHA1, selector checkbox, compartir max 5 contactos |
| **Canal** | `lib/03_listas/` (17 archivos) |
| **Costos** | PageMisListas 1,222 líneas |
| **KPIs** | Crear lista + compartir < 3 toques |

### 04_provider (temas)

| Dimensión | Hallazgo |
|-----------|----------|
| **Problema** | Usuario no puede personalizar tema visual |
| **Solución** | Selector 9 temas (Radio buttons) + `StateProvider<SelectColorProvider>` |
| **Cliente** | Desarrollador/usuario final |
| **Propuesta** | Temas M3 predefinidos (INE, MC, MOR, PAN, PRD, PRI, PT, PVEM + dark) |
| **Canal** | `lib/04_provider/` |
| **Costos** | Sin persistencia (debe migrar a secure storage) |
| **KPIs** | Cambio de tema inmediato (reactivo) |

### 05_provider_menus

| Dimensión | Hallazgo |
|-----------|----------|
| **Problema** | Menús y elementos de navegación duplicados o inconsistentes |
| **Solución** | Provider centralizado de elementos de menú (iconos, etiquetas, rutas) |
| **Cliente** | Desarrollador |
| **Propuesta** | `var_elementos_menus.dart` como fuente única de verdad |
| **Canal** | `lib/05_provider_menus/` |
| **Costos** | Mantenimiento al agregar nuevas pantallas |
| **KPIs** | Menú consistente en todas las pantallas |

### 07_routes (navegación)

| Dimensión | Hallazgo |
|-----------|----------|
| **Problema** | Navegación compleja sin GoRouter |
| **Solución** | `AppRoutes.routeGenerate()` como `onGenerateRoute` + `routes_parameters.dart` |
| **Cliente** | Usuario + Desarrollador |
| **Propuesta** | Navegación basada en strings con parámetros tipados |
| **Canal** | `lib/07_routes/` |
| **Costos** | Mantenimiento manual de rutas |
| **KPIs** | Navegación sin errores de ruta |

### 08_pantallas

| Dimensión | Hallazgo |
|-----------|----------|
| **Problema** | Módulo más grande del proyecto (~50 archivos, ~30,000 líneas) |
| **Solución** | Dividir en hitos: inicio, perfil, propiedades, tus_espacios, conocidos, grupos, ubicacion, widgets_comunes |
| **Cliente** | Usuario final |
| **Propuesta** | Catálogo completo con detalle + PDF + filtros |
| **Canal** | `lib/08_pantallas/` |
| **Costos** | 3 archivos gigantes = 86% del módulo |
| **KPIs** | Rendimiento scroll en catálogo |

### 10_user_login

| Dimensión | Hallazgo |
|-----------|----------|
| **Problema** | Autenticación JWT segura con storage diferente por plataforma |
| **Solución** | `flutter_secure_storage` (mobile) + `shared_preferences` (web/Windows) |
| **Cliente** | Usuario final |
| **Propuesta** | Login con JWT + interceptor Dio auto-token |
| **Canal** | `lib/10_user_login/` |
| **Costos** | Manejo de token expirado |
| **KPIs** | Login sin errores de token |

### 12_localidades (localidades)

| Dimensión | Hallazgo |
|-----------|----------|
| **Problema** | Búsqueda por CP + datos SEPOMEX + Google Maps |
| **Solución** | Hub localidades con búsqueda CP + mapa + lista maestra |
| **Cliente** | Usuario buscando propiedades por zona |
| **Propuesta** | Integración SEPOMEX + GMaps |
| **Canal** | `lib/12_localidades/` |
| **Costos** | Duplicación de screen_maestro vs pagina_principal |
| **KPIs** | Búsqueda CP < 1s |

### 14_geolocalizacion (app_keys + geo)

| Dimensión | Hallazgo |
|-----------|----------|
| **Problema** | Credenciales CouchDB y Google Maps se inyectan en compile-time |
| **Solución** | `String.fromEnvironment()` en `app_keys.dart` + `direccionip.dart` |
| **Cliente** | Desarrollador/CI |
| **Propuesta** | `--dart-define-from-file=defines.json` |
| **Canal** | `lib/14_geolocalizacion/` |
| **Costos** | `defines.json` no versionado (.gitignore) |
| **KPIs** | Build sin fugas de credenciales |

### 20_var_globales (temas + elementos)

| Dimensión | Hallazgo |
|-----------|----------|
| **Problema** | Colores inconsistentes entre widgets |
| **Solución** | `appTheme` global (ColorScheme) + `ui_exceptions.dart` |
| **Cliente** | Desarrollador |
| **Propuesta** | `var_color_themes.dart` como única fuente de color |
| **Canal** | `lib/20_var_globales/` |
| **Costos** | Migración de colores hardcoded existentes |
| **KPIs** | 0 colores `Colors.xxx` |

### 22_imagenes (fotos propiedad/usuario)

| Dimensión | Hallazgo |
|-----------|----------|
| **Problema** | Gestión de fotos en 3 vistas sincronizadas + compresión + orden |
| **Solución** | Carousel + Cuadros + Listado drag&drop con persistencia PUT |
| **Cliente** | Usuario propietario |
| **Propuesta** | Subida múltiple comprimida + reorden con PUT API |
| **Canal** | `lib/22_imagenes/` |
| **Costos** | `flutter_image_compress` no soporta Web |
| **KPIs** | Subida < 5s por foto |

### 40_security (credenciales + hash + endpoints)

| Dimensión | Hallazgo |
|-----------|----------|
| **Problema** | Flutter no debe tocar CouchDB + passwords deben tener hash |
| **Solución** | SHA-256 para passwords, tokens reset 1h, AES-256 legacy deprecated |
| **Cliente** | Usuario + Backend |
| **Propuesta** | `direccionip.dart` (env), `encriptar.dart` (deprecated), `generate_hash.dart`, `generate_reset_token.dart` |
| **Canal** | `lib/40_security/` |
| **Costos** | AES hardcoded key/iv → riesgo si se usa |
| **KPIs** | Cero credenciales en código fuente |

### 41_connectivity (detección red)

| Dimensión | Hallazgo |
|-----------|----------|
| **Problema** | App se queda sin datos sin indicar offline |
| **Solución** | Provider reactivo WiFi/Mobile/None + pantalla offline |
| **Cliente** | Usuario móvil |
| **Propuesta** | `checaPlataformaProvider` + pantalla de recuperación |
| **Canal** | `lib/41_connectivity/` |
| **Costos** | Monitoreo de conexión constante |
| **KPIs** | Detección < 1s |

### 42_sistema_operativo (detección plataforma)

| Dimensión | Hallazgo |
|-----------|----------|
| **Problema** | Comportamiento diferente por plataforma (web/mobile/desktop) |
| **Solución** | `kIsWeb` + `defaultTargetPlatform` en provider |
| **Cliente** | Desarrollador |
| **Propuesta** | `ElementoPlataforma` con 7 plataformas |
| **Canal** | `lib/42_sistema_operativo/` |
| **Costos** | Testing en todas las plataformas |
| **KPIs** | Detección correcta en Web + Windows + Android |

### 60_global_widgets (widgets reutilizables)

| Dimensión | Hallazgo |
|-----------|----------|
| **Problema** | Botones, inputs, dialogs, FutureBuilder repetidos en todas las pantallas |
| **Solución** | Widgets globales M3: MyButton, MyTextField, SquareTile, showMessageDialog, state* FutureBuilder, generaCantidad, derechosReservados |
| **Cliente** | Desarrollador |
| **Propuesta** | 6 widgets/utilidades globales + `appTheme` obligatorio |
| **Canal** | `lib/60_global_widgets/` |
| **Costos** | Variables globales `isHidden*` → estado compartido (deuda) |
| **KPIs** | Sin `Colors.xxx` en widgets |

### 08_pantallas/widgets_comunes

| Dimensión | Hallazgo |
|-----------|----------|
| **Problema** | Etiqueta de precio por tipo de transacción repetida en cards |
| **Solución** | Widget `letrerprecio()` puro con switch sobre `tipodetransaccion` |
| **Cliente** | Usuario viendo catálogo |
| **Propuesta** | 1 archivo, 38 líneas, 4 casos (Venta/Renta/Venta-Renta/Traspaso) |
| **Canal** | `lib/08_pantallas/widgets_comunes/` |
| **Costos** | Case default `Text("")` sin fallback |
| **KPIs** | Cero crash en renderizado |