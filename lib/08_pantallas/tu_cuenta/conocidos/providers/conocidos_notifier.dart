import 'dart:async';
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

import '../../../../40_security/direccionip.dart';
import '../../../../60_global_widgets/debugprint.dart';
import '../models/conocido.dart';

// =============================================================================
// HELPERS
// =============================================================================

const String _dbInvitaciones = 'buscobien_invitaciones';

Map<String, String> get _authHeaders => {
  'Authorization': 'Basic ${base64Encode(utf8.encode('$username:$password'))}',
  'Content-Type': 'application/json',
};

// =============================================================================
// NOTIFIER PRINCIPAL
// =============================================================================
// Índice CouchDB recomendado (crear en Fauxton):
//   {"index": {"fields": ["type", "senderId", "receiverId"]}, "name": "idx-invitaciones"}

class ConocidosNotifier extends AsyncNotifier<List<Conocido>> {
  String _currentUserId = '';

  @override
  FutureOr<List<Conocido>> build() async {
    return [];
  }

  // Carga todas las invitaciones (enviadas y recibidas) del usuario.
  // Llamar desde initState del widget raíz con addPostFrameCallback.
  Future<void> cargar(String userId) async {
    _currentUserId = userId;
    state = const AsyncValue.loading();
    try {
      state = AsyncValue.data(await _fetchConocidos(userId));
    } catch (e, st) {
      debugPrintLevels(1, 'ConocidosNotifier.cargar exception: $e');
      state = AsyncValue.error(e, st);
    }
  }

  Future<List<Conocido>> _fetchConocidos(String userId) async {
    final url = Uri.parse('$direccionip/$_dbInvitaciones/_find');
    final body = jsonEncode({
      'selector': {
        'type': 'invitacion_social',
        r'$or': [
          {'senderId': userId},
          {'receiverId': userId},
        ],
      },
      'limit': 200,
    });

    final response = await http.post(url, headers: _authHeaders, body: body);
    if (response.statusCode == 200) {
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      final docs = data['docs'] as List<dynamic>;
      return docs.map((e) => _fromCouchDb(e as Map<String, dynamic>)).toList();
    }
    debugPrintLevels(1, 'ConocidosNotifier._fetchConocidos error: ${response.statusCode}');
    return [];
  }

  // Convierte el documento de CouchDB al modelo Conocido.
  Conocido _fromCouchDb(Map<String, dynamic> doc) {
    return Conocido(
      id: doc['_id'] ?? '',
      solicitanteId: doc['senderId'] ?? '',
      solicitanteNombre: doc['senderName'] ?? '',
      receptorId: doc['receiverId'] ?? '',
      receptorNombre: doc['receiverName'] ?? '',
      estado: _parseEstado(doc['status'] ?? 'pending'),
      fechaActualizacion: DateTime.tryParse(doc['timestamp'] ?? '') ?? DateTime.now(),
    );
  }

  InvitacionEstado _parseEstado(String status) {
    switch (status) {
      case 'accepted': return InvitacionEstado.aceptado;
      case 'rejected': return InvitacionEstado.rechazado;
      case 'blocked':  return InvitacionEstado.bloqueado;
      default:         return InvitacionEstado.pendiente;
    }
  }

  String _statusStr(InvitacionEstado estado) {
    switch (estado) {
      case InvitacionEstado.aceptado:  return 'accepted';
      case InvitacionEstado.rechazado: return 'rejected';
      case InvitacionEstado.bloqueado: return 'blocked';
      case InvitacionEstado.pendiente: return 'pending';
    }
  }

  // Envía una invitación a CouchDB y recarga la lista.
  Future<bool> enviarInvitacion(
    String solicitanteId,
    String solicitanteNombre,
    String receptorId,
    String receptorNombre,
  ) async {
    try {
      final id = const Uuid().v4();
      final body = jsonEncode({
        '_id': id,
        'type': 'invitacion_social',
        'senderId': solicitanteId,
        'senderName': solicitanteNombre,
        'receiverId': receptorId,
        'receiverName': receptorNombre,
        'status': 'pending',
        'timestamp': DateTime.now().toIso8601String(),
      });

      final url = Uri.parse('$direccionip/$_dbInvitaciones');
      final response = await http.post(url, headers: _authHeaders, body: body);

      if (response.statusCode == 201) {
        if (_currentUserId.isNotEmpty) {
          final lista = await _fetchConocidos(_currentUserId);
          state = AsyncValue.data(lista);
        }
        return true;
      }
      debugPrintLevels(1, 'enviarInvitacion error: ${response.statusCode} ${response.body}');
      return false;
    } catch (e) {
      debugPrintLevels(1, 'enviarInvitacion exception: $e');
      return false;
    }
  }

  // Agrega directamente al promotor como contacto aceptado (sin pasar por pendiente).
  // Si ya existe una relación aceptada en cualquier dirección, retorna true sin duplicar.
  Future<bool> agregarContactoAceptado(
    String solicitanteId,
    String solicitanteNombre,
    String receptorId,
    String receptorNombre,
  ) async {
    final lista = state.value ?? [];
    final yaExiste = lista.any((c) =>
        c.estado == InvitacionEstado.aceptado &&
        ((c.solicitanteId == solicitanteId && c.receptorId == receptorId) ||
            (c.solicitanteId == receptorId && c.receptorId == solicitanteId)));
    if (yaExiste) return true;

    try {
      final id = const Uuid().v4();
      final body = jsonEncode({
        '_id': id,
        'type': 'invitacion_social',
        'senderId': solicitanteId,
        'senderName': solicitanteNombre,
        'receiverId': receptorId,
        'receiverName': receptorNombre,
        'status': 'accepted',
        'timestamp': DateTime.now().toIso8601String(),
      });
      final url = Uri.parse('$direccionip/$_dbInvitaciones');
      final response = await http.post(url, headers: _authHeaders, body: body);
      if (response.statusCode == 201) {
        if (_currentUserId.isNotEmpty) {
          state = AsyncValue.data(await _fetchConocidos(_currentUserId));
        }
        return true;
      }
      debugPrintLevels(1, 'agregarContactoAceptado error: ${response.statusCode}');
      return false;
    } catch (e) {
      debugPrintLevels(1, 'agregarContactoAceptado exception: $e');
      return false;
    }
  }

  // Acepta o rechaza una invitación. Obtiene el _rev vigente antes del PUT.
  Future<void> responderInvitacion(String documentoId, InvitacionEstado nuevoEstado) async {
    try {
      final getUrl = Uri.parse('$direccionip/$_dbInvitaciones/$documentoId');
      final getResponse = await http.get(getUrl, headers: _authHeaders);
      if (getResponse.statusCode != 200) return;

      final doc = jsonDecode(utf8.decode(getResponse.bodyBytes)) as Map<String, dynamic>;
      doc['status'] = _statusStr(nuevoEstado);

      final putUrl = Uri.parse('$direccionip/$_dbInvitaciones/$documentoId');
      final putResponse = await http.put(putUrl, headers: _authHeaders, body: jsonEncode(doc));

      if (putResponse.statusCode == 200 || putResponse.statusCode == 201) {
        final listaActual = state.value ?? [];
        state = AsyncValue.data(
          listaActual.map((c) {
            if (c.id == documentoId) return c.copyWith(estado: nuevoEstado);
            return c;
          }).toList(),
        );
      } else {
        debugPrintLevels(1, 'responderInvitacion error: ${putResponse.statusCode}');
      }
    } catch (e) {
      debugPrintLevels(1, 'responderInvitacion exception: $e');
    }
  }
}

final conocidosProvider =
    AsyncNotifierProvider<ConocidosNotifier, List<Conocido>>(() {
      return ConocidosNotifier();
    });

// =============================================================================
// PROVIDERS DERIVADOS
// =============================================================================

final conocidosAceptadosProvider =
    Provider.family<AsyncValue<List<Conocido>>, String>((ref, currentUserId) {
      return ref.watch(conocidosProvider).whenData((lista) {
        return lista
            .where(
              (c) =>
                  c.estado == InvitacionEstado.aceptado &&
                  (c.solicitanteId == currentUserId ||
                      c.receptorId == currentUserId),
            )
            .toList();
      });
    });

final invitacionesRecibidasProvider =
    Provider.family<AsyncValue<List<Conocido>>, String>((ref, currentUserId) {
      return ref.watch(conocidosProvider).whenData((lista) {
        return lista.where((c) => c.receptorId == currentUserId).toList();
      });
    });

final invitacionesEnviadasProvider =
    Provider.family<AsyncValue<List<Conocido>>, String>((ref, currentUserId) {
      return ref.watch(conocidosProvider).whenData((lista) {
        return lista.where((c) => c.solicitanteId == currentUserId).toList();
      });
    });
