# Inventario de Elementos — Listas de Favoritos y Compartidas (03_listas)

**Directorio:** `lib\03_listas\`
**Total archivos `.dart` fuente:** 17 (15 en raíz + 2 en `models/`)
**Epic asociado:** [`02_Epics_EARS/03_listas.md`](../../02_Epics_EARS/03_vistas.md)/(`03_listas.md`)
**Features BDD:** [`03_Features_BDD/03_listas/listas_favoritos_compartir.feature`](../../03_Features_BDD/03_listas/listas_favoritos_compartir.feature) (7 escenarios)
**User Stories:** [`04_User_Stories/03_listas.md`](../../04_User_Stories/03_listas.md) (7 US)
**Fecha:** 2026-08-12
**Fuente:** Ingeniería inversa

---

## Tabla 1 — Resumen de componentes por rol funcional

| # | Componente | Archivo | Tipo | Rol funcional | US-LIST |
|---|-------------|---------|------|----------------|---------|
| 1 | `UserListsNotifier` | `provider_user_lists.dart` | Riverpod StateNotifier | CRUD listas propias | US-LIST-001, 002, 006 |
| 2 | `ClassListaPropiedadesProvider` | `provider_listas_propiedades.dart` | Riverpod Notifier | Relación lista↔propiedad | US-LIST-003, 006, 007 |
| 3 | `ListasCompartidasNotifier` | `provider_listas_compartidas.dart` | Riverpod StateNotifier | Compartir listas | US-LIST-001, 004 |
| 4 | `PropiedadesCompartidasConocidosNotifier` | `provider_propiedades_compartidas_conocidos.dart` | Riverpod StateNotifier | Compartir propiedad a conocidos | US-LIST-005 |
| 5 | `MeGustaNotifier` | `provider_me_gusta.dart` | Riverpod StateNotifier | Toggle Me Gusta + auto-Favoritas | US-LIST-006 |
| 6 | `ListaPropertyListModel` / `Listapropiedad` | `data_lista_propiedad.dart` | Modelo (json) | Documento relación lista-propiedad | US-LIST-003, 007 |
| 7 | `GetListaPropertyListModel` / `RowListaProperty` | `data_lista_propiedad_get.dart` | Modelo (json) | Vista CouchDB relaciones | US-LIST-003, 007 |
| 8 | `UserPropertyListModel` / `Lista` | `data_user_list_model.dart` | Modelo (json) | Documento lista de usuario | US-LIST-001, 002 |
| 9 | `GetUserPropertyListModel` / `RowGetUserPropertyList` / `Value` | `data_user_list_model_get.dart` | Modelo (json) | Vista listas de un usuario | US-LIST-001 |
| 10 | `ListaCompartidaModel` | `models/lista_compartida_model.dart` | Modelo (json) | Documento lista compartida | US-LIST-004 |
| 11 | `MeGustaModel` | `models/me_gusta_model.dart` | Modelo (json) | Documento me gusta | US-LIST-006 |
| 12 | `DialogSelectorListas` | `lista_select_lista_save_propiedad.dart` | StatefulWidget (Dialog) | Selector de listas (checkboxes) | US-LIST-003 |
| 13 | `PageCompartirConConocido` | `page_compartir_con_conocido.dart` | StatefulWidget | Compartir propiedad a conocidos (máx 5) | US-LIST-005 |
| 14 | `PageCompartirConGrupo` | `page_compartir_con_grupo.dart` | StatefulWidget | Compartir propiedad a grupos | US-LIST-005 |
| 15 | `PageDetalleListaCompartida` | `pagina_detalle_lista_compartida.dart` | StatefulWidget | Detalle lista recibida (read + copy) | US-LIST-007 |
| 16 | `PageDetalleLista` | `pagina_detalle_listas.dart` | StatefulWidget | Detalle lista propia (read) | US-LIST-007 |
| 17 | `PageMisListas` | `pagina_mis_listas.dart` | StatefulWidget | Hub central 3 tabs | US-LIST-001, 002 |

---

## Tabla 2 — Detalle por archivo (alcance estricto)

| # | Ruta relativa (desde `lib\03_listas\`) | Clases / Funciones | Líneas | Dependencias clave (import) | Estado | Comentario / Deuda técnica |
|---|----------------------------------------|--------------------|--------|------------------------------|--------|-----------------------------|
| 1 | `data_lista_propiedad.dart` | `ListaPropertyListModel`, `Listapropiedad` | 259 | `dart:convert` | ✓ ok | Documento CouchDB relación (listaId+propertyId). Definiciones repetidas (4x Listapropiedad) — el grep mostró ráfagas del parseo. Modelo no-Freezed (JSON manual) |
| 2 | `data_lista_propiedad_get.dart` | `GetListaPropertyListModel`, `RowListaProperty` | 223 | `dart:convert` | ✓ ok | Respuesta de vista CouchDB para relaciones lista-propiedad |
| 3 | `data_user_list_model.dart` | `UserPropertyListModel`, `Lista` | 54 | `dart:convert` | ✓ ok | Documento lista-de-usuario (corto). Las 2 clases (`Lista` interna vs `UserPropertyListModel`) |

# (tabla continúa)

| # | Ruta relativa | Clases / Funciones | Líneas | Dependencias clave | Estado | Comentario |
|---|---------------|--------------------|--------|---------------------|--------|--------------|
| 4 | `data_user_list_model_get.dart` | `GetUserPropertyListModel`, `RowGetUserPropertyList`, `Value` | 163 | `dart:convert` | ✓ ok | Vista listas por usuario (rows+value). parseo más complejo |
| 5 | `models/lista_compartida_model.dart` | `ListaCompartidaModel` | 61 | — | ✓ ok | doc lista compartida (listaOrigenId, usuarioOrigenId, usuarioDestinoId, timestamp, mensaje). Definición corta |
| 6 | `models/me_gusta_model.dart` | `MeGustaModel` | 43 | — | ✓ ok | doc me gusta (`_id=SHA1(userId+propertyId)`, anti-dup). Muy corto |
| 7 | `provider_user_lists.dart` | `UserListsNotifier` (`StateNotifier`) | 278 | `riverpod`, `dio`, `direccionip`, `data_user_list_model*`, `debugprint`, `40_security` | ✓ ok | CRUD listas de usuario. `crearLista(nombre)` construye SHA1 id. Optimistic local. Deuda: `listaFavoritasId` cache en state no se invalida tras cambio |
| 8 | `provider_listas_propiedades.dart` | `ClassListaPropiedadesProvider` | 347 | `riverpod`, `dio`, `direccionip`, `data_lista_propiedad*`, `debugprint` | ✓ ok | Relaciones lista↔propiedad. `addPropiedadALista`/`removePropiedadDeLista` con anti-duplicado. `propertiesDetailsProvider.family` (FutureProvider) hace bulk `$in` |
| 9 | `provider_listas_compartidas.dart` | `ListasCompartidasNotifier` | 342 | `riverpod`, `dio`, `direccionip`, `lista_compartida_model`, `mensajesChatProvider` | ✓ ok | `compartirLista(listaOrigenId, destinos[], mensaje)`. Batch no atómico (no usa `_bulk_docs`). `silent skip` si duplicado |
| 10 | `provider_propiedades_compartidas_conocidos.dart` | `PropiedadCompartidaKnownModel`, `PropiedadesCompartidasConocidosNotifier` | 166 | `riverpod`, `dio`, `direccionip`, `mensajesChatProvider` | ✓ ok | Comparte propiedad a conocidos (UUID id). Notifica chat `tipo:'propiedad'`. Sin anti-duplicado estricto |
| 11 | `provider_me_gusta.dart` | `MeGustaNotifier` | 276 | `riverpod`, `dio`, `direccionip`, `provider_user_lists`, `provider_listas_propiedades`, `me_gusta_model` | ⚠ deuda | `toggleMeGusta` con optimistic local + `_agregarMeGusta`/`_quitarMeGusta`. Auto-crea "Favoritas" la primera vez; PUT perfil usuario si falla deja inconsistencia (documentado en Epic). Sin rollback robusto |
| 12 | `lista_select_lista_save_propiedad.dart` | `DialogSelectorListas`, `_DialogSelectorListasState` | 492 | `material`, `riverpod`, `Symbols`, `provider_user_lists`, `provider_listas_propiedades` | ✓ ok | Selector checkboxes por lista, diff al confirmar. SnackBar con conteo. No transaccional (si red falla a mitad queda estado parcial) |
| 13 | `page_compartir_con_conocido.dart` | `PageCompartirConConocido`, `_PageCompartirConConocidoState` | 241 | `material`, `riverpod`, `Symbols`, `provider_propiedades_compartidas_conocidos`, `60_global_widgets` | ✓ ok | CheckboxListTile conocidos, máx 5 (`Set<String>` con lengthCheck). `if(!mounted) return` post await — cumple regla AGENTS.md |
| 14 | `page_compartir_con_grupo.dart` | `PageCompartirConGrupo`, `_PageCompartirConGrupoState` | 206 | `material`, `riverpod`, `Symbols`, `publicacionesGrupoProvider` (`08_pantallas/tu_cuenta/grupos`), `mensajesGrupoProvider` | ✓ ok | CheckboxListTile grupos. Acoplado con `08_pantallas/tu_cuenta/grupos` (dependencia transversal) |
| 15 | `pagina_detalle_lista_compartida.dart` | `PageDetalleListaCompartida`, `_PageDetalleListaCompartidaState` | 156 | `material`, `riverpod`, `Symbols`, `provider_listas_propiedades`, `provider_user_lists`, `future_builder_state_widgets` | ✓ ok | Detalle lista recibida. CTA "Guardar en mis listas" (copia propiedades a nueva lista propia) |
| 16 | `pagina_detalle_listas.dart` | `PageDetalleLista`, `_PageDetalleListaState` | 415 | `material`, `riverpod`, `Symbols`, `provider_listas_propiedades`, `future_builder_state_widgets`, `WrapModernCardPropiedades` (`60_global_widgets`) | ✓ ok | Detalle lista propia. Renderiza `WrapModernCardPropiedades` con fallback endpoints (`endpointsCaptura`/`endpointsPublicados`) |
| 17 | `pagina_mis_listas.dart` | `PageMisListas`, `_PageMisListasState` | 1222 | `material`, `riverpod`, `Symbols`, `Symbols.appTheme`, todos los providers de 03_listas, `app_routes` | ⚠ deuda | **1,222 líneas** — excede 2-3x tamaño razonable. Contiene creación/borrado inline además del hub. Refactor pendiente. Tabs: Propias/Recibidas/Enviadas. Dismissible para borrar. CTA Compartir/Ver-detalle/Editar |

---

## Notas críticas

- **`pagina_mis_listas.dart` (1,222 líneas)** — repositorio monolítico de UI + lógica. Refactor: extraer por tab a 3 widgets dedicados (`TabPropiasWidget`, `TabRecibidasWidget`, `TabEnviadasWidget`) y mover lógica de creación/borrado a `UserListsNotifier` (deuda priorizada).
- **Modelos JSON manuales** (no Freezed): los 6 modelos (`data_lista_propiedad*`, `data_user_list_model*`, `models/*.dart`) usan `dart:convert`+`Map<String,dynamic>` sin Freezed. Inconsistencia con 22_imagenes y 14_geolocalizacion que sí lo usan. Migración pendiente a Freezed para uniformidad y seguridad de tipos.
- **5 providers de tipo `StateNotifier`/`Notifier`** — sin `AsyncNotifier` formal de Riverpod 3.x (no compatible con la convención del AGENTS.md "Riverpod 3.x con `@riverpod`"). Deuda: migrar a `@riverpod` annotations + `build_runner` para tipado estricto.
- **`propertiesDetailsProvider.family`** (en `provider_listas_propiedades.dart`) usa Mango `$in` para bulk fetch N propiedades en 1 query — pero sin paginación (`limit + bookmark`). Riesgo para listas >50 propiedades: la UI podría freezarse esperando respuesta.
- **`provider_me_gusta.dart`** tiene flujo crítico de auto-creación de "Favoritas" con perfil PUT que puede dejar inconsistencia si falla (documentado en US-LIST-006).
- **`Compartir lista` (provider_listas_compartidas.dart)** no usa `_bulk_docs` CouchDB — hace N POSTs. Si 3/5 fallan, 2 quedan guardados. Deuda documentada.
- **Acoplamiento transversal:** `page_compartir_con_grupo.dart` + `page_compartir_con_conocido.dart` dependen de `publicacionesGrupoProvider`/`mensajesGrupoProvider`/`mensajesChatProvider` que viven en `08_pantallas/tu_cuenta/conocidos` y `08_pantallas/tu_cuenta/grupos`. Es dependencia cíclica potencial que hoy se resuelve con re-export / import directo.
- **`SHARED id` conventions:** US-LIST-002 (SHA1 anti-dup), US-LIST-006 (SHA1 anti-dup), US-LIST-005 (UUID sin anti-dup estricto). Heterogéneo — documentar por qué.
- **DBs CouchDB afectadas** (ver `06_Bases_de_Datos` en transversal): `buscobien_listas_usuario`, `buscobien_listas_propiedades`, `buscobien_listas_compartidas`, `buscobien_listas_compartidas_usuarios`, `buscobien_propiedades_compartidas_conocidos`, `buscobien_publicaciones_grupo`, `buscobien_megusta_propiedades`, `buscobien_usuarios`, `buscobien_propiedades_publicadas_*`, `buscobien_propiedades_publicados_*`, `buscobien_mensajes`, `buscobien_mensajes_grupos`.
- **Sin tests**: ninguna unit/widget test para los 6 modelos, 6 pantallas ni los 5 providers. Smoke test global no cubre la lógica de diffs, anti-duplicado, ni auto-creación Favoritas.
