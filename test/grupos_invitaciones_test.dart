import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

import 'package:buscobien/08_pantallas/tu_cuenta/grupos/models/invitacion_grupo_model.dart';
import 'package:buscobien/08_pantallas/tu_cuenta/grupos/providers/grupos_invitaciones_provider.dart';

Map<String, dynamic> _inv(String id, String de, String para, [String status = 'pending']) => {
  '_id': id,
  'type': 'invitacion_grupo',
  'senderId': de,
  'senderName': 'N-$de',
  'receiverId': para,
  'receiverName': 'N-$para',
  'grupoId': 'g1',
  'grupoNombre': 'Grupo',
  'status': status,
  'timestamp': '2026-01-01T00:00:00.000',
};

http.Response _find(List<Map<String, dynamic>> d) => http.Response(jsonEncode({'docs': d}), 200);

void main() {
  late ProviderContainer c;
  setUp(() => c = ProviderContainer());
  tearDown(() => c.dispose());

  Future<T> con<T>(MockClient cli, Future<T> Function() f) => http.runWithClient(f, () => cli);
  GruposInvitacionesNotifier n() => c.read(gruposInvitacionesProvider.notifier);

  test('fetchInvitaciones carga, y ante error HTTP o excepción se comporta', () async {
    await con(MockClient((r) async => _find([_inv('1', 'u1', 'u2')])), () => n().fetchInvitaciones('u1'));
    expect(c.read(gruposInvitacionesProvider).value!.length, 1);

    await con(MockClient((r) async => http.Response('x', 500)), () => n().fetchInvitaciones('u1'));
    expect(c.read(gruposInvitacionesProvider).value, isEmpty);

    await con(MockClient((r) async => throw Exception('red')), () => n().fetchInvitaciones('u1'));
    expect(c.read(gruposInvitacionesProvider).hasError, isTrue);
  });

  test('enviarInvitacion usa PUT por id y recarga las invitaciones', () async {
    final metodos = <String>[];
    final cli = MockClient((r) async {
      metodos.add(r.method);
      return r.method == 'PUT' ? http.Response('{"ok":true}', 201) : _find([_inv('1', 'u1', 'u2')]);
    });
    final ok = await con(cli, () => n().enviarInvitacion(senderId: 'u1', senderName: 'A', receiverId: 'u2', receiverName: 'B', grupoId: 'g1', grupoNombre: 'Grupo'));
    expect(ok, isTrue);
    expect(metodos, ['PUT', 'POST']);
  });

  test('enviarInvitacion crea la base si no existe y reintenta', () async {
    var puts = 0;
    final cli = MockClient((r) async {
      if (r.method == 'PUT') {
        puts++;
        if (puts == 1) return http.Response('not_found', 404); // documento
        if (puts == 2) return http.Response('{"ok":true}', 201); // crea la base
        return http.Response('{"ok":true}', 201); // reintento
      }
      return _find([]);
    });
    final ok = await con(cli, () => n().enviarInvitacion(senderId: 'u1', senderName: 'A', receiverId: 'u2', receiverName: 'B', grupoId: 'g1', grupoNombre: 'Grupo'));
    expect(ok, isTrue);
    expect(puts, 3);
  });

  test('no reenvía si ya hay una invitación pendiente al mismo usuario y grupo', () async {
    final cli = MockClient((r) async => _find([_inv('1', 'u1', 'u2')]));
    await con(cli, () => n().fetchInvitaciones('u1'));
    var llamadas = 0;
    final cli2 = MockClient((r) async {
      llamadas++;
      return http.Response('{}', 201);
    });
    final ok = await con(cli2, () => n().enviarInvitacion(senderId: 'u1', senderName: 'A', receiverId: 'u2', receiverName: 'B', grupoId: 'g1', grupoNombre: 'Grupo'));
    expect(ok, isFalse);
    expect(llamadas, 0);
  });

  test('enviarInvitacion devuelve false ante error del servidor o de red', () async {
    Future<bool> enviar(MockClient cli) => con(cli, () => n().enviarInvitacion(senderId: 'u1', senderName: 'A', receiverId: 'u3', receiverName: 'B', grupoId: 'g1', grupoNombre: 'Grupo'));
    expect(await enviar(MockClient((r) async => http.Response('x', 500))), isFalse);
    expect(await enviar(MockClient((r) async => throw Exception('red'))), isFalse);
  });

  test('responderInvitacion guarda el nuevo estado y recarga', () async {
    Map<String, dynamic>? guardado;
    final cli = MockClient((r) async {
      if (r.method == 'PUT') {
        guardado = jsonDecode(r.body) as Map<String, dynamic>;
        return http.Response('{"ok":true}', 201);
      }
      return _find([_inv('1', 'u2', 'u1', 'accepted')]);
    });
    final inv = InvitacionGrupoModel.fromJson(_inv('1', 'u2', 'u1'));
    expect(await con(cli, () => n().responderInvitacion(inv, 'accepted', 'u1')), isTrue);
    expect(guardado!['status'], 'accepted');
    expect(c.read(gruposInvitacionesProvider).value!.single.status, 'accepted');
  });

  test('responderInvitacion devuelve false si falla el PUT', () async {
    final inv = InvitacionGrupoModel.fromJson(_inv('1', 'u2', 'u1'));
    expect(await con(MockClient((r) async => http.Response('x', 409)), () => n().responderInvitacion(inv, 'rejected', 'u1')), isFalse);
    expect(await con(MockClient((r) async => throw Exception('red')), () => n().responderInvitacion(inv, 'rejected', 'u1')), isFalse);
  });

  test('los providers derivados filtran recibidas pendientes y enviadas', () async {
    final cli = MockClient((r) async => _find([_inv('1', 'u1', 'u2'), _inv('2', 'u3', 'u1'), _inv('3', 'u4', 'u1', 'accepted')]));
    await con(cli, () => n().fetchInvitaciones('u1'));
    expect(c.read(invitacionesGrupoRecibidasProvider('u1')).map((x) => x.id), ['2']);
    expect(c.read(invitacionesGrupoEnviadasProvider('u1')).map((x) => x.id), ['1']);
  });
}
