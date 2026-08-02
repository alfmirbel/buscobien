# SDD - 08_pantallas_tu_cuenta_conocidos
**Directorio:** `lib/08_pantallas/tu_cuenta/conocidos`
**Fecha:** 2026-07-25

## Estructura técnica
- **Archivos:** `conocidos_view.dart`, `page_mis_contactos.dart`, `page_invitaciones.dart`, `page_descubrir_usuarios.dart`, `page_chat_privado.dart`, `page_perfil_contacto.dart`, `invitacion_model.dart`, `mensaje_model.dart`, `models/conocido.dart`, `.freezed.dart`, `.g.dart`, `provider_mensajes.dart`, `providers/conocidos_notifier.dart`, `social_providers.dart`
- **Providers:** `conocidos_notifier.dart`, `provider_mensajes.dart`
- **Modelos:** `Conocido`, `InvitacionEstado`, `Mensaje`
- **Páginas/Rutas:** Mis contactos, invitaciones, descubrir usuarios, chat privado, perfil contacto
- **I/O externo:** CouchDB HTTP
- **Dependencias:** `flutter_riverpod`, `http`
- **Riesgos:** Restricción de chat por estado; invitaciones duplicadas.

## Requerimientos EARS

### REQ-UBI-001 — Ubiquitous
El sistema deberá permitir invitar contactos y listar los aceptados.

### REQ-EVT-001 — Event-Driven
Cuando el usuario envía invitación, el sistema deberá persistir el documento.

### REQ-EVT-002 — Event-Driven
Cuando el usuario acepta una invitación, el sistema deberá agregar el contacto.

### REQ-STATE-001 — State-Driven
Mientras la relación no esté aceptada, el sistema deberá impedir chat privado.

### REQ-STATE-002 — State-Driven
Mientras el chat privado esté abierto, el sistema deberá suscribirse a cambios.

### REQ-UNW-001 — Unwanted
Si la invitación ya fue resuelta, entonces el sistema deberá mostrar estado final y evitar reenvío.

### REQ-CMP-001 — Complex
Mientras el usuario revisa invitaciones, cuando acepta una solicitud, el sistema deberá agregar contacto y redirigir a chat privado.
