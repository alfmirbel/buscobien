# Etapa 6: Modelo de Datos y Bases de Datos (SDLC Stage 6)

Esta carpeta consolida la especificación completa del modelo de datos de **BuscoBien**, mapeo de las 19 colecciones/bases de datos CouchDB (`buscobien_*`), convenciones de UUIDs, índices Mango y definición de modelos inmutables en Freezed.

---

## 📄 Estructura de Documentos en esta Etapa

| Archivo | Descripción | Enlace Directo |
| :--- | :--- | :--- |
| **`buscobien_databases_complete.md`** | **Diccionario de esquemas de 19 bases CouchDB (diseño)**: Propósitos, convenciones de Doc ID, índices Mango, vistas secundarias y ejemplos JSON, más un apéndice con los archivos de `lib/` que usan cada base. | [Ver Documento](buscobien_databases_complete.md) |
| **`bases_de_datos_en_codigo.md`** | Inventario **generado** (`generar_bases_de_datos_en_codigo.py`) de las bases `buscobien_*` que el código de `lib/` referencia, con módulos y archivos, comparado contra el diccionario. | [Ver Documento](bases_de_datos_en_codigo.md) |
| **`indice_archivos_modelos.md`** | Índice exhaustivo de modelos de datos Freezed (`.freezed.dart`, `.g.dart`), entidades de dominio y serialización JSON. | [Ver Documento](../00_indice/indice_archivos_modelos.md) |
