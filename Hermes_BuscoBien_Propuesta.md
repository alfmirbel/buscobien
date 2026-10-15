# Hermes BuscoBien Core - Propuesta de Configuración y Uso de Agentes y Bots

## 1. Fundamento Metodológico

### 1.1 Cadena de Valor de Michael Porter (1985)
Herramienta de análisis estratégico que descompone la organización en actividades principales y de apoyo a través de las cuales la empresa crea valor para sus clientes y obtiene ventaja competitiva.

**Actividades Primarias:**
1. **Logística interna** - Almacenamiento y gestión de inventario de propiedades, fichas técnicas, planos.
2. **Operaciones** - Procesos de captura, validación, publicación y actualización de propiedades en buscobien.net.
3. **Logística externa** - Despacho de visitas, coordinación de recorridos, integración con agentes inmobiliarios.
4. **Marketing y Ventas** - Captación de leads, nutrimiento, conversión de interesados en clientes.
5. **Servicio postventa** - Seguimiento post-compra, fidelización, gestión de garantías y renovaciones.

**Actividades de Apoyo:**
1. **Infraestructura de la firma** - Servidores, bases de datos (CouchDB 35 bases), Qdrant, infraestructura Flutter/WASM.
2. **Desarrollo de tecnología** - Mantenimiento del framework Flutter, actualizaciones de modelos IA (Llama 3 local via Ollama), integraciones.
3. **Adquisiciones** - Gestión de proveedores de contenido multimedia, alianzas con portales inmobiliarios.
4. **Gestión de recursos humanos** - Capacitación al staff en uso de paneles de control, interpretación de métricas.
5. **Desarrollo de procedimientos** - Manuales de operación, políticas de calidad, estándares de UI/UX.

### 1.2 Business Model Canvas (Alexander Osterwalder & Yves Pigneur, 2010)
Herramienta de una sola página para diseñar, visualizar y evaluar el modelo de negocio.

| Bloque | Aplicación a BuscoBien + Hermes |
|--------|----------------------------------|
| **Segmentos de clientes** | Compradores de inmuebles, vendedores/promotores, inversores, corredores inmobiliarios, gestores de propiedades. |
| **Propuesta de valor** | Búsqueda inteligente y vectorial de propiedades, automatización de lead management, generación de presupuestos y contratos, monitoreo de cartera, atención 24/7 mediante bots Hermes. |
| **Canales** | Portal web buscobien.net, aplicación móvil Flutter, bots de Telegram, panel de promotor, email, redes sociales. |
| **Relación con clientes** | Self-service mediante panel interativo, asistencia automatizada por bot Hermes, agente dedicado por promotor (HITL cuando se requiere), comunidad de inversores. |
| **Flujos de ingreso** | Suscripción mensual por acceso al panel promotor, comisión por transacción cerrada por la plataforma, mantenimiento y soporte premium, generación de contratos automáticos. |
| **Recursos clave** | Infraestructura Hermes (gateway, modelos IA, bases de datos), catálogo de propiedades, integraciones con APIs externas, personal técnico. |
| **Actividades clave** | Configuración de perfiles Hermes por cliente, ingesta y enriquecimiento de datos, mantenimiento de modelos de búsqueda vectorial, orquestación de flujos de aprobación humana. |
| **Socios clave** | APIs inmobiliarias (EasyBroker, portales), fabricantes de tecnología de captura, servicios de firma electrónica, Google Maps. |
| **Estructura de costos** | Infraestructura cloud/on-premise, licencias de modelos IA, mantenimiento del portal, desarrollo y entrenamiento de agentes, marketing y adquisición de leads. |

---

## 2. Arquitectura de Implementación Hermes Agent para BuscoBien

### 2.1 Componentes del Sistema

| Componente | Descripción | Configuración |
|------------|-------------|---------------|
| **Hermes Gateway (Node.js/Express)** | Puerto 3000 (interno), middleware JWT, multi-tenant dispatch, WebSocket para chat, whitelist Telegram. | Configuración por `client_id` (promotor ID), integración con `--dart-define` de CouchDB. |
| **Nginx** | Puerto 443 (HTTPS), terminación TLS, validación JWT, enrutado a servicios internos. | Certificados SSL, reglas de reescritura para SEO, header `promotor_id`. |
| **Ollama (Windows/WSL2)** | Modelo Llama 3 8B cuantizado (Q4_K_M) en RTX 4060. | Inferencia local para extracción de entidades, generación de presupuestos, troubleshooting. |
| **NeMo Guardrails (WSL2, puerto 8000)** | Proxy semántico con Colang scripts. | *Input Rails*: bloqueo prompt injection, manipulación de precios. *Output Rails*: validación de formatos, cumplimiento normativo MX. |
| **Qdrant Vector DB** | Puerto 6333, colección `buscobien_catalog`. | Embeddings de descripciones propiedades, filtros por zona, precio, recamaras, promoter_id. |
| **CouchDB** | Puerto 5984, 35 bases referenciadas. | Documentos: propiedades, leads, usuarios, contratos,_historial. Esquema multi-tenant. |
| **Telegram Bot API** | Canal C2 para promotores y staff. | Bots por rol: `@bot_busqueda`, `@bot_promotor`, `@bot_soporte`. Botones inline para aprobaciones. |
| **Panel Web (Flutter/WASM)** | Frontend buscobien.net con nuevas rutas. | Rutas: `/mi-agente`, `/panel-promotor`, `/busqueda-avanzada`, `/contratos`. |
| **n8n Orchestrator** | Automatización de flujos: lead → presupuesto → contrato → mantenimiento. | Flujos visuales, nodos de espera de aprobación humana. |

### 2.2 Perfiles Hermes (Bots) para BuscoBien

| Perfil | Rol | Skills | Canal |
|--------|-----|--------|-------|
| **hermes-lead-qualifier** | Califica leads entrantes (web, Telegram, formulario web). | NLP, detección intención (compra/venta/renta), extracción presupuesto, zona, urgencia. | Webhook, Telegram, formulario web. |
| **hermes-prop-manager** | Gestiona el inventario de propiedades del promotor. | Ingesta PDF/ficha técnica, extracción metadatos, actualización CouchDB/Qdrant, alertas stock. | Panel promotor, Telegram. |
| **hermes-sre-guard** | Monitoreo de salud del sistema y propiedades. | Integración SNMP/ONVIF (opcional), alertas caídas, salud VRAM, logs auditoría. | Telegram, panel web. |
| **hermes-budget-bot** | Genera presupuestos personalizados. | Modelo Llama 3 + precios catálogo, lista materiales, mano de obra, márgenes. | Telegram, panel web, export PDF. |
| **hermes-legal-drafter** | Redacta contratos y documentos jurídicos. | Plantillas normativas MX (CONTRODE, PROFECO), generación cláusulas automáticas. | Panel web, export Firma Digital. |
| **hermes-maps-bot** | Integración geolocalización y análisis de zonas. | Google Maps API, tiempos traslado, escuelas cercanas, valuación zona. | Panel web, mapa ficha propiedad. |
| **hermes-analytics-bot** | Dashboard de métricas y KPIs. | Reportes ventas, conversión, tiempo promedio ciclo, inventario viejo. | Panel promotor, export CSV/Excel. |

### 2.3 Flujo de Trabajo Típico

```
[Lead entra por web/Telegram]
        │
        ▼
[hermes-lead-qualifier] → extrae entidades → guarda Lead en CouchDB `buscobien_leads`
        │
        ▼
[hermes-prop-manager] → filtra propiedades por promoter_id y criterios → envía 3 candidatas al lead
        │
        ▼
[usuario loguea Telegram] → valida User ID → vínculo con CouchDB user_id
        │
        ▼
[Panel promotor] → ve lista propiedades, filtra, actualiza estado
        │
        ▼
[n8n workflow] → si lead acepta → genera contrato automático → cierra trámite
```

---

## 3. Configuración Operativa

### 3.1 Paso a Paso (fuera del reposo `/mnt/buscobien`)

#### Paso 1: Preparar entorno Hermes
```bash
# En ~/.hermes/profiles/buscobien/
mkdir -p agents/ skills/ plugins/ config/ workspace/

# 1. Definir perfiles YAML en agents/
#    - lead-qualifier.yaml
#    - prop-manager.yaml
#    - sre-guard.yaml
#    - budget-bot.yaml
#    - legal-drafter.yaml
#    - maps-bot.yaml
#    - analytics-bot.yaml

# 2. Crear skills en skills/ (scripts + prompts)
#    - lectura_planos/
#    - generador_presupuestos/
#    - troubleshooting_camaras/
#    - programador_visitas/
#    - monitor_salud_sistemas/
#    - verificador_cumplimiento/
#    - facturacion_electronica/

# 3. Configurar plugins en plugins/
#    - telegram-bridge/ (token bot, whitelist user IDs)
#    - web-panel/ (rutas Flutter nuevas)
```

#### Paso 2: Configurar infraestructura
```bash
# Nginx (puede ya estar en operación en buscobien.net)
# Agregar bloque server para /api/v1/... con JWT validation y header promoter_id

# Ollama
ollama run llama3:8b-instruct-q4_K_M

# NeMo Guardrails
# Crear guardrails/ con input_rails.colang, output_rails.colang, topical_rails.colang

# Qdrant y CouchDB (Docker)
docker run -d -p 5984:5984 couchdb
docker run -d -p 6333:6333 qdrant/qdrant

# Telegram Bots
# BotFather: crear @buscobien_lead, @buscobien_promoter, @buscobien_support
# Guardar tokens en ~/.hermes/profiles/buscobien/.env
```

#### Paso 3: Desplegar Hermes Gateway
```bash
# Node.js gateway con middleware JWT
# Endpoints clave:
#   POST /api/v1/leads/intake  → recibe payload desde formulario web
#   GET  /api/v1/propiedades/buscar  → retorna lista con filtros + vectoriales
#   GET  /api/v1/promotor/:id/dashboard  → datos del promotor logueado
#   WS   /ws/telegram            → bridge con bot de Telegram
```

#### Paso 4: Integrar con buscobien.net (sin modificar /mnt/buscobien)
- Agregar nuevas rutas en el frontend Flutter en `~/.hermes/profiles/buscobien/frontend/`:
  - `/mi-agente` → configuración de agente personal, ligar Telegram
  - `/panel-promotor` → dashboard con métricas, lista propiedades, acciones HITL
  - `/busqueda-avanzada` → formulario con todos los filtros (operación, zona, precio, recamaras, baños)
- Conectar widgets con los endpoints del Paso 3 usando `http` package y `--dart-define` para credenciales.

#### Paso 5: Prubas y puesta en marcha
- Probar flujo: lead entra → qualifies → recibe 3 propiedades → acepta → contrato generado.
- Verificar que Qdrant vectores se actualicen al crear/actualizar propiedad.
- Confirmar que los botones inline de Telegram funcionan para aprobaciones.
- Medir tiempos: de lead a primera propuesta < 5 minutos.

---

## 4. Aplicación de las Metodologías Solicitadas

### 4.1 Aplicación de la Cadena de Valor de Porter

| Actividad | Cómo Hermes Bot aporta valor |
|-----------|------------------------------|
| **Logística interna** | `hermes-prop-manager` automáticamente clasifica y ubica propiedades en CouchDB/Qdrant, sin captura manual de datos. |
| **Operaciones** | Búsqueda vectorial en Qdrant retorna resultados en < 2 segundos; formularios prellenados con datos del lead. |
| **Logística externa** | `hermes-sre-guard` coordina visitas, envía recordatorios Telegram, optimiza rutas con Google Maps API. |
| **Marketing y Ventas** | `hermes-lead-qualifier` nutría al lead con contenido automatizado (vídeos, planos, presupuestos); `hermes-budget-bot` genera propuesta económica al momento. |
| **Servicio postventa** | `hermes-sre-guard` monitorea salud de propiedades (aunque sea solo reporte de estatus), `hermes-analytics-bot` emite reportes trimestrales de satisfacción. |
| **Infraestructura** | Los bots aprovechan la infraestructura existente (CouchDB 35 bases, Qdrant, Google Maps) sin necesidad de nuevos servidores. |
| **Desarrollo tecnológico** | Los modelos Llama 3 locales (Ollama) reducen costos de API calls a servicios externos; actualizaciones vía `--dart-define`. |
| **Adquisiciones** | Integración con EasyBroker API (opcional REQ-OP-001) para sincronizar precios y disponibilidad. |
| **RR.HH** | Capacitación rápida: el staff interactúa con los bots, no necesita profundos conocimientos de IA. |
| **Procedimientos** | Manuales de operación se actualizan automáticamente cuando se añade una nueva skill o se cambia un flujo en n8n. |

### 4.2 Aplicación del Business Model Canvas

| Bloque | Definición en el contexto BuscoBien + Hermes |
|--------|---------------------------------------------|
| **Segmentos** | 1. Compradores primerizos (buscan propiedad, presupuesto orientado).<br>2. Inversores (buscan rentabilidad, análisis de zona).<br>3. Promotores/desarrolladores (gestionan inventario, lanzan nuevos proyectos).<br>4. Corredores inmobiliarios (usan panel para captar y convertir). |
| **Propuesta de valor** | *"Tu agente inmobiliario personal, que busca mejores propiedades para ti, genera presupuestos al instante y gestiona trámites, todo desde tu Telegram o el portal web."* |
| **Canales** | Portal buscobien.net (web), app móvil Flutter, Bot Telegram (C2), panel de promotor (web), email automático. |
| **Relación con clientes** | Self-service (el usuario busca y filtra solo), Asistencia automatizada (bot responde dudas), Agente dedicado (promotor tiene su Hermes Bot personal), Comunidad (listas de propiedades compartidas). |
| **Flujos de ingreso** | 1. Suscripción mensual panel promotor (premium).<br>2. Comisión por cada operación cerrada a través del portal (%).<br>3. Mantenimiento y soporte técnico mensual opcional.<br>4. Generación de contratos con firma digital (costo por documento). |
| **Recursos clave** | • Infraestructura: CouchDB, Qdrant, Ollama (RTX 4060), Google Maps API.<br>• Datos: catálogo de propiedades enriquecidas con embeddings.<br>• Talento: configuradores de agentes Hermes, personal de soporte.<br>• Propiedad intelectual: prompts Colang, plantillas legales, flujos n8n. |
| **Actividades clave** | • Configuración inicial de perfiles Hermes por cliente.<br>• Ingesta y enriquecimiento continuo de datos (PDFs, fotos, planos).<br>• Mantenimiento de modelos vectoriales en Qdrant.<br>• Orquestación de flujos de aprobación humana (HITL). |
| **Socios clave** | • EasyBroker API (catálogo inmobiliario).<br>• Google Maps/Places (análisis de zona).<br>• Servicios de firma electrónica (FIEL/e.firma).<br>• Portales de difusión (Vivanuncios, Inmuebles24). |
| **Estructura de costos** | • Infraestructura (hosting, mantenimiento bases de datos).<br>• Licencias/uso de modelos IA (Ollama local = costo operativo cercano a 0 tras hardware).<br>• Desarrollo y entrenamiento de agentes (una vez, luego mantenimiento).<br>• Marketing y adquisición de leads iniciales. |

---

## 5. KPIs y Métricas de Éxito

| KPI | Meta | Medición |
|-----|------|----------|
| Tiempo de calificación de lead | < 2 minutos | Auto: `hermes-lead-qualifier` guarda lead y envía notificación. |
| Tiempo desde lead hasta primera propuesta | < 5 minutos | `hermes-budget-bot` genera PDF presupuestado automáticamente. |
| Precisión en búsqueda vectorial | > 85% de relevancia | Medir clicks/impresiones en resultados Qdrant. |
| Tasa de conversión lead → visita | > 30% | Número de visitas agendadas / leads calificados. |
| Tasa de conversión visita → operación cerrada | > 15% | Integración con n8n → contrato firmado. |
| Satisfacción del usuario (CSAT) | > 4.5/5 | Encuesta automatizada después de cada interacción con el bot. |
| Reducción de tiempo administrativo | 40% menos horas en captura y seguimiento | Comparativa pre/post implementación Hermes. |

---

## 6. Consideraciones de Seguridad y Cumplimiento

| Aspecto | Medida |
|---------|--------|
| **Aislamiento multi-tenant** | JWT con `promotor_id` se propaga en todos los headers; CouchDB y Qdrant filtran por este campo automáticamente. |
| **Protección de datos** | CouchDB `_security` por base; Qdrant payloads etiquetados; ningún dato sensible sale del entorno sin cifrado. |
| **Validación legal** | `hermes-legal-drafter` output rails de NeMo Guardrails verifican presencia de cláusulas obligatorias (CONTRODE, PROFECO). Si faltan, bloquea y solicita regeneración. |
| **Acceso Telegram** | Whitelist de User IDs configurada en `hermes-gateway.js`; mensajes de IDs no autorizados se descartan y registran. |
| **Auditoría** | Cada acción (búsqueda, lead, contrato, actualización) se registra en CouchDB `auditoria` con `actor`, `timestamp`, `promotor_id`. |
| **Backup** | Replicación CouchDB continua; snapshots Qdrant nocturnos en disco distinto. |

---

## 7. Próximos Pasos para la Empresa BuscoBien

1. **Aprobar la propuesta** y definir el alcance (¿todos los rubros o iniciar con CCTV y control de accesos?).
2. **Ejecutar Paso 1** (estructurar carpetas y definir perfiles Hermes YAML).
3. **Ejecutar Paso 2** (configurar Ollama, NeMo Guardrails, Docker CouchDB/Qdrant).
4. **Ejecutar Paso 3** (desplegar Hermes Gateway y endpoints API).
5. **Integrar frontend** en buscobien.net (rutas nuevas, conectar widgets).
6. **Piloto con 3 promotores** y medir KPIs.
7. **Escalar** a todo el catálogo y activar módulos adicionales (firma electrónica, EasyBroker sync).

---
*Propuesta generada bajo la doble óptica de la Cadena de Valor de Porter (1985) y el Business Model Canvas (2010), diseñada exclusivamente para la empresa BuscoBien y su portal buscobien.net. No modifica código ni documentación del directorio `/mnt/buscobien`; todos los entregables se configuran en `~/.hermes/profiles/buscobien/`.*