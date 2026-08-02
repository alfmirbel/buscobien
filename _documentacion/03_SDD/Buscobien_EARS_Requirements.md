# Buscobien — Documento de Requerimientos EARS
**Fecha:** 2026-07-24  
**Fuente:** Ingeniería inversa de `/mnt/buscobien/lib` (solo lectura)  
**Formato:** EARS — Easy Approach to Requirements Syntax  
**Alcance:** Requerimientos funcionales y no funcionales derivados del código actual; no incluye especulación de producto.

---

## 1. Splash / Boot
- Directorio: `lib/01_splash_screen`
- Archivos: `splash_page.dart`, `glass_objects.dart`, `versiones.dart`

| ID | Requerimiento | Evidencia | Estado |
|-----|---------------|-----------|--------|
| REQ-01.001 | El sistema mostrará una pantalla de splash en arranque en frío hasta que se cumplan condiciones de navegación inicial. | `SplashPage` redirige a `PrincipalSliversMenuInicial` tras checar conexión y tiempo mínimo. | En código |
| REQ-01.002 | El sistema verificará conectividad antes de rutear al shell principal usando el proveedor de conectividad existente. | Uso de `checaConeccionesProvider` en splash. | En código |
| REQ-01.003 | El sistema navegará al shell principal cuando conectividad y duración mínima de splash se cumplan. | Transición condicionada por `_isNavigating` y `_minDurationPassed`. | En código |
| REQ-01.004 | El sistema navegará a la pantalla sin conexión cuando el chequeo de red indique indisponibilidad. | Ruta `AppRoutes.sinconeccion` como fallback. | En código |
| REQ-01.005 | El sistema mostrará placeholders visuales (logo, loader, aviso de demo) durante la inicialización. | Constantes visuales y textos en `versiones.dart`. | En código |
| REQ-01.006 | El sistema no bloqueará el splash de forma indefinida; inicializaciones pesadas se diferirán al shell principal. | Inicialización de ubicación comentada/pospuesta a `PrincipalSliversMenuInicial`. | Parcial |

---

## 2. Home / Navegación global
- Directorio: `lib/01_home`
- Archivos: `home_state.dart`, `home_navigation_provider.dart`, `home_state.freezed.dart`, `home_navigation_provider.g.dart`

| ID | Requerimiento | Evidencia | Estado |
|-----|---------------|-----------|--------|
| REQ-02.001 | El sistema mantendrá un estado global de navegación principal por tabs/secciones. | `HomeState` con índices por sección. | En código |
| REQ-02.002 | El sistema expondrá setters para las secciones: Inicio, Principal, Nivel de Gobierno, Tipo Espacio, Tipo Transacción, Mi Cuenta, Mi Cuenta Usuario. | Métodos `actualizarInicial`, `actualizarPrincipal`, etc. | En código |
| REQ-02.003 | El sistema consumirá este estado global en el shell principal para decidir la sección renderizada. | `PrincipalSliversMenuInicial` consulta `homeNavigationProvider`. | En código |
| REQ-02.004 | El sistema inicializará el estado de navegación con valores por defecto y versión 0. | `HomeState` inicial con ceros y versión 0. | En código |

---

## 3. Pantalla principal / Landing y Sliver
- Directorio: `lib/02_principal_screen`
- Archivos: `principal_00_inicio.dart`, `principal_02_page_appbar.dart`, `principal_03_page_drawer.dart`, `principal_sliver_screen_menus_inicio.dart`

| ID | Requerimiento | Evidencia | Estado |
|-----|---------------|-----------|--------|
| REQ-03.001 | El sistema renderizará un shell común con AppBar y Drawer en las secciones principales. | `PrincipalSliversMenuInicial` con AppBar/Drawer compartidos. | En código |
| REQ-03.002 | El sistema renderizará menús sliver asociados a cada sección de landing. | Slivers condicionales por `homeNavigationProvider`. | En código |
| REQ-03.003 | El sistema presentará placeholders para items del Drawer no implementados, sin navegación expuesta. | Items “Próximamente” comentados en Drawer. | Parcial |
| REQ-03.004 | El sistema mostrará una vista sin sesión cuando no exista sesión en el índice inicial. | Vista `_vistaSinUsuario` con llamado a login. | En código |
| REQ-03.005 | El sistema disparará el flujo de login desde la vista sin sesión. | Botón/link a login desde `_vistaSinUsuario`. | En código |

---

## 4. Rutas y Deep Links
- Directorio: `lib/07_routes`
- Archivos: `app_routes.dart`, `deep_link_handler.dart`, `pagina_route_error.dart`, `routes_parameters.dart`

| ID | Requerimiento | Evidencia | Estado |
|-----|---------------|-----------|--------|
| REQ-04.001 | El sistema definirá constantes de ruta para todas las pantallas activas. | `AppRoutes` centraliza rutas. | En código |
| REQ-04.002 | El sistema ruteará desde splash a principal y desde sin-conexión a pantalla de conectividad. | Rutas declaradas en `routeGenerate`. | En código |
| REQ-04.003 | El sistema soportará un flujo de recuperación de contraseña vía deep link con token y perfil. | `deep_link_handler.dart` -> `/cambioPassword` con `token` y `perfil`. | En código |
| REQ-04.004 | El sistema declarará manejo de error/fallback para argumentos de deep link inválidos. | `pagina_route_error.dart`. | En código |
| REQ-04.005 | El sistema no ocultará silenciosamente rutas undefined; deberá mostrar fallback visible. | `routeGenerate` retorna `null` en default. | Riesgo |

---

## 5. Seguridad / Auth / Session
- Directorios: `lib/10_user_login`, `lib/40_security`
- Archivos clave: `provider_session.dart`, `session_storage.dart`, `session_repository.dart`, `login_01_login_page.dart`, `login_03_form_register_user.dart`, `page_cambio_password.dart`, `password_recovery_repository.dart`, `avatar/provider_get_avatar.dart`, `generate_hash.dart`, `generate_reset_token.dart`, `direccionip.dart`, `encriptar.dart`

| ID | Requerimiento | Evidencia | Estado |
|-----|---------------|-----------|--------|
| REQ-05.001 | El sistema autenticará usuarios mediante credenciales almacenadas en formulario Basic Auth. | Variables globales `username/password`; header Basic en `session_repository.dart`. | En código |
| REQ-05.002 | El sistema persistirá datos de sesión mediante una abstracción de almacenamiento local que seleccione secure storage en móvil y shared preferences en web. | `session_storage.dart` implementa `Mobile`/`Web`. | En código |
| REQ-05.003 | El sistema persistirá el hash de la contraseña en sesión; no almacenará contraseña en texto plano. | `userPassHash` presente en flujos de sesión. | Parcial |
| REQ-05.004 | El sistema permitirá el registro de nuevos usuarios en la base de datos de usuarios. | Pantalla `RegisterScreenUsers`. | En código |
| REQ-05.005 | El sistema soportará recuperación de contraseña vía endpoint externo de correo. | `password_recovery_repository.dart` -> `http://citigov.cloud:3001/api/enviar-correo-recuperacion`. | En código |
| REQ-05.006 | El sistema procesará el deep link de recuperación con verificación de token en la pantalla de cambio de contraseña. | Ruta `/cambioPassword` con token y perfil. | En código |
| REQ-05.007 | El sistema expondrá flujos de recuperación, subida, actualización y almacenamiento de avatar asociado al usuario en sesión. | `classUserAvatarProvider` con métodos CRUD de avatar. | En código |
| REQ-05.008 | El sistema limitará los backends de autenticación a tres bases de datos: usuarios generales, promotores y propietarios. | Referencias a `buscobien_usuarios`, `buscobien_usuarios_promotores`. | En código |
| REQ-05.009 | El sistema no expondrá credenciales backend en logs o salidas diagnósticas de UI. | Uso de globales `username/password` sin sanitizar en algunos flujos. | Riesgo |

---

## 6. Búsqueda / Listado / Detalle de propiedades
- Directorios: `lib/08_pantallas/inicio`, `lib/08_pantallas/propiedades`, `lib/08_pantallas/widgets_comunes`
- Archivos clave: `pagina_inicio_busca_espacios.dart`, `inicio_propiedades_providers.dart`, `data_espacios_casas.dart`, `http_find_propiedades_10en10.dart`, `http_view_count_filter_propiedades.dart`, `clase_busqueda_estado.dart`, `widget_wrap_modern_card.dart`, `propiedades/pagina_detalle_propiedad.dart`, `propiedades/pagina_detalle_propiedad_pdf.dart`

| ID | Requerimiento | Evidencia | Estado |
|-----|---------------|-----------|--------|
| REQ-06.001 | El sistema presentará una página de búsqueda de propiedades desde el shell principal. | `PaginaInicioBuscaEspacios`. | En código |
| REQ-06.002 | El sistema soportará filtros por nivel de gobierno, tipo propiedad, tipo espacio, tipo transacción y un dropdown adicional. | Providers `menu*Provider` + `currentQueryProvider`. | En código |
| REQ-06.003 | El sistema ensamblará un objeto de consulta único con los valores de filtro seleccionados. | `VariablesViewQuery`. | En código |
| REQ-06.004 | El sistema obtendrá resultados paginados desde el backend usando controles de paginación server-side. | `findPropiedadesEstadosde10en10Provider` y `paramSkip`. | En código |
| REQ-06.005 | El sistema mostrará metadatos de conteo total para soportar UI de paginación. | `viewCountFilterPropiedadesProvider`. | En código |
| REQ-06.006 | El sistema presentará una página de detalle de propiedad con información completa. | `PaginaDetallePropiedad`. | En código |
| REQ-06.007 | El sistema ofrecerá una ruta de exportación PDF desde el detalle de propiedad. | `PaginaDetallePropiedadPdf`. | En código |
| REQ-06.008 | El sistema manejará estados de carga, vacío y error explícitos en flujos de búsqueda y listado. | `_buildSinPropiedades`, estados `waiting/error`. | En código |
| REQ-06.009 | El sistema deshabilitará interacciones de búsqueda cuando esté offline o no haya filtros seleccionados. | `checaConeccionesProvider` + validaciones de filtros. | Parcial |

---

## 7. Mapas
- Directorio: `lib/14_geolocalizacion`
- Archivos: `google_map_mapa_propiedades.dart`, `google_map_place_data.dart`, `google_map_place_data.json`, `app_keys.dart`, `provider_actual_place.dart`

| ID | Requerimiento | Evidencia | Estado |
|-----|---------------|-----------|--------|
| REQ-07.001 | El sistema renderizará un mapa de propiedades usando Google Maps Flutter. | Página `/mapapropiedades`. | En código |
| REQ-07.002 | El sistema geocodificará direcciones construidas a partir de campos de ubicación locales. | Geocoding sobre `addressQuery` construido localmente. | En código |
| REQ-07.003 | El sistema hará zoom a la ubicación de la propiedad, con fallback a municipio si la geocodificación precisa falla. | Ajuste de bounds y fallback por municipio. | En código |
| REQ-07.004 | El sistema annotará marcadores con precio o metadata relevante de la propiedad. | Marcadores personalizados con precio. | En código |
| REQ-07.005 | El sistema se comportará de forma segura en web al requerir ajuste de bounds del mapa. | Fallback específico documentado para web. | En código |

---

## 8. Localidades / Ubicación
- Directorios: `lib/08_pantallas/ubicacion`, `lib/12_localidades_user`
- Archivos clave: `pagina_principal_localidades.dart`, `pagina_busca_localidades_gmaps.dart`, `provider_localidades_del_cp.dart`, `data_sepomex_localidades.dart`, `data_user_localidad.dart`, `provider_get_localidades_usuario.dart`, `localidades_repository.dart`

| ID | Requerimiento | Evidencia | Estado |
|-----|---------------|-----------|--------|
| REQ-08.001 | El sistema permitirá búsqueda de localidades por código postal, estado, municipio y asentamiento. | `SepomexLocalidades`, `data_sepomex_localidades_get_cp.dart`. | En código |
| REQ-08.002 | El sistema permitirá seleccionar localidades en el contexto del perfil de usuario. | `userLocalidadesProvider`. | En código |
| REQ-08.003 | El sistema persistirá localidades seleccionadas por el usuario. | Integración con `sessionProvider`. | En código |
| REQ-08.004 | El sistema expondrá páginas de maestro de localidades y búsqueda asistida por GMaps. | `/localidades`, `/listalocalidades`, `PaginaBuscaLocalidadGMaps`. | En código |
| REQ-08.005 | El sistema aplicará localidades de usuario como filtros en flujos de búsqueda de propiedades cuando esté configurado. | Sincronización con `sessionProvider`. | Parcial |
| REQ-08.006 | El sistema evitará fallos por índices CouchDB inválidos o ausentes en consultas de localidad. | Validaciones insuficientes detectadas. | Riesgo |

---

## 9. Listas / Favoritos / Compartir
- Directorio: `lib/03_listas`
- Archivos clave: `pagina_mis_listas.dart`, `provider_user_lists.dart`, `provider_listas_propiedades.dart`, `provider_listas_compartidas.dart`, `provider_me_gusta.dart`, `models/lista_compartida_model.dart`, `models/me_gusta_model.dart`, `page_compartir_con_conocido.dart`, `page_compartir_con_grupo.dart`

| ID | Requerimiento | Evidencia | Estado |
|-----|---------------|-----------|--------|
| REQ-09.001 | El sistema permitirá crear, consultar y eliminar listas de propiedades del usuario. | `userListsProvider`: `createList`, `fetchUserLists`, `deleteLista`. | En código |
| REQ-09.002 | El sistema permitirá agregar propiedades a listas existentes desde flujos de navegación. | `addPropiedadALista`, `_agregarPropiedadAFavoritas`. | En código |
| REQ-09.003 | El sistema permitirá eliminar propiedades de listas, incluyendo borrado lógico. | `borrarPropiedadDeLista`, `borrarListapropiedadPorId`. | En código |
| REQ-09.004 | El sistema indicará explícitamente una lista “Favoritas” cuando el usuario marque una propiedad como me gusta. | Creación implícita de favoritas en `_agregarPropiedadAFavoritas`. | Parcial |
| REQ-09.005 | El sistema limitará las invitaciones de compartir lista a un número máximo definido por envío. | Límite duro detectado de 5 contactos. | En código |
| REQ-09.006 | El sistema copiará propiedades a una base de datos separada cuando se comparta una lista. | `listasCompartidasProvider` apunta a DB separada. | En código |
| REQ-09.007 | El sistema notificará al destinatario por chat o invitaciones cuando se comparta una lista. | Flujo de compartir con notificación implícita. | Parcial |
| REQ-09.008 | El sistema permitirá aceptar o rechazar invitaciones a listas compartidas. | Estados `InvitacionEstado`. | En código |
| REQ-09.009 | El sistema limitará listas muy grandes para evitar saturación de UI. | Placeholders “No hay…” sin paginación explícita clara. | Riesgo |

---

## 10. Grupos / Social
- Directorio: `lib/08_pantallas/tu_cuenta/grupos`
- Archivos clave: `grupos_view.dart`, `page_mis_grupos.dart`, `page_descubrir_grupos.dart`, `page_detalle_grupo.dart`, `page_chat_grupo.dart`, `page_invitaciones_grupo.dart`, `models/grupo.freezed.dart`, `providers/grupos_notifier.dart`, `providers/mensajes_grupo_provider.dart`, `providers/publicaciones_grupo_provider.dart`, `providers/avisos_grupo_provider.dart`

| ID | Requerimiento | Evidencia | Estado |
|-----|---------------|-----------|--------|
| REQ-10.001 | El sistema permitirá crear grupos y asignará el primer miembro como administrador. | `crearGrupo` asigna admin sin validaciones adicionales. | En código |
| REQ-10.002 | El sistema permitirá invitar usuarios a grupos y responder invitaciones. | `enviarInvitacion`, `responderInvitacion`. | En código |
| REQ-10.003 | El sistema proveerá descubrimiento de grupos públicos. | `gruposPublicosProvider`. | En código |
| REQ-10.004 | El sistema proveerá chat grupal mediante suscripción continua a cambios. | `_changes?feed=continuous` en mensajes. | En código |
| REQ-10.005 | El sistema permitirá publicar properties/avisos dentro del grupo, con límite de caracteres para avisos. | `publicarAviso`, `publicarPropiedad`; límite 250 chars. | En código |
| REQ-10.006 | El sistema soportará paginación de publicaciones de grupo. | `cargarMas` en `publicacionesGrupoProvider`. | En código |
| REQ-10.007 | El sistema cerrará suscripciones de cambios al salir o cerrar el chat. | `onDispose` referenciado en provider de mensajes. | Parcial |
| REQ-10.008 | El sistema protegerá actualizaciones concurrentes de miembros controlando revisiones. | Riesgo de colisiones `_rev` en `agregarMiembro`. | Riesgo |

---

## 11. Conocidos / Chat privado
- Directorio: `lib/08_pantallas/tu_cuenta/conocidos`
- Archivos clave: `conocidos_view.dart`, `page_mis_contactos.dart`, `page_invitaciones.dart`, `page_descubrir_usuarios.dart`, `page_chat_privado.dart`, `providers/conocidos_notifier.dart`, `providers/social_providers.dart`, `provider_mensajes.dart`

| ID | Requerimiento | Evidencia | Estado |
|-----|---------------|-----------|--------|
| REQ-11.001 | El sistema permitirá enviar invitaciones de contacto por identificador de usuario. | `enviarInvitacion`. | En código |
| REQ-11.002 | El sistema listará invitaciones recibidas y enviadas con acciones aceptar/rechazar. | Vistas de invitaciones. | En código |
| REQ-11.003 | El sistema listará contactos aceptados y permitirá acceso a perfil de contacto. | `conocidosAceptadosProvider`, `page_perfil_contacto.dart`. | En código |
| REQ-11.004 | El sistema proveerá chat privado entre contactos aceptados. | `page_chat_privado.dart`. | En código |
| REQ-11.005 | El sistema impedirá abrir chat privado desde invitaciones no aceptadas. | Restricción por estado de relación. | Parcial |

---

## 12. Tus espacios / CRUD propiedades / Compra
- Directorios: `lib/08_pantallas/tu_cuenta/tus_espacios`, `lib/08_pantallas/tu_cuenta/tus_espacios/compra_espacios`
- Archivos clave: `pagina_tus_espacios.dart`, `form_crea_ficha_captura_propiedad.dart`, `form_update_espacio_comprado.dart`, `http_publica_propiedad.dart`, `compra_espacios/form_compra_espacios.dart`, `compra_espacios/provider_compra_espacios.dart`, `tabla_tipopropiedad_vs_campos.dart`

| ID | Requerimiento | Evidencia | Estado |
|-----|---------------|-----------|--------|
| REQ-12.001 | El sistema listará propiedades publicadas o propiedad del usuario autenticado. | `espaciosCasaConListaFotosGetProvider`. | En código |
| REQ-12.002 | El sistema permitirá crear y editar propiedades con campos condicionales por tipo de inmueble. | `form_update_espacio_comprado.dart`, `tabla_tipopropiedad_vs_campos.dart`. | En código |
| REQ-12.003 | El sistema permitirá publicar, despublicar y eliminar propiedades. | Lógica en formularios y `http_publica_propiedad.dart`. | Parcial |
| REQ-12.004 | El sistema soportará flujo de compra de espacios con selección de medio de pago y cálculo de totales. | `compraDeEspaciosProvider` y formulario de compra. | En código |
| REQ-12.005 | El sistema persistirá metadata de compra en la base de datos de propiedades. | `writeCompraEspaciosToCouchDB`. | En código |
| REQ-12.006 | El sistema mostrará u ocultará campos condicionales según el tipo de propiedad seleccionado. | Arrays/dicts condicionales en `tabla_tipopropiedad_vs_campos.dart`. | En código |

---

## 13. Imágenes / Fotos
- Directorio: `lib/22_imagenes`
- Archivos clave: `variables_imagenes.dart`, `inicio_fotos_usuario/pagina_carousel_fotos_usuario.dart`, `inicio_fotos_usuario/pagina_carousel_fotos_usuario_mini.dart`, `tus_espacios_fotos_propiedad/manejo_de_fotos/funciones_compress_image.dart`, `http_funciones_gestion_foto.dart`, `provider_get_fotos_ids_user_propiedad.dart`, `provider_get_lista_fotos_ordenadas.dart`, `image_file_structure.dart`

| ID | Requerimiento | Evidencia | Estado |
|-----|---------------|-----------|--------|
| REQ-13.001 | El sistema permitirá agregar múltiples fotos a una propiedad. | `AgregaMultiplesFotos`. | En código |
| REQ-13.002 | El sistema comprimirá imágenes antes de la subida usando procesamiento local. | `funciones_compress_image.dart`. | En código |
| REQ-13.003 | El sistema preservará el orden explícito de fotos de propiedad. | `FotosOrden`, `DataFotosOrdenadas`. | En código |
| REQ-13.004 | El sistema recuperará listas ordenadas de fotos por identificador de propiedad y usuario. | `provider_get_lista_fotos_ordenadas.dart`. | En código |
| REQ-13.005 | El sistema almacenará fotos como adjuntos de CouchDB asociados a documentos de propiedad. | `http_funciones_gestion_foto.dart`. | En código |
| REQ-13.006 | El sistema mostrará fotos de usuario y propiedad en páginas dedicadas con paginación/miniaturas. | Rutas `/fotospropiedad`, `/fotospropiedadpaginada`, `/fotospropiedadminiaturas`. | En código |
| REQ-13.007 | El sistema proveerá gestión de avatar: selección, subida, actualización y recuperación. | `provider_get_avatar.dart`, `manejo_imagenes_avatar.dart`. | En código |
| REQ-13.008 | El sistema degradará de forma controlada cuando falte metadata o adjuntos de foto. | Placeholders de carga y vacío en carouseles. | Parcial |

---

## 14. Perfil / Preferencias
- Directorios: `lib/08_pantallas/perfil`, `lib/04_provider`, `lib/10_user_login/avatar`
- Archivos clave: `perfil/pagina_perfil.dart`, `provider/pagina_colores.dart`, `provider_preferencias.dart`, `avatar/manejo_imagenes_avatar.dart`

| ID | Requerimiento | Evidencia | Estado |
|-----|---------------|-----------|--------|
| REQ-14.001 | El sistema mostrará el perfil del usuario autenticado desde datos de sesión. | `sessionProvider.userData` alimenta perfil. | En código |
| REQ-14.002 | El sistema permitirá editar campos del perfil respaldados por documentos de usuario. | Pantalla de perfil con edición condicionada a sesión. | En código |
| REQ-14.003 | El sistema proveerá gestión de avatar desde el flujo de perfil. | `page_perfil.dart` con acceso a avatar. | En código |
| REQ-14.004 | El sistema expondrá preferencias de color/tema desde un proveedor centralizado. | `provider_preferencias.dart`, `pagina_colores.dart`. | En código |
| REQ-14.005 | El sistema impedirá renderizado de vistas dependientes de sesión cuando la sesión no exista. | `_buildNoUserView` y redirecciones a login. | Parcial |

---

## 15. Conectividad / OS / Utilidades
- Directorios: `lib/41_connectivity`, `lib/42_sistema_operativo`, `lib/40_security`
- Archivos clave: `connectivitycheck_provider.dart`, `pagina_sin_coneccion.dart`, `detecta_os.dart`, `generate_hash.dart`, `generate_reset_token.dart`, `direccionip.dart`, `encriptar.dart`, `couchdb_errors.dart`

| ID | Requerimiento | Evidencia | Estado |
|-----|---------------|-----------|--------|
| REQ-15.001 | El sistema monitoreará el estado de red y expondrá conectividad a la shell UI. | `checaConeccionesProvider`. | En código |
| REQ-15.002 | El sistema renderizará una pantalla dedicada sin conexión en escenarios offline. | `/sinconeccion`. | En código |
| REQ-15.003 | El sistema detectará la familia de sistema operativo para comportamientos específicos por plataforma. | `detecta_os.dart`. | En código |
| REQ-15.004 | El sistema expondrá endpoints URL centralizados para operaciones orientadas a propiedades. | `urls_endpoints_espacios.dart`. | En código |
| REQ-15.005 | El sistema mapeará respuestas de error de CouchDB a clasificaciones orientadas al usuario. | `couchdb_errors.dart`. | En código |
| REQ-15.006 | El sistema permitirá reiniciar estado de conectividad cacheado al reconectar. | `checaConeccionesProvider` con estado reactivo. | Parcial |

---

## 16. Widgets globales / Utilidades
- Directorio: `lib/60_global_widgets`
- Archivos clave: `dialogbox_mensaje_general.dart`, `future_builder_state_widgets.dart`, `bottom_fijo.dart`, `genera_cantidad_monetaria.dart`, `derechos_reservados.dart`

| ID | Requerimiento | Evidencia | Estado |
|-----|---------------|-----------|--------|
| REQ-16.001 | El sistema proveerá un componente de diálogo genérico para confirmaciones y mensajes. | `dialogbox_mensaje_general.dart`. | En código |
| REQ-16.002 | El sistema proveerá constructores reutilizables de carga/error/espera usados en múltiples pantallas. | `future_builder_state_widgets.dart`. | En código |
| REQ-16.003 | El sistema formateará cantidades monetarias mediante una utilidad compartida. | `genera_cantidad_monetaria.dart`. | En código |
| REQ-16.004 | El sistema renderizará texto de derechos reservados/pie mediante un widget compartido. | `derechos_reservados.dart`. | En código |
| REQ-16.005 | El sistema controlará el nivel de salida de depuración para diagnósticos. | `debugprint.dart`. | En código |

---

## NFR-00. Requerimientos no funcionales
| ID | Requerimiento | Evidencia | Estado |
|-----|---------------|-----------|--------|
| NFR-00.001 | El sistema preservará los outputs de ingeniería inversa como documentación; no requiere modificación del código fuente para satisfacer este documento. | Análisis de solo lectura. | En código |
| NFR-00.002 | El sistema utilizará Riverpod para gestión de estado y mantendrá límites asíncronos observables en proveedores. | Uso generalizado de `flutter_riverpod` y `riverpod_annotation`. | En código |
| NFR-00.003 | El sistema almacenará secretos fuera de control de versiones y evitará persistencia de contraseñas en texto plano. | `.env` en `.gitignore`, variables globales detectadas. | Riesgo |
| NFR-00.004 | El sistema mantendrá archivos grandes de formulario y proveedores bajo umbrales de complejidad; en fases futuras se refactorizarán formularios que superen el umbral. | `form_update_espacio_comprado.dart` de 6689 líneas. | Riesgo |

---

## Matriz de trazabilidad resumida
| ID | Feature | Providers | Modelos | Rutas | I/O externo | Dependencias clave |
|-----|---------|-----------|---------|-------|-------------|-------------------|
| REQ-01 | Splash | No | No | `/`, `/splash` | `connectivity_plus` | `flutter_riverpod` |
| REQ-02 | Home/Nav | `HomeNavigation` | `HomeState` | `/principal` | No | `freezed`, `riverpod_annotation` |
| REQ-03 | Principal | `homeNavigationProvider`, `sessionProvider`, `menu*Provider` | `MenuOption` | `/principal` | CouchDB indirecto | `flutter_riverpod`, `material_symbols_icons` |
| REQ-04 | Rutas | No | No | Varias | Deep links | `app_links` |
| REQ-05 | Seguridad/Auth/Session | `SessionNotifier`, `classUserAvatarProvider` | `AuthState`, `GetUserData`, `GetUserAvatar` | `/login`, `/registro`, `/cambiopassword`, `/gestionavatar` | CouchDB, Node mailer | `http`, `flutter_secure_storage`, `shared_preferences`, `file_picker` |
| REQ-06 | Búsqueda/Propiedades | `currentQueryProvider`, `findPropiedadesEstadosde10en10Provider` | `EspaciosCasaGet`, `VariablesViewQuery` | `/buscapropiedades`, `/mapapropiedades` | CouchDB, Google Maps | `http`, `google_maps_flutter`, `geocoding` |
| REQ-07 | Mapas | `ubicacionActualProvider` | `GoogleMapPlaceData` | `/mapapropiedades` | Google Maps/geocoding, JSON local | `google_maps_flutter`, `geocoding` |
| REQ-08 | Localidades | `localidadesPorCodigoPostalProvider`, `userLocalidadesProvider` | `LocalidadCp`, `LocalidadesGet`, `UsuarioLocalidades` | `/localidades`, `/listalocalidades` | CouchDB, SEPOMEX JSON | `flutter_riverpod`, `http` |
| REQ-09 | Listas/Compartir | `userListsProvider`, `listaPropiedadesProvider`, `listasCompartidasProvider`, `meGustaProvider` | `GetUserPropertyListModel`, `ListaCompartidaModel`, `MeGustaModel` | `/listaspropiedades` | CouchDB | `http`, `uuid` |
| REQ-10 | Grupos | `gruposProvider`, `mensajesGrupoProvider`, `publicacionesGrupoProvider`, `avisosGrupoProvider` | `GrupoModel`, `MensajeGrupoModel`, `PublicacionGrupoModel`, `AvisoGrupoModel` | Desde Mi Cuenta | CouchDB, `_changes` | `http`, `uuid`, `flutter_riverpod` |
| REQ-11 | Conocidos/Chat | `conocidosProvider`, `provider_mensajes` | `Conocido`, `InvitacionEstado` | Desde Mi Cuenta | CouchDB | `http`, `uuid` |
| REQ-12 | Tus espacios | `espaciosCasaConListaFotosGetProvider`, `compraDeEspaciosProvider` | `EspaciosCasa`, `CompraEspaciosData` | `/editaespacio`, `/compraespacios` | CouchDB | `http`, `flutter_riverpod` |
| REQ-13 | Imágenes | `provider_get_fotos_ids_user_propiedad.dart`, `provider_get_lista_fotos_ordenadas.dart` | `DataFotosCasa`, `FotosOrden` | `/agregamultiplesfotos`, `/fotospropiedad`, `/fotospropiedadpaginada` | CouchDB attachments | `http`, `flutter_riverpod` |
| REQ-14 | Perfil/Preferencias | `sessionProvider`, `classUserAvatarProvider` | Sesión | `/perfil`, `/gestionavatar`, `/preferencias` | CouchDB avatares | `file_picker`, `http` |
| REQ-15 | Conectividad/OS | `checaConeccionesProvider` | `ElementoDeConeccion` | `/sinconeccion`, `/checaconeccion`, `/plataforma` | `connectivity_plus` | `flutter_riverpod` |
| REQ-16 | Widgets globales | No | No | Varias | No | `flutter` |

---

## Riesgos destacados
- Dependencia de variables globales en multiples módulos: complica testing/concurrencia.
- Contraseña gestionada como texto en memoria antes del hash.
- Rutas declaradas sin implementación visible: `generadatapropiedades`, `generadatausuarios`, `generadatapromotores`.
- Formulario de edición de espacio comprado con alta complejidad y responsabilidades concentradas.
- Manejo inconsistente de errores HTTP entre códigos 200/201/202 y errores 5xx.

