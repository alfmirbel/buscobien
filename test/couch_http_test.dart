import 'dart:convert';

import 'package:buscobien/10_user_login/usuario_login/session_storage.dart';
import 'package:buscobien/40_security/api_client.dart';
import 'package:buscobien/40_security/couch_http.dart' as couch;
import 'package:buscobien/40_security/direccionip.dart';
import 'package:buscobien/40_security/token_store.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

class _Almacen implements SessionStorage {
  final datos = <String, String>{};
  @override
  Future<void> delete({required String key}) async => datos.remove(key);
  @override
  Future<void> deleteAll() async => datos.clear();
  @override
  Future<String?> read({required String key}) async => datos[key];
  @override
  Future<void> write({required String key, required String value}) async => datos[key] = value;
}

class _AlmacenRoto extends _Almacen {
  @override
  Future<String?> read({required String key}) async => throw StateError('llavero no disponible');
}

String _jwt(DateTime exp) {
  String p(Object o) => base64Url.encode(utf8.encode(jsonEncode(o))).replaceAll('=', '');
  return '${p({'alg': 'RS256'})}.${p({'exp': exp.millisecondsSinceEpoch ~/ 1000})}.firma';
}

http.Response _json(Object o, [int s = 200]) => http.Response(jsonEncode(o), s);

void main() {
  late _Almacen almacen;
  late TokenStore tokens;
  late ApiClient api;
  late couch.CouchHttp cliente;

  setUp(() {
    almacen = _Almacen();
    tokens = TokenStore(almacen);
    api = ApiClient(baseUrl: apiBaseUrl, tokens: tokens);
    cliente = couch.CouchHttp(tokens, api);
  });

  Future<T> con<T>(MockClient c, Future<T> Function() f) => http.runWithClient(f, () => c);
  final url = Uri.parse('$dbBaseUrl/buscobien_publicados_normal');

  test('con sesión añade el token y descarta cualquier Authorization que pase quien llama', () async {
    final acceso = _jwt(DateTime.now().add(const Duration(minutes: 15)));
    await tokens.guardar(accessToken: acceso, refreshToken: 'r1');
    late http.Request recibida;
    final mock = MockClient((req) async {
      recibida = req;
      return _json({'ok': true});
    });
    await con(mock, () => cliente.get(url, headers: {'Authorization': 'Basic admin:secreto', 'Content-Type': 'application/json'}));
    expect(recibida.headers['Authorization'], 'Bearer $acceso');
    expect(recibida.headers['Content-Type'], 'application/json');
  });

  test('sin sesión va como visitante (sin cabecera Authorization)', () async {
    late http.Request recibida;
    final mock = MockClient((req) async {
      recibida = req;
      return _json({'ok': true});
    });
    final r = await con(mock, () => cliente.get(url, headers: {'Authorization': 'Basic x'}));
    expect(r.statusCode, 200);
    expect(recibida.headers.containsKey('Authorization'), isFalse);
  });

  test('renueva antes de enviar si el token de acceso venció', () async {
    almacen.datos[TokenStore.claveRenovacion] = 'r1';
    final rutas = <String>[];
    final mock = MockClient((req) async {
      rutas.add(req.url.path);
      if (req.url.path == '/auth/refresh') {
        return _json({'accessToken': _jwt(DateTime.now().add(const Duration(minutes: 15))), 'refreshToken': 'r2'});
      }
      return _json({'ok': true});
    });
    await con(mock, () => cliente.get(url));
    expect(rutas, ['/auth/refresh', '/db/buscobien_publicados_normal']);
    expect(tokens.refreshToken, 'r2');
  });

  test('si CouchDB rechaza el token (401 o 400) renueva una vez y repite', () async {
    await tokens.guardar(accessToken: _jwt(DateTime.now().add(const Duration(minutes: 15))), refreshToken: 'r1');
    for (final estado in [401, 400]) {
      var intentos = 0;
      final mock = MockClient((req) async {
        if (req.url.path == '/auth/refresh') {
          return _json({'accessToken': _jwt(DateTime.now().add(const Duration(minutes: 15))), 'refreshToken': 'r$estado'});
        }
        intentos += 1;
        return intentos == 1 ? _json({'error': 'unauthorized'}, estado) : _json({'ok': true});
      });
      final r = await con(mock, () => cliente.get(url));
      expect(r.statusCode, 200, reason: 'estado $estado');
      expect(intentos, 2);
    }
  });

  test('un 403 (falta de permiso) no dispara renovación', () async {
    await tokens.guardar(accessToken: _jwt(DateTime.now().add(const Duration(minutes: 15))), refreshToken: 'r1');
    var renovaciones = 0;
    final mock = MockClient((req) async {
      if (req.url.path == '/auth/refresh') renovaciones += 1;
      return _json({'error': 'forbidden'}, 403);
    });
    final r = await con(mock, () => cliente.put(url, body: '{}'));
    expect(r.statusCode, 403);
    expect(renovaciones, 0);
  });

  test('las URLs que no son de la pasarela se envían sin cambios', () async {
    await tokens.guardar(accessToken: _jwt(DateTime.now().add(const Duration(minutes: 15))), refreshToken: 'r1');
    late http.Request recibida;
    final mock = MockClient((req) async {
      recibida = req;
      return _json({});
    });
    await con(mock, () => cliente.get(Uri.parse('https://otro.example/x'), headers: {'X-Prueba': '1'}));
    expect(recibida.headers['X-Prueba'], '1');
    expect(recibida.headers.containsKey('Authorization'), isFalse);
  });

  test('POST, PUT y DELETE conservan el cuerpo', () async {
    final cuerpos = <String>[];
    final mock = MockClient((req) async {
      cuerpos.add('${req.method} ${req.body}');
      return _json({});
    });
    await con(mock, () async {
      await cliente.post(url, body: '{"a":1}');
      await cliente.put(url, body: '{"b":2}');
      await cliente.delete(url);
    });
    expect(cuerpos, ['POST {"a":1}', 'PUT {"b":2}', 'DELETE ']);
  });

  test('si el almacén seguro falla, trabaja como visitante en lugar de romper', () async {
    final roto = TokenStore(_AlmacenRoto());
    final c = couch.CouchHttp(roto, ApiClient(baseUrl: apiBaseUrl, tokens: roto));
    final mock = MockClient((req) async => _json({'ok': true}));
    final r = await con(mock, () => c.get(url));
    expect(r.statusCode, 200);
  });
}
