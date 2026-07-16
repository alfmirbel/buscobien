import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';
import '../../03_listas/lista_select_lista_save_propiedad.dart';
import '../../03_listas/page_compartir_con_grupo.dart';
import '../../03_listas/page_compartir_con_conocido.dart';
import '../../07_routes/app_routes.dart';
import '../../08_pantallas/propiedades/pagina_detalle_propiedad.dart';
import '../../10_user_login/usuario_login/provider_session.dart';
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
import '../variables_imagenes.dart';
import 'package:carousel_slider/carousel_slider.dart'; // NECESARIO IMPORTAR ESTO

//------------------------------------------------------------------------------
// OPTIMIZADO

class PaginaCarouselFotosUsuario extends ConsumerStatefulWidget {
  final ValueEspaciosCasaGet valueespaciosparameter;

  const PaginaCarouselFotosUsuario(this.valueespaciosparameter, {super.key});

  @override
  ConsumerState<PaginaCarouselFotosUsuario> createState() =>
      PaginaCarouselFotosUsuarioState();
}

class PaginaCarouselFotosUsuarioState
    extends ConsumerState<PaginaCarouselFotosUsuario> {
  final scaffoldKeyCarouselFotos = GlobalKey<ScaffoldState>();
  String idUsuario = "";
  String idPropiedad = "";
  String nombrePropiedad = "";
  String tipoDeEspacio = "";
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
    debugPrintLevels(9, "* PaginaCarouselFotosUsuario initState");

    propiedad = widget.valueespaciosparameter;
    //idUsuario = ref.watch(sessionProvider).rows[0].value.userId;
    idUsuario = widget.valueespaciosparameter.espacioscasa.idusuario;
    idPropiedad = widget.valueespaciosparameter.espacioscasa.idPropiedad;
    tipoDeEspacio = widget.valueespaciosparameter.espacioscasa.tipodeanuncio;
    nombrePropiedad =
        widget.valueespaciosparameter.espacioscasa.nombredelapropiedad;

    _futureMetaData = _cargarMetadatos();
  }

  //---------------------------

  // Métodos del ciclo de vida (Mantenidos según instrucción)
  @override
  void didChangeDependencies() {
    debugPrintLevels(1, " PaginaCarouselFotosUsuario didChangeDependencies");
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(covariant PaginaCarouselFotosUsuario oldWidget) {
    debugPrintLevels(1, " PaginaCarouselFotosUsuario didUpdateWidget");
    super.didUpdateWidget(oldWidget);
  }

  @override
  void deactivate() {
    debugPrintLevels(1, " PaginaCarouselFotosUsuario deactivate");
    super.deactivate();
  }

  @override
  void dispose() {
    debugPrintLevels(1, " PaginaCarouselFotosUsuario dispose");
    super.dispose();
  }

  //-------------------
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
  Widget build(BuildContext context) {
    debugPrintLevels(1, "* PaginaCarouselFotosUsuario build");

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
                widthCuadroFotoPropiedad,
                heightCuadroFotoPropiedad,
              ),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: stateErrorFormat(
                widthCuadroFotoPropiedad,
                heightCuadroFotoPropiedad,
                snapshot.error.toString(),
              ),
            );
          }

          return Center(
            child: Container(
              color: appTheme.onSecondary,
              alignment: Alignment.topCenter,
              width: widthCuadroFotoPropiedad,
              padding: const EdgeInsets.all(4),
              child: (numeroDeFotos == 0)
                  ? _buildSinFotos()
                  : Column(
                      children: [
                        // CORRECCIÓN: Usamos CarouselSlider en lugar de CarouselView
                        Container(
                          width: widthCuadroFotoPropiedad,
                          height: heightCuadroFotoPropiedad,
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
                              height: heightCuadroFotoPropiedad,
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
      width: widthCuadroFotoPropiedad,
      height: heightCuadroFotoPropiedad,
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
        width: widthCuadroFotoPropiedad, // Asegura ancho completo
        alignment: Alignment.topCenter,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
        child: FutureBuilder<String>(
          future: recuperaFotoPorIdFoto(currentIdFoto),
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
      width: widthCuadroFotoPropiedad,
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
                onSelected: (value) async {
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
                  } else if (value == "guardar") {
                    debugPrintLevels(
                      10,
                      "DialogSelectorListas call: ${idUsuario} - ${idPropiedad}",
                    );
                    if (ref.read(sessionProvider).sessionUserData.userId !=
                        "") {
                      await Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (context) => DialogSelectorListas(
                            userId: ref
                                .read(sessionProvider)
                                .sessionUserData
                                .userId,
                            propertyId: idPropiedad,
                            tipoDeEspacio: tipoDeEspacio,
                          ),
                        ),
                      );
                      debugPrintLevels(
                        10,
                        "DialogSelectorListas back: ${idUsuario} - ${idPropiedad}",
                      );
                    } else {
                      setState(() {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text(
                              "Ingresa o Registrate para crar listas.",
                            ),
                            backgroundColor: appTheme.error,
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      });
                    }
                  } else if (value == "compartir_grupo") {
                    final session = ref.read(sessionProvider).sessionUserData;
                    if (session.userId.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text("Ingresa para compartir."),
                          backgroundColor: appTheme.error,
                        ),
                      );
                      return;
                    }
                    await Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => PageCompartirConGrupo(
                          propiedadId: idPropiedad,
                          propiedadNombre: nombrePropiedad,
                          tipodeespacio: tipoDeEspacio,
                          currentUserId: session.userId,
                          currentUserName: session.userName,
                        ),
                      ),
                    );
                  } else if (value == "compartir_conocido") {
                    final session = ref.read(sessionProvider).sessionUserData;
                    if (session.userId.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text("Ingresa para compartir."),
                          backgroundColor: appTheme.error,
                        ),
                      );
                      return;
                    }
                    await Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => PageCompartirConConocido(
                          propiedadId: idPropiedad,
                          propiedadNombre: nombrePropiedad,
                          tipodeespacio: tipoDeEspacio,
                          currentUserId: session.userId,
                          currentUserName: session.userName,
                        ),
                      ),
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
                  PopupMenuItem<String>(
                    value: "compartir_grupo",
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Icon(
                            Symbols.group,
                            color: appTheme.onSecondary,
                          ),
                        ),
                        Text(
                          'Con Grupo',
                          style: TextStyle(
                            fontSize: 12,
                            color: appTheme.onSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  PopupMenuItem<String>(
                    value: "compartir_conocido",
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Icon(
                            Symbols.person_outline,
                            color: appTheme.onSecondary,
                          ),
                        ),
                        Text(
                          'Con Conocido',
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
