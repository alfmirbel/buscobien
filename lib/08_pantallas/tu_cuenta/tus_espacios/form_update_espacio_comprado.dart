import 'package:buscobien/08_pantallas/inicio/data_espacios_casas_get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../05_provider_menus/variables_menus.dart';
import '../../../60_global_widgets/debugprint.dart';
import '../../../60_global_widgets/dialogbox_mensaje_general.dart';
import '../../inicio/catalogo_otras_caracteristicas.dart';
import 'provider_espacios_casa_get.dart';
import '../../../20_var_globales/var_color_themes.dart';
import '../../../20_var_globales/var_color_widget.dart';
import '../../../20_var_globales/variables_globales.dart';
import 'tabla_tipopropiedad_vs_campos.dart';

// CORECCIÓN EE ERROR
//------------------------------------------------------------------------------
// OPTIMIZADO

class PaginaEditaEspacio extends ConsumerStatefulWidget {
  final ValueEspaciosCasaGet propiedadParameter;
  const PaginaEditaEspacio(this.propiedadParameter, {super.key});

  @override
  ConsumerState createState() {
    debugPrintLevels(1, " **************************************************");
    debugPrintLevels(1, "  1. PaginaEditaEspacio createState");
    debugPrintLevels(1, " **************************************************");
    return PaginaEditaEspacioState();
  }
}

class PaginaEditaEspacioState extends ConsumerState<PaginaEditaEspacio>
    with TickerProviderStateMixin {
  // VARIABLES DE ESTADO
  late TextEditingController celdaControllerPublicacion;
  int currentStep = 0;
  List<bool> pasosActivar = List<bool>.filled(5, false);

  double alto = 25;
  double ancho = 100;
  double verticalWidth = 275.00;

  // Propiedad local mutable para el formulario
  late ValueEspaciosCasaGet propiedad;

  final formKeyEspacioComprado = GlobalKey<FormState>();
  String tipoDePropiedad = otrosTiposDeInmueble[0];
  String tipoDeTransaccion = "Venta";

  @override
  void initState() {
    super.initState(); // Se recomienda llamar a super primero
    debugPrintLevels(1, " **************************************************");
    debugPrintLevels(1, " 02. PaginaEditaEspacio initState");
    debugPrintLevels(1, " **************************************************");

    celdaControllerPublicacion = TextEditingController();
    propiedad = widget.propiedadParameter;

    // Inicializar checkbox según la data
    setchecklistAdicionalesGet(propiedad);

    // Configuración inicial de los pasos del Stepper
    pasosActivar[0] = true;

    // Inicializar dropdowns con valores seguros y validación de existencia
    if (propiedad.espacioscasa.tipodepropiedad == "" ||
        !listaTipoInmuebles.contains(propiedad.espacioscasa.tipodepropiedad)) {
      tipoDePropiedad = otrosTiposDeInmueble[0];
    } else {
      tipoDePropiedad = propiedad.espacioscasa.tipodepropiedad;
    }

    // Inicializar transacción
    if (propiedad.espacioscasa.tipodetransaccion != "" &&
        listaTiposDeTransaccion.contains(
          propiedad.espacioscasa.tipodetransaccion,
        )) {
      tipoDeTransaccion = propiedad.espacioscasa.tipodetransaccion;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    debugPrintLevels(1, " PaginaEditaEspacio dispose");
    celdaControllerPublicacion.dispose();
    super.dispose();
  }

  update() {
    if (mounted) {
      setState(() {
        debugPrintLevels(1, " 03. PaginaEditaEspacio setState update");
      });
    }
  }

  // --- MÉTODOS DE UI (Botones y Lógica de Pasos) ---

  void _siguientePaso() {
    setState(() {
      if (currentStep < 4) {
        pasosActivar[currentStep] = false;
        currentStep++;
        pasosActivar[currentStep] = true;
      }
    });
  }

  void _anteriorPaso() {
    setState(() {
      if (currentStep > 0) {
        pasosActivar[currentStep] = false;
        currentStep--;
        pasosActivar[currentStep] = true;
      }
    });
  }

  ElevatedButton botonGuardar(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: appTheme.primary,
        minimumSize: const Size(150, 40),
      ),
      onPressed: () async {
        if (formKeyEspacioComprado.currentState!.validate()) {
          formKeyEspacioComprado.currentState!.save();

          // 1. Obtener índice actual
          int indexAnterior = ref
              .read(espaciosCasaConListaFotosGetProvider.notifier)
              .getIndexEspaciosCasas();

          // 2. Buscar índice basado en ID (por seguridad)
          int index = ref
              .read(espaciosCasaConListaFotosGetProvider)
              .espaciosCasas
              .rows
              .indexWhere(
                (propiedadEnLista) =>
                    propiedadEnLista.value.espacioscasa.idPropiedad ==
                    propiedad.espacioscasa.idPropiedad,
              );
          // EL INDICE ES LA PROPIEDAD ACTUAL EN LA LISTA
          // REGRESA -1 SI NO SE ENCONTRO LA POSICIÓN
          // SI LA ENCONTRO, ACTUALIZA EL INDICE CON SU POSICIÓN
          if (index != -1) {
            ref
                .read(espaciosCasaConListaFotosGetProvider.notifier)
                .setIndexEspaciosCasas(index);
          }
          // 3. ACTUALIZAR EL ESTADO EN RIVERPOD
          // COPIANDO TODA LA PROPIEDAD EN LA POSICIÓN INDEX
          ref
              .read(espaciosCasaConListaFotosGetProvider.notifier)
              .setEspaciosCasasGet(propiedad);

          debugPrintLevels(5, "05. PaginaEditaEspacio Guarda cambios ");

          // 4. Guardar en Base de Datos
          await ref
              .read(espaciosCasaConListaFotosGetProvider.notifier)
              .updatePropiedadCasaGetToCouchDB()
              .then((resultado) async {
                // Restaurar índice si es necesario
                ref
                    .read(espaciosCasaConListaFotosGetProvider.notifier)
                    .setIndexEspaciosCasas(indexAnterior);

                debugPrintLevels(
                  5,
                  "06. PaginaEditaEspacio Resultado de Update espacio: $resultado",
                );

                if (mounted) {
                  await showMessageDialog(
                    context,
                    "Actualiza propiedad",
                    "Se actualizó correctamente",
                    appTheme.primary,
                    TextAlign.center,
                    "Salir",
                  );
                  Navigator.of(context).pop();
                }
              });
        }
      },
      child: Text(
        'Guardar',
        style: TextStyle(fontSize: 14, color: appTheme.onPrimary),
      ),
    );
  }

  // CORRECCIÓN AQUI: Se cambia pushReplacementNamed por Navigator.pop
  ElevatedButton botonSalir(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: appTheme.onSurface,
        minimumSize: const Size(150, 40),
      ),
      onPressed: () {
        // Regresa a la pantalla anterior sin reconstruir rutas ni causar ciclos
        Navigator.pop(context);
      },
      child: const Text(
        'Regresar',
        style: TextStyle(fontSize: 14, color: Colors.white),
      ),
    );
  }

  ElevatedButton _botonNavegacion(String texto, VoidCallback funcion) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: appTheme.primary,
        minimumSize: const Size(150, 40),
      ),
      onPressed: funcion,
      child: Text(
        texto,
        style: const TextStyle(fontSize: 14, color: Colors.white),
      ),
    );
  }

  // --- CONSTRUCCIÓN DE PASOS (Steps) ---

  Step _buildPasoPropiedad() {
    return Step(
      title: Text((screenWidth > verticalWidth) ? "" : "Propiedad"),
      label: Text(
        (screenWidth > verticalWidth) ? "Propiedad" : "",
        style: TextStyle(
          color: appTheme.primary,
          fontWeight: (pasosActivar[0]) ? FontWeight.bold : FontWeight.normal,
          fontSize: 10,
        ),
      ),
      content: Column(
        children: [
          Center(
            child: Text(
              "Datos de la propiedad",
              style: TextStyle(
                color: appTheme.primary,
                fontSize: fontSizeTituloPagina,
                fontWeight: FontWeight.bold,
                fontFamily: "Comfortaa",
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
              // Dropdown Tipo Propiedad
              _buildDropdown(
                value: tipoDePropiedad,
                items: listaTipoInmuebles,
                onChanged: (newValue) {
                  if (newValue != null) {
                    setState(() {
                      tipoDePropiedad = newValue;
                      setCampoEspaciosCasasGet(
                        propiedad,
                        "tipodepropiedad",
                        tipoDePropiedad,
                      );
                    });
                  }
                },
              ),
              // Dropdown Tipo Transacción
              _buildDropdown(
                value: tipoDeTransaccion,
                items: listaTiposDeTransaccion,
                onChanged: (newValue) {
                  if (newValue != null) {
                    setState(() {
                      tipoDeTransaccion = newValue;
                      setCampoEspaciosCasasGet(
                        propiedad,
                        "tipodetransaccion",
                        tipoDeTransaccion,
                      );
                    });
                  }
                },
              ),
              // Campos dinámicos
              renglonCapturaGet(
                "clavedelapropiedad",
                buildCampoTextoGet(
                  propiedad,
                  ref,
                  "clavedelapropiedad",
                  "",
                  20,
                  true,
                ),
                Alignment.topLeft,
                300,
              ),
              renglonCapturaGet(
                "tipodeanuncio",
                buildCampoTextoGet(
                  propiedad,
                  ref,
                  "tipodeanuncio",
                  "",
                  50,
                  false,
                ),
                Alignment.topLeft,
                300,
              ),
              renglonCapturaGet(
                "tipodetransaccion",
                buildCampoTextoGet(
                  propiedad,
                  ref,
                  "tipodetransaccion",
                  "",
                  50,
                  true,
                ),
                Alignment.topLeft,
                300,
              ),
              renglonCapturaGet(
                "nombredelapropiedad",
                buildCampoTextoGet(
                  propiedad,
                  ref,
                  "nombredelapropiedad",
                  "",
                  50,
                  true,
                ),
                Alignment.topLeft,
                300,
              ),
              renglonCapturaGet(
                "inmobiliaria",
                buildCampoTextoGet(
                  propiedad,
                  ref,
                  "inmobiliaria",
                  "",
                  80,
                  true,
                ),
                Alignment.topLeft,
                300,
              ),
              renglonCapturaGet(
                "inmobiliariaimagen",
                buildCampoTextoGet(
                  propiedad,
                  ref,
                  "inmobiliariaimagen",
                  "",
                  80,
                  true,
                ),
                Alignment.topLeft,
                300,
              ),
              renglonCapturaGet(
                "linkinmobiliaria",
                buildCampoTextoGet(
                  propiedad,
                  ref,
                  "linkinmobiliaria",
                  "",
                  80,
                  true,
                ),
                Alignment.topLeft,
                300,
              ),
              renglonCapturaGet(
                "sloganinmobiliaria",
                buildCampoTextoGet(
                  propiedad,
                  ref,
                  "sloganinmobiliaria",
                  "",
                  80,
                  true,
                ),
                Alignment.topLeft,
                300,
              ),
              renglonCapturaGet(
                "ubicaciongeneral",
                buildCampoTextoGet(
                  propiedad,
                  ref,
                  "ubicaciongeneral",
                  "",
                  80,
                  true,
                ),
                Alignment.topLeft,
                300,
              ),
              renglonCapturaGet(
                "descripcion",
                buildCampoTextoGet(propiedad, ref, "descripcion", "", 80, true),
                Alignment.topLeft,
                300,
              ),
              renglonCapturaGet(
                "letreropromocional",
                buildCampoTextoGet(
                  propiedad,
                  ref,
                  "letreropromocional",
                  "",
                  80,
                  true,
                ),
                Alignment.topLeft,
                300,
              ),
              if (metrosdeterrenoMatriz.contains(tipoDePropiedad))
                renglonCapturaGet(
                  "metrosdeterreno",
                  buildCampoTextoGet(
                    propiedad,
                    ref,
                    "metrosdeterreno",
                    "",
                    250,
                    true,
                  ),
                  Alignment.topLeft,
                  300,
                ),
              if (metrosconstruidosMatriz.contains(tipoDePropiedad))
                renglonCapturaGet(
                  "metrosconstruidos",
                  buildCampoTextoGet(
                    propiedad,
                    ref,
                    "metrosconstruidos",
                    "",
                    250,
                    true,
                  ),
                  Alignment.topLeft,
                  300,
                ),
              if (recamarasMatriz.contains(tipoDePropiedad))
                renglonCapturaGet(
                  "recamaras",
                  buildCampoTextoGet(propiedad, ref, "recamaras", "", 20, true),
                  Alignment.topLeft,
                  300,
                ),
              if (banosMatriz.contains(tipoDePropiedad))
                renglonCapturaGet(
                  "banos",
                  buildCampoTextoGet(propiedad, ref, "banos", "", 10, true),
                  Alignment.topLeft,
                  300,
                ),
              if (mediosbanosMatriz.contains(tipoDePropiedad))
                renglonCapturaGet(
                  "mediosbanos",
                  buildCampoTextoGet(
                    propiedad,
                    ref,
                    "mediosbanos",
                    "",
                    50,
                    true,
                  ),
                  Alignment.topLeft,
                  300,
                ),
              if (cuartosdeservicioMatriz.contains(tipoDePropiedad))
                renglonCapturaGet(
                  "cuartosdeservicio",
                  buildCampoTextoGet(
                    propiedad,
                    ref,
                    "cuartosdeservicio",
                    "",
                    80,
                    true,
                  ),
                  Alignment.topLeft,
                  300,
                ),
              if (estacionamientosMatriz.contains(tipoDePropiedad))
                renglonCapturaGet(
                  "estacionamientos",
                  buildCampoTextoGet(
                    propiedad,
                    ref,
                    "estacionamientos",
                    "",
                    80,
                    true,
                  ),
                  Alignment.topLeft,
                  300,
                ),
              if (estacionamientoscubiertosMatriz.contains(tipoDePropiedad))
                renglonCapturaGet(
                  "estacionamientoscubiertos",
                  buildCampoTextoGet(
                    propiedad,
                    ref,
                    "estacionamientoscubiertos",
                    "",
                    80,
                    true,
                  ),
                  Alignment.topLeft,
                  300,
                ),
              if (elementosadicionalescasaMatriz.contains(tipoDePropiedad))
                renglonCapturaGet(
                  "elementosadicionalescasa",
                  buildCampoTextoGet(
                    propiedad,
                    ref,
                    "elementosadicionalescasa",
                    "",
                    250,
                    true,
                  ),
                  Alignment.topLeft,
                  300,
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
              botonGuardar(context),
              _botonNavegacion('Siguiente', _siguientePaso),
            ],
          ),
          const SizedBox(height: 20),
          botonSalir(context),
        ],
      ),
      isActive: pasosActivar[0],
    );
  }

  Step _buildPasoPrecio() {
    return Step(
      title: Text((screenWidth > verticalWidth) ? "" : "Precio"),
      label: Text(
        (screenWidth > verticalWidth) ? "Precio" : "",
        style: TextStyle(
          color: appTheme.primary,
          fontWeight: (pasosActivar[1]) ? FontWeight.bold : FontWeight.normal,
          fontSize: 10,
        ),
      ),
      content: Column(
        children: [
          Center(
            child: Text(
              "Precio y costos de la propiedad",
              style: TextStyle(
                color: appTheme.primary,
                fontSize: fontSizeTituloPagina,
                fontWeight: FontWeight.bold,
                fontFamily: "Comfortaa",
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
              if ([
                    "Venta",
                    "Venta/Renta",
                    "Traspaso",
                  ].contains(tipoDeTransaccion) &&
                  precioventaMatriz.contains(tipoDePropiedad))
                renglonCapturaGet(
                  "precioventa",
                  buildCampoTextoGet(
                    propiedad,
                    ref,
                    "precioventa",
                    "",
                    80,
                    true,
                  ),
                  Alignment.topLeft,
                  300,
                ),
              if (["Renta", "Venta/Renta"].contains(tipoDeTransaccion) &&
                  preciorentaMatriz.contains(tipoDePropiedad))
                renglonCapturaGet(
                  "preciorenta",
                  buildCampoTextoGet(
                    propiedad,
                    ref,
                    "preciorenta",
                    "",
                    80,
                    true,
                  ),
                  Alignment.topLeft,
                  300,
                ),
              if (["Renta", "Venta/Renta"].contains(tipoDeTransaccion) &&
                  mantenimientoMatriz.contains(tipoDePropiedad))
                renglonCapturaGet(
                  "mantenimiento",
                  buildCampoTextoGet(
                    propiedad,
                    ref,
                    "mantenimiento",
                    "",
                    80,
                    true,
                  ),
                  Alignment.topLeft,
                  300,
                ),
              if (monedaMatriz.contains(tipoDePropiedad))
                renglonCapturaGet(
                  "moneda",
                  buildCampoTextoGet(propiedad, ref, "moneda", "", 30, true),
                  Alignment.topLeft,
                  300,
                ),
              renglonCapturaGet(
                "condicionesdeventa",
                buildCampoTextoGet(
                  propiedad,
                  ref,
                  "condicionesdeventa",
                  "",
                  30,
                  true,
                ),
                Alignment.topLeft,
                300,
              ),
              if (linkvideoMatriz.contains(tipoDePropiedad))
                renglonCapturaGet(
                  "linkvideo",
                  buildCampoTextoGet(propiedad, ref, "linkvideo", "", 30, true),
                  Alignment.topLeft,
                  300,
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
              _botonNavegacion('Anterior', _anteriorPaso),
              botonGuardar(context),
              _botonNavegacion('Siguiente', _siguientePaso),
            ],
          ),
          const SizedBox(height: 20),
          botonSalir(context),
        ],
      ),
      isActive: pasosActivar[1],
    );
  }

  Step _buildPasoUbicacion() {
    return Step(
      title: Text((screenWidth > verticalWidth) ? "" : "Ubicación"),
      label: Text(
        (screenWidth > verticalWidth) ? "Ubicación" : "",
        style: TextStyle(
          color: appTheme.primary,
          fontWeight: (pasosActivar[2]) ? FontWeight.bold : FontWeight.normal,
          fontSize: 10,
        ),
      ),
      content: Column(
        children: [
          Center(
            child: Text(
              "Dirección de la propiedad",
              style: TextStyle(
                color: appTheme.primary,
                fontSize: fontSizeTituloPagina,
                fontWeight: FontWeight.bold,
                fontFamily: "Comfortaa",
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
                "pais",
                buildCampoTextoGet(propiedad, ref, "pais", "", 30, false),
                Alignment.topLeft,
                300,
              ),
              renglonCapturaGet(
                "estado",
                buildCampoTextoGet(propiedad, ref, "estado", "", 30, true),
                Alignment.topLeft,
                300,
              ),
              renglonCapturaGet(
                "municipio",
                buildCampoTextoGet(propiedad, ref, "municipio", "", 30, true),
                Alignment.topLeft,
                300,
              ),
              renglonCapturaGet(
                "ciudad",
                buildCampoTextoGet(propiedad, ref, "ciudad", "", 30, true),
                Alignment.topLeft,
                300,
              ),
              renglonCapturaGet(
                "zona",
                buildCampoTextoGet(propiedad, ref, "zona", "", 30, true),
                Alignment.topLeft,
                300,
              ),
              renglonCapturaGet(
                "asentamiento",
                buildCampoTextoGet(
                  propiedad,
                  ref,
                  "asentamiento",
                  "",
                  30,
                  true,
                ),
                Alignment.topLeft,
                300,
              ),
              renglonCapturaGet(
                "codigopostal",
                buildCampoTextoGet(
                  propiedad,
                  ref,
                  "codigopostal",
                  "",
                  30,
                  true,
                ),
                Alignment.topLeft,
                300,
              ),
              renglonCapturaGet(
                "tipo",
                buildCampoTextoGet(propiedad, ref, "tipo", "", 30, true),
                Alignment.topLeft,
                300,
              ),
              renglonCapturaGet(
                "calle",
                buildCampoTextoGet(propiedad, ref, "calle", "", 30, true),
                Alignment.topLeft,
                300,
              ),
              renglonCapturaGet(
                "numeroexterior",
                buildCampoTextoGet(
                  propiedad,
                  ref,
                  "numeroexterior",
                  "",
                  30,
                  true,
                ),
                Alignment.topLeft,
                300,
              ),
              renglonCapturaGet(
                "numerointerior",
                buildCampoTextoGet(
                  propiedad,
                  ref,
                  "numerointerior",
                  "",
                  30,
                  true,
                ),
                Alignment.topLeft,
                300,
              ),
              renglonCapturaGet(
                "entrecalle01",
                buildCampoTextoGet(
                  propiedad,
                  ref,
                  "entrecalle01",
                  "",
                  30,
                  true,
                ),
                Alignment.topLeft,
                300,
              ),
              renglonCapturaGet(
                "entrecalle02",
                buildCampoTextoGet(
                  propiedad,
                  ref,
                  "entrecalle02",
                  "",
                  30,
                  true,
                ),
                Alignment.topLeft,
                300,
              ),
              renglonCapturaGet(
                "latitud",
                buildCampoTextoGet(propiedad, ref, "latitud", "", 30, true),
                Alignment.topLeft,
                300,
              ),
              renglonCapturaGet(
                "longitud",
                buildCampoTextoGet(propiedad, ref, "longitud", "", 30, true),
                Alignment.topLeft,
                300,
              ),
              renglonCapturaGet(
                "latitudDecimal",
                buildCampoTextoGet(
                  propiedad,
                  ref,
                  "latitudDecimal",
                  "",
                  30,
                  true,
                ),
                Alignment.topLeft,
                300,
              ),
              renglonCapturaGet(
                "longitudDecimal",
                buildCampoTextoGet(
                  propiedad,
                  ref,
                  "longitudDecimal",
                  "",
                  30,
                  true,
                ),
                Alignment.topLeft,
                300,
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
              _botonNavegacion('Anterior', _anteriorPaso),
              botonGuardar(context),
              _botonNavegacion('Siguiente', _siguientePaso),
            ],
          ),
          const SizedBox(height: 20),
          botonSalir(context),
        ],
      ),
      isActive: pasosActivar[2],
    );
  }

  Step _buildPasoAdicionales() {
    return Step(
      title: Text((screenWidth > verticalWidth) ? "" : "Adicionales"),
      label: Text(
        (screenWidth > verticalWidth) ? "Adicionales" : "",
        style: TextStyle(
          color: appTheme.primary,
          fontWeight: (pasosActivar[3]) ? FontWeight.bold : FontWeight.normal,
          fontSize: 10,
        ),
      ),
      content: Column(
        children: [
          Center(
            child: Text(
              "Datos adicionales",
              style: TextStyle(
                color: appTheme.primary,
                fontSize: fontSizeTituloPagina,
                fontWeight: FontWeight.bold,
                fontFamily: "Comfortaa",
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
              if (panelessolaresMatriz.contains(tipoDePropiedad))
                capturaCampoGetConCheckBox("panelessolares", "", 80),
              if (jardinMatriz.contains(tipoDePropiedad))
                capturaCampoGetConCheckBox("jardin", "", 80),
              if (albercaMatriz.contains(tipoDePropiedad))
                capturaCampoGetConCheckBox("alberca", "", 80),
              if (calefaccionMatriz.contains(tipoDePropiedad))
                capturaCampoGetConCheckBox("calefaccion", "", 80),
              if (aireacondicionadoMatriz.contains(tipoDePropiedad))
                capturaCampoGetConCheckBox("aireacondicionado", "", 80),
              if (seguridadMatriz.contains(tipoDePropiedad))
                capturaCampoGetConCheckBox("seguridad", "", 80),
              if (enfraccionamientoMatriz.contains(tipoDePropiedad))
                capturaCampoGetConCheckBox("enfraccionamiento", "", 80),
              if (casasenelconjuntoMatriz.contains(tipoDePropiedad))
                capturaCampoGetConCheckBox("casasenelconjunto", "", 80),
              if (casaclubMatriz.contains(tipoDePropiedad))
                capturaCampoGetConCheckBox("casaclub", "", 80),
              if (salondeeventosMatriz.contains(tipoDePropiedad))
                capturaCampoGetConCheckBox("salondeeventos", "", 80),
              if (centrodenegociosMatriz.contains(tipoDePropiedad))
                capturaCampoGetConCheckBox("centrodenegocios", "", 80),
              if (gimnacioMatriz.contains(tipoDePropiedad))
                capturaCampoGetConCheckBox("gimnacio", "", 80),
              if (cisternaMatriz.contains(tipoDePropiedad))
                capturaCampoGetConCheckBox("cisterna", "", 80),
              if (almacenamientodeaguaMatriz.contains(tipoDePropiedad))
                capturaCampoGetConCheckBox("almacenamientodeagua", "", 80),
              if (tratamientodeaguasMatriz.contains(tipoDePropiedad))
                capturaCampoGetConCheckBox("tratamientodeaguas", "", 80),
              if (otrascaracteristicasMatriz.contains(tipoDePropiedad))
                capturaCampoGetConCheckBox("otrascaracteristicas", "", 80),
            ],
          ),
          const SizedBox(height: 20),
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 20,
            runSpacing: 10,
            alignment: WrapAlignment.center,
            children: [
              _botonNavegacion('Anterior', _anteriorPaso),
              botonGuardar(context),
              _botonNavegacion('Siguiente', _siguientePaso),
            ],
          ),
          const SizedBox(height: 20),
          botonSalir(context),
        ],
      ),
      isActive: pasosActivar[3],
    );
  }

  Step _buildPasoContacto() {
    return Step(
      title: Text((screenWidth > verticalWidth) ? "" : "Contacto"),
      label: Text(
        (screenWidth > verticalWidth) ? "Contacto" : "",
        style: TextStyle(
          color: appTheme.primary,
          fontWeight: (pasosActivar[4]) ? FontWeight.bold : FontWeight.normal,
          fontSize: 10,
        ),
      ),
      content: Column(
        children: [
          Center(
            child: Text(
              "Datos del promotor",
              style: TextStyle(
                color: appTheme.primary,
                fontSize: fontSizeTituloPagina,
                fontWeight: FontWeight.bold,
                fontFamily: "Comfortaa",
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
                "nombre",
                buildCampoTextoGet(propiedad, ref, "nombre", "", 30, true),
                Alignment.topLeft,
                300,
              ),
              renglonCapturaGet(
                "empresa",
                buildCampoTextoGet(propiedad, ref, "empresa", "", 30, true),
                Alignment.topLeft,
                300,
              ),
              renglonCapturaGet(
                "imgendeempresa",
                buildCampoTextoGet(
                  propiedad,
                  ref,
                  "imgendeempresa",
                  "",
                  30,
                  true,
                ),
                Alignment.topLeft,
                300,
              ),
              renglonCapturaGet(
                "numerocelular",
                buildCampoTextoGet(
                  propiedad,
                  ref,
                  "numerocelular",
                  "",
                  30,
                  true,
                ),
                Alignment.topLeft,
                300,
              ),
              renglonCapturaGet(
                "numerootro",
                buildCampoTextoGet(propiedad, ref, "numerootro", "", 30, true),
                Alignment.topLeft,
                300,
              ),
              renglonCapturaGet(
                "numeroinmobiliaria",
                buildCampoTextoGet(
                  propiedad,
                  ref,
                  "numeroinmobiliaria",
                  "",
                  30,
                  true,
                ),
                Alignment.topLeft,
                300,
              ),
              renglonCapturaGet(
                "correoelectronico",
                buildCampoTextoGet(
                  propiedad,
                  ref,
                  "correoelectronico",
                  "",
                  30,
                  true,
                ),
                Alignment.topLeft,
                300,
              ),
              renglonCapturaGet(
                "nombreusuariocontacto",
                buildCampoTextoGet(
                  propiedad,
                  ref,
                  "nombreusuariocontacto",
                  "",
                  30,
                  true,
                ),
                Alignment.topLeft,
                300,
              ),
              renglonCapturaGet(
                "imgendelcontacto",
                buildCampoTextoGet(
                  propiedad,
                  ref,
                  "imgendelcontacto",
                  "",
                  30,
                  true,
                ),
                Alignment.topLeft,
                300,
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
              _botonNavegacion('Anterior', _anteriorPaso),
              botonGuardar(context),
            ],
          ),
          const SizedBox(height: 20),
          botonSalir(context),
        ],
      ),
      isActive: pasosActivar[4],
    );
  }

  Widget _buildDropdown({
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      width: 300,
      height: 40,
      alignment: Alignment.center,
      padding: const EdgeInsets.fromLTRB(8, 0, 5, 3),
      decoration: BoxDecoration(
        color: appTheme.surface,
        borderRadius: BorderRadius.circular(9),
        border: Border.all(color: appTheme.primary, width: 2),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          icon: Icon(
            Symbols.arrow_drop_down,
            size: menuTabIconSize * 2,
            color: appTheme.primary,
          ),
          selectedItemBuilder: (BuildContext context) {
            return items.map<Widget>((String item) {
              return Container(
                alignment: AlignmentGeometry.bottomLeft,
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 2),
                child: Text(
                  item,
                  style: TextStyle(
                    color: appTheme.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: menuTabLabelSize,
                  ),
                ),
              );
            }).toList();
          },
          items: items.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: SizedBox(
                height: 25.0,
                child: Text(
                  value,
                  style: TextStyle(
                    fontSize: menuTabLabelSize,
                    fontWeight: FontWeight.bold,
                    color: appTheme.primary,
                  ),
                ),
              ),
            );
          }).toList(),
          onChanged: onChanged,
          isExpanded: false,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Calculamos dimensiones
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    debugPrintLevels(1, " **************************************************");
    debugPrintLevels(1, " 02. PaginaEditaEspacio build");
    debugPrintLevels(1, " **************************************************");

    // Construir la lista de pasos aquí para asegurar acceso al contexto y estado actual
    List<Step> pasosCapturaPropiedad = [
      _buildPasoPropiedad(),
      _buildPasoPrecio(),
      _buildPasoUbicacion(),
      _buildPasoAdicionales(),
      _buildPasoContacto(),
    ];

    // --- SCAFFOLD ---
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 40.0,
        centerTitle: true,
        titleSpacing: 0,
        backgroundColor: appTheme.primary,
        iconTheme: IconThemeData(size: 14, color: appTheme.onPrimary),
        title: Text(
          'Actualiza propiedad: ${ref.read(espaciosCasaConListaFotosGetProvider).espaciosCasas.rows.isNotEmpty ? ref.read(espaciosCasaConListaFotosGetProvider).espaciosCasas.rows[0].value.espacioscasa.clavedelapropiedad : ""}',
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
      body: Form(
        key: formKeyEspacioComprado,
        autovalidateMode: AutovalidateMode.disabled,
        child: Stepper(
          controlsBuilder: (BuildContext context, ControlsDetails details) {
            // Ocultamos los controles por defecto ya que usamos botones personalizados en el contenido
            return Container(alignment: Alignment.topLeft);
          },
          steps: pasosCapturaPropiedad,
          type: (screenWidth < verticalWidth)
              ? StepperType.vertical
              : StepperType.horizontal,
          currentStep: currentStep,
          onStepTapped: (step) {
            setState(() {
              pasosActivar[currentStep] = false;
              currentStep = step;
              pasosActivar[currentStep] = true;
            });
          },
          onStepContinue: _siguientePaso,
          onStepCancel: _anteriorPaso,
        ),
      ),
    );
  }

  // --- MÉTODOS AUXILIARES DENTRO DEL STATE ---

  SizedBox capturaCampoGetConCheckBox(
    String nombreDeLaVariable,
    String expRegular,
    int numchar,
  ) {
    return SizedBox(
      width: 300,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          campoGetDeSeleccion(nombreDeLaVariable),
          const SizedBox(width: 5),
          (checklistAdicionales[nombreDeLaVariable] ?? false)
              ? renglonCapturaGet(
                  ref
                      .read(espaciosCasaConListaFotosGetProvider.notifier)
                      .getCampoEspaciosCasasGet(nombreDeLaVariable),
                  buildCampoTextoGet(
                    propiedad,
                    ref,
                    nombreDeLaVariable,
                    expRegular,
                    numchar,
                    true,
                  ),
                  Alignment.topLeft,
                  250,
                )
              : SizedBox(
                  width: 250,
                  child: Text(
                    ref
                        .read(espaciosCasaConListaFotosGetProvider.notifier)
                        .getCampoEspaciosCasasGet(nombreDeLaVariable),
                    maxLines: 2,
                    overflow: TextOverflow.visible,
                    softWrap: true,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  Checkbox campoGetDeSeleccion(String nombreDeLaVariable) {
    return Checkbox(
      value: checklistAdicionales[nombreDeLaVariable],
      onChanged: (value) {
        setState(() {
          if (value!) {
            checklistAdicionales[nombreDeLaVariable] = true;
            ref
                .read(espaciosCasaConListaFotosGetProvider.notifier)
                .setCampoEspaciosCasasGet(nombreDeLaVariable, "si");
            setCampoEspaciosCasasGet(propiedad, nombreDeLaVariable, "si");
          } else {
            checklistAdicionales[nombreDeLaVariable] = false;
            ref
                .read(espaciosCasaConListaFotosGetProvider.notifier)
                .setCampoEspaciosCasasGet(nombreDeLaVariable, "");
            setCampoEspaciosCasasGet(propiedad, nombreDeLaVariable, "");
          }
        });
      },
    );
  }

  void setchecklistAdicionalesGet(ValueEspaciosCasaGet propiedad) {
    debugPrintLevels(5, 'HTTP setchecklistAdicionalesGet');

    final map = propiedad.espacioscasa.datosadicionalescasa;

    if (map.panelessolares == "si")
      checklistAdicionales["panelessolares"] = true;
    if (map.jardin == "si") checklistAdicionales["jardin"] = true;
    if (map.alberca == "si") checklistAdicionales["alberca"] = true;
    if (map.calefaccion == "si") checklistAdicionales["calefaccion"] = true;
    if (map.aireacondicionado == "si")
      checklistAdicionales["aireacondicionado"] = true;
    if (map.seguridad == "si") checklistAdicionales["seguridad"] = true;
    if (map.enfraccionamiento == "si")
      checklistAdicionales["enfraccionamiento"] = true;
    if (map.casasenelconjunto == "si")
      checklistAdicionales["casasenelconjunto"] = true;
    if (map.casaclub == "si") checklistAdicionales["casaclub"] = true;
    if (map.salondeeventos == "si")
      checklistAdicionales["salondeeventos"] = true;
    if (map.centrodenegocios == "si")
      checklistAdicionales["centrodenegocios"] = true;
    if (map.gimnacio == "si") checklistAdicionales["gimnacio"] = true;
    if (map.cisterna == "si") checklistAdicionales["cisterna"] = true;
    if (map.almacenamientodeagua == "si")
      checklistAdicionales["almacenamientodeagua"] = true;
    if (map.tratamientodeaguas == "si")
      checklistAdicionales["tratamientodeaguas"] = true;
    if (map.otrascaracteristicas == "si")
      checklistAdicionales["otrascaracteristicas"] = true;
  }
}

// -----------------------------------------------------------------------------
// FUNCIONES AUXILIARES GLOBALES
// -----------------------------------------------------------------------------

SizedBox renglonCapturaGet(
  String etiqueta,
  Widget function,
  AlignmentGeometry alineacion,
  double ancho,
) {
  return SizedBox(
    width: ancho,
    child: FormaEtiquetaFolioGet(etiqueta, function, alineacion),
  );
}

Widget FormaEtiquetaFolioGet(
  String etiqueta,
  Widget function,
  AlignmentGeometry alineacion,
) {
  return Container(
    width: (screenWidth < smallScreenMin) ? screenWidth : screenWidth * 0.7,
    alignment: alineacion,
    child: function,
  );
}

Widget buildCampoTextoGet(
  ValueEspaciosCasaGet propiedad,
  WidgetRef ref,
  String nombreVariable,
  String expRegular,
  int numchar,
  bool enable,
) {
  return SizedBox(
    child: (!enable)
        ? Text(
            getCampoEspaciosCasasGet(propiedad, nombreVariable),
            maxLines: 8,
            style: TextStyle(
              color: appTheme.primary,
              fontSize: tamanoLetra,
              fontWeight: FontWeight.normal,
              decoration: TextDecoration.overline,
            ),
          )
        : TextFormField(
            initialValue: getCampoEspaciosCasasGet(propiedad, nombreVariable),
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
                  "${ref.read(espaciosCasaConListaFotosGetProvider.notifier).getNombreDelCampoPropiedadCasaGet(nombreVariable)} ",
              floatingLabelBehavior: FloatingLabelBehavior.always,
              isDense: true,
              contentPadding: const EdgeInsets.fromLTRB(10, 15, 10, 15),
            ),
            onChanged: (String? value) {
              setCampoEspaciosCasasGet(propiedad, nombreVariable, value!);
            },
          ),
  );
}

//----------------------------------

void setCampoEspaciosCasasGet(
  ValueEspaciosCasaGet propiedad,
  String campo,
  String valor,
) {
  debugPrintLevels(
    2,
    'HTTP setCampoEspaciosCasasGet: campo = $campo, valor: $valor',
  );

  switch (campo) {
    case "id":
      propiedad.id = valor;
      break;
    case "rev":
      propiedad.rev = valor;
      break;

    case "versiondelformato":
      propiedad.espacioscasa.versiondelformato = valor;
      break;
    case "idPropiedad":
      propiedad.espacioscasa.idPropiedad = valor;
      break;
    case "clavedelapropiedad":
      propiedad.espacioscasa.clavedelapropiedad = valor;
      break;
    case "idusuario":
      propiedad.espacioscasa.idusuario = valor;
      break;

    case "tipodeanuncio":
      propiedad.espacioscasa.tipodeanuncio = valor;
      break;
    case "tipodetransaccion":
      propiedad.espacioscasa.tipodetransaccion = valor;
      break;
    case "idTransaccion":
      propiedad.espacioscasa.idTransaccion = valor;
      break;

    case "nombredelapropiedad":
      propiedad.espacioscasa.nombredelapropiedad = valor;
      break;
    case "inmobiliaria":
      propiedad.espacioscasa.inmobiliaria = valor;
      break;
    case "inmobiliariaimagen":
      propiedad.espacioscasa.inmobiliariaimagen = valor;
      break;
    case "linkinmobiliaria":
      propiedad.espacioscasa.inmobiliariaimagen = valor;
      break;
    case "sloganinmobiliaria":
      propiedad.espacioscasa.inmobiliariaimagen = valor;
      break;

    case "ubicaciongeneral":
      propiedad.espacioscasa.ubicaciongeneral = valor;
      break;

    case "tipodepropiedad":
      propiedad.espacioscasa.tipodepropiedad = valor;
      break;

    case "descripcion":
      propiedad.espacioscasa.descripcion = valor;
      break;
    case "letreropromocional":
      propiedad.espacioscasa.letreropromocional = valor;
      break;
    case "metrosdeterreno":
      propiedad.espacioscasa.metrosdeterreno = valor;
      break;
    case "metrosconstruidos":
      propiedad.espacioscasa.metrosconstruidos = valor;
      break;
    case "recamaras":
      propiedad.espacioscasa.recamaras = valor;
      break;
    case "banos":
      propiedad.espacioscasa.banos = valor;
      break;
    case "mediosbanos":
      propiedad.espacioscasa.mediosbanos = valor;
      break;
    case "cuartosdeservicio":
      propiedad.espacioscasa.cuartosdeservicio = valor;
      break;
    case "estacionamientos":
      propiedad.espacioscasa.estacionamientos = valor;
      break;
    case "estacionamientoscubiertos":
      propiedad.espacioscasa.estacionamientoscubiertos = valor;
      break;

    case "panelessolares":
      propiedad.espacioscasa.datosadicionalescasa.panelessolares = valor;
      break;
    case "jardin":
      propiedad.espacioscasa.datosadicionalescasa.jardin = valor;
      break;
    case "alberca":
      propiedad.espacioscasa.datosadicionalescasa.alberca = valor;
      break;
    case "calefaccion":
      propiedad.espacioscasa.datosadicionalescasa.calefaccion = valor;
      break;
    case "aireacondicionado":
      propiedad.espacioscasa.datosadicionalescasa.aireacondicionado = valor;
      break;
    case "seguridad":
      propiedad.espacioscasa.datosadicionalescasa.seguridad = valor;
      break;
    case "enfraccionamiento":
      propiedad.espacioscasa.datosadicionalescasa.enfraccionamiento = valor;
      break;
    case "casasenelconjunto":
      propiedad.espacioscasa.datosadicionalescasa.casasenelconjunto = valor;
      break;
    case "casaclub":
      propiedad.espacioscasa.datosadicionalescasa.casaclub = valor;
      break;
    case "salondeeventos":
      propiedad.espacioscasa.datosadicionalescasa.salondeeventos = valor;
      break;
    case "centrodenegocios":
      propiedad.espacioscasa.datosadicionalescasa.centrodenegocios = valor;
      break;
    case "gimnacio":
      propiedad.espacioscasa.datosadicionalescasa.gimnacio = valor;
      break;
    case "cisterna":
      propiedad.espacioscasa.datosadicionalescasa.cisterna = valor;
      break;
    case "almacenamientodeagua":
      propiedad.espacioscasa.datosadicionalescasa.almacenamientodeagua = valor;
      break;
    case "tratamientodeaguas":
      propiedad.espacioscasa.datosadicionalescasa.tratamientodeaguas = valor;
      break;
    case "otrascaracteristicas":
      propiedad.espacioscasa.datosadicionalescasa.otrascaracteristicas = valor;

    case "elementosadicionalescasa":
      propiedad.espacioscasa.elementosadicionalescasa = valor;
      break;

    case "precioventa":
      propiedad.espacioscasa.precioventa = valor;
      break;
    case "preciorenta":
      propiedad.espacioscasa.preciorenta = valor;
      break;
    case "mantenimiento":
      propiedad.espacioscasa.mantenimiento = valor;
      break;
    case "moneda":
      propiedad.espacioscasa.moneda = valor;
      break;

    case "niveldeprioridad":
      propiedad.espacioscasa.niveldeprioridad = valor;
      break;
    case "condicionesdeventa":
      propiedad.espacioscasa.condicionesdeventa = valor;
      break;
    case "fotoprincipal":
      propiedad.espacioscasa.fotoprincipal = valor;
      break;
    case "numerodefotos":
      propiedad.espacioscasa.numerodefotos = valor;
      break;
    case "linkvideo":
      propiedad.espacioscasa.linkvideo = valor;
      break;

    case "nombre":
      propiedad.espacioscasa.datosdelcontactocasa.nombre = valor;
      break;
    case "empresa":
      propiedad.espacioscasa.datosdelcontactocasa.empresa = valor;
      break;
    case "imgendeempresa":
      propiedad.espacioscasa.datosdelcontactocasa.imgendeempresa = valor;
      break;
    case "numerocelular":
      propiedad.espacioscasa.datosdelcontactocasa.numerocelular = valor;
      break;
    case "numerootro":
      propiedad.espacioscasa.datosdelcontactocasa.numerootro = valor;
      break;
    case "numeroinmobiliaria":
      propiedad.espacioscasa.datosdelcontactocasa.numeroinmobiliaria = valor;
      break;
    case "correoelectronico":
      propiedad.espacioscasa.datosdelcontactocasa.correoelectronico = valor;
      break;
    case "idusuariocontacto":
      propiedad.espacioscasa.datosdelcontactocasa.idusuariocontacto = valor;
      break;
    case "nombreusuariocontacto":
      propiedad.espacioscasa.datosdelcontactocasa.nombreusuariocontacto = valor;
      break;
    case "imgendelcontacto":
      propiedad.espacioscasa.datosdelcontactocasa.imgendelcontacto = valor;
      break;

    case "pais":
      propiedad.espacioscasa.ubicacioncasa.pais = valor;
      break;

    // LocalidadCp es @freezed — se usa copyWith para actualizar
    case "idEstado":
      propiedad.espacioscasa.ubicacioncasa.localidadCp = propiedad
          .espacioscasa
          .ubicacioncasa
          .localidadCp
          .copyWith(idEstado: int.tryParse(valor) ?? 0);
      break;
    case "estado":
      propiedad.espacioscasa.ubicacioncasa.localidadCp = propiedad
          .espacioscasa
          .ubicacioncasa
          .localidadCp
          .copyWith(estado: valor);
      break;
    case "idMunicipio":
      propiedad.espacioscasa.ubicacioncasa.localidadCp = propiedad
          .espacioscasa
          .ubicacioncasa
          .localidadCp
          .copyWith(idMunicipio: int.tryParse(valor) ?? 0);
      break;
    case "municipio":
      propiedad.espacioscasa.ubicacioncasa.localidadCp = propiedad
          .espacioscasa
          .ubicacioncasa
          .localidadCp
          .copyWith(municipio: valor);
      break;
    case "ciudad":
      propiedad.espacioscasa.ubicacioncasa.localidadCp = propiedad
          .espacioscasa
          .ubicacioncasa
          .localidadCp
          .copyWith(ciudad: valor);
      break;
    case "zona":
      propiedad.espacioscasa.ubicacioncasa.localidadCp = propiedad
          .espacioscasa
          .ubicacioncasa
          .localidadCp
          .copyWith(zona: valor);
      break;
    case "asentamiento":
      propiedad.espacioscasa.ubicacioncasa.localidadCp = propiedad
          .espacioscasa
          .ubicacioncasa
          .localidadCp
          .copyWith(asentamiento: valor);
      break;
    case "codigopostal":
      propiedad.espacioscasa.ubicacioncasa.localidadCp = propiedad
          .espacioscasa
          .ubicacioncasa
          .localidadCp
          .copyWith(cp: int.tryParse(valor) ?? 0);
      break;
    case "tipo":
      propiedad.espacioscasa.ubicacioncasa.localidadCp = propiedad
          .espacioscasa
          .ubicacioncasa
          .localidadCp
          .copyWith(tipo: valor);
      break;

    case "calle":
      propiedad.espacioscasa.ubicacioncasa.calle = valor;
      break;
    case "numeroexterior":
      propiedad.espacioscasa.ubicacioncasa.numeroexterior = valor;
      break;
    case "numerointerior":
      propiedad.espacioscasa.ubicacioncasa.numerointerior = valor;
      break;

    case "latitud":
      propiedad.espacioscasa.ubicacioncasa.latitud = valor;
      break;
    case "longitud":
      propiedad.espacioscasa.ubicacioncasa.longitud = valor;
      break;
    case "latitudDecimal":
      propiedad.espacioscasa.ubicacioncasa.latitudDecimal = valor;
      break;
    case "longitudDecimal":
      propiedad.espacioscasa.ubicacioncasa.longitudDecimal = valor;
      break;

    case "diapublicacion":
      propiedad.espacioscasa.fechadepublicacioncasa.dia = int.parse(valor);
      break;
    case "mespublicacion":
      propiedad.espacioscasa.fechadepublicacioncasa.mes = int.parse(valor);
      break;
    case "aniopublicacion":
      propiedad.espacioscasa.fechadepublicacioncasa.anio = int.parse(valor);
      break;

    case "diadecierre":
      propiedad.espacioscasa.fechadecierrecasa.dia = int.parse(valor);
      break;
    case "mesdecierre":
      propiedad.espacioscasa.fechadecierrecasa.mes = int.parse(valor);
      break;
    case "aniodecierre":
      propiedad.espacioscasa.fechadecierrecasa.anio = int.parse(valor);
      break;

    case "activa":
      propiedad.espacioscasa.activa = int.parse(valor);
      break;
    case "timestampcasa":
      propiedad.espacioscasa.timestampcasa = valor;
      break;
  }
}

String getCampoEspaciosCasasGet(ValueEspaciosCasaGet propiedad, String campo) {
  // debugPrintLevels(5, 'HTTP getCampoEspaciosCasasGet');

  String variableRegreso = "";
  final varEspaciosCasasGetProvider = propiedad;

  switch (campo) {
    case "id":
      return variableRegreso = varEspaciosCasasGetProvider.id;
    case "rev":
      return variableRegreso = varEspaciosCasasGetProvider.rev;

    case "versiondelformato":
      return variableRegreso =
          varEspaciosCasasGetProvider.espacioscasa.versiondelformato;
    case "idPropiedad":
      return variableRegreso =
          varEspaciosCasasGetProvider.espacioscasa.idPropiedad;
    case "clavedelapropiedad":
      return variableRegreso =
          varEspaciosCasasGetProvider.espacioscasa.clavedelapropiedad;
    case "idusuario":
      return variableRegreso =
          varEspaciosCasasGetProvider.espacioscasa.idusuario;

    case "tipodeanuncio":
      return variableRegreso =
          varEspaciosCasasGetProvider.espacioscasa.tipodeanuncio;
    case "tipodetransaccion":
      return variableRegreso =
          varEspaciosCasasGetProvider.espacioscasa.tipodetransaccion;
    case "idTransaccion":
      return variableRegreso =
          varEspaciosCasasGetProvider.espacioscasa.idTransaccion;

    case "nombredelapropiedad":
      return variableRegreso =
          varEspaciosCasasGetProvider.espacioscasa.nombredelapropiedad;
    case "inmobiliaria":
      return variableRegreso =
          varEspaciosCasasGetProvider.espacioscasa.inmobiliaria;
    case "inmobiliariaimagen":
      return variableRegreso =
          varEspaciosCasasGetProvider.espacioscasa.inmobiliariaimagen;
    case "linkinmobiliaria":
      return variableRegreso =
          varEspaciosCasasGetProvider.espacioscasa.linkinmobiliaria;
    case "sloganinmobiliaria":
      return variableRegreso =
          varEspaciosCasasGetProvider.espacioscasa.sloganinmobiliaria;

    case "ubicaciongeneral":
      return variableRegreso =
          varEspaciosCasasGetProvider.espacioscasa.ubicaciongeneral;

    case "tipodepropiedad":
      return variableRegreso =
          varEspaciosCasasGetProvider.espacioscasa.tipodepropiedad;
    case "descripcion":
      return variableRegreso =
          varEspaciosCasasGetProvider.espacioscasa.descripcion;
    case "letreropromocional":
      return variableRegreso =
          varEspaciosCasasGetProvider.espacioscasa.letreropromocional;
    case "metrosdeterreno":
      return variableRegreso =
          varEspaciosCasasGetProvider.espacioscasa.metrosdeterreno;
    case "metrosconstruidos":
      return variableRegreso =
          varEspaciosCasasGetProvider.espacioscasa.metrosconstruidos;
    case "recamaras":
      return variableRegreso =
          varEspaciosCasasGetProvider.espacioscasa.recamaras;
    case "banos":
      return variableRegreso = varEspaciosCasasGetProvider.espacioscasa.banos;
    case "mediosbanos":
      return variableRegreso =
          varEspaciosCasasGetProvider.espacioscasa.mediosbanos;
    case "cuartosdeservicio":
      return variableRegreso =
          varEspaciosCasasGetProvider.espacioscasa.cuartosdeservicio;
    case "estacionamientos":
      return variableRegreso =
          varEspaciosCasasGetProvider.espacioscasa.estacionamientos;
    case "estacionamientoscubiertos":
      return variableRegreso =
          varEspaciosCasasGetProvider.espacioscasa.estacionamientoscubiertos;

    case "panelessolares":
      variableRegreso = varEspaciosCasasGetProvider
          .espacioscasa
          .datosadicionalescasa
          .panelessolares;
    case "jardin":
      return variableRegreso =
          varEspaciosCasasGetProvider.espacioscasa.datosadicionalescasa.jardin;
    case "alberca":
      return variableRegreso =
          varEspaciosCasasGetProvider.espacioscasa.datosadicionalescasa.alberca;
    case "calefaccion":
      return variableRegreso = varEspaciosCasasGetProvider
          .espacioscasa
          .datosadicionalescasa
          .calefaccion;
    case "aireacondicionado":
      variableRegreso = varEspaciosCasasGetProvider
          .espacioscasa
          .datosadicionalescasa
          .aireacondicionado;
    case "seguridad":
      return variableRegreso = varEspaciosCasasGetProvider
          .espacioscasa
          .datosadicionalescasa
          .seguridad;
    case "enfraccionamiento":
      variableRegreso = varEspaciosCasasGetProvider
          .espacioscasa
          .datosadicionalescasa
          .enfraccionamiento;
    case "casasenelconjunto":
      variableRegreso = varEspaciosCasasGetProvider
          .espacioscasa
          .datosadicionalescasa
          .casasenelconjunto;
    case "casaclub":
      return variableRegreso = varEspaciosCasasGetProvider
          .espacioscasa
          .datosadicionalescasa
          .casaclub;
    case "salondeeventos":
      variableRegreso = varEspaciosCasasGetProvider
          .espacioscasa
          .datosadicionalescasa
          .salondeeventos;
    case "centrodenegocios":
      variableRegreso = varEspaciosCasasGetProvider
          .espacioscasa
          .datosadicionalescasa
          .centrodenegocios;
    case "gimnacio":
      return variableRegreso = varEspaciosCasasGetProvider
          .espacioscasa
          .datosadicionalescasa
          .gimnacio;
    case "cisterna":
      return variableRegreso = varEspaciosCasasGetProvider
          .espacioscasa
          .datosadicionalescasa
          .cisterna;
    case "almacenamientodeagua":
      variableRegreso = varEspaciosCasasGetProvider
          .espacioscasa
          .datosadicionalescasa
          .almacenamientodeagua;
    case "tratamientodeaguas":
      variableRegreso = varEspaciosCasasGetProvider
          .espacioscasa
          .datosadicionalescasa
          .tratamientodeaguas;
    case "otrascaracteristicas":
      variableRegreso = varEspaciosCasasGetProvider
          .espacioscasa
          .datosadicionalescasa
          .otrascaracteristicas;

    case "elementosadicionalescasa":
      return variableRegreso =
          varEspaciosCasasGetProvider.espacioscasa.elementosadicionalescasa;

    case "precioventa":
      return variableRegreso =
          varEspaciosCasasGetProvider.espacioscasa.precioventa;
    case "preciorenta":
      return variableRegreso =
          varEspaciosCasasGetProvider.espacioscasa.preciorenta;
    case "mantenimiento":
      return variableRegreso =
          varEspaciosCasasGetProvider.espacioscasa.mantenimiento;
    case "moneda":
      return variableRegreso = varEspaciosCasasGetProvider.espacioscasa.moneda;
    case "niveldeprioridad":
      return variableRegreso =
          varEspaciosCasasGetProvider.espacioscasa.niveldeprioridad;
    case "condicionesdeventa":
      return variableRegreso =
          varEspaciosCasasGetProvider.espacioscasa.condicionesdeventa;
    case "fotoprincipal":
      return variableRegreso =
          varEspaciosCasasGetProvider.espacioscasa.fotoprincipal;
    case "numerodefotos":
      return variableRegreso =
          varEspaciosCasasGetProvider.espacioscasa.numerodefotos;
    case "linkvideo":
      return variableRegreso =
          varEspaciosCasasGetProvider.espacioscasa.linkvideo;

    case "nombre":
      return variableRegreso =
          varEspaciosCasasGetProvider.espacioscasa.datosdelcontactocasa.nombre;
    case "empresa":
      return variableRegreso =
          varEspaciosCasasGetProvider.espacioscasa.datosdelcontactocasa.empresa;
    case "imgendeempresa":
      return variableRegreso = varEspaciosCasasGetProvider
          .espacioscasa
          .datosdelcontactocasa
          .imgendeempresa;
    case "numerocelular":
      return variableRegreso = varEspaciosCasasGetProvider
          .espacioscasa
          .datosdelcontactocasa
          .numerocelular;
    case "numerootro":
      return variableRegreso = varEspaciosCasasGetProvider
          .espacioscasa
          .datosdelcontactocasa
          .numerootro;
    case "numeroinmobiliaria":
      return variableRegreso = varEspaciosCasasGetProvider
          .espacioscasa
          .datosdelcontactocasa
          .numeroinmobiliaria;
    case "correoelectronico":
      return variableRegreso = varEspaciosCasasGetProvider
          .espacioscasa
          .datosdelcontactocasa
          .correoelectronico;
    case "idusuariocontacto":
      return variableRegreso = varEspaciosCasasGetProvider
          .espacioscasa
          .datosdelcontactocasa
          .idusuariocontacto;
    case "nombreusuariocontacto":
      return variableRegreso = varEspaciosCasasGetProvider
          .espacioscasa
          .datosdelcontactocasa
          .nombreusuariocontacto;
    case "imgendelcontacto":
      return variableRegreso = varEspaciosCasasGetProvider
          .espacioscasa
          .datosdelcontactocasa
          .imgendelcontacto;

    case "pais":
      return variableRegreso =
          varEspaciosCasasGetProvider.espacioscasa.ubicacioncasa.pais;

    case "idEstado":
      return variableRegreso = varEspaciosCasasGetProvider
          .espacioscasa
          .ubicacioncasa
          .localidadCp
          .idEstado
          .toString();
    case "estado":
      return variableRegreso = varEspaciosCasasGetProvider
          .espacioscasa
          .ubicacioncasa
          .localidadCp
          .estado;
    case "idMunicipio":
      return variableRegreso = varEspaciosCasasGetProvider
          .espacioscasa
          .ubicacioncasa
          .localidadCp
          .idMunicipio
          .toString();
    case "municipio":
      return variableRegreso = varEspaciosCasasGetProvider
          .espacioscasa
          .ubicacioncasa
          .localidadCp
          .municipio;
    case "ciudad":
      return variableRegreso = varEspaciosCasasGetProvider
          .espacioscasa
          .ubicacioncasa
          .localidadCp
          .ciudad;
    case "zona":
      return variableRegreso = varEspaciosCasasGetProvider
          .espacioscasa
          .ubicacioncasa
          .localidadCp
          .zona;
    case "asentamiento":
      return variableRegreso = varEspaciosCasasGetProvider
          .espacioscasa
          .ubicacioncasa
          .localidadCp
          .asentamiento;
    case "codigopostal":
      return variableRegreso = varEspaciosCasasGetProvider
          .espacioscasa
          .ubicacioncasa
          .localidadCp
          .cp
          .toString();
    case "tipo":
      return variableRegreso = varEspaciosCasasGetProvider
          .espacioscasa
          .ubicacioncasa
          .localidadCp
          .tipo;

    case "calle":
      return variableRegreso =
          varEspaciosCasasGetProvider.espacioscasa.ubicacioncasa.calle;
    case "numeroexterior":
      return variableRegreso =
          varEspaciosCasasGetProvider.espacioscasa.ubicacioncasa.numeroexterior;
    case "numerointerior":
      return variableRegreso =
          varEspaciosCasasGetProvider.espacioscasa.ubicacioncasa.numerointerior;
    case "entrecalle01":
      return variableRegreso =
          varEspaciosCasasGetProvider.espacioscasa.ubicacioncasa.entrecalle01;
    case "entrecalle02":
      return variableRegreso =
          varEspaciosCasasGetProvider.espacioscasa.ubicacioncasa.entrecalle02;

    case "latitud":
      return variableRegreso =
          varEspaciosCasasGetProvider.espacioscasa.ubicacioncasa.latitud;
    case "longitud":
      return variableRegreso =
          varEspaciosCasasGetProvider.espacioscasa.ubicacioncasa.longitud;
    case "latitudDecimal":
      return variableRegreso =
          varEspaciosCasasGetProvider.espacioscasa.ubicacioncasa.latitudDecimal;
    case "longitudDecimal":
      return variableRegreso = varEspaciosCasasGetProvider
          .espacioscasa
          .ubicacioncasa
          .longitudDecimal;

    case "diapublicacion":
      return variableRegreso = varEspaciosCasasGetProvider
          .espacioscasa
          .fechadepublicacioncasa
          .dia
          .toStringAsFixed(0);
    case "mespublicacion":
      return variableRegreso = varEspaciosCasasGetProvider
          .espacioscasa
          .fechadepublicacioncasa
          .mes
          .toStringAsFixed(0);
    case "aniopublicacion":
      return variableRegreso = varEspaciosCasasGetProvider
          .espacioscasa
          .fechadepublicacioncasa
          .anio
          .toStringAsFixed(0);

    case "diadecierre":
      return variableRegreso = varEspaciosCasasGetProvider
          .espacioscasa
          .fechadecierrecasa
          .dia
          .toStringAsFixed(0);
    case "mesdecierre":
      return variableRegreso = varEspaciosCasasGetProvider
          .espacioscasa
          .fechadecierrecasa
          .mes
          .toStringAsFixed(0);
    case "aniodecierre":
      return variableRegreso = varEspaciosCasasGetProvider
          .espacioscasa
          .fechadecierrecasa
          .anio
          .toStringAsFixed(0);

    case "activa":
      return variableRegreso = varEspaciosCasasGetProvider.espacioscasa.activa
          .toStringAsFixed(0);
    case "timestampcasa":
      return variableRegreso =
          varEspaciosCasasGetProvider.espacioscasa.timestampcasa;
  }
  return variableRegreso;
}

//------------------------------------------------------------------------------
// OPTIMIZADO
/*
class PaginaEditaEspacio extends ConsumerStatefulWidget {
  final ValueEspaciosCasaGet propiedadParameter;
  const PaginaEditaEspacio(this.propiedadParameter, {super.key});

  @override
  ConsumerState createState() {
    debugPrintLevels(1, " **************************************************");
    debugPrintLevels(1, "  1. PaginaEditaEspacio createState");
    debugPrintLevels(1, " **************************************************");
    return PaginaEditaEspacioState();
  }
}

class PaginaEditaEspacioState extends ConsumerState<PaginaEditaEspacio>
    with TickerProviderStateMixin {
  // VARIABLES DE ESTADO
  late TextEditingController celdaControllerPublicacion;
  int currentStep = 0;
  List<bool> pasosActivar = List<bool>.filled(5, false);

  double alto = 25;
  double ancho = 100;
  double verticalWidth = 275.00;

  // Propiedad local mutable para el formulario
  late ValueEspaciosCasaGet propiedad;

  final formKeyEspacioComprado = GlobalKey<FormState>();
  String tipoDePropiedad = otrosTiposDeInmueble[0];
  String tipoDeTransaccion = "Venta";

  @override
  void initState() {
    super.initState(); // Se recomienda llamar a super primero
    debugPrintLevels(1, " **************************************************");
    debugPrintLevels(1, " 02. PaginaEditaEspacio initState");
    debugPrintLevels(1, " **************************************************");

    celdaControllerPublicacion = TextEditingController();
    propiedad = widget.propiedadParameter;

    // Inicializar checkbox según la data
    setchecklistAdicionalesGet(propiedad);

    // Configuración inicial de los pasos del Stepper
    pasosActivar[0] = true;

    // Inicializar dropdowns con valores seguros y validación de existencia
    if (propiedad.espacioscasa.tipodepropiedad == "" ||
        !listaTipoInmuebles.contains(propiedad.espacioscasa.tipodepropiedad)) {
      tipoDePropiedad = otrosTiposDeInmueble[0];
    } else {
      tipoDePropiedad = propiedad.espacioscasa.tipodepropiedad;
    }

    // Inicializar transacción
    if (propiedad.espacioscasa.tipodetransaccion != "" &&
        listaTiposDeTransaccion.contains(
          propiedad.espacioscasa.tipodetransaccion,
        )) {
      tipoDeTransaccion = propiedad.espacioscasa.tipodetransaccion;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    debugPrintLevels(1, " PaginaEditaEspacio dispose");
    celdaControllerPublicacion.dispose();
    super.dispose();
  }

  update() {
    if (mounted) {
      setState(() {
        debugPrintLevels(1, " 03. PaginaEditaEspacio setState update");
      });
    }
  }

  // --- MÉTODOS DE UI (Botones y Lógica de Pasos) ---

  void _siguientePaso() {
    setState(() {
      if (currentStep < 4) {
        pasosActivar[currentStep] = false;
        currentStep++;
        pasosActivar[currentStep] = true;
      }
    });
  }

  void _anteriorPaso() {
    setState(() {
      if (currentStep > 0) {
        pasosActivar[currentStep] = false;
        currentStep--;
        pasosActivar[currentStep] = true;
      }
    });
  }

  ElevatedButton botonGuardar(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: appTheme.primary,
        minimumSize: const Size(150, 40),
      ),
      onPressed: () async {
        if (formKeyEspacioComprado.currentState!.validate()) {
          formKeyEspacioComprado.currentState!.save();

          // 1. Obtener índice actual
          int indexAnterior = ref
              .read(espaciosCasaConListaFotosGetProvider.notifier)
              .getIndexEspaciosCasas();

          // 2. Buscar índice basado en ID (por seguridad)
          int index = ref
              .read(espaciosCasaConListaFotosGetProvider)
              .espaciosCasas
              .rows
              .indexWhere(
                (propiedadEnLista) =>
                    propiedadEnLista.value.espacioscasa.idPropiedad ==
                    propiedad.espacioscasa.idPropiedad,
              );
          // EL INDICE ES LA PROPIEDAD ACTUAL EN LA LISTA
          // REGRESA -1 SI NO SE ENCONTRO LA POSICIÓN
          // SI LA ENCONTRO, ACTUALIZA EL INDICE CON SU POSICIÓN
          if (index != -1) {
            ref
                .read(espaciosCasaConListaFotosGetProvider.notifier)
                .setIndexEspaciosCasas(index);
          }
          // 3. ACTUALIZAR EL ESTADO EN RIVERPOD
          // COPIANDO TODA LA PROPIEDAD EN LA POSICIÓN INDEX
          ref
              .read(espaciosCasaConListaFotosGetProvider.notifier)
              .setEspaciosCasasGet(ref, propiedad);

          debugPrintLevels(5, "05. PaginaEditaEspacio Guarda cambios ");

          // 4. Guardar en Base de Datos
          await ref
              .read(espaciosCasaConListaFotosGetProvider.notifier)
              .updatePropiedadCasaGetToCouchDB()
              .then((resultado) async {
                // Restaurar índice si es necesario
                ref
                    .read(espaciosCasaConListaFotosGetProvider.notifier)
                    .setIndexEspaciosCasas(indexAnterior);

                debugPrintLevels(
                  5,
                  "06. PaginaEditaEspacio Resultado de Update espacio: $resultado",
                );

                if (mounted) {
                  await showMessageDialog(
                    context,
                    "Actualiza propiedad",
                    "Se actualizó correctamente",
                    appTheme.primary,
                    TextAlign.center,
                  );
                  Navigator.of(context).pop();
                }
              });
        }
      },
      child: Text(
        'Guardar',
        style: TextStyle(fontSize: 14, color: appTheme.onPrimary),
      ),
    );
  }

  ElevatedButton botonSalir(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: appTheme.onSurface,
        minimumSize: const Size(150, 40),
      ),
      onPressed: () {
        //Navigator.of(context).pop();
        Navigator.pushReplacementNamed(
          context,
          AppRoutes.principal,
          arguments: "",
        );
      },
      child: const Text(
        'Regresar',
        style: TextStyle(fontSize: 14, color: Colors.white),
      ),
    );
  }

  ElevatedButton _botonNavegacion(String texto, VoidCallback funcion) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: appTheme.primary,
        minimumSize: const Size(150, 40),
      ),
      onPressed: funcion,
      child: Text(
        texto,
        style: const TextStyle(fontSize: 14, color: Colors.white),
      ),
    );
  }

  // --- CONSTRUCCIÓN DE PASOS (Steps) ---

  Step _buildPasoPropiedad() {
    return Step(
      title: Text((screenWidth > verticalWidth) ? "" : "Propiedad"),
      label: Text(
        (screenWidth > verticalWidth) ? "Propiedad" : "",
        style: TextStyle(
          color: appTheme.primary,
          fontWeight: (pasosActivar[0]) ? FontWeight.bold : FontWeight.normal,
          fontSize: 10,
        ),
      ),
      content: Column(
        children: [
          Center(
            child: Text(
              "Datos de la propiedad",
              style: TextStyle(
                color: appTheme.primary,
                fontSize: fontSizeTituloPagina,
                fontWeight: FontWeight.bold,
                fontFamily: "Comfortaa",
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
              // Dropdown Tipo Propiedad
              _buildDropdown(
                value: tipoDePropiedad,
                items: listaTipoInmuebles,
                onChanged: (newValue) {
                  if (newValue != null) {
                    setState(() {
                      tipoDePropiedad = newValue;
                      setCampoEspaciosCasasGet(
                        propiedad,
                        "tipodepropiedad",
                        tipoDePropiedad,
                      );
                    });
                  }
                },
              ),
              // Dropdown Tipo Transacción
              _buildDropdown(
                value: tipoDeTransaccion,
                items: listaTiposDeTransaccion,
                onChanged: (newValue) {
                  if (newValue != null) {
                    setState(() {
                      tipoDeTransaccion = newValue;
                      setCampoEspaciosCasasGet(
                        propiedad,
                        "tipodetransaccion",
                        tipoDeTransaccion,
                      );
                    });
                  }
                },
              ),
              // Campos dinámicos
              renglonCapturaGet(
                "clavedelapropiedad",
                buildCampoTextoGet(
                  propiedad,
                  ref,
                  "clavedelapropiedad",
                  "",
                  20,
                  true,
                ),
                Alignment.topLeft,
                300,
              ),
              renglonCapturaGet(
                "tipodeanuncio",
                buildCampoTextoGet(
                  propiedad,
                  ref,
                  "tipodeanuncio",
                  "",
                  50,
                  false,
                ),
                Alignment.topLeft,
                300,
              ),
              renglonCapturaGet(
                "tipodetransaccion",
                buildCampoTextoGet(
                  propiedad,
                  ref,
                  "tipodetransaccion",
                  "",
                  50,
                  true,
                ),
                Alignment.topLeft,
                300,
              ),
              renglonCapturaGet(
                "nombredelapropiedad",
                buildCampoTextoGet(
                  propiedad,
                  ref,
                  "nombredelapropiedad",
                  "",
                  50,
                  true,
                ),
                Alignment.topLeft,
                300,
              ),
              renglonCapturaGet(
                "inmobiliaria",
                buildCampoTextoGet(
                  propiedad,
                  ref,
                  "inmobiliaria",
                  "",
                  80,
                  true,
                ),
                Alignment.topLeft,
                300,
              ),
              renglonCapturaGet(
                "inmobiliariaimagen",
                buildCampoTextoGet(
                  propiedad,
                  ref,
                  "inmobiliariaimagen",
                  "",
                  80,
                  true,
                ),
                Alignment.topLeft,
                300,
              ),
              renglonCapturaGet(
                "linkinmobiliaria",
                buildCampoTextoGet(
                  propiedad,
                  ref,
                  "linkinmobiliaria",
                  "",
                  80,
                  true,
                ),
                Alignment.topLeft,
                300,
              ),
              renglonCapturaGet(
                "sloganinmobiliaria",
                buildCampoTextoGet(
                  propiedad,
                  ref,
                  "sloganinmobiliaria",
                  "",
                  80,
                  true,
                ),
                Alignment.topLeft,
                300,
              ),
              renglonCapturaGet(
                "ubicaciongeneral",
                buildCampoTextoGet(
                  propiedad,
                  ref,
                  "ubicaciongeneral",
                  "",
                  80,
                  true,
                ),
                Alignment.topLeft,
                300,
              ),
              renglonCapturaGet(
                "descripcion",
                buildCampoTextoGet(propiedad, ref, "descripcion", "", 80, true),
                Alignment.topLeft,
                300,
              ),
              renglonCapturaGet(
                "letreropromocional",
                buildCampoTextoGet(
                  propiedad,
                  ref,
                  "letreropromocional",
                  "",
                  80,
                  true,
                ),
                Alignment.topLeft,
                300,
              ),
              if (metrosdeterrenoMatriz.contains(tipoDePropiedad))
                renglonCapturaGet(
                  "metrosdeterreno",
                  buildCampoTextoGet(
                    propiedad,
                    ref,
                    "metrosdeterreno",
                    "",
                    250,
                    true,
                  ),
                  Alignment.topLeft,
                  300,
                ),
              if (metrosconstruidosMatriz.contains(tipoDePropiedad))
                renglonCapturaGet(
                  "metrosconstruidos",
                  buildCampoTextoGet(
                    propiedad,
                    ref,
                    "metrosconstruidos",
                    "",
                    250,
                    true,
                  ),
                  Alignment.topLeft,
                  300,
                ),
              if (recamarasMatriz.contains(tipoDePropiedad))
                renglonCapturaGet(
                  "recamaras",
                  buildCampoTextoGet(propiedad, ref, "recamaras", "", 20, true),
                  Alignment.topLeft,
                  300,
                ),
              if (banosMatriz.contains(tipoDePropiedad))
                renglonCapturaGet(
                  "banos",
                  buildCampoTextoGet(propiedad, ref, "banos", "", 10, true),
                  Alignment.topLeft,
                  300,
                ),
              if (mediosbanosMatriz.contains(tipoDePropiedad))
                renglonCapturaGet(
                  "mediosbanos",
                  buildCampoTextoGet(
                    propiedad,
                    ref,
                    "mediosbanos",
                    "",
                    50,
                    true,
                  ),
                  Alignment.topLeft,
                  300,
                ),
              if (cuartosdeservicioMatriz.contains(tipoDePropiedad))
                renglonCapturaGet(
                  "cuartosdeservicio",
                  buildCampoTextoGet(
                    propiedad,
                    ref,
                    "cuartosdeservicio",
                    "",
                    80,
                    true,
                  ),
                  Alignment.topLeft,
                  300,
                ),
              if (estacionamientosMatriz.contains(tipoDePropiedad))
                renglonCapturaGet(
                  "estacionamientos",
                  buildCampoTextoGet(
                    propiedad,
                    ref,
                    "estacionamientos",
                    "",
                    80,
                    true,
                  ),
                  Alignment.topLeft,
                  300,
                ),
              if (estacionamientoscubiertosMatriz.contains(tipoDePropiedad))
                renglonCapturaGet(
                  "estacionamientoscubiertos",
                  buildCampoTextoGet(
                    propiedad,
                    ref,
                    "estacionamientoscubiertos",
                    "",
                    80,
                    true,
                  ),
                  Alignment.topLeft,
                  300,
                ),
              if (elementosadicionalescasaMatriz.contains(tipoDePropiedad))
                renglonCapturaGet(
                  "elementosadicionalescasa",
                  buildCampoTextoGet(
                    propiedad,
                    ref,
                    "elementosadicionalescasa",
                    "",
                    250,
                    true,
                  ),
                  Alignment.topLeft,
                  300,
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
              botonGuardar(context),
              _botonNavegacion('Siguiente', _siguientePaso),
            ],
          ),
          const SizedBox(height: 20),
          botonSalir(context),
        ],
      ),
      isActive: pasosActivar[0],
    );
  }

  Step _buildPasoPrecio() {
    return Step(
      title: Text((screenWidth > verticalWidth) ? "" : "Precio"),
      label: Text(
        (screenWidth > verticalWidth) ? "Precio" : "",
        style: TextStyle(
          color: appTheme.primary,
          fontWeight: (pasosActivar[1]) ? FontWeight.bold : FontWeight.normal,
          fontSize: 10,
        ),
      ),
      content: Column(
        children: [
          Center(
            child: Text(
              "Precio y costos de la propiedad",
              style: TextStyle(
                color: appTheme.primary,
                fontSize: fontSizeTituloPagina,
                fontWeight: FontWeight.bold,
                fontFamily: "Comfortaa",
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
              if ([
                    "Venta",
                    "Venta/Renta",
                    "Traspaso",
                  ].contains(tipoDeTransaccion) &&
                  precioventaMatriz.contains(tipoDePropiedad))
                renglonCapturaGet(
                  "precioventa",
                  buildCampoTextoGet(
                    propiedad,
                    ref,
                    "precioventa",
                    "",
                    80,
                    true,
                  ),
                  Alignment.topLeft,
                  300,
                ),
              if (["Renta", "Venta/Renta"].contains(tipoDeTransaccion) &&
                  preciorentaMatriz.contains(tipoDePropiedad))
                renglonCapturaGet(
                  "preciorenta",
                  buildCampoTextoGet(
                    propiedad,
                    ref,
                    "preciorenta",
                    "",
                    80,
                    true,
                  ),
                  Alignment.topLeft,
                  300,
                ),
              if (["Renta", "Venta/Renta"].contains(tipoDeTransaccion) &&
                  mantenimientoMatriz.contains(tipoDePropiedad))
                renglonCapturaGet(
                  "mantenimiento",
                  buildCampoTextoGet(
                    propiedad,
                    ref,
                    "mantenimiento",
                    "",
                    80,
                    true,
                  ),
                  Alignment.topLeft,
                  300,
                ),
              if (monedaMatriz.contains(tipoDePropiedad))
                renglonCapturaGet(
                  "moneda",
                  buildCampoTextoGet(propiedad, ref, "moneda", "", 30, true),
                  Alignment.topLeft,
                  300,
                ),
              renglonCapturaGet(
                "condicionesdeventa",
                buildCampoTextoGet(
                  propiedad,
                  ref,
                  "condicionesdeventa",
                  "",
                  30,
                  true,
                ),
                Alignment.topLeft,
                300,
              ),
              if (linkvideoMatriz.contains(tipoDePropiedad))
                renglonCapturaGet(
                  "linkvideo",
                  buildCampoTextoGet(propiedad, ref, "linkvideo", "", 30, true),
                  Alignment.topLeft,
                  300,
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
              _botonNavegacion('Anterior', _anteriorPaso),
              botonGuardar(context),
              _botonNavegacion('Siguiente', _siguientePaso),
            ],
          ),
          const SizedBox(height: 20),
          botonSalir(context),
        ],
      ),
      isActive: pasosActivar[1],
    );
  }

  Step _buildPasoUbicacion() {
    return Step(
      title: Text((screenWidth > verticalWidth) ? "" : "Ubicación"),
      label: Text(
        (screenWidth > verticalWidth) ? "Ubicación" : "",
        style: TextStyle(
          color: appTheme.primary,
          fontWeight: (pasosActivar[2]) ? FontWeight.bold : FontWeight.normal,
          fontSize: 10,
        ),
      ),
      content: Column(
        children: [
          Center(
            child: Text(
              "Dirección de la propiedad",
              style: TextStyle(
                color: appTheme.primary,
                fontSize: fontSizeTituloPagina,
                fontWeight: FontWeight.bold,
                fontFamily: "Comfortaa",
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
                "pais",
                buildCampoTextoGet(propiedad, ref, "pais", "", 30, false),
                Alignment.topLeft,
                300,
              ),
              renglonCapturaGet(
                "estado",
                buildCampoTextoGet(propiedad, ref, "estado", "", 30, true),
                Alignment.topLeft,
                300,
              ),
              renglonCapturaGet(
                "municipio",
                buildCampoTextoGet(propiedad, ref, "municipio", "", 30, true),
                Alignment.topLeft,
                300,
              ),
              renglonCapturaGet(
                "ciudad",
                buildCampoTextoGet(propiedad, ref, "ciudad", "", 30, true),
                Alignment.topLeft,
                300,
              ),
              renglonCapturaGet(
                "zona",
                buildCampoTextoGet(propiedad, ref, "zona", "", 30, true),
                Alignment.topLeft,
                300,
              ),
              renglonCapturaGet(
                "asentamiento",
                buildCampoTextoGet(
                  propiedad,
                  ref,
                  "asentamiento",
                  "",
                  30,
                  true,
                ),
                Alignment.topLeft,
                300,
              ),
              renglonCapturaGet(
                "codigopostal",
                buildCampoTextoGet(
                  propiedad,
                  ref,
                  "codigopostal",
                  "",
                  30,
                  true,
                ),
                Alignment.topLeft,
                300,
              ),
              renglonCapturaGet(
                "tipo",
                buildCampoTextoGet(propiedad, ref, "tipo", "", 30, true),
                Alignment.topLeft,
                300,
              ),
              renglonCapturaGet(
                "calle",
                buildCampoTextoGet(propiedad, ref, "calle", "", 30, true),
                Alignment.topLeft,
                300,
              ),
              renglonCapturaGet(
                "numeroexterior",
                buildCampoTextoGet(
                  propiedad,
                  ref,
                  "numeroexterior",
                  "",
                  30,
                  true,
                ),
                Alignment.topLeft,
                300,
              ),
              renglonCapturaGet(
                "numerointerior",
                buildCampoTextoGet(
                  propiedad,
                  ref,
                  "numerointerior",
                  "",
                  30,
                  true,
                ),
                Alignment.topLeft,
                300,
              ),
              renglonCapturaGet(
                "entrecalle01",
                buildCampoTextoGet(
                  propiedad,
                  ref,
                  "entrecalle01",
                  "",
                  30,
                  true,
                ),
                Alignment.topLeft,
                300,
              ),
              renglonCapturaGet(
                "entrecalle02",
                buildCampoTextoGet(
                  propiedad,
                  ref,
                  "entrecalle02",
                  "",
                  30,
                  true,
                ),
                Alignment.topLeft,
                300,
              ),
              renglonCapturaGet(
                "latitud",
                buildCampoTextoGet(propiedad, ref, "latitud", "", 30, true),
                Alignment.topLeft,
                300,
              ),
              renglonCapturaGet(
                "longitud",
                buildCampoTextoGet(propiedad, ref, "longitud", "", 30, true),
                Alignment.topLeft,
                300,
              ),
              renglonCapturaGet(
                "latitudDecimal",
                buildCampoTextoGet(
                  propiedad,
                  ref,
                  "latitudDecimal",
                  "",
                  30,
                  true,
                ),
                Alignment.topLeft,
                300,
              ),
              renglonCapturaGet(
                "longitudDecimal",
                buildCampoTextoGet(
                  propiedad,
                  ref,
                  "longitudDecimal",
                  "",
                  30,
                  true,
                ),
                Alignment.topLeft,
                300,
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
              _botonNavegacion('Anterior', _anteriorPaso),
              botonGuardar(context),
              _botonNavegacion('Siguiente', _siguientePaso),
            ],
          ),
          const SizedBox(height: 20),
          botonSalir(context),
        ],
      ),
      isActive: pasosActivar[2],
    );
  }

  Step _buildPasoAdicionales() {
    return Step(
      title: Text((screenWidth > verticalWidth) ? "" : "Adicionales"),
      label: Text(
        (screenWidth > verticalWidth) ? "Adicionales" : "",
        style: TextStyle(
          color: appTheme.primary,
          fontWeight: (pasosActivar[3]) ? FontWeight.bold : FontWeight.normal,
          fontSize: 10,
        ),
      ),
      content: Column(
        children: [
          Center(
            child: Text(
              "Datos adicionales",
              style: TextStyle(
                color: appTheme.primary,
                fontSize: fontSizeTituloPagina,
                fontWeight: FontWeight.bold,
                fontFamily: "Comfortaa",
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
              if (panelessolaresMatriz.contains(tipoDePropiedad))
                capturaCampoGetConCheckBox("panelessolares", "", 80),
              if (jardinMatriz.contains(tipoDePropiedad))
                capturaCampoGetConCheckBox("jardin", "", 80),
              if (albercaMatriz.contains(tipoDePropiedad))
                capturaCampoGetConCheckBox("alberca", "", 80),
              if (calefaccionMatriz.contains(tipoDePropiedad))
                capturaCampoGetConCheckBox("calefaccion", "", 80),
              if (aireacondicionadoMatriz.contains(tipoDePropiedad))
                capturaCampoGetConCheckBox("aireacondicionado", "", 80),
              if (seguridadMatriz.contains(tipoDePropiedad))
                capturaCampoGetConCheckBox("seguridad", "", 80),
              if (enfraccionamientoMatriz.contains(tipoDePropiedad))
                capturaCampoGetConCheckBox("enfraccionamiento", "", 80),
              if (casasenelconjuntoMatriz.contains(tipoDePropiedad))
                capturaCampoGetConCheckBox("casasenelconjunto", "", 80),
              if (casaclubMatriz.contains(tipoDePropiedad))
                capturaCampoGetConCheckBox("casaclub", "", 80),
              if (salondeeventosMatriz.contains(tipoDePropiedad))
                capturaCampoGetConCheckBox("salondeeventos", "", 80),
              if (centrodenegociosMatriz.contains(tipoDePropiedad))
                capturaCampoGetConCheckBox("centrodenegocios", "", 80),
              if (gimnacioMatriz.contains(tipoDePropiedad))
                capturaCampoGetConCheckBox("gimnacio", "", 80),
              if (cisternaMatriz.contains(tipoDePropiedad))
                capturaCampoGetConCheckBox("cisterna", "", 80),
              if (almacenamientodeaguaMatriz.contains(tipoDePropiedad))
                capturaCampoGetConCheckBox("almacenamientodeagua", "", 80),
              if (tratamientodeaguasMatriz.contains(tipoDePropiedad))
                capturaCampoGetConCheckBox("tratamientodeaguas", "", 80),
              if (otrascaracteristicasMatriz.contains(tipoDePropiedad))
                capturaCampoGetConCheckBox("otrascaracteristicas", "", 80),
            ],
          ),
          const SizedBox(height: 20),
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 20,
            runSpacing: 10,
            alignment: WrapAlignment.center,
            children: [
              _botonNavegacion('Anterior', _anteriorPaso),
              botonGuardar(context),
              _botonNavegacion('Siguiente', _siguientePaso),
            ],
          ),
          const SizedBox(height: 20),
          botonSalir(context),
        ],
      ),
      isActive: pasosActivar[3],
    );
  }

  Step _buildPasoContacto() {
    return Step(
      title: Text((screenWidth > verticalWidth) ? "" : "Contacto"),
      label: Text(
        (screenWidth > verticalWidth) ? "Contacto" : "",
        style: TextStyle(
          color: appTheme.primary,
          fontWeight: (pasosActivar[4]) ? FontWeight.bold : FontWeight.normal,
          fontSize: 10,
        ),
      ),
      content: Column(
        children: [
          Center(
            child: Text(
              "Datos del promotor",
              style: TextStyle(
                color: appTheme.primary,
                fontSize: fontSizeTituloPagina,
                fontWeight: FontWeight.bold,
                fontFamily: "Comfortaa",
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
                "nombre",
                buildCampoTextoGet(propiedad, ref, "nombre", "", 30, true),
                Alignment.topLeft,
                300,
              ),
              renglonCapturaGet(
                "empresa",
                buildCampoTextoGet(propiedad, ref, "empresa", "", 30, true),
                Alignment.topLeft,
                300,
              ),
              renglonCapturaGet(
                "imgendeempresa",
                buildCampoTextoGet(
                  propiedad,
                  ref,
                  "imgendeempresa",
                  "",
                  30,
                  true,
                ),
                Alignment.topLeft,
                300,
              ),
              renglonCapturaGet(
                "numerocelular",
                buildCampoTextoGet(
                  propiedad,
                  ref,
                  "numerocelular",
                  "",
                  30,
                  true,
                ),
                Alignment.topLeft,
                300,
              ),
              renglonCapturaGet(
                "numerootro",
                buildCampoTextoGet(propiedad, ref, "numerootro", "", 30, true),
                Alignment.topLeft,
                300,
              ),
              renglonCapturaGet(
                "numeroinmobiliaria",
                buildCampoTextoGet(
                  propiedad,
                  ref,
                  "numeroinmobiliaria",
                  "",
                  30,
                  true,
                ),
                Alignment.topLeft,
                300,
              ),
              renglonCapturaGet(
                "correoelectronico",
                buildCampoTextoGet(
                  propiedad,
                  ref,
                  "correoelectronico",
                  "",
                  30,
                  true,
                ),
                Alignment.topLeft,
                300,
              ),
              renglonCapturaGet(
                "nombreusuariocontacto",
                buildCampoTextoGet(
                  propiedad,
                  ref,
                  "nombreusuariocontacto",
                  "",
                  30,
                  true,
                ),
                Alignment.topLeft,
                300,
              ),
              renglonCapturaGet(
                "imgendelcontacto",
                buildCampoTextoGet(
                  propiedad,
                  ref,
                  "imgendelcontacto",
                  "",
                  30,
                  true,
                ),
                Alignment.topLeft,
                300,
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
              _botonNavegacion('Anterior', _anteriorPaso),
              botonGuardar(context),
            ],
          ),
          const SizedBox(height: 20),
          botonSalir(context),
        ],
      ),
      isActive: pasosActivar[4],
    );
  }

  Widget _buildDropdown({
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      width: 300,
      height: 40,
      alignment: Alignment.center,
      padding: const EdgeInsets.fromLTRB(8, 0, 5, 3),
      decoration: BoxDecoration(
        color: appTheme.surface,
        borderRadius: BorderRadius.circular(9),
        border: Border.all(color: appTheme.primary, width: 2),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          icon: Icon(
            Symbols.arrow_drop_down,
            size: menuTabIconSize * 2,
            color: appTheme.primary,
          ),
          selectedItemBuilder: (BuildContext context) {
            return items.map<Widget>((String item) {
              return Container(
                alignment: AlignmentGeometry.bottomLeft,
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 2),
                child: Text(
                  item,
                  style: TextStyle(
                    color: appTheme.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: menuTabLabelSize,
                  ),
                ),
              );
            }).toList();
          },
          items: items.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: SizedBox(
                height: 25.0,
                child: Text(
                  value,
                  style: TextStyle(
                    fontSize: menuTabLabelSize,
                    fontWeight: FontWeight.bold,
                    color: appTheme.primary,
                  ),
                ),
              ),
            );
          }).toList(),
          onChanged: onChanged,
          isExpanded: false,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Calculamos dimensiones
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    debugPrintLevels(1, " **************************************************");
    debugPrintLevels(1, " 02. PaginaEditaEspacio build");
    debugPrintLevels(1, " **************************************************");

    // Construir la lista de pasos aquí para asegurar acceso al contexto y estado actual
    List<Step> pasosCapturaPropiedad = [
      _buildPasoPropiedad(),
      _buildPasoPrecio(),
      _buildPasoUbicacion(),
      _buildPasoAdicionales(),
      _buildPasoContacto(),
    ];

    // --- SCAFFOLD ---
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 40.0,
        centerTitle: true,
        titleSpacing: 0,
        backgroundColor: appTheme.primary,
        iconTheme: IconThemeData(size: 14, color: appTheme.onPrimary),
        title: Text(
          'Actualiza propiedad: ${ref.read(espaciosCasaConListaFotosGetProvider).espaciosCasas.rows.isNotEmpty ? ref.read(espaciosCasaConListaFotosGetProvider).espaciosCasas.rows[0].value.espacioscasa.clavedelapropiedad : ""}',
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
      body: Form(
        key: formKeyEspacioComprado,
        autovalidateMode: AutovalidateMode.disabled,
        child: Stepper(
          controlsBuilder: (BuildContext context, ControlsDetails details) {
            // Ocultamos los controles por defecto ya que usamos botones personalizados en el contenido
            return Container(alignment: Alignment.topLeft);
          },
          steps: pasosCapturaPropiedad,
          type: (screenWidth < verticalWidth)
              ? StepperType.vertical
              : StepperType.horizontal,
          currentStep: currentStep,
          onStepTapped: (step) {
            setState(() {
              pasosActivar[currentStep] = false;
              currentStep = step;
              pasosActivar[currentStep] = true;
            });
          },
          onStepContinue: _siguientePaso,
          onStepCancel: _anteriorPaso,
        ),
      ),
    );
  }

  // --- MÉTODOS AUXILIARES DENTRO DEL STATE ---

  SizedBox capturaCampoGetConCheckBox(
    String nombreDeLaVariable,
    String expRegular,
    int numchar,
  ) {
    return SizedBox(
      width: 300,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          campoGetDeSeleccion(nombreDeLaVariable),
          const SizedBox(width: 5),
          (checklistAdicionales[nombreDeLaVariable] ?? false)
              ? renglonCapturaGet(
                  ref
                      .read(espaciosCasaConListaFotosGetProvider.notifier)
                      .getCampoEspaciosCasasGet(nombreDeLaVariable),
                  buildCampoTextoGet(
                    propiedad,
                    ref,
                    nombreDeLaVariable,
                    expRegular,
                    numchar,
                    true,
                  ),
                  Alignment.topLeft,
                  250,
                )
              : SizedBox(
                  width: 250,
                  child: Text(
                    ref
                        .read(espaciosCasaConListaFotosGetProvider.notifier)
                        .getCampoEspaciosCasasGet(nombreDeLaVariable),
                    maxLines: 2,
                    overflow: TextOverflow.visible,
                    softWrap: true,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  Checkbox campoGetDeSeleccion(String nombreDeLaVariable) {
    return Checkbox(
      value: checklistAdicionales[nombreDeLaVariable],
      onChanged: (value) {
        setState(() {
          if (value!) {
            checklistAdicionales[nombreDeLaVariable] = true;
            ref
                .read(espaciosCasaConListaFotosGetProvider.notifier)
                .setCampoEspaciosCasasGet(nombreDeLaVariable, "si");
            setCampoEspaciosCasasGet(propiedad, nombreDeLaVariable, "si");
          } else {
            checklistAdicionales[nombreDeLaVariable] = false;
            ref
                .read(espaciosCasaConListaFotosGetProvider.notifier)
                .setCampoEspaciosCasasGet(nombreDeLaVariable, "");
            setCampoEspaciosCasasGet(propiedad, nombreDeLaVariable, "");
          }
        });
      },
    );
  }

  void setchecklistAdicionalesGet(ValueEspaciosCasaGet propiedad) {
    debugPrintLevels(5, 'HTTP setchecklistAdicionalesGet');

    final map = propiedad.espacioscasa.datosadicionalescasa;

    if (map.panelessolares == "si")
      checklistAdicionales["panelessolares"] = true;
    if (map.jardin == "si") checklistAdicionales["jardin"] = true;
    if (map.alberca == "si") checklistAdicionales["alberca"] = true;
    if (map.calefaccion == "si") checklistAdicionales["calefaccion"] = true;
    if (map.aireacondicionado == "si")
      checklistAdicionales["aireacondicionado"] = true;
    if (map.seguridad == "si") checklistAdicionales["seguridad"] = true;
    if (map.enfraccionamiento == "si")
      checklistAdicionales["enfraccionamiento"] = true;
    if (map.casasenelconjunto == "si")
      checklistAdicionales["casasenelconjunto"] = true;
    if (map.casaclub == "si") checklistAdicionales["casaclub"] = true;
    if (map.salondeeventos == "si")
      checklistAdicionales["salondeeventos"] = true;
    if (map.centrodenegocios == "si")
      checklistAdicionales["centrodenegocios"] = true;
    if (map.gimnacio == "si") checklistAdicionales["gimnacio"] = true;
    if (map.cisterna == "si") checklistAdicionales["cisterna"] = true;
    if (map.almacenamientodeagua == "si")
      checklistAdicionales["almacenamientodeagua"] = true;
    if (map.tratamientodeaguas == "si")
      checklistAdicionales["tratamientodeaguas"] = true;
    if (map.otrascaracteristicas == "si")
      checklistAdicionales["otrascaracteristicas"] = true;
  }
}

// -----------------------------------------------------------------------------
// FUNCIONES AUXILIARES GLOBALES
// -----------------------------------------------------------------------------

SizedBox renglonCapturaGet(
  String etiqueta,
  Widget function,
  AlignmentGeometry alineacion,
  double ancho,
) {
  return SizedBox(
    width: ancho,
    child: FormaEtiquetaFolioGet(etiqueta, function, alineacion),
  );
}

Widget FormaEtiquetaFolioGet(
  String etiqueta,
  Widget function,
  AlignmentGeometry alineacion,
) {
  return Container(
    width: (screenWidth < smallScreenMin) ? screenWidth : screenWidth * 0.7,
    alignment: alineacion,
    child: function,
  );
}

Widget buildCampoTextoGet(
  ValueEspaciosCasaGet propiedad,
  WidgetRef ref,
  String nombreVariable,
  String expRegular,
  int numchar,
  bool enable,
) {
  return SizedBox(
    child: (!enable)
        ? Text(
            getCampoEspaciosCasasGet(propiedad, nombreVariable),
            maxLines: 8,
            style: TextStyle(
              color: appTheme.primary,
              fontSize: tamanoLetra,
              fontWeight: FontWeight.normal,
              decoration: TextDecoration.overline,
            ),
          )
        : TextFormField(
            initialValue: getCampoEspaciosCasasGet(propiedad, nombreVariable),
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
                  "${ref.read(espaciosCasaConListaFotosGetProvider.notifier).getNombreDelCampoPropiedadCasaGet(nombreVariable)} ",
              floatingLabelBehavior: FloatingLabelBehavior.always,
              isDense: true,
              contentPadding: const EdgeInsets.fromLTRB(10, 15, 10, 15),
            ),
            onChanged: (String? value) {
              setCampoEspaciosCasasGet(propiedad, nombreVariable, value!);
            },
          ),
  );
}

//----------------------------------

void setCampoEspaciosCasasGet(
  ValueEspaciosCasaGet propiedad,
  String campo,
  String valor,
) {
  debugPrintLevels(
    2,
    'HTTP setCampoEspaciosCasasGet: campo = $campo, valor: $valor',
  );

  switch (campo) {
    case "id":
      propiedad.id = valor;
      break;
    case "rev":
      propiedad.rev = valor;
      break;

    case "versiondelformato":
      propiedad.espacioscasa.versiondelformato = valor;
      break;
    case "idPropiedad":
      propiedad.espacioscasa.idPropiedad = valor;
      break;
    case "clavedelapropiedad":
      propiedad.espacioscasa.clavedelapropiedad = valor;
      break;
    case "idusuario":
      propiedad.espacioscasa.idusuario = valor;
      break;

    case "tipodeanuncio":
      propiedad.espacioscasa.tipodeanuncio = valor;
      break;
    case "tipodetransaccion":
      propiedad.espacioscasa.tipodetransaccion = valor;
      break;
    case "idTransaccion":
      propiedad.espacioscasa.idTransaccion = valor;
      break;

    case "nombredelapropiedad":
      propiedad.espacioscasa.nombredelapropiedad = valor;
      break;
    case "inmobiliaria":
      propiedad.espacioscasa.inmobiliaria = valor;
      break;
    case "inmobiliariaimagen":
      propiedad.espacioscasa.inmobiliariaimagen = valor;
      break;
    case "linkinmobiliaria":
      propiedad.espacioscasa.inmobiliariaimagen = valor;
      break;
    case "sloganinmobiliaria":
      propiedad.espacioscasa.inmobiliariaimagen = valor;
      break;

    case "ubicaciongeneral":
      propiedad.espacioscasa.ubicaciongeneral = valor;
      break;

    case "tipodepropiedad":
      propiedad.espacioscasa.tipodepropiedad = valor;
      break;

    case "descripcion":
      propiedad.espacioscasa.descripcion = valor;
      break;
    case "letreropromocional":
      propiedad.espacioscasa.letreropromocional = valor;
      break;
    case "metrosdeterreno":
      propiedad.espacioscasa.metrosdeterreno = valor;
      break;
    case "metrosconstruidos":
      propiedad.espacioscasa.metrosconstruidos = valor;
      break;
    case "recamaras":
      propiedad.espacioscasa.recamaras = valor;
      break;
    case "banos":
      propiedad.espacioscasa.banos = valor;
      break;
    case "mediosbanos":
      propiedad.espacioscasa.mediosbanos = valor;
      break;
    case "cuartosdeservicio":
      propiedad.espacioscasa.cuartosdeservicio = valor;
      break;
    case "estacionamientos":
      propiedad.espacioscasa.estacionamientos = valor;
      break;
    case "estacionamientoscubiertos":
      propiedad.espacioscasa.estacionamientoscubiertos = valor;
      break;

    case "panelessolares":
      propiedad.espacioscasa.datosadicionalescasa.panelessolares = valor;
      break;
    case "jardin":
      propiedad.espacioscasa.datosadicionalescasa.jardin = valor;
      break;
    case "alberca":
      propiedad.espacioscasa.datosadicionalescasa.alberca = valor;
      break;
    case "calefaccion":
      propiedad.espacioscasa.datosadicionalescasa.calefaccion = valor;
      break;
    case "aireacondicionado":
      propiedad.espacioscasa.datosadicionalescasa.aireacondicionado = valor;
      break;
    case "seguridad":
      propiedad.espacioscasa.datosadicionalescasa.seguridad = valor;
      break;
    case "enfraccionamiento":
      propiedad.espacioscasa.datosadicionalescasa.enfraccionamiento = valor;
      break;
    case "casasenelconjunto":
      propiedad.espacioscasa.datosadicionalescasa.casasenelconjunto = valor;
      break;
    case "casaclub":
      propiedad.espacioscasa.datosadicionalescasa.casaclub = valor;
      break;
    case "salondeeventos":
      propiedad.espacioscasa.datosadicionalescasa.salondeeventos = valor;
      break;
    case "centrodenegocios":
      propiedad.espacioscasa.datosadicionalescasa.centrodenegocios = valor;
      break;
    case "gimnacio":
      propiedad.espacioscasa.datosadicionalescasa.gimnacio = valor;
      break;
    case "cisterna":
      propiedad.espacioscasa.datosadicionalescasa.cisterna = valor;
      break;
    case "almacenamientodeagua":
      propiedad.espacioscasa.datosadicionalescasa.almacenamientodeagua = valor;
      break;
    case "tratamientodeaguas":
      propiedad.espacioscasa.datosadicionalescasa.tratamientodeaguas = valor;
      break;
    case "otrascaracteristicas":
      propiedad.espacioscasa.datosadicionalescasa.otrascaracteristicas = valor;

    case "elementosadicionalescasa":
      propiedad.espacioscasa.elementosadicionalescasa = valor;
      break;

    case "precioventa":
      propiedad.espacioscasa.precioventa = valor;
      break;
    case "preciorenta":
      propiedad.espacioscasa.preciorenta = valor;
      break;
    case "mantenimiento":
      propiedad.espacioscasa.mantenimiento = valor;
      break;
    case "moneda":
      propiedad.espacioscasa.moneda = valor;
      break;

    case "niveldeprioridad":
      propiedad.espacioscasa.niveldeprioridad = valor;
      break;
    case "condicionesdeventa":
      propiedad.espacioscasa.condicionesdeventa = valor;
      break;
    case "fotoprincipal":
      propiedad.espacioscasa.fotoprincipal = valor;
      break;
    case "numerodefotos":
      propiedad.espacioscasa.numerodefotos = valor;
      break;
    case "linkvideo":
      propiedad.espacioscasa.linkvideo = valor;
      break;

    case "nombre":
      propiedad.espacioscasa.datosdelcontactocasa.nombre = valor;
      break;
    case "empresa":
      propiedad.espacioscasa.datosdelcontactocasa.empresa = valor;
      break;
    case "imgendeempresa":
      propiedad.espacioscasa.datosdelcontactocasa.imgendeempresa = valor;
      break;
    case "numerocelular":
      propiedad.espacioscasa.datosdelcontactocasa.numerocelular = valor;
      break;
    case "numerootro":
      propiedad.espacioscasa.datosdelcontactocasa.numerootro = valor;
      break;
    case "numeroinmobiliaria":
      propiedad.espacioscasa.datosdelcontactocasa.numeroinmobiliaria = valor;
      break;
    case "correoelectronico":
      propiedad.espacioscasa.datosdelcontactocasa.correoelectronico = valor;
      break;
    case "idusuariocontacto":
      propiedad.espacioscasa.datosdelcontactocasa.idusuariocontacto = valor;
      break;
    case "nombreusuariocontacto":
      propiedad.espacioscasa.datosdelcontactocasa.nombreusuariocontacto = valor;
      break;
    case "imgendelcontacto":
      propiedad.espacioscasa.datosdelcontactocasa.imgendelcontacto = valor;
      break;

    case "pais":
      propiedad.espacioscasa.ubicacioncasa.pais = valor;
      break;

    case "idEstado":
      propiedad.espacioscasa.ubicacioncasa.localidadCp.idEstado = int.parse(
        valor,
      );
      break;
    case "estado":
      propiedad.espacioscasa.ubicacioncasa.localidadCp.estado = valor;
      break;
    case "idMunicipio":
      propiedad.espacioscasa.ubicacioncasa.localidadCp.idMunicipio = int.parse(
        valor,
      );
      break;
    case "municipio":
      propiedad.espacioscasa.ubicacioncasa.localidadCp.municipio = valor;
      break;
    case "ciudad":
      propiedad.espacioscasa.ubicacioncasa.localidadCp.ciudad = valor;
      break;
    case "zona":
      propiedad.espacioscasa.ubicacioncasa.localidadCp.zona = valor;
      break;
    case "asentamiento":
      propiedad.espacioscasa.ubicacioncasa.localidadCp.asentamiento = valor;
      break;
    case "codigopostal":
      propiedad.espacioscasa.ubicacioncasa.localidadCp.cp = int.parse(valor);
      break;
    case "tipo":
      propiedad.espacioscasa.ubicacioncasa.localidadCp.tipo = valor;
      break;

    case "calle":
      propiedad.espacioscasa.ubicacioncasa.calle = valor;
      break;
    case "numeroexterior":
      propiedad.espacioscasa.ubicacioncasa.numeroexterior = valor;
      break;
    case "numerointerior":
      propiedad.espacioscasa.ubicacioncasa.numerointerior = valor;
      break;

    case "latitud":
      propiedad.espacioscasa.ubicacioncasa.latitud = valor;
      break;
    case "longitud":
      propiedad.espacioscasa.ubicacioncasa.longitud = valor;
      break;
    case "latitudDecimal":
      propiedad.espacioscasa.ubicacioncasa.latitudDecimal = valor;
      break;
    case "longitudDecimal":
      propiedad.espacioscasa.ubicacioncasa.longitudDecimal = valor;
      break;

    case "diapublicacion":
      propiedad.espacioscasa.fechadepublicacioncasa.dia = int.parse(valor);
      break;
    case "mespublicacion":
      propiedad.espacioscasa.fechadepublicacioncasa.mes = int.parse(valor);
      break;
    case "aniopublicacion":
      propiedad.espacioscasa.fechadepublicacioncasa.anio = int.parse(valor);
      break;

    case "diadecierre":
      propiedad.espacioscasa.fechadecierrecasa.dia = int.parse(valor);
      break;
    case "mesdecierre":
      propiedad.espacioscasa.fechadecierrecasa.mes = int.parse(valor);
      break;
    case "aniodecierre":
      propiedad.espacioscasa.fechadecierrecasa.anio = int.parse(valor);
      break;

    case "activa":
      propiedad.espacioscasa.activa = int.parse(valor);
      break;
    case "timestampcasa":
      propiedad.espacioscasa.timestampcasa = valor;
      break;
  }
}

String getCampoEspaciosCasasGet(ValueEspaciosCasaGet propiedad, String campo) {
  // debugPrintLevels(5, 'HTTP getCampoEspaciosCasasGet');

  String variableRegreso = "";
  final varEspaciosCasasGetProvider = propiedad;

  switch (campo) {
    case "id":
      return variableRegreso = varEspaciosCasasGetProvider.id;
    case "rev":
      return variableRegreso = varEspaciosCasasGetProvider.rev;

    case "versiondelformato":
      return variableRegreso =
          varEspaciosCasasGetProvider.espacioscasa.versiondelformato;
    case "idPropiedad":
      return variableRegreso =
          varEspaciosCasasGetProvider.espacioscasa.idPropiedad;
    case "clavedelapropiedad":
      return variableRegreso =
          varEspaciosCasasGetProvider.espacioscasa.clavedelapropiedad;
    case "idusuario":
      return variableRegreso =
          varEspaciosCasasGetProvider.espacioscasa.idusuario;

    case "tipodeanuncio":
      return variableRegreso =
          varEspaciosCasasGetProvider.espacioscasa.tipodeanuncio;
    case "tipodetransaccion":
      return variableRegreso =
          varEspaciosCasasGetProvider.espacioscasa.tipodetransaccion;
    case "idTransaccion":
      return variableRegreso =
          varEspaciosCasasGetProvider.espacioscasa.idTransaccion;

    case "nombredelapropiedad":
      return variableRegreso =
          varEspaciosCasasGetProvider.espacioscasa.nombredelapropiedad;
    case "inmobiliaria":
      return variableRegreso =
          varEspaciosCasasGetProvider.espacioscasa.inmobiliaria;
    case "inmobiliariaimagen":
      return variableRegreso =
          varEspaciosCasasGetProvider.espacioscasa.inmobiliariaimagen;
    case "linkinmobiliaria":
      return variableRegreso =
          varEspaciosCasasGetProvider.espacioscasa.linkinmobiliaria;
    case "sloganinmobiliaria":
      return variableRegreso =
          varEspaciosCasasGetProvider.espacioscasa.sloganinmobiliaria;

    case "ubicaciongeneral":
      return variableRegreso =
          varEspaciosCasasGetProvider.espacioscasa.ubicaciongeneral;

    case "tipodepropiedad":
      return variableRegreso =
          varEspaciosCasasGetProvider.espacioscasa.tipodepropiedad;
    case "descripcion":
      return variableRegreso =
          varEspaciosCasasGetProvider.espacioscasa.descripcion;
    case "letreropromocional":
      return variableRegreso =
          varEspaciosCasasGetProvider.espacioscasa.letreropromocional;
    case "metrosdeterreno":
      return variableRegreso =
          varEspaciosCasasGetProvider.espacioscasa.metrosdeterreno;
    case "metrosconstruidos":
      return variableRegreso =
          varEspaciosCasasGetProvider.espacioscasa.metrosconstruidos;
    case "recamaras":
      return variableRegreso =
          varEspaciosCasasGetProvider.espacioscasa.recamaras;
    case "banos":
      return variableRegreso = varEspaciosCasasGetProvider.espacioscasa.banos;
    case "mediosbanos":
      return variableRegreso =
          varEspaciosCasasGetProvider.espacioscasa.mediosbanos;
    case "cuartosdeservicio":
      return variableRegreso =
          varEspaciosCasasGetProvider.espacioscasa.cuartosdeservicio;
    case "estacionamientos":
      return variableRegreso =
          varEspaciosCasasGetProvider.espacioscasa.estacionamientos;
    case "estacionamientoscubiertos":
      return variableRegreso =
          varEspaciosCasasGetProvider.espacioscasa.estacionamientoscubiertos;

    case "panelessolares":
      variableRegreso = varEspaciosCasasGetProvider
          .espacioscasa
          .datosadicionalescasa
          .panelessolares;
    case "jardin":
      return variableRegreso =
          varEspaciosCasasGetProvider.espacioscasa.datosadicionalescasa.jardin;
    case "alberca":
      return variableRegreso =
          varEspaciosCasasGetProvider.espacioscasa.datosadicionalescasa.alberca;
    case "calefaccion":
      return variableRegreso = varEspaciosCasasGetProvider
          .espacioscasa
          .datosadicionalescasa
          .calefaccion;
    case "aireacondicionado":
      variableRegreso = varEspaciosCasasGetProvider
          .espacioscasa
          .datosadicionalescasa
          .aireacondicionado;
    case "seguridad":
      return variableRegreso = varEspaciosCasasGetProvider
          .espacioscasa
          .datosadicionalescasa
          .seguridad;
    case "enfraccionamiento":
      variableRegreso = varEspaciosCasasGetProvider
          .espacioscasa
          .datosadicionalescasa
          .enfraccionamiento;
    case "casasenelconjunto":
      variableRegreso = varEspaciosCasasGetProvider
          .espacioscasa
          .datosadicionalescasa
          .casasenelconjunto;
    case "casaclub":
      return variableRegreso = varEspaciosCasasGetProvider
          .espacioscasa
          .datosadicionalescasa
          .casaclub;
    case "salondeeventos":
      variableRegreso = varEspaciosCasasGetProvider
          .espacioscasa
          .datosadicionalescasa
          .salondeeventos;
    case "centrodenegocios":
      variableRegreso = varEspaciosCasasGetProvider
          .espacioscasa
          .datosadicionalescasa
          .centrodenegocios;
    case "gimnacio":
      return variableRegreso = varEspaciosCasasGetProvider
          .espacioscasa
          .datosadicionalescasa
          .gimnacio;
    case "cisterna":
      return variableRegreso = varEspaciosCasasGetProvider
          .espacioscasa
          .datosadicionalescasa
          .cisterna;
    case "almacenamientodeagua":
      variableRegreso = varEspaciosCasasGetProvider
          .espacioscasa
          .datosadicionalescasa
          .almacenamientodeagua;
    case "tratamientodeaguas":
      variableRegreso = varEspaciosCasasGetProvider
          .espacioscasa
          .datosadicionalescasa
          .tratamientodeaguas;
    case "otrascaracteristicas":
      variableRegreso = varEspaciosCasasGetProvider
          .espacioscasa
          .datosadicionalescasa
          .otrascaracteristicas;

    case "elementosadicionalescasa":
      return variableRegreso =
          varEspaciosCasasGetProvider.espacioscasa.elementosadicionalescasa;

    case "precioventa":
      return variableRegreso =
          varEspaciosCasasGetProvider.espacioscasa.precioventa;
    case "preciorenta":
      return variableRegreso =
          varEspaciosCasasGetProvider.espacioscasa.preciorenta;
    case "mantenimiento":
      return variableRegreso =
          varEspaciosCasasGetProvider.espacioscasa.mantenimiento;
    case "moneda":
      return variableRegreso = varEspaciosCasasGetProvider.espacioscasa.moneda;
    case "niveldeprioridad":
      return variableRegreso =
          varEspaciosCasasGetProvider.espacioscasa.niveldeprioridad;
    case "condicionesdeventa":
      return variableRegreso =
          varEspaciosCasasGetProvider.espacioscasa.condicionesdeventa;
    case "fotoprincipal":
      return variableRegreso =
          varEspaciosCasasGetProvider.espacioscasa.fotoprincipal;
    case "numerodefotos":
      return variableRegreso =
          varEspaciosCasasGetProvider.espacioscasa.numerodefotos;
    case "linkvideo":
      return variableRegreso =
          varEspaciosCasasGetProvider.espacioscasa.linkvideo;

    case "nombre":
      return variableRegreso =
          varEspaciosCasasGetProvider.espacioscasa.datosdelcontactocasa.nombre;
    case "empresa":
      return variableRegreso =
          varEspaciosCasasGetProvider.espacioscasa.datosdelcontactocasa.empresa;
    case "imgendeempresa":
      return variableRegreso = varEspaciosCasasGetProvider
          .espacioscasa
          .datosdelcontactocasa
          .imgendeempresa;
    case "numerocelular":
      return variableRegreso = varEspaciosCasasGetProvider
          .espacioscasa
          .datosdelcontactocasa
          .numerocelular;
    case "numerootro":
      return variableRegreso = varEspaciosCasasGetProvider
          .espacioscasa
          .datosdelcontactocasa
          .numerootro;
    case "numeroinmobiliaria":
      return variableRegreso = varEspaciosCasasGetProvider
          .espacioscasa
          .datosdelcontactocasa
          .numeroinmobiliaria;
    case "correoelectronico":
      return variableRegreso = varEspaciosCasasGetProvider
          .espacioscasa
          .datosdelcontactocasa
          .correoelectronico;
    case "idusuariocontacto":
      return variableRegreso = varEspaciosCasasGetProvider
          .espacioscasa
          .datosdelcontactocasa
          .idusuariocontacto;
    case "nombreusuariocontacto":
      return variableRegreso = varEspaciosCasasGetProvider
          .espacioscasa
          .datosdelcontactocasa
          .nombreusuariocontacto;
    case "imgendelcontacto":
      return variableRegreso = varEspaciosCasasGetProvider
          .espacioscasa
          .datosdelcontactocasa
          .imgendelcontacto;

    case "pais":
      return variableRegreso =
          varEspaciosCasasGetProvider.espacioscasa.ubicacioncasa.pais;

    case "idEstado":
      return variableRegreso = varEspaciosCasasGetProvider
          .espacioscasa
          .ubicacioncasa
          .localidadCp
          .idEstado
          .toString();
    case "estado":
      return variableRegreso = varEspaciosCasasGetProvider
          .espacioscasa
          .ubicacioncasa
          .localidadCp
          .estado;
    case "idMunicipio":
      return variableRegreso = varEspaciosCasasGetProvider
          .espacioscasa
          .ubicacioncasa
          .localidadCp
          .idMunicipio
          .toString();
    case "municipio":
      return variableRegreso = varEspaciosCasasGetProvider
          .espacioscasa
          .ubicacioncasa
          .localidadCp
          .municipio;
    case "ciudad":
      return variableRegreso = varEspaciosCasasGetProvider
          .espacioscasa
          .ubicacioncasa
          .localidadCp
          .ciudad;
    case "zona":
      return variableRegreso = varEspaciosCasasGetProvider
          .espacioscasa
          .ubicacioncasa
          .localidadCp
          .zona;
    case "asentamiento":
      return variableRegreso = varEspaciosCasasGetProvider
          .espacioscasa
          .ubicacioncasa
          .localidadCp
          .asentamiento;
    case "codigopostal":
      return variableRegreso = varEspaciosCasasGetProvider
          .espacioscasa
          .ubicacioncasa
          .localidadCp
          .cp
          .toString();
    case "tipo":
      return variableRegreso = varEspaciosCasasGetProvider
          .espacioscasa
          .ubicacioncasa
          .localidadCp
          .tipo;

    case "calle":
      return variableRegreso =
          varEspaciosCasasGetProvider.espacioscasa.ubicacioncasa.calle;
    case "numeroexterior":
      return variableRegreso =
          varEspaciosCasasGetProvider.espacioscasa.ubicacioncasa.numeroexterior;
    case "numerointerior":
      return variableRegreso =
          varEspaciosCasasGetProvider.espacioscasa.ubicacioncasa.numerointerior;
    case "entrecalle01":
      return variableRegreso =
          varEspaciosCasasGetProvider.espacioscasa.ubicacioncasa.entrecalle01;
    case "entrecalle02":
      return variableRegreso =
          varEspaciosCasasGetProvider.espacioscasa.ubicacioncasa.entrecalle02;

    case "latitud":
      return variableRegreso =
          varEspaciosCasasGetProvider.espacioscasa.ubicacioncasa.latitud;
    case "longitud":
      return variableRegreso =
          varEspaciosCasasGetProvider.espacioscasa.ubicacioncasa.longitud;
    case "latitudDecimal":
      return variableRegreso =
          varEspaciosCasasGetProvider.espacioscasa.ubicacioncasa.latitudDecimal;
    case "longitudDecimal":
      return variableRegreso = varEspaciosCasasGetProvider
          .espacioscasa
          .ubicacioncasa
          .longitudDecimal;

    case "diapublicacion":
      return variableRegreso = varEspaciosCasasGetProvider
          .espacioscasa
          .fechadepublicacioncasa
          .dia
          .toStringAsFixed(0);
    case "mespublicacion":
      return variableRegreso = varEspaciosCasasGetProvider
          .espacioscasa
          .fechadepublicacioncasa
          .mes
          .toStringAsFixed(0);
    case "aniopublicacion":
      return variableRegreso = varEspaciosCasasGetProvider
          .espacioscasa
          .fechadepublicacioncasa
          .anio
          .toStringAsFixed(0);

    case "diadecierre":
      return variableRegreso = varEspaciosCasasGetProvider
          .espacioscasa
          .fechadecierrecasa
          .dia
          .toStringAsFixed(0);
    case "mesdecierre":
      return variableRegreso = varEspaciosCasasGetProvider
          .espacioscasa
          .fechadecierrecasa
          .mes
          .toStringAsFixed(0);
    case "aniodecierre":
      return variableRegreso = varEspaciosCasasGetProvider
          .espacioscasa
          .fechadecierrecasa
          .anio
          .toStringAsFixed(0);

    case "activa":
      return variableRegreso = varEspaciosCasasGetProvider.espacioscasa.activa
          .toStringAsFixed(0);
    case "timestampcasa":
      return variableRegreso =
          varEspaciosCasasGetProvider.espacioscasa.timestampcasa;
  }
  return variableRegreso;
}
*/
//------------------------------------------------------------------------------
/*
class PaginaEditaEspacio extends ConsumerStatefulWidget {
  final ValueEspaciosCasaGet propiedadParameter;
  const PaginaEditaEspacio(this.propiedadParameter, {super.key});

  @override
  ConsumerState createState() {
    debugPrintLevels(1, " **************************************************");
    debugPrintLevels(1, "  1. PaginaEditaEspacio createState");
    debugPrintLevels(1, " **************************************************");
    return PaginaEditaEspacioState();
  }
}

class PaginaEditaEspacioState extends ConsumerState<PaginaEditaEspacio>
    with TickerProviderStateMixin {
  // VARIABLES DE ESTADO (Movidas dentro de la clase para evitar conflictos globales)
  late TextEditingController celdaControllerPublicacion;
  int currentStep = 0;
  List<bool> pasosActivar = List<bool>.filled(5, false);

  double alto = 25;
  double ancho = 100;
  double verticalWidth = 275.00;

  // Propiedad local mutable para el formulario
  late ValueEspaciosCasaGet propiedad;

  final formKeyEspacioComprado = GlobalKey<FormState>();
  String tipoDePropiedad = otrosTiposDeInmueble[0];
  String tipoDeTransaccion = "Venta";

  @override
  void initState() {
    debugPrintLevels(1, " **************************************************");
    debugPrintLevels(1, " 02. PaginaEditaEspacio initState");
    debugPrintLevels(1, " **************************************************");

    super
        .initState(); // Super debe ir al inicio generalmente o antes de usar context

    celdaControllerPublicacion = TextEditingController();
    propiedad = widget.propiedadParameter;

    // Inicializar checkbox según la data
    setchecklistAdicionalesGet(propiedad);

    // Configuración inicial de los pasos del Stepper
    pasosActivar[0] = true; // El paso 0 inicia activo
    // El resto ya están en false por el List.filled

    // Inicializar dropdowns con valores seguros
    if (propiedad.espacioscasa.tipodepropiedad == "") {
      tipoDePropiedad = otrosTiposDeInmueble[0];
    } else {
      // Validar que el valor exista en la lista para evitar error de Dropdown
      if (listaTipoInmuebles.contains(propiedad.espacioscasa.tipodepropiedad)) {
        tipoDePropiedad = propiedad.espacioscasa.tipodepropiedad;
      } else {
        tipoDePropiedad = otrosTiposDeInmueble[0];
      }
    }

    // Inicializar transacción
    if (propiedad.espacioscasa.tipodetransaccion != "" &&
        listaTiposDeTransaccion.contains(
          propiedad.espacioscasa.tipodetransaccion,
        )) {
      tipoDeTransaccion = propiedad.espacioscasa.tipodetransaccion;
    }
  }

  @override
  void didChangeDependencies() {
    debugPrintLevels(1, " PaginaEditaEspacio didChangeDependencies");
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    debugPrintLevels(1, " PaginaEditaEspacio dispose");
    celdaControllerPublicacion.dispose(); // Importante liberar memoria
    super.dispose();
  }

  update() {
    setState(() {
      debugPrintLevels(1, " 03. PaginaEditaEspacio setState update");
    });
  }

  @override
  Widget build(BuildContext context) {
    // Calculamos dimensiones directamente en build (sin setState)
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    // Ajuste responsivo local
    // double contentWidth = (screenWidth > verticalWidth) ? screenWidth * 0.8 : screenWidth;

    debugPrintLevels(1, " **************************************************");
    debugPrintLevels(1, " 02. PaginaEditaEspacio build");
    debugPrintLevels(1, " **************************************************");

    // NOTA: Se eliminó el setState que estaba aquí porque causaba bucles infinitos.
    // La actualización de UI debe ser reactiva.

    ElevatedButton botonGuardar(BuildContext context) {
      return ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: appTheme.primary,
          minimumSize: const Size(150, 40),
        ),
        onPressed: () async {
          if (formKeyEspacioComprado.currentState!.validate()) {
            formKeyEspacioComprado.currentState!.save();

            // 1. Obtener índice actual (si es necesario para la lógica de negocio)
            int indexAnterior = ref
                .read(espaciosCasaConListaFotosGetProvider.notifier)
                .getIndexEspaciosCasas();

            // 2. Buscar índice basado en ID (por seguridad)
            int index = ref
                .read(espaciosCasaConListaFotosGetProvider)
                .espaciosCasas
                .rows
                .indexWhere(
                  (propiedadEnLista) =>
                      propiedadEnLista.value.espacioscasa.idPropiedad ==
                      propiedad.espacioscasa.idPropiedad,
                );

            // Si no encuentra el index (-1), usar el anterior o manejar error
            if (index != -1) {
              ref
                  .read(espaciosCasaConListaFotosGetProvider.notifier)
                  .setIndexEspaciosCasas(index);
            }

            // 3. ACTUALIZAR EL ESTADO EN RIVERPOD (Función nueva solicitada)
            ref
                .read(espaciosCasaConListaFotosGetProvider.notifier)
                .setEspaciosCasasGet(ref, propiedad);

            debugPrintLevels(5, "05. PaginaEditaEspacio Guarda cambios ");

            // 4. Guardar en Base de Datos
            await ref
                .read(espaciosCasaConListaFotosGetProvider.notifier)
                .updatePropiedadCasaGetToCouchDB()
                .then((resultado) async {
                  // Restaurar índice si es necesario
                  ref
                      .read(espaciosCasaConListaFotosGetProvider.notifier)
                      .setIndexEspaciosCasas(indexAnterior);

                  debugPrintLevels(
                    5,
                    "06. PaginaEditaEspacio Resultado de Update espacio: $resultado",
                  );

                  await showMessageDialog(
                    context,
                    "Actualiza propiedad",
                    "Se actualizó correctamente",
                    appTheme.primary,
                    TextAlign.center,
                  );
                });
          }
        },
        child: Text(
          'Guardar',
          style: TextStyle(fontSize: 14, color: appTheme.onPrimary),
        ),
      );
    }

    ElevatedButton botonSalir(BuildContext context) {
      return ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: appTheme.onSurface,
          minimumSize: const Size(150, 40),
        ),
        onPressed: () async {
          Navigator.pushNamed(context, AppRoutes.principal, arguments: "");
        },
        child: const Text(
          'Regresar', // Corregido typo "Regesar"
          style: TextStyle(fontSize: 14, color: Colors.white),
        ),
      );
    }

    // --- DEFINICIÓN DE PASOS DEL STEPPER ---
    // Nota: Se mueven aquí dentro del build para acceder al contexto y variables actualizadas
    List<Step> pasosCapturaPropiedad = [
      // -----------------------------------------------------------------------
      // PASO 1: PROPIEDAD
      // -----------------------------------------------------------------------
      Step(
        title: Text((screenWidth > verticalWidth) ? "" : "Propiedad"),
        label: Text(
          (screenWidth > verticalWidth) ? "Propiedad" : "",
          style: TextStyle(
            color: appTheme.primary,
            fontWeight: (pasosActivar[0]) ? FontWeight.bold : FontWeight.normal,
            fontSize: 10,
          ),
        ),
        content: Column(
          children: [
            Center(
              child: Text(
                "Datos de la propiedad",
                style: TextStyle(
                  color: appTheme.primary,
                  fontSize: fontSizeTituloPagina,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Comfortaa",
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
                // Dropdown Tipo Propiedad
                Container(
                  width: 300,
                  height: 40,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.fromLTRB(8, 0, 5, 3),
                  decoration: BoxDecoration(
                    color: appTheme.surface,
                    borderRadius: BorderRadius.circular(9),
                    border: Border.all(color: appTheme.primary, width: 2),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: tipoDePropiedad,
                      icon: Icon(
                        Symbols.arrow_drop_down,
                        size: menuTabIconSize * 2,
                        color: appTheme.primary,
                      ),
                      selectedItemBuilder: (BuildContext context) {
                        return listaTipoInmuebles.map<Widget>((String item) {
                          return Container(
                            alignment: AlignmentGeometry.bottomLeft,
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 2),
                            child: Text(
                              item,
                              style: TextStyle(
                                color: appTheme.primary,
                                fontWeight: FontWeight.bold,
                                fontSize: menuTabLabelSize,
                              ),
                            ),
                          );
                        }).toList();
                      },
                      items: listaTipoInmuebles.map<DropdownMenuItem<String>>((
                        String value,
                      ) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: SizedBox(
                            height: 25.0,
                            child: Text(
                              value,
                              style: TextStyle(
                                fontSize: menuTabLabelSize,
                                fontWeight: FontWeight.bold,
                                color: appTheme.primary,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          setState(() {
                            tipoDePropiedad = newValue;
                            setCampoEspaciosCasasGet(
                              propiedad,
                              "tipodepropiedad",
                              tipoDePropiedad,
                            );
                          });
                        }
                      },
                      isExpanded: false,
                    ),
                  ),
                ),

                // Dropdown Tipo Transacción
                Container(
                  width: 300,
                  height: 40,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.fromLTRB(8, 0, 5, 3),
                  decoration: BoxDecoration(
                    color: appTheme.surface,
                    borderRadius: BorderRadius.circular(9),
                    border: Border.all(color: appTheme.primary, width: 2),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: tipoDeTransaccion,
                      icon: Icon(
                        Symbols.arrow_drop_down,
                        size: menuTabIconSize * 2,
                        color: appTheme.primary,
                      ),
                      selectedItemBuilder: (BuildContext context) {
                        return listaTiposDeTransaccion.map<Widget>((
                          String item,
                        ) {
                          return Container(
                            alignment: AlignmentGeometry.bottomLeft,
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 2),
                            child: Text(
                              item,
                              style: TextStyle(
                                color: appTheme.primary,
                                fontWeight: FontWeight.bold,
                                fontSize: menuTabLabelSize,
                              ),
                            ),
                          );
                        }).toList();
                      },
                      items: listaTiposDeTransaccion
                          .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: SizedBox(
                                height: 25.0,
                                child: Text(
                                  value,
                                  style: TextStyle(
                                    fontSize: menuTabLabelSize,
                                    fontWeight: FontWeight.bold,
                                    color: appTheme.primary,
                                  ),
                                ),
                              ),
                            );
                          })
                          .toList(),
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          setState(() {
                            tipoDeTransaccion = newValue;
                            setCampoEspaciosCasasGet(
                              propiedad,
                              "tipodetransaccion", // Corregido key case
                              tipoDeTransaccion,
                            );
                          });
                        }
                      },
                      isExpanded: false,
                    ),
                  ),
                ),

                // Campos dinámicos
                renglonCapturaGet(
                  "clavedelapropiedad",
                  buildCampoTextoGet(
                    propiedad,
                    ref,
                    "clavedelapropiedad",
                    "",
                    20,
                    true,
                  ),
                  Alignment.topLeft,
                  300,
                ),
                renglonCapturaGet(
                  "tipodeanuncio",
                  buildCampoTextoGet(
                    propiedad,
                    ref,
                    "tipodeanuncio",
                    "",
                    50,
                    false,
                  ),
                  Alignment.topLeft,
                  300,
                ),
                renglonCapturaGet(
                  "tipodetransaccion",
                  buildCampoTextoGet(
                    propiedad,
                    ref,
                    "tipodetransaccion",
                    "",
                    50,
                    true,
                  ),
                  Alignment.topLeft,
                  300,
                ),
                renglonCapturaGet(
                  "nombredelapropiedad",
                  buildCampoTextoGet(
                    propiedad,
                    ref,
                    "nombredelapropiedad",
                    "",
                    50,
                    true,
                  ),
                  Alignment.topLeft,
                  300,
                ),
                renglonCapturaGet(
                  "inmobiliaria",
                  buildCampoTextoGet(
                    propiedad,
                    ref,
                    "inmobiliaria",
                    "",
                    80,
                    true,
                  ),
                  Alignment.topLeft,
                  300,
                ),
                renglonCapturaGet(
                  "inmobiliariaimagen",
                  buildCampoTextoGet(
                    propiedad,
                    ref,
                    "inmobiliariaimagen",
                    "",
                    80,
                    true,
                  ),
                  Alignment.topLeft,
                  300,
                ),
                renglonCapturaGet(
                  "linkinmobiliaria",
                  buildCampoTextoGet(
                    propiedad,
                    ref,
                    "linkinmobiliaria",
                    "",
                    80,
                    true,
                  ),
                  Alignment.topLeft,
                  300,
                ),
                renglonCapturaGet(
                  "sloganinmobiliaria",
                  buildCampoTextoGet(
                    propiedad,
                    ref,
                    "sloganinmobiliaria",
                    "",
                    80,
                    true,
                  ),
                  Alignment.topLeft,
                  300,
                ),
                renglonCapturaGet(
                  "ubicaciongeneral",
                  buildCampoTextoGet(
                    propiedad,
                    ref,
                    "ubicaciongeneral",
                    "",
                    80,
                    true,
                  ),
                  Alignment.topLeft,
                  300,
                ),
                renglonCapturaGet(
                  "descripcion",
                  buildCampoTextoGet(
                    propiedad,
                    ref,
                    "descripcion",
                    "",
                    80,
                    true,
                  ),
                  Alignment.topLeft,
                  300,
                ),
                renglonCapturaGet(
                  "letreropromocional",
                  buildCampoTextoGet(
                    propiedad,
                    ref,
                    "letreropromocional",
                    "",
                    80,
                    true,
                  ),
                  Alignment.topLeft,
                  300,
                ),

                (!metrosdeterrenoMatriz.contains(tipoDePropiedad))
                    ? const SizedBox(height: 0)
                    : renglonCapturaGet(
                        "metrosdeterreno",
                        buildCampoTextoGet(
                          propiedad,
                          ref,
                          "metrosdeterreno",
                          "",
                          250,
                          true,
                        ),
                        Alignment.topLeft,
                        300,
                      ),
                (!metrosconstruidosMatriz.contains(tipoDePropiedad))
                    ? const SizedBox(height: 0)
                    : renglonCapturaGet(
                        "metrosconstruidos",
                        buildCampoTextoGet(
                          propiedad,
                          ref,
                          "metrosconstruidos",
                          "",
                          250,
                          true,
                        ),
                        Alignment.topLeft,
                        300,
                      ),
                (!recamarasMatriz.contains(tipoDePropiedad))
                    ? const SizedBox(height: 0)
                    : renglonCapturaGet(
                        "recamaras",
                        buildCampoTextoGet(
                          propiedad,
                          ref,
                          "recamaras",
                          "",
                          20,
                          true,
                        ),
                        Alignment.topLeft,
                        300,
                      ),
                (!banosMatriz.contains(tipoDePropiedad))
                    ? const SizedBox(height: 0)
                    : renglonCapturaGet(
                        "banos",
                        buildCampoTextoGet(
                          propiedad,
                          ref,
                          "banos",
                          "",
                          10,
                          true,
                        ),
                        Alignment.topLeft,
                        300,
                      ),
                (!mediosbanosMatriz.contains(tipoDePropiedad))
                    ? const SizedBox(height: 0)
                    : renglonCapturaGet(
                        "mediosbanos",
                        buildCampoTextoGet(
                          propiedad,
                          ref,
                          "mediosbanos",
                          "",
                          50,
                          true,
                        ),
                        Alignment.topLeft,
                        300,
                      ),
                (!cuartosdeservicioMatriz.contains(tipoDePropiedad))
                    ? const SizedBox(height: 0)
                    : renglonCapturaGet(
                        "cuartosdeservicio",
                        buildCampoTextoGet(
                          propiedad,
                          ref,
                          "cuartosdeservicio",
                          "",
                          80,
                          true,
                        ),
                        Alignment.topLeft,
                        300,
                      ),
                (!estacionamientosMatriz.contains(tipoDePropiedad))
                    ? const SizedBox(height: 0)
                    : renglonCapturaGet(
                        "estacionamientos",
                        buildCampoTextoGet(
                          propiedad,
                          ref,
                          "estacionamientos",
                          "",
                          80,
                          true,
                        ),
                        Alignment.topLeft,
                        300,
                      ),
                (!estacionamientoscubiertosMatriz.contains(tipoDePropiedad))
                    ? const SizedBox(height: 0)
                    : renglonCapturaGet(
                        "estacionamientoscubiertos",
                        buildCampoTextoGet(
                          propiedad,
                          ref,
                          "estacionamientoscubiertos",
                          "",
                          80,
                          true,
                        ),
                        Alignment.topLeft,
                        300,
                      ),
                (!elementosadicionalescasaMatriz.contains(tipoDePropiedad))
                    ? const SizedBox(height: 0)
                    : renglonCapturaGet(
                        "elementosadicionalescasa",
                        buildCampoTextoGet(
                          propiedad,
                          ref,
                          "elementosadicionalescasa",
                          "",
                          250,
                          true,
                        ),
                        Alignment.topLeft,
                        300,
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
                botonGuardar(context),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: appTheme.primary,
                    minimumSize: const Size(150, 40),
                  ),
                  onPressed: () {
                    setState(() {
                      pasosActivar[currentStep] = false;
                      currentStep++;
                      pasosActivar[currentStep] = true;
                    });
                  },
                  child: const Text(
                    'Siguiente',
                    style: TextStyle(fontSize: 14, color: Colors.white),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            botonSalir(context),
          ],
        ),
        isActive: pasosActivar[0],
      ),

      // -----------------------------------------------------------------------
      // PASO 2: PRECIO
      // -----------------------------------------------------------------------
      Step(
        title: Text((screenWidth > verticalWidth) ? "" : "Precio"),
        label: Text(
          (screenWidth > verticalWidth) ? "Precio" : "",
          style: TextStyle(
            color: appTheme.primary,
            fontWeight: (pasosActivar[1]) ? FontWeight.bold : FontWeight.normal,
            fontSize: 10,
          ),
        ),
        content: Column(
          children: [
            Center(
              child: Text(
                "Precio y costos de la propiedad",
                style: TextStyle(
                  color: appTheme.primary,
                  fontSize: fontSizeTituloPagina,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Comfortaa",
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
                ((tipoDeTransaccion == "Venta") ||
                        (tipoDeTransaccion == "Venta/Renta") ||
                        (tipoDeTransaccion == "Traspaso"))
                    ? (!precioventaMatriz.contains(tipoDePropiedad))
                          ? const SizedBox(height: 0)
                          : renglonCapturaGet(
                              "precioventa",
                              buildCampoTextoGet(
                                propiedad,
                                ref,
                                "precioventa",
                                "",
                                80,
                                true,
                              ),
                              Alignment.topLeft,
                              300,
                            )
                    : const SizedBox(height: 0),

                ((tipoDeTransaccion == "Renta") ||
                        (tipoDeTransaccion == "Venta/Renta"))
                    ? (!preciorentaMatriz.contains(tipoDePropiedad))
                          ? const SizedBox(height: 0)
                          : renglonCapturaGet(
                              "preciorenta",
                              buildCampoTextoGet(
                                propiedad,
                                ref,
                                "preciorenta",
                                "",
                                80,
                                true,
                              ),
                              Alignment.topLeft,
                              300,
                            )
                    : const SizedBox(height: 0),

                ((tipoDeTransaccion == "Renta") ||
                        (tipoDeTransaccion == "Venta/Renta"))
                    ? (!mantenimientoMatriz.contains(tipoDePropiedad))
                          ? const SizedBox(height: 0)
                          : renglonCapturaGet(
                              "mantenimiento",
                              buildCampoTextoGet(
                                propiedad,
                                ref,
                                "mantenimiento",
                                "",
                                80,
                                true,
                              ),
                              Alignment.topLeft,
                              300,
                            )
                    : const SizedBox(height: 0),

                (!monedaMatriz.contains(tipoDePropiedad))
                    ? const SizedBox(height: 0)
                    : renglonCapturaGet(
                        "moneda",
                        buildCampoTextoGet(
                          propiedad,
                          ref,
                          "moneda",
                          "",
                          30,
                          true,
                        ),
                        Alignment.topLeft,
                        300,
                      ),

                renglonCapturaGet(
                  "condicionesdeventa",
                  buildCampoTextoGet(
                    propiedad,
                    ref,
                    "condicionesdeventa",
                    "",
                    30,
                    true,
                  ),
                  Alignment.topLeft,
                  300,
                ),

                (!linkvideoMatriz.contains(tipoDePropiedad))
                    ? const SizedBox(height: 0)
                    : renglonCapturaGet(
                        "linkvideo",
                        buildCampoTextoGet(
                          propiedad,
                          ref,
                          "linkvideo",
                          "",
                          30,
                          true,
                        ),
                        Alignment.topLeft,
                        300,
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
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: appTheme.primary,
                    minimumSize: const Size(150, 40),
                  ),
                  onPressed: () {
                    setState(() {
                      pasosActivar[currentStep] = false;
                      currentStep--;
                      pasosActivar[currentStep] = true;
                    });
                  },
                  child: const Text(
                    'Anterior',
                    style: TextStyle(fontSize: 14, color: Colors.white),
                  ),
                ),
                botonGuardar(context),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: appTheme.primary,
                    minimumSize: const Size(150, 40),
                  ),
                  onPressed: () {
                    setState(() {
                      pasosActivar[currentStep] = false;
                      currentStep++;
                      pasosActivar[currentStep] = true;
                    });
                  },
                  child: const Text(
                    'Siguiente',
                    style: TextStyle(fontSize: 14, color: Colors.white),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            botonSalir(context),
          ],
        ),
        isActive: pasosActivar[1],
      ),

      // -----------------------------------------------------------------------
      // PASO 3: UBICACIÓN
      // -----------------------------------------------------------------------
      Step(
        title: Text((screenWidth > verticalWidth) ? "" : "Ubicación"),
        label: Text(
          (screenWidth > verticalWidth) ? "Ubicación" : "",
          style: TextStyle(
            color: appTheme.primary,
            fontWeight: (pasosActivar[2]) ? FontWeight.bold : FontWeight.normal,
            fontSize: 10,
          ),
        ),
        content: Column(
          children: [
            Center(
              child: Text(
                "Dirección de la propiedad",
                style: TextStyle(
                  color: appTheme.primary,
                  fontSize: fontSizeTituloPagina,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Comfortaa",
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
                  "pais",
                  buildCampoTextoGet(propiedad, ref, "pais", "", 30, false),
                  Alignment.topLeft,
                  300,
                ),
                renglonCapturaGet(
                  "estado",
                  buildCampoTextoGet(propiedad, ref, "estado", "", 30, true),
                  Alignment.topLeft,
                  300,
                ),
                renglonCapturaGet(
                  "municipio",
                  buildCampoTextoGet(propiedad, ref, "municipio", "", 30, true),
                  Alignment.topLeft,
                  300,
                ),
                renglonCapturaGet(
                  "ciudad",
                  buildCampoTextoGet(propiedad, ref, "ciudad", "", 30, true),
                  Alignment.topLeft,
                  300,
                ),
                renglonCapturaGet(
                  "zona",
                  buildCampoTextoGet(propiedad, ref, "zona", "", 30, true),
                  Alignment.topLeft,
                  300,
                ),
                renglonCapturaGet(
                  "asentamiento",
                  buildCampoTextoGet(
                    propiedad,
                    ref,
                    "asentamiento",
                    "",
                    30,
                    true,
                  ),
                  Alignment.topLeft,
                  300,
                ),
                renglonCapturaGet(
                  "codigopostal",
                  buildCampoTextoGet(
                    propiedad,
                    ref,
                    "codigopostal",
                    "",
                    30,
                    true,
                  ),
                  Alignment.topLeft,
                  300,
                ),
                renglonCapturaGet(
                  "tipo",
                  buildCampoTextoGet(propiedad, ref, "tipo", "", 30, true),
                  Alignment.topLeft,
                  300,
                ),
                renglonCapturaGet(
                  "calle",
                  buildCampoTextoGet(propiedad, ref, "calle", "", 30, true),
                  Alignment.topLeft,
                  300,
                ),
                renglonCapturaGet(
                  "numeroexterior",
                  buildCampoTextoGet(
                    propiedad,
                    ref,
                    "numeroexterior",
                    "",
                    30,
                    true,
                  ),
                  Alignment.topLeft,
                  300,
                ),
                renglonCapturaGet(
                  "numerointerior",
                  buildCampoTextoGet(
                    propiedad,
                    ref,
                    "numerointerior",
                    "",
                    30,
                    true,
                  ),
                  Alignment.topLeft,
                  300,
                ),
                renglonCapturaGet(
                  "entrecalle01",
                  buildCampoTextoGet(
                    propiedad,
                    ref,
                    "entrecalle01",
                    "",
                    30,
                    true,
                  ),
                  Alignment.topLeft,
                  300,
                ),
                renglonCapturaGet(
                  "entrecalle02",
                  buildCampoTextoGet(
                    propiedad,
                    ref,
                    "entrecalle02",
                    "",
                    30,
                    true,
                  ),
                  Alignment.topLeft,
                  300,
                ),
                renglonCapturaGet(
                  "latitud",
                  buildCampoTextoGet(propiedad, ref, "latitud", "", 30, true),
                  Alignment.topLeft,
                  300,
                ),
                renglonCapturaGet(
                  "longitud",
                  buildCampoTextoGet(propiedad, ref, "longitud", "", 30, true),
                  Alignment.topLeft,
                  300,
                ),
                renglonCapturaGet(
                  "latitudDecimal",
                  buildCampoTextoGet(
                    propiedad,
                    ref,
                    "latitudDecimal",
                    "",
                    30,
                    true,
                  ),
                  Alignment.topLeft,
                  300,
                ),
                renglonCapturaGet(
                  "longitudDecimal",
                  buildCampoTextoGet(
                    propiedad,
                    ref,
                    "longitudDecimal",
                    "",
                    30,
                    true,
                  ),
                  Alignment.topLeft,
                  300,
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
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: appTheme.primary,
                    minimumSize: const Size(150, 40),
                  ),
                  onPressed: () {
                    setState(() {
                      pasosActivar[currentStep] = false;
                      currentStep--;
                      pasosActivar[currentStep] = true;
                    });
                  },
                  child: const Text(
                    'Anterior',
                    style: TextStyle(fontSize: 14, color: Colors.white),
                  ),
                ),
                botonGuardar(context),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: appTheme.primary,
                    minimumSize: const Size(150, 40),
                  ),
                  onPressed: () {
                    setState(() {
                      pasosActivar[currentStep] = false;
                      currentStep++;
                      pasosActivar[currentStep] = true;
                    });
                  },
                  child: const Text(
                    'Siguiente',
                    style: TextStyle(fontSize: 14, color: Colors.white),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            botonSalir(context),
          ],
        ),
        isActive: pasosActivar[2],
      ),

      // -----------------------------------------------------------------------
      // PASO 4: ADICIONALES
      // -----------------------------------------------------------------------
      Step(
        title: Text((screenWidth > verticalWidth) ? "" : "Adicionales"),
        label: Text(
          (screenWidth > verticalWidth) ? "Adicionales" : "",
          style: TextStyle(
            color: appTheme.primary,
            fontWeight: (pasosActivar[3]) ? FontWeight.bold : FontWeight.normal,
            fontSize: 10,
          ),
        ),
        content: Column(
          children: [
            Center(
              child: Text(
                "Datos adicionales",
                style: TextStyle(
                  color: appTheme.primary,
                  fontSize: fontSizeTituloPagina,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Comfortaa",
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
                (!panelessolaresMatriz.contains(tipoDePropiedad))
                    ? const SizedBox(height: 0)
                    : capturaCampoGetConCheckBox("panelessolares", "", 80),
                (!jardinMatriz.contains(tipoDePropiedad))
                    ? const SizedBox(height: 0)
                    : capturaCampoGetConCheckBox("jardin", "", 80),
                (!albercaMatriz.contains(tipoDePropiedad))
                    ? const SizedBox(height: 0)
                    : capturaCampoGetConCheckBox("alberca", "", 80),
                (!calefaccionMatriz.contains(tipoDePropiedad))
                    ? const SizedBox(height: 0)
                    : capturaCampoGetConCheckBox("calefaccion", "", 80),
                (!aireacondicionadoMatriz.contains(tipoDePropiedad))
                    ? const SizedBox(height: 0)
                    : capturaCampoGetConCheckBox("aireacondicionado", "", 80),
                (!seguridadMatriz.contains(tipoDePropiedad))
                    ? const SizedBox(height: 0)
                    : capturaCampoGetConCheckBox("seguridad", "", 80),
                (!enfraccionamientoMatriz.contains(tipoDePropiedad))
                    ? const SizedBox(height: 0)
                    : capturaCampoGetConCheckBox("enfraccionamiento", "", 80),
                (!casasenelconjuntoMatriz.contains(tipoDePropiedad))
                    ? const SizedBox(height: 0)
                    : capturaCampoGetConCheckBox("casasenelconjunto", "", 80),
                (!casaclubMatriz.contains(tipoDePropiedad))
                    ? const SizedBox(height: 0)
                    : capturaCampoGetConCheckBox("casaclub", "", 80),
                (!salondeeventosMatriz.contains(tipoDePropiedad))
                    ? const SizedBox(height: 0)
                    : capturaCampoGetConCheckBox("salondeeventos", "", 80),
                (!centrodenegociosMatriz.contains(tipoDePropiedad))
                    ? const SizedBox(height: 0)
                    : capturaCampoGetConCheckBox("centrodenegocios", "", 80),
                (!gimnacioMatriz.contains(tipoDePropiedad))
                    ? const SizedBox(height: 0)
                    : capturaCampoGetConCheckBox("gimnacio", "", 80),
                (!cisternaMatriz.contains(tipoDePropiedad))
                    ? const SizedBox(height: 0)
                    : capturaCampoGetConCheckBox("cisterna", "", 80),
                (!almacenamientodeaguaMatriz.contains(tipoDePropiedad))
                    ? const SizedBox(height: 0)
                    : capturaCampoGetConCheckBox(
                        "almacenamientodeagua",
                        "",
                        80,
                      ),
                (!tratamientodeaguasMatriz.contains(tipoDePropiedad))
                    ? const SizedBox(height: 0)
                    : capturaCampoGetConCheckBox("tratamientodeaguas", "", 80),
                (!otrascaracteristicasMatriz.contains(tipoDePropiedad))
                    ? const SizedBox(height: 0)
                    : capturaCampoGetConCheckBox(
                        "otrascaracteristicas",
                        "",
                        80,
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
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: appTheme.primary,
                    minimumSize: const Size(150, 40),
                  ),
                  onPressed: () {
                    setState(() {
                      pasosActivar[currentStep] = false;
                      currentStep--;
                      pasosActivar[currentStep] = true;
                    });
                  },
                  child: const Text(
                    'Anterior',
                    style: TextStyle(fontSize: 14, color: Colors.white),
                  ),
                ),
                botonGuardar(context),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: appTheme.primary,
                    minimumSize: const Size(150, 40),
                  ),
                  onPressed: () {
                    setState(() {
                      pasosActivar[currentStep] = false;
                      currentStep++;
                      pasosActivar[currentStep] = true;
                    });
                  },
                  child: const Text(
                    'Siguiente',
                    style: TextStyle(fontSize: 14, color: Colors.white),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            botonSalir(context),
          ],
        ),
        isActive: pasosActivar[3],
      ),

      // -----------------------------------------------------------------------
      // PASO 5: CONTACTO
      // -----------------------------------------------------------------------
      Step(
        title: Text((screenWidth > verticalWidth) ? "" : "Contacto"),
        label: Text(
          (screenWidth > verticalWidth) ? "Contacto" : "",
          style: TextStyle(
            color: appTheme.primary,
            fontWeight: (pasosActivar[4]) ? FontWeight.bold : FontWeight.normal,
            fontSize: 10,
          ),
        ),
        content: Column(
          children: [
            Center(
              child: Text(
                "Datos del promotor",
                style: TextStyle(
                  color: appTheme.primary,
                  fontSize: fontSizeTituloPagina,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Comfortaa",
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
                  "nombre",
                  buildCampoTextoGet(propiedad, ref, "nombre", "", 30, true),
                  Alignment.topLeft,
                  300,
                ),
                renglonCapturaGet(
                  "empresa",
                  buildCampoTextoGet(propiedad, ref, "empresa", "", 30, true),
                  Alignment.topLeft,
                  300,
                ),
                renglonCapturaGet(
                  "imgendeempresa",
                  buildCampoTextoGet(
                    propiedad,
                    ref,
                    "imgendeempresa",
                    "",
                    30,
                    true,
                  ),
                  Alignment.topLeft,
                  300,
                ),
                renglonCapturaGet(
                  "numerocelular",
                  buildCampoTextoGet(
                    propiedad,
                    ref,
                    "numerocelular",
                    "",
                    30,
                    true,
                  ),
                  Alignment.topLeft,
                  300,
                ),
                renglonCapturaGet(
                  "numerootro",
                  buildCampoTextoGet(
                    propiedad,
                    ref,
                    "numerootro",
                    "",
                    30,
                    true,
                  ),
                  Alignment.topLeft,
                  300,
                ),
                renglonCapturaGet(
                  "numeroinmobiliaria",
                  buildCampoTextoGet(
                    propiedad,
                    ref,
                    "numeroinmobiliaria",
                    "",
                    30,
                    true,
                  ),
                  Alignment.topLeft,
                  300,
                ),
                renglonCapturaGet(
                  "correoelectronico",
                  buildCampoTextoGet(
                    propiedad,
                    ref,
                    "correoelectronico",
                    "",
                    30,
                    true,
                  ),
                  Alignment.topLeft,
                  300,
                ),
                renglonCapturaGet(
                  "nombreusuariocontacto",
                  buildCampoTextoGet(
                    propiedad,
                    ref,
                    "nombreusuariocontacto",
                    "",
                    30,
                    true,
                  ),
                  Alignment.topLeft,
                  300,
                ),
                renglonCapturaGet(
                  "imgendelcontacto",
                  buildCampoTextoGet(
                    propiedad,
                    ref,
                    "imgendelcontacto",
                    "",
                    30,
                    true,
                  ),
                  Alignment.topLeft,
                  300,
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
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: appTheme.primary,
                    minimumSize: const Size(150, 40),
                  ),
                  onPressed: () {
                    setState(() {
                      pasosActivar[currentStep] = false;
                      currentStep--;
                      pasosActivar[currentStep] = true;
                    });
                  },
                  child: const Text(
                    'Anterior',
                    style: TextStyle(fontSize: 14, color: Colors.white),
                  ),
                ),
                botonGuardar(context),
              ],
            ),
            const SizedBox(height: 20),
            botonSalir(context),
          ],
        ),
        isActive: pasosActivar[4],
      ),
    ];

    // --- SCAFFOLD ---
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 40.0,
        centerTitle: true,
        titleSpacing: 0,
        backgroundColor: appTheme.primary,
        iconTheme: IconThemeData(size: 14, color: appTheme.onPrimary),
        title: Text(
          'Actualiza propiedad: ${ref.read(espaciosCasaConListaFotosGetProvider).espaciosCasas.rows.isNotEmpty ? ref.read(espaciosCasaConListaFotosGetProvider).espaciosCasas.rows[0].value.espacioscasa.clavedelapropiedad : ""}',
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
      body: Form(
        key: formKeyEspacioComprado,
        autovalidateMode: AutovalidateMode.disabled,
        child: Stepper(
          controlsBuilder: (BuildContext context, ControlsDetails details) {
            return Container(alignment: Alignment.topLeft);
          },
          steps: pasosCapturaPropiedad,
          type: (screenWidth < verticalWidth)
              ? StepperType.vertical
              : StepperType.horizontal,
          currentStep: currentStep,
          onStepTapped: (step) {
            setState(() {
              pasosActivar[currentStep] = false;
              currentStep = step;
              pasosActivar[currentStep] = true;
            });
          },
          onStepContinue: () {
            setState(() {
              if (currentStep < pasosCapturaPropiedad.length - 1) {
                pasosActivar[currentStep] = false;
                currentStep++;
                pasosActivar[currentStep] = true;
              }
            });
          },
          onStepCancel: () {
            setState(() {
              if (currentStep > 0) {
                pasosActivar[currentStep] = false;
                currentStep--;
                pasosActivar[currentStep] = true;
              }
            });
          },
        ),
      ),
    );
  }

  // --- MÉTODOS AUXILIARES DENTRO DEL STATE ---

  SizedBox capturaCampoGetConCheckBox(
    String nombreDeLaVariable,
    String expRegular,
    int numchar,
  ) {
    return SizedBox(
      width: 300,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          campoGetDeSeleccion(nombreDeLaVariable),
          const SizedBox(width: 5),
          (checklistAdicionales[nombreDeLaVariable] ?? false)
              ? renglonCapturaGet(
                  ref
                      .read(espaciosCasaConListaFotosGetProvider.notifier)
                      .getCampoEspaciosCasasGet(nombreDeLaVariable),
                  buildCampoTextoGet(
                    propiedad,
                    ref,
                    nombreDeLaVariable,
                    expRegular,
                    numchar,
                    true,
                  ),
                  Alignment.topLeft,
                  250,
                )
              : SizedBox(
                  width: 250,
                  child: Text(
                    ref
                        .read(espaciosCasaConListaFotosGetProvider.notifier)
                        .getCampoEspaciosCasasGet(nombreDeLaVariable),
                    maxLines: 2,
                    overflow: TextOverflow.visible,
                    softWrap: true,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  Checkbox campoGetDeSeleccion(String nombreDeLaVariable) {
    return Checkbox(
      value: checklistAdicionales[nombreDeLaVariable],
      onChanged: (value) {
        setState(() {
          if (value!) {
            checklistAdicionales[nombreDeLaVariable] = true;
            ref
                .read(espaciosCasaConListaFotosGetProvider.notifier)
                .setCampoEspaciosCasasGet(nombreDeLaVariable, "si");
            // También actualizamos la propiedad local
            setCampoEspaciosCasasGet(propiedad, nombreDeLaVariable, "si");
          } else {
            checklistAdicionales[nombreDeLaVariable] = false;
            ref
                .read(espaciosCasaConListaFotosGetProvider.notifier)
                .setCampoEspaciosCasasGet(nombreDeLaVariable, "");
            // También actualizamos la propiedad local
            setCampoEspaciosCasasGet(propiedad, nombreDeLaVariable, "");
          }
        });
      },
    );
  }

  void setchecklistAdicionalesGet(ValueEspaciosCasaGet propiedad) {
    debugPrintLevels(5, 'HTTP setchecklistAdicionalesGet');
    // Reinicia el mapa si es necesario, asumiendo que checklistAdicionales es global
    // o asegúrate que esté limpio.

    if (propiedad.espacioscasa.datosadicionalescasa.panelessolares == "si")
      checklistAdicionales["panelessolares"] = true;
    if (propiedad.espacioscasa.datosadicionalescasa.jardin == "si")
      checklistAdicionales["jardin"] = true;
    if (propiedad.espacioscasa.datosadicionalescasa.alberca == "si")
      checklistAdicionales["alberca"] = true;
    if (propiedad.espacioscasa.datosadicionalescasa.calefaccion == "si")
      checklistAdicionales["calefaccion"] = true;
    if (propiedad.espacioscasa.datosadicionalescasa.aireacondicionado == "si")
      checklistAdicionales["aireacondicionado"] = true;
    if (propiedad.espacioscasa.datosadicionalescasa.seguridad == "si")
      checklistAdicionales["seguridad"] = true;
    if (propiedad.espacioscasa.datosadicionalescasa.enfraccionamiento == "si")
      checklistAdicionales["enfraccionamiento"] = true;
    if (propiedad.espacioscasa.datosadicionalescasa.casasenelconjunto == "si")
      checklistAdicionales["casasenelconjunto"] = true;
    if (propiedad.espacioscasa.datosadicionalescasa.casaclub == "si")
      checklistAdicionales["casaclub"] = true;
    if (propiedad.espacioscasa.datosadicionalescasa.salondeeventos == "si")
      checklistAdicionales["salondeeventos"] = true;
    if (propiedad.espacioscasa.datosadicionalescasa.centrodenegocios == "si")
      checklistAdicionales["centrodenegocios"] = true;
    if (propiedad.espacioscasa.datosadicionalescasa.gimnacio == "si")
      checklistAdicionales["gimnacio"] = true;
    if (propiedad.espacioscasa.datosadicionalescasa.cisterna == "si")
      checklistAdicionales["cisterna"] = true;
    if (propiedad.espacioscasa.datosadicionalescasa.almacenamientodeagua ==
        "si")
      checklistAdicionales["almacenamientodeagua"] = true;
    if (propiedad.espacioscasa.datosadicionalescasa.tratamientodeaguas == "si")
      checklistAdicionales["tratamientodeaguas"] = true;
    if (propiedad.espacioscasa.datosadicionalescasa.otrascaracteristicas ==
        "si")
      checklistAdicionales["otrascaracteristicas"] = true;
  }
}

// -----------------------------------------------------------------------------
// FUNCIONES AUXILIARES GLOBALES (Se mantienen fuera como en el original)
// -----------------------------------------------------------------------------

SizedBox renglonCapturaGet(
  String etiqueta,
  Widget function,
  AlignmentGeometry alineacion,
  double ancho,
) {
  return SizedBox(
    width: ancho,
    child: FormaEtiquetaFolioGet(etiqueta, function, alineacion),
  );
}

Widget FormaEtiquetaFolioGet(
  String etiqueta,
  Widget function,
  AlignmentGeometry alineacion,
) {
  return Container(
    // Nota: screenWidth y smallScreenMin deben ser globales accesibles aquí
    width: (screenWidth < smallScreenMin) ? screenWidth : screenWidth * 0.7,
    alignment: alineacion,
    child: function,
  );
}

Widget buildCampoTextoGet(
  ValueEspaciosCasaGet propiedad,
  WidgetRef ref,
  String nombreVariable,
  String expRegular,
  int numchar,
  bool enable,
) {
  return SizedBox(
    child: (!enable)
        ? Text(
            getCampoEspaciosCasasGet(propiedad, nombreVariable),
            maxLines: 8,
            style: TextStyle(
              color: appTheme.primary,
              fontSize: tamanoLetra,
              fontWeight: FontWeight.normal,
              decoration: TextDecoration.overline,
            ),
          )
        : TextFormField(
            initialValue: getCampoEspaciosCasasGet(propiedad, nombreVariable),
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
                  " ${ref.read(espaciosCasaConListaFotosGetProvider.notifier).getCampoEspaciosCasasGet(nombreVariable)} ",
              floatingLabelBehavior: FloatingLabelBehavior.always,
              isDense: true,
              contentPadding: const EdgeInsets.fromLTRB(10, 15, 10, 15),
            ),
            onChanged: (String? value) {
              setCampoEspaciosCasasGet(propiedad, nombreVariable, value!);
            },
          ),
  );
}

//----------------------------------

void setCampoEspaciosCasasGet(
  ValueEspaciosCasaGet propiedad,
  String campo,
  String valor,
) {
  debugPrintLevels(
    2,
    'HTTP setCampoEspaciosCasasGet: campo = $campo, valor: $valor',
  );

  switch (campo) {
    case "id":
      propiedad.id = valor;
      break;
    case "rev":
      propiedad.rev = valor;
      break;

    case "versiondelformato":
      propiedad.espacioscasa.versiondelformato = valor;
      break;
    case "idPropiedad":
      propiedad.espacioscasa.idPropiedad = valor;
      break;
    case "clavedelapropiedad":
      propiedad.espacioscasa.clavedelapropiedad = valor;
      break;
    case "idusuario":
      propiedad.espacioscasa.idusuario = valor;
      break;

    case "tipodeanuncio":
      propiedad.espacioscasa.tipodeanuncio = valor;
      break;
    case "tipodetransaccion":
      propiedad.espacioscasa.tipodetransaccion = valor;
      debugPrintLevels(
        2,
        'HTTP setCampoEspaciosCasasGet tipodetransaccion: campo = $campo, valor: ${propiedad.espacioscasa.tipodetransaccion}',
      );
      break;
    case "idTransaccion":
      propiedad.espacioscasa.idTransaccion = valor;
      break;

    case "nombredelapropiedad":
      propiedad.espacioscasa.nombredelapropiedad = valor;
      break;
    case "inmobiliaria":
      propiedad.espacioscasa.inmobiliaria = valor;
      break;
    case "inmobiliariaimagen":
      propiedad.espacioscasa.inmobiliariaimagen = valor;
      break;
    case "linkinmobiliaria":
      propiedad.espacioscasa.inmobiliariaimagen = valor;
      break;
    case "sloganinmobiliaria":
      propiedad.espacioscasa.inmobiliariaimagen = valor;
      break;

    case "ubicaciongeneral":
      propiedad.espacioscasa.ubicaciongeneral = valor;
      break;

    case "tipodepropiedad":
      propiedad.espacioscasa.tipodepropiedad = valor;
      debugPrintLevels(
        2,
        'HTTP setCampoEspaciosCasasGet cambio tipodepropiedad: campo = $campo, valor: ${propiedad.espacioscasa.tipodepropiedad}',
      );
      break;

    case "descripcion":
      propiedad.espacioscasa.descripcion = valor;
      break;
    case "letreropromocional":
      propiedad.espacioscasa.letreropromocional = valor;
      break;
    case "metrosdeterreno":
      propiedad.espacioscasa.metrosdeterreno = valor;
      break;
    case "metrosconstruidos":
      propiedad.espacioscasa.metrosconstruidos = valor;
      break;
    case "recamaras":
      propiedad.espacioscasa.recamaras = valor;
      break;
    case "banos":
      propiedad.espacioscasa.banos = valor;
      break;
    case "mediosbanos":
      propiedad.espacioscasa.mediosbanos = valor;
      break;
    case "cuartosdeservicio":
      propiedad.espacioscasa.cuartosdeservicio = valor;
      break;
    case "estacionamientos":
      propiedad.espacioscasa.estacionamientos = valor;
      break;
    case "estacionamientoscubiertos":
      propiedad.espacioscasa.estacionamientoscubiertos = valor;
      break;

    case "panelessolares":
      // debugPrintLevels(5, "cambia valor = $valor");
      propiedad.espacioscasa.datosadicionalescasa.panelessolares = valor;
      break;
    case "jardin":
      propiedad.espacioscasa.datosadicionalescasa.jardin = valor;
      break;
    case "alberca":
      propiedad.espacioscasa.datosadicionalescasa.alberca = valor;
      break;
    case "calefaccion":
      propiedad.espacioscasa.datosadicionalescasa.calefaccion = valor;
      break;
    case "aireacondicionado":
      propiedad.espacioscasa.datosadicionalescasa.aireacondicionado = valor;
      break;
    case "seguridad":
      propiedad.espacioscasa.datosadicionalescasa.seguridad = valor;
      break;
    case "enfraccionamiento":
      propiedad.espacioscasa.datosadicionalescasa.enfraccionamiento = valor;
      break;
    case "casasenelconjunto":
      propiedad.espacioscasa.datosadicionalescasa.casasenelconjunto = valor;
      break;
    case "casaclub":
      propiedad.espacioscasa.datosadicionalescasa.casaclub = valor;
      break;
    case "salondeeventos":
      propiedad.espacioscasa.datosadicionalescasa.salondeeventos = valor;
      break;
    case "centrodenegocios":
      propiedad.espacioscasa.datosadicionalescasa.centrodenegocios = valor;
      break;
    case "gimnacio":
      propiedad.espacioscasa.datosadicionalescasa.gimnacio = valor;
      break;
    case "cisterna":
      propiedad.espacioscasa.datosadicionalescasa.cisterna = valor;
      break;
    case "almacenamientodeagua":
      propiedad.espacioscasa.datosadicionalescasa.almacenamientodeagua = valor;
      break;
    case "tratamientodeaguas":
      propiedad.espacioscasa.datosadicionalescasa.tratamientodeaguas = valor;
      break;
    case "otrascaracteristicas":
      propiedad.espacioscasa.datosadicionalescasa.otrascaracteristicas = valor;

    case "elementosadicionalescasa":
      propiedad.espacioscasa.elementosadicionalescasa = valor;
      break;

    case "precioventa":
      propiedad.espacioscasa.precioventa = valor;
      break;
    case "preciorenta":
      propiedad.espacioscasa.preciorenta = valor;
      break;
    case "mantenimiento":
      propiedad.espacioscasa.mantenimiento = valor;
      break;
    case "moneda":
      propiedad.espacioscasa.moneda = valor;
      break;

    case "niveldeprioridad":
      propiedad.espacioscasa.niveldeprioridad = valor;
      break;
    case "condicionesdeventa":
      propiedad.espacioscasa.condicionesdeventa = valor;
      break;
    case "fotoprincipal":
      propiedad.espacioscasa.fotoprincipal = valor;
      break;
    case "numerodefotos":
      propiedad.espacioscasa.numerodefotos = valor;
      break;
    case "linkvideo":
      propiedad.espacioscasa.linkvideo = valor;
      break;

    case "nombre":
      propiedad.espacioscasa.datosdelcontactocasa.nombre = valor;
      break;
    case "empresa":
      propiedad.espacioscasa.datosdelcontactocasa.empresa = valor;
      break;
    case "imgendeempresa":
      propiedad.espacioscasa.datosdelcontactocasa.imgendeempresa = valor;
      break;
    case "numerocelular":
      propiedad.espacioscasa.datosdelcontactocasa.numerocelular = valor;
      break;
    case "numerootro":
      propiedad.espacioscasa.datosdelcontactocasa.numerootro = valor;
      break;
    case "numeroinmobiliaria":
      propiedad.espacioscasa.datosdelcontactocasa.numeroinmobiliaria = valor;
      break;
    case "correoelectronico":
      propiedad.espacioscasa.datosdelcontactocasa.correoelectronico = valor;
      break;
    case "idusuariocontacto":
      propiedad.espacioscasa.datosdelcontactocasa.idusuariocontacto = valor;
      break;
    case "nombreusuariocontacto":
      propiedad.espacioscasa.datosdelcontactocasa.nombreusuariocontacto = valor;
      break;
    case "imgendelcontacto":
      propiedad.espacioscasa.datosdelcontactocasa.imgendelcontacto = valor;
      break;

    case "pais":
      propiedad.espacioscasa.ubicacioncasa.pais = valor;
      break;

    case "idEstado":
      propiedad.espacioscasa.ubicacioncasa.localidadCp.idEstado = int.parse(
        valor,
      );
      break;
    case "estado":
      propiedad.espacioscasa.ubicacioncasa.localidadCp.estado = valor;
      break;
    case "idMunicipio":
      propiedad.espacioscasa.ubicacioncasa.localidadCp.idMunicipio = int.parse(
        valor,
      );
      break;
    case "municipio":
      propiedad.espacioscasa.ubicacioncasa.localidadCp.municipio = valor;
      break;
    case "ciudad":
      propiedad.espacioscasa.ubicacioncasa.localidadCp.ciudad = valor;
      break;
    case "zona":
      propiedad.espacioscasa.ubicacioncasa.localidadCp.zona = valor;
      break;
    case "asentamiento":
      propiedad.espacioscasa.ubicacioncasa.localidadCp.asentamiento = valor;
      break;
    case "codigopostal":
      propiedad.espacioscasa.ubicacioncasa.localidadCp.cp = int.parse(valor);
      break;
    case "tipo":
      propiedad.espacioscasa.ubicacioncasa.localidadCp.tipo = valor;
      break;

    case "calle":
      propiedad.espacioscasa.ubicacioncasa.calle = valor;
      break;
    case "numeroexterior":
      propiedad.espacioscasa.ubicacioncasa.numeroexterior = valor;
      break;
    case "numerointerior":
      propiedad.espacioscasa.ubicacioncasa.numerointerior = valor;
      break;

    case "latitud":
      propiedad.espacioscasa.ubicacioncasa.latitud = valor;
      break;
    case "longitud":
      propiedad.espacioscasa.ubicacioncasa.longitud = valor;
      break;
    case "latitudDecimal":
      propiedad.espacioscasa.ubicacioncasa.latitudDecimal = valor;
      break;
    case "longitudDecimal":
      propiedad.espacioscasa.ubicacioncasa.longitudDecimal = valor;
      break;

    case "diapublicacion":
      propiedad.espacioscasa.fechadepublicacioncasa.dia = int.parse(valor);
      break;
    case "mespublicacion":
      propiedad.espacioscasa.fechadepublicacioncasa.mes = int.parse(valor);
      break;
    case "aniopublicacion":
      propiedad.espacioscasa.fechadepublicacioncasa.anio = int.parse(valor);
      break;

    case "diadecierre":
      propiedad.espacioscasa.fechadecierrecasa.dia = int.parse(valor);
      break;
    case "mesdecierre":
      propiedad.espacioscasa.fechadecierrecasa.mes = int.parse(valor);
      break;
    case "aniodecierre":
      propiedad.espacioscasa.fechadecierrecasa.anio = int.parse(valor);
      break;

    case "activa":
      propiedad.espacioscasa.activa = int.parse(valor);
      break;
    case "timestampcasa":
      propiedad.espacioscasa.timestampcasa = valor;
      break;
  }
}

String getCampoEspaciosCasasGet(ValueEspaciosCasaGet propiedad, String campo) {
  // debugPrintLevels(5, 'HTTP getCampoEspaciosCasasGet');

  String variableRegreso = "";
  final varEspaciosCasasGetProvider = propiedad;

  switch (campo) {
    case "id":
      return variableRegreso = varEspaciosCasasGetProvider.id;
    case "rev":
      return variableRegreso = varEspaciosCasasGetProvider.rev;

    case "versiondelformato":
      return variableRegreso =
          varEspaciosCasasGetProvider.espacioscasa.versiondelformato;
    case "idPropiedad":
      return variableRegreso =
          varEspaciosCasasGetProvider.espacioscasa.idPropiedad;
    case "clavedelapropiedad":
      return variableRegreso =
          varEspaciosCasasGetProvider.espacioscasa.clavedelapropiedad;
    case "idusuario":
      return variableRegreso =
          varEspaciosCasasGetProvider.espacioscasa.idusuario;

    case "tipodeanuncio":
      return variableRegreso =
          varEspaciosCasasGetProvider.espacioscasa.tipodeanuncio;
    case "tipodetransaccion":
      return variableRegreso =
          varEspaciosCasasGetProvider.espacioscasa.tipodetransaccion;
    case "idTransaccion":
      return variableRegreso =
          varEspaciosCasasGetProvider.espacioscasa.idTransaccion;

    case "nombredelapropiedad":
      return variableRegreso =
          varEspaciosCasasGetProvider.espacioscasa.nombredelapropiedad;
    case "inmobiliaria":
      return variableRegreso =
          varEspaciosCasasGetProvider.espacioscasa.inmobiliaria;
    case "inmobiliariaimagen":
      return variableRegreso =
          varEspaciosCasasGetProvider.espacioscasa.inmobiliariaimagen;
    case "linkinmobiliaria":
      return variableRegreso =
          varEspaciosCasasGetProvider.espacioscasa.linkinmobiliaria;
    case "sloganinmobiliaria":
      return variableRegreso =
          varEspaciosCasasGetProvider.espacioscasa.sloganinmobiliaria;

    case "ubicaciongeneral":
      return variableRegreso =
          varEspaciosCasasGetProvider.espacioscasa.ubicaciongeneral;

    case "tipodepropiedad":
      return variableRegreso =
          varEspaciosCasasGetProvider.espacioscasa.tipodepropiedad;
    case "descripcion":
      return variableRegreso =
          varEspaciosCasasGetProvider.espacioscasa.descripcion;
    case "letreropromocional":
      return variableRegreso =
          varEspaciosCasasGetProvider.espacioscasa.letreropromocional;
    case "metrosdeterreno":
      return variableRegreso =
          varEspaciosCasasGetProvider.espacioscasa.metrosdeterreno;
    case "metrosconstruidos":
      return variableRegreso =
          varEspaciosCasasGetProvider.espacioscasa.metrosconstruidos;
    case "recamaras":
      return variableRegreso =
          varEspaciosCasasGetProvider.espacioscasa.recamaras;
    case "banos":
      return variableRegreso = varEspaciosCasasGetProvider.espacioscasa.banos;
    case "mediosbanos":
      return variableRegreso =
          varEspaciosCasasGetProvider.espacioscasa.mediosbanos;
    case "cuartosdeservicio":
      return variableRegreso =
          varEspaciosCasasGetProvider.espacioscasa.cuartosdeservicio;
    case "estacionamientos":
      return variableRegreso =
          varEspaciosCasasGetProvider.espacioscasa.estacionamientos;
    case "estacionamientoscubiertos":
      return variableRegreso =
          varEspaciosCasasGetProvider.espacioscasa.estacionamientoscubiertos;

    case "panelessolares":
      variableRegreso = varEspaciosCasasGetProvider
          .espacioscasa
          .datosadicionalescasa
          .panelessolares;
    case "jardin":
      return variableRegreso =
          varEspaciosCasasGetProvider.espacioscasa.datosadicionalescasa.jardin;
    case "alberca":
      return variableRegreso =
          varEspaciosCasasGetProvider.espacioscasa.datosadicionalescasa.alberca;
    case "calefaccion":
      return variableRegreso = varEspaciosCasasGetProvider
          .espacioscasa
          .datosadicionalescasa
          .calefaccion;
    case "aireacondicionado":
      variableRegreso = varEspaciosCasasGetProvider
          .espacioscasa
          .datosadicionalescasa
          .aireacondicionado;
    case "seguridad":
      return variableRegreso = varEspaciosCasasGetProvider
          .espacioscasa
          .datosadicionalescasa
          .seguridad;
    case "enfraccionamiento":
      variableRegreso = varEspaciosCasasGetProvider
          .espacioscasa
          .datosadicionalescasa
          .enfraccionamiento;
    case "casasenelconjunto":
      variableRegreso = varEspaciosCasasGetProvider
          .espacioscasa
          .datosadicionalescasa
          .casasenelconjunto;
    case "casaclub":
      return variableRegreso = varEspaciosCasasGetProvider
          .espacioscasa
          .datosadicionalescasa
          .casaclub;
    case "salondeeventos":
      variableRegreso = varEspaciosCasasGetProvider
          .espacioscasa
          .datosadicionalescasa
          .salondeeventos;
    case "centrodenegocios":
      variableRegreso = varEspaciosCasasGetProvider
          .espacioscasa
          .datosadicionalescasa
          .centrodenegocios;
    case "gimnacio":
      return variableRegreso = varEspaciosCasasGetProvider
          .espacioscasa
          .datosadicionalescasa
          .gimnacio;
    case "cisterna":
      return variableRegreso = varEspaciosCasasGetProvider
          .espacioscasa
          .datosadicionalescasa
          .cisterna;
    case "almacenamientodeagua":
      variableRegreso = varEspaciosCasasGetProvider
          .espacioscasa
          .datosadicionalescasa
          .almacenamientodeagua;
    case "tratamientodeaguas":
      variableRegreso = varEspaciosCasasGetProvider
          .espacioscasa
          .datosadicionalescasa
          .tratamientodeaguas;
    case "otrascaracteristicas":
      variableRegreso = varEspaciosCasasGetProvider
          .espacioscasa
          .datosadicionalescasa
          .otrascaracteristicas;

    case "elementosadicionalescasa":
      return variableRegreso =
          varEspaciosCasasGetProvider.espacioscasa.elementosadicionalescasa;

    case "precioventa":
      return variableRegreso =
          varEspaciosCasasGetProvider.espacioscasa.precioventa;
    case "preciorenta":
      return variableRegreso =
          varEspaciosCasasGetProvider.espacioscasa.preciorenta;
    case "mantenimiento":
      return variableRegreso =
          varEspaciosCasasGetProvider.espacioscasa.mantenimiento;
    case "moneda":
      return variableRegreso = varEspaciosCasasGetProvider.espacioscasa.moneda;
    case "niveldeprioridad":
      return variableRegreso =
          varEspaciosCasasGetProvider.espacioscasa.niveldeprioridad;
    case "condicionesdeventa":
      return variableRegreso =
          varEspaciosCasasGetProvider.espacioscasa.condicionesdeventa;
    case "fotoprincipal":
      return variableRegreso =
          varEspaciosCasasGetProvider.espacioscasa.fotoprincipal;
    case "numerodefotos":
      return variableRegreso =
          varEspaciosCasasGetProvider.espacioscasa.numerodefotos;
    case "linkvideo":
      return variableRegreso =
          varEspaciosCasasGetProvider.espacioscasa.linkvideo;

    case "nombre":
      return variableRegreso =
          varEspaciosCasasGetProvider.espacioscasa.datosdelcontactocasa.nombre;
    case "empresa":
      return variableRegreso =
          varEspaciosCasasGetProvider.espacioscasa.datosdelcontactocasa.empresa;
    case "imgendeempresa":
      return variableRegreso = varEspaciosCasasGetProvider
          .espacioscasa
          .datosdelcontactocasa
          .imgendeempresa;
    case "numerocelular":
      return variableRegreso = varEspaciosCasasGetProvider
          .espacioscasa
          .datosdelcontactocasa
          .numerocelular;
    case "numerootro":
      return variableRegreso = varEspaciosCasasGetProvider
          .espacioscasa
          .datosdelcontactocasa
          .numerootro;
    case "numeroinmobiliaria":
      return variableRegreso = varEspaciosCasasGetProvider
          .espacioscasa
          .datosdelcontactocasa
          .numeroinmobiliaria;
    case "correoelectronico":
      return variableRegreso = varEspaciosCasasGetProvider
          .espacioscasa
          .datosdelcontactocasa
          .correoelectronico;
    case "idusuariocontacto":
      return variableRegreso = varEspaciosCasasGetProvider
          .espacioscasa
          .datosdelcontactocasa
          .idusuariocontacto;
    case "nombreusuariocontacto":
      return variableRegreso = varEspaciosCasasGetProvider
          .espacioscasa
          .datosdelcontactocasa
          .nombreusuariocontacto;
    case "imgendelcontacto":
      return variableRegreso = varEspaciosCasasGetProvider
          .espacioscasa
          .datosdelcontactocasa
          .imgendelcontacto;

    case "pais":
      return variableRegreso =
          varEspaciosCasasGetProvider.espacioscasa.ubicacioncasa.pais;

    case "idEstado":
      return variableRegreso = varEspaciosCasasGetProvider
          .espacioscasa
          .ubicacioncasa
          .localidadCp
          .idEstado
          .toString();
    case "estado":
      return variableRegreso = varEspaciosCasasGetProvider
          .espacioscasa
          .ubicacioncasa
          .localidadCp
          .estado;
    case "idMunicipio":
      return variableRegreso = varEspaciosCasasGetProvider
          .espacioscasa
          .ubicacioncasa
          .localidadCp
          .idMunicipio
          .toString();
    case "municipio":
      return variableRegreso = varEspaciosCasasGetProvider
          .espacioscasa
          .ubicacioncasa
          .localidadCp
          .municipio;
    case "ciudad":
      return variableRegreso = varEspaciosCasasGetProvider
          .espacioscasa
          .ubicacioncasa
          .localidadCp
          .ciudad;
    case "zona":
      return variableRegreso = varEspaciosCasasGetProvider
          .espacioscasa
          .ubicacioncasa
          .localidadCp
          .zona;
    case "asentamiento":
      return variableRegreso = varEspaciosCasasGetProvider
          .espacioscasa
          .ubicacioncasa
          .localidadCp
          .asentamiento;
    case "codigopostal":
      return variableRegreso = varEspaciosCasasGetProvider
          .espacioscasa
          .ubicacioncasa
          .localidadCp
          .cp
          .toString();
    case "tipo":
      return variableRegreso = varEspaciosCasasGetProvider
          .espacioscasa
          .ubicacioncasa
          .localidadCp
          .tipo;

    case "calle":
      return variableRegreso =
          varEspaciosCasasGetProvider.espacioscasa.ubicacioncasa.calle;
    case "numeroexterior":
      return variableRegreso =
          varEspaciosCasasGetProvider.espacioscasa.ubicacioncasa.numeroexterior;
    case "numerointerior":
      return variableRegreso =
          varEspaciosCasasGetProvider.espacioscasa.ubicacioncasa.numerointerior;
    case "entrecalle01":
      return variableRegreso =
          varEspaciosCasasGetProvider.espacioscasa.ubicacioncasa.entrecalle01;
    case "entrecalle02":
      return variableRegreso =
          varEspaciosCasasGetProvider.espacioscasa.ubicacioncasa.entrecalle02;

    case "latitud":
      return variableRegreso =
          varEspaciosCasasGetProvider.espacioscasa.ubicacioncasa.latitud;
    case "longitud":
      return variableRegreso =
          varEspaciosCasasGetProvider.espacioscasa.ubicacioncasa.longitud;
    case "latitudDecimal":
      return variableRegreso =
          varEspaciosCasasGetProvider.espacioscasa.ubicacioncasa.latitudDecimal;
    case "longitudDecimal":
      return variableRegreso = varEspaciosCasasGetProvider
          .espacioscasa
          .ubicacioncasa
          .longitudDecimal;

    case "diapublicacion":
      return variableRegreso = varEspaciosCasasGetProvider
          .espacioscasa
          .fechadepublicacioncasa
          .dia
          .toStringAsFixed(0);
    case "mespublicacion":
      return variableRegreso = varEspaciosCasasGetProvider
          .espacioscasa
          .fechadepublicacioncasa
          .mes
          .toStringAsFixed(0);
    case "aniopublicacion":
      return variableRegreso = varEspaciosCasasGetProvider
          .espacioscasa
          .fechadepublicacioncasa
          .anio
          .toStringAsFixed(0);

    case "diadecierre":
      return variableRegreso = varEspaciosCasasGetProvider
          .espacioscasa
          .fechadecierrecasa
          .dia
          .toStringAsFixed(0);
    case "mesdecierre":
      return variableRegreso = varEspaciosCasasGetProvider
          .espacioscasa
          .fechadecierrecasa
          .mes
          .toStringAsFixed(0);
    case "aniodecierre":
      return variableRegreso = varEspaciosCasasGetProvider
          .espacioscasa
          .fechadecierrecasa
          .anio
          .toStringAsFixed(0);

    case "activa":
      return variableRegreso = varEspaciosCasasGetProvider.espacioscasa.activa
          .toStringAsFixed(0);
    case "timestampcasa":
      return variableRegreso =
          varEspaciosCasasGetProvider.espacioscasa.timestampcasa;
  }
  debugPrintLevels(
    2,
    "----- getCampoEspaciosCasasGet campo = $campo, valor: $variableRegreso",
  );
  return variableRegreso;
}
*/
