# Reconciliación de catálogos Epics ↔ SDD y etiquetado de Gherkin

**Fecha:** 2026-10-07  
**Estado:** reconciliación aplicada; mapeo a diseño parcialmente revisado (tabla manual) y mapeo a Gherkin *propuesto* (sin revisión humana completa).

## 1. Problema encontrado

| Hallazgo | Detalle |
| :--- | :--- |
| Dos catálogos con el mismo prefijo | Las Epics definían 250 `REQ-*`; 12 SDD definían otros 769 `REQ-*` propios. |
| Colisión de IDs con distinto significado | 74 IDs coincidían por nombre pero describían cosas distintas (p. ej. `REQ-MAIN-002`). La primera matriz los daba como trazados y eran falsos positivos. |
| IDs duplicados dentro de un mismo SDD | 77 definiciones repetidas (p. ej. `SDD-LIS-020`, `DES-COM-001`) en 11 SDD. |
| Contenido ajeno en un SDD | `SDD_modulo_08_pantallas_propiedades` incluía 32 requisitos de la pantalla de **Perfil** (copiados). |
| Gherkin sin IDs | Ningún escenario llevaba tags; la cobertura solo era posible por módulo. |
| Epics con datos inexactos | Nombres de bases inexistentes, funciones que el código no tiene, rutas y almacenamiento erróneos (ver §3). |

## 2. Decisión de reconciliación

1. **`REQ-*` identifica únicamente a los requerimientos de las Epics** (fuente oficial, nivel «qué»).
2. Los requisitos propios de los SDD pasan a **`DES-*`** (requisito de diseño, nivel «cómo»); 819 apariciones renombradas en 12 SDD. Los `SDD-*` se conservan. Los IDs duplicados se renumeraron (continúan la secuencia del prefijo).
3. La relación REQ → diseño es **de uno a muchos y opcional**: muchos elementos de diseño (fallos, opcionales, rendimiento) no tienen REQ padre; es correcto.
4. El vínculo se guarda **fuera de los documentos**, en CSV revisables.
5. Los `.feature` se etiquetan con `@REQ-<MÓD>-<NNN>` por escenario (formato Gherkin estándar, filtrable con `--tags`).

## 3. Correcciones a las Epics y a los documentos relacionados

| Módulo | Corrección |
| :--- | :--- |
| `07_routes` | 38 constantes de ruta, **22** con pantalla (antes «30+»); 16 sin `case`; `PaginaDeError` no se muestra; validación de deep link solo en `deep_link_handler`; Web evalúa la URL una sola vez; +5 requerimientos (`REQ-ROUT-013..017`). |
| `08_pantallas_propiedades` | `REQ-PROP-004..007` reescritos: **no existen** CTAs «Contactar/Compartir/Guardar en lista» en la ficha (los dos últimos viven en el carrusel de `22_imagenes`); `PdfGeneratorService` está implementado pero **ningún archivo lo invoca**; +3 requerimientos (`REQ-PROP-010..012`). |
| `10_user_login` | Token de recuperación se guarda en el documento del usuario (`usuario.reset_token`/`token_expiry`), no en una base aparte; flags de rol reales; `SessionStorage` usa `flutter_secure_storage` salvo en Web; +2 requerimientos (`REQ-AUTH-011..012`). |
| `08_pantallas_tu_cuenta_conocidos` | Aceptar/rechazar solo actualiza `status` en `buscobien_invitaciones` (no hay documentos bidireccionales ni mensaje de bienvenida); no existe borrar contacto. |
| `08_pantallas_tu_cuenta_grupos` | Los miembros viven en el arreglo `miembros` de `buscobien_grupos` (no existe `buscobien_grupos_miembros`); eliminar miembro **no está implementado** (escenario marcado `@pendiente`); +4 requerimientos (`REQ-GPU-013..016`). |
| `08_pantallas_tu_cuenta_tus_espacios` | +4 requerimientos funcionales (`REQ-ESP-011..014`: vistas por rol, ficha, edición en Stepper, publicar/despublicar con reversión). |
| Varios | Nombres de bases corregidos a los reales del código (`buscobien_usuarios_listas`, `buscobien_grupos_publicaciones`, `buscobien_grupos_avisos`, `buscobien_grupos_invitaciones`, `buscobien_user_localidad`, `codigospostales`, y las de propiedades en singular: `..._normal`, `_destacado`, `_super`, `_oportunidad`, `_remate`); `showMessageDialog` y `variables_imagenes.dart` descritos como son. |
| `SDD propiedades` | Se eliminaron los 32 requisitos de Perfil y las secciones 8–10 (que eran de Perfil); quedan 29 requisitos propios del detalle. |

Los requerimientos de arquitectura que el código aún no cumple (cliente → CouchDB directo, sin JWT) **no se corrigieron en el código**: siguen pendientes de la configuración de nginx y JWT; los documentos distinguen «estado real» de «objetivo».

## 4. Método de mapeo

`mapeo_trazabilidad.py` genera los CSV con tres niveles, siempre dentro del mismo módulo:

| Origen | Confianza / estado | Uso |
| :--- | :--- | :--- |
| Tabla manual [`mapeo_manual_diseno.csv`](mapeo_manual_diseno.csv) (117 reglas: id exacto o prefijo de sección → REQ) | `alta` / `tabla` | Vínculo firme. Cubre `10_user_login`, `tus_espacios`, `grupos`, `propiedades` y `07_routes`. |
| Similitud de texto (TF-IDF + coseno) elemento ↔ REQ | `alta` ≥ 0,34; `media` 0,22–0,34 / `propuesto` | `alta` firme; `media` probable («~»). |
| Similitud por sección del SDD ↔ REQ (≥ 0,25) | `grupo` / `propuesto` | Probable («~»). |
| Escenarios Gherkin ↔ REQ (similitud, máx. 2) | `alta`/`media` / `propuesto` | Se etiquetan ambos niveles con `@mapeo-auto`. |

Calidad estimada con muestreo manual: `alta` automática ≈ 70 %, `media` ≈ 50 %. Por eso los tags automáticos llevan `@mapeo-auto`; los escenarios con tags escritos a mano o confirmados no reciben sugerencias.

## 5. Resultados (matriz regenerada)

| Indicador | Antes | Ahora |
| :--- | ---: | ---: |
| Requerimientos de las Epics | 250 | 268 |
| REQ con elemento de diseño firme (alta/tabla/confirmado) | 74 (falsos positivos) | 164 (61 %) |
| …más probables | — | 19 |
| REQ con escenario Gherkin etiquetado | 0 | 207 (77 %) |
| Elementos de diseño / con vínculo firme por tabla | 1.484 | 1.452 / 329 |
| Elementos de diseño sin REQ padre | — | 318 |
| Escenarios Gherkin (detallados + análisis) | 1.231 | 1.264 (incluye 33 nuevos de `07_routes`) |
| Líneas de tags `@REQ` firmes / automáticas | 0 / 0 | 33 / 606 |
| REQ con historia de usuario (citada o de confianza alta) | 107 (43 %) | 189 (71 %) |
| REQ sin historia de usuario | 143 | 79 |
| Módulos sin SDD o Gherkin | `07_routes` | ninguno |

Se escribieron 15 historias nuevas (`US-ROUT-004`, `US-AUTH-007/008`, `US-TUS-007..010`, `US-GPU-008..011`, `US-PROP-006..008`) para los requerimientos agregados, y `mapeo_req_historias.csv` propone el vínculo historia → REQ para las historias que no citaban IDs (alta = firme, media = probable «~»).

## 6. Cómo revisar y mantener

1. Abrir `mapeo_req_gherkin.csv` y `mapeo_req_diseno.csv`; filtrar `confianza=media|grupo` y los módulos nivel A.
2. Corregir `req_id` y poner `estado=confirmado` (acepta) o `rechazado` (descarta). El script nunca sobrescribe filas confirmadas ni rechazadas. Para reglas masivas de diseño, editar `mapeo_manual_diseno.csv`.
3. Ejecutar en `03_analisis_funcional/`:

```powershell
python mapeo_trazabilidad.py                    # recalcula filas "propuesto"/"tabla"
python etiquetar_features.py --incluir-media    # escribe tags @REQ-* (idempotente)
python generar_matriz_trazabilidad.py           # regenera la matriz (lee los CSV de mapeo)
python ..\00_indice\verificar_documentacion.py  # contrasta con el código
```

4. En los `.feature`: una línea `@REQ-XXX-NNN` sin `@mapeo-auto` es **firme** (escrita a mano o confirmada) y se conserva; `@REQ-… @mapeo-auto` es una sugerencia que se recalcula. `python etiquetar_features.py --quitar` elimina solo las líneas formadas exclusivamente por tags `@REQ`/`@mapeo-auto`.
5. Filtrar por requerimiento al ejecutar BDD: `--tags @REQ-SEC-007`.

## 7. Pendientes

- Revisar las filas de confianza media y `grupo` (≈ 420 de diseño y ≈ 330 escenarios solo-media).
- Revisar `mapeo_req_historias.csv` y escribir historias para los 79 REQ que aún no tienen `US-*` (la mayoría son requerimientos técnicos o de deuda; valorar si merecen historia).
- Decidir, por cada función documentada que el código no cumple (exportar PDF sin invocar, CTAs de la ficha, eliminar miembro, 16 rutas sin pantalla), si se implementa o se retira del alcance.
- Corregir en el código el cliente → CouchDB directo cuando estén listos nginx y JWT.
