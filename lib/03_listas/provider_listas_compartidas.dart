import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

import '../40_security/direccionip.dart';
import '../60_global_widgets/debugprint.dart';
import '../08_pantallas/tu_cuenta/conocidos/provider_mensajes.dart';
import 'models/lista_compartida_model.dart';

// =============================================================================
// PROVIDER — LISTAS COMPARTIDAS ENTRE USUARIOS
// =============================================================================
// Base: buscobien_listas_compartidas_usuarios
// Índices requeridos:
//   {"index":{"fields":["type","usuarioOrigenId","usuarioDestinoId"]},"name":"idx-lista-compartida-dupla"}
//   {"index":{"fields":["type","usuarioOrigenId"]},"name":"idx-lista-compartida-origen"}
//   {"index":{"fields":["type","usuarioDestinoId"]},"name":"idx-lista-compartida-destino"}

const String _dbListasCompartidas = 'buscobien_listas_compartidas_usuarios';
const String _dbListasPropCompartidas = 'buscobien_listas_prop_compartidas';

Map<String, String> get _authHeaders => {
  'Authorization': 'Basic ${base64Encode(utf8.encode('$username:$password'))}',
  'Content-Type': 'application/json',
};

// =============================================================================
// CONSTANTES DE RESULTADO para compartirLista
// =============================================================================
// 1  = éxito
// 0  = error (fallo de red / HTTP)
// -1 = ya compartida (anti-duplicado)
// =============================================================================

// =============================================================================
// NOTIFIER
// =============================================================================

class ListasCompartidasNotifier
    extends AsyncNotifier<List<ListaCompartidaModel>> {
  @override
  Future<List<ListaCompartidaModel>> build() async => [];

  // Carga todas las listas donde el usuario es origen o destino.
  Future<void> fetchListasCompartidas(String userId) async {
    state = const AsyncValue.loading();
    try {
      state = AsyncValue.data(await _fetch(userId));
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<List<ListaCompartidaModel>> _fetch(String userId) async {
    final url = Uri.parse('$direccionip/$_dbListasCompartidas/_find');
    final body = jsonEncode({
      'selector': {
        'type': 'lista_compartida',
        r'$or': [
          {'usuarioOrigenId': userId},
          {'usuarioDestinoId': userId},
        ],
      },
      'limit': 200,
    });

    final response = await http.post(url, headers: _authHeaders, body: body);
    if (response.statusCode == 200) {
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      return (data['docs'] as List)
          .map((e) => ListaCompartidaModel.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    debugPrintLevels(1, 'fetchListasCompartidas error: ${response.statusCode}');
    return [];
  }

  // ---------------------------------------------------------------------------
  // compartirLista
  // Retorna: 1=éxito, -1=ya compartida, 0=error
  // ---------------------------------------------------------------------------
  Future<int> compartirLista({
    required String listaOrigenId,
    required String listaNombreOrigen,
    required String usuarioOrigenId,
    required String usuarioOrigenNombre,
    required String usuarioDestinoId,
    required String usuarioDestinoNombre,
  }) async {
    try {
      // Anti-duplicado
      final existe = await _existeCompartida(listaOrigenId, usuarioDestinoId);
      if (existe) {
        debugPrintLevels(
          1,
          'compartirLista: lista ya compartida con $usuarioDestinoId',
        );
        return -1;
      }

      final listaCompartidaId = const Uuid().v4();
      final listaNombre = '$listaNombreOrigen (de $usuarioOrigenNombre)';

      final modelo = ListaCompartidaModel(
        id: listaCompartidaId,
        listaOrigenId: listaOrigenId,
        listaNombre: listaNombre,
        usuarioOrigenId: usuarioOrigenId,
        usuarioOrigenNombre: usuarioOrigenNombre,
        usuarioDestinoId: usuarioDestinoId,
        usuarioDestinoNombre: usuarioDestinoNombre,
        timestamp: DateTime.now().toIso8601String(),
      );

      final url = Uri.parse(
        '$direccionip/$_dbListasCompartidas/$listaCompartidaId',
      );
      final response = await http.put(
        url,
        headers: _authHeaders,
        body: listaCompartidaModelToJson(modelo),
      );

      debugPrintLevels(
        1,
        'compartirLista PUT status: ${response.statusCode} | body: ${response.body}',
      );

      if (response.statusCode != 201 && response.statusCode != 200) {
        return 0;
      }

      // Copiar propiedades de la lista origen a la lista compartida
      await _copiarPropiedades(
        listaOrigenId: listaOrigenId,
        listaCompartidaId: listaCompartidaId,
      );

      // Notificar al destinatario por chat privado
      await enviarMensajeDirecto(
        senderId: usuarioOrigenId,
        receiverId: usuarioDestinoId,
        content: listaNombreOrigen,
        tipo: 'lista',
        listaCompartidaId: listaCompartidaId,
      );

      return 1;
    } catch (e) {
      debugPrintLevels(1, 'compartirLista exception: $e');
      return 0;
    }
  }

  // Verifica si ya existe un registro compartido entre listaOrigenId y usuarioDestinoId.
  Future<bool> _existeCompartida(
    String listaOrigenId,
    String usuarioDestinoId,
  ) async {
    try {
      final url = Uri.parse('$direccionip/$_dbListasCompartidas/_find');
      final body = jsonEncode({
        'selector': {
          'type': 'lista_compartida',
          'listaOrigenId': listaOrigenId,
          'usuarioDestinoId': usuarioDestinoId,
        },
        'limit': 1,
      });
      final response = await http.post(url, headers: _authHeaders, body: body);
      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        return (data['docs'] as List).isNotEmpty;
      }
    } catch (e) {
      debugPrintLevels(1, '_existeCompartida exception: $e');
    }
    return false;
  }

  Future<void> _copiarPropiedades({
    required String listaOrigenId,
    required String listaCompartidaId,
  }) async {
    try {
      final urlIds = Uri.parse(
        '$direccionip/buscobien_listas_propiedades/_design/DDLOCAL/_view/vistaListaID?key="$listaOrigenId"',
      );
      final respIds = await http.get(urlIds, headers: _authHeaders);
      if (respIds.statusCode != 200) return;

      final dataIds = jsonDecode(utf8.decode(respIds.bodyBytes));
      final rows = (dataIds['rows'] as List?) ?? [];

      for (final row in rows) {
        final listaPropiedad = row['value'];
        if (listaPropiedad == null) continue;

        final nuevaRelacion = {
          '_id': const Uuid().v4(),
          'listaCompartidaId': listaCompartidaId,
          'propertyId': listaPropiedad['propertyId'] ?? '',
          'tipodeespacio': listaPropiedad['tipodeespacio'] ?? '',
          'timestamp': DateTime.now().toIso8601String(),
          'type': 'lista_prop_compartida',
        };

        await http.post(
          Uri.parse('$direccionip/$_dbListasPropCompartidas'),
          headers: _authHeaders,
          body: jsonEncode(nuevaRelacion),
        );
      }
    } catch (e) {
      debugPrintLevels(1, '_copiarPropiedades exception: $e');
    }
  }

  // ---------------------------------------------------------------------------
  // dejarDeCompartir
  // Elimina el registro de lista compartida y sus propiedades copiadas.
  // ---------------------------------------------------------------------------
  Future<bool> dejarDeCompartir(
    ListaCompartidaModel modelo,
    String userId,
  ) async {
    try {
      // GET para obtener _rev actual
      final docUrl = Uri.parse(
        '$direccionip/$_dbListasCompartidas/${modelo.id}',
      );
      final getResp = await http.get(docUrl, headers: _authHeaders);
      if (getResp.statusCode != 200) {
        debugPrintLevels(
          1,
          'dejarDeCompartir GET error: ${getResp.statusCode}',
        );
        return false;
      }
      final doc = jsonDecode(utf8.decode(getResp.bodyBytes));

      // Marcar como eliminado
      final putResp = await http.put(
        docUrl,
        headers: _authHeaders,
        body: jsonEncode({
          '_id': modelo.id,
          '_rev': doc['_rev'],
          '_deleted': true,
        }),
      );

      if (putResp.statusCode != 200 &&
          putResp.statusCode != 201 &&
          putResp.statusCode != 202) {
        debugPrintLevels(
          1,
          'dejarDeCompartir PUT error: ${putResp.statusCode}',
        );
        return false;
      }

      // Limpiar propiedades copiadas huérfanas en buscobien_listas_prop_compartidas
      await _limpiarPropiedadesCompartidas(modelo.id);

      // Refrescar estado
      await fetchListasCompartidas(userId);
      return true;
    } catch (e) {
      debugPrintLevels(1, 'dejarDeCompartir exception: $e');
      return false;
    }
  }

  Future<void> _limpiarPropiedadesCompartidas(String listaCompartidaId) async {
    try {
      final findUrl = Uri.parse(
        '$direccionip/$_dbListasPropCompartidas/_find',
      );
      final findBody = jsonEncode({
        'selector': {
          'type': 'lista_prop_compartida',
          'listaCompartidaId': listaCompartidaId,
        },
        'limit': 200,
      });
      final findResp = await http.post(
        findUrl,
        headers: _authHeaders,
        body: findBody,
      );
      if (findResp.statusCode != 200) return;

      final data = jsonDecode(utf8.decode(findResp.bodyBytes));
      final docs = (data['docs'] as List?) ?? [];

      for (final d in docs) {
        final id = d['_id'] as String?;
        final rev = d['_rev'] as String?;
        if (id == null || rev == null) continue;
        await http.put(
          Uri.parse('$direccionip/$_dbListasPropCompartidas/$id'),
          headers: _authHeaders,
          body: jsonEncode({'_id': id, '_rev': rev, '_deleted': true}),
        );
      }
    } catch (e) {
      debugPrintLevels(1, '_limpiarPropiedadesCompartidas exception: $e');
    }
  }

  // Recupera los IDs de propiedades de una lista compartida.
  Future<List<Map<String, dynamic>>> fetchPropiedadesListaCompartida(
    String listaCompartidaId,
  ) async {
    try {
      final url = Uri.parse('$direccionip/$_dbListasPropCompartidas/_find');
      final body = jsonEncode({
        'selector': {
          'type': 'lista_prop_compartida',
          'listaCompartidaId': listaCompartidaId,
        },
        'limit': 200,
      });
      final response = await http.post(url, headers: _authHeaders, body: body);
      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        return List<Map<String, dynamic>>.from(data['docs'] as List);
      }
    } catch (e) {
      debugPrintLevels(1, 'fetchPropiedadesListaCompartida exception: $e');
    }
    return [];
  }
}

final listasCompartidasProvider =
    AsyncNotifierProvider<ListasCompartidasNotifier, List<ListaCompartidaModel>>(
      ListasCompartidasNotifier.new,
    );
