import 'dart:convert';

import 'package:buscobien/07_routes/routes_parameters.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';
import '../../../../07_routes/app_routes.dart';
import '../../../../60_global_widgets/future_builder_state_widgets.dart';
import '../../../../60_global_widgets/debugprint.dart';
import '../../../data_models/data_fotos_ordenadas.dart';
import '../../../variables_imagenes.dart';
import '../futures_y_providers/future_get_fotos_by_idpr_orden.dart';
import '../lista_fotos_ordenadas/provider_get_lista_fotos_ordenadas.dart';
import '../lista_ids_fotos/data_fotos_get_ids_fotos_user_prop.dart';
import '../../../../20_var_globales/var_color_themes.dart';
import '../../../../20_var_globales/var_color_widget.dart';
import '../../../../20_var_globales/variables_globales.dart';
import '../../../../08_pantallas/inicio/data_espacios_casas_get.dart';

import '../futures_y_providers/http_funciones_gestion_foto.dart';
import '../futures_y_providers/future_recupera_ids_fotos_propiedad.dart';

// OPTIMIZADO

import 'package:carousel_slider/carousel_slider.dart'; // NECESARIO

class PaginaCarouselFotosWidget extends ConsumerStatefulWidget {
  final ValueEspaciosCasaGet valueespaciosparameter;

  const PaginaCarouselFotosWidget(this.valueespaciosparameter, {super.key});

  @override
  ConsumerState<PaginaCarouselFotosWidget> createState() =>
      PaginaCarouselFotosWidgetState();
}

class PaginaCarouselFotosWidgetState
    extends ConsumerState<PaginaCarouselFotosWidget> {
  final scaffoldKeyListaFotos = GlobalKey<ScaffoldState>();
  String idUsuario = "";
  String idPropiedad = "";
  String nombrePropiedad = "";
  int indiceFotos = 0;
  int numeroDeFotos = 0;

  // Usamos CarouselSliderController para mayor control
  final CarouselSliderController controllerCarousel =
      CarouselSliderController();

  // Futuro unificado para cargar orden y datos
  late Future<void> _futureCargaDatos;

  // Estructura principal para manejar las fotos (Ordenada)
  ListaFotosOrdenadas listaIdFotosOrden = ListaFotosOrdenadas(
    idListaFotos: '',
    idUsuario: '',
    idPropiedad: '',
    fotosOrden: [],
    timestamp: '',
  );

  // Respaldo de IDs crudos
  GetIdsFotosUserProp listaIdsCrudos = GetIdsFotosUserProp(
    totalRows: 0,
    offset: 0,
    rows: [],
  );

  @override
  void initState() {
    debugPrintLevels(9, "* PaginaCarouselFotosWidget initState");

    // Inicialización de variables locales
    final espacios = widget.valueespaciosparameter.espacioscasa;
    idUsuario = espacios.idusuario;
    idPropiedad = espacios.idPropiedad;
    nombrePropiedad = espacios.nombredelapropiedad;

    // Inicializar parámetros de gestión
    parameterGestionFoto.addAll({
      "idUsuario": idUsuario,
      "idPropiedad": idPropiedad,
      "idFoto": espacios.fotoprincipal,
      "propiedad": widget.valueespaciosparameter,
      "fotoprincipal": espacios.fotoprincipal,
      "indice": 0,
    });

    // Cargar datos (IDs y Orden)
    _futureCargaDatos = _cargarDatosYOrden();

    super.initState();
  }

  /// Lógica centralizada para obtener IDs y luego el Orden
  Future<void> _cargarDatosYOrden() async {
    try {
      // 1. Obtener IDs crudos (para saber cuántas hay y validar)
      listaIdsCrudos = await recuperaIdsFotosDePropiedades(
        idUsuario,
        idPropiedad,
      );

      if (listaIdsCrudos.rows.isEmpty) {
        numeroDeFotos = 0;
        return;
      }

      numeroDeFotos = listaIdsCrudos.rows.length;

      // 2. Intentar obtener el orden guardado
      final statusOrden = await recuperaFotosOrdenadasIdProperty(
        ref,
        idPropiedad,
      );
      final listaOrdenProvider = ref.read(getListaFotosOrdenadasProvider);

      bool usarOrdenGuardado = false;

      // Validamos si la petición fue exitosa y si la lista tiene datos
      if (statusOrden == 200 && listaOrdenProvider.rows.isNotEmpty) {
        // Validamos integridad: ¿El número de fotos ordenadas coincide con las reales?
        // Si difieren, es mejor usar los IDs crudos para evitar errores de índice.
        if (listaOrdenProvider.rows[0].value.listadefotos.fotosOrden.length ==
            numeroDeFotos) {
          usarOrdenGuardado = true;
        }
      }

      if (usarOrdenGuardado) {
        debugPrintLevels(9, "Usando Lista Ordenada Guardada");
        listaIdFotosOrden = listaOrdenProvider.rows[0].value.listadefotos;
      } else {
        debugPrintLevels(9, "Usando Lista Cruda (Generando Orden Default)");
        // Generamos una estructura de orden "al vuelo" basada en los IDs crudos
        listaIdFotosOrden = ListaFotosOrdenadas(
          idListaFotos: '',
          idUsuario: idUsuario,
          idPropiedad: idPropiedad,
          fotosOrden: [],
          timestamp: '',
        );

        for (var i = 0; i < listaIdsCrudos.rows.length; i++) {
          listaIdFotosOrden.fotosOrden.add(
            FotosOrden(posicion: i, idFoto: listaIdsCrudos.rows[i].value),
          );
        }
      }
    } catch (e) {
      debugPrintLevels(0, "Error cargando datos: $e");
      numeroDeFotos = 0;
    }
  }

  @override
  void dispose() {
    debugPrintLevels(1, " PaginaCarouselFotosWidget dispose");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrintLevels(9, "* PaginaCarouselFotosWidget build");

    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: FutureBuilder<void>(
        future: _futureCargaDatos,
        builder: (context, snapshot) {
          // ESTADOS DE CARGA Y ERROR
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Text(
                "",
                style: TextStyle(color: appTheme.primary, fontSize: 14),
              ),
            );
          }
          if (snapshot.hasError) {
            return stateErrorFormat(
              widthCuadroFotoPropiedad,
              heightCuadroFotoPropiedad,
              snapshot.error.toString(),
            );
          }

          // CONTENIDO PRINCIPAL
          return SingleChildScrollView(
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                const SizedBox(height: 10),

                // TITULO
                Text(
                  'Fotos de la propiedad: $numeroDeFotos',
                  style: TextStyle(
                    color: appTheme.primary,
                    fontSize: fontSizeSubtituloPagina,
                    fontWeight: FontWeight.bold,
                    fontFamily: "Comfortaa",
                  ),
                ),
                const SizedBox(height: 10),

                // AREA DEL CAROUSEL
                Center(
                  child: SizedBox(
                    height: (screenHeight > screenWidth)
                        ? screenWidth / 1.6
                        : screenHeight * 0.65,
                    width: (screenHeight > screenWidth)
                        ? screenWidth * 1
                        : screenHeight * 1.6,
                    child: (numeroDeFotos == 0)
                        ? _buildBotonAgregarFoto(context)
                        : _buildCarouselSlider(),
                  ),
                ),

                const SizedBox(height: 10),

                // BOTONES DE NAVEGACIÓN
                (numeroDeFotos > 0)
                    ? buildButtons()
                    : const SizedBox(height: 1),

                const SizedBox(height: 30),
              ],
            ),
          );
        },
      ),
    );
  }

  // Widget para el Carousel Slider (Lista Ordenada)
  Widget _buildCarouselSlider() {
    return CarouselSlider.builder(
      carouselController: controllerCarousel,
      itemCount: numeroDeFotos,
      itemBuilder: (BuildContext context, int index, int realIndex) {
        // Obtenemos el ID de la foto basándonos en la lista ordenada
        final String idFotoActual = listaIdFotosOrden.fotosOrden[index].idFoto;
        return _buildFotoItem(idFotoActual, index);
      },
      options: CarouselOptions(
        // Ocupa toda la altura del contenedor padre
        aspectRatio: (screenHeight > screenWidth) ? 16 / 9 : 4 / 3,
        viewportFraction: 1.0, // Una foto a la vez
        initialPage: indiceFotos,
        enableInfiniteScroll:
            false, // Importante para controlar botones next/prev manualmente
        scrollPhysics: const BouncingScrollPhysics(),
        onPageChanged: (index, reason) {
          // Sincronizamos el índice cuando el usuario desliza con el dedo
          setState(() {
            indiceFotos = index;
          });
        },
      ),
    );
  }

  // Widget individual para cada foto (Lazy Loading)
  Widget _buildFotoItem(String idFoto, int index) {
    return GestureDetector(
      onTap: () {
        _navegarAGestionFotos(context, index, idFoto);
      },
      child: FutureBuilder<String>(
        future: recuperaFotoPorIdFoto(idFoto),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return stateWaiting(
              widthCuadroFotoPropiedad,
              heightCuadroFotoPropiedad,
            );
          }
          if (snapshot.hasError ||
              !snapshot.hasData ||
              snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                "No se encontró foto",
                style: TextStyle(fontSize: 12, color: appTheme.error),
              ),
            );
          }

          return Container(
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              image: DecorationImage(
                image: MemoryImage(base64Decode(snapshot.data!)),
                fit: BoxFit.contain, // Ajuste para ver la foto completa
              ),
            ),
          );
        },
      ),
    );
  }

  // Botón para cuando no hay fotos
  Widget _buildBotonAgregarFoto(BuildContext context) {
    return Container(
      color: appTheme.onSecondary,
      alignment: Alignment.topCenter,
      child: Center(
        child: InkWell(
          onTap: () => _navegarAGestionFotos(context, 0, ""),
          child: Container(
            color: appTheme.surface,
            width: 65,
            height: 65,
            child: Center(
              child: Icon(Symbols.add, size: 60, color: appTheme.primary),
            ),
          ),
        ),
      ),
    );
  }

  // Función helper para navegación
  void _navegarAGestionFotos(BuildContext context, int index, String idFoto) {
    parameterGestionFoto["idUsuario"] = idUsuario;
    parameterGestionFoto["idPropiedad"] = idPropiedad;
    parameterGestionFoto["idFoto"] = idFoto;
    parameterGestionFoto["propiedad"] = widget.valueespaciosparameter;
    parameterGestionFoto["indice"] = index;
    // Si es el índice 0, asumimos que es principal, o según lógica de negocio
    parameterGestionFoto["fotoprincipal"] = (index == 0);

    Navigator.pushNamed(
      context,
      AppRoutes.agregafotopropiedad,
      arguments: parameterGestionFoto,
    );
  }

  // Botones de control y texto indicador
  Widget buildButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // BOTON ATRAS
        ElevatedButton(
          style: ButtonStyle(
            backgroundColor: WidgetStatePropertyAll<Color>(appTheme.primary),
          ),
          child: Icon(Symbols.arrow_back, size: 18, color: appTheme.onPrimary),
          onPressed: () {
            if (numeroDeFotos > 0 && (indiceFotos - 1) >= 0) {
              // Animamos el carrusel. El setState se hace en onPageChanged
              controllerCarousel.animateToPage(
                indiceFotos - 1,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            }
          },
        ),

        // INDICADOR DE TEXTO (Foto X - Total)
        Column(
          children: [
            Text(
              '${indiceFotos + 1} - $numeroDeFotos',
              style: TextStyle(
                color: appTheme.primary,
                fontSize: 12,
                fontWeight: FontWeight.bold,
                fontFamily: "Comfortaa",
              ),
            ),
            if (indiceFotos == 0)
              Text(
                'Foto principal',
                style: TextStyle(
                  color: appTheme.primary,
                  fontSize: 10, // Un poco más pequeño
                  fontWeight: FontWeight.bold,
                  fontFamily: "Comfortaa",
                ),
              ),
          ],
        ),

        // BOTON ADELANTE
        ElevatedButton(
          style: ButtonStyle(
            backgroundColor: WidgetStatePropertyAll<Color>(appTheme.primary),
          ),
          child: Icon(
            Symbols.arrow_forward,
            size: 18,
            color: appTheme.onPrimary,
          ),
          onPressed: () {
            if (numeroDeFotos > 0 && (indiceFotos + 1) < numeroDeFotos) {
              // Animamos el carrusel. El setState se hace en onPageChanged
              controllerCarousel.animateToPage(
                indiceFotos + 1,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            }
          },
        ),
      ],
    );
  }
}

//----------------------------------------------------------------------------
/*
class PaginaCarouselFotosWidget extends ConsumerStatefulWidget {
  final ValueEspaciosCasaGet valueespaciosparameter;
  /*
EL PARAMETRO SE PASA DE LA PROPIEDAD GENERADA EN LA LISTA
ValueEspaciosCasaGet =
  String id;
  String rev;
  EspaciosCasa espacioscasa;
*/
  const PaginaCarouselFotosWidget(this.valueespaciosparameter, {super.key});

  @override
  // ignore: library_private_types_in_public_api
  ConsumerState<PaginaCarouselFotosWidget> createState() =>
      PaginaCarouselFotosWidgetState();
}

class PaginaCarouselFotosWidgetState
    extends ConsumerState<PaginaCarouselFotosWidget> {
  //late PerfilModel _model;

  final scaffoldKeyListaFotos = GlobalKey<ScaffoldState>();
  String idUsuario = "";
  String idPropiedad = "";
  String nombrePropiedad = "";
  int indiceFotos = 0;
  int numeroDeFotos = 0;

  String fotoprincipal = "";
  var controllerCarousel = CarouselController();

  late Future<CuentaFotos> _numeroDeImagenesIdUserPropiedad;
  late Future<GetIdsFotosUserProp> _recuperaIdsFotosDePropiedades;

  @override
  void initState() {
    debugPrintLevels(9, "****************************************");
    debugPrintLevels(9, "* PaginaCarouselFotosWidget initState");
    debugPrintLevels(9, "****************************************");

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
    parameterGestionFoto["idUsuario"] =
        widget.valueespaciosparameter.espacioscasa.idusuario;
    parameterGestionFoto["idPropiedad"] =
        widget.valueespaciosparameter.espacioscasa.idPropiedad;
    parameterGestionFoto["idFoto"] =
        widget.valueespaciosparameter.espacioscasa.fotoprincipal;
    parameterGestionFoto["propiedad"] = widget.valueespaciosparameter;
    parameterGestionFoto["fotoprincipal"] =
        widget.valueespaciosparameter.espacioscasa.fotoprincipal;
    parameterGestionFoto["indice"] = 0;

    idUsuario = widget.valueespaciosparameter.espacioscasa.idusuario;
    idPropiedad = widget.valueespaciosparameter.espacioscasa.idPropiedad;
    nombrePropiedad =
        widget.valueespaciosparameter.espacioscasa.nombredelapropiedad;
    //  fotoPrincipal = widget.valueespaciosparameter.espacioscasa.fotoprincipal;

    debugPrintLevels(
      9,
      "PaginaCarouselFotosWidget idusuario: ${widget.valueespaciosparameter.espacioscasa.idusuario}",
    );
    debugPrintLevels(
      9,
      "PaginaCarouselFotosWidget idPropiedad: ${widget.valueespaciosparameter.espacioscasa.idPropiedad}",
    );

    debugPrintLevels(9, "* PaginaCarouselFotosWidget initState end");

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

    super.initState();
  }

  //-----------------------------------------------------------------------------
  @override
  void didChangeDependencies() {
    debugPrintLevels(1, " PaginaCarouselFotosWidget didChangeDependencies");
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(covariant PaginaCarouselFotosWidget oldWidget) {
    debugPrintLevels(1, " PaginaCarouselFotosWidget didUpdateWidget");
    super.didUpdateWidget(oldWidget);
  }

  @override
  void deactivate() {
    debugPrintLevels(1, " PaginaCarouselFotosWidget deactivate");
    super.deactivate();
  }

  @override
  void dispose() {
    debugPrintLevels(1, " PaginaCarouselFotosWidget dispose");
    //  controllerCarousel.dispose();
    super.dispose();
  }
  //-----------------------------------------------------------------------------

  // GUARDA LA LISTA DE IDS DE LAS FOTOS EN LA LISTA DE LA PROPIEDAD
  GetIdsFotosUserProp listaIdFotos = GetIdsFotosUserProp(
    totalRows: 0,
    offset: 0,
    rows: [],
  );
  // GUARDA EL NUMERO DE FOTOS DE LA PROPIEDAD
  CuentaFotos cuentaFotos = CuentaFotos(rows: []);

  @override
  Widget build(BuildContext context) {
    // debugPrintLevels(9, "****************************************");
    debugPrintLevels(9, "* PaginaCarouselFotosWidget build");
    //  debugPrintLevels(9, "****************************************");

    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      /*
      appBar: AppBar(
        toolbarHeight: 40.0, // default kToolbarHeight = 56.0
        centerTitle: true,
        titleSpacing: 0,
        backgroundColor: appTheme.primary,

        iconTheme: IconThemeData(
          size: 14,
          color: appTheme.onPrimary,
        ),

        title: Text(
          "Lista de fotos de la propiedad",
          style: TextStyle(
            color: appTheme.onPrimary,
            fontWeight: FontWeight.normal,
            fontSize: 14,
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Symbols.arrow_back,
            color: appTheme.secondary,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.small(
        onPressed: () {},
        child: const Icon(Symbols.add),
      ),
      */
      body: FutureBuilder<CuentaFotos>(
        // OBTIENE EL NUMERO DE FOTOS DE LA PROPIEDAD Y EL USUARIO
        future: _numeroDeImagenesIdUserPropiedad,
        builder: (context, snapshotNumImagenes) {
          switch (snapshotNumImagenes.connectionState) {
            case ConnectionState.none:
              return stateNone(
                widthCuadroFotoPropiedad,
                heightCuadroFotoPropiedad,
              );
            case ConnectionState.waiting:
              return Center(
                child: Text(
                  "",
                  style: TextStyle(
                    color: appTheme.primary,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    fontFamily: "Comfortaa",
                  ),
                ),
                //   child: CircularProgressIndicator(color: appTheme.primary),
              );
            case ConnectionState.active:
              return stateActive(
                widthCuadroFotoPropiedad,
                heightCuadroFotoPropiedad,
              );
            case ConnectionState.done:
              if (snapshotNumImagenes.hasError) {
                return stateErrorFormat(
                  widthCuadroFotoPropiedad,
                  heightCuadroFotoPropiedad,
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
                /*
                {
                  "rows": [
                    {
                      "key": null,
                      "value": 4
                    }
                  ]
                }
                value ES EL NUMERO DE FOTOS
              */
                cuentaFotos = snapshotNumImagenes.data!;
                // INICITALIZA CONTROLADOR
                controllerCarousel.initialItem;
                controllerCarousel.initialScrollOffset;
                // GENERA UNA LISTA CON SCROLL
                return SingleChildScrollView(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      const SizedBox(height: 10),
                      // TITULO DEL CONTENIDO
                      Text(
                        'Fotos de la propiedad: $numeroDeFotos',
                        //     'Fotos de la propiedad: ${ref.read(espaciosCasaConListaFotosGetProvider).espaciosCasas.rows[ref.read(espaciosCasaConListaFotosGetProvider).index].value.espacioscasa.clavedelapropiedad}',
                        style: TextStyle(
                          color: appTheme.primary,
                          fontSize: fontSizeSubtituloPagina,
                          fontWeight: FontWeight.bold,
                          fontFamily: "Comfortaa",
                        ),
                      ),
                      const SizedBox(height: 10),
                      // GENERA CONTENEDOR DE LA FOTO EN EL CAROUSEL
                      Center(
                        child: SizedBox(
                          height: (screenHeight > screenWidth)
                              ? screenWidth / 1.6
                              : screenHeight * 0.65,
                          width: (screenHeight > screenWidth)
                              ? screenWidth * 1
                              : screenHeight * 1.6,
                          child: (numeroDeFotos == 0)
                              ? // CASO: LA LISTA ESTA SIN FOTOS
                                Container(
                                  color: appTheme.onSecondary,
                                  alignment: Alignment.topCenter,
                                  child: Center(
                                    child: InkWell(
                                      borderRadius: BorderRadius.all(
                                        Radius.zero,
                                      ),
                                      radius: 0.0,
                                      splashColor:
                                          appTheme.outline, // Splash color
                                      onTap: () {
                                        // LLENA LOS PARAMETROS PARA PASAR
                                        // A LA PAGINA DE AGREGAR FOTOS
                                        /*
                                        "idUsuario": "",
                                        "idPropiedad": "",
                                        "idFoto": "",
                                        "propiedad": ValueEspaciosCasaGet,
                                        "fotoprincipal": bool,
                                        "indice": 0,
                                      */
                                        parameterGestionFoto["idUsuario"] =
                                            widget
                                                .valueespaciosparameter
                                                .espacioscasa
                                                .idusuario;
                                        parameterGestionFoto["idPropiedad"] =
                                            widget
                                                .valueespaciosparameter
                                                .espacioscasa
                                                .idPropiedad;
                                        parameterGestionFoto["idFoto"] = "";
                                        parameterGestionFoto["propiedad"] =
                                            widget.valueespaciosparameter;
                                        parameterGestionFoto["indice"] =
                                            indiceFotos;
                                        // (indiceFotos == 0)
                                        parameterGestionFoto["fotoprincipal"] =
                                            true;
                                        debugPrintLevels(
                                          10,
                                          "FutureBuilder agregafotopropiedad parameter: $parameterGestionFoto",
                                        );
                                        Navigator.pushNamed(
                                          context,
                                          // GestionImagenesCasas(), pagina_gestion_fotos_agrega
                                          AppRoutes.agregafotopropiedad,
                                          arguments: parameterGestionFoto,
                                        );
                                      },
                                      child: Container(
                                        color: appTheme.surface,
                                        width: 65,
                                        height: 65,
                                        child: Center(
                                          child: Icon(
                                            Symbols.add,
                                            size: 60,
                                            color: appTheme.primary,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              : // CASO: CON FOTOS -> GENERA CAROUSEL
                                FutureBuilder<GetIdsFotosUserProp>(
                                  future: _recuperaIdsFotosDePropiedades,
                                  builder: (context, snapshotListaGetIdFotos) {
                                    // RECUPERA LISTA DE FOTOS IDs DE LA PROPIEDAD
                                    switch (snapshotListaGetIdFotos
                                        .connectionState) {
                                      case ConnectionState.none:
                                        return stateNone(
                                          widthCuadroFotoPropiedad,
                                          heightCuadroFotoPropiedad,
                                        );
                                      case ConnectionState.waiting:
                                        return stateWaiting(
                                          widthCuadroFotoPropiedad,
                                          heightCuadroFotoPropiedad,
                                        );
                                      case ConnectionState.active:
                                        return stateActive(
                                          widthCuadroFotoPropiedad,
                                          heightCuadroFotoPropiedad,
                                        );
                                      case ConnectionState.done:
                                        if (snapshotListaGetIdFotos.hasError) {
                                          return stateErrorFormat(
                                            widthCuadroFotoPropiedad,
                                            heightCuadroFotoPropiedad,
                                            snapshotListaGetIdFotos.error,
                                          );
                                        } else {
                                          debugPrintLevels(
                                            9,
                                            "FutureBuilder _recuperaIdsFotosDePropiedades: done",
                                          );
                                          listaIdFotos =
                                              snapshotListaGetIdFotos.data!;
                                          debugPrintLevels(
                                            9,
                                            "NUMERO DE IDS FOTOS RECUPERADOS: ${listaIdFotos.rows.length}",
                                          );
                                          //return CarouselView.weighted(
                                          return CarouselView(
                                            itemExtent: double.infinity,
                                            shrinkExtent: 0,
                                            itemSnapping: false,
                                            scrollDirection: Axis.horizontal,
                                            controller: controllerCarousel,
                                            //   flexWeights:
                                            //       (smallScreenMax > screenWidth)
                                            //           ? const [1]
                                            //           : const [1, 6, 1],
                                            elevation: 5,
                                            shape: LinearBorder(),
                                            padding: const EdgeInsets.all(6),
                                            onTap: (index) {
                                              parameterGestionFoto["idUsuario"] =
                                                  widget
                                                      .valueespaciosparameter
                                                      .espacioscasa
                                                      .idusuario;
                                              parameterGestionFoto["idPropiedad"] =
                                                  widget
                                                      .valueespaciosparameter
                                                      .espacioscasa
                                                      .idPropiedad;
                                              parameterGestionFoto["idFoto"] =
                                                  listaIdFotos
                                                      .rows[indiceFotos]
                                                      .value;
                                              parameterGestionFoto["indice"] =
                                                  indiceFotos;
                                              parameterGestionFoto["propiedad"] =
                                                  widget.valueespaciosparameter;

                                              (indiceFotos == 0)
                                                  ? parameterGestionFoto["fotoprincipal"] =
                                                        true
                                                  : parameterGestionFoto["fotoprincipal"] =
                                                        false;
                                              /*
                                              dialogCreaPaginaInsideBox(
                                                  context,
                                                  "Agrega foto",
                                                  GestionFotosActualiza(
                                                      parameterGestionFoto));
                                            */
                                            },
                                            //reverse: true,
                                            children: [
                                              Container(
                                                alignment: Alignment.topCenter,
                                                child: FutureBuilder<String>(
                                                  // OBTIENE DE LA BD LA LISTA DE PROPIEDADES
                                                  future: recuperaFotoPorIdFoto(
                                                    listaIdFotos
                                                        .rows[indiceFotos]
                                                        .value,
                                                  ),
                                                  builder: (context, snapshotIdFoto) {
                                                    debugPrintLevels(
                                                      9,
                                                      ">>  PaginaCarouselFotosWidget recuperaFotoPorIdFoto: ${listaIdFotos.rows[indiceFotos].value}",
                                                    );
                                                    /*
                                            FotosCasaGet {
                                              int totalRows;
                                              int offset;
                                              List<RowFotosCasaGet> rows;
                                                String id;
                                                String key;
                                                ValueFotosCasaGet value;                                          
                                                  String id;
                                                  String rev;
                                                  FotosCasaClass fotosCasa =
                                                    String idFoto;
                                                    String idUsuario;
                                                    String idPropiedad;
                                                    String filaname;
                                                    String path;
                                                    int size;
                                                    dynamic identifier;
                                                    String foto;
                                                    String contentType;
                                                    String timestamp;
                                            */
                                                    switch (snapshotIdFoto
                                                        .connectionState) {
                                                      case ConnectionState.none:
                                                        return stateNone(
                                                          widthCuadroFotoPropiedad,
                                                          heightCuadroFotoPropiedad,
                                                        );
                                                      case ConnectionState
                                                          .waiting:
                                                        return stateWaiting(
                                                          widthCuadroFotoPropiedad,
                                                          heightCuadroFotoPropiedad,
                                                        );
                                                      case ConnectionState
                                                          .active:
                                                        return stateActive(
                                                          widthCuadroFotoPropiedad,
                                                          heightCuadroFotoPropiedad,
                                                        );
                                                      case ConnectionState.done:
                                                        if (snapshotIdFoto
                                                            .hasError) {
                                                          return stateErrorFormat(
                                                            widthCuadroFotoPropiedad,
                                                            heightCuadroFotoPropiedad,
                                                            snapshotIdFoto
                                                                .error,
                                                          );
                                                        } else {
                                                          debugPrintLevels(
                                                            9,
                                                            "FutureBuilder recuperaFotoPorIdFoto: done",
                                                          );
                                                          fotoprincipal =
                                                              snapshotIdFoto
                                                                  .data!;
                                                          return (fotoprincipal ==
                                                                  "")
                                                              ? const Text(
                                                                  "No se encontro foto",
                                                                  style: TextStyle(
                                                                    fontSize:
                                                                        12,
                                                                    color: Colors
                                                                        .white,
                                                                  ),
                                                                )
                                                              : Ink.image(
                                                                  fit:
                                                                      (screenHeight >
                                                                          screenWidth)
                                                                      ? BoxFit
                                                                            .fitHeight
                                                                      : BoxFit
                                                                            .fitHeight, // https://api.flutter.dev/flutter/painting/BoxFit.html
                                                                  image: MemoryImage(
                                                                    base64Decode(
                                                                      fotoprincipal,
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
                                    }
                                  },
                                ),
                        ),
                      ),

                      const SizedBox(height: 8),

                      (numeroDeFotos > 0)
                          ? buildPagination(indiceFotos, numeroDeFotos)
                          : const SizedBox(height: 1),
                      const SizedBox(height: 10),
                      (numeroDeFotos > 0)
                          ? buildButtons()
                          : const SizedBox(height: 1),

                      const SizedBox(height: 30),
                    ],
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

  Widget buildButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          style: ButtonStyle(
            backgroundColor: WidgetStatePropertyAll<Color>(appTheme.primary),
          ),
          child: Icon(Symbols.arrow_back, size: 18, color: appTheme.onPrimary),
          onPressed: () {
            if (numeroDeFotos > 0) {
              // controllerCarousel.position;
              if ((indiceFotos - 1) >= 0) {
                indiceFotos = indiceFotos - 1;
              }
              controllerCarousel.jumpTo(indiceFotos.roundToDouble());

              debugPrintLevels(
                9,
                "setState Buttom: index-pos: $indiceFotos, ${controllerCarousel.offset}",
              );
              setState(() {});
            }
          },
        ),
        (indiceFotos == 0)
            ? Text(
                'Foto principal',
                style: TextStyle(
                  color: appTheme.primary,
                  fontSize: fontSizeSubtituloPagina,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Comfortaa",
                ),
              )
            : const Text(""),
        ElevatedButton(
          style: ButtonStyle(
            backgroundColor: WidgetStatePropertyAll<Color>(appTheme.primary),
          ),
          child: Icon(Symbols.arrow_forward, size: 18, color: appTheme.onPrimary),
          onPressed: () {
            if (numeroDeFotos > 0) {
              // controllerCarousel.nextPage();
              if ((indiceFotos + 1) < numeroDeFotos) {
                indiceFotos = indiceFotos + 1;
              }
              controllerCarousel.jumpTo(indiceFotos.roundToDouble());

              debugPrintLevels(
                9,
                "setState Buttom: index-pos: $indiceFotos, ${controllerCarousel.offset}",
              );
              setState(() {});
            }
          },
        ),
      ],
    );
  }
}
*/
