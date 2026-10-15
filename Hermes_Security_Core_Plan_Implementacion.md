# Hermes Security Core - Plan de Implementación

## 1. Objetivo
Implementar la arquitectura Hermes Security Core para operar una empresa de instalación de sistemas de seguridad (videovigilancia, control de accesos, detección de incendios) utilizando Hermes Agent con bots especializados por rol, sin modificar el código ni documentación del proyecto Buscobien.

## 2. Equipo y Roles

| Rol | Responsabilidades | Tiempo estimado semanal |
|-----|-------------------|--------------------------|
| **Project Lead / Architecture Owner** | Validación de gates, coordinación entre equipos, aprobación de entregables, seguimiento de KPIs. | 4 h |
| **DevOps / Infra** | Configuración de Nginx, Tailscale, Docker (Qdrant, CouchDB), despliegue de Hermes Gateway, monitoreo. | 10 h |
| **Backend Engineer** | Desarrollo de endpoints de webhook, integración con APIs de equipos y ERP, configuración de n8n. | 12 h |
| **AI/ML Engineer** | Configuración de Ollama, NeMo Guardrails, entrenamiento de skills específicas (lectura de planos, generación de presupuestos). | 12 h |
| **Flutter/Frontend Engineer** | Desarrollo de panel web para clientes y staff interno, dashboards de proyectos, reportes. | 10 h |
| **QA / Tester** | Pruebas unitarias, de integración y de seguridad; validación de flujos end-to-end. | 8 h |
| **Security Officer** | Revisión de accesos, cumplimiento normativo, auditoría de logs, gestión de secrets. | 4 h |
| **Business Analyst** | Definición de requerimientos, capacitación a usuarios, documentación operativa. | 6 h |

> Todos los entregables se generan fuera del repositorio `buscobien` en `/mnt`; se ubican en `~/.hermes/profiles/buscobien/workspace/` o `~/.hermes/profiles/buscobien/config/`.

## 3. Fases y Entregables

### Fase 0: Gate de Inicio y Ambiente Base
| Objetivo | Disponer de entorno limpio, sin dependencias del proyecto Buscobien, y confirmar disponibilidad de hardware/software. |
|----------|---------------------------------------------------------------------------------------------------------------|
| Tareas | 1. Confirmar que el equipo MSI Katana + RTX 4060 tiene espacio en disco y drivers actualizados.<br>2. Instalar WSL2 Ubuntu 22.04 LTS, Docker Desktop, Node.js 20.x.<br>3. Verificar conectividad a internet y acceso a Telegram (para creación de bots).<br>4. Crear estructura de carpetas: `~/hermes-security-workspace/`, `~/.hermes/profiles/buscobien/agents/`, `skills/`, `plugins/`, `config/`. |
| Entregables | - Informe de estado de hardware/software (`00_gate_ready.md`).<br>- Topología de red básica (IPs de Windows, WSL2, router).<br>- Estructura de directorios creada. |
| Dependencias | Ninguna. |
| Owner | DevOps / Infra |

---

### Fase 1: Infraestructura Base y Gateway Seguro
| Objetivo | Tener Nginx, Hermes Gateway, Tailscale y bases de datos operativas. |
|----------|--------------------------------------------------------------------|
| Tareas | 1. **Nginx**: Configurar `server` en puerto 443 con TLS (certificado autofirmado o Let's Encrypt), validación JWT, inyección de headers `client_id`, `sucursal_id`, `rol`.<br>2. **Hermes Gateway (Node.js)**: Desarrollar middleware que:<br>   - Valide JWT emitido por el sistema de autenticación.<br>   - Mantenga `whitelist_telegram_user_ids.txt` para cada perfil.<br>   - Enrute eventos a n8n o a agentes locales.<br>3. **Tailscale**: Instalar en Windows, WSL2 y servidor Ubuntu (si aplica); configurar ACLs por rol.<br>4. **Docker Compose**: Levantar CouchDB (puerto 5984) y Qdrant (puerto 6333) en WSL2.<br>5. **Seguridad**: Configurar CouchDB `_security` por base de datos, habilitar TLS interno si es posible. |
| Entregables | - `nginx.conf` (funcional).<br>- `hermes-gateway.js` (middleware JWT + whitelist Telegram).<br>- `docker-compose.yml` (CouchDB + Qdrant).<br>- `tailscale-acls.json` (si aplica).<br>- Script de prueba `test-gateway.sh` que valide ping HTTPS y headers. |
| Dependencias | Fase 0 aprobada. |
| Owner | DevOps / Infra + Backend Engineer |

---

### Fase 2: Motor de Inferencia y Skills Core
| Objetivo | Tener a Ollama, NeMo Guardrails y las skills base funcionando. |
|----------|--------------------------------------------------------------|
| Tareas | 1. **Ollama (Windows)**: Instalar `ollama`, descargar `llama3:8b-instruct-q4_K_M`, validar consumo VRAM < 7.5 GB.<br>2. **NeMo Guardrails (WSL2)**: Instalar `nemo-guardrails`, crear directorio `~/.hermes/profiles/buscobien/config/guardrails/` con:<br>   - `input_rails.colang` (bloqueo de prompt injection, manipulación de precios, solicitudes de datos sensibles sin autorización).<br>   - `output_rails.colang` (validación de formato de presupuestos, cumplimiento de normativas, no divulgación de información de otros clientes).<br>   - `topical_rails.colang` (temas permitidos: seguridad, instalaciones, mantenimiento; bloqueo de temas no relacionados).<br>3. **Skills base**:<br>   - `lectura_planos`: OCR/visión para extraer medidas y ubicaciones de planos PDF/DWG.<br>   - `generador_presupuestos`: A partir de requerimientos estructurados (tipo de servicio, m², cantidad de equipos), genera presupuesto en PDF con lista de materiales y mano de obra.<br>   - `troubleshooting_camaras`: Base de conocimiento (síntoma → solución) para cámaras IP, DVRs, NVRs, paneles de alarma y detectores PCI.<br>   - `programador_visitas`: Asigna técnicos según zona (Google Maps Distance Matrix API), disponibilidad y tipo de servicio; genera órdenes de visita.<br>4. **Subagentes iniciales**: Desarrollar `hermes-lead-qualifier` y `hermes-tech-assist` como scripts Node.js que consuman Ollama y NeMo. |
| Entregables | - `ollama-config.yaml` (modelo, parámetros de generación).<br>- `guardrails/` con 3 archivos Colang.<br>- Carpeta `skills/` con 4 skills base (scripts + prompts).<br>- 2 subagentes Node.js funcionales (`lead-qualifier`, `tech-assist`).<br>- Prueba unitaria de cada skill (inputs de prueba → salida esperada). |
| Dependencias | Fase 1 completada. |
| Owner | AI/ML Engineer + Backend Engineer |

---

### Fase 3: Integración con Sistemas y Bots de Comunicación
| Objetivo | Tener la plataforma comunicada con ERP/CRM, APIs de equipos y bots de Telegram. |
|----------|--------------------------------------------------------------------------------|
| Tareas | 1. **Integración ERP/CRM**: Desarrollar módulos de sincronización con Odoo/ERPNext (clientes, proyectos, facturación, inventario).<br>2. **APIs de equipos**: Integrar al menos 2 marcas (ej. Hikvision y Dahua) para consulta de estado de cámaras y NVRs.<br>3. **Telegram Bots**:<br>   - Registrar 3 bots: `@SecurityBot_Comercial` (para leads y presupuestos), `@TechBot_Campo` (para técnicos), `@MaintBot_Scheduler` (para mantenimientos).<br>   - Implementar comandos (`/start`, `/status`, `/presupuesto`, `/visita`, `/ticket`), botones inline (Aprobar/Rechazar presupuesto, Confirmar visita).<br>   - Configurar webhook a Hermes Gateway.<br>4. **Panel Web (Flutter)**: Crear vistas mínimas:<br>   - Login y dashboard de proyectos.<br>   - Detalle de proyecto: cámaras, estado de instalación, órdenes de servicio.<br>   - Vista de tickets: abrir, asignar, cerrar.<br>5. **Adaptador WebSocket**: Para chat en tiempo real entre técnicos y oficina. |
| Entregables | - Módulos de integración ERP/CRM (código Node.js).<br>- Scripts de prueba de APIs de equipos.<br>- 3 bots Telegram funcionales con comandos y callbacks.<br>- Panel web mínimo viable (MVP) en Flutter.<br>- Documento `integraciones_tecnicas.md` (endpoints, credenciales, ejemplos de uso). |
| Dependencias | Fase 2 completada. |
| Owner | Backend Engineer + Flutter Engineer |

---

### Fase 4: Automatización Avanzada y Agentes de Soporte
| Objetivo | Desplegar agentes especializados y cerrar el ciclo de automatización. |
|----------|--------------------------------------------------------------------|
| Tareas | 1. **Desarrollar agentes restantes**:<br>   - `hermes-project-manager`: planificación de proyectos, asignación de recursos.<br>   - `hermes-inventory-bot`: gestión de stock, alertas de reorden, órdenes de compra.<br>   - `hermes-maintenance-scheduler`: programación de mantenimientos preventivos, recordatorios.<br>   - `hermes-client-concierge`: interacción con clientes finales (citas, encuestas, alertas de fallos).<br>   - `hermes-sre-guard`: monitoreo de salud de sistemas instalados (vía SNMP/ONVIF), apertura automática de tickets.<br>   - `hermes-compliance-bot`: verificación de normativas, generación de documentación de cumplimiento.<br>   - `hermes-billing-bot`: facturación, cobranza, conciliación.<br>2. **Configurar n8n**: Flujos de orquestación:<br>   - Lead → presupuesto → orden de servicio → factura.<br>   - Alerta de cámara offline → ticket → asignación → cierre.<br>   - Mantenimiento programado → recordatorio → confirmación → cierre.<br>3. **Entrenar modelos específicos**: Ajustar prompts para generación de presupuestos con listas de precios reales y troubleshooting específico de la marca de equipos utilizada. |
| Entregables | - 7 agentes Hermes adicionales configurados (`agent.yaml` + skills).<br>- Flujos n8n documentados y funcionales.<br>- Modelos de presupuestos y troubleshooting actualizados.<br>- Pruebas de integración de cada agente con el ERP y CouchDB. |
| Dependencias | Fase 3 completada. |
| Owner | AI/ML Engineer + Backend Engineer + Business Analyst |

---

### Fase 5: Piloto, Capacitación y Ajustes
| Objetivo | Validar en entorno real con clientes y técnicos, ajustar antes del despliegue general. |
|----------|--------------------------------------------------------------------------------------|
| Tareas | 1. Seleccionar 3 clientes piloto (uno de cada rubro: CCTV, control de accesos, PCI).<br>2. Dar de alta en el sistema, configurar sus perfiles y capacitar al personal.<br>3. Ejecutar flujos completos: lead → presupuesto → venta → instalación → mantenimiento → soporte.<br>4. Medir KPIs (tiempos, satisfacción, reducción de visitas).<br>5. Ajustar skills, prompts y flujos según retroalimentación.<br>6. Documentar manuales de usuario y operación. |
| Entregables | - Informe de pilotaje (`pilot-report.md`) con métricas y observaciones.<br>- Skills y agentes ajustados.<br>- Manuales de usuario (comerciales, técnicos, clientes).<br>- Plan de capacitación para todo el personal. |
| Dependencias | Fase 4 completada. |
| Owner | Todos los roles (coordinación por Project Lead) |

---

### Fase 6: Despliegue General y Optimización
| Objetivo | Escalar a todos los clientes y optimizar continuamente. |
|----------|--------------------------------------------------------|
| Tareas | 1. Migrar todos los clientes activos al nuevo sistema.<br>2. Activar monitoreo proactivo (hermes-sre-guard) para sitios críticos.<br>3. Implementar dashboards avanzados: métricas de negocio, tiempo de respuesta, tasa de cumplimiento de mantenimientos.<br>4. Entrenar modelos con datos reales de la empresa para mejorar precisión de presupuestos y diagnóstico.<br>5. Establecer ciclo de mejora continua: revisión mensual de KPIs, actualización de skills, capacitación trimestral. |
| Entregables | - Sistema en producción con todos los clientes.<br>- Dashboards en línea.<br>- Modelos entrenados con datos históricos.<br>- Plan de mejora continua documentado. |
| Dependencias | Fase 5 exitosa. |
| Owner | Project Lead + AI/ML Engineer + DevOps |

## 4. Timeline Resumido (12 semanas)

| Semana | Enfoque |
|--------|---------|
| 0 | Gate de inicio, ambiente base. |
| 1-2 | Fase 1: Infraestructura base, Nginx, Gateway, Docker. |
| 3-4 | Fase 2: Motor de inferencia, NeMo Guardrails, skills base. |
| 5-6 | Fase 3: Integración ERP/CRM, APIs de equipos, bots Telegram, panel web MVP. |
| 7-8 | Fase 4: Agentes avanzados, n8n, automatización de flujos. |
| 9-10 | Fase 5: Piloto con 3 clientes, capacitación, ajustes. |
| 11-12 | Fase 6: Despliegue general, optimización, documentación final. |

## 5. Entregables Generales

| Entregable | Descripción |
|------------|-------------|
| `Hermes_Security_Core_Arquitectura.md` | Documento de arquitectura técnica, componentes, flujos y modelo de datos. |
| `Hermes_Security_Core_Plan_Implementacion.md` | Este documento: plan de trabajo por fases. |
| `~/.hermes/profiles/buscobien/agents/` | Perfiles YAML de cada bot/agente. |
| `~/.hermes/profiles/buscobien/skills/` | Skills específicas del rubro (lectura de planos, presupuestos, troubleshooting). |
| `~/.hermes/profiles/buscobien/plugins/` | Plugins: telegram-bridge, web-panel, erp-adapter. |
| `config/nginx.conf` | Configuración de Nginx con TLS y JWT. |
| `config/guardrails/*.colang` | Reglas de seguridad y cumplimiento. |
| `scripts/` | Scripts de despliegue, pruebas y sincronización. |
| `docs/manuales/` | Manuales de usuario por rol. |

## 6. Próximos Pasos Inmediatos
1. Aprobar el gate de inicio (hardware/software disponible).
2. Ejecutar Fase 0: crear directorios y verificar entorno.
3. Iniciar Fase 1: configurar Nginx, Gateway, Docker.

---
*Documento generado bajo lineamientos de: no modificar código/docs del proyecto buscobien, alineación con Cadena de Valor de Porter y Business Model Canvas.*