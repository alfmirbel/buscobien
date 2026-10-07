# Inventario de Componentes - Sección `localidades_user` (D:\buscobien\lib\12_localidades_user)

Este módulo gestiona la asignación, almacenamiento, recuperación y sincronización offline/online de las localidades geográficas preferidas de cada usuario basadas en el catálogo postal nacional de México (SEPOMEX). Permite la relación multi-localidad del usuario y asocia su ubicación activa directamente con su sesión de Riverpod.

---

## Tabla de Inventario de Componentes de Localidades de Usuario

| Subdirectorio | Nombre del archivo | Tipo de componentes | Nombre del componente | Parámetros que requiere | Variables que utiliza (externas/globales/Riverpod) | Variables internas / Estado | Estilos que le aplican |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| N/A | `data_user_localidad.dart` | Clase de Modelo de Datos (Freezed) | `UsuarioLocalidades` | Constructor Freezed / Fábrica `fromJson` | `LocalidadCp` | Propiedades inmutables de ubicación del usuario (`idCodigopostal`, `idUsuario`, `pais`, `localidadCp`, `calle`, `seccionine`, `latitud`, `longitud`, `latDecimal`, `lonDecimal`, `timestamp`) | N/A |
| N/A | `data_user_localidad_get.dart` | Clases de Mapeo JSON (Freezed / CouchDB) | `UsuarioLocalidadesGet`, `RowsUserLocal` | Constructor Freezed / Fábricas `fromJson` / Función global `usuarioLocalidadesGetFromJson` | `UsuarioLocalidades` | `totalRows`, `offset`, `rows` (`id`, `key`, `value`) | N/A |
| N/A | `data_user_localidad.freezed.dart` | Código Autogenerado (Freezed) | Clases extendidas de mezcla | Autogenerado por build_runner | Ninguno | Propiedades del modelo inmutables | N/A |
| N/A | `data_user_localidad.g.dart` | Código Autogenerado (Serialización) | Funciones de parseo JSON | Autogenerado por build_runner | Ninguno | Funciones serializadoras | N/A |
| N/A | `data_user_localidad_get.freezed.dart` | Código Autogenerado (Freezed) | Clases extendidas de mezcla | Autogenerado por build_runner | Ninguno | Propiedades del modelo inmutables | N/A |
| N/A | `data_user_localidad_get.g.dart` | Código Autogenerado (Serialización) | Funciones de parseo JSON | Autogenerado por build_runner | Ninguno | Funciones serializadoras | N/A |
| N/A | `localidades_repository.dart` | Clase de Repositorio de Datos / Provider | `LocalidadesRepository`, `localidadesRepositoryProvider` | `userId`, `asentamiento`, `localidad` (UsuarioLocalidades), `cp` (int) para métodos | `direccionip`, `username`, `password` (para auth headers) | `_headers`, consultas de CouchDB y deserialización | N/A |
| N/A | `provider_get_localidades_usuario.dart` | Notificador de Estado (Riverpod) / Providers | `ClassUserLocalNotifierProvider`, `userLocalidadesProvider`, `getUserLocalidadesFutureProvider` | `asentamiento` (String), `userLocal` (UsuarioLocalidades), `index` (int), `localidad` (LocalidadCp) para métodos | `localidadesRepositoryProvider`, `sessionProvider` | `localidadSeleccionada` (int) y mapeo del estado reactivo `UsuarioLocalidadesGet` | N/A |

---

## Análisis Técnico y Flujo de Operación

1. **Persistencia Basada en CouchDB (`localidades_repository.dart`):**
   * El repositorio implementa consultas avanzadas a vistas de mapas CouchDB en la base de datos `buscobien_user_localidad`. Utiliza la vista `vistaUserID` para recuperar las localidades de un ID de usuario específico y la vista compuesta `vistaUserAsentamiento` con llaves combinadas `["$userId", "$asentamiento"]` para validar la existencia y evitar registros duplicados (respondiendo con un código `409 Conflict`). También consulta la base de datos de apoyo `codigospostales` a través de la vista `vistaCP`.

2. **Reactividad de Ubicación Coordinada (`provider_get_localidades_usuario.dart`):**
   * El notifier reactivo `ClassUserLocalNotifierProvider` no solo mantiene una lista local con las localidades geográficas del usuario (`UsuarioLocalidadesGet`), sino que sincroniza activamente la sesión global. Métodos clave como `setUserLocalSelectedFromLocalidades` y `setUserLocalFromUserLocalGet` invocan de manera interna:
     `ref.read(sessionProvider.notifier).updateLocalidadEnSesion(locData.localidadCp)`
     Esto asegura que, al alternar entre las ubicaciones preferidas guardadas del usuario, toda la aplicación (búsquedas, filtros, mapa) reaccione instantáneamente a la nueva ubicación seleccionada sin requerir reinicios.

3. **Inmutabilidad Absoluta con Freezed:**
   * Tanto el modelo individual `UsuarioLocalidades` como el listado de resultados `UsuarioLocalidadesGet` se definen mediante anotaciones `@freezed`. Esto facilita enormemente la manipulación de arreglos y la copia segura de propiedades mediante `copyWith` (como en la adición de marcas de tiempo en tiempo real en `writeUserLocalidadToCouchDB`).
