import '../../40_security/api_client.dart';
import '../../60_global_widgets/debugprint.dart';
import 'conocidos/mensaje_model.dart';
import 'grupos/models/mensaje_grupo_model.dart';
import 'grupos/models/publicacion_grupo_model.dart';

/// Resultado de publicar una propiedad en un grupo.
enum ResultadoPublicar { publicada, duplicada, error }

/// Chat, publicaciones de grupo y propiedades de listas compartidas, servidos por buscobien-api.
///
/// Esas bases están cerradas a los clientes: el servidor decide quién lee y quién escribe, y pone el
/// remitente y la fecha. Las lecturas devuelven `null` si falla la petición, para distinguir
/// «sin mensajes» de «no se pudo consultar».
class SocialApi {
  SocialApi({ApiClient? api}) : _api = api ?? apiClient;

  final ApiClient _api;

  List<T>? _lista<T>(ApiResponse r, String campo, T Function(Map<String, dynamic>) desde) {
    final datos = r.json?[campo];
    if (!r.ok || datos is! List) {
      debugPrintLevels(1, 'SocialApi $campo: HTTP ${r.status} ${r.code}');
      return null;
    }
    return datos.whereType<Map<String, dynamic>>().map(desde).toList();
  }

  // ---- chat privado -------------------------------------------------------------------------
  /// Mensajes con [con], del más nuevo al más viejo. Con [desde] solo los de esa fecha en adelante.
  Future<List<MensajeModel>?> mensajes(String con, {String? desde, int limite = 200}) async {
    final r = await _api.get(
      '/mensajes/con/${Uri.encodeComponent(con)}',
      query: {'limite': '$limite', if (desde != null && desde.isNotEmpty) 'desde': desde},
    );
    return _lista(r, 'mensajes', MensajeModel.fromJson);
  }

  /// Devuelve el mensaje tal como quedó guardado (con la fecha del servidor) o `null` si falló.
  Future<MensajeModel?> enviarMensaje(MensajeModel m) async {
    final r = await _api.post(
      '/mensajes',
      cuerpo: {
        if (m.id.isNotEmpty) 'id': m.id,
        'receiverId': m.receiverId,
        'content': m.content,
        'tipo': m.tipo,
        'propiedadId': m.propiedadId,
        'listaCompartidaId': m.listaCompartidaId,
      },
    );
    final msg = r.json?['mensaje'];
    if (!r.ok || msg is! Map<String, dynamic>) {
      debugPrintLevels(1, 'SocialApi.enviarMensaje: HTTP ${r.status} ${r.code}');
      return null;
    }
    return MensajeModel.fromJson(msg);
  }

  // ---- chat de grupo ------------------------------------------------------------------------
  Future<List<MensajeGrupoModel>?> mensajesGrupo(String grupoId, {String? desde, int limite = 300}) async {
    final r = await _api.get(
      '/grupos/${Uri.encodeComponent(grupoId)}/mensajes',
      query: {'limite': '$limite', if (desde != null && desde.isNotEmpty) 'desde': desde},
    );
    return _lista(r, 'mensajes', MensajeGrupoModel.fromJson);
  }

  Future<MensajeGrupoModel?> enviarMensajeGrupo(MensajeGrupoModel m) async {
    final r = await _api.post(
      '/grupos/${Uri.encodeComponent(m.grupoId)}/mensajes',
      cuerpo: {
        if (m.id.isNotEmpty) 'id': m.id,
        'content': m.content,
        'tipo': m.tipo,
        'propiedadId': m.propiedadId,
        'listaCompartidaId': m.listaCompartidaId,
      },
    );
    final msg = r.json?['mensaje'];
    if (!r.ok || msg is! Map<String, dynamic>) {
      debugPrintLevels(1, 'SocialApi.enviarMensajeGrupo: HTTP ${r.status} ${r.code}');
      return null;
    }
    return MensajeGrupoModel.fromJson(msg);
  }

  Future<bool> marcarLeidosGrupo(String grupoId) async {
    final r = await _api.post('/grupos/${Uri.encodeComponent(grupoId)}/mensajes/leidos', cuerpo: const {});
    return r.ok;
  }

  // ---- publicaciones de grupo ---------------------------------------------------------------
  Future<List<PublicacionGrupoModel>?> publicaciones(String grupoId, {int saltar = 0, int limite = 10}) async {
    final r = await _api.get(
      '/grupos/${Uri.encodeComponent(grupoId)}/publicaciones',
      query: {'saltar': '$saltar', 'limite': '$limite'},
    );
    return _lista(r, 'publicaciones', PublicacionGrupoModel.fromJson);
  }

  Future<(ResultadoPublicar, PublicacionGrupoModel?)> publicar({
    required String grupoId,
    required String propiedadId,
    required String propiedadNombre,
    required String tipodeespacio,
  }) async {
    final r = await _api.post(
      '/grupos/${Uri.encodeComponent(grupoId)}/publicaciones',
      cuerpo: {'propiedadId': propiedadId, 'propiedadNombre': propiedadNombre, 'tipodeespacio': tipodeespacio},
    );
    final pub = r.json?['publicacion'];
    if (r.ok && pub is Map<String, dynamic>) return (ResultadoPublicar.publicada, PublicacionGrupoModel.fromJson(pub));
    if (r.status == 409) return (ResultadoPublicar.duplicada, null);
    debugPrintLevels(1, 'SocialApi.publicar: HTTP ${r.status} ${r.code}');
    return (ResultadoPublicar.error, null);
  }

  Future<bool> quitarPublicacion(String grupoId, String id) async {
    final r = await _api.delete('/grupos/${Uri.encodeComponent(grupoId)}/publicaciones/${Uri.encodeComponent(id)}');
    return r.ok;
  }

  // ---- propiedades de una lista compartida --------------------------------------------------
  /// Propiedades de la lista compartida: `[{id, propertyId, tipodeespacio, timestamp}]`.
  Future<List<Map<String, dynamic>>?> propiedadesDeLista(String listaCompartidaId) async {
    final r = await _api.get('/listas-compartidas/${Uri.encodeComponent(listaCompartidaId)}/propiedades');
    return _lista(r, 'propiedades', (m) => m);
  }

  /// Copia a la lista compartida las propiedades de la lista de origen de quien comparte.
  Future<bool> copiarPropiedades(String listaCompartidaId) async {
    final r = await _api.post(
      '/listas-compartidas/${Uri.encodeComponent(listaCompartidaId)}/propiedades',
      cuerpo: const {},
    );
    return r.ok;
  }

  Future<bool> borrarPropiedades(String listaCompartidaId) async {
    final r = await _api.delete('/listas-compartidas/${Uri.encodeComponent(listaCompartidaId)}/propiedades');
    return r.ok;
  }
}

/// Instancia única de la app.
final SocialApi socialApi = SocialApi();
