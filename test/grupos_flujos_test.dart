import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

import 'package:buscobien/08_pantallas/tu_cuenta/grupos/models/grupo_model.dart';
import 'package:buscobien/08_pantallas/tu_cuenta/grupos/providers/grupos_notifier.dart';

Map<String, dynamic> _grupo([String id = 'grupo:1']) => {
  '_id': id,
  '_rev': '1-abc',
  'type': 'grupo',
  'creadorId': 'u1',
  'creadorNombre': 'Ana',
  'nombre': 'Compradores',
  'miembros': [
    {'usuarioId': 'u1', 'usuarioNombre': 'Ana', 'rol': 'admin', 'fechaIngreso': ''},
  ],
};

MiembroGrupoModel _miembro(String id) => MiembroGrupoModel(
  usuarioId: id,
  usuarioNombre: 'N-$id',
  rol: 'miembro',
  fechaIngreso: '',
);

void main() {
  late ProviderContainer c;
  setUp(() => c = ProviderContainer());
  tearDown(() => c.dispose());

  Future<T> con<T>(MockClient cli, Future<T> Function() f) =>
      http.runWithClient(f, () => cli);

  GruposNotifier n() => c.read(gruposProvider.notifier);
  http.Response find(List<Map<String, dynamic>> d) =>
      http.Response(jsonEncode({'docs': d}), 200);

  group('carga', () {
    test('cargarMisGrupos llena el estado con los grupos del usuario', () async {
      final cli = MockClient((r) async {
        expect(jsonDecode(r.body)['selector']['miembros'][r'$elemMatch']['usuarioId'], 'u1');
        return find([_grupo(), _grupo('grupo:2')]);
      });
      await con(cli, () => n().cargarMisGrupos('u1'));
      expect(c.read(gruposProvider).value!.map((g) => g.id), ['grupo:1', 'grupo:2']);
    });

    test('cargarMisGrupos: error HTTP deja lista vacía y excepción deja error', () async {
      await con(MockClient((r) async => http.Response('x', 500)), () => n().cargarMisGrupos('u1'));
      expect(c.read(gruposProvider).value, isEmpty);
      await con(MockClient((r) async => throw Exception('red')), () => n().cargarMisGrupos('u1'));
      expect(c.read(gruposProvider).hasError, isTrue);
    });

    test('cargarGruposPublicos filtra por privacidad y tolera fallos', () async {
      final cli = MockClient((r) async {
        expect(jsonDecode(r.body)['selector']['privacidad'], 'publica');
        return find([_grupo()]);
      });
      expect((await con(cli, () => n().cargarGruposPublicos())).length, 1);
      expect(await con(MockClient((r) async => http.Response('x', 500)), () => n().cargarGruposPublicos()), isEmpty);
      expect(await con(MockClient((r) async => throw Exception('red')), () => n().cargarGruposPublicos()), isEmpty);
    });
  });

  group('crearGrupo', () {
    test('con 201 agrega el grupo con el creador como admin', () async {
      Map<String, dynamic>? enviado;
      final cli = MockClient((r) async {
        enviado = jsonDecode(r.body) as Map<String, dynamic>;
        return http.Response('{"ok":true}', 201);
      });
      final ok = await con(cli, () => n().crearGrupo(creadorId: 'u1', creadorNombre: 'Ana', nombre: 'G', descripcion: 'd'));
      expect(ok, isTrue);
      expect(enviado!['miembros'][0]['rol'], 'admin');
      expect(c.read(gruposProvider).value!.single.nombre, 'G');
    });

    test('con error del servidor o de red devuelve false', () async {
      Future<bool> crear(MockClient cli) => con(cli, () => n().crearGrupo(creadorId: 'u1', creadorNombre: 'Ana', nombre: 'G', descripcion: 'd'));
      expect(await crear(MockClient((r) async => http.Response('x', 500))), isFalse);
      expect(await crear(MockClient((r) async => throw Exception('red'))), isFalse);
    });
  });

  group('agregarMiembro', () {
    test('agrega al nuevo miembro con PUT', () async {
      Map<String, dynamic>? guardado;
      final cli = MockClient((r) async {
        if (r.method == 'GET') return http.Response(jsonEncode(_grupo()), 200);
        guardado = jsonDecode(r.body) as Map<String, dynamic>;
        return http.Response('{"ok":true}', 201);
      });
      expect(await con(cli, () => n().agregarMiembro('grupo:1', _miembro('u2'))), isTrue);
      expect((guardado!['miembros'] as List).length, 2);
    });

    test('si ya es miembro no escribe', () async {
      final metodos = <String>[];
      final cli = MockClient((r) async {
        metodos.add(r.method);
        return http.Response(jsonEncode(_grupo()), 200);
      });
      expect(await con(cli, () => n().agregarMiembro('grupo:1', _miembro('u1'))), isTrue);
      expect(metodos, ['GET']);
    });

    test('devuelve false si el grupo no existe o el PUT falla', () async {
      expect(await con(MockClient((r) async => http.Response('x', 404)), () => n().agregarMiembro('g', _miembro('u2'))), isFalse);
      final falla = MockClient((r) async => r.method == 'GET' ? http.Response(jsonEncode(_grupo()), 200) : http.Response('x', 409));
      expect(await con(falla, () => n().agregarMiembro('grupo:1', _miembro('u2'))), isFalse);
    });
  });

  group('actualizarGrupo', () {
    test('con 201 reemplaza el grupo en el estado', () async {
      final base = MockClient((r) async => find([_grupo()]));
      await con(base, () => n().cargarMisGrupos('u1'));
      final editado = GrupoModel.fromJson(_grupo())..nombre = 'Nuevo nombre';
      final cli = MockClient((r) async => http.Response('{"ok":true}', 201));
      expect(await con(cli, () => n().actualizarGrupo(editado)), isTrue);
      expect(c.read(gruposProvider).value!.single.nombre, 'Nuevo nombre');
    });

    test('con error devuelve false', () async {
      final g = GrupoModel.fromJson(_grupo());
      expect(await con(MockClient((r) async => http.Response('x', 409)), () => n().actualizarGrupo(g)), isFalse);
      expect(await con(MockClient((r) async => throw Exception('red')), () => n().actualizarGrupo(g)), isFalse);
    });
  });
}
