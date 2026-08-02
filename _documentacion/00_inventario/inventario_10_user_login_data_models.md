# Inventario de Componentes - Sección `data_models` (D:\buscobien\lib\10_user_login\data_models)

Este módulo contiene todos los modelos de datos, estructuras de mapeo JSON y clases de estado de autenticación utilizadas en el flujo de inicio de sesión, perfiles y persistencia de perfiles del sistema Buscobien.

---

## Tabla de Inventario de Modelos de Datos

| Subdirectorio | Nombre del archivo | Tipo de componentes | Nombre del componente | Parámetros que requiere | Variables que utiliza (externas/globales/Riverpod) | Variables internas / Estado | Estilos que le aplican |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| N/A | `auth_state.dart` | Clase de Estado Inmutable | `AuthState` | Constructor nombrado / Fábrica `AuthState.initial()` | `SessionData`, `GetIdUserPass`, `GetUserData`, `LocalidadCp` | `sessionUserData`, `initialIdUserPass`, `userData`, flags de roles (`esUsuario`, `esPromotor`, `esPropietario`, etc.) y tokens | N/A |
| N/A | `data_get_id_user_pass.dart` | Clase de Mapeo JSON (CouchDB) | `GetIdUserPass`, `RowIdUserPass`, `ValueIdUserPass` | Constructor normal / Fábricas `fromJson` | Ninguno | `totalRows`, `offset`, `rows`, `id`, `key`, `value`, `userId`, `userName`, `userPass`, `idFoto` | N/A |
| N/A | `data_get_user.dart` | Clase de Mapeo JSON (CouchDB) | `GetUserData`, `RowGetUserData`, `ValueGetUserData` | Constructor normal / Fábricas `fromJson` | `Usuario` | `totalRows`, `offset`, `rows`, `id`, `key`, `value`, `usuario` | N/A |
| N/A | `data_user_promotor.dart` | Clase de Modelo de Datos | `UserDataPromotor` | Constructor normal / Fábricas `fromJson` | Ninguno | `tipodeusuario`, `rfc`, `numerodecliente`, `inmobiliaria`, espacios de publicación (`espacionormal`, `espaciodestacados`, etc.) | N/A |
| N/A | `data_usuarios.dart` | Clases de Modelos de Datos | `UserData`, `Usuario`, `FechaDeNacimiento`, `UbicacionUserData` | Constructor normal / Fábricas `fromJson` | `LocalidadCp`, `UserDataPromotor` | `usuario`, `idUsuario`, `avatar`, `nombres`, `apellidopaterno`, `apellidomaterno`, `numerocelular`, `correoelectronico`, `nombreusuario`, `claveacceso`, `ubicacionUserData`, `fechaDeNacimiento`, `timestamp`, `datospromotor` | N/A |
| N/A | `user_profile.dart` | Clase de Modelo de Datos (Freezed) | `UserProfile` | Constructor Freezed / Fábrica `fromJson` | Ninguno | `id`, `rev`, `avatarUrl`, `nombres`, `apellidos`, `correoElectronico`, `numeroCelular` | N/A |
| N/A | `user_profile.freezed.dart` | Código Autogenerado (Freezed) | Clase de mezcla y clases extendidas internas | Autogenerado por build_runner | Ninguno | Propiedades del modelo inmutables | N/A |
| N/A | `user_profile.g.dart` | Código Autogenerado (Serialización) | Funciones de parseo JSON | Autogenerado por build_runner | Ninguno | Funciones serializadoras | N/A |

---

## Análisis Técnico y Estructura de Datos

1. **Gestión Inmutable del Estado de Autenticación (`auth_state.dart`):**
   * La clase `AuthState` es el núcleo inmutable del estado de sesión en Buscobien. Agrupa los datos del usuario (`userData`), credenciales (`initialIdUserPass`) y flags de roles (`esUsuario`, `esPromotor`, `esPropietario`, `esVendedor`, etc.). Proporciona una fábrica `AuthState.initial()` para inicializar el estado vacío de manera predecible, y un método `copyWith` para realizar transiciones seguras e inmutables del estado bajo el patrón de Riverpod.

2. **Modelo de CouchDB Integrado:**
   * Las clases en `data_get_id_user_pass.dart` y `data_get_user.dart` replican con precisión la estructura en formato de "vistas" de CouchDB, incluyendo propiedades como `totalRows`, `offset` y una lista de `rows` con campos `key` y `value`. Esto permite deserializar respuestas directamente del motor CouchDB sin capas intermedias complejas.

3. **Inclusión de Dependencias Geográficas:**
   * `data_usuarios.dart` conecta la estructura del usuario con la geografía a través de `UbicacionUserData`, la cual integra de forma directa la clase `LocalidadCp` proveniente de la sección de ubicación. Esto vincula de forma nativa a cada usuario con su localidad SEPOMEX activa de manera estructurada.
