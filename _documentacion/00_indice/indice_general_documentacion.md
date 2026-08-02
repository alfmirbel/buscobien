# Índice General de Documentación — `/mnt/buscobien/_documentacion`

**Última actualización:** 2026-07-25  
**Alcance:** Inventario real de archivos y carpetas presentes en `/mnt/buscobien/_documentacion/`.

---

## Estructura general

- `00_indice/` — Índices maestros y guías de navegación documental.
- `00_inventario/` — Inventarios por módulo, reportes, análisis de código muerto, uso de CouchDB y hallazgos.
- `01_EARS/` — Requerimientos EARS, BDD/EARS consolidado y documento `.docx` final unificado.
- `02_BDD/` — Especificaciones BDD en Gherkin.
- `03_SDD/` — SDDs generales y por feature, arquitectura, flujos, planificación y JSON.
- `04_guias/` — Guías operativas, motor social, plan UI/UX y reglas de diseño.

---

## Directorio `00_indice/`

| Archivo                           | Contenido principal                        |
| --------------------------------- | ------------------------------------------ |
| `indice_general_documentacion.md` | Índice maestro del repositorio documental. |

---

## Directorio `00_inventario/`

| Archivo                                                  | Contenido principal                               |
| -------------------------------------------------------- | ------------------------------------------------- |
| `modulos_inventariados.md`                               | Resumen de módulos inventariados.                 |
| `resumen_modulos_inventariados.md`                       | Resumen ejecutivo de módulos.                     |
| `reporte_archivos_buscobien.md`                          | Reporte general de archivos.                      |
| `reporte_archivos_buscobien_inicial.md`                  | Reporte inicial de archivos.                      |
| `reporte_cambios_hallazgos_ubicacion.md`                 | Cambios y hallazgos de ubicación.                 |
| `reporte_modulos_localidades.md`                         | Reporte de módulos de localidades.                |
| `dead_code_analysis.md`                                  | Análisis de código muerto.                        |
| `USO_couchdb_databases.md`                               | Uso de bases de datos CouchDB.                    |
| `inventario_01_home.md`                                  | Inventario de `lib/01_home`.                      |
| `inventario_01_splash_screen.md`                         | Inventario de `lib/01_splash_screen`.             |
| `inventario_02_principal_screen.md`                      | Inventario de `lib/02_principal_screen`.          |
| `inventario_03_listas.md`                                | Inventario de `lib/03_listas`.                    |
| `inventario_03_vistas.md`                                | Inventario de `lib/03_vistas`.                    |
| `inventario_04_provider.md`                              | Inventario de `lib/04_provider`.                  |
| `inventario_05_provider_menus.md`                        | Inventario de `lib/05_provider_menus`.            |
| `inventario_07_routes.md`                                | Inventario de `lib/07_routes`.                    |
| `inventario_08_pantallas_inicio.md`                      | Inventario de `lib/08_pantallas/inicio`.          |
| `inventario_08_pantallas_maestro.md`                     | Inventario maestro de `lib/08_pantallas`.         |
| `inventario_08_pantallas_perfil.md`                      | Inventario de `lib/08_pantallas/perfil`.          |
| `inventario_08_pantallas_propiedades.md`                 | Inventario de `lib/08_pantallas/propiedades`.     |
| `inventario_08_pantallas_tu_cuenta.md`                   | Inventario de `lib/08_pantallas/tu_cuenta`.       |
| `inventario_08_pantallas_ubicacion.md`                   | Inventario de `lib/08_pantallas/ubicacion`.       |
| `inventario_08_pantallas_widgets_comunes.md`             | Inventario de `lib/08_pantallas/widgets_comunes`. |
| `inventario_10_user_login_avatar.md`                     | Inventario de avatar/login.                       |
| `inventario_10_user_login_data_models.md`                | Inventario de modelos de login.                   |
| `inventario_10_user_login_usuario_login.md`              | Inventario de login de usuario.                   |
| `inventario_12_localidades_user.md`                      | Inventario de `lib/12_localidades_user`.          |
| `inventario_14_geolocalizacion.md`                       | Inventario de `lib/14_geolocalizacion`.           |
| `inventario_20_var_globales.md`                          | Inventario de `lib/20_var_globales`.              |
| `inventario_22_imagenes.md`                              | Inventario de `lib/22_imagenes`.                  |
| `inventario_22_imagenes_data_models.md`                  | Inventario de modelos de imágenes.                |
| `inventario_22_imagenes_inicio_fotos_usuario.md`         | Inventario de fotos de usuario.                   |
| `inventario_22_imagenes_tus_espacios_fotos_propiedad.md` | Inventario de fotos de propiedad.                 |
| `inventario_40_security.md`                              | Inventario de `lib/40_security`.                  |
| `inventario_41_connectivity.md`                          | Inventario de `lib/41_connectivity`.              |
| `inventario_42_sistema_operativo.md`                     | Inventario de `lib/42_sistema_operativo`.         |
| `inventario_60_global_widgets.md`                        | Inventario de `lib/60_global_widgets`.            |

---

## Directorio `01_EARS/`

| Archivo                            | Contenido principal                           |
| ---------------------------------- | --------------------------------------------- |
| `Buscobien_EARS_Requirements.md`   | Requerimientos consolidados en notación EARS. |
| `Buscobien_EARS_Requirements.docx` | Documento EARS en formato Word.               |
| `buscobien_bdd_EARS.md`            | Consolidado BDD/EARS.                         |

---

## Directorio `02_BDD/`

| Archivo            | Contenido principal                       |
| ------------------ | ----------------------------------------- |
| `buscobien_bdd.md` | Especificaciones BDD/Gherkin por feature. |

---

## Directorio `03_SDD/`

| Archivo                                       | Contenido principal                          |
| --------------------------------------------- | -------------------------------------------- |
| `Buscobien_SDD.md`                            | SDD general del proyecto.                    |
| `MotorSocial_SDD.md`                          | SDD del motor social.                        |
| `TuCuenta_SDD.md`                             | SDD de Tu Cuenta.                            |
| `01_motor_social.md`                          | Documento base del motor social.             |
| `02_motor_social_mis_conocidos.md`            | SDD/feature Mis Conocidos.                   |
| `03_motor_social_mis_grupos.md`               | SDD/feature Mis Grupos.                      |
| `03_plan_implementacion_mis_grupos.md`        | Plan de implementación de Mis Grupos.        |
| `03_requerimientos_mis_grupos.md`             | Requerimientos de Mis Grupos.                |
| `especificacion_motor_social.md`              | Especificación del motor social.             |
| `arquitectura_navegacion.md`                  | Arquitectura y reorganización de navegación. |
| `auditoria_ui_ux_diseno_navegacion_flujos.md` | Auditoría UI/UX y flujos.                    |
| `flujo_operacion_buscobien.md`                | Flujo de operación paso a paso.              |
| `buscobien_sdd_openapi.json`                  | Especificación JSON del diseño/SDD.          |

---

## Directorio `04_guias/`

| Archivo                                                           | Contenido principal                        |
| ----------------------------------------------------------------- | ------------------------------------------ |
| `antigravity_ui_rules.md`                                         | Reglas UI y convenciones de diseño.        |
| `plan_trabajo_ui_ux_diseno_navegacion_flujos.md`                  | Plan de trabajo UI/UX y flujos.            |
| `01_motor_social.md`                                              | Guía base del motor social.                |
| `02_motor_social_mis_conocidos.md`                                | Guía de Mis Conocidos.                     |
| `03_motor_social_mis_grupos.md`                                   | Guía de Mis Grupos.                        |
| `03_plan_implementacion_mis_grupos.md`                            | Plan de implementación.                    |
| `03_requerimientos_mis_grupos.md`                                 | Requerimientos del módulo.                 |
| `GUIA Notificaciones entre Usuarios Tipos y Mejores Prácticas.md` | Guía de notificaciones y buenas prácticas. |

---

## Observaciones

- Los documentos de `00_inventario/` cubren módulos de `lib/` desde `01_home` hasta `60_global_widgets`.
- El documento unificado actualizado está en `01_EARS/Buscobien_EARS_Requirements.docx`.
