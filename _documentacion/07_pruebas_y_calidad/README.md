# Etapa 7: Pruebas y Calidad de Software (SDLC Stage 7)

Esta carpeta reúne la estrategia de pruebas del sistema, comandos de automatización QA (`flutter test`, `flutter analyze`) y el repositorio completo de 129 archivos `.feature` de escenarios de prueba Gherkin BDD por pantalla.

---

## 📄 Estructura de Documentos en esta Etapa

| Elemento / Directorio | Descripción | Enlace Directo |
| :--- | :--- | :--- |
| **`estrategia_de_pruebas_y_smoke_tests.md`** | Estado real de las pruebas (9 pruebas en verde: seguridad y rutas), pirámide de pruebas objetivo, trazabilidad por tags y criterios de aceptación. | [Ver Documento](estrategia_de_pruebas_y_smoke_tests.md) |
| **Tags `@REQ-*`** | Cada escenario lleva `@REQ-<MÓD>-<NNN>` (trazabilidad con las Epics). `@mapeo-auto` marca una sugerencia sin revisar; `@pendiente` marca funcionalidad documentada que el código aún no tiene. Procedimiento en [`reconciliacion_epics_sdd.md`](../03_analisis_funcional/reconciliacion_epics_sdd.md). | — |
| **`gherkin_bdd_scenarios/`** | Repositorio completo de **129 archivos `.feature`** con escenarios de prueba BDD estructurados por módulo (`01_home`, `08_pantallas`, `10_user_login`, `14_geolocalizacion`, etc.). | [Explorar Escenarios BDD](gherkin_bdd_scenarios/) |
