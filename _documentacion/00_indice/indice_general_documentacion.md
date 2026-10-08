# Índice General de Documentación — `D:\buscobien\_documentacion`

**Última consolidación:** 2026-10-07  
**Alcance:** repositorio único de documentación técnica de **BuscoBien** (Flutter + API Node.js + CouchDB), ordenado por las 8 etapas del ciclo de vida del desarrollo de sistemas (SDLC). Cada documento existe en un solo lugar.

```mermaid
flowchart LR
    E1["01 Planeación"] --> E2["02 Requerimientos"] --> E3["03 Análisis funcional"] --> E4["04 Arquitectura y diseño"]
    E4 --> E5["05 Desarrollo y especif. técnicas"] --> E6["06 Modelo de datos"] --> E7["07 Pruebas y calidad"] --> E8["08 Operación y despliegue"]
```

---

## Lectura obligatoria / acceso rápido

| Si buscas… | Ve a… |
| :--- | :--- |
| **Reglas de UI (Material 3)** — obligatorias antes de cualquier cambio visual | [`antigravity_ui_rules.md`](../05_desarrollo_y_especificaciones_tecnicas/antigravity_ui_rules.md) |
| **Arquitectura general** (Riverpod + Freezed + Dio + API + CouchDB) | [`arquitectura_general_buscobien.md`](../04_arquitectura_y_diseno/arquitectura_general_buscobien.md) |
| **Arquitectura de navegación** | [`arquitectura_navegacion.md`](../04_arquitectura_y_diseno/arquitectura_navegacion.md) |
| **Motor social** (Conocidos, Grupos, mensajería) | [`especificacion_motor_social.md`](../04_arquitectura_y_diseno/especificacion_motor_social.md) |
| **Stack y comandos de compilación** | [`stack_tecnologico.md`](../05_desarrollo_y_especificaciones_tecnicas/stack_tecnologico.md) |
| **Mapa de módulos de `lib/`** | [`dominios_modulos_archivos.md`](../05_desarrollo_y_especificaciones_tecnicas/dominios_modulos_archivos.md) |
| **Bases de datos CouchDB (35 referenciadas en código)** | [`buscobien_databases_complete.md`](../06_modelo_de_datos_y_bd/buscobien_databases_complete.md) |
| **Resumen por módulo** | [`resumen_modulos_inventariados.md`](../05_desarrollo_y_especificaciones_tecnicas/inventario_componentes/resumen_modulos_inventariados.md) |
| **Acceso SSH / servidor** | [`ssh_servidor_y_despliegue.md`](../08_operacion_guias_y_despliegue/ssh_servidor_y_despliegue.md) |

---

## Catálogo por etapa

### 00 — `00_indice/`
| Documento | Contenido |
| :--- | :--- |
| [`indice_general_documentacion.md`](indice_general_documentacion.md) | Este catálogo. |
| [`indice_archivos_modelos.md`](indice_archivos_modelos.md) | Índice exhaustivo de modelos de datos y entidades Freezed de `lib/`. |
| [`verificar_documentacion.py`](verificar_documentacion.py) | Script de verificación: contrasta la documentación con `lib/` (enlaces, inventarios, credenciales, IDs, bases de datos). |
| [`GUIA_ESTANDAR_DOCUMENTACION_SDLC.md`](GUIA_ESTANDAR_DOCUMENTACION_SDLC.md) | Estándar reutilizable para generar y mantener esta documentación, con script de validación de enlaces. |

### 01 — [`01_planeacion_y_estrategia/`](../01_planeacion_y_estrategia/README.md)
- [`okrs_y_lean_canvas.md`](../01_planeacion_y_estrategia/okrs_y_lean_canvas.md) — Lean Canvas y OKRs.
- [`plan_de_trabajo.md`](../01_planeacion_y_estrategia/plan_de_trabajo.md) — metodologías, estado de las capas documentales y definición de terminado.

### 02 — [`02_requerimientos/`](../02_requerimientos/README.md)
- [`EARS_requerimientos_consolidados.md`](../02_requerimientos/EARS_requerimientos_consolidados.md) — patrones EARS y matriz de requerimientos.
- [`epics_ears/`](../02_requerimientos/epics_ears/) — 26 Epics con requerimientos EARS, uno por módulo de `lib/`.
- [`user_stories/`](../02_requerimientos/user_stories/) — 129 historias de usuario en 27 archivos (índice generado) ([índice](../02_requerimientos/user_stories/00_indice_user_stories.md)).

### 03 — [`03_analisis_funcional/`](../03_analisis_funcional/README.md)
- [`bdd_high_level_specs.md`](../03_analisis_funcional/bdd_high_level_specs.md) — resumen funcional de alto nivel.
- [`matriz_trazabilidad_ears_bdd_sdd.md`](../03_analisis_funcional/matriz_trazabilidad_ears_bdd_sdd.md) — trazabilidad EARS ➔ BDD ➔ SDD.
- [`reconciliacion_epics_sdd.md`](../03_analisis_funcional/reconciliacion_epics_sdd.md) — reconciliación Epics ↔ SDD ↔ Gherkin; scripts `mapeo_trazabilidad.py`, `etiquetar_features.py`, `generar_matriz_trazabilidad.py`.
- [`features_analisis/`](../03_analisis_funcional/features_analisis/) — 48 `.feature` de análisis (por módulo y `transversales/`).

### 04 — [`04_arquitectura_y_diseno/`](../04_arquitectura_y_diseno/README.md)
- [`arquitectura_general_buscobien.md`](../04_arquitectura_y_diseno/arquitectura_general_buscobien.md), [`arquitectura_navegacion.md`](../04_arquitectura_y_diseno/arquitectura_navegacion.md), [`especificacion_motor_social.md`](../04_arquitectura_y_diseno/especificacion_motor_social.md).
- [`arquitectura_c4.md`](../04_arquitectura_y_diseno/arquitectura_c4.md), [`contrato_api_actual.md`](../04_arquitectura_y_diseno/contrato_api_actual.md), [`modelo_de_amenazas.md`](../04_arquitectura_y_diseno/modelo_de_amenazas.md), [`adr/registro_decisiones.md`](../04_arquitectura_y_diseno/adr/registro_decisiones.md) — C4, interfaces reales, STRIDE y ADR.
- [`buscobien_sdd_maestro.md`](../04_arquitectura_y_diseno/buscobien_sdd_maestro.md) — SDD maestro.
- [`modulos_sdd/`](../04_arquitectura_y_diseno/modulos_sdd/) — 29 SDD detallados por módulo (incluye `07_routes`).

### 05 — [`05_desarrollo_y_especificaciones_tecnicas/`](../05_desarrollo_y_especificaciones_tecnicas/README.md)
- [`stack_tecnologico.md`](../05_desarrollo_y_especificaciones_tecnicas/stack_tecnologico.md), [`dominios_modulos_archivos.md`](../05_desarrollo_y_especificaciones_tecnicas/dominios_modulos_archivos.md), [`antigravity_ui_rules.md`](../05_desarrollo_y_especificaciones_tecnicas/antigravity_ui_rules.md).
- [`inventario_componentes/`](../05_desarrollo_y_especificaciones_tecnicas/inventario_componentes/) — vista arquitectónica por módulo con diagramas Mermaid (32 documentos, incluye reportes consolidados).
- [`inventario_elementos/`](../05_desarrollo_y_especificaciones_tecnicas/inventario_elementos/) — tablas de 10 columnas por archivo fuente (26 documentos).

### 06 — [`06_modelo_de_datos_y_bd/`](../06_modelo_de_datos_y_bd/README.md)
- [`bases_de_datos_en_codigo.md`](../06_modelo_de_datos_y_bd/bases_de_datos_en_codigo.md) — inventario generado de las bases referenciadas en `lib/`.
- [`buscobien_databases_complete.md`](../06_modelo_de_datos_y_bd/buscobien_databases_complete.md) — diccionario de esquemas (19 de diseño), inventario de las 35 bases referenciadas en el código, convenciones de IDs, índices Mango y apéndice de uso en `lib/`.

### 07 — [`07_pruebas_y_calidad/`](../07_pruebas_y_calidad/README.md)
- [`estrategia_de_pruebas_y_smoke_tests.md`](../07_pruebas_y_calidad/estrategia_de_pruebas_y_smoke_tests.md).
- [`gherkin_bdd_scenarios/`](../07_pruebas_y_calidad/gherkin_bdd_scenarios/) — 129 `.feature` con escenarios detallados por módulo y pantalla.

### 08 — [`08_operacion_guias_y_despliegue/`](../08_operacion_guias_y_despliegue/README.md)
- [`runbook_operacion.md`](../08_operacion_guias_y_despliegue/runbook_operacion.md), [`ssh_servidor_y_despliegue.md`](../08_operacion_guias_y_despliegue/ssh_servidor_y_despliegue.md), [`guia_motor_social_y_grupos.md`](../08_operacion_guias_y_despliegue/guia_motor_social_y_grupos.md), [`guia_notificaciones_entre_usuarios.md`](../08_operacion_guias_y_despliegue/guia_notificaciones_entre_usuarios.md), [`plan_trabajo_ui_ux_navegacion.md`](../08_operacion_guias_y_despliegue/plan_trabajo_ui_ux_navegacion.md).

---

## Reglas de mantenimiento

1. **Un solo lugar**: toda la documentación vive en `D:\buscobien\_documentacion\`; no se crean copias («- copia») ni carpetas paralelas.
2. **Sin credenciales**: nunca se escriben contraseñas ni API keys; se usan `defines.json` / `--dart-define`.
3. **Enlaces relativos** a archivos existentes (script de validación en la [guía estándar](GUIA_ESTANDAR_DOCUMENTACION_SDLC.md)).
4. **UI**: todo cambio visual sigue [`antigravity_ui_rules.md`](../05_desarrollo_y_especificaciones_tecnicas/antigravity_ui_rules.md).
5. **Alta de módulo nuevo**: agregar Epic EARS, User Stories, Feature, SDD, inventarios y escenarios Gherkin en su etapa, y actualizar este índice.
