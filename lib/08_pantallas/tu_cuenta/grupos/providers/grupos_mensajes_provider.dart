import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import 'package:buscobien/08_pantallas/tu_cuenta/grupos/models/mensaje_grupo_model.dart';
import 'package:buscobien/08_pantallas/tu_cuenta/social_api.dart';
import 'package:buscobien/08_pantallas/tu_cuenta/sondeo.dart';
import 'package:buscobien/60_global_widgets/debugprint.dart';

// =============================================================================
// PROVIDER DE MENSAJES DEL CHAT GRUPAL (Riverpod 3.x)
// =============================================================================
// Los mensajes viven en buscobien_grupos_mensajes, una base cerrada a los clientes: se leen y
// escriben por buscobien-api (/grupos/:id/mensajes). Solo los miembros del grupo tienen acceso.
//
// Uso: ref.watch(mensajesGrupoProvider(grupoId))
//      ref.read(mensajesGrupoProvider(grupoId).notifier).enviar(...)

final mensajesGrupoProvider = AsyncNotifierProvider.family<
    MensajesGrupoNotifier, List<MensajeGrupoModel>, String>(
  (grupoId) => MensajesGrupoNotifier(grupoId),
);

// =============================================================================
// NOTIFIER
// =============================================================================

class MensajesGrupoNotifier extends AsyncNotifier<List<MensajeGrupoModel>> {
  MensajesGrupoNotifier(this._grupoId, {SocialApi? api, Duration intervalo = const Duration(seconds: 3)})
      : _api = api,
        _intervalo = intervalo;

  final String _grupoId;
  final SocialApi? _api;
  final Duration _intervalo;
  SocialApi get _social => _api ?? socialApi;

  /// Fecha del mensaje más reciente que el servidor ya confirmó; punto de partida del sondeo.
  String _ultimoDelServidor = '';

  @override
  Future<List<MensajeGrupoModel>> build() async {
    // El sondeo corre solo mientras alguna pantalla escucha el chat.
    final sondeo = Sondeo(_sondear, intervalo: _intervalo);
    sondeo.atarA(ref);

    final mensajes = await _cargarMensajes();
    if (ref.mounted) sondeo.iniciarSiHayOyentes();
    return mensajes;
  }

  static int _masNuevoPrimero(MensajeGrupoModel a, MensajeGrupoModel b) => b.timestamp.compareTo(a.timestamp);

  void _recordarUltimo(Iterable<MensajeGrupoModel> confirmados) {
    for (final m in confirmados) {
      if (m.timestamp.compareTo(_ultimoDelServidor) > 0) _ultimoDelServidor = m.timestamp;
    }
  }

  // ── Carga inicial ─────────────────────────────────────────────────────────

  Future<List<MensajeGrupoModel>> _cargarMensajes() async {
    final mensajes = await _social.mensajesGrupo(_grupoId);
    if (mensajes == null) return [];
    _recordarUltimo(mensajes);
    return mensajes..sort(_masNuevoPrimero);
  }

  // ── Sondeo de novedades ───────────────────────────────────────────────────

  Future<void> _sondear() async {
    final actual = state.asData?.value;
    if (actual == null || !ref.mounted) return;
    final nuevos = await _social.mensajesGrupo(
      _grupoId,
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
  // Optimistic update; al confirmarlo el servidor se sustituye por la versión guardada y, si falla,
  // el mensaje se retira. El remitente y su nombre los toma el servidor de la sesión y del grupo.

  Future<bool> enviar({
    required String senderId,
    required String senderName,
    required String content,
    String tipo = 'texto',
    String propiedadId = '',
  }) async {
    if (content.trim().isEmpty) return false;

    final msg = MensajeGrupoModel(
      id: const Uuid().v4(),
      senderId: senderId,
      senderName: senderName,
      grupoId: _grupoId,
      content: content.trim(),
      timestamp: DateTime.now().toUtc().toIso8601String(),
      tipo: tipo,
      propiedadId: propiedadId,
    );

    state = AsyncData([msg, ...state.asData?.value ?? []]);

    MensajeGrupoModel? guardado;
    try {
      guardado = await _social.enviarMensajeGrupo(msg);
    } catch (e) {
      debugPrintLevels(1, 'MensajesGrupoNotifier.enviar: $e');
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

  // ── Marcar mensajes como leídos ───────────────────────────────────────────
  // Llamar solo al abrir el chat: una sola petición marca los mensajes de los demás.

  Future<void> marcarMensajesLeidos(String currentUserId) async {
    final noLeidos = (state.asData?.value ?? []).where((m) => !m.leido && m.senderId != currentUserId);
    if (noLeidos.isEmpty) return;
    try {
      if (!await _social.marcarLeidosGrupo(_grupoId) || !ref.mounted) return;
      final ids = noLeidos.map((m) => m.id).toSet();
      state = AsyncData([
        for (final m in state.asData?.value ?? <MensajeGrupoModel>[])
          if (ids.contains(m.id)) (m..leido = true) else m,
      ]);
    } catch (e) {
      debugPrintLevels(1, 'marcarMensajesLeidos: $e');
    }
  }
}
