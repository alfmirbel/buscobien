# Documento de Arquitectura — Hermes BuscoBien Core

**Versión:** 1.0  
**Fecha:** 2026-10-10  
**Alcance:** Arquitectura técnica para la integración de agentes Hermes (Bots) en la plataforma BuscoBien (promoción inmobiliaria)  
**Base:** `Hermes_BuscoBien_Propuesta.md`  
**Restricción:** No modifica código ni documentación del proyecto bajo `/mnt/buscobien`. Todos los entregables se ubican en `~/.hermes/profiles/buscobien/`.

---

## 1. Resumen Ejecutivo

Hermes BuscoBien Core es una plataforma de agentes autónomos especializados en promoción inmobiliaria que opera como capa de inteligencia sobre la infraestructura existente de BuscoBien (portal web Flutter/WASM, CouchDB, Qdrant, Google Maps). Cada promotor recibe un **agente personal aislado por `promotor_id`** que gestiona su inventario, califica leads, genera presupuestos, redacta contratos y coordina visitas, interactuando por dos canales: **panel web** (Mission Control) y **bot de Telegram** (C2 con aprobaciones HITL).

El diseño prioriza:
- **Multi-tenancy** estricto: cada promotor solo accede a su cartera.
- **Privacidad de datos:** inferencia local (Ollama/RTX 4060), sin exposición de datos sensibles a APIs públicas.
- **Cumplimiento normativo mexicano:** NeMo Guardrails con Output Rails para PROFECO/CONTRODE.
- **Extensibilidad:** nuevas skills y agentes se agregan sin reescribir el core.

---

## 2. Contexto y Alcance

### 2.1. Contexto del Sistema

| Actor | Descripción |
|-------|-------------|
| **Comprador / Cliente final** | Busca propiedades, contacta por web/WhatsApp/Telegram, recibe propuestas personalizadas. |
| **Promotor / Vendedor** | Gestiona inventario, recibe leads, aprueba propuestas por Telegram. |
| **Corredor inmobiliario** | Usa panel para captar y convertir, opera como extensión del promotor. |
| **Administrador BuscoBien** | Configura agentes, revisa auditoría, administra usuarios y permisos. |
| **Inversor / Gestor de propiedades** | Accede a métricas, reportes y análisis de zona. |

### 2.2. Fuera de Alcance

- No modifica la base de código Flutter del repositorio `buscobien` en `/mnt`.
- No altera la arquitectura documental `_documentacion/`.
- No cambia el modelo de negocio (comisiones, suscripciones) ya existente.
- No implementa firma electrónica certificada (se integra por API externa en fase posterior).

---

## 3. Requisitos Arquitectónicos

| ID | Requisito | Prioridad |
|----|-----------|-----------|
| AR-001 | Cada agente Hermes opera aislado por `promotor_id`; no puede acceder a datos de otro promotor. | Crítica |
| AR-002 | La inferencia de lenguaje se ejecuta localmente (Ollama + RTX 4060); las APIs de terceros son opcionales. | Alta |
| AR-003 | Todo tráfico entre nodos (Windows, WSL2, Ubuntu) se canaliza por Tailscale (WireGuard). | Crítica |
| AR-004 | NeMo Guardrails actúa como proxy obligatorio entre cualquier entrada de usuario y el modelo local. | Crítica |
| AR-005 | Los documentos de propiedades se persisten en CouchDB; los embeddings semánticos en Qdrant. | Alta |
| AR-006 | El frontend del panel promotor se construye en Flutter, sin modificar el código del portal principal. | Alta |
| AR-007 | Las credenciales de CouchDB se inyectan vía `--dart-define` y nunca se hardcodean. | Crítica |
| AR-008 | Los bots de Telegram validan User ID contra whitelist; mensajes no autorizados se descartan y registran. | Crítica |
| AR-009 | El sistema debe ser indexable por buscadores (SEO); cada propiedad genera `JSON-LD` y contribuye al `sitemap.xml`. | Media |
| AR-010 | Toda acción se registra en auditoría (CouchDB `auditoria`) con actor, timestamp y promotor_id. | Alta |

---

## 4. Principios de Diseño

1. **Aislamiento por tenant:** `promotor_id` es la clave de partición en CouchDB y Qdrant; ningún query cruza fronteras.
2. **Local-first:** La inferencia corre en hardware propio; la nube es solo para opcionales (EasyBroker, Maps).
3. **Zero-trust:** Todo tráfico interno viaja por Tailscale; sin puertos abiertos públicamente.
4. **Fail-safe en legalidad:** Si NeMo Guardrails no puede validar una respuesta, el flujo se detiene y escala a humano.
5. **Extensibilidad horizontal:** Nuevas skills se agregan como módulos sin tocar el gateway.
6. **Human-in-the-Loop (HITL):** Acciones de alto impacto (enviar propuesta, firmar contrato) pausan el flujo para aprobación por Telegram.
7. **Observabilidad:** Logs centralizados, métricas de inferencia, alertas de salud por agente.

---

## 5. Arquitectura de Contexto (C4 Nivel 1)

```
┌─────────────────────────────────────────────────────────────────────┐
│                          USUARIOS                                    │
│  [Cliente Final]  [Promotor]  [Corredor]  [Admin BuscoBien]          │
└──────┬────────────────┬────────────┬─────────────────┬──────────────┘
       │                │            │                 │
       ▼                ▼            ▼                 ▼
┌─────────────────────────────────────────────────────────────────────┐
│  CANALES: Web Portal (buscobien.net) | Flutter App | Telegram Bots   │
└─────────────────────────────────────────────────────────────────────┘
       │
       ▼
┌─────────────────────────────────────────────────────────────────────┐
│  HERMES BUSCOBIEN CORE (buscobien-backend)                           │
│  ┌──────────────┐ ┌──────────────┐ ┌──────────────┐ ┌────────────┐  │
│  │ Nginx+JWT    │ │ Gateway      │ │ n8n          │ │ Telegram   │  │
│  │ (TLS :443)   │ │ Node.js:3000 │ │ Orchestrator │ │ Bridge     │  │
│  └──────────────┘ └──────────────┘ └──────────────┘ └────────────┘  │
│  ┌──────────────────────────────────────────────────────────────┐   │
│  │  HERMES AGENTS (multi-tenant, por promotor_id):              │   │
│  │  lead-qualifier | prop-manager | sre-guard | budget-bot      │   │
│  │  legal-drafter  | maps-bot     | analytics-bot               │   │
│  └──────────────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────────────┘
       │                                    │
       ▼                                    ▼
┌──────────────────────┐        ┌──────────────────────────────────┐
│ INFERENCIA LOCAL     │        │ PERSISTENCIA                     │
│ WSL2: NeMo:8000      │───────▶│ WSL2: Qdrant:6333 (vectorial)    │
│ Windows: Ollama:11434│        │ WSL2: CouchDB:5984 (documental)  │
└──────────────────────┘        └──────────────────────────────────┘
       │
       ▼
┌─────────────────────────────────────────────────────────────────────┐
│  SERVICIOS EXTERNOS (opcionales)                                     │
│  EasyBroker API | Google Maps | Firma Digital | WhatsApp Business    │
└─────────────────────────────────────────────────────────────────────┘
```

---

## 6. Arquitectura Lógica (C4 Nivel 2)

### 6.1. Capas del Sistema

| Capa | Componentes | Responsabilidad |
|------|-------------|-----------------|
| **Presentación** | Portal Flutter/WASM, Telegram Bots, Panel Promotor | Interacción con usuarios; no contiene lógica de negocio. |
| **Gateway / BFF** | Nginx (TLS+JWT), Hermes Gateway (Node.js) | Autenticación, enrutado, multi-tenant dispatch, validación. |
| **Orquestación** | n8n, Telegram Bridge | Flujos de negocio, nodos HITL, despachos a terceros. |
| **Agentes** | 7 perfiles Hermes (lead-qualifier, prop-manager, etc.) | Razonamiento, generación de contenido, decisiones asistidas. |
| **Gobernanza IA** | NeMo Guardrails (Input/Output/Topical Rails) | Proxy semántico obligatorio hacia el modelo. |
| **Inferencia** | Ollama (Llama 3 8B Q4_K_M) | Extracción de entidades, generación de textos, embeddings. |
| **Persistencia** | CouchDB, Qdrant | Documentos y vectores con aislamiento por `promotor_id`. |
| **Observabilidad** | Logs, métricas, auditoría | Trazabilidad completa, alertas, reportes. |

### 6.2. Patrones Arquitectónicos

| Patrón | Aplicación |
|--------|------------|
| **API Gateway + BFF** | Nginx valida JWT, inyecta `promotor_id`; el Gateway Node.js actúa como backend-for-frontend del panel. |
| **Multi-tenant con contexto propagado** | JWT → header `promotor_id` → middleware → queries a CouchDB/Qdrant con filtro obligatorio. |
| **Proxy pattern** | NeMo Guardrails es proxy entre cualquier cliente HTTP y Ollama; todo pasa por él. |
| **Orquestación con HITL** | n8n usa "Wait for Webhook / Approval" para pausar flujos hasta que el promotor pulse [Aprobar]. |
| **CQRS ligero** | Escrituras en CouchDB (documentos); lecturas enriquecidas en Qdrant (vectoriales). |
| **Skill as module** | Cada skill es un directorio autónomo con prompts + scripts; se habilita por `agent.yaml`. |
| **Backend-for-Frontend (panel promotor)** | El Gateway Node.js expone endpoints simplificados para el panel Flutter, ocultando la complejidad de CouchDB/Qdrant. |

---

## 7. Arquitectura Física (Despliegue)

### 7.1. Nodos del Sistema

| Nodo | Hardware/OS | Servicios | Puertos |
|------|-------------|-----------|---------|
| **Edge / Proxy público** | Servidor Ubuntu (o cloud) | Nginx (TLS, JWT), Let's Encrypt | 443 |
| **Gateway / Orquestación** | Servidor Ubuntu | Hermes Gateway (Node.js), n8n, Telegram Bridge | 3000, 5678 |
| **Inferencia Windows** | Windows 11, RTX 4060 | Ollama | 11434 (localhost) |
| **Gobernanza WSL2** | WSL2 Ubuntu 22.04 | NeMo Guardrails | 8000 (localhost) |
| **Persistencia WSL2** | WSL2 Ubuntu 22.04 | CouchDB, Qdrant (Docker) | 5984, 6333 |
| **Malla segura** | Todos los nodos | Tailscale (WireGuard) | — |

### 7.2. Flujo de Red

```
[Internet]
   │
   ▼
[Nginx :443] ──TLS──▶ valida JWT ──▶ reenvía a Gateway Node.js :3000
                              │
                              ▼
                     [Gateway :3000] ──┐
                              │        │
                     ┌────────┘        └────────┐
                     ▼                          ▼
              [n8n :5678]            [Telegram Bridge :3000]
                     │                          │
                     ▼                          ▼
         ┌─────────────────┐          ┌──────────────────┐
         │ WSL2 : NeMo:8000│◀─────────│ Telegram Bot API │
         │     (Guards)    │          │  (cloud)         │
         └────────┬────────┘          └──────────────────┘
                  │
                  ▼
         ┌──────────────────┐
         │ Windows: Ollama  │
         │ :11434           │
         │ (Llama 3 Q4_K_M) │
         └──────────────────┘
                  │
                  ▼
         ┌────────────────────────────────┐
         │ WSL2: CouchDB:5984 + Qdrant:6333│
         │ (persistencia documental +      │
         │  vectorial)                     │
         └────────────────────────────────┘
```

---

## 8. Arquitectura de Datos

### 8.1. Modelo Documental (CouchDB)

| Base de datos | Documentos clave | Campos multi-tenant |
|---------------|------------------|---------------------|
| `buscobien_usuarios` | usuario, promotor, admin | `promotor_id`, `telegram_user_id`, `rol` |
| `buscobien_propiedades` | ficha, fotos, plano, status | `promotor_id`, `status` (publicada/retirada/vendida) |
| `buscobien_leads` | prospecto, perfil, estado | `promotor_id`, `estado` (nuevo/perfilado/pendiente) |
| `buscobien_contratos` | promesa_compraventa, arras | `promotor_id`, `cliente_id` |
| `buscobien_listas` | lista_compartida, criterios | `promotor_id`, `grupo_ids`, `usuarios_ids` |
| `buscobien_auditoria` | evento, actor, timestamp | `promotor_id`, `actor` |

**Convenciones:**
- Cada documento lleva `_id` con prefijo por tipo: `usr_`, `prop_`, `lead_`, `contr_`, `list_`, `aud_`.
- `promotor_id` es obligatorio en todo documento de dominio.
- Vistas Mango para búsquedas por `promotor_id`, `status`, `zona`, `precio`.

### 8.2. Modelo Vectorial (Qdrant)

| Colección | Payload / Filtros | Contenido |
|-----------|-------------------|-----------|
| `buscobien_catalog` | `promotor_id`, `status`, `zona`, `recamaras`, `tipo_operacion` | Embeddings de descripciones de propiedades. |
| `buscobien_leads_semantic` | `promotor_id`, `lead_id`, `tipo_operacion` | Embeddings de mensajes de leads para matching inverso. |
| `buscobien_historial` | `promotor_id`, `usuario_id`, `timestamp` | Embeddings de interacciones para recomendaciones. |

**Estrategia de actualización:**
- Al crear/actualizar propiedad en CouchDB → trigger recalcula embedding → upsert en Qdrant con `promotor_id` como filtro escalar.
- Al cambiar `status` a `retirada`/`vendida` → se marca el vector como inactivo (payload `activo: false`).

---

## 9. Arquitectura de Agentes Hermes

### 9.1. Catálogo de Agentes

| Agente | Rol | Skills clave | Canales | Dependencias |
|--------|-----|--------------|---------|--------------|
| **hermes-lead-qualifier** | Califica leads entrantes | NLP, detección intención, extracción entidades | Webhook, Telegram, formulario | Ollama, NeMo, CouchDB, Qdrant |
| **hermes-prop-manager** | Gestiona inventario | Ingesta PDF, extracción metadatos, upsert Qdrant | Panel, Telegram | Ollama, CouchDB, Qdrant |
| **hermes-sre-guard** | Monitoreo de salud | Integración SNMP/ONVIF, alertas, logs | Telegram, panel | APIs equipos, CouchDB |
| **hermes-budget-bot** | Genera presupuestos | Cálculo, catálogo precios, export PDF | Telegram, panel, email | Ollama, CouchDB |
| **hermes-legal-drafter** | Redacta contratos | Plantillas MX, validación PROFECO | Panel, export | Ollama, NeMo (Output Rails) |
| **hermes-maps-bot** | Análisis de zona | Google Maps API, tiempos traslado | Panel, mapa | Google Maps |
| **hermes-analytics-bot** | Métricas y KPIs | Reportes ventas, conversión, ciclo | Panel, export CSV/Excel | CouchDB (agregaciones) |

### 9.2. Estructura de un Agente (`agent.yaml`)

```yaml
id: hermes-lead-qualifier
name: Calificador de Leads BuscoBien
description: Analiza mensajes entrantes y clasifica la intención del prospecto.
model: llama3:8b-instruct-q4_K_M      # local vía Ollama
memory:
  documental: couchdb                  # persistencia
  vectorial: qdrant                    # memoria semántica
guardrails: nemo-proxy                 # obligatorio
channels:
  - webhook
  - telegram
  - formulario
skills:
  - lectura_planos
  - generador_presupuestos
  - verificador_cumplimiento
permissions:
  apis: [easybroker, google-maps]      # opcional
  read: [propiedades, leads]
  write: [leads, presupuestos]
multi_tenant:
  partition_key: promotor_id
```

### 9.3. Ciclo de Vida de una Petición (Ejemplo: Nuevo Lead)

```
1. [Formulario web] POST /api/v1/leads/intake
   payload: { promotor_id, mensaje, zona_contacto }
   │
   ▼
2. [Gateway Node.js] valida JWT → inyecta promotor_id
   │
   ▼
3. [hermes-lead-qualifier] ──▶ [NeMo Guardrails :8000] (Input Rails)
   │  - ¿prompt injection?  → bloquear
   │  - ¿topic válido?      → continuar
   ▼
4. [Ollama :11434] extrae: {operacion, presupuesto, zona, urgencia}
   │
   ▼
5. [CouchDB] crea lead con estado "perfilado"
   │
   ▼
6. [Qdrant] consulta vectorial con filtro {promotor_id, status: "disponible"}
   │
   ▼
7. [hermes-prop-manager] devuelve 3 candidatas
   │
   ▼
8. [n8n] workflow → nodo "Wait for Webhook / Approval"
   │
   ▼
9. [Telegram Bot] envía tarjeta al promotor con [Aprobar] / [Rechazar]
   │
   ▼
10. Promotor pulsa [Aprobar] → n8n reanuda → envía propuesta → CouchDB: "propuesta_enviada"
```

---

## 10. Arquitectura de Seguridad

### 10.1. Capas de Seguridad

| Capa | Mecanismo |
|------|-----------|
| **Perímetro** | Tailscale WireGuard mesh; sin puertos públicos excepto 443 (Nginx). |
| **Transporte** | TLS 1.3 en Nginx; HTTPS obligatorio. |
| **Autenticación** | JWT emitido por buscobien-backend; validado en Nginx y Gateway. |
| **Autorización** | `promotor_id` derivado del JWT; middleware fuerza filtro en todas las queries. |
| **Inferencia** | NeMo Guardrails (Input Rails: bloqueo jailbreak; Topical Rails: temas permitidos). |
| **Legalidad** | Output Rails: validación PROFECO/CONTRODE en contratos; si falta cláusula, se bloquea y regenera. |
| **Auditoría** | Cada acción registra `actor`, `timestamp`, `promotor_id` en CouchDB `auditoria`. |
| **Secrets** | `defines.json` / `--dart-define` para Flutter; `.env` local en `~/.hermes/profiles/buscobien/` para tokens. |

### 10.2. Modelo de Amenazas (STRIDE resumido)

| Amenaza | Mitigación |
|---------|------------|
| **Spoofing (suplantación)** | JWT con firma; whitelist de User IDs de Telegram. |
| **Tampering (manipulación)** | NeMo Input Rails bloquea "cambiar precio a $1"; validación de entradas. |
| **Repudiation (repudio)** | Auditoría inmutable por documento; logs centralizados. |
| **Information disclosure** | Aislamiento por `promotor_id`; cifrado en reposo (CouchDB `_security`); sin exposición de datos a terceros sin consentimiento. |
| **Denial of Service** | Rate limiting en Nginx; colas en n8n; aislamiento de inferencia local. |
| **Elevation of Privilege** | Rol derivado del JWT; no hay comandos privilegiados por defecto en agentes. |

---

## 11. Integraciones Externas

| Integración | Tipo | Estado | Uso |
|-------------|------|--------|-----|
| **Telegram Bot API** | REST + Webhook | Obligatorio | Canal C2, botones inline, notificaciones. |
| **Google Maps API** | REST | Obligatorio | Mapas, geocoding, tiempos de traslado. |
| **EasyBroker API** | REST | Opcional (REQ-OP-001) | Sincronización de inventario con portales. |
| **Firma Electrónica (FIEL/e.firma)** | REST / SOAP | Opcional | Firma de contratos generados. |
| **WhatsApp Business API** | REST | Opcional | Envío de propuestas al cliente final. |
| **Pasarelas de pago** | REST | Opcional | Cobro de suscripciones y comisiones. |

**Gestión de credenciales:** Todos los tokens se almacenan en `~/.hermes/profiles/buscobien/.env` y se referencian como `<SECRETO>` en documentación. Nunca se commitean.

---

## 12. Consideraciones de Despliegue

### 12.1. Ambientes

| Ambiente | Propósito |
|----------|-----------|
| **Local / Dev** | WSL2 + Windows + Tailscale; pruebas de agentes y guardrails. |
| **Staging** | Réplica con datos anonimizados; validación de flujos con promotores piloto. |
| **Producción** | Nginx público, gateway, n8n, persistencia; monitoreo 24/7. |

### 12.2. Estrategia de Despliegue

1. **Fase 1:** Levantar gateway + Tailscale + JWT (puerta de entrada).
2. **Fase 2:** NeMo Guardrails + Ollama + Qdrant + CouchDB (pipeline de inferencia).
3. **Fase 3:** Frontend panel promotor + Telegram bots (UI y canal C2).
4. **Fase 4:** Piloto con 3-5 promotores; medir KPIs; ajustar.
5. **Fase 5:** Escalar a catálogo completo; activar integraciones opcionales.

### 12.3. Rollback

- Cada agente es independiente; se puede desactivar desde `agent.yaml` sin afectar el core.
- CouchDB permite revertir por `_rev`; Qdrant permite borrar colección y re-indexar.
- Nginx y Gateway tienen configuraciones versionadas en Git (repositorio externo).

---

## 13. Requisitos No Funcionales

| Requisito | Meta | Verificación |
|-----------|------|--------------|
| **Latencia de búsqueda vectorial** | < 2 s (p95) | Benchmark en Qdrant. |
| **Latencia de inferencia local** | < 5 s por prompt (Llama 3 8B Q4_K_M en RTX 4060) | Logs de Ollama. |
| **Disponibilidad** | 99.5% (excluyendo mantenimiento programado) | Monitoreo Tailscale + health checks. |
| **Escalabilidad** | Soporta 100 promotores activos sin degradación | Pruebas de carga en staging. |
| **Recuperación** | RPO < 1 h (backups CouchDB); RTO < 4 h | Simulacros de restauración. |
| **Seguridad** | 0 credenciales hardcodeadas; 0 datos de un promotor accesibles por otro | Auditoría de código y revisión de logs. |

---

## 14. Métricas de Éxito

| KPI | Meta | Herramienta de medición |
|-----|------|--------------------------|
| Tiempo de calificación de lead | < 2 min | Logs del agente |
| Tiempo lead → primera propuesta | < 5 min | Flujo n8n |
| Precisión de búsqueda vectorial | > 85% relevancia | Click-through en panel |
| Conversión lead → visita | > 30% | CRM integrado |
| Conversión visita → operación | > 15% | n8n → contrato |
| CSAT (satisfacción) | > 4.5/5 | Encuesta post-interacción |
| Reducción de tiempo administrativo | 40% | Comparativa pre/post |

---

## 15. Riesgos y Mitigaciones

| Riesgo | Impacto | Probabilidad | Mitigación |
|--------|---------|--------------|------------|
| Alucinaciones del modelo en contratos | Alto | Media | Output Rails de NeMo + plantillas estrictas + revisión humana obligatoria. |
| Fuga de datos entre promotores | Alto | Baja | Filtro `promotor_id` obligatorio en todas las queries; tests de aislamiento. |
| Caída de Tailscale | Alto | Baja | Fallback a conexión directa cifrada; monitoreo proactivo. |
| Saturación de VRAM en RTX 4060 | Medio | Media | Límite de contexto; cola de peticiones; monitoreo de VRAM. |
| Dependencia de EasyBroker (si se usa) | Medio | Media | Modo degradado: operar sin sincronización externa. |
| Cambios normativos (PROFECO/CONTRODE) | Medio | Baja | Output Rails configurables; actualización de plantillas sin redeploy. |

---

## 16. Trazabilidad

| Documento relacionado | Vínculo |
|-----------------------|---------|
| `Hermes_BuscoBien_Propuesta.md` | Propuesta base (Porter + Business Model Canvas) |
| `requerimientos/modulo_busqueda_propiedades_req.md` | Requerimientos EARS del módulo |
| `plan_marketing_buscobien.md` | Plan de marketing (Shapiro) |
| `arquitectura_general_buscobien.md` (en `/mnt/buscobien`) | Arquitectura base del portal |
| `antigravity_ui_rules.md` (en `/mnt/buscobien`) | Reglas UI para el panel promotor |

---

## 17. Glosario

| Término | Definición |
|---------|------------|
| **HITL** | Human-in-the-Loop: pausa de flujo automatizado para aprobación humana. |
| **Multi-tenant** | Arquitectura donde múltiples clientes (promotores) comparten infraestructura con aislamiento lógico. |
| **Output Rails** | Reglas de NeMo Guardrails que validan la salida del modelo antes de entregarla al usuario. |
| **Embedding** | Representación vectorial de texto para búsqueda semántica en Qdrant. |
| **Colang** | Lenguaje de reglas de NeMo Guardrails para definir rails de entrada/salida. |
| **BFF** | Backend-for-Frontend: capa que adapta datos para un cliente específico (panel Flutter). |

---

## 18. Aprobaciones

| Rol | Nombre | Fecha | Firma |
|-----|--------|-------|-------|
| Arquitecto de Software | — | — | — |
| Líder Técnico BuscoBien | — | — | — |
| Representante del Negocio | — | — | — |

---

*Documento de arquitectura generado a partir de `Hermes_BuscoBien_Propuesta.md`. No modifica código ni documentación del directorio `/mnt/buscobien`; todos los entregables se ubican en `~/.hermes/profiles/buscobien/`.*