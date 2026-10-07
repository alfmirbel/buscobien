# Guía Estándar e Instrucciones para la Generación de Documentación SDLC

**Nombre del Estándar:** Marco de Documentación Unificada del Ciclo de Vida del Desarrollo de Sistemas (_SDLC Documentation Standard_)  
**Versión:** 1.2.0 (2026-10-07: agrega verificación automática contra el código, regla «afirmar solo lo verificado», convención de IDs REQ/DES/SDD y mapeo de trazabilidad)  
**Ámbito de Aplicación:** Proyectos de Desarrollo de Software (Web, Móvil, Desktop, Backend y Microservicios)  
**Objetivo:** Proveer una guía paso a paso y reutilizable para auditar, estructurar, redactar, consolidar y depurar la documentación técnica de cualquier proyecto de software siguiendo las 8 etapas del SDLC.

---

## 🎯 Principios Fundamentales del Estándar

1. **Trazabilidad Bidireccional Total**: Todo requerimiento de negocio debe poder rastrearse hasta su historia de usuario, especificación BDD, diseño SDD, componente de código, tabla de base de datos y escenario de prueba QA.
2. **Cero Duplicidad y Redundancia**: No se crean copias borrador ("- copia") en producción documental. La información de similar naturaleza se consolida en documentos canónicos (cada documento existe en un solo lugar).
3. **Cero Enlaces Rotos**: Todos los enlaces hipertexto entre documentos utilizan rutas relativas o esquema `file:///` estrictamente validados.
4. **Independencia de Credenciales**: NUNCA se escriben secretos, contraseñas o llaves privadas en los documentos; se especifican variables de entorno o archivos `.json` excluidos de Git.
5. **Una sola fuente de verdad**: cada hecho se documenta en un solo lugar y los demás documentos lo enlazan (no lo copian). Si algo puede derivarse del código (inventarios, listas de campos, índices), se **genera** con script y se marca como generado; solo se **redacta a mano** lo que el código no dice (por qué, requisitos, decisiones).
6. **Vigencia verificable**: todo documento redactado lleva fecha de última revisión y, cuando aplica, el módulo/commit que describe. Un documento sin revisar en más de 90 días tras cambios en su módulo se considera potencialmente obsoleto.
7. **Proporcionalidad**: se documenta con la profundidad que el riesgo justifica. Un módulo de 2 archivos no necesita 6 capas de documentos (ver «Niveles de profundidad»).
8. **Afirmar solo lo verificado**: toda afirmación sobre el código (arquitectura, librerías, bases de datos, almacenamiento) se contrasta con `lib/` antes de publicarla; si el código difiere del objetivo, el documento distingue «estado real» de «objetivo».

---

## 🧭 Metodologías: cuáles se usan y cuáles se recomiendan

| Necesidad | Método adoptado | Valoración | Recomendación |
| :--- | :--- | :--- | :--- |
| Requerimientos | EARS (5 patrones) | Correcto: sin ambigüedad y verificable | Mantener; cada requerimiento con ID estable y prioridad (MoSCoW) |
| Historias de usuario | 3 C's + criterios de aceptación | Correcto | Que los criterios de aceptación **sean** los escenarios Gherkin (enlazarlos, no reescribirlos) |
| Comportamiento | BDD / Gherkin | Correcto para negocio; hoy solo documental (no se ejecuta) | Automatizar los críticos (login, búsqueda, publicar) con `integration_test` o similar |
| Diseño | SDD por módulo | Correcto, pero verboso | Añadir **C4** (contexto, contenedores) y **ADR** para decisiones; los SDD por módulo solo cuentan lo no obvio |
| Arquitectura | Documento general + Mermaid | Correcto | Mantener Mermaid (versionable); evitar imágenes binarias |
| API | Texto en SDD | Insuficiente: el backend es un repo aparte | Contrato **OpenAPI** como fuente única entre Flutter y Node.js |
| Datos | Diccionario de 19 DBs de diseño (el código referencia 35) | Parcial | Añadir ejemplos JSON validables y los índices Mango reales (`db/design/`) |
| Inventarios | Tablas manuales de 10 columnas | Alto costo, envejece rápido | **Generar** con script/`dart analyze`; no mantener a mano |
| Calidad | Smoke test + `.feature` | Cobertura efectiva casi nula | Pirámide: unit (providers/modelos) > widget > integración; meta de cobertura por módulo |
| Seguridad | Dispersa (módulo 40, DB) | Insuficiente | Modelo de amenazas breve (STRIDE) para auth, mensajería y acceso a CouchDB |
| Operación | Guías SSH/PM2 | Parcial | Añadir runbook de incidentes, backup/restauración de CouchDB y checklist de despliegue |

### Niveles de profundidad por módulo

| Nivel | Criterio | Documentos mínimos |
| :--- | :--- | :--- |
| **A — Crítico** | Auth, seguridad, datos persistentes, motor social, publicación de propiedades | Epic EARS + Historias + Feature/Gherkin + SDD + inventario de componentes |
| **B — Funcional** | Pantallas y flujos de negocio | Epic EARS (puede agrupar) + Feature/Gherkin + SDD breve |
| **C — Soporte** | Utilidades, constantes, widgets simples | Una sola ficha en el inventario de componentes |

### Convención de IDs de trazabilidad

Formato único `REQ-<MÓDULO>-<NNN>` (ej. `REQ-ROUT-001`) **solo para requerimientos de las Epics**; `DES-<MÓDULO>-<TEMA>-<NNN>` o `SDD-<MÓD>-<NNN>` para requisitos/elementos de diseño en los SDD; `US-<MÓDULO>-<NNN>` para historias y tags Gherkin `@REQ-ROUT-001` por escenario. La matriz de trazabilidad se **genera** buscando esos IDs en epics, historias, `.feature` y SDD; no se escribe a mano. No se mezclan esquemas numéricos antiguos (`REQ-01.001`).

---

## 🏛️ Estructura de Carpetas Estándar

Todo proyecto documentado bajo este estándar debe generar la siguiente jerarquía dentro de su carpeta `_documentacion/`:

```
<directorio_proyecto>/_documentacion/
├── README.md                                           # Punto de entrada y navegación rápida
│
├── 00_indice/                                          # Índices maestros y guías del estándar
│   ├── indice_general_documentacion.md                 # Catálogo completo de la documentación
│   ├── indice_archivos_modelos.md                      # Índice de modelos de datos y entidades
│   └── GUIA_ESTANDAR_DOCUMENTACION_SDLC.md             # Este documento de instrucciones
│
├── 01_planeacion_y_estrategia/                          # Etapa 1: Planeación y Visión de Negocio
│   ├── README.md
│   ├── plan_de_trabajo.md                              # Plan de ejecución, metodologías y alcance
│   └── okrs_y_lean_canvas.md                           # Lean Canvas (Modelo de negocio) + OKRs
│
├── 02_requerimientos/                                  # Etapa 2: Ingeniería de Requerimientos
│   ├── README.md
│   ├── EARS_requerimientos_consolidados.md             # Sintaxis EARS formal (5 patrones)
│   ├── epics_ears/                                     # Requerimientos EARS por módulo
│   └── user_stories/                                   # Historias de Usuario con criterios de aceptación
│
├── 03_analisis_funcional/                               # Etapa 3: Análisis Funcional y BDD
│   ├── README.md
│   ├── bdd_high_level_specs.md                         # Resumen funcional de alto nivel
│   ├── matriz_trazabilidad_ears_bdd_sdd.md             # Matriz de Trazabilidad EARS ➔ BDD ➔ SDD
│   └── features_analisis/                              # Gherkin .feature de análisis por módulo
│
├── 04_arquitectura_y_diseno/                           # Etapa 4: Arquitectura y Diseños SDD
│   ├── README.md
│   ├── arquitectura_general_<sistema>.md               # Arquitectura general y patrones de diseño
│   ├── arquitectura_navegacion.md                     # Enrutamiento y manejo de estado
│   ├── especificacion_<modulo_clave>.md                # Diseños de motores complejos o subsistemas
│   ├── <sistema>_sdd_maestro.md                        # SDD Maestro del sistema
│   └── modulos_sdd/                                    # SDDs detallados por módulo de código
│
├── 05_desarrollo_y_especificaciones_tecnicas/          # Etapa 5: Especificaciones para Desarrollo
│   ├── README.md
│   ├── stack_tecnologico.md                            # Lenguajes, frameworks, flags y comandos
│   ├── dominios_modulos_archivos.md                    # Mapa de dominios, módulos y árbol de archivos
│   ├── <sistema>_ui_rules.md                           # Design System, reglas UI/UX, tokens de color
│   ├── inventario_componentes/                         # Inventario técnico con diagramas Mermaid
│   └── inventario_elementos/                           # Tablas de 10 columnas por archivo fuente
│
├── 06_modelo_de_datos_y_bd/                            # Etapa 6: Modelo de Datos y Bases de Datos
│   ├── README.md
│   └── <sistema>_databases_complete.md                 # Diccionario de bases de datos/tablas + apéndice de uso en código
│                                                       # (el índice de modelos vive en 00_indice/indice_archivos_modelos.md)
│
├── 07_pruebas_y_calidad/                               # Etapa 7: Pruebas y Aseguramiento QA
│   ├── README.md
│   ├── estrategia_de_pruebas_y_smoke_tests.md          # Plan QA, Smoke tests, linters y cobertura
│   └── gherkin_bdd_scenarios/                          # Repositorio de escenarios .feature por módulo
│
└── 08_operacion_guias_y_despliegue/                    # Etapa 8: Operación, Guías y Despliegue
    ├── README.md
    ├── ssh_servidor_y_despliegue.md                    # Guía SSH, VPS, Docker/PM2 y comandos prod
    ├── guia_<subsistema_clave>.md                      # Guías operativas para usuarios/admins
    └── plan_trabajo_ui_ux_navegacion.md                # Flujos de operación y planes UX
```

---

## 📋 Plan de Instrucciones Paso a Paso para Documentar un Proyecto

### 🔹 Paso 1: Auditoría e Inventariado de Código Fuente

1. Ejecutar un escaneo del árbol del proyecto (`lib/`, `src/`, `app/`, etc.) registrando todos los módulos, submódulos y archivos fuente.
2. Identificar el stack tecnológico (lenguajes, frameworks, gestores de estado, ORM/drivers de BD, servicios externos).
3. Verificar la configuración de credenciales (asegurar que las llaves de API o contraseñas se consuman via variables de entorno o `defines.json`).

### 🔹 Paso 2: Generar Etapa 1 — Planeación y Estrategia (`01_planeacion_y_estrategia`)

1. **Redactar `okrs_y_lean_canvas.md`**:
   - Completar las 9 casillas del Lean Canvas (Problema, Clientes, Propuesta de Valor, Solución, Canales, Ingresos, Costos, Métricas, Ventaja Injusta).
   - Definir Objetivos de negocio y Resultados Clave (OKRs) cuantitativos.
2. **Redactar `plan_de_trabajo.md`**:
   - Detallar el alcance de entregables por módulo y prioridades de desarrollo.

### 🔹 Paso 3: Generar Etapa 2 — Requerimientos (`02_requerimientos`)

1. **Redactar `EARS_requerimientos_consolidados.md`**:
   - Aplicar los 5 patrones formales de EARS:
     - **Ubicuo**: _El sistema DEBERÁ [acción]._
     - **Evento**: _CUANDO [evento], el sistema DEBERÁ [acción]._
     - **Estado**: _MIENTRAS [estado], el sistema DEBERÁ [acción]._
     - **Opcional**: _DONDE [característica opcional], el sistema DEBERÁ [acción]._
     - **Complejo**: _MIENTRAS [estado], CUANDO [evento], el sistema DEBERÁ [acción]._
2. **Crear carpeta `epics_ears/`**:
   - Crear un archivo `.md` por cada módulo con la lista de requerimientos EARS.
3. **Crear carpeta `user_stories/`**:
   - Crear un archivo `.md` por cada módulo con las Historias de Usuario (US) en formato:  
     _Como [rol], quiero [funcionalidad] para [beneficio]._ + Criterios de Aceptación.

### 🔹 Paso 4: Generar Etapa 3 — Análisis Funcional y BDD (`03_analisis_funcional`)

1. **Redactar `matriz_trazabilidad_ears_bdd_sdd.md`**:
   - Construir una tabla que relaciones: `ID Requerimiento EARS ➔ ID User Story ➔ Archivo BDD ➔ Módulo SDD`.
2. **Redactar `bdd_high_level_specs.md`**:
   - Resumir el comportamiento de alto nivel esperado por módulo.
3. **Crear carpeta `features_analisis/`**:
   - Redactar especificaciones Gherkin (`.feature`) de alto nivel.

### 🔹 Paso 5: Generar Etapa 4 — Arquitectura y Diseño (`04_arquitectura_y_diseno`)

1. **Redactar `arquitectura_general_<sistema>.md`**:
   - Explicar la arquitectura de capas, desacoplamiento, patrones de persistencia e integración API.
2. **Redactar `arquitectura_navegacion.md`**:
   - Especificar el sistema de enrutamiento y gestión reactiva del estado de navegación.
3. **Crear carpeta `modulos_sdd/`**:
   - Generar un documento SDD por cada módulo explicando: responsabilidades, diagramas de clases, flujos de datos y manejo de excepciones.

### 🔹 Paso 6: Generar Etapa 5 — Especificaciones Técnicas (`05_desarrollo_y_especificaciones_tecnicas`)

1. **Redactar `stack_tecnologico.md`**:
   - Documentar versiones exactas de herramientas, flags de compilación y prerrequisitos del sistema.
2. **Redactar `<sistema>_ui_rules.md`**:
   - Especificar las reglas de diseño (Design System, paleta de colores cromática, íconos permitidos, bordes, tipografía).
3. **Crear carpeta `inventario_componentes/`**:
   - Redactar un inventario por módulo incluyendo **diagramas de flujo Mermaid** (`graph TD`, `sequenceDiagram`, `stateDiagram-v2`).
4. **Crear carpeta `inventario_elementos/`**:
   - Construir una **Tabla de 10 Columnas** por cada archivo fuente del proyecto:
     | Subdirectorio | Nombre de Archivo | Variables Definidas | Clases | Descripción de Clases | Variables de Clase | Funciones/Widgets | Descripción de Función/Widget | Variables Utilizadas | Llamadas a Otras Clases/Widgets |

### 🔹 Paso 7: Generar Etapa 6 — Modelo de Datos (`06_modelo_de_datos_y_bd`)

1. **Redactar `<sistema>_databases_complete.md`**:
   - Crear el diccionario completo de bases de datos/tablas: ID de documento, Índices, Vistas y Esquemas JSON de ejemplo.
2. **Redactar `indice_archivos_modelos.md`**:
   - Mapear las clases de modelo de datos inmutables, DTOs y serializadores JSON.

### 🔹 Paso 8: Generar Etapa 7 — Pruebas y Calidad QA (`07_pruebas_y_calidad`)

1. **Redactar `estrategia_de_pruebas_y_smoke_tests.md`**:
   - Definir comandos de ejecución de pruebas unitarias, linters y cobertura.
2. **Crear carpeta `gherkin_bdd_scenarios/`**:
   - Redactar los escenarios de prueba `.feature` en sintaxis Gherkin (`Feature`, `Scenario`, `Given`, `When`, `Then`, `And`).

### 🔹 Paso 9: Generar Etapa 8 — Operación y Despliegue (`08_operacion_guias_y_despliegue`)

1. **Redactar `ssh_servidor_y_despliegue.md`**:
   - Detallar alias SSH, claves, comandos de inicio de servicio (`ssh-agent`), gestores de proceso (PM2, Docker) y servidores web (Apache, Nginx).
2. **Redactar guías operativas específicas** (`guia_notificaciones.md`, `guia_motor_social.md`).

### 🔹 Paso 10: Indexación y Verificación Automática de Enlaces Rotos

1. Generar los archivos `README.md` navegables dentro del directorio raíz `_documentacion/` y en cada una de las 8 subcarpetas.
2. Ejecutar `python verificar_documentacion.py` (esta carpeta): contrasta la documentación con el código (enlaces rotos, archivos de `lib/` sin inventariar o inexistentes, credenciales, prefijo `REQ-` en SDD, tags sin Epic, bases `buscobien_*` sin inventariar) y devuelve código de salida 1 si hay errores. Úsalo como hook pre-commit o paso de CI.
3. Opcionalmente, el script de PowerShell siguiente valida solo enlaces para garantizar que **no existan hipervínculos rotos** en toda la documentación:

```powershell
# Validación de enlaces rotos (relativos y file:///), incluye carpetas y anclas de archivo
$mdFiles = Get-ChildItem -Path "D:\buscobien\_documentacion\" -Recurse -Filter "*.md"
$brokenLinks = @()

foreach ($file in $mdFiles) {
    $content = Get-Content $file.FullName -Raw -Encoding UTF8
    $dir = $file.DirectoryName
    $found = [regex]::Matches($content, '\]\(((?!https?:|mailto:|#)[^)\s]+)\)')

    foreach ($m in $found) {
        $link = $m.Groups[1].Value
        $cleanPath = [uri]::UnescapeDataString(($link -replace 'file:///', '').Split('#')[0])
        if ($cleanPath -eq '') { continue }
        $targetPath = if ($cleanPath -match '^[a-zA-Z]:') { $cleanPath } else { [System.IO.Path]::Combine($dir, $cleanPath) }

        if (-not (Test-Path -LiteralPath $targetPath)) {
            $brokenLinks += [PSCustomObject]@{
                SourceFile = $file.FullName
                LinkText   = $m.Groups[1].Value
                TargetRaw  = $link
            }
        }
    }
}

Write-Host "Total archivos Markdown auditados: $($mdFiles.Count)"
Write-Host "Total de enlaces rotos detectados: $($brokenLinks.Count)"
if ($brokenLinks.Count -gt 0) { $brokenLinks | Format-Table -AutoSize }
```

---

## 🔄 Mantenimiento y Vigencia

1. **Disparador**: todo PR que modifique `lib/<módulo>/` actualiza, en el mismo PR, el SDD/Epic/Feature del módulo o declara «sin impacto documental».
2. **Generado vs redactado**: inventarios de elementos, índice de modelos y matriz de trazabilidad se regeneran con script (no se editan a mano); Epics, historias, SDD y guías se redactan.
3. **Automatización (CI o hook pre-commit)**: ejecutar `verificar_documentacion.py` (enlaces, inventarios vs código, credenciales, IDs), buscar credenciales (`AIza…`, `password: "…"`), verificar que cada `REQ-*` aparezca en al menos un `.feature` o historia, y que no existan carpetas «- copia».
4. **Revisión periódica**: trimestral, o al cerrar cada hito; actualizar la fecha de revisión y el índice general.
5. **Fechas absolutas** y encabezado mínimo en cada documento redactado: título, fecha de revisión, módulo/alcance, responsable.
6. **Datos que envejecen** (conteos de archivos, número de features, versiones) se evitan en prosa o se generan; si no, se omiten.

## ⚠️ Brechas conocidas (pendientes de este repositorio)

| Brecha | Impacto | Acción propuesta |
| :--- | :--- | :--- |
| Matriz generada (268 REQ): 40 % con historia, 61 % con diseño y 77 % con escenario Gherkin etiquetado; el mapeo a diseño es parcialmente revisado (tabla manual de 117 reglas) y el de Gherkin es una *propuesta* automática (≈50–70 % de acierto) | Trazabilidad útil pero sin revisión completa | Revisar `mapeo_req_gherkin.csv` (estado `confirmado`/`rechazado`) y escribir historias para los 161 REQ sin US; ver `03_analisis_funcional/reconciliacion_epics_sdd.md` |
| **Código vs. documentación:** el código incumple funciones que los documentos describían (exportar PDF sin invocar, CTAs «Contactar/Compartir» ausentes en la ficha, eliminar miembro de grupo inexistente, 16 rutas sin pantalla) | Expectativas de producto sin respaldo | Decidir por cada caso: implementar o retirar del alcance (ya marcados como «Parcial»/«Implementado, sin invocar»/`@pendiente`) |
| Los 129 `.feature` detallados y los 48 de análisis solapan en tema | Doble mantenimiento | Conservar los detallados como pruebas; reducir los de análisis a uno por módulo o fusionarlos |
| Solo existe una prueba (plantilla de contador) y **falla**; frente a 199 archivos `.dart` | Escenarios sin ejecución y sin red de seguridad | Reemplazarla y seguir la pirámide de [`estrategia_de_pruebas_y_smoke_tests.md`](../07_pruebas_y_calidad/estrategia_de_pruebas_y_smoke_tests.md) |
| Inventarios de componentes y elementos describen lo mismo con distinto formato | Redundancia y desfase | Generar los de elementos; dejar los de componentes solo para módulos nivel A |
| Épicas, historias y SDD por módulo repiten información | Volumen alto (~70 % del peso total) | Mantener plantillas con secciones obligatorias y quitar texto genérico |
| `indice_archivos_modelos.md` pesa ~170 KB | Difícil de leer y mantener | Generarlo automáticamente o dividirlo por módulo |
| **Crítico (pendiente de decisión):** la documentación afirmaba que Flutter no toca CouchDB y usa Dio + JWT; el código usa `http` con Basic Auth y credenciales de administrador compiladas en 34 archivos (corregido en los documentos; sigue siendo deuda de seguridad en el código) | Riesgo de seguridad y documentación engañosa | Migrar a API Node.js tras nginx con JWT (objetivo; pendiente de la configuración de nginx y JWT) y mantener `verificar_documentacion.py` para contrastar afirmaciones con `lib/` |
| Contrato OpenAPI de la API Node.js objetivo | Riesgo de desalineación Flutter–API cuando exista la API | Publicar OpenAPI en el repo backend y enlazarlo desde [`contrato_api_actual.md`](../04_arquitectura_y_diseno/contrato_api_actual.md) |
| ADR, modelo de amenazas, C4 y runbook existen, pero partes de la operación **no están verificadas en el servidor** (roles de CouchDB, firewall, respaldos reales) | Procedimientos sin validar | Ejecutar y validar el [`runbook_operacion.md`](../08_operacion_guias_y_despliegue/runbook_operacion.md) y los pendientes de [`modelo_de_amenazas.md`](../04_arquitectura_y_diseno/modelo_de_amenazas.md) |

---

## 📌 Checklist de Conformidad del Estándar

- [ ] ¿Existen las 8 carpetas numéricas del SDLC (`01_` a `08_`)?
- [ ] ¿Cada carpeta cuenta con su archivo `README.md` navegable?
- [ ] ¿Los requerimientos utilizan notación EARS formal?
- [ ] ¿Los escenarios de prueba están expresados en sintaxis Gherkin BDD?
- [ ] ¿Existen diagramas visuales Mermaid en la arquitectura y componentes?
- [ ] ¿El modelo de datos contiene diccionario completo con esquemas de ejemplo?
- [ ] ¿El script de validación de enlaces retorna **0 enlaces rotos**?
- [ ] ¿Cada `REQ-*` tiene al menos una historia y un escenario Gherkin (matriz generada, no manual)?
- [ ] ¿Cada documento redactado tiene fecha de revisión y alcance?
- [ ] ¿Los inventarios derivables del código están generados y no escritos a mano?
- [ ] ¿Cada módulo respeta su nivel de profundidad (A/B/C)?
- [ ] ¿Existen ADR para las decisiones de arquitectura relevantes y contrato OpenAPI de la API?
