# Estrategia de Pruebas y Aseguramiento de Calidad (QA) — BuscoBien

**Fase de SDLC:** Etapa 7 — Pruebas y Calidad de Software  
**Revisión de exactitud:** 2026-10-07 (se ejecutó `flutter test`; actualizado tras MEJ-02)

---

## 1. Estado real

| Elemento | Estado verificado |
| :--- | :--- |
| Pruebas automatizadas | 8 archivos, 33 pruebas: `async_value_widget_test`, `campo_texto_test` (validadores y `CampoTexto`), `campos_edicion_test` (ida y vuelta de los 68 campos), `seguridad_test` (hashes y token de recuperación), `rutas_test` (`routeGenerate`), `widgets_test` (`PaginaDeError`, `BotonAccionPropiedad`), `grupos_notifier_test` y `conocidos_notifier_test` (eliminar miembro/contacto con `MockClient`) |
| Resultado de `flutter test` | **Pasa** (`+16`, 2026-10-07). La prueba de plantilla del contador se eliminó (MEJ-02) |
| Pruebas unitarias de providers/modelos | No existen |
| Pruebas de integración | No existen |
| Escenarios Gherkin | 129 archivos detallados con 1.023 escenarios (más 48 archivos de análisis) **documentales**, no ejecutables todavía |
| Cobertura de código | No se mide |

La suite cubre solo seguridad y rutas; no hay pruebas de providers, widgets ni integración. Siguiente paso: MEJ-23 y MEJ-25.

## 2. Estrategia objetivo (pirámide de pruebas)

| Nivel | Qué cubrir primero | Herramienta |
| :--- | :--- | :--- |
| Unitarias | Funciones puras y modelos: `generate_hash`, `generate_reset_token`/`isTokenValid`, `routeGenerate` (22 rutas + `null`), `_navigateIfRecovery`, modelos Freezed (`fromJson`/`toJson`) | `flutter_test` |
| Providers | `HomeNavigation`, `coloresProvider`, `SessionNotifier`, `ConocidosNotifier`, `GruposNotifier` con un cliente HTTP simulado (`http` mock) | `flutter_test` + `ProviderContainer` |
| Widgets | `PaginaDetalleWidget`, `PaginaDeError`, formularios de login/registro, tema M3 | `flutter_test` (`testWidgets`) |
| Integración / BDD | Flujos críticos: login, recuperación de contraseña (deep link), búsqueda de propiedades, publicar propiedad | `integration_test` (o `bdd_widget_test` con los `.feature`) |

Prioridad por nivel de módulo (ver [`plan_de_trabajo.md`](../01_planeacion_y_estrategia/plan_de_trabajo.md) §4): primero los **A** (`10_user_login`, `40_security`, motor social, `tus_espacios`, `03_listas`, `12_localidades_user`, `22_imagenes`).

Meta sugerida: ≥ 70 % de cobertura de líneas en módulos nivel A y ≥ 40 % en B, medida con `flutter test --coverage`.

## 3. Trazabilidad requisito ↔ prueba

Cada escenario Gherkin lleva `@REQ-<MÓD>-<NNN>` (ver [`reconciliacion_epics_sdd.md`](../03_analisis_funcional/reconciliacion_epics_sdd.md)). Filtrar un requerimiento: `--tags @REQ-ROUT-007`. La matriz [`matriz_trazabilidad_ears_bdd_sdd.md`](../03_analisis_funcional/matriz_trazabilidad_ears_bdd_sdd.md) indica qué REQ aún no tienen escenario.

Convenciones de tags: `@REQ-…` (requerimiento), `@mapeo-auto` (sugerencia sin revisar), `@pendiente` (funcionalidad documentada que el código aún no tiene).

## 4. Análisis estático

```powershell
flutter analyze
```
Debe terminar sin errores (existen `riverpod_lint` y `analysis_options.yaml`). Los resultados históricos en la raíz (`analyze_output.txt`, `.dart_analysis.txt`) no forman parte de la documentación.

## 5. Escenarios Gherkin por módulo

Ubicación: [`gherkin_bdd_scenarios/`](gherkin_bdd_scenarios/) — una carpeta por módulo de `lib/` (`01_home`, `01_splash_screen`, `02_principal_screen`, `03_listas`, `03_vistas`, `04_provider`, `05_provider_menus`, `07_routes`, `08_pantallas/*`, `10_user_login`, `12_localidades_user`, `14_geolocalizacion`, `20_var_globales`, `22_imagenes`, `40_security`, `41_connectivity`, `42_sistema_operativo`, `60_global_widgets`, `main`).

Algunos escenarios describen comportamiento **deseado** que el código aún no tiene (p. ej., interceptor JWT, exportación a PDF accesible, eliminar miembro de grupo). Antes de automatizarlos, contrastarlos con la Epic correspondiente, donde el estado real está marcado.

## 6. Criterios de aceptación para producción

1. `flutter build web --wasm --dart-define-from-file=defines.json` termina con código 0.
2. `flutter analyze` sin errores.
3. `flutter test` pasa (hoy pasa: 33 pruebas).
4. Cumplimiento de [`antigravity_ui_rules.md`](../05_desarrollo_y_especificaciones_tecnicas/antigravity_ui_rules.md).
5. `python _documentacion/00_indice/verificar_documentacion.py` sin errores.
