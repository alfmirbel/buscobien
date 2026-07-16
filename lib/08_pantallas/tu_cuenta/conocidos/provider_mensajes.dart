import 'dart:async';
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

import '../../../40_security/direccionip.dart';
import '../../../60_global_widgets/debugprint.dart';
import 'mensaje_model.dart';

// Envía un mensaje directo a CouchDB sin iniciar el feed de cambios continuo.
// Útil para envíos únicos desde widgets que no necesitan escuchar la conversación.
Future<bool> enviarMensajeDirecto({
  required String senderId,
  required String receiverId,
  required String content,
  String tipo = 'texto',
  String propiedadId = '',
  String listaCompartidaId = '',
}) async {
  if (content.trim().isEmpty) return false;
  final msg = MensajeModel(
    id: const Uuid().v4(),
    senderId: senderId,
    receiverId: receiverId,
    content: content.trim(),
    timestamp: DateTime.now().toIso8601String(),
    tipo: tipo,
    propiedadId: propiedadId,
    listaCompartidaId: listaCompartidaId,
  );
  try {
    final response = await http.post(
      Uri.parse('$direccionip/buscobien_mensajes'),
      headers: {
        'Authorization':
            'Basic ${base64Encode(utf8.encode('$username:$password'))}',
        'Content-Type': 'application/json',
      },
      body: mensajeModelToJson(msg),
    );
    return response.statusCode == 201;
  } catch (e) {
    debugPrintLevels(1, 'enviarMensajeDirecto: $e');
    return false;
  }
}

// Clave del provider: "currentUserId@@targetUserId"
String chatProviderKey(String currentUserId, String targetUserId) =>
    '$currentUserId@@$targetUserId';

// =============================================================================
// PROVIDER — AsyncNotifierProvider.family (Riverpod 3.x)
// =============================================================================
// En Riverpod 3.x el arg se inyecta por constructor, no por FamilyAsyncNotifier.
// Uso: ref.watch(mensajesChatProvider(chatKey))
//      ref.read(mensajesChatProvider(chatKey).notifier).enviar(text)

final mensajesChatProvider = AsyncNotifierProvider.family<
    MensajesChatNotifier, List<MensajeModel>, String>(
  (chatKey) => MensajesChatNotifier(chatKey),
);

// =============================================================================
// NOTIFIER
// =============================================================================

class MensajesChatNotifier extends AsyncNotifier<List<MensajeModel>> {
  MensajesChatNotifier(String chatKey) {
    final parts = chatKey.split('@@');
    _currentUserId = parts[0];
    _targetUserId = parts[1];
  }

  late final String _currentUserId;
  late final String _targetUserId;
  http.Client? _changesClient;
  StreamSubscription<String>? _changesSub;

  @override
  Future<List<MensajeModel>> build() async {
    // Cierra el stream al destruir el notifier (al salir de la pantalla).
    ref.onDispose(_cerrarStream);

    final mensajes = await _cargarMensajes();
    _iniciarStream(); // arranca en background, no bloquea la UI
    return mensajes;
  }

  // ── Carga inicial desde _find ─────────────────────────────────────────────

  Future<List<MensajeModel>> _cargarMensajes() async {
    final url = Uri.parse('$direccionip/buscobien_mensajes/_find');
    final body = jsonEncode({
      'selector': {
        'type': 'chat_mensaje',
        r'$or': [
          {'senderId': _currentUserId, 'receiverId': _targetUserId},
          {'senderId': _targetUserId, 'receiverId': _currentUserId},
        ],
      },
      'limit': 200,
    });

    try {
      final response = await http.post(url, headers: _headers, body: body);
      if (response.statusCode != 200) return [];
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      return (data['docs'] as List)
          .map((e) => MensajeModel.fromJson(e))
          .toList()
        ..sort((a, b) => b.timestamp.compareTo(a.timestamp)); // newest-first
    } catch (e) {
      debugPrintLevels(1, 'MensajesChatNotifier._cargarMensajes: $e');
      return [];
    }
  }

  // ── _changes feed continuo ────────────────────────────────────────────────
  // CouchDB emite una línea JSON por cambio y una línea vacía de heartbeat.
  // LineSplitter divide el stream; cada doc se inyecta al frente de la lista
  // (index 0 = más reciente) para que ListView(reverse:true) lo muestre al fondo.

  Future<void> _iniciarStream() async {
    _cerrarStream();

    final uri = Uri.parse(
      '$direccionip/buscobien_mensajes/_changes'
      '?feed=continuous&heartbeat=10000&since=now&include_docs=true'
      '&filter=_selector',
    );

    final request = http.Request('POST', uri)
      ..headers.addAll(_headers)
      ..body = jsonEncode({
        'selector': {
          'type': 'chat_mensaje',
          r'$or': [
            {'senderId': _currentUserId, 'receiverId': _targetUserId},
            {'senderId': _targetUserId, 'receiverId': _currentUserId},
          ],
        },
      });

    try {
      _changesClient = http.Client();
      final streamed = await _changesClient!.send(request);

      _changesSub = streamed.stream
          .transform(utf8.decoder)
          .transform(const LineSplitter())
          .listen((line) {
            if (line.trim().isEmpty) return; // heartbeat vacío de CouchDB

            try {
              final json = jsonDecode(line) as Map<String, dynamic>;
              if (!json.containsKey('doc')) return;

              final nuevo = MensajeModel.fromJson(
                json['doc'] as Map<String, dynamic>,
              );

              final actual = state.asData?.value ?? [];
              // Dedup: el optimistic update ya insertó el mensaje propio.
              if (actual.any((m) => m.id == nuevo.id)) return;
              state = AsyncData([nuevo, ...actual]);
            } catch (_) {}
          });
    } catch (e) {
      debugPrintLevels(1, 'MensajesChatNotifier._iniciarStream: $e');
    }
  }

  void _cerrarStream() {
    _changesSub?.cancel();
    _changesClient?.close();
    _changesSub = null;
    _changesClient = null;
  }

  // ── Enviar mensaje ─────────────────────────────────────────────────────────
  // Optimistic update: el mensaje propio aparece de inmediato en la UI.
  // Cuando el _changes feed lo devuelva, el dedup por id lo descarta.

  Future<void> enviar(
    String content, {
    String tipo = 'texto',
    String propiedadId = '',
  }) async {
    if (content.trim().isEmpty) return;

    final msg = MensajeModel(
      id: const Uuid().v4(),
      senderId: _currentUserId,
      receiverId: _targetUserId,
      content: content.trim(),
      timestamp: DateTime.now().toIso8601String(),
      tipo: tipo,
      propiedadId: propiedadId,
    );

    state = AsyncData([msg, ...state.asData?.value ?? []]);

    try {
      final response = await http.post(
        Uri.parse('$direccionip/buscobien_mensajes'),
        headers: _headers,
        body: mensajeModelToJson(msg),
      );
      if (response.statusCode != 201) {
        debugPrintLevels(1, 'enviar: statusCode=${response.statusCode}');
      }
    } catch (e) {
      debugPrintLevels(1, 'MensajesChatNotifier.enviar: $e');
    }
  }

  Map<String, String> get _headers => {
        'Authorization':
            'Basic ${base64Encode(utf8.encode('$username:$password'))}',
        'Content-Type': 'application/json',
      };
}
