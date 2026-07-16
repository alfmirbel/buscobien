//------------------------------------------------------------------------------
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../20_var_globales/var_color_themes.dart';
import '../60_global_widgets/debugprint.dart';
import 'connectivitycheck_provider.dart';

class PaginaSinConeccion extends ConsumerWidget {
  // Cambiar a ConsumerWidget
  final String letrero;
  const PaginaSinConeccion(this.letrero, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    debugPrintLevels(1, " **************************************************");
    debugPrintLevels(1, " 1, PaginaSinConeccion build");
    debugPrintLevels(1, " **************************************************");

    // ESCUCHAR CAMBIOS: Si vuelve el internet, cerrar esta pantalla automáticamente
    ref.listen(checaConeccionesProvider, (prev, next) {
      next.whenData((coneccion) {
        if (coneccion.etiqueta == "Conectado") {
          Navigator.of(context).pop(); // Cierra la pantalla de error
        }
      });
    });

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 40.0, // default kToolbarHeight = 56.0
        centerTitle: true,
        titleSpacing: 0,
        backgroundColor: appTheme.error,
        automaticallyImplyLeading: false,
        iconTheme: IconThemeData(size: 14, color: appTheme.onError),
        /*
        leading: IconButton(
          icon: const Icon(Symbols.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        */
        title: Text(
          "buscobien: error en la aplicación",
          style: TextStyle(
            color: appTheme.onError,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Estado de la conexión a Internet',
              style: TextStyle(
                color: appTheme.error,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 15),
            Text(
              letrero,
              style: TextStyle(
                color: appTheme.error,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 15),
            Center(
              child: Text(
                'Para usar la aplicación',
                style: TextStyle(
                  color: appTheme.error,
                  fontWeight: FontWeight.normal,
                  fontSize: 14,
                ),
              ),
            ),
            Center(
              child: Text(
                'se requiere acceso a Internet.',
                style: TextStyle(
                  color: appTheme.error,
                  fontWeight: FontWeight.normal,
                  fontSize: 14,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Center(
              child: Text(
                'Verifica tu conexión',
                style: TextStyle(
                  color: appTheme.error,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: Text(
                'Al activar tu conexión',
                style: TextStyle(
                  color: appTheme.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
            Center(
              child: Text(
                'se inicia la aplicación',
                style: TextStyle(
                  color: appTheme.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
            Center(
              child: Text(
                'en automático.',
                style: TextStyle(
                  color: appTheme.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
            /*
            SizedBox(
              width: 200,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(3),
                  backgroundColor: appTheme.error,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: Text(
                  '  Regresar ',
                  style: TextStyle(
                    color: appTheme.onError,
                    //backgroundColor: appTheme.onTertiary,
                    fontSize: 12,
                    fontFamily: "Comfortaa",
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // checar regreso
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            */
          ],
        ),
      ),
    );
  }
}
