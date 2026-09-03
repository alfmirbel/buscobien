# Inventario de Componentes del Directorio: `D:\buscobien\lib\08_pantallas\propiedades`

Este documento contiene un análisis detallado e inventario de todos los componentes declarados en cada uno de los archivos `.dart` dentro de la carpeta `D:\buscobien\lib\08_pantallas\propiedades`.

Este subdirectorio contiene 3 archivos de código fuente:
1. `data_find_propiedades.dart`: Modelo de datos JSON para mapear búsquedas complejas (Query Find) en CouchDB.
2. `pagina_detalle_propiedad_pdf.dart`: Módulo de generación de PDF para descargar la ficha técnica completa del inmueble.
3. `pagina_detalle_propiedad.dart`: Pantalla principal de la ficha técnica que renderiza la información detallada e interactiva de una propiedad seleccionada.

---

## Tabla de Inventario de Componentes

| Subdirectorio | Nombre del archivo | Tipo de componentes | Nombre del componente | Parámetros que requiere (en su caso) | Variables que utiliza (externas/globales/providers) | Variables internas / locales | Estilos que le aplican (en su caso) |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| `08_pantallas/propiedades` | `data_find_propiedades.dart` | Función global (retorna `FindPropiedades`) | `findPropiedadesFromJson` | `String str` | No aplica | Decodifica un JSON a un objeto tipo `FindPropiedades` | No aplica |
| `08_pantallas/propiedades` | `data_find_propiedades.dart` | Función global (retorna `String`) | `findPropiedadesToJson` | `FindPropiedades data` | No aplica | Codifica un objeto `FindPropiedades` a un String JSON | No aplica |
| `08_pantallas/propiedades` | `data_find_propiedades.dart` | Clase de datos (Modelo principal) | `FindPropiedades` | `{required this.docs, required this.bookmark}` | `Doc` | Atributos `docs` (lista de `Doc`) y `bookmark` (puntero de paginación de CouchDB) | No aplica |
| `08_pantallas/propiedades` | `data_find_propiedades.dart` | Clase de datos (Submodelo) | `Doc` | `{required this.id, required this.rev, required this.espacioscasa}` | `EspaciosCasa` | Mapeador para envolver `id`, `rev` y el cuerpo `espacioscasa` (clase `EspaciosCasa`) | No aplica |
| `08_pantallas/propiedades` | `data_find_propiedades.dart` | Método constructor | `Doc.fromJson` | `Map<String, dynamic> json` | `EspaciosCasa` | Constructor de asignación técnica NoSQL (`_id`, `_rev`, `espacioscasa`) | No aplica |
| `08_pantallas/propiedades` | `pagina_detalle_propiedad_pdf.dart` | Servicio global / Clase estática | `PdfGeneratorService` | No aplica | `recuperaFotoPorIdFoto`, `ValueEspaciosCasaGet` | Clase contenedora del servicio de PDFs | No aplica |
| `08_pantallas/propiedades` | `pagina_detalle_propiedad_pdf.dart` | Método asíncrono estático | `generarYDescargarPDF` | `ValueEspaciosCasaGet propiedad`, `String idFotoPrincipal`, `List<String> idsGaleria` | `PdfGoogleFonts.materialIcons`, `Printing.layoutPdf` | `pdf` (`Document`), `espacios` (`EspaciosCasa`), `clave`, `nombreArchivo`, `mainImageBytes`, `galeriaBytes`, `font` | Genera un PDF de tamaño **Carta** (`PdfPageFormat.letter`) con márgenes de `40`. Combina tablas de características con iconos vectoriales embebidos e imágenes transformadas a bytes de manera fluida |
| `08_pantallas/propiedades` | `pagina_detalle_propiedad_pdf.dart` | Métodos auxiliares de dibujo de PDF | `_buildHeader`, `_buildDescripcion`, `_buildMainImage`, `_buildPrecios`, `_buildDatosGrid`, `_buildUbicacion`, `_buildContacto`, `_buildGaleria` | Múltiples firmas según el componente (textos, listas de bytes, fuentes, objetos de datos) | No aplica | Retornan widgets nativos de la librería de dibujo `pdf/widgets.pw` | Usan `PdfColors` (gris claro, gris oscuro, blanco) con fuentes y tablas cuadriculadas con bordes de grosor `1.0` en color gris `400` |
| `08_pantallas/propiedades` | `pagina_detalle_propiedad.dart` | Clase de Flutter (`ConsumerStatefulWidget`) | `PaginaDetalleWidget` | `ValueEspaciosCasaGet propiedad`, `GetIdsFotosUserProp listaIdsFotos`, `{super.key}` | No aplica | Crea `PaginaDetalleWidgetState` | No aplica |
| `08_pantallas/propiedades` | `pagina_detalle_propiedad.dart` | Estado privado de Widget | `PaginaDetalleWidgetState` | No aplica | `getListaFotosOrdenadasProvider`, `appTheme`, `listaOtrasCaracteristicas` | `scaffoldDetalleKey`, `valoresVacios` (`["", "0"]`), `iconSizeBanner`, `textSizeBanner`, `espacioEntreDato`, `screenWidth`, `screenHeight`, márgenes adaptativos (`padMargenL`, `padMargenT`, etc.) | Layout responsivo: márgenes laterales de `90` en pantallas grandes que se encogen a `15` en móviles (`screenWidth < smallScreenMin`) |
| `08_pantallas/propiedades` | `pagina_detalle_propiedad.dart` | Método de construcción de pantalla | `build` | `BuildContext context` | `PdfGeneratorService`, `appTheme`, `listaOtrasCaracteristicas` | Extrae objetos de la propiedad (`espacios`, `ubicacion`, `contacto`, `listamasdatos`), construye `AppBar`, `FloatingActionButton` de PDF y `SingleChildScrollView` con cuerpo jerárquico | `appTheme.primary` (fondo de la barra superior y FAB), `fontSizeTituloPagina` (20), `fontSizeSubtituloPagina` (16) |
| `08_pantallas/propiedades` | `pagina_detalle_propiedad.dart` | Método de renderizado auxiliar | `_buildTituloSeccion` | `String titulo`, `{double fontSize = 0}` | `appTheme` | `Container`, `Text` | Título centrado con un ancho máximo de `350` y color de texto `appTheme.onPrimaryContainer` |
| `08_pantallas/propiedades` | `pagina_detalle_propiedad.dart` | Método de renderizado auxiliar | `_buildPrecioFila` | `String label`, `String valor` | `appTheme` | `Container`, `Text` | Altura fija de `30` con fondo `appTheme.surface` y texto en negrita |
| `08_pantallas/propiedades` | `pagina_detalle_propiedad.dart` | Método de renderizado auxiliar | `_buildFilaDato` | `String label`, `String valor`, `double maxWidth`, `{bool fullWidth = false}` | `appTheme` | `Container`, `BoxDecoration`, `Text`, `ConstrainedBox` | Caja con fondo blanco, borde de color `appTheme.secondary` con grosor `1.0` y esquinas redondeadas (`BorderRadius.circular(3)`). Padding interno moderado y restricción de ancho mínimo (`140`) |
| `08_pantallas/propiedades` | `pagina_detalle_propiedad.dart` | Método de renderizado auxiliar | `_buildDatoContacto` | `String label`, `String valor` | Ninguna | `Align`, `Padding`, `Text` | Alineación izquierda, fuente `12` en negrita |
| `08_pantallas/propiedades` | `pagina_detalle_propiedad.dart` | Método de renderizado auxiliar | `_buildFotoPrincipalYIconos` | `EspaciosCasa espacios` | `recuperaFotoPorIdFoto`, `appTheme` | `idFotoPrincipal`, `FutureBuilder`, `Container`, `Wrap` | Cuadro de imagen principal de `350x250` con borde `3` de color `appTheme.outlineVariant` y radio de borde de `15`. Fila de iconos inferior con espaciado controlado |
| `08_pantallas/propiedades` | `pagina_detalle_propiedad.dart` | Método de renderizado auxiliar | `_buildIconoDato` | `IconData icon`, `String valor`, `String sufijo` | `appTheme` | `Row`, `Icon`, `Text` | Icono de color `appTheme.onPrimaryContainer` y tamaño `iconSizeBanner` (16) con texto tamaño `10` |
| `08_pantallas/propiedades` | `pagina_detalle_propiedad.dart` | Método de renderizado auxiliar | `_buildGaleriaFotos` | `String idUsuario`, `String idPropiedad` | `recuperaIdsFotosDePropiedades`, `recuperaFotosOrdenadasIdProperty`, `getListaFotosOrdenadasProvider` | `FutureBuilder`, `listaIds` (`GetIdsFotosUserProp`), `fotosParaMostrar`, `fotosProvider` | Genera una galería usando un `Wrap` con espacios horizontal/vertical de `10.0` para albergar instancias dinámicas de `_FotoItemWidget` |
| `08_pantallas/propiedades` | `pagina_detalle_propiedad.dart` | Clase de Flutter (`StatelessWidget` interna) | `_FotoItemWidget` | `required String idFoto` | `recuperaFotoPorIdFoto` | `FutureBuilder`, `SizedBox`, `Ink.image`, `InkWell` | Miniatura de `150x100` con ajuste de imagen `BoxFit.cover`. Si falla la imagen, muestra una caja gris con un icono roto de imagen |

## Detalles de Optimización y Arquitectura

1. **Diseño Modular de PDFs (`pagina_detalle_propiedad_pdf.dart`)**:
   La generación de PDF está completamente desacoplada de la interfaz gráfica. Dado que el motor de PDF no soporta el ciclo de vida reactivo de Flutter, `PdfGeneratorService` descarga asíncronamente todas las fotos desde CouchDB y las procesa a memoria en forma de `Uint8List` antes de iniciar el trazado de las páginas, garantizando un rendimiento óptimo sin bloqueos en el hilo principal de la aplicación.

2. **Adaptación de Pantallas y Diseño Responsivo (`pagina_detalle_propiedad.dart`)**:
   La vista utiliza el tamaño del dispositivo (`MediaQuery`) para ajustar sus márgenes. En pantallas de escritorio, añade márgenes generosos a los lados (`90px`) para evitar que el texto se estire demasiado y sea difícil de leer. En dispositivos móviles, compacta el diseño con márgenes de `15px` para maximizar el área visible.

3. **Galería Inteligente con Orden Personalizado (`pagina_detalle_propiedad.dart`)**:
   Al cargar la galería de fotos, se ejecutan dos operaciones concurrentes:
   - Se recuperan todos los IDs de fotos de CouchDB asociados al inmueble (`recuperaIdsFotosDePropiedades`).
   - Se consulta el catálogo de orden personalizado (`recuperaFotosOrdenadasIdProperty`).
   Si existe un orden personalizado definido por el usuario promotor, la galería lo aplica inmediatamente. Si no existe un orden, autogenera el acomodo secuencial por defecto en tiempo de ejecución de manera limpia.
