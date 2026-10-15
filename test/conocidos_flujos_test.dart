import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

import 'package:buscobien/08_pantallas/tu_cuenta/conocidos/models/conocido.dart';
import 'package:buscobien/08_pantallas/tu_cuenta/conocidos/providers/conocidos_notifier.dart';

Map<String, dynamic> _doc(String id, String de, String para, String estado) => {
  '_id': id,
  'senderId': de,
  'senderName': 'N-$de',
  'receiverId': para,
  'receiverName': 'N-$para',
  'status': estado,
  'timestamp': '2026-01-01T00:00:00.000',
};

http.Response _find(List<Map<String, dynamic>> docs) =>
    http.Response(jsonEncode({'docs': docs}), 200);

void main() {
  late ProviderContainer c;
  setUp(() => c = ProviderContainer());
  tearDown(() => c.dispose());

  Future<T> con<T>(MockClient cli, Future<T> Function() f) =>
      http.runWithClient(f, () => cli);

  test('cargar convierte los documentos y traduce los estados', () async {
    final cli = MockClient(
      (r) async => _find([
        _doc('1', 'u1', 'u2', 'accepted'),
        _doc('2', 'u3', 'u1', 'rejected'),
        _doc('3', 'u1', 'u4', 'blocked'),
        _doc('4', 'u5', 'u1', 'pending'),
      ]),
    );
    await con(cli, () => c.read(conocidosProvider.notifier).cargar('u1'));
    final lista = c.read(conocidosProvider).value!;
    expect(lista.map((x) => x.estado), [
      InvitacionEstado.aceptado,
      InvitacionEstado.rechazado,
      InvitacionEstado.bloqueado,
      InvitacionEstado.pendiente,
    ]);
    expect(lista.first.solicitanteNombre, 'N-u1');
  });

  test('cargar con respuesta de error deja la lista vacía', () async {
    final cli = MockClient((r) async => http.Response('boom', 500));
    await con(cli, () => c.read(conocidosProvider.notifier).cargar('u1'));
    expect(c.read(conocidosProvider).value, isEmpty);
  });

  test('cargar con excepción de red deja el estado en error', () async {
    final cli = MockClient((r) async => throw Exception('sin red'));
    await con(cli, () => c.read(conocidosProvider.notifier).cargar('u1'));
    expect(c.read(conocidosProvider).hasError, isTrue);
  });

  test('enviarInvitacion devuelve true con 201 y recarga la lista', () async {
    var finds = 0;
    final cli = MockClient((r) async {
      if (r.url.path.endsWith('_find')) {
        finds++;
        return _find([_doc('1', 'u1', 'u2', 'pending')]);
      }
      return http.Response('{"ok":true}', 201);
    });
    final n = c.read(conocidosProvider.notifier);
    await con(cli, () => n.cargar('u1'));
    final ok = await con(cli, () => n.enviarInvitacion('u1', 'A', 'u2', 'B'));
    expect(ok, isTrue);
    expect(finds, 2);
  });

  test('enviarInvitacion devuelve false si el servidor rechaza o falla', () async {
    final n = c.read(conocidosProvider.notifier);
    expect(
      await con(MockClient((r) async => http.Response('x', 500)), () => n.enviarInvitacion('u1', 'A', 'u2', 'B')),
      isFalse,
    );
    expect(
      await con(MockClient((r) async => throw Exception('red')), () => n.enviarInvitacion('u1', 'A', 'u2', 'B')),
      isFalse,
    );
  });

  test('agregarContactoAceptado no duplica una relación aceptada', () async {
    var posts = 0;
    final cli = MockClient((r) async {
      if (r.method == 'POST' && !r.url.path.endsWith('_find')) posts++;
      return _find([_doc('1', 'u2', 'u1', 'accepted')]);
    });
    final n = c.read(conocidosProvider.notifier);
    await con(cli, () => n.cargar('u1'));
    final ok = await con(cli, () => n.agregarContactoAceptado('u1', 'A', 'u2', 'B'));
    expect(ok, isTrue);
    expect(posts, 0);
  });

  test('agregarContactoAceptado crea el documento cuando no existe', () async {
    final cuerpos = <Map<String, dynamic>>[];
    final cli = MockClient((r) async {
      if (r.url.path.endsWith('_find')) return _find([]);
      cuerpos.add(jsonDecode(r.body) as Map<String, dynamic>);
      return http.Response('{"ok":true}', 201);
    });
    final n = c.read(conocidosProvider.notifier);
    await con(cli, () => n.cargar('u1'));
    expect(await con(cli, () => n.agregarContactoAceptado('u1', 'A', 'u9', 'B')), isTrue);
    expect(cuerpos.single['status'], 'accepted');
    expect(cuerpos.single['receiverId'], 'u9');
  });

  test('responderInvitacion actualiza el estado local tras el PUT', () async {
    final cli = MockClient((r) async {
      if (r.url.path.endsWith('_find')) return _find([_doc('1', 'u2', 'u1', 'pending')]);
      if (r.method == 'GET') return http.Response(jsonEncode(_doc('1', 'u2', 'u1', 'pending')), 200);
      expect(jsonDecode(r.body)['status'], 'accepted');
      return http.Response('{"ok":true}', 201);
    });
    final n = c.read(conocidosProvider.notifier);
    await con(cli, () => n.cargar('u1'));
    await con(cli, () => n.responderInvitacion('1', InvitacionEstado.aceptado));
    expect(c.read(conocidosProvider).value!.single.estado, InvitacionEstado.aceptado);
  });

  test('responderInvitacion no cambia nada si el GET falla', () async {
    final cli = MockClient((r) async {
      if (r.url.path.endsWith('_find')) return _find([_doc('1', 'u2', 'u1', 'pending')]);
      return http.Response('no', 404);
    });
    final n = c.read(conocidosProvider.notifier);
    await con(cli, () => n.cargar('u1'));
    await con(cli, () => n.responderInvitacion('1', InvitacionEstado.rechazado));
    expect(c.read(conocidosProvider).value!.single.estado, InvitacionEstado.pendiente);
  });

  test('los providers derivados separan recibidas y enviadas', () async {
    final cli = MockClient(
      (r) async => _find([_doc('1', 'u1', 'u2', 'pending'), _doc('2', 'u3', 'u1', 'pending')]),
    );
    await con(cli, () => c.read(conocidosProvider.notifier).cargar('u1'));
    expect(c.read(invitacionesRecibidasProvider('u1')).value!.map((x) => x.id), ['2']);
    expect(c.read(invitacionesEnviadasProvider('u1')).value!.map((x) => x.id), ['1']);
  });
}
