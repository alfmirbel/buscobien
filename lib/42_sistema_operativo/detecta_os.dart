// https://chtgupta.medium.com/stop-using-kisweb-the-right-way-to-implement-multi-platform-code-in-your-flutter-project-edcd67970aa3
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../07_routes/app_routes.dart';
import '../20_var_globales/var_color_themes.dart';
import '../20_var_globales/var_elementos_menus.dart';
import "package:flutter/foundation.dart";

class ElementoPlataforma {
  int index = 0;
  String etiqueta = "";
  IconData icono = Symbols.web;
  List<bool> buttonSelectOpcion = [
    false, // mobile
    false, // wifi
    false, // ethernet
    false, // vpn
    false, // bluetooth
    false, // other
    false, // none
  ];
  String nombrePlataforma = "";

  ElementoPlataforma(
    this.index,
    this.etiqueta,
    this.icono,
    this.buttonSelectOpcion,
    this.nombrePlataforma,
  );
}

List<String> listaNombrePlataforma = [
  "android",
  "fuchsia",
  "iOS",
  "linux",
  "macOS",
  "windows",
  "Web u otro",
];

List<String> plataformasCompressWeb = [
  "android",
  "fuchsia",
  "iOS",
  "Web u otro",
];

List<String> plataformasCompressWin = ["linux", "macOS", "windows"];

final checaPlataformaProvider = StateProvider<ElementoPlataforma>((ref) {
  return initialTiposElementoPlataforma;
});

ElementoPlataforma initialTiposElementoPlataforma = ElementoPlataforma(
  0,
  elementosPlataforma[0].etiqueta,
  elementosPlataforma[0].icono,
  [
    false, // android
    false, // fuchsia
    false, // iOS
    false, // linux
    false, // macOS
    false, // windows
    false, // No se pudo verificar
  ],
  "Sin verificar conexión",
);

void setCheckPlataformaProvider(WidgetRef ref) {
  // // //debugPrintLevels(2, "setCheckPlataformaProvider inicializa");

  ref.read(checaPlataformaProvider).index = 0; // none
  ref.read(checaPlataformaProvider).buttonSelectOpcion[0] = false;
  ref.read(checaPlataformaProvider).buttonSelectOpcion[1] = false;
  ref.read(checaPlataformaProvider).buttonSelectOpcion[2] = false;
  ref.read(checaPlataformaProvider).buttonSelectOpcion[3] = false;
  ref.read(checaPlataformaProvider).buttonSelectOpcion[4] = false;
  ref.read(checaPlataformaProvider).buttonSelectOpcion[5] = false;
  ref.read(checaPlataformaProvider).buttonSelectOpcion[6] = false;

  ref.read(checaPlataformaProvider).etiqueta =
      elementosPlataforma[0].etiqueta; // Sin conexión
  ref.read(checaPlataformaProvider).icono = elementosPlataforma[0].icono;

  if (kIsWeb) {
    initialTiposElementoPlataforma.buttonSelectOpcion[6] = true;
    ref.read(checaPlataformaProvider).nombrePlataforma = "Web u otro";
    ref.read(checaPlataformaProvider).index = 6;
    ref.read(checaPlataformaProvider).etiqueta =
        elementosPlataforma[6].etiqueta;
    ref.read(checaPlataformaProvider).icono = elementosPlataforma[6].icono;
    ref.read(checaPlataformaProvider).buttonSelectOpcion[6] = true;
  } else {
    switch (defaultTargetPlatform) {
      case (TargetPlatform.android):
        // // //debugPrintLevels(2, "setCheckConeccionesProvider android");
        initialTiposElementoPlataforma.buttonSelectOpcion[0] = true;
        ref.read(checaPlataformaProvider).nombrePlataforma = "android";
        ref.read(checaPlataformaProvider).index = 0;
        ref.read(checaPlataformaProvider).etiqueta =
            elementosPlataforma[0].etiqueta;
        ref.read(checaPlataformaProvider).icono = elementosPlataforma[0].icono;
        ref.read(checaPlataformaProvider).buttonSelectOpcion[0] = true;
        break;
      case (TargetPlatform.fuchsia):
        // // //debugPrintLevels(2, "setCheckConeccionesProvider fuchsia");
        initialTiposElementoPlataforma.buttonSelectOpcion[1] = true;
        ref.read(checaPlataformaProvider).nombrePlataforma = "fuchsia";
        ref.read(checaPlataformaProvider).index = 1;
        ref.read(checaPlataformaProvider).etiqueta =
            elementosPlataforma[1].etiqueta;
        ref.read(checaPlataformaProvider).icono = elementosPlataforma[1].icono;
        ref.read(checaPlataformaProvider).buttonSelectOpcion[1] = true;
        break;
      case (TargetPlatform.iOS):
        // // //debugPrintLevels(2, "setCheckConeccionesProvider iOS");
        initialTiposElementoPlataforma.buttonSelectOpcion[2] = true;
        ref.read(checaPlataformaProvider).nombrePlataforma = "iOS";
        ref.read(checaPlataformaProvider).index = 2;
        ref.read(checaPlataformaProvider).etiqueta =
            elementosPlataforma[2].etiqueta;
        ref.read(checaPlataformaProvider).icono = elementosPlataforma[2].icono;
        ref.read(checaPlataformaProvider).buttonSelectOpcion[2] = true;
        break;
      case (TargetPlatform.linux):
        // // //debugPrintLevels(2, "setCheckConeccionesProvider linux");
        initialTiposElementoPlataforma.buttonSelectOpcion[3] = true;
        ref.read(checaPlataformaProvider).nombrePlataforma = "linux";
        ref.read(checaPlataformaProvider).index = 3;
        ref.read(checaPlataformaProvider).etiqueta =
            elementosPlataforma[3].etiqueta;
        ref.read(checaPlataformaProvider).icono = elementosPlataforma[3].icono;
        ref.read(checaPlataformaProvider).buttonSelectOpcion[3] = true;
        break;

      case (TargetPlatform.macOS):
        // // //debugPrintLevels(2, "setCheckConeccionesProvider macOS");
        initialTiposElementoPlataforma.buttonSelectOpcion[4] = true;
        ref.read(checaPlataformaProvider).nombrePlataforma = "macOS";
        ref.read(checaPlataformaProvider).index = 4;
        ref.read(checaPlataformaProvider).etiqueta =
            elementosPlataforma[4].etiqueta;
        ref.read(checaPlataformaProvider).icono = elementosPlataforma[4].icono;
        ref.read(checaPlataformaProvider).buttonSelectOpcion[4] = true;
        break;
      case (TargetPlatform.windows):
        // // //debugPrintLevels(2, "setCheckConeccionesProvider windows");
        initialTiposElementoPlataforma.buttonSelectOpcion[5] = true;
        ref.read(checaPlataformaProvider).nombrePlataforma = "windows";
        ref.read(checaPlataformaProvider).index = 5;
        ref.read(checaPlataformaProvider).etiqueta =
            elementosPlataforma[5].etiqueta;
        ref.read(checaPlataformaProvider).icono = elementosPlataforma[5].icono;
        ref.read(checaPlataformaProvider).buttonSelectOpcion[5] = true;
        break;
    }
  }
}

class PaginaDetectaPlataforma extends StatelessWidget {
  const PaginaDetectaPlataforma({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme.surface,
      appBar: AppBar(
        toolbarHeight: 40.0, // default kToolbarHeight = 56.0
        centerTitle: true,
        titleSpacing: 0,
        backgroundColor: appTheme.error,
        automaticallyImplyLeading: false,
        title: Text(
          'Sistema Operativo',
          style: TextStyle(
            color: appTheme.onError,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        elevation: 4,
      ),
      body: Center(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Plataforma',
                style: TextStyle(
                  color: appTheme.error,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 10),
              Container(
                //alignment: Alignment.center,
                padding: const EdgeInsets.all(3),
                  color: appTheme.surface,
                width: 300,
                child: ListView(
                  shrinkWrap: true,
                  children: List.generate(
                    listaNombrePlataforma.length,
                    (index) => Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Text(
                            listaNombrePlataforma[index],
                            style: TextStyle(
                              color: appTheme.error,
                              fontWeight: FontWeight.normal,
                              fontSize: 14,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          flex: 1,
                          child: Text(
                            (initialTiposElementoPlataforma
                                    .buttonSelectOpcion[index])
                                ? "Detectado"
                                : "No",
                            style: TextStyle(
                              color: appTheme.error,
                              fontWeight: FontWeight.normal,
                              fontSize: 14,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 15),
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
                    'Regresar',
                    style: TextStyle(
                      color: appTheme.onError,
                      //backgroundColor: appTheme.onTertiary,
                      fontSize: 12,
                      fontFamily: "Comfortaa",
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  // checar regreso
                  onPressed: () => Navigator.pushNamed(
                    context,
                    AppRoutes.principal, //
                    arguments: "",
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
