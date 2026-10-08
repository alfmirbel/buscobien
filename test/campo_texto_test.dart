import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:buscobien/60_global_widgets/campo_texto.dart';

void main() {
  group('Validadores', () {
    test('un valor vacío es válido salvo que el campo sea obligatorio', () {
      for (final t in TipoCampo.values) {
        expect(Validadores.validar(t, ''), isNull, reason: t.name);
        expect(Validadores.validar(t, '   '), isNull, reason: t.name);
        expect(Validadores.validar(t, '', esObligatorio: true, etiqueta: 'Nombre'), 'Nombre es obligatorio');
      }
    });

    test('entero y código postal', () {
      expect(Validadores.entero('3'), isNull);
      expect(Validadores.entero('3.5'), isNotNull);
      expect(Validadores.entero('tres'), isNotNull);
      expect(Validadores.codigoPostal('03100'), isNull);
      expect(Validadores.codigoPostal('3100'), isNotNull);
    });

    test('decimal y dinero', () {
      expect(Validadores.decimal('120'), isNull);
      expect(Validadores.decimal('120.5'), isNull);
      expect(Validadores.decimal('120,5'), isNotNull);
      expect(Validadores.dinero('1500000'), isNull);
      expect(Validadores.dinero('1,500,000.00'), isNull);
      expect(Validadores.dinero(r'$ 2500.50'), isNull);
      expect(Validadores.dinero('mucho'), isNotNull);
    });

    test('teléfono: 7 a 15 dígitos con separadores permitidos', () {
      expect(Validadores.telefono('55 1234 5678'), isNull);
      expect(Validadores.telefono('+52 (55) 1234-5678'), isNull);
      expect(Validadores.telefono('12345'), isNotNull);
      expect(Validadores.telefono('55abc12345'), isNotNull);
    });

    test('correo y url', () {
      expect(Validadores.correo('ana@ejemplo.com'), isNull);
      expect(Validadores.correo('ana@ejemplo'), isNotNull);
      expect(Validadores.correo('ana ejemplo.com'), isNotNull);
      expect(Validadores.url('https://buscobien.net/video'), isNull);
      expect(Validadores.url('buscobien.net'), isNotNull);
      expect(Validadores.url('ftp://x.com'), isNotNull);
    });

    test('latitud y longitud dentro de rango', () {
      expect(Validadores.latitud('19.4326'), isNull);
      expect(Validadores.latitud('-90'), isNull);
      expect(Validadores.latitud('91'), isNotNull);
      expect(Validadores.longitud('-99.1332'), isNull);
      expect(Validadores.longitud('181'), isNotNull);
      expect(Validadores.longitud('abc'), isNotNull);
    });
  });

  group('CampoTexto', () {
    Future<void> montar(WidgetTester tester, Widget campo) => tester.pumpWidget(
      MaterialApp(home: Scaffold(body: Form(autovalidateMode: AutovalidateMode.always, child: campo))),
    );

    testWidgets('un campo entero solo acepta dígitos y respeta la longitud', (tester) async {
      String? ultimo;
      await montar(tester, CampoTexto(etiqueta: 'Recámaras', valorInicial: '', tipo: TipoCampo.entero, onChanged: (v) => ultimo = v));
      await tester.enterText(find.byType(TextFormField), '12ab3456789');
      await tester.pump();
      expect(ultimo, '123456'); // sin letras y recortado a 6 dígitos
    });

    testWidgets('muestra el error de validación y el asterisco de obligatorio', (tester) async {
      await montar(tester, CampoTexto(etiqueta: 'Correo', valorInicial: 'no-es-correo', tipo: TipoCampo.correo, obligatorio: true, onChanged: (_) {}));
      await tester.pump();
      expect(find.text('Escribe un correo válido (nombre@dominio.com)'), findsOneWidget);
      expect(find.text('Correo *'), findsOneWidget);
    });

    testWidgets('usa el teclado del tipo de campo', (tester) async {
      await montar(tester, CampoTexto(etiqueta: 'Teléfono', valorInicial: '', tipo: TipoCampo.telefono, onChanged: (_) {}));
      final campo = tester.widget<TextField>(find.byType(TextField));
      expect(campo.keyboardType, TextInputType.phone);
    });
  });
}
