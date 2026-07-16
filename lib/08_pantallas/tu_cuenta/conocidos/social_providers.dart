import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

import '../../../40_security/direccionip.dart';
import 'invitacion_model.dart';
import 'mensaje_model.dart';

// =============================================================================
// 3. PROVIDERS (LÓGICA DE NEGOCIO Y COUCHDB)
// =============================================================================

// Helper para Auth
Map<String, String> get _authHeaders => {
  'Authorization': 'Basic ${base64Encode(utf8.encode('$username:$password'))}',
  'Content-Type': 'application/json',
};

// --- A. PROVIDER DE USUARIOS (Simulado para listar usuarios a invitar) ---
final usersListProvider = FutureProvider<List<Map<String, dynamic>>>((
  ref,
) async {
  // Aquí llamas a tu vista de CouchDB que devuelve los usuarios registrados.
  // Ejemplo simplificado usando _find:
  final url = Uri.parse('$direccionip/buscobien_usuarios/_find');
  final body = jsonEncode({
    "selector": {
      "usuario.nombreusuario": {"\$exists": true},
    },
    "limit": 50,
  });

  final response = await http.post(url, headers: _authHeaders, body: body);
  if (response.statusCode == 200) {
    final data = jsonDecode(utf8.decode(response.bodyBytes));
    return List<Map<String, dynamic>>.from(data['docs']);
  }
  return [];
});

// --- A. PROVIDER DE USUARIOS (Simulado para listar usuarios a invitar) ---
final usersPromotoresListProvider = FutureProvider<List<Map<String, dynamic>>>((
  ref,
) async {
  // Aquí llamas a tu vista de CouchDB que devuelve los usuarios registrados.
  // Ejemplo simplificado usando _find:
  final url = Uri.parse('$direccionip/buscobien_usuarios_promotores/_find');
  final body = jsonEncode({
    "selector": {
      "usuario.nombreusuario": {"\$exists": true},
    },
    "limit": 50,
  });

  final response = await http.post(url, headers: _authHeaders, body: body);
  if (response.statusCode == 200) {
    final data = jsonDecode(utf8.decode(response.bodyBytes));
    return List<Map<String, dynamic>>.from(data['docs']);
  }
  return [];
});

// --- B. PROVIDER DE INVITACIONES ---

class InvitacionesNotifier
    extends StateNotifier<AsyncValue<List<InvitacionModel>>> {
  InvitacionesNotifier() : super(const AsyncValue.loading());
  final _uuid = const Uuid();

  // Obtener invitaciones enviadas o recibidas
  Future<void> fetchInvitaciones(String userId) async {
    state = const AsyncValue.loading();
    try {
      final url = Uri.parse('$direccionip/buscobien_social/_find');
      final body = jsonEncode({
        "selector": {
          "type": "invitation",
          "\$or": [
            {"senderId": userId},
            {"receiverId": userId},
          ],
        },
      });

      final response = await http.post(url, headers: _authHeaders, body: body);
      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        final List<dynamic> docs = data['docs'];
        state = AsyncValue.data(
          docs.map((e) => InvitacionModel.fromJson(e)).toList(),
        );
      } else {
        state = AsyncValue.data([]);
      }
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  // Enviar Invitación
  Future<bool> sendInvitation(
    String senderId,
    String senderName,
    String receiverId,
    String receiverName,
  ) async {
    try {
      final inv = InvitacionModel(
        id: _uuid.v4(),
        senderId: senderId,
        senderName: senderName,
        receiverId: receiverId,
        receiverName: receiverName,
        timestamp: DateTime.now().toIso8601String(),
      );

      final url = Uri.parse('$direccionip/buscobien_social');
      final response = await http.post(
        url,
        headers: _authHeaders,
        body: jsonEncode(inv.toJson()),
      );

      if (response.statusCode == 201) {
        fetchInvitaciones(senderId); // Recargar
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  // Cambiar estado de invitación (Aceptar / Rechazar)
  Future<bool> updateInvitationStatus(
    InvitacionModel inv,
    String newStatus,
    String currentUserId,
  ) async {
    try {
      inv.status = newStatus;
      final url = Uri.parse('$direccionip/buscobien_social/${inv.id}');

      final response = await http.put(
        url,
        headers: _authHeaders,
        body: jsonEncode(inv.toJson()),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        fetchInvitaciones(currentUserId);
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }
}

// --- C. PROVIDER DE CHAT ---
final chatProvider =
    FutureProvider.family<List<MensajeModel>, Map<String, String>>((
      ref,
      params,
    ) async {
      final currentUserId = params['currentUserId']!;
      final targetUserId = params['targetUserId']!;

      final url = Uri.parse('$direccionip/buscobien_social/_find');
      final body = jsonEncode({
        "selector": {
          "type": "chat_message",
          "\$or": [
            {"senderId": currentUserId, "receiverId": targetUserId},
            {"senderId": targetUserId, "receiverId": currentUserId},
          ],
        },
        "sort": [
          {"timestamp": "asc"},
        ], // Asegúrate de tener un índice creado en CouchDB para esto
      });

      final response = await http.post(url, headers: _authHeaders, body: body);
      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        final List<dynamic> docs = data['docs'];
        return docs.map((e) => MensajeModel.fromJson(e)).toList();
      }
      return [];
    });

Future<bool> sendChatMessage(
  String senderId,
  String receiverId,
  String content,
) async {
  try {
    final msg = MensajeModel(
      senderId: senderId,
      receiverId: receiverId,
      content: content,
      timestamp: DateTime.now().toIso8601String(),
    );
    final url = Uri.parse('$direccionip/buscobien_social');
    final response = await http.post(
      url,
      headers: _authHeaders,
      body: jsonEncode(msg.toJson()),
    );
    return response.statusCode == 201;
  } catch (e) {
    return false;
  }
}
