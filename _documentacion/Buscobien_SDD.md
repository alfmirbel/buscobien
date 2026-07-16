# Software Design Document — BuscoBien

**Versión:** 1.0.0 (reverse-engineered)  
**Fecha:** 2026-07-12  
**Fuente:** Código existente en `/mnt/buscobien`  
**Formato:** SDD por feature/directorio  
**Scope:** Documento de requerimientos y diseño derivado exclusivamente del código actual. No incluye cambios ni suposiciones fuera del repo.

---

## Índice

1. [Resumen Ejecutivo](#1-resumen-ejecutivo)
2. [Arquitectura General](#2-arquitectura-general)
3. [Feature: Splash](#3-feature-splash)
4. [Feature: Home](#4-feature-home)
5. [Feature: Principal Screen](#5-feature-principal-screen)
6. [Feature: Listas](#6-feature-listas)
7. [Feature: Vistas](#7-feature-vistas)
8. [Feature: Provider Preferencias](#8-feature-provider-preferencias)
9. [Feature: Provider Menus](#9-feature-provider-menus)
10. [Feature: Routes](#10-feature-routes)
11. [Feature: Pantallas — Inicio](#11-feature-pantallas--inicio)
12. [Feature: Pantallas — Perfil](#12-feature-pantallas--perfil)
13. [Feature: Pantallas — Propiedades](#13-feature-pantallas--propiedades)
14. [Feature: Pantallas — Ubicación](#14-feature-pantallas--ubicacion)
15. [Feature: Pantallas — Tu Cuenta](#15-feature-pantallas--tu-cuenta)
16. [Feature: User Login](#16-feature-user-login)
17. [Feature: Localidades User](#17-feature-localidades-user)
18. [Feature: Geolocalización](#18-feature-geolocalizacion)
19. [Feature: Variables Globales](#19-feature-variables-globales)
20. [Feature: Imágenes](#20-feature-imagenes)
21. [Feature: Security](#21-feature-security)
22. [Feature: Connectivity](#22-feature-connectivity)
23. [Feature: Sistema Operativo](#23-feature-sistema-operativo)
24. [Feature: Global Widgets](#24-feature-global-widgets)
25. [RNF y Riesgos](#25-rnf-y-riesgos)
26. [Trazabilidad por Módulo](#26-trazabilidad-por-m-dulo)
27. [Supuestos y Limitaciones](#27-supuestos-y-limitaciones)

---

## 1. Resumen Ejecutivo

**BuscoBien** es una aplicación Flutter de participación ciudadana / bienes raíces. Es un producto funcional ya integrado contra CouchDB, con módulos de autenticación, catálogo de propiedades, listas de usuario, likes, geolocalización, gestión de imágenes, navegación reactiva y navegación profunda. El proyecto usa `flutter_riverpod`, `freezed`, JSON manual, CouchDB HTTP directo y multi-plataforma.

---

## 2. Arquitectura General

- **Framework UI:** Flutter Material 3.
- **Gestión de estado:** Riverpod (`flutter_riverpod: ^3.0.3`, `riverpod_annotation`).
- **Serialización:** JSON manual en muchos modelos y helpers `fromJson`/`toJson`/`fromMap`/`toMap`.
- **Backend:** CouchDB por HTTP básico; autorización Basic Base64 `username:password`.
- **Multiplataforma:** Android, iOS, Web, Windows, macOS, Linux; deep links con `app_links`.
- **Fuente de datos temática:** `assets/`, Google Maps (`google_maps_flutter`), `geolocator`, `geocoding`.
- **Storage / auth:** `shared_preferences` (JWT web/Windows), `flutter_secure_storage` (iOS/Android).
- **UI helpers:** `material_symbols_icons`, `shimmer`, `carousel_slider`, `pdf`/`printing`, `timeago`, `intl`.

---

## 3. Feature: Splash

**Directorio:** `lib/01_splash_screen`

### 3.1 Archivos

- `splash_page.dart`

### 3.2 Requerimientos y estado

| ID   | Requerimiento                                                     | Evidencia en código                                          | Estado              |
| ---- | ----------------------------------------------------------------- | ------------------------------------------------------------ | ------------------- |
| SP-1 | Pantalla de carga/branding inicial con temporizador configurable. | `SplashPage` recibe `duration` y muestra logo blanco + copy. | Implementado        |
| SP-2 | Validación de conectividad antes de navegar al home.              | Lee `checaConeccionesProvider` y bloquea si no hay conexión. | Implementado        |
| SP-3 | Navegación reactiva a `AppRoutes.principal` cuando hay conexión.  | `_attemptNavigation()` hace `pushReplacementNamed`.          | Implementado        |
| SP-4 | Pantalla de error cuando no hay conexión.                         | Navega a `AppRoutes.sinconeccion` con mensaje.               | Implementado        |
| SP-5 | Versión de app mostrada en pantalla de splash.                    | `V.$versionActual` en texto inferior.                        | Implementado        |
| SP-6 | Preparado para carga paralela de ubicación (comentado).           | Código preparado para background location init.              | Parcial / comentado |

---

## 4. Feature: Home

**Directorio:** `lib/01_home`

### 4.1 Archivos

- `home_state.dart` / `home_state.freezed.dart`
- `home_navigation_provider.dart` + `.g.dart`

### 4.2 Estado de navegación principal

Modelo `HomeState` contiene índices:

- `indiceInicial`
- `indicePrincipal`
- `indiceNivelGobierno`
- `indiceTipoEspacio`
- `indiceTipoTransaccion`
- `indiceMiCuenta`
- `indiceMiCuentaUsuario`
- `version`

Proveedor: `homeNavigationProvider`.

| ID  | Requerimiento                                                | Estado       |
| --- | ------------------------------------------------------------ | ------------ |
| H-1 | Navegación por secciones con estado centralizado.            | Implementado |
| H-2 | Estado reactivo por índices de menú principal y secundarios. | Implementado |
| H-3 | Base para filtrado dinámico de catálogo de propiedades.      | Implementado |

---

## 5. Feature: Principal Screen

**Directorio:** `lib/02_principal_screen`

### 5.1 Archivos representativos

- `00_principales_opciones.dart`
- `principal_sliver_screen_menus_inicio.dart`
- `principal_00_inicio.dart`
- `principal_02_page_appbar.dart`
- `principal_03_page_drawer.dart`

### 5.2 Requerimientos y estado

| ID   | Requerimiento                                                 | Evidencia                                                                  | Estado       |
| ---- | ------------------------------------------------------------- | -------------------------------------------------------------------------- | ------------ |
| PR-1 | Landing pages por tipo de visitante/rol.                      | `listaLandingPages` y `MenuOption` con 8 opciones.                         | Implementado |
| PR-2 | Menú de opciones principales con íconos y fondo.              | Modelo `MenuOption` y lista configurada.                                   | Implementado |
| PR-3 | Slivers / appbar / drawer por nivel de gobierno u opción.     | Archivos `principal_02_page_appbar.dart`, `principal_03_page_drawer.dart`. | Implementado |
| PR-4 | Navegación lateral/tipo transacción y tipo espacio integrada. | Menús generados por providers y widgets ligados a `HomeState`.             | Implementado |

---

## 6. Feature: Listas

**Directorio:** `lib/03_listas`

### 6.1 Archivos

- `pagina_mis_listas.dart`
- `pagina_detalle_listas.dart`
- `pagina_detalle_lista_compartida.dart`
- `page_compartir_con_conocido.dart`
- `page_compartir_con_grupo.dart`
- `provider_user_lists.dart`
- `provider_listas_propiedades.dart`
- `provider_me_gusta.dart`
- `provider_listas_compartidas.dart`
- `provider_propiedades_compartidas_conocidos.dart`
- `data_user_list_model.dart` / `data_user_list_model_get.dart`
- `data_lista_propiedad.dart` / `data_lista_propiedad_get.dart`
- `lista_select_lista_save_propiedad.dart`
- `models/lista_compartida_model.dart`
- `models/me_gusta_model.dart`

### 6.2 Modelos

| Modelo                          | Campos clave                                          |
| ------------------------------- | ----------------------------------------------------- |
| `Lista`                         | `listaId`, `userId`, `listName`, `type`, `timestamp`  |
| `GetUserPropertyListModel`      | Row-based: `RowGetUserPropertyList` → `Lista`         |
| `Listapropiedad`                | IDs de relación lista-propiedad + tipo y timestamp    |
| `ListaCompartidaModel`          | IDs de origen/destino, listaOrigenId, timestamps      |
| `MeGustaModel`                  | `usuarioId`, `propiedadId`, `timestamp`               |
| `PropiedadCompartidaKnownModel` | origen/destino, propiedadId, tipodeespacio, timestamp |

### 6.3 Requerimientos y estado

| ID  | Requerimiento                                                 | Evidencia                                                             | Estado       |
| --- | ------------------------------------------------------------- | --------------------------------------------------------------------- | ------------ |
| L-1 | Obtener listas del usuario por userId.                        | `fetchUserLists` consulta CouchDB vista por userId.                   | Implementado |
| L-2 | Crear lista con nombre, con ordenamiento "Favoritas" primero. | `createList` y reorden local en memoria.                              | Implementado |
| L-3 | Eliminar lista.                                               | `deleteLista` con PUT/\_deleted por `_rev`.                           | Implementado |
| L-4 | Agregar propiedad a lista.                                    | `addPropiedadALista` crea relación en `buscobien_listas_propiedades`. | Implementado |
| L-5 | Eliminar relación lista-propiedad.                            | `borrarPropiedadDeLista` y `borrarListapropiedadPorId`.               | Implementado |
| L-6 | "Me gusta" en propiedades con toggle.                         | `MeGustaNotifier.toggleMeGusta` y auto-creación de "Favoritas".       | Implementado |
| L-7 | Compartir lista con conocidos/grupos con límite 5.            | Dialogs con `CheckboxListTile`, confirmación y ejecución.             | Implementado |
| L-8 | Compartir propiedad con conocido/grupo.                       | `provider_propiedades_compartidas_conocidos.dart`.                    | Implementado |
| L-9 | Detalle de lista compartida.                                  | `pagina_detalle_lista_compartida.dart`.                               | Implementado |

---

## 7. Feature: Vistas

**Directorio:** `lib/03_vistas`

### 7.1 Archivos

- `pagina_asociaciones.dart`
- `pagina_hospedaje.dart`
- `pagina_inmobiliarias.dart`
- `pagina_market.dart`
- `pagina_promotores.dart`
- `pagina_propietarios.dart`
- `pagina_proveedores.dart`
- `pagina_servicios.dart`
- `pagina_usuarios.dart`

### 7.2 Requerimientos y estado

| ID  | Requerimiento                                                      | Evidencia                        | Estado       |
| --- | ------------------------------------------------------------------ | -------------------------------- | ------------ |
| V-1 | Landing diferenciada por perfil/rol de visitante.                  | 9 páginas dedicadas por vista.   | Implementado |
| V-2 | Navegación directa desde menú principal a landing correspondiente. | `MenuOption` + rutas integradas. | Implementado |

---

## 8. Feature: Provider Preferencias

**Directorio:** `lib/04_provider`

### 8.1 Archivos

- `pagina_colores.dart`

### 8.2 Requerimientos y estado

| ID  | Requerimiento                     | Evidencia                                  | Estado       |
| --- | --------------------------------- | ------------------------------------------ | ------------ |
| P-1 | Página de preferencias temáticas. | `PaginaColores` recibe argumento por ruta. | Implementado |

---

## 9. Feature: Provider Menus

**Directorio:** `lib/05_provider_menus`

### 9.1 Archivos

- `appbar_sliver_menu_inicial.dart`
- `appbar_sliver_menu_principal.dart`
- `appbar_sliver_menu_nivel_gobierno.dart`
- `appbar_sliver_menu_tipo_espacio.dart`
- `appbar_menu_tipo_transaccion_inferior.dart`
- `appbar_menu_tu_cuenta.dart`
- `appbar_menu_tu_cuenta_usuario.dart`
- `dropdown_menu_principal_propiedades.dart`
- `provider_menu_inicial.dart`
- `provider_menu_principal.dart`
- `provider_menu_nivel_gobierno.dart`
- `provider_menu_tipo_de_transaccion.dart`
- `provider_menu_tipo_espacio.dart`
- `provider_menu_tu_cuenta.dart`
- `provider_menu_tu_cuenta_usuario.dart`
- `variables_menus.dart`

### 9.2 Requerimientos y estado

| ID  | Requerimiento                                   | Evidencia                                              | Estado       |
| --- | ----------------------------------------------- | ------------------------------------------------------ | ------------ |
| M-1 | Menú superior Sliver por nivel de gobierno.     | `provider_menu_nivel_gobierno` + widget sliver.        | Implementado |
| M-2 | Menú superior Sliver por tipo de espacio.       | `provider_menu_tipo_espacio` + widget sliver.          | Implementado |
| M-3 | Menú inferior por tipo de transacción.          | `appbar_menu_tipo_transaccion_inferior`.               | Implementado |
| M-4 | Dropdown de filtrado principal de propiedades.  | `dropdown_menu_principal_propiedades.dart`.            | Implementado |
| M-5 | Menú inicial de onboarding / home.              | `provider_menu_inicial`.                               | Implementado |
| M-6 | Menú "Tu cuenta" diferenciado por tipo usuario. | Providers y widgets separados para usuario y genérico. | Implementado |

---

## 10. Feature: Routes

**Directorio:** `lib/07_routes`

### 10.1 Archivos

- `app_routes.dart`
- `deep_link_handler.dart`
- `pagina_route_error.dart`
- `routes_parameters.dart`

### 10.2 Rutas identificadas

- `/` → Splash
- `/home` → HomeScreen
- `/login` / `/loginuser` → Login
- `/registro` → Registro
- `/principal` → Menu inicial slivers
- `/plataforma` → Detección de plataforma
- `/sinconeccion` → Error sin conexión
- `/checaconeccion` → Chequeo de conexión
- `/listalocalidades` → Lista de localidades
- `/localidades` → Búsqueda GMaps localidades
- `/localidad` / `/editaespacio` → Detalle/edición espacio
- `/perfil` → Perfil usuario
- `/preferencias` → Preferencias visuales
- `/gestionavatar` → Avatar
- `/compraespacios` → Compra espacios
- `/carouselfotospropiedad`, `/fotospropiedad`, `/gestionfotopropiedad`, `/agregamultiplesfotos`, `/fotospropiedadminiaturas`, `/fotospropiedadpaginada` → Flujo fotos propiedad
- `/filtrapropiedades`, `/buscapropiedades`, `/generadatapropiedades`, `/generadatausuarios`, `/generadatapromotores` → Filtrado/back generado
- `/mapapropiedades`, `/listaspropiedades` → Mapa y listas
- `/recuperar` y `/recuperar?token=&perfil=` handled via query params
- `/solicitarrecuperacion`, `/cambiopassword` → Recovery flow

### 10.3 Requerimientos y estado

| ID  | Requerimiento                                 | Evidencia                                                      | Estado       |
| --- | --------------------------------------------- | -------------------------------------------------------------- | ------------ |
| R-1 | Routing central por switch `routeGenerate`.   | `app_routes.dart` con `routeGenerate` completo.                | Implementado |
| R-2 | Deep linking para recuperación de contraseña. | `_navigateIfRecovery` maneja `/recuperar?...` en web y mobile. | Implementado |
| R-3 | Parámetros tipados por ruta.                  | `routes_parameters.dart` con objetos y maps parametrizados.    | Implementado |
| R-4 | Página de error fallback.                     | `pagina_route_error.dart`.                                     | Parcial      |

---

## 11. Feature: Pantallas — Inicio

**Directorio:** `lib/08_pantallas/inicio`

### 11.1 Archivos

- `pagina_inicio_busca_espacios.dart`
- `inicio_propiedades_providers.dart` + `.g.dart`
- `clase_busqueda_estado.dart` + `.g.dart`
- `data_espacios_casas.dart`
- `data_espacios_casas_get.dart`
- `data_count_view_documentos.dart`
- `data_get_valores_menus.dart`
- `http_find_propiedades_10en10.dart` + `.g.dart`
- `http_view_count_filter_propiedades.dart` + `.g.dart`
- `catalogo_otras_caracteristicas.dart`
- `widget_wrap_modern_card.dart`

### 11.2 Modelos

- `EspaciosCasaGet`, `EspaciosCasa`, `Datosadicionalescasa`, `Datosdelcontactocasa`, `Ubicacioncasa`, `Fechadecasa`, `LocalidadCp`.
- `ValueEspaciosCasaGet`.
- `FindLocalidadXcp`, `LocalityEntryLike`, `LocalidadCpRow`.

### 11.3 Requerimientos y estado

| ID   | Requerimiento                                                  | Evidencia                                                                        | Estado       |
| ---- | -------------------------------------------------------------- | -------------------------------------------------------------------------------- | ------------ |
| IN-1 | Listado paginado de propiedades.                               | Providers `findPropiedadesEstadosde10en10Provider`, `paramSkip` para paginación. | Implementado |
| IN-2 | Filtros por nivel de gobierno, tipo espacio, tipo transacción. | Menús integrados y `clase_busqueda_estado`, `currentQueryProvider`.              | Implementado |
| IN-3 | Conteo de documentos para paginador.                           | `viewCountFilterPropiedadesProvider` retorna totales.                            | Implementado |
| IN-4 | Card moderna de propiedad en grid.                             | `_buildGrid` + `widget_wrap_modern_card`.                                        | Implementado |
| IN-5 | Mapa flotante para visualización geo.                          | FAB lleva a `/mapapropiedades`.                                                  | Implementado |
| IN-6 | Pantalla “Sin propiedades”.                                    | `_buildSinPropiedades()`.                                                        | Implementado |
| IN-7 | Características adicionales de propiedad.                      | `catalogo_otras_caracteristicas.dart`.                                           | Parcial      |
| IN-8 | Búsqueda desde query params y filtrado dinámico.               | `http_view_count_filter_propiedades`, invalida providers en cambios.             | Implementado |

---

## 12. Feature: Pantallas — Perfil

**Directorio:** `lib/08_pantallas/perfil`

### 12.1 Archivos

- `pagina_perfil.dart`

### 12.2 Requerimientos y estado

| ID   | Requerimiento                               | Evidencia                                  | Estado       |
| ---- | ------------------------------------------- | ------------------------------------------ | ------------ |
| PE-1 | Visualización de datos de sesión y usuario. | `AuthState` presentado en pantalla.        | Implementado |
| PE-2 | Gestión de avatar.                          | Integración con `classUserAvatarProvider`. | Implementado |

---

## 13. Feature: Pantallas — Propiedades

**Directorio:** `lib/08_pantallas/propiedades`

### 13.1 Archivos

- `pagina_detalle_propiedad.dart`
- `pagina_detalle_propiedad_pdf.dart`

### 13.2 Requerimientos y estado

| ID   | Requerimiento                                                           | Evidencia                                                         | Estado                |
| ---- | ----------------------------------------------------------------------- | ----------------------------------------------------------------- | --------------------- |
| PD-1 | Detalle completo de propiedad con datos técnicos, ubicación y contacto. | `PaginaDetalleWidget` imprime toda la ficha.                      | Implementado          |
| PD-2 | Acciones desde detalle: like/guardar en lista.                          | `_MeGustaButtonFicha`, dialog `_dialogGuardarEnLista` para chat.  | Implementado          |
| PD-3 | Generación de PDF de ficha de propiedad.                                | `PdfGeneratorService.generarYDescargarPDF`.                       | Implementado          |
| PD-4 | PDF incluye imagen principal + galería limitada.                        | Carga base64 y genera memoria para PDF.                           | Implementado          |
| PD-5 | Publicación y cierre de propiedad con fechas.                           | Presente en modelo `fechadepublicacioncasa`, `fechadecierrecasa`. | Parcial (solo modelo) |

---

## 14. Feature: Pantallas — Ubicación

**Directorio:** `lib/08_pantallas/ubicacion`

### 14.1 Archivos

- `pagina_busca_localidades_gmaps.dart`
- `pagina_principal_localidades.dart`
- `screen_maestro_localidades.dart`
- `data_localidad_find.dart`
- `data_sepomex_localidades.dart` / `.freezed.dart` / `.g.dart`

### 14.2 Modelos

- `FindLocalidadXcp`, `LocalidadCp`, `LocalityEntry`, `PostalCodeLookupResult`.
- `SepomexLocalidades`.

### 14.3 Requerimientos y estado

| ID  | Requerimiento                                     | Evidencia                                                           | Estado       |
| --- | ------------------------------------------------- | ------------------------------------------------------------------- | ------------ |
| U-1 | Búsqueda de localidades por CP.                   | `data_sepomex_localidades_get_cp.dart`, `data_localidad_find.dart`. | Implementado |
| U-2 | Búsqueda dial con Google Maps.                    | `pagina_busca_localidades_gmaps.dart` y Google Maps widget.         | Implementado |
| U-3 | Estado Freezed para búsqueda reactiva.            | `clase_busqueda_estado.g.dart` para separación.                     | Implementado |
| U-4 | Origen maestro para flujos de edición de espacio. | `screen_maestro_localidades.dart`.                                  | Implementado |

---

## 15. Feature: Pantallas — Tu Cuenta

**Directorio:** `lib/08_pantallas/tu_cuenta`

### 15.1 Subdirectorios/archivos representativos

Referencia encontrada en rutas y parámetros:

- `form_compra_espacios.dart`
- `form_update_espacio_comprado.dart`
- Subcarpeta `conocidos` con modelos/providers.

### 15.2 Requerimientos y estado

| ID   | Requerimiento                               | Evidencia                                                   | Estado       |
| ---- | ------------------------------------------- | ----------------------------------------------------------- | ------------ |
| TC-1 | Compra de espacios por publicación/usuario. | Rutas dedicadas para compra y edición.                      | Implementado |
| TC-2 | Actualización de espacio comprado.          | Form de edición dedicado.                                   | Implementado |
| TC-3 | Gestión de conocidos/contactos.             | Providers y modelos `conocido.dart` dentro de esta feature. | Implementado |

---

## 16. Feature: User Login

**Directorio:** `lib/10_user_login`

### 16.1 Archivos

- `login_01_login_page.dart`
- `login_03_form_register_user.dart`
- `page_cambio_password.dart`
- `page_solicitar_recuperacion.dart`
- `provider_session.dart` + `.g.dart`
- `session_repository.dart` + `.g.dart`
- `session_storage.dart`
- `data_session.dart`
- `data_models/auth_state.dart`, `data_get_user.dart`, `data_usuarios.dart`, `data_get_id_user_pass.dart`, `data_user_promotor.dart`
- `dialogbox_login.dart`
- `avatar/*` para avatar management

### 16.2 Modelos y estado

- `Usuario` con campos completos, `UbicacionUserData`, `UserDataPromotor`, `FechaDeNacimiento`.
- `AuthState` con flags de perfil y multi-rol.
- `SessionStorage` polimórfico: sesión local/segura según plataforma.
- Repositorio HTTP contra CouchDB por vistas y diseño.

### 16.3 Requerimientos y estado

| ID   | Requerimiento                                                                  | Evidencia                                                                                                         | Estado       |
| ---- | ------------------------------------------------------------------------------ | ----------------------------------------------------------------------------------------------------------------- | ------------ | ----------------- | ------------ |
| UL-1 | Login con usuario + contraseña y selección de perfil.                          | `LoginPage` con dropdown y `_handleLogin`.                                                                        | Implementado |
| UL-2 | Selección de perfil multi-rol.                                                 | Dropdown: Usuario, Promotor, Propietario, Anfitrión, Vendedor, Especialista, Proveedor, Asociación, Inmobiliaria. | Implementado |
| UL-3 | Registro de usuario nuevo.                                                     | `RegisterScreenUsers`                                                                                             |              | ruta `/registro`. | Implementado |
| UL-4 | Recuperación de contraseña.                                                    | Flujo solicitar recuperación + cambio por token con `deep_link_handler`.                                          | Implementado |
| UL-5 | Sesión persistente local.                                                      | `getSessionValuesFromLocalStorage` + `saveVarValueToLocalStorage`.                                                | Implementado |
| UL-6 | Cierre de sesión/reset.                                                        | `deleteLocalSessionData`, `resetInitialUserData`.                                                                 | Implementado |
| UL-7 | Hash de contraseña y almacenamiento seguro.                                    | SHA-256 de password, `userPassHash`, storage diferenciado por OS.                                                 | Implementado |
| UL-8 | Avatar por usuario.                                                            | Providers y páginas para manejo de avatar.                                                                        | Implementado |
| UL-9 | Multi-base por perfil: `buscobien_usuarios` y `buscobien_usuarios_promotores`. | `session_repository.dart` switch por `esPromotor`.                                                                | Implementado |

---

## 17. Feature: Localidades User

**Directorio:** `lib/12_localidades_user`

### 17.1 Archivos

- `data_user_localidad.dart` / `.freezed.dart` / `.g.dart`
- `data_user_localidad_get.dart` / `.freezed.dart` / `.g.dart`
- `localidades_repository.dart`
- `provider_get_localidades_usuario.dart`

### 17.2 Requerimientos y estado

| ID   | Requerimiento                            | Evidencia                                           | Estado       |
| ---- | ---------------------------------------- | --------------------------------------------------- | ------------ |
| LU-1 | Obtener localidades asociadas a usuario. | Provider y modelos Freezed para datos serializados. | Implementado |
| LU-2 | Rehidratar localidades desde CouchDB.    | `localidades_repository.dart`.                      | Implementado |
| LU-3 | Estado reactivo de localidades.          | `provider_get_localidades_usuario.dart`.            | Implementado |

---

## 18. Feature: Geolocalización

**Directorio:** `lib/14_geolocalizacion`

### 18.1 Archivos

- `google_map_mapa_propiedades.dart`
- `google_map_place_data.dart`
- `provider_actual_place.dart`
- `app_keys.dart`

### 18.2 Requerimientos y estado

| ID  | Requerimiento                                | Evidencia                                                     | Estado       |
| --- | -------------------------------------------- | ------------------------------------------------------------- | ------------ |
| G-1 | Mapa de propiedades por coordenadas.         | `PaginaMapaPropiedades` con `EspaciosCasaGet` como argumento. | Implementado |
| G-2 | Place data / marcadores detallados.          | `google_map_place_data.dart`.                                 | Implementado |
| G-3 | Place actual / ubicación actual del usuario. | `provider_actual_place.dart`.                                 | Implementado |
| G-4 | API keys / config.                           | `app_keys.dart`.                                              | Implementado |

---

## 19. Feature: Variables Globales

**Directorio:** `lib/20_var_globales`

### 19.1 Archivos

- `variables_globales.dart`
- `var_color_themes.dart`
- `var_color_widget.dart`
- `var_de_estilo_widgets.dart`
- `var_elementos_menus.dart`
- `var_login.dart`
- `couchdb_errors.dart`

### 19.2 Requerimientos y estado

| ID   | Requerimiento               | Evidencia                                       | Estado       |
| ---- | --------------------------- | ----------------------------------------------- | ------------ |
| VG-1 | Constantes UI globales.     | Tamaños de fuente, paddings, alturas de appbar. | Implementado |
| VG-2 | Theme colors centralizados. | `appTheme` y helpers por widget/theme.          | Implementado |
| VG-3 | Variables de sesión/login.  | `var_login.dart`.                               | Implementado |
| VG-4 | Errores CouchDB mapeados.   | `couchdb_errors.dart`.                          | Implementado |

---

## 20. Feature: Imágenes

**Directorio:** `lib/22_imagenes`

### 20.1 Archivos

- `variables_imagenes.dart`
- `data_models/data_fotos_casa.dart`
- `data_models/data_fotos_casa_get.dart`
- `data_models/data_fotos_casa_get_ids.dart`
- `data_models/data_fotos_ordenadas.dart`
- `inicio_fotos_usuario/pagina_carousel_fotos_usuario.dart`
- `inicio_fotos_usuario/pagina_carousel_fotos_usuario_mini.dart`
- `tus_espacios_fotos_propiedad/funciones_compress_image.dart`
- `tus_espacios_fotos_propiedad/image_file_structure.dart`

### 20.2 Modelos

- `DataFotosCasa`, `DataFotosCasaGet`, `DataFotosCasaGetIds`, `DataFotosOrdenadas`.

### 20.3 Requerimientos y estado

| ID   | Requerimiento                                      | Evidencia                                                  | Estado       |
| ---- | -------------------------------------------------- | ---------------------------------------------------------- | ------------ |
| IM-1 | Galería de fotos de propiedad paginada/miniaturas. | Rutas dedicadas y páginas de carrusel/miniatura.           | Implementado |
| IM-2 | Compresión de imagen.                              | `funciones_compress_image.dart`.                           | Implementado |
| IM-3 | Estructura de archivos de imagen local.            | `image_file_structure.dart`.                               | Implementado |
| IM-4 | Carousel en inicio de fotos de usuario.            | `inicio_fotos_usuario/pagina_carousel_fotos_usuario.dart`. | Implementado |

---

## 21. Feature: Security

**Directorio:** `lib/40_security`

### 21.1 Archivos

- `direccionip.dart`
- `encriptar.dart`
- `generate_hash.dart`
- `generate_reset_token.dart`
- `urls_endpoints_espacios.dart`

### 21.2 Requerimientos y estado

| ID  | Requerimiento                                      | Evidencia                             | Estado       |
| --- | -------------------------------------------------- | ------------------------------------- | ------------ |
| S-1 | Variables de entorno / CI para endpoint CouchDB.   | `direccionip.dart` con URL base.      | Implementado |
| S-2 | Hashing de claves para autenticación.              | `generate_hash.dart` SHA-256 y SHA-1. | Implementado |
| S-3 | Generación de token de recuperación de contraseña. | `generate_reset_token.dart`.          | Implementado |
| S-4 | Encriptación utilitaria.                           | `encriptar.dart`.                     | Implementado |
| S-5 | URLs/endpoints centralizados.                      | `urls_endpoints_espacios.dart`.       | Implementado |

---

## 22. Feature: Connectivity

**Directorio:** `lib/41_connectivity`

### 22.1 Archivos

- `connectivitycheck_provider.dart`
- `pagina_sin_coneccion.dart`

### 22.2 Requerimientos y estado

| ID  | Requerimiento                                              | Evidencia                                          | Estado       |
| --- | ---------------------------------------------------------- | -------------------------------------------------- | ------------ |
| C-1 | Monitoreo reactivo de conexión a internet.                 | Provider expone estado conectado/desconectado.     | Implementado |
| C-2 | Pantalla amigable cuando no hay conexión.                  | `PaginaSinConeccion` y ruta dedicada.              | Implementado |
| C-3 | Integración con splash para cerrar flujo antes de navegar. | `SplashPage` consulta conexión antes de continuar. | Implementado |

---

## 23. Feature: Sistema Operativo

**Directorio:** `lib/42_sistema_operativo`

### 23.1 Archivos

- `detecta_os.dart`

### 23.2 Requerimientos y estado

| ID   | Requerimiento                        | Evidencia                             | Estado       |
| ---- | ------------------------------------ | ------------------------------------- | ------------ |
| SO-1 | Detectar sistema operativo/platform. | Widget/página y helpers de detección. | Implementado |

---

## 24. Feature: Global Widgets

**Directorio:** `lib/60_global_widgets`

### 24.1 Archivos

- `debugprint.dart`
- `dialogbox_mensaje_general.dart`
- `bottom_fijo.dart`
- `derechos_reservados.dart`
- `future_builder_state_widgets.dart`
- `genera_cantidad_monetaria.dart`

### 24.2 Requerimientos y estado

| ID   | Requerimiento                              | Evidencia                                              | Estado       |
| ---- | ------------------------------------------ | ------------------------------------------------------ | ------------ |
| GW-1 | Sistema de debug por niveles.              | `debugprint.dart` con función `debugPrintLevels(...)`. | Implementado |
| GW-2 | Dialogo general reutilizable.              | `dialogbox_mensaje_general.dart`.                      | Implementado |
| GW-3 | Bottom bar persistente/fija.               | `bottom_fijo.dart`.                                    | Implementado |
| GW-4 | Footer derechos reservados.                | `derechos_reservados.dart`.                            | Implementado |
| GW-5 | FutureBuilder con manejo de estados Async. | `future_builder_state_widgets.dart`.                   | Implementado |
| GW-6 | Formateadores monetarios y utilitarios.    | `genera_cantidad_monetaria.dart`.                      | Implementado |

---

## 25. RNF y Riesgos

### 25.1 Requerimientos no funcionales clave

- **RNF-1:** Multiplataforma con comportamiento nativo en mobile, web y desktop.
- **RNF-2:** Estado reactivo y centralizado con Riverpod + Freezed.
- **RNF-3:** Persistencia de sesión diferenciada por plataforma seguro/no-seguro.
- **RNF-4:** Serialización JSON contra CouchDB sin locks pesados.
- **RNF-5:** Deep links para flujos críticos de recuperación.
- **RNF-6:** Google Maps integrado para propiedades y localidades.

### 25.2 Riesgos principales

- **Alto:** dependencia a variables globales y Basic Auth en código cliente (`username`/`password`), riesgo de exposición de credenciales.
- **Alto:** eliminación/escritura en CouchDB mediante `_deleted` por PUT, frágil frente a conflictos de `_rev`.
- **Medio:** mezcla de arquitectura reactiva con flags y variables globales mutables.
- **Medio:** mensajes de versión y flujos con lógica en comentarios/“Fase X” sin documentación formal consolidada.

---

## 26. Trazabilidad por Módulo

| Feature                  | Modelos | Providers/Pages | API/Hardware      | Estado general                  |
| ------------------------ | ------- | --------------- | ----------------- | ------------------------------- |
| 01_splash_screen         | —       | Sí              | —                 | Completo                        |
| 01_home                  | Sí      | Sí              | —                 | Completo                        |
| 02_principal_screen      | Sí      | Sí              | —                 | Completo                        |
| 03_listas                | Sí      | Sí              | HTTP              | Completo                        |
| 03_vistas                | Parcial | —               | —                 | Parcial / pantallas placeholder |
| 04_provider              | —       | Sí              | —                 | Parcial                         |
| 05_provider_menus        | —       | Sí              | —                 | Completo                        |
| 07_routes                | Parcial | Sí              | deep link         | Completo                        |
| 08_pantallas/inicio      | Sí      | Sí              | HTTP/Google Maps  | Completo                        |
| 08_pantallas/perfil      | Sí      | Sí              | —                 | Completo                        |
| 08_pantallas/propiedades | Sí      | Sí              | PDF/imágenes      | Completo                        |
| 08_pantallas/ubicacion   | Sí      | Sí              | Google Maps       | Completo                        |
| 10_user_login            | Sí      | Sí              | HTTP              | Completo                        |
| 12_localidades_user      | Sí      | Sí              | HTTP              | Completo                        |
| 14_geolocalizacion       | —       | Sí              | Google Maps       | Completo                        |
| 20_var_globales          | —       | —               | —                 | Completo                        |
| 22_imagenes              | Sí      | Sí              | file/image picker | Completo                        |
| 40_security              | —       | —               | —                 | Completo                        |
| 41_connectivity          | —       | Sí              | connectivity_plus | Completo                        |
| 42_sistema_operativo     | —       | Sí              | plataforma        | Completo                        |
| 60_global_widgets        | —       | —               | —                 | Completo                        |

---

## 27. Supuestos y Limitaciones

- Este documento deriva exclusivamente del código en `/mnt/buscobien`.
- No hay documentación formal previa de API o backend; todo el conocimiento del protocolo proviene de rutas/parámetros/clientes HTTP hardcodeados.
- El proyecto actual es un producto funcional con backend CouchDB expuesto en cliente; cualquier cambio de arquitectura real debería encapsular credenciales y rutas en backend seguro.
- No se realizaron cambios de código; toda la trazabilidad es estática por lectura.
