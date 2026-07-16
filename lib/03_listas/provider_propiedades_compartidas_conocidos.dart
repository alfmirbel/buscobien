import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

import '../40_security/direccionip.dart';
import '../60_global_widgets/debugprint.dart';

// =============================================================================
// PROVIDER — PROPIEDADES COMPARTIDAS ENTRE CONOCIDOS
// =============================================================================
// Base: buscobien_propiedades_compartidas_conocidos
// Índices requeridos:
//   {"index":{"fields":["type","origenId","destinoId"]},"name":"idx-prop-compartida-dupla"}
//   {"index":{"fields":["type","destinoId"]},"name":"idx-prop-compartida-destino"}

const String _dbPropCompartidas = 'buscobien_propiedades_compartidas_conocidos';

Map<String, String> get _authHeaders => {
  'Authorization': 'Basic ${base64Encode(utf8.encode('$username:$password'))}',
  'Content-Type': 'application/json',
};

class PropiedadCompartidaKnownModel {
  final String id;
  final String origenId;
  final String origenNombre;
  final String destinoId;
  final String destinoNombre;
  final String propiedadId;
  final String propiedadNombre;
  final String tipodeespacio;
  final String timestamp;

  const PropiedadCompartidaKnownModel({
    required this.id,
    required this.origenId,
    required this.origenNombre,
    required this.destinoId,
    required this.destinoNombre,
    required this.propiedadId,
    required this.propiedadNombre,
    required this.tipodeespacio,
    required this.timestamp,
  });

  factory PropiedadCompartidaKnownModel.fromJson(Map<String, dynamic> json) =>
      PropiedadCompartidaKnownModel(
        id: json['_id'] as String? ?? '',
        origenId: json['origenId'] as String? ?? '',
        origenNombre: json['origenNombre'] as String? ?? '',
        destinoId: json['destinoId'] as String? ?? '',
        destinoNombre: json['destinoNombre'] as String? ?? '',
        propiedadId: json['propiedadId'] as String? ?? '',
        propiedadNombre: json['propiedadNombre'] as String? ?? '',
        tipodeespacio: json['tipodeespacio'] as String? ?? '',
        timestamp: json['timestamp'] as String? ?? '',
      );

  Map<String, dynamic> toJson() => {
    'origenId': origenId,
    'origenNombre': origenNombre,
    'destinoId': destinoId,
    'destinoNombre': destinoNombre,
    'propiedadId': propiedadId,
    'propiedadNombre': propiedadNombre,
    'tipodeespacio': tipodeespacio,
    'timestamp': timestamp,
    'type': 'propiedad_compartida_conocido',
  };
}

// =============================================================================
// NOTIFIER
// =============================================================================

class PropiedadesCompartidasConocidosNotifier
    extends AsyncNotifier<List<PropiedadCompartidaKnownModel>> {
  @override
  Future<List<PropiedadCompartidaKnownModel>> build() async => [];

  Future<void> fetchPropiedadesCompartidas(String userId) async {
    state = const AsyncValue.loading();
    try {
      final url = Uri.parse('$direccionip/$_dbPropCompartidas/_find');
      final body = jsonEncode({
        'selector': {
          'type': 'propiedad_compartida_conocido',
          r'$or': [
            {'origenId': userId},
            {'destinoId': userId},
          ],
        },
        'limit': 200,
      });
      final response = await http.post(url, headers: _authHeaders, body: body);
      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        state = AsyncValue.data(
          (data['docs'] as List)
              .map(
                (e) => PropiedadCompartidaKnownModel.fromJson(
                  e as Map<String, dynamic>,
                ),
              )
              .toList(),
        );
      } else {
        state = const AsyncValue.data([]);
      }
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  // Guarda una propiedad compartida con un conocido.
  Future<bool> compartirPropiedad({
    required String origenId,
    required String origenNombre,
    required String destinoId,
    required String destinoNombre,
    required String propiedadId,
    required String propiedadNombre,
    required String tipodeespacio,
  }) async {
    try {
      final id = const Uuid().v4();
      final modelo = PropiedadCompartidaKnownModel(
        id: id,
        origenId: origenId,
        origenNombre: origenNombre,
        destinoId: destinoId,
        destinoNombre: destinoNombre,
        propiedadId: propiedadId,
        propiedadNombre: propiedadNombre,
        tipodeespacio: tipodeespacio,
        timestamp: DateTime.now().toIso8601String(),
      );

      final response = await http.put(
        Uri.parse('$direccionip/$_dbPropCompartidas/$id'),
        headers: _authHeaders,
        body: jsonEncode({'_id': id, ...modelo.toJson()}),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return true;
      }
      debugPrintLevels(
        1,
        'compartirPropiedad error: ${response.statusCode}',
      );
      return false;
    } catch (e) {
      debugPrintLevels(1, 'compartirPropiedad exception: $e');
      return false;
    }
  }
}

final propiedadesCompartidasConocidosProvider = AsyncNotifierProvider<
    PropiedadesCompartidasConocidosNotifier,
    List<PropiedadCompartidaKnownModel>>(
  PropiedadesCompartidasConocidosNotifier.new,
);
