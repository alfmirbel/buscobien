import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

import 'package:buscobien/08_pantallas/tu_cuenta/grupos/providers/grupos_notifier.dart';

Map<String, dynamic> _grupo() => {
  '_id': 'grupo:1',
  '_rev': '1-abc',
  'type': 'grupo',
  'creadorId': 'u1',
  'creadorNombre': 'Ana',
  'nombre': 'Compradores',
  'miembros': [
    {'usuarioId': 'u1', 'usuarioNombre': 'Ana', 'rol': 'admin', 'fechaIngreso': ''},
    {'usuarioId': 'u2', 'usuarioNombre': 'Luis', 'rol': 'miembro', 'fechaIngreso': ''},
  ],
};

void main() {
  group('GruposNotifier.eliminarMiembro', () {
    test('quita al miembro y guarda el grupo con PUT', () async {
      final metodos = <String>[];
      Map<String, dynamic>? guardado;
      final cliente = MockClient((req) async {
        metodos.add(req.method);
        if (req.method == 'GET') return http.Response(jsonEncode(_grupo()), 200);
        guardado = jsonDecode(req.body) as Map<String, dynamic>;
        return http.Response('{"ok":true}', 201);
      });

      final contenedor = ProviderContainer();
      addTearDown(contenedor.dispose);
      final actualizado = await http.runWithClient(
        () => contenedor.read(gruposProvider.notifier).eliminarMiembro('grupo:1', 'u2'),
        () => cliente,
      );

      expect(metodos, ['GET', 'PUT']);
      expect(actualizado!.miembros.map((m) => m.usuarioId), ['u1']);
      expect((guardado!['miembros'] as List).length, 1);
    });

    test('no elimina a un administrador ni escribe en la base', () async {
      final metodos = <String>[];
      final cliente = MockClient((req) async {
        metodos.add(req.method);
        return http.Response(jsonEncode(_grupo()), 200);
      });

      final contenedor = ProviderContainer();
      addTearDown(contenedor.dispose);
      final actualizado = await http.runWithClient(
        () => contenedor.read(gruposProvider.notifier).eliminarMiembro('grupo:1', 'u1'),
        () => cliente,
      );

      expect(actualizado, isNull);
      expect(metodos, ['GET']);
    });

    test('devuelve null si el usuario no es miembro o la escritura falla', () async {
      var llamadas = 0;
      final cliente = MockClient((req) async {
        llamadas++;
        if (req.method == 'GET') return http.Response(jsonEncode(_grupo()), 200);
        return http.Response('conflict', 409);
      });

      final contenedor = ProviderContainer();
      addTearDown(contenedor.dispose);
      final notifier = contenedor.read(gruposProvider.notifier);

      expect(
        await http.runWithClient(() => notifier.eliminarMiembro('grupo:1', 'nadie'), () => cliente),
        isNull,
      );
      expect(
        await http.runWithClient(() => notifier.eliminarMiembro('grupo:1', 'u2'), () => cliente),
        isNull,
      );
      expect(llamadas, 3); // GET; GET + PUT rechazado
    });
  });
}
