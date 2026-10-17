import 'dart:convert';

import 'package:http/http.dart' as http;
// Todo lo demás de package:http (Response, Client, Request...) se reexporta tal cual.
export 'package:http/http.dart' hide get, post, put, delete;

import 'api_client.dart';
import 'direccionip.dart';
import 'token_store.dart';

/// Acceso a CouchDB **a través de nginx** (`https://api.buscobien.net/db`) con el token de la
/// sesión. Sustituye a `package:http` en los módulos que consultan bases de datos:
///
/// ```dart
/// import '../../40_security/couch_http.dart' as http;
/// final r = await http.get(Uri.parse('$dbBaseUrl/buscobien_publicados_normal/...'));
/// ```
///
/// - Añade `Authorization: Bearer <token>` si hay sesión (sin sesión la petición va como visitante,
///   que solo puede leer el catálogo y los datos de referencia).
/// - Renueva el token antes de enviar si venció, y una vez más si el servidor lo rechaza
///   (CouchDB responde `401` o `400` ante un token vencido o inválido).
/// - Ignora cualquier `Authorization` que pase quien llama: las credenciales de administrador
///   ya no viajan desde la app.
/// - Las URLs que no son de la pasarela se envían sin cambios.
class CouchHttp {
  CouchHttp(this._tokens, this._api, {this.base = dbBaseUrl});

  final TokenStore _tokens;
  final ApiClient _api;
  final String base;

  bool _esDeLaPasarela(Uri url) => url.toString().startsWith(base);

  Future<http.Response> _enviar(
    String metodo,
    Uri url,
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
  ) async {
    Future<http.Response> una(Map<String, String> cabeceras) {
      switch (metodo) {
        case 'GET':
          return http.get(url, headers: cabeceras);
        case 'POST':
          return http.post(url, headers: cabeceras, body: body, encoding: encoding);
        case 'PUT':
          return http.put(url, headers: cabeceras, body: body, encoding: encoding);
        default:
          return http.delete(url, headers: cabeceras, body: body, encoding: encoding);
      }
    }

    if (!_esDeLaPasarela(url)) return una(headers ?? const {});

    final limpias = <String, String>{
      for (final e in (headers ?? const <String, String>{}).entries)
        if (e.key.toLowerCase() != 'authorization') e.key: e.value,
    };

    await _tokens.cargar();
    if (_tokens.haySesion && !_tokens.accesoVigente) await _api.renovarSesion();

    var respuesta = await una({...limpias, ..._tokens.authHeaders});
    final huboToken = _tokens.authHeaders.isNotEmpty;
    if (huboToken && _tokens.haySesion && (respuesta.statusCode == 401 || respuesta.statusCode == 400)) {
      // Con un token válido CouchDB responde 403 cuando falta permiso; 401/400 indica un token
      // vencido o inválido: se renueva una vez y se repite.
      if (await _api.renovarSesion()) respuesta = await una({...limpias, ..._tokens.authHeaders});
    }
    return respuesta;
  }

  Future<http.Response> get(Uri url, {Map<String, String>? headers}) =>
      _enviar('GET', url, headers, null, null);

  Future<http.Response> post(Uri url, {Map<String, String>? headers, Object? body, Encoding? encoding}) =>
      _enviar('POST', url, headers, body, encoding);

  Future<http.Response> put(Uri url, {Map<String, String>? headers, Object? body, Encoding? encoding}) =>
      _enviar('PUT', url, headers, body, encoding);

  Future<http.Response> delete(Uri url, {Map<String, String>? headers, Object? body, Encoding? encoding}) =>
      _enviar('DELETE', url, headers, body, encoding);
}

/// Instancia única de la app.
final CouchHttp couchHttp = CouchHttp(tokenStore, apiClient);

Future<http.Response> get(Uri url, {Map<String, String>? headers}) => couchHttp.get(url, headers: headers);

Future<http.Response> post(Uri url, {Map<String, String>? headers, Object? body, Encoding? encoding}) =>
    couchHttp.post(url, headers: headers, body: body, encoding: encoding);

Future<http.Response> put(Uri url, {Map<String, String>? headers, Object? body, Encoding? encoding}) =>
    couchHttp.put(url, headers: headers, body: body, encoding: encoding);

Future<http.Response> delete(Uri url, {Map<String, String>? headers, Object? body, Encoding? encoding}) =>
    couchHttp.delete(url, headers: headers, body: body, encoding: encoding);
