import 'package:buscobien/22_imagenes/tus_espacios_fotos_propiedad/manejo_de_fotos/futures_y_providers/foto_por_id_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('FotoBuilder entrega espera, dato y error como AsyncSnapshot', (
    t,
  ) async {
    var llamadas = 0;
    final contenedor = ProviderContainer(
      overrides: [
        fotoPorIdProvider('a').overrideWith((ref) async {
          llamadas++;
          return 'FOTO';
        }),
        fotoPorIdProvider('mala').overrideWith(
          (ref) => Future<String>.error('falla'),
        ),
      ],
    );
    addTearDown(contenedor.dispose);

    Widget app(String id) => UncontrolledProviderScope(
      container: contenedor,
      child: MaterialApp(
        home: FotoBuilder(
          idFoto: id,
          builder: (c, s) {
            if (s.connectionState == ConnectionState.waiting) {
              return const Text('espera');
            }
            return Text(s.hasError ? 'error' : 'dato:${s.data}');
          },
        ),
      ),
    );

    await t.pumpWidget(app('a'));
    expect(find.text('espera'), findsOneWidget);
    await t.pumpAndSettle();
    expect(find.text('dato:FOTO'), findsOneWidget);

    await t.pumpWidget(app('a')); // reconstruir no vuelve a pedir la foto
    await t.pumpAndSettle();
    expect(llamadas, 1);

    await t.pumpWidget(app('mala'));
    await t.pumpAndSettle();
    expect(find.text('error'), findsOneWidget);
  });
}
