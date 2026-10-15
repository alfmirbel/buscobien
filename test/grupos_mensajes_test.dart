import 'dart:async';
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

import 'package:buscobien/08_pantallas/tu_cuenta/grupos/providers/grupos_mensajes_provider.dart';

Map<String, dynamic> _msg(String id, String de, String hora, {bool leido = false}) => {
  '_id': id,
  'type': 'mensaje_grupo',
  'senderId': de,
  'senderName': 'N-$de',
  'grupoId': 'g1',
  'content': 'hola $id',
  'timestamp': hora,
  'leido': leido,
};

http.StreamedResponse _json(Object o, [int code = 200]) => http.StreamedResponse(
  Stream.value(utf8.encode(jsonEncode(o))),
  code,
);

void main() {
  late ProviderContainer c;
  setUp(() => c = ProviderContainer());
  tearDown(() => c.dispose());

  test('carga los mensajes, el más reciente primero, y añade los del feed _changes', () async {
    final cambios = StreamController<List<int>>();
    final cli = MockClient.streaming((req, body) async {
      if (req.url.path.endsWith('_changes')) {
        return http.StreamedResponse(cambios.stream, 200);
      }
      return _json({
        'docs': [_msg('1', 'u2', '2026-01-01T10:00:00'), _msg('2', 'u3', '2026-01-01T11:00:00')],
      });
    });

    final lista = await http.runWithClient(
      () => c.read(mensajesGrupoProvider('g1').future),
      () => cli,
    );
    expect(lista.map((m) => m.id), ['2', '1']);

    // llega un mensaje nuevo por el feed (más una línea vacía de heartbeat y un duplicado)
    cambios.add(utf8.encode('\n'));
    cambios.add(utf8.encode('${jsonEncode({'doc': _msg('3', 'u2', '2026-01-01T12:00:00')})}\n'));
    cambios.add(utf8.encode('${jsonEncode({'doc': _msg('3', 'u2', '2026-01-01T12:00:00')})}\n'));
    await Future<void>.delayed(const Duration(milliseconds: 50));
    expect(c.read(mensajesGrupoProvider('g1')).value!.map((m) => m.id), ['3', '2', '1']);
    await cambios.close();
  });

  test('si la carga falla devuelve lista vacía', () async {
    final cli = MockClient.streaming((req, body) async {
      if (req.url.path.endsWith('_changes')) return http.StreamedResponse(const Stream.empty(), 200);
      return _json({'error': 'x'}, 500);
    });
    final lista = await http.runWithClient(() => c.read(mensajesGrupoProvider('g1').future), () => cli);
    expect(lista, isEmpty);
  });

  test('enviar muestra el mensaje al instante, ignora texto vacío y publica con POST', () async {
    final posts = <Map<String, dynamic>>[];
    final cli = MockClient.streaming((req, body) async {
      if (req.url.path.endsWith('_changes')) return http.StreamedResponse(const Stream.empty(), 200);
      if (req.url.path.endsWith('_find')) return _json({'docs': []});
      posts.add(jsonDecode(await http.ByteStream(body).bytesToString()) as Map<String, dynamic>);
      return _json({'ok': true}, 201);
    });
    await http.runWithClient(() async {
      await c.read(mensajesGrupoProvider('g1').future);
      final n = c.read(mensajesGrupoProvider('g1').notifier);
      await n.enviar(senderId: 'u1', senderName: 'Ana', content: '   ');
      await n.enviar(senderId: 'u1', senderName: 'Ana', content: ' Hola ');
    }, () => cli);
    expect(posts.length, 1);
    expect(posts.single['content'], 'Hola');
    expect(c.read(mensajesGrupoProvider('g1')).value!.single.content, 'Hola');
  });

  test('marcarMensajesLeidos solo actualiza los ajenos no leídos', () async {
    final puts = <String>[];
    final cli = MockClient.streaming((req, body) async {
      if (req.url.path.endsWith('_changes')) return http.StreamedResponse(const Stream.empty(), 200);
      if (req.url.path.endsWith('_find')) {
        return _json({
          'docs': [
            _msg('1', 'u2', '2026-01-01T10:00:00'),
            _msg('2', 'u1', '2026-01-01T11:00:00'),
            _msg('3', 'u2', '2026-01-01T12:00:00', leido: true),
          ],
        });
      }
      puts.add('${req.method} ${req.url.path}');
      return _json({'ok': true});
    });
    await http.runWithClient(() async {
      await c.read(mensajesGrupoProvider('g1').future);
      await c.read(mensajesGrupoProvider('g1').notifier).marcarMensajesLeidos('u1');
    }, () => cli);
    expect(puts.length, 1);
    expect(puts.single, endsWith('/1'));
  });
}
