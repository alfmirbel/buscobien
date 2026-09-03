# SDD — Módulo 14_geolocalizacion (BuscoBien)
## Especificación de Requerimientos (EARS)
**Directorio fuente:** `lib/14_geolocalizacion`  
**Arquitectura:** Flutter + Riverpod + Google Maps + Geocoding  
**Dependencias clave:** `google_maps_flutter`, `geocoding`, `geolocator`, `flutter_riverpod`

---

## 1. Requerimientos Ubicuos

### 1.1 Gestión del Estado de Ubicación
- **REQ-GEO-001:** El sistema deberá mantener un estado global de la ubicación actual del usuario mediante el proveedor `ubicacionActualProvider`.
- **REQ-GEO-002:** El sistema deberá gestionar el controlador del mapa Google Maps a través de un `Completer<GoogleMapController>`.
- **REQ-GEO-003:** El sistema deberá almacenar marcadores en un `Set<Marker>` dentro del estado global.

### 1.2 Acceso a Servicios Externos
- **REQ-GEO-004:** El sistema deberá acceder a la API de Google Maps mediante la clave `GOOGLE_MAPS_KEY` definida en `app_keys.dart`.
- **REQ-GEO-005:** El sistema deberá utilizar las coordenadas de posición del dispositivo para geocodificación inversa.
- **REQ-GEO-006:** El sistema deberá soportar las plataformas Android, iOS, Web y Windows para funcionalidades de geolocalización.

### 1.3 Integración con Temas
- **REQ-GEO-007:** El sistema deberá utilizar el tema global `appTheme` para colores de marcadores, botones y UI del mapa.

---

## 2. Requerimientos Controlados por Eventos

### 2.1 Inicialización del Mapa
- **REQ-INI-001:** Cuando el mapa se crea (`onMapCreated`), el sistema deberá asignar el controlador al estado y completar el `Completer` si no estaba completado.
- **REQ-INI-002:** Cuando el widget de mapa se destruye (`dispose`), el sistema deberá liberar el controlador del mapa y reiniciar el `Completer`.

### 2.2 Gestión de Permisos
- **REQ-PER-001:** Cuando el usuario solicita determinar su ubicación, el sistema deberá verificar si los servicios de ubicación están habilitados.
- **REQ-PER-002:** Cuando los servicios están deshabilitados, el sistema deberá mostrar "La localización está deshabilitada." y retornar permiso 0.
- **REQ-PER-003:** Cuando el permiso está denegado, el sistema deberá solicitar permiso al usuario.
- **REQ-PER-004:** Cuando el usuario deniega el permiso, el sistema deberá mostrar "Permiso de localización denegado." y retornar permiso 0.
- **REQ-PER-005:** Cuando el permiso es denegado permanentemente, el sistema deberá mostrar "Localización negada permanentemente." y retornar permiso 0.
- **REQ-PER-006:** Cuando el permiso es concedido, el sistema deberá obtener la posición actual y actualizar latitud/longitud en el estado.

### 2.3 Determinación de Ubicación
- **REQ-DET-001:** Cuando el sistema determina la ubicación en Android o iOS, el sistema deberá utilizar geocodificación nativa (`placemarkFromCoordinates`).
- **REQ-DET-002:** Cuando el sistema determina la ubicación en Web o Windows, el sistema deberá utilizar la API HTTP de Geocoding de Google Maps.
- **REQ-DET-003:** Cuando la geocodificación nativa retorna resultados, el sistema deberá extraer el código postal y actualizar el provider de localidades.
- **REQ-DET-004:** Cuando la API HTTP retorna status "OK", el sistema deberá extraer la dirección formateada y el código postal de los componentes.
- **REQ-DET-005:** Cuando la dirección ya está cacheada en estado Web/Windows, el sistema deberá retornar la cache sin consultar la API.

### 2.4 Agregado de Marcadores
- **REQ-MAR-001:** Cuando el usuario agrega un marcador, el sistema deberá limpiar el conjunto existente de marcadores.
- **REQ-MAR-002:** Cuando se crea un marcador, el sistema deberá posicionarlo en las coordenadas especificadas con título y snippet.
- **REQ-MAR-003:** Cuando se agrega un marcador de ubicación actual, el sistema deberá usar título "Mi Ubicación" y snippet con la dirección.

### 2.5 Ajuste de Cámara
- **REQ-CAM-001:** Cuando el nivel de gobierno es "Nacional", el sistema deberá buscar "México" con zoom 5.0.
- **REQ-CAM-002:** Cuando el nivel de gobierno es "Estado", el sistema deberá buscar "[estado], México." con zoom 8.0.
- **REQ-CAM-003:** Cuando el nivel de gobierno es "Municipio", el sistema deberá buscar "[municipio], [estado], México." con zoom 11.0.
- **REQ-CAM-004:** Cuando el nivel de gobierno es "C.P.", el sistema deberá buscar "[cp], [municipio], [estado], México." con zoom 14.0.
- **REQ-CAM-005:** Cuando el nivel de gobierno es "Asentamiento", el sistema deberá buscar "[asentamiento], [cp], [municipio], [estado], México." con zoom 16.0.
- **REQ-CAM-006:** Cuando el usuario presiona el botón "Reajustar", el sistema deberá volver a ejecutar el ajuste de cámara por nombre de nivel de gobierno.

### 2.6 Actualización Dinámica
- **REQ-DIN-001:** Cuando el nivel de gobierno cambia en el provider, el sistema deberá actualizar la variable local y reejecutar el ajuste de cámara.

---

## 3. Requerimientos Controlados por Estados

### 3.1 Estado: Cargando Marcadores
- **REQ-CAR-MAP-001:** Mientras el sistema carga los marcadores de propiedades, el sistema deberá mostrar un indicador de progreso circular con opacidad de fondo del 30% en negro.
- **REQ-CAR-MAP-002:** Mientras el sistema carga los marcadores, el sistema deberá mantener el color del progreso como el color primario del tema.

### 3.2 Estado: Sin Propiedades
- **REQ-SIN-PROP-001:** Mientras la lista de propiedades esté vacía, el sistema deberá mostrar el mensaje "No hay propiedades que mostrar."
- **REQ-SIN-PROP-002:** Mientras no haya propiedades, el sistema deberá mostrar un espacio de 10px debajo del mensaje.

### 3.3 Estado: Con Propiedades
- **REQ-CON-PROP-001:** Mientras existan propiedades, el sistema deberá renderizar marcadores personalizados con el precio de cada propiedad.
- **REQ-CON-PROP-002:** Mientras existan propiedades, el sistema deberá mostrar la ventana de información al seleccionar un marcador.

### 3.4 Estado: Plataforma Web
- **REQ-WEB-001:** Mientras la plataforma es Web, el sistema deberá ajustar la cámara por bounds en lugar de por geocodificación.
- **REQ-WEB-002:** Mientras la plataforma es Web, el sistema deberá utilizar la API HTTP de geocoding para determinar la ubicación.

### 3.5 Estado: Plataforma Windows
- **REQ-WIN-001:** Mientras la plataforma es Windows, el sistema deberá utilizar la API HTTP de geocoding para determinar la ubicación.
- **REQ-WIN-002:** Mientras la plataforma es Windows, el sistema deberá ajustar la cámara por bounds.

---

## 4. Requerimientos de Comportamiento No Deseado

### 4.1 Errores de Red y API
- **REQ-FAL-001:** Si la API HTTP de geocoding retorna status diferente de 200 o body vacío, entonces el sistema deberá registrar el código de estado y retornar vacío.
- **REQ-FAL-002:** Si ocurre una excepción en la consulta HTTP, entonces el sistema deberá capturar la excepción, registrarla en depuración y retornar cadena vacía.
- **REQ-FAL-003:** Si la API de Google Maps retorna status diferente de "OK", entonces el sistema deberá no procesar el resultado y retornar.

### 4.2 Errores de Geocodificación
- **REQ-FAL-004:** Si `placemarkFromCoordinates` lanza una excepción, entonces el sistema deberá capturar el error y registrarlo en depuración.
- **REQ-FAL-005:** Si `locationFromAddress` no encuentra coordenadas para la consulta, entonces el sistema deberá mostrar mensaje de depuración y no ajustar la cámara.
- **REQ-FAL-006:** Si la geocodificación por colonia falla y el nivel es "Asentamiento" o "Colonia", entonces el sistema deberá intentar fallback a nivel Municipio.

### 4.3 Errores de Datos
- **REQ-FAL-007:** Si las coordenadas de una propiedad son inválidas (`null` o conversión fallida), entonces el sistema deberá omitir esa propiedad sin renderizar su marcador.
- **REQ-FAL-008:** Si el nivel de gobierno no coincide con ningún caso, entonces el sistema deberá establecer "Sin ubicación" como consulta de dirección.

---

## 5. Requerimientos de Funciones Opcionales

### 5.1 Catálogo SEPOMEX / Código Postal
- **REQ-OPT-001:** Donde el usuario ingrese un código postal, el sistema deberá permitir buscar localidades asociadas.
- **REQ-OPT-002:** Donde existan localidades para el código postal, el sistema deberá navegar a la lista de localidades.

### 5.2 Sincronización con Localidades
- **REQ-OPT-003:** Donde se determine el código postal desde geocodificación, el sistema deberá sincronizar el provider de localidades por código postal.
- **REQ-OPT-004:** Donde el usuario busque por código postal, el sistema deberá actualizar el estado del provider con el nuevo CP.

---

## 6. Requerimientos Complejos

### 6.1 Flujo Completo de Geocodificación y Marcadores
- **REQ-COM-001:** Mientras el usuario solicita su ubicación, cuando el sistema obtiene la posición, entonces deberá realizar geocodificación inversa, extraer el CP, actualizar el provider, agregar marcador "Mi Ubicación" y ajustar cámara con zoom 12.

### 6.2 Flujo de Búsqueda por CP y Navegación
- **REQ-COM-002:** Mientras el usuario busca por código postal, cuando el sistema valida y guarda el CP, entonces deberá actualizar el provider, refrescar localidades del CP y navegar a la lista de localidades.

### 6.3 Flujo de Mapa de Propiedades con Niveles de Gobierno
- **REQ-COM-003:** Mientras el usuario abre el mapa de propiedades, cuando el sistema carga los marcadores, entonces deberá generar marcadores personalizados con precio y color por tipo de transacción, ajustar cámara por nivel de gobierno, mostrar indicador de carga y ocultarlo al finalizar.

### 6.4 Flujo de Ajuste de Cámara por Geocoding con Fallback
- **REQ-COM-004:** Mientras el usuario está en el mapa de propiedades, cuando el nivel es Asentamiento, entonces deberá buscar por colonia; si no encuentra, deberá hacer fallback a municipio y ajustar cámara con zoom 12.

### 6.5 Flujo de Ciclo de Vida del Mapa
- **REQ-COM-005:** Mientras el usuario navega a la pantalla de búsqueda, cuando el mapa se crea, entonces deberá registrar el controlador; al navegar fuera, deberá liberar el controlador y reiniciar el Completer.

---

## 7. Modelos de Datos

### 7.1 GooglemapPlace (API Geocoding)
| Campo | Tipo | Descripción |
|-------|------|-------------|
| `plusCode` | PlusCode | Código Plus de ubicación |
| `results` | List<Result> | Lista de resultados de geocodificación |
| `status` | String | Estado de la respuesta (OK, ZERO_RESULTS, etc.) |

### 7.2 PlusCode
| Campo | Tipo | Descripción |
|-------|------|-------------|
| `compoundCode` | String | Código compuesto |
| `globalCode` | String | Código global |

### 7.3 Result
| Campo | Tipo | Descripción |
|-------|------|-------------|
| `addressComponents` | List<AddressComponent> | Componentes de dirección |
| `formattedAddress` | String | Dirección formateada |
| `geometry` | Geometry | Geometría de la ubicación |
| `navigationPoints` | List<NavigationPoint> | Puntos de navegación (opcional) |
| `placeId` | String | ID del lugar |
| `types` | List<String> | Tipos de lugar |
| `plusCode` | PlusCode? | Código Plus (opcional) |

### 7.4 AddressComponent
| Campo | Tipo | Descripción |
|-------|------|-------------|
| `longName` | String | Nombre largo del componente |
| `shortName` | String | Nombre corto del componente |
| `types` | List<String> | Tipos del componente |

### 7.5 Geometry
| Campo | Tipo | Descripción |
|-------|------|-------------|
| `location` | NortheastClass | Coordenadas de ubicación |
| `locationType` | String | Tipo de ubicación |
| `viewport` | Viewport | Viewport recomendado |
| `bounds` | Viewport? | Límites del lugar (opcional) |

### 7.6 DatosDeLaUbicacionActual (Estado Riverpod)
| Campo | Tipo | Descripción |
|-------|------|-------------|
| `marcadores` | Set<Marker> | Conjunto de marcadores del mapa |
| `postalCode` | String | Código postal detectado |
| `addressGM` | String | Dirección desde Google Maps |
| `permisodelocalizacion` | int | Estado del permiso (0=no, 1=si) |
| `estadoDeLaConeccion` | String | Estado de conexión |
| `resultadoPermisoUbicacion` | String | Mensaje de resultado del permiso |
| `latitud` | double | Latitud actual |
| `longitud` | double | Longitud actual |
| `currentAddress` | String | Dirección actual formateada |
| `placemarksList` | List<Placemark> | Lista de resultados de geocodificación nativa |
| `actualAddress` | String | Dirección actual nativa |
| `setState` | bool | Flag para forzar rebuild |
| `userLocation` | GooglemapPlace | Resultado de API HTTP geocoding |
| `posicionCamara` | CameraPosition | Posición actual de la cámara |
| `actualPosition` | Position | Posición GPS actual |
| `place` | Placemark | Placemark actual |
| `mapController` | GoogleMapController? | Controlador del mapa |
| `controller` | Completer<GoogleMapController> | Completer del controlador |

---

## 8. Proveedores Riverpod

| Proveedor | Tipo | Descripción |
|-----------|------|-------------|
| `ubicacionActualProvider` | NotifierProvider | Estado global de ubicación actual |
| `getUbicacionActuaFuturelProvider` | FutureProvider | Future para determinar ubicación actual |
| `solicitaAccesoUbicacionFutureProvider` | FutureProvider | Future para solicitar acceso a ubicación |
| `localidadesPorCodigoPostalProvider` | NotifierProvider | Estado de localidades por código postal (ubicación/provider_localidades_del_cp.dart) |
| `getLocalidadesDelCPFutureProvider` | FutureProvider | Future para cargar localidades por CP (ubicación/provider_localidades_del_cp.dart) |

---

## 9. Pantallas

### 9.1 PaginaBuscaLocalidadGMaps (`lib/08_pantallas/ubicacion/pagina_busca_localidades_gmaps.dart`)
- Ruta: `/buscalocalidad`
- Funcionalidad: Búsqueda de ubicación por código postal
- Componentes: Form con TextFormField de CP, botón "Busca ubicaciones", mapa en miniatura con ubicación actual
- Validación: Campo CP obligatorio, máximo 5 caracteres

### 9.2 PaginaMapaPropiedades (`lib/14_geolocalizacion/google_map_mapa_propiedades.dart`)
- Ruta: No definida en este archivo, consumida desde rutas
- Funcionalidad: Visualización de propiedades en mapa con marcadores personalizados
- Niveles de gobierno: Nacional, Estado, Municipio, C.P., Asentamiento
- Marcadores personalizados: Canvas con precio, color por tipo de transacción

---

## 10. Reglas de Negocio

- **RN-001:** El código postal debe tener máximo 5 caracteres.
- **RN-002:** El color del marcador depende del tipo de transacción: Venta = primary, Renta = secondary, Otro = tertiary.
- **RN-003:** El zoom del mapa depende del nivel de gobierno: Nacional=5, Estado=8, Municipio=11, C.P.=14, Asentamiento=16.
- **RN-004:** Al cambiar el nivel de gobierno, se recalcula la consulta de geocodificación y se ajusta la cámara.
- **RN-005:** En Web, el ajuste de cámara se realiza por bounds calculados de los marcadores.
- **RN-006:** Si no se encuentra geocodificación para colonia, se hace fallback a municipio.
- **RN-007:** La dirección cacheada en Web/Windows se reutiliza para evitar consultas HTTP repetidas.
- **RN-008:** El controlador del mapa se libera al cerrar la pantalla para evitar fugas de memoria.

---

## 11. Endpoints Externos

| Servicio | Método | Endpoint |
|----------|--------|----------|
| Google Maps Geocoding API | GET | `https://maps.googleapis.com/maps/api/geocode/json?latlng=[lat],[lng]&key=[GOOGLE_MAPS_KEY]` |

---

## 12. Estructura de Archivos

```
lib/14_geolocalizacion/
├── app_keys.dart                               # Claves de API (GOOGLE_MAPS_KEY)
├── provider_actual_place.dart                  # Provider principal de ubicación actual
├── google_map_place_data.dart                  # Modelos JSON para API Geocoding
├── google_map_place_data.json                  # Datos de ejemplo JSON
├── google_map_mapa_propiedades.dart            # Página de mapa de propiedades
└── advanced_markers/                           # (directorio presente, sin archivos .dart)

Dependencias externas utilizadas:
lib/08_pantallas/ubicacion/provider_localidades_del_cp.dart
lib/08_pantallas/ubicacion/data_sepomex_localidades.dart
lib/08_pantallas/ubicacion/data_sepomex_localidades_get_cp.dart
lib/12_localidades_user/localidades_repository.dart
```

---

## 13. Consideraciones de Plataforma

| Plataforma | Geocodificación | Ajuste de Cámara |
|------------|-----------------|------------------|
| Android | Nativa (`placemarkFromCoordinates`) | Por nombre |
| iOS | Nativa (`placemarkFromCoordinates`) | Por nombre |
| Web | HTTP (`getPlaceFromCoordinates`) | Por bounds |
| Windows | HTTP (`getPlaceFromCoordinates`) | Por bounds |
| Linux/macOS/Fuchsia | No soportada | No soportada |

---

## 14. Dependencias Técnicas

- **Geolocalización:** `geolocator` para obtener posición GPS, `geocoding` para geocodificación nativa
- **Mapas:** `google_maps_flutter` para renderizado de mapas
- **Estado:** `flutter_riverpod` con `NotifierProvider` y `FutureProvider`
- **HTTP:** `package:http` para consultas a API de Google Maps en Web/Windows
- **Modelos:** Clases Dart manuales con `fromJson`/`toJson` (sin code generation en este módulo)
