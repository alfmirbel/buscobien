# Epic: Listas de Favoritos y Compartidas (03_listas)

**Directorio:** `lib\03_listas\`  
**Archivos:** 15 en raíz + 2 en `models/` + 1 en `providers/` = **18 archivos**  
**Fecha:** 2026-08-12  
**Fuente:** Ingeniería inversa

---

## Impact Mapping

| Objetivo de Negocio | Actor | Impacto | Entregable |
|---------------------|-------|---------|------------|
| Productividad: organización y colaboración | Usuario final | Crea listas propias, agrega/quita propiedades, comparte con contactos/grupos, ve recibidas/enviadas | Hub `PageMisListas` (3 tabs) + dialogs compartir |
| | Conocido/Grupo | Recibe propiedades/listas compartidas, ve detalle, chatea | `PageDetalleListaCompartida`, `PageCompartirConConocido/Grupo` |
| | Sistema | Persiste relaciones en CouchDB dedicadas por tipo compartición | 5 DBs: `buscobien_listas_propiedades`, `buscobien_listas_compartidas_usuarios`, `buscobien_propiedades_compartidas_conocidos`, `buscobien_grupos_publicaciones`, `buscobien_megusta_propiedades` |

---

## User Story Mapping

```
Usuario en Mi Cuenta → Listas (PageMisListas)
       │
       ▼
┌─────────────────────────────────────────────────────────────┐
│ TabBar: Propias | Recibidas | Enviadas                      │
│                                                              │
│ Propias:                                                     │
│ - Crear lista (dialog + SHA1 hash ID)                       │
│ - Ver detalle (PageDetalleLista: Dismissible borrar)        │
│ - Compartir lista (dialog → máx 5 conocidos/grupos)         │
│                                                              │
│ Recibidas/Enviadas:                                          │
│ - Filtran listasCompartidasProvider (origen/destino)        │
│ - Detalle compartida (PageDetalleListaCompartida)           │
└────────────────────────┬────────────────────────────────────┘
                         │
        ┌────────────────┼────────────────┬────────────────┐
        ▼                ▼                ▼                ▼
   Me Gusta         Compartir         Compartir       Detalle
   (toggle)         Propiedad         Lista           Compartida
   (Favoritas       (Conocido/Grupo)  (Conocido/      (props
    auto-creada)     → chat notif      Grupo)          bulk)
```

---

## Especificación SDD / EARS

**Prefijo IDs:** `REQ-LIST-XXX`

| ID | Tipo EARS | Requerimiento | Evidencia | Estado |
|----|-----------|---------------|-----------|--------|
| REQ-LIST-001 | **Ubicuo** | El sistema definirá modelos: `Lista` (listaId, userId, listName, type, timestamp), `Listapropiedad` (listapropiedadId, userId, listaId, propertyId, tipodeespacio, type, timestamp), `ListaCompartidaModel` (id, rev, listaOrigenId, listaNombre, usuarioOrigenId/Nombre, usuarioDestinoId/Nombre, timestamp), `MeGustaModel` (id, rev, usuarioId, propiedadId, timestamp). | `lib\03_listas\data_*.dart`, `models/*.dart` | En código |
| REQ-LIST-002 | **Ubicuo** | El sistema expondrá `PageMisListas` como hub central con TabBar 3 tabs: **Propias** (crear/borrar/ver/compartir), **Recibidas** (filtradas `listasCompartidasProvider` donde `usuarioDestinoId == currentUser`), **Enviadas** (donde `usuarioOrigenId == currentUser`). | `lib\03_listas\pagina_mis_listas.dart` | En código |
| REQ-LIST-003 | **Evento** | Cuando el usuario cree lista en tab Propias, el sistema generará `listaId = SHA1(userId + timestamp + random)`, guardará en `buscobien_usuarios_listas` y actualizará `UserListsNotifier`. | `provider_user_lists.dart:createList()` | En código |
| REQ-LIST-004 | **Evento** | Cuando el usuario agregue propiedad a lista (`DialogSelectorListas` → checkboxes), el sistema invocará `ClassListaPropiedadesProvider.addPropiedadALista()` → guarda en `buscobien_listas_propiedades` (relación N:M). | `lista_select_lista_save_propiedad.dart`, `provider_listas_propiedades.dart` | En código |
| REQ-LIST-005 | **Evento** | Cuando el usuario comparta **lista** con contactos (máx 5), el sistema copiará propiedades a `buscobien_listas_compartidas_usuarios` + creará registro en `buscobien_listas_compartidas_usuarios` + enviará notificación chat (`mensajesChatProvider.enviar(tipo:'lista')`). | `provider_listas_compartidas.dart:compartirLista()` | En código |
| REQ-LIST-006 | **Evento** | Cuando el usuario comparta **propiedad** con conocido/grupo, el sistema creará doc en `buscobien_propiedades_compartidas_conocidos` / `buscobien_grupos_publicaciones` + notificación chat. | `page_compartir_con_conocido.dart`, `page_compartir_con_grupo.dart` | En código |
| REQ-LIST-007 | **Evento** | Cuando el usuario haga **toggle Me Gusta** en propiedad, el sistema creará/borrará en `buscobien_megusta_propiedades`; si es primer "me gusta", auto-creará lista "Favoritas" y agregará propiedad (`_agregarPropiedadAFavoritas` anti-duplicado). | `provider_me_gusta.dart:toggleMeGusta()` | En código |
| REQ-LIST-008 | **Estado** | Mientras `PageDetalleLista` muestre propiedades, el sistema hará bulk fetch via `propertiesDetailsProvider` (FutureProvider.family con `$in` Mango query) y renderizará `WrapModernCardPropiedades` con fallback a endpoints alternativos. | `pagina_detalle_listas.dart`, `provider_user_lists.dart` | En código |
| REQ-LIST-009 | **No Deseado** | Si `compartirLista()` detecte duplicado (misma listaOrigenId + usuarioDestinoId), el sistema silenciosamente no creará duplicado (anti-duplicado en provider) — **sin feedback al usuario**. | `provider_listas_compartidas.dart:80-100` | Parcial |
| REQ-LIST-010 | **No Deseado** | Si `borrarListapropiedadPorId()` falle (network, _rev), el sistema propagará excepción sin rollback UI optimista. | `provider_listas_propiedades.dart` | Riesgo |
| REQ-LIST-011 | **Complejo** | Mientras el usuario esté en tab Recibidas/Enviadas, cuando `listasCompartidasProvider` actualice (nueva compartida), el sistema filtrará reactivamente y actualizará UI sin reload manual. | `pagina_mis_listas.dart:_tabRecibidas/_tabEnviadas` | En código |

---

## Trazabilidad a Código

La evidencia de cada requerimiento (archivo y líneas) está en la columna **Evidencia** de la tabla anterior. Archivos adicionales no citados en ella:

| Componente | Archivo | Función clave |
|------------|---------|---------------|
| `Lista` / `Listapropiedad` models | `data_user_list_model.dart`, `data_lista_propiedad.dart` | DTOs |
| `ListaCompartidaModel` / `MeGustaModel` | `models/lista_compartida_model.dart`, `models/me_gusta_model.dart` | Compartidos |
| `PageDetalleLista` / `PageDetalleListaCompartida` | `pagina_detalle_listas.dart`, `pagina_detalle_lista_compartida.dart` | Detalle |
| `PropiedadesCompartidasConocidosNotifier` | `provider_propiedades_compartidas_conocidos.dart` | Compartir props |

---

## Bases de Datos CouchDB Involucradas

Ver el inventario generado desde el código: [`bases_de_datos_en_codigo.md`](../../06_modelo_de_datos_y_bd/bases_de_datos_en_codigo.md) (listas: `buscobien_usuarios_listas`, `buscobien_listas_propiedades`, `buscobien_listas_compartidas_usuarios`, `buscobien_listas_prop_compartidas`; me gusta: `buscobien_megusta_propiedades`; compartir: `buscobien_propiedades_compartidas_conocidos`, `buscobien_grupos_publicaciones`).

## Notas de Arquitectura

- **7 DBs CouchDB** para listas/compartidos/me-gusta — separación física por caso de uso.
- **Anti-duplicado en providers**: `compartirLista` y `addPropiedadALista` verifican existencia antes de crear.
- **Bulk fetch con `$in`**: `propertiesDetailsProvider` usa Mango `$in` para traer N propiedades en 1 query.
- **Notificaciones integradas**: Compartir → `mensajesChatProvider.enviar()` / `mensajesGrupoProvider.enviar()` — acoplamiento a motor social.
- **SHA1 para IDs listas**: `sha1.convert(utf8.encode(userId + timestamp + random))` — colisiones teóricas no manejadas.