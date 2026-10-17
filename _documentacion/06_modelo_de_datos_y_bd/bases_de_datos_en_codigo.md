# Bases de datos CouchDB referenciadas en el código (`lib/`)

**Generado:** 2026-10-16 por [`generar_bases_de_datos_en_codigo.py`](generar_bases_de_datos_en_codigo.py) — no editar a mano.  
**Método:** búsqueda de cadenas `buscobien_*` y de rutas `$direccionip/<base>` en los `.dart` de `lib/`. Las bases construidas dinámicamente (concatenación) no se detectan.

| Indicador | Valor |
| :--- | ---: |
| Bases referenciadas en el código | 30 |
| …que están en el diccionario de esquemas | 15 |
| …que **faltan** en el diccionario | 15 |
| Del diccionario sin referencia en el código del cliente | 4 |

## Inventario

| Base | En diccionario | Archivos | Módulos (`lib/`) | Archivos de código |
| :--- | :---: | ---: | :--- | :--- |
| `buscobien_avatares` | **no** | 2 | `10_user_login`, `22_imagenes` | `10_user_login/avatar/provider_get_avatar.dart`, `22_imagenes/tus_espacios_fotos_propiedad/manejo_de_fotos/fotos_de_la_propiedad/pagina_agrega_multiples_fotos.dart` |
| `buscobien_casas_comprados_destacado` | sí | 1 | `40_security` | `40_security/urls_endpoints_espacios.dart` |
| `buscobien_casas_comprados_normal` | sí | 1 | `40_security` | `40_security/urls_endpoints_espacios.dart` |
| `buscobien_casas_comprados_oportunidad` | sí | 1 | `40_security` | `40_security/urls_endpoints_espacios.dart` |
| `buscobien_casas_comprados_remate` | sí | 1 | `40_security` | `40_security/urls_endpoints_espacios.dart` |
| `buscobien_casas_comprados_super` | sí | 1 | `40_security` | `40_security/urls_endpoints_espacios.dart` |
| `buscobien_compra_espacios` | **no** | 1 | `08_pantallas/tu_cuenta` | `08_pantallas/tu_cuenta/tus_espacios/compra_espacios/provider_compra_espacios.dart` |
| `buscobien_fotos_ordenadas` | **no** | 3 | `22_imagenes` | `22_imagenes/tus_espacios_fotos_propiedad/manejo_de_fotos/futures_y_providers/future_get_fotos_by_idpr_orden.dart`, `22_imagenes/tus_espacios_fotos_propiedad/manejo_de_fotos/lista_fotos_ordenadas/future_put_fotos_orden.dart`, `22_imagenes/tus_espacios_fotos_propiedad/manejo_de_fotos/lista_fotos_ordenadas/future_update_fotos_orden.dart` |
| `buscobien_grupos` | sí | 2 | `08_pantallas/tu_cuenta` | `08_pantallas/tu_cuenta/grupos/models/grupo_model.dart`, `08_pantallas/tu_cuenta/grupos/providers/grupos_notifier.dart` |
| `buscobien_grupos_avisos` | **no** | 1 | `08_pantallas/tu_cuenta` | `08_pantallas/tu_cuenta/grupos/providers/avisos_grupo_provider.dart` |
| `buscobien_grupos_invitaciones` | **no** | 1 | `08_pantallas/tu_cuenta` | `08_pantallas/tu_cuenta/grupos/providers/grupos_invitaciones_provider.dart` |
| `buscobien_grupos_mensajes` | **no** | 1 | `08_pantallas/tu_cuenta` | `08_pantallas/tu_cuenta/grupos/providers/grupos_mensajes_provider.dart` |
| `buscobien_grupos_publicaciones` | **no** | 2 | `01_splash_screen`, `08_pantallas/tu_cuenta` | `01_splash_screen/versiones.dart`, `08_pantallas/tu_cuenta/grupos/providers/publicaciones_grupo_provider.dart` |
| `buscobien_invitaciones` | sí | 1 | `08_pantallas/tu_cuenta` | `08_pantallas/tu_cuenta/conocidos/providers/conocidos_notifier.dart` |
| `buscobien_listas_compartidas_usuarios` | **no** | 2 | `01_splash_screen`, `03_listas` | `01_splash_screen/versiones.dart`, `03_listas/provider_listas_compartidas.dart` |
| `buscobien_listas_prop_compartidas` | **no** | 2 | `01_splash_screen`, `03_listas` | `01_splash_screen/versiones.dart`, `03_listas/provider_listas_compartidas.dart` |
| `buscobien_listas_propiedades` | sí | 3 | `03_listas` | `03_listas/provider_listas_compartidas.dart`, `03_listas/provider_listas_propiedades.dart`, `03_listas/provider_me_gusta.dart` |
| `buscobien_megusta_propiedades` | **no** | 2 | `01_splash_screen`, `03_listas` | `01_splash_screen/versiones.dart`, `03_listas/provider_me_gusta.dart` |
| `buscobien_mensajes` | sí | 1 | `08_pantallas/tu_cuenta` | `08_pantallas/tu_cuenta/conocidos/provider_mensajes.dart` |
| `buscobien_propiedades_casas_fotos` | **no** | 2 | `22_imagenes` | `22_imagenes/tus_espacios_fotos_propiedad/manejo_de_fotos/futures_y_providers/future_recupera_ids_fotos_propiedad.dart`, `22_imagenes/tus_espacios_fotos_propiedad/manejo_de_fotos/futures_y_providers/http_funciones_gestion_foto.dart` |
| `buscobien_publicados_destacado` | sí | 1 | `40_security` | `40_security/urls_endpoints_espacios.dart` |
| `buscobien_publicados_normal` | sí | 1 | `40_security` | `40_security/urls_endpoints_espacios.dart` |
| `buscobien_publicados_oportunidad` | sí | 1 | `40_security` | `40_security/urls_endpoints_espacios.dart` |
| `buscobien_publicados_remate` | sí | 1 | `40_security` | `40_security/urls_endpoints_espacios.dart` |
| `buscobien_publicados_super` | sí | 1 | `40_security` | `40_security/urls_endpoints_espacios.dart` |
| `buscobien_user_localidad` | **no** | 1 | `12_localidades_user` | `12_localidades_user/localidades_repository.dart` |
| `buscobien_usuarios` | sí | 3 | `08_pantallas/tu_cuenta`, `10_user_login` | `08_pantallas/tu_cuenta/conocidos/social_providers.dart`, `08_pantallas/tu_cuenta/grupos/providers/grupos_invitaciones_provider.dart`, `10_user_login/usuario_login/session_repository.dart` |
| `buscobien_usuarios_listas` | **no** | 1 | `03_listas` | `03_listas/provider_user_lists.dart` |
| `buscobien_usuarios_promotores` | **no** | 3 | `08_pantallas/tu_cuenta`, `10_user_login` | `08_pantallas/tu_cuenta/conocidos/social_providers.dart`, `08_pantallas/tu_cuenta/grupos/providers/grupos_invitaciones_provider.dart`, `10_user_login/usuario_login/session_repository.dart` |
| `codigospostales` | **no** | 1 | `12_localidades_user` | `12_localidades_user/localidades_repository.dart` |

## Del diccionario, sin referencia en el cliente

Pueden existir en el servidor o usarse solo desde el backend; confirmar en CouchDB antes de darlas por vigentes.

- `buscobien_auditoria`
- `buscobien_configuracion`
- `buscobien_parametros`
- `buscobien_propiedades`
