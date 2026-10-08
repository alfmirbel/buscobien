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
      for (final nombre in [AppRoutes.principal, AppRoutes.registro, AppRoutes.perfil, AppRoutes.listaspropiedades]) {
        final ruta = routeGenerate(RouteSettings(name: nombre));
        expect(ruta, isA<MaterialPageRoute>(), reason: nombre);
        expect(ruta!.settings.name, nombre);
      }
    });

    test('/cambiopassword sin argumentos falla en tiempo de ejecución (REQ-ROUT-016)', () {
      expect(() => routeGenerate(const RouteSettings(name: AppRoutes.cambioPassword)), throwsA(isA<TypeError>()));
    });
  });
}
