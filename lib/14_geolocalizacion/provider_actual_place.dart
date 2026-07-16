import 'dart:async';
import 'dart:core';
import 'package:buscobien/14_geolocalizacion/app_keys.dart';
import 'package:buscobien/14_geolocalizacion/google_map_place_data.dart';
import 'package:flutter/foundation.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as google_maps;
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../42_sistema_operativo/detecta_os.dart';
import '../08_pantallas/ubicacion/provider_localidades_del_cp.dart';
import '../60_global_widgets/debugprint.dart';

//----------------------------------------------------------------------------
//----------------------------------------------------------------------------

//----------------------------------------------------------------------------

class DatosDeLaUbicacionActual {
  //
  Set<Marker> marcadores = {};

  String postalCode = "";
  String addressGM = "";

  int permisodelocalizacion = 0; // 0 = no
  String estadoDeLaConeccion = "";
  String resultadoPermisoUbicacion = "";
  double latitud = 0;
  double longitud = 0;

  String currentAddress = "";
  List<Placemark> placemarksList = [];
  String actualAddress = "";
  bool setState = true;

  GooglemapPlace userLocation = GooglemapPlace(
    plusCode: PlusCode(compoundCode: "", globalCode: ""),
    results: [],
    status: "",
  );

  CameraPosition posicionCamara = CameraPosition(
    target: LatLng(0.0, 0.0),
    zoom: 12,
  );

  Position actualPosition = Position(
    latitude: 0.0,
    longitude: 0.0,
    timestamp: DateTime.now(),
    altitude: 0.0,
    altitudeAccuracy: 0.0,
    accuracy: 0.0,
    heading: 0.0,
    headingAccuracy: 0.0,
    floor: 0,
    speed: 0.0,
    speedAccuracy: 0.0,
    isMocked: false,
  );

  Placemark place = Placemark(
    name: '',
    street: '',
    isoCountryCode: '',
    country: '',
    postalCode: '',
    administrativeArea: '',
    subAdministrativeArea: '',
    locality: '',
    subLocality: '',
    thoroughfare: '',
    subThoroughfare: '',
  );
  GoogleMapController? mapController;
  Completer<GoogleMapController> controller = Completer();
}

//----------------------------------------------------------------------------
//----------------------------------------------------------------------------
final ubicacionActualProvider =
    NotifierProvider<
      ClassLocalidadesNotifierProvider,
      DatosDeLaUbicacionActual
    >(() {
      return ClassLocalidadesNotifierProvider();
    });

//-----------------------------------------------------------------------------
class ClassLocalidadesNotifierProvider
    extends Notifier<DatosDeLaUbicacionActual> {
  // initial value
  @override
  DatosDeLaUbicacionActual build() {
    return DatosDeLaUbicacionActual();
  }

  //------------------------------------------------------------------------------

  void inicializaMarcadores() {
    state.marcadores.clear();
  }

  void addMarker(
    String markerID,
    double lat,
    double lon,
    String titulo,
    String snippetVal,
  ) {
    //------------------------------------------------------------------------
    // https://medium.com/@JBXBergDev/how-to-use-googlemap-markers-with-flutter-material-Symbols-38c4c975e928
    //
    // Define the position of the marker
    LatLng markerPosition = LatLng(lat, lon);

    // Create a new marker
    Marker marker = Marker(
      markerId: MarkerId(markerID),
      position: markerPosition,
      icon: google_maps.BitmapDescriptor.defaultMarker,
      // https://community.flutterflow.io/ask-the-community/post/custom-marker-icon-on-map-QT2S1rJMxxhJ0sP
      infoWindow: InfoWindow(title: titulo, snippet: snippetVal),
    );

    // Update the set of markers
    inicializaMarcadores();
    state.marcadores.add(marker);
    _notify();
  }

  /// La UI llama a este método en el callback onMapCreated del GoogleMap widget.
  void onMapCreated(GoogleMapController controller) {
    state.mapController = controller;
    if (!state.controller.isCompleted) {
      state.controller.complete(controller);
    }
  }

  /// Libera el controlador cuando el widget se destruye (llamar desde dispose()).
  void disposeMapController() {
    if (state.controller.isCompleted) {
      state.mapController?.dispose();
      state.controller = Completer<GoogleMapController>();
    }
  }

  // https://www.geeksforgeeks.org/how-to-get-users-current-location-on-google-maps-in-flutter/

  Future<Position> getUserCurrentLocation() async {
    // Delegamos al flujo correcto que ya valida el estado del permiso
    final permiso = await determinePermisosUbicacion();
    if (permiso == 0) {
      throw Exception(state.resultadoPermisoUbicacion);
    }
    return state.actualPosition;
  }

  //------------------------------------------------------------------------------

  Future<int> determinePermisosUbicacion() async {
    debugPrintLevels(0, "---- determinePermisosUbicacion()");
    state.permisodelocalizacion = 1;

    state.resultadoPermisoUbicacion = "La localización esta habilitada";
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      state.permisodelocalizacion = 0;
      state.resultadoPermisoUbicacion = 'La localización está deshabilitada.';
      debugPrintLevels(
        0,
        "---- determinePermisosUbicacion(): ${state.resultadoPermisoUbicacion}",
      );
      _notify();
      return state.permisodelocalizacion;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        state.permisodelocalizacion = 0;
        state.resultadoPermisoUbicacion = 'Permiso de localización denegado.';
      }
      debugPrintLevels(
        0,
        "---- determinePermisosUbicacion(): ${state.resultadoPermisoUbicacion}",
      );
      _notify();
      return state.permisodelocalizacion;
    }

    if (permission == LocationPermission.deniedForever) {
      state.permisodelocalizacion = 0;
      state.resultadoPermisoUbicacion = 'Localización negada permanentemente.';
      debugPrintLevels(
        0,
        "---- determinePermisosUbicacion(): ${state.resultadoPermisoUbicacion}",
      );
      _notify();
      return state.permisodelocalizacion;
    }

    state.actualPosition = await Geolocator.getCurrentPosition();
    state.latitud = state.actualPosition.latitude;
    state.longitud = state.actualPosition.longitude;
    debugPrintLevels(
      0,
      "---- determinePermisosUbicacion(): ${state.resultadoPermisoUbicacion}",
    );
    _notify();
    return state.permisodelocalizacion;
  }

  Future<Placemark> getAddressFromLatLng(
    double latitude,
    double longitude,
  ) async {
    debugPrintLevels(
      0,
      "getAddressFromLatLng(): ${latitude.toString()} : ${longitude.toString()}",
    );

    await placemarkFromCoordinates(latitude, longitude)
        .then((placemarks) {
          debugPrintLevels(0, "getAddressFromLatLng() placemarks: $placemarks");
          state.actualAddress = 'No results found.';
          if (placemarks.isNotEmpty) {
            state.actualAddress = placemarks[0].toString();
            state.place = placemarks[0];
            // Extracción robusta: evita null assertion e int.parse que fallan silenciosamente
            final cp = int.tryParse(state.place.postalCode ?? "");
            if (cp != null && cp > 0) {
              state.postalCode = state.place.postalCode!;
              ref
                  .read(localidadesPorCodigoPostalProvider.notifier)
                  .setCodigoPostal(cp);
            }
            state.placemarksList = placemarks;
          }
          state.currentAddress =
              "${state.place.name}, ${state.place.thoroughfare}, ${state.place.subThoroughfare}, "
              "${state.place.locality}, ${state.place.administrativeArea} ${state.place.postalCode}, ${state.place.country}";
        })
        .catchError((e) {
          debugPrintLevels(0, "Error en placemarkFromCoordinates: $e");
        });
    _notify();
    return state.place;
  }

  /// Hace geocodificación inversa vía HTTP usando las coordenadas ya disponibles en state.
  /// No llama a getUserCurrentLocation() — las coordenadas deben estar en state.latitud/longitud
  /// antes de llamar a este método (establecidas por determinePermisosUbicacion()).
  Future<String> getPlaceFromCoordinates() async {
    debugPrintLevels(
      0,
      "HTTP getPlaceFromCoordinates lat:${state.latitud} lng:${state.longitud}",
    );

    if (!state.addressGM.isEmpty) {
      debugPrintLevels(
        0,
        "HTTP getPlaceFromCoordinates: dirección ya cacheada",
      );
      return "";
    }

    final String url =
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=${state.latitud},${state.longitud}&key=$GOOGLE_MAPS_KEY';

    String resultado = "";
    try {
      final response = await http.get(Uri.parse(url));
      debugPrintLevels(
        0,
        "HTTP getPlaceFromCoordinates status: ${response.statusCode}",
      );
      if (response.statusCode == 200 && response.body.isNotEmpty) {
        resultado = response.body;
      } else {
        debugPrintLevels(
          0,
          "HTTP getPlaceFromCoordinates sin resultado: ${response.statusCode}",
        );
      }
    } catch (e) {
      debugPrintLevels(0, "HTTP getPlaceFromCoordinates excepción: $e");
    }
    return resultado;
  }

  //------------------------------------------------------------------------------

  /// Procesa la respuesta de la Geocoding REST API de Google.
  /// Extrae dirección formateada y código postal, y los propaga al provider.
  /// Usado por: Web, Windows (plataformas sin soporte nativo de geocoding).
  void _procesarResultadoGeocodingAPI() {
    if (state.userLocation.status != "OK") return;

    state.addressGM = state.userLocation.results[0].formattedAddress;

    for (var component in state.userLocation.results[0].addressComponents) {
      if (component.types.isNotEmpty && component.types[0] == "postal_code") {
        state.postalCode = component.longName;
        final cp = int.tryParse(component.longName);
        if (cp != null && cp > 0) {
          ref
              .read(localidadesPorCodigoPostalProvider.notifier)
              .setCodigoPostal(cp);
          debugPrintLevels(0, "CP propagado: $cp");
        }
      }
    }
    state.setState = false;
    debugPrintLevels(
      0,
      "DIRECCIÓN: ${state.addressGM} | CP: ${state.postalCode}",
    );
  }

  Future<void> determinaUbicacion() async {
    debugPrintLevels(0, "---- determinaUbicacion()");

    if (kIsWeb) {
      debugPrintLevels(
        0,
        "---- determinaUbicacion() [WEB] → getPlaceFromCoordinates()",
      );
      await getPlaceFromCoordinates().then((json) {
        debugPrintLevels(0, "---- determinaUbicacion(), json: ");

        if (json.isNotEmpty) {
          state.userLocation = googlemapPlaceFromJson(json);
          _procesarResultadoGeocodingAPI();
        }
      });
    } else {
      switch (defaultTargetPlatform) {
        case TargetPlatform.android:
          await getAddressFromLatLng(state.latitud, state.longitud);
          break;
        case TargetPlatform.iOS:
          await getAddressFromLatLng(state.latitud, state.longitud);
          break;
        case TargetPlatform.windows:
          await getPlaceFromCoordinates().then((json) {
            debugPrintLevels(0, "---- getPlaceFromCoordinates(), json: ");

            if (json.isNotEmpty) {
              state.userLocation = googlemapPlaceFromJson(json);
              _procesarResultadoGeocodingAPI();
            }
          });
          break;
        case TargetPlatform.fuchsia:
        case TargetPlatform.linux:
        case TargetPlatform.macOS:
          debugPrintLevels(
            0,
            "---- determinaUbicacion(): plataforma no soportada",
          );
          break;
      }
    }

    if (ref.read(checaPlataformaProvider).etiqueta != "windows") {
      addMarker(
        '01',
        state.latitud,
        state.longitud,
        'Mi Ubicación',
        state.addressGM,
      );
      state.posicionCamara = CameraPosition(
        target: LatLng(state.latitud, state.longitud),
        zoom: 12,
      );
    }
    _notify();
  }

  /// Crea una nueva instancia del estado para que Riverpod detecte el cambio
  /// de referencia y notifique a los consumidores.
  /// Necesario porque DatosDeLaUbicacionActual no es @freezed.
  void _notify() {
    final s = state;
    state = DatosDeLaUbicacionActual()
      ..marcadores = s.marcadores
      ..postalCode = s.postalCode
      ..addressGM = s.addressGM
      ..permisodelocalizacion = s.permisodelocalizacion
      ..estadoDeLaConeccion = s.estadoDeLaConeccion
      ..resultadoPermisoUbicacion = s.resultadoPermisoUbicacion
      ..latitud = s.latitud
      ..longitud = s.longitud
      ..currentAddress = s.currentAddress
      ..placemarksList = s.placemarksList
      ..actualAddress = s.actualAddress
      ..setState = s.setState
      ..userLocation = s.userLocation
      ..posicionCamara = s.posicionCamara
      ..actualPosition = s.actualPosition
      ..place = s.place
      ..mapController = s.mapController
      ..controller = s.controller;
  }

  //------------------------------------------------------------------------------
}

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------

final getUbicacionActuaFuturelProvider = FutureProvider<void>((ref) async {
  debugPrintLevels(0, "*** getUbicacionActuaFuturelProvider");
  return await ref.read(ubicacionActualProvider.notifier).determinaUbicacion();
});

final solicitaAccesoUbicacionFutureProvider = FutureProvider<int>((ref) async {
  debugPrintLevels(0, "*** getUbicacionActuaFuturelProvider");
  return await ref
      .read(ubicacionActualProvider.notifier)
      .determinePermisosUbicacion();
});
