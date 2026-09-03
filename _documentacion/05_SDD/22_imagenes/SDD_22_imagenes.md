# SDD — Módulo 22_imagenes (BuscoBien)
## Especificación de Requerimientos (EARS)
**Directorio fuente:** `lib/22_imagenes`  
**Arquitectura:** Flutter + Riverpod + CouchDB + Google Maps  
**Propósito:** Gestión de fotos de propiedades, incluyendo carga, compresión, almacenamiento, ordenamiento y visualización en múltiples formatos (carrusel, lista, cuadrícula)

---

## 1. Requerimientos Ubicuos

### 1.1 Gestión de Fotos de Propiedades
- **REQ-FOT-001:** El sistema deberá permitir gestionar fotos asociadas a propiedades inmobiliarias de usuarios.
- **REQ-FOT-002:** El sistema deberá almacenar las fotos en la base de datos CouchDB `buscobien_propiedades_casas_fotos`.
- **REQ-FOT-003:** El sistema deberá soportar compresión de imágenes en todas las plataformas (Android, iOS, Web, Windows).
- **REQ-FOT-004:** El sistema deberá autenticar todas las operaciones de fotos mediante encabezado `Authorization: Basic`.

### 1.2 Dimensiones de Visualización
- **REQ-FOT-005:** El sistema deberá usar dimensiones de 300x200 píxeles para el carrusel completo de fotos (`widthCuadroFotoPropiedad = 300`, `heightCuadroFotoPropiedad = 200`).
- **REQ-FOT-006:** El sistema deberá usar dimensiones de 200x125 píxeles para el carrusel mini de fotos (`widthCuadroFotoPropiedadLocal = 200`, `heightCuadroFotoPropiedadLocal = 125`).
- **REQ-FOT-007:** El sistema deberá usar dimensiones de 150x100 píxeles para los thumbnails en modo cuadrícula.
- **REQ-FOT-008:** El sistema deberá usar dimensiones de 80x50 píxeles para los thumbnails en modo listado.

### 1.3 Límites de Compresión
- **REQ-FOT-009:** El sistema deberá aplicar calidad 80% en compresión de imágenes para Android/iOS.
- **REQ-FOT-010:** El sistema deberá aplicar calidad 80% en compresión de imágenes para Windows.
- **REQ-FOT-011:** El sistema deberá redimensionar imágenes a ancho máximo 800 píxeles en Windows manteniendo la proporción.
- **REQ-FOT-012:** El sistema deberá redimensionar imágenes a ancho mínimo 620 píxeles y alto mínimo 480 píxeles para formato WebP en móviles.
- **REQ-FOT-013:** El sistema deberá redimensionar imágenes a ancho mínimo 1080 píxeles y alto mínimo 1080 píxeles para conversión a WebP.
- **REQ-FOT-014:** El sistema deberá limitar el número máximo de fotos a 10 por defecto (`numerodefichas = 10`).

---

## 2. Requerimientos Controlados por Eventos

### 2.1 Carga de Fotos
- **REQ-CAR-001:** Cuando el usuario abre la pantalla de carrusel de fotos, el sistema deberá recuperar los IDs de fotos de la propiedad.
- **REQ-CAR-002:** Cuando el sistema recupera los IDs, el sistema deberá consultar el orden guardado de fotos para esa propiedad.
- **REQ-CAR-003:** Cuando existe un orden guardado y coincide en cantidad con los IDs, el sistema deberá usar ese orden para mostrar las fotos.
- **REQ-CAR-004:** Cuando no existe orden guardado o las cantidades no coinciden, el sistema deberá generar un orden secuencial basado en los IDs.

### 2.2 Visualización en Carrusel
- **REQ-CAR-005:** Cuando el usuario desliza el carrusel, el sistema deberá actualizar el índice activo y el contador "X/Y".
- **REQ-CAR-006:** Cuando el usuario presiona "Anterior" en la primera foto, el sistema deberá deshabilitar el botón.
- **REQ-CAR-007:** Cuando el usuario presiona "Siguiente" en la última foto, el sistema deberá deshabilitar el botón.
- **REQ-CAR-008:** Cuando el usuario toca una foto en el carrusel, el sistema deberá navegar a la ruta `fotospropiedad`.

### 2.3 Menú de Opciones
- **REQ-OPC-001:** Cuando el usuario presiona el menú de opciones en el carrusel, el sistema deberá mostrar opciones: Ficha, Fotos, Guardar, Con Grupo, Con Conocido.
- **REQ-OPC-002:** Cuando el usuario selecciona "Ficha", el sistema deberá navegar a `PaginaDetalleWidget`.
- **REQ-OPC-003:** Cuando el usuario selecciona "Fotos", el sistema deberá navegar a la ruta `fotospropiedad`.
- **REQ-OPC-004:** Cuando el usuario selecciona "Guardar", el sistema deberá abrir `DialogSelectorListas` para agregar la propiedad a una lista.
- **REQ-OPC-005:** Cuando el usuario selecciona "Con Grupo", el sistema deberá abrir `PageCompartirConGrupo`.
- **REQ-OPC-006:** Cuando el usuario selecciona "Con Conocido", el sistema deberá abrir `PageCompartirConConocido`.

### 2.4 Gestión de Fotos (CRUD)
- **REQ-GES-001:** Cuando el usuario presiona "Agregar", el sistema deberá navegar a la ruta `fotosagregafotoalista` para capturar/selectar una foto.
- **REQ-GES-002:** Cuando el usuario confirma la eliminación de una foto, el sistema deberá eliminar el documento de CouchDB y actualizar el orden.
- **REQ-GES-003:** Cuando el usuario presiona "Guardar" en modo listado, el sistema deberá persistir el orden de fotos en CouchDB.
- **REQ-GES-004:** Cuando el usuario presiona "Refrescar", el sistema deberá recargar los datos de fotos y orden desde CouchDB.
- **REQ-GES-005:** Cuando el usuario reordena fotos en la lista, el sistema deberá actualizar las posiciones internas y reflejar el cambio en la UI.

### 2.5 Compresión de Imágenes
- **REQ-COM-001:** Cuando el usuario selecciona una imagen en Android/iOS, el sistema deberá comprimir usando `FlutterImageCompress.compressWithFile`.
- **REQ-COM-002:** Cuando el usuario selecciona una imagen en Windows, el sistema deberá comprimir usando `fotoCompressListWin` con Dart puro.
- **REQ-COM-003:** Cuando el usuario sube una imagen en Web, el sistema deberá comprimir usando `compressImageWeb`.
- **REQ-COM-004:** Cuando el sistema necesita formato WebP en Windows, el sistema deberá usar `fotoCompressListWebP` como fallback.
- **REQ-COM-005:** Cuando el sistema convierte a WebP en móviles, el sistema deberá usar `FlutterImageCompress.compressWithList` con `CompressFormat.webp`.

### 2.6 Tabs de Gestión de Fotos
- **REQ-TAB-001:** Cuando el usuario abre la gestión de fotos, el sistema deberá mostrar 3 pestañas: Cargar, Ordenar, Mostrar.
- **REQ-TAB-002:** Cuando el usuario cambia de pestaña, el sistema deberá actualizar el estilo visual (colores activo/inactivo).
- **REQ-TAB-003:** Cuando el usuario desliza entre pestañas, el sistema deberá detectar el cambio y actualizar el estilo automáticamente.

---

## 3. Requerimientos Controlados por Estados

### 3.1 Estado: Cargando Fotos
- **REQ-CAR-EST-001:** Mientras el sistema carga los IDs de fotos, el sistema deberá mostrar un indicador de progreso circular con el tamaño del contenedor (300x200 o 200x125).
- **REQ-CAR-EST-002:** Mientras el sistema carga una foto individual en el carrusel, el sistema deberá mostrar el mismo indicador de progreso.

### 3.2 Estado: Sin Fotos
- **REQ-SIN-FOT-001:** Mientras la propiedad no tiene fotos, el sistema deberá mostrar un contenedor con borde `appTheme.outline` y radio 12.
- **REQ-SIN-FOT-002:** Mientras no hay fotos, el sistema deberá mostrar el texto "No se encontró foto" centrado en color `appTheme.onPrimary`.
- **REQ-SIN-FOT-003:** Mientras no hay fotos, el sistema deberá mostrar un botón con icono `fullscreen` y tooltip "Datos de la propiedad".

### 3.3 Estado: Con Fotos
- **REQ-CON-FOT-001:** Mientras existen fotos, el sistema deberá renderizar el carrusel o lista según la vista seleccionada.
- **REQ-CON-FOT-002:** Mientras existen fotos, el sistema deberá mostrar el contador "X/Y" en la barra de navegación del carrusel.
- **REQ-CON-FOT-003:** Mientras existen fotos, el sistema deberá mostrar los botones de navegación (Anterior/Siguiente) con estado habilitado/deshabilitado según la posición.

### 3.4 Estado: Modo Listado
- **REQ-LIS-001:** Mientras el usuario está en modo listado, el sistema deberá mostrar una `ReorderableListView` con las fotos.
- **REQ-LIS-002:** Mientras el usuario está en modo listado, el sistema deberá mostrar la barra inferior con botones Agregar, Guardar y Refrescar.

### 3.5 Estado: Modo Cuadrícula
- **REQ-CUA-001:** Mientras el usuario está en modo cuadrícula, el sistema deberá mostrar un `Wrap` con thumbnails de 150x100 píxeles.
- **REQ-CUA-002:** Mientras el usuario está en modo cuadrícula, el sistema deberá mostrar la barra inferior con botones Agregar y Refrescar.

### 3.6 Estado: Pestaña Activa
- **REQ-PES-001:** Mientras la pestaña está activa, el sistema deberá mostrar fondo `appTheme.onPrimary`, icono y texto en `appTheme.primary`.
- **REQ-PES-002:** Mientras la pestaña está inactiva, el sistema deberá mostrar fondo `appTheme.primary`, icono y texto en `appTheme.onPrimary`.

---

## 4. Requerimientos de Comportamiento No Deseado

### 4.1 Errores de Red
- **REQ-FAL-001:** Si el servidor CouchDB no responde, entonces el sistema deberá capturar la excepción de socket y retornar código 503.
- **REQ-FAL-002:** Si ocurre una excepción no controlada en la petición HTTP, entonces el sistema deberá capturarla y retornar código 500.
- **REQ-FAL-003:** Si la petición HTTP excede el timeout de 10 segundos, entonces el sistema deberá cancelar la petición y retornar código 500 o 503.

### 4.2 Errores de Datos
- **REQ-FAL-004:** Si el ID de foto está vacío, entonces el sistema deberá retornar código 400 sin realizar la petición HTTP.
- **REQ-FAL-005:** Si la respuesta HTTP retorna lista vacía, entonces el sistema deberá retornar cadena vacía o valor 0 según el contexto.
- **REQ-FAL-006:** Si la foto no tiene contenido base64, entonces el sistema deberá mostrar el placeholder "No se encontró foto".

### 4.3 Errores de Compresión
- **REQ-FAL-007:** Si la imagen no se puede decodificar en Web, entonces el sistema deberá retornar la imagen original sin comprimir.
- **REQ-FAL-008:** Si la imagen no se puede decodificar en Windows, entonces el sistema deberá lanzar una excepción "No se pudo decodificar la imagen."
- **REQ-FAL-009:** Si el archivo no existe en Windows, entonces el sistema deberá lanzar una excepción "El archivo no existe: [ruta]".

### 4.4 Errores de Eliminación
- **REQ-FAL-010:** Si el índice de foto está fuera de rango al intentar eliminar, entonces el sistema deberá mostrar un mensaje de error y no realizar la eliminación.
- **REQ-FAL-011:** Si la eliminación falla con código diferente de 200, 202 o 404, entonces el sistema deberá mostrar el mensaje de error de CouchDB correspondiente.

---

## 5. Requerimientos de Funciones Opcionales

### 5.1 Formato WebP
- **REQ-OPT-001:** Donde el sistema necesite comprimir a WebP en Android/iOS/Web, el sistema deberá usar `FlutterImageCompress.compressWithList` con `CompressFormat.webp`.
- **REQ-OPT-002:** Donde el sistema necesite comprimir a WebP en Windows, el sistema deberá usar `fotoCompressListWebP` con fallback a JPEG.

### 5.2 Orden de Fotos
- **REQ-OPT-003:** Donde el usuario reordene las fotos, el sistema deberá persistir el orden en un documento separado de CouchDB.
- **REQ-OPT-004:** Donde exista un orden guardado, el sistema deberá validar que la cantidad de fotos coincida antes de usarlo.

### 5.3 Compresión Multiplataforma
- **REQ-OPT-005:** Donde la plataforma sea Windows, el sistema deberá usar lógica Dart pura para compresión.
- **REQ-OPT-006:** Donde la plataforma sea Web, el sistema deberá usar `compressImageWeb` con el paquete `image`.

---

## 6. Requerimientos Complejos

### 6.1 Flujo de Carga de Fotos con Orden
- **REQ-COM-001:** Mientras el usuario abre la gestión de fotos, cuando el sistema carga los IDs y el orden guardado, entonces deberá validar coincidencia de cantidades, usar el orden guardado si coincide, o generar uno nuevo si no, y renderizar la vista correspondiente.

### 6.2 Flujo de Eliminación con Actualización de Estado
- **REQ-COM-002:** Mientras el usuario elimina una foto, cuando el sistema confirma la eliminación en CouchDB, entonces deberá remover la foto de la lista general, removerla de la lista de orden, actualizar el documento de orden en CouchDB, y recargar la UI.

### 6.3 Flujo de Compresión por Plataforma
- **REQ-COM-003:** Mientras el usuario selecciona una imagen, cuando el sistema detecta la plataforma, entonces deberá aplicar la estrategia de compresión correspondiente: nativo en móviles, Dart puro en Windows, Dart puro en Web.

### 6.4 Flujo de Navegación entre Tabs
- **REQ-COM-004:** Mientras el usuario está en la gestión de fotos, cuando cambia de pestaña o desliza, entonces deberá actualizar el TabController, cambiar el estilo visual de las pestañas, y mostrar la vista correspondiente (Cargar/Ordenar/Mostrar).

### 6.5 Flujo de Guardado de Orden
- **REQ-COM-005:** Mientras el usuario guarda el orden de fotos, cuando el sistema detecta que existe un orden previo, entonces deberá actualizar el documento existente; si no existe, deberá crear uno nuevo con el usuario, propiedad, lista de posiciones y timestamp.

---

## 7. Modelos de Datos

### 7.1 FotosCasaClass
| Campo | Tipo | Descripción |
|-------|------|-------------|
| `idFoto` | String | Hash SHA256 único de la foto |
| `idUsuario` | String | ID del usuario propietario |
| `idPropiedad` | String | ID de la propiedad |
| `filaname` | String | Nombre original del archivo |
| `path` | String | Ruta del archivo |
| `size` | int | Tamaño en bytes |
| `identifier` | dynamic | Identificador del archivo |
| `foto` | String | Contenido de la imagen en base64 |
| `contentType` | String | Tipo MIME (ej. image/jpg) |
| `timestamp` | String | Marca de tiempo de creación |

### 7.2 ListaFotosOrdenadas
| Campo | Tipo | Descripción |
|-------|------|-------------|
| `idListaFotos` | String | ID del documento de orden |
| `idUsuario` | String | ID del usuario |
| `idPropiedad` | String | ID de la propiedad |
| `fotosOrden` | List<FotosOrden> | Lista de fotos ordenadas |
| `timestamp` | String | Marca de tiempo |

### 7.3 FotosOrden
| Campo | Tipo | Descripción |
|-------|------|-------------|
| `posicion` | int | Posición en el orden |
| `idFoto` | String | ID de la foto |

### 7.4 CuentaFotos
| Campo | Tipo | Descripción |
|-------|------|-------------|
| `rows` | List<RowCuentaFotos> | Lista de resultados |
| `totalRows` | int | Total de filas |
| `offset` | int | Offset |

### 7.5 RowCuentaFotos
| Campo | Tipo | Descripción |
|-------|------|-------------|
| `key` | String | Clave (array [idUsuario, idPropiedad]) |
| `value` | int | Cantidad de fotos |

### 7.6 PlatformFileNoFinal
| Campo | Tipo | Descripción |
|-------|------|-------------|
| `path` | String | Ruta del archivo |
| `name` | String | Nombre del archivo |
| `size` | int | Tamaño en bytes |
| `bytes` | Uint8List? | Contenido binario |
| `readStream` | Stream<List<int>>? | Stream de lectura |
| `identifier` | String? | Identificador |

### 7.7 ResultadoGuardaFoto
| Campo | Tipo | Descripción |
|-------|------|-------------|
| `statusCode` | int | Código HTTP de respuesta |
| `idFoto` | String | ID generado de la foto |

---

## 8. Pantallas y Vistas

### 8.1 PaginaCarouselFotosUsuario (`lib/22_imagenes/inicio_fotos_usuario/pagina_carousel_fotos_usuario.dart`)
- **Dimensiones:** 300x200 píxeles
- **Funcionalidad:** Carrusel completo de fotos con navegación por botones y swipe
- **Controles:** Anterior/Siguiente, contador X/Y, menú de opciones (3 puntos)
- **Estados:** Carga, error, vacío, con fotos
- **Navegación:** A `fotospropiedad` al tocar foto, a `PaginaDetalleWidget` desde menú

### 8.2 PaginaCarouselFotosMini (`lib/22_imagenes/inicio_fotos_usuario/pagina_carousel_fotos_usuario_mini.dart`)
- **Dimensiones:** 200x125 píxeles
- **Funcionalidad:** Carrusel mini para vistas compactas
- **Controles:** Igual que carrusel completo pero sin menú de opciones avanzadas

### 8.3 PropiedadesListaFotosPromotor (`lib/22_imagenes/tus_espacios_fotos_propiedad/manejo_de_fotos/opciones_menu_fotos/pagina_lista_fotos_listado.dart`)
- **Funcionalidad:** Lista reordenable de fotos con drag & drop
- **Controles:** Botones Agregar, Guardar, Refrescar en barra inferior
- **Condicional:** Barra inferior completa solo en sección "Mi cuenta"

### 8.4 PropiedadesMiniFotoListaPromotor (`lib/22_imagenes/tus_espacios_fotos_propiedad/manejo_de_fotos/opciones_menu_fotos/pagina_lista_fotos_cuadros.dart`)
- **Funcionalidad:** Cuadrícula de thumbnails de fotos
- **Dimensiones thumbnail:** 150x100 píxeles
- **Controles:** Botones Agregar, Refrescar (sin Guardar)

### 8.5 PaginaFotosPropiedad (`lib/22_imagenes/tus_espacios_fotos_propiedad/manejo_de_fotos/opciones_menu_fotos/pagina_fotos_menu_opciones.dart`)
- **Funcionalidad:** Pantalla principal con TabBar de 3 pestañas
- **Pestañas:** Cargar (cuadrícula), Ordenar (lista), Mostrar (carrusel)
- **Estilo:** Tabs con estilo inverso (activo: fondo onPrimary, inactivo: fondo primary)

---

## 9. Reglas de Negocio

- **RN-001:** El ID de foto se genera mediante hash SHA256 de: idUsuario + nombreArchivo + timestamp + random(999).
- **RN-002:** El primer foto agregada a una propiedad se marca automáticamente como foto principal.
- **RN-003:** El orden de fotos se guarda en un documento separado de las fotos mismas.
- **RN-004:** Si el orden guardado tiene diferente cantidad de fotos que los IDs actuales, se descarta el orden guardado y se genera uno nuevo.
- **RN-005:** Al eliminar una foto, se debe actualizar tanto la lista general como la lista de orden.
- **RN-006:** La compresión en Windows usa Dart puro porque `flutter_image_compress` no soporta nativamente Windows.
- **RN-007:** El timeout de peticiones HTTP es de 10 segundos para operaciones normales y 30 segundos para subida de fotos.
- **RN-008:** La autenticación se realiza mediante Basic Auth con `username:password` en base64.
- **RN-009:** El formato de content_type para fotos es "image/jpg".
- **RN-010:** El estado de sesión se valida antes de permitir guardar en listas o compartir.

---

## 10. Endpoints CouchDB

| Operación | Método | Endpoint |
|-----------|--------|----------|
| Guardar foto | POST | `buscobien_propiedades_casas_fotos` |
| Eliminar foto | DELETE | `buscobien_propiedades_casas_fotos/{id}?rev={rev}` |
| Recuperar foto por ID | GET | `buscobien_propiedades_casas_fotos/_design/DDFOTO/_view/idFoto?key="{idFoto}"` |
| Contar fotos por usuario/propiedad | GET | `buscobien_propiedades_casas_fotos/_design/DDUSPR/_view/cuentaFotos?key=["{idUsuario}","{idPropiedad}"]` |
| Recuperar todas las fotas de usuario/propiedad | GET | `buscobien_propiedades_casas_fotos/_design/DDUSPR/_view/userproperty?key=["{idUsuario}","{idPropiedad}"]` |
| Recuperar IDs de fotos por usuario/propiedad | GET | `buscobien_propiedades_casas_fotos/_design/DDUSPR/_view/idUserPropiedadFoto?key=["{idUsuario}","{idPropiedad}"]` |
| Recuperar IDs de fotos por propiedad | GET | `buscobien_propiedades_casas_fotos/_design/DDFOTO/_view/idFotoIdPropiedad?key="{idPropiedad}"` |
| Recuperar fotos con skip/limit | GET | `buscobien_propiedades_casas_fotos/_design/DDUSPR/_view/userproperty?key=["{idUsuario}","{idPropiedad}"]&skip={skip}&limit={limit}` |

---

## 11. Estructura de Archivos

```
lib/22_imagenes/
├── variables_imagenes.dart                                    # Constantes de dimensiones (300x200, 200x125, 10)
├── inicio_fotos_usuario/
│   ├── pagina_carousel_fotos_usuario.dart                     # Carrusel completo (300x200)
│   └── pagina_carousel_fotos_usuario_mini.dart                # Carrusel mini (200x125)
├── data_models/
│   ├── data_fotos_casa.dart                                   # Modelo FotosCasa y FotosCasaClass
│   ├── data_fotos_casa_get.dart                               # Modelo wrapper para respuesta GET
│   ├── data_fotos_casa_get_ids.dart                            # Modelo wrapper para lista de IDs
│   ├── data_fotos_ordenadas.dart                              # Modelo ListaFotosOrdenadas y FotosOrden
│   ├── data_fotos_get_ids_fotos_user_prop.dart                 # Modelo GetIdsFotosUserProp
│   ├── data_cuenta_fotos.dart                                  # Modelo CuentaFotos
│   ├── data_couchdb_post_return.dart                          # Modelo ResultadoGuardaFoto
│   ├── data_fotos_lista_fotos_iduser_idprop.dart               # Modelo lista de fotas
│   └── json/                                                   # Datos de ejemplo JSON
├── tus_espacios_fotos_propiedad/
│   ├── image_file_structure.dart                              # Clase PlatformFileNoFinal
│   ├── funciones_compress_image.dart                           # Compresión multiplataforma
│   └── manejo_de_fotos/
│       ├── opciones_menu_fotos/
│       │   ├── pagina_fotos_menu_opciones.dart                 # Pantalla principal con tabs
│       │   ├── pagina_lista_fotos_listado.dart                 # Modo listado reordenable
│       │   ├── pagina_lista_fotos_cuadros.dart                 # Modo cuadrícula
│       │   └── pagina_lista_fotos_carousel.dart                # Modo carrusel
│       ├── futures_y_providers/
│       │   ├── future_funciones_fotos.dart                     # Funciones de foto (CRUD, navegación)
│       │   ├── future_get_fotos_by_idpr_orden.dart             # Future para fotos ordenadas
│       │   ├── future_recupera_ids_fotos_propiedad.dart        # Future para recuperar IDs
│       │   ├── future_update_fotos_orden.dart                  # Future para actualizar orden
│       │   ├── future_put_fotos_orden.dart                     # Future para crear orden
│       │   ├── http_funciones_gestion_foto.dart                # Funciones HTTP de gestión de fotos
│       │   ├── provider_get_fotos_ids_user_propiedad.dart      # Provider de IDs de fotos
│       │   └── provider_get_lista_fotos_ordenadas.dart         # Provider de orden de fotos
│       ├── lista_ids_fotos/
│       │   └── data_fotos_get_ids_fotos_user_prop.dart         # Modelo GetIdsFotosUserProp
│       ├── lista_fotos_ordenadas/
│       │   ├── provider_get_lista_fotos_ordenadas.dart         # Provider de orden
│       │   ├── data_fotos_ordenadas_get_idpropiedad.dart       # Modelo wrapper orden
│       │   └── clase_listas_fotos_propiedad.dart               # Clases auxiliares
│       └── datos_fotos/
│           ├── data_cuenta_fotos.dart                          # Modelo CuentaFotos
│           ├── data_fotos_lista_fotos_iduser_idprop.dart       # Modelo lista fotos
│           └── data_couchdb_post_return.dart                   # Modelo resultado POST
```

---

## 12. Dependencias Técnicas

- **Imágenes:** `flutter_image_compress`, `image` (Dart puro), `carousel_slider`
- **HTTP:** `package:http` para peticiones a CouchDB
- **Estado:** `flutter_riverpod` con `NotifierProvider`, `FutureProvider`, `ConsumerStatefulWidget`
- **UI:** Material Design 3, `ReorderableListView`, `TabBar`, `TabController`, `PopupMenuButton`
- **Seguridad:** `generate_hash.dart` para SHA256, `direccionip.dart` para URL base
- **Plataforma:** `dart:io` para detección de Windows, `kIsWeb` para Web

---

## 13. Reglas de Compresión por Plataforma

| Plataforma | Método | Formato | Calidad | Dimensiones |
|------------|--------|---------|---------|-------------|
| Android/iOS | `FlutterImageCompress.compressWithFile` | Original | 80% | min 2300x1500 |
| Android/iOS | `FlutterImageCompress.compressAndGetFile` | Original | 80% | - |
| Android/iOS/Web | `FlutterImageCompress.compressWithList` | WebP | Variable | min 620x480 |
| Windows | `fotoCompressListWin` (Dart puro) | JPEG | 80% | max 800px ancho |
| Web | `compressImageWeb` (Dart puro) | JPEG | 80% | Original |
| Windows | `fotoCompressListWebP` (fallback) | JPEG | Variable | 620px ancho |

---

## 14. Flujos de Usuario Principales

### 14.1 Flujo de Visualización de Fotos
1. Usuario abre propiedad → Sistema carga IDs y orden de fotos
2. Sistema valida orden guardado vs IDs actuales
3. Sistema renderiza vista correspondiente (carrusel/lista/cuadrícula)
4. Usuario navega entre fotos (swipe/botones)
5. Usuario puede ver detalle, compartir, guardar en lista

### 14.2 Flujo de Gestión de Fotos
1. Usuario accede a "Mi cuenta" → "Mis Espacios" → Propiedad
2. Usuario abre gestión de fotos (tab Cargar/Ordenar/Mostrar)
3. En Cargar: ve cuadrícula, puede agregar fotos
4. En Ordenar: ve lista reordenable, puede arrastrar y guardar orden
5. En Mostrar: ve carrusel completo con navegación

### 14.3 Flujo de Subida de Foto
1. Usuario presiona "Agregar" → Navega a captura/selector
2. Sistema comprime imagen según plataforma
3. Sistema genera ID SHA256 único
4. Sistema envía POST a CouchDB con metadatos
5. Sistema actualiza lista de fotos y orden
6. Sistema recarga la UI

### 14.4 Flujo de Eliminación de Foto
1. Usuario presiona botón eliminar en foto
2. Sistema muestra diálogo de confirmación
3. Si confirma: Sistema elimina de CouchDB
4. Sistema actualiza lista general y lista de orden
5. Sistema actualiza documento de orden en CouchDB
6. Sistema recarga la UI
