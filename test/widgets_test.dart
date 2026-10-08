import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_symbols_icons/symbols.dart';

import 'package:buscobien/07_routes/pagina_route_error.dart';
import 'package:buscobien/08_pantallas/propiedades/acciones_propiedad.dart';

void main() {
  group('PaginaDeError', () {
    testWidgets('muestra el mensaje recibido y el botón Salir regresa a la pantalla anterior', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) => Scaffold(
              body: TextButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const PaginaDeError('Activa los permisos de ubicación')),
                ),
                child: const Text('abrir'),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('abrir'));
      await tester.pumpAndSettle();

      expect(find.text('Error en la aplicación'), findsOneWidget);
      expect(find.text('Activa los permisos de ubicación'), findsOneWidget);

      await tester.tap(find.text('Salir'));
      await tester.pumpAndSettle();
      expect(find.text('abrir'), findsOneWidget);
    });
  });

  group('BotonAccionPropiedad', () {
    testWidgets('muestra el título y ejecuta la acción al tocarlo', (tester) async {
      var toques = 0;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BotonAccionPropiedad(
              icono: Symbols.picture_as_pdf,
              titulo: 'PDF',
              tooltip: 'Exportar ficha en PDF',
              onTap: () => toques++,
            ),
          ),
        ),
      );
      expect(find.text('PDF'), findsOneWidget);
      await tester.tap(find.text('PDF'));
      expect(toques, 1);
    });
  });
}
