import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../60_global_widgets/debugprint.dart';
import 'direccionip.dart';
import 'token_store.dart';

/// Respuesta de buscobien-api. Los errores del servicio llegan como `{ error, code }`.
class ApiResponse {
  const ApiResponse(this.status, this.data);

  /// Código HTTP; `0` si no hubo respuesta (sin red o tiempo agotado).
  final int status;
  final dynamic data;

  bool get ok => status >= 200 && status < 300;
  bool get sinRed => status == 0;
  Map<String, dynamic>? get json => data is Map<String, dynamic> ? data as Map<String, dynamic> : null;
  String get code => (json?['code'] as String?) ?? (sinRed ? 'NETWORK' : '');
  String get mensaje => (json?['error'] as String?) ?? '';
}

/// Cliente único de buscobien-api: añade el token de acceso, aplica un tiempo máximo y
/// renueva la sesión una sola vez cuando el servidor la rechaza.
///
/// Usa las funciones de `package:http`, por lo que las pruebas pueden sustituir el cliente con
/// `http.runWithClient`.
class ApiClient {
  ApiClient({required this.baseUrl, required this.tokens, this.timeout = const Duration(seconds: 10)});

  final String baseUrl;
  final TokenStore tokens;
  final Duration timeout;

  /// Se llama cuando la sesión ya no se puede recuperar (renovación rechazada): la app debe
  /// volver al estado «sin sesión».
  Future<void> Function()? alExpirarSesion;

  Future<bool>? _renovando;

  Future<ApiResponse> get(String ruta, {Map<String, String>? query, bool auth = true}) =>
      _enviar('GET', ruta, query: query, auth: auth);

  Future<ApiResponse> post(String ruta, {Object? cuerpo, bool auth = true}) =>
      _enviar('POST', ruta, cuerpo: cuerpo, auth: auth);

  Future<ApiResponse> put(String ruta, {Object? cuerpo, bool auth = true}) =>
      _enviar('PUT', ruta, cuerpo: cuerpo, auth: auth);

  Future<ApiResponse> delete(String ruta, {bool auth = true}) => _enviar('DELETE', ruta, auth: auth);

  Future<ApiResponse> _enviar(
    String metodo,
    String ruta, {
    Object? cuerpo,
    Map<String, String>? query,
    bool auth = true,
  }) async {
    if (auth) {
      await tokens.cargar();
      // Renovación preventiva: evita una petición que se sabe que será rechazada.
      if (!tokens.accesoVigente && tokens.haySesion) await _renovar();
    }
    var respuesta = await _una(metodo, ruta, cuerpo, query, auth);
    if (auth && _sesionRechazada(respuesta) && tokens.haySesion) {
      if (await _renovar()) respuesta = await _una(metodo, ruta, cuerpo, query, auth);
    }
    return respuesta;
  }

  bool _sesionRechazada(ApiResponse r) =>
      r.status == 401 && (r.code == 'INVALID_TOKEN' || r.code == 'MISSING_TOKEN');

  /// Una sola renovación a la vez: las peticiones simultáneas esperan la misma (el servidor
  /// interpretaría dos renovaciones con el mismo token como un robo y cerraría la sesión).
  Future<bool> _renovar() => _renovando ??= _hacerRenovacion().whenComplete(() => _renovando = null);

  Future<bool> _hacerRenovacion() async {
    final renovacion = tokens.refreshToken;
    if (renovacion.isEmpty) return false;
    final r = await _una('POST', '/auth/refresh', {'refreshToken': renovacion}, null, false);
    final datos = r.json;
    if (r.ok && datos?['accessToken'] is String && datos?['refreshToken'] is String) {
      await tokens.guardar(
        accessToken: datos!['accessToken'] as String,
        refreshToken: datos['refreshToken'] as String,
      );
      return true;
    }
    if (r.status == 400 || r.status == 401) {
      // El servidor rechazó la renovación: la sesión terminó.
      await tokens.limpiar();
      await alExpirarSesion?.call();
    }
    return false; // sin red u otro error: se conserva la sesión para reintentar
  }

  Future<ApiResponse> _una(
    String metodo,
    String ruta,
    Object? cuerpo,
    Map<String, String>? query,
    bool auth,
  ) async {
    try {
      final uri = Uri.parse('$baseUrl$ruta').replace(queryParameters: query);
      final cabeceras = <String, String>{
        'Accept': 'application/json',
        if (cuerpo != null) 'Content-Type': 'application/json',
        if (auth) ...tokens.authHeaders,
      };
      final texto = cuerpo == null ? null : jsonEncode(cuerpo);
      final http.Response res = switch (metodo) {
        'GET' => await http.get(uri, headers: cabeceras).timeout(timeout),
        'POST' => await http.post(uri, headers: cabeceras, body: texto).timeout(timeout),
        'PUT' => await http.put(uri, headers: cabeceras, body: texto).timeout(timeout),
        'DELETE' => await http.delete(uri, headers: cabeceras).timeout(timeout),
        _ => throw ArgumentError('Método no soportado: $metodo'),
      };
      dynamic datos;
      if (res.bodyBytes.isNotEmpty) {
        try {
          datos = jsonDecode(utf8.decode(res.bodyBytes));
        } catch (_) {
          datos = null;
        }
      }
      return ApiResponse(res.statusCode, datos);
    } catch (e) {
      debugPrintLevels(1, 'ApiClient $metodo $ruta sin respuesta: $e');
      return const ApiResponse(0, null);
    }
  }
}

/// Instancia única de la app.
final ApiClient apiClient = ApiClient(baseUrl: apiBaseUrl, tokens: tokenStore);
