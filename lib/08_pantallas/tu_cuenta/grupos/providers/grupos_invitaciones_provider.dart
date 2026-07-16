import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

import 'package:buscobien/40_security/direccionip.dart';
import 'package:buscobien/60_global_widgets/debugprint.dart';
import 'package:buscobien/08_pantallas/tu_cuenta/grupos/models/invitacion_grupo_model.dart';

// =============================================================================
// PROVIDER DE INVITACIONES A GRUPOS
// =============================================================================
// Espejo de social_providers.dart (conocidos), adaptado para grupos.
//
// Base de datos CouchDB: buscobien_grupos_invitaciones
// Índice requerido (crear en Fauxton):
//   {"index": {"fields": ["type", "receiverId"]}, "name": "idx-inv-receiver"}
//   {"index": {"fields": ["type", "senderId"]},   "name": "idx-inv-sender"}

const String _dbInvitaciones = 'buscobien_grupos_invitaciones';

Map<String, String> get _authHeaders => {
  'Authorization':
      'Basic ${base64Encode(utf8.encode('$username:$password'))}',
  'Content-Type': 'application/json',
};

// =============================================================================
// NOTIFIER
// =============================================================================

class GruposInvitacionesNotifier
    extends StateNotifier<AsyncValue<List<InvitacionGrupoModel>>> {
  GruposInvitacionesNotifier() : super(const AsyncValue.loading());

  final _uuid = const Uuid();

  // Carga todas las invitaciones donde el usuario es sender o receiver.
  Future<void> fetchInvitaciones(String userId) async {
    state = const AsyncValue.loading();
    try {
      final url = Uri.parse('$direccionip/$_dbInvitaciones/_find');
      final body = jsonEncode({
        'selector': {
          'type': 'invitacion_grupo',
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
        state = AsyncValue.data(
          docs
              .map(
                (e) => InvitacionGrupoModel.fromJson(e as Map<String, dynamic>),
              )
              .toList(),
        );
      } else {
        debugPrintLevels(
          1,
          'GruposInvitacionesNotifier.fetchInvitaciones error: ${response.statusCode}',
        );
        state = const AsyncValue.data([]);
      }
    } catch (e, st) {
      debugPrintLevels(
        1,
        'GruposInvitacionesNotifier.fetchInvitaciones exception: $e',
      );
      state = AsyncValue.error(e, st);
    }
  }

  // Envía una invitación a un usuario para unirse a un grupo.
  // Verifica que no exista ya una invitación pendiente para el mismo par usuario-grupo.
  Future<bool> enviarInvitacion({
    required String senderId,
    required String senderName,
    required String receiverId,
    required String receiverName,
    required String grupoId,
    required String grupoNombre,
  }) async {
    try {
      // Verificar invitación previa pendiente (solo las enviadas por el mismo remitente)
      final invExistente = _invitacionPendienteExiste(senderId, receiverId, grupoId);
      if (invExistente) return false;

      final inv = InvitacionGrupoModel(
        id: _uuid.v4(),
        senderId: senderId,
        senderName: senderName,
        receiverId: receiverId,
        receiverName: receiverName,
        grupoId: grupoId,
        grupoNombre: grupoNombre,
        timestamp: DateTime.now().toIso8601String(),
      );

      // Usa PUT /{db}/{docid} para mayor confiabilidad cuando el _id es conocido
      final docUrl = Uri.parse('$direccionip/$_dbInvitaciones/${inv.id}');
      final body = invitacionGrupoModelToJson(inv);
      var response = await http.put(docUrl, headers: _authHeaders, body: body);

      // Si la base de datos no existe, crearla y reintentar
      if (response.statusCode == 404) {
        debugPrintLevels(
          1,
          'GruposInvitacionesNotifier.enviarInvitacion: base de datos no encontrada, creando...',
        );
        final dbUrl = Uri.parse('$direccionip/$_dbInvitaciones');
        final createResp = await http.put(dbUrl, headers: _authHeaders);
        // 201 = creada, 412 = ya existía — ambas son aceptables
        debugPrintLevels(
          1,
          'GruposInvitacionesNotifier crearDB: ${createResp.statusCode} ${createResp.body}',
        );
        response = await http.put(docUrl, headers: _authHeaders, body: body);
      }

      if (response.statusCode == 201 || response.statusCode == 200) {
        await fetchInvitaciones(senderId);
        return true;
      }
      debugPrintLevels(
        1,
        'GruposInvitacionesNotifier.enviarInvitacion error: ${response.statusCode} ${response.body}',
      );
      return false;
    } catch (e) {
      debugPrintLevels(
        1,
        'GruposInvitacionesNotifier.enviarInvitacion exception: $e',
      );
      return false;
    }
  }

  // Acepta o rechaza una invitación recibida.
  // Al aceptar, llama opcionalmente a agregarMiembro en GruposNotifier.
  Future<bool> responderInvitacion(
    InvitacionGrupoModel inv,
    String nuevoStatus, // "accepted" | "rejected"
    String currentUserId,
  ) async {
    try {
      inv.status = nuevoStatus;
      inv.timestampRespuesta = DateTime.now().toIso8601String();

      final url = Uri.parse('$direccionip/$_dbInvitaciones/${inv.id}');
      final response = await http.put(
        url,
        headers: _authHeaders,
        body: invitacionGrupoModelToJson(inv),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        await fetchInvitaciones(currentUserId);
        return true;
      }
      debugPrintLevels(
        1,
        'GruposInvitacionesNotifier.responderInvitacion error: ${response.statusCode}',
      );
      return false;
    } catch (e) {
      debugPrintLevels(
        1,
        'GruposInvitacionesNotifier.responderInvitacion exception: $e',
      );
      return false;
    }
  }

  // Verifica en el estado local si ya existe una invitación pendiente enviada
  // por senderId al mismo receiverId para el mismo grupoId.
  bool _invitacionPendienteExiste(String senderId, String receiverId, String grupoId) {
    final lista = state.value ?? [];
    return lista.any(
      (inv) =>
          inv.senderId == senderId &&
          inv.receiverId == receiverId &&
          inv.grupoId == grupoId &&
          inv.status == 'pending',
    );
  }
}

// =============================================================================
// PROVIDERS EXPORTADOS
// =============================================================================

final gruposInvitacionesProvider = StateNotifierProvider<
  GruposInvitacionesNotifier,
  AsyncValue<List<InvitacionGrupoModel>>
>((ref) => GruposInvitacionesNotifier());

// Invitaciones recibidas por el usuario actual (pendientes).
final invitacionesGrupoRecibidasProvider =
    Provider.family<List<InvitacionGrupoModel>, String>((ref, userId) {
      final estado = ref.watch(gruposInvitacionesProvider);
      return estado.value
              ?.where(
                (inv) => inv.receiverId == userId && inv.status == 'pending',
              )
              .toList() ??
          [];
    });

// Invitaciones enviadas por el usuario actual (todas).
final invitacionesGrupoEnviadasProvider =
    Provider.family<List<InvitacionGrupoModel>, String>((ref, userId) {
      final estado = ref.watch(gruposInvitacionesProvider);
      return estado.value
              ?.where((inv) => inv.senderId == userId)
              .toList() ??
          [];
    });

// =============================================================================
// PROVIDER DE USUARIOS PARA INVITAR (buscar usuarios registrados)
// =============================================================================
// Reutiliza los mismos endpoints que social_providers.dart de conocidos.

final usuariosParaInvitarProvider =
    FutureProvider<List<Map<String, dynamic>>>((ref) async {
      final url = Uri.parse('$direccionip/buscobien_usuarios/_find');
      final body = jsonEncode({
        'selector': {
          'usuario.nombreusuario': {r'$exists': true},
        },
        'limit': 50,
      });

      try {
        final response = await http.post(url, headers: _authHeaders, body: body);
        if (response.statusCode == 200) {
          final data = jsonDecode(utf8.decode(response.bodyBytes));
          return List<Map<String, dynamic>>.from(data['docs'] as List);
        }
        return [];
      } catch (e) {
        debugPrintLevels(1, 'usuariosParaInvitarProvider exception: $e');
        return [];
      }
    });

final promotoresParaInvitarProvider =
    FutureProvider<List<Map<String, dynamic>>>((ref) async {
      final url = Uri.parse(
        '$direccionip/buscobien_usuarios_promotores/_find',
      );
      final body = jsonEncode({
        'selector': {
          'usuario.nombreusuario': {r'$exists': true},
        },
        'limit': 50,
      });

      try {
        final response = await http.post(url, headers: _authHeaders, body: body);
        if (response.statusCode == 200) {
          final data = jsonDecode(utf8.decode(response.bodyBytes));
          return List<Map<String, dynamic>>.from(data['docs'] as List);
        }
        return [];
      } catch (e) {
        debugPrintLevels(1, 'promotoresParaInvitarProvider exception: $e');
        return [];
      }
    });
