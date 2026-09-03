# SDD - 08_pantallas_tu_cuenta_grupos
**Directorio:** `lib/08_pantallas/tu_cuenta/grupos`
**Fecha:** 2026-07-25

## Estructura técnica
- **Archivos:** `grupos_view.dart`, `page_mis_grupos.dart`, `page_descubrir_grupos.dart`, `page_detalle_grupo.dart`, `page_chat_grupo.dart`, `page_invitaciones_grupo.dart`, `models/grupo.dart`, `.freezed.dart`, `.g.dart`, `models/grupo_model.dart`, `models/aviso_grupo_model.dart`, `models/invitacion_grupo_model.dart`, `models/mensaje_grupo_model.dart`, `models/publicacion_grupo_model.dart`, `providers/grupos_notifier.dart`, `providers/grupos_invitaciones_provider.dart`, `providers/grupos_mensajes_provider.dart`, `providers/publicaciones_grupo_provider.dart`, `providers/avisos_grupo_provider.dart`
- **Providers:** `grupos_notifier`, `grupos_mensajes_provider`, `publicaciones_grupo_provider`, `avisos_grupo_provider`, `grupos_invitaciones_provider`
- **Modelos:** `Grupo`, `GrupoModel`, `MensajeGrupoModel`, `PublicacionGrupoModel`, `AvisoGrupoModel`, `InvitacionGrupoModel`
- **Páginas/Rutas:** Mis grupos, descubrir, detalle, chat grupual, invitaciones
- **I/O externo:** CouchDB HTTP; `_changes?feed=continuous`
- **Dependencias:** `flutter_riverpod`, `http`, `uuid`
- **Riesgos:** Colisiones `_rev`; cierre de stream en chat grupal; límite 250 chars en avisos.

## Requerimientos EARS

### REQ-UBI-001 — Ubiquitous
El sistema deberá listar grupos, permitir descubrimiento público y mostrar chat.

### REQ-EVT-001 — Event-Driven
Cuando el usuario envía invitación, el sistema deberá crear documento de invitación.

### REQ-EVT-002 — Event-Driven
Cuando se publica un aviso, el sistema deberá escribir el documento y notificar chat.

### REQ-EVT-003 — Event-Driven
Cuando un miembro acepta invitación, el sistema deberá agregarlo al grupo.

### REQ-STATE-001 — State-Driven
Mientras el usuario está en chat grupal, el sistema deberá mantener suscripción continua.

### REQ-UNW-001 — Unwanted
Si hay colisión de `_rev`, entonces el sistema deberá reintentar con revisión actual antes de actualizar miembros.

### REQ-UNW-002 — Unwanted
Si el chat pierde conexión, entonces el sistema deberá almacenar mensaje como pendiente.

### REQ-CMP-001 — Complex
Mientras el usuario publica, cuando el aviso supera 250 caracteres, el sistema deberá rechazar publicación inline y mantener foco.
