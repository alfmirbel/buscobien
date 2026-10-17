import 'dart:convert';

import 'package:buscobien/10_user_login/usuario_login/auth_api.dart';
import 'package:buscobien/10_user_login/usuario_login/provider_session.dart';
import 'package:buscobien/10_user_login/usuario_login/session_storage.dart';
import 'package:buscobien/40_security/api_client.dart';
import 'package:buscobien/40_security/api_providers.dart';
import 'package:buscobien/40_security/token_store.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

class AlmacenFalso implements SessionStorage {
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

/// JWT de pruebas: solo importa la fecha de expiración.
String jwtCon(DateTime expira) {
  String parte(Object o) => base64Url.encode(utf8.encode(jsonEncode(o))).replaceAll('=', '');
  return '${parte({'alg': 'RS256'})}.${parte({'exp': expira.millisecondsSinceEpoch ~/ 1000, 'sub': 'u1'})}.firma';
}

http.Response json(Object cuerpo, [int estado = 200]) =>
    http.Response(jsonEncode(cuerpo), estado, headers: {'content-type': 'application/json'});

Map<String, dynamic> sesionServidor({String id = 'u1', DateTime? expira, String renovacion = 'r1'}) => {
  'accessToken': jwtCon(expira ?? DateTime.now().add(const Duration(minutes: 15))),
  'refreshToken': renovacion,
  'tokenType': 'Bearer',
  'expiresIn': 900,
  'user': {'id': id, 'nombre': 'Ana Pérez', 'foto': 'foto-1', 'perfil': 'Usuario'},
};

void main() {
  late AlmacenFalso almacen;
  late TokenStore tokens;
  late ApiClient api;

  setUp(() {
    almacen = AlmacenFalso();
    tokens = TokenStore(almacen);
    api = ApiClient(baseUrl: 'https://api.test', tokens: tokens);
  });

  Future<T> con<T>(MockClient cliente, Future<T> Function() f) => http.runWithClient(f, () => cliente);

  group('TokenStore', () {
    test('lee la expiración del JWT y rechaza tokens mal formados', () {
      final exp = DateTime.utc(2030, 1, 1);
      expect(expiracionDeJwt(jwtCon(exp)), exp);
      for (final malo in ['', 'a.b', 'a.b.c', 'a.%%%.c']) {
        expect(expiracionDeJwt(malo), isNull, reason: malo);
      }
    });

    test('guarda solo el token de renovación y lo recupera; el de acceso queda en memoria', () async {
      final acceso = jwtCon(DateTime.now().add(const Duration(minutes: 15)));
      await tokens.guardar(accessToken: acceso, refreshToken: 'r1');
      expect(almacen.datos, {TokenStore.claveRenovacion: 'r1'});
      expect(tokens.accesoVigente, isTrue);
      expect(tokens.authHeaders, {'Authorization': 'Bearer $acceso'});

      final otro = TokenStore(almacen);
      await otro.cargar();
      expect(otro.refreshToken, 'r1');
      expect(otro.haySesion, isTrue);
      expect(otro.accesoVigente, isFalse);
      expect(otro.authHeaders, isEmpty);
    });

    test('un token que vence en menos de 30 s ya no se considera vigente', () async {
      await tokens.guardar(accessToken: jwtCon(DateTime.now().add(const Duration(seconds: 20))), refreshToken: 'r');
      expect(tokens.accesoVigente, isFalse);
    });

    test('limpiar borra todo', () async {
      await tokens.guardar(accessToken: jwtCon(DateTime.now().add(const Duration(minutes: 5))), refreshToken: 'r');
      await tokens.limpiar();
      expect(almacen.datos, isEmpty);
      expect(tokens.haySesion, isFalse);
      expect(tokens.accessToken, isEmpty);
    });
  });

  group('ApiClient', () {
    test('añade el token de acceso, la ruta y los parámetros', () async {
      await tokens.guardar(accessToken: jwtCon(DateTime.now().add(const Duration(minutes: 15))), refreshToken: 'r1');
      late http.Request recibida;
      final cliente = MockClient((req) async {
        recibida = req;
        return json({'ok': true});
      });
      final r = await con(cliente, () => api.get('/usuarios/buscar', query: {'q': 'ana lópez'}));
      expect(r.ok, isTrue);
      expect(recibida.url.toString(), 'https://api.test/usuarios/buscar?q=ana+l%C3%B3pez');
      expect(recibida.headers['Authorization'], startsWith('Bearer '));
    });

    test('sin auth no manda el token', () async {
      await tokens.guardar(accessToken: jwtCon(DateTime.now().add(const Duration(minutes: 15))), refreshToken: 'r1');
      late http.Request recibida;
      final cliente = MockClient((req) async {
        recibida = req;
        return json({}, 401);
      });
      await con(cliente, () => api.post('/auth/login', cuerpo: {'a': 1}, auth: false));
      expect(recibida.headers.containsKey('Authorization'), isFalse);
      expect(jsonDecode(recibida.body), {'a': 1});
    });

    test('si el servidor rechaza el token renueva la sesión una vez y repite la petición', () async {
      await tokens.guardar(accessToken: jwtCon(DateTime.now().add(const Duration(minutes: 15))), refreshToken: 'r1');
      final nuevo = sesionServidor(renovacion: 'r2');
      final llamadas = <String>[];
      final cliente = MockClient((req) async {
        llamadas.add('${req.method} ${req.url.path}');
        if (req.url.path == '/auth/refresh') {
          expect(jsonDecode(req.body)['refreshToken'], 'r1');
          return json(nuevo);
        }
        return llamadas.where((l) => l.endsWith('/compras')).length == 1
            ? json({'error': 'x', 'code': 'INVALID_TOKEN'}, 401)
            : json([]);
      });
      final r = await con(cliente, () => api.get('/compras'));
      expect(r.ok, isTrue);
      expect(llamadas, ['GET /compras', 'POST /auth/refresh', 'GET /compras']);
      expect(tokens.refreshToken, 'r2');
      expect(almacen.datos[TokenStore.claveRenovacion], 'r2');
    });

    test('varias peticiones rechazadas a la vez comparten UNA sola renovación', () async {
      await tokens.guardar(accessToken: jwtCon(DateTime.now().add(const Duration(minutes: 15))), refreshToken: 'r1');
      var renovaciones = 0;
      final cliente = MockClient((req) async {
        if (req.url.path == '/auth/refresh') {
          renovaciones += 1;
          await Future<void>.delayed(const Duration(milliseconds: 50));
          return json(sesionServidor(renovacion: 'r2'));
        }
        return req.headers['Authorization'] == 'Bearer ${tokens.accessToken}' && renovaciones > 0
            ? json({'ok': true})
            : json({'error': 'x', 'code': 'INVALID_TOKEN'}, 401);
      });
      final rs = await con(cliente, () => Future.wait([api.get('/a'), api.get('/b'), api.get('/c')]));
      expect(rs.every((r) => r.ok), isTrue);
      expect(renovaciones, 1);
    });

    test('renueva antes de enviar cuando el token de acceso ya venció', () async {
      almacen.datos[TokenStore.claveRenovacion] = 'r1';
      final llamadas = <String>[];
      final cliente = MockClient((req) async {
        llamadas.add(req.url.path);
        return req.url.path == '/auth/refresh' ? json(sesionServidor(renovacion: 'r2')) : json({'ok': true});
      });
      final r = await con(cliente, () => api.get('/usuarios/me'));
      expect(r.ok, isTrue);
      expect(llamadas, ['/auth/refresh', '/usuarios/me']);
    });

    test('si la renovación es rechazada limpia los tokens y avisa que la sesión terminó', () async {
      await tokens.guardar(accessToken: jwtCon(DateTime.now().add(const Duration(minutes: 15))), refreshToken: 'r1');
      var avisos = 0;
      api.alExpirarSesion = () async => avisos += 1;
      final cliente = MockClient((req) async => req.url.path == '/auth/refresh'
          ? json({'error': 'x', 'code': 'REFRESH_REUSED'}, 401)
          : json({'error': 'x', 'code': 'INVALID_TOKEN'}, 401));
      final r = await con(cliente, () => api.get('/compras'));
      expect(r.status, 401);
      expect(avisos, 1);
      expect(tokens.haySesion, isFalse);
      expect(almacen.datos, isEmpty);
    });

    test('un fallo de red al renovar conserva la sesión', () async {
      await tokens.guardar(accessToken: jwtCon(DateTime.now().add(const Duration(minutes: 15))), refreshToken: 'r1');
      var avisos = 0;
      api.alExpirarSesion = () async => avisos += 1;
      final cliente = MockClient((req) async => req.url.path == '/auth/refresh'
          ? throw http.ClientException('sin red')
          : json({'error': 'x', 'code': 'INVALID_TOKEN'}, 401));
      await con(cliente, () => api.get('/compras'));
      expect(avisos, 0);
      expect(tokens.refreshToken, 'r1');
    });

    test('un 401 por credenciales incorrectas NO dispara la renovación', () async {
      await tokens.guardar(accessToken: jwtCon(DateTime.now().add(const Duration(minutes: 15))), refreshToken: 'r1');
      var renovaciones = 0;
      final cliente = MockClient((req) async {
        if (req.url.path == '/auth/refresh') renovaciones += 1;
        return json({'error': 'La contraseña actual no es correcta', 'code': 'INVALID_CREDENTIALS'}, 401);
      });
      final r = await con(cliente, () => api.post('/auth/password', cuerpo: {'actual': 'x', 'nueva': 'y'}));
      expect(r.code, 'INVALID_CREDENTIALS');
      expect(renovaciones, 0);
    });

    test('sin red devuelve estado 0 y código NETWORK; respuestas que no son JSON no rompen', () async {
      final sinRed = MockClient((req) async => throw http.ClientException('sin red'));
      final r = await con(sinRed, () => api.get('/x', auth: false));
      expect([r.status, r.code, r.sinRed], [0, 'NETWORK', true]);

      final html = MockClient((req) async => http.Response('<html>', 502));
      final r2 = await con(html, () => api.get('/x', auth: false));
      expect(r2.status, 502);
      expect(r2.json, isNull);
    });

    test('un tiempo agotado se trata como falta de red', () async {
      final lento = ApiClient(baseUrl: 'https://api.test', tokens: tokens, timeout: const Duration(milliseconds: 20));
      final cliente = MockClient((req) async {
        await Future<void>.delayed(const Duration(milliseconds: 200));
        return json({});
      });
      final r = await con(cliente, () => lento.get('/x', auth: false));
      expect(r.sinRed, isTrue);
    });
  });

  group('AuthApi', () {
    late AuthApi auth;
    setUp(() => auth = AuthApi(api));

    test('login correcto devuelve la sesión y NO guarda tokens por sí mismo', () async {
      final cliente = MockClient((req) async {
        expect(req.url.path, '/auth/login');
        expect(jsonDecode(req.body), {'nombreusuario': 'ana', 'password': 'Clave1234', 'perfil': 'Usuario'});
        return json(sesionServidor());
      });
      final r = await con(cliente, () => auth.login(usuario: 'ana', password: 'Clave1234', perfil: 'Usuario'));
      expect(r.ok, isTrue);
      expect(r.dato!.userId, 'u1');
      expect(r.dato!.nombre, 'Ana Pérez');
      expect(almacen.datos, isEmpty);
    });

    test('login rechazado, bloqueado y sin red dan mensajes comprensibles', () async {
      Future<ResultadoAuth<SesionApi>> intento(MockClient c) =>
          con(c, () => auth.login(usuario: 'a', password: 'b', perfil: 'Usuario'));
      final mala = await intento(MockClient((r) async => json({'error': 'Credenciales inválidas', 'code': 'INVALID_CREDENTIALS'}, 401)));
      expect([mala.ok, mala.code, mala.mensaje], [false, 'INVALID_CREDENTIALS', 'Usuario o contraseña incorrectos.']);
      final bloqueado = await intento(MockClient((r) async => json({'error': 'x', 'code': 'TOO_MANY_ATTEMPTS'}, 429)));
      expect(bloqueado.mensaje, contains('Demasiados intentos'));
      final sinRed = await intento(MockClient((r) async => throw http.ClientException('x')));
      expect(sinRed.mensaje, contains('No hay conexión'));
      final raro = await intento(MockClient((r) async => json({'otra': 'cosa'})));
      expect(raro.code, 'BAD_RESPONSE');
    });

    test('registrar conserva el mensaje del servidor y cierra la sesión que el servidor abre', () async {
      final rutas = <String>[];
      final cliente = MockClient((req) async {
        rutas.add(req.url.path);
        if (req.url.path == '/auth/register') return json(sesionServidor(renovacion: 'rNueva'), 201);
        expect(jsonDecode(req.body)['refreshToken'], 'rNueva');
        return json({'ok': true});
      });
      final ok = await con(cliente, () => auth.registrar({'nombreusuario': 'x'}));
      expect(ok.ok, isTrue);
      expect(rutas, ['/auth/register', '/auth/logout']);
      expect(almacen.datos, isEmpty);

      final repetido = await con(
        MockClient((r) async => json({'error': 'El nombre de usuario ya existe', 'code': 'USERNAME_TAKEN'}, 409)),
        () => auth.registrar({'nombreusuario': 'x'}),
      );
      expect(repetido.mensaje, 'El nombre de usuario ya existe');
    });

    test('cerrarSesion revoca en el servidor y olvida los tokens aunque no haya red', () async {
      await tokens.guardar(accessToken: jwtCon(DateTime.now().add(const Duration(minutes: 5))), refreshToken: 'r1');
      await con(MockClient((r) async => throw http.ClientException('sin red')), () => auth.cerrarSesion());
      expect(tokens.haySesion, isFalse);
      expect(almacen.datos, isEmpty);
    });

    test('recuperación de contraseña: solicitud y confirmación', () async {
      final cuerpos = <String, dynamic>{};
      final cliente = MockClient((req) async {
        cuerpos[req.url.path] = jsonDecode(req.body);
        if (req.url.path == '/auth/recover/confirm' && cuerpos[req.url.path]['token'] == 'viejo') {
          return json({'error': 'x', 'code': 'INVALID_RESET_TOKEN'}, 401);
        }
        return json({'ok': true});
      });
      expect((await con(cliente, () => auth.solicitarRecuperacion(correo: 'a@b.co', perfil: 'Usuario'))).ok, isTrue);
      expect(cuerpos['/auth/recover/request'], {'correoelectronico': 'a@b.co', 'perfil': 'Usuario'});
      expect((await con(cliente, () => auth.confirmarRecuperacion(token: 'nuevo', perfil: 'Usuario', password: 'Clave1234'))).ok, isTrue);
      final invalido = await con(cliente, () => auth.confirmarRecuperacion(token: 'viejo', perfil: 'Usuario', password: 'Clave1234'));
      expect(invalido.code, 'INVALID_RESET_TOKEN');
      expect(invalido.mensaje, contains('no es válido'));
    });
  });

  group('sessionProvider con la API', () {
    late ProviderContainer c;

    ProviderContainer crear() => ProviderContainer(overrides: [
      sessionStorageProvider.overrideWithValue(almacen),
      tokenStoreProvider.overrideWithValue(tokens),
      apiClientProvider.overrideWithValue(api),
      authApiProvider.overrideWithValue(AuthApi(api)),
    ]);

    setUp(() {
      c = crear();
      // El provider se elimina solo cuando nadie lo escucha; en la app siempre hay widgets escuchando.
      c.listen(sessionProvider, (_, __) {});
    });
    tearDown(() => c.dispose());

    test('iniciar sesión correcto: autentica, guarda el token de renovación y borra la sesión local previa', () async {
      almacen.datos['userPassHash'] = 'hash-viejo-de-otra-version';
      final cliente = MockClient((req) async => json(sesionServidor(id: 'abc123')));
      final r = await con(cliente, () => c.read(sessionProvider.notifier).iniciarSesionConApi(usuario: 'ana', password: 'Clave1234'));
      expect(r.ok, isTrue);
      final s = c.read(sessionProvider);
      expect(s.isAuthenticated, isTrue);
      expect(s.sessionUserData.userId, 'abc123');
      expect(s.sessionUserData.userName, 'ana');
      expect(s.sessionUserData.userPass, isEmpty);
      expect(almacen.datos.keys, [TokenStore.claveRenovacion]);
    });

    test('iniciar sesión con contraseña incorrecta NO autentica (antes entraba con cualquier clave)', () async {
      final cliente = MockClient((req) async => json({'error': 'Credenciales inválidas', 'code': 'INVALID_CREDENTIALS'}, 401));
      final r = await con(cliente, () => c.read(sessionProvider.notifier).iniciarSesionConApi(usuario: 'ana', password: 'cualquiera1'));
      expect(r.ok, isFalse);
      expect(c.read(sessionProvider).isAuthenticated, isFalse);
      expect(tokens.haySesion, isFalse);
      expect(almacen.datos, isEmpty);
    });

    test('usa el perfil elegido en la pantalla', () async {
      c.read(sessionProvider.notifier).setNombrePerfil('Promotor');
      late Map<String, dynamic> enviado;
      final cliente = MockClient((req) async {
        enviado = jsonDecode(req.body) as Map<String, dynamic>;
        return json(sesionServidor());
      });
      await con(cliente, () => c.read(sessionProvider.notifier).iniciarSesionConApi(usuario: 'ana', password: 'Clave1234'));
      expect(enviado['perfil'], 'Promotor');
    });

    test('cerrar sesión revoca en el servidor y deja la app sin sesión', () async {
      final llamadas = <String>[];
      final cliente = MockClient((req) async {
        llamadas.add(req.url.path);
        return req.url.path == '/auth/login' ? json(sesionServidor()) : json({'ok': true});
      });
      await con(cliente, () async {
        await c.read(sessionProvider.notifier).iniciarSesionConApi(usuario: 'ana', password: 'Clave1234');
        await c.read(sessionProvider.notifier).cerrarSesion();
      });
      expect(llamadas, ['/auth/login', '/auth/logout']);
      expect(c.read(sessionProvider).isAuthenticated, isFalse);
      expect(tokens.haySesion, isFalse);
      expect(almacen.datos, isEmpty);
    });

    test('una sesión guardada por una versión anterior (sin token de renovación) no se restaura', () async {
      almacen.datos.addAll({'userId': 'u1', 'userName': 'ana', 'nombrePerfil': 'Usuario', 'userPassHash': 'abc'});
      await con(MockClient((req) async => json({})), () => c.read(sessionProvider.notifier).getSessionValuesFromLocalStorage());
      expect(c.read(sessionProvider).isAuthenticated, isFalse);
    });

    test('una sesión con token de renovación se restaura y se valida en segundo plano', () async {
      almacen.datos.addAll({'userId': 'u1', 'userName': 'ana', 'nombrePerfil': 'Usuario', TokenStore.claveRenovacion: 'r1'});
      final llamadas = <String>[];
      final cliente = MockClient((req) async {
        llamadas.add(req.url.path);
        return req.url.path == '/auth/refresh' ? json(sesionServidor(renovacion: 'r2')) : json({'id': 'u1'});
      });
      await con(cliente, () async {
        c.read(sessionProvider);
        await c.read(sessionProvider.notifier).getSessionValuesFromLocalStorage();
        await Future<void>.delayed(const Duration(milliseconds: 50));
      });
      expect(c.read(sessionProvider).isAuthenticated, isTrue);
      expect(c.read(sessionProvider).sessionUserData.userId, 'u1');
      expect(llamadas, ['/auth/refresh', '/usuarios/me']);
    });

    test('si el servidor rechaza la sesión guardada, la app queda sin sesión', () async {
      almacen.datos.addAll({'userId': 'u1', 'userName': 'ana', 'nombrePerfil': 'Usuario', TokenStore.claveRenovacion: 'r1'});
      final cliente = MockClient((req) async => json({'error': 'x', 'code': 'REFRESH_REUSED'}, 401));
      await con(cliente, () async {
        c.read(sessionProvider);
        await c.read(sessionProvider.notifier).getSessionValuesFromLocalStorage();
        await Future<void>.delayed(const Duration(milliseconds: 80));
      });
      expect(c.read(sessionProvider).isAuthenticated, isFalse);
      expect(tokens.haySesion, isFalse);
    });
  });
}
