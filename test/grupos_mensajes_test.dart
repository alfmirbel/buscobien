import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

import 'package:buscobien/08_pantallas/tu_cuenta/grupos/models/mensaje_grupo_model.dart';
import 'package:buscobien/08_pantallas/tu_cuenta/grupos/providers/grupos_mensajes_provider.dart';

Map<String, dynamic> _msg(String id, String de, String hora, {bool leido = false}) => {
  'id': id,
  'senderId': de,
  'senderName': 'N-$de',
  'grupoId': 'g1',
  'content': 'hola $id',
  'timestamp': hora,
  'leido': leido,
  'tipo': 'texto',
};

http.Response _json(Object o, [int code = 200]) =>
    http.Response(jsonEncode(o), code, headers: {'content-type': 'application/json'});

/// Servidor de chat de grupo en memoria: lista (con `desde`), crea y marca como leído.
class _Servidor {
  final mensajes = <Map<String, dynamic>>[];
  final peticiones = <http.Request>[];
  bool fallaEnvio = false;
  bool fallaLista = false;

  Future<http.Response> responder(http.Request r) async {
    peticiones.add(r);
    final ruta = r.url.path;
    if (r.method == 'GET' && ruta == '/grupos/g1/mensajes') {
      if (fallaLista) return _json({'error': 'x', 'code': 'INTERNAL'}, 500);
      final desde = r.url.queryParameters['desde'];
      final lista = mensajes.where((m) => desde == null || (m['timestamp'] as String).compareTo(desde) >= 0).toList();
      return _json({'mensajes': lista});
    }
    if (r.method == 'POST' && ruta == '/grupos/g1/mensajes') {
      if (fallaEnvio) return _json({'error': 'x', 'code': 'NOT_MEMBER'}, 403);
      final cuerpo = jsonDecode(r.body) as Map<String, dynamic>;
      final nuevo = {
        'id': cuerpo['id'],
        'senderId': 'u1',
        'senderName': 'Ana Servidor',
        'grupoId': 'g1',
        'content': cuerpo['content'],
        'timestamp': '2026-01-01T12:00:00.000Z',
        'leido': false,
        'tipo': cuerpo['tipo'],
      };
      mensajes.add(nuevo);
      return _json({'mensaje': nuevo}, 201);
    }
    if (r.method == 'POST' && ruta == '/grupos/g1/mensajes/leidos') return _json({'marcados': 1});
    return _json({'error': 'no', 'code': 'NOT_FOUND'}, 404);
  }

  Iterable<http.Request> de(String metodo) => peticiones.where((p) => p.method == metodo);
}

void main() {
  late ProviderContainer c;
  late _Servidor s;
  setUp(() {
    s = _Servidor();
    c = ProviderContainer(
      overrides: [
        mensajesGrupoProvider.overrideWith2(
          (grupoId) => MensajesGrupoNotifier(grupoId, intervalo: const Duration(milliseconds: 20)),
        ),
      ],
    );
  });
  tearDown(() => c.dispose());

  Future<T> con<T>(Future<T> Function() f) => http.runWithClient(f, () => MockClient(s.responder));
  Future<void> espera([int ms = 120]) => Future<void>.delayed(Duration(milliseconds: ms));

  test('carga los mensajes, el más reciente primero, y añade los que llegan por sondeo', () async {
    s.mensajes.addAll([_msg('1', 'u2', '2026-01-01T10:00:00.000Z'), _msg('2', 'u3', '2026-01-01T11:00:00.000Z')]);
    await con(() async {
      c.listen(mensajesGrupoProvider('g1'), (anterior, nuevo) {}); // una pantalla escuchando
      final lista = await c.read(mensajesGrupoProvider('g1').future);
      expect(lista.map((m) => m.id), ['2', '1']);

      s.mensajes.add(_msg('3', 'u2', '2026-01-01T12:00:00.000Z'));
      await espera();
      expect(c.read(mensajesGrupoProvider('g1')).value!.map((m) => m.id), ['3', '2', '1']);
    });
    // el sondeo pide desde el último mensaje conocido y no duplica los que ya tenía
    final sondeos = s.de('GET').where((p) => p.url.queryParameters.containsKey('desde'));
    expect(sondeos, isNotEmpty);
    expect(sondeos.first.url.queryParameters['desde'], '2026-01-01T11:00:00.000Z');
    expect(c.read(mensajesGrupoProvider('g1')).value!.length, 3);
  });

  test('si la carga falla devuelve lista vacía', () async {
    s.fallaLista = true;
    final lista = await con(() => c.read(mensajesGrupoProvider('g1').future));
    expect(lista, isEmpty);
  });

  test('enviar muestra el mensaje al instante, ignora texto vacío y lo sustituye por el guardado', () async {
    await con(() async {
      await c.read(mensajesGrupoProvider('g1').future);
      final n = c.read(mensajesGrupoProvider('g1').notifier);
      expect(await n.enviar(senderId: 'u1', senderName: 'Ana', content: '   '), isFalse);
      final futuro = n.enviar(senderId: 'u1', senderName: 'Ana', content: ' Hola ');
      expect(c.read(mensajesGrupoProvider('g1')).value!.single.content, 'Hola'); // optimista
      expect(await futuro, isTrue);
    });
    final posts = s.de('POST').where((p) => p.url.path.endsWith('/mensajes')).toList();
    expect(posts.length, 1);
    final cuerpo = jsonDecode(posts.single.body) as Map<String, dynamic>;
    expect(cuerpo['content'], 'Hola');
    expect(cuerpo.containsKey('senderId'), isFalse, reason: 'el remitente lo pone el servidor');
    final guardado = c.read(mensajesGrupoProvider('g1')).value!.single;
    expect(guardado.senderName, 'Ana Servidor');
    expect(guardado.timestamp, '2026-01-01T12:00:00.000Z');
  });

  test('si el servidor rechaza el envío el mensaje se retira', () async {
    s.fallaEnvio = true;
    await con(() async {
      await c.read(mensajesGrupoProvider('g1').future);
      final ok = await c.read(mensajesGrupoProvider('g1').notifier).enviar(senderId: 'u1', senderName: 'Ana', content: 'hola');
      expect(ok, isFalse);
    });
    expect(c.read(mensajesGrupoProvider('g1')).value, isEmpty);
  });

  test('marcarMensajesLeidos hace una sola petición y marca solo los ajenos no leídos', () async {
    s.mensajes.addAll([
      _msg('1', 'u2', '2026-01-01T10:00:00.000Z'),
      _msg('2', 'u1', '2026-01-01T11:00:00.000Z'),
      _msg('3', 'u2', '2026-01-01T12:00:00.000Z', leido: true),
    ]);
    await con(() async {
      await c.read(mensajesGrupoProvider('g1').future);
      await c.read(mensajesGrupoProvider('g1').notifier).marcarMensajesLeidos('u1');
    });
    expect(s.de('POST').where((p) => p.url.path.endsWith('/leidos')).length, 1);
    final porId = {for (final MensajeGrupoModel m in c.read(mensajesGrupoProvider('g1')).value!) m.id: m.leido};
    expect(porId, {'1': true, '2': false, '3': true});
  });

  test('el sondeo se detiene cuando nadie escucha y se reanuda al volver', () async {
    await con(() async {
      final sub = c.listen(mensajesGrupoProvider('g1'), (anterior, nuevo) {});
      await c.read(mensajesGrupoProvider('g1').future);
      await espera();
      final conOyente = s.peticiones.length;
      expect(conOyente, greaterThan(1));

      sub.close();
      await espera(60); // deja terminar una consulta en curso
      final alCerrar = s.peticiones.length;
      await espera();
      expect(s.peticiones.length, alCerrar, reason: 'sin oyentes no debe consultar');

      final sub2 = c.listen(mensajesGrupoProvider('g1'), (anterior, nuevo) {});
      await espera();
      expect(s.peticiones.length, greaterThan(alCerrar));
      sub2.close();
    });
  });
}
