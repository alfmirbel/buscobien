# Índice General de Documentación — `/mnt/buscobien/_documentacion`

> Guía de navegación de la documentación del proyecto Buscobien.  
> **Estructura:** directorios temáticos con archivos `.md`.  
> **Última actualización:** julio 2026.

---

## Directorio raíz `/mnt/buscobien/_documentacion`

| # | Archivo | Título / contenido principal |
|---|---------|------------------------------|
| 1 | `antigravity_ui_rules.md` | Reglas y estilos globales para el diseño de interfaces. |
| 2 | `arquitectura_navegacion.md` | Reorganización de menús y arquitectura de navegación. |
| 3 | `Buscobien_SDD.md` | Software Design Document del proyecto Buscobien. |
| 4 | `flujo_operacion_buscobien.md` | Flujo de operación de Buscobien: pantallas, menús y arranque. |
| 5 | `reporte_archivos_buscobien.md` | Reporte general de archivos del proyecto. |
| 6 | `resumen_modulos_inventariados.md` | Resumen ejecutivo de los módulos inventariados. |
| 7 | `TuCuenta_SDD.md` | Software Design Document del módulo TuCuenta. |

---

## Subdirectorio `diseno_motor_social/`

Documentación específica del **Motor Social**.

| # | Archivo | Título / contenido principal |
|---|---------|------------------------------|
| 1 | `01_motor_social.md` | Documento base del Motor Social. |
| 2 | `02_motor_social_mis_conocidos.md` | Funcionalidad de la opción **Mis conocidos**. |
| 3 | `03_motor_social_mis_grupos.md` | Funcionalidad de la opción **Mis grupos**. |
| 4 | `03_plan_implementacion_mis_grupos.md` | Plan de implementación del módulo Mis grupos. |
| 5 | `03_requerimientos_mis_grupos.md` | Requerimientos del módulo Mis grupos. |
| 6 | `MotorSocial_SDD.md` | Software Design Document del Motor Social. |
| 7 | `especificacion_motor_social.md` | Especificación técnica del Motor Social. |

---

## Subdirectorio `inventario_componentes/`

Inventarios técnicos orientados al componente/lib correspondiente en `lib/`.

| # | Archivo | Módulo `lib/` | Contenido principal |
|---|---------|---------------|---------------------|
| 1 | `inventario_01_home.md` | `lib/01_home` | Inventario de componentes de Home. |
| 2 | `inventario_01_splash_screen.md` | `lib/01_splash_screen` | Pantalla de splash inicial. |
| 3 | `inventario_02_principal_screen.md` | `lib/02_principal_screen` | Pantalla principal. |
| 4 | `inventario_03_listas.md` | `lib/03_listas` | Módulo de listas. |
| 5 | `inventario_03_vistas.md` | `lib/03_vistas` | Vistas compartidas. |
| 6 | `inventario_04_provider.md` | `lib/04_provider` | Providers base. |
| 7 | `inventario_05_provider_menus.md` | `lib/05_provider_menus` | Providers de menús. |
| 8 | `inventario_07_routes.md` | `lib/07_routes` | Enrutamiento de la app. |
| 9 | `inventario_08_pantallas_inicio.md` | `lib/08_pantallas/inicio` | Pantallas de inicio. |
| 10 | `inventario_08_pantallas_perfil.md` | `lib/08_pantallas/perfil` | Pantallas de perfil. |
| 11 | `inventario_08_pantallas_propiedades.md` | `lib/08_pantallas/propiedades` | Pantallas de propiedades. |
| 12 | `inventario_08_pantallas_tu_cuenta.md` | `lib/08_pantallas/tu_cuenta` | Pantallas de TuCuenta. |
| 13 | `inventario_08_pantallas_ubicacion.md` | `lib/08_pantallas/ubicacion` | Pantallas de ubicación. |
| 14 | `inventario_08_pantallas_widgets_comunes.md` | `lib/08_pantallas/widgets_comunes` | Widgets compartidos. |
| 15 | `inventario_10_user_login_avatar.md` | `lib/10_user_login/avatar` | Gestión de avatar en login. |
| 16 | `inventario_10_user_login_data_models.md` | `lib/10_user_login/data_models` | Modelos de datos del login. |
| 17 | `inventario_10_user_login_usuario_login.md` | `lib/10_user_login/usuario_login` | Flujo de usuario y login. |
| 18 | `inventario_12_localidades_user.md` | `lib/12_localidades_user` | Localidades asociadas al usuario. |
| 19 | `inventario_14_geolocalizacion.md` | `lib/14_geolocalizacion` | Módulo de geolocalización. |
| 20 | `inventario_20_var_globales.md` | `lib/20_var_globales` | Variables globales y entorno. |
| 21 | `inventario_22_imagenes.md` | `lib/22_imagenes` | Módulo de imágenes (inventario global). |
| 22 | `inventario_22_imagenes_data_models.md` | `lib/22_imagenes/data_models` | Modelos de datos de imágenes. |
| 23 | `inventario_22_imagenes_inicio_fotos_usuario.md` | `lib/22_imagenes/inicio_fotos_usuario` | Fotos de usuario en inicio. |
| 24 | `inventario_22_imagenes_tus_espacios_fotos_propiedad.md` | `lib/22_imagenes/tus_espacios_fotos_propiedad` | Fotos de espacios/propiedad. |
| 25 | `inventario_40_security.md` | `lib/40_security` | Seguridad y autenticación. |
| 26 | `inventario_41_connectivity.md` | `lib/41_connectivity` | Conectividad y comunicación. |
| 27 | `inventario_42_sistema_operativo.md` | `lib/42_sistema_operativo` | Adaptación a sistema operativo. |
| 28 | `inventario_60_global_widgets.md` | `lib/60_global_widgets` | Widgets globales reutilizables. |
| 29 | `modulos_inventariados.md` | General | Arquitectura general de módulos. |
| 30 | `reporte_archivos_buscobien.md` | General | Reporte de archivos Dart según flujo/menús. |
| 31 | `reporte_archivos_buscobien_inicial.md` | General | Reporte inicial de archivos Dart. |
| 32 | `resumen_modulos_inventariados.md` | General | Resumen ejecutivo de módulos. |

---

## Subdirectorio `inventario_elementos/`

Inventarios de elementos de UI/interacción dentro de cada módulo `lib/`.

| # | Archivo | Módulo `lib/` | Contenido principal |
|---|---------|---------------|---------------------|
| 1 | `dead_code_analysis.md` | Todo `lib/` | Análisis de código muerto en el proyecto Flutter. |
| 2 | `GUIA Notificaciones entre Usuarios Tipos y Mejores Prácticas.md` | Varios | Tipos de notificaciones y mejores prácticas. |
| 3 | `inventario_01_home.md` | `lib/01_home` | Elementos UI y lógica de Home. |
| 4 | `inventario_01_splash_screen.md` | `lib/01_splash_screen` | Pantalla de splash. |
| 5 | `inventario_02_principal_screen.md` | `lib/02_principal_screen` | Pantalla principal. |
| 6 | `inventario_03_listas.md` | `lib/03_listas` | Elementos de listas. |
| 7 | `inventario_03_vistas.md` | `lib/03_vistas` | Vistas detalladas. |
| 8 | `inventario_04_provider.md` | `lib/04_provider` | Providers. |
| 9 | `inventario_05_provider_menus.md` | `lib/05_provider_menus` | Providers de menús. |
| 10 | `inventario_07_routes.md` | `lib/07_routes` | Rutas y navegación. |
| 11 | `inventario_08_pantallas_inicio.md` | `lib/08_pantallas/inicio` | Pantallas de inicio. |
| 12 | `inventario_08_pantallas_perfil.md` | `lib/08_pantallas/perfil` | Pantallas de perfil. |
| 13 | `inventario_08_pantallas_propiedades.md` | `lib/08_pantallas/propiedades` | Pantallas de propiedades. |
| 14 | `inventario_08_pantallas_tu_cuenta.md` | `lib/08_pantallas/tu_cuenta` | Pantallas de TuCuenta. |
| 15 | `inventario_08_pantallas_ubicacion.md` | `lib/08_pantallas/ubicacion` | Pantallas de ubicación. |
| 16 | `inventario_08_pantallas_widgets_comunes.md` | `lib/08_pantallas/widgets_comunes` | Widgets comunes. |
| 17 | `inventario_10_user_login_avatar.md` | `lib/10_user_login/avatar` | Avatar en login. |
| 18 | `inventario_10_user_login_data_models.md` | `lib/10_user_login/data_models` | Modelos del login. |
| 19 | `inventario_10_user_login_usuario_login.md` | `lib/10_user_login/usuario_login` | Flujo de login. |
| 20 | `inventario_12_localidades_user.md` | `lib/12_localidades_user` | Localidades del usuario. |
| 21 | `inventario_14_geolocalizacion.md` | `lib/14_geolocalizacion` | Geolocalización. |
| 22 | `inventario_20_var_globales.md` | `lib/20_var_globales` | Variables globales. |
| 23 | `inventario_22_imagenes.md` | `lib/22_imagenes` | Inventario de elementos del módulo imágenes. |
| 24 | `reporte_archivos_buscobien.md` | General | Reporte de archivos Dart (flujo/menús). |
| 25 | `reporte_archivos_buscobien_inicial.md` | General | Reporte inicial de archivos Dart. |

---

## Subdirectorio `inventarios_bases_datos/`

Documentación de persistencia y base de datos.

| # | Archivo | Contenido principal |
|---|---------|---------------------|
| 1 | `USO_couchdb_databases.md` | Uso y estructura de bases de datos CouchDB en Buscobien. |

---

## Subdirectorio `reportes_ubicacion/`

Reportes específicos del módulo de **Ubicación / Localidades**.

| # | Archivo | Contenido principal |
|---|---------|---------------------|
| 1 | `reporte_cambios_hallazgos_ubicacion.md` | Cambios, hallazgos y recomendaciones del módulo de Ubicación. |
| 2 | `reporte_modulos_localidades.md` | Reporte de arquitectura de módulos de Localización y Ubicación. |

---

## Cómo usar este índice

1. Busca primero por **subdirectorio** para acotar el dominio.  
2. Si buscas el **componente**, ve a `inventario_componentes/`.  
3. Si buscas los **elementos de UI/interacción**, ve a `inventario_elementos/`.  
4. Para reglas, flujo general o arquitectura, usa el **directorio raíz**.  
5. Si necesitas profundizar en un módulo concreto, consulta el `SDD` o la especificación correspondiente.

---

*Documento generado automáticamente por agente pm_analista.*
