# Dominios, Módulos y Archivos — BuscoBien

Este documento cataloga los **dominios funcionales** de la aplicación BuscoBien, los **módulos** (directorios) que los componen y los **archivos** que los implementan, con base en el subdirectorio `D:/buscobien/lib`.

---

## Índice de Dominios

1. [Núcleo / Bootstrap](#1-núcleo--bootstrap)
2. [Inicio y Navegación Principal](#2-inicio-y-navegación-principal)
3. [Splash y Carga Inicial](#3-splash-y-carga-inicial)
4. [Pantalla Principal (Menús)](#4-pantalla-principal-menús)
5. [Listas de Propiedades (Social)](#5-listas-de-propiedades-social)
6. [Vistas Auxiliares / Catálogos](#6-vistas-auxiliares--catálogos)
7. [Preferencias y Tema (Provider)](#7-preferencias-y-tema-provider)
8. [Menús (Provider)](#8-menús-provider)
9. [Rutas y Navegación](#9-rutas-y-navegación)
10. [Búsqueda / Inicio de Propiedades](#10-búsqueda--inicio-de-propiedades)
11. [Detalle de Propiedades](#11-detalle-de-propiedades)
12. [Perfil de Usuario](#12-perfil-de-usuario)
13. [Tu Cuenta — Módulo Social](#13-tu-cuenta--módulo-social)
   - 13.1 [Conocidos](#131-conocidos)
   - 13.2 [Grupos](#132-grupos)
   - 13.3 [Tus Espacios (Propiedades)](#133-tus-espacios-propiedades)
14. [Ubicación y Localidades](#14-ubicación-y-localidades)
15. [Widgets Comunes](#15-widgets-comunes)
16. [Autenticación y Login de Usuario](#16-autenticación-y-login-de-usuario)
17. [Localidades del Usuario](#17-localidades-del-usuario)
18. [Geolocalización y Google Maps](#18-geolocalización-y-google-maps)
19. [Variables Globales y Temas](#19-variables-globales-y-temas)
20. [Gestión de Imágenes](#20-gestión-de-imágenes)
21. [Seguridad](#21-seguridad)
22. [Conectividad](#22-conectividad)
23. [Sistema Operativo (Plataforma)](#23-sistema-operativo-plataforma)
24. [Widgets Globales](#24-widgets-globales)

---

## 1. Núcleo / Bootstrap

Punto de entrada y configuración raíz de la app.

- **`lib/main.dart`** — Inicializa Flutter, fija la estrategia de URLs, define la orientación, monta `ProviderScope` y registra el handler de deep links.

---

## 2. Inicio y Navegación Principal

Módulo `lib/01_home/` — Estado y proveedores de la pantalla home / navegación principal.

- `lib/01_home/home_navigation_provider.dart` — Provider Riverpod para la navegación de la home.
- `lib/01_home/home_navigation_provider.g.dart` — Código generado de Riverpod.
- `lib/01_home/home_state.dart` — Modelo de estado (Freezed) de la home.
- `lib/01_home/home_state.freezed.dart` — Implementación Freezed.

---

## 3. Splash y Carga Inicial

Módulo `lib/01_splash_screen/` — Pantalla de splash, branding y versionado.

- `lib/01_splash_screen/splash_page.dart` — Widget principal del splash.
- `lib/01_splash_screen/glass_objects.dart` — Elementos visuales "glass" del splash.
- `lib/01_splash_screen/versiones.dart` — Información de versiones de la app.

---

## 4. Pantalla Principal (Menús)

Módulo `lib/02_principal_screen/` — Pantalla principal con menús sliver y navegación global.

- `lib/02_principal_screen/00_principales_opciones.dart` — Definición de opciones principales.
- `lib/02_principal_screen/principal_00_inicio.dart` — Punto de inicio de la pantalla principal.
- `lib/02_principal_screen/principal_02_page_appbar.dart` — AppBar principal.
- `lib/02_principal_screen/principal_03_page_drawer.dart` — Drawer principal.
- `lib/02_principal_screen/principal_sliver_screen_menus_inicio.dart` — Sliver con menús de inicio.

---

## 5. Listas de Propiedades (Social)

Módulo `lib/03_listas/` — Listas personales, compartidas, "me gusta" y compartir con conocidos/grupos.

### Datos / Modelos

- `lib/03_listas/data_lista_propiedad.dart` — Modelo de lista de propiedades.
- `lib/03_listas/data_lista_propiedad_get.dart` — DTO de entrada/salida de listas.
- `lib/03_listas/data_user_list_model.dart` — Modelo de listas del usuario.
- `lib/03_listas/data_user_list_model_get.dart` — DTO de listas del usuario.
- `lib/03_listas/models/lista_compartida_model.dart` — Modelo de listas compartidas.
- `lib/03_listas/models/me_gusta_model.dart` — Modelo de "me gusta".

### Providers

- `lib/03_listas/provider_listas_compartidas.dart` — Provider de listas compartidas.
- `lib/03_listas/provider_listas_propiedades.dart` — Provider de listas de propiedades.
- `lib/03_listas/provider_me_gusta.dart` — Provider de "me gusta".
- `lib/03_listas/provider_propiedades_compartidas_conocidos.dart` — Provider de propiedades compartidas con conocidos.
- `lib/03_listas/provider_user_lists.dart` — Provider de listas de usuario.

### Pantallas / Widgets

- `lib/03_listas/lista_select_lista_save_propiedad.dart` — Selector de listas para guardar.
- `lib/03_listas/page_compartir_con_conocido.dart` — Compartir propiedad con un conocido.
- `lib/03_listas/page_compartir_con_grupo.dart` — Compartir propiedad con un grupo.
- `lib/03_listas/pagina_detalle_lista_compartida.dart` — Detalle de lista compartida.
- `lib/03_listas/pagina_detalle_listas.dart` — Detalle de lista propia.
- `lib/03_listas/pagina_mis_listas.dart` — Pantalla "Mis listas".

---

## 6. Vistas Auxiliares / Catálogos

Módulo `lib/03_vistas/` — Páginas de catálogos y vistas auxiliares (asociaciones, hospedaje, inmobiliarias, market, promotores, propietarios, proveedores, servicios, usuarios).

- `lib/03_vistas/pagina_asociaciones.dart`
- `lib/03_vistas/pagina_hospedaje.dart`
- `lib/03_vistas/pagina_inmobiliarias.dart`
- `lib/03_vistas/pagina_market.dart`
- `lib/03_vistas/pagina_promotores.dart`
- `lib/03_vistas/pagina_propietarios.dart`
- `lib/03_vistas/pagina_proveedores.dart`
- `lib/03_vistas/pagina_servicios.dart`
- `lib/03_vistas/pagina_usuarios.dart`

---

## 7. Preferencias y Tema (Provider)

Módulo `lib/04_provider/` — Preferencias del usuario y selección de paleta de colores.

- `lib/04_provider/pagina_colores.dart` — Pantalla de selección de colores/tema.
- `lib/04_provider/provider_preferencias.dart` — Provider de preferencias.

---

## 8. Menús (Provider)

Módulo `lib/05_provider_menus/` — Providers y widgets de menús (AppBar, sliver, dropdowns).

### Variables / Constantes

- `lib/05_provider_menus/variables_menus.dart` — Variables y constantes de menús.

### Providers

- `lib/05_provider_menus/provider_menu_inicial.dart`
- `lib/05_provider_menus/provider_menu_nivel_gobierno.dart`
- `lib/05_provider_menus/provider_menu_principal.dart`
- `lib/05_provider_menus/provider_menu_tipo_de_transaccion.dart`
- `lib/05_provider_menus/provider_menu_tipo_espacio.dart`
- `lib/05_provider_menus/provider_menu_tu_cuenta.dart`
- `lib/05_provider_menus/provider_menu_tu_cuenta_usuario.dart`

### Widgets de menú

- `lib/05_provider_menus/appbar_menu_tipo_transaccion_inferior.dart`
- `lib/05_provider_menus/appbar_menu_tu_cuenta.dart`
- `lib/05_provider_menus/appbar_menu_tu_cuenta_usuario.dart`
- `lib/05_provider_menus/appbar_sliver_menu_inicial.dart`
- `lib/05_provider_menus/appbar_sliver_menu_nivel_gobierno.dart`
- `lib/05_provider_menus/appbar_sliver_menu_principal.dart`
- `lib/05_provider_menus/appbar_sliver_menu_tipo_espacio.dart`
- `lib/05_provider_menus/dropdown_menu_principal_propiedades.dart`

---

## 9. Rutas y Navegación

Módulo `lib/07_routes/` — Sistema centralizado de navegación, parámetros tipados y manejo de deep links.

- `lib/07_routes/app_routes.dart` — Definición de rutas y `routeGenerate`.
- `lib/07_routes/deep_link_handler.dart` — Manejo de deep links.
- `lib/07_routes/pagina_route_error.dart` — Página de error de ruta.
- `lib/07_routes/routes_parameters.dart` — Parámetros tipados para las rutas.

---

## 10. Búsqueda / Inicio de Propiedades

Módulo `lib/08_pantallas/inicio/` — Pantalla de inicio, búsqueda, filtros y catálogo de propiedades.

### Datos / Modelos

- `lib/08_pantallas/inicio/data_count_view_documentos.dart` — Conteo de documentos.
- `lib/08_pantallas/inicio/data_espacios_casas.dart` — Modelo principal de espacios/casas.
- `lib/08_pantallas/inicio/data_espacios_casas_get.dart` — DTO de entrada/salida de espacios.
- `lib/08_pantallas/inicio/data_get_valores_menus.dart` — DTO de valores de menús.
- `lib/08_pantallas/inicio/catalogo_otras_caracteristicas.dart` — Catálogo de otras características.
- `lib/08_pantallas/inicio/clase_busqueda_estado.dart` — Estado de búsqueda.
- `lib/08_pantallas/inicio/clase_busqueda_estado.g.dart` — Freezed/JSON generado.

### Servicios HTTP

- `lib/08_pantallas/inicio/http_find_propiedades_10en10.dart` — Búsqueda paginada de propiedades.
- `lib/08_pantallas/inicio/http_find_propiedades_10en10.g.dart` — Generado.
- `lib/08_pantallas/inicio/http_view_count_filter_propiedades.dart` — Vista/conteo con filtros.
- `lib/08_pantallas/inicio/http_view_count_filter_propiedades.g.dart` — Generado.

### Providers

- `lib/08_pantallas/inicio/inicio_propiedades_providers.dart`
- `lib/08_pantallas/inicio/inicio_propiedades_providers.g.dart`

### Pantallas / Widgets

- `lib/08_pantallas/inicio/pagina_inicio_busca_espacios.dart` — Pantalla principal de búsqueda.
- `lib/08_pantallas/inicio/widget_wrap_modern_card.dart` — Tarjetas modernas de propiedad.

---

## 11. Detalle de Propiedades

Módulo `lib/08_pantallas/propiedades/` — Vista de detalle de una propiedad (incluye ficha PDF).

- `lib/08_pantallas/propiedades/data_find_propiedades.dart` — Datos de búsqueda de propiedad.
- `lib/08_pantallas/propiedades/pagina_detalle_propiedad.dart` — Pantalla de detalle.
- `lib/08_pantallas/propiedades/pagina_detalle_propiedad_pdf.dart` — Detalle en formato PDF.

---

## 12. Perfil de Usuario

Módulo `lib/08_pantallas/perfil/` — Pantalla de perfil de usuario.

- `lib/08_pantallas/perfil/pagina_perfil.dart` — Pantalla de perfil.

---

## 13. Tu Cuenta — Módulo Social

Módulo `lib/08_pantallas/tu_cuenta/` — Concentra los sub-dominios sociales y de gestión de propiedades del usuario.

### 13.1 Conocidos

Directorio `lib/08_pantallas/tu_cuenta/conocidos/`.

#### Modelos

- `lib/08_pantallas/tu_cuenta/conocidos/invitacion_model.dart` — Modelo de invitación.
- `lib/08_pantallas/tu_cuenta/conocidos/mensaje_model.dart` — Modelo de mensaje.
- `lib/08_pantallas/tu_cuenta/conocidos/models/conocido.dart` — Modelo de conocido.
- `lib/08_pantallas/tu_cuenta/conocidos/models/conocido.freezed.dart`
- `lib/08_pantallas/tu_cuenta/conocidos/models/conocido.g.dart`

#### Providers

- `lib/08_pantallas/tu_cuenta/conocidos/provider_mensajes.dart` — Provider de mensajes.
- `lib/08_pantallas/tu_cuenta/conocidos/providers/conocidos_notifier.dart` — Notifier de conocidos.
- `lib/08_pantallas/tu_cuenta/conocidos/social_providers.dart` — Providers sociales.

#### Pantallas / Widgets

- `lib/08_pantallas/tu_cuenta/conocidos/conocidos_view.dart` — Vista principal de conocidos.
- `lib/08_pantallas/tu_cuenta/conocidos/page_chat_privado.dart` — Chat privado.
- `lib/08_pantallas/tu_cuenta/conocidos/page_descubrir_usuarios.dart` — Descubrir usuarios.
- `lib/08_pantallas/tu_cuenta/conocidos/page_invitaciones.dart` — Gestión de invitaciones.
- `lib/08_pantallas/tu_cuenta/conocidos/page_mis_contactos.dart` — Mis contactos.
- `lib/08_pantallas/tu_cuenta/conocidos/page_perfil_contacto.dart` — Perfil de contacto.

### 13.2 Grupos

Directorio `lib/08_pantallas/tu_cuenta/grupos/`.

#### Modelos

- `lib/08_pantallas/tu_cuenta/grupos/models/aviso_grupo_model.dart` — Modelo de aviso de grupo.
- `lib/08_pantallas/tu_cuenta/grupos/models/grupo.dart` — Modelo de grupo.
- `lib/08_pantallas/tu_cuenta/grupos/models/grupo.freezed.dart`
- `lib/08_pantallas/tu_cuenta/grupos/models/grupo.g.dart`
- `lib/08_pantallas/tu_cuenta/grupos/models/grupo_model.dart` — Modelo de datos de grupo.
- `lib/08_pantallas/tu_cuenta/grupos/models/invitacion_grupo_model.dart` — Modelo de invitación a grupo.

#### Pantallas

- `lib/08_pantallas/tu_cuenta/grupos/grupos_view.dart` — Vista principal de grupos.

### 13.3 Tus Espacios (Propiedades)

Directorio `lib/08_pantallas/tu_cuenta/tus_espacios/`.

- `lib/08_pantallas/tu_cuenta/tus_espacios/compra_espacios/form_compra_espacios.dart` — Formulario de compra de espacios.
- `lib/08_pantallas/tu_cuenta/tus_espacios/form_update_espacio_comprado.dart` — Formulario de actualización de espacio comprado.
- `lib/08_pantallas/tu_cuenta/tus_espacios/http_publica_propiedad.dart` — Servicio HTTP de publicación.
- `lib/08_pantallas/tu_cuenta/tus_espacios/pagina_tus_espacios.dart` — Pantalla de "Tus espacios".
- `lib/08_pantallas/tu_cuenta/tus_espacios/provider_espacios_casa_get.dart` — Provider de espacios.
- `lib/08_pantallas/tu_cuenta/tus_espacios/tabla_tipopropiedad_vs_campos.dart` — Tabla tipo-propiedad vs campos.

---

## 14. Ubicación y Localidades

Módulo `lib/08_pantallas/ubicacion/` — Localidades (SEPOMEX), búsqueda y pantallas de ubicación.

### Datos / Modelos

- `lib/08_pantallas/ubicacion/data_localidad_find.dart` — DTO de búsqueda de localidad.
- `lib/08_pantallas/ubicacion/data_sepomex_localidades.dart` — Modelo Freezed de localidades SEPOMEX.
- `lib/08_pantallas/ubicacion/data_sepomex_localidades.freezed.dart`
- `lib/08_pantallas/ubicacion/data_sepomex_localidades.g.dart`
- `lib/08_pantallas/ubicacion/data_sepomex_localidades_get_cp.dart` — DTO de búsqueda por CP.

### Providers

- `lib/08_pantallas/ubicacion/provider_localidades_del_cp.dart` — Provider de localidades por CP.

### Pantallas

- `lib/08_pantallas/ubicacion/pagina_busca_localidades_gmaps.dart` — Búsqueda con Google Maps.
- `lib/08_pantallas/ubicacion/pagina_principal_localidades.dart` — Pantalla principal de localidades.
- `lib/08_pantallas/ubicacion/screen_maestro_localidades.dart` — Pantalla maestro.

---

## 15. Widgets Comunes

Módulo `lib/08_pantallas/widgets_comunes/` — Widgets compartidos por las pantallas.

- `lib/08_pantallas/widgets_comunes/widget_letrero_tipo_transaccion.dart` — Letrero de tipo de transacción.

---

## 16. Autenticación y Login de Usuario

Módulo `lib/10_user_login/` — Autenticación, sesión, registro, recuperación de contraseña y avatar.

### Datos / Modelos

- `lib/10_user_login/data_models/auth_state.dart` — Estado de autenticación.
- `lib/10_user_login/data_models/data_get_id_user_pass.dart` — DTO id/contraseña.
- `lib/10_user_login/data_models/data_get_user.dart` — DTO de usuario.
- `lib/10_user_login/data_models/data_user_promotor.dart` — Modelo de usuario promotor.
- `lib/10_user_login/data_models/data_usuarios.dart` — Modelo de usuarios.

### Avatar

- `lib/10_user_login/avatar/data_user_avatar_get.dart` — DTO de avatar.
- `lib/10_user_login/avatar/manejo_imagenes_avatar.dart` — Manejo de imágenes de avatar.
- `lib/10_user_login/avatar/provider_get_avatar.dart` — Provider de avatar.
- `lib/10_user_login/avatar/provider_get_avatar.g.dart`

### Login / Sesión

- `lib/10_user_login/usuario_login/data_session.dart` — Modelo de sesión.
- `lib/10_user_login/usuario_login/dialogbox_login.dart` — Diálogo de login.
- `lib/10_user_login/usuario_login/login_01_login_page.dart` — Pantalla de login.
- `lib/10_user_login/usuario_login/login_03_form_register_user.dart` — Formulario de registro.
- `lib/10_user_login/usuario_login/page_cambio_password.dart` — Cambio de contraseña.
- `lib/10_user_login/usuario_login/page_solicitar_recuperacion.dart` — Solicitar recuperación.
- `lib/10_user_login/usuario_login/password_recovery_repository.dart` — Repositorio de recuperación.
- `lib/10_user_login/usuario_login/provider_session.dart` — Provider de sesión.
- `lib/10_user_login/usuario_login/provider_session.g.dart`
- `lib/10_user_login/usuario_login/session_repository.dart` — Repositorio de sesión.
- `lib/10_user_login/usuario_login/session_repository.g.dart`
- `lib/10_user_login/usuario_login/session_storage.dart` — Almacenamiento de sesión.
- `lib/10_user_login/usuario_login/textos_tc_ap.dart` — Textos legales (Términos / Aviso de Privacidad).

---

## 17. Localidades del Usuario

Módulo `lib/12_localidades_user/` — Localidades asociadas al usuario.

- `lib/12_localidades_user/data_user_localidad.dart` — Modelo Freezed.
- `lib/12_localidades_user/data_user_localidad.freezed.dart`
- `lib/12_localidades_user/data_user_localidad.g.dart`
- `lib/12_localidades_user/data_user_localidad_get.dart` — DTO.
- `lib/12_localidades_user/data_user_localidad_get.freezed.dart`
- `lib/12_localidades_user/data_user_localidad_get.g.dart`
- `lib/12_localidades_user/localidades_repository.dart` — Repositorio de localidades.
- `lib/12_localidades_user/provider_get_localidades_usuario.dart` — Provider.

---

## 18. Geolocalización y Google Maps

Módulo `lib/14_geolocalizacion/` — Integración con Google Maps y Places.

- `lib/14_geolocalizacion/app_keys.dart` — API keys (Maps/Places).
- `lib/14_geolocalizacion/google_map_mapa_propiedades.dart` — Mapa de propiedades.
- `lib/14_geolocalizacion/google_map_place_data.dart` — Datos de Places.
- `lib/14_geolocalizacion/provider_actual_place.dart` — Provider de lugar actual.

---

## 19. Variables Globales y Temas

Módulo `lib/20_var_globales/` — Temas, constantes, helpers, formateadores y manejo de errores.

- `lib/20_var_globales/couchdb_errors.dart` — Catálogo de errores CouchDB.
- `lib/20_var_globales/format_chat_timestamp.dart` — Formateador de timestamps de chat.
- `lib/20_var_globales/ui_exceptions.dart` — Excepciones de UI.
- `lib/20_var_globales/var_color_themes.dart` — Temas de color (ColorScheme M3).
- `lib/20_var_globales/var_color_widget.dart` — Helpers de color para widgets.
- `lib/20_var_globales/var_de_estilo_widgets.dart` — Estilos de widgets.
- `lib/20_var_globales/var_elementos_menus.dart` — Elementos de menús.
- `lib/20_var_globales/var_login.dart` — Constantes de login.
- `lib/20_var_globales/variables_globales.dart` — Variables globales.

---

## 20. Gestión de Imágenes

Módulo `lib/20_22_imagenes/...` (en `lib/22_imagenes/`) — Modelos, servicios y pantallas de imágenes (fotos de usuario y de propiedades).

### Datos / Modelos

- `lib/22_imagenes/data_models/data_fotos_casa.dart` — Modelo de fotos de casa.
- `lib/22_imagenes/data_models/data_fotos_casa_get.dart` — DTO de fotos.
- `lib/22_imagenes/data_models/data_fotos_casa_get_ids.dart` — DTO de IDs de fotos.
- `lib/22_imagenes/data_models/data_fotos_ordenadas.dart` — Modelo de fotos ordenadas.

### Inicio / Fotos Usuario

- `lib/22_imagenes/inicio_fotos_usuario/pagina_carousel_fotos_usuario.dart` — Carrusel de fotos del usuario.
- `lib/22_imagenes/inicio_fotos_usuario/pagina_carousel_fotos_usuario_mini.dart` — Carrusel mini.

### Tus Espacios — Fotos de Propiedad

- `lib/22_imagenes/tus_espacios_fotos_propiedad/funciones_compress_image.dart` — Compresión de imágenes.
- `lib/22_imagenes/tus_espacios_fotos_propiedad/image_file_structure.dart` — Estructura del archivo de imagen.
- `lib/22_imagenes/tus_espacios_fotos_propiedad/manejo_de_fotos/datos_fotos/data_couchdb_post_return.dart` — Respuesta de CouchDB.
- `lib/22_imagenes/tus_espacios_fotos_propiedad/manejo_de_fotos/datos_fotos/data_cuenta_fotos.dart` — Cuenta de fotos.
- `lib/22_imagenes/tus_espacios_fotos_propiedad/manejo_de_fotos/datos_fotos/data_fotos_lista_fotos_iduser_idprop.dart` — Lista de fotos por usuario/propiedad.
- `lib/22_imagenes/tus_espacios_fotos_propiedad/manejo_de_fotos/fotos_de_la_propiedad/pagina_agrega_multiples_fotos.dart` — Agregar múltiples fotos.
- `lib/22_imagenes/tus_espacios_fotos_propiedad/manejo_de_fotos/futures_y_providers/future_funciones_fotos.dart` — Funciones/futures de fotos.
- `lib/22_imagenes/tus_espacios_fotos_propiedad/manejo_de_fotos/futures_y_providers/future_get_fotos_by_idpr_orden.dart` — Obtener fotos ordenadas.
- `lib/22_imagenes/tus_espacios_fotos_propiedad/manejo_de_fotos/futures_y_providers/future_recupera_ids_fotos_propiedad.dart` — Recuperar IDs.
- `lib/22_imagenes/tus_espacios_fotos_propiedad/manejo_de_fotos/futures_y_providers/http_funciones_gestion_foto.dart` — HTTP de gestión.
- `lib/22_imagenes/tus_espacios_fotos_propiedad/manejo_de_fotos/futures_y_providers/provider_get_fotos_ids_user_propiedad.dart` — Provider de IDs de fotos.
- `lib/22_imagenes/tus_espacios_fotos_propiedad/manejo_de_fotos/lista_fotos_ordenadas/clase_listas_fotos_propiedad.dart` — Clase de listas.
- `lib/22_imagenes/tus_espacios_fotos_propiedad/manejo_de_fotos/lista_fotos_ordenadas/data_fotos_ordenadas_get_idpropiedad.dart` — DTO de fotos ordenadas.
- `lib/22_imagenes/tus_espacios_fotos_propiedad/manejo_de_fotos/lista_fotos_ordenadas/future_put_fotos_orden.dart` — PUT de orden.
- `lib/22_imagenes/tus_espacios_fotos_propiedad/manejo_de_fotos/lista_fotos_ordenadas/future_update_fotos_orden.dart` — UPDATE de orden.
- `lib/22_imagenes/tus_espacios_fotos_propiedad/manejo_de_fotos/lista_fotos_ordenadas/provider_get_lista_fotos_ordenadas.dart` — Provider.
- `lib/22_imagenes/tus_espacios_fotos_propiedad/manejo_de_fotos/lista_ids_fotos/data_fotos_get_ids_fotos_user_prop.dart` — DTO de IDs.
- `lib/22_imagenes/tus_espacios_fotos_propiedad/manejo_de_fotos/opciones_menu_fotos/pagina_fotos_menu_opciones.dart` — Menú de opciones.
- `lib/22_imagenes/tus_espacios_fotos_propiedad/manejo_de_fotos/opciones_menu_fotos/pagina_lista_fotos_carousel.dart` — Carrusel.
- `lib/22_imagenes/tus_espacios_fotos_propiedad/manejo_de_fotos/opciones_menu_fotos/pagina_lista_fotos_cuadros.dart` — Cuadrícula.
- `lib/22_imagenes/tus_espacios_fotos_propiedad/manejo_de_fotos/opciones_menu_fotos/pagina_lista_fotos_listado.dart` — Listado.

### Variables

- `lib/22_imagenes/variables_imagenes.dart` — Variables de imágenes.

---

## 21. Seguridad

Módulo `lib/40_security/` — Endpoints, hashing, encriptación y tokens.

- `lib/40_security/direccionip.dart` — Lectura de IP / variables de entorno.
- `lib/40_security/encriptar.dart` — Funciones de encriptación.
- `lib/40_security/generate_hash.dart` — Generación de hashes.
- `lib/40_security/generate_reset_token.dart` — Tokens de reseteo.
- `lib/40_security/urls_endpoints_espacios.dart` — URLs/Endpoints de espacios.

---

## 22. Conectividad

Módulo `lib/41_connectivity/` — Detección de conexión a internet y pantallas de fallback.

- `lib/41_connectivity/connectivitycheck_provider.dart` — Provider de chequeo de conexión.
- `lib/41_connectivity/pagina_sin_coneccion.dart` — Pantalla "sin conexión".

---

## 23. Sistema Operativo (Plataforma)

Módulo `lib/42_sistema_operativo/` — Detección de plataforma y comportamiento específico.

- `lib/42_sistema_operativo/detecta_os.dart` — Detecta OS / plataforma actual.

---

## 24. Widgets Globales

Módulo `lib/60_global_widgets/` — Widgets y helpers reutilizables en toda la app.

- `lib/60_global_widgets/bottom_fijo.dart` — Bottom bar fija.
- `lib/60_global_widgets/debugprint.dart` — Helper de debug print con niveles.
- `lib/60_global_widgets/derechos_reservados.dart` — Widget/pantalla de derechos reservados.
- `lib/60_global_widgets/dialogbox_mensaje_general.dart` — Diálogo de mensaje general.
- `lib/60_global_widgets/future_builder_state_widgets.dart` — Wrappers para `FutureBuilder` con estados.
- `lib/60_global_widgets/genera_cantidad_monetaria.dart` — Formateador de cantidades monetarias.

---

## Resumen Estadístico

- **24 dominios** funcionales identificados.
- **1 archivo raíz** (`main.dart`) en el núcleo.
- **~15 archivos generados** (`*.g.dart`, `*.freezed.dart`) que acompañan a sus contrapartes manuales.
- **3 sub-dominios sociales** dentro de `tu_cuenta/`: Conocidos, Grupos, Tus Espacios.
- Múltiples módulos con la convención `<código>_<nombre>/` que agrupan pantallas, modelos, providers y servicios por dominio.

## Convenciones Observadas

1. **Prefijos numéricos en módulos** (`01_home`, `02_principal_screen`, etc.) — orden sugerido de carga/dependencia.
2. **Modelos en `data_models/` o `models/`** dentro de cada dominio.
3. **Providers con sufijo `_provider.dart`** o en subcarpeta `providers/`.
4. **Archivos `.g.dart` y `.freezed.dart`** siempre al lado de su archivo fuente.
5. **Pantallas con prefijo `pagina_` o `page_`** según su tipo (español para primarias, inglés para flujos secundarios/social).
6. **Servicios HTTP con prefijo `http_`** y `future_` para funciones asíncronas específicas.
7. **Repositorios con sufijo `_repository.dart`** para abstraer fuentes de datos.
