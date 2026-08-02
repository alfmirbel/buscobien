# Inventario maestro — `lib/08_pantallas`
**Fuente:** verificación directa de `/mnt/buscobien/lib/08_pantallas`  
**Fecha:** 2026-07-25  
**Total archivos Dart:** 72  
**Subdirectorios:** 9

---

## Subdirectorios y responsabilidad
| Subdirectorio | Archivos Dart | Responsabilidad |
|---|---|---|
| `08_pantallas/inicio` | 12 | Búsqueda/listado de propiedades, filtros, paginación, detalle(parcial), PDF(parcial), cards |
| `08_pantallas/perfil` | 1 | Perfil de usuario |
| `08_pantallas/propiedades` | 3 | Detalle de propiedad y exportación PDF |
| `08_pantallas/tu_cuenta` | 43 | CRUD propiedades, compra de espacios, grupos, sociales, conocidos |
| `08_pantallas/tu_cuenta/conocidos` | 11 | Invitaciones, contactos, chat privado |
| `08_pantallas/tu_cuenta/grupos` | 14 | Grupos, chat grupal, avisos, publicaciones, invitaciones |
| `08_pantallas/tu_cuenta/tus_espacios` | 9 | CRUD propiedad, compra, tipos condicionales |
| `08_pantallas/ubicacion` | 8 | Localidades, SEPOMEX, maestro localidades, búsqueda GMaps |
| `08_pantallas/widgets_comunes` | 1 | Widgets reutilizables |

---

## Archivos identificados por subdirectorio
- `inicio/`: `catalogo_otras_caracteristicas.dart`, `clase_busqueda_estado.dart`, `clase_busqueda_estado.g.dart`, `data_count_view_documentos.dart`, `data_espacios_casas.dart`, `data_espacios_casas_get.dart`, `data_get_valores_menus.dart`, `http_find_propiedades_10en10.dart`, `http_find_propiedades_10en10.g.dart`, `http_view_count_filter_propiedades.dart`, `http_view_count_filter_propiedades.g.dart`, `inicio_propiedades_providers.dart`, `inicio_propiedades_providers.g.dart`, `pagina_inicio_busca_espacios.dart`, `widget_wrap_modern_card.dart`
- `perfil/`: `pagina_perfil.dart`
- `propiedades/`: `data_find_propiedades.dart`, `pagina_detalle_propiedad.dart`, `pagina_detalle_propiedad_pdf.dart`
- `tu_cuenta/conocidos/`: `conocidos_view.dart`, `invitacion_model.dart`, `mensaje_model.dart`, `models/conocido.dart`, `models/conocido.freezed.dart`, `models/conocido.g.dart`, `page_chat_privado.dart`, `page_descubrir_usuarios.dart`, `page_invitaciones.dart`, `page_mis_contactos.dart`, `page_perfil_contacto.dart`, `provider_mensajes.dart`, `providers/conocidos_notifier.dart`, `social_providers.dart`
- `tu_cuenta/grupos/`: `grupos_view.dart`, `models/aviso_grupo_model.dart`, `models/grupo.dart`, `models/grupo.freezed.dart`, `models/grupo.g.dart`, `models/grupo_model.dart`, `models/invitacion_grupo_model.dart`, `models/mensaje_grupo_model.dart`, `models/publicacion_grupo_model.dart`, `page_chat_grupo.dart`, `page_descubrir_grupos.dart`, `page_detalle_grupo.dart`, `page_invitaciones_grupo.dart`, `page_mis_grupos.dart`, `providers/avisos_grupo_provider.dart`, `providers/grupos_invitaciones_provider.dart`, `providers/grupos_mensajes_provider.dart`, `providers/grupos_notifier.dart`, `providers/publicaciones_grupo_provider.dart`
- `tu_cuenta/tus_espacios/`: `compra_espacios/data_compra_espacios.dart`, `compra_espacios/data_compra_espacios_get.dart`, `compra_espacios/form_compra_espacios.dart`, `compra_espacios/provider_compra_espacios.dart`, `form_crea_ficha_captura_propiedad.dart`, `form_update_espacio_comprado.dart`, `http_publica_propiedad.dart`, `pagina_tus_espacios.dart`, `provider_espacios_casa_get.dart`, `tabla_tipopropiedad_vs_campos.dart`
- `ubicacion/`: `data_localidad_find.dart`, `data_sepomex_localidades.dart`, `data_sepomex_localidades.freezed.dart`, `data_sepomex_localidades.g.dart`, `data_sepomex_localidades_get_cp.dart`, `pagina_busca_localidades_gmaps.dart`, `pagina_principal_localidades.dart`, `provider_localidades_del_cp.dart`, `screen_maestro_localidades.dart`
- `widgets_comunes/`: `widget_letrero_tipo_transaccion.dart`

---

## Proveedores, modelos y páginas por subdirectorio
### `inicio`
- **Providers:** `inicio_propiedades_providers.dart`, `.g.dart`
- **Modelos:** `data_espacios_casas.dart`, `data_espacios_casas_get.dart`, `data_get_valores_menus.dart`, `clase_busqueda_estado.dart`
- **Páginas:** `pagina_inicio_busca_espacios.dart`
- **Widgets:** `widget_wrap_modern_card.dart`
- **HTTP:** `http_find_propiedades_10en10.dart`, `http_view_count_filter_propiedades.dart`

### `perfil`
- **Páginas:** `pagina_perfil.dart`

### `propiedades`
- **Páginas:** `pagina_detalle_propiedad.dart`, `pagina_detalle_propiedad_pdf.dart`
- **Modelos:** `data_find_propiedades.dart`

### `tu_cuenta/conocidos`
- **Providers:** `providers/conocidos_notifier.dart`, `providers/social_providers.dart`, `provider_mensajes.dart`
- **Modelos:** `invitacion_model.dart`, `mensaje_model.dart`, `models/conocido.freezed.dart`, `models/conocido.g.dart`
- **Páginas:** `conocidos_view.dart`, `page_chat_privado.dart`, `page_descubrir_usuarios.dart`, `page_invitaciones.dart`, `page_mis_contactos.dart`, `page_perfil_contacto.dart`

### `tu_cuenta/grupos`
- **Providers:** `providers/grupos_notifier.dart`, `providers/grupos_invitaciones_provider.dart`, `providers/grupos_mensajes_provider.dart`, `providers/publicaciones_grupo_provider.dart`, `providers/avisos_grupo_provider.dart`
- **Modelos:** `models/grupo.freezed.dart`, `models/grupo.g.dart`, `models/grupo_model.dart`, `models/aviso_grupo_model.dart`, `models/invitacion_grupo_model.dart`, `models/mensaje_grupo_model.dart`, `models/publicacion_grupo_model.dart`
- **Páginas:** `grupos_view.dart`, `page_chat_grupo.dart`, `page_descubrir_grupos.dart`, `page_detalle_grupo.dart`, `page_invitaciones_grupo.dart`, `page_mis_grupos.dart`

### `tu_cuenta/tus_espacios`
- **Providers:** `provider_espacios_casa_get.dart`, `compra_espacios/provider_compra_espacios.dart`
- **Modelos:** `compra_espacios/data_compra_espacios.dart`, `compra_espacios/data_compra_espacios_get.dart`
- **Páginas:** `pagina_tus_espacios.dart`, `form_crea_ficha_captura_propiedad.dart`, `form_update_espacio_comprado.dart`, `http_publica_propiedad.dart`, `tabla_tipopropiedad_vs_campos.dart`

### `ubicacion`
- **Providers:** `provider_localidades_del_cp.dart`
- **Modelos:** `data_localidad_find.dart`, `data_sepomex_localidades.dart`, `data_sepomex_localidades.freezed.dart`, `data_sepomex_localidades.g.dart`, `data_sepomex_localidades_get_cp.dart`
- **Páginas:** `pagina_busca_localidades_gmaps.dart`, `pagina_principal_localidades.dart`, `screen_maestro_localidades.dart`

### `widgets_comunes`
- **Widgets:** `widget_letrero_tipo_transaccion.dart`

---

## Rutas inferidas
- `inicio/pagina_inicio_busca_espacios.dart` → ruta de búsqueda principal
- `propiedades/pagina_detalle_propiedad.dart` → detalle
- `propiedades/pagina_detalle_propiedad_pdf.dart` → PDF
- `tu_cuenta/tus_espacios` → edición/compra desde Mi Cuenta
- `tu_cuenta/grupos/*` → rutas internas de Mi Cuenta
- `tu_cuenta/conocidos/*` → rutas internas de Mi Cuenta
- `ubicacion/screen_maestro_localidades.dart` → maestro
- `ubicacion/pagina_busca_localidades_gmaps.dart` → búsqueda GMaps

---

## APIs/External I/O
- CouchDB HTTP: `http_find_propiedades_10en10.dart`, `http_view_count_filter_propiedades.dart`, `http_publica_propiedad.dart`, `compra_espacios/*`, providers de grupos/conocidos
- Google Maps/geocoding: `pagina_busca_localidades_gmaps.dart`, `ubicacion/*`
- Almacenamiento local: storage en sesión y fotos

---

## Hallazgos y brechas
- Gran parte de la lógica social/grupos/conocidos está contenida en este directorio, pero el inventario consolidado actual solo referenciaba `tu_cuenta` genéricamente.
- Los archivos generados `.g.dart`, `.freezed.dart`, `.json` aumentan el conteo total; hay 72 Dart files pero no todos son páginas.
- `form_update_espacio_comprado.dart` es un archivo grande y de riesgo ya documentado.
- No existe un `routes_parameters.dart` local; todas las rutas dependen de `07_routes`.
- El inventario `00_inventario/` solo cubría `inicio`, `perfil`, `propiedades`, `tu_cuenta`, `ubicacion`, `widgets_comunes`; faltaba cobertura explícita de `conocidos`, `grupos`, `tus_espacios` y `compra_espacios`.

---

## Trazabilidad hacia EARS
| ID | Feature | Archivos clave en `08_pantallas` |
|---|---|---|
| REQ-06 | Búsqueda/Propiedades | `pagina_inicio_busca_espacios.dart`, `inicio_propiedades_providers.dart`, `data_espacios_casas_get.dart`, `http_find_propiedades_10en10.dart`, `http_view_count_filter_propiedades.dart`, `pagina_detalle_propiedad.dart`, `pagina_detalle_propiedad_pdf.dart` |
| REQ-07 | Mapas | (implementado en `14_geolocalizacion`) |
| REQ-08 | Localidades | `pagina_principal_localidades.dart`, `pagina_busca_localidades_gmaps.dart`, `provider_localidades_del_cp.dart`, `data_sepomex_localidades.dart`, `screen_maestro_localidades.dart` |
| REQ-09 | Listas/Compartir | (implementado en `03_listas`, no en `08_pantallas`) |
| REQ-10 | Grupos/Social | `grupos_view.dart`, `page_mis_grupos.dart`, `page_descubrir_grupos.dart`, `page_detalle_grupo.dart`, `page_invitaciones_grupo.dart`, `page_chat_grupo.dart`, providers y models de grupos |
| REQ-11 | Conocidos/Chat | `conocidos_view.dart`, `page_mis_contactos.dart`, `page_invitaciones.dart`, `page_descubrir_usuarios.dart`, `page_chat_privado.dart`, `page_perfil_contacto.dart`, providers y models conocidos |
| REQ-12 | Tus espacios/CRUD/Compra | `pagina_tus_espacios.dart`, `form_crea_ficha_captura_propiedad.dart`, `form_update_espacio_comprado.dart`, `http_publica_propiedad.dart`, `compra_espacios/*`, `tabla_tipopropiedad_vs_campos.dart` |
| REQ-13 | Imágenes/Fotos | (implementado en `22_imagenes`, referenciado parcialmente) |
| REQ-14 | Perfil/Prefs | `perfil/pagina_perfil.dart` |
