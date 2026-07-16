import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';
import '../../07_routes/app_routes.dart';
import '../../08_pantallas/propiedades/pagina_detalle_propiedad.dart';
import '../../60_global_widgets/future_builder_state_widgets.dart';
import '../../60_global_widgets/debugprint.dart';

import '../tus_espacios_fotos_propiedad/manejo_de_fotos/futures_y_providers/future_get_fotos_by_idpr_orden.dart';
import '../tus_espacios_fotos_propiedad/manejo_de_fotos/lista_fotos_ordenadas/provider_get_lista_fotos_ordenadas.dart';
import '../tus_espacios_fotos_propiedad/manejo_de_fotos/lista_ids_fotos/data_fotos_get_ids_fotos_user_prop.dart';
import '../../20_var_globales/var_color_themes.dart';
import '../../20_var_globales/var_color_widget.dart';
import '../../08_pantallas/inicio/data_espacios_casas_get.dart';
import '../data_models/data_fotos_ordenadas.dart';
import '../tus_espacios_fotos_propiedad/manejo_de_fotos/futures_y_providers/http_funciones_gestion_foto.dart';
import '../tus_espacios_fotos_propiedad/manejo_de_fotos/futures_y_providers/future_recupera_ids_fotos_propiedad.dart';
import 'package:carousel_slider/carousel_slider.dart'; // NECESARIO IMPORTAR ESTO

//------------------------------------------------------------------------------
// OPTIMIZADO

double widthCuadroFotoPropiedadLocal = 200;
double heightCuadroFotoPropiedadLocal = 125;

class PaginaCarouselFotosMini extends ConsumerStatefulWidget {
  final ValueEspaciosCasaGet valueespaciosparameter;

  const PaginaCarouselFotosMini(this.valueespaciosparameter, {super.key});

  @override
  ConsumerState<PaginaCarouselFotosMini> createState() =>
      PaginaCarouselFotosMiniState();
}

class PaginaCarouselFotosMiniState
    extends ConsumerState<PaginaCarouselFotosMini> {
  final scaffoldKeyCarouselFotos = GlobalKey<ScaffoldState>();
  String idUsuario = "";
  String idPropiedad = "";
  String nombrePropiedad = "";
  int indiceFotos = 0;
  int numeroDeFotos = 0;

  // CORRECCIÓN: Usamos CarouselSliderController (Versión 5.0.0+)
  // Si usas una versión anterior a la 5.0.0, usa 'CarouselController'
  final CarouselSliderController controllerCarousel =
      CarouselSliderController();

  late ValueEspaciosCasaGet propiedad;

  GetIdsFotosUserProp listaidsfotos = GetIdsFotosUserProp(
    rows: [],
    totalRows: 0,
    offset: 0,
  );

  ListaFotosOrdenadas listaIdFotosOrden = ListaFotosOrdenadas(
    idListaFotos: '',
    idUsuario: '',
    idPropiedad: '',
    fotosOrden: [],
    timestamp: '',
  );

  late Future<void> _futureMetaData;

  @override
  void initState() {
    super.initState();
    debugPrintLevels(9, "* PaginaCarouselFotosMini initState");

    propiedad = widget.valueespaciosparameter;
    idUsuario = widget.valueespaciosparameter.espacioscasa.idusuario;
    idPropiedad = widget.valueespaciosparameter.espacioscasa.idPropiedad;
    nombrePropiedad =
        widget.valueespaciosparameter.espacioscasa.nombredelapropiedad;

    _futureMetaData = _cargarMetadatos();
  }

  Future<void> _cargarMetadatos() async {
    List<FotosOrden> listaOrdenProvider = [];
    try {
      final idsData = await recuperaIdsFotosDePropiedades(
        idUsuario,
        idPropiedad,
      );
      listaidsfotos = idsData;
      debugPrintLevels(
        10,
        "*** RECUOERA IDS NO FOTOS:  ${listaidsfotos.rows.length}",
      );

      if (listaidsfotos.rows.isNotEmpty) {
        numeroDeFotos = listaidsfotos.rows.length;

        final statusOrden = await recuperaFotosOrdenadasIdProperty(
          ref,
          idPropiedad,
        );
        debugPrintLevels(
          10,
          "*** RECUOERA IDS ORDENADOS STATUSCODE: $statusOrden",
        );

        bool usarOrdenGuardado = false;
        if (statusOrden == 200) {
          debugPrintLevels(
            10,
            "*** RECUOERA IDS ORDENADOS NO FOTOS:  ${ref.read(getListaFotosOrdenadasProvider).rows[0].value.listadefotos.fotosOrden.length}",
          );
          listaOrdenProvider = ref
              .read(getListaFotosOrdenadasProvider)
              .rows[0]
              .value
              .listadefotos
              .fotosOrden;

          debugPrintLevels(
            10,
            "*** RECUOERA IDS ORDENADOS STATUSCODE: $statusOrden, NO FOTOS:  ${listaOrdenProvider.length}",
          );

          if (listaOrdenProvider.isNotEmpty) {
            if (listaOrdenProvider.length == numeroDeFotos) {
              debugPrintLevels(
                10,
                "*** EXISTE LISTA ORDENADA, NO VACIA CON MISMO DATOS QUE LISTA SIN ORDENAR",
              );

              usarOrdenGuardado = true;
            }
          }
        }

        if (usarOrdenGuardado) {
          listaIdFotosOrden.fotosOrden = listaOrdenProvider;
          debugPrintLevels(10, "*** GENERA LISTA SIN ORDENAR");
        } else {
          debugPrintLevels(10, "*** GENERA LISTA ORDENADA");
          listaIdFotosOrden.fotosOrden.clear();
          listaIdFotosOrden = ListaFotosOrdenadas(
            idListaFotos: '',
            idUsuario: listaidsfotos.rows[0].key[0],
            idPropiedad: listaidsfotos.rows[0].key[1],
            fotosOrden: [],
            timestamp: '',
          );

          for (var i = 0; i < listaidsfotos.rows.length; i++) {
            listaIdFotosOrden.fotosOrden.add(
              FotosOrden(posicion: i, idFoto: listaidsfotos.rows[i].value),
            );
          }
        }
      } else {
        debugPrintLevels(10, "*** NO HAY LISTA DE FOTOS");
        numeroDeFotos = 0;
      }
    } catch (e) {
      debugPrintLevels(10, "Error cargando metadatos: $e");
      numeroDeFotos = 0;
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrintLevels(1, "* PaginaCarouselFotosMini build");

    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      key: scaffoldKeyCarouselFotos,
      body: FutureBuilder<void>(
        future: _futureMetaData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: stateWaiting(
                widthCuadroFotoPropiedadLocal,
                heightCuadroFotoPropiedadLocal,
              ),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: stateErrorFormat(
                widthCuadroFotoPropiedadLocal,
                heightCuadroFotoPropiedadLocal,
                snapshot.error.toString(),
              ),
            );
          }

          return Center(
            child: Container(
              color: appTheme.onSecondary,
              alignment: Alignment.topCenter,
              width: widthCuadroFotoPropiedadLocal,
              padding: const EdgeInsets.all(4),
              child: (numeroDeFotos == 0)
                  ? _buildSinFotos()
                  : Column(
                      children: [
                        // CORRECCIÓN: Usamos CarouselSlider en lugar de CarouselView
                        Container(
                          width: widthCuadroFotoPropiedadLocal,
                          height: heightCuadroFotoPropiedadLocal,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: CarouselSlider.builder(
                            itemCount: numeroDeFotos,
                            carouselController: controllerCarousel,
                            itemBuilder:
                                (
                                  BuildContext context,
                                  int index,
                                  int realIndex,
                                ) {
                                  return _buildCarouselItem(index);
                                },
                            options: CarouselOptions(
                              height: heightCuadroFotoPropiedadLocal,
                              viewportFraction: 1.0, // Ocupa todo el ancho
                              enableInfiniteScroll:
                                  false, // Evita scroll infinito para controlar botones
                              initialPage: indiceFotos,
                              scrollPhysics: const BouncingScrollPhysics(),
                              onPageChanged: (index, reason) {
                                // Sincronizamos el indice si el usuario desliza con el dedo
                                setState(() {
                                  indiceFotos = index;
                                });
                              },
                            ),
                          ),
                        ),
                        SizedBox(height: 3),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: buildButtons(indiceFotos, numeroDeFotos),
                        ),
                      ],
                    ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSinFotos() {
    return Container(
      width: widthCuadroFotoPropiedadLocal,
      height: heightCuadroFotoPropiedadLocal,
      decoration: BoxDecoration(
        color: appTheme.outline,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Text(
              "No se encontró foto",
              style: TextStyle(fontSize: 14, color: appTheme.onPrimary),
            ),
          ),
          const SizedBox(height: 10),
          IconButton(
            icon: const Icon(Symbols.fullscreen),
            iconSize: 20,
            color: appTheme.onPrimary,
            tooltip: 'Datos de la propiedad',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      PaginaDetalleWidget(propiedad, listaidsfotos),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCarouselItem(int index) {
    final String currentIdFoto = listaIdFotosOrden.fotosOrden[index].idFoto;

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          AppRoutes.fotospropiedad,
          arguments: propiedad,
        );
      },
      child: Container(
        width: widthCuadroFotoPropiedadLocal, // Asegura ancho completo
        alignment: Alignment.topCenter,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
        child: FutureBuilder<String>(
          future: recuperaFotoPorIdFoto(currentIdFoto),
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return stateWaiting(
                widthCuadroFotoPropiedadLocal,
                heightCuadroFotoPropiedadLocal,
              );
            }

            if (snapshot.hasError ||
                !snapshot.hasData ||
                snapshot.data!.isEmpty) {
              return Center(
                child: Text(
                  "Error",
                  style: TextStyle(color: appTheme.error, fontSize: 10),
                ),
              );
            }

            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                image: DecorationImage(
                  image: MemoryImage(base64Decode(snapshot.data!)),
                  fit: BoxFit.cover,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget buildButtons(int actualIndex, int pointsnumber) {
    return Container(
      width: widthCuadroFotoPropiedadLocal,
      height: 25,
      alignment: Alignment.topCenter,
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              alignment: Alignment.center,
              child: IconButton(
                style: (indiceFotos == 0)
                    ? ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll<Color>(
                          appTheme.onPrimary,
                        ),
                      )
                    : ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll<Color>(
                          appTheme.primary,
                        ),
                      ),
                alignment: Alignment.center,
                icon: const Icon(Symbols.arrow_back),
                padding: EdgeInsets.zero,
                iconSize: 16,
                color: appTheme.onPrimary,
                disabledColor: appTheme.onPrimary,
                tooltip: 'anterior',
                onPressed: (indiceFotos == 0)
                    ? null
                    : () {
                        if (numeroDeFotos > 0 && (indiceFotos - 1) >= 0) {
                          // CORRECCIÓN: Usamos jumpToPage
                          controllerCarousel.jumpToPage(indiceFotos - 1);
                          // El setState se llamará automáticamente en onPageChanged
                        }
                      },
              ),
            ),
          ),

          Expanded(
            flex: 5,
            child: Container(
              alignment: Alignment.center,
              child: Center(
                child: Text(
                  "${indiceFotos + 1}/$numeroDeFotos",
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: appTheme.primary,
                  ),
                ),
              ),
            ),
          ),

          Expanded(
            flex: 1,
            child: Container(
              alignment: Alignment.center,
              child: IconButton(
                style: (indiceFotos == (numeroDeFotos - 1))
                    ? ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll<Color>(
                          appTheme.onPrimary,
                        ),
                      )
                    : ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll<Color>(
                          appTheme.primary,
                        ),
                      ),
                icon: const Icon(Symbols.arrow_forward),
                padding: EdgeInsets.zero,
                iconSize: 16,
                alignment: Alignment.center,
                color: appTheme.onPrimary,
                disabledColor: appTheme.onPrimary,
                tooltip: 'siguiente',
                onPressed: (indiceFotos == (numeroDeFotos - 1))
                    ? null
                    : () {
                        if (numeroDeFotos > 0 &&
                            (indiceFotos + 1) < numeroDeFotos) {
                          // CORRECCIÓN: Usamos jumpToPage
                          controllerCarousel.jumpToPage(indiceFotos + 1);
                          // El setState se llamará automáticamente en onPageChanged
                        }
                      },
              ),
            ),
          ),

          Expanded(
            flex: 1,
            child: Container(
              width: 20,
              alignment: Alignment.center,
              child: PopupMenuButton<String>(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Icon(
                    Symbols.more_vert_rounded,
                    size: 20,
                    color: appTheme.onPrimaryContainer,
                  ),
                ),
                tooltip: 'Opciones',
                color: appTheme.secondary,
                iconSize: 20,
                elevation: 10,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(9.0),
                  side: BorderSide(color: appTheme.secondary, width: 1),
                ),
                offset: const Offset(0, 30),
                onSelected: (value) {
                  if (value == "ficha") {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            PaginaDetalleWidget(propiedad, listaidsfotos),
                      ),
                    );
                  } else if (value == "fotos") {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.fotospropiedad,
                      arguments: propiedad,
                    );
                  }
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                  PopupMenuItem<String>(
                    value: "ficha",
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Icon(
                            Symbols.fullscreen,
                            color: appTheme.onSecondary,
                          ),
                        ),
                        Text(
                          'Ficha',
                          style: TextStyle(
                            fontSize: 12,
                            color: appTheme.onSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  PopupMenuItem<String>(
                    value: "fotos",
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Icon(
                            Symbols.view_comfy_alt,
                            color: appTheme.onSecondary,
                          ),
                        ),
                        Text(
                          'Fotos',
                          style: TextStyle(
                            fontSize: 12,
                            color: appTheme.onSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  PopupMenuItem<String>(
                    value: "guardar",
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Icon(
                            Symbols.playlist_add,
                            color: appTheme.onSecondary,
                          ),
                        ),
                        Text(
                          'Guardar',
                          style: TextStyle(
                            fontSize: 12,
                            color: appTheme.onSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
//------------------------------------------------------------------------------
/*
class PaginaCarouselFotosMini extends ConsumerStatefulWidget {
  final ValueEspaciosCasaGet valueespaciosparameter;
  /*
EL PARAMETRO SE PASA DE LA PROPIEDAD GENERADA EN LA LISTA
ValueEspaciosCasaGet =
  String id;
  String rev;
  EspaciosCasa espacioscasa;
*/
  const PaginaCarouselFotosMini(this.valueespaciosparameter, {super.key});

  @override
  // ignore: library_private_types_in_public_api
  ConsumerState<PaginaCarouselFotosMini> createState() =>
      PaginaCarouselFotosMiniState();
}

class PaginaCarouselFotosMiniState
    extends ConsumerState<PaginaCarouselFotosMini> {
  //late PerfilModel _model;

  final scaffoldKeyCarouselFotos = GlobalKey<ScaffoldState>();
  String idUsuario = "";
  String idPropiedad = "";
  String nombrePropiedad = "";
  int indiceFotos = 0;
  int numeroDeFotos = 0;

  String fotoprincipal = "";

  var controllerCarousel = CarouselController();

  late Future<CuentaFotos> _numeroDeImagenesIdUserPropiedad;
  late Future<GetIdsFotosUserProp> _recuperaIdsFotosDePropiedades;
  late Future<int> _recuperaFotosOrdenadasIdProperty;

  late ValueEspaciosCasaGet propiedad;

  // GUARDA LA LISTA DE IDS DE LAS FOTOS EN LA LISTA DE LA PROPIEDAD
  /*
  GetIdsFotosUserProp listaIdFotos =
      GetIdsFotosUserProp(totalRows: 0, offset: 0, rows: []);
      */

  // GUARDA EL NUMERO DE FOTOS DE LA PROPIEDAD
  GetIdsFotosUserProp listaidsfotos = GetIdsFotosUserProp(
    rows: [],
    totalRows: 0,
    offset: 0,
  );
  ListaFotosOrdenadas listaIdFotosOrden = ListaFotosOrdenadas(
    idListaFotos: '',
    idUsuario: '',
    idPropiedad: '',
    fotosOrden: [],
    timestamp: '',
  );
  //---------------------
  CarouselView carouselFotos() {
    return CarouselView(
      itemExtent: double.infinity,
      shrinkExtent: 0,
      itemSnapping: false,
      scrollDirection: Axis.horizontal,
      controller: controllerCarousel,
      shape: LinearBorder(),
      onTap: (value) {
        Navigator.pushNamed(
          context,
          AppRoutes.fotospropiedad,
          // carouselfotospropiedad = PaginaCapturaFotosWidget(), pagina_carrusel_fotos_captura.dart
          arguments: propiedad,
        );
      },
      //reverse: true,
      children: [
        Container(
          alignment: Alignment.topCenter,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
          child: FutureBuilder<String>(
            // OBTIENE DE LA BD LA LISTA DE PROPIEDADES
            future: recuperaFotoPorIdFoto(
              listaIdFotosOrden.fotosOrden[indiceFotos].idFoto,
            ),
            builder: (context, snapshot) {
              debugPrintLevels(
                9,
                ">>  recuperaFotosOrdenadasIdProperty recuperaFotoPorIdFoto: ${listaIdFotosOrden.fotosOrden[indiceFotos].idFoto}",
              );
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                  return stateNone(250, 250);
                case ConnectionState.waiting:
                  return stateWaiting(
                    widthCuadroFotoPropiedadLocal,
                    heightCuadroFotoPropiedadLocal,
                  );
                case ConnectionState.active:
                  return stateActive(
                    widthCuadroFotoPropiedadLocal,
                    heightCuadroFotoPropiedadLocal,
                  );
                case ConnectionState.done:
                  if (snapshot.hasError) {
                    return stateErrorFormat(
                      widthCuadroFotoPropiedadLocal,
                      heightCuadroFotoPropiedadLocal,
                      snapshot.error,
                    );
                  } else {
                    debugPrintLevels(
                      9,
                      "FutureBuilder recuperaFotosOrdenadasIdProperty: done",
                    );
                    fotoprincipal = snapshot.data!;
                    return (snapshot.data! == "")
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Center(
                                child: Text(
                                  "No se encontro foto",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: appTheme.onPrimary,
                                  ),
                                ),
                              ),
                              SizedBox(height: 10),
                              IconButton(
                                icon: const Icon(Symbols.fullscreen),
                                iconSize: 20,
                                splashRadius: 1,
                                color: appTheme.onPrimary,
                                tooltip: 'Datos de la propiedad',
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => PaginaDetalleWidget(
                                        propiedad,
                                        listaidsfotos,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          )
                        : Container(
                            width: 350,
                            height: 200,
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 1,
                                color: appTheme.outlineVariant,
                              ),
                              borderRadius: BorderRadius.circular(15),
                              image: DecorationImage(
                                image: MemoryImage(base64Decode(fotoprincipal)),
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                  }
              }
            },
          ),
        ),
      ],
    );
  }

  //-----------------
  @override
  void initState() {
    debugPrintLevels(9, "****************************************");
    debugPrintLevels(9, "* PaginaCarouselFotosMini initState");
    debugPrintLevels(9, "****************************************");

    // GUARDA LA LISTA DE IDS DE LAS FOTOS EN LA LISTA DE LA PROPIEDAD
    GetIdsFotosUserProp(totalRows: 0, offset: 0, rows: []);
    // GUARDA EL NUMERO DE FOTOS DE LA PROPIEDAD
    /*
    parameterGestionFoto =
      "idUsuario": "",
      "idPropiedad": "",
      "idFoto": "",
      "propiedad": EspaciosCasaGet,
      "fotoprincipal": bool,
      "indice": 0,
    */
    // INICIALIZA QUE NO ES LA FOTO PRINCIPAL Y parameterGestionFoto

    idUsuario = widget.valueespaciosparameter.espacioscasa.idusuario;
    idPropiedad = widget.valueespaciosparameter.espacioscasa.idPropiedad;
    nombrePropiedad =
        widget.valueespaciosparameter.espacioscasa.nombredelapropiedad;

    propiedad = widget.valueespaciosparameter;
    //  fotoPrincipal = widget.valueespaciosparameter.espacioscasa.fotoprincipal;

    debugPrintLevels(
      9,
      "PaginaCarouselFotosWidget idusuario: ${widget.valueespaciosparameter.espacioscasa.idusuario}",
    );
    debugPrintLevels(
      9,
      "PaginaCarouselFotosWidget idPropiedad: ${widget.valueespaciosparameter.espacioscasa.idPropiedad}",
    );

    debugPrintLevels(9, "* PaginaCarouselFotosMini initState end");

    // GENERA VARIABLES DE LOS PROVIDERS NUMERO DE IMAGENES Y IDS DE LAS FOTOS
    _numeroDeImagenesIdUserPropiedad = numeroDeImagenesIdUserPropiedad(
      ref,
      idUsuario,
      idPropiedad,
    );
    _recuperaIdsFotosDePropiedades = recuperaIdsFotosDePropiedades(
      idUsuario,
      idPropiedad,
    );
    _recuperaFotosOrdenadasIdProperty = recuperaFotosOrdenadasIdProperty(
      ref,
      idPropiedad,
    );

    super.initState();
  }

  //-----------------------------------------------------------------------------
  @override
  void didChangeDependencies() {
    debugPrintLevels(1, " PaginaCarouselFotosMini didChangeDependencies");
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(covariant PaginaCarouselFotosMini oldWidget) {
    debugPrintLevels(1, " PaginaCarouselFotosMini didUpdateWidget");
    super.didUpdateWidget(oldWidget);
  }

  @override
  void deactivate() {
    debugPrintLevels(1, " PaginaCarouselFotosMini deactivate");
    super.deactivate();
  }

  @override
  void dispose() {
    debugPrintLevels(1, " PaginaCarouselFotosMini dispose");
    // controllerCarousel.dispose();
    super.dispose();
  }

  //-----------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    //  debugPrintLevels(1, "****************************************");
    debugPrintLevels(1, "* PaginaCarouselFotosMini build");
    //  debugPrintLevels(1, "****************************************");

    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: FutureBuilder<CuentaFotos>(
        // OBTIENE EL NUMERO DE FOTOS DE LA PROPIEDAD Y EL USUARIO
        future: _numeroDeImagenesIdUserPropiedad,
        builder: (context, snapshotNumImagenes) {
          switch (snapshotNumImagenes.connectionState) {
            case ConnectionState.none:
              return stateNone(
                widthCuadroFotoPropiedadLocal,
                heightCuadroFotoPropiedadLocal,
              );
            case ConnectionState.waiting:
              return stateWaiting(
                widthCuadroFotoPropiedadLocal,
                heightCuadroFotoPropiedadLocal,
              );
            case ConnectionState.active:
              return stateActive(
                widthCuadroFotoPropiedadLocal,
                heightCuadroFotoPropiedadLocal,
              );
            case ConnectionState.done:
              if (snapshotNumImagenes.hasError) {
                return stateErrorFormat(
                  widthCuadroFotoPropiedadLocal,
                  heightCuadroFotoPropiedadLocal,
                  snapshotNumImagenes.error,
                );
              } else {
                // CHECA QUE LA LISTA NO ESTE VACIA
                if (snapshotNumImagenes.data!.rows.isEmpty) {
                  debugPrintLevels(9, "** numero de fotos vacio");
                  numeroDeFotos = 0;
                } else {
                  debugPrintLevels(
                    9,
                    "** numero de fotos recuperadas: ${snapshotNumImagenes.data!.rows[0].value}",
                  );
                  numeroDeFotos = snapshotNumImagenes.data!.rows[0].value;
                }
                // REGRESA LA ESTRUCTURA CUENTAFOTOS
                // INICITALIZA CONTROLADOR CAROUSEL
                controllerCarousel.initialItem;
                controllerCarousel.initialScrollOffset;
                // GENERA UNA LISTA CON SCROLL
                // GENERA CONTENEDOR DE LA FOTO EN EL CAROUSEL
                return Center(
                  child: Container(
                    color: appTheme.onSecondary,
                    alignment: Alignment.topCenter,
                    width: widthCuadroFotoPropiedadLocal,
                    padding: EdgeInsets.all(4),
                    // height: heightCuadroFotoPropiedadLocal,
                    child: (numeroDeFotos == 0)
                        ? // CASO: LA LISTA ESTA SIN FOTOS
                          Container(
                            width: widthCuadroFotoPropiedadLocal,
                            height: heightCuadroFotoPropiedadLocal,
                            decoration: BoxDecoration(
                              color: appTheme.outline,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Center(
                                  child: Text(
                                    "No se encontro foto",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: appTheme.onPrimary,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 10),
                                IconButton(
                                  icon: const Icon(Symbols.fullscreen),
                                  iconSize: 20,
                                  splashRadius: 1,
                                  color: appTheme.onPrimary,
                                  tooltip: 'Datos de la propiedad',
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            PaginaDetalleWidget(
                                              propiedad,
                                              listaidsfotos,
                                            ),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          )
                        : // CASO: LISTA CON FOTOS  -> BUSCA FOTOS ORDENADAS
                          Column(
                            //alignment: Alignment.center,
                            children: [
                              Container(
                                width: widthCuadroFotoPropiedadLocal,
                                height: heightCuadroFotoPropiedadLocal,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: FutureBuilder<GetIdsFotosUserProp>(
                                  //future: _recuperaIdsFotosDePropiedades,
                                  future: recuperaIdsFotosDePropiedades(
                                    idUsuario,
                                    idPropiedad,
                                  ),
                                  builder: (context, snapshotIdFotos) {
                                    switch (snapshotIdFotos.connectionState) {
                                      case ConnectionState.none:
                                        return stateNone(
                                          widthCuadroFotoPropiedadLocal,
                                          heightCuadroFotoPropiedadLocal,
                                        );
                                      case ConnectionState.waiting:
                                        return stateWaiting(
                                          widthCuadroFotoPropiedadLocal,
                                          heightCuadroFotoPropiedadLocal,
                                        );
                                      case ConnectionState.active:
                                        return stateActive(
                                          widthCuadroFotoPropiedadLocal,
                                          heightCuadroFotoPropiedadLocal,
                                        );
                                      case ConnectionState.done:
                                        if (snapshotIdFotos.hasError) {
                                          return stateErrorFormat(
                                            widthCuadroFotoPropiedadLocal,
                                            heightCuadroFotoPropiedadLocal,
                                            snapshotIdFotos.error,
                                          );
                                        } else {
                                          listaidsfotos = snapshotIdFotos.data!;
                                          debugPrintLevels(
                                            9,
                                            "************* FutureBuilder _recuperaIdsFotosDePropiedades length: ${listaidsfotos.rows.length}",
                                          );
                                          //CASO LISTA VACIA
                                          if (listaidsfotos.rows.isEmpty) {
                                            return Expanded(
                                              child: Center(
                                                child: Text(
                                                  "No se encotraron fotos",
                                                ),
                                              ),
                                            );
                                          } else {
                                            // CASO LISTA CON DATOS
                                            // BUSCA LA LISTA DE FOTOS ORDENADAS

                                            return FutureBuilder<int>(
                                              // future:_recuperaFotosOrdenadasIdProperty,
                                              future:
                                                  recuperaFotosOrdenadasIdProperty(
                                                    ref,
                                                    idPropiedad,
                                                  ),
                                              builder: (context, snapshotOrdenFotos) {
                                                switch (snapshotOrdenFotos
                                                    .connectionState) {
                                                  case ConnectionState.none:
                                                    return stateNone(
                                                      widthCuadroFotoPropiedadLocal,
                                                      heightCuadroFotoPropiedadLocal,
                                                    );
                                                  case ConnectionState.waiting:
                                                    return stateWaiting(
                                                      widthCuadroFotoPropiedadLocal,
                                                      heightCuadroFotoPropiedadLocal,
                                                    );
                                                  case ConnectionState.active:
                                                    return stateActive(
                                                      widthCuadroFotoPropiedadLocal,
                                                      heightCuadroFotoPropiedadLocal,
                                                    );
                                                  case ConnectionState.done:
                                                    if (snapshotOrdenFotos
                                                        .hasError) {
                                                      return stateErrorFormat(
                                                        widthCuadroFotoPropiedadLocal,
                                                        heightCuadroFotoPropiedadLocal,
                                                        snapshotOrdenFotos
                                                            .error,
                                                      );
                                                    } else {
                                                      debugPrintLevels(
                                                        9,
                                                        "******* FutureBuilder _recuperaListaFotosOrden length: ${ref.read(getListaFotosOrdenadasProvider).rows.length}",
                                                      );
                                                      int? resultado =
                                                          snapshotOrdenFotos
                                                              .data;
                                                      // CHECA
                                                      // SI HAY LISTA ORDENADA,
                                                      // SI NO HAY ERROR Y
                                                      // SI LA LONG DE LISTAS ES IGUAL
                                                      if ((resultado != 200) ||
                                                          (ref
                                                              .read(
                                                                getListaFotosOrdenadasProvider,
                                                              )
                                                              .rows
                                                              .isEmpty)) {
                                                        // NO TIENE LISTA ORDENADA
                                                        // LIMPIA LISTA ORDENADA
                                                        // CREA LA LISTA ORDENADA CON LA LISTA DE IDS
                                                        debugPrintLevels(
                                                          9,
                                                          "********** CASO: NO TIENE LISTA ORDENADA, ERROR, DIFERENTE LONG",
                                                        );
                                                        listaIdFotosOrden
                                                                .idPropiedad =
                                                            listaidsfotos
                                                                .rows[0]
                                                                .key[1];
                                                        listaIdFotosOrden
                                                                .idUsuario =
                                                            listaidsfotos
                                                                .rows[0]
                                                                .key[0];
                                                        listaIdFotosOrden
                                                            .fotosOrden
                                                            .clear();
                                                        for (
                                                          var i = 0;
                                                          i <
                                                              listaidsfotos
                                                                  .rows
                                                                  .length;
                                                          i++
                                                        ) {
                                                          listaIdFotosOrden
                                                              .fotosOrden
                                                              .add(
                                                                FotosOrden(
                                                                  posicion: i,
                                                                  idFoto:
                                                                      listaidsfotos
                                                                          .rows[i]
                                                                          .value,
                                                                ),
                                                              );
                                                        }
                                                        //------------------------------------------------------
                                                        // GENERA CONTENEDOR DE LA LISTA DE FOTOS
                                                        //  botonReloadActive = true;
                                                        // DESDE LA LISTA ORDENADA
                                                        debugPrintLevels(
                                                          9,
                                                          "NUMERO DE IDS ORDENADOS DE FOTOS RECUPERADOS recuperaFotosOrdenadasIdProperty: ${listaIdFotosOrden.fotosOrden.length}",
                                                        );
                                                      } else {
                                                        // SIN ERROR LA BUSQUEDA Y
                                                        // CASO: LISTA ORDENADA NO VACIA
                                                        listaIdFotosOrden = ref
                                                            .read(
                                                              getListaFotosOrdenadasProvider,
                                                            )
                                                            .rows[0]
                                                            .value
                                                            .listadefotos;
                                                        debugPrintLevels(
                                                          9,
                                                          "NUMERO DE IDS ORDENADOS DE FOTOS RECUPERADOS recuperaFotosOrdenadasIdProperty: ${listaIdFotosOrden.fotosOrden.length}",
                                                        );
                                                      }
                                                    }
                                                }
                                                return carouselFotos();
                                              },
                                            );
                                          }
                                        }
                                    }
                                  },
                                ),
                              ),
                              // Barra de datos de la imagen -----------------------
                              // BOTONES EN LA FOTO
                              Align(
                                alignment: Alignment.bottomCenter,
                                child: (numeroDeFotos > 0)
                                    ? buildButtons(indiceFotos, numeroDeFotos)
                                    : const SizedBox(height: 0),
                              ),
                            ],
                          ),
                  ),
                );
              }
          }
        },
      ),
    );
  }

  Widget buildPagination(int actualIndex, int pointsnumber) {
    return AnimatedSmoothIndicator(
      activeIndex: actualIndex,
      count: pointsnumber,
      onDotClicked: (index) {
        debugPrintLevels(20, "Dot clicked: index = $index");
        controllerCarousel.jumpTo(index.truncateToDouble());
        indiceFotos = index;
        setState(() {});
      },
      effect: ScaleEffect(
        dotWidth: 8,
        dotHeight: 8,
        dotColor: appTheme.outline,
        activeDotColor: appTheme.primary,
      ),
    );
  }

  Widget buildButtons(int actualIndex, int pointsnumber) {
    return Container(
      width: widthCuadroFotoPropiedadLocal,
      height: 25,
      //color: Colors.black.withValues(alpha: 0.3),
      //padding: EdgeInsets.all(3),
      alignment: Alignment.topCenter,
      child: Row(
        //  mainAxisSize: MainAxisSize.max,
        //  mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 1,
            child: Container(
              alignment: Alignment.center,
              child: IconButton(
                style: (indiceFotos == 0)
                    ? ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll<Color>(
                          appTheme.onPrimary,
                        ),
                      )
                    : ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll<Color>(
                          appTheme.primary,
                        ),
                      ),
                alignment: Alignment.center,
                icon: const Icon(Symbols.arrow_back),
                padding: EdgeInsets.zero,
                iconSize: 16,
                // splashRadius: 1,
                color: appTheme.onPrimary,
                disabledColor: appTheme.onPrimary,
                tooltip: 'anterior',
                onPressed: (indiceFotos == 0)
                    ? null
                    : () {
                        if (numeroDeFotos > 0) {
                          // controllerCarousel.position;
                          if ((indiceFotos - 1) >= 0) {
                            indiceFotos = indiceFotos - 1;
                          }
                          controllerCarousel.jumpTo(
                            indiceFotos.roundToDouble(),
                          );

                          debugPrintLevels(
                            9,
                            "setState Buttom: index-pos: $indiceFotos, ${controllerCarousel.offset}",
                          );
                          setState(() {});
                        }
                      },
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: Container(
              alignment: Alignment.center,
              child: Center(
                child: Text(
                  "${indiceFotos + 1}/$numeroDeFotos",
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: appTheme.primary,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              alignment: Alignment.center,
              child: IconButton(
                style: (indiceFotos == (numeroDeFotos - 1))
                    ? ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll<Color>(
                          appTheme.onPrimary,
                        ),
                      )
                    : ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll<Color>(
                          appTheme.primary,
                        ),
                      ),
                icon: const Icon(Symbols.arrow_forward),
                padding: EdgeInsets.zero,
                iconSize: 16,
                alignment: Alignment.center,
                // splashRadius: 1,
                color: appTheme.onPrimary,
                disabledColor: appTheme.onPrimary,
                tooltip: 'siguiente',
                onPressed: (indiceFotos == (numeroDeFotos - 1))
                    ? null
                    : () {
                        if (numeroDeFotos > 0) {
                          // controllerCarousel.nextPage();
                          if ((indiceFotos + 1) < numeroDeFotos) {
                            indiceFotos = indiceFotos + 1;
                          }
                          controllerCarousel.jumpTo(
                            indiceFotos.roundToDouble(),
                          );

                          debugPrintLevels(
                            9,
                            "setState Buttom: index-pos: $indiceFotos, ${controllerCarousel.offset}",
                          );
                          setState(() {});
                        }
                      },
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              width: 20,
              alignment: Alignment.center,
              child:
                  /*Positioned(
                bottom: 16.0,
                left: 16.0,
                child: FloatingActionButton(
                  onPressed: () {},
                  child: Icon(Symbols.menu),
                  backgroundColor: Colors.green,
                ),
              ),
             */
                  /*
                  IconButton(
                padding: EdgeInsets.zero,
                icon: const Icon(Symbols.more_vert_rounded),
                iconSize: 20,
                // splashRadius: 1,
                color: appTheme.primary,
                tooltip: 'Opciones',
                onPressed: () {
                  */
                  /* PopupMenuButton(
                    color: appTheme.secondary,
                    tooltip: 'Opciones',
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: Icon(
                        Symbols.more_vert_rounded,
                        size: 20,
                        color: appTheme.onPtimary, // primary
                      ),
                    ),
                    onSelected: (value) {
                      if (value == "ficha") {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                PaginaDetalleWidget(propiedad, listaidsfotos),
                          ),
                        );
                      } else if (value == "fotos") {
                        Navigator.pushNamed(
                          context,
                          AppRoutes.fotospropiedad,
                          // pagina_fotos_propiedad.dart
                          // PaginaFotosPropiedad
                          arguments: propiedad,
                        );
                      } else if (value == "guardar") {
                        // add desired output
                      }
                    },*/
                  PopupMenuButton(
                    // 1. Estilo del Icono disparador
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: Icon(
                        Symbols.more_vert_rounded,
                        size: 20,
                        color: appTheme.onPrimaryContainer, // primary
                      ),
                    ),
                    tooltip: 'Opciones',
                    // icon: Icon(
                    //   Symbols.more_vert_rounded,
                    //   color: appTheme.primary, // primary
                    // ),
                    // 2. Estilo del "Cajón" del menú (Fondo y forma)
                    color: appTheme.secondary, // Color de fondo del menú
                    iconSize: 20,
                    elevation: 10, // Sombra
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        9.0,
                      ), // Bordes redondeados
                      side: BorderSide(
                        color: appTheme.secondary,
                        width: 1,
                      ), // Borde opcional
                    ),
                    // 3. Posición (Desplazamiento)
                    // Mueve el menú hacia abajo para que no tape el botón
                    offset: const Offset(0, 30),
                    onSelected: (value) {
                      if (value == "ficha") {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                PaginaDetalleWidget(propiedad, listaidsfotos),
                          ),
                        );
                      } else if (value == "fotos") {
                        Navigator.pushNamed(
                          context,
                          AppRoutes.fotospropiedad,
                          // pagina_fotos_propiedad.dart
                          // PaginaFotosPropiedad
                          arguments: propiedad,
                        );
                      } else if (value == "guardar") {
                        // add desired output
                      }
                    },
                    itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                      PopupMenuItem(
                        value: "ficha",
                        child: SizedBox(
                          width: 89,
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                  5.0,
                                  5.0,
                                  5.0,
                                  5.0,
                                ),
                                child: Icon(
                                  Symbols.fullscreen,
                                  color: appTheme.onSecondary,
                                ),
                              ),
                              Text(
                                'Ficha',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.normal,
                                  color: appTheme.onSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      PopupMenuItem(
                        value: "fotos",
                        child: SizedBox(
                          width: 89,
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                  5.0,
                                  5.0,
                                  5.0,
                                  5.0,
                                ),
                                child: Icon(
                                  Symbols.view_comfy_alt,
                                  color: appTheme.onSecondary,
                                ),
                              ),
                              Text(
                                'Fotos',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.normal,
                                  color: appTheme.onSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      PopupMenuItem(
                        value: "guardar",
                        child: SizedBox(
                          width: 89,
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                  5.0,
                                  5.0,
                                  5.0,
                                  5.0,
                                ),
                                child: Icon(
                                  Symbols.playlist_add,
                                  color: appTheme.onSecondary,
                                ),
                              ),
                              Text(
                                'Guardar',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.normal,
                                  color: appTheme.onSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
            ),
            //   },
            //   ),
          ),
        ],
      ),
    );
  }
}
*/
