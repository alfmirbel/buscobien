import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../40_security/couch_http.dart' as http;
import '../40_security/direccionip.dart';
import '../60_global_widgets/debugprint.dart';
import '../08_pantallas/tu_cuenta/conocidos/provider_mensajes.dart';
import '../08_pantallas/tu_cuenta/social_api.dart';
import 'models/lista_compartida_model.dart';

// =============================================================================
// PROVIDER — LISTAS COMPARTIDAS ENTRE USUARIOS
// =============================================================================
// Base: buscobien_listas_compartidas_usuarios (abierta a usuarios con sesión; escribe quien comparte).
// Las propiedades de cada lista compartida viven en buscobien_listas_prop_compartidas, una base
// cerrada: se copian, leen y borran por buscobien-api (/listas-compartidas/:id/propiedades).
// Índices requeridos:
//   {"index":{"fields":["type","usuarioOrigenId","usuarioDestinoId"]},"name":"idx-lista-compartida-dupla"}
//   {"index":{"fields":["type","usuarioOrigenId"]},"name":"idx-lista-compartida-origen"}
//   {"index":{"fields":["type","usuarioDestinoId"]},"name":"idx-lista-compartida-destino"}

const String _dbListasCompartidas = 'buscobien_listas_compartidas_usuarios';

const Map<String, String> _authHeaders = {'Content-Type': 'application/json'};

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
    final url = Uri.parse('$dbBaseUrl/$_dbListasCompartidas/_find');
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
        '$dbBaseUrl/$_dbListasCompartidas/$listaCompartidaId',
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
      await socialApi.copiarPropiedades(listaCompartidaId);

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
      final url = Uri.parse('$dbBaseUrl/$_dbListasCompartidas/_find');
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

  // ---------------------------------------------------------------------------
  // dejarDeCompartir
  // Elimina el registro de lista compartida y sus propiedades copiadas.
  // ---------------------------------------------------------------------------
  Future<bool> dejarDeCompartir(
    ListaCompartidaModel modelo,
    String userId,
  ) async {
    try {
      // Primero las propiedades copiadas: el servidor valida con la lista, que aún debe existir.
      await socialApi.borrarPropiedades(modelo.id);

      // GET para obtener _rev actual
      final docUrl = Uri.parse(
        '$dbBaseUrl/$_dbListasCompartidas/${modelo.id}',
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

      // Refrescar estado
      await fetchListasCompartidas(userId);
      return true;
    } catch (e) {
      debugPrintLevels(1, 'dejarDeCompartir exception: $e');
      return false;
    }
  }

  // Recupera los IDs de propiedades de una lista compartida.
  Future<List<Map<String, dynamic>>> fetchPropiedadesListaCompartida(
    String listaCompartidaId,
  ) async {
    try {
      return await socialApi.propiedadesDeLista(listaCompartidaId) ?? [];
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
