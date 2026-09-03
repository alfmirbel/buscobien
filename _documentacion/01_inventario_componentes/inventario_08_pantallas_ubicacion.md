# Inventario de Componentes - Sección `ubicacion` (D:\buscobien\lib\08_pantallas\ubicacion)

Este documento detalla el inventario de todos los archivos Dart de la sección **`ubicacion`** de Buscobien. Este módulo gestiona la búsqueda geográfica, la validación de códigos postales utilizando el sistema SEPOMEX, la visualización en Google Maps de las coordenadas físicas y la selección de localidades para la visualización personalizada de propiedades en el dashboard de inicio.

---

## Tabla de Inventario de Archivos `.dart`

| Subdirectorio | Nombre del archivo | Tipo de componentes | Nombre del componente | Parámetros que requiere | Variables que utiliza (externas/globales/Riverpod) | Variables internas / Estado | Estilos que le aplican |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| N/A | `data_localidad_find.dart` | Clases de Mapeo JSON | `FindLocalidadXcp`, `Doc` | Constructor normal / Fábricas `fromJson` | `LocalidadCp` | `docs`, `bookmark` | N/A |
| N/A | `data_sepomex_localidades.dart` | Clase de Modelo (Freezed) | `LocalidadCp` | Constructor con parámetros nombrados | Ninguno | `idEstado`, `estado`, `idMunicipio`, `municipio`, `ciudad`, `zona`, `cp`, `asentamiento`, `tipo` | N/A |
| N/A | `data_sepomex_localidades.freezed.dart` | Código Generado (Freezed) | Clase de mezcla y clases extendidas internas | Autogenerado por build_runner | Ninguno | Propiedades del modelo inmutables | N/A |
| N/A | `data_sepomex_localidades.g.dart` | Código Generado (Serialización) | Funciones de parseo JSON | Autogenerado por build_runner | Ninguno | Funciones serializadoras | N/A |
| N/A | `data_sepomex_localidades_get_cp.dart` | Clases de Mapeo CouchDB | `LocalidadesGet`, `RowLocalidadesGet`, `ValueLocalidadesGet` | Constructor normal / Fábricas `fromJson` | `LocalidadCp` | `totalRows`, `offset`, `rows`, `id`, `key`, `value` | N/A |
| N/A | `pagina_busca_localidades_gmaps.dart` | `ConsumerStatefulWidget` / `State` | `PaginaBuscaLocalidadGMaps`, `PaginaBuscaLocalidadGMapsState` | Ninguno | `codigoPostalBusquedaProvider`, `localidadesPorCodigoPostalProvider`, `ubicacionActualProvider`, `getLocalidadesDelCPFutureProvider`, `widthFicha`, `appTheme` | `_formKeyBuscaUbicacion`, `valorActualProvider`, `localidad` | `appTheme.primary`, `appTheme.onPrimary`, `Comfortaa` (Google Font) |
| N/A | `pagina_principal_localidades.dart` | `ConsumerStatefulWidget` / `State` | `PaginaPrincipalListaLocalidades`, `PaginaPrincipalListaLocalidadesState` | Ninguno | `localidadesPorCodigoPostalProvider`, `sessionProvider`, `userLocalidadesProvider`, `appTheme`, variables de tamaño de letra | `scaffoldListaLocalidadesKey`, `registroULEncontrada`, `localidadesVacia` | `appTheme.onInverseSurface`, `appTheme.primary`, `appTheme.onPrimary`, `Comfortaa` |
| N/A | `provider_localidades_del_cp.dart` | Clases de Estado y Providers (Riverpod) | `ListaDeLocalidadesDelCP`, `ClassLocalidadesNotifierProvider`, `localidadesPorCodigoPostalProvider`, `getLocalidadesDelCPFutureProvider` | Ninguno | `localidadesRepositoryProvider` | `codigoPostal`, `localidadSeleccionada`, `localidades` | N/A |
| N/A | `screen_maestro_localidades.dart` | `ConsumerStatefulWidget` / `State` | `LocalidadesListScreen`, `LocalidadesListScreenState` | `codigoP` (int) | `localidadesPorCodigoPostalProvider`, `userLocalidadesProvider`, `getLocalidadesDelCPFutureProvider`, `appTheme`, variables globales de tipografía | `celdaControllerDialog` (para AlertDialog) | `appTheme.primary`, `appTheme.onPrimary`, `appTheme.surface`, `Comfortaa` |

---

## Observaciones Arquitectónicas del Módulo de Ubicación

1. **Retención de Versiones Previas (Código Comentado):**
   * En `pagina_busca_localidades_gmaps.dart` se conserva un bloque de código considerable completamente comentado entre las líneas 349 y 621. Este bloque contiene una implementación histórica de la clase `PaginaBuscaLocalidadGMaps` previa a su última optimización con Riverpod, lo cual es útil como referencia histórica de la evolución del componente, pero no se ejecuta en producción.

2. **Integración con Servicios Nativos (Google Maps):**
   * `PaginaBuscaLocalidadGMaps` realiza una integración premium con el SDK nativo a través del widget `GoogleMap`. El estado del controlador se administra a través del `ubicacionActualProvider` (definido en el módulo `14_geolocalizacion`), lo que facilita la sincronización de marcadores y la actualización dinámica de la cámara basándose en la latitud y longitud.

3. **Inmutabilidad y Generación de Código:**
   * La clase `LocalidadCp` (definida en `data_sepomex_localidades.dart`) utiliza la anotación `@freezed` para proporcionar inmutabilidad del estado y soporte robusto para métodos esenciales como `copyWith` y `fromJson`. Esto asegura que los datos geográficos provenientes de CouchDB se procesen con absoluta seguridad tipográfica en todo el flujo de Riverpod.
