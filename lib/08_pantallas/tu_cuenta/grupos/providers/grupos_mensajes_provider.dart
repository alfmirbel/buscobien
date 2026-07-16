import 'dart:async';
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

import 'package:buscobien/40_security/direccionip.dart';
import 'package:buscobien/60_global_widgets/debugprint.dart';
import 'package:buscobien/08_pantallas/tu_cuenta/grupos/models/mensaje_grupo_model.dart';

// =============================================================================
// PROVIDER DE MENSAJES DEL CHAT GRUPAL (Riverpod 3.x)
// =============================================================================
// Base de datos CouchDB: buscobien_grupos_mensajes
// Índice requerido (crear en Fauxton):
//   {"index": {"fields": ["type", "grupoId", "timestamp"]}, "name": "idx-msg-grupo"}
//
// Uso: ref.watch(mensajesGrupoProvider(grupoId))
//      ref.read(mensajesGrupoProvider(grupoId).notifier).enviar(...)

const String _dbMensajes = 'buscobien_grupos_mensajes';

final mensajesGrupoProvider = AsyncNotifierProvider.family<
    MensajesGrupoNotifier, List<MensajeGrupoModel>, String>(
  (grupoId) => MensajesGrupoNotifier(grupoId),
);

// =============================================================================
// NOTIFIER
// =============================================================================

class MensajesGrupoNotifier extends AsyncNotifier<List<MensajeGrupoModel>> {
  MensajesGrupoNotifier(this._grupoId);

  final String _grupoId;
  http.Client? _changesClient;
  StreamSubscription<String>? _changesSub;

  @override
  Future<List<MensajeGrupoModel>> build() async {
    ref.onDispose(_cerrarStream);

    final mensajes = await _cargarMensajes();
    _iniciarStream();
    return mensajes;
  }

  // ── Carga inicial desde _find ─────────────────────────────────────────────

  Future<List<MensajeGrupoModel>> _cargarMensajes() async {
    final url = Uri.parse('$direccionip/$_dbMensajes/_find');
    final body = jsonEncode({
      'selector': {
        'type': 'mensaje_grupo',
        'grupoId': _grupoId,
      },
      'limit': 300,
    });

    try {
      final response = await http.post(url, headers: _authHeaders, body: body);
      if (response.statusCode != 200) return [];
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      return (data['docs'] as List)
          .map((e) => MensajeGrupoModel.fromJson(e as Map<String, dynamic>))
          .toList()
        ..sort((a, b) => b.timestamp.compareTo(a.timestamp)); // newest-first
    } catch (e) {
      debugPrintLevels(1, 'MensajesGrupoNotifier._cargarMensajes: $e');
      return [];
    }
  }

  // ── _changes feed continuo ────────────────────────────────────────────────
  // CouchDB emite una línea JSON por cambio y una línea vacía de heartbeat.
  // LineSplitter divide el stream; cada doc se inyecta al frente (newest-first)
  // para que ListView(reverse:true) lo muestre al fondo de la pantalla.

  Future<void> _iniciarStream() async {
    _cerrarStream();

    final uri = Uri.parse(
      '$direccionip/$_dbMensajes/_changes'
      '?feed=continuous&heartbeat=10000&since=now&include_docs=true'
      '&filter=_selector',
    );

    final request = http.Request('POST', uri)
      ..headers.addAll(_authHeaders)
      ..body = jsonEncode({
        'selector': {
          'type': 'mensaje_grupo',
          'grupoId': _grupoId,
        },
      });

    try {
      _changesClient = http.Client();
      final streamed = await _changesClient!.send(request);

      _changesSub = streamed.stream
          .transform(utf8.decoder)
          .transform(const LineSplitter())
          .listen((line) {
            if (line.trim().isEmpty) return; // heartbeat vacío

            try {
              final json = jsonDecode(line) as Map<String, dynamic>;
              if (!json.containsKey('doc')) return;

              final nuevo = MensajeGrupoModel.fromJson(
                json['doc'] as Map<String, dynamic>,
              );

              final actual = state.asData?.value ?? [];
              if (actual.any((m) => m.id == nuevo.id)) return;
              state = AsyncData([nuevo, ...actual]);
            } catch (_) {}
          });
    } catch (e) {
      debugPrintLevels(1, 'MensajesGrupoNotifier._iniciarStream: $e');
    }
  }

  void _cerrarStream() {
    _changesSub?.cancel();
    _changesClient?.close();
    _changesSub = null;
    _changesClient = null;
  }

  // ── Enviar mensaje ─────────────────────────────────────────────────────────

  Future<void> enviar({
    required String senderId,
    required String senderName,
    required String content,
    String tipo = 'texto',
    String propiedadId = '',
  }) async {
    if (content.trim().isEmpty) return;

    final msg = MensajeGrupoModel(
      id: const Uuid().v4(),
      senderId: senderId,
      senderName: senderName,
      grupoId: _grupoId,
      content: content.trim(),
      timestamp: DateTime.now().toIso8601String(),
      tipo: tipo,
      propiedadId: propiedadId,
    );

    // Optimistic update: aparece en la UI antes del ACK de CouchDB.
    state = AsyncData([msg, ...state.asData?.value ?? []]);

    try {
      final response = await http.post(
        Uri.parse('$direccionip/$_dbMensajes'),
        headers: _authHeaders,
        body: mensajeGrupoModelToJson(msg),
      );
      if (response.statusCode != 201) {
        debugPrintLevels(1, 'enviar: statusCode=${response.statusCode}');
      }
    } catch (e) {
      debugPrintLevels(1, 'MensajesGrupoNotifier.enviar: $e');
    }
  }

  // ── Marcar mensajes como leídos ───────────────────────────────────────────
  // Llamar solo al abrir el chat (un PUT por mensaje no leído).

  Future<void> marcarMensajesLeidos(String currentUserId) async {
    final mensajes = state.asData?.value ?? [];
    final noLeidos = mensajes.where(
      (m) => !m.leido && m.senderId != currentUserId,
    );

    for (final msg in noLeidos) {
      try {
        msg.leido = true;
        await http.put(
          Uri.parse('$direccionip/$_dbMensajes/${msg.id}'),
          headers: _authHeaders,
          body: mensajeGrupoModelToJson(msg),
        );
      } catch (e) {
        debugPrintLevels(1, 'marcarMensajesLeidos: $e');
      }
    }
  }

  Map<String, String> get _authHeaders => {
        'Authorization':
            'Basic ${base64Encode(utf8.encode('$username:$password'))}',
        'Content-Type': 'application/json',
      };
}
