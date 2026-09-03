# Plan: Generación de documentación del sistema BuscoBien por ingeniería inversa

## Decisión base (según respuestas del usuario)
- **Reutilizar y completar**: generar nuevo en `bakswell\lib\_analisisydiseno`, reutilizando lo ya existente en `buscobien\_documentacion` (EARS, BDD, inventarios) y **generando nuevo lo que falta** (OKRs, Lean Canvas, Epics con EARS por subdirectorio, Gherkin .feature español).
- **Gherkin español estricto**: `# language: es`, `Característica:`, `Escenario:`, `Dado/Cuando/Entonces/Y` (convención ya existente en el repo).
- **Granularidad por subdirectorio nivel 1**: una Epic por cada subdirectorio nivel 1 de `lib` (unas 18-19 epics), una Feature por subcarpeta/funcionalidad, una User Story por página/widget principal. Inventario por subdirectorio nivel 1.

## Estrategia de alto nivel

Voy a leer cada subdirectorio de `D:\buscobien\lib` (18 carpetas nivel 1 + `main.dart` = 19 unidades) con agentes Explore que focalicen en distintos grupos, y producir los 6 entregables en `D:\buscobien\lib\_analisisydiseno\<PasoNN_Nombre>\` organizados jerárquicamente respetando la estructura de subdirectorios del código.

## Estructura de entregables (en `D:\buscobien\lib\_analisisydiseno\`)

```
lib/_analisisydiseno/
├── 00_README.md                        # Índice general y guía de navegación
│
├── 01_Iniciativa_OKR/
│   ├── 01_OKRs.md                      # Objetivo + 3-5 KR medibles
│   └── 02_Lean_Canvas.md               # Lean Canvas / Business Canvas + ROI
│
├── 02_Epics_EARS/                      # Una Epic por subdirectorio nivel 1
│   ├── 01_home.md                      # Impact Mapping + User Story Mapping + specs EARS
│   ├── 01_splash_screen.md
│   ├── 02_principal_screen.md
│   ├── 03_listas.md
│   ├── 03_vistas.md
│   ├── 04_provider.md
│   ├── 05_provider_menus.md
│   ├── 07_routes.md
│   ├── 08_pantallas_inicio.md
│   ├── 08_pantallas_perfil.md
│   ├── 08_pantallas_propiedades.md
│   ├── 08_pantallas_tu_cuenta_conocidos.md
│   ├── 08_pantallas_tu_cuenta_grupos.md
│   ├── 08_pantallas_tu_cuenta_tus_espacios.md
│   ├── 08_pantallas_ubicacion.md
│   ├── 10_user_login.md
│   ├── 12_localidades_user.md
│   ├── 14_geolocalizacion.md
│   ├── 20_var_globales.md
│   ├── 22_imagenes.md
│   ├── 40_security.md
│   ├── 41_connectivity.md
│   ├── 42_sistema_operativo.md
│   ├── 60_global_widgets.md
│   └── main.md                         # main.dart + BuscoBienApp
│
├── 03_Features_BDD/                    # Gherkin .feature español, un .feature por Epic/Feature
│   ├── 01_home/
│   │   └── navegacion_home.feature
│   ├── 01_splash_screen/
│   │   └── arranque_splash.feature
│   ├── 02_principal_screen/
│   │   └── pantalla_principal.feature
│   ├── 03_listas/
│   │   └── listas_favoritos.feature
│   ├── 03_vistas/
│   │   └── vistas_catalogo.feature
│   ├── 04_provider/
│   │   └── preferencias_tema.feature
│   ├── 05_provider_menus/
│   │   └── menus_appbar.feature
│   ├── 07_routes/
│   │   └── rutas_deep_links.feature
│   ├── 08_pantallas_inicio/
│   │   └── busqueda_propiedades.feature
│   ├── 08_pantallas_perfil/
│   ├── 08_pantallas_propiedades/
│   ├── 08_pantallas_tu_cuenta_conocidos/
│   ├── 08_pantallas_tu_cuenta_grupos/
│   ├── 08_pantallas_tu_cuenta_tus_espacios/
│   ├── 08_pantallas_ubicacion/
│   ├── 10_user_login/
│   ├── 12_localidades_user/
│   ├── 14_geolocalizacion/
│   ├── 20_var_globales/
│   ├── 22_imagenes/
│   ├── 40_security/
│   ├── 41_connectivity/
│   ├── 42_sistema_operativo/
│   ├── 60_global_widgets/
│   └── main/
│
├── 04_User_Stories/                    # 3 C's por Feature: Card, Conversation (Escenarios), Confirmation
│   ├── 01_home.md
│   ├── ... (uno .md por subdirectorio nivel 1)
│   └── main.md
│
└── 05_Tareas_Inventarios/              # Dos tablas por archivo .dart según el goal
    ├── 01_home/
    │   ├── componentes_01_home.md      # Tabla 1: Subdir, Archivo, Tipo componente, Nombre, Parámetros, Variables que utiliza, Variables internas, Estilos
    │   └── elementos_01_home.md        # Tabla 2: Subdir, Archivo, Variables definidas, Clases, Variables de la clase, Funciones/widgets, Variables que utiliza, Llamadas a otras clases/widgets
    ├── 01_splash_screen/
    │   ├── componentes_01_splash_screen.md
    │   └── elementos_01_splash_screen.md
    ├── ... (por cada subdirectorio nivel 1)
    └── main/
        └── elementos_main.md
```

## Metodologías aplicadas por paso

### Paso 1 — Ingeniería inversa (base de todos)
Lectura sistemática de cada `.dart` no autogenerado (los `.g.dart`/`.freezed.dart` se referencian brevemente pero no se documentan en profundidad, ya son derivados). La ingeniería inversa es la fuente para los pasos 2-6.

### Paso 2 — Iniciativa (OKRs + Lean Canvas)
- `01_OKRs.md`: 1 Objetivo inspirador (Iniciativa de negocio) + 3-5 Resultados Clave medibles (con % o cifras objetivo) basados en lo que el código permite inferir (catálogo de propiedades, motor social, geolocalización, multiplataforma, segmentos: promotores/propietarios/inmobiliarias/proveedores).
- `02_Lean_Canvas.md`: 9 bloques del Lean Canvas (Problema, Segmentos, Propuesta Valor, Solución, Canales, Ingresos, Costos, Métricas Clave, Ventaja Única) + sección ROI esperado.

### Paso 3 — Epics (User Story Mapping + Impact Mapping + SDD/EARS)
Por cada subdirectorio nivel 1 → un `.md` con:
- **Impact Mapping**: Objetivo de negocio → Actor(es) → Impacto(s) → Entregable (Epic).
- **User Story Mapping**: User Journey simplificado para ese subdirectorio; los grandes pasos del viaje = la Epic.
- **Especificación SDD/EARS pelo completo**: tablas por Feature con columnas `ID | Requerimiento | Evidencia | Estado`, donde cada Requerimiento sigue uno de los 6 patrones EARS (Ubicuo / Evento / Estado / No Deseado / Opcional / Compleño), con la sintaxis exacta en español ("El sistema deberá / Cuando [disparador], el sistema deberá / Mientras [estado], el sistema deberá / Si [falla], entonces el sistema deberá / Donde [función incluida], el sistema deberá / Mientras [estado], cuando [disparador], el sistema deberá"). SeReferenciar evidencia en archivos `.dart` con rutas con backslash (convención del repo). Mantener numeración `REQ-NN.xxx` compatible con el doc EARS existente (`_documentacion/03_SDD_HL/Buscobien_EARS_Requirements.md`), pero con prefijo nuevo para evitar colisión (por ejemplo `REQ-BSB-NN.xxx` o por sección Epic `REQ-EP01.xxx`).

### Paso 4 — Features BDD (Gherkin español)
Por cada Epic (subdirectorio nivel 1) → una carpeta `03_Features_BDD/<subdir>/` con uno o varios `.feature`. Cada `.feature` con:
```
# language: es
Característica: <nombre> con Material Design 3

  Como <usuario>
  Quiero <acción>
  Para <beneficio>
```
Una `Característica` por Feature entregable de la Epic. Reutilizaré y armonizaré los 150 `.feature` ya existentes en `_documentacion/04_BDD` y `02_BDD_HL` (formato ya compatible). Para Features no cubiertas por los existentes, las redactaré nuevos.

### Paso 5 — User Stories (Escenarios + 3 C's)
Por cada Feature del paso 4 → sección en `04_User_Stories/<subdir>.md` con:
- **Card**: "Como [usuario], quiero [acción] para [beneficio]".

### Paso 6 — Tareas / Inventarios (dos tablas por archivo .dart)
Por cada subdirectorio nivel 1 → carpeta `05_Tareas_Inventarios/<subdir>/` con dos `.md`:

**a) `componentes_<subdir>.md`** — inventario de componentes con tabla (siguiendo formato de `inventario_01_home.md`):

| Subdirectorio (si aplica) | Nombre del archivo | Tipo de componente | Nombre del componente | Parámetros que requiere | Variables que utiliza | Variables internas | Estilos que le aplican |

**b) `elementos_<subdir>.md`** — inventario de elementos con segunda tabla:

| Subdirectorio (si aplica) | Nombre del archivo | Variables definidas en el archivo | Clases | Variables de la clase | Funciones o widgets definidos en la clase | Variables que utiliza | Llamadas a otras clases o widgets |

Los `.dart` autogenerados (`.g.dart`, `.freezed.dart`) se incluirán con nota "Código generado por build_runner; ver archivo fuente" sin desglose completo, para respetar el criterio de terminación (abarcar TODOS los .dart) sin duplicar el esfuerzo en archivos derivados.

## Ejecución

Para mantener el rango de contexto controlable, ejecutaré por **lotes geográficos** del código (no por paso), de modo que cada subdirectorio se procesa completo de extremo a extremo (Epics → Features → User Stories → Inventarios) antes de pasar al siguiente. Esto evita releer los mismos archivos:

1. **Lote A** (base transversal): pasos 1-2 (Iniciativa OKR + Lean Canvas) — requiere panorama global, lo hago primero a partir de lo ya explorado.
2. **Lote B** (subsistemas pequeños): `main`, `01_splash_screen`, `01_home`, `07_routes`, `04_provider`, `41_connectivity`, `42_sistema_operativo`, `60_global_widgets`, `20_var_globales`, `40_security` — estos ya están parcialmente en `Buscobien_EARS_Requirements.md`.
3. **Lote C** (subsistemas medianos): `02_principal_screen`, `03_vistas`, `05_provider_menus`, `10_user_login`, `12_localidades_user`, `14_geolocalizacion`, `03_listas`.
4. **Lote D** (subsistema grande `08_pantallas`): `inicio`, `perfil`, `propiedades`, `ubicacion`, `tu_cuenta/conocidos`, `grupos`, `tus_espacios`, `widgets_comunes`.
5. **Lote E** (subsistema `22_imagenes`): completo con sus subcarpetas.

Por cada subdirectorio del lote:
- Lanzaré agentes Explore para leer el `.dart` fuente (no autogenerados).
- Reutilizaré inventarios y `.feature` ya existentes en `buscobien\_documentacion` cuando aplique (copiaré/adaptaré su contenido para `lib\_analisisydiseno`).
- Redactaré lo faltante con las metodologías indicadas.

## Criterio de terminación
Documentados **TODOS los archivos `.dart`** (los 218, incluyendo `.g.dart`/`.freezed.dart` referenciados brevemente) en los 6 pasos, abarcando toda la funcionalidad del sistema (del splash/navegación hasta motor social, geolocalización, gestión de fotos, permisos y widgets globales). Se entregará `00_README.md` con índice navegable.

## Notas
- **Idioma**: toda la doc en español (convención del repo).
- **Estilo**: Markdown, tablas `ID|Requerimiento|Evidencia|Estado`, rutas `.dart` con backslash,diagramas mermaid en inventarios cuando aporten.
- **No se modifica código existente**: solo se crean archivos nuevos bajo `lib\_analisisydiseno\`.
- **build_runner, tests,flutter analyze**: no se ejecutan (no se toca código, solo doc).
- Será un volumen alto de archivos (~80-100 documentos `.md` y `.feature`). Validaré al cierre el conteo total de `.dart` cubiertos vs 218.