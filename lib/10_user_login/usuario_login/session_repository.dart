import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../40_security/api_client.dart';
import '../data_models/data_get_user.dart';

part 'session_repository.g.dart';

class SessionRepository {
  SessionRepository({ApiClient? api}) : _api = api ?? apiClient;

  final ApiClient _api;

  /// Datos del usuario con sesión, desde `GET /usuarios/me` de buscobien-api.
  ///
  /// Devuelve el código HTTP y, si salió bien, los datos con la misma forma que usaba la vista de
  /// CouchDB (`GetUserData`). El servidor nunca envía la clave, por lo que `claveacceso` va vacía.
  Future<(int, GetUserData?)> getUserDataByName({
    required String userName,
    required String nombrePerfil,
  }) async {
    final r = await _api.get('/usuarios/me');
    final cuerpo = r.json;
    final usuario = cuerpo?['usuario'];
    if (!r.ok || cuerpo == null || usuario is! Map || cuerpo['id'] is! String) {
      return (r.sinRed ? 500 : (r.status == 0 ? 500 : r.status), null);
    }
    final id = cuerpo['id'] as String;
    try {
      final datos = GetUserData.fromJson({
        'total_rows': 1,
        'offset': 0,
        'rows': [
          {
            'id': id,
            'key': userName,
            'value': {
              '_id': id,
              '_rev': '',
              'usuario': {...Map<String, dynamic>.from(usuario), 'claveacceso': ''},
            },
          },
        ],
      });
      return (200, datos);
    } catch (_) {
      return (500, null); // documento con campos que el modelo no reconoce
    }
  }
}

@riverpod
SessionRepository sessionRepository(Ref ref) {
  return SessionRepository();
}
