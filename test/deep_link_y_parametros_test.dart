import 'package:buscobien/07_routes/app_routes.dart';
import 'package:buscobien/07_routes/deep_link_handler.dart';
import 'package:buscobien/07_routes/routes_parameters.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('navigateIfRecovery (REQ-ROUT-007/008)', () {
    late GlobalKey<NavigatorState> clave;
    late List<RouteSettings> empujadas;

    Future<void> montar(WidgetTester t) async {
      clave = GlobalKey<NavigatorState>();
      empujadas = [];
      await t.pumpWidget(
        MaterialApp(
          navigatorKey: clave,
          home: const SizedBox(),
          onGenerateRoute: (s) {
            empujadas.add(s);
            return MaterialPageRoute(
              settings: s,
              builder: (_) => const SizedBox(),
            );
          },
        ),
      );
    }

    testWidgets('abre el cambio de contraseña con token y perfil', (t) async {
      await montar(t);
      navigateIfRecovery(
        Uri.parse('https://buscobien.net/recuperar?token=abc&perfil=Usuario'),
        clave,
      );
      await t.pumpAndSettle();
      expect(empujadas.last.name, AppRoutes.cambioPassword);
      expect(empujadas.last.arguments, {'token': 'abc', 'perfil': 'Usuario'});
    });

    testWidgets('ignora rutas que no son /recuperar', (t) async {
      await montar(t);
      navigateIfRecovery(Uri.parse('https://buscobien.net/otra?token=a&perfil=b'), clave);
      await t.pumpAndSettle();
      expect(empujadas, isEmpty);
    });

    testWidgets('ignora el enlace si falta token o perfil', (t) async {
      await montar(t);
      navigateIfRecovery(Uri.parse('https://buscobien.net/recuperar?token=a'), clave);
      navigateIfRecovery(Uri.parse('https://buscobien.net/recuperar?perfil=b'), clave);
      navigateIfRecovery(Uri.parse('https://buscobien.net/recuperar?token=&perfil=b'), clave);
      await t.pumpAndSettle();
      expect(empujadas, isEmpty);
    });

    testWidgets('acepta localhost en desarrollo web', (t) async {
      await montar(t);
      navigateIfRecovery(Uri.parse('http://localhost:5000/recuperar?token=x&perfil=Promotor'), clave);
      await t.pumpAndSettle();
      expect(empujadas.single.name, AppRoutes.cambioPassword);
    });
  });

  group('routes_parameters', () {
    test('los parámetros iniciales están vacíos o en valores neutros', () {
      expect(parameterLocalidad['cp'], 3100);
      expect(parametrosListaFotos['skip'], 0);
      expect(parameterEditaEspacio.espacioscasa.idPropiedad, '');
      expect(parameterEditaFotos.espacioscasa.idPropiedad, '');
      expect(inicializaValueGetCasa.espacioscasa.activa, 1);
      expect(parameterFotoPrincipal, 0);
      expect(parameterActualizaEspacio, isNotEmpty);
      expect(parameterCapturaFotosCasa, isNotEmpty);
      expect(parameterPaginaMenuTipoTransaccion, isNotEmpty);
      expect(parameterGestionFoto, isNotEmpty);
      expect(parameterPaginaChecaConeccion.containsKey('ref'), isTrue);
    });

    test('ArgumentsLocalidad.setCP actualiza el código postal', () {
      final a = ArgumentsLocalidad(cp: 1000)..setCP(44100);
      expect(a.cp, 44100);
    });

    test('los resultados de guardar foto conservan sus datos', () {
      final r = ResultSaveFoto(
        resultadoEnFotos: ResultadoGuardaFoto(statusCode: 201, idFoto: 'f1'),
        resultadoEnEspacios: 200,
      );
      expect(r.resultadoEnFotos.idFoto, 'f1');
      expect(r.resultadoEnEspacios, 200);
    });
  });
}
