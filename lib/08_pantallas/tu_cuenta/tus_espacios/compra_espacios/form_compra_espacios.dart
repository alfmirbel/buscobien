//import 'package:buscobien/08_pantallas/propiedades/tus_propiedades/form_captura_propiedad.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';
import '../../../../10_user_login/usuario_login/provider_session.dart';
import '../../../../20_var_globales/couchdb_errors.dart';
import '../../../../60_global_widgets/debugprint.dart';
import '../../../../60_global_widgets/dialogbox_mensaje_general.dart';
import '../form_update_espacio_comprado.dart';
import 'provider_compra_espacios.dart';
import '../../../../20_var_globales/var_color_themes.dart';
import '../../../../20_var_globales/var_color_widget.dart';
import '../../../../20_var_globales/variables_globales.dart';

class PaginaCompraEspacios extends ConsumerStatefulWidget {
  const PaginaCompraEspacios({super.key});

  @override
  // ignore: no_logic_in_create_state
  ConsumerState createState() {
    debugPrintLevels(1, " **************************************************");
    debugPrintLevels(1, "  1. PaginaCompraEspacios createState");
    debugPrintLevels(1, " **************************************************");
    return PaginaCompraEspaciosState();
  }
}

class PaginaCompraEspaciosState extends ConsumerState<PaginaCompraEspacios> {
  double alto = 25;
  double ancho = 100;
  double verticalWidth = 275.00;
  String idUsuario = "";

  final GlobalKey<FormState> formKeyCompraEspacio = GlobalKey<FormState>();

  @override
  void initState() {
    debugPrintLevels(1, " **************************************************");
    debugPrintLevels(1, "  1. PaginaCompraEspacios initState");
    debugPrintLevels(1, " **************************************************");
    idUsuario = ref
        .read(sessionProvider)
        .userData
        .rows[0]
        .value
        .usuario
        .idUsuario;
    ref.read(compraDeEspaciosProvider.notifier).resetCampoEspacioCompra();
    ref
        .read(compraDeEspaciosProvider.notifier)
        .setCampoEspacioCompra(ref, "idUsuario", idUsuario);

    super.initState();
  }

  //-----------------------------------------------------------------------------
  @override
  void didChangeDependencies() {
    debugPrintLevels(1, " PaginaCompraEspacios didChangeDependencies");
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(covariant PaginaCompraEspacios oldWidget) {
    debugPrintLevels(1, " PaginaCompraEspacios didUpdateWidget");
    super.didUpdateWidget(oldWidget);
  }

  @override
  void deactivate() {
    debugPrintLevels(1, " PaginaCompraEspacios deactivate");
    super.deactivate();
  }

  @override
  void dispose() {
    debugPrintLevels(1, " PaginaCompraEspacios dispose");
    super.dispose();
  }

  //-----------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    debugPrintLevels(1, " **************************************************");
    debugPrintLevels(1, "  3. PaginaCompraEspacios build");
    debugPrintLevels(1, " **************************************************");
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    setState(() {
      screenWidth = MediaQuery.of(context).size.width * 0.8;
      screenHeight = MediaQuery.of(context).size.height;
    });

    //-SCAFFOLD---------------------------------------------------------------------
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 40.0, // default kToolbarHeight = 56.0
        centerTitle: true,
        titleSpacing: 0,
        backgroundColor: appTheme.primary,
        iconTheme: IconThemeData(size: 14, color: appTheme.onPrimary),
        title: Text(
          'Compra de Espacios',
          style: TextStyle(
            color: appTheme.onPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        leading: IconButton(
          color: appTheme.onPrimary,
          icon: const Icon(Symbols.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: formKeyCompraEspacio,
          child: Column(
            children: [
              Center(
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    Text(
                      'Espacios',
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      style: TextStyle(
                        color: appTheme.primary,
                        fontSize: fontSizeTituloPagina,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Comfortaa",
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: Text(
                  "Número de espacios",
                  maxLines: 2,
                  style: TextStyle(
                    fontFamily: 'Outfit',
                    color: appTheme.secondary,
                    fontSize: fontSizeTituloPagina,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.start,
                spacing: 20,
                runSpacing: 10,
                alignment: WrapAlignment.start,
                children: [
                  renglonCapturaGet(
                    "noDeEspaciosNormales",
                    buildCampoCompraEspacioCasa(
                      ref,
                      "noDeEspaciosNormales",
                      "",
                      30,
                    ),
                    Alignment.topLeft,
                    300,
                  ),
                  renglonCapturaGet(
                    "noDeEspaciosDestacados",
                    buildCampoCompraEspacioCasa(
                      ref,
                      "noDeEspaciosDestacados",
                      "",
                      30,
                    ),
                    Alignment.topLeft,
                    300,
                  ),
                  renglonCapturaGet(
                    "noDeEspaciosSuperdestacados",
                    buildCampoCompraEspacioCasa(
                      ref,
                      "noDeEspaciosSuperdestacados",
                      "",
                      30,
                    ),
                    Alignment.topLeft,
                    300,
                  ),
                  renglonCapturaGet(
                    "noDeEspaciosOportunidades",
                    buildCampoCompraEspacioCasa(
                      ref,
                      "noDeEspaciosOportunidades",
                      "",
                      30,
                    ),
                    Alignment.topLeft,
                    300,
                  ),
                  renglonCapturaGet(
                    "noDeEspaciosRemates",
                    buildCampoCompraEspacioCasa(
                      ref,
                      "noDeEspaciosRemates",
                      "",
                      30,
                    ),
                    Alignment.topLeft,
                    300,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Center(
                child: Text(
                  "Costo de los espacios",
                  maxLines: 2,
                  style: TextStyle(
                    fontFamily: 'Outfit',
                    color: appTheme.secondary,
                    fontSize: fontSizeTituloPagina,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: Text(
                  "Costo",
                  maxLines: 2,
                  style: TextStyle(
                    fontFamily: 'Outfit',
                    color: appTheme.secondary,
                    fontSize: fontSizeTituloPagina,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.start,
                spacing: 20,
                runSpacing: 10,
                alignment: WrapAlignment.start,
                children: [
                  renglonCapturaGet(
                    "totalEspacioNormal",
                    buildCampoCompraEspacioCasa(
                      ref,
                      "totalEspacioNormal",
                      "",
                      30,
                    ),
                    Alignment.topLeft,
                    300,
                  ),
                  renglonCapturaGet(
                    "totalEspacioDestacado",
                    buildCampoCompraEspacioCasa(
                      ref,
                      "totalEspacioDestacado",
                      "",
                      30,
                    ),
                    Alignment.topLeft,
                    300,
                  ),
                  renglonCapturaGet(
                    "totalEspacioSuperdestacado",
                    buildCampoCompraEspacioCasa(
                      ref,
                      "totalEspacioSuperdestacado",
                      "",
                      30,
                    ),
                    Alignment.topLeft,
                    300,
                  ),
                  renglonCapturaGet(
                    "totalEspaciosOportunidades",
                    buildCampoCompraEspacioCasa(
                      ref,
                      "totalEspaciosOportunidades",
                      "",
                      30,
                    ),
                    Alignment.topLeft,
                    300,
                  ),
                  renglonCapturaGet(
                    "totalEspaciosRemates",
                    buildCampoCompraEspacioCasa(
                      ref,
                      "totalEspaciosRemates",
                      "",
                      30,
                    ),
                    Alignment.topLeft,
                    300,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.start,
                spacing: 20,
                runSpacing: 10,
                alignment: WrapAlignment.start,
                children: [
                  renglonCapturaGet(
                    "impuestos",
                    buildCampoCompraEspacioCasa(ref, "impuestos", "", 30),
                    Alignment.topLeft,
                    300,
                  ),
                  renglonCapturaGet(
                    "granTotal",
                    buildCampoCompraEspacioCasa(ref, "granTotal", "", 30),
                    Alignment.topLeft,
                    300,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Center(
                child: Text(
                  "Forma de pago",
                  maxLines: 2,
                  style: TextStyle(
                    fontFamily: 'Outfit',
                    color: appTheme.secondary,
                    fontSize: fontSizeTituloPagina,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.start,
                spacing: 20,
                runSpacing: 10,
                alignment: WrapAlignment.start,
                children: [
                  renglonCapturaGet(
                    "medioDePago",
                    buildCampoCompraEspacioCasa(ref, "medioDePago", "", 30),
                    Alignment.topLeft,
                    300,
                  ),
                  renglonCapturaGet(
                    "referenciaDePago",
                    buildCampoCompraEspacioCasa(
                      ref,
                      "referenciaDePago",
                      "",
                      30,
                    ),
                    Alignment.topLeft,
                    500,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 20,
                runSpacing: 10,
                alignment: WrapAlignment.center,
                children: [
                  Builder(
                    builder: (context) => ElevatedButton(
                      // ignore: sort_child_properties_last
                      child: const Text(
                        'Cancelar',
                        style: TextStyle(fontSize: 14, color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: appTheme.primary,
                        minimumSize: const Size(150, 40),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  Builder(
                    builder: (context) => ElevatedButton(
                      // ignore: sort_child_properties_last
                      child: const Text(
                        'Comprar',
                        style: TextStyle(fontSize: 14, color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: appTheme.primary,
                        minimumSize: const Size(150, 40),
                      ),
                      onPressed: () async {
                        if (formKeyCompraEspacio.currentState!.validate()) {
                          debugPrintLevels(
                            2,
                            "Pagina Compra Espacios writeCompraEspaciosToCouchDB status",
                          );

                          formKeyCompraEspacio.currentState!.save();
                          await ref
                              .read(compraDeEspaciosProvider.notifier)
                              .writeCompraEspaciosToCouchDB(ref)
                              .then((onValue) async {
                                debugPrintLevels(
                                  2,
                                  "Pagina Compra Espacios writeCompraEspaciosToCouchDB status: $onValue",
                                );
                                if (codigoCouchDB.containsKey(onValue)) {
                                  //  (BuildContext context)  =>  showMessageDialog(
                                  await showMessageDialog(
                                    // ignore: use_build_context_synchronously
                                    context,
                                    "Compra Espacios",
                                    codigoCouchDB[onValue]!.label,
                                    appTheme.primary,
                                    TextAlign.center,
                                    "Salir",
                                  );
                                } else {
                                  await showMessageDialog(
                                    // ignore: use_build_context_synchronously
                                    context,
                                    "Compra Espacios",
                                    "Se generaron los espacios.",
                                    appTheme.primary,
                                    TextAlign.center,
                                    "Salir",
                                  );
                                }
                                Navigator.pop(context);
                              });
                        }
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}

//-----------------------------------------------------------------------------+

// Create a Form widget.-----------------------------------------------
Widget buildCampoCompraEspacioCasa(
  WidgetRef ref,
  String nombreVariable,
  String expRegular,
  int numchar,
) {
  final compraEspaciosProvider = ref.read(compraDeEspaciosProvider.notifier);
  debugPrintLevels(1, " **************************************************");
  debugPrintLevels(1, "  3. PaginaCompraEspacios buildCampoCompraEspacioCasa");
  debugPrintLevels(1, " **************************************************");

  return SizedBox(
    //height: 50,
    child: TextFormField(
      initialValue: compraEspaciosProvider.getCampoEspacioCompra(
        ref,
        nombreVariable,
      ),
      style: TextStyle(
        color: appTheme.primary,
        fontSize: tamanoLetra,
        fontWeight: FontWeight.normal,
      ),
      minLines: 1,
      maxLines: 8,
      maxLength: numchar,
      decoration: InputDecoration(
        border: const OutlineInputBorder(gapPadding: 1.0),
        filled: true,
        fillColor: appTheme.onPrimary,
        labelText:
            " ${compraEspaciosProvider.getNombreDelCampoCompraEspacio(nombreVariable)} ",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        isDense: true,
        contentPadding: const EdgeInsets.fromLTRB(10, 15, 10, 15),
      ),
      validator: (String? value) {
        if (value!.isEmpty) {
          return 'El campo es obligatorio';
        }
        /*
      if (!RegExp(r"expRegular").hasMatch(value)) {
        return 'El formato no es válido';
      }
      */
        return null;
      },
      onSaved: (String? value) {
        value = value?.toUpperCase();
        compraEspaciosProvider.setCampoEspacioCompra(
          ref,
          nombreVariable,
          value!,
        );
        //ref.read(folioProvider).clavefoliodeventa = value!;
      },
    ),
  );
}
