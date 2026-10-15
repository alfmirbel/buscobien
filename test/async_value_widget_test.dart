import 'package:buscobien/60_global_widgets/async_value_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _app(AsyncValue<String> v, {VoidCallback? retry}) => MaterialApp(
  home: Scaffold(
    body: AsyncValueWidget<String>(
      value: v,
      mensajeError: 'Error al cargar prueba',
      onReintentar: retry,
      data: (d) => Text('dato: $d'),
    ),
  ),
);

void main() {
  testWidgets('muestra el indicador de carga', (t) async {
    await t.pumpWidget(_app(const AsyncLoading()));
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('muestra el dato', (t) async {
    await t.pumpWidget(_app(const AsyncData('uno')));
    expect(find.text('dato: uno'), findsOneWidget);
  });

  testWidgets('en error muestra el mensaje y reintenta', (t) async {
    var veces = 0;
    await t.pumpWidget(
      _app(AsyncError('x', StackTrace.empty), retry: () => veces++),
    );
    expect(find.text('Error al cargar prueba'), findsOneWidget);
    await t.tap(find.text('Reintentar'));
    expect(veces, 1);
  });

  testWidgets('sin onReintentar no muestra el botón', (t) async {
    await t.pumpWidget(_app(AsyncError('x', StackTrace.empty)));
    expect(find.text('Reintentar'), findsNothing);
  });
}
