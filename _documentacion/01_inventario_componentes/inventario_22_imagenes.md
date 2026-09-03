# Inventario de Componentes y Modelos de Datos del Módulo `lib/22_imagenes`

Este reporte técnico ofrece una documentación exhaustiva del módulo de imágenes del proyecto **Buscobien**. Contiene el desglose técnico y detallado de cada uno de los **28 archivos** que integran la carpeta [lib/22_imagenes](file:///D:/buscobien/lib/22_imagenes), estructurado de acuerdo a su ubicación en la jerarquía de subdirectorios.

Para cada archivo, se incluye su descripción técnica y una tabla analítica que expone:
- El tipo de componentes.
- Los nombres de los componentes definidos (clases, funciones, widgets, etc.).
- Los parámetros requeridos para su instanciación u operación.
- Las dependencias y variables de contexto externas o globales que utiliza (incluyendo Providers y variables de configuración).
- Las variables internas que configuran su estado o lógica operativa interna.
- Los estilos visuales, fuentes y colores del tema global aplicados.

---

## Índice de Archivos Documentados

1. **Raíz del Módulo (`lib/22_imagenes`)**
   - [variables_imagenes.dart](file:///D:/buscobien/lib/22_imagenes/variables_imagenes.dart)
2. **Subdirectorio `data_models`**
   - [data_fotos_casa.dart](file:///D:/buscobien/lib/22_imagenes/data_models/data_fotos_casa.dart)
   - [data_fotos_casa_get.dart](file:///D:/buscobien/lib/22_imagenes/data_models/data_fotos_casa_get.dart)
   - [data_fotos_casa_get_ids.dart](file:///D:/buscobien/lib/22_imagenes/data_models/data_fotos_casa_get_ids.dart)
   - [data_fotos_ordenadas.dart](file:///D:/buscobien/lib/22_imagenes/data_models/data_fotos_ordenadas.dart)
3. **Subdirectorio `inicio_fotos_usuario`**
   - [pagina_carousel_fotos_usuario.dart](file:///D:/buscobien/lib/22_imagenes/inicio_fotos_usuario/pagina_carousel_fotos_usuario.dart)
   - [pagina_carousel_fotos_usuario_mini.dart](file:///D:/buscobien/lib/22_imagenes/inicio_fotos_usuario/pagina_carousel_fotos_usuario_mini.dart)
4. **Subdirectorio `tus_espacios_fotos_propiedad`**
   - [funciones_compress_image.dart](file:///D:/buscobien/lib/22_imagenes/tus_espacios_fotos_propiedad/funciones_compress_image.dart)
   - [image_file_structure.dart](file:///D:/buscobien/lib/22_imagenes/tus_espacios_fotos_propiedad/image_file_structure.dart)
5. **Subdirectorio `tus_espacios_fotos_propiedad/manejo_de_fotos/datos_fotos`**
   - [data_couchdb_post_return.dart](file:///D:/buscobien/lib/22_imagenes/tus_espacios_fotos_propiedad/manejo_de_fotos/datos_fotos/data_couchdb_post_return.dart)
   - [data_cuenta_fotos.dart](file:///D:/buscobien/lib/22_imagenes/tus_espacios_fotos_propiedad/manejo_de_fotos/datos_fotos/data_cuenta_fotos.dart)
   - [data_fotos_lista_fotos_iduser_idprop.dart](file:///D:/buscobien/lib/22_imagenes/tus_espacios_fotos_propiedad/manejo_de_fotos/datos_fotos/data_fotos_lista_fotos_iduser_idprop.dart)
6. **Subdirectorio `tus_espacios_fotos_propiedad/manejo_de_fotos/fotos_de_la_propiedad`**
   - [pagina_agrega_multiples_fotos.dart](file:///D:/buscobien/lib/22_imagenes/tus_espacios_fotos_propiedad/manejo_de_fotos/fotos_de_la_propiedad/pagina_agrega_multiples_fotos.dart)
7. **Subdirectorio `tus_espacios_fotos_propiedad/manejo_de_fotos/futures_y_providers`**
   - [future_funciones_fotos.dart](file:///D:/buscobien/lib/22_imagenes/tus_espacios_fotos_propiedad/manejo_de_fotos/futures_y_providers/future_funciones_fotos.dart)
   - [future_get_fotos_by_idpr_orden.dart](file:///D:/buscobien/lib/22_imagenes/tus_espacios_fotos_propiedad/manejo_de_fotos/futures_y_providers/future_get_fotos_by_idpr_orden.dart)
   - [future_recupera_ids_fotos_propiedad.dart](file:///D:/buscobien/lib/22_imagenes/tus_espacios_fotos_propiedad/manejo_de_fotos/futures_y_providers/future_recupera_ids_fotos_propiedad.dart)
   - [http_funciones_gestion_foto.dart](file:///D:/buscobien/lib/22_imagenes/tus_espacios_fotos_propiedad/manejo_de_fotos/futures_y_providers/http_funciones_gestion_foto.dart)
   - [provider_get_fotos_ids_user_propiedad.dart](file:///D:/buscobien/lib/22_imagenes/tus_espacios_fotos_propiedad/manejo_de_fotos/futures_y_providers/provider_get_fotos_ids_user_propiedad.dart)
8. **Subdirectorio `tus_espacios_fotos_propiedad/manejo_de_fotos/lista_fotos_ordenadas`**
   - [clase_listas_fotos_propiedad.dart](file:///D:/buscobien/lib/22_imagenes/tus_espacios_fotos_propiedad/manejo_de_fotos/lista_fotos_ordenadas/clase_listas_fotos_propiedad.dart)
   - [data_fotos_ordenadas_get_idpropiedad.dart](file:///D:/buscobien/lib/22_imagenes/tus_espacios_fotos_propiedad/manejo_de_fotos/lista_fotos_ordenadas/data_fotos_ordenadas_get_idpropiedad.dart)
   - [future_put_fotos_orden.dart](file:///D:/buscobien/lib/22_imagenes/tus_espacios_fotos_propiedad/manejo_de_fotos/lista_fotos_ordenadas/future_put_fotos_orden.dart)
   - [future_update_fotos_orden.dart](file:///D:/buscobien/lib/22_imagenes/tus_espacios_fotos_propiedad/manejo_de_fotos/lista_fotos_ordenadas/future_update_fotos_orden.dart)
   - [provider_get_lista_fotos_ordenadas.dart](file:///D:/buscobien/lib/22_imagenes/tus_espacios_fotos_propiedad/manejo_de_fotos/lista_fotos_ordenadas/provider_get_lista_fotos_ordenadas.dart)
9. **Subdirectorio `tus_espacios_fotos_propiedad/manejo_de_fotos/lista_ids_fotos`**
   - [data_fotos_get_ids_fotos_user_prop.dart](file:///D:/buscobien/lib/22_imagenes/tus_espacios_fotos_propiedad/manejo_de_fotos/lista_ids_fotos/data_fotos_get_ids_fotos_user_prop.dart)
10. **Subdirectorio `tus_espacios_fotos_propiedad/manejo_de_fotos/opciones_menu_fotos`**
    - [pagina_fotos_menu_opciones.dart](file:///D:/buscobien/lib/22_imagenes/tus_espacios_fotos_propiedad/manejo_de_fotos/opciones_menu_fotos/pagina_fotos_menu_opciones.dart)
    - [pagina_lista_fotos_carousel.dart](file:///D:/buscobien/lib/22_imagenes/tus_espacios_fotos_propiedad/manejo_de_fotos/opciones_menu_fotos/pagina_lista_fotos_carousel.dart)
    - [pagina_lista_fotos_cuadros.dart](file:///D:/buscobien/lib/22_imagenes/tus_espacios_fotos_propiedad/manejo_de_fotos/opciones_menu_fotos/pagina_lista_fotos_cuadros.dart)
    - [pagina_lista_fotos_listado.dart](file:///D:/buscobien/lib/22_imagenes/tus_espacios_fotos_propiedad/manejo_de_fotos/opciones_menu_fotos/pagina_lista_fotos_listado.dart)

---

## 1. Raíz del Módulo (`lib/22_imagenes`)

### [variables_imagenes.dart](file:///D:/buscobien/lib/22_imagenes/variables_imagenes.dart)
Define variables globales numéricas que controlan las dimensiones de renderizado estándar para los cuadros de fotos de las propiedades y el número de fichas en carruseles a lo largo del módulo.

| Subdirectorio | Nombre de Archivo | Tipo de Componentes | Nombre del Componente | Parámetros que requiere | Variables que utiliza | Variables internas | Estilos que le aplican |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| N/A (Raíz) | `variables_imagenes.dart` | Variables Globales | `widthCuadroFotoPropiedad`, `heightCuadroFotoPropiedad`, `numerodefichas` | Ninguno | Ninguna | Ninguna | Define dimensiones base: ancho (`300`), alto (`200`) y número base de fichas (`6`). |

---

## 2. Subdirectorio `data_models`

### [data_fotos_casa.dart](file:///D:/buscobien/lib/22_imagenes/data_models/data_fotos_casa.dart)
Contiene la estructura principal del modelo de datos para representar una foto de propiedad individual, incluyendo serialización y deserialización JSON desde/hacia CouchDB.

| Subdirectorio | Nombre de Archivo | Tipo de Componentes | Nombre del Componente | Parámetros que requiere | Variables que utiliza | Variables internas | Estilos que le aplican |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| `data_models` | `data_fotos_casa.dart` | Modelo de Datos y Funciones Helpers | `FotosCasa`, `FotosCasaClass`, `fotosCasaFromJson`, `fotosCasaToJson` | **FotosCasa**: `fotosCasaClass`<br>**FotosCasaClass**: `idFoto`, `idUsuario`, `idPropiedad`, `filaname`, `path`, `size`, `identifier`, `foto`, `contentType`, `timestamp` | `dart:convert` (JSON encoding/decoding) | Propiedades del objeto para serialización JSON | N/A |

### [data_fotos_casa_get.dart](file:///D:/buscobien/lib/22_imagenes/data_models/data_fotos_casa_get.dart)
Define el modelo de datos utilizado para procesar la respuesta estructurada de las consultas `_view` de CouchDB al solicitar una o más fotos de propiedades.

| Subdirectorio | Nombre de Archivo | Tipo de Componentes | Nombre del Componente | Parámetros que requiere | Variables que utiliza | Variables internas | Estilos que le aplican |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| `data_models` | `data_fotos_casa_get.dart` | Modelo de Datos y Funciones Helpers | `FotosCasaGet`, `RowFotosCasaGet`, `ValueFotosCasaGet`, `fotosCasaGetFromJson`, `fotosCasaGetToJson` | **FotosCasaGet**: `totalRows`, `offset`, `rows`<br>**RowFotosCasaGet**: `id`, `key`, `value`<br>**ValueFotosCasaGet**: `id`, `rev`, `fotosCasa` | `dart:convert`, `data_fotos_casa.dart` | Estructuras de listas y mapas de mapeo JSON | N/A |

### [data_fotos_casa_get_ids.dart](file:///D:/buscobien/lib/22_imagenes/data_models/data_fotos_casa_get_ids.dart)
Representa el modelo de datos para capturar listas de fotos filtradas por llaves compuestas de IDs de usuario e IDs de propiedad.

| Subdirectorio | Nombre de Archivo | Tipo de Componentes | Nombre del Componente | Parámetros que requiere | Variables que utiliza | Variables internas | Estilos que le aplican |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| `data_models` | `data_fotos_casa_get_ids.dart` | Modelo de Datos y Funciones Helpers | `FotosCasaGetIDs`, `RowFotosCasaGetIDs`, `ValueFotosCasaGetIDs`, `fotosCasaGetIDsFromJson`, `fotosCasaGetIDsToJson` | **FotosCasaGetIDs**: `totalRows`, `offset`, `rows`<br>**RowFotosCasaGetIDs**: `id`, `key` (lista de IDs), `value`<br>**ValueFotosCasaGetIDs**: `id`, `rev`, `fotosCasa` | `dart:convert`, `data_fotos_casa.dart` | Mapeo de campos JSON de CouchDB | N/A |

### [data_fotos_ordenadas.dart](file:///D:/buscobien/lib/22_imagenes/data_models/data_fotos_ordenadas.dart)
Establece el modelo de datos para persistir y reordenar las posiciones de las fotos pertenecientes a una propiedad, mapeando el orden de visualización de forma inmutable.

| Subdirectorio | Nombre de Archivo | Tipo de Componentes | Nombre del Componente | Parámetros que requiere | Variables que utiliza | Variables internas | Estilos que le aplican |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| `data_models` | `data_fotos_ordenadas.dart` | Modelo de Datos | `ListaFotosOrdenadas`, `FotosOrden`, `listaFotosOrdenadasFromJson`, `listaFotosOrdenadasToJson` | **ListaFotosOrdenadas**: `idListaFotos`, `idUsuario`, `idPropiedad`, `fotosOrden`, `timestamp`<br>**FotosOrden**: `posicion`, `idFoto` | `dart:convert` | Estructura anidada para representar arreglos de fotos y sus posiciones | N/A |

---

## 3. Subdirectorio `inicio_fotos_usuario`

### [pagina_carousel_fotos_usuario.dart](file:///D:/buscobien/lib/22_imagenes/inicio_fotos_usuario/pagina_carousel_fotos_usuario.dart)
Pantalla principal interactiva para que el usuario final visualice las fotos de una propiedad específica en formato de carrusel completo, con botones de navegación lateral y menús de opciones flotantes.

| Subdirectorio | Nombre de Archivo | Tipo de Componentes | Nombre del Componente | Parámetros que requiere | Variables que utiliza | Variables internas | Estilos que le aplican |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| `inicio_fotos_usuario` | `pagina_carousel_fotos_usuario.dart` | ConsumerStatefulWidget | `PaginaCarouselFotosUsuario`, `PaginaCarouselFotosUsuarioState` | `valueespaciosparameter` (tipo `ValueEspaciosCasaGet`) | `sessionProvider`, `getListaFotosOrdenadasProvider`, `widthCuadroFotoPropiedad`, `heightCuadroFotoPropiedad` (globales) | `scaffoldKeyCarouselFotos`, `idUsuario`, `idPropiedad`, `nombrePropiedad`, `tipoDeEspacio`, `indiceFotos`, `numeroDeFotos`, `controllerCarousel`, `propiedad`, `listaidsfotos`, `listaIdFotosOrden`, `_futureMetaData` | **Fondo**: `appTheme.onSecondary` (blanco/claro)<br>**Color Principal**: `appTheme.primary`<br>**Color Secundario**: `appTheme.secondary`<br>**Bordes**: Redondeo `BorderRadius.circular(12)`<br>**Controles**: Desactivados (`appTheme.onPrimary`), Activos (`appTheme.primary`) |

### [pagina_carousel_fotos_usuario_mini.dart](file:///D:/buscobien/lib/22_imagenes/inicio_fotos_usuario/pagina_carousel_fotos_usuario_mini.dart)
Variación compacta (Mini) del visualizador de carrusel de fotos, optimizada para tarjetas de listado de búsqueda rápida y pantallas secundarias que requieren menor uso de memoria y espacio.

| Subdirectorio | Nombre de Archivo | Tipo de Componentes | Nombre del Componente | Parámetros que requiere | Variables que utiliza | Variables internas | Estilos que le aplican |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| `inicio_fotos_usuario` | `pagina_carousel_fotos_usuario_mini.dart` | ConsumerStatefulWidget | `PaginaCarouselFotosMini`, `PaginaCarouselFotosMiniState` | `valueespaciosparameter` (tipo `ValueEspaciosCasaGet`) | `getListaFotosOrdenadasProvider` | `scaffoldKeyCarouselFotos`, `idUsuario`, `idPropiedad`, `nombrePropiedad`, `indiceFotos`, `numeroDeFotos`, `controllerCarousel`, `propiedad`, `listaidsfotos`, `listaIdFotosOrden`, `_futureMetaData` | **Dimensiones**: `widthCuadroFotoPropiedadLocal` (`200`), `heightCuadroFotoPropiedadLocal` (`125`) locales.<br>**Colores**: `appTheme.onSecondary`, `appTheme.outline`, `appTheme.primary`. |

---

## 4. Subdirectorio `tus_espacios_fotos_propiedad`

### [funciones_compress_image.dart](file:///D:/buscobien/lib/22_imagenes/tus_espacios_fotos_propiedad/funciones_compress_image.dart)
Conjunto optimizado de funciones utilitarias y de compresión gráfica. Adapta la estrategia de compresión automáticamente dependiendo de la plataforma de ejecución (usa `flutter_image_compress` nativo en Android/iOS y fallback asíncrono con decodificación de Dart puro bajo el paquete `image` para Windows y la Web).

| Subdirectorio | Nombre de Archivo | Tipo de Componentes | Nombre del Componente | Parámetros que requiere | Variables que utiliza | Variables internas | Estilos que le aplican |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| `tus_espacios_fotos_propiedad` | `funciones_compress_image.dart` | Helpers / Funciones de Utilidad Gráfica | `testCompressFile`, `testCompressAndGetFile`, `testCompressAsset`, `compressImageWeb`, `fotoCompressListWebP`, `fotoCompressListWin`, `convertToWebP` | Depende de la función: `File` (móvil), `imagePath` (String en Windows), `imageBytes` (Uint8List en Web/móvil) o `compress` (nivel de calidad entero 0-100) | `kIsWeb`, `Platform.isWindows`, `FlutterImageCompress`, paquete `image` as `img`, `debugPrintLevels` | Variables de imágenes decodificadas (`Image?`), buffers comprimidos (`Uint8List`), archivos temporales de destino | N/A |

### [image_file_structure.dart](file:///D:/buscobien/lib/22_imagenes/tus_espacios_fotos_propiedad/image_file_structure.dart)
Estructura auxiliar mutable que sirve para desacoplar los datos de los archivos seleccionados de la clase final de `file_picker` (la cual posee propiedades inmutables), permitiendo modificar la ruta, el tamaño y los bytes una vez efectuada la compresión en tiempo de ejecución.

| Subdirectorio | Nombre de Archivo | Tipo de Componentes | Nombre del Componente | Parámetros que requiere | Variables que utiliza | Variables internas | Estilos que le aplican |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| `tus_espacios_fotos_propiedad` | `image_file_structure.dart` | Estructura de Datos / Helpers | `PlatformFileNoFinal`, `copiaPlatformFile2NoFinal`, `emptyBytes` | **PlatformFileNoFinal**: `path`, `name`, `size`, `bytes`, `readStream`, `identifier`<br>**copiaPlatformFile2NoFinal**: `platformFile`, `result` (PlatformFile) | `PlatformFile` de `file_picker`, `Uint8List` | Propiedades mutables de clase | N/A |

---

## 5. Subdirectorio `tus_espacios_fotos_propiedad/manejo_de_fotos/datos_fotos`

### [data_couchdb_post_return.dart](file:///D:/buscobien/lib/22_imagenes/tus_espacios_fotos_propiedad/manejo_de_fotos/datos_fotos/data_couchdb_post_return.dart)
Modelo de datos para capturar y deserializar los metadatos retornados por CouchDB tras operaciones exitosas de inserción o actualización (POST/PUT), los cuales informan el éxito (`ok`), el ID autogenerado (`id`) y el hash de revisión actual (`rev`).

| Subdirectorio | Nombre de Archivo | Tipo de Componentes | Nombre del Componente | Parámetros que requiere | Variables que utiliza | Variables internas | Estilos que le aplican |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| `.../datos_fotos` | `data_couchdb_post_return.dart` | Modelo de Datos y Helpers JSON | `CouchDbReturnValue`, `couchDbReturnValueFromJson`, `couchDbReturnValueToJson` | **CouchDbReturnValue**: `ok`, `id`, `rev` | `dart:convert` | Mapeo de respuestas HTTP de base de datos | N/A |

### [data_cuenta_fotos.dart](file:///D:/buscobien/lib/22_imagenes/tus_espacios_fotos_propiedad/manejo_de_fotos/datos_fotos/data_cuenta_fotos.dart)
Modelo de datos para interpretar respuestas agregadas de conteo procedentes de consultas de reducción en CouchDB, facilitando la lectura directa del valor numérico total de fotos asociadas.

| Subdirectorio | Nombre de Archivo | Tipo de Componentes | Nombre del Componente | Parámetros que requiere | Variables que utiliza | Variables internas | Estilos que le aplican |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| `.../datos_fotos` | `data_cuenta_fotos.dart` | Modelo de Datos y Helpers JSON | `CuentaFotos`, `RowCuentaFotos`, `cuentaFotosFromJson`, `cuentaFotosToJson` | **CuentaFotos**: `rows` (Lista de Rows)<br>**RowCuentaFotos**: `key`, `value` | `dart:convert` | Campos de conteo CouchDB | N/A |

### [data_fotos_lista_fotos_iduser_idprop.dart](file:///D:/buscobien/lib/22_imagenes/tus_espacios_fotos_propiedad/manejo_de_fotos/datos_fotos/data_fotos_lista_fotos_iduser_idprop.dart)
Modelo de datos especializado para decodificar consultas estructuradas por llaves compuestas de fotos que enlazan un ID de usuario con un ID de propiedad específicos.

| Subdirectorio | Nombre de Archivo | Tipo de Componentes | Nombre del Componente | Parámetros que requiere | Variables que utiliza | Variables internas | Estilos que le aplican |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| `.../datos_fotos` | `data_fotos_lista_fotos_iduser_idprop.dart` | Modelo de Datos y Helpers JSON | `ListaFotosIdsPropiedadGet`, `RowListaFotosIds`, `ValueListaFotosIds`, `listaIdsUserPropertyFotoGetFromJson`, `listaIdsUserPropertyFotoGetToJson` | **ListaFotosIdsPropiedadGet**: `totalRows`, `offset`, `rows`<br>**RowListaFotosIds**: `id`, `key`, `value`<br>**ValueListaFotosIds**: `idUsuario`, `idPropiedad`, `idFoto` | `dart:convert` | Variables JSON | N/A |

---

## 6. Subdirectorio `tus_espacios_fotos_propiedad/manejo_de_fotos/fotos_de_la_propiedad`

### [pagina_agrega_multiples_fotos.dart](file:///D:/buscobien/lib/22_imagenes/tus_espacios_fotos_propiedad/manejo_de_fotos/fotos_de_la_propiedad/pagina_agrega_multiples_fotos.dart)
Formulario completo y dinámico que permite la carga por lotes de imágenes desde el disco del dispositivo, ejecutando el flujo de compresión bajo hilos asíncronos en paralelo, y guardando de forma masiva los resultados en el almacén de CouchDB.

| Subdirectorio | Nombre de Archivo | Tipo de Componentes | Nombre del Componente | Parámetros que requiere | Variables que utiliza | Variables internas | Estilos que le aplican |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| `.../fotos_de_la_propiedad` | `pagina_agrega_multiples_fotos.dart` | ConsumerStatefulWidget | `AgregaMultiplesFotos`, `AgregaMultiplesFotosState` | `parametros` (tipo `Map<String, dynamic>` que contiene `idUsuario`, `idPropiedad`, `propiedad`, etc.) | `checaPlataformaProvider`, `appTheme`, `direccionip`, `username`, `password`, `parameterGestionFoto` | `listadefotos`, `idUsuario`, `idPropiedad`, `idFoto`, `_isLoading`, `propiedad`, `seleccionada`, `principalbool`, `botonGuardaFotosActive` | **Colores**: Fondo (`appTheme.onPrimary`), tarjetas e iconos (`appTheme.secondary`), loader spinner (`appTheme.primary`).<br>**Fuentes**: `Comfortaa` y `Outfit`. |

---

## 7. Subdirectorio `tus_espacios_fotos_propiedad/manejo_de_fotos/futures_y_providers`

### [future_funciones_fotos.dart](file:///D:/buscobien/lib/22_imagenes/tus_espacios_fotos_propiedad/manejo_de_fotos/futures_y_providers/future_funciones_fotos.dart)
Concentra diálogos interactivos de confirmación del sistema de archivos (ej. diálogos modales para la confirmación de la eliminación física de fotos) y mapeos de códigos de error de bases de datos.

| Subdirectorio | Nombre de Archivo | Tipo de Componentes | Nombre del Componente | Parámetros que requiere | Variables que utiliza | Variables internas | Estilos que le aplican |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| `.../futures_y_providers` | `future_funciones_fotos.dart` | Diálogos y Funciones de Flujo de UI | `dialogConfirmaBorradoFoto` (asíncrono) | `context` (BuildContext) | `appTheme`, `getListaFotosOrdenadasProvider`, `sessionProvider` | `seleccion` (bool) | **Fondo Diálogo**: `appTheme.error` (Alerta/rojo para operaciones críticas)<br>**Botones**: `appTheme.onPrimary` (Fondo), `appTheme.primary` (Texto).<br>**Fuente**: `Comfortaa` en negritas.<br>**Textos**: `fontSizeCard` global. |

### [future_get_fotos_by_idpr_orden.dart](file:///D:/buscobien/lib/22_imagenes/tus_espacios_fotos_propiedad/manejo_de_fotos/futures_y_providers/future_get_fotos_by_idpr_orden.dart)
Implementa la lógica de red de bajo nivel para recuperar el listado ordenador de fotos persistido en CouchDB, integrando protección contra llamadas huérfanas en widgets desmontados (*Async Gaps*).

| Subdirectorio | Nombre de Archivo | Tipo de Componentes | Nombre del Componente | Parámetros que requiere | Variables que utiliza | Variables internas | Estilos que le aplican |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| `.../futures_y_providers` | `future_get_fotos_by_idpr_orden.dart` | Petición de Red / Future | `recuperaFotosOrdenadasIdProperty` | `ref` (WidgetRef), `idPropiedad` (String) | `getListaFotosOrdenadasProvider`, `direccionip`, `username`, `password`, `http.Client` | `statusCode`, `keyEncoded`, `baseUrl`, `basicAuth`, `headers`, `response`, `jsonResponse`, `resultado` | N/A |

### [future_recupera_ids_fotos_propiedad.dart](file:///D:/buscobien/lib/22_imagenes/tus_espacios_fotos_propiedad/manejo_de_fotos/futures_y_providers/future_recupera_ids_fotos_propiedad.dart)
Gestiona la petición HTTP de solo IDs, la cual retorna las llaves primarias de las fotos de la propiedad sin descargar las pesadas cadenas binarias de imágenes (*Base64*), optimizando el rendimiento de carga inicial.

| Subdirectorio | Nombre de Archivo | Tipo de Componentes | Nombre del Componente | Parámetros que requiere | Variables que utiliza | Variables internas | Estilos que le aplican |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| `.../futures_y_providers` | `future_recupera_ids_fotos_propiedad.dart` | Petición de Red / Future | `recuperaIdsFotosDePropiedades` | `idUsuario` (String), `idPropiedad` (String) | `direccionip`, `username`, `password`, `http.Client` | `listaIdsFotos`, `statusCode`, `jsonKey`, `encodedKey`, `baseUrl`, `basicAuth`, `headers`, `response` | N/A |

### [http_funciones_gestion_foto.dart](file:///D:/buscobien/lib/22_imagenes/tus_espacios_fotos_propiedad/manejo_de_fotos/futures_y_providers/http_funciones_gestion_foto.dart)
Orquestador principal de peticiones asíncronas HTTP relacionadas con fotos. Provee funciones para borrar registros por ID, recuperar imágenes completas en Base64, contar elementos y enviar nuevas imágenes decodificadas a CouchDB.

| Subdirectorio | Nombre de Archivo | Tipo de Componentes | Nombre del Componente | Parámetros que requiere | Variables que utiliza | Variables internas | Estilos que le aplican |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| `.../futures_y_providers` | `http_funciones_gestion_foto.dart` | API de Red / Helpers HTTP | `deleteFotoPorIdFoto`, `recuperaFotoPorIdFoto`, `numeroDeImagenesIdUserPropiedad`, `guardaFotoEnCouchDB`, `borraFoto` | Variables según método (`id`, `rev`, `idFoto`, `idUsuario`, `idPropiedad`, `ref`, `fotosCasa`) | `direccionip`, `username`, `password`, `getListaFotosCasaProviderId` | `resultado`, `encodedRev`, `baseUrl`, `basicAuth`, `headers`, `response`, `fotosCasa` | N/A |

### [provider_get_fotos_ids_user_propiedad.dart](file:///D:/buscobien/lib/22_imagenes/tus_espacios_fotos_propiedad/manejo_de_fotos/futures_y_providers/provider_get_fotos_ids_user_propiedad.dart)
Declara el proveedor Riverpod encargado de mantener en memoria caché reactiva los datos de las fotos seleccionadas o cargadas actualmente en el formulario, proveyendo métodos de inserción inmutables.

| Subdirectorio | Nombre de Archivo | Tipo de Componentes | Nombre del Componente | Parámetros que requiere | Variables que utiliza | Variables internas | Estilos que le aplican |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| `.../futures_y_providers` | `provider_get_fotos_ids_user_propiedad.dart` | Riverpod NotifierProvider | `getListaFotosCasaProviderId`, `ClassListaFotosCasaNotifierProvider` | `listaFotos` (en `setListaDeFotosPropiedad`), `fotosCasa` (en `addEspacioFotoListaDeFotosPropiedad`) | `FotosCasaGetIDs`, `RowFotosCasaGetIDs`, `ValueFotosCasaGetIDs`, `FotosCasaClass` | `newRows` (Lista temporal inmutable de filas) | N/A |

---

## 8. Subdirectorio `tus_espacios_fotos_propiedad/manejo_de_fotos/lista_fotos_ordenadas`

### [clase_listas_fotos_propiedad.dart](file:///D:/buscobien/lib/22_imagenes/tus_espacios_fotos_propiedad/manejo_de_fotos/lista_fotos_ordenadas/clase_listas_fotos_propiedad.dart)
Clase contenedora auxiliar diseñada para encapsular conjuntos compuestos de listas de fotos ordenadas junto con sus listas correspondientes de IDs crudos bajo un único objeto de transferencia de datos.

| Subdirectorio | Nombre de Archivo | Tipo de Componentes | Nombre del Componente | Parámetros que requiere | Variables que utiliza | Variables internas | Estilos que le aplican |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| `.../lista_fotos_ordenadas` | `clase_listas_fotos_propiedad.dart` | Clase de Estructura de Datos | `ListasFotosPropiedad` | `idPropiedad`, `listasfotosordenadas`, `listasidsfotos` | `ListaFotosOrdenadasGetIdPropiedad`, `GetIdsFotosUserProp` | Propiedades internas | N/A |

### [data_fotos_ordenadas_get_idpropiedad.dart](file:///D:/buscobien/lib/22_imagenes/tus_espacios_fotos_propiedad/manejo_de_fotos/lista_fotos_ordenadas/data_fotos_ordenadas_get_idpropiedad.dart)
Define la estructura del modelo CouchDB mapeado para la recuperación de esquemas de ordenamiento persistidos mediante llaves de consulta de propiedades.

| Subdirectorio | Nombre de Archivo | Tipo de Componentes | Nombre del Componente | Parámetros que requiere | Variables que utiliza | Variables internas | Estilos que le aplican |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| `.../lista_fotos_ordenadas` | `data_fotos_ordenadas_get_idpropiedad.dart` | Modelo de Datos y Helpers JSON | `ListaFotosOrdenadasGetIdPropiedad`, `RowGetIdPropiedad`, `ValueGetIdPropiedad`, `listaFotosOrdenadasGetIdPropiedadFromJson`, `listaFotosOrdenadasGetIdPropiedadToJson` | **ListaFotosOrdenadasGetIdPropiedad**: `totalRows`, `offset`, `rows`<br>**RowGetIdPropiedad**: `id`, `key`, `value`<br>**ValueGetIdPropiedad**: `id`, `rev`, `listadefotos` | `dart:convert`, `data_fotos_ordenadas.dart` | Variables JSON | N/A |

### [future_put_fotos_orden.dart](file:///D:/buscobien/lib/22_imagenes/tus_espacios_fotos_propiedad/manejo_de_fotos/lista_fotos_ordenadas/future_put_fotos_orden.dart)
Provee la lógica de red asíncrona para guardar un nuevo documento de ordenamiento en CouchDB mediante solicitudes HTTP POST firmadas mediante autenticación básica.

| Subdirectorio | Nombre de Archivo | Tipo de Componentes | Nombre del Componente | Parámetros que requiere | Variables que utiliza | Variables internas | Estilos que le aplican |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| `.../lista_fotos_ordenadas` | `future_put_fotos_orden.dart` | Petición HTTP / Future | `guardaFotosOrdenadas` | `listaFotos` (tipo `ListaFotosOrdenadas`) | `direccionip`, `username`, `password`, `generateSHA256Hash`, `Random`, `http.Client` | `baseUrl`, `basicAuth`, `headers`, `internalJson`, `jsonContent`, `returnValue`, `statusCode`, `response` | N/A |

### [future_update_fotos_orden.dart](file:///D:/buscobien/lib/22_imagenes/tus_espacios_fotos_propiedad/manejo_de_fotos/lista_fotos_ordenadas/future_update_fotos_orden.dart)
Provee la lógica de red asíncrona para actualizar un documento de ordenamiento existente en CouchDB mediante solicitudes HTTP PUT dirigidas al ID del recurso y revisiones específicas.

| Subdirectorio | Nombre de Archivo | Tipo de Componentes | Nombre del Componente | Parámetros que requiere | Variables que utiliza | Variables internas | Estilos que le aplican |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| `.../lista_fotos_ordenadas` | `future_update_fotos_orden.dart` | Petición HTTP / Future | `actualizaFotosOrdenadas` | `listaFotos` (tipo `ValueGetIdPropiedad`) | `direccionip`, `username`, `password`, `generateSHA256Hash`, `Random`, `http.Client` | `statusCode`, `baseUrl`, `basicAuth`, `headers`, `jsonContent`, `updateUrl`, `response` | N/A |

### [provider_get_lista_fotos_ordenadas.dart](file:///D:/buscobien/lib/22_imagenes/tus_espacios_fotos_propiedad/manejo_de_fotos/lista_fotos_ordenadas/provider_get_lista_fotos_ordenadas.dart)
Establece el proveedor de Riverpod que controla de manera centralizada el estado del orden de visualización de las fotos de la propiedad activa en la sesión de edición.

| Subdirectorio | Nombre de Archivo | Tipo de Componentes | Nombre del Componente | Parámetros que requiere | Variables que utiliza | Variables internas | Estilos que le aplican |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| `.../lista_fotos_ordenadas` | `provider_get_lista_fotos_ordenadas.dart` | Riverpod NotifierProvider | `getListaFotosOrdenadasProvider`, `ClassListaFotosCasaNotifierProvider` | `lista` (en `setFotoListaPosiciones`) | `getListaFotosCasaProviderId`, `ListaFotosOrdenadasGetIdPropiedad`, `RowGetIdPropiedad`, `FotosOrden` | `fotosProvider`, `ultimaFoto`, `newRows`, `activeRow`, `newFotosOrden` | N/A |

---

## 9. Subdirectorio `tus_espacios_fotos_propiedad/manejo_de_fotos/lista_ids_fotos`

### [data_fotos_get_ids_fotos_user_prop.dart](file:///D:/buscobien/lib/22_imagenes/tus_espacios_fotos_propiedad/manejo_de_fotos/lista_ids_fotos/data_fotos_get_ids_fotos_user_prop.dart)
Estructura el modelo de mapeo de CouchDB requerido para capturar el listado crudo de identificadores de fotos correspondientes a la consulta compuesta usuario-propiedad.

| Subdirectorio | Nombre de Archivo | Tipo de Componentes | Nombre del Componente | Parámetros que requiere | Variables que utiliza | Variables internas | Estilos que le aplican |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| `.../lista_ids_fotos` | `data_fotos_get_ids_fotos_user_prop.dart` | Modelo de Datos y Helpers JSON | `GetIdsFotosUserProp`, `RowIdsFotos`, `getIdsFotosUserPropFromJson`, `getIdsFotosUserPropToJson` | **GetIdsFotosUserProp**: `totalRows`, `offset`, `rows`<br>**RowIdsFotos**: `id`, `key` (llaves), `value` | `dart:convert` | Estructuras de mapas JSON | N/A |

---

## 10. Subdirectorio `tus_espacios_fotos_propiedad/manejo_de_fotos/opciones_menu_fotos`

### [pagina_fotos_menu_opciones.dart](file:///D:/buscobien/lib/22_imagenes/tus_espacios_fotos_propiedad/manejo_de_fotos/opciones_menu_fotos/pagina_fotos_menu_opciones.dart)
Estructura de navegación por pestañas (*TabBar*) para el módulo de administración de fotos del Promotor. Permite conmutar con gestos táctiles (Swipe) o pulsaciones entre tres modalidades de visualización y edición: Vista en Cuadrícula (Cuadros), Listado Reordenable (Listado) y Vista Preliminar (Carrusel).

| Subdirectorio | Nombre de Archivo | Tipo de Componentes | Nombre del Componente | Parámetros que requiere | Variables que utiliza | Variables internas | Estilos que le aplican |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| `.../opciones_menu_fotos` | `pagina_fotos_menu_opciones.dart` | ConsumerStatefulWidget | `PaginaFotosPropiedad`, `PaginaFotosPropiedadState` | `propiedad` (tipo `ValueEspaciosCasaGet`) | `appTheme`, variables de dimensiones de pantalla globales | `scaffoldKeyFotosPropiedad`, `tabControllerOpcionesFotos`, `buttonSelectOpcionFotos`, `idUsuario`, `idPropiedad`, `idFoto`, `principalbool`, `screenWidth`, `screenHeight` | **Colores**: Pestañas inactivas (`appTheme.secondary`), activa (`appTheme.onPrimary`), contenedor (`appTheme.surface`).<br>**Tipografía**: `Comfortaa` y `Outfit` con variables `fontSizeSubtituloPagina`. |

### [pagina_lista_fotos_carousel.dart](file:///D:/buscobien/lib/22_imagenes/tus_espacios_fotos_propiedad/manejo_de_fotos/opciones_menu_fotos/pagina_lista_fotos_carousel.dart)
Pestaña del visualizador de fotos en Carrusel dentro de la interfaz del Promotor. Ofrece una vista idéntica a la final del usuario, pero ajustada dentro de las pestañas de administración.

| Subdirectorio | Nombre de Archivo | Tipo de Componentes | Nombre del Componente | Parámetros que requiere | Variables que utiliza | Variables internas | Estilos que le aplican |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| `.../opciones_menu_fotos` | `pagina_lista_fotos_carousel.dart` | ConsumerStatefulWidget | `PaginaCarouselFotosWidget`, `PaginaCarouselFotosWidgetState` | `valueespaciosparameter` (tipo `ValueEspaciosCasaGet`) | `getListaFotosOrdenadasProvider`, `checaPlataformaProvider`, `appTheme`, `parameterGestionFoto` | `scaffoldKeyListaFotos`, `idUsuario`, `idPropiedad`, `nombrePropiedad`, `indiceFotos`, `numeroDeFotos`, `controllerCarousel`, `_futureCargaDatos`, `listaIdFotosOrden`, `listaIdsCrudos` | **Dimensiones**: `widthCuadroFotoPropiedad`, `heightCuadroFotoPropiedad` globales.<br>**Colores**: Fondo (`appTheme.onSecondary`), botones e iconos (`appTheme.primary` / `appTheme.error`). Fuentes `Comfortaa`. |

### [pagina_lista_fotos_cuadros.dart](file:///D:/buscobien/lib/22_imagenes/tus_espacios_fotos_propiedad/manejo_de_fotos/opciones_menu_fotos/pagina_lista_fotos_cuadros.dart)
Pestaña de administración de fotos tipo galería de cuadrícula (*GridView*). Renderiza cada foto comprimida en miniatura de forma compacta, ofreciendo accesos directos para eliminar la foto, asignarla como imagen de portada (Principal), o acceder a la página de carga de múltiples fotos.

| Subdirectorio | Nombre de Archivo | Tipo de Componentes | Nombre del Componente | Parámetros que requiere | Variables que utiliza | Variables internas | Estilos que le aplican |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| `.../opciones_menu_fotos` | `pagina_lista_fotos_cuadros.dart` | ConsumerStatefulWidget | `PropiedadesMiniFotoListaPromotor`, `PropiedadesMiniFotoListaPromotorState` | `valueespaciosparameter` (tipo `ValueEspaciosCasaGet`) | `getListaFotosOrdenadasProvider`, `checaPlataformaProvider`, `appTheme`, `parameterGestionFoto` | `scaffoldKeyMinisFotos`, `idUsuario`, `idPropiedad`, `nombrePropiedad`, `indiceFotos`, `numeroDeFotos`, `propiedad`, `botonAgregarActive`, `botonGuardarActive`, `botonReloadActive`, `numFotosAgregadas`, `listaidsfotos`, `_numeroDeImagenesIdUserPropiedad`, `_recuperaIdsFotosDePropiedades`, `_recuperaListaFotosOrden` | **Diseño**: Galería de cuadrícula responsiva.<br>**Colores**: `appTheme.primary`, `appTheme.onPrimary`, `appTheme.secondary`, `appTheme.outline`. Fuente `Outfit`. |

### [pagina_lista_fotos_listado.dart](file:///D:/buscobien/lib/22_imagenes/tus_espacios_fotos_propiedad/manejo_de_fotos/opciones_menu_fotos/pagina_lista_fotos_listado.dart)
Pestaña que implementa un listado vertical interactivo y reordenable (*ReorderableListView*). Permite al Promotor arrastrar y soltar las miniaturas de las fotos para configurar libremente el orden en que se presentarán al cliente, persistiendo dicha secuencia de manera permanente al pulsar el botón de guardar.

| Subdirectorio | Nombre de Archivo | Tipo de Componentes | Nombre del Componente | Parámetros que requiere | Variables que utiliza | Variables internas | Estilos que le aplican |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| `.../opciones_menu_fotos` | `pagina_lista_fotos_listado.dart` | ConsumerStatefulWidget y StatelessWidget local | `PropiedadesListaFotosPromotor`, `PropiedadesListaFotosPromotorState`, `_FotoItemReorderable` | **PropiedadesListaFotosPromotor**: `valueespaciosparameter` (tipo `ValueEspaciosCasaGet`) <br>**_FotoItemReorderable**: `key`, `index`, `idFoto`, `onDelete` | `getListaFotosOrdenadasProvider`, `checaPlataformaProvider`, `appTheme`, `parameterGestionFoto` | `scaffoldKeyFootosPromotor`, `idUsuario`, `idPropiedad`, `nombrePropiedad`, `numeroDeFotos`, `_listaVisualFotos`, `_futuresCombinados` | **Diseño**: Filas de listado reordenables arrastrando desde el icono derecho.<br>**Colores**: `appTheme.onPrimary` (Fondo cabecera), `appTheme.secondary` (Textos de número de fotos), `appTheme.surface` (Fondo contenedor).<br>**Fuentes**: `Outfit` con variable de escala `fontSizeSubtituloPagina`. |

---

## Resumen del Inventario de Archivos

| Ubicación / Carpeta | Cantidad de Archivos | Responsabilidad Operativa Principal |
| :--- | :---: | :--- |
| **Raíz del Módulo** | 1 | Configuración de medidas y dimensiones físicas estándar del módulo de imágenes. |
| **Subdirectorio `data_models`** | 4 | Estructuras de datos estructuradas de CouchDB y mapeo estricto JSON-to-Dart para fotos y posiciones. |
| **Subdirectorio `inicio_fotos_usuario`** | 2 | Interfaces de carrusel interactivo y sliders mini para el cliente final/usuario comprador. |
| **Subdirectorio `tus_espacios_fotos_propiedad`** | 2 | Compresión adaptativa por sistema operativo y buffers locales mutables para carga de archivos. |
| **Subdirectorio `.../datos_fotos`** | 3 | Interpretación de respuestas de peticiones HTTP CouchDB (POST returns, conteos y filtros compuestos). |
| **Subdirectorio `.../fotos_de_la_propiedad`** | 1 | Pantalla de carga, compresión en paralelo e inserción persistente masiva de fotos. |
| **Subdirectorio `.../futures_y_providers`** | 5 | Orquestador de lógica de red, obtención asíncrona de metadatos y estado reactivo Riverpod. |
| **Subdirectorio `.../lista_fotos_ordenadas`** | 5 | Clases de combinación, modelos específicos, providers y llamadas de actualización del ordenamiento. |
| **Subdirectorio `.../lista_ids_fotos`** | 1 | Modelo de datos optimizado para descarga exclusiva de identificadores de bases de datos. |
| **Subdirectorio `.../opciones_menu_fotos`** | 4 | Pantalla organizadora de pestañas de administración y las tres vistas (carrusel, cuadros y reordenable). |
| **TOTAL** | **28** | **Módulo completo integrado de visualización, compresión, carga, edición y reordenamiento de fotos.** |
