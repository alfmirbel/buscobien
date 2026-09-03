# Epic: Pantallas — Tu Cuenta > Grupos (Red Social Comunitaria) (08_pantallas/tu_cuenta/grupos)

**Directorio:** `lib\08_pantallas\tu_cuenta\grupos\`
**Archivos:** 19 `.dart` (6 en raíz [views/pages] + 8 en `models/` [incluye 2 generados] + 5 en `providers/`)
**Total líneas aprox:** 4,170 (raíz 2,651 + models 1,525 + providers 1,030)
**Fecha:** 2026-08-13
**Fuente:** Ingeniería inversa

---

## Impact Mapping

| Objetivo de Negocio | Actor | Impacto | Entregable |
|---------------------|-------|---------|------------|
| Comunidades colaborativas para promotores | Promotor / Agente | Crea grupos para su asociación/inmobiliaria; publica avisos; comparte propiedades con miembros | `PageMisGrupos`, `PageDetalleGrupo` (993 líneas, 5 sub-tabs) |
| Sistema de membresías con roles | Usuario | Invita a conocidos como miembros; acepta invitaciones | `PageInvitacionesGrupo` (352), `GruposInvitacionesNotifier` (280) |
| Comunicación grupal | Miembro | Chat del grupo con burbujas de mensaje/propiedad/lista — paralelo al chat 1:1 pero colectivo | `PageChatGrupo` (358) |
| Catálogo y descubrimiento | Usuario descubre | Busca grupos por categoría/temática y une | `PageDescubrirGrupos` (325) |
| Avisos y publicaciones internas | Admin / Miembros | Publica avisos internos del grupo (sólo admin crea) | `_TabAvisos`, `AvisosGrupoNotifier` (133) |

---

## User Story Mapping

```
Sección "Tu Cuenta > Grupos" de PrincipalSliversMenuInicial
   │
   ▼
GruposView (3 tabs: Mis Grupos / Descubrir / Invitaciones)
   │
   ├── PageMisGrupos
   │     └── tap → PageDetalleGrupo (4 tabs: Publicaciones / Miembros / Avisos / Chat)
   │           ├── _TabPublicaciones: PublicacionesGrupoNotifier
   │           ├── _TabMiembros (_InfoRow): GruposNotifier
   │           ├── _TabAvisos (_TarjetaAviso): AvisosGrupoNotifier
   │           └── CTA Chatear → PageChatGrupo
   │
   ├── PageDescubrirGrupos
   │     └── CTA "Unirse" → crea solicitud/invitación
   │
   └── PageInvitacionesGrupo
         └── Aceptar/Rechazar → GruposInvitacionesNotifier
```

---

## Especificación SDD / EARS

**Prefijo IDs:** `REQ-GPU-XXX`

| ID | Tipo EARS | Requerimiento | Evidencia | Estado |
|----|-----------|---------------|-----------|--------|
| REQ-GPU-001 | **Ubicuo** | El sistema expondrá modelos `Grupo` (34, Freezed con `MiembroGrupo`), `GrupoModel`+`MiembroGrupoModel` (111, json manual), `InvitacionGrupoModel` (69), `MensajeGrupoModel` (69), `PublicacionGrupoModel` (61), `AvisoGrupoModel` (52) para tipar grupos completos. | `models/grupo.dart`, `models/grupo_model.dart`, otros | En código |
| REQ-GPU-002 | **Ubicuo** | El sistema expondrá `GruposView` (ConsumerStatefulWidget, 101 líneas) con 3 tabs: Mis Grupos / Descubrir / Invitaciones. | `grupos_view.dart:1-101` | En código |
| REQ-GPU-003 | **Estado** | Mientras el usuario esté en `PageMisGrupos`, el sistema consumirá `GruposNotifier` (249) para listar grupos donde `currentUser ∈ miembros[]`. | `page_mis_grupos.dart:482`, `providers/grupos_notifier.dart` | En código |
| REQ-GPU-004 | **Evento** | Cuando el usuario toque un grupo, el sistema navegará a `PageDetalleGrupo` (993 líneas) con 4 sub-tabs: Publicaciones / Miembros / Avisos / Chat. | `page_detalle_grupo.dart:1-993` | En código |
| REQ-GPU-005 | **Evento** | Cuando el usuario en `_TabPublicaciones` vea las publicaciones del grupo, el sistema consumirá `PublicacionesGrupoNotifier` (168) que lista propiedades compartidas en el grupo. | `page_detalle_grupo.dart._TabPublicaciones`, `providers/publicaciones_grupo_provider.dart` | En código |
| REQ-GPU-006 | **Evento** | Cuando admin cree un aviso en `_TabAvisos`, `AvisosGrupoNotifier` (133) lo persistirá en `buscobien_avisos_grupo` con timestamp. | `page_detalle_grupo.dart._TabAvisos._TabAvisosState`, `providers/avisos_grupo_provider.dart` | En código |
| REQ-GPU-007 | **Evento** | Cuando el usuario visite `PageDescubrirGrupos`, el sistema listará grupos públicos y CTA "Unirse"; si el grupo requiere invitación, muestra "Solicitar unirse". | `page_descubrir_grupos.dart:325` | En código |
| REQ-GPU-008 | **Evento** | Cuando el admin invita a un conocido a un grupo, `GruposInvitacionesNotifier` (280) crea doc en `buscobien_invitaciones_grupos` con estado pendiente; receptor ve badge en tab Invitaciones. | `page_invitaciones_grupo.dart:352`, `providers/grupos_invitaciones_provider.dart` | En código |
| REQ-GPU-009 | **Estado** | Mientras el miembro esté en `PageChatGrupo` (358 líneas), el sistema consumirá `MensajesGrupoNotifier` (200) para listar mensajes paginados por `grupoId` y permitir texto + compartir propiedad/lista. | `page_chat_grupo.dart:358`, `providers/grupos_mensajes_provider.dart` | En código |
| REQ-GPU-010 | **Evento** | Cuando un miembro toque `_BurbujaPropiedad` / `_BurbujaLista` en `PageChatGrupo`, el sistema navegará a `PaginaDetalleWidget` (`08_pantallas/propiedades`) o `PageDetalleLista` (`03_listas`). | `page_chat_grupo.dart._BurbujaPropiedad, _BurbujaLista` | En código |
| REQ-GPU-011 | **No Deseado** | Si `_BurbujaPropiedad` / `_BurbujaLista` en grupo duplica los de conocidos, el sistema **comparte largaudad de código craving refactor** (deuda). | `page_chat_grupo.dart:(duplicados de page_chat_privado.dart)` | Deuda técnica |
| REQ-GPU-012 | **Complejo** | Mientras `PageChatGrupo` tenga sub-widget `ChatGrupoEmbebido`, el sistema podrá reusarlo en pantallas que necesiten chat embebido (ej. modulo de grupos en detalle). | `page_chat_grupo.dart.ChatGrupoEmbebido, _ChatGrupoEmbebidoState` | En código |

---

## Trazabilidad a Código

| Componente | Ruta | Líneas |
|------------|-----|--------|
| `GruposView` | `grupos_view.dart` | 101 |
| `PageMisGrupos`, `_PageMisGruposState`, `_GrupoCard` | `page_mis_grupos.dart` | 482 |
| `PageDescubrirGrupos`, `_GrupoDescubrirCard` | `page_descubrir_grupos.dart` | 325 |
| `PageDetalleGrupo` + 6 sub-widgets | `page_detalle_grupo.dart` | 993 |
| `PageInvitacionesGrupo` + 4 sub-widgets | `page_invitaciones_grupo.dart` | 352 |
| `PageChatGrupo` + 5 sub-widgets + `ChatGrupoEmbebido` | `page_chat_grupo.dart` | 358 |
| `Grupo` (Freezed), `MiembroGrupo` (Freezed) | `models/grupo.dart` | 34 |
| `GrupoModel`, `MiembroGrupoModel` | `models/grupo_model.dart` | 111 |
| `InvitacionGrupoModel` | `models/invitacion_grupo_model.dart` | 69 |
| `MensajeGrupoModel` | `models/mensaje_grupo_model.dart` | 69 |
| `PublicacionGrupoModel` | `models/publicacion_grupo_model.dart` | 61 |
| `AvisoGrupoModel` | `models/aviso_grupo_model.dart` | 52 |
| (generados) `grupo.freezed.dart`, `grupo.g.dart` | `models/` | 782 + 47 |
| `GruposNotifier` | `providers/grupos_notifier.dart` | 249 |
| `GruposInvitacionesNotifier` | `providers/grupos_invitaciones_provider.dart` | 280 |
| `MensajesGrupoNotifier` | `providers/grupos_mensajes_provider.dart` | 200 |
| `PublicacionesGrupoNotifier` | `providers/publicaciones_grupo_provider.dart` | 168 |
| `AvisosGrupoNotifier` | `providers/avisos_grupo_provider.dart` | 133 |

---

## Deuda Técnica

1. **Duplicación de burbujas (`_BurbujaPropiedad`/`_BurbujaLista`)** entre `page_chat_grupo.dart` y `page_chat_privado.dart` (conocidos) — refactor `60_global_widgets/burbuja_propiedad_lista.dart` reutilizable.
2. **2 modelos para Grupo**: `Grupo` (Freezed) y `GrupoModel` (json manual) — duplicidad de representación. Unificar a una sola.
3. **`PageDetalleGrupo` 993 líneas** con 6 sub-widgets anidados (`_TabPublicaciones`, `_TarjetaPublicacion`, `_TabMiembros`, `_TabAvisos`, `_TabAvisosState`, `_TarjetaAviso`, `_InfoRow`) — refactor a 4 widgets separados.
4. **Providers legacy** sin `@riverpod` annotation — Riverpod 3.x deprecó. Migración pendiente.
5. **Sin tests** de ningún archivo (6 pages + 8 models + 5 providers).
6. **Acoplamiento con `03_listas`** (`PublicacionesGrupoNotifier` comparte propiedades) y `08_pantallas/propiedades` (navegación desde burbujas) — esperado.
7. **Sub-feature `compra_espacios/` en tus_espacios** probablemente reusa `PublicacionesGrupoNotifier.Model` — verificar. Documentado en tus_espacios.
8. **`ChatGrupoEmbebido` widget embebible** en otras pantallas — patrón reutilizable bien diseñado, candidato a `60_global_widgets`.
