import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../60_global_widgets/debugprint.dart';
import '../social_api.dart';
import '../sondeo.dart';
import 'mensaje_model.dart';

// Envía un mensaje directo sin abrir la conversación (POST /mensajes de buscobien-api).
// Útil para envíos únicos desde widgets que no necesitan escuchar la conversación.
// El remitente lo toma el servidor de la sesión; [senderId] se conserva por compatibilidad.
Future<bool> enviarMensajeDirecto({
  required String senderId,
  required String receiverId,
  required String content,
  String tipo = 'texto',
  String propiedadId = '',
  String listaCompartidaId = '',
  SocialApi? api,
}) async {
  if (content.trim().isEmpty) return false;
  final msg = MensajeModel(
    id: const Uuid().v4(),
    senderId: senderId,
    receiverId: receiverId,
    content: content.trim(),
    timestamp: DateTime.now().toUtc().toIso8601String(),
    tipo: tipo,
    propiedadId: propiedadId,
    listaCompartidaId: listaCompartidaId,
  );
  try {
    return await (api ?? socialApi).enviarMensaje(msg) != null;
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
  MensajesChatNotifier(String chatKey, {SocialApi? api, Duration intervalo = const Duration(seconds: 3)})
      : _api = api,
        _intervalo = intervalo {
    final parts = chatKey.split('@@');
    _currentUserId = parts[0];
    _targetUserId = parts[1];
  }

  late final String _currentUserId;
  late final String _targetUserId;
  final SocialApi? _api;
  final Duration _intervalo;
  SocialApi get _social => _api ?? socialApi;

  /// Fecha del mensaje más reciente que el servidor ya confirmó; punto de partida del sondeo.
  String _ultimoDelServidor = '';

  @override
  Future<List<MensajeModel>> build() async {
    // El sondeo corre solo mientras alguna pantalla escucha la conversación.
    final sondeo = Sondeo(_sondear, intervalo: _intervalo);
    sondeo.atarA(ref);

    final mensajes = await _cargarMensajes();
    if (ref.mounted) sondeo.iniciarSiHayOyentes(); // arranca en segundo plano, no bloquea la UI
    return mensajes;
  }

  // ── Carga inicial ─────────────────────────────────────────────────────────

  Future<List<MensajeModel>> _cargarMensajes() async {
    final mensajes = await _social.mensajes(_targetUserId);
    if (mensajes == null) return [];
    _recordarUltimo(mensajes);
    return mensajes..sort(_masNuevoPrimero);
  }

  static int _masNuevoPrimero(MensajeModel a, MensajeModel b) => b.timestamp.compareTo(a.timestamp);

  void _recordarUltimo(Iterable<MensajeModel> confirmados) {
    for (final m in confirmados) {
      if (m.timestamp.compareTo(_ultimoDelServidor) > 0) _ultimoDelServidor = m.timestamp;
    }
  }

  // ── Sondeo de novedades ───────────────────────────────────────────────────
  // Pide los mensajes desde el último que el servidor confirmó (incluido, para no perder los que
  // comparten el mismo instante) y descarta los que ya están por id.

  Future<void> _sondear() async {
    final actual = state.asData?.value;
    if (actual == null || !ref.mounted) return;
    final nuevos = await _social.mensajes(
      _targetUserId,
      desde: _ultimoDelServidor.isEmpty ? null : _ultimoDelServidor,
    );
    if (nuevos == null || !ref.mounted) return;
    _recordarUltimo(nuevos);
    final vigente = state.asData?.value ?? actual;
    final ids = vigente.map((m) => m.id).toSet();
    final aAgregar = nuevos.where((m) => !ids.contains(m.id)).toList();
    if (aAgregar.isEmpty) return;
    state = AsyncData([...vigente, ...aAgregar]..sort(_masNuevoPrimero));
  }

  // ── Enviar mensaje ─────────────────────────────────────────────────────────
  // Optimistic update: el mensaje propio aparece de inmediato en la UI y, al confirmarlo el
  // servidor, se sustituye por la versión guardada (con su fecha). Si falla, se retira.

  Future<bool> enviar(
    String content, {
    String tipo = 'texto',
    String propiedadId = '',
  }) async {
    if (content.trim().isEmpty) return false;

    final msg = MensajeModel(
      id: const Uuid().v4(),
      senderId: _currentUserId,
      receiverId: _targetUserId,
      content: content.trim(),
      timestamp: DateTime.now().toUtc().toIso8601String(),
      tipo: tipo,
      propiedadId: propiedadId,
    );

    state = AsyncData([msg, ...state.asData?.value ?? []]);

    MensajeModel? guardado;
    try {
      guardado = await _social.enviarMensaje(msg);
    } catch (e) {
      debugPrintLevels(1, 'MensajesChatNotifier.enviar: $e');
    }
    if (!ref.mounted) return guardado != null;

    final actual = state.asData?.value ?? [];
    if (guardado == null) {
      state = AsyncData(actual.where((m) => m.id != msg.id).toList());
      return false;
    }
    _recordarUltimo([guardado]);
    state = AsyncData([for (final m in actual) m.id == msg.id ? guardado : m]..sort(_masNuevoPrimero));
    return true;
  }
}
