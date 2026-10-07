# Etapa 3: Análisis Funcional y BDD (SDLC Stage 3)

Esta carpeta reúne la matriz de trazabilidad del sistema, las especificaciones funcionales de alto nivel y los archivos de características BDD (*Behavior-Driven Development*) expresados en sintaxis Gherkin.

---

## 📄 Estructura de Documentos en esta Etapa

| Elemento / Directorio | Descripción | Enlace Directo |
| :--- | :--- | :--- |
| **`bdd_high_level_specs.md`** | Resumen ejecutivo de las características funcionales de alto nivel probadas con BDD Gherkin. | [Ver Documento](bdd_high_level_specs.md) |
| **`matriz_trazabilidad_ears_bdd_sdd.md`** | Matriz **generada** (`generar_matriz_trazabilidad.py`): módulo y requerimiento EARS ➔ historia de usuario ➔ SDD ➔ Gherkin, con cobertura y brechas. | [Ver Documento](matriz_trazabilidad_ears_bdd_sdd.md) |
| **`reconciliacion_epics_sdd.md`** | Reconciliación de los catálogos `REQ-*` (Epics) y `DES-*`/`SDD-*` (SDD), método de mapeo, resultados y flujo de revisión; datos en `mapeo_req_diseno.csv` y `mapeo_req_gherkin.csv`. | [Ver Documento](reconciliacion_epics_sdd.md) |
| **Rol de los `.feature`** | `features_analisis/` = vista funcional de alto nivel (1–3 archivos por módulo, para negocio); `07_pruebas_y_calidad/gherkin_bdd_scenarios/` = escenarios detallados y candidatos a automatizar. No se fusionan: tienen audiencia y granularidad distintas, y ambos llevan tags `@REQ-*`. | — |
| **`features_analisis/`** | Colección de 48 archivos `.feature` de especificación funcional BDD de alto nivel: uno o más por módulo de `lib/` y, en `transversales/`, características que cruzan varios módulos (login, splash, localidades, listas, imágenes, etc.). | [Explorar Features](features_analisis/) |
