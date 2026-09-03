# Epic: Pantallas — Tu Cuenta > Conocidos (Red Social Privada) (08_pantallas/tu_cuenta/conocidos)

**Directorio:** `lib\08_pantallas\tu_cuenta\conocidos\`
**Archivos:** 14 `.dart` (10 en raíz + 1 en `models/` de fuente + 2 generados `.g.dart`/`.freezed.dart` + 1 en `providers/`) — **Total: 14**
**Fecha:** 2026-08-13
**Fuente:** Ingeniería inversa

---

## Impact Mapping

| Objetivo de Negocio | Actor | Impacto | Entregable |
|---------------------|-------|---------|------------|
| Funcionalidades sociales (chat, lista contactos, invitaciones) | Usuario | Ve sus contactos, descubre nuevos, invita a la red, chatea 1:1 con burbujas de propiedad/lista | `PageMisContactos`, `PageDescubrirUsuarios`, `PageInvitaciones`, `PageChatPrivado` |
| Sistema de solicitudes e invitaciones | Usuario | Envía/acepta/rechaza invitaciones para conectarse | `invitacion_model.dart`, `social_providers.dart` (InvitacionesNotifier), `PageInvitaciones` |
| Interacción social con catálogo (propiedad/lista en chat) | Usuario | Comparte propiedad o lista directamente en el chat y abre detalle | `page_chat_privado.dart _BurbujaPropiedad`, `_BurbujaLista` |

---

## User Story Mapping

```
Sección "Tu Cuenta > Conocidos" de PrincipalSliversMenuInicial
   │
   ▼
ConocidosView (Consumer widget)
   ├── tabs: Mis Contactos | Descubrir | Invitaciones
   │
   ├── PageMisContactos (lista conocidos de currentUser)
   │     └── tap contacto → PagePerfilContacto (ver perfil)
   │           └── CTA "Chatear" → PageChatPrivado
   │
   ├── PageDescubrirUsuarios (buscar nuevos usuarios por nombre/email)
   │     └── tap → PagePerfilContacto
   │           ├── CTA "Invitar" → crea invitacion_model
   │           └── CTA "Chatear" si ya son conocidos
   │
   └── PageInvitaciones (invitaciones recibidas)
         ├── Aceptar → crea doc busco_mensajes + busco_conocido
         └── Rechazar → marca invitacion rechazada
```

---

## Especificación SDD / EARS

**Prefijo IDs:** `REQ-CON-XXX`

| ID | Tipo EARS | Requerimiento | Evidencia | Estado |
|----|-----------|---------------|-----------|--------|
| REQ-CON-001 | **Ubicuo** | El sistema expondrá modelos `MensajeModel` (61), `InvitacionModel` (59), `conocido.dart` (Freezed) para tipar conversaciones, invitaciones y contactos. | `mensaje_model.dart`, `invitacion_model.dart`, `models/conocido.dart` | En código |
| REQ-CON-002 | **Ubicuo** | El sistema expondrá `ConocidosView` (ConsumerStatefulWidget, 71 líneas) con 3 tabs: Mis Contactos / Descubrir / Invitaciones. | `conocidos_view.dart:1-71` | En código |
| REQ-CON-003 | **Estado** | Mientras el usuario esté en `PageMisContactos`, el sistema listará sus conocidos vía `conocidosNotifierProvider` (filtrado por `idUsuario == currentUser`), con búsqueda por nombre y CTA tap → `PagePerfilContacto`. | `page_mis_contactos.dart:140`, `providers/conocidos_notifier.dart` | En código |
| REQ-CON-004 | **Evento** | Cuando el usuario visite `PageDescubrirUsuarios`, el sistema permitirá buscar usuarios por nombre/email y mostrará tarjetas con CTA "Invitar" (si no son conocidos) o "Chatear" (si ya lo son). | `page_descubrir_usuarios.dart:173` | En código |
| REQ-CON-005 | **Evento** | Cuando el usuario toque "Invitar", el sistema creará un doc en `buscobien_invitaciones` (con `_id` SHA1/UUID) con estado "pendiente", e incrementará badge en el tab Invitaciones del receptor. | `social_providers.dart:InvitacionesNotifier`, `invitacion_model.dart` | En código |
| REQ-CON-006 | **Evento** | Cuando el receptor toque "Aceptar" en `PageInvitaciones`, el sistema creará bidireccionalmente docs en `buscobien_conocidos_usuarios` (origen+destino) + mensaje de bienvenida en `buscobien_mensajes`, y notificará vía `provider_mensajes`. | `social_providers.dart.aceptarInvitacion`, `page_invitaciones.dart:162` | En código |
| REQ-CON-007 | **Estado** | Mientras el usuario esté en `PageChatPrivado`, el sistema consumirá `MensajesChatNotifier` (225 líneas) para listar mensajes paginados por `(idUsuarioOrigen, idUsuarioDestino)` y permitir envío de mensajes de texto + compartir propiedad/lista. | `page_chat_privado.dart:398`, `provider_mensajes.dart:225` | En código |
| REQ-CON-008 | **Evento** | Cuando el usuario envíe una propiedad o lista al chat, el sistema insertará un mensaje de tipo `'propiedad'` o `'lista'` con payload doc, que se renderizará como `_BurbujaPropiedad` o `_BurbujaLista` (sub-widgets en PageChatPrivado). | `page_chat_privado.dart:_BurbujaPropiedad, _BurbujaLista` | En código |
| REQ-CON-009 | **Evento** | Cuando el receptor toque una `_BurbujaPropiedad`/_BurbujaLista en el chat, el sistema navegará a `PaginaDetalleWidget` (de `08_pantallas/propiedades`) o `PageDetalleLista` (de `03_listas`). | `page_chat_privado.dart` tap handlers | En código |
| REQ-CON-010 | **No Deseado** | Si `aceptarInvitacion` falla a la mitad (crea `conocidos` pero no `mensaje`), el sistema puede dejar estado inconsistente — deuda transaccionalidad. | `social_providers.dart:aceptarInvitacion` | Deuda técnica |
| REQ-CON-011 | **Complejo** | Mientras el usuario esté en `PagePerfilContacto`, el sistema leerá `provider_session` del contacto, mostrará avatar/nombre/datos públicos y CTAs condicionales (Invitar si no conocidos, Chatear si ya conocidos, Eliminar si son conocidos). | `page_perfil_contacto.dart:159` | En código |

---

## Trazabilidad a Código

| Componente | Archivo | Líneas |
|------------|---------|--------|
| `ConocidosView` (ConsumerStateful) | `conocidos_view.dart` | 71 |
| `MensajeModel` | `mensaje_model.dart` | 61 |
| `InvitacionModel` | `invitacion_model.dart` | 59 |
| `Conocido` (Freezed) | `models/conocido.dart` | (n/a) |
| `Conocido.freezed.dart`, `Conocido.g.dart` | `models/` (generados) | — |
| `PageChatPrivado` + `_BurbujaPropiedad` + `_BurbujaLista` | `page_chat_privado.dart` | 398 |
| `PageDescubrirUsuarios` | `page_descubrir_usuarios.dart` | 173 |
| `PageInvitaciones` | `page_invitaciones.dart` | 162 |
| `PageMisContactos` | `page_mis_contactos.dart` | 140 |
| `PagePerfilContacto` | `page_perfil_contacto.dart` | 159 |
| `MensajesChatNotifier` | `provider_mensajes.dart` | 225 |
| `InvitacionesNotifier` | `social_providers.dart` | 217 |
| `ConocidosNotifier` | `providers/conocidos_notifier.dart` | (n/a) |

---

## Deuda Técnica

1. **Inconsistencia de layout:** modelo `conocido.dart` vive en `models/` (Freezed) pero `mensaje_model.dart` y `invitacion_model.dart` viven en raíz (json manual). Deberían homogenizar.
2. **Providers repartidos:** `MensajesChatNotifier` en raíz (`provider_mensajes.dart`) y `InvitacionesNotifier` en raíz (`social_providers.dart`), pero `ConocidosNotifier` en `providers/`. Deuda de organización.
3. **Transaccionalidad `aceptarInvitacion`:** crea 2 docs `conocidos` (origen+destino) + 1 mensaje — si falla 1, queda inconsistente. Refactor: usar `_bulk_docs` CouchDB o saga.
4. **`_BurbujaPropiedad` / `_BurbujaLista` embebidos en `PageChatPrivado`:** 398 líneas — extraer a `60_global_widgets/burbuja_propiedad_lista.dart` reutilizable en `PageChatGrupo` (duplicación parcial documentada en grupos).
5. **Sin `@riverpod` annotations** en providers legacy (`StateNotifier`, `Notifier`) — Riverpod 3.x deprecó los legacy. Migración pendiente.
6. **Sin tests** de ningún archivo.
7. **Acoplamiento con `03_listas`** (PageDetalleLista navigation) y `08_pantallas/propiedades` (PaginaDetalleWidget) — esperado.
