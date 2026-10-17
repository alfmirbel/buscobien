import '../../../40_security/api_client.dart';

/// Usuarios que se pueden invitar, desde `GET /usuarios/buscar` de buscobien-api.
///
/// El servidor solo entrega nombre, foto y perfil (nunca correo, teléfono ni hash) y excluye a quien
/// consulta. Se devuelve con la forma que ya usan las pantallas (`{ 'usuario': {...} }`).
Future<List<Map<String, dynamic>>> buscarUsuariosPublicos({
  required String perfil,
  String q = '',
  int limite = 50,
  ApiClient? api,
}) async {
  final r = await (api ?? apiClient).get(
    '/usuarios/buscar',
    query: {'perfil': perfil, 'limit': '$limite', if (q.trim().isNotEmpty) 'q': q.trim()},
  );
  final datos = r.data;
  if (!r.ok || datos is! List) return [];
  return datos.whereType<Map<String, dynamic>>().map((u) {
    return {
      'usuario': {
        'id_usuario': (u['id'] as String?) ?? '',
        // El servidor ya junta nombres y apellido paterno en `nombre`.
        'nombres': (u['nombre'] as String?) ?? '',
        'apellidopaterno': '',
        'avatar': (u['foto'] as String?) ?? '',
      },
    };
  }).toList();
}
