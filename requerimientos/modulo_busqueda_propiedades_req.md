# Requerimiento de Sistema: Módulo de Búsqueda y Gestión de Propiedades para BuscoBien

## 1. Contexto
**BuscoBien** es una plataforma inmobiliaria multiplataforma desarrollada con Flutter, que consume una API Node.js y persiste información en CouchDB (35 bases referenciadas) y Qdrant para búsqueda vectorial. El portal `buscobien.net` ofrece a usuarios y promotores la capacidad de buscar, filtr y gestionar propiedades inmobiliarias, con arquitectura modular, Riverpod 3.x para estado, modelos Freezed y json_serializable, y google_maps_flutter para geolocalización. Los documentos técnicos están organizados bajo `/mnt/buscobien/_documentacion/` siguiendo las 8 etapas SDLC, siendo los más relevantes para este requerimiento: `arquitectura_general_buscobien.md`, `02_requerimientos/EARS_requerimientos_consolidados.md`, `03_analisis_funcional/bdd_high_level_specs.md`, y `05_desarrollo_y_especificaciones_tecnicas/antigravity_ui_rules.md`.

> **Nota:** Este requerimiento está diseñado para operar dentro del ecosistema existente de BuscoBien, sin modificar código ni documentación del directorio `/mnt/buscobien`. Los entregables se generan en `~/.hermes/profiles/buscobien/`.

## 2. Requisitos Ubicuos (Ubiquitous Requirements)
*Requisitos no funcionales y principios de diseño que el sistema debe cumplir de forma permanente.*

- **REQ-UBI-001:** El sistema deberá canalizar todas las peticiones de búsqueda y filtrado de propiedades hacia el endpoint `/api/v1/propiedades/buscar`, inyectando el `promotor_id` del usuario autenticado para aislamiento multi-tenant.
- **REQ-UBI-002:** El sistema deberá mantener actualizados los vectores semánticos en Qdrant ante cualquier mutación en el catálogo maestro de propiedades (`buscobien_propiedades` en CouchDB).
- **REQ-UBI-003:** El sistema deberá encriptar todo el tráfico entre los nodos (Flutter web, API Node.js, CouchDB, Qdrant) utilizando la capa de red segura provista por Tailscale o equivalente Zero-Trust.
- **REQ-UBI-004:** La UI debe seguir obligatoriamente las reglas de Material Design 3 definidas en `antigravity_ui_rules.md` (sin índices de sombra, backgrounds `surface-first`, tokens `appTheme.*`).
- **REQ-UBI-005:** Las credenciales de CouchDB (`COUCHDB_URL`, `username`, `password`) nunca deben aparecer hardcodeadas en el código Flutter; deben inyectarse exclusivamente mediante `--dart-define` en la compilación y almacenarse de forma segura en `flutter_secure_storage` (móvil) o `shared_preferences` (web).
- **REQ-UBI-006:** El portal debe ser totalmente indexable por buscadores (SEO), generando `meta` tags JSON-LD dinámicos por propiedad y manteniendo un `sitemap.xml` actualizado automáticamente.

## 3. Requisitos Dirigidos por Eventos (Event-Driven Requirements)
*Sintaxis: Cuando [evento detonador], el sistema deberá [respuesta del sistema].*

- **REQ-ED-001 (Búsqueda de propiedades):** Cuando el usuario final ingrese criterios de búsqueda (operación: renta/venta, zona geográfica, rango de precio, recámaras, baños, tipo de propiedad) en el campo de búsqueda del portal y pulse "Buscar", el sistema deberá retornar una lista de propiedades ordenadas por relevancia, aplicando filtros sobre los metadatos almacenados en CouchDB y buscando embeddings semánticos en Qdrant con el modelo Llama 3 local (o modelo remoto via Ollama), respetando el `promotor_id` del usuario si aplica.
- **REQ-ED-002 (Captura de lead):** Cuando un usuario complete el formulario de contacto "Solicitar información" en ficha de propiedad, el sistema deberá crear automáticamente un documento de lead en CouchDB (`buscobien_leads`) con timestamp, datos del usuario, ID de propiedad consultada, y disparar un webhook POST a `https://<dominio>/api/v1/leads/intake` con el payload JSON.
- **REQ-ED-003 (Actualización de ficha):** Cuando un promotor actualice los datos de una propiedad (precio, disponibilidad, fotos) desde el panel de administración, el sistema deberá actualizar el documento correspondiente en CouchDB, invalidar los caches de Qdrant y regenerar el embedding vectorial usando el modelo de lenguaje local.
- **REQ-ED-004 (Integración con Telegram Bot):** Cuando un usuario inicie sesión con su Telegram User ID en el perfil de BuscoBien, el sistema deberá asociar el ID al `user_id` de CouchDB y habilitar el envío de notificaciones push interactivas (botones inline) desde el bot de Hermes para aprobaciones de propuestas o alertas de nuevas propiedades.
- **REQ-ED-005 (Geolocalización y mapas):** Cuando el usuario habilite la vista de mapa en ficha de propiedad, el sistema deberá cargar `google_maps_flutter` con marcadores para la propiedad y puntos de interés cercanos (escuelas, hospitales) usando la Google Maps Geocoding/Places API, respetando la estrategia `url_strategy` limpia definida en el stack tecnológico.

## 4. Requisitos de Estado (State-Driven Requirements)
*Sintaxis: Mientras [estado del sistema], el sistema deberá [comportamiento en ejecución].*

- **REQ-SD-001 (Modo búsqueda activa):** Mientras el modelo de búsqueda esté ejecutando una consulta vectorial en Qdrant, el subsistema de monitorización deberá mantener el consumo de VRAM/CPU dentro de límites seguros y mostrar un indicador de "cargando" en UI con skeleton loader según reglas antigravity.
- **REQ-SD-002 (Estado sesión usuario):** Mientras un usuario tenga sesión activa en `buscobien.net` (token JWT vigente, datos en `SessionStorage`/`shared_preferences`), el sistema deberá permitir acceso a rutas protegidas (`/mis-propiedades`, `/panel-promotor`) y actualizar automáticamente el estado `ultima_actividad` en CouchDB cada N minutos.
- **REQ-SD-003 (Propiedad publicada o retirada):** Mientras una propiedad en CouchDB tenga el atributo `status: "publicada"`, deberá aparecer en los resultados de búsqueda y en el mapa; mientras tenga `status: "retirada"` o `status: "vendida"`, deberá ser excluida automáticamente de resultados y mapas, y mostrarse solo en el historial del promotor.

## 5. Requisitos No Deseados / Respuestas a Excepciones (Unwanted Behaviour Requirements)
*Sintaxis: Si [condición de error o ataque], entonces el sistema deberá [acción de contención].*

- **REQ-UB-001 (Inyección de prompts en búsqueda):** Si una entrada de usuario contiene patrones de evasión de instructivas (prompt injection), el sistema deberá filtrar los caracteres especiales no permitidos, limpiar la entrada antes de consultar a Qdrant/ CouchDB, y devolver una respuesta amigable: "Solicitud inválida. Por favor, refine sus criterios de búsqueda."
- **REQ-UB-002 (Filtro de credenciales expuestas):** Si el sistema detecta que un archivo compilado de Flutter contiene variables de entorno de CouchDB sin el flag `--dart-define`, deberá negarse a iniciar la sesión y mostrar error crítico: "Configuración de seguridad incompleta. Contacte al administrador."
- **REQ-UB-003 (Search overload):** Si el número de simultaneidad de búsquedas simultáneas excede el límite configurado (p. ej., 10 consultas por minuto por usuario), el sistema debería colas las solicitudes adicionales y retornar `429 Too Many Requests` con header `Retry-After`, en lugar de saturar la base de datos.
- **REQ-UB-004 (SEO metadata vacío):** Si las metadatos SEO (title, description, JSON-LD) no pueden generarse para una propiedad, el sistema debería usar valores por defecto optimizados por palabra clave y registrar un warning en los logs, en lugar de enviar páginas sin metadatos a los buscadores.

## 6. Requisitos Opcionales (Optional Features Requirements)
*Donde [función o subsistema opcional esté habilitado], el sistema deberá [comportamiento específico].*

- **REQ-OP-001 (Integración con EasyBroker API):** Donde se configure la API externa de EasyBroker en el orquestador n8n, el sistema deberá sincronizar bidireccionalmente el inventario de propiedades para evitar disparidades de precios o disponibilidad en portales comerciales.
- **REQ-OP-002 (Generación multimedia local):** Donde el entorno cuente con capacidad de procesamiento en segundo plano disponible, el subsistema deberá componer automáticamente carruseles de imágenes optimizadas y vídeos cortos de introducción de propiedades para redes sociales (Instagram, Facebook), usando scripts Python ejecutados por Hermes en la GPU RTX 4060 del usuario.
- **REQ-OP-003 (Agente Hermes recomendarador):** Donde el modelo Llama 3 local esté entrenado con histórico de interacciones, el sistema deberá ofrecer recomendaciones proactivas de propiedades al usuario logado basándose en su historial de búsquedas, favoritos y perfil de presupuesto.

## 7. Matriz de Trazabilidad Breve

| Requisito | Origen | Afecta Módulo | Dependencia |
|-----------|--------|---------------|-------------|
| REQ-UBI-001 | Arquitectura BuscoBien | API Gateway, CouchDB query | JWT, `promotor_id` |
| REQ-ED-001 | Flujo usuario portal | Módulo búsqueda Flutter, Qdrant, CouchDB | google_maps_flutter, stack_tecnologico.md |
| REQ-SD-001 | Rendimiento UI | Flutter render, estado Riverpod | antigravity_ui_rules.md |
| REQ-UB-001 | Seguridad | Validación entrada, sanitización | NeMo Guardrails (si está activo) |
| REQ-OP-001 | Expansión externa | API EasyBroker, n8n | tokens de terceros (almacenar en .env local) |

## 8. Definición de Hecho (Definition of Done) por Requerimiento

Un requerimiento seconsiderá "Done" cuando:
1. El caso de test unitario/integración associated pase en el entorno de CI (usando `dart test` y `build_runner`).
2. La documentación técnica esté actualizada en `_documentacion/` con enlaces relativos verificados por `verificar_documentacion.py`.
3. No se hayan introducido vulnerabilidades de seguridad nuevas (revisión de `AGENTS.md` y checklist de credenciales).
4. El cambio cumpla con las `antigravity_ui_rules.md` y no rompa la responsividad web probada en Chrome/Firefox/Edge.
5. Los `dart-define` para credenciales estén validados y no hardcodeados (revisado por Security Officer).

---
*Generado alineado con la Cadena de Valor de Porter (análisis de actividades primarias y de apoyo para el módulo de búsqueda/gestión) y el Business Model Canvas (segmentos: compradores, vendedores, promotores; propuesta de valor: búsqueda inteligente, vectorial, con cumplimiento normativo y SEO; canales: portal web, app móvil, Telegram Bot; flujos de ingreso: suscripción promotor, comisión por transacción, mantenimiento; recursos clave: CouchDB, Qdrant, modelo Llama 3, Google Maps; actividades clave: búsqueda, filtrado, lead capture, gestión de propiedades; socios clave: APIs inmobiliarias, fabricantes de hardware; estructura de costos: infraestructura cloud/on-premise, licencias, desarrollo de agentes).*