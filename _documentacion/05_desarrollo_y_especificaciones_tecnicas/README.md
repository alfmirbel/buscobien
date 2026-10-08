# Etapa 5: Desarrollo y Especificaciones Técnicas (SDLC Stage 5)

Esta carpeta reúne la documentación técnica directa para el equipo de desarrollo: stack tecnológico, reglas de compilación `--wasm`, mapa de dominios y archivos, convenciones de diseño Material Design 3 (M3) e inventarios detallados por componente y elemento.

---

## 📄 Estructura de Documentos en esta Etapa

| Archivo / Directorio | Descripción | Enlace Directo |
| :--- | :--- | :--- |
| **`stack_tecnologico.md`** | Stack tecnológico completo (Flutter Web WASM, Riverpod 3, Freezed, http, Google Maps, Node.js/Express, CouchDB) y comandos de compilación. | [Ver Documento](stack_tecnologico.md) |
| **`dominios_modulos_archivos.md`** | Mapa de dominios de negocio, responsabilidades de cada módulo en `lib/` y estructura de archivos. | [Ver Documento](dominios_modulos_archivos.md) |
| **`antigravity_ui_rules.md`** | **Reglas de UI Material Design 3 (Mandatorias)**: Uso del `ColorScheme` de `appTheme`, codepoints de íconos `0xe000`–`0xe900` y componentes M3. | [Ver Documento](antigravity_ui_rules.md) |
| **`revision_de_codigo.md`** | Revisión de código: inventario de pantallas de despliegue y captura, 26 hallazgos con evidencia y severidad. | [Ver Documento](revision_de_codigo.md) |
| **`inventario_componentes/`** | Vista arquitectónica por módulo (32 documentos): componentes, responsabilidades y diagramas Mermaid. Incluye `resumen_modulos_inventariados.md`, `reporte_archivos_dart_flujo_operacion.md` y `reporte_ubicacion_localidades.md`. | [Explorar Inventario Componentes](inventario_componentes/) |
| **`inventario_elementos/`** | Vista elemental por archivo (26 documentos): tablas de 10 columnas con clases, métodos, parámetros, variables y llamadas. | [Explorar Inventario Elementos](inventario_elementos/) |
