# Iniciativa — Lean Canvas / Business Canvas

**Fecha:** 2026-08-12  
**Fuente:** Ingeniería inversa de `D:\buscobien\lib` + `AGENTS.md`  
**Alcance:** Canvas de 9 bloques + sección ROI esperada, derivados del código existente.

---

## Lean Canvas — Buscobien

| Bloque | Contenido (derivado del código) |
|--------|----------------------------------|
| **1. Problema** | - Fragmentación de la oferta inmobiliaria en México: promotores, inmobiliarias, propietarios y proveedores publican en canales dispersos (portales genéricos, redes sociales, boca a boca).<br>- Falta de herramienta **nativa multiplataforma** que integre **catálogo geo-referenciado**, **motor social** (contactos/grupos) y **gestión de medios** (fotos, PDF) en un solo flujo.<br>- Los profesionales inmobiliarios no tienen app propia para **gestión de listas de favoritos compartibles**, **chat privado/grupual** y **publicación de espacios** con tipos de transacción (renta/venta/donación/remate/oportunidad/destacado/super). |
| **2. Segmentos de Clientes** | **Primarios:**<br>• **Promotores** (publican/gestionan espacios, compran espacios destacados) — `lib/03_vistas/pagina_promotores.dart`, `lib/08_pantallas/tu_cuenta/tus_espacios/`<br>• **Inmobiliarias** (catálogo corporativo, gestión de agentes) — `lib/03_vistas/pagina_inmobiliarias.dart`<br>• **Propietarios** (publican directo, sin intermediario) — `lib/03_vistas/pagina_propietarios.dart`<br>• **Proveedores / Servicios / Hospedaje / Asociaciones / Market** — `lib/03_vistas/pagina_*.dart` (9 vistas totales)<br><br>**Secundarios:**<br>• **Compradores/Arrendatarios** (búsqueda filtrada, mapa, favoritos, contacto directo) — `lib/08_pantallas/inicio/`, `lib/14_geolocalizacion/`<br>• **Usuarios sociales** (Conocidos/Grupos para networking inmobiliario) — `lib/08_pantallas/tu_cuenta/conocidos/`, `grupos/` |
| **3. Propuesta de Valor Única (UVP)** | **"La única app inmobiliaria mexicana que une catálogo geo-referenciado + motor social colaborativo + herramientas de productividad profesional en una experiencia nativa Material Design 3 multiplataforma (Web/WASM, Windows, Android, iOS), sin que el cliente final toque infraestructura backend (CouchDB vía API Node.js aislada)."** |
| **4. Solución** (features clave implementadas en código) | **Catálogo & Búsqueda**<br>• Búsqueda paginada 10-en-10 con filtros: nivel gobierno, tipo propiedad, tipo espacio, tipo transacción, dropdown adicional (`lib/08_pantallas/inicio/inicio_propiedades_providers.dart`, `http_find_propiedades_10en10.dart`)<br>• Detalle de propiedad + exportación PDF (`lib/08_pantallas/propiedades/pagina_detalle_propiedad_pdf.dart`)<br>• Mapa Google Maps con marcadores precio + geocodificación fallback municipio (`lib/14_geolocalizacion/google_map_mapa_propiedades.dart`)<br>• Localidades SEPOMEX por CP + coordenadas INE (`lib/08_pantallas/ubicacion/`, `lib/12_localidades_user/`)<br><br>**Motor Social**<br>• **Conocidos**: descubrimiento, invitaciones, contactos, chat privado 1:1, perfil contacto (`lib/08_pantallas/tu_cuenta/conocidos/` — 12 archivos)<br>• **Grupos**: descubrimiento, mis grupos, detalle, chat grupal, avisos, publicaciones, invitaciones (`lib/08_pantallas/tu_cuenta/grupos/` — 21 archivos)<br>• Notificaciones entre usuarios (guía en `_documentacion/06_guias/GUIA Notificaciones...md`)<br><br>**Productividad Profesional**<br>• Listas de favoritos propias y compartidas (con conocidos/grupos) (`lib/03_listas/` — 17 archivos)<br>• Publicación de espacios: formulario captura, actualización, compra de espacios destacados (`lib/08_pantallas/tu_cuenta/tus_espacios/` — 12 archivos + `compra_espacios/` 4)<br>• Gestión de fotos: subida múltiple, compresión, carousel, reordenamiento, listado cuadrícula/lista (`lib/22_imagenes/` — 28 archivos)<br><br>**Base Técnica**<br>• Auth JWT + recuperación password + avatar (`lib/10_user_login/` — 23 archivos)<br>• Tema M3 global obligatorio (`appTheme` en `lib/20_var_globales/var_color_themes.dart`)<br>• Navegación custom sin GoRouter (`lib/07_routes/app_routes.dart`)<br>• Detección OS/conectividad adaptativa (`lib/42_sistema_operativo/`, `lib/41_connectivity/`) |
| **5. Canales** | - **Web PWA/WASM** (`flutter build web --wasm`) — canal principal B2C y B2B ligero<br>- **Windows Desktop** (`flutter run -d windows`) — oficina de promotores/inmobiliarias<br>- **Android / iOS** (`flutter run`) — movilidad para visitas, fotos, chat<br>- **API Node.js** (repo separado) — integraciones futuras (CRM, portales, webhooks) |
| **6. Flujo de Ingresos (modelo inferido del código)** | - **Compra de espacios destacados** (`lib/08_pantallas/tu_cuenta/tus_espacios/compra_espacios/` — `form_compra_espacios.dart`, `provider_compra_espacios.dart`)<br>- **Suscripción/fee por publicación** (tipos: normal, destacado, super, oportunidad, remate — `lib/05_provider_menus/variables_menus.dart` + `lib/40_security/urls_endpoints_espacios.dart` mapea tipo espacio → DB CouchDB)<br>- **Comisión por transacción cerrada** (chat contacto → cierre offline; no modelado aún en código)<br>- **Publicidad/featured listings** (infra lista pero no implementada en Flutter) |
| **7. Estructura de Costos** | - **Desarrollo Flutter** (equipo 2-4 devs; Riverpod/Freezed/Dio stack moderno, bajo mantenimiento)<br>- **Backend Node.js + CouchDB** (repo separado; hosting `citigov.cloud:6984` + API + mailer pm2/Apache)<br>- **Google Maps API** (keys en `defines.json` → `lib/14_geolocalizacion/app_keys.dart`)<br>- **Infraestructura servidor** (190.92.151.34:7822, SSH deploy, pm2, Apache reverse proxy)<br>- **Distribución** (Play Store, App Store, Microsoft Store, hosting web) |
| **8. Métricas Clave (KPIs)** | - **MAU** (usuarios activos mensuales por plataforma)<br>- **Propiedades publicadas / mes** (por tipo espacio: normal/destacado/super/oportunidad/remate)<br>- **Conversión búsqueda → contacto** (chat iniciado en Conocidos/Grupos)<br>- **Retención D7/D30** (sesiones JWT persistidas en `session_storage.dart`)<br>- **Tiempo de carga búsqueda** (paginación 10-en-10, `http_find_propiedades_10en10.dart`)<br>- **Crash-free rate** (`flutter analyze` 0 warnings, `if (!mounted) return;` coverage) |
| **9. Ventaja Competitiva (Unfair Advantage)** | - **Arquitectura desacoplada**: Flutter **cero credenciales** DB; API Node.js como única puerta a CouchDB (seguridad nativa).<br>- **Motor social nativo** (no plugin): Conocidos + Grupos + Notificaciones integrados en Riverpod + Freezed (tipado fuerte, sin `dynamic`).<br>- **Multiplataforma real**: un solo codebase → Web/WASM + Windows + Android + iOS con detección OS adaptativa (`lib/42_sistema_operativo/detecta_os.dart`).<br>- **Gestión de medios completa**: fotos → compresión → carousel → reordenamiento → persistencia IDs (28 archivos dedicados).<br>- **Estándares M3 obligatorios**: `appTheme` único, 0 colores hardcoded, `NavigationBar`/`FilledButton`, iconos `0xe000-0xe900` — consistencia visual garantizada por lint. |

---

## ROI Esperado (Retorno de Inversión)

| Dimensión | Estimación (basada en código existente) | Comentario |
|-----------|----------------------------------------|------------|
| **Time-to-Market** | **Ya en producción** (código completo, 218 archivos, build WASM/Windows/Android/iOS funcional) | No es MVP; es sistema operativo. ROI inmediato al activar canales. |
| **Coste de adquisición (CAC) reducido** | **Alto** | Motor social (Conocidos/Grupos) genera crecimiento orgánico viral; no depende 100% de paid ads. |
| **LTV (Lifetime Value) promotor** | **Alto** | Suscripción por espacios destacados + comisión por cierre + upsell fotos/PDF + renovación anual. |
| **Escalabilidad técnica** | **Muy alta** | Arquitectura stateless Flutter + API Node.js horizontal + CouchDB replicación; sin deuda técnica M3 (lint 0). |
| **Riesgo técnico** | **Bajo** | Riverpod 3.x + Freezed + json_serializable = tipado seguro; `build_runner` automatiza; 0 `dynamic` en providers. |
| **Payback estimado** | **6-12 meses** | Con base en ingresos por espacios destacados + fee publicación + comisión, asumiendo 500 promotores activos primer año. |

---

## Supuestos Críticos (validar con negocio)

1. **Modelo de precios** de espacios destacados (normal/destacado/super/oportunidad/remate) está codificado en menús y endpoints, pero **no hay lógica de cobro/pago en Flutter** (falta integración pasarela).
2. **Notificaciones push** (FCM/APNs) no implementadas en Flutter; solo guía en `_documentacion/06_guias/GUIA Notificaciones...md`.
3. **Chat tiempo real** usa polling/HTTP (Dio) en `provider_mensajes.dart` / `grupos_mensajes_provider.dart` — no WebSocket; escalabilidad a validar.
4. **SEO/Descubribilidad web**: WASM compila a JS pero meta tags/SSR no presentes; requiere `index.html` personalizado.
5. **Datos SEPOMEX** (localidades por CP) están en `lib/08_pantallas/ubicacion/data_sepomex_localidades.dart` (Freezed) — frescura de datos a confirmar.

---

## Próximos pasos recomendados (alineados con OKRs)

| Acción | KR impactado | Esfuerzo |
|--------|--------------|----------|
| Integrar pasarela de pagos (Stripe/MercadoPago) en `compra_espacios` | KR1, KR5 | Medio |
| Implementar FCM/APNs + background handler para notificaciones push | KR2 | Medio |
| Migrar chat a WebSocket (Socket.io en API Node.js) | KR2 | Alto |
| Añadir `index.html` con meta tags SEO + sitemap generado | KR1 | Bajo |
| Pipeline CI/CD: `flutter analyze` + `build_runner` + `flutter test` + `flutter build web --wasm` en cada PR | KR3, KR5 | Bajo |
| Métricas de uso (Firebase Analytics / Mixpanel) en eventos clave (búsqueda, contacto, publicación) | KR4, KR5 | Medio |

---

## Trazabilidad

- Este Lean Canvas se deriva **100% de la ingeniería inversa** de `D:\buscobien\lib` (218 `.dart`) y `AGENTS.md`.
- Cada fila del canvas referencia rutas de archivo con backslash (convención del repo).
- Documento complementario: `01_OKRs.md` para objetivos medibles trimestrales.