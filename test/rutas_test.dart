import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:buscobien/07_routes/app_routes.dart';

void main() {
  group('routeGenerate', () {
    test('una ruta sin case devuelve null', () {
      expect(routeGenerate(const RouteSettings(name: '/rutainexistente')), isNull);
    });

    test('una ruta que ya no existe en AppRoutes (/login) también devuelve null', () {
      expect(routeGenerate(const RouteSettings(name: '/login')), isNull);
    });

    test('las rutas sin argumentos devuelven un MaterialPageRoute con el mismo nombre', () {
      for (final nombre in [AppRoutes.principal, AppRoutes.registro, AppRoutes.perfil, AppRoutes.listaspropiedades, AppRoutes.plataforma, AppRoutes.gestionavatar]) {
        final ruta = routeGenerate(RouteSettings(name: nombre));
        expect(ruta, isA<MaterialPageRoute>(), reason: nombre);
        expect(ruta!.settings.name, nombre);
      }
    });

    test('las rutas con argumento simple conservan el nombre y los argumentos', () {
      final casos = {
        AppRoutes.sinconeccion: 'sin red',
        AppRoutes.listalocalidades: 44100,
        AppRoutes.preferencias: 'u1',
        AppRoutes.checaconeccion: <String, dynamic>{'ref': null},
      };
      casos.forEach((nombre, argumento) {
        final ruta = routeGenerate(RouteSettings(name: nombre, arguments: argumento));
        expect(ruta, isA<MaterialPageRoute>(), reason: nombre);
        expect(ruta!.settings.arguments, argumento);
      });
    });

    test('un argumento de tipo equivocado falla con TypeError', () {
      expect(
        () => routeGenerate(const RouteSettings(name: AppRoutes.listalocalidades, arguments: 'no es int')),
        throwsA(isA<TypeError>()),
      );
    });

    test('/cambiopassword sin argumentos falla en tiempo de ejecución (REQ-ROUT-016)', () {
      expect(() => routeGenerate(const RouteSettings(name: AppRoutes.cambioPassword)), throwsA(isA<TypeError>()));
    });
  });
}
