import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

import 'package:buscobien/08_pantallas/tu_cuenta/conocidos/providers/conocidos_notifier.dart';

void main() {
  group('ConocidosNotifier.eliminarContacto', () {
    test('lee la revisión y borra el documento con DELETE ?rev=', () async {
      final peticiones = <String>[];
      final cliente = MockClient((req) async {
        peticiones.add('${req.method} ${req.url.path}${req.url.query.isEmpty ? '' : '?${req.url.query}'}');
        if (req.method == 'GET') return http.Response(jsonEncode({'_id': 'inv1', '_rev': '3-xyz'}), 200);
        return http.Response('{"ok":true}', 200);
      });
      final contenedor = ProviderContainer();
      addTearDown(contenedor.dispose);

      final ok = await http.runWithClient(
        () => contenedor.read(conocidosProvider.notifier).eliminarContacto('inv1'),
        () => cliente,
      );

      expect(ok, isTrue);
      expect(peticiones.length, 2);
      expect(peticiones[0], startsWith('GET '));
      expect(peticiones[1], endsWith('/inv1?rev=3-xyz'));
    });

    test('si el documento ya no existe lo da por eliminado y si falla el borrado devuelve false', () async {
      final contenedor = ProviderContainer();
      addTearDown(contenedor.dispose);
      final notifier = contenedor.read(conocidosProvider.notifier);

      final yaNoExiste = MockClient((req) async => http.Response('not_found', 404));
      expect(await http.runWithClient(() => notifier.eliminarContacto('inv9'), () => yaNoExiste), isTrue);

      final falla = MockClient((req) async {
        if (req.method == 'GET') return http.Response(jsonEncode({'_rev': '1-a'}), 200);
        return http.Response('conflict', 409);
      });
      expect(await http.runWithClient(() => notifier.eliminarContacto('inv1'), () => falla), isFalse);
    });
  });
}
