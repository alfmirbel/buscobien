# Inventario Exhaustivo de Modelos y Componentes - BuscoBien

> Archivos analizados: `lib/` (excluyendo archivos generados `.g.dart` y `.freezed.dart`)

## Tabla Resumen

| Subdirectorio | Archivo | Tipo | Clases |
|---|---|---|---|
| (raiz) | main.dart | Página/Inicio | BuscoBienApp, _BuscoBienAppState |
| 01_home | home_navigation_provider.dart | Utilidad | HomeNavigation |
| 01_home | home_state.dart | Utilidad | HomeState |
| 01_splash_screen | glass_objects.dart | Widget | GlassMorphismContainer2, GlassMorphismContainer, GlassBox |
| 01_splash_screen | splash_page.dart | Widget | SplashPage, _SplashPageState |
| 01_splash_screen | versiones.dart | Utilidad | AppVersion |
| 02_principal_screen | 00_principales_opciones.dart | Utilidad | MenuOption |
| 02_principal_screen | principal_00_inicio.dart | Widget | PageInicio, PageInicioState, _HoverScaleCard, _HoverScaleCardState |
| 02_principal_screen | principal_02_page_appbar.dart | Utilidad | (ninguna) |
| 02_principal_screen | principal_03_page_drawer.dart | Widget | MenuDrawer |
| 02_principal_screen | principal_sliver_screen_menus_inicio.dart | Widget | PrincipalSliversMenuInicial, _PrincipalSliversMenuInicialState, VistaContenidoDinamico |
| 03_listas | data_lista_propiedad.dart | Modelo de datos | ListaPropertyListModel, Listapropiedad |
| 03_listas | data_lista_propiedad_get.dart | Modelo de datos | GetListaPropertyListModel, RowListaProperty |
| 03_listas | data_user_list_model.dart | Modelo de datos | UserPropertyListModel, Lista |
| 03_listas | data_user_list_model_get.dart | Modelo de datos | GetUserPropertyListModel, RowGetUserPropertyList, Value |
| 03_listas | lista_select_lista_save_propiedad.dart | Widget | DialogSelectorListas, _DialogSelectorListasState |
| 03_listas | models/lista_compartida_model.dart | Modelo de datos | ListaCompartidaModel |
| 03_listas | models/me_gusta_model.dart | Modelo de datos | MeGustaModel |
| 03_listas | page_compartir_con_conocido.dart | Widget | PageCompartirConConocido, _PageCompartirConConocidoState |
| 03_listas | page_compartir_con_grupo.dart | Widget | PageCompartirConGrupo, _PageCompartirConGrupoState |
| 03_listas | pagina_detalle_lista_compartida.dart | Widget | PageDetalleListaCompartida, _PageDetalleListaCompartidaState |
| 03_listas | pagina_detalle_listas.dart | Widget | PageDetalleLista, Lista, Listapropiedad, _PageDetalleListaState |
| 03_listas | pagina_mis_listas.dart | Widget | PageMisListas, _PageMisListasState |
| 03_listas | provider_listas_compartidas.dart | Provider | ListasCompartidasNotifier |
| 03_listas | provider_listas_propiedades.dart | Provider | ClassListaPropiedadesProvider |
| 03_listas | provider_me_gusta.dart | Provider | MeGustaNotifier |
| 03_listas | provider_propiedades_compartidas_conocidos.dart | Provider | PropiedadCompartidaKnownModel, PropiedadesCompartidasConocidosNotifier |
| 03_listas | provider_user_lists.dart | Provider | UserListsNotifier |
| 03_vistas | pagina_asociaciones.dart | Widget | LandingAsociacionesPage |
| 03_vistas | pagina_hospedaje.dart | Widget | LandingHospedajePage |
| 03_vistas | pagina_inmobiliarias.dart | Widget | LandingInmobiliariasPage |
| 03_vistas | pagina_market.dart | Widget | LandingMarketPage |
| 03_vistas | pagina_promotores.dart | Widget | LandingAgentesPage |
| 03_vistas | pagina_propietarios.dart | Widget | LandingPropietariosPage |
| 03_vistas | pagina_proveedores.dart | Widget | LandingProveedoresPage01 |
| 03_vistas | pagina_servicios.dart | Widget | LandingServiciosPage |
| 03_vistas | pagina_usuarios.dart | Widget | LandingBusquedaPage |
| 04_provider | pagina_colores.dart | Widget | PaginaColores, PaginaColoresState |
| 04_provider | provider_preferencias.dart | Provider | SelectColorProvider |
| 05_provider_menus | appbar_menu_tipo_transaccion_inferior.dart | Widget | MenuInferiorTipoDeTransaccion, _MenuInferiorTipoDeTransaccionState |
| 05_provider_menus | appbar_menu_tu_cuenta.dart | Widget | MenuSuperiorPaginaTuCuenta |
| 05_provider_menus | appbar_menu_tu_cuenta_usuario.dart | Widget | MenuSuperiorPaginaTuCuentaUsuario |
| 05_provider_menus | appbar_sliver_menu_inicial.dart | Utilidad | (ninguna) |
| 05_provider_menus | appbar_sliver_menu_nivel_gobierno.dart | Widget | MenuSuperiorPaginaInicioNivelGobierno |
| 05_provider_menus | appbar_sliver_menu_principal.dart | Utilidad | (ninguna) |
| 05_provider_menus | appbar_sliver_menu_tipo_espacio.dart | Widget | MenuSuperiorPaginaTipoDeEspacios |
| 05_provider_menus | dropdown_menu_principal_propiedades.dart | Widget | DropdownButtonPropiedad, DropdownButtonPropiedadState |
| 05_provider_menus | provider_menu_inicial.dart | Provider | ElementosDelMenuInicial, ClaseMenuInicial |
| 05_provider_menus | provider_menu_nivel_gobierno.dart | Provider | ElementosDelMenuNivelDeGobierno, ClaseMenuNivelDeGobierno |
| 05_provider_menus | provider_menu_principal.dart | Provider | ElementosDelMenuPrincipal, ClaseMenuPrincipal |
| 05_provider_menus | provider_menu_tipo_de_transaccion.dart | Provider | ElementosDelMenuTipoDePublicacion, ClaseMenuTipoDePublicacion |
| 05_provider_menus | provider_menu_tipo_espacio.dart | Provider | ElementosDelMenuTipoEspacios, ClaseMenuTipoEspacio |
| 05_provider_menus | provider_menu_tu_cuenta.dart | Provider | ElementosDelMenuTuCuenta, ClaseMenuTuCuenta |
| 05_provider_menus | provider_menu_tu_cuenta_usuario.dart | Provider | ElementosDelMenuTuCuentaUsuario, ClaseMenuTuCuentaUsuario |
| 05_provider_menus | variables_menus.dart | Utilidad | (ninguna) |
| 07_routes | app_routes.dart | Rutas | AppRoutes |
| 07_routes | deep_link_handler.dart | Utilidad | (ninguna) |
| 07_routes | pagina_route_error.dart | Rutas | PaginaDeError |
| 07_routes | routes_parameters.dart | Rutas | ResultadoGuardaFoto, ResultSaveFoto, ArgumentsLocalidad, ArgumentsListaLocalidad |
| 08_pantallas | inicio/catalogo_otras_caracteristicas.dart | Utilidad | (ninguna) |
| 08_pantallas | inicio/clase_busqueda_estado.dart | Utilidad | BusquedaPaginacion, SearchTerm |
| 08_pantallas | inicio/data_count_view_documentos.dart | Modelo de datos | CountViewDoctos, RowCountViewDoctos |
| 08_pantallas | inicio/data_espacios_casas.dart | Modelo de datos | EspaciosCasa, Datosadicionalescasa, Datosdelcontactocasa, Fechadecasa, Ubicacioncasa |
| 08_pantallas | inicio/data_espacios_casas_get.dart | Modelo de datos | EspaciosCasaGet, RowEspaciosCasaGet, ValueEspaciosCasaGet |
| 08_pantallas | inicio/data_get_valores_menus.dart | Modelo de datos | VariablesViewQuery |
| 08_pantallas | inicio/http_find_propiedades_10en10.dart | Utilidad | (ninguna) |
| 08_pantallas | inicio/http_view_count_filter_propiedades.dart | Utilidad | (ninguna) |
| 08_pantallas | inicio/inicio_propiedades_providers.dart | Utilidad | PaginacionBusqueda |
| 08_pantallas | inicio/pagina_inicio_busca_espacios.dart | Widget | PaginaBuscaEspacios, _PaginaBuscaEspaciosState |
| 08_pantallas | inicio/widget_wrap_modern_card.dart | Widget | WrapModernCardPropiedades, _MeGustaButton, _MeGustaButtonState |
| 08_pantallas | perfil/pagina_perfil.dart | Widget | PaginaPerfilWidget, PaginaPerfilWidgetState |
| 08_pantallas | propiedades/data_find_propiedades.dart | Modelo de datos | FindPropiedades, Doc |
| 08_pantallas | propiedades/pagina_detalle_propiedad.dart | Widget | PaginaDetalleWidget, PaginaDetalleWidgetState, _FotoItemWidget, _MeGustaButtonFicha |
| 08_pantallas | propiedades/pagina_detalle_propiedad_pdf.dart | Página | PdfGeneratorService |
| 08_pantallas | tu_cuenta/conocidos/conocidos_view.dart | Widget | ConocidosView, _ConocidosViewState |
| 08_pantallas | tu_cuenta/conocidos/invitacion_model.dart | Modelo de datos | InvitacionModel |
| 08_pantallas | tu_cuenta/conocidos/mensaje_model.dart | Modelo de datos | MensajeModel |
| 08_pantallas | tu_cuenta/conocidos/models/conocido.dart | Utilidad | Conocido |
| 08_pantallas | tu_cuenta/conocidos/page_chat_privado.dart | Widget | PageChatPrivado, _PageChatPrivadoState, _BurbujaPropiedad, _BurbujaLista |
| 08_pantallas | tu_cuenta/conocidos/page_descubrir_usuarios.dart | Widget | PageDescubrirUsuarios |
| 08_pantallas | tu_cuenta/conocidos/page_invitaciones.dart | Widget | PageInvitaciones |
| 08_pantallas | tu_cuenta/conocidos/page_mis_contactos.dart | Widget | PageMisContactos, _PageMisContactosState |
| 08_pantallas | tu_cuenta/conocidos/page_perfil_contacto.dart | Widget | PagePerfilContacto |
| 08_pantallas | tu_cuenta/conocidos/provider_mensajes.dart | Provider | MensajesChatNotifier |
| 08_pantallas | tu_cuenta/conocidos/providers/conocidos_notifier.dart | Provider | ConocidosNotifier |
| 08_pantallas | tu_cuenta/conocidos/social_providers.dart | Provider | InvitacionesNotifier |
| 08_pantallas | tu_cuenta/grupos/grupos_view.dart | Widget | GruposView, _GruposViewState |
| 08_pantallas | tu_cuenta/grupos/models/aviso_grupo_model.dart | Modelo de datos | AvisoGrupoModel |
| 08_pantallas | tu_cuenta/grupos/models/grupo.dart | Utilidad | MiembroGrupo, Grupo |
| 08_pantallas | tu_cuenta/grupos/models/grupo_model.dart | Modelo de datos | GrupoModel, MiembroGrupoModel |
| 08_pantallas | tu_cuenta/grupos/models/invitacion_grupo_model.dart | Modelo de datos | InvitacionGrupoModel |
| 08_pantallas | tu_cuenta/grupos/models/mensaje_grupo_model.dart | Modelo de datos | MensajeGrupoModel |
| 08_pantallas | tu_cuenta/grupos/models/publicacion_grupo_model.dart | Modelo de datos | PublicacionGrupoModel |
| 08_pantallas | tu_cuenta/grupos/page_chat_grupo.dart | Widget | PageChatGrupo, _PageChatGrupoState, _BurbujaMensaje, _BurbujaPropiedad, _BurbujaLista, _BarraInput, ChatGrupoEmbebido, _ChatGrupoEmbebidoState |
| 08_pantallas | tu_cuenta/grupos/page_descubrir_grupos.dart | Widget | PageDescubrirGrupos, _GrupoDescubrirCard |
| 08_pantallas | tu_cuenta/grupos/page_detalle_grupo.dart | Widget | PageDetalleGrupo, _PageDetalleGrupoState, _TabPublicaciones, _TarjetaPublicacion, _TabMiembros, _TabAvisos, _TabAvisosState, _TarjetaAviso, _InfoRow |
| 08_pantallas | tu_cuenta/grupos/page_invitaciones_grupo.dart | Widget | PageInvitacionesGrupo, _PageInvitacionesGrupoState, _ListaInvitaciones, _InvitacionCard, _StatusBadge |
| 08_pantallas | tu_cuenta/grupos/page_mis_grupos.dart | Widget | PageMisGrupos, _PageMisGruposState, _GrupoCard |
| 08_pantallas | tu_cuenta/grupos/providers/avisos_grupo_provider.dart | Provider | AvisosGrupoNotifier |
| 08_pantallas | tu_cuenta/grupos/providers/grupos_invitaciones_provider.dart | Provider | GruposInvitacionesNotifier |
| 08_pantallas | tu_cuenta/grupos/providers/grupos_mensajes_provider.dart | Provider | MensajesGrupoNotifier |
| 08_pantallas | tu_cuenta/grupos/providers/grupos_notifier.dart | Provider | GruposNotifier |
| 08_pantallas | tu_cuenta/grupos/providers/publicaciones_grupo_provider.dart | Provider | PublicacionesGrupoNotifier |
| 08_pantallas | tu_cuenta/tus_espacios/compra_espacios/data_compra_espacios.dart | Modelo de datos | CompraEspacio, FechaDe |
| 08_pantallas | tu_cuenta/tus_espacios/compra_espacios/data_compra_espacios_get.dart | Modelo de datos | CompraEspacioGet, RowCompraEspacio, ValueCompraEspacio |
| 08_pantallas | tu_cuenta/tus_espacios/compra_espacios/form_compra_espacios.dart | Widget | PaginaCompraEspacios, PaginaCompraEspaciosState |
| 08_pantallas | tu_cuenta/tus_espacios/compra_espacios/provider_compra_espacios.dart | Provider | ClassCompraEspaciosNotifierProvider |
| 08_pantallas | tu_cuenta/tus_espacios/form_crea_ficha_captura_propiedad.dart | Widget | ConceptoEspacioRow, UbicacionEspacioRow, CreaFichaCapturaPropiedad, _CreaFichaCapturaPropiedadState |
| 08_pantallas | tu_cuenta/tus_espacios/form_update_espacio_comprado.dart | Widget | PaginaEditaEspacio, PaginaEditaEspacioState |
| 08_pantallas | tu_cuenta/tus_espacios/http_publica_propiedad.dart | Utilidad | (ninguna) |
| 08_pantallas | tu_cuenta/tus_espacios/pagina_tus_espacios.dart | Widget | PaginaTusEspacios, PaginaTipoEspaciosState |
| 08_pantallas | tu_cuenta/tus_espacios/provider_espacios_casa_get.dart | Provider | ListaEspaciosCasa, ClassCompraEspaciosNotifierProvider |
| 08_pantallas | tu_cuenta/tus_espacios/tabla_tipopropiedad_vs_campos.dart | Utilidad | (ninguna) |
| 08_pantallas | ubicacion/data_localidad_find.dart | Modelo de datos | FindLocalidadXcp, Doc |
| 08_pantallas | ubicacion/data_sepomex_localidades.dart | Modelo de datos | LocalidadCp |
| 08_pantallas | ubicacion/data_sepomex_localidades_get_cp.dart | Modelo de datos | LocalidadesGet, RowLocalidadesGet, ValueLocalidadesGet |
| 08_pantallas | ubicacion/pagina_busca_localidades_gmaps.dart | Widget | PaginaBuscaLocalidadGMaps, PaginaBuscaLocalidadGMapsState |
| 08_pantallas | ubicacion/pagina_principal_localidades.dart | Widget | PaginaPrincipalListaLocalidades, PaginaPrincipalListaLocalidadesState |
| 08_pantallas | ubicacion/provider_localidades_del_cp.dart | Provider | ListaDeLocalidadesDelCP, ClassLocalidadesNotifierProvider |
| 08_pantallas | ubicacion/screen_maestro_localidades.dart | Widget | LocalidadesListScreen, LocalidadesListScreenState |
| 08_pantallas | widgets_comunes/widget_letrero_tipo_transaccion.dart | Utilidad | (ninguna) |
| 10_user_login | avatar/data_user_avatar_get.dart | Modelo de datos | GetUserAvatar, RowGetUserAvatar, ValueGetUserAvatar |
| 10_user_login | avatar/manejo_imagenes_avatar.dart | Widget | GestionAvatares, GestionAvataresState |
| 10_user_login | avatar/provider_get_avatar.dart | Provider | ClassUserAvatarNotifier |
| 10_user_login | data_models/auth_state.dart | Utilidad | AuthState |
| 10_user_login | data_models/data_get_id_user_pass.dart | Modelo de datos | GetIdUserPass, RowIdUserPass, ValueIdUserPass |
| 10_user_login | data_models/data_get_user.dart | Modelo de datos | GetUserData, RowGetUserData, ValueGetUserData |
| 10_user_login | data_models/data_user_promotor.dart | Modelo de datos | UserDataPromotor |
| 10_user_login | data_models/data_usuarios.dart | Modelo de datos | UserData, Usuario, FechaDeNacimiento, UbicacionUserData |
| 10_user_login | usuario_login/data_session.dart | Modelo de datos | SessionData |
| 10_user_login | usuario_login/dialogbox_login.dart | Utilidad | (ninguna) |
| 10_user_login | usuario_login/login_01_login_page.dart | Widget | LoginPage, _LoginPageState, DropdownTipoUsuario, _DropdownTipoUsuarioState |
| 10_user_login | usuario_login/login_03_form_register_user.dart | Widget | RegisterScreenUsers, RegisterScreenUsersState, CheckboxTerminoCondiciones, CheckboxTerminoCondicionesState |
| 10_user_login | usuario_login/page_cambio_password.dart | Widget | PageCambioPassword, _PageCambioPasswordState |
| 10_user_login | usuario_login/page_solicitar_recuperacion.dart | Widget | PageSolicitarRecuperacion, _PageSolicitarRecuperacionState |
| 10_user_login | usuario_login/password_recovery_repository.dart | Repositorio/API | (ninguna) |
| 10_user_login | usuario_login/provider_session.dart | Provider | SessionNotifier |
| 10_user_login | usuario_login/session_repository.dart | Repositorio/API | SessionRepository |
| 10_user_login | usuario_login/session_storage.dart | Utilidad/Sesión | SessionStorage, MobileSessionStorage, WebSessionStorage |
| 10_user_login | usuario_login/textos_tc_ap.dart | Utilidad/Textos | VisorTerminosWidget |
| 12_localidades_user | data_user_localidad.dart | Modelo de datos | UsuarioLocalidades |
| 12_localidades_user | data_user_localidad_get.dart | Modelo de datos | UsuarioLocalidadesGet, RowsUserLocal |
| 12_localidades_user | localidades_repository.dart | Repositorio/API | LocalidadesRepository |
| 12_localidades_user | provider_get_localidades_usuario.dart | Provider | ClassUserLocalNotifierProvider |
| 14_geolocalizacion | app_keys.dart | Configuración | MyApp, _MyAppState |
| 14_geolocalizacion | google_map_mapa_propiedades.dart | Widget | PaginaMapaPropiedades, _PaginaMapaPropiedadesState |
| 14_geolocalizacion | google_map_place_data.dart | Utilidad | GooglemapPlace, PlusCode, Result, AddressComponent, Geometry, Viewport, NortheastClass, NavigationPoint, NavigationPointLocation |
| 14_geolocalizacion | provider_actual_place.dart | Provider | DatosDeLaUbicacionActual, ClassLocalidadesNotifierProvider |
| 20_var_globales | couchdb_errors.dart | Utilidad | CouchdbCodigo |
| 20_var_globales | format_chat_timestamp.dart | Variables Globales | (ninguna) |
| 20_var_globales | ui_exceptions.dart | Variables Globales | (ninguna) |
| 20_var_globales | var_color_themes.dart | Variables Globales | (ninguna) |
| 20_var_globales | var_color_widget.dart | Variables Globales | MyThemes |
| 20_var_globales | var_de_estilo_widgets.dart | Variables Globales | (ninguna) |
| 20_var_globales | var_elementos_menus.dart | Variables Globales | ElementosMenus, ElementoSeleccionado |
| 20_var_globales | var_login.dart | Variables Globales | (ninguna) |
| 20_var_globales | variables_globales.dart | Variables Globales | (ninguna) |
| 22_imagenes | data_models/data_fotos_casa.dart | Modelo de datos | FotosCasa, FotosCasaClass |
| 22_imagenes | data_models/data_fotos_casa_get.dart | Modelo de datos | FotosCasaGet, RowFotosCasaGet, ValueFotosCasaGet |
| 22_imagenes | data_models/data_fotos_casa_get_ids.dart | Modelo de datos | FotosCasaGetIDs, RowFotosCasaGetIDs, ValueFotosCasaGetIDs |
| 22_imagenes | data_models/data_fotos_ordenadas.dart | Modelo de datos | ListaFotosOrdenadas, FotosOrden |
| 22_imagenes | inicio_fotos_usuario/pagina_carousel_fotos_usuario.dart | Widget | PaginaCarouselFotosUsuario, PaginaCarouselFotosUsuarioState |
| 22_imagenes | inicio_fotos_usuario/pagina_carousel_fotos_usuario_mini.dart | Widget | PaginaCarouselFotosMini, PaginaCarouselFotosMiniState |
| 22_imagenes | tus_espacios_fotos_propiedad/funciones_compress_image.dart | Utilidad | (ninguna) |
| 22_imagenes | tus_espacios_fotos_propiedad/image_file_structure.dart | Utilidad | PlatformFileNoFinal |
| 22_imagenes | tus_espacios_fotos_propiedad/manejo_de_fotos/datos_fotos/data_couchdb_post_return.dart | Modelo de datos | CouchDbReturnValue |
| 22_imagenes | tus_espacios_fotos_propiedad/manejo_de_fotos/datos_fotos/data_cuenta_fotos.dart | Modelo de datos | CuentaFotos, RowCuentaFotos |
| 22_imagenes | tus_espacios_fotos_propiedad/manejo_de_fotos/datos_fotos/data_fotos_lista_fotos_iduser_idprop.dart | Modelo de datos | ListaFotosIdsPropiedadGet, RowListaFotosIds, ValueListaFotosIds |
| 22_imagenes | tus_espacios_fotos_propiedad/manejo_de_fotos/fotos_de_la_propiedad/pagina_agrega_multiples_fotos.dart | Widget | AgregaMultiplesFotos, AgregaMultiplesFotosState |
| 22_imagenes | tus_espacios_fotos_propiedad/manejo_de_fotos/futures_y_providers/future_funciones_fotos.dart | Utilidad | (ninguna) |
| 22_imagenes | tus_espacios_fotos_propiedad/manejo_de_fotos/futures_y_providers/future_get_fotos_by_idpr_orden.dart | Utilidad | (ninguna) |
| 22_imagenes | tus_espacios_fotos_propiedad/manejo_de_fotos/futures_y_providers/future_recupera_ids_fotos_propiedad.dart | Utilidad | (ninguna) |
| 22_imagenes | tus_espacios_fotos_propiedad/manejo_de_fotos/futures_y_providers/http_funciones_gestion_foto.dart | Utilidad | (ninguna) |
| 22_imagenes | tus_espacios_fotos_propiedad/manejo_de_fotos/futures_y_providers/provider_get_fotos_ids_user_propiedad.dart | Provider | ClassListaFotosCasaNotifierProvider |
| 22_imagenes | tus_espacios_fotos_propiedad/manejo_de_fotos/lista_fotos_ordenadas/clase_listas_fotos_propiedad.dart | Utilidad | ListasFotosPropiedad |
| 22_imagenes | tus_espacios_fotos_propiedad/manejo_de_fotos/lista_fotos_ordenadas/data_fotos_ordenadas_get_idpropiedad.dart | Modelo de datos | ListaFotosOrdenadasGetIdPropiedad, RowGetIdPropiedad, ValueGetIdPropiedad |
| 22_imagenes | tus_espacios_fotos_propiedad/manejo_de_fotos/lista_fotos_ordenadas/future_put_fotos_orden.dart | Utilidad | (ninguna) |
| 22_imagenes | tus_espacios_fotos_propiedad/manejo_de_fotos/lista_fotos_ordenadas/future_update_fotos_orden.dart | Utilidad | (ninguna) |
| 22_imagenes | tus_espacios_fotos_propiedad/manejo_de_fotos/lista_fotos_ordenadas/provider_get_lista_fotos_ordenadas.dart | Provider | ClassListaFotosCasaNotifierProvider |
| 22_imagenes | tus_espacios_fotos_propiedad/manejo_de_fotos/lista_ids_fotos/data_fotos_get_ids_fotos_user_prop.dart | Modelo de datos | GetIdsFotosUserProp, RowIdsFotos |
| 22_imagenes | tus_espacios_fotos_propiedad/manejo_de_fotos/opciones_menu_fotos/pagina_fotos_menu_opciones.dart | Widget | PaginaFotosPropiedad, PaginaFotosPropiedadState |
| 22_imagenes | tus_espacios_fotos_propiedad/manejo_de_fotos/opciones_menu_fotos/pagina_lista_fotos_carousel.dart | Widget | PaginaCarouselFotosWidget, PaginaCarouselFotosWidgetState |
| 22_imagenes | tus_espacios_fotos_propiedad/manejo_de_fotos/opciones_menu_fotos/pagina_lista_fotos_cuadros.dart | Widget | PropiedadesMiniFotoListaPromotor, PropiedadesMiniFotoListaPromotorState |
| 22_imagenes | tus_espacios_fotos_propiedad/manejo_de_fotos/opciones_menu_fotos/pagina_lista_fotos_listado.dart | Widget | PropiedadesListaFotosPromotor, PropiedadesListaFotosPromotorState, _FotoItemReorderable, _FotoItemReorderableState, _ImagenFotoLoader |
| 22_imagenes | variables_imagenes.dart | Utilidad | (ninguna) |
| 40_security | direccionip.dart | Variables Globales | (ninguna) |
| 40_security | encriptar.dart | Variables Globales | (ninguna) |
| 40_security | generate_hash.dart | Variables Globales | (ninguna) |
| 40_security | generate_reset_token.dart | Variables Globales | (ninguna) |
| 40_security | urls_endpoints_espacios.dart | Variables Globales | (ninguna) |
| 41_connectivity | connectivitycheck_provider.dart | Conectividad | ElementoDeConeccion, ElementoDatos, ChecaConeccionesNotifier, PaginaChecaInternet, PaginaChecaInternetState |
| 41_connectivity | pagina_sin_coneccion.dart | Widget | PaginaSinConeccion |
| 42_sistema_operativo | detecta_os.dart | Utilidad/Sistema | ElementoPlataforma, PaginaDetectaPlataforma |
| 60_global_widgets | bottom_fijo.dart | Widget | MyButton, MyTextField, SquareTile, MyTextFieldPassword, MyTextFieldPasswordState |
| 60_global_widgets | debugprint.dart | Utilidad | (ninguna) |
| 60_global_widgets | derechos_reservados.dart | Utilidad | (ninguna) |
| 60_global_widgets | dialogbox_mensaje_general.dart | Utilidad | (ninguna) |
| 60_global_widgets | future_builder_state_widgets.dart | Utilidad | (ninguna) |
| 60_global_widgets | genera_cantidad_monetaria.dart | Utilidad | (ninguna) |

---

## (raiz)

## (raiz)/main.dart
**Tipo:** Página/Inicio
**Clases:** BuscoBienApp, _BuscoBienAppState
**Variables top-level:** GlobalKey
**Variables por clase:**
- BuscoBienApp: *(sin campos detectados)*
- _BuscoBienAppState: *(sin campos detectados)*
**Dependencias (imports del proyecto):** *(ninguna)*
**Widgets/Componentes usados:** MaterialApp, StatefulWidget
**Notas:** *(pendiente revisión manual)*

## 01_home

## 01_home/home_navigation_provider.dart
**Tipo:** Utilidad
**Clases:** HomeNavigation
**Variables top-level:** *(ninguna)*
**Variables por clase:**
- HomeNavigation: *(sin campos detectados)*
**Dependencias (imports del proyecto):** ../60_global_widgets/debugprint.dart, home_state.dart
**Widgets/Componentes usados:** *(ninguno detectado)*
**Notas:** *(pendiente revisión manual)*

## 01_home/home_state.dart
**Tipo:** Utilidad
**Clases:** HomeState
**Variables top-level:** *(ninguna)*
**Variables por clase:**
- HomeState: *(sin campos detectados)*
**Dependencias (imports del proyecto):** *(ninguna)*
**Widgets/Componentes usados:** *(ninguno detectado)*
**Notas:** *(pendiente revisión manual)*

## 01_splash_screen

## 01_splash_screen/glass_objects.dart
**Tipo:** Widget
**Clases:** GlassMorphismContainer2, GlassMorphismContainer, GlassBox
**Variables top-level:** *(ninguna)*
**Variables por clase:**
- GlassMorphismContainer2: double width, double height, Widget child, double borderRadius, double blurStrength
- GlassMorphismContainer: double width, double height, Widget child, double borderRadius, double blurStrength
- GlassBox: double width, double height, Widget child
**Dependencias (imports del proyecto):** ../20_var_globales/var_color_widget.dart
**Widgets/Componentes usados:** Container, Positioned, SizedBox, Stack, StatelessWidget
**Notas:** *(pendiente revisión manual)*

## 01_splash_screen/splash_page.dart
**Tipo:** Widget
**Clases:** SplashPage, _SplashPageState
**Variables top-level:** *(ninguna)*
**Variables por clase:**
- SplashPage: int duration, Widget goToPage
- _SplashPageState: bool _isNavigating, bool _minDurationPassed
**Dependencias (imports del proyecto):** ../07_routes/app_routes.dart, ../20_var_globales/var_color_widget.dart, ../41_connectivity/connectivitycheck_provider.dart, glass_objects.dart, versiones.dart
**Widgets/Componentes usados:** Center, Column, Image, Positioned, Scaffold, SizedBox, Stack, Text
**Notas:** *(pendiente revisión manual)*

## 01_splash_screen/versiones.dart
**Tipo:** Utilidad
**Clases:** AppVersion
**Variables top-level:** List
**Variables por clase:**
- AppVersion: String version, String titulo, DateTime fecha, bool esCritica
**Dependencias (imports del proyecto):** *(ninguna)*
**Widgets/Componentes usados:** AppBar, Dialog, FutureBuilder, GestureDetector, ListTile, ListView, SizedBox, SliverAppBar, TabBar
**Notas:** *(pendiente revisión manual)*

## 02_principal_screen

## 02_principal_screen/00_principales_opciones.dart
**Tipo:** Utilidad
**Clases:** MenuOption
**Variables top-level:** List
**Variables por clase:**
- MenuOption: String nombreCorto, String nombreLargo, String descripcion, IconData icono, String imagePath
**Dependencias (imports del proyecto):** ../03_vistas/pagina_asociaciones.dart, ../03_vistas/pagina_hospedaje.dart, ../03_vistas/pagina_inmobiliarias.dart, ../03_vistas/pagina_propietarios.dart, ../03_vistas/pagina_servicios.dart, ../03_vistas/pagina_promotores.dart, ../03_vistas/pagina_proveedores.dart, ../03_vistas/pagina_market.dart, ../03_vistas/pagina_usuarios.dart, ../20_var_globales/var_elementos_menus.dart
**Widgets/Componentes usados:** *(ninguno detectado)*
**Notas:** *(pendiente revisión manual)*

## 02_principal_screen/principal_00_inicio.dart
**Tipo:** Widget
**Clases:** PageInicio, PageInicioState, _HoverScaleCard, _HoverScaleCardState
**Variables top-level:** codigoPostalBusquedaProvider, warningApp
**Variables por clase:**
- PageInicio: *(sin campos detectados)*
- PageInicioState: ScrollController _scrollController
- _HoverScaleCard: Widget child, VoidCallback onTap
- _HoverScaleCardState: AnimationController _controller
**Dependencias (imports del proyecto):** ../60_global_widgets/derechos_reservados.dart, ../20_var_globales/var_color_themes.dart, ../20_var_globales/var_color_widget.dart, 00_principales_opciones.dart
**Widgets/Componentes usados:** Card, Center, Column, Container, Expanded, GestureDetector, Hero, Icon, Image, InkWell, Padding, Positioned, Row, Scaffold, SizedBox, Stack, StatefulWidget, Text, Wrap
**Notas:** *(pendiente revisión manual)*

## 02_principal_screen/principal_02_page_appbar.dart
**Tipo:** Utilidad
**Clases:** *(ninguna)*
**Variables top-level:** screenWidth, asyncConeccion, ubicacionState, imageBytes, loginExitoso
**Variables por clase:**
*(ninguna)*
**Dependencias (imports del proyecto):** ../01_home/home_navigation_provider.dart, ../05_provider_menus/provider_menu_inicial.dart, ../05_provider_menus/provider_menu_principal.dart, ../05_provider_menus/variables_menus.dart, ../07_routes/app_routes.dart, ../07_routes/pagina_route_error.dart, ../07_routes/routes_parameters.dart, ../10_user_login/avatar/data_user_avatar_get.dart, ../10_user_login/avatar/manejo_imagenes_avatar.dart, ../10_user_login/avatar/provider_get_avatar.dart, ../10_user_login/usuario_login/dialogbox_login.dart, ../10_user_login/usuario_login/provider_session.dart, ../14_geolocalizacion/provider_actual_place.dart, ../20_var_globales/var_color_themes.dart, ../20_var_globales/var_color_widget.dart, ../20_var_globales/var_login.dart, ../20_var_globales/variables_globales.dart, ../41_connectivity/connectivitycheck_provider.dart, ../60_global_widgets/debugprint.dart
**Widgets/Componentes usados:** AppBar, CircleAvatar, Container, Icon, IconButton, Padding, Row, Scaffold, SizedBox, Text
**Notas:** *(pendiente revisión manual)*

## 02_principal_screen/principal_03_page_drawer.dart
**Tipo:** Widget
**Clases:** MenuDrawer
**Variables top-level:** AppExitType, SizedBox
**Variables por clase:**
- MenuDrawer: *(sin campos detectados)*
**Dependencias (imports del proyecto):** ../01_splash_screen/versiones.dart, ../07_routes/app_routes.dart, ../20_var_globales/var_color_themes.dart, ../42_sistema_operativo/detecta_os.dart, ../60_global_widgets/debugprint.dart, ../60_global_widgets/dialogbox_mensaje_general.dart
**Widgets/Componentes usados:** CircleAvatar, ConsumerWidget, Container, Divider, Drawer, Icon, Image, ListTile, ListView, Row, SizedBox, Stack, Text
**Notas:** *(pendiente revisión manual)*

## 02_principal_screen/principal_sliver_screen_menus_inicio.dart
**Tipo:** Widget
**Clases:** PrincipalSliversMenuInicial, _PrincipalSliversMenuInicialState, VistaContenidoDinamico
**Variables top-level:** ScrollController, currentUserId, locationNotifier, status, postalCode, result, navState, userSession, SizedBox, SizedBox, SizedBox, SizedBox
**Variables por clase:**
- PrincipalSliversMenuInicial: *(sin campos detectados)*
- _PrincipalSliversMenuInicialState: *(sin campos detectados)*
- VistaContenidoDinamico: HomeState navState
**Dependencias (imports del proyecto):** ../10_user_login/avatar/provider_get_avatar.dart, ../01_home/home_navigation_provider.dart, ../01_home/home_state.dart, ../03_listas/pagina_mis_listas.dart, ../05_provider_menus/appbar_menu_tu_cuenta.dart, ../05_provider_menus/appbar_menu_tu_cuenta_usuario.dart, ../05_provider_menus/appbar_sliver_menu_inicial.dart, ../05_provider_menus/appbar_sliver_menu_principal.dart, ../05_provider_menus/provider_menu_inicial.dart, ../05_provider_menus/provider_menu_nivel_gobierno.dart, ../05_provider_menus/provider_menu_principal.dart, ../05_provider_menus/provider_menu_tipo_de_transaccion.dart, ../05_provider_menus/provider_menu_tipo_espacio.dart, ../05_provider_menus/provider_menu_tu_cuenta.dart, ../05_provider_menus/provider_menu_tu_cuenta_usuario.dart, ../07_routes/app_routes.dart, ../08_pantallas/inicio/pagina_inicio_busca_espacios.dart, ../08_pantallas/perfil/pagina_perfil.dart, ../08_pantallas/tu_cuenta/conocidos/conocidos_view.dart, ../08_pantallas/tu_cuenta/grupos/grupos_view.dart, ../08_pantallas/tu_cuenta/tus_espacios/pagina_tus_espacios.dart, ../08_pantallas/tu_cuenta/tus_espacios/tabla_tipopropiedad_vs_campos.dart, ../08_pantallas/ubicacion/pagina_principal_localidades.dart, ../08_pantallas/ubicacion/provider_localidades_del_cp.dart, ../10_user_login/usuario_login/dialogbox_login.dart, ../14_geolocalizacion/provider_actual_place.dart, ../20_var_globales/var_color_themes.dart, ../20_var_globales/var_color_widget.dart, ../20_var_globales/var_elementos_menus.dart, ../20_var_globales/var_login.dart, ../20_var_globales/variables_globales.dart, ../41_connectivity/connectivitycheck_provider.dart, ../60_global_widgets/debugprint.dart, principal_00_inicio.dart, principal_02_page_appbar.dart, principal_03_page_drawer.dart
**Widgets/Componentes usados:** Center, Column, Container, CustomScrollView, Expanded, GestureDetector, Icon, Row, Scaffold, SizedBox, StatelessWidget, Text
**Notas:** *(pendiente revisión manual)*

## 03_listas

## 03_listas/data_lista_propiedad.dart
**Tipo:** Modelo de datos
**Clases:** ListaPropertyListModel, Listapropiedad
**Variables top-level:** *(ninguna)*
**Variables por clase:**
- ListaPropertyListModel: Listapropiedad listapropiedad, Listapropiedad listapropiedad, Listapropiedad listapropiedad, Listapropiedad listapropiedad
- Listapropiedad: String listapropiedadId, String userId, String listaId, String propertyId, String tipodeespacio, String type, String timestamp, String listapropiedadId, String userId, String listaId, String propertyId, String tipodeespacio, String type, String timestamp, String listapropiedadId, String userId, String listaId, String propertyId, String type, String timestamp, String listapropiedadId, String userId, String listaId, String propertyId, String type, String timestamp
**Dependencias (imports del proyecto):** *(ninguna)*
**Widgets/Componentes usados:** *(ninguno detectado)*
**Notas:** *(pendiente revisión manual)*

## 03_listas/data_lista_propiedad_get.dart
**Tipo:** Modelo de datos
**Clases:** GetListaPropertyListModel, RowListaProperty
**Variables top-level:** *(ninguna)*
**Variables por clase:**
- GetListaPropertyListModel: int totalRows, int offset, int totalRows, int offset, int totalRows, int offset
- RowListaProperty: String id, String key, Listapropiedad listapropiedad, String id, String key, Listapropiedad listapropiedad, String id, String key, Listapropiedad listapropiedad
**Dependencias (imports del proyecto):** data_lista_propiedad.dart, data_lista_propiedad.dart, data_lista_propiedad.dart
**Widgets/Componentes usados:** *(ninguno detectado)*
**Notas:** *(pendiente revisión manual)*

## 03_listas/data_user_list_model.dart
**Tipo:** Modelo de datos
**Clases:** UserPropertyListModel, Lista
**Variables top-level:** *(ninguna)*
**Variables por clase:**
- UserPropertyListModel: Lista value
- Lista: String listaId, String userId, String listName, String type, String timestamp
**Dependencias (imports del proyecto):** *(ninguna)*
**Widgets/Componentes usados:** *(ninguno detectado)*
**Notas:** *(pendiente revisión manual)*

## 03_listas/data_user_list_model_get.dart
**Tipo:** Modelo de datos
**Clases:** GetUserPropertyListModel, RowGetUserPropertyList, Value
**Variables top-level:** *(ninguna)*
**Variables por clase:**
- GetUserPropertyListModel: int totalRows, int offset, int totalRows, int offset
- RowGetUserPropertyList: String id, String key, Lista value, String id, String key, Value value
- Value: String listaId, String userId, String listName, String type, String timestamp
**Dependencias (imports del proyecto):** data_user_list_model.dart
**Widgets/Componentes usados:** *(ninguno detectado)*
**Notas:** *(pendiente revisión manual)*

## 03_listas/lista_select_lista_save_propiedad.dart
**Tipo:** Widget
**Clases:** DialogSelectorListas, _DialogSelectorListasState
**Variables top-level:** *(ninguna)*
**Variables por clase:**
- DialogSelectorListas: String userId, String propertyId, String tipoDeEspacio
- _DialogSelectorListasState: bool _isSaving
**Dependencias (imports del proyecto):** ../60_global_widgets/future_builder_state_widgets.dart, ../20_var_globales/var_color_themes.dart, ../22_imagenes/variables_imagenes.dart, ../60_global_widgets/debugprint.dart, provider_listas_propiedades.dart, provider_user_lists.dart
**Widgets/Componentes usados:** AlertDialog, Center, Column, Container, Dialog, Divider, ElevatedButton, Expanded, FutureBuilder, Icon, InkWell, InputDecoration, ListView, Padding, Row, SizedBox, Text, TextButton, TextField
**Notas:** *(pendiente revisión manual)*

## 03_listas/models/lista_compartida_model.dart
**Tipo:** Modelo de datos
**Clases:** ListaCompartidaModel
**Variables top-level:** *(ninguna)*
**Variables por clase:**
- ListaCompartidaModel: String id, String rev, String listaOrigenId, String listaNombre, String usuarioOrigenId, String usuarioOrigenNombre, String usuarioDestinoId, String usuarioDestinoNombre, String timestamp
**Dependencias (imports del proyecto):** *(ninguna)*
**Widgets/Componentes usados:** *(ninguno detectado)*
**Notas:** *(pendiente revisión manual)*

## 03_listas/models/me_gusta_model.dart
**Tipo:** Modelo de datos
**Clases:** MeGustaModel
**Variables top-level:** *(ninguna)*
**Variables por clase:**
- MeGustaModel: String id, String rev, String usuarioId, String propiedadId, String timestamp
**Dependencias (imports del proyecto):** *(ninguna)*
**Widgets/Componentes usados:** *(ninguno detectado)*
**Notas:** *(pendiente revisión manual)*

## 03_listas/page_compartir_con_conocido.dart
**Tipo:** Widget
**Clases:** PageCompartirConConocido, _PageCompartirConConocidoState
**Variables top-level:** *(ninguna)*
**Variables por clase:**
- PageCompartirConConocido: String propiedadId, String propiedadNombre, String tipodeespacio, String currentUserId, String currentUserName
- _PageCompartirConConocidoState: bool _enviando, int _maxSeleccion
**Dependencias (imports del proyecto):** *(ninguna)*
**Widgets/Componentes usados:** AppBar, Center, Column, Expanded, ListView, Padding, Scaffold, SizedBox, Text, TextButton
**Notas:** *(pendiente revisión manual)*

## 03_listas/page_compartir_con_grupo.dart
**Tipo:** Widget
**Clases:** PageCompartirConGrupo, _PageCompartirConGrupoState
**Variables top-level:** *(ninguna)*
**Variables por clase:**
- PageCompartirConGrupo: String propiedadId, String propiedadNombre, String tipodeespacio, String currentUserId, String currentUserName
- _PageCompartirConGrupoState: bool _enviando
**Dependencias (imports del proyecto):** *(ninguna)*
**Widgets/Componentes usados:** AppBar, Center, Column, Expanded, ListView, Padding, Scaffold, SizedBox, Text, TextButton
**Notas:** *(pendiente revisión manual)*

## 03_listas/pagina_detalle_lista_compartida.dart
**Tipo:** Widget
**Clases:** PageDetalleListaCompartida, _PageDetalleListaCompartidaState
**Variables top-level:** *(ninguna)*
**Variables por clase:**
- PageDetalleListaCompartida: ListaCompartidaModel listaCompartida
- _PageDetalleListaCompartidaState: *(sin campos detectados)*
**Dependencias (imports del proyecto):** ../08_pantallas/inicio/data_espacios_casas_get.dart, ../08_pantallas/inicio/widget_wrap_modern_card.dart, ../08_pantallas/tu_cuenta/tus_espacios/provider_espacios_casa_get.dart, ../20_var_globales/var_color_themes.dart, ../40_security/urls_endpoints_espacios.dart, ../60_global_widgets/debugprint.dart, models/lista_compartida_model.dart, provider_listas_compartidas.dart
**Widgets/Componentes usados:** AppBar, Center, Column, FutureBuilder, Icon, ListView, Scaffold, SizedBox, Text
**Notas:** *(pendiente revisión manual)*

## 03_listas/pagina_detalle_listas.dart
**Tipo:** Widget
**Clases:** PageDetalleLista, Lista, Listapropiedad, _PageDetalleListaState
**Variables top-level:** *(ninguna)*
**Variables por clase:**
- PageDetalleLista: Lista lista
- Lista: String listaId, String userId, String listName, String type, String timestamp
- Listapropiedad: String listapropiedadId, String userId, String listaId, String propertyId, String tipodeespacio, String type, String timestamp
- _PageDetalleListaState: String propertyId, String listapropiedadId
**Dependencias (imports del proyecto):** ../08_pantallas/inicio/data_espacios_casas_get.dart, ../08_pantallas/inicio/widget_wrap_modern_card.dart, ../08_pantallas/tu_cuenta/tus_espacios/provider_espacios_casa_get.dart, ../20_var_globales/var_color_themes.dart, ../40_security/urls_endpoints_espacios.dart, ../60_global_widgets/debugprint.dart, data_user_list_model.dart, provider_listas_propiedades.dart
**Widgets/Componentes usados:** AlertDialog, AppBar, Center, Column, Container, ElevatedButton, FutureBuilder, Icon, ListView, Padding, Scaffold, SizedBox, Text, TextButton, Wrap
**Notas:** *(pendiente revisión manual)*

## 03_listas/pagina_mis_listas.dart
**Tipo:** Widget
**Clases:** PageMisListas, _PageMisListasState
**Variables top-level:** *(ninguna)*
**Variables por clase:**
- PageMisListas: *(sin campos detectados)*
- _PageMisListasState: String _idUsuario, String _nombreUsuario, bool _cargando
**Dependencias (imports del proyecto):** ../10_user_login/usuario_login/dialogbox_login.dart, ../10_user_login/usuario_login/provider_session.dart, ../60_global_widgets/future_builder_state_widgets.dart, ../20_var_globales/var_color_themes.dart, ../20_var_globales/var_elementos_menus.dart, ../20_var_globales/variables_globales.dart, ../22_imagenes/variables_imagenes.dart, data_user_list_model.dart, pagina_detalle_listas.dart, provider_user_lists.dart, provider_listas_compartidas.dart, models/lista_compartida_model.dart, pagina_detalle_lista_compartida.dart
**Widgets/Componentes usados:** AlertDialog, Card, Center, CircleAvatar, Column, Container, Dialog, ElevatedButton, Expanded, FloatingActionButton, GestureDetector, Icon, IconButton, InputDecoration, ListTile, ListView, Padding, Row, Scaffold, SizedBox, TabBar, Text, TextButton, TextField
**Notas:** *(pendiente revisión manual)*

## 03_listas/provider_listas_compartidas.dart
**Tipo:** Provider
**Clases:** ListasCompartidasNotifier
**Variables top-level:** String, String, listasCompartidasProvider
**Variables por clase:**
- ListasCompartidasNotifier: *(sin campos detectados)*
**Dependencias (imports del proyecto):** ../40_security/direccionip.dart, ../60_global_widgets/debugprint.dart, ../08_pantallas/tu_cuenta/conocidos/provider_mensajes.dart, models/lista_compartida_model.dart
**Widgets/Componentes usados:** *(ninguno detectado)*
**Notas:** *(pendiente revisión manual)*

## 03_listas/provider_listas_propiedades.dart
**Tipo:** Provider
**Clases:** ClassListaPropiedadesProvider
**Variables top-level:** listaPropiedadesProvider
**Variables por clase:**
- ClassListaPropiedadesProvider: final _uuid
**Dependencias (imports del proyecto):** ../40_security/direccionip.dart, ../60_global_widgets/debugprint.dart, data_lista_propiedad.dart, data_lista_propiedad_get.dart, data_user_list_model.dart
**Widgets/Componentes usados:** *(ninguno detectado)*
**Notas:** *(pendiente revisión manual)*

## 03_listas/provider_me_gusta.dart
**Tipo:** Provider
**Clases:** MeGustaNotifier
**Variables top-level:** String, meGustaProvider
**Variables por clase:**
- MeGustaNotifier: String _currentUserId
**Dependencias (imports del proyecto):** ../40_security/direccionip.dart, ../60_global_widgets/debugprint.dart, models/me_gusta_model.dart, provider_user_lists.dart
**Widgets/Componentes usados:** *(ninguno detectado)*
**Notas:** *(pendiente revisión manual)*

## 03_listas/provider_propiedades_compartidas_conocidos.dart
**Tipo:** Provider
**Clases:** PropiedadCompartidaKnownModel, PropiedadesCompartidasConocidosNotifier
**Variables top-level:** String, propiedadesCompartidasConocidosProvider
**Variables por clase:**
- PropiedadCompartidaKnownModel: String id, String origenId, String origenNombre, String destinoId, String destinoNombre, String propiedadId, String propiedadNombre, String tipodeespacio, String timestamp
- PropiedadesCompartidasConocidosNotifier: *(sin campos detectados)*
**Dependencias (imports del proyecto):** ../40_security/direccionip.dart, ../60_global_widgets/debugprint.dart
**Widgets/Componentes usados:** *(ninguno detectado)*
**Notas:** *(pendiente revisión manual)*

## 03_listas/provider_user_lists.dart
**Tipo:** Provider
**Clases:** UserListsNotifier
**Variables top-level:** userListsProvider, propertiesDetailsProvider, url, body, response, data
**Variables por clase:**
- UserListsNotifier: *(sin campos detectados)*
**Dependencias (imports del proyecto):** ../40_security/direccionip.dart, ../60_global_widgets/debugprint.dart, data_user_list_model.dart, data_user_list_model_get.dart
**Widgets/Componentes usados:** *(ninguno detectado)*
**Notas:** *(pendiente revisión manual)*

## 03_vistas

## 03_vistas/pagina_asociaciones.dart
**Tipo:** Widget
**Clases:** LandingAsociacionesPage
**Variables top-level:** *(ninguna)*
**Variables por clase:**
- LandingAsociacionesPage: *(sin campos detectados)*
**Dependencias (imports del proyecto):** ../01_home/home_navigation_provider.dart, ../02_principal_screen/00_principales_opciones.dart, ../05_provider_menus/variables_menus.dart, ../60_global_widgets/derechos_reservados.dart, ../20_var_globales/var_color_themes.dart
**Widgets/Componentes usados:** AppBar, Column, ConsumerWidget, Container, ElevatedButton, Expanded, Icon, IconButton, Padding, Row, Scaffold, SizedBox, Text, TextButton, Wrap
**Notas:** *(pendiente revisión manual)*

## 03_vistas/pagina_hospedaje.dart
**Tipo:** Widget
**Clases:** LandingHospedajePage
**Variables top-level:** *(ninguna)*
**Variables por clase:**
- LandingHospedajePage: *(sin campos detectados)*
**Dependencias (imports del proyecto):** ../01_home/home_navigation_provider.dart, ../02_principal_screen/00_principales_opciones.dart, ../05_provider_menus/provider_menu_inicial.dart, ../05_provider_menus/provider_menu_principal.dart, ../05_provider_menus/provider_menu_tipo_espacio.dart, ../05_provider_menus/provider_menu_tu_cuenta.dart, ../05_provider_menus/variables_menus.dart, ../07_routes/app_routes.dart, ../60_global_widgets/derechos_reservados.dart, ../20_var_globales/var_color_themes.dart
**Widgets/Componentes usados:** AppBar, Column, ConsumerWidget, Container, ElevatedButton, Expanded, Icon, IconButton, Padding, Positioned, Row, Scaffold, SizedBox, Stack, Text, TextButton, Wrap
**Notas:** *(pendiente revisión manual)*

## 03_vistas/pagina_inmobiliarias.dart
**Tipo:** Widget
**Clases:** LandingInmobiliariasPage
**Variables top-level:** *(ninguna)*
**Variables por clase:**
- LandingInmobiliariasPage: *(sin campos detectados)*
**Dependencias (imports del proyecto):** ../01_home/home_navigation_provider.dart, ../02_principal_screen/00_principales_opciones.dart, ../05_provider_menus/variables_menus.dart, ../60_global_widgets/derechos_reservados.dart, ../20_var_globales/var_color_themes.dart
**Widgets/Componentes usados:** AppBar, Center, Column, ConsumerWidget, Container, ElevatedButton, Expanded, GridView, Icon, IconButton, InputDecoration, Padding, Row, Scaffold, SizedBox, Text, TextButton, Wrap
**Notas:** *(pendiente revisión manual)*

## 03_vistas/pagina_market.dart
**Tipo:** Widget
**Clases:** LandingMarketPage
**Variables top-level:** *(ninguna)*
**Variables por clase:**
- LandingMarketPage: *(sin campos detectados)*
**Dependencias (imports del proyecto):** ../01_home/home_navigation_provider.dart, ../02_principal_screen/00_principales_opciones.dart, ../05_provider_menus/variables_menus.dart, ../60_global_widgets/derechos_reservados.dart, ../20_var_globales/var_color_themes.dart
**Widgets/Componentes usados:** AppBar, Column, ConsumerWidget, Container, ElevatedButton, Expanded, Icon, IconButton, Padding, Row, Scaffold, SizedBox, Text, Wrap
**Notas:** *(pendiente revisión manual)*

## 03_vistas/pagina_promotores.dart
**Tipo:** Widget
**Clases:** LandingAgentesPage
**Variables top-level:** *(ninguna)*
**Variables por clase:**
- LandingAgentesPage: *(sin campos detectados)*
**Dependencias (imports del proyecto):** ../01_home/home_navigation_provider.dart, ../02_principal_screen/00_principales_opciones.dart, ../05_provider_menus/provider_menu_inicial.dart, ../05_provider_menus/provider_menu_principal.dart, ../05_provider_menus/provider_menu_tipo_de_transaccion.dart, ../05_provider_menus/variables_menus.dart, ../07_routes/app_routes.dart, ../10_user_login/usuario_login/dialogbox_login.dart, ../20_var_globales/var_color_themes.dart, ../20_var_globales/var_color_widget.dart
**Widgets/Componentes usados:** AppBar, Center, Column, ConsumerWidget, Container, ElevatedButton, GridView, Icon, IconButton, Padding, Row, Scaffold, SizedBox, Text, TextButton, Wrap
**Notas:** *(pendiente revisión manual)*

## 03_vistas/pagina_propietarios.dart
**Tipo:** Widget
**Clases:** LandingPropietariosPage
**Variables top-level:** *(ninguna)*
**Variables por clase:**
- LandingPropietariosPage: *(sin campos detectados)*
**Dependencias (imports del proyecto):** ../01_home/home_navigation_provider.dart, ../02_principal_screen/00_principales_opciones.dart, ../05_provider_menus/provider_menu_inicial.dart, ../05_provider_menus/provider_menu_principal.dart, ../05_provider_menus/provider_menu_tipo_espacio.dart, ../05_provider_menus/provider_menu_tu_cuenta.dart, ../05_provider_menus/variables_menus.dart, ../07_routes/app_routes.dart, ../20_var_globales/var_color_themes.dart
**Widgets/Componentes usados:** AppBar, Card, Center, Column, ConsumerWidget, Container, ElevatedButton, Expanded, Icon, IconButton, Padding, Row, Scaffold, SizedBox, Text, TextButton
**Notas:** *(pendiente revisión manual)*

## 03_vistas/pagina_proveedores.dart
**Tipo:** Widget
**Clases:** LandingProveedoresPage01
**Variables top-level:** *(ninguna)*
**Variables por clase:**
- LandingProveedoresPage01: *(sin campos detectados)*
**Dependencias (imports del proyecto):** ../01_home/home_navigation_provider.dart, ../02_principal_screen/00_principales_opciones.dart, ../05_provider_menus/variables_menus.dart, ../20_var_globales/var_color_themes.dart
**Widgets/Componentes usados:** AppBar, Center, Chip, Column, ConsumerWidget, Container, ElevatedButton, Expanded, Icon, IconButton, ListTile, Padding, Positioned, Row, Scaffold, SizedBox, Stack, Text, Wrap
**Notas:** *(pendiente revisión manual)*

## 03_vistas/pagina_servicios.dart
**Tipo:** Widget
**Clases:** LandingServiciosPage
**Variables top-level:** *(ninguna)*
**Variables por clase:**
- LandingServiciosPage: *(sin campos detectados)*
**Dependencias (imports del proyecto):** ../01_home/home_navigation_provider.dart, ../02_principal_screen/00_principales_opciones.dart, ../05_provider_menus/variables_menus.dart, ../20_var_globales/var_color_themes.dart
**Widgets/Componentes usados:** AppBar, CircleAvatar, Column, ConsumerWidget, Container, ElevatedButton, Expanded, Icon, IconButton, Padding, Row, Scaffold, SizedBox, Text, TextButton, Wrap
**Notas:** *(pendiente revisión manual)*

## 03_vistas/pagina_usuarios.dart
**Tipo:** Widget
**Clases:** LandingBusquedaPage
**Variables top-level:** *(ninguna)*
**Variables por clase:**
- LandingBusquedaPage: double iconSizeBanner, double textSizeBanner, double espacioEntreDato
**Dependencias (imports del proyecto):** ../01_home/home_navigation_provider.dart, ../02_principal_screen/00_principales_opciones.dart, ../02_principal_screen/principal_00_inicio.dart, ../05_provider_menus/provider_menu_inicial.dart, ../05_provider_menus/provider_menu_principal.dart, ../05_provider_menus/provider_menu_tipo_de_transaccion.dart, ../05_provider_menus/variables_menus.dart, ../07_routes/app_routes.dart, ../08_pantallas/inicio/data_espacios_casas.dart, ../08_pantallas/inicio/data_espacios_casas_get.dart, ../08_pantallas/inicio/http_find_propiedades_10en10.dart, ../08_pantallas/inicio/inicio_propiedades_providers.dart, ../20_var_globales/var_color_themes.dart, ../22_imagenes/inicio_fotos_usuario/pagina_carousel_fotos_usuario_mini.dart
**Widgets/Componentes usados:** AppBar, Card, Center, CircleAvatar, Column, ConsumerWidget, Container, ElevatedButton, Expanded, Hero, Icon, IconButton, Image, InputDecoration, ListView, Padding, Positioned, Row, Scaffold, SizedBox, Stack, StatefulWidget, Text, TextButton, TextField, Wrap
**Notas:** *(pendiente revisión manual)*

## 04_provider

## 04_provider/pagina_colores.dart
**Tipo:** Widget
**Clases:** PaginaColores, PaginaColoresState
**Variables top-level:** *(ninguna)*
**Variables por clase:**
- PaginaColores: String backpage
- PaginaColoresState: *(sin campos detectados)*
**Dependencias (imports del proyecto):** ../../04_provider/provider_preferencias.dart, ../../20_var_globales/var_color_themes.dart, ../60_global_widgets/debugprint.dart
**Widgets/Componentes usados:** AppBar, Center, Column, Container, ElevatedButton, Expanded, Radio, Row, Scaffold, SizedBox, Text, TextButton
**Notas:** *(pendiente revisión manual)*

## 04_provider/provider_preferencias.dart
**Tipo:** Provider
**Clases:** SelectColorProvider
**Variables top-level:** coloresProvider
**Variables por clase:**
- SelectColorProvider: int color, String etiqueta
**Dependencias (imports del proyecto):** *(ninguna)*
**Widgets/Componentes usados:** *(ninguno detectado)*
**Notas:** *(pendiente revisión manual)*

## 05_provider_menus

## 05_provider_menus/appbar_menu_tipo_transaccion_inferior.dart
**Tipo:** Widget
**Clases:** MenuInferiorTipoDeTransaccion, _MenuInferiorTipoDeTransaccionState
**Variables top-level:** *(ninguna)*
**Variables por clase:**
- MenuInferiorTipoDeTransaccion: *(sin campos detectados)*
- _MenuInferiorTipoDeTransaccionState: *(sin campos detectados)*
**Dependencias (imports del proyecto):** ../01_home/home_navigation_provider.dart, ../20_var_globales/var_color_themes.dart, ../20_var_globales/var_de_estilo_widgets.dart, ../60_global_widgets/debugprint.dart, provider_menu_tipo_de_transaccion.dart, variables_menus.dart
**Widgets/Componentes usados:** Container, Icon
**Notas:** *(pendiente revisión manual)*

## 05_provider_menus/appbar_menu_tu_cuenta.dart
**Tipo:** Widget
**Clases:** MenuSuperiorPaginaTuCuenta
**Variables top-level:** *(ninguna)*
**Variables por clase:**
- MenuSuperiorPaginaTuCuenta: *(sin campos detectados)*
**Dependencias (imports del proyecto):** ../01_home/home_navigation_provider.dart, ../20_var_globales/var_de_estilo_widgets.dart, provider_menu_tu_cuenta.dart, variables_menus.dart
**Widgets/Componentes usados:** ConsumerWidget, Icon, SliverAppBar
**Notas:** *(pendiente revisión manual)*

## 05_provider_menus/appbar_menu_tu_cuenta_usuario.dart
**Tipo:** Widget
**Clases:** MenuSuperiorPaginaTuCuentaUsuario
**Variables top-level:** *(ninguna)*
**Variables por clase:**
- MenuSuperiorPaginaTuCuentaUsuario: *(sin campos detectados)*
**Dependencias (imports del proyecto):** ../01_home/home_navigation_provider.dart, ../20_var_globales/var_color_themes.dart, ../20_var_globales/var_de_estilo_widgets.dart, provider_menu_tu_cuenta_usuario.dart, variables_menus.dart
**Widgets/Componentes usados:** ConsumerWidget, Icon, SliverAppBar
**Notas:** *(pendiente revisión manual)*

## 05_provider_menus/appbar_sliver_menu_inicial.dart
**Tipo:** Utilidad
**Clases:** *(ninguna)*
**Variables top-level:** manuPrincipal
**Variables por clase:**
*(ninguna)*
**Dependencias (imports del proyecto):** ../01_home/home_navigation_provider.dart, ../20_var_globales/var_color_themes.dart, ../20_var_globales/var_de_estilo_widgets.dart, ../60_global_widgets/debugprint.dart, provider_menu_inicial.dart, variables_menus.dart
**Widgets/Componentes usados:** Icon, SliverAppBar
**Notas:** *(pendiente revisión manual)*

## 05_provider_menus/appbar_sliver_menu_nivel_gobierno.dart
**Tipo:** Widget
**Clases:** MenuSuperiorPaginaInicioNivelGobierno
**Variables top-level:** GlobalKey
**Variables por clase:**
- MenuSuperiorPaginaInicioNivelGobierno: *(sin campos detectados)*
**Dependencias (imports del proyecto):** ../01_home/home_navigation_provider.dart, ../20_var_globales/var_color_themes.dart, ../08_pantallas/ubicacion/provider_localidades_del_cp.dart, ../20_var_globales/var_de_estilo_widgets.dart, ../60_global_widgets/debugprint.dart, provider_menu_nivel_gobierno.dart, variables_menus.dart
**Widgets/Componentes usados:** AppBar, ConsumerWidget, Icon, SliverAppBar
**Notas:** *(pendiente revisión manual)*

## 05_provider_menus/appbar_sliver_menu_principal.dart
**Tipo:** Utilidad
**Clases:** *(ninguna)*
**Variables top-level:** manuPrincipal
**Variables por clase:**
*(ninguna)*
**Dependencias (imports del proyecto):** ../01_home/home_navigation_provider.dart, ../20_var_globales/var_color_themes.dart, ../20_var_globales/var_de_estilo_widgets.dart, ../60_global_widgets/debugprint.dart, provider_menu_principal.dart, variables_menus.dart
**Widgets/Componentes usados:** Icon, SliverAppBar
**Notas:** *(pendiente revisión manual)*

## 05_provider_menus/appbar_sliver_menu_tipo_espacio.dart
**Tipo:** Widget
**Clases:** MenuSuperiorPaginaTipoDeEspacios
**Variables top-level:** GlobalKey
**Variables por clase:**
- MenuSuperiorPaginaTipoDeEspacios: *(sin campos detectados)*
**Dependencias (imports del proyecto):** ../01_home/home_navigation_provider.dart, ../20_var_globales/var_color_themes.dart, ../20_var_globales/var_de_estilo_widgets.dart, ../60_global_widgets/debugprint.dart, provider_menu_tipo_espacio.dart, variables_menus.dart
**Widgets/Componentes usados:** ConsumerWidget, Icon, SliverAppBar
**Notas:** *(pendiente revisión manual)*

## 05_provider_menus/dropdown_menu_principal_propiedades.dart
**Tipo:** Widget
**Clases:** DropdownButtonPropiedad, DropdownButtonPropiedadState
**Variables top-level:** *(ninguna)*
**Variables por clase:**
- DropdownButtonPropiedad: WidgetRef ref, int index, String valorInicial, ValueChangeCallback onChangedCallback, bool listaamostrar
- DropdownButtonPropiedadState: *(sin campos detectados)*
**Dependencias (imports del proyecto):** ../02_principal_screen/principal_sliver_screen_menus_inicio.dart, ../08_pantallas/tu_cuenta/tus_espacios/tabla_tipopropiedad_vs_campos.dart, ../20_var_globales/var_color_themes.dart, variables_menus.dart
**Widgets/Componentes usados:** Container, Icon, SizedBox, Text
**Notas:** *(pendiente revisión manual)*

## 05_provider_menus/provider_menu_inicial.dart
**Tipo:** Provider
**Clases:** ElementosDelMenuInicial, ClaseMenuInicial
**Variables top-level:** menuInicialProvider
**Variables por clase:**
- ElementosDelMenuInicial: int index, String etiqueta, int indexPromotor, IconData icono, TabController tabControllerMenuInicial, int seleccionMenuInicial
- ClaseMenuInicial: *(sin campos detectados)*
**Dependencias (imports del proyecto):** ../10_user_login/usuario_login/provider_session.dart, ../20_var_globales/var_elementos_menus.dart
**Widgets/Componentes usados:** *(ninguno detectado)*
**Notas:** *(pendiente revisión manual)*

## 05_provider_menus/provider_menu_nivel_gobierno.dart
**Tipo:** Provider
**Clases:** ElementosDelMenuNivelDeGobierno, ClaseMenuNivelDeGobierno
**Variables top-level:** menuNivelDeGobiernoProvider
**Variables por clase:**
- ElementosDelMenuNivelDeGobierno: int index, String etiqueta, IconData icono, TabController tabControllerMenuNivelDeGobierno, int seleccionMenuNivelDeGobierno
- ClaseMenuNivelDeGobierno: *(sin campos detectados)*
**Dependencias (imports del proyecto):** ../20_var_globales/var_elementos_menus.dart
**Widgets/Componentes usados:** *(ninguno detectado)*
**Notas:** *(pendiente revisión manual)*

## 05_provider_menus/provider_menu_principal.dart
**Tipo:** Provider
**Clases:** ElementosDelMenuPrincipal, ClaseMenuPrincipal
**Variables top-level:** menuPrincipalProvider
**Variables por clase:**
- ElementosDelMenuPrincipal: int index, String etiqueta, int indexPromotor, IconData icono, TabController tabControllerMenuPrincipal, int seleccionMenuPrincipal
- ClaseMenuPrincipal: *(sin campos detectados)*
**Dependencias (imports del proyecto):** ../10_user_login/usuario_login/provider_session.dart, ../20_var_globales/var_elementos_menus.dart
**Widgets/Componentes usados:** *(ninguno detectado)*
**Notas:** *(pendiente revisión manual)*

## 05_provider_menus/provider_menu_tipo_de_transaccion.dart
**Tipo:** Provider
**Clases:** ElementosDelMenuTipoDePublicacion, ClaseMenuTipoDePublicacion
**Variables top-level:** menuTipoDeTransaccionProvider
**Variables por clase:**
- ElementosDelMenuTipoDePublicacion: int index, String etiqueta, IconData icono, TabController tabControllerMenuTipoDePublicacion, int seleccionMenuTipoDePublicacion
- ClaseMenuTipoDePublicacion: *(sin campos detectados)*
**Dependencias (imports del proyecto):** ../20_var_globales/var_elementos_menus.dart
**Widgets/Componentes usados:** *(ninguno detectado)*
**Notas:** *(pendiente revisión manual)*

## 05_provider_menus/provider_menu_tipo_espacio.dart
**Tipo:** Provider
**Clases:** ElementosDelMenuTipoEspacios, ClaseMenuTipoEspacio
**Variables top-level:** menuTipoEspaciosProvider
**Variables por clase:**
- ElementosDelMenuTipoEspacios: int index, String etiqueta, IconData icono, TabController tabControllerMenuTipoEspacios, int seleccionMenuTipoEspacios
- ClaseMenuTipoEspacio: *(sin campos detectados)*
**Dependencias (imports del proyecto):** ../20_var_globales/var_elementos_menus.dart
**Widgets/Componentes usados:** *(ninguno detectado)*
**Notas:** *(pendiente revisión manual)*

## 05_provider_menus/provider_menu_tu_cuenta.dart
**Tipo:** Provider
**Clases:** ElementosDelMenuTuCuenta, ClaseMenuTuCuenta
**Variables top-level:** menuTuCuentaProvider
**Variables por clase:**
- ElementosDelMenuTuCuenta: int index, String etiqueta, IconData icono, TabController tabControllerMenuTuCuenta, int seleccionMenuTuCuenta
- ClaseMenuTuCuenta: *(sin campos detectados)*
**Dependencias (imports del proyecto):** ../20_var_globales/var_elementos_menus.dart
**Widgets/Componentes usados:** *(ninguno detectado)*
**Notas:** *(pendiente revisión manual)*

## 05_provider_menus/provider_menu_tu_cuenta_usuario.dart
**Tipo:** Provider
**Clases:** ElementosDelMenuTuCuentaUsuario, ClaseMenuTuCuentaUsuario
**Variables top-level:** menuTuCuentaUsuarioProvider
**Variables por clase:**
- ElementosDelMenuTuCuentaUsuario: int index, String etiqueta, IconData icono, int seleccionMenuTuCuentaUsuario
- ClaseMenuTuCuentaUsuario: *(sin campos detectados)*
**Dependencias (imports del proyecto):** ../20_var_globales/var_elementos_menus.dart
**Widgets/Componentes usados:** *(ninguno detectado)*
**Notas:** *(pendiente revisión manual)*

## 05_provider_menus/variables_menus.dart
**Tipo:** Utilidad
**Clases:** *(ninguna)*
**Variables top-level:** *(ninguna)*
**Variables por clase:**
*(ninguna)*
**Dependencias (imports del proyecto):** *(ninguna)*
**Widgets/Componentes usados:** *(ninguno detectado)*
**Notas:** *(pendiente revisión manual)*

## 07_routes

## 07_routes/app_routes.dart
**Tipo:** Rutas
**Clases:** AppRoutes
**Variables top-level:** PrincipalSliversMenuInicial, PaginaDetectaPlataforma, PageSolicitarRecuperacion, args
**Variables por clase:**
- AppRoutes: const main, const home, const splash, const login, const principal, const plataforma, const opciones, const sinconeccion, const checaconeccion, const loginuser, const registro, const listalocalidades, const localidades, const localidad, const editaespacio, const perfil, const preferencias, const gestionavatar, const compraespacios, const carouselfotospropiedad, const gestionfotopropiedad, const agregafotopropiedad, const fotospropiedad, const catalogotipotransaccion, const filtrapropiedades, const buscapropiedades, const generadatapropiedades, const generadatausuarios, const generadatapromotores, const gestionfotoscasa, const fotospropiedadpaginada, const fotospropiedadminiaturas, const fotosagregafotoalista, const agregamultiplesfotos, const mapapropiedades, const listaspropiedades, const solicitarRecuperacion, const cambioPassword
**Dependencias (imports del proyecto):** ../01_splash_screen/splash_page.dart, ../02_principal_screen/principal_sliver_screen_menus_inicio.dart, ../03_listas/pagina_mis_listas.dart, ../08_pantallas/tu_cuenta/tus_espacios/compra_espacios/form_compra_espacios.dart, ../08_pantallas/tu_cuenta/tus_espacios/form_update_espacio_comprado.dart, ../04_provider/pagina_colores.dart, ../08_pantallas/perfil/pagina_perfil.dart, ../08_pantallas/ubicacion/pagina_busca_localidades_gmaps.dart, ../14_geolocalizacion/google_map_mapa_propiedades.dart, ../22_imagenes/tus_espacios_fotos_propiedad/manejo_de_fotos/fotos_de_la_propiedad/pagina_agrega_multiples_fotos.dart, ../22_imagenes/tus_espacios_fotos_propiedad/manejo_de_fotos/opciones_menu_fotos/pagina_lista_fotos_listado.dart, ../22_imagenes/tus_espacios_fotos_propiedad/manejo_de_fotos/opciones_menu_fotos/pagina_lista_fotos_carousel.dart, ../10_user_login/usuario_login/login_03_form_register_user.dart, ../10_user_login/usuario_login/page_solicitar_recuperacion.dart, ../10_user_login/usuario_login/page_cambio_password.dart, ../10_user_login/avatar/manejo_imagenes_avatar.dart, ../22_imagenes/tus_espacios_fotos_propiedad/manejo_de_fotos/opciones_menu_fotos/pagina_fotos_menu_opciones.dart, ../41_connectivity/connectivitycheck_provider.dart, ../41_connectivity/pagina_sin_coneccion.dart, ../42_sistema_operativo/detecta_os.dart, ../08_pantallas/ubicacion/screen_maestro_localidades.dart, ../60_global_widgets/debugprint.dart
**Widgets/Componentes usados:** *(ninguno detectado)*
**Notas:** *(pendiente revisión manual)*

## 07_routes/deep_link_handler.dart
**Tipo:** Utilidad
**Clases:** *(ninguna)*
**Variables top-level:** uri, appLinks, token, perfil
**Variables por clase:**
*(ninguna)*
**Dependencias (imports del proyecto):** app_routes.dart
**Widgets/Componentes usados:** *(ninguno detectado)*
**Notas:** *(pendiente revisión manual)*

## 07_routes/pagina_route_error.dart
**Tipo:** Rutas
**Clases:** PaginaDeError
**Variables top-level:** *(ninguna)*
**Variables por clase:**
- PaginaDeError: String letrero
**Dependencias (imports del proyecto):** ../20_var_globales/var_color_themes.dart, ../60_global_widgets/debugprint.dart
**Widgets/Componentes usados:** AppBar, Center, Column, ElevatedButton, Scaffold, SizedBox, StatelessWidget, Text
**Notas:** *(pendiente revisión manual)*

## 07_routes/routes_parameters.dart
**Tipo:** Rutas
**Clases:** ResultadoGuardaFoto, ResultSaveFoto, ArgumentsLocalidad, ArgumentsListaLocalidad
**Variables top-level:** *(ninguna)*
**Variables por clase:**
- ResultadoGuardaFoto: int statusCode, String idFoto
- ResultSaveFoto: ResultadoGuardaFoto resultadoEnFotos, int resultadoEnEspacios
- ArgumentsLocalidad: int cp
- ArgumentsListaLocalidad: FindLocalidadXcp listaLocalidades, int cp
**Dependencias (imports del proyecto):** ../08_pantallas/inicio/data_espacios_casas.dart, ../08_pantallas/inicio/data_espacios_casas_get.dart, ../08_pantallas/ubicacion/data_sepomex_localidades.dart, ../08_pantallas/ubicacion/data_localidad_find.dart
**Widgets/Componentes usados:** *(ninguno detectado)*
**Notas:** *(pendiente revisión manual)*

## 08_pantallas

## 08_pantallas/inicio/catalogo_otras_caracteristicas.dart
**Tipo:** Utilidad
**Clases:** *(ninguna)*
**Variables top-level:** *(ninguna)*
**Variables por clase:**
*(ninguna)*
**Dependencias (imports del proyecto):** *(ninguna)*
**Widgets/Componentes usados:** *(ninguno detectado)*
**Notas:** *(pendiente revisión manual)*

## 08_pantallas/inicio/clase_busqueda_estado.dart
**Tipo:** Utilidad
**Clases:** BusquedaPaginacion, SearchTerm
**Variables top-level:** *(ninguna)*
**Variables por clase:**
- BusquedaPaginacion: *(sin campos detectados)*
- SearchTerm: *(sin campos detectados)*
**Dependencias (imports del proyecto):** *(ninguna)*
**Widgets/Componentes usados:** *(ninguno detectado)*
**Notas:** *(pendiente revisión manual)*

## 08_pantallas/inicio/data_count_view_documentos.dart
**Tipo:** Modelo de datos
**Clases:** CountViewDoctos, RowCountViewDoctos
**Variables top-level:** *(ninguna)*
**Variables por clase:**
- CountViewDoctos: *(sin campos detectados)*
- RowCountViewDoctos: dynamic key, int value
**Dependencias (imports del proyecto):** *(ninguna)*
**Widgets/Componentes usados:** *(ninguno detectado)*
**Notas:** *(pendiente revisión manual)*

## 08_pantallas/inicio/data_espacios_casas.dart
**Tipo:** Modelo de datos
**Clases:** EspaciosCasa, Datosadicionalescasa, Datosdelcontactocasa, Fechadecasa, Ubicacioncasa
**Variables top-level:** *(ninguna)*
**Variables por clase:**
- EspaciosCasa: String versiondelformato, String idPropiedad, String clavedelapropiedad, String idusuario, String tipodeanuncio, String tipodepropiedad, String tipodetransaccion, String idTransaccion, String nombredelapropiedad, String inmobiliaria, String inmobiliariaimagen, String linkinmobiliaria, String sloganinmobiliaria, String ubicaciongeneral, String descripcion, String letreropromocional, String metrosdeterreno, String metrosconstruidos, String recamaras, String banos, String mediosbanos, String cuartosdeservicio, String estacionamientos, String estacionamientoscubiertos, Datosadicionalescasa datosadicionalescasa, String elementosadicionalescasa, String precioventa, String preciorenta, String mantenimiento, String moneda, String niveldeprioridad, String condicionesdeventa, String fotoprincipal, String numerodefotos, String linkvideo, Datosdelcontactocasa datosdelcontactocasa, Ubicacioncasa ubicacioncasa, Fechadecasa fechadepublicacioncasa, Fechadecasa fechadecierrecasa, int activa, String timestampcasa
- Datosadicionalescasa: String panelessolares, String jardin, String alberca, String calefaccion, String aireacondicionado, String seguridad, String enfraccionamiento, String casasenelconjunto, String casaclub, String salondeeventos, String centrodenegocios, String gimnacio, String cisterna, String almacenamientodeagua, String tratamientodeaguas, String otrascaracteristicas
- Datosdelcontactocasa: String nombre, String empresa, String imgendeempresa, String numerocelular, String numerootro, String numeroinmobiliaria, String correoelectronico, String idusuariocontacto, String nombreusuariocontacto, String imgendelcontacto
- Fechadecasa: int dia, int mes, int anio
- Ubicacioncasa: String pais, LocalidadCp localidadCp, String calle, String numeroexterior, String numerointerior, String entrecalle01, String entrecalle02, String latitud, String longitud, String latitudDecimal, String longitudDecimal
**Dependencias (imports del proyecto):** ../ubicacion/data_sepomex_localidades.dart
**Widgets/Componentes usados:** *(ninguno detectado)*
**Notas:** *(pendiente revisión manual)*

## 08_pantallas/inicio/data_espacios_casas_get.dart
**Tipo:** Modelo de datos
**Clases:** EspaciosCasaGet, RowEspaciosCasaGet, ValueEspaciosCasaGet
**Variables top-level:** *(ninguna)*
**Variables por clase:**
- EspaciosCasaGet: int totalRows, int offset
- RowEspaciosCasaGet: String id, String key, ValueEspaciosCasaGet value
- ValueEspaciosCasaGet: String id, String rev, EspaciosCasa espacioscasa
**Dependencias (imports del proyecto):** data_espacios_casas.dart
**Widgets/Componentes usados:** *(ninguno detectado)*
**Notas:** *(pendiente revisión manual)*

## 08_pantallas/inicio/data_get_valores_menus.dart
**Tipo:** Modelo de datos
**Clases:** VariablesViewQuery
**Variables top-level:** *(ninguna)*
**Variables por clase:**
- VariablesViewQuery: String etiquetaMenuPrincipal, String etiquetaNivelGobierno, String etiquetaTipoDeEspacio, String etiquetaTipoDeTransaccion, int codigoPostal, String queryMenuPrincipal, String queryNivelGobierno, String queryTipoDeEspacio, String queryTipoDeTransaccion
**Dependencias (imports del proyecto):** *(ninguna)*
**Widgets/Componentes usados:** *(ninguno detectado)*
**Notas:** *(pendiente revisión manual)*

## 08_pantallas/inicio/http_find_propiedades_10en10.dart
**Tipo:** Utilidad
**Clases:** *(ninguna)*
**Variables top-level:** tipoEspacio, dbName, busquedaJSON, headers, response, responseBody, findDocs, propiedadesAsync
**Variables por clase:**
*(ninguna)*
**Dependencias (imports del proyecto):** ../../../40_security/direccionip.dart, ../../05_provider_menus/provider_menu_tipo_espacio.dart, ../../40_security/urls_endpoints_espacios.dart, ../../60_global_widgets/debugprint.dart, data_espacios_casas_get.dart, ../propiedades/data_find_propiedades.dart, data_get_valores_menus.dart
**Widgets/Componentes usados:** Switch, Text
**Notas:** *(pendiente revisión manual)*

## 08_pantallas/inicio/http_view_count_filter_propiedades.dart
**Tipo:** Utilidad
**Clases:** *(ninguna)*
**Variables top-level:** myQuery, countAsync, menuPrincipalEtiqueta, nivelGobierno, isPrincipalTodos, isTransaccionTodas, fullUrl, String, response, responseBody, data, keyString, response, responseBody
**Variables por clase:**
*(ninguna)*
**Dependencias (imports del proyecto):** ../../../40_security/direccionip.dart, ../../02_principal_screen/principal_sliver_screen_menus_inicio.dart, ../../05_provider_menus/provider_menu_nivel_gobierno.dart, ../../05_provider_menus/provider_menu_principal.dart, ../../40_security/urls_endpoints_espacios.dart, ../../60_global_widgets/debugprint.dart, data_count_view_documentos.dart, data_get_valores_menus.dart
**Widgets/Componentes usados:** Text
**Notas:** *(pendiente revisión manual)*

## 08_pantallas/inicio/inicio_propiedades_providers.dart
**Tipo:** Utilidad
**Clases:** PaginacionBusqueda
**Variables top-level:** *(ninguna)*
**Variables por clase:**
- PaginacionBusqueda: *(sin campos detectados)*
**Dependencias (imports del proyecto):** ../../01_home/home_navigation_provider.dart, ../../02_principal_screen/principal_sliver_screen_menus_inicio.dart, ../../05_provider_menus/provider_menu_nivel_gobierno.dart, ../../05_provider_menus/provider_menu_principal.dart, ../../05_provider_menus/provider_menu_tipo_de_transaccion.dart, ../../05_provider_menus/provider_menu_tipo_espacio.dart, ../ubicacion/provider_localidades_del_cp.dart, ../../60_global_widgets/debugprint.dart, data_get_valores_menus.dart
**Widgets/Componentes usados:** *(ninguno detectado)*
**Notas:** *(pendiente revisión manual)*

## 08_pantallas/inicio/pagina_inicio_busca_espacios.dart
**Tipo:** Widget
**Clases:** PaginaBuscaEspacios, _PaginaBuscaEspaciosState
**Variables top-level:** TextEditingController
**Variables por clase:**
- PaginaBuscaEspacios: HomeState posicionNueva
- _PaginaBuscaEspaciosState: TextEditingController controllerSearch
**Dependencias (imports del proyecto):** ../../01_home/home_navigation_provider.dart, ../../02_principal_screen/principal_sliver_screen_menus_inicio.dart, ../../05_provider_menus/appbar_menu_tipo_transaccion_inferior.dart, ../../05_provider_menus/appbar_sliver_menu_nivel_gobierno.dart, ../../05_provider_menus/appbar_sliver_menu_tipo_espacio.dart, ../../05_provider_menus/dropdown_menu_principal_propiedades.dart, ../../05_provider_menus/provider_menu_principal.dart, ../../05_provider_menus/provider_menu_tipo_de_transaccion.dart, ../../05_provider_menus/variables_menus.dart, ../../07_routes/app_routes.dart, ../../20_var_globales/var_color_themes.dart, ../../20_var_globales/var_color_widget.dart, ../../22_imagenes/variables_imagenes.dart, ../../60_global_widgets/debugprint.dart, clase_busqueda_estado.dart, data_espacios_casas_get.dart, http_view_count_filter_propiedades.dart, inicio_propiedades_providers.dart, widget_wrap_modern_card.dart
**Widgets/Componentes usados:** Center, Column, Container, CustomScrollView, Expanded, FloatingActionButton, FutureBuilder, Icon, IconButton, Padding, Row, Scaffold, SizedBox, Text, Wrap
**Notas:** *(pendiente revisión manual)*

## 08_pantallas/inicio/widget_wrap_modern_card.dart
**Tipo:** Widget
**Clases:** WrapModernCardPropiedades, _MeGustaButton, _MeGustaButtonState
**Variables top-level:** *(ninguna)*
**Variables por clase:**
- WrapModernCardPropiedades: int index, EspaciosCasaGet listaSeleccionadas, double iconSizeBanner, double textSizeBanner, double espacioEntreDato
- _MeGustaButton: String propiedadId
- _MeGustaButtonState: bool _toggling
**Dependencias (imports del proyecto):** ../../02_principal_screen/principal_sliver_screen_menus_inicio.dart, ../../05_provider_menus/provider_menu_principal.dart, ../../10_user_login/usuario_login/dialogbox_login.dart, ../../10_user_login/usuario_login/provider_session.dart, ../../20_var_globales/var_color_themes.dart, ../../22_imagenes/inicio_fotos_usuario/pagina_carousel_fotos_usuario.dart, ../../22_imagenes/variables_imagenes.dart, ../../03_listas/provider_me_gusta.dart, ../../03_listas/provider_user_lists.dart, ../tu_cuenta/conocidos/provider_mensajes.dart, ../tu_cuenta/conocidos/providers/conocidos_notifier.dart, data_espacios_casas.dart
**Widgets/Componentes usados:** AlertDialog, Card, Column, ConsumerWidget, Container, ElevatedButton, Expanded, Icon, IconButton, InkWell, Padding, Row, SizedBox, Text, Wrap
**Notas:** *(pendiente revisión manual)*

## 08_pantallas/perfil/pagina_perfil.dart
**Tipo:** Widget
**Clases:** PaginaPerfilWidget, PaginaPerfilWidgetState
**Variables top-level:** Text, Text
**Variables por clase:**
- PaginaPerfilWidget: *(sin campos detectados)*
- PaginaPerfilWidgetState: final scaffoldPerfilKey, bool isUserLoggedIn
**Dependencias (imports del proyecto):** ../../01_home/home_navigation_provider.dart, ../../05_provider_menus/provider_menu_inicial.dart, ../../05_provider_menus/provider_menu_nivel_gobierno.dart, ../../05_provider_menus/provider_menu_principal.dart, ../../05_provider_menus/provider_menu_tipo_de_transaccion.dart, ../../10_user_login/usuario_login/provider_session.dart, ../../10_user_login/avatar/provider_get_avatar.dart, ../../07_routes/app_routes.dart, ../../10_user_login/usuario_login/dialogbox_login.dart, ../../60_global_widgets/future_builder_state_widgets.dart, ../../20_var_globales/var_color_themes.dart, ../../10_user_login/avatar/manejo_imagenes_avatar.dart, ../../20_var_globales/variables_globales.dart, ../../22_imagenes/variables_imagenes.dart, ../../60_global_widgets/bottom_fijo.dart, ../../60_global_widgets/debugprint.dart
**Widgets/Componentes usados:** AlertDialog, Center, CircleAvatar, Column, Container, Divider, ElevatedButton, Expanded, FutureBuilder, GestureDetector, Icon, Padding, Row, Scaffold, SizedBox, Stack, Text
**Notas:** *(pendiente revisión manual)*

## 08_pantallas/propiedades/data_find_propiedades.dart
**Tipo:** Modelo de datos
**Clases:** FindPropiedades, Doc
**Variables top-level:** *(ninguna)*
**Variables por clase:**
- FindPropiedades: String bookmark
- Doc: String id, String rev, EspaciosCasa espacioscasa
**Dependencias (imports del proyecto):** ../inicio/data_espacios_casas.dart
**Widgets/Componentes usados:** *(ninguno detectado)*
**Notas:** *(pendiente revisión manual)*

## 08_pantallas/propiedades/pagina_detalle_propiedad.dart
**Tipo:** Widget
**Clases:** PaginaDetalleWidget, PaginaDetalleWidgetState, _FotoItemWidget, _MeGustaButtonFicha
**Variables top-level:** *(ninguna)*
**Variables por clase:**
- PaginaDetalleWidget: ValueEspaciosCasaGet propiedad, GetIdsFotosUserProp listaIdsFotos
- PaginaDetalleWidgetState: final scaffoldDetalleKey, double iconSizeBanner, double textSizeBanner, double espacioEntreDato
- _FotoItemWidget: String idFoto
- _MeGustaButtonFicha: String propiedadId
**Dependencias (imports del proyecto):** ../../60_global_widgets/future_builder_state_widgets.dart, ../../20_var_globales/var_color_themes.dart, ../../20_var_globales/var_color_widget.dart, ../../22_imagenes/data_models/data_fotos_ordenadas.dart, ../../22_imagenes/tus_espacios_fotos_propiedad/manejo_de_fotos/futures_y_providers/http_funciones_gestion_foto.dart, ../../22_imagenes/tus_espacios_fotos_propiedad/manejo_de_fotos/futures_y_providers/future_get_fotos_by_idpr_orden.dart, ../../22_imagenes/tus_espacios_fotos_propiedad/manejo_de_fotos/lista_fotos_ordenadas/provider_get_lista_fotos_ordenadas.dart, ../../22_imagenes/tus_espacios_fotos_propiedad/manejo_de_fotos/lista_ids_fotos/data_fotos_get_ids_fotos_user_prop.dart, ../../22_imagenes/tus_espacios_fotos_propiedad/manejo_de_fotos/futures_y_providers/future_recupera_ids_fotos_propiedad.dart, ../../22_imagenes/variables_imagenes.dart, ../../60_global_widgets/debugprint.dart, ../inicio/data_espacios_casas.dart, ../inicio/data_espacios_casas_get.dart, ../../10_user_login/usuario_login/provider_session.dart, ../../10_user_login/usuario_login/dialogbox_login.dart, ../../03_listas/provider_me_gusta.dart, ../../03_listas/provider_user_lists.dart
**Widgets/Componentes usados:** Align, Center, Column, ConsumerWidget, Container, FutureBuilder, Icon, IconButton, InkWell, Padding, Row, SizedBox, StatelessWidget, Text, Wrap
**Notas:** *(pendiente revisión manual)*

## 08_pantallas/propiedades/pagina_detalle_propiedad_pdf.dart
**Tipo:** Página
**Clases:** PdfGeneratorService
**Variables top-level:** *(ninguna)*
**Variables por clase:**
- PdfGeneratorService: final pdf, final espacios, String clave, String nombreArchivo, final fontBase, final fontBold, final fontIcons, String base64, String base64, final font
**Dependencias (imports del proyecto):** ../../22_imagenes/tus_espacios_fotos_propiedad/manejo_de_fotos/futures_y_providers/http_funciones_gestion_foto.dart, ../inicio/data_espacios_casas_get.dart
**Widgets/Componentes usados:** Align, Center, Column, Container, Divider, FutureBuilder, Icon, Image, Row, SizedBox, Text, Wrap
**Notas:** *(pendiente revisión manual)*

## 08_pantallas/tu_cuenta/conocidos/conocidos_view.dart
**Tipo:** Widget
**Clases:** ConocidosView, _ConocidosViewState
**Variables top-level:** *(ninguna)*
**Variables por clase:**
- ConocidosView: String currentUserId, String currentUserName
- _ConocidosViewState: int _currentIndex
**Dependencias (imports del proyecto):** ../../../20_var_globales/var_color_themes.dart, ../../../20_var_globales/variables_globales.dart, page_mis_contactos.dart, page_invitaciones.dart, page_descubrir_usuarios.dart
**Widgets/Componentes usados:** Icon, NavigationBar, Scaffold, StatefulWidget
**Notas:** *(pendiente revisión manual)*

## 08_pantallas/tu_cuenta/conocidos/invitacion_model.dart
**Tipo:** Modelo de datos
**Clases:** InvitacionModel
**Variables top-level:** *(ninguna)*
**Variables por clase:**
- InvitacionModel: String id, String rev, String senderId, String senderName, String receiverId, String receiverName, String status, String timestamp
**Dependencias (imports del proyecto):** *(ninguna)*
**Widgets/Componentes usados:** *(ninguno detectado)*
**Notas:** *(pendiente revisión manual)*

## 08_pantallas/tu_cuenta/conocidos/mensaje_model.dart
**Tipo:** Modelo de datos
**Clases:** MensajeModel
**Variables top-level:** *(ninguna)*
**Variables por clase:**
- MensajeModel: String id, String rev, String senderId, String receiverId, String content, String timestamp, String tipo, String propiedadId, String listaCompartidaId
**Dependencias (imports del proyecto):** *(ninguna)*
**Widgets/Componentes usados:** *(ninguno detectado)*
**Notas:** *(pendiente revisión manual)*

## 08_pantallas/tu_cuenta/conocidos/models/conocido.dart
**Tipo:** Utilidad
**Clases:** Conocido
**Variables top-level:** *(ninguna)*
**Variables por clase:**
- Conocido: *(sin campos detectados)*
**Dependencias (imports del proyecto):** *(ninguna)*
**Widgets/Componentes usados:** *(ninguno detectado)*
**Notas:** *(pendiente revisión manual)*

## 08_pantallas/tu_cuenta/conocidos/page_chat_privado.dart
**Tipo:** Widget
**Clases:** PageChatPrivado, _PageChatPrivadoState, _BurbujaPropiedad, _BurbujaLista
**Variables top-level:** *(ninguna)*
**Variables por clase:**
- PageChatPrivado: String currentUserId, String targetUserId, String targetName
- _PageChatPrivadoState: final _textController
- _BurbujaPropiedad: String propiedadId, String nombre
- _BurbujaLista: String listaCompartidaId, String nombre
**Dependencias (imports del proyecto):** provider_mensajes.dart
**Widgets/Componentes usados:** Align, AppBar, Center, CircleAvatar, Column, Container, Expanded, Flexible, GestureDetector, Icon, IconButton, InputDecoration, ListView, Row, Scaffold, SizedBox, StatelessWidget, Text, TextField
**Notas:** *(pendiente revisión manual)*

## 08_pantallas/tu_cuenta/conocidos/page_descubrir_usuarios.dart
**Tipo:** Widget
**Clases:** PageDescubrirUsuarios
**Variables top-level:** *(ninguna)*
**Variables por clase:**
- PageDescubrirUsuarios: String currentUserId, String currentUserName
**Dependencias (imports del proyecto):** ../../../20_var_globales/var_color_themes.dart, ../../../20_var_globales/variables_globales.dart, providers/conocidos_notifier.dart, social_providers.dart
**Widgets/Componentes usados:** AppBar, Card, Center, CircleAvatar, ConsumerWidget, CustomScrollView, FilledButton, Icon, ListTile, Padding, Scaffold, Text
**Notas:** *(pendiente revisión manual)*

## 08_pantallas/tu_cuenta/conocidos/page_invitaciones.dart
**Tipo:** Widget
**Clases:** PageInvitaciones
**Variables top-level:** *(ninguna)*
**Variables por clase:**
- PageInvitaciones: String currentUserId
**Dependencias (imports del proyecto):** ../../../05_provider_menus/variables_menus.dart, ../../../20_var_globales/var_color_themes.dart, ../../../20_var_globales/variables_globales.dart, providers/conocidos_notifier.dart, models/conocido.dart
**Widgets/Componentes usados:** AppBar, Card, Center, CircleAvatar, ConsumerWidget, Icon, IconButton, ListTile, ListView, Row, Scaffold, TabBar, Text
**Notas:** *(pendiente revisión manual)*

## 08_pantallas/tu_cuenta/conocidos/page_mis_contactos.dart
**Tipo:** Widget
**Clases:** PageMisContactos, _PageMisContactosState
**Variables top-level:** *(ninguna)*
**Variables por clase:**
- PageMisContactos: String currentUserId
- _PageMisContactosState: *(sin campos detectados)*
**Dependencias (imports del proyecto):** ../../../20_var_globales/var_color_themes.dart, providers/conocidos_notifier.dart, page_chat_privado.dart, page_perfil_contacto.dart
**Widgets/Componentes usados:** Card, Center, CircleAvatar, Column, FilledButton, Icon, IconButton, ListTile, ListView, Row, Scaffold, SizedBox, Text
**Notas:** *(pendiente revisión manual)*

## 08_pantallas/tu_cuenta/conocidos/page_perfil_contacto.dart
**Tipo:** Widget
**Clases:** PagePerfilContacto
**Variables top-level:** propiedadesContactoProvider, url, body, response
**Variables por clase:**
- PagePerfilContacto: String contactoId, String contactoName
**Dependencias (imports del proyecto):** ../../../20_var_globales/var_color_themes.dart, ../../../20_var_globales/var_de_estilo_widgets.dart, ../../../40_security/direccionip.dart
**Widgets/Componentes usados:** Card, Center, CircleAvatar, Column, ConsumerWidget, Container, Divider, Expanded, GridView, Icon, Padding, Scaffold, SizedBox, Text
**Notas:** *(pendiente revisión manual)*

## 08_pantallas/tu_cuenta/conocidos/provider_mensajes.dart
**Tipo:** Provider
**Clases:** MensajesChatNotifier
**Variables top-level:** msg, response, mensajesChatProvider
**Variables por clase:**
- MensajesChatNotifier: final parts
**Dependencias (imports del proyecto):** ../../../40_security/direccionip.dart, ../../../60_global_widgets/debugprint.dart, mensaje_model.dart
**Widgets/Componentes usados:** ListView
**Notas:** *(pendiente revisión manual)*

## 08_pantallas/tu_cuenta/conocidos/providers/conocidos_notifier.dart
**Tipo:** Provider
**Clases:** ConocidosNotifier
**Variables top-level:** String, conocidosProvider, conocidosAceptadosProvider, invitacionesRecibidasProvider, invitacionesEnviadasProvider
**Variables por clase:**
- ConocidosNotifier: String _currentUserId
**Dependencias (imports del proyecto):** ../../../../40_security/direccionip.dart, ../../../../60_global_widgets/debugprint.dart, ../models/conocido.dart
**Widgets/Componentes usados:** *(ninguno detectado)*
**Notas:** *(pendiente revisión manual)*

## 08_pantallas/tu_cuenta/conocidos/social_providers.dart
**Tipo:** Provider
**Clases:** InvitacionesNotifier
**Variables top-level:** usersListProvider, url, body, response, data, usersPromotoresListProvider, url, body, response, data, chatProvider, currentUserId, targetUserId, url, body, response, data, List, msg, url, response
**Variables por clase:**
- InvitacionesNotifier: final _uuid
**Dependencias (imports del proyecto):** ../../../40_security/direccionip.dart, invitacion_model.dart, mensaje_model.dart
**Widgets/Componentes usados:** *(ninguno detectado)*
**Notas:** *(pendiente revisión manual)*

## 08_pantallas/tu_cuenta/grupos/grupos_view.dart
**Tipo:** Widget
**Clases:** GruposView, _GruposViewState
**Variables top-level:** *(ninguna)*
**Variables por clase:**
- GruposView: String currentUserId, String currentUserName
- _GruposViewState: int _currentIndex
**Dependencias (imports del proyecto):** ../../../20_var_globales/variables_globales.dart, page_descubrir_grupos.dart, page_invitaciones_grupo.dart, page_mis_grupos.dart, providers/grupos_invitaciones_provider.dart
**Widgets/Componentes usados:** Badge, Column, Expanded, Icon, NavigationBar, Text
**Notas:** *(pendiente revisión manual)*

## 08_pantallas/tu_cuenta/grupos/models/aviso_grupo_model.dart
**Tipo:** Modelo de datos
**Clases:** AvisoGrupoModel
**Variables top-level:** *(ninguna)*
**Variables por clase:**
- AvisoGrupoModel: String id, String rev, String grupoId, String autorId, String autorNombre, String contenido, String timestamp
**Dependencias (imports del proyecto):** *(ninguna)*
**Widgets/Componentes usados:** *(ninguno detectado)*
**Notas:** *(pendiente revisión manual)*

## 08_pantallas/tu_cuenta/grupos/models/grupo.dart
**Tipo:** Utilidad
**Clases:** MiembroGrupo, Grupo
**Variables top-level:** *(ninguna)*
**Variables por clase:**
- MiembroGrupo: *(sin campos detectados)*
- Grupo: *(sin campos detectados)*
**Dependencias (imports del proyecto):** *(ninguna)*
**Widgets/Componentes usados:** *(ninguno detectado)*
**Notas:** *(pendiente revisión manual)*

## 08_pantallas/tu_cuenta/grupos/models/grupo_model.dart
**Tipo:** Modelo de datos
**Clases:** GrupoModel, MiembroGrupoModel
**Variables top-level:** *(ninguna)*
**Variables por clase:**
- GrupoModel: String id, String rev, String creadorId, String creadorNombre, String nombre, String descripcion, String objetivo, String privacidad, String visibilidad, String participacion, String timestamp
- MiembroGrupoModel: String usuarioId, String usuarioNombre, String rol, String fechaIngreso
**Dependencias (imports del proyecto):** *(ninguna)*
**Widgets/Componentes usados:** *(ninguno detectado)*
**Notas:** *(pendiente revisión manual)*

## 08_pantallas/tu_cuenta/grupos/models/invitacion_grupo_model.dart
**Tipo:** Modelo de datos
**Clases:** InvitacionGrupoModel
**Variables top-level:** *(ninguna)*
**Variables por clase:**
- InvitacionGrupoModel: String id, String rev, String senderId, String senderName, String receiverId, String receiverName, String grupoId, String grupoNombre, String status, String timestamp, String timestampRespuesta
**Dependencias (imports del proyecto):** *(ninguna)*
**Widgets/Componentes usados:** *(ninguno detectado)*
**Notas:** *(pendiente revisión manual)*

## 08_pantallas/tu_cuenta/grupos/models/mensaje_grupo_model.dart
**Tipo:** Modelo de datos
**Clases:** MensajeGrupoModel
**Variables top-level:** *(ninguna)*
**Variables por clase:**
- MensajeGrupoModel: String id, String rev, String senderId, String senderName, String grupoId, String content, String timestamp, bool leido, String tipo, String propiedadId, String listaCompartidaId
**Dependencias (imports del proyecto):** *(ninguna)*
**Widgets/Componentes usados:** *(ninguno detectado)*
**Notas:** *(pendiente revisión manual)*

## 08_pantallas/tu_cuenta/grupos/models/publicacion_grupo_model.dart
**Tipo:** Modelo de datos
**Clases:** PublicacionGrupoModel
**Variables top-level:** *(ninguna)*
**Variables por clase:**
- PublicacionGrupoModel: String id, String rev, String grupoId, String propiedadId, String propiedadNombre, String tipodeespacio, String autorId, String autorNombre, String timestamp
**Dependencias (imports del proyecto):** *(ninguna)*
**Widgets/Componentes usados:** *(ninguno detectado)*
**Notas:** *(pendiente revisión manual)*

## 08_pantallas/tu_cuenta/grupos/page_chat_grupo.dart
**Tipo:** Widget
**Clases:** PageChatGrupo, _PageChatGrupoState, _BurbujaMensaje, _BurbujaPropiedad, _BurbujaLista, _BarraInput, ChatGrupoEmbebido, _ChatGrupoEmbebidoState
**Variables top-level:** *(ninguna)*
**Variables por clase:**
- PageChatGrupo: String grupoId, String grupoNombre, String currentUserId, String currentUserName
- _PageChatGrupoState: final _textController
- _BurbujaMensaje: MensajeGrupoModel msg
- _BurbujaPropiedad: String propiedadId, String nombre
- _BurbujaLista: String listaCompartidaId, String nombre
- _BarraInput: TextEditingController controller, VoidCallback onSend
- ChatGrupoEmbebido: String grupoId, String currentUserId, String currentUserName
- _ChatGrupoEmbebidoState: final _textController
**Dependencias (imports del proyecto):** models/mensaje_grupo_model.dart, providers/grupos_mensajes_provider.dart
**Widgets/Componentes usados:** Align, AppBar, Center, CircleAvatar, Column, Container, Expanded, Icon, IconButton, InputDecoration, ListView, Padding, Row, Scaffold, SizedBox, StatelessWidget, Text, TextField
**Notas:** *(pendiente revisión manual)*

## 08_pantallas/tu_cuenta/grupos/page_descubrir_grupos.dart
**Tipo:** Widget
**Clases:** PageDescubrirGrupos, _GrupoDescubrirCard
**Variables top-level:** *(ninguna)*
**Variables por clase:**
- PageDescubrirGrupos: String currentUserId, String currentUserName
- _GrupoDescubrirCard: GrupoModel grupo, String currentUserId, String currentUserName
**Dependencias (imports del proyecto):** ../../../20_var_globales/var_color_themes.dart, ../../../20_var_globales/variables_globales.dart, models/grupo_model.dart, page_detalle_grupo.dart, providers/grupos_invitaciones_provider.dart, providers/grupos_notifier.dart
**Widgets/Componentes usados:** AppBar, Card, Center, CircleAvatar, Column, ConsumerWidget, CustomScrollView, Expanded, FilledButton, Icon, IconButton, Padding, Row, Scaffold, SizedBox, Spacer, Text
**Notas:** *(pendiente revisión manual)*

## 08_pantallas/tu_cuenta/grupos/page_detalle_grupo.dart
**Tipo:** Widget
**Clases:** PageDetalleGrupo, _PageDetalleGrupoState, _TabPublicaciones, _TarjetaPublicacion, _TabMiembros, _TabAvisos, _TabAvisosState, _TarjetaAviso, _InfoRow
**Variables top-level:** *(ninguna)*
**Variables por clase:**
- PageDetalleGrupo: GrupoModel grupo, String currentUserId, String currentUserName
- _PageDetalleGrupoState: GrupoModel _grupo
- _TabPublicaciones: GrupoModel grupo, String currentUserId
- _TarjetaPublicacion: PublicacionGrupoModel pub, String currentUserId, String grupoId
- _TabMiembros: GrupoModel grupo, String currentUserId, bool esAdmin
- _TabAvisos: GrupoModel grupo, String currentUserId, String currentUserName
- _TabAvisosState: *(sin campos detectados)*
- _TarjetaAviso: AvisoGrupoModel aviso, String currentUserId, String grupoId
- _InfoRow: String label, String value
**Dependencias (imports del proyecto):** models/grupo_model.dart, page_chat_grupo.dart, providers/grupos_invitaciones_provider.dart, providers/publicaciones_grupo_provider.dart, providers/avisos_grupo_provider.dart, models/publicacion_grupo_model.dart, models/aviso_grupo_model.dart
**Widgets/Componentes usados:** AlertDialog, AppBar, Card, Center, Chip, CircleAvatar, Column, ConsumerWidget, Container, Dialog, ElevatedButton, Expanded, FloatingActionButton, FutureBuilder, GestureDetector, Icon, IconButton, InputDecoration, ListTile, ListView, Padding, Positioned, Row, Scaffold, SizedBox, Stack, StatelessWidget, TabBar, Text, TextButton, TextField
**Notas:** *(pendiente revisión manual)*

## 08_pantallas/tu_cuenta/grupos/page_invitaciones_grupo.dart
**Tipo:** Widget
**Clases:** PageInvitacionesGrupo, _PageInvitacionesGrupoState, _ListaInvitaciones, _InvitacionCard, _StatusBadge
**Variables top-level:** *(ninguna)*
**Variables por clase:**
- PageInvitacionesGrupo: String currentUserId, String currentUserName
- _PageInvitacionesGrupoState: *(sin campos detectados)*
- _ListaInvitaciones: bool isReceived, String currentUserId, String currentUserName
- _InvitacionCard: InvitacionGrupoModel inv, bool isReceived, String currentUserId, String currentUserName
- _StatusBadge: String status
**Dependencias (imports del proyecto):** ../../../20_var_globales/var_color_themes.dart, ../../../20_var_globales/variables_globales.dart, ../../../05_provider_menus/variables_menus.dart, models/grupo_model.dart, models/invitacion_grupo_model.dart, providers/grupos_invitaciones_provider.dart, providers/grupos_notifier.dart
**Widgets/Componentes usados:** AppBar, Badge, Card, Center, Chip, CircleAvatar, Column, ConsumerWidget, Expanded, FilledButton, Icon, IconButton, ListView, Padding, Row, Scaffold, SizedBox, StatelessWidget, TabBar, Text
**Notas:** *(pendiente revisión manual)*

## 08_pantallas/tu_cuenta/grupos/page_mis_grupos.dart
**Tipo:** Widget
**Clases:** PageMisGrupos, _PageMisGruposState, _GrupoCard
**Variables top-level:** *(ninguna)*
**Variables por clase:**
- PageMisGrupos: String currentUserId, String currentUserName
- _PageMisGruposState: *(sin campos detectados)*
- _GrupoCard: GrupoModel grupo, String currentUserId, String currentUserName
**Dependencias (imports del proyecto):** models/grupo_model.dart, page_detalle_grupo.dart, providers/grupos_notifier.dart
**Widgets/Componentes usados:** AlertDialog, Card, Center, Chip, CircleAvatar, Column, Container, ElevatedButton, Expanded, FilledButton, FloatingActionButton, Icon, InkWell, InputDecoration, ListView, Padding, Row, Scaffold, SizedBox, StatelessWidget, Text
**Notas:** *(pendiente revisión manual)*

## 08_pantallas/tu_cuenta/grupos/providers/avisos_grupo_provider.dart
**Tipo:** Provider
**Clases:** AvisosGrupoNotifier
**Variables top-level:** String, avisosGrupoProvider
**Variables por clase:**
- AvisosGrupoNotifier: String _grupoId
**Dependencias (imports del proyecto):** *(ninguna)*
**Widgets/Componentes usados:** *(ninguno detectado)*
**Notas:** *(pendiente revisión manual)*

## 08_pantallas/tu_cuenta/grupos/providers/grupos_invitaciones_provider.dart
**Tipo:** Provider
**Clases:** GruposInvitacionesNotifier
**Variables top-level:** String, gruposInvitacionesProvider, invitacionesGrupoRecibidasProvider, estado, invitacionesGrupoEnviadasProvider, estado, usuariosParaInvitarProvider, url, body, response, data, promotoresParaInvitarProvider, url, body, response, data
**Variables por clase:**
- GruposInvitacionesNotifier: final _uuid
**Dependencias (imports del proyecto):** *(ninguna)*
**Widgets/Componentes usados:** *(ninguno detectado)*
**Notas:** *(pendiente revisión manual)*

## 08_pantallas/tu_cuenta/grupos/providers/grupos_mensajes_provider.dart
**Tipo:** Provider
**Clases:** MensajesGrupoNotifier
**Variables top-level:** String, mensajesGrupoProvider
**Variables por clase:**
- MensajesGrupoNotifier: String _grupoId
**Dependencias (imports del proyecto):** *(ninguna)*
**Widgets/Componentes usados:** ListView
**Notas:** *(pendiente revisión manual)*

## 08_pantallas/tu_cuenta/grupos/providers/grupos_notifier.dart
**Tipo:** Provider
**Clases:** GruposNotifier
**Variables top-level:** String, gruposProvider, gruposPublicosProvider, url, body, response, data, docs
**Variables por clase:**
- GruposNotifier: *(sin campos detectados)*
**Dependencias (imports del proyecto):** *(ninguna)*
**Widgets/Componentes usados:** *(ninguno detectado)*
**Notas:** *(pendiente revisión manual)*

## 08_pantallas/tu_cuenta/grupos/providers/publicaciones_grupo_provider.dart
**Tipo:** Provider
**Clases:** PublicacionesGrupoNotifier
**Variables top-level:** String, int, publicacionesGrupoProvider
**Variables por clase:**
- PublicacionesGrupoNotifier: String _grupoId, int _skip, bool _hayMas
**Dependencias (imports del proyecto):** *(ninguna)*
**Widgets/Componentes usados:** *(ninguno detectado)*
**Notas:** *(pendiente revisión manual)*

## 08_pantallas/tu_cuenta/tus_espacios/compra_espacios/data_compra_espacios.dart
**Tipo:** Modelo de datos
**Clases:** CompraEspacio, FechaDe
**Variables top-level:** *(ninguna)*
**Variables por clase:**
- CompraEspacio: String versiondelformato, String idUsuario, String idTransaccion, int noDeEspaciosNormales, int noDeEspaciosDestacados, int noDeEspaciosSuperdestacados, int noDeEspaciosOportunidades, int noDeEspaciosRemates, FechaDe fechaDeCompra, FechaDe fechaDePago, String medioDePago, String referenciaDePago, int mesesContratados, String vencimiento, int vigente, double totalEspacioNormal, double totalEspacioDestacado, double totalEspacioSuperdestacado, double totalEspaciosOportunidades, double totalEspaciosRemates, double impuestos, double granTotal, String timestamp
- FechaDe: int dia, int mes, int anio
**Dependencias (imports del proyecto):** *(ninguna)*
**Widgets/Componentes usados:** *(ninguno detectado)*
**Notas:** *(pendiente revisión manual)*

## 08_pantallas/tu_cuenta/tus_espacios/compra_espacios/data_compra_espacios_get.dart
**Tipo:** Modelo de datos
**Clases:** CompraEspacioGet, RowCompraEspacio, ValueCompraEspacio
**Variables top-level:** *(ninguna)*
**Variables por clase:**
- CompraEspacioGet: int totalRows, int offset
- RowCompraEspacio: String id, String key, ValueCompraEspacio value
- ValueCompraEspacio: String id, String rev, CompraEspacio espacio
**Dependencias (imports del proyecto):** data_compra_espacios.dart
**Widgets/Componentes usados:** *(ninguno detectado)*
**Notas:** *(pendiente revisión manual)*

## 08_pantallas/tu_cuenta/tus_espacios/compra_espacios/form_compra_espacios.dart
**Tipo:** Widget
**Clases:** PaginaCompraEspacios, PaginaCompraEspaciosState
**Variables top-level:** compraEspaciosProvider
**Variables por clase:**
- PaginaCompraEspacios: *(sin campos detectados)*
- PaginaCompraEspaciosState: double alto, double ancho, double verticalWidth, String idUsuario
**Dependencias (imports del proyecto):** ../../../../10_user_login/usuario_login/provider_session.dart, ../../../../20_var_globales/couchdb_errors.dart, ../../../../60_global_widgets/debugprint.dart, ../../../../60_global_widgets/dialogbox_mensaje_general.dart, ../form_update_espacio_comprado.dart, provider_compra_espacios.dart, ../../../../20_var_globales/var_color_themes.dart, ../../../../20_var_globales/var_color_widget.dart, ../../../../20_var_globales/variables_globales.dart
**Widgets/Componentes usados:** AppBar, Center, Column, ElevatedButton, Form, Icon, IconButton, InputDecoration, Scaffold, SizedBox, Text, Wrap
**Notas:** *(pendiente revisión manual)*

## 08_pantallas/tu_cuenta/tus_espacios/compra_espacios/provider_compra_espacios.dart
**Tipo:** Provider
**Clases:** ClassCompraEspaciosNotifierProvider
**Variables top-level:** compraDeEspaciosProvider, getCompraEspaciosFutureProvider
**Variables por clase:**
- ClassCompraEspaciosNotifierProvider: *(sin campos detectados)*
**Dependencias (imports del proyecto):** ../../../../10_user_login/usuario_login/provider_session.dart, ../../../../40_security/direccionip.dart, ../../../../40_security/generate_hash.dart, ../../../../40_security/urls_endpoints_espacios.dart, ../../../ubicacion/data_sepomex_localidades.dart, ../../../../60_global_widgets/debugprint.dart, data_compra_espacios.dart, data_compra_espacios_get.dart, ../../../inicio/data_espacios_casas.dart
**Widgets/Componentes usados:** *(ninguno detectado)*
**Notas:** *(pendiente revisión manual)*

## 08_pantallas/tu_cuenta/tus_espacios/form_crea_ficha_captura_propiedad.dart
**Tipo:** Widget
**Clases:** ConceptoEspacioRow, UbicacionEspacioRow, CreaFichaCapturaPropiedad, _CreaFichaCapturaPropiedadState
**Variables top-level:** Text, Text, Text, Text, SizedBox
**Variables por clase:**
- ConceptoEspacioRow: int index, String concepto, String valor, int index, String concepto, String valor, int index, String concepto, String valor
- UbicacionEspacioRow: String concepto, String valor, String concepto, String valor, String concepto, String valor
- CreaFichaCapturaPropiedad: int indexListaPropiedad, ValueEspaciosCasaGet propiedad, dynamic update, int indexListaPropiedad, ValueEspaciosCasaGet propiedad, dynamic update, BuildContext context, WidgetRef ref, int indexListaPropiedad, ValueEspaciosCasaGet propiedad, dynamic update
- _CreaFichaCapturaPropiedadState: *(sin campos detectados)*
**Dependencias (imports del proyecto):** ../../../07_routes/app_routes.dart, ../../../60_global_widgets/future_builder_state_widgets.dart, ../../../20_var_globales/var_color_themes.dart, ../../../20_var_globales/variables_globales.dart, ../../../22_imagenes/tus_espacios_fotos_propiedad/manejo_de_fotos/futures_y_providers/http_funciones_gestion_foto.dart, ../../../22_imagenes/tus_espacios_fotos_propiedad/manejo_de_fotos/lista_ids_fotos/data_fotos_get_ids_fotos_user_prop.dart, ../../../22_imagenes/tus_espacios_fotos_propiedad/manejo_de_fotos/futures_y_providers/future_recupera_ids_fotos_propiedad.dart, ../../../22_imagenes/variables_imagenes.dart, ../../../60_global_widgets/debugprint.dart, ../../../60_global_widgets/dialogbox_mensaje_general.dart, ../../inicio/catalogo_otras_caracteristicas.dart, ../../propiedades/pagina_detalle_propiedad.dart, ../../widgets_comunes/widget_letrero_tipo_transaccion.dart, http_publica_propiedad.dart, provider_espacios_casa_get.dart
**Widgets/Componentes usados:** AlertDialog, Align, Card, Center, Column, Container, ElevatedButton, Expanded, ExpansionTile, FutureBuilder, GestureDetector, Icon, IconButton, InkWell, Padding, Row, SizedBox, Stack, StatelessWidget, Text
**Notas:** *(pendiente revisión manual)*

## 08_pantallas/tu_cuenta/tus_espacios/form_update_espacio_comprado.dart
**Tipo:** Widget
**Clases:** PaginaEditaEspacio, PaginaEditaEspacioState
**Variables top-level:** varEspaciosCasasGetProvider, varEspaciosCasasGetProvider, varEspaciosCasasGetProvider
**Variables por clase:**
- PaginaEditaEspacio: ValueEspaciosCasaGet propiedadParameter, ValueEspaciosCasaGet propiedadParameter, ValueEspaciosCasaGet propiedadParameter
- PaginaEditaEspacioState: TextEditingController celdaControllerPublicacion, int currentStep, double alto, double ancho, double verticalWidth, ValueEspaciosCasaGet propiedad, final formKeyEspacioComprado, String tipoDePropiedad, String tipoDeTransaccion, TextEditingController celdaControllerPublicacion, int currentStep, double alto, double ancho, double verticalWidth, ValueEspaciosCasaGet propiedad, final formKeyEspacioComprado, String tipoDePropiedad, String tipoDeTransaccion, TextEditingController celdaControllerPublicacion, int currentStep, double alto, double ancho, double verticalWidth, ValueEspaciosCasaGet propiedad, final formKeyEspacioComprado, String tipoDePropiedad, String tipoDeTransaccion
**Dependencias (imports del proyecto):** ../../../05_provider_menus/variables_menus.dart, ../../../60_global_widgets/debugprint.dart, ../../../60_global_widgets/dialogbox_mensaje_general.dart, ../../inicio/catalogo_otras_caracteristicas.dart, provider_espacios_casa_get.dart, ../../../20_var_globales/var_color_themes.dart, ../../../20_var_globales/var_color_widget.dart, ../../../20_var_globales/variables_globales.dart, tabla_tipopropiedad_vs_campos.dart
**Widgets/Componentes usados:** AppBar, Center, Checkbox, Column, Container, ElevatedButton, Form, Icon, IconButton, InputDecoration, Row, Scaffold, SizedBox, Text, Wrap
**Notas:** *(pendiente revisión manual)*

## 08_pantallas/tu_cuenta/tus_espacios/http_publica_propiedad.dart
**Tipo:** Utilidad
**Clases:** *(ninguna)*
**Variables top-level:** getResponse, responsePut, responseInsert, getResponse, response, responseInsert, responseInsert, getResponse, deleteResponse, getResponse, deleteResponse
**Variables por clase:**
*(ninguna)*
**Dependencias (imports del proyecto):** ../../../20_var_globales/couchdb_errors.dart, ../../../40_security/direccionip.dart, ../../../40_security/urls_endpoints_espacios.dart, ../../../60_global_widgets/debugprint.dart, ../../inicio/data_espacios_casas.dart, ../../inicio/data_espacios_casas_get.dart
**Widgets/Componentes usados:** Switch
**Notas:** *(pendiente revisión manual)*

## 08_pantallas/tu_cuenta/tus_espacios/pagina_tus_espacios.dart
**Tipo:** Widget
**Clases:** PaginaTusEspacios, PaginaTipoEspaciosState
**Variables top-level:** *(ninguna)*
**Variables por clase:**
- PaginaTusEspacios: *(sin campos detectados)*
- PaginaTipoEspaciosState: final scaffoldTipoEspacioKey
**Dependencias (imports del proyecto):** ../../../05_provider_menus/appbar_sliver_menu_tipo_espacio.dart, ../../../07_routes/app_routes.dart, ../../../10_user_login/usuario_login/dialogbox_login.dart, ../../../10_user_login/usuario_login/provider_session.dart, ../../../60_global_widgets/future_builder_state_widgets.dart, ../../../20_var_globales/var_color_themes.dart, ../../../20_var_globales/var_elementos_menus.dart, ../../../20_var_globales/variables_globales.dart, ../../../60_global_widgets/debugprint.dart, ../../../20_var_globales/var_color_widget.dart, ../../../05_provider_menus/provider_menu_tipo_espacio.dart, provider_espacios_casa_get.dart, form_crea_ficha_captura_propiedad.dart
**Widgets/Componentes usados:** Center, Column, Container, CustomScrollView, Expanded, FutureBuilder, GestureDetector, Icon, Row, Scaffold, SizedBox, SliverAppBar, Text, Wrap
**Notas:** *(pendiente revisión manual)*

## 08_pantallas/tu_cuenta/tus_espacios/provider_espacios_casa_get.dart
**Tipo:** Provider
**Clases:** ListaEspaciosCasa, ClassCompraEspaciosNotifierProvider
**Variables top-level:** espaciosCasaConListaFotosGetProvider, listaEspaciosCasaFutureProvider, espaciosCasaConListaFotosGetProvider, setEspaciosCasaFutureProvider, saveEspaciosCasaFutureProvider, listaEspaciosCasaFutureProvider
**Variables por clase:**
- ListaEspaciosCasa: int index, EspaciosCasaGet espaciosCasas, ListasFotosPropiedad listasFotos, int index, EspaciosCasaGet espaciosCasas, ListasFotosPropiedad listasFotos
- ClassCompraEspaciosNotifierProvider: *(sin campos detectados)*
**Dependencias (imports del proyecto):** ../../../10_user_login/usuario_login/provider_session.dart, ../../../20_var_globales/couchdb_errors.dart, ../../../22_imagenes/tus_espacios_fotos_propiedad/manejo_de_fotos/lista_fotos_ordenadas/clase_listas_fotos_propiedad.dart, ../../../40_security/direccionip.dart, ../../../40_security/urls_endpoints_espacios.dart, ../../../60_global_widgets/debugprint.dart, ../../inicio/data_espacios_casas_get.dart, ../../../05_provider_menus/provider_menu_tipo_espacio.dart, ../../inicio/catalogo_otras_caracteristicas.dart
**Widgets/Componentes usados:** *(ninguno detectado)*
**Notas:** *(pendiente revisión manual)*

## 08_pantallas/tu_cuenta/tus_espacios/tabla_tipopropiedad_vs_campos.dart
**Tipo:** Utilidad
**Clases:** *(ninguna)*
**Variables top-level:** *(ninguna)*
**Variables por clase:**
*(ninguna)*
**Dependencias (imports del proyecto):** *(ninguna)*
**Widgets/Componentes usados:** *(ninguno detectado)*
**Notas:** *(pendiente revisión manual)*

## 08_pantallas/ubicacion/data_localidad_find.dart
**Tipo:** Modelo de datos
**Clases:** FindLocalidadXcp, Doc
**Variables top-level:** *(ninguna)*
**Variables por clase:**
- FindLocalidadXcp: String bookmark
- Doc: LocalidadCp localidadCp
**Dependencias (imports del proyecto):** data_sepomex_localidades.dart
**Widgets/Componentes usados:** *(ninguno detectado)*
**Notas:** *(pendiente revisión manual)*

## 08_pantallas/ubicacion/data_sepomex_localidades.dart
**Tipo:** Modelo de datos
**Clases:** LocalidadCp
**Variables top-level:** *(ninguna)*
**Variables por clase:**
- LocalidadCp: *(sin campos detectados)*
**Dependencias (imports del proyecto):** *(ninguna)*
**Widgets/Componentes usados:** *(ninguno detectado)*
**Notas:** *(pendiente revisión manual)*

## 08_pantallas/ubicacion/data_sepomex_localidades_get_cp.dart
**Tipo:** Modelo de datos
**Clases:** LocalidadesGet, RowLocalidadesGet, ValueLocalidadesGet
**Variables top-level:** *(ninguna)*
**Variables por clase:**
- LocalidadesGet: int totalRows, int offset
- RowLocalidadesGet: String id, int key, ValueLocalidadesGet value
- ValueLocalidadesGet: String id, String rev, LocalidadCp localidadCp
**Dependencias (imports del proyecto):** data_sepomex_localidades.dart
**Widgets/Componentes usados:** *(ninguno detectado)*
**Notas:** *(pendiente revisión manual)*

## 08_pantallas/ubicacion/pagina_busca_localidades_gmaps.dart
**Tipo:** Widget
**Clases:** PaginaBuscaLocalidadGMaps, PaginaBuscaLocalidadGMapsState
**Variables top-level:** *(ninguna)*
**Variables por clase:**
- PaginaBuscaLocalidadGMaps: *(sin campos detectados)*
- PaginaBuscaLocalidadGMapsState: int valorActualProvider, String localidad
**Dependencias (imports del proyecto):** ../../02_principal_screen/principal_00_inicio.dart, ../../07_routes/app_routes.dart, ../../20_var_globales/var_color_themes.dart, provider_localidades_del_cp.dart, ../../60_global_widgets/debugprint.dart, ../../60_global_widgets/bottom_fijo.dart
**Widgets/Componentes usados:** AppBar, Center, Column, ConsumerWidget, Container, ElevatedButton, Form, InputDecoration, Scaffold, SizedBox, Text
**Notas:** *(pendiente revisión manual)*

## 08_pantallas/ubicacion/pagina_principal_localidades.dart
**Tipo:** Widget
**Clases:** PaginaPrincipalListaLocalidades, PaginaPrincipalListaLocalidadesState
**Variables top-level:** *(ninguna)*
**Variables por clase:**
- PaginaPrincipalListaLocalidades: *(sin campos detectados)*
- PaginaPrincipalListaLocalidadesState: final scaffoldListaLocalidadesKey
**Dependencias (imports del proyecto):** ../../07_routes/app_routes.dart, ../../10_user_login/usuario_login/dialogbox_login.dart, ../../10_user_login/usuario_login/provider_session.dart, ../../12_localidades_user/data_user_localidad.dart, ../../12_localidades_user/data_user_localidad_get.dart, ../../12_localidades_user/provider_get_localidades_usuario.dart, ../../20_var_globales/var_color_themes.dart, ../../20_var_globales/var_color_widget.dart, ../../20_var_globales/var_elementos_menus.dart, ../../20_var_globales/variables_globales.dart, ../../60_global_widgets/debugprint.dart, data_sepomex_localidades.dart, data_sepomex_localidades_get_cp.dart
**Widgets/Componentes usados:** AlertDialog, Card, Center, Column, Container, Expanded, GestureDetector, Icon, IconButton, ListTile, Padding, Row, Scaffold, SizedBox, Text, TextButton
**Notas:** *(pendiente revisión manual)*

## 08_pantallas/ubicacion/provider_localidades_del_cp.dart
**Tipo:** Provider
**Clases:** ListaDeLocalidadesDelCP, ClassLocalidadesNotifierProvider
**Variables top-level:** ListaDeLocalidadesDelCP, localidadesPorCodigoPostalProvider, getLocalidadesDelCPFutureProvider
**Variables por clase:**
- ListaDeLocalidadesDelCP: int codigoPostal, int localidadSeleccionada, LocalidadesGet localidades
- ClassLocalidadesNotifierProvider: *(sin campos detectados)*
**Dependencias (imports del proyecto):** data_sepomex_localidades.dart, data_sepomex_localidades_get_cp.dart, ../../../12_localidades_user/localidades_repository.dart
**Widgets/Componentes usados:** *(ninguno detectado)*
**Notas:** *(pendiente revisión manual)*

## 08_pantallas/ubicacion/screen_maestro_localidades.dart
**Tipo:** Widget
**Clases:** LocalidadesListScreen, LocalidadesListScreenState
**Variables top-level:** TextEditingController
**Variables por clase:**
- LocalidadesListScreen: int codigoP
- LocalidadesListScreenState: *(sin campos detectados)*
**Dependencias (imports del proyecto):** ../../07_routes/app_routes.dart, ../../10_user_login/usuario_login/provider_session.dart, ../../12_localidades_user/data_user_localidad.dart, ../../12_localidades_user/provider_get_localidades_usuario.dart, ../../20_var_globales/var_color_themes.dart, ../../20_var_globales/variables_globales.dart, ../../41_connectivity/pagina_sin_coneccion.dart, provider_localidades_del_cp.dart, ../../60_global_widgets/debugprint.dart, data_sepomex_localidades_get_cp.dart
**Widgets/Componentes usados:** AlertDialog, AppBar, Card, Center, Column, Container, ElevatedButton, Icon, ListTile, ListView, Padding, Scaffold, SizedBox, Text
**Notas:** *(pendiente revisión manual)*

## 08_pantallas/widgets_comunes/widget_letrero_tipo_transaccion.dart
**Tipo:** Utilidad
**Clases:** *(ninguna)*
**Variables top-level:** *(ninguna)*
**Variables por clase:**
*(ninguna)*
**Dependencias (imports del proyecto):** ../../20_var_globales/var_color_themes.dart
**Widgets/Componentes usados:** Text
**Notas:** *(pendiente revisión manual)*

## 10_user_login

## 10_user_login/avatar/data_user_avatar_get.dart
**Tipo:** Modelo de datos
**Clases:** GetUserAvatar, RowGetUserAvatar, ValueGetUserAvatar
**Variables top-level:** *(ninguna)*
**Variables por clase:**
- GetUserAvatar: int totalRows, int offset
- RowGetUserAvatar: String id, String key, ValueGetUserAvatar value
- ValueGetUserAvatar: String id, String rev, String idFoto, String idUsuario, String filaname, String path, int size, dynamic identifier, String avatar, String contentType, String timestamp
**Dependencias (imports del proyecto):** *(ninguna)*
**Widgets/Componentes usados:** *(ninguno detectado)*
**Notas:** *(pendiente revisión manual)*

## 10_user_login/avatar/manejo_imagenes_avatar.dart
**Tipo:** Widget
**Clases:** GestionAvatares, GestionAvataresState
**Variables top-level:** SizedBox, SizedBox, SizedBox
**Variables por clase:**
- GestionAvatares: *(sin campos detectados)*
- GestionAvataresState: PlatformFile platformFile, String filePath, String fileContent, String parametroUserID, Uint8List filesGet, PlatformFile platformFile, String filePath, String fileContent, String parametroUserID, Uint8List filesGet, PlatformFile platformFile, String filePath, String fileContent, String parametroUserID, Uint8List filesGet
**Dependencias (imports del proyecto):** ../../20_var_globales/couchdb_errors.dart, ../../60_global_widgets/debugprint.dart, ../../60_global_widgets/dialogbox_mensaje_general.dart, ../usuario_login/provider_session.dart, provider_get_avatar.dart, ../../20_var_globales/var_color_themes.dart
**Widgets/Componentes usados:** AppBar, Center, Column, Container, ElevatedButton, Icon, Image, InkWell, Scaffold, SizedBox, Text
**Notas:** *(pendiente revisión manual)*

## 10_user_login/avatar/provider_get_avatar.dart
**Tipo:** Provider
**Clases:** ClassUserAvatarNotifier
**Variables top-level:** GetUserAvatar, notifier
**Variables por clase:**
- ClassUserAvatarNotifier: *(sin campos detectados)*
**Dependencias (imports del proyecto):** ../../60_global_widgets/debugprint.dart, data_user_avatar_get.dart, ../../40_security/direccionip.dart, ../../40_security/generate_hash.dart
**Widgets/Componentes usados:** *(ninguno detectado)*
**Notas:** *(pendiente revisión manual)*

## 10_user_login/data_models/auth_state.dart
**Tipo:** Utilidad
**Clases:** AuthState
**Variables top-level:** *(ninguna)*
**Variables por clase:**
- AuthState: SessionData sessionUserData, GetIdUserPass initialIdUserPass, GetUserData userData, bool esUsuario, bool esPromotor, bool esPropietario, bool esAnfrition, bool esVendedor, bool esEspecialista, bool esProveedor, bool esAsociacion, bool esInmobiliaria, String nombrePerfil, bool isAuthenticated, bool isUserDataLoaded, String perfilActual, bool esUsuarioComprador, bool esUsuarioPromotor, bool esUsuarioEspecialista
**Dependencias (imports del proyecto):** ../../08_pantallas/ubicacion/data_sepomex_localidades.dart, ../usuario_login/data_session.dart, data_get_id_user_pass.dart, data_get_user.dart, data_user_promotor.dart, data_usuarios.dart
**Widgets/Componentes usados:** *(ninguno detectado)*
**Notas:** *(pendiente revisión manual)*

## 10_user_login/data_models/data_get_id_user_pass.dart
**Tipo:** Modelo de datos
**Clases:** GetIdUserPass, RowIdUserPass, ValueIdUserPass
**Variables top-level:** *(ninguna)*
**Variables por clase:**
- GetIdUserPass: int totalRows, int offset
- RowIdUserPass: String id, String key, ValueIdUserPass value
- ValueIdUserPass: String userId, String userName, String userPass, String idFoto
**Dependencias (imports del proyecto):** *(ninguna)*
**Widgets/Componentes usados:** *(ninguno detectado)*
**Notas:** *(pendiente revisión manual)*

## 10_user_login/data_models/data_get_user.dart
**Tipo:** Modelo de datos
**Clases:** GetUserData, RowGetUserData, ValueGetUserData
**Variables top-level:** *(ninguna)*
**Variables por clase:**
- GetUserData: int totalRows, int offset
- RowGetUserData: String id, String key, ValueGetUserData value
- ValueGetUserData: String id, String rev, Usuario usuario
**Dependencias (imports del proyecto):** data_usuarios.dart
**Widgets/Componentes usados:** *(ninguno detectado)*
**Notas:** *(pendiente revisión manual)*

## 10_user_login/data_models/data_user_promotor.dart
**Tipo:** Modelo de datos
**Clases:** UserDataPromotor
**Variables top-level:** *(ninguna)*
**Variables por clase:**
- UserDataPromotor: String tipodeusuario, String rfc, String numerodecliente, String inmobiliaria, int espacionormal, int espaciodestacados, int espaciosuperdestacados, int espaciosoportunidad, int espaciosremate
**Dependencias (imports del proyecto):** *(ninguna)*
**Widgets/Componentes usados:** *(ninguno detectado)*
**Notas:** *(pendiente revisión manual)*

## 10_user_login/data_models/data_usuarios.dart
**Tipo:** Modelo de datos
**Clases:** UserData, Usuario, FechaDeNacimiento, UbicacionUserData
**Variables top-level:** *(ninguna)*
**Variables por clase:**
- UserData: Usuario usuario
- Usuario: String idUsuario, String avatar, String nombres, String apellidopaterno, String apellidomaterno, String numerocelular, String correoelectronico, String nombreusuario, String claveacceso, UbicacionUserData ubicacionUserData, FechaDeNacimiento fechaDeNacimiento, String timestamp, UserDataPromotor datospromotor
- FechaDeNacimiento: int dia, int mes, int anio
- UbicacionUserData: String pais, LocalidadCp localidadCp, String calle, String seccionine, String latitud, String longitud, String latDecimal, String lonDecimal
**Dependencias (imports del proyecto):** ../../08_pantallas/ubicacion/data_sepomex_localidades.dart, data_user_promotor.dart
**Widgets/Componentes usados:** *(ninguno detectado)*
**Notas:** *(pendiente revisión manual)*

## 10_user_login/usuario_login/data_session.dart
**Tipo:** Modelo de datos
**Clases:** SessionData
**Variables top-level:** *(ninguna)*
**Variables por clase:**
- SessionData: String key, String varName, String valueToSave, String userId, String userName, String userPass, String esUsuarioComprador, String esUsuarioPromotor, String esUsuarioEspecialista, bool boolUsuarioComprador, bool boolUsuarioPromotor, bool boolUsuarioEspecialista
**Dependencias (imports del proyecto):** *(ninguna)*
**Widgets/Componentes usados:** *(ninguno detectado)*
**Notas:** *(pendiente revisión manual)*

## 10_user_login/usuario_login/dialogbox_login.dart
**Tipo:** Utilidad
**Clases:** *(ninguna)*
**Variables top-level:** *(ninguna)*
**Variables por clase:**
*(ninguna)*
**Dependencias (imports del proyecto):** ../../02_principal_screen/principal_00_inicio.dart, ../../20_var_globales/var_color_themes.dart, ../../60_global_widgets/dialogbox_mensaje_general.dart, login_01_login_page.dart, provider_session.dart
**Widgets/Componentes usados:** AlertDialog, ElevatedButton, SizedBox, Text
**Notas:** *(pendiente revisión manual)*

## 10_user_login/usuario_login/login_01_login_page.dart
**Tipo:** Widget
**Clases:** LoginPage, _LoginPageState, DropdownTipoUsuario, _DropdownTipoUsuarioState
**Variables top-level:** *(ninguna)*
**Variables por clase:**
- LoginPage: *(sin campos detectados)*
- _LoginPageState: bool _isLoading, final usernameController, final passwordController
- DropdownTipoUsuario: *(sin campos detectados)*
- _DropdownTipoUsuarioState: String _selectedValue
**Dependencias (imports del proyecto):** ../../05_provider_menus/provider_menu_inicial.dart, ../../07_routes/app_routes.dart, ../../20_var_globales/var_color_themes.dart, ../../40_security/generate_hash.dart, ../../60_global_widgets/debugprint.dart, ../../60_global_widgets/dialogbox_mensaje_general.dart, ../../60_global_widgets/bottom_fijo.dart, ../avatar/provider_get_avatar.dart, ../data_models/data_get_user.dart, provider_session.dart
**Widgets/Componentes usados:** Center, Column, GestureDetector, Icon, Image, InputDecoration, Scaffold, SizedBox, Text, TextButton
**Notas:** *(pendiente revisión manual)*

## 10_user_login/usuario_login/login_03_form_register_user.dart
**Tipo:** Widget
**Clases:** RegisterScreenUsers, RegisterScreenUsersState, CheckboxTerminoCondiciones, CheckboxTerminoCondicionesState
**Variables top-level:** *(ninguna)*
**Variables por clase:**
- RegisterScreenUsers: *(sin campos detectados)*
- RegisterScreenUsersState: String _validaclavedeacceso, String codigopostal, String rfc
- CheckboxTerminoCondiciones: WidgetRef ref
- CheckboxTerminoCondicionesState: *(sin campos detectados)*
**Dependencias (imports del proyecto):** ../../20_var_globales/couchdb_errors.dart, ../../20_var_globales/var_color_themes.dart, ../../20_var_globales/var_color_widget.dart, ../../20_var_globales/variables_globales.dart, ../../40_security/generate_hash.dart, ../../60_global_widgets/debugprint.dart, ../../60_global_widgets/dialogbox_mensaje_general.dart, ../../60_global_widgets/bottom_fijo.dart, provider_session.dart, textos_tc_ap.dart
**Widgets/Componentes usados:** AlertDialog, AppBar, Center, Checkbox, Column, Container, ElevatedButton, Expanded, Form, Icon, IconButton, InkWell, InputDecoration, Row, Scaffold, SizedBox, StatefulWidget, Text, TextButton, Wrap
**Notas:** *(pendiente revisión manual)*

## 10_user_login/usuario_login/page_cambio_password.dart
**Tipo:** Widget
**Clases:** PageCambioPassword, _PageCambioPasswordState
**Variables top-level:** *(ninguna)*
**Variables por clase:**
- PageCambioPassword: String token, String perfil
- _PageCambioPasswordState: final _formKey, final _passController, final _confirmController, bool _obscurePass, bool _obscureConfirm, bool _isLoading, bool _tokenValido
**Dependencias (imports del proyecto):** ../../07_routes/app_routes.dart, ../../20_var_globales/var_color_themes.dart, ../../60_global_widgets/dialogbox_mensaje_general.dart, password_recovery_repository.dart
**Widgets/Componentes usados:** AppBar, Center, Column, ElevatedButton, Expanded, Form, GestureDetector, Icon, IconButton, Image, InputDecoration, Row, Scaffold, SizedBox, Text
**Notas:** *(pendiente revisión manual)*

## 10_user_login/usuario_login/page_solicitar_recuperacion.dart
**Tipo:** Widget
**Clases:** PageSolicitarRecuperacion, _PageSolicitarRecuperacionState
**Variables top-level:** *(ninguna)*
**Variables por clase:**
- PageSolicitarRecuperacion: *(sin campos detectados)*
- _PageSolicitarRecuperacionState: final _formKey, final _correoController, String _perfilSeleccionado, bool _isLoading
**Dependencias (imports del proyecto):** ../../05_provider_menus/provider_menu_inicial.dart, ../../20_var_globales/var_color_themes.dart, ../../40_security/generate_reset_token.dart, ../../60_global_widgets/bottom_fijo.dart, ../../60_global_widgets/dialogbox_mensaje_general.dart, password_recovery_repository.dart
**Widgets/Componentes usados:** Align, AppBar, Center, Column, Form, GestureDetector, Icon, Image, InputDecoration, Scaffold, SizedBox, Text
**Notas:** *(pendiente revisión manual)*

## 10_user_login/usuario_login/password_recovery_repository.dart
**Tipo:** Repositorio/API
**Clases:** *(ninguna)*
**Variables top-level:** basicAuth, db, url, body, response, json, docs, doc, docId, rev, nombre, db, getUrl, getResp, doc, rev, usuario, putUrl, putResp, db, url, body, response, json, docs, doc, tokenExpiry, db, getUrl, getResp, doc, rev, usuario, putResp, String, response
**Variables por clase:**
*(ninguna)*
**Dependencias (imports del proyecto):** ../../40_security/direccionip.dart, ../../40_security/generate_reset_token.dart, ../../60_global_widgets/debugprint.dart
**Widgets/Componentes usados:** *(ninguno detectado)*
**Notas:** *(pendiente revisión manual)*

## 10_user_login/usuario_login/provider_session.dart
**Tipo:** Provider
**Clases:** SessionNotifier
**Variables top-level:** *(ninguna)*
**Variables por clase:**
- SessionNotifier: String basicAuth
**Dependencias (imports del proyecto):** ../../40_security/direccionip.dart, ../../08_pantallas/ubicacion/data_sepomex_localidades.dart, ../../60_global_widgets/debugprint.dart, ../data_models/data_get_user.dart, ../data_models/data_user_promotor.dart, ../data_models/data_usuarios.dart, ../data_models/data_get_id_user_pass.dart, ../data_models/auth_state.dart, data_session.dart, session_repository.dart, session_storage.dart
**Widgets/Componentes usados:** *(ninguno detectado)*
**Notas:** *(pendiente revisión manual)*

## 10_user_login/usuario_login/session_repository.dart
**Tipo:** Repositorio/API
**Clases:** SessionRepository
**Variables top-level:** *(ninguna)*
**Variables por clase:**
- SessionRepository: *(sin campos detectados)*
**Dependencias (imports del proyecto):** ../../40_security/direccionip.dart, ../../40_security/generate_hash.dart, ../../60_global_widgets/debugprint.dart, ../data_models/data_get_user.dart, ../data_models/data_get_id_user_pass.dart, ../data_models/data_usuarios.dart
**Widgets/Componentes usados:** *(ninguno detectado)*
**Notas:** *(pendiente revisión manual)*

## 10_user_login/usuario_login/session_storage.dart
**Tipo:** Utilidad/Sesión
**Clases:** SessionStorage, MobileSessionStorage, WebSessionStorage
**Variables top-level:** *(ninguna)*
**Variables por clase:**
- SessionStorage: *(sin campos detectados)*
- MobileSessionStorage: FlutterSecureStorage _storage
- WebSessionStorage: *(sin campos detectados)*
**Dependencias (imports del proyecto):** *(ninguna)*
**Widgets/Componentes usados:** *(ninguno detectado)*
**Notas:** *(pendiente revisión manual)*

## 10_user_login/usuario_login/textos_tc_ap.dart
**Tipo:** Utilidad/Textos
**Clases:** VisorTerminosWidget
**Variables top-level:** *(ninguna)*
**Variables por clase:**
- VisorTerminosWidget: *(sin campos detectados)*
**Dependencias (imports del proyecto):** *(ninguna)*
**Widgets/Componentes usados:** Container, Expanded, ListView, Padding, Row, SizedBox, StatelessWidget, Text
**Notas:** *(pendiente revisión manual)*

## 12_localidades_user

## 12_localidades_user/data_user_localidad.dart
**Tipo:** Modelo de datos
**Clases:** UsuarioLocalidades
**Variables top-level:** *(ninguna)*
**Variables por clase:**
- UsuarioLocalidades: *(sin campos detectados)*
**Dependencias (imports del proyecto):** ../08_pantallas/ubicacion/data_sepomex_localidades.dart
**Widgets/Componentes usados:** *(ninguno detectado)*
**Notas:** *(pendiente revisión manual)*

## 12_localidades_user/data_user_localidad_get.dart
**Tipo:** Modelo de datos
**Clases:** UsuarioLocalidadesGet, RowsUserLocal
**Variables top-level:** *(ninguna)*
**Variables por clase:**
- UsuarioLocalidadesGet: *(sin campos detectados)*
- RowsUserLocal: *(sin campos detectados)*
**Dependencias (imports del proyecto):** data_user_localidad.dart
**Widgets/Componentes usados:** *(ninguno detectado)*
**Notas:** *(pendiente revisión manual)*

## 12_localidades_user/localidades_repository.dart
**Tipo:** Repositorio/API
**Clases:** LocalidadesRepository
**Variables top-level:** localidadesRepositoryProvider
**Variables por clase:**
- LocalidadesRepository: final basicAuth
**Dependencias (imports del proyecto):** ../08_pantallas/ubicacion/data_sepomex_localidades_get_cp.dart, ../40_security/direccionip.dart, data_user_localidad.dart, data_user_localidad_get.dart
**Widgets/Componentes usados:** *(ninguno detectado)*
**Notas:** *(pendiente revisión manual)*

## 12_localidades_user/provider_get_localidades_usuario.dart
**Tipo:** Provider
**Clases:** ClassUserLocalNotifierProvider
**Variables top-level:** userLocalidadesProvider, getUserLocalidadesFutureProvider
**Variables por clase:**
- ClassUserLocalNotifierProvider: *(sin campos detectados)*
**Dependencias (imports del proyecto):** ../10_user_login/usuario_login/provider_session.dart, ../08_pantallas/ubicacion/data_sepomex_localidades.dart, ../08_pantallas/ubicacion/data_sepomex_localidades_get_cp.dart, data_user_localidad.dart, data_user_localidad_get.dart, localidades_repository.dart
**Widgets/Componentes usados:** *(ninguno detectado)*
**Notas:** *(pendiente revisión manual)*

## 14_geolocalizacion

## 14_geolocalizacion/app_keys.dart
**Tipo:** Configuración
**Clases:** MyApp, _MyAppState
**Variables top-level:** String, String
**Variables por clase:**
- MyApp: *(sin campos detectados)*
- _MyAppState: GoogleMapController mapController, LatLng _center
**Dependencias (imports del proyecto):** *(ninguna)*
**Widgets/Componentes usados:** AppBar, Icon, MaterialApp, Scaffold, StatefulWidget, Text
**Notas:** *(pendiente revisión manual)*

## 14_geolocalizacion/google_map_mapa_propiedades.dart
**Tipo:** Widget
**Clases:** PaginaMapaPropiedades, _PaginaMapaPropiedadesState
**Variables top-level:** *(ninguna)*
**Variables por clase:**
- PaginaMapaPropiedades: EspaciosCasaGet listaPropiedadesVar
- _PaginaMapaPropiedadesState: bool _isLoading, String nivelGobierno, double zoomLevel, String addressQuery, CameraPosition _kInitialPosition
**Dependencias (imports del proyecto):** ../05_provider_menus/provider_menu_nivel_gobierno.dart, ../08_pantallas/inicio/data_espacios_casas_get.dart, ../08_pantallas/ubicacion/provider_localidades_del_cp.dart, ../08_pantallas/ubicacion/data_sepomex_localidades.dart, ../20_var_globales/var_color_themes.dart, ../60_global_widgets/debugprint.dart
**Widgets/Componentes usados:** AppBar, Center, Column, Container, FloatingActionButton, Icon, Image, Padding, Scaffold, SizedBox, Stack, Text
**Notas:** *(pendiente revisión manual)*

## 14_geolocalizacion/google_map_place_data.dart
**Tipo:** Utilidad
**Clases:** GooglemapPlace, PlusCode, Result, AddressComponent, Geometry, Viewport, NortheastClass, NavigationPoint, NavigationPointLocation
**Variables top-level:** *(ninguna)*
**Variables por clase:**
- GooglemapPlace: PlusCode plusCode, String status
- PlusCode: String compoundCode, String globalCode
- Result: String formattedAddress, Geometry geometry, String placeId
- AddressComponent: String longName, String shortName
- Geometry: NortheastClass location, String locationType, Viewport viewport
- Viewport: NortheastClass northeast, NortheastClass southwest
- NortheastClass: double lat, double lng
- NavigationPoint: NavigationPointLocation location
- NavigationPointLocation: double latitude, double longitude
**Dependencias (imports del proyecto):** *(ninguna)*
**Widgets/Componentes usados:** *(ninguno detectado)*
**Notas:** *(pendiente revisión manual)*

## 14_geolocalizacion/provider_actual_place.dart
**Tipo:** Provider
**Clases:** DatosDeLaUbicacionActual, ClassLocalidadesNotifierProvider
**Variables top-level:** ubicacionActualProvider, getUbicacionActuaFuturelProvider, solicitaAccesoUbicacionFutureProvider
**Variables por clase:**
- DatosDeLaUbicacionActual: String postalCode, String addressGM, int permisodelocalizacion, String estadoDeLaConeccion, String resultadoPermisoUbicacion, double latitud, double longitud, String currentAddress, String actualAddress, bool setState, GooglemapPlace userLocation, CameraPosition posicionCamara, Position actualPosition, Placemark place
- ClassLocalidadesNotifierProvider: *(sin campos detectados)*
**Dependencias (imports del proyecto):** ../42_sistema_operativo/detecta_os.dart, ../08_pantallas/ubicacion/provider_localidades_del_cp.dart, ../60_global_widgets/debugprint.dart
**Widgets/Componentes usados:** *(ninguno detectado)*
**Notas:** *(pendiente revisión manual)*

## 20_var_globales

## 20_var_globales/couchdb_errors.dart
**Tipo:** Utilidad
**Clases:** CouchdbCodigo
**Variables top-level:** *(ninguna)*
**Variables por clase:**
- CouchdbCodigo: int codigo, String label, String description
**Dependencias (imports del proyecto):** *(ninguna)*
**Widgets/Componentes usados:** *(ninguno detectado)*
**Notas:** *(pendiente revisión manual)*

## 20_var_globales/format_chat_timestamp.dart
**Tipo:** Variables Globales
**Clases:** *(ninguna)*
**Variables top-level:** dt, now, today, messageDay, h, m
**Variables por clase:**
*(ninguna)*
**Dependencias (imports del proyecto):** *(ninguna)*
**Widgets/Componentes usados:** *(ninguno detectado)*
**Notas:** *(pendiente revisión manual)*

## 20_var_globales/ui_exceptions.dart
**Tipo:** Variables Globales
**Clases:** *(ninguna)*
**Variables top-level:** Color
**Variables por clase:**
*(ninguna)*
**Dependencias (imports del proyecto):** *(ninguna)*
**Widgets/Componentes usados:** *(ninguno detectado)*
**Notas:** *(pendiente revisión manual)*

## 20_var_globales/var_color_themes.dart
**Tipo:** Variables Globales
**Clases:** *(ninguna)*
**Variables top-level:** lightPAN, darkPAN, lightINE, darkINE, lightMC, darkMC, lightMOR, darkMOR, lightPRD, darkPRD, lightPRI, darkPRI, lightPT, darkPT, lightPVEM, darkPVEM, ColorScheme
**Variables por clase:**
*(ninguna)*
**Dependencias (imports del proyecto):** *(ninguna)*
**Widgets/Componentes usados:** *(ninguno detectado)*
**Notas:** *(pendiente revisión manual)*

## 20_var_globales/var_color_widget.dart
**Tipo:** Variables Globales
**Clases:** MyThemes
**Variables top-level:** colorIcono, colorOpcionMenu, colorAppBarIcono, colorNavRailIcono, colorNavRailIconoUn, colorIconoBarra, colorIconoBarraOff, primarioColor, fondoColor, colorTextoNormal, fondoColorCard, barraBotonesCard, colorIconoBarraInvertido, colorTextoOpcionBarra, colorIndicador, colorBotonOpciones, colorBotonVotar, colorLabel, screenWidth, screenHeight, double, double, double, double, double, double, double, double
**Variables por clase:**
- MyThemes: final darkTheme, final ligthTheme
**Dependencias (imports del proyecto):** *(ninguna)*
**Widgets/Componentes usados:** *(ninguno detectado)*
**Notas:** *(pendiente revisión manual)*

## 20_var_globales/var_de_estilo_widgets.dart
**Tipo:** Variables Globales
**Clases:** *(ninguna)*
**Variables top-level:** *(ninguna)*
**Variables por clase:**
*(ninguna)*
**Dependencias (imports del proyecto):** ../20_var_globales/variables_globales.dart, ../05_provider_menus/variables_menus.dart, var_color_themes.dart
**Widgets/Componentes usados:** AppBar, TabBar, Text
**Notas:** *(pendiente revisión manual)*

## 20_var_globales/var_elementos_menus.dart
**Tipo:** Variables Globales
**Clases:** ElementosMenus, ElementoSeleccionado
**Variables top-level:** *(ninguna)*
**Variables por clase:**
- ElementosMenus: String etiqueta, IconData icono
- ElementoSeleccionado: int index, String etiqueta, IconData icono
**Dependencias (imports del proyecto):** *(ninguna)*
**Widgets/Componentes usados:** *(ninguno detectado)*
**Notas:** *(pendiente revisión manual)*

## 20_var_globales/var_login.dart
**Tipo:** Variables Globales
**Clases:** *(ninguna)*
**Variables top-level:** *(ninguna)*
**Variables por clase:**
*(ninguna)*
**Dependencias (imports del proyecto):** *(ninguna)*
**Widgets/Componentes usados:** *(ninguno detectado)*
**Notas:** *(pendiente revisión manual)*

## 20_var_globales/variables_globales.dart
**Tipo:** Variables Globales
**Clases:** *(ninguna)*
**Variables top-level:** tabBarIndWeight, fontSizeMenuBar, iconSizeMenuBar, textoAlturaAppBar, textoAnchoAppBar, fontSizeCard, cardPadding, iconSizeFiltros, textSizeFiltros, boxHeightFiltros, boxWeigthFiltros
**Variables por clase:**
*(ninguna)*
**Dependencias (imports del proyecto):** *(ninguna)*
**Widgets/Componentes usados:** *(ninguno detectado)*
**Notas:** *(pendiente revisión manual)*

## 22_imagenes

## 22_imagenes/data_models/data_fotos_casa.dart
**Tipo:** Modelo de datos
**Clases:** FotosCasa, FotosCasaClass
**Variables top-level:** *(ninguna)*
**Variables por clase:**
- FotosCasa: FotosCasaClass fotosCasa
- FotosCasaClass: String idFoto, String idUsuario, String idPropiedad, String filaname, String path, int size, dynamic identifier, String foto, String contentType, String timestamp
**Dependencias (imports del proyecto):** *(ninguna)*
**Widgets/Componentes usados:** *(ninguno detectado)*
**Notas:** *(pendiente revisión manual)*

## 22_imagenes/data_models/data_fotos_casa_get.dart
**Tipo:** Modelo de datos
**Clases:** FotosCasaGet, RowFotosCasaGet, ValueFotosCasaGet
**Variables top-level:** *(ninguna)*
**Variables por clase:**
- FotosCasaGet: int totalRows, int offset
- RowFotosCasaGet: String id, String key, ValueFotosCasaGet value
- ValueFotosCasaGet: String id, String rev, FotosCasaClass fotosCasa
**Dependencias (imports del proyecto):** data_fotos_casa.dart
**Widgets/Componentes usados:** *(ninguno detectado)*
**Notas:** *(pendiente revisión manual)*

## 22_imagenes/data_models/data_fotos_casa_get_ids.dart
**Tipo:** Modelo de datos
**Clases:** FotosCasaGetIDs, RowFotosCasaGetIDs, ValueFotosCasaGetIDs
**Variables top-level:** *(ninguna)*
**Variables por clase:**
- FotosCasaGetIDs: int totalRows, int offset
- RowFotosCasaGetIDs: String id, ValueFotosCasaGetIDs value
- ValueFotosCasaGetIDs: String id, String rev, FotosCasaClass fotosCasa
**Dependencias (imports del proyecto):** data_fotos_casa.dart
**Widgets/Componentes usados:** *(ninguno detectado)*
**Notas:** *(pendiente revisión manual)*

## 22_imagenes/data_models/data_fotos_ordenadas.dart
**Tipo:** Modelo de datos
**Clases:** ListaFotosOrdenadas, FotosOrden
**Variables top-level:** *(ninguna)*
**Variables por clase:**
- ListaFotosOrdenadas: String idListaFotos, String idUsuario, String idPropiedad, String timestamp
- FotosOrden: int posicion, String idFoto
**Dependencias (imports del proyecto):** *(ninguna)*
**Widgets/Componentes usados:** *(ninguno detectado)*
**Notas:** *(pendiente revisión manual)*

## 22_imagenes/inicio_fotos_usuario/pagina_carousel_fotos_usuario.dart
**Tipo:** Widget
**Clases:** PaginaCarouselFotosUsuario, PaginaCarouselFotosUsuarioState
**Variables top-level:** *(ninguna)*
**Variables por clase:**
- PaginaCarouselFotosUsuario: ValueEspaciosCasaGet valueespaciosparameter
- PaginaCarouselFotosUsuarioState: final scaffoldKeyCarouselFotos, String idUsuario, String idPropiedad, String nombrePropiedad, String tipoDeEspacio, int indiceFotos, int numeroDeFotos, CarouselSliderController controllerCarousel, ValueEspaciosCasaGet propiedad, GetIdsFotosUserProp listaidsfotos, ListaFotosOrdenadas listaIdFotosOrden
**Dependencias (imports del proyecto):** ../../03_listas/lista_select_lista_save_propiedad.dart, ../../03_listas/page_compartir_con_grupo.dart, ../../03_listas/page_compartir_con_conocido.dart, ../../07_routes/app_routes.dart, ../../08_pantallas/propiedades/pagina_detalle_propiedad.dart, ../../10_user_login/usuario_login/provider_session.dart, ../../60_global_widgets/future_builder_state_widgets.dart, ../../60_global_widgets/debugprint.dart, ../tus_espacios_fotos_propiedad/manejo_de_fotos/futures_y_providers/future_get_fotos_by_idpr_orden.dart, ../tus_espacios_fotos_propiedad/manejo_de_fotos/lista_fotos_ordenadas/provider_get_lista_fotos_ordenadas.dart, ../tus_espacios_fotos_propiedad/manejo_de_fotos/lista_ids_fotos/data_fotos_get_ids_fotos_user_prop.dart, ../../20_var_globales/var_color_themes.dart, ../../20_var_globales/var_color_widget.dart, ../../08_pantallas/inicio/data_espacios_casas_get.dart, ../data_models/data_fotos_ordenadas.dart, ../tus_espacios_fotos_propiedad/manejo_de_fotos/futures_y_providers/http_funciones_gestion_foto.dart, ../tus_espacios_fotos_propiedad/manejo_de_fotos/futures_y_providers/future_recupera_ids_fotos_propiedad.dart, ../variables_imagenes.dart
**Widgets/Componentes usados:** Align, CarouselSlider, Center, Column, Container, Expanded, FutureBuilder, GestureDetector, Icon, IconButton, Padding, Row, Scaffold, SizedBox, Text
**Notas:** *(pendiente revisión manual)*

## 22_imagenes/inicio_fotos_usuario/pagina_carousel_fotos_usuario_mini.dart
**Tipo:** Widget
**Clases:** PaginaCarouselFotosMini, PaginaCarouselFotosMiniState
**Variables top-level:** *(ninguna)*
**Variables por clase:**
- PaginaCarouselFotosMini: ValueEspaciosCasaGet valueespaciosparameter, ValueEspaciosCasaGet valueespaciosparameter, String id, String rev, EspaciosCasa espacioscasa
- PaginaCarouselFotosMiniState: final scaffoldKeyCarouselFotos, String idUsuario, String idPropiedad, String nombrePropiedad, int indiceFotos, int numeroDeFotos, CarouselSliderController controllerCarousel, ValueEspaciosCasaGet propiedad, GetIdsFotosUserProp listaidsfotos, ListaFotosOrdenadas listaIdFotosOrden, final scaffoldKeyCarouselFotos, String idUsuario, String idPropiedad, String nombrePropiedad, int indiceFotos, int numeroDeFotos, String fotoprincipal, var controllerCarousel, ValueEspaciosCasaGet propiedad, GetIdsFotosUserProp listaIdFotos, GetIdsFotosUserProp listaidsfotos, ListaFotosOrdenadas listaIdFotosOrden
**Dependencias (imports del proyecto):** ../../07_routes/app_routes.dart, ../../08_pantallas/propiedades/pagina_detalle_propiedad.dart, ../../60_global_widgets/future_builder_state_widgets.dart, ../../60_global_widgets/debugprint.dart, ../tus_espacios_fotos_propiedad/manejo_de_fotos/futures_y_providers/future_get_fotos_by_idpr_orden.dart, ../tus_espacios_fotos_propiedad/manejo_de_fotos/lista_fotos_ordenadas/provider_get_lista_fotos_ordenadas.dart, ../tus_espacios_fotos_propiedad/manejo_de_fotos/lista_ids_fotos/data_fotos_get_ids_fotos_user_prop.dart, ../../20_var_globales/var_color_themes.dart, ../../20_var_globales/var_color_widget.dart, ../../08_pantallas/inicio/data_espacios_casas_get.dart, ../data_models/data_fotos_ordenadas.dart, ../tus_espacios_fotos_propiedad/manejo_de_fotos/futures_y_providers/http_funciones_gestion_foto.dart, ../tus_espacios_fotos_propiedad/manejo_de_fotos/futures_y_providers/future_recupera_ids_fotos_propiedad.dart
**Widgets/Componentes usados:** Align, CarouselSlider, Center, Column, Container, Expanded, FloatingActionButton, FutureBuilder, GestureDetector, Icon, IconButton, Padding, Positioned, Row, Scaffold, SizedBox, Text
**Notas:** *(pendiente revisión manual)*

## 22_imagenes/tus_espacios_fotos_propiedad/funciones_compress_image.dart
**Tipo:** Utilidad
**Clases:** *(ninguna)*
**Variables top-level:** result, bytes, newFile, result, list, originalImage, image, resized, result, File, Uint8List, img, img, Uint8List, result, result, result, list, originalImage, result, File, Uint8List, img, img, Uint8List, File, Uint8List, image, bytes, image, webpBytes, result
**Variables por clase:**
*(ninguna)*
**Dependencias (imports del proyecto):** ../../60_global_widgets/debugprint.dart
**Widgets/Componentes usados:** Image
**Notas:** *(pendiente revisión manual)*

## 22_imagenes/tus_espacios_fotos_propiedad/image_file_structure.dart
**Tipo:** Utilidad
**Clases:** PlatformFileNoFinal
**Variables top-level:** *(ninguna)*
**Variables por clase:**
- PlatformFileNoFinal: String path, String name, int size
**Dependencias (imports del proyecto):** *(ninguna)*
**Widgets/Componentes usados:** *(ninguno detectado)*
**Notas:** *(pendiente revisión manual)*

## 22_imagenes/tus_espacios_fotos_propiedad/manejo_de_fotos/datos_fotos/data_couchdb_post_return.dart
**Tipo:** Modelo de datos
**Clases:** CouchDbReturnValue
**Variables top-level:** *(ninguna)*
**Variables por clase:**
- CouchDbReturnValue: bool ok, String id, String rev
**Dependencias (imports del proyecto):** *(ninguna)*
**Widgets/Componentes usados:** *(ninguno detectado)*
**Notas:** *(pendiente revisión manual)*

## 22_imagenes/tus_espacios_fotos_propiedad/manejo_de_fotos/datos_fotos/data_cuenta_fotos.dart
**Tipo:** Modelo de datos
**Clases:** CuentaFotos, RowCuentaFotos
**Variables top-level:** *(ninguna)*
**Variables por clase:**
- CuentaFotos: *(sin campos detectados)*
- RowCuentaFotos: dynamic key, int value
**Dependencias (imports del proyecto):** *(ninguna)*
**Widgets/Componentes usados:** *(ninguno detectado)*
**Notas:** *(pendiente revisión manual)*

## 22_imagenes/tus_espacios_fotos_propiedad/manejo_de_fotos/datos_fotos/data_fotos_lista_fotos_iduser_idprop.dart
**Tipo:** Modelo de datos
**Clases:** ListaFotosIdsPropiedadGet, RowListaFotosIds, ValueListaFotosIds
**Variables top-level:** *(ninguna)*
**Variables por clase:**
- ListaFotosIdsPropiedadGet: int totalRows, int offset
- RowListaFotosIds: String id, ValueListaFotosIds value
- ValueListaFotosIds: String idUsuario, String idPropiedad, String idFoto
**Dependencias (imports del proyecto):** *(ninguna)*
**Widgets/Componentes usados:** *(ninguno detectado)*
**Notas:** *(pendiente revisión manual)*

## 22_imagenes/tus_espacios_fotos_propiedad/manejo_de_fotos/fotos_de_la_propiedad/pagina_agrega_multiples_fotos.dart
**Tipo:** Widget
**Clases:** AgregaMultiplesFotos, AgregaMultiplesFotosState
**Variables top-level:** *(ninguna)*
**Variables por clase:**
- AgregaMultiplesFotos: *(sin campos detectados)*
- AgregaMultiplesFotosState: String idUsuario, String idPropiedad, String idFoto, bool _isLoading, ValueEspaciosCasaGet propiedad, String seleccionada, bool principalbool, bool botonGuardaFotosActive, PlatformFile platformFile, String filePath, String fileContent, String idUsuario, String idPropiedad, String idFoto, ResultadoGuardaFoto resultadoGuardaFoto, ValueEspaciosCasaGet propiedad, String seleccionada, bool principalbool, FilePickerResult result, FotosCasaGet fotoCasa, bool botonGuardaFotosActive
**Dependencias (imports del proyecto):** ../../../../08_pantallas/inicio/data_espacios_casas.dart, ../../../../08_pantallas/inicio/data_espacios_casas_get.dart, ../../../../08_pantallas/ubicacion/data_sepomex_localidades.dart, ../../../../20_var_globales/var_color_themes.dart, ../../../../42_sistema_operativo/detecta_os.dart, ../../../../60_global_widgets/debugprint.dart, ../../../../60_global_widgets/dialogbox_mensaje_general.dart, ../../funciones_compress_image.dart, ../../image_file_structure.dart, ../futures_y_providers/http_funciones_gestion_foto.dart
**Widgets/Componentes usados:** AppBar, Center, Column, Container, ElevatedButton, Expanded, Icon, Padding, Row, Scaffold, SizedBox, Stack, Text, Wrap
**Notas:** *(pendiente revisión manual)*

## 22_imagenes/tus_espacios_fotos_propiedad/manejo_de_fotos/futures_y_providers/future_funciones_fotos.dart
**Tipo:** Utilidad
**Clases:** *(ninguna)*
**Variables top-level:** bool, SizedBox, SizedBox, listaFotosProvider, String, String, listaOrdenadaProvider, listaFotosOrden, seagregofoto, listaOrdenada, seagregofoto, listaOrdenada, Text, Text, seagregofoto, seagregofoto
**Variables por clase:**
*(ninguna)*
**Dependencias (imports del proyecto):** ../lista_fotos_ordenadas/future_update_fotos_orden.dart, ../lista_fotos_ordenadas/provider_get_lista_fotos_ordenadas.dart, http_funciones_gestion_foto.dart, provider_get_fotos_ids_user_propiedad.dart
**Widgets/Componentes usados:** AlertDialog, Column, Container, ElevatedButton, Expanded, SizedBox, Text
**Notas:** *(pendiente revisión manual)*

## 22_imagenes/tus_espacios_fotos_propiedad/manejo_de_fotos/futures_y_providers/future_get_fotos_by_idpr_orden.dart
**Tipo:** Utilidad
**Clases:** *(ninguna)*
**Variables top-level:** String, response, Map, String, response, Map, response
**Variables por clase:**
*(ninguna)*
**Dependencias (imports del proyecto):** ../../../../60_global_widgets/debugprint.dart, ../lista_fotos_ordenadas/data_fotos_ordenadas_get_idpropiedad.dart, ../lista_fotos_ordenadas/provider_get_lista_fotos_ordenadas.dart
**Widgets/Componentes usados:** *(ninguno detectado)*
**Notas:** *(pendiente revisión manual)*

## 22_imagenes/tus_espacios_fotos_propiedad/manejo_de_fotos/futures_y_providers/future_recupera_ids_fotos_propiedad.dart
**Tipo:** Utilidad
**Clases:** *(ninguna)*
**Variables top-level:** response, response
**Variables por clase:**
*(ninguna)*
**Dependencias (imports del proyecto):** ../../../../40_security/direccionip.dart, ../../../../60_global_widgets/debugprint.dart, ../lista_ids_fotos/data_fotos_get_ids_fotos_user_prop.dart
**Widgets/Componentes usados:** *(ninguno detectado)*
**Notas:** *(pendiente revisión manual)*

## 22_imagenes/tus_espacios_fotos_propiedad/manejo_de_fotos/futures_y_providers/http_funciones_gestion_foto.dart
**Tipo:** Utilidad
**Clases:** *(ninguna)*
**Variables top-level:** response, response, response, response, response, response, response, response, response, response, response, response, response, response, response, response, response, response
**Variables por clase:**
*(ninguna)*
**Dependencias (imports del proyecto):** ../../../../07_routes/routes_parameters.dart, ../../../../40_security/direccionip.dart, ../../../../40_security/generate_hash.dart, ../../../../60_global_widgets/debugprint.dart, ../../../data_models/data_fotos_casa_get.dart, ../../../data_models/data_fotos_casa_get_ids.dart, ../datos_fotos/data_cuenta_fotos.dart, ../../image_file_structure.dart, ../datos_fotos/data_fotos_lista_fotos_iduser_idprop.dart, provider_get_fotos_ids_user_propiedad.dart
**Widgets/Componentes usados:** *(ninguno detectado)*
**Notas:** *(pendiente revisión manual)*

## 22_imagenes/tus_espacios_fotos_propiedad/manejo_de_fotos/futures_y_providers/provider_get_fotos_ids_user_propiedad.dart
**Tipo:** Provider
**Clases:** ClassListaFotosCasaNotifierProvider
**Variables top-level:** getListaFotosCasaProviderId, getListaFotosCasaProviderId
**Variables por clase:**
- ClassListaFotosCasaNotifierProvider: *(sin campos detectados)*
**Dependencias (imports del proyecto):** ../../../../60_global_widgets/debugprint.dart, ../../../data_models/data_fotos_casa.dart, ../../../data_models/data_fotos_casa_get_ids.dart
**Widgets/Componentes usados:** *(ninguno detectado)*
**Notas:** *(pendiente revisión manual)*

## 22_imagenes/tus_espacios_fotos_propiedad/manejo_de_fotos/lista_fotos_ordenadas/clase_listas_fotos_propiedad.dart
**Tipo:** Utilidad
**Clases:** ListasFotosPropiedad
**Variables top-level:** *(ninguna)*
**Variables por clase:**
- ListasFotosPropiedad: String idPropiedad
**Dependencias (imports del proyecto):** data_fotos_ordenadas_get_idpropiedad.dart
**Widgets/Componentes usados:** *(ninguno detectado)*
**Notas:** *(pendiente revisión manual)*

## 22_imagenes/tus_espacios_fotos_propiedad/manejo_de_fotos/lista_fotos_ordenadas/data_fotos_ordenadas_get_idpropiedad.dart
**Tipo:** Modelo de datos
**Clases:** ListaFotosOrdenadasGetIdPropiedad, RowGetIdPropiedad, ValueGetIdPropiedad
**Variables top-level:** *(ninguna)*
**Variables por clase:**
- ListaFotosOrdenadasGetIdPropiedad: int totalRows, int offset
- RowGetIdPropiedad: String id, String key, ValueGetIdPropiedad value
- ValueGetIdPropiedad: String id, String rev, ListaFotosOrdenadas listadefotos
**Dependencias (imports del proyecto):** ../../../data_models/data_fotos_ordenadas.dart
**Widgets/Componentes usados:** *(ninguno detectado)*
**Notas:** *(pendiente revisión manual)*

## 22_imagenes/tus_espacios_fotos_propiedad/manejo_de_fotos/lista_fotos_ordenadas/future_put_fotos_orden.dart
**Tipo:** Utilidad
**Clases:** *(ninguna)*
**Variables top-level:** response, response
**Variables por clase:**
*(ninguna)*
**Dependencias (imports del proyecto):** ../../../../40_security/direccionip.dart, ../../../../40_security/generate_hash.dart, ../../../../60_global_widgets/debugprint.dart, ../../../data_models/data_fotos_ordenadas.dart, ../datos_fotos/data_couchdb_post_return.dart
**Widgets/Componentes usados:** *(ninguno detectado)*
**Notas:** *(pendiente revisión manual)*

## 22_imagenes/tus_espacios_fotos_propiedad/manejo_de_fotos/lista_fotos_ordenadas/future_update_fotos_orden.dart
**Tipo:** Utilidad
**Clases:** *(ninguna)*
**Variables top-level:** response, response
**Variables por clase:**
*(ninguna)*
**Dependencias (imports del proyecto):** ../../../../40_security/direccionip.dart, ../../../../40_security/generate_hash.dart, ../../../../60_global_widgets/debugprint.dart, data_fotos_ordenadas_get_idpropiedad.dart
**Widgets/Componentes usados:** *(ninguno detectado)*
**Notas:** *(pendiente revisión manual)*

## 22_imagenes/tus_espacios_fotos_propiedad/manejo_de_fotos/lista_fotos_ordenadas/provider_get_lista_fotos_ordenadas.dart
**Tipo:** Provider
**Clases:** ClassListaFotosCasaNotifierProvider
**Variables top-level:** getListaFotosOrdenadasProvider, getListaFotosOrdenadasProvider
**Variables por clase:**
- ClassListaFotosCasaNotifierProvider: *(sin campos detectados)*
**Dependencias (imports del proyecto):** ../../../../60_global_widgets/debugprint.dart, ../../../data_models/data_fotos_ordenadas.dart, data_fotos_ordenadas_get_idpropiedad.dart, ../futures_y_providers/provider_get_fotos_ids_user_propiedad.dart
**Widgets/Componentes usados:** *(ninguno detectado)*
**Notas:** *(pendiente revisión manual)*

## 22_imagenes/tus_espacios_fotos_propiedad/manejo_de_fotos/lista_ids_fotos/data_fotos_get_ids_fotos_user_prop.dart
**Tipo:** Modelo de datos
**Clases:** GetIdsFotosUserProp, RowIdsFotos
**Variables top-level:** *(ninguna)*
**Variables por clase:**
- GetIdsFotosUserProp: int totalRows, int offset
- RowIdsFotos: String id, String value
**Dependencias (imports del proyecto):** *(ninguna)*
**Widgets/Componentes usados:** *(ninguno detectado)*
**Notas:** *(pendiente revisión manual)*

## 22_imagenes/tus_espacios_fotos_propiedad/manejo_de_fotos/opciones_menu_fotos/pagina_fotos_menu_opciones.dart
**Tipo:** Widget
**Clases:** PaginaFotosPropiedad, PaginaFotosPropiedadState
**Variables top-level:** *(ninguna)*
**Variables por clase:**
- PaginaFotosPropiedad: ValueEspaciosCasaGet propiedad, ValueEspaciosCasaGet propiedad
- PaginaFotosPropiedadState: final scaffoldKeyFotosPropiedad, TabController tabControllerOpcionesFotos, String idUsuario, String idPropiedad, String idFoto, bool principalbool, final scaffoldKeyFotosPropiedad, TabController tabControllerOpcionesFotos, String idUsuario, String idPropiedad, String idFoto, bool principalbool
**Dependencias (imports del proyecto):** ../../../../../20_var_globales/var_color_themes.dart, ../../../../../20_var_globales/var_color_widget.dart, ../../../../../60_global_widgets/debugprint.dart, ../../../../08_pantallas/inicio/data_espacios_casas_get.dart, pagina_lista_fotos_cuadros.dart, pagina_lista_fotos_listado.dart, pagina_lista_fotos_carousel.dart
**Widgets/Componentes usados:** AppBar, Container, Icon, IconButton, Row, Scaffold, SizedBox, TabBar, Text
**Notas:** *(pendiente revisión manual)*

## 22_imagenes/tus_espacios_fotos_propiedad/manejo_de_fotos/opciones_menu_fotos/pagina_lista_fotos_carousel.dart
**Tipo:** Widget
**Clases:** PaginaCarouselFotosWidget, PaginaCarouselFotosWidgetState
**Variables top-level:** *(ninguna)*
**Variables por clase:**
- PaginaCarouselFotosWidget: ValueEspaciosCasaGet valueespaciosparameter, ValueEspaciosCasaGet valueespaciosparameter, String id, String rev, EspaciosCasa espacioscasa
- PaginaCarouselFotosWidgetState: final scaffoldKeyListaFotos, String idUsuario, String idPropiedad, String nombrePropiedad, int indiceFotos, int numeroDeFotos, CarouselSliderController controllerCarousel, ListaFotosOrdenadas listaIdFotosOrden, GetIdsFotosUserProp listaIdsCrudos, final scaffoldKeyListaFotos, String idUsuario, String idPropiedad, String nombrePropiedad, int indiceFotos, int numeroDeFotos, String fotoprincipal, var controllerCarousel
**Dependencias (imports del proyecto):** ../../../../07_routes/app_routes.dart, ../../../../60_global_widgets/future_builder_state_widgets.dart, ../../../../60_global_widgets/debugprint.dart, ../../../data_models/data_fotos_ordenadas.dart, ../../../variables_imagenes.dart, ../futures_y_providers/future_get_fotos_by_idpr_orden.dart, ../lista_fotos_ordenadas/provider_get_lista_fotos_ordenadas.dart, ../lista_ids_fotos/data_fotos_get_ids_fotos_user_prop.dart, ../../../../20_var_globales/var_color_themes.dart, ../../../../20_var_globales/var_color_widget.dart, ../../../../20_var_globales/variables_globales.dart, ../../../../08_pantallas/inicio/data_espacios_casas_get.dart, ../futures_y_providers/http_funciones_gestion_foto.dart, ../futures_y_providers/future_recupera_ids_fotos_propiedad.dart
**Widgets/Componentes usados:** AppBar, CarouselSlider, Center, Column, Container, ElevatedButton, FloatingActionButton, FutureBuilder, GestureDetector, Icon, IconButton, InkWell, Row, Scaffold, SizedBox, Slider, Text
**Notas:** *(pendiente revisión manual)*

## 22_imagenes/tus_espacios_fotos_propiedad/manejo_de_fotos/opciones_menu_fotos/pagina_lista_fotos_cuadros.dart
**Tipo:** Widget
**Clases:** PropiedadesMiniFotoListaPromotor, PropiedadesMiniFotoListaPromotorState
**Variables top-level:** scaffoldKeyMinisFotos, ValueEspaciosCasaGet, Future, Future, Future, providerFotos, target, fotoItem, base64String, SizedBox, scaffoldKeyMinisFotos, ValueEspaciosCasaGet, Future, Future, Future, EdgeInsetsGeometry, SizedBox
**Variables por clase:**
- PropiedadesMiniFotoListaPromotor: ValueEspaciosCasaGet valueespaciosparameter, ValueEspaciosCasaGet valueespaciosparameter
- PropiedadesMiniFotoListaPromotorState: *(sin campos detectados)*
**Dependencias (imports del proyecto):** ../../../../05_provider_menus/provider_menu_principal.dart, ../../../../07_routes/app_routes.dart, ../../../../07_routes/routes_parameters.dart, ../../../../08_pantallas/inicio/data_espacios_casas_get.dart, ../../../../60_global_widgets/future_builder_state_widgets.dart, ../../../../20_var_globales/var_color_themes.dart, ../../../../20_var_globales/var_color_widget.dart, ../../../../20_var_globales/var_elementos_menus.dart, ../../../../60_global_widgets/debugprint.dart, ../datos_fotos/data_cuenta_fotos.dart, ../lista_fotos_ordenadas/data_fotos_ordenadas_get_idpropiedad.dart, ../futures_y_providers/future_get_fotos_by_idpr_orden.dart, ../lista_fotos_ordenadas/provider_get_lista_fotos_ordenadas.dart, ../lista_ids_fotos/data_fotos_get_ids_fotos_user_prop.dart, ../../../data_models/data_fotos_ordenadas.dart, ../futures_y_providers/http_funciones_gestion_foto.dart, ../futures_y_providers/future_recupera_ids_fotos_propiedad.dart
**Widgets/Componentes usados:** AppBar, Center, Column, Container, ElevatedButton, Expanded, FutureBuilder, Icon, Padding, Row, Scaffold, SizedBox, Text, Wrap
**Notas:** *(pendiente revisión manual)*

## 22_imagenes/tus_espacios_fotos_propiedad/manejo_de_fotos/opciones_menu_fotos/pagina_lista_fotos_listado.dart
**Tipo:** Widget
**Clases:** PropiedadesListaFotosPromotor, PropiedadesListaFotosPromotorState, _FotoItemReorderable, _FotoItemReorderableState, _ImagenFotoLoader
**Variables top-level:** scaffoldKeyFootosPromotor, Future, getIdsData, fotoItem, providerOrden, fotosOrdenadas, item, SizedBox, SizedBox, rowExistente, scaffoldKeyFootosPromotor, Future, statusFotos, idFotoOrdenada, listaOrden, item, listaDefault, item, SizedBox, SizedBox, SizedBox, rowExistente, scaffoldKeyFootosPromotor, Future, Future, index, espacio, index, espacio, SizedBox, SizedBox, SizedBox, SizedBox, SizedBox
**Variables por clase:**
- PropiedadesListaFotosPromotor: ValueEspaciosCasaGet valueespaciosparameter, ValueEspaciosCasaGet valueespaciosparameter, ValueEspaciosCasaGet valueespaciosparameter
- PropiedadesListaFotosPromotorState: *(sin campos detectados)*
- _FotoItemReorderable: int index, String idFoto, VoidCallback onDelete, int index, String idFoto, VoidCallback onDelete
- _FotoItemReorderableState: *(sin campos detectados)*
- _ImagenFotoLoader: String idFoto
**Dependencias (imports del proyecto):** ../../../../05_provider_menus/provider_menu_principal.dart, ../../../../07_routes/routes_parameters.dart, ../../../../08_pantallas/inicio/data_espacios_casas_get.dart, ../../../../60_global_widgets/future_builder_state_widgets.dart, ../../../../20_var_globales/var_color_themes.dart, ../../../../20_var_globales/var_color_widget.dart, ../../../../20_var_globales/var_elementos_menus.dart, ../../../../20_var_globales/variables_globales.dart, ../../../../60_global_widgets/debugprint.dart, ../../../data_models/data_fotos_ordenadas.dart, ../../../variables_imagenes.dart, ../futures_y_providers/future_funciones_fotos.dart, ../futures_y_providers/future_recupera_ids_fotos_propiedad.dart, ../futures_y_providers/http_funciones_gestion_foto.dart, ../lista_fotos_ordenadas/data_fotos_ordenadas_get_idpropiedad.dart, ../futures_y_providers/future_get_fotos_by_idpr_orden.dart, ../lista_fotos_ordenadas/future_put_fotos_orden.dart, ../lista_fotos_ordenadas/future_update_fotos_orden.dart, ../lista_fotos_ordenadas/provider_get_lista_fotos_ordenadas.dart, ../lista_ids_fotos/data_fotos_get_ids_fotos_user_prop.dart
**Widgets/Componentes usados:** Align, AppBar, Center, CircleAvatar, Column, Container, ElevatedButton, Expanded, FloatingActionButton, FutureBuilder, Icon, IconButton, ListTile, Row, Scaffold, SizedBox, StatefulWidget, StatelessWidget, Text
**Notas:** *(pendiente revisión manual)*

## 22_imagenes/variables_imagenes.dart
**Tipo:** Utilidad
**Clases:** *(ninguna)*
**Variables top-level:** *(ninguna)*
**Variables por clase:**
*(ninguna)*
**Dependencias (imports del proyecto):** *(ninguna)*
**Widgets/Componentes usados:** *(ninguno detectado)*
**Notas:** *(pendiente revisión manual)*

## 40_security

## 40_security/direccionip.dart
**Tipo:** Variables Globales
**Clases:** *(ninguna)*
**Variables top-level:** String, String, String
**Variables por clase:**
*(ninguna)*
**Dependencias (imports del proyecto):** *(ninguna)*
**Widgets/Componentes usados:** *(ninguno detectado)*
**Notas:** *(pendiente revisión manual)*

## 40_security/encriptar.dart
**Tipo:** Variables Globales
**Clases:** *(ninguna)*
**Variables top-level:** String, String, String, cipherKey, encryptService, initVector, cipherKey, encryptService, initVector, prefs
**Variables por clase:**
*(ninguna)*
**Dependencias (imports del proyecto):** *(ninguna)*
**Widgets/Componentes usados:** *(ninguno detectado)*
**Notas:** *(pendiente revisión manual)*

## 40_security/generate_hash.dart
**Tipo:** Variables Globales
**Clases:** *(ninguna)*
**Variables top-level:** bytes, md5Hash, bytes, sha1Hash, bytes, sha256Hash
**Variables por clase:**
*(ninguna)*
**Dependencias (imports del proyecto):** *(ninguna)*
**Widgets/Componentes usados:** *(ninguno detectado)*
**Notas:** *(pendiente revisión manual)*

## 40_security/generate_reset_token.dart
**Tipo:** Variables Globales
**Clases:** *(ninguna)*
**Variables top-level:** uuid, hash, expiry, expiry
**Variables por clase:**
*(ninguna)*
**Dependencias (imports del proyecto):** *(ninguna)*
**Widgets/Componentes usados:** *(ninguno detectado)*
**Notas:** *(pendiente revisión manual)*

## 40_security/urls_endpoints_espacios.dart
**Tipo:** Variables Globales
**Clases:** *(ninguna)*
**Variables top-level:** Map, Map
**Variables por clase:**
*(ninguna)*
**Dependencias (imports del proyecto):** *(ninguna)*
**Widgets/Componentes usados:** *(ninguno detectado)*
**Notas:** *(pendiente revisión manual)*

## 41_connectivity

## 41_connectivity/connectivitycheck_provider.dart
**Tipo:** Conectividad
**Clases:** ElementoDeConeccion, ElementoDatos, ChecaConeccionesNotifier, PaginaChecaInternet, PaginaChecaInternetState
**Variables top-level:** checaConeccionesProvider, Connectivity
**Variables por clase:**
- ElementoDeConeccion: int index, String etiqueta, IconData icono, String estadoDeLaConeccion
- ElementoDatos: String etiqueta, IconData icono
- ChecaConeccionesNotifier: *(sin campos detectados)*
- PaginaChecaInternet: *(sin campos detectados)*
- PaginaChecaInternetState: *(sin campos detectados)*
**Dependencias (imports del proyecto):** ../20_var_globales/var_color_themes.dart, ../60_global_widgets/debugprint.dart
**Widgets/Componentes usados:** AppBar, Center, Column, Container, ElevatedButton, Expanded, ListView, Row, Scaffold, SizedBox, Switch, Text
**Notas:** *(pendiente revisión manual)*

## 41_connectivity/pagina_sin_coneccion.dart
**Tipo:** Widget
**Clases:** PaginaSinConeccion
**Variables top-level:** *(ninguna)*
**Variables por clase:**
- PaginaSinConeccion: String letrero
**Dependencias (imports del proyecto):** ../20_var_globales/var_color_themes.dart, ../60_global_widgets/debugprint.dart, connectivitycheck_provider.dart
**Widgets/Componentes usados:** AppBar, Center, Column, ConsumerWidget, ElevatedButton, Icon, IconButton, Scaffold, SizedBox, Text
**Notas:** *(pendiente revisión manual)*

## 42_sistema_operativo

## 42_sistema_operativo/detecta_os.dart
**Tipo:** Utilidad/Sistema
**Clases:** ElementoPlataforma, PaginaDetectaPlataforma
**Variables top-level:** checaPlataformaProvider
**Variables por clase:**
- ElementoPlataforma: int index, String etiqueta, IconData icono, String nombrePlataforma
- PaginaDetectaPlataforma: *(sin campos detectados)*
**Dependencias (imports del proyecto):** ../07_routes/app_routes.dart, ../20_var_globales/var_color_themes.dart, ../20_var_globales/var_elementos_menus.dart
**Widgets/Componentes usados:** AppBar, Center, Column, Container, ElevatedButton, Expanded, ListView, Row, Scaffold, SizedBox, StatelessWidget, Text
**Notas:** *(pendiente revisión manual)*

## 60_global_widgets

## 60_global_widgets/bottom_fijo.dart
**Tipo:** Widget
**Clases:** MyButton, MyTextField, SquareTile, MyTextFieldPassword, MyTextFieldPasswordState
**Variables top-level:** *(ninguna)*
**Variables por clase:**
- MyButton: String etiqueta
- MyTextField: final controller, String hintText, bool obscureText, IconData icono
- SquareTile: String imagePath
- MyTextFieldPassword: TextEditingController controller, String hintText, IconData icono
- MyTextFieldPasswordState: *(sin campos detectados)*
**Dependencias (imports del proyecto):** ../20_var_globales/var_color_themes.dart, debugprint.dart
**Widgets/Componentes usados:** Center, Column, Container, Icon, IconButton, Image, InputDecoration, Padding, SizedBox, StatefulWidget, StatelessWidget, Text, TextButton, TextField
**Notas:** *(pendiente revisión manual)*

## 60_global_widgets/debugprint.dart
**Tipo:** Utilidad
**Clases:** *(ninguna)*
**Variables top-level:** *(ninguna)*
**Variables por clase:**
*(ninguna)*
**Dependencias (imports del proyecto):** *(ninguna)*
**Widgets/Componentes usados:** *(ninguno detectado)*
**Notas:** *(pendiente revisión manual)*

## 60_global_widgets/derechos_reservados.dart
**Tipo:** Utilidad
**Clases:** *(ninguna)*
**Variables top-level:** SizedBox, SizedBox, SizedBox, SizedBox
**Variables por clase:**
*(ninguna)*
**Dependencias (imports del proyecto):** ../20_var_globales/var_color_themes.dart
**Widgets/Componentes usados:** Column, SizedBox, Text
**Notas:** *(pendiente revisión manual)*

## 60_global_widgets/dialogbox_mensaje_general.dart
**Tipo:** Utilidad
**Clases:** *(ninguna)*
**Variables top-level:** *(ninguna)*
**Variables por clase:**
*(ninguna)*
**Dependencias (imports del proyecto):** ../../20_var_globales/var_color_themes.dart
**Widgets/Componentes usados:** AlertDialog, Container, ElevatedButton, Text
**Notas:** *(pendiente revisión manual)*

## 60_global_widgets/future_builder_state_widgets.dart
**Tipo:** Utilidad
**Clases:** *(ninguna)*
**Variables top-level:** *(ninguna)*
**Variables por clase:**
*(ninguna)*
**Dependencias (imports del proyecto):** debugprint.dart, ../20_var_globales/var_color_themes.dart
**Widgets/Componentes usados:** Center, Container, FutureBuilder, Text
**Notas:** *(pendiente revisión manual)*

## 60_global_widgets/genera_cantidad_monetaria.dart
**Tipo:** Utilidad
**Clases:** *(ninguna)*
**Variables top-level:** random
**Variables por clase:**
*(ninguna)*
**Dependencias (imports del proyecto):** debugprint.dart
**Widgets/Componentes usados:** *(ninguno detectado)*
**Notas:** *(pendiente revisión manual)*
