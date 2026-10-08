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
import '../../../60_global_widgets/campo_texto.dart';
import 'edicion/acceso_campos.dart';
import 'edicion/campos_edicion.dart';

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
  bool _guardando = false; // evita enviar dos veces el mismo guardado
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
      onPressed: _guardando ? null : _guardar,
      child: _guardando
          ? SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: appTheme.onPrimary,
              ),
            )
          : Text(
              'Guardar',
              style: TextStyle(fontSize: 14, color: appTheme.onPrimary),
            ),
    );
  }

  Future<void> _guardar() async {
    final formulario = formKeyEspacioComprado.currentState;
    if (formulario == null || _guardando) return;

    if (!formulario.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: appTheme.error,
          content: Text(
            'Revisa los campos marcados en rojo (pueden estar en otros pasos).',
            style: TextStyle(color: appTheme.onError),
          ),
        ),
      );
      return;
    }
    formulario.save();
    setState(() => _guardando = true);

    final notifier = ref.read(espaciosCasaConListaFotosGetProvider.notifier);
    int resultado = 0;
    try {
      // 1. Índice actual y posición de esta propiedad en la lista (por id)
      final indexAnterior = notifier.getIndexEspaciosCasas();
      final index = ref
          .read(espaciosCasaConListaFotosGetProvider)
          .espaciosCasas
          .rows
          .indexWhere(
            (p) =>
                p.value.espacioscasa.idPropiedad ==
                propiedad.espacioscasa.idPropiedad,
          );
      if (index != -1) notifier.setIndexEspaciosCasas(index);

      // 2. Copiar la propiedad editada al estado de Riverpod y guardar en CouchDB
      notifier.setEspaciosCasasGet(propiedad);
      debugPrintLevels(5, "05. PaginaEditaEspacio Guarda cambios ");
      resultado = await notifier.updatePropiedadCasaGetToCouchDB();
      notifier.setIndexEspaciosCasas(indexAnterior);
      debugPrintLevels(
          5, "06. PaginaEditaEspacio Resultado de Update espacio: $resultado");
    } catch (e) {
      debugPrintLevels(1, "PaginaEditaEspacio guardar exception: $e");
    }
    if (!mounted) return;

    final exito = resultado == 200 || resultado == 201;
    await showMessageDialog(
      context,
      "Actualiza propiedad",
      exito
          ? "Se actualizó correctamente"
          : "No se pudo guardar la propiedad (código $resultado). Revisa tu conexión e inténtalo de nuevo.",
      exito ? appTheme.primary : appTheme.error,
      TextAlign.center,
      exito ? "Salir" : "Cerrar",
    );
    if (!mounted) return;
    if (exito) {
      Navigator.of(context).pop();
    } else {
      setState(() => _guardando = false);
    }
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

  static const _titulosPaso = [
    "Datos de la propiedad",
    "Precio y costos de la propiedad",
    "Dirección de la propiedad",
    "Datos adicionales",
    "Datos del promotor",
  ];
  static const _etiquetasPaso = [
    "Propiedad",
    "Precio",
    "Ubicación",
    "Adicionales",
    "Contacto",
  ];

  Step _buildPasoPropiedad() => _buildPaso(0, camposPropiedad, encabezado: [
        // Dropdown Tipo Propiedad
        _buildDropdown(
          value: tipoDePropiedad,
          items: listaTipoInmuebles,
          onChanged: (newValue) {
            if (newValue != null) {
              setState(() {
                tipoDePropiedad = newValue;
                setCampoEspaciosCasasGet(
                    propiedad, "tipodepropiedad", tipoDePropiedad);
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
                    propiedad, "tipodetransaccion", tipoDeTransaccion);
              });
            }
          },
        ),
      ]);

  Step _buildPasoPrecio() => _buildPaso(1, camposPrecio);
  Step _buildPasoUbicacion() => _buildPaso(2, camposUbicacion);
  Step _buildPasoAdicionales() => _buildPaso(3, camposAdicionales);
  Step _buildPasoContacto() => _buildPaso(4, camposContacto);

  /// Paso del Stepper: título, campos visibles según el tipo de inmueble y de
  /// transacción (ver `edicion/campos_edicion.dart`) y botones de navegación.
  Step _buildPaso(int indice, List<CampoDef> campos,
      {List<Widget> encabezado = const []}) {
    final visibles = camposVisibles(campos, tipoDePropiedad, tipoDeTransaccion);
    final esUltimo = indice == _etiquetasPaso.length - 1;
    return Step(
      title: Text((screenWidth > verticalWidth) ? "" : _etiquetasPaso[indice]),
      label: Text(
        (screenWidth > verticalWidth) ? _etiquetasPaso[indice] : "",
        style: TextStyle(
          color: appTheme.primary,
          fontWeight:
              (pasosActivar[indice]) ? FontWeight.bold : FontWeight.normal,
          fontSize: 10,
        ),
      ),
      content: Column(
        children: [
          Center(
            child: Text(
              _titulosPaso[indice],
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
              ...encabezado,
              ...visibles.map(
                (c) => c.conCasilla
                    ? capturaCampoGetConCheckBox(c.nombre)
                    : renglonCapturaGet(
                        c.nombre,
                        buildCampoTextoGet(propiedad, ref, c),
                        Alignment.topLeft,
                        300,
                      ),
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
              if (indice > 0) _botonNavegacion('Anterior', _anteriorPaso),
              botonGuardar(context),
              if (!esUltimo) _botonNavegacion('Siguiente', _siguientePaso),
            ],
          ),
          const SizedBox(height: 20),
          botonSalir(context),
        ],
      ),
      isActive: pasosActivar[indice],
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

  SizedBox capturaCampoGetConCheckBox(String nombreDeLaVariable) {
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
                    CampoDef(nombreDeLaVariable, maxLength: 80),
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
  CampoDef campo,
) {
  final valor = getCampoEspaciosCasasGet(propiedad, campo.nombre);
  if (!campo.editable) {
    return Text(
      valor,
      maxLines: 8,
      style: TextStyle(
        color: appTheme.primary,
        fontSize: tamanoLetra,
        fontWeight: FontWeight.normal,
        decoration: TextDecoration.overline,
      ),
    );
  }
  return CampoTexto(
    etiqueta: ref
        .read(espaciosCasaConListaFotosGetProvider.notifier)
        .getNombreDelCampoPropiedadCasaGet(campo.nombre),
    valorInicial: valor,
    tipo: campo.tipo,
    obligatorio: campo.obligatorio,
    maxLength: campo.maxLength,
    maxLines: campo.lineas,
    onChanged: (v) => setCampoEspaciosCasasGet(propiedad, campo.nombre, v),
  );
}

//------------------------------------------------------------------------------
// OPTIMIZADO
//------------------------------------------------------------------------------
