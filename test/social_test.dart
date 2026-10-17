import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

import 'package:buscobien/03_listas/models/lista_compartida_model.dart';
import 'package:buscobien/03_listas/provider_listas_compartidas.dart';
import 'package:buscobien/08_pantallas/tu_cuenta/conocidos/provider_mensajes.dart';
import 'package:buscobien/08_pantallas/tu_cuenta/grupos/providers/publicaciones_grupo_provider.dart';

http.Response _json(Object o, [int code = 200]) =>
    http.Response(jsonEncode(o), code, headers: {'content-type': 'application/json'});

Map<String, dynamic> _msg(String id, String de, String para, String hora, [String texto = 'hola']) => {
  'id': id,
  'senderId': de,
  'receiverId': para,
  'content': '$texto $id',
  'timestamp': hora,
  'tipo': 'texto',
  'propiedadId': '',
  'listaCompartidaId': '',
};

void main() {
  late ProviderContainer c;
  setUp(() => c = ProviderContainer());
  tearDown(() => c.dispose());

  Future<T> con<T>(MockClient cli, Future<T> Function() f) => http.runWithClient(f, () => cli);

  group('chat privado', () {
    test('carga la conversación del más nuevo al más viejo y añade lo que llega por sondeo', () async {
      final guardados = <Map<String, dynamic>>[
        _msg('1', 'u1', 'u2', '2026-01-01T10:00:00.000Z'),
        _msg('2', 'u2', 'u1', '2026-01-01T11:00:00.000Z'),
      ];
      final urls = <Uri>[];
      final cli = MockClient((r) async {
        urls.add(r.url);
        expect(r.url.path, '/mensajes/con/u2');
        final desde = r.url.queryParameters['desde'];
        return _json({'mensajes': guardados.where((m) => desde == null || (m['timestamp'] as String).compareTo(desde) >= 0).toList()});
      });
      final provider = mensajesChatProvider(chatProviderKey('u1', 'u2'));
      final lc = ProviderContainer(
        overrides: [
          mensajesChatProvider.overrideWith2(
            (key) => MensajesChatNotifier(key, intervalo: const Duration(milliseconds: 20)),
          ),
        ],
      );
      addTearDown(lc.dispose);
      await con(cli, () async {
        lc.listen(provider, (anterior, nuevo) {});
        expect((await lc.read(provider.future)).map((m) => m.id), ['2', '1']);
        guardados.add(_msg('3', 'u2', 'u1', '2026-01-01T12:00:00.000Z'));
        await Future<void>.delayed(const Duration(milliseconds: 120));
        expect(lc.read(provider).value!.map((m) => m.id), ['3', '2', '1']);
      });
      expect(urls.any((u) => u.queryParameters['desde'] == '2026-01-01T11:00:00.000Z'), isTrue);
    });

    test('enviar muestra el mensaje al instante, lo reemplaza por el guardado y retira el que falla', () async {
      var fallar = false;
      final cuerpos = <Map<String, dynamic>>[];
      final cli = MockClient((r) async {
        if (r.method == 'GET') return _json({'mensajes': []});
        cuerpos.add(jsonDecode(r.body) as Map<String, dynamic>);
        if (fallar) return _json({'error': 'x', 'code': 'RATE_LIMITED'}, 429);
        return _json({'mensaje': _msg(cuerpos.last['id'] as String, 'u1', 'u2', '2026-01-01T12:00:00.000Z', 'x')}, 201);
      });
      final provider = mensajesChatProvider(chatProviderKey('u1', 'u2'));
      await con(cli, () async {
        await c.read(provider.future);
        final n = c.read(provider.notifier);
        expect(await n.enviar('   '), isFalse);
        final futuro = n.enviar(' Hola ');
        expect(c.read(provider).value!.single.content, 'Hola');
        expect(await futuro, isTrue);
        expect(c.read(provider).value!.single.timestamp, '2026-01-01T12:00:00.000Z');

        fallar = true;
        expect(await n.enviar('otro'), isFalse);
        expect(c.read(provider).value!.length, 1, reason: 'el mensaje fallido se retira');
      });
      expect(cuerpos.first.keys.toSet(), {'id', 'receiverId', 'content', 'tipo', 'propiedadId', 'listaCompartidaId'});
      expect(cuerpos.first['receiverId'], 'u2');
    });

    test('enviarMensajeDirecto publica con POST /mensajes y rechaza texto vacío', () async {
      Map<String, dynamic>? cuerpo;
      final cli = MockClient((r) async {
        expect(r.url.path, '/mensajes');
        cuerpo = jsonDecode(r.body) as Map<String, dynamic>;
        return _json({'mensaje': _msg('1', 'u1', 'u2', '2026-01-01T12:00:00.000Z')}, 201);
      });
      await con(cli, () async {
        expect(await enviarMensajeDirecto(senderId: 'u1', receiverId: 'u2', content: '  '), isFalse);
        expect(
          await enviarMensajeDirecto(senderId: 'u1', receiverId: 'u2', content: 'Mira', tipo: 'lista', listaCompartidaId: 'lc-1'),
          isTrue,
        );
      });
      expect(cuerpo!['tipo'], 'lista');
      expect(cuerpo!['listaCompartidaId'], 'lc-1');
    });

    test('sin respuesta del servidor enviarMensajeDirecto devuelve false', () async {
      final cli = MockClient((r) async => throw http.ClientException('sin red'));
      expect(await con(cli, () => enviarMensajeDirecto(senderId: 'u1', receiverId: 'u2', content: 'hola')), isFalse);
    });
  });

  group('publicaciones de grupo', () {
    Map<String, dynamic> pub(String id) => {
      'id': id, 'grupoId': 'g1', 'propiedadId': 'p-$id', 'propiedadNombre': 'Casa $id',
      'tipodeespacio': 'normal', 'autorId': 'u1', 'autorNombre': 'Ana', 'timestamp': '2026-01-01T10:00:00.000Z',
    };

    test('pagina de 10 en 10 con saltar y limite', () async {
      final pedidos = <Map<String, String>>[];
      final cli = MockClient((r) async {
        pedidos.add(r.url.queryParameters);
        final saltar = int.parse(r.url.queryParameters['saltar']!);
        final n = saltar == 0 ? 10 : 3;
        return _json({'publicaciones': [for (var i = 0; i < n; i++) pub('${saltar + i}')]});
      });
      final provider = publicacionesGrupoProvider('g1');
      await con(cli, () async {
        expect((await c.read(provider.future)).length, 10);
        expect(c.read(provider.notifier).hayMas, isTrue);
        await c.read(provider.notifier).cargarMas();
        expect(c.read(provider).value!.length, 13);
        expect(c.read(provider.notifier).hayMas, isFalse);
      });
      expect(pedidos.map((p) => p['saltar']), ['0', '10']);
      expect(pedidos.every((p) => p['limite'] == '10'), isTrue);
    });

    test('compartir agrega la publicación y un duplicado devuelve false', () async {
      var llamadas = 0;
      final cli = MockClient((r) async {
        if (r.method == 'GET') return _json({'publicaciones': []});
        llamadas++;
        if (llamadas == 2) return _json({'error': 'x', 'code': 'DUPLICATE'}, 409);
        return _json({'publicacion': pub('nueva')}, 201);
      });
      final provider = publicacionesGrupoProvider('g1');
      await con(cli, () async {
        await c.read(provider.future);
        final n = c.read(provider.notifier);
        Future<bool> compartir() => n.compartirPropiedad(
          propiedadId: 'p-nueva', propiedadNombre: 'Casa', tipodeespacio: 'normal', autorId: 'u1', autorNombre: 'Ana',
        );
        expect(await compartir(), isTrue);
        expect(c.read(provider).value!.single.id, 'nueva');
        expect(await compartir(), isFalse);
        expect(c.read(provider).value!.length, 1);
      });
    });

    test('quitar elimina la publicación solo si el servidor lo acepta', () async {
      var acepta = false;
      final cli = MockClient((r) async {
        if (r.method == 'GET') return _json({'publicaciones': [pub('a'), pub('b')]});
        expect(r.url.path, '/grupos/g1/publicaciones/a');
        return acepta ? _json({'ok': true}) : _json({'error': 'x', 'code': 'FORBIDDEN'}, 403);
      });
      final provider = publicacionesGrupoProvider('g1');
      await con(cli, () async {
        final lista = await c.read(provider.future);
        final n = c.read(provider.notifier);
        expect(await n.quitarPublicacion(lista.first), isFalse);
        expect(c.read(provider).value!.length, 2);
        acepta = true;
        expect(await n.quitarPublicacion(lista.first), isTrue);
        expect(c.read(provider).value!.map((p) => p.id), ['b']);
      });
    });
  });

  group('listas compartidas', () {
    ListaCompartidaModel modelo() => ListaCompartidaModel(
      id: 'lc-1', listaOrigenId: 'l-1', listaNombre: 'Favoritas', usuarioOrigenId: 'u1', usuarioOrigenNombre: 'Ana',
      usuarioDestinoId: 'u2', usuarioDestinoNombre: 'Luis', timestamp: '2026-01-01T10:00:00.000Z',
    );

    test('compartir crea la lista, copia las propiedades por la API y avisa por chat', () async {
      final llamadas = <String>[];
      final cli = MockClient((r) async {
        llamadas.add('${r.method} ${r.url.path}');
        if (r.url.path.endsWith('/_find')) return _json({'docs': []});
        if (r.method == 'PUT') return _json({'ok': true, 'id': 'x', 'rev': '1-a'}, 201);
        if (r.url.path.endsWith('/propiedades')) return _json({'total': 2}, 201);
        if (r.url.path == '/mensajes') return _json({'mensaje': _msg('1', 'u1', 'u2', '2026-01-01T12:00:00.000Z')}, 201);
        return _json({}, 404);
      });
      final r = await con(cli, () => c.read(listasCompartidasProvider.notifier).compartirLista(
        listaOrigenId: 'l-1', listaNombreOrigen: 'Favoritas', usuarioOrigenId: 'u1', usuarioOrigenNombre: 'Ana',
        usuarioDestinoId: 'u2', usuarioDestinoNombre: 'Luis',
      ));
      expect(r, 1);
      expect(llamadas.any((l) => l.startsWith('PUT /db/buscobien_listas_compartidas_usuarios/')), isTrue);
      expect(llamadas.where((l) => l.startsWith('POST /listas-compartidas/') && l.endsWith('/propiedades')).length, 1);
      expect(llamadas.contains('POST /mensajes'), isTrue);
      expect(llamadas.any((l) => l.contains('buscobien_listas_prop_compartidas')), isFalse, reason: 'esa base ya no se toca desde la app');
    });

    test('dejar de compartir borra primero las propiedades por la API y luego el documento', () async {
      final llamadas = <String>[];
      final cli = MockClient((r) async {
        llamadas.add('${r.method} ${r.url.path}');
        if (r.url.path.endsWith('/_find')) return _json({'docs': []});
        if (r.method == 'DELETE') return _json({'ok': true});
        if (r.method == 'GET') return _json({'_id': 'lc-1', '_rev': '1-a'});
        return _json({'ok': true}, 201);
      });
      final ok = await con(cli, () => c.read(listasCompartidasProvider.notifier).dejarDeCompartir(modelo(), 'u1'));
      expect(ok, isTrue);
      expect(llamadas.first, 'DELETE /listas-compartidas/lc-1/propiedades');
      expect(llamadas.indexWhere((l) => l.startsWith('PUT /db/buscobien_listas_compartidas_usuarios/lc-1')), greaterThan(0));
    });

    test('lee las propiedades de una lista compartida desde la API', () async {
      final cli = MockClient((r) async {
        expect(r.url.path, '/listas-compartidas/lc-1/propiedades');
        return _json({'propiedades': [{'id': 'a', 'propertyId': 'p-1', 'tipodeespacio': 'normal'}]});
      });
      final props = await con(cli, () => c.read(listasCompartidasProvider.notifier).fetchPropiedadesListaCompartida('lc-1'));
      expect(props.single['propertyId'], 'p-1');
    });

    test('si la API falla devuelve lista vacía', () async {
      final cli = MockClient((r) async => _json({'error': 'x', 'code': 'NOT_FOUND'}, 404));
      expect(await con(cli, () => c.read(listasCompartidasProvider.notifier).fetchPropiedadesListaCompartida('lc-9')), isEmpty);
    });
  });
}
