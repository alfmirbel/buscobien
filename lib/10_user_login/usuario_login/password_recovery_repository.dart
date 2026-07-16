import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../40_security/direccionip.dart';
import '../../40_security/generate_reset_token.dart';
import '../../60_global_widgets/debugprint.dart';

// ---------------------------------------------------------------------------
// Helpers internos
// ---------------------------------------------------------------------------

Map<String, String> get _authHeaders {
  final basicAuth =
      'Basic ${base64Encode(utf8.encode('$username:$password'))}';
  return {
    'Authorization': basicAuth,
    'Content-Type': 'application/json',
  };
}

String _getDatabase(String perfil) => switch (perfil) {
      'Promotor' => 'buscobien_usuarios_promotores',
      'Propietario' => 'buscobien_usuarios_propietarios',
      _ => 'buscobien_usuarios',
    };

// ---------------------------------------------------------------------------
// Buscar usuario por correo (Mango query)
// ---------------------------------------------------------------------------

/// Retorna `(docId, rev, nombreusuario)` si se encuentra, o null si no existe.
Future<({String docId, String rev, String nombre})?> buscarUsuarioPorCorreo(
  String correo,
  String perfil,
) async {
  final db = _getDatabase(perfil);
  final url = '$direccionip/$db/_find';

  final body = jsonEncode({
    'selector': {
      'usuario.correoelectronico': {'\$eq': correo},
    },
    'limit': 1,
  });

  try {
    final response = await http.post(
      Uri.parse(url),
      headers: _authHeaders,
      body: body,
    );

    if (response.statusCode != 200) {
      debugPrintLevels(0, 'buscarUsuarioPorCorreo HTTP ${response.statusCode}');
      return null;
    }

    final json = jsonDecode(utf8.decode(response.bodyBytes));
    final docs = json['docs'] as List?;
    if (docs == null || docs.isEmpty) return null;

    final doc = docs.first as Map<String, dynamic>;
    final docId = doc['_id'] as String? ?? '';
    final rev = doc['_rev'] as String? ?? '';
    final nombre =
        (doc['usuario']?['nombreusuario'] as String?) ?? '';

    return (docId: docId, rev: rev, nombre: nombre);
  } catch (e) {
    debugPrintLevels(0, 'buscarUsuarioPorCorreo error: $e');
    return null;
  }
}

// ---------------------------------------------------------------------------
// Guardar token de recuperación en el documento
// ---------------------------------------------------------------------------

Future<bool> guardarTokenRecuperacion(
  String docId,
  String perfil,
  String token,
  String expiry,
) async {
  final db = _getDatabase(perfil);

  // GET para obtener la versión actualizada del doc
  final getUrl = '$direccionip/$db/$docId';
  try {
    final getResp =
        await http.get(Uri.parse(getUrl), headers: _authHeaders);
    if (getResp.statusCode != 200) return false;

    final doc = jsonDecode(utf8.decode(getResp.bodyBytes)) as Map<String, dynamic>;
    final rev = doc['_rev'] as String;

    // Merging token fields
    final usuario = (doc['usuario'] as Map<String, dynamic>)
      ..['reset_token'] = token
      ..['token_expiry'] = expiry;
    doc['usuario'] = usuario;

    final putUrl = '$direccionip/$db/$docId';
    final putResp = await http.put(
      Uri.parse(putUrl),
      headers: {
        ..._authHeaders,
        'If-Match': rev,
      },
      body: jsonEncode(doc),
    );

    return putResp.statusCode == 200 || putResp.statusCode == 201;
  } catch (e) {
    debugPrintLevels(0, 'guardarTokenRecuperacion error: $e');
    return false;
  }
}

// ---------------------------------------------------------------------------
// Validar token (Mango query por reset_token)
// ---------------------------------------------------------------------------

/// Retorna `(docId, rev)` si el token es válido y no expiró, o null si inválido.
Future<({String docId, String rev})?> validarToken(
  String token,
  String perfil,
) async {
  final db = _getDatabase(perfil);
  final url = '$direccionip/$db/_find';

  final body = jsonEncode({
    'selector': {
      'usuario.reset_token': {'\$eq': token},
    },
    'limit': 1,
  });

  try {
    final response = await http.post(
      Uri.parse(url),
      headers: _authHeaders,
      body: body,
    );

    if (response.statusCode != 200) return null;

    final json = jsonDecode(utf8.decode(response.bodyBytes));
    final docs = json['docs'] as List?;
    if (docs == null || docs.isEmpty) return null;

    final doc = docs.first as Map<String, dynamic>;
    final tokenExpiry =
        doc['usuario']?['token_expiry'] as String? ?? '';

    if (!isTokenValid(tokenExpiry)) return null;

    return (
      docId: doc['_id'] as String? ?? '',
      rev: doc['_rev'] as String? ?? '',
    );
  } catch (e) {
    debugPrintLevels(0, 'validarToken error: $e');
    return null;
  }
}

// ---------------------------------------------------------------------------
// Actualizar contraseña y limpiar token
// ---------------------------------------------------------------------------

Future<bool> actualizarPassword(
  String docId,
  String perfil,
  String nuevoPasswordHash,
) async {
  final db = _getDatabase(perfil);
  final getUrl = '$direccionip/$db/$docId';

  try {
    final getResp =
        await http.get(Uri.parse(getUrl), headers: _authHeaders);
    if (getResp.statusCode != 200) return false;

    final doc = jsonDecode(utf8.decode(getResp.bodyBytes)) as Map<String, dynamic>;
    final rev = doc['_rev'] as String;

    final usuario = doc['usuario'] as Map<String, dynamic>;
    usuario['claveacceso'] = nuevoPasswordHash;
    usuario.remove('reset_token');
    usuario.remove('token_expiry');
    doc['usuario'] = usuario;

    final putResp = await http.put(
      Uri.parse('$direccionip/$db/$docId'),
      headers: {
        ..._authHeaders,
        'If-Match': rev,
      },
      body: jsonEncode(doc),
    );

    return putResp.statusCode == 200 || putResp.statusCode == 201;
  } catch (e) {
    debugPrintLevels(0, 'actualizarPassword error: $e');
    return false;
  }
}

// ---------------------------------------------------------------------------
// Enviar correo via microservicio Node.js
// ---------------------------------------------------------------------------

const String _mailerUrl =
    'http://citigov.cloud:3001/api/enviar-correo-recuperacion';

Future<bool> enviarCorreoRecuperacion({
  required String email,
  required String nombreUsuario,
  required String resetToken,
  required String perfil,
}) async {
  try {
    final response = await http.post(
      Uri.parse(_mailerUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'nombreUsuario': nombreUsuario,
        'resetToken': resetToken,
        'perfil': perfil,
      }),
    );

    return response.statusCode == 200;
  } catch (e) {
    debugPrintLevels(0, 'enviarCorreoRecuperacion error: $e');
    return false;
  }
}
