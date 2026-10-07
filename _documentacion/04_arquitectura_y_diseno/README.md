# Etapa 4: Arquitectura y Diseño de Software (SDLC Stage 4)

Esta carpeta reúne la especificación completa del diseño arquitectónico del sistema BuscoBien (*Software Design Documents - SDD*), patrones de navegación, diseño del Motor Social y arquitectura de capas.

---

## 📄 Estructura de Documentos en esta Etapa

| Archivo / Directorio | Descripción | Enlace Directo |
| :--- | :--- | :--- |
| **`arquitectura_general_buscobien.md`** | Arquitectura general del sistema, patrón Riverpod 3.x + Freezed + http + CouchDB (API Node.js como objetivo). | [Ver Documento](arquitectura_general_buscobien.md) |
| **`arquitectura_navegacion.md`** | Especificación completa de navegación reactiva sin GoRouter (`HomeNavigation` + `AppRoutes.routeGenerate`). | [Ver Documento](arquitectura_navegacion.md) |
| **`especificacion_motor_social.md`** | Especificación y diseño detallado del Motor Social (Conocidos, Grupos, Mensajería y Notificaciones). | [Ver Documento](especificacion_motor_social.md) |
| **`buscobien_sdd_maestro.md`** | SDD Maestro consolidado del sistema BuscoBien. | [Ver Documento](buscobien_sdd_maestro.md) |
| **`arquitectura_c4.md`** | Diagramas C4 (contexto, contenedores real y objetivo, componentes). | [Ver Documento](arquitectura_c4.md) |
| **`contrato_api_actual.md`** | Interfaces realmente usadas: patrones CouchDB, vistas, microservicio de correo, deep links. | [Ver Documento](contrato_api_actual.md) |
| **`modelo_de_amenazas.md`** | Modelo de amenazas STRIDE con evidencia en el código. | [Ver Documento](modelo_de_amenazas.md) |
| **`adr/registro_decisiones.md`** | Registro de decisiones de arquitectura (ADR-001…010) y plantilla. | [Ver Documento](adr/registro_decisiones.md) |
| **`modulos_sdd/`** | Catálogo de 29 documentos SDD detallados por cada módulo de `lib/` (`01_home`, `02_principal_screen`, `08_pantallas`, `10_user_login`, etc.). | [Explorar Modulos SDD](modulos_sdd/) |
