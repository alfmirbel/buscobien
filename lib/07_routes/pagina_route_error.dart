import 'package:flutter/material.dart';
import '../20_var_globales/var_color_themes.dart';
import '../60_global_widgets/debugprint.dart';

class PaginaDeError extends StatelessWidget {
  final String letrero;
  const PaginaDeError(this.letrero, {super.key});

  @override
  Widget build(BuildContext context) {
    debugPrintLevels(1, " **************************************************");
    debugPrintLevels(1, " 1, PaginaDeError build");
    debugPrintLevels(1, " **************************************************");

    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 40.0, // default kToolbarHeight = 56.0
          centerTitle: true,
          titleSpacing: 0,
          backgroundColor: appTheme.error,
          automaticallyImplyLeading: false,

          title: Text(
            "Error en la aplicación",
            style: TextStyle(
              color: appTheme.onError,
              fontWeight: FontWeight.normal,
              fontSize: 14,
            ),
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Ocurrio el siguiente problema',
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
                  'Vuelva a intentarlo',
                  style: TextStyle(
                    color: appTheme.error,
                    fontWeight: FontWeight.normal,
                    fontSize: 14,
                  ),
                ),
              ),
              const SizedBox(height: 15),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(3),
                  backgroundColor: appTheme.error,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: Text(
                  'Salir',
                  style: TextStyle(
                    color: appTheme.onError,
                    //backgroundColor: appTheme.onTertiary,
                    fontSize: 12,
                    fontFamily: "Comfortaa",
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // checar regreso
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        ));
  }
}
