# Inventario de Componentes - Sección `geolocalizacion` (D:\buscobien\lib\14_geolocalizacion)

Este módulo implementa la integración principal con el SDK de Google Maps en Flutter para plataformas móviles y Web. Contiene la geolocalización en tiempo real del usuario (`Geolocator`), traducción de coordenadas a direcciones legibles (`Geocoding` nativo y API REST de Google), definición segura de claves de API mediante variables de compilación (`String.fromEnvironment`), y una pantalla interactiva con pines de mapas autogenerados bajo demanda en un lienzo 2D (`Canvas`).

---

## Tabla de Inventario de Componentes de Geolocalización y Mapas

| Subdirectorio | Nombre del archivo | Tipo de componentes | Nombre del componente | Parámetros que requiere | Variables que utiliza (externas/globales/Riverpod) | Variables internas / Estado | Estilos que le aplican |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| N/A | `advanced_markers` | `StatefulWidget` / `State` | `AdvancedMarkerExample`, `_AdvancedMarkerExampleState` | Ninguno | `marcadores` (globales o implícitos) | `GoogleMap` básico con marcadores de prueba | N/A |
| N/A | `app_keys.dart` | Constantes Globales de Compilación | `GOOGLE_KEY`, `GOOGLE_MAPS_KEY` | Ninguno | `String.fromEnvironment` | Claves de API leídas de manera segura en tiempo de compilación | N/A |
| N/A | `google_map_mapa_propiedades.dart` | `ConsumerStatefulWidget` / `State` | `PaginaMapaPropiedades`, `_PaginaMapaPropiedadesState` | `listaPropiedadesVar` (EspaciosCasaGet) | `menuNivelDeGobiernoProvider`, `localidadesPorCodigoPostalProvider`, `appTheme` | `_controller` (Completer), `_markers` (Set), `_isLoading` (bool), `nivelGobierno` (String), `zoomLevel` (double), `addressQuery` (String) | `appTheme.primary`, `appTheme.secondary`, `appTheme.tertiary`, `appTheme.onPrimary`, `appTheme.onPrimaryContainer` |
| N/A | `google_map_place_data.dart` | Clases de Modelo de Datos (Geocoding API) | `GooglemapPlace`, `PlusCode`, `Result`, `AddressComponent`, `Geometry`, `Viewport`, `NortheastClass`, `NavigationPoint`, `NavigationPointLocation` | Constructor clásico / Fábrica `fromJson` / Funciones globales de parseo | JSON devuelto por la API de Google Geocode | Propiedades y métodos `toJson` para mapeo seguro de respuestas HTTP | N/A |
| N/A | `google_map_place_data.json` | Archivo de Datos Estáticos (Soporte) | JSON de respuesta | N/A | N/A | Contiene una respuesta mock estructurada de la API de Geocoding | N/A |
| N/A | `provider_actual_place.dart` | Notificador de Estado (Riverpod) / Providers / Modelo | `DatosDeLaUbicacionActual`, `ClassLocalidadesNotifierProvider`, `ubicacionActualProvider`, `getUbicacionActuaFuturelProvider`, `solicitaAccesoUbicacionFutureProvider` | `markerID`, `lat`, `lon`, `titulo`, `snippetVal` para métodos | `localidadesPorCodigoPostalProvider`, `checaPlataformaProvider`, `GOOGLE_MAPS_KEY` | `state` que encapsula la ubicación activa, marcadores, controladores del mapa y estado de permisos | N/A |

---

## Análisis Técnico y Flujo de Operación

1. **Inyección Segura de Credenciales (`app_keys.dart`):**
   * El archivo de claves evita la exposición de credenciales críticas en el repositorio público utilizando variables del sistema en compilación a través de:
     `const String GOOGLE_MAPS_KEY = String.fromEnvironment('GOOGLE_MAPS_KEY');`
     Esto permite que las claves sean inyectadas de forma dinámica durante `flutter build` o `flutter run` mediante el argumento `--dart-define`.

2. **Georreferenciación Híbrida Multiplataforma (`provider_actual_place.dart`):**
   * El notifier principal `ClassLocalidadesNotifierProvider` coordina la geolocalización del usuario de manera inteligente según el sistema operativo:
     * En **Android/iOS (Dispositivos Móviles)**: Utiliza `geolocator` para obtener coordenadas GPS y la biblioteca nativa `geocoding` (`placemarkFromCoordinates`) para traducirlas a direcciones legibles.
     * En **Web / Windows (Escritorio)**: Al no tener soporte nativo de geocoding nativo en Flutter para estas plataformas, el proveedor ejecuta llamadas REST HTTP directas contra la API de Geocoding de Google Maps inyectando `GOOGLE_MAPS_KEY` de forma segura.

3. **Pines Dinámicos Renderizados en Lienzo (`google_map_mapa_propiedades.dart`):**
   * En lugar de cargar imágenes estáticas de assets, `PaginaMapaPropiedades` implementa un generador dinámico de marcadores utilizando un `ui.PictureRecorder` y un `Canvas` 2D (`_createCustomMarkerBitmap`). Esto dibuja rectángulos redondeados con sombra en tiempo real y escribe el precio de la propiedad de forma dinámica sobre el marcador. Los colores del marcador corresponden al tipo de transacción (ej. Azul Primario para "Venta", Magenta Secundario para "Renta").

4. **Sincronización Automática de Cámara y Gobierno:**
   * La cámara del mapa se ajusta automáticamente escuchando los cambios en el proveedor de nivel de gobierno (`menuNivelDeGobiernoProvider`). Al modificarse la selección, el widget dispara un geocoding en reversa del nombre legible (p. ej., "Jalisco, México" o "Guadalajara, Jalisco, México") para enfocar y reajustar el zoom del mapa con transiciones animadas de forma fluida.
