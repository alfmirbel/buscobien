import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/foundation.dart'; // NECESARIO PARA kIsWeb
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:material_symbols_icons/symbols.dart';
// Importa tus variables globales y modelos
import '../05_provider_menus/provider_menu_nivel_gobierno.dart';
// Asegúrate de que esta importación sea correcta según tu estructura
// import '../xx_modelos/espacios_casa_get.dart';
// import '../08_pantallas/inicio/data_espacios_casas_get.dart';
import '../08_pantallas/inicio/data_espacios_casas_get.dart';
import '../08_pantallas/ubicacion/provider_localidades_del_cp.dart';
import '../08_pantallas/ubicacion/data_sepomex_localidades.dart';
import '../20_var_globales/var_color_themes.dart';
import 'package:geocoding/geocoding.dart';

import '../60_global_widgets/debugprint.dart'; // IMPORTANTE: Agrega este paquete

// Importa tus variables globales y modelos
// import '../08_pantallas/inicio/data_espacios_casas_get.dart';
// Asegúrate de importar la definición de EspaciosCasaGet correctamente
/*
i necesitas configurar un mapa digital (como en Google Maps o Flutter) para que encuadre todo México por defecto, puedes usar este cuadro delimitador (Bounding Box) aproximado:
Suroeste (Southwest): 14.5321° N, 118.3667° W
Noreste (Northeast): 32.7183° N, 86.7100° W
O usar una coordenada central aproximada:
Latitud: 23.6345° N
Longitud: 102.5528° W
*/

class PaginaMapaPropiedades extends ConsumerStatefulWidget {
  final EspaciosCasaGet listaPropiedadesVar;

  const PaginaMapaPropiedades({super.key, required this.listaPropiedadesVar});

  @override
  ConsumerState<PaginaMapaPropiedades> createState() =>
      _PaginaMapaPropiedadesState();
}

class _PaginaMapaPropiedadesState extends ConsumerState<PaginaMapaPropiedades> {
  final Completer<GoogleMapController> _controller = Completer();
  Set<Marker> _markers = {};
  bool _isLoading = true;
  String nivelGobierno = "";
  double zoomLevel = 5.0;
  String addressQuery = "";

  // Coordenada central de México por defecto
  static const CameraPosition _kInitialPosition = CameraPosition(
    target: LatLng(20.00, -100.00),
    zoom: 5.0,
  );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _cargarMarcadores();
    });
    // Eliminamos ref.watch de initState para evitar el error anterior
  }

  Future<void> _cargarMarcadores() async {
    Set<Marker> tempMarkers = {};

    for (var item in widget.listaPropiedadesVar.rows) {
      final prop = item.value;

      // Conversión segura
      final double? lat = double.tryParse(
        prop.espacioscasa.ubicacioncasa.latitud.toString(),
      );
      final double? lng = double.tryParse(
        prop.espacioscasa.ubicacioncasa.longitud.toString(),
      );

      if (lat == null || lng == null) continue;

      final Color colorPin =
          (prop.espacioscasa.tipodetransaccion.contains("Venta"))
          ? appTheme.primary
          : (prop.espacioscasa.tipodetransaccion.contains("Renta"))
          ? appTheme.secondary
          : appTheme.tertiary;

      final icon = await _createCustomMarkerBitmap(
        (prop.espacioscasa.tipodetransaccion.contains("Venta"))
            ? prop.espacioscasa.precioventa
            : (prop.espacioscasa.tipodetransaccion.contains("Renta"))
            ? prop.espacioscasa.preciorenta
            : "${prop.espacioscasa.precioventa}/${prop.espacioscasa.preciorenta}",
        backgroundColor: colorPin,
      );

      tempMarkers.add(
        Marker(
          markerId: MarkerId(prop.id),
          position: LatLng(lat, lng),
          icon: icon,
          infoWindow: InfoWindow(
            title:
                "${prop.espacioscasa.tipodepropiedad} en ${prop.espacioscasa.tipodetransaccion}",
            snippet: (prop.espacioscasa.tipodetransaccion.contains("Venta"))
                ? "Venta: ${prop.espacioscasa.precioventa}"
                : (prop.espacioscasa.tipodetransaccion.contains("Renta"))
                ? "Renta: ${prop.espacioscasa.preciorenta}"
                : "Venta/Renta: ${prop.espacioscasa.precioventa}/${prop.espacioscasa.preciorenta}",
          ),
        ),
      );
    }

    if (mounted) {
      setState(() {
        _markers = tempMarkers;
        _isLoading = false;
      });
      // Ajustamos la cámara basándonos en el NOMBRE del lugar, no en los pines
      _ajustarCamaraPorNombreNivelGobierno();
    }
  }

  // ---------------------------------------------------------------------------
  // LÓGICA DE CÁMARA POR GEOCODING (NOMBRE DEL LUGAR)
  // ---------------------------------------------------------------------------
  Future<void> _ajustarCamaraPorNombreNivelGobierno() async {
    debugPrintLevels(
      07,
      "_ajustarCamaraPorNombreNivelGobierno. Genera controlador.",
    );

    final GoogleMapController controller = await _controller.future;

    // 1. Validaciones iniciales
    if (!_controller.isCompleted) {
      debugPrintLevels(
        07,
        "_ajustarCamaraPorNombreNivelGobierno. Controlladors incompleto.",
      );
      return;
    }

    if (kIsWeb) {
      debugPrintLevels(07, "Web detectada: Usando ajuste por Bounds (Límites)");
      _ajustarCamaraPorBounds(controller);
      return;
    }

    debugPrintLevels(
      07,
      "_ajustarCamaraPorNombreNivelGobierno. Clave: ${widget.listaPropiedadesVar.rows.length}",
    );
    // 1. Extraemos los datos de ubicación de la PRIMERA propiedad disponible.
    // Asumimos que si filtraste por "Jalisco", todas las propiedades son de Jalisco.

    // widget.listaPropiedadesVar.rows[0].value.espacioscasa;
    // 2. Construimos la dirección de búsqueda (Query String) basada en el Nivel
    addressQuery = "";
    // Helper local para limpiar nulos y vacíos.
    // Ejemplo: Si municipio es null, genera "Estado, Pais" en lugar de "null, Estado, Pais"
    /*
    "Nacional",
    "Estado",
    "Municipio",
    "C.P.",
    "Tipo/Localidad",
    */
    final ubicacion = ref.watch(localidadesPorCodigoPostalProvider);
    final int indiceLocalidad = ubicacion.localidadSeleccionada;
    final localidadData =
        ubicacion.localidades.rows[indiceLocalidad].value.localidadCp;
    debugPrintLevels(
      07,
      "_ajustarCamaraPorNombreNivelGobierno. $indiceLocalidad, ${ubicacion.localidades.rows[indiceLocalidad].value.localidadCp.cp.toString()}",
    );

    switch (nivelGobierno) {
      case "Nacional":
        addressQuery = "México";
        zoomLevel = 5.0;
        break;
      case 'Estado':
        addressQuery = localidadData.estado.isEmpty
            ? "Sin Estado"
            : ("${localidadData.estado}, México.");
        zoomLevel = 8.0;
        break;
      case 'Municipio':
        addressQuery = localidadData.municipio.isEmpty
            ? "Sin Municipio"
            : ("${localidadData.municipio}, ${localidadData.estado}, México.");
        zoomLevel = 11.0;
        break;
      case 'C.P.':
        addressQuery = localidadData.cp == 0
            ? "Sin C.P."
            : ("${localidadData.cp.toString()}, ${localidadData.municipio}, ${localidadData.estado}, México.");
        zoomLevel = 14.0;
        break;
      case 'Asentamiento':
        addressQuery = localidadData.asentamiento.isEmpty
            ? "Sin localidad"
            : ("${localidadData.asentamiento}, ${localidadData.cp.toString()}, ${localidadData.municipio}, ${localidadData.estado}, México.");
        zoomLevel = 16.0;
        break;
      default:
        addressQuery = "Sin ubicación";
    }
    /*
    switch (nivelGobierno) {
      case 'Nacional':
        // Ejemplo: "Mexico"
        addressQuery = ubicacion.pais;
        zoomLevel = 5.0;
        break;

      case 'Estado':
        // Ejemplo: "Jalisco, Mexico"
        addressQuery =
            "${ubicacion.ubicacioncasa.localidadCp.estado}, ${ubicacion.ubicacioncasa.pais}";
        zoomLevel = 20.0;
        break;
      case 'Municipio':
        // Ejemplo: "Guadalajara, Jalisco, Mexico"
        addressQuery =
            "${ubicacion.ubicacioncasa.localidadCp.municipio}, ${ubicacion.ubicacioncasa.localidadCp.estado}, ${ubicacion.ubicacioncasa.pais}";
        zoomLevel = 40.0;
        break;
      case 'C.P.':
        // Ejemplo: "44100, Mexico"
        addressQuery =
            "${ubicacion.ubicacioncasa.localidadCp.cp}, ${ubicacion.ubicacioncasa.pais}";
        zoomLevel = 80.0;
        break;

      case 'Asentamiento':
        // Ejemplo: "Colonia Centro, Guadalajara, Jalisco, Mexico"
        // Agregamos contexto superior para evitar ambigüedades
        addressQuery =
            "${ubicacion.ubicacioncasa.localidadCp.asentamiento}, ${ubicacion.ubicacioncasa.localidadCp.municipio}, ${ubicacion.ubicacioncasa.localidadCp.estado}, ${ubicacion.ubicacioncasa.pais}";
        zoomLevel = 100;
        break;

      default:
        // Si no hay nivel claro, usamos coordenadas de pines como fallback o país
        addressQuery = addressQuery = ubicacion.ubicacioncasa.pais;
        zoomLevel = 5.0;
        break;
    }
*/
    // 2. Validación final antes de llamar al API
    if (addressQuery.isEmpty || addressQuery.trim() == "null") {
      debugPrintLevels(07, "Dirección vacía o inválida, cancelando geocoding.");
      return;
    }

    debugPrintLevels(
      07,
      "Buscando coordenadas para: $addressQuery, con nivel: $nivelGobierno",
    );

    try {
      // 3. Usamos el paquete 'geocoding' para buscar las coordenadas de ese texto
      debugPrintLevels(07, "Buscando locationFromAddress: $addressQuery");

      List<Location> locations = await locationFromAddress(addressQuery);

      debugPrintLevels(07, "Regresa locationFromAddress: ${locations.first}");

      if (locations.isNotEmpty) {
        // Tomamos el primer resultado encontrado
        final Location location = locations.first;

        // 4. Movemos la cámara
        controller.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: LatLng(location.latitude, location.longitude),
              zoom: zoomLevel,
            ),
          ),
        );
      } else {
        debugPrintLevels(
          07,
          "No se encontraron coordenadas para: $addressQuery",
        );
        if (nivelGobierno.toLowerCase().contains('colonia') ||
            nivelGobierno.toLowerCase().contains('asentamiento')) {
          debugPrint("🔄 Intentando fallback a nivel Municipio...");
          _fallbackMunicipio(localidadData, controller);
        }
      }
    } catch (e) {
      debugPrintLevels(07, "Error en Geocoding: $e");
      // Fallback opcional: Si falla el geocoding, podrías usar la lógica anterior de bounds
    }
  }

  // Fallback por si la colonia está mal escrita o no existe en Google Maps
  Future<void> _fallbackMunicipio(
    LocalidadCp localidadData,
    GoogleMapController controller,
  ) async {
    try {
      final municipio = localidadData.municipio;
      final estado = localidadData.estado;
      if (municipio.isEmpty || estado.isEmpty) return;
      final fallbackQuery = "$municipio, $estado, México";
      List<Location> locs = await locationFromAddress(fallbackQuery);
      if (locs.isNotEmpty) {
        controller.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: LatLng(locs.first.latitude, locs.first.longitude),
              zoom: 12,
            ),
          ),
        );
      }
    } catch (e) {
      debugPrint("Falló también el fallback: $e");
    }
  }

  // ---------------------------------------------------------------------------
  // FALLBACK: AJUSTE POR BOUNDS (Funciona en Web, Android y iOS)
  // Calcula el recuadro para que se vean todos los pines visibles
  // ---------------------------------------------------------------------------
  void _ajustarCamaraPorBounds(GoogleMapController controller) {
    if (_markers.isEmpty) return;

    double minLat = 90.0;
    double maxLat = -90.0;
    double minLng = 180.0;
    double maxLng = -180.0;

    for (var marker in _markers) {
      if (marker.position.latitude < minLat) minLat = marker.position.latitude;
      if (marker.position.latitude > maxLat) maxLat = marker.position.latitude;
      if (marker.position.longitude < minLng)
        minLng = marker.position.longitude;
      if (marker.position.longitude > maxLng)
        maxLng = marker.position.longitude;
    }

    controller.animateCamera(
      CameraUpdate.newLatLngBounds(
        LatLngBounds(
          southwest: LatLng(minLat, minLng),
          northeast: LatLng(maxLat, maxLng),
        ),
        50.0, // Padding
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // GENERADOR DE IMAGEN DEL MARCADOR (CANVAS) - Sin cambios
  // ---------------------------------------------------------------------------
  Future<BitmapDescriptor> _createCustomMarkerBitmap(
    String text, {
    required Color backgroundColor,
  }) async {
    const double fontSize = 10.0;
    const double padding = 1.0;

    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);

    final TextPainter textPainter = TextPainter(
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );

    textPainter.text = TextSpan(
      text: text,
      style: const TextStyle(
        fontSize: fontSize,
        color: Colors.white,
        fontWeight: FontWeight.normal,
      ),
    );

    textPainter.layout();

    final double width = textPainter.width + (padding * 2) + 5;
    final double height = textPainter.height + (padding * 2) + 30;

    final Paint paint = Paint()..color = backgroundColor;
    final Paint paintBorder = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    final RRect rRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, width, height - 20),
      const Radius.circular(3),
    );

    canvas.drawRRect(
      rRect.shift(const Offset(2, 2)),
      Paint()..color = Colors.black.withValues(alpha: 0.3),
    );

    canvas.drawRRect(rRect, paint);
    canvas.drawRRect(rRect, paintBorder);

    final Path path = Path();
    path.moveTo(width / 2 - 15, height - 20);
    path.lineTo(width / 2, height);
    path.lineTo(width / 2 + 15, height - 20);
    path.close();
    canvas.drawPath(path, paint);
    canvas.drawPath(path, paintBorder);

    textPainter.paint(canvas, Offset(padding, padding / 2));

    final ui.Image image = await pictureRecorder.endRecording().toImage(
      width.toInt(),
      height.toInt(),
    );

    final ByteData? byteData = await image.toByteData(
      format: ui.ImageByteFormat.png,
    );

    return BitmapDescriptor.bytes(byteData!.buffer.asUint8List());
  }

  @override
  Widget build(BuildContext context) {
    // Actualizamos la variable local en el build
    nivelGobierno = ref.watch(menuNivelDeGobiernoProvider).etiqueta;

    // Listener para actualizar la cámara si el nivel cambia dinámicamente
    ref.listen(menuNivelDeGobiernoProvider, (previous, next) {
      nivelGobierno = next.etiqueta;
      _ajustarCamaraPorNombreNivelGobierno();
    });

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 40.0,
        centerTitle: true,
        titleSpacing: 0,
        backgroundColor: appTheme.primary,
        iconTheme: IconThemeData(size: 14, color: appTheme.onPrimary),
        title: Text(
          "Mapa de propiedades",
          style: TextStyle(
            color: appTheme.onPrimary,
            fontWeight: FontWeight.normal,
            fontSize: 14,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          //   mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 10),
            Container(
              //  width: 500,
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
              alignment: Alignment.center,
              height: 40,
              child: Text(
                "Propiedades a nivel $nivelGobierno",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: appTheme.onPrimaryContainer,
                  fontSize: 14,
                  letterSpacing: -0.15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            if (widget.listaPropiedadesVar.rows.isEmpty)
              Container(
                //  width: 500,
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                alignment: Alignment.center,
                // height: 40,
                child: Text(
                  "No hay propiedades que mostrar.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: appTheme.onPrimaryContainer,
                    fontSize: 12,
                    // letterSpacing: -0.15,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
            if (widget.listaPropiedadesVar.rows.isEmpty)
              const SizedBox(height: 10),
            Container(
              height: 350,
              width: 350,
              padding: const EdgeInsets.all(
                3,
              ), // Espacio entre el contenido y el borde
              decoration: BoxDecoration(
                color: appTheme.onPrimary, // Color de fondo del contenedor
                border: Border.all(
                  color: appTheme.primary, // Color del borde
                  width: 1.5, // Grosor del borde
                ),
                borderRadius: BorderRadius.circular(
                  5,
                ), // Opcional: Bordes redondeados
              ),
              child: Stack(
                children: [
                  GoogleMap(
                    mapType: MapType.normal,
                    initialCameraPosition: _kInitialPosition,
                    markers: _markers,
                    myLocationEnabled: true,
                    myLocationButtonEnabled: true,
                    zoomControlsEnabled: false,
                    mapToolbarEnabled: false,
                    onMapCreated: (GoogleMapController controller) {
                      if (!_controller.isCompleted) {
                        _controller.complete(controller);
                      }
                    },
                  ),

                  if (_isLoading)
                    Container(
                      color: Colors.black.withValues(alpha: 0.3),
                      child: Center(
                        child: CircularProgressIndicator(
                          color: appTheme.primary,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _ajustarCamaraPorNombreNivelGobierno();
        },
        label: Text("Reajustar", style: TextStyle(color: appTheme.onPrimary)),
        icon: Icon(Symbols.center_focus_strong, color: appTheme.onPrimary),
        backgroundColor: appTheme.primary,
        // foregroundColor: Colors.white,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
