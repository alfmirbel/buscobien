import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:buscobien/08_pantallas/tu_cuenta/grupos/models/publicacion_grupo_model.dart';
import 'package:buscobien/08_pantallas/tu_cuenta/social_api.dart';
import 'package:buscobien/60_global_widgets/debugprint.dart';

// =============================================================================
// PROVIDER — PUBLICACIONES DE PROPIEDADES EN GRUPOS
// =============================================================================
// Base buscobien_grupos_publicaciones, cerrada a los clientes: se usa por buscobien-api
// (/grupos/:id/publicaciones). El autor y su nombre los toma el servidor de la sesión.

const int _pageSize = 10;

// Patrón Riverpod 3.x: factory recibe el arg y lo pasa al constructor.
final publicacionesGrupoProvider = AsyncNotifierProvider.family<
    PublicacionesGrupoNotifier, List<PublicacionGrupoModel>, String>(
  (grupoId) => PublicacionesGrupoNotifier(grupoId),
);

class PublicacionesGrupoNotifier
    extends AsyncNotifier<List<PublicacionGrupoModel>> {
  PublicacionesGrupoNotifier(this._grupoId, {SocialApi? api}) : _api = api;

  final String _grupoId;
  final SocialApi? _api;
  SocialApi get _social => _api ?? socialApi;
  int _skip = 0;
  bool _hayMas = true;

  bool get hayMas => _hayMas;

  @override
  Future<List<PublicacionGrupoModel>> build() async {
    _skip = 0;
    _hayMas = true;
    return _fetch(0);
  }

  Future<List<PublicacionGrupoModel>> _fetch(int skip) async {
    try {
      final docs = await _social.publicaciones(_grupoId, saltar: skip, limite: _pageSize);
      if (docs == null) return [];
      if (docs.length < _pageSize) _hayMas = false;
      return docs;
    } catch (e) {
      debugPrintLevels(1, 'PublicacionesGrupoNotifier._fetch exception: $e');
      return [];
    }
  }

  Future<void> cargarMas() async {
    if (!_hayMas) return;
    _skip += _pageSize;
    final actuales = state.value ?? [];
    final nuevas = await _fetch(_skip);
    if (!ref.mounted) return;
    state = AsyncValue.data([...actuales, ...nuevas]);
  }

  /// `false` si ya se había publicado esa propiedad o si falla. [autorId] y [autorNombre] se
  /// conservan por compatibilidad: el servidor usa los de la sesión.
  Future<bool> compartirPropiedad({
    required String propiedadId,
    required String propiedadNombre,
    required String tipodeespacio,
    required String autorId,
    required String autorNombre,
  }) async {
    try {
      final (resultado, pub) = await _social.publicar(
        grupoId: _grupoId,
        propiedadId: propiedadId,
        propiedadNombre: propiedadNombre,
        tipodeespacio: tipodeespacio,
      );
      if (resultado != ResultadoPublicar.publicada || pub == null || !ref.mounted) {
        return resultado == ResultadoPublicar.publicada;
      }
      state = AsyncValue.data([pub, ...state.value ?? []]);
      return true;
    } catch (e) {
      debugPrintLevels(1, 'compartirPropiedad exception: $e');
      return false;
    }
  }

  Future<bool> quitarPublicacion(PublicacionGrupoModel pub) async {
    try {
      if (!await _social.quitarPublicacion(_grupoId, pub.id) || !ref.mounted) return false;
      state = AsyncValue.data((state.value ?? []).where((p) => p.id != pub.id).toList());
      return true;
    } catch (e) {
      debugPrintLevels(1, 'quitarPublicacion exception: $e');
      return false;
    }
  }
}
