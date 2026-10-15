# Hermes Security Core - Arquitectura del Sistema

## 1. Visión General
"Hermes Security Core" es una solución de agentes autónomos (Hermes Bots) para empresas de instalación de sistemas de seguridad: videovigilancia, control de accesos, detección de incendios y desarrollo de sistemas relacionados. Cada cliente, técnico y rol interno opera bajo perfiles aislados de Hermes Agent, gestionando el ciclo completo: prospección, diseño, instalación, mantenimiento y soporte postventa.

---

## 2. Cadena de Valor de Porter (aplicada)

### Actividades Primarias

| Actividad | Dónde actúa Hermes Agent/Bot | Ejemplo concreto |
|-----------|-------------------------------|-------------------|
| **Logística interna** | Recepción de pedidos, gestión de inventario de equipos (cámaras, DVRs, paneles PCI, cableado, etc.). | `hermes-inventory-bot` alerta stock bajo, sugiere reorden, genera órdenes de compra automáticas. |
| **Operaciones** | Instalación, configuración de sistemas, programación de dispositivos, generación de planos y documentación. | `hermes-tech-assist` entrega checklists, schematics, manuales paso a paso; `hermes-project-manager` genera cronogramas y asigna técnicos. |
| **Logística externa** | Despacho de técnicos, seguimiento de vehículos, programación de rutas de visita. | `hermes-dispatch-bot` optimiza rutas con Google Maps, envía recordatorios y actualiza estados en tiempo real. |
| **Marketing y Ventas** | Calificación de leads, generación de propuestas comerciales, seguimiento de cotizaciones. | `hermes-lead-qualifier` clasifica la necesidad (CCTV, control de accesos, PCI), presupuesto, urgencia y asigna a un comercial. |
| **Servicio postventa** | Mantenimiento preventivo/correctivo, soporte técnico, monitoreo remoto, gestión de garantías. | `hermes-maintenance-scheduler` programa visitas, `hermes-sre-guard` monitorea salud de sistemas instalados (vía SNMP/API), alerta de fallos. |

### Actividades de Apoyo

| Actividad | Dónde actúa Hermes Agent/Bot | Ejemplo concreto |
|-----------|-------------------------------|-------------------|
| **Infraestructura** | Gestión de redes, VPNs, servidores de monitoreo para clientes. | `hermes-sre-guard` supervisa disponibilidad de NVRs, paneles de alarma y puertas de acceso; ejecuta remediaciones básicas (reinicio, actualización de firmware). |
| **Gestión de RRHH** | Capacitación de técnicos, control de asistencia, evaluación de competencias. | `hermes-training-coordinator` programa cursos, envía recordatorios, genera evaluaciones y certificados. |
| **Desarrollo tecnológico** | Diseño de soluciones personalizadas, integración de sistemas, prototipado. | `hermes-rd-assist` genera scripts de automatización (Python para Zoneminder, configuración de PLCs), documenta especificaciones. |
| **Adquisiciones** | Gestión de proveedores, comparación de precios, órdenes de compra. | `hermes-procurement-bot` monitorea catálogos de distribuidores (Hikvision, Dahua, etc.), sugiere proveedores según costo/tiempo de entrega. |
| **Administración y finanzas** | Facturación, cobranza, reportes contables. | `hermes-billing-bot` genera facturas, envía recordatorios de pago, concilia cobros y genera reportes financieros. |

---

## 3. Business Model Canvas (adaptado)

| Bloque | Descripción |
|--------|-------------|
| **Segmentos de clientes** | · Empresas comerciales e industrias (naves, oficinas, retail).<br>· Condominios y desarrollos inmobiliarios.<br>· Gobierno y sector público.<br>· Hogares de alta gama. |
| **Propuesta de valor** | · Agente personal por cliente/empresa para gestión integral de seguridad.<br>· Monitoreo 24/7 con alertas proactivas y mantenimiento predictivo.<br>· Cumplimiento normativo (NFPA 72, IEC 62443, NOM-001-SEDE).<br>· Reportes automáticos y trazabilidad completa. |
| **Canales** | · Panel web (browsable) para clientes y administradores.<br>· Bots de Telegram para técnicos y staff interno.<br>· App móvil (cliente final).<br>· Email transaccional. |
| **Relación con clientes** | · Self-service: panel de control de cámaras, eventos y mantenimientos.<br>· Soporte 24/7 mediante bot y humano.<br>· Agente Hermes dedicado por cuenta (multi-tenant aislado). |
| **Flujos de ingreso** | · Suscripción mensual por dispositivo monitoreado (cámara, detector, puerta).<br>· Tarifa plana por proyecto de instalación.<br>· Mantenimiento preventivo (anual/trimestral).<br>· Comisiones por venta de equipos y accesorios. |
| **Recursos clave** | · Infraestructura Hermes (gateway, modelos IA, bases de datos).<br>· Catálogo de productos y precios.<br>· Integraciones con APIs de fabricantes y plataformas de monitoreo.<br>· Datos de clientes y configuraciones. |
| **Actividades clave** | · Configuración de perfiles Hermes por cliente.<br>· Entrenamiento de modelos específicos (detección de patrones en alarmas, lectura de planos).<br>· Mantenimiento de integraciones con ERP/CRM y APIs de equipos. |
| **Socios clave** | · Fabricantes: Hikvision, Dahua, Bosch, Honeywell, Notifier.<br>· Plataformas de monitoreo: Milestone, Zoneminder, Blue Iris.<br>· Operadores de telefonía y datos (para conectividad 4G/LTE).<br>· Empresas de mantenimiento tercerizadas. |
| **Estructura de costos** | · Infraestructura (on-premise + cloud para backups).<br>· Licencias de software (ERP, plataformas de monitoreo).<br>· Capacitación y soporte técnico.<br>· Desarrollo y entrenamiento de agentes. |

---

## 4. Arquitectura Técnica Hermes Security Core

### 4.1 Componentes Principales

| Componente | Tecnología | Función |
|------------|------------|---------|
| **Hermes Gateway (Node.js/Express)** | Puerto 3000 (interno) | Middleware JWT, multi-tenant dispatch, WebSocket para chat, whitelist de usuarios Telegram. |
| **Nginx** | Puerto 443 (HTTPS) | TLS terminación, validación JWT, inyección de `client_id` y `sucursal_id`, enrutado a servicios internos. |
| **Tailscale** | WireGuard mesh | Red segura entre oficina, nube, sitio del cliente y técnicos. |
| **Ollama** | Windows/WSL2, RTX 4060 (puerto 11434) | Inferencia local: extracción de entidades de solicitudes, generación de presupuestos, troubleshooting. |
| **NeMo Guardrails** | WSL2 (puerto 8000) | Proxy semántico: bloqueo de manipulación de precios, validación de normativas, protección de datos sensibles. |
| **CouchDB** | WSL2 (puerto 5984) | Persistencia documental: clientes, proyectos, órdenes de servicio, inventario, historial de mantenimientos. |
| **Qdrant** | WSL2 (puerto 6333) | Memoria vectorial: embeddings de planos, manuales, historial de conversaciones, catálogo de productos. |
| **Telegram Bot API** | Cloud | Canal C2 para técnicos, comerciales y administradores; botones inline para aprobaciones, alertas, reportes. |
| **Panel Web (Flutter/WASM)** | Frontend | Misión de control: dashboard de proyectos, estado de sistemas, tickets, métricas. |
| **Integraciones ERP/CRM** | REST | Odoo / ERPNext / HubSpot: sincronización de clientes, facturación, inventario. |
| **APIs de Equipos** | REST/ONVIF | Hikvision, Dahua, Milestone: estado de cámaras, NVRs, paneles de alarma, control de accesos. |

### 4.2 Perfiles Hermes (Bots)

| Perfil | Rol | Skills asociadas | Canal |
|--------|-----|------------------|-------|
| **hermes-lead-qualifier** | Califica leads entrantes (web, teléfono, redes). | NLP, detección de intención, extracción de tipo de servicio, presupuesto, urgencia. | Webhook, Telegram, email. |
| **hermes-project-manager** | Gestiona proyectos de instalación: planificación, asignación de recursos, seguimiento. | Gestión de tareas, calendario, asignación de técnicos, generación de cronogramas. | Telegram, panel web. |
| **hermes-tech-assist** | Asiste a técnicos en campo: manuales, troubleshooting, confirmación de pasos, reportes de avance. | Visión (fotos de instalaciones), generación de reportes, acceso a base de conocimiento. | Telegram (fotos, voz), panel web. |
| **hermes-maintenance-scheduler** | Programa mantenimientos preventivos/correctivos, genera órdenes de servicio, alertas de vencimiento. | Calendario, recordatorios, integración con APIs de equipos. | Telegram, email, SMS. |
| **hermes-inventory-bot** | Gestiona stock de equipos y materiales, alerta de reorden, genera órdenes de compra. | Lectura de catálogos, comparación de precios, integración con proveedores. | Panel web, Telegram. |
| **hermes-client-concierge** | Interacción con clientes finales: dudas, citas, encuestas, alertas de fallos. | NLP, envío de documentos, programación de visitas. | Web chat, WhatsApp, Telegram, email. |
| **hermes-sre-guard** | Monitoreo de salud de sistemas instalados (NVRs, paneles, detectores), detección de anomalías. | Integración SNMP/ONVIF, alertas tempranas, escalación a técnicos. | Telegram, panel web. |
| **hermes-compliance-bot** | Verifica cumplimiento normativo (NFPA, IEC, NOM), genera documentación, recordatorios de inspección. | Lectura de normativas, generación de informes, checklists. | Panel web, email. |
| **hermes-billing-bot** | Genera facturas, envía recordatorios de pago, concilia cobros. | Integración ERP/contabilidad, plantillas de factura. | Email, panel web. |

### 4.3 Diagrama de Arquitectura

```
[Cliente / Lead] ──Web/WhatsApp/Telegram──► [Hermes Gateway] ──► [NeMo Guardrails] ──► [Ollama]
                                                                                    │
[Cliente / Técnico / Staff] ──Telegram/Botón──► [Hermes Gateway] ──► [n8n] ──┐     │
                                                                             ▼     ▼
[Panel Web Flutter] ──HTTPS/JWT──► [Nginx] ──► [Node.js API] ──► [CouchDB]     [Qdrant]
                                                                             ▲
[APIs Externas] (ERP, Odoo, Hikvision, Milestone, Google Maps) ────────────────┘
```

### 4.4 Modelo de Datos (CouchDB)

| Base / Documento | Campos principales (multi-tenant) |
|------------------|-----------------------------------|
| `clientes` | `_id`, `client_id`, `nombre`, `rfc`, `domicilio`, `tipo_servicio`, `promotor_id` (referencia a staff que lo gestiona), `created_at` |
| `proyectos` | `_id`, `proyecto_id`, `client_id`, `tipo` (CCTV, PCI, control_accesos, etc.), `estado`, `tecnico_asignado`, `fecha_inicio`, `fecha_fin`, `promotor_id` |
| `ordenes_servicio` | `_id`, `orden_id`, `proyecto_id`, `tipo` (preventivo, correctivo, instalación), `descripcion`, `tecnico_asignado`, `fecha_programada`, `estado`, `checklist` |
| `inventario` | `_id`, `sku`, `descripcion`, `cantidad`, `ubicacion`, `proveedor`, `costo`, `promotor_id` |
| `tickets` | `_id`, `ticket_id`, `client_id`, `proyecto_id`, `categoria`, `prioridad`, `descripcion`, `estado`, `asignado_a`, `created_at` |
| `usuarios` | `_id`, `user_id`, `nombre`, `rol` (admin, comercial, tecnico, cliente), `telegram_user_id`, `promotor_id` |
| `auditoria` | `_id`, `evento`, `actor`, `detalles`, `timestamp`, `promotor_id` |

### 4.5 Esquema Qdrant (embeddings)

| Colección | Contenido | Filtros |
|-----------|-----------|---------|
| `manuales_tecnicos` | PDFs de manuales de cámaras, DVRs, paneles PCI, detectores. | `marca`, `modelo`, `tipo_equipo` |
| `planos_instalacion` | Planos DWG/PDF de proyectos. | `proyecto_id`, `tipo_equipo` |
| `catalogo_productos` | Descripciones de productos, características, compatibilidades. | `categoria`, `marca` |
| `historial_conversaciones` | Transcripciones y embeddings de interacciones con clientes. | `client_id`, `rol` |
| `normativas` | Textos de NFPA, IEC, NOM-001-SEDE, etc. | `tipo_normativa`, `año` |

### 4.6 Skills y Plugins Clave

| Skill / Plugin | Descripción |
|----------------|-------------|
| **lectura_planos** | Extrae medidas, ubicación de accesos, puntos de cableado de planos PDF/DWG. |
| **generador_presupuestos** | A partir de requerimientos (cantidad de cámaras, metros de cable, horas de instalación), genera propuesta económica en PDF. |
| **troubleshooting_camaras** | Base de conocimiento: síntomas → solución para cámaras IP, DVRs, NVRs. |
| **programador_visitas** | Asigna técnicos según zona, disponibilidad y tipo de servicio; envía recordatorios. |
| **monitor_salud_sistemas** | Consulta APIs SNMP/ONVIF de NVRs, paneles de alarma; detecta cámaras offline, almacenamiento lleno, baterías bajas. |
| **verificador_cumplimiento** | Revisa que la instalación cumpla con normativa: número de detectores por m², trayectorias de cableado, respaldos de energía. |
| **facturacion_electronica** | Genera factura CFDI a partir de orden de servicio aprobada. (Integración con ERP). |

---

## 5. Flujos de Trabajo Principales

### 5.1 Flujo de Prospección a Instalación

1. Un lead envía mensaje por web o WhatsApp: "Necesito instalar 6 cámaras en mi nave industrial, 2 accesos deontrol y sistema contra incendios".
2. `hermes-lead-qualifier` analiza el mensaje, extrae:
   - Tipo de servicio: CCTV (6), control de accesos (2), PCI (1 sistema).
   - Tamaño: 500 m².
   - Presupuesto estimado: $150,000 MXN.
   - Urgencia: esta semana.
3. El bot crea un `ticket` en CouchDB, asigna al comercial `Juan Pérez` y envía notificación a su Telegram.
4. `hermes-project-manager` crea un `proyecto` con checklist de materiales (cámaras tipo bullet, DVR 8 canales, cable UTP, gabinetes, detectores de humo, etc.) y consulta inventario a `hermes-inventory-bot`.
5. Se agenda visita técnica, se asignan 2 técnicos y se envía confirmación al cliente.
6. El técnico recibe el detalle del proyecto, planos y lista de materiales en Telegram. `hermes-tech-assist` resuelve dudas en tiempo real.
7. Al finalizar la instalación, se genera reporte de avance, se actualiza el estado del proyecto y se dispara `hermes-maintenance-scheduler` para programar mantenimiento trimestral.

### 5.2 Flujo de Mantenimiento y Soporte

1. `hermes-sre-guard` monitorea el NVR del cliente; detecta cámara 3 offline desde hace 10 minutos.
2. Abre un `ticket` de prioridad alta, asigna al técnico disponible más cercano y envía alerta a Telegram del técnico y del cliente.
3. El técnico confirma asistencia, resuelve el problema y actualiza el ticket.
4. Se genera reporte automático de incidencia y se registra en el historial del cliente.

### 5.3 Flujo de Cumplimiento Normativo

1. Antes de una inspección de protección civil, `hermes-compliance-bot` revisa el proyecto:
   - Número de detectores por m².
   - Tiempo de respuesta de la alarma.
   - Estado de extintores.
2. Si falta documentación, genera recordatorios y guía para obtener certificados.
3. Al superar la inspección, genera el acta de cumplimiento y la almacena en el historial.

---

## 6. Acceso a Herramientas de Terceros

| Herramienta | Tipo de Acceso | Uso |
|-------------|----------------|-----|
| **Telegram Bot API** | Token bot | Canal principal para técnicos, comerciales y administradores; botones inline para aprobaciones y actualizaciones. |
| **APIs de Fabricantes** (Hikvision, Dahua, Honeywell) | REST / ONVIF | Configuración remota, estado de equipos, actualizaciones de firmware. |
| **Plataformas de Monitoreo** (Milestone, Zoneminder, Blue Iris) | REST / Webhooks | Integración para consultar eventos, estados de cámaras, almacenamiento. |
| **ERP/CRM** (Odoo, ERPNext, HubSpot) | REST API | Sincronización de clientes, proyectos, facturación, inventario. |
| **Google Maps API** | API key | Geocodificación de clientes, optimización de rutas de visita, cálculo de tiempos de desplazamiento. |
| **Facturación Electrónica (PAC)** | REST / SOAP | Generación de CFDI, envío a cliente, timbrado. |
| **Pasarelas de Pago** (Stripe, PayPal, Mercado Pago) | REST API | Cobros automáticos de mantenimientos, proyectos. |
| **Servicios de Firma Digital** (FIEL, e.firma) | REST / SOAP | Firma de contratos y órdenes de servicio. |

> **Gestión de accesos:** Todos los tokens, claves API y configuraciones se almacenan en archivos `.env` locales bajo `~/.hermes/profiles/buscobien/.env` y nunca se exponen en el código ni en commits.

---

## 7. Configuración Paso a Paso (propuesta operativa)

### Paso 1: Instalar infraestructura base (una sola vez)
1. Habilitar WSL2 Ubuntu con Docker (Qdrant, CouchDB).
2. Instalar Ollama en Windows/WSL2 con modelo `llama3:8b-instruct-q4_K_M`.
3. Instalar NeMo Guardrails en WSL2 (puerto 8000) con reglas básicas de seguridad.
4. Configurar Tailscale entre oficina, servidor y sitios de clientes (para acceso remoto seguro a equipos).
5. Desplegar Hermes Gateway (Node.js) con middleware JWT y whitelist de Telegram.

### Paso 2: Definir perfiles Hermes por rol
Crear en `~/.hermes/profiles/buscobien/` la siguiente estructura:
```
profiles/
├── buscobien/
│   ├── agents/
│   │   ├── lead-qualifier/
│   │   │   └── agent.yaml
│   │   ├── project-manager/
│   │   │   └── agent.yaml
│   │   ├── tech-assist/
│   │   │   └── agent.yaml
│   │   ├── maintenance-scheduler/
│   │   │   └── agent.yaml
│   │   ├── inventory-bot/
│   │   │   └── agent.yaml
│   │   ├── client-concierge/
│   │   │   └── agent.yaml
│   │   ├── sre-guard/
│   │   │   └── agent.yaml
│   │   ├── compliance-bot/
│   │   │   └── agent.yaml
│   │   └── billing-bot/
│   │       └── agent.yaml
│   ├── skills/
│   │   ├── lectura_planos/
│   │   ├── generador_presupuestos/
│   │   ├── troubleshooting_camaras/
│   │   ├── programador_visitas/
│   │   ├── monitor_salud_sistemas/
│   │   ├── verificador_cumplimiento/
│   │   └── facturacion_electronica/
│   └── plugins/
│       ├── telegram-bridge/
│       └── web-panel/
```

Cada `agent.yaml` incluye:
- `id`, `name`, `description`
- `model`: `llama3:8b` (o fallback a OpenAI si se desea)
- `skills`: lista de skills habilitadas
- `memory`: `cqoudb`, `qdrant`
- `channels`: `telegram`, `webhook`, `panel`
- `permissions`: acceso a APIs de equipos, ERP, etc.

### Paso 3: Configurar skills específicas
Ejemplo de skill `generador_presupuestos`:
```
Prompt base:
"Eres un experto en sistemas de seguridad. Genera un presupuesto detallado para el siguiente requerimiento:
[REQUERIMIENTO]
Considera: costo de equipos (cámaras, DVRs, cable, conectores), horas de instalación, licencias de software, mantenimiento primer año.
Formato de salida: JSON con campos: concepto, cantidad, costo_unitario, costo_total, notas."
```

Skills como `lectura_planos` usan `vision` para procesar imágenes de planos y extraer medidas.

### Paso 4: Registrar bots de Telegram
1. Crear bots via BotFather: `@SecurityBot_Lead`, `@TechBot_Asist`, `@MaintBot_Scheduler`, etc. (o un único bot con menús por rol).
2. Configurar webhook hacia Hermes Gateway: `https://<dominio>/webhook/telegram`.
3. Implementar botones inline para aprobaciones de presupuestos, confirmación de visitas, etc.

### Paso 5: Integrar con ERP/CRM y APIs de equipos
1. Configurar conexión a Odoo/ERPNext vía API key.
2. Probar integración con al menos un fabricante (ej. Hikvision) para obtener estado de cámaras.
3. Sincronizar catálogo de productos y precios.

### Paso 6: Pruebas de humo y piloto
1. Simular flujo completo: lead → presupuesto → orden de servicio → instalación → mantenimiento.
2. Validar que los agentes respeten las barandillas (no generen presupuestos sin datos, no accedan a información de otros clientes).
3. Ajustar prompts y skills según feedback de comerciales y técnicos.

---

## 8. Seguridad y Cumplimiento

| Aspecto | Medida |
|---------|--------|
| **Aislamiento multi-tenant** | Cada cliente, técnico y staff se autentica con JWT; el `client_id` se propaga en headers y usamos para filtrar documentos CouchDB y vectores Qdrant. |
| **Protección de datos** | Datos de clientes (videos, ubicaciones) se almacenan encriptados en reposo. Acceso solo por personal autorizado. |
| **Validación normativa** | `hermes-compliance-bot` asegura que las especificaciones de instalación cumplan con NFPA 72, IEC 62443, NOM-001-SEDE. |
| **Auditoría** | Todos los cambios (presupuestos, órdenes, configuraciones) se registran en CouchDB `auditoria` con `actor`, `timestamp` y `client_id`. |
| **Acceso remoto seguro** | Conexión a sitios de clientes solo vía Tailscale; no se exponen puertos públicos. |
| **Backup** | Replicación de CouchDB y snapshots de Qdrant en servidor externo diariamente. |

---

## 9. Métricas de Éxito (KPIs)

| KPI | Meta |
|-----|------|
| Tiempo de generación de presupuestos | < 2 minutos (vs. 2-4 horas manual). |
| Tiempo de respuesta a soporte | < 15 minutos (24/7). |
| Cumplimiento de mantenimientos preventivos | > 95%. |
| Reducción de visitas técnicas innecesarias | 30% (gracias a diagnóstico remoto). |
| Satisfacción del cliente (CSAT) | > 4.5/5. |
| Tasa de conversión de leads | +25% por respuesta inmediata. |

---

## 10. Cierre
Hermes Security Core transforma la operación de una empresa de seguridad en una organización centrada en agentes autónomos: cada cliente tiene un agente personal que gestiona su seguridad de forma proactiva, cada técnico tiene un asistente en tiempo real y la administración tiene visibilidad total mediante dashboards y auditoría automática. La arquitectura se apoya en la infraestructura existente (Hermes Agent + bots), con mínima fricción y cumpliendo normativas del sector.

---
*Documento generado bajo lineamientos de: no modificar código/docs del proyecto buscobien, alineación con Cadena de Valor de Porter y Business Model Canvas.*