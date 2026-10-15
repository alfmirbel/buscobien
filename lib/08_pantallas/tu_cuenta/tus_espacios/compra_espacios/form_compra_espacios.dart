//import 'package:buscobien/08_pantallas/propiedades/tus_propiedades/form_captura_propiedad.dart';
import 'package:flutter/material.dart';
import '../../../../60_global_widgets/campo_texto.dart';
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
  bool _comprando = false; // evita registrar la compra dos veces

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

  Future<void> _comprar() async {
    final formulario = formKeyCompraEspacio.currentState;
    if (formulario == null || _comprando || !formulario.validate()) return;
    formulario.save();
    setState(() => _comprando = true);

    int estado = 0;
    try {
      estado = await ref
          .read(compraDeEspaciosProvider.notifier)
          .writeCompraEspaciosToCouchDB(ref);
      debugPrintLevels(2, "Pagina Compra Espacios writeCompraEspaciosToCouchDB status: $estado");
    } catch (e) {
      debugPrintLevels(1, "Pagina Compra Espacios exception: $e");
    }
    if (!mounted) return;

    await showMessageDialog(
      context,
      "Compra Espacios",
      codigoCouchDB.containsKey(estado)
          ? codigoCouchDB[estado]!.label
          : (estado == 0 ? "No se pudo registrar la compra. Inténtalo de nuevo." : "Se generaron los espacios."),
      estado == 0 ? appTheme.error : appTheme.primary,
      TextAlign.center,
      "Salir",
    );
    if (!mounted) return;
    if (estado == 0) {
      setState(() => _comprando = false);
    } else {
      Navigator.pop(context);
    }
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
                    buildCampoCompraEspacioCasa(ref, "noDeEspaciosNormales"),
                    Alignment.topLeft,
                    300,
                  ),
                  renglonCapturaGet(
                    "noDeEspaciosDestacados",
                    buildCampoCompraEspacioCasa(ref, "noDeEspaciosDestacados"),
                    Alignment.topLeft,
                    300,
                  ),
                  renglonCapturaGet(
                    "noDeEspaciosSuperdestacados",
                    buildCampoCompraEspacioCasa(ref, "noDeEspaciosSuperdestacados"),
                    Alignment.topLeft,
                    300,
                  ),
                  renglonCapturaGet(
                    "noDeEspaciosOportunidades",
                    buildCampoCompraEspacioCasa(ref, "noDeEspaciosOportunidades"),
                    Alignment.topLeft,
                    300,
                  ),
                  renglonCapturaGet(
                    "noDeEspaciosRemates",
                    buildCampoCompraEspacioCasa(ref, "noDeEspaciosRemates"),
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
                    buildCampoCompraEspacioCasa(ref, "totalEspacioNormal"),
                    Alignment.topLeft,
                    300,
                  ),
                  renglonCapturaGet(
                    "totalEspacioDestacado",
                    buildCampoCompraEspacioCasa(ref, "totalEspacioDestacado"),
                    Alignment.topLeft,
                    300,
                  ),
                  renglonCapturaGet(
                    "totalEspacioSuperdestacado",
                    buildCampoCompraEspacioCasa(ref, "totalEspacioSuperdestacado"),
                    Alignment.topLeft,
                    300,
                  ),
                  renglonCapturaGet(
                    "totalEspaciosOportunidades",
                    buildCampoCompraEspacioCasa(ref, "totalEspaciosOportunidades"),
                    Alignment.topLeft,
                    300,
                  ),
                  renglonCapturaGet(
                    "totalEspaciosRemates",
                    buildCampoCompraEspacioCasa(ref, "totalEspaciosRemates"),
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
                    buildCampoCompraEspacioCasa(ref, "impuestos"),
                    Alignment.topLeft,
                    300,
                  ),
                  renglonCapturaGet(
                    "granTotal",
                    buildCampoCompraEspacioCasa(ref, "granTotal"),
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
                    buildCampoCompraEspacioCasa(ref, "medioDePago"),
                    Alignment.topLeft,
                    300,
                  ),
                  renglonCapturaGet(
                    "referenciaDePago",
                    buildCampoCompraEspacioCasa(ref, "referenciaDePago"),
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
                      child: Text(
                        'Cancelar',
                        style: TextStyle(fontSize: 14, color: appTheme.onPrimary),
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
                      child: Text(
                        'Comprar',
                        style: TextStyle(fontSize: 14, color: appTheme.onPrimary),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: appTheme.primary,
                        minimumSize: const Size(150, 40),
                      ),
                      onPressed: _comprando ? null : _comprar,
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
/// Tipo de dato de cada campo de la compra: cantidades enteras o importes.
TipoCampo _tipoCampoCompra(String nombre) {
  if (nombre.startsWith('noDeEspacios') || nombre.startsWith('mesesContratados')) {
    return TipoCampo.entero;
  }
  if (nombre.startsWith('totalEspacio') || nombre == 'impuestos' || nombre == 'granTotal') {
    return TipoCampo.dinero;
  }
  return TipoCampo.texto;
}

Widget buildCampoCompraEspacioCasa(WidgetRef ref, String nombreVariable) {
  final compraEspaciosProvider = ref.read(compraDeEspaciosProvider.notifier);
  return CampoTexto(
    etiqueta: compraEspaciosProvider.getNombreDelCampoCompraEspacio(nombreVariable),
    valorInicial: compraEspaciosProvider.getCampoEspacioCompra(ref, nombreVariable),
    tipo: _tipoCampoCompra(nombreVariable),
    obligatorio: true,
    onChanged: (v) => compraEspaciosProvider.setCampoEspacioCompra(ref, nombreVariable, v.toUpperCase()),
  );
}
