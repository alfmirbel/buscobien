# Inventario de Elementos — Landing Pages por Actor / Catálogos Públicos (03_vistas)

**Directorio:** `lib\03_vistas\`
**Total archivos `.dart`:** 9 (uno por landing/segmento)
**Epic asociado:** [`02_Epics_EARS/03_vistas.md`](../../02_Epics_EARS/03_vistas.md)
**Features BDD:** [`03_Features_BDD/03_vistas/landing_pages_por_actor.feature`](../../03_Features_BDD/03_vistas/landing_pages_por_actor.feature) (10 escenarios)
**User Stories:** [`04_User_Stories/03_vistas.md`](../../04_User_Stories/03_vistas.md) (4 US)
**Fecha:** 2026-08-12
**Fuente:** Ingeniería inversa

---

## Tabla 1 — Resumen de componentes por landing

| # | Componente | Archivo | Líneas aprox. | Actor objetivo | CTA Principal | Funcional? | US-VIST |
|---|-------------|---------|---------------|----------------|---------------|-----------|---------|
| 1 | `LandingAgentesPage` | `pagina_promotores.dart` | 664 | Promotor | "Prueba Gratis"/"Publicar" | ✓ | US-VIST-002 |
| 2 | `LandingPropietariosPage` | `pagina_propietarios.dart` | 575 | Propietario | "Publicar Gratis Ahora" | ✓ | US-VIST-002 |
| 3 | `LandingHospedajePage` | `pagina_hospedaje.dart` | 562 | Hospedaje | "Aquí publicaras" | ✓ | US-VIST-002 |
| 4 | `LandingBusquedaPage` | `pagina_usuarios.dart` | 1044 | Comprador/Arrendatario | "Buscar" (CP) + carrusel | ✓ (híbrida) | US-VIST-003 |
| 5 | `LandingInmobiliariasPage` | `pagina_inmobiliarias.dart` | 637 | Inmobiliaria | "PROXIMAMENTE REGISTRO" + form | Parcial | US-VIST-004 |
| 6 | `LandingMarketPage` | `pagina_market.dart` | 539 | Retail/Market | "AQUÍ PODRAS SUBIR..." | ✗ placeholder | US-VIST-004 |
| 7 | `LandingProveedoresPage01` | `pagina_proveedores.dart` | 571 | Proveedor | "PROXIMAMENTE..." | ✗ placeholder | US-VIST-004 |
| 8 | `LandingServiciosPage` | `pagina_servicios.dart` | 519 | Servicios | "PROXIMAMENTE CREAR..." | ✗ placeholder | US-VIST-004 |
| 9 | `LandingAsociacionesPage` | `pagina_asociaciones.dart` | 461 | Asociaciones | "Proximamente Registro" | ✗ placeholder | US-VIST-004 |

**Total líneas aprox: 5,572** (todas las landings son ConsumerWidget con estructura común Hero + secciones + Footer).

---

## Tabla 2 — Detalle por archivo

| # | Archivo | Clase principal | Líneas | Dependencias clave (import) | CTA / Acción | Estado | Comentario / Deuda técnica |
|---|---------|----------------|--------|------------------------------|---------------|--------|------------------------------|
| 1 | `pagina_promotores.dart` | `LandingAgentesPage` | 664 | `material`, `provider_menu_tipo_espacio`, `provider_menu_tipo_transaccion`, `provider_menu_tu_cuenta`, `provider_menu_nivel_gobierno`, `app_routes`, `Symbols`, `var_color_themes` | "Prueba Gratis"/"Publicar" → configura 4 providers + `pushReplacementNamed(principal)` | ✓ ok | NOTA: la clase se llama `LandingAgentesPage` aunque el archivo dice "promotores" — incoherencia histórica. Color navy/gold hardcoded |
| 2 | `pagina_propietarios.dart` | `LandingPropietariosPage` | 575 | `material`, `05_provider_menus/*` (4), `app_routes`, `Symbols` | "Publicar Gratis Ahora" → configura 4 providers propietario + `pushReplacementNamed(principal)` | ✓ ok | Paleta azul/rojo hardcoded |
| 3 | `pagina_hospedaje.dart` | `LandingHospedajePage` | 562 | `material`, `05_provider_menus/*` (5: + `seleccionPrincipal`), `app_routes`, `Symbols` | "Aquí publicaras" → configura 5 providers + `pushReplacementNamed(principal)` | ✓ ok | Paleta azul/ámbar hardcoded |
| 4 | `pagina_usuarios.dart` | `LandingBusquedaPage` | 1044 | `material`, `findPropiedadesEstadosde10en10Provider`, `codigoPostalBusquedaProvider`, `Symbols`, `08_pantallas`, `22_imagenes` (mini carousel) | "Buscar" → valida CP + actualiza provider + navega localidades. Carrusel paginado `paramSkip += 10` | ✓ ok | **Landing híbrida**: 2x tamaño del resto. Paginación manual sin `infinite_scroll` package — riesgo de race conditions en scroll rápido. Cards: usar `PaginaCarouselFotosMini` |
| 5 | `pagina_inmobiliarias.dart` | `LandingInmobiliariasPage` | 637 | `material`, `Symbols` | CTA placeholder + form contacto TextFormField onSubmit NO conectado | ⚠ Parcial | Única con form contacto parcial. Backend del form pendiente |
| 6 | `pagina_market.dart` | `LandingMarketPage` | 539 | `material`, `Symbols` | "AQUÍ PODRAS SUBIR..." sin acción real | ✗ placeholder | Texto inconsistente ("AQUÍ" mayúsculas). Refactor con template común |
| 7 | `pagina_proveedores.dart` | `LandingProveedoresPage01` | 571 | `material`, `Symbols` | "PROXIMAMENTE..."sin acción real | ✗ placeholder | Nombre clase con sufijo `01` (anti-pattern) |
| 8 | `pagina_servicios.dart` | `LandingServiciosPage` | 519 | `material`, `Symbols` | "PROXIMAMENTE CREAR..." sin acción real | ✗ placeholder | Texto CTA inconsistente vs otras landings |
| 9 | `pagina_asociaciones.dart` | `LandingAsociacionesPage` | 461 | `material`, `Symbols` | "Proximamente Registro" sin acción real | ✗ placeholder | Texto "Proximamente" sin acento; es la más corta |

---

## Notas críticas

- **9 ConsumerWidgets, 1 patrón**: estructura común completa (AppBar condicional + SingleChildScrollView + Hero + Beneficios + Stats + Features + Pasos + Footer + `derechosReservadosObscuro()`). Originalmente copy-paste; refactor a `LandingTemplate(config)` reduciría 5,572 líneas a <1,000.
- **Sólo 4/9 landings funcionales** (Promotores, Propietarios, Hospedaje, Usuarios). Las 5 restantes son placeholders pendientes de activación.
- **Colores `Color(0xFF...)` hardcoded** en todas las landings: **violan `ui_exceptions.dart`** y NO están registrados como excepciones. Deuda técnica documentada en el Epic y el US-VIST-001. Refactor: usar `appTheme` global o crear ColorScheme dedicados para cada segmento.
- **`LandingAgentesPage` (promotores.dart)** — nombre de clase inconsistente con el archivo (promotor ≠ agente). Sugerido renombrar a `LandingPromotoresPage`.
- **`LandingProveedoresPage01`** — sufijo `01` sin significado. Sugerido eliminar.
- **Inconsistencias textuales**: "PROXIMAMENTE" en 3 landings vs "Proximamente" (sin acento) en asociaciones, vs "AQUÍ PODRAS..." en market. Estandarizar.
- **`pagina_usuarios.dart` (1,044 líneas)** es 2-3x del resto de landings por ser híbrida (landing + búsqueda viva). Candidata a split: `LandingBusquedaPage` + `BusquedaPropiedadesWidget` reutilizable.
- **Paginación manual `paramSkip += 10`** en `usuarios.dart`: no usa paquete `infinite_scroll_pagination`. Riesgo de race conditions al hacer scroll rápido (peticiones se solapan, invalidación de respuestas antiguas).
- **Form Inmobiliarias sin backend**: desconectado, submit no persiste.
- **Sin tests**: ningún widget test de landings. Smoke test global cubre arranque pero no el contenido.
- **Imports de providers globales (`05_provider_menus/*`) desde las landings funcionales** — acoplamiento directo a providers mutables (deuda ya documentada en 05_provider_menus).
