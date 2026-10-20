# Hermes Real Estate Core - Plan de Trabajo Actualizado

> **Nota:** Todo el trabajo descrito a continuación se realiza **fuera del repositorio `buscobien`** (es decir, fuera de `/mnt/buscobien` y su árbol `_documentacion/`). No se modifican archivos de código, documentación ni configuración existente del proyecto. Los entregables se ubicarán en directorios propios del perfil `buscobien` bajo `~/.hermes/profiles/buscobien/` o en rutas de configuración independientes.

## 1. Estado Actual y Puerta de Entrada

| Item | Estado | Acción |
|------|--------|--------|
| **Corrección Nginx + JWT** | **En proceso** (usuario reportó) | **GATE:** El plan no inicia Fase 1 hasta que Nginx esté con terminación TLS y validación JWT sobre el dominio de `buscobien.net`. Se espera confirmación del usuario antes de pasar a la siguiente fase. |
| **Arquitectura definida** | Aprobada (ver arquitectura Hermes Real Estate Core) | Servirá como base técnica para todas las fases. |
| **Hardware disponible** | MSI Katana + RTX 4060, WSL2 Ubuntu, servidor Node.js | Listo para uso; no requiere adquisiciones nuevas. |
| **Accesos terceros** | Pendientes de registro (Telegram bot, APIs opcionales) | Se gestionarán en la Fase 1. |

## 2. Equipo y Roles

| Rol | Responsabilidades | Tiempo estimado semanal |
|-----|-------------------|--------------------------|
| **Project Lead / Architecture Owner** | Validación de gates, coordinación entre equipos, aprobación de entregables. | 2 h |
| **DevOps / Infra** | Nginx, Tailscale, despliegue de contenedores, configuración de puertos locales, seguridad de red. | 8 h |
| **Backend Engineer (Node.js/Express)** | Gateway JWT, endpoints de webhooks a n8n, integración Hermes Gateway, configuración de n8n flujos. | 10 h |
| **Flutter/Frontend Engineer** | Nuevas rutas y pantallas en buscobien.net (`/mi-agente`, `/mission-control`, `/listas-compartidas`), widgets de estado del bot, adaptación UI/UX. | 12 h |
| **AI/ML Engineer** | Despliegue de Ollama + Llama 3 8B, configuración de NeMo Guardrails (Colang scripts), validación Input/Output Rails PROFECO. | 10 h |
| **QA / Tester** | Casos de prueba unitarios y de integración, validación de flujos HITL (Telegram), pruebas de seguridad (inyección de prompts, permisos Telegram). | 6 h |
| **Security Officer** | Revisión de listas blancas Telegram, auditoría de JWT, validación de cumplimiento PROFECO en barandillas, manejo de datos sensibles. | 4 h |

> **Todos los miembros operan sobre configuraciones y entornos aislados**; ningún cambio toca el directorio `buscobien` en `/mnt/buscobien`.

## 3. Fases y Entregables

### **Fase 0 – Puerta de Entrada y Ambiente Base**
| Objetivo | Quitar el gate Nginx/JWT y tener el ambiente base listo. |
|----------|----------------------------------------------------------|
| **Tareas** | 1. Recibir confirmación del usuario de que Nginx + JWT ya no bloquea tráfico interno.<br>2. Verificar conectividad Tailscale entre todos los nodos (Windows, WSL2, Ubuntu).<br>3. Crear directorios de trabajo fuera del repo buscobien: `~/hermes-workspace/`, `~/.hermes/profiles/buscobien/config/`, `~/hermes-workspace/scripts/`|
| **Entregables** | - Informe de estado: "Nginx JWT gate cleared".<br>- Topología Tailscale verificada (IPs/subnets de cada nodo).<br>- Estructura de carpetas lista para los siguientes pasos. |
| **Dependencias** | Ninguna fuera de la confirmación del gate. |
| **Owner** | DevOps / Infra |

---

### **Fase 1 – Gateway Seguro y Configuración de Red**
| Objetivo | Tener Nginx con TLS terminación, validación JWT y enrutado interno listos. |
|----------|--------------------------------------------------------------------------|
| **Tareas** | 1. **Nginx**: Configurar bloque `server { listen 443 ssl; ssl_cert...; location / { proxy_pass http://127.0.0.1:3000; auth_jwt "..."; add_header promoter_id $promoter_id; } }` (usando certificado autofirmado o el existente del entorno).<br>2. **JWT**: Generar esquema de tokens que incluyan `promotor_id`, `roles`, `exp`. El backend de buscobien.net ya emite JWTs; se reutiliza la válidadación existente, solo se añade el header `promoter_id` que los downstream servicios leerán.<br>3. **Hermes Gateway (módulo interno)**: Script Node.js que mantiene `whitelist_telegram_user_ids.txt`; valida cada mensaje entrante antes de pasar a NeMo Guardrails.<br>4. **Tailscale**: Verificar modo *subnet* y que todos los nodos se ven entre sí (Windows, WSL2, Ubuntu).<br>5. **Prueba**: `curl -k https://buscobien.net/api/v1/ping` debe devolver `200` con header `promoter_id`. |
| **Entregables** | - Archivo `nginx.conf` configurado (fuera de `/mnt/buscobien`).<br>- Script `hermes-gateway.js` con lista blanca y middleware JWT.<br>- Documento `tailscale-topology.md` (diagrama y IPs).<br>- Script de prueba `test-gateway.sh`. |
| **Dependencias** | Gate Fase 0 aprobado. |
| **Owner** | DevOps / Infra + Backend Engineer |

---

### **Fase 2 – Pipeline de Inferencia Segura y Bases de Datos Vectoriales**
| Objetivo | NeMo Guardrails + Ollama + Qdrant + CouchDB operativos con multi‑tenant. |
|----------|------------------------------------------------------------------------|
| **Tareas** | 1. **NeMo Guardrails (WSL2)**: Crear directorio `~/.hermes/profiles/buscobien/config/guardrails/` con tres archivos Colang:<br>`input_rails.colang` (bloqueo prompt injection, "cambiar precio", roles no autorizados).<br>`output_rails.colang` (validación PROFECO: presencia de cláusula de registro, arras, gravámenes; rechazo y regeneración guiada).<br>`topical_rails.colang` (validación de contratos promesa de compraventa).<br>2. **Ollama (Windows)**: `ollama run llama3:8b` con modelo cuantizado `Q4_K_M`; verificar consumo VRAM < 7.5 GB en RTX 4060.<br>3. **Qdrant (WSL2)**: `docker run -p 6333:6333 qdrant/qdrant`; crear colección `buscobien_catalog` con payloads: `promotor_id`, `status`, `zona`, `recamaras`.<br>4. **CouchDB (WSL2)**: `docker run -p 5984:5984 couchdb`; crear `_users` y `_security` con esquema `promotor_id` por documento.<br>5. **Subagentes Hermes (Node.js)**:<br>   - `hermes-lead-qualifier.js`: escucha webhook `POST /api/v1/leads/intake`, pasa por NeMo Guardrails (`curl -X POST http://localhost:8000/parse`), extrae entidades con Ollama JSON mode, guarda lead en CouchDB, consulta Qdrant con filtro `promotor_id`.<br>   - `hermes-prop-manager.js`: monitorea carpeta `~/hermes-workspace/ingesta/`, procesa PDFs/fichas, extrae atributos rígidos, genera copy SEO, calcula embedding (usando `ollama embed` o SDK Qdrant), actualiza CouchDB y Qdrant.<br>   - `hermes-sre-guard.js`: wrapper alrededor de Ollama que toda petición debe pasar por `http://localhost:8000/v1/chat/completions`; ante bloqueo, retorna respuesta canónica de seguridad y registra log en Ubuntu. |
| **Entregables** | - `guardrails/` con 3 archivos Colang.<br>- `ollama-config.json` (modelo, GPU, parámetros).<br>- `qdrant-collection-schema.md`.<br>- `couchdb-security-schema.md`.<br>- 3 scripts Node.js de subagentes (lead‑qualifier, prop‑manager, sre‑guard).<br>- `docker-compose.yml` local (solo para Qdrant + CouchDB, sin tocar reposo buscobien). |
| **Dependencias** | Fase 1 completada (gateway y Tailscale). |
| **Owner** | AI/ML Engineer + Backend Engineer |

---

### **Fase 3 – Frontend, Telegram Bot y Adaptador Social**
| Objetivo | UI en buscobien.net lista, bot Telegram funcional, adapter WebSocket para chat interno. |
|----------|------------------------------------------------------------------|
| **Tareas** | 1. **Flutter rutas**: Agregar (fuera del repo `buscobien`, en `~/.hermes/profiles/buscobien/frontend/`):<br>   - `routes.dart` con rutas `/mi-agente`, `/mission-control`, `/listas-compartidas`.<br>   - Pantallas asociadas que consumen `http://127.0.0.1:3000/api/v1/...` (gateway Node).<br>2. **Bot Telegram**: Registrar nuevo bot @BotFather, obtener token. Crear script `telegram-bot.js` (Node.js con `node-telegram-bot-api`):<br>   - Commands: `/start`, `/status`, `/propiedades`.<br>   - Inline keyboards: `[Aprobar Envío]`, `[Rechazar / Editar]` con callbacks cifrados (usando secreto compartido con n8n).<br>   - Responder notificaciones de leads, estado de propiedades, listas compartidas.<br>3. **Hermes Gateway integration**: Conectar `telegram-bot.js` con el módulo `hermes-gateway.js` de Fase 1 (validar User ID contra whitelist).<br>4. **Adapter WebSocket social**: Componente Flutter `social-concierge.dart` que se conecta a `ws://127.0.0.1:3000/ws` (gateway Node) y maneja eventos `@Hermes`, invocaciones en grupos, listado de propiedades en tiempo real.<br>5. **Pruebas de UI**: Navegación por nuevas rutas, simulación de respuestas del bot, envío de pruebas de aprobaciones. |
| **Entregables** | - `flutter_routes_expansion/` (nuevas rutas y pantallas, *solo archivos Dart/XML, sin tocar `lib/` original).*<br>- `telegram-bot.js` con comandos y inline keyboards.<br>- `social-adapter.dart` (Flutter WebSocket).<br>- `test-frontend.sh` (scripts de automatización de clicks/validaciones). |
| **Dependencies** | Fase 2 operativa (pipeline de inferencia). |
| **Owner** | Flutter/Frontend Engineer + Backend Engineer |

---

### **Fase 4 – Pilotaje con Promotores y Ajustes**
| Objetivo | Validar flujo completo con 5 promotores reales y ajustar parámetros. |
|----------|---------------------------------------------------------------------|
| **Tareas** | 1. **Alta de promotores**: Crear 5 cuentas de prueba en `buscobien.net` (o entorno de staging).<br>2. **Onboarding Telegram**: Cada promotor ejecuta `/start` con el bot, provee su User ID, se agrega a la whitelist.<br>3. **Flujo end‑to‑end**:<br>   - Promotor suba una ficha PDF → `hermes-prop-manager` la procesa, actualiza CouchDB/Qdrant.<br>   - Usuario final en buscobien.net consulta propiedades → sistema filtra por `promotor_id` y muestra 3 candidatas.<br>   - n8n webhook dispara → Ollama extrae intención → Qdrant devuelve coincidencias → n8n envía tarjeta Telegram al promotor con `[Aprobar Envío]`.<br>   - Promotor pulsa → n8n reanuda → envía propuesta por WhatsApp/correo → CouchDB actualiza a `propuesta_enviada`.<br>4. **Monitoreo**: Grafana/loki básico (o logs de consola) para tiempos de inferencia, tasas de bloqueo NeMo, uso VRAM, latencia de Qdrant/CouchDB.<br>5. **Ajustes**: Refinar barandillas Colang (añadir/quitar patrones), ajustar prompts de Ollama, actualizar listas blancas, corregir UI si es necesario. |
| **Entregables** | - Informe de pilotaje (`pilot-report.md`): métricas de éxito, fallos, observaciones.<br>- Scripts de ajuste de barandillas actualizados.<br>- Guía de operación para el promotor (cómo vincular Telegram, qué esperar). |
| **Dependencias** | Fase 3 completada y operativa. |
| **Owner** | QA / Tester + Proyecto Lead + Todos los roles (colaboración). |

## 4. Timeline Resumido (8 semanas)

| Semana | Enfoque Principal |
|--------|-------------------|
| **0** | Gate Nginx/JWT, entorno base (Fase 0). |
| **1‑2** | Gateway seguro, Tailscale, JWT inyección (Fase 1). |
| **3‑4** | Pipeline inferencia: NeMo, Ollama, Qdrant, CouchDB, subagentes (Fase 2). |
| **5‑6** | Frontend nuevas rutas, bot Telegram, adapter social (Fase 3). |
| **7‑8** | Pilotaje con 5 promotores, observación, ajustes finales (Fase 4). |

> **Total:** ~8 semanas desde la aprobación del gate. Todas las entregables se entregan en rutas fuera de `/mnt/buscobien`, por lo que el proyecto original permanece intacto.

## 5. Herramientas y Accesos de Terceros (a gestionar)

| Herramienta | Tipo de Acceso | Qué se Necesita Hacer |
|-------------|----------------|-----------------------|
| **BotFather (Telegram)** | Cuenta nueva / token bot | Crear bot `@buscobien_bot`, token para `telegram-bot.js`. |
| **n8n** | Auto‑hosted (Docker) | Despliegue de flujos: webhooks de leads, nodos de espera HITL, despachos WhatsApp/correo. |
| **Google Maps APIs (opcional)** | API key REST | Si se quiere enriquecer fichas con escuelas/hospitales/tiempos de traslado (bandera `REQ-OP-001`). |
| **EasyBroker API** | Token OAuth | Sincronización opcional de inventario con portales externos. |
| **APIs de Firma Electrónica (MILES/Notaría)** | REST / SOAP | Redacción semi‑autónoma de contratos promesa de compraventa y envío a firma (opcional en Fase 4). |
| **Google Calendar API** (opcional) | API key REST | Sincronizar disponibilidad del promotor para recorridos. |
| **WhatsApp Business API** | Cuenta/token | Envío de propuestas al cliente final (opcional). |

> **Todas las claves y tokens se almacenarán en archivos `.env` locales** fuera del reposo `buscobien` (ej. `~/.hermes/profiles/buscobien/.env`). Nunca se commitean ni comparten en el repositorio original.

## 6. Restricciones y Check‑list de No‑Modificación

| Área | Acción Permitida | Acción Prohibida |
|------|------------------|------------------|
| **Código fuente `buscobien`** | Nada. | No editar `lib/`, `pubspec.yaml`, `routes.dart`, ningún archivo bajo `/mnt/buscobien`. |
| **Documentación `_documentacion/`** | Nada. | No modificar markdowns, índices, scripts de verificación dentro de esa carpeta. |
| **Configuración del perfil `buscobien`** | ✅ Crear/editar bajo `~/.hermes/profiles/buscobien/` (skills, plugins, config, scripts, workspace). | ❌ Extender o alterar la estructura existente del repo. |
| **Sistema de archivos del usuario** | ✅ Usar carpetas propias (`~/hermes-workspace/`, `~/scripts`, `~/.hermes/...`). | ❌ Modificar carpetas del proyecto `buscobien` en `/mnt` o `D:/`. |
| **Accesos a terceros** | ✅ Crear cuentas, obtener tokens, almacenarlos localmente. | ❌ Publicar credenciales en chat ni en repos. |

## 7. Próximos Pasos Imediatos (órden de ejecución)

1. **Solicitar al usuario:** Confirmación formal de que la corrección de Nginx + JWT está lista y el gate está aprobado.
2. **Ejecutar Fase 0** – una vez confirmado: crear estructura de carpetas, verificar Tailscale, generar informe de gate cleared.
3. **Pasar a Fase 1** – configurar Nginx, JWT middleware, Hermes Gateway, lista blanca Telegram.
4. **Iterar Fases 2‑4** – según el timeline, con revisiones cada dos semanas.

## 8. Cierre

Este **Plan de Trabajo Actualizado** provee una hoja de ruta clara y sin riesgos para la integración de **Hermes Real Estate Core** sobre la infraestructura existente del usuario, respetando la restricción de no tocar el código ni documentación del proyecto `buscobien`. Cada fase tiene entregables tangibles, owners asignados y dependencias explícitas. La clave de inicio es la aprobación del **gate Nginx + JWT**; una vez superado, el resto sigue un ritmo predecible de 2 semanas por fase, con un piloto operativo al final de la octava semana.