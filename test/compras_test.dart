import 'dart:convert';

import 'package:buscobien/07_routes/app_routes.dart';
import 'package:buscobien/07_routes/deep_link_handler.dart';
import 'package:buscobien/08_pantallas/tu_cuenta/tus_espacios/compra_espacios/compras_api.dart';
import 'package:buscobien/08_pantallas/tu_cuenta/tus_espacios/compra_espacios/form_compra_espacios.dart';
import 'package:buscobien/08_pantallas/tu_cuenta/tus_espacios/compra_espacios/pagina_estado_compra.dart';
import 'package:buscobien/10_user_login/usuario_login/session_storage.dart';
import 'package:buscobien/40_security/api_client.dart';
import 'package:buscobien/40_security/token_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

class _Almacen implements SessionStorage {
  final datos = <String, String>{};
  @override
  Future<void> delete({required String key}) async => datos.remove(key);
  @override
  Future<void> deleteAll() async => datos.clear();
  @override
  Future<String?> read({required String key}) async => datos[key];
  @override
  Future<void> write({required String key, required String value}) async => datos[key] = value;
}

http.Response _json(Object cuerpo, [int estado = 200]) =>
    http.Response(jsonEncode(cuerpo), estado, headers: {'content-type': 'application/json'});

const _catalogo = {
  'moneda': 'mxn',
  'iva': 0.16,
  'mesesMaximo': 12,
  'maximoPorTipo': 20,
  'tipos': {
    'normales': {'nombre': 'Normal', 'precioMensualCentavos': 9900},
    'destacados': {'nombre': 'Destacado', 'precioMensualCentavos': 19900},
    'superdestacados': {'nombre': 'Súper destacado', 'precioMensualCentavos': 29900},
    'oportunidades': {'nombre': 'Oportunidad', 'precioMensualCentavos': 14900},
    'remates': {'nombre': 'Remate', 'precioMensualCentavos': 12900},
  },
};

/// Servidor falso: guarda las peticiones y responde según [responder].
class _Servidor {
  _Servidor(this.responder);
  final http.Response Function(http.Request) responder;
  final peticiones = <http.Request>[];

  ComprasApi get api {
    final tokens = TokenStore(_Almacen());
    final cliente = ApiClient(baseUrl: 'https://api.test', tokens: tokens);
    return ComprasApi(api: cliente);
  }

  Future<T> ejecutar<T>(Future<T> Function() f) => http.runWithClient(
        f,
        () => MockClient((r) async {
          peticiones.add(r);
          return responder(r);
        }),
      );
}

void main() {
  final precios = PreciosCompra.desdeJson(_catalogo)!;

  group('importes', () {
    test('la vista previa usa la misma fórmula que el servidor', () {
      final v = calcularVistaPrevia(precios, {'normales': 2, 'destacados': 1}, 3);
      // (9900×2 + 19900) × 3 = 119 100 ; IVA 16 % = 19 056
      expect(v.subtotalCentavos, 119100);
      expect(v.impuestosCentavos, 19056);
      expect(v.totalCentavos, 138156);
      expect(v.vacia, isFalse);
    });

    test('sin espacios no hay nada que pagar', () {
      expect(calcularVistaPrevia(precios, {}, 5).vacia, isTrue);
    });

    test('el IVA se redondea al centavo', () {
      final v = calcularVistaPrevia(precios, {'normales': 1}, 1); // 9900 × 0.16 = 1584
      expect(v.impuestosCentavos, 1584);
      final w = calcularVistaPrevia(const PreciosCompra(
        moneda: 'mxn', iva: 0.16, mesesMaximo: 12, maximoPorTipo: 20,
        nombres: {}, precioMensualCentavos: {'normales': 1050},
      ), {'normales': 1}, 1); // 168.0
      expect(w.impuestosCentavos, 168);
    });

    test('formatoDinero separa miles y muestra centavos', () {
      expect(formatoDinero(0), r'$0.00');
      expect(formatoDinero(5), r'$0.05');
      expect(formatoDinero(123456), r'$1,234.56');
      expect(formatoDinero(100000000), r'$1,000,000.00');
    });

    test('un catálogo incompleto se rechaza', () {
      expect(PreciosCompra.desdeJson(null), isNull);
      expect(PreciosCompra.desdeJson({'moneda': 'mxn'}), isNull);
    });
  });

  group('ComprasApi', () {
    test('lee los precios', () async {
      final s = _Servidor((_) => _json(_catalogo));
      final r = await s.ejecutar(() => s.api.precios());
      expect(r.ok, isTrue);
      expect(r.dato!.mesesMaximo, 12);
      expect(s.peticiones.single.url.path, '/compras/precios');
    });

    test('iniciar el pago envía solo los tipos con cantidad', () async {
      final s = _Servidor((_) => _json({'compraId': 'compra:abc', 'checkoutUrl': 'https://checkout.stripe.com/x'}, 201));
      final r = await s.ejecutar(() => s.api.iniciarPago(meses: 2, cantidades: {'normales': 3, 'remates': 0}));
      expect(r.ok, isTrue);
      expect(r.dato!.checkoutUrl, 'https://checkout.stripe.com/x');
      final cuerpo = jsonDecode(s.peticiones.single.body) as Map<String, dynamic>;
      expect(cuerpo, {'meses': 2, 'cantidades': {'normales': 3}});
    });

    test('pagos deshabilitados dan un mensaje claro', () async {
      final s = _Servidor((_) => _json({'error': 'x', 'code': 'PAYMENTS_UNAVAILABLE'}, 503));
      final r = await s.ejecutar(() => s.api.iniciarPago(meses: 1, cantidades: {'normales': 1}));
      expect(r.ok, isFalse);
      expect(r.mensaje, contains('no están disponibles'));
    });

    test('respuesta sin enlace de pago es un error', () async {
      final s = _Servidor((_) => _json({'compraId': 'compra:abc'}, 201));
      final r = await s.ejecutar(() => s.api.iniciarPago(meses: 1, cantidades: {'normales': 1}));
      expect(r.ok, isFalse);
    });

    test('lee el estado de una compra', () async {
      final s = _Servidor((_) => _json({'id': 'compra:abc', 'estado': 'pagada', 'espaciosCreados': true, 'total': 1385}));
      final r = await s.ejecutar(() => s.api.estado('compra:abc'));
      expect(r.dato!.pagada, isTrue);
      expect(r.dato!.espaciosCreados, isTrue);
      expect(r.dato!.total, 1385.0);
    });

    test('estados terminados sin pago', () {
      for (final e in ['fallida', 'expirada', 'inconsistente']) {
        expect(EstadoCompra(id: 'x', estado: e, espaciosCreados: false, total: 0).terminadaSinPago, isTrue);
      }
      expect(const EstadoCompra(id: 'x', estado: 'pendiente', espaciosCreados: false, total: 0).terminadaSinPago, isFalse);
    });
  });

  group('PaginaEstadoCompra', () {
    Widget app(ComprasApi api, {Duration intervalo = const Duration(milliseconds: 10), int maximo = 100}) => ProviderScope(
          child: MaterialApp(
            routes: {AppRoutes.principal: (_) => const Scaffold(body: Text('principal'))},
            home: PaginaEstadoCompra(compraId: 'compra:abc', api: api, intervalo: intervalo, maximoConsultas: maximo),
          ),
        );

    testWidgets('espera el pago, lo confirma y deja de consultar', (tester) async {
      var llamadas = 0;
      final s = _Servidor((_) {
        llamadas++;
        final estado = llamadas < 3 ? 'pendiente' : 'pagada';
        return _json({'id': 'compra:abc', 'estado': estado, 'espaciosCreados': estado == 'pagada', 'total': 100});
      });
      await http.runWithClient(() async {
        await tester.pumpWidget(app(s.api));
        expect(find.text('Esperando la confirmación del pago'), findsOneWidget);
        for (var i = 0; i < 6; i++) {
          await tester.pump(const Duration(milliseconds: 20));
        }
        expect(find.text('Pago confirmado'), findsOneWidget);
        final hasta = llamadas;
        await tester.pump(const Duration(milliseconds: 100));
        expect(llamadas, hasta, reason: 'ya no debe consultar');
        await tester.pumpWidget(const SizedBox());
      }, () => MockClient((r) async => s.responder(r)));
    });

    testWidgets('una compra expirada se informa sin cobro', (tester) async {
      final s = _Servidor((_) => _json({'id': 'compra:abc', 'estado': 'expirada', 'espaciosCreados': false, 'total': 0}));
      await http.runWithClient(() async {
        await tester.pumpWidget(app(s.api));
        await tester.pump(const Duration(milliseconds: 30));
        expect(find.text('La sesión de pago venció'), findsOneWidget);
        expect(find.text('Salir'), findsOneWidget);
        await tester.pumpWidget(const SizedBox());
      }, () => MockClient((r) async => s.responder(r)));
    });

    testWidgets('al agotar las consultas ofrece revisar de nuevo', (tester) async {
      final s = _Servidor((_) => _json({'id': 'compra:abc', 'estado': 'pendiente', 'espaciosCreados': false, 'total': 0}));
      await http.runWithClient(() async {
        await tester.pumpWidget(app(s.api, maximo: 2));
        for (var i = 0; i < 5; i++) {
          await tester.pump(const Duration(milliseconds: 20));
        }
        expect(find.text('Seguimos esperando la confirmación'), findsOneWidget);
        expect(find.text('Revisar de nuevo'), findsOneWidget);
        await tester.pumpWidget(const SizedBox());
      }, () => MockClient((r) async => s.responder(r)));
    });
  });

  group('PaginaCompraEspacios', () {
    testWidgets('muestra el resumen y habilita el pago al elegir espacios', (tester) async {
      final s = _Servidor((_) => _json(_catalogo));
      tester.view.physicalSize = const Size(800, 2600); // que el ListView construya todo
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      await http.runWithClient(() async {
        await tester.pumpWidget(ProviderScope(child: MaterialApp(home: PaginaCompraEspacios(api: s.api))));
        await tester.pump(const Duration(milliseconds: 50));
        expect(find.text('Normal'), findsOneWidget);

        FilledButton boton() => tester.widget<FilledButton>(find.byWidgetPredicate((w) => w is FilledButton).last);
        expect(boton().onPressed, isNull, reason: 'sin espacios no se puede pagar');

        await tester.tap(find.byTooltip('Agregar uno').first);
        await tester.pump();
        expect(boton().onPressed, isNotNull);
        expect(find.text(r'$99.00'), findsWidgets); // subtotal de 1 espacio normal × 1 mes
        expect(find.text(r'$114.84'), findsOneWidget); // total con IVA 16 %
        await tester.pumpWidget(const SizedBox());
      }, () => MockClient((r) async => s.responder(r)));
    });

    testWidgets('si no hay precios ofrece reintentar', (tester) async {
      final s = _Servidor((_) => _json({'error': 'x', 'code': 'PRICES_UNAVAILABLE'}, 503));
      await http.runWithClient(() async {
        await tester.pumpWidget(ProviderScope(child: MaterialApp(home: PaginaCompraEspacios(api: s.api))));
        await tester.pump(const Duration(milliseconds: 50));
        expect(find.text('Reintentar'), findsOneWidget);
        await tester.pumpWidget(const SizedBox());
      }, () => MockClient((r) async => s.responder(r)));
    });
  });

  group('regreso desde Stripe', () {
    testWidgets('/compra/exito abre el estado de la compra', (tester) async {
      final llave = GlobalKey<NavigatorState>();
      final vistos = <RouteSettings>[];
      await tester.pumpWidget(MaterialApp(
        navigatorKey: llave,
        navigatorObservers: [_Observador(vistos)],
        onGenerateRoute: (s) => MaterialPageRoute(settings: s, builder: (_) => const SizedBox()),
      ));
      navigateIfPurchase(Uri.parse('https://buscobien.net/compra/exito?compra=compra%3Aabc'), llave);
      await tester.pump();
      expect(vistos.last.name, AppRoutes.estadoCompra);
      expect(vistos.last.arguments, 'compra:abc');
    });

    testWidgets('sin id de compra o en otra ruta no hace nada', (tester) async {
      final llave = GlobalKey<NavigatorState>();
      final vistos = <RouteSettings>[];
      await tester.pumpWidget(MaterialApp(
        navigatorKey: llave,
        navigatorObservers: [_Observador(vistos)],
        onGenerateRoute: (s) => MaterialPageRoute(settings: s, builder: (_) => const SizedBox()),
      ));
      final antes = vistos.length;
      navigateIfPurchase(Uri.parse('https://buscobien.net/compra/exito'), llave);
      navigateIfPurchase(Uri.parse('https://buscobien.net/otra?compra=x'), llave);
      await tester.pump();
      expect(vistos.length, antes);
    });
  });
}

class _Observador extends NavigatorObserver {
  _Observador(this.vistos);
  final List<RouteSettings> vistos;
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) => vistos.add(route.settings);
}
