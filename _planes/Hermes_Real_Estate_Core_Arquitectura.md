# Hermes Real Estate Core - Arquitectura del Sistema

## Visión General
Sistema de agentes inmobiliarios personales (Hermes Bot) para promotores afiliados a buscobien.net, integrado con la plataforma existente bajo modelo de agentes aislados por `promotor_id`.

## Componentes Principales

### 1. Capa de Presentación & Portal Web
- **Frontend Flutter/WASM**: Mismo código base con rutas adicionales (`/mi-agente`, `/mission-control`, `/listas-compartidas`)
- **Panel de Promotor**: Pestaña dentro del portal con estado del agente, métricas, salud del pipeline y bitácora de auditoría
- **Web Widget (Chat Propietario)**: Chat integrado donde el agente Hermes puede ser invocado con `@Hermes` en grupos o DMs

### 2. Capa de Orquestación & Gateway (Nodo Híbrido)
- **Nginx**: Puerto 443 (HTTPS), terminación TLS, validación JWT, inyección de `promotor_id` en headers, enrutado a servicios internos
- **Node.js/Express Gateway**: Puerto 3000 (interno), autentica JWT, deriva `promotor_id` y reenvía eventos a n8n mediante túnel Tailscale
- **n8n Router**: Orquestador de flujos: webhooks de entrada, nodos de espera de aprobación humana, despachos de correo/WhatsApp, integración con APIs terceras
- **Tailscale malla segura**: Red privada que conecta todos los nodos (Windows, WSL2, Ubuntu) sin exponer puertos públicamente

### 3. Capa de Inferencia, Gobernanza y Persistencia (Nodo Híbrido)
- **Windows 11 (Ollama + RTX 4060)**: Ejecuta `Llama 3 8B` cuantizado (Q4/QLoRA) usando la GPU para extracción de intención, generación de propuestas y razonamiento
- **WSL2 Ubuntu**: 
  - **NeMo Guardrails** (puerto 8000): *Input Rails* (bloqueo de prompt injection, manipulación de precios), *Output Rails* (validación PROFECO/NOM-247-SE-2021), *Topical Rails* (validación de contratos promesa de compraventa)
  - **Qdrant Vector DB** (puerto 6333): Colección `buscobien_catalog` con embeddings semánticos de propiedades y leads; filtros por `promotor_id`, status, zona, recamaras
  - **Apache CouchDB** (puerto 5984): Persistencia documental: usuarios, propiedades, leads, contratos promesa de compraventa, listas compartidas; esquema multi-tenant con `promotor_id`
- **Telegram Bot API**: Canal C2 privado por promotor, botones inline `[Aprobar Envío]` / `[Rechazar / Editar]`, notificaciones en tiempo real, callbacks cifrados hacia n8n

## Diagrama de Flujo Resumido

```
[Promotor – Flutter/WASM] ──HTTPS──► [Nginx] ──JWT──► [Node.js Gateway]
   │                                        │
   │                                        ├──► [n8n Router] ──► [Hermes Gateway] ──► [NeMo Guardrails WS:8000]
   │                                        │                       │                       │
   │                                        ├──► [Webhook a n8n] ──► [Ollama:Llama3] ──► [Qdrant] ──► [CouchDB]
   │                       │                       │                       │
[Promotor Telegram] ──Bot API──► [Hermes Gateway] ──► [n8n] ──► (reanuda/continúa) ──► [Flujos HITL]
```

## Seguridad y Cumplimiento

| Área | Medida |
|------|--------|
| **Autenticación y autorización** | JWT emitido por buscobien‑backend; validado por Nginx antes de cualquier operación. El `promotor_id` se deriva del token y se usa para aislamiento multi‑tenant en todos los servicios. |
| **Red segura** | Todo el tráfico entre nodos (Windows, WSL2, Ubuntu) atraviesa **Tailscale** (WireGuard), sin puertos abiertos públicamente. |
| **Inferencia local** | Los modelos Llama 3 se ejecutan en la RTX 4060 del usuario; todo tráfico hacia Ollama obliga pasar por **NeMo Guardrails** (WSL2:puerto 8000). |
| **Validación legal** | *Output Rails* de NeMo verifican presencia de cláusulas PROFECO (registro de contrato, arras, gravámenes). Si faltan, el bloque se regenera guiado por plantilla estricta. |
| **Acceso Telegram** | Solo los User IDs incluidos en la lista blanca del Hermes Gateway pueden interactuar con los botones HITL y recibir aprobaciones. Cualquier mensaje de un ID no autorizado se descarta y registra en logs de Ubuntu. |
| **Auditoría** | Cada cambio de estado en CouchDB, cada consulta vectorial en Qdrant y cada acción del agente se registra con timestamp y `promotor_id`. Replicable para compliance interno. |
| **Protección de datos sensibles** | Cifrado en reposo (CouchDB `_security`, discos SSD) y en tránsito (HTTPS/TLS en Nginx). Las credenciales de CouchDB nunca se embeden en el código Flutter; se inyectan mediante `--dart-define` en compilación. |