# Estrategia de Negocio: OKRs y Lean Canvas — BuscoBien

**Fase de SDLC:** Etapa 1 — Planeación y Estrategia  
**Plataforma:** BuscoBien (Inmobiliaria México)  
**Última actualización:** 2026-09-29  

---

## 1. Resumen Ejecutivo y Visión del Producto

**BuscoBien** es una plataforma tecnológica para la promoción, descubrimiento y gestión inmobiliaria en México. Su arquitectura desacoplada permite a compradores, arrendatarios, promotores e inmobiliarias publicar y explorar inmuebles mediante mapas interactivos, filtrado por niveles de gobierno (Federal, Estatal, Municipal), gestión de favoritos compartidos y una red social integrada (Conocidos y Grupos).

---

## 2. Lean Canvas — Modelo de Negocio

| Sección Lean Canvas | Detalle Operativo en Plataforma |
| :--- | :--- |
| **1. Problema** | • Fragmentación de la oferta inmobiliaria en México.<br>• Falta de herramientas de filtrado ágiles por nivel de gobierno y geolocalización precisa.<br>• Complejidad para compartir listados de inmuebles entre conocidos y grupos de interés.<br>• Altos costos de publicación para agentes promotores e inmobiliarias pequeñas. |
| **2. Segmentos de Clientes** | • **Usuarios finales**: Compradores y arrendatarios que buscan viviendas, comercios o terrenos.<br>• **Agentes promotores e inmobiliarias**: Usuarios profesionales que capturan, destacan y administran portafolios de inmuebles.<br>• **Redes comunitarias / Grupos**: Colectivos que buscan espacios compartidos o de interés específico. |
| **3. Propuesta de Valor Única** | • Plataforma ultrarrápida (Web WASM + Flutter) con mapa interactivo y geocodificación SEPOMEX.<br>• Motor Social integrado para compartir inmuebles directamente con Conocidos y Grupos de interés sin salir de la app.<br>• Publicación flexible por categorías de espacio (Normal, Destacado, Superdestacado, Oportunidad, Remate). |
| **4. Solución Implementada** | • Búsqueda paginada 10-en-10 con filtros reactivos (`inicio_propiedades_providers.dart`).<br>• Exportación de ficha técnica a PDF (`pagina_detalle_propiedad_pdf.dart`).<br>• Mapa Google Maps con marcadores dinámicos de precio.<br>• Chat y mensajería peer-to-peer y grupal (`lib/08_pantallas/tu_cuenta/`). |
| **5. Canales** | • Aplicación Web PWA/WASM en `https://buscobien.mx`.<br>• Aplicaciones nativas móviles Android/iOS y de escritorio Windows. |
| **6. Flujos de Ingreso** | • Suscripciones de promotores por límites de espacios.<br>• Venta de espacios destacados, superdestacados y de remate.<br>• Servicios de valor agregado para inmobiliarias. |
| **7. Estructura de Costos** | • Servidor VPS de CouchDB (`citigov.cloud:6984`) y Node.js API.<br>• Microservicio de correos PM2 (`buscobien-mailer`).<br>• Consumos de API de Google Maps Geocoding & Maps SDK. |
| **8. Métricas Clave** | • Número de propiedades activas publicadas.<br>• Ratio de interacción en el Motor Social (invitaciones aceptadas, mensajes enviados).<br>• Consultas de búsqueda por municipio/CP y descargas de PDF. |
| **9. Ventaja Injusta** | • Integración nativa de red social en la misma app de búsqueda inmobiliaria, reduciendo la fricción de compartir enlaces externos. |

---

## 3. Objetivos y Resultados Clave (OKRs)

### OKR 1: Experiencia de Usuario y Desempeño Visual
- **Objetivo**: Proveer una interfaz ultrarrápida, fluida y alineada a los estándares premium de Material Design 3.
- **KR 1.1**: Mantener el tiempo de renderizado de la primera pantalla bajo 1.5 segundos utilizando compilación Web WASM.
- **KR 1.2**: 100% de los widgets visuales adaptados al `ColorScheme` global (`appTheme`) sin colores hardcodeados.
- **KR 1.3**: Paginación transparente 10-en-10 sin bloqueos del hilo principal del navegador.

### OKR 2: Motor Social e Interacción de Usuarios
- **Objetivo**: Fomentar la colaboración activa entre usuarios mediante Conocidos y Grupos.
- **KR 2.1**: Permitir el envío de invitaciones y conexión peer-to-peer en menos de 3 clics.
- **KR 2.2**: Lograr una latencia de mensajería inferior a 500ms mediante la API reactiva de CouchDB/Node.js.
- **KR 2.3**: Soportar listas compartidas con sincronización automática de estado.

### OKR 3: Eficiencia Operativa y Seguridad
- **Objetivo**: Garantizar una arquitectura desacoplada y segura sin exponer datos sensibles.
- **KR 3.1**: 0 credenciales de base de datos expuestas en el cliente Flutter (100% mediante Node.js API en `defines.json`).
- **KR 3.2**: Persistencia de sesiones JWT segura mediante `flutter_secure_storage` y `shared_preferences`.
