# Plan de Trabajo — Fase 1: Generación de Documentación Completa (Ingeniería Inversa)

**Proyecto:** Buscobien — Plataforma de promoción inmobiliaria (Flutter + Riverpod 3.x + Freezed + Dio + Google Maps)  
**Fecha:** 2026-08-12  
**Autor:** Ingeniería inversa automatizada sobre `D:\buscobien\lib` (218 archivos `.dart` no generados)  
**Salida:** `D:\buscobien\_documentacion\_analisisydiseno\00_Plan\PLAN_DE_TRABAJO_FASE1.md`  
**Directorio base de entrega:** `D:\buscobien\_documentacion\_analisisydiseno\` (reutilizando estructura existente)

---

## 1. Resumen Ejecutivo

Este plan define la **Fase 1** (planificación) y sienta las bases para la **Fase 2** (ejecución) de la documentación completa del sistema Buscobien mediante ingeniería inversa del código en `lib/`.

**Estado actual:** La documentación en `_documentacion/_analisisydiseno/` **ya está parcialmente construida** con 5 de 6 capas requeridas:
- ✅ `01_Iniciativa_OKR/` — OKRs + Lean Canvas (completo)
- ✅ `02_Epics_EARS/` — 17/18 subdirectorios (falta `08_pantallas` y `22_imagenes`)
- ✅ `03_Features_BDD/` — 16 `.feature` (faltan `03_vistas`, `08_pantallas/*`, `22_imagenes/*`)
- ⚠️ `04_User_Stories/` — 5/18 subdirectorios dedicados + 13 consolidados en `03_listas.md` (requiere separación)
- ⚠️ `05_Tareas_Inventarios/` — 8/18 subdirectorios (faltan 10, incluidos todos los de `08_pantallas/*` y `22_imagenes/*`)
- ❌ `06_Bases_de_Datos/` — **No existe** en `_analisisydiseno` (fuentes en `_documentacion/07_data_base/couchdb_databases.md` y `_documentacion/01_inventario_componentes/USO_couchdb_databases.md`)

**Objetivo del plan:** Completar las brechas, consolidar lo existente, y generar la documentación faltante siguiendo el orden jerárquico de subdirectorios de `lib/`.

---

## 2. Metodologías y Técnicas Aplicadas (por entregable)

| Entregable | Metodología | Estructura obligatoria |
|------------|-------------|------------------------|
| **Iniciativa** | OKRs (Objetivo + 3-5 KR medibles) + Lean Canvas | Objetivo inspirador, 5 KRs con métrica y evidencia en código, Canvas 9 bloques |
| **Epics (Épicas)** | User Story Mapping + Impact Mapping + SDD (Spec-Driven) | Una Epic por subdirectorio principal; especificaciones EARS (5 patrones + complejos) |
| **Features (Características)** | BDD (Behavior-Driven Development) | Gherkin `# language: es` → `Característica:` + escenarios `Dado/Cuando/Entonces` |
| **User Stories** | 3 C's (Card, Conversation, Confirmation) | Card: "Como [rol] quiero [acción] para [beneficio]"; Conversation: narrativa; Confirmation: Criterios de Aceptación |
| **Tasks/Sub-tasks** | Inventario técnico por archivo `.dart` | 2 tablas: (1) Componentes/widgets con params, variables, estilos; (2) Elementos: variables, clases, funciones, llamadas |
| **Bases de Datos** | Análisis de modelos Dart + mapeo a CouchDB | Estructura Dart, diccionario de datos, JSON, DB CouchDB (`buscobien_*`), Mango queries, vistas, índices |

---

## 3. Inventario de Subdirectorios Principales (Orden de Ejecución)

Orden cronológico **por dependencias arquitectónicas** (base → features → UI):

| # | Subdirectorio | Archivos `.dart` | Prioridad | Estado actual en `_analisisydiseno` |
|---|---------------|------------------|-----------|--------------------------------------|
| 1 | `main.dart` (raíz) | 1 | Crítica | ✅ OKRs, ✅ Epic, ✅ Feature, ✅ US, ✅ Inventario |
| 2 | `01_splash_screen` | 3 | Crítica | ✅ OKRs, ✅ Epic, ✅ Feature, ✅ US, ✅ Inventario |
| 3 | `01_home` | 2 | Crítica | ✅ OKRs, ✅ Epic, ✅ Feature, ✅ US, ✅ Inventario |
| 4 | `02_principal_screen` | 5 | Alta | ✅ OKRs, ✅ Epic, ⚠️ Feature (1/3), ✅ US (consolidada), ✅ Inventario |
| 5 | `07_routes` | 4 | Alta | ✅ OKRs, ✅ Epic, ✅ Feature, ✅ US, ✅ Inventario |
| 6 | `04_provider` | 2 | Media | ✅ OKRs, ✅ Epic, ✅ Feature, ⚠️ US (consolidada), ❌ Inventario |
| 7 | `05_provider_menus` | 16 | Alta | ✅ OKRs, ✅ Epic, ✅ Feature, ⚠️ US (consolidada), ❌ Inventario |
| 8 | `10_user_login` | 19 | Crítica | ✅ OKRs, ✅ Epic, ✅ Feature, ⚠️ US (consolidada), ✅ Inventario |
| 9 | `12_localidades_user` | 4 | Media | ✅ OKRs, ✅ Epic, ✅ Feature, ⚠️ US (consolidada), ✅ Inventario |
| 10 | `14_geolocalizacion` | 4 | Alta | ✅ OKRs, ✅ Epic, ✅ Feature, ⚠️ US (consolidada), ❌ Inventario |
| 11 | `20_var_globales` | 9 | Media | ✅ OKRs, ✅ Epic, ✅ Feature, ⚠️ US (consolidada), ❌ Inventario |
| 12 | `40_security` | 5 | Alta | ✅ OKRs, ✅ Epic, ✅ Feature, ⚠️ US (consolidada), ❌ Inventario |
| 13 | `41_connectivity` | 2 | Media | ✅ OKRs, ✅ Epic, ❌ Feature, ⚠️ US (consolidada), ❌ Inventario |
| 14 | `42_sistema_operativo` | 1 | Media | ✅ OKRs, ✅ Epic, ✅ Feature, ⚠️ US (consolidada), ❌ Inventario |
| 15 | `60_global_widgets` | 6 | Media | ✅ OKRs, ✅ Epic, ✅ Feature, ⚠️ US (consolidada), ✅ Inventario |
| 16 | `03_vistas` | 9 | Media | ✅ OKRs, ✅ Epic, ❌ Feature, ⚠️ US (consolidada), ❌ Inventario |
| 17 | `03_listas` | 17 | Alta | ✅ OKRs, ✅ Epic, ✅ Feature, ⚠️ US (consolidada), ❌ Inventario |
| 18 | `22_imagenes` | 28 | Alta | ✅ OKRs, ❌ Epic, ❌ Feature, ⚠️ US (consolidada), ❌ Inventario |
| 19 | `08_pantallas` | 62 | **Crítica** | ✅ OKRs, ❌ Epic, ❌ Feature, ❌ US, ❌ Inventario |

**Total:** 218 archivos `.dart` en 18 subdirectorios + `main.dart`

---

## 4. Brechas Detalladas por Capa (Qué Falta Generar/Completar)

### 4.1 Capa 1 — Iniciativa (OKRs + Lean Canvas)
- **Estado:** ✅ **Completo** en `_analisisydiseno/01_Iniciativa_OKR/01_OKRs.md` y `02_Lean_Canvas.md`.
- **Acción:** Validar consistencia con código final; no requiere trabajo nuevo.

### 4.2 Capa 2 — Epics con EARS (02_Epics_EARS/)
- **Faltantes:**
  - `08_pantallas.md` — **El mayor gap**: 62 archivos, 6 subcarpetas funcionales (inicio, perfil, propiedades, tu_cuenta/conocidos, tu_cuenta/grupos, tu_cuenta/tus_espacios, ubicacion, widgets_comunes). Requiere **sub-Épicas por subcarpeta**.
  - `22_imagenes.md` — 28 archivos, flujo completo de fotos (usuario + propiedades).
- **Existentes (17):** Revisar que cubran todos los 5 patrones EARS + complejos; completar donde falte.

### 4.3 Capa 3 — Features BDD (03_Features_BDD/)
- **Faltantes (subdirectorios sin `.feature`):**
  - `03_vistas/` — 9 landing pages por actor (asociaciones, hospedaje, inmobiliarias, market, promotores, propietarios, proveedores, servicios, usuarios).
  - `08_pantallas/` — **Múltiples features por subcarpeta** (mínimo 8: búsqueda, detalle propiedad, PDF, perfil, conocidos, grupos, tus_espacios, ubicacion).
  - `22_imagenes/` — Mínimo 4: carousel usuario, carousel mini, gestión fotos propiedad (subida, listado, orden), compresión.
- **Existentes (16):** Validar cobertura completa de escenarios por feature.

### 4.4 Capa 4 — User Stories (04_User_Stories/)
- **Faltantes (archivos dedicados por subdirectorio):**
  - `02_principal_screen.md`, `03_listas.md`, `03_vistas.md`, `04_provider.md`, `05_provider_menus.md`, `08_pantallas.md` (o subarchivos), `10_user_login.md`, `12_localidades_user.md`, `14_geolocalizacion.md`, `20_var_globales.md`, `22_imagenes.md`, `40_security.md`, `41_connectivity.md`, `42_sistema_operativo.md`.
- **Consolidados en `03_listas.md` (13 subsistemas):** Separar en archivos individuales con formato 3 C's completo (Card + Conversation + Confirmation).
- **Índice:** Actualizar `00_indice_user_stories.md` con todos los archivos.

### 4.5 Capa 5 — Tasks/Sub-tasks Inventarios (05_Tareas_Inventarios/)
- **Faltantes (subdirectorios sin `elementos_*.md`):**
  - `01_splash_screen`, `03_listas`, `03_vistas`, `05_provider_menus`, `08_pantallas` (7 subcarpetas = 7 archivos), `14_geolocalizacion`, `20_var_globales`, `22_imagenes` (3 subcarpetas), `40_security`, `41_connectivity`, `42_sistema_operativo`.
- **Existentes (8):** Completar con las 2 tablas requeridas (componentes + elementos) si están incompletos.

### 4.6 Capa 6 — Bases de Datos (06_Bases_de_Datos/) **NUEVA**
- **Crear directorio** `_analisisydiseno/06_Bases_de_Datos/`.
- **Fuentes:** `_documentacion/07_data_base/couchdb_databases.md` (19 DBs mapeadas) + `_documentacion/01_inventario_componentes/USO_couchdb_databases.md` + modelos Freezed en `lib/*/models/*.dart` y `lib/*/data_models/*.dart`.
- **Entregables por DB `buscobien_*`:**
  1. Estructura Dart (clases Freezed/@JsonSerializable).
  2. Diccionario de datos (campo, tipo, obligatorio, descripción).
  3. JSON de ejemplo (documento CouchDB).
  4. Nombre DB CouchDB + diseño de índices Mango (fields, partial_filter_selector).
  5. Vistas/consultas usadas en providers (Mango queries extraídas del código).
  6. Relaciones entre DBs (ej. `buscobien_usuarios` → `buscobien_invitaciones` → `buscobien_grupos`).

---

## 5. Plan Cronológico por Etapas (Fase 2 - Ejecución)

El plan se ejecuta **subdirectorio por subdirectorio** en el orden de la Sección 3.  
**Por cada subdirectorio principal** se ejecutan **las 6 Etapas** en secuencia:

### ETAPA 1 — Iniciativa (solo una vez, al inicio)
- Validar/actualizar OKRs y Lean Canvas con hallazgos de la ingeniería inversa completa.

### ETAPA 2 — Epic EARS (por subdirectorio)
- Generar/completar `02_Epics_EARS/<subdir>.md`.
- Para `08_pantallas`: crear **un archivo principal** + **sub-archivos por subcarpeta funcional** (ej. `08_pantallas_inicio.md`, `08_pantallas_tu_cuenta_conocidos.md`, etc.).
- Estructura EARS obligatoria por requisito:
  - Ubicuos: `[El sistema] deberá [respuesta]`
  - Event-driven: `Cuando [disparador], el [sistema] deberá [respuesta]`
  - State-driven: `Mientras [estado], el [sistema] deberá [respuesta]`
  - Unwanted: `Si [condición/falla], entonces el [sistema] deberá [respuesta]`
  - Optional: `Donde [función incluida], el [sistema] deberá [respuesta]`
  - Complejos: `Mientras [estado], cuando [disparador], el [sistema] deberá [respuesta]`

### ETAPA 3 — Features BDD (por subdirectorio)
- Generar `03_Features_BDD/<subdir>/<feature>.feature` (Gherkin español `# language: es`).
- Mínimo 1 feature por flujo de valor al usuario; para `08_pantallas` → 8-12 features.

### ETAPA 4 — User Stories 3 C's (por subdirectorio)
- Generar `04_User_Stories/<subdir>.md` (archivo dedicado, **no consolidado**).
- Por feature: múltiples US con Card + Conversation + Confirmation (Criterios de Aceptación = escenarios Gherkin).

### ETAPA 5 — Inventario Tasks/Sub-tasks (por subdirectorio)
- Generar `05_Tareas_Inventarios/<subdir>/elementos_<subdir>.md`.
- **Tabla 1 — Componentes/Widgets:** Subdirectorio, Archivo, Tipo, Nombre, Parámetros, Variables, Variables internas, Estilos.
- **Tabla 2 — Elementos de código:** Subdirectorio, Archivo, Variables top-level, Clases, Variables de clase, Funciones/Widgets, Variables usadas, Llamadas a otras clases/widgets.

### ETAPA 6 — Bases de Datos (transversal, al final de cada Epic que use BD)
- Por cada Epic que acceda a CouchDB (vía API), documentar en `06_Bases_de_Datos/<db_name>.md` los 6 ítems de la Sección 4.6.
- Consolidar índice `06_Bases_de_Datos/INDICE.md`.

---

## 6. Puntos de Control y Liberación de Contexto (Regla Fase 2, Paso 3)

**Al terminar CADA subdirectorio principal (Sección 3):**
1. ✅ Confirmar que las 6 Etapas están completas para ese subdirectorio.
2. ✅ Verificar que los archivos generados están en `_analisisydiseno/` con estructura correcta.
3. 📤 **Liberar contexto** — informar al usuario: "Subdirectorio `<nombre>` completado. Archivos generados: [lista]. ¿Continuar con `<siguiente>`?"
4. ⏸ **Esperar confirmación explícita** antes de pasar al siguiente subdirectorio principal.

**Excepción:** `08_pantallas` (62 archivos) se divide en **7 hitos** por subcarpeta funcional, cada uno con su punto de control:
1. `08_pantallas/inicio` (15 archivos)
2. `08_pantallas/perfil` (1 archivo)
3. `08_pantallas/propiedades` (3 archivos)
4. `08_pantallas/tu_cuenta/conocidos` (12 archivos)
5. `08_pantallas/tu_cuenta/grupos` (21 archivos)
6. `08_pantallas/tu_cuenta/tus_espacios` (9 archivos)
7. `08_pantallas/ubicacion` (6 archivos) + `widgets_comunes` (1 archivo)

---

## 7. Estructura de Directorios de Salida (Final)

```
_documentacion/_analisisydiseno/
├── 00_Plan/
│   └── PLAN_DE_TRABAJO_FASE1.md          ← ESTE ARCHIVO
├── 01_Iniciativa_OKR/
│   ├── 01_OKRs.md                        ✅ EXISTE
│   └── 02_Lean_Canvas.md                 ✅ EXISTE
├── 02_Epics_EARS/
│   ├── 01_home.md                        ✅ EXISTE
│   ├── 01_splash_screen.md               ✅ EXISTE
│   ├── 02_principal_screen.md            ✅ EXISTE
│   ├── 03_listas.md                      ✅ EXISTE
│   ├── 03_vistas.md                      ✅ EXISTE
│   ├── 04_provider.md                    ✅ EXISTE
│   ├── 05_provider_menus.md              ✅ EXISTE
│   ├── 07_routes.md                      ✅ EXISTE
│   ├── 08_pantallas.md                   ❌ FALTA (principal)
│   ├── 08_pantallas_inicio.md            ❌ FALTA (sub-épica)
│   ├── 08_pantallas_perfil.md            ❌ FALTA
│   ├── 08_pantallas_propiedades.md       ❌ FALTA
│   ├── 08_pantallas_tu_cuenta_conocidos.md ❌ FALTA
│   ├── 08_pantallas_tu_cuenta_grupos.md  ❌ FALTA
│   ├── 08_pantallas_tu_cuenta_tus_espacios.md ❌ FALTA
│   ├── 08_pantallas_ubicacion.md         ❌ FALTA
│   ├── 10_user_login.md                  ✅ EXISTE
│   ├── 12_localidades_user.md            ✅ EXISTE
│   ├── 14_geolocalizacion.md             ✅ EXISTE
│   ├── 20_var_globales.md                ✅ EXISTE
│   ├── 22_imagenes.md                    ❌ FALTA
│   ├── 40_security.md                    ✅ EXISTE
│   ├── 41_connectivity.md                ✅ EXISTE
│   ├── 42_sistema_operativo.md           ✅ EXISTE
│   ├── 60_global_widgets.md              ✅ EXISTE
│   └── main.md                           ✅ EXISTE
├── 03_Features_BDD/
│   ├── 01_home/navegacion_home.feature           ✅ EXISTE
│   ├── 01_splash_screen/arranque_splash.feature  ✅ EXISTE
│   ├── 02_principal_screen/pantalla_principal_landings.feature ✅ EXISTE
│   ├── 03_listas/listas_favoritos_compartir.feature ✅ EXISTE
│   ├── 03_vistas/                                ❌ DIRECTORIO FALTA
│   ├── 04_provider/preferencias_tema.feature     ✅ EXISTE
│   ├── 05_provider_menus/menus_dinamicos.feature ✅ EXISTE
│   ├── 07_routes/rutas_deep_links.feature        ✅ EXISTE
│   ├── 08_pantallas/                             ❌ DIRECTORIO FALTA (8+ features)
│   ├── 10_user_login/autenticacion_sesion.feature ✅ EXISTE
│   ├── 12_localidades_user/localidades_usuario.feature ✅ EXISTE
│   ├── 14_geolocalizacion/mapa_geolocalizacion.feature ✅ EXISTE
│   ├── 20_var_globales/variables_globales_temas.feature ✅ EXISTE
│   ├── 22_imagenes/                              ❌ DIRECTORIO FALTA (4+ features)
│   ├── 40_security/seguridad_endpoints.feature   ✅ EXISTE
│   ├── 41_connectivity/                          ❌ DIRECTORIO FALTA
│   ├── 42_sistema_operativo/deteccion_plataforma.feature ✅ EXISTE
│   ├── 60_global_widgets/widgets_globales_m3.feature ✅ EXISTE
│   └── main/inicializacion_global.feature        ✅ EXISTE
├── 04_User_Stories/
│   ├── 00_indice_user_stories.md         ✅ EXISTE (actualizar)
│   ├── 01_home.md                        ✅ EXISTE
│   ├── 01_splash_screen.md               ✅ EXISTE
│   ├── 02_principal_screen.md            ❌ FALTA
│   ├── 03_listas.md                      ⚠️ CONSOLIDADA (separar)
│   ├── 03_vistas.md                      ❌ FALTA
│   ├── 04_provider.md                    ❌ FALTA
│   ├── 05_provider_menus.md              ❌ FALTA
│   ├── 07_routes.md                      ✅ EXISTE
│   ├── 08_pantallas.md                   ❌ FALTA (o subarchivos)
│   ├── 10_user_login.md                  ❌ FALTA
│   ├── 12_localidades_user.md            ❌ FALTA
│   ├── 14_geolocalizacion.md             ❌ FALTA
│   ├── 20_var_globales.md                ❌ FALTA
│   ├── 22_imagenes.md                    ❌ FALTA
│   ├── 40_security.md                    ❌ FALTA
│   ├── 41_connectivity.md                ❌ FALTA
│   ├── 42_sistema_operativo.md           ❌ FALTA
│   └── 60_global_widgets.md              ❌ FALTA
├── 05_Tareas_Inventarios/
│   ├── 01_home/elementos_01_home.md              ✅ EXISTE
│   ├── 01_splash_screen/elementos_01_splash_screen.md ❌ FALTA
│   ├── 02_principal_screen/elementos_02_principal_screen.md ✅ EXISTE
│   ├── 03_listas/elementos_03_listas.md          ❌ FALTA
│   ├── 03_vistas/elementos_03_vistas.md          ❌ FALTA
│   ├── 04_provider/elementos_04_provider.md      ✅ EXISTE
│   ├── 05_provider_menus/elementos_05_provider_menus.md ❌ FALTA
│   ├── 07_routes/elementos_07_routes.md          ✅ EXISTE
│   ├── 08_pantallas/                             ❌ DIRECTORIO FALTA (7 sub-archivos)
│   ├── 10_user_login/elementos_10_user_login.md  ✅ EXISTE
│   ├── 12_localidades_user/elementos_12_localidades_user.md ✅ EXISTE
│   ├── 14_geolocalizacion/elementos_14_geolocalizacion.md ❌ FALTA
│   ├── 20_var_globales/elementos_20_var_globales.md ❌ FALTA
│   ├── 22_imagenes/                              ❌ DIRECTORIO FALTA (3 sub-archivos)
│   ├── 40_security/elementos_40_security.md      ❌ FALTA
│   ├── 41_connectivity/elementos_41_connectivity.md ❌ FALTA
│   ├── 42_sistema_operativo/elementos_42_sistema_operativo.md ❌ FALTA
│   ├── 60_global_widgets/elementos_60_global_widgets.md ✅ EXISTE
│   └── main/elementos_main.md                    ✅ EXISTE
└── 06_Bases_de_Datos/                          ❌ **DIRECTORIO NUEVO**
    ├── INDICE.md
    ├── buscobien_megusta_propiedades.md
    ├── buscobien_listas_compartidas_usuarios.md
    ├── buscobien_grupos_publicaciones.md
    ├── buscobien_listas_prop_compartidas.md
    ├── buscobien_listas_propiedades.md
    ├── buscobien_propiedades.md
    ├── buscobien_propiedades_compartidas_conocidos.md
    ├── buscobien_usuarios_listas.md
    ├── buscobien_casas_comprados_normal.md
    ├── buscobien_casas_comprados_destacado.md
    ├── buscobien_casas_comprados_super.md
    ├── buscobien_casas_comprados_oportunidad.md
    ├── buscobien_casas_comprados_remate.md
    ├── buscobien_espacios.md
    ├── buscobien_invitaciones.md
    ├── buscobien_mensajes.md
    └── buscobien_usuarios.md
```

---

## 8. Criterios de Terminación (Definition of Done)

La **Fase 1** (este plan) se da por terminada cuando:
- [x] Plan escrito en `_documentacion/_analisisydiseno/00_Plan/PLAN_DE_TRABAJO_FASE1.md`.
- [x] Usuario confirma el plan y autoriza inicio de Fase 2.

La **Fase 2** (ejecución) se da por terminada cuando:
- [ ] Todos los ✅/❌ de la Sección 7 están resueltos (verde = completo).
- [ ] Cada subdirectorio principal de `lib/` tiene sus 6 capas documentadas en `_analisisydiseno/`.
- [ ] `06_Bases_de_Datos/` cubre las 19 DBs `buscobien_*` identificadas.
- [ ] No hay archivos `.dart` sin cobertura en inventarios (Sección 4.5).
- [ ] `flutter analyze` pasa sin warnings en código (validación de que la doc no introduce deuda).

---

## 9. Estimación de Esfuerzo (Referencia)

| Subdirectorio | Archivos | Epics | Features | US | Inventario | Complejidad |
|---------------|----------|-------|----------|-----|------------|-------------|
| `08_pantallas` | 62 | 1+7 | 8-12 | 15-20 | 7 | **Muy Alta** |
| `22_imagenes` | 28 | 1 | 4-5 | 8-10 | 3 | Alta |
| `03_listas` | 17 | 1 | 1 | 3 | 1 | Media |
| `10_user_login` | 19 | 1 | 1 | 4 | 1 | Media |
| `05_provider_menus` | 16 | 1 | 1 | 2 | 1 | Media |
| `03_vistas` | 9 | 1 | 3-5 | 2 | 1 | Media |
| `02_principal_screen` | 5 | 1 | 2-3 | 3 | 1 | Baja |
| `20_var_globales` | 9 | 1 | 1 | 3 | 1 | Baja |
| `40_security` | 5 | 1 | 1 | 4 | 1 | Baja |
| `14_geolocalizacion` | 4 | 1 | 1 | 2 | 1 | Baja |
| `01_splash_screen` | 3 | 1 | 1 | 2 | 1 | Baja |
| `01_home` | 2 | 1 | 1 | 2 | 1 | Baja |
| `07_routes` | 4 | 1 | 1 | 3 | 1 | Baja |
| `12_localidades_user` | 4 | 1 | 1 | 1 | 1 | Baja |
| `41_connectivity` | 2 | 1 | 1 | 2 | 1 | Baja |
| `42_sistema_operativo` | 1 | 1 | 1 | 1 | 1 | Muy Baja |
| `60_global_widgets` | 6 | 1 | 1 | 2 | 1 | Baja |
| `04_provider` | 2 | 1 | 1 | 2 | 1 | Baja |
| `main.dart` | 1 | 1 | 1 | 3 | 1 | Muy Baja |

**Total estimado:** ~190-220 artifacts de documentación (archivos `.md` + `.feature`).

---

## 10. Próximos Pasos Inmediatos

1. **Usuario revisa y aprueba este plan** (o solicita ajustes).
2. **Inicio Fase 2** con subdirectorio `#1: main.dart` (validación rápida, ya documentado).
3. **Secuencia:** `01_splash_screen` → `01_home` → `02_principal_screen` → `07_routes` → `04_provider` → `05_provider_menus` → `10_user_login` → `12_localidades_user` → `14_geolocalizacion` → `20_var_globales` → `40_security` → `41_connectivity` → `42_sistema_operativo` → `60_global_widgets` → `03_vistas` → `03_listas` → `22_imagenes` → `08_pantallas` (7 hitos).

---

**Fin del Plan de Trabajo — Fase 1**  
*Generado por ingeniería inversa completa de `D:\buscobien\lib` (218 archivos `.dart`) el 2026-08-12.*