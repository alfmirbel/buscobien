# Plan de Trabajo — Documentación del Sistema (Ingeniería Inversa + SDLC)

**Proyecto:** BuscoBien — Plataforma de promoción inmobiliaria (Flutter + Riverpod 3.x + Freezed + Dio + Google Maps; API Node.js + CouchDB)  
**Alcance:** documentación completa derivada de `D:\buscobien\lib` (199 archivos `.dart` no generados)  
**Última actualización:** 2026-10-07 — documentación consolidada y reordenada por etapas del SDLC

> Este documento sustituye al «Plan de Trabajo Fase 1» (2026-08-12). Se eliminaron el análisis de brechas, la estimación de esfuerzo y la estructura de salida provisional (`_analisisydiseno`), todos ya superados: las 6 capas existen para todos los módulos y la documentación vive en una sola jerarquía por etapa del SDLC (ver [índice general](../00_indice/indice_general_documentacion.md)).

---

## 1. Estado

| Capa original | Ubicación actual | Estado |
| :--- | :--- | :--- |
| Iniciativa (OKRs + Lean Canvas) | [`okrs_y_lean_canvas.md`](okrs_y_lean_canvas.md) | Completo |
| Epics EARS | [`02_requerimientos/epics_ears/`](../02_requerimientos/epics_ears/) | Completo (26 módulos) |
| Features BDD de análisis | [`03_analisis_funcional/features_analisis/`](../03_analisis_funcional/features_analisis/) | Completo |
| User Stories | [`02_requerimientos/user_stories/`](../02_requerimientos/user_stories/) | Completo (una por módulo) |
| Inventarios (componentes y elementos) | [`05_desarrollo_y_especificaciones_tecnicas/`](../05_desarrollo_y_especificaciones_tecnicas/) | Completo; consolidado en dos conjuntos |
| Bases de datos | [`06_modelo_de_datos_y_bd/`](../06_modelo_de_datos_y_bd/) | Completo (19 DBs `buscobien_*`) |
| SDD por módulo | [`04_arquitectura_y_diseno/modulos_sdd/`](../04_arquitectura_y_diseno/modulos_sdd/) | Completo |
| Escenarios Gherkin detallados | [`07_pruebas_y_calidad/gherkin_bdd_scenarios/`](../07_pruebas_y_calidad/gherkin_bdd_scenarios/) | Completo |

---

## 2. Metodologías por entregable

| Entregable | Metodología | Estructura obligatoria |
| :--- | :--- | :--- |
| **Iniciativa** | OKRs + Lean Canvas | Objetivo, 3–5 KR medibles con evidencia en código, Canvas de 9 bloques |
| **Epics** | User Story Mapping + Impact Mapping + SDD | Una Epic por módulo de `lib/`; requerimientos EARS (5 patrones + complejos) |
| **Features** | BDD (Gherkin `# language: es`) | `Característica:` + escenarios `Dado/Cuando/Entonces` |
| **User Stories** | 3 C's (Card, Conversation, Confirmation) | «Como [rol] quiero [acción] para [beneficio]» + criterios de aceptación |
| **Inventarios** | Inventario técnico por archivo `.dart` | *Componentes*: análisis y diagramas Mermaid por módulo. *Elementos*: tabla de 10 columnas por archivo (variables, clases, funciones, llamadas) |
| **Bases de datos** | Análisis de modelos Dart + mapeo a CouchDB | Estructura Dart, diccionario de datos, JSON, DB `buscobien_*`, Mango, vistas, índices |

Orden de trabajo por módulo (dependencias arquitectónicas, base → features → UI): `main` → `01_splash_screen` → `01_home` → `02_principal_screen` → `07_routes` → `04_provider` → `05_provider_menus` → `10_user_login` → `12_localidades_user` → `14_geolocalizacion` → `20_var_globales` → `40_security` → `41_connectivity` → `42_sistema_operativo` → `60_global_widgets` → `03_listas` / `03_vistas` → `08_pantallas/*` → `22_imagenes`.

---

## 3. Definición de terminado (mantenimiento continuo)

Al cambiar código en `lib/`, la documentación se considera al día cuando:

- [ ] El módulo afectado conserva sus capas: Epic EARS, User Stories, Feature de análisis, SDD, inventarios y escenarios Gherkin.
- [ ] Las bases de datos nuevas o modificadas están en [`buscobien_databases_complete.md`](../06_modelo_de_datos_y_bd/buscobien_databases_complete.md).
- [ ] Los modelos Freezed nuevos están en [`indice_archivos_modelos.md`](../00_indice/indice_archivos_modelos.md).
- [ ] No hay credenciales en los documentos (se usan `defines.json` / `--dart-define`).
- [ ] Los enlaces internos son relativos y apuntan a archivos existentes.
- [ ] `flutter analyze` pasa sin warnings.

---

## 4. Clasificación de módulos por nivel de profundidad

Criterios de la [guía](../00_indice/GUIA_ESTANDAR_DOCUMENTACION_SDLC.md): **A** = autenticación, seguridad, datos persistentes, motor social y publicación (Epic + historias + Feature + SDD + inventario + Gherkin); **B** = pantallas y flujos de negocio (Epic + Feature + SDD); **C** = soporte (ficha en el inventario). Hoy todos los módulos tienen la documentación completa; la clasificación sirve para decidir **dónde profundizar y qué mantener primero** cuando cambie el código.

| Nivel | Módulos | Motivo |
| :--- | :--- | :--- |
| **A** | `10_user_login`, `40_security`, `08_pantallas_tu_cuenta_conocidos`, `08_pantallas_tu_cuenta_grupos`, `08_pantallas_tu_cuenta_tus_espacios`, `03_listas`, `12_localidades_user`, `22_imagenes` | Credenciales y sesión, datos de personas, escritura en CouchDB y red social |
| **B** | `01_splash_screen`, `02_principal_screen`, `03_vistas`, `05_provider_menus`, `07_routes`, `08_pantallas_inicio`, `08_pantallas_perfil`, `08_pantallas_propiedades`, `08_pantallas_ubicacion`, `14_geolocalizacion` | Flujos de negocio y navegación |
| **C** | `01_home`, `04_provider`, `08_pantallas_widgets_comunes`, `20_var_globales`, `41_connectivity`, `42_sistema_operativo`, `60_global_widgets`, `main` | Soporte y utilidades |
