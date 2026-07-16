import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../../../20_var_globales/var_color_themes.dart';
import '../../../../../20_var_globales/var_color_widget.dart';
import '../../../../../60_global_widgets/debugprint.dart';
import '../../../../08_pantallas/inicio/data_espacios_casas_get.dart';
import 'pagina_lista_fotos_cuadros.dart';
import 'pagina_lista_fotos_listado.dart';
import 'pagina_lista_fotos_carousel.dart';

// OPTIMIZADO

class PaginaFotosPropiedad extends ConsumerStatefulWidget {
  final ValueEspaciosCasaGet propiedad;

  const PaginaFotosPropiedad(this.propiedad, {super.key});

  @override
  // ignore: no_logic_in_create_state
  ConsumerState createState() {
    debugPrintLevels(20, " **************************************************");
    debugPrintLevels(20, " 1. PaginaFotosPropiedad createState");
    debugPrintLevels(20, " **************************************************");
    return PaginaFotosPropiedadState();
  }
}

class PaginaFotosPropiedadState extends ConsumerState<PaginaFotosPropiedad>
    with TickerProviderStateMixin {
  // SUGERENCIA: Se asigna esta key al Scaffold más abajo.
  final scaffoldKeyFotosPropiedad = GlobalKey<ScaffoldState>();

  late TabController tabControllerOpcionesFotos;

  // Estado para controlar el estilo de los botones
  List<bool> buttonSelectOpcionFotos = [true, false, false];

  String idUsuario = "";
  String idPropiedad = "";
  String idFoto = "";
  bool principalbool = false;

  @override
  void initState() {
    super.initState();
    debugPrintLevels(20, " **************************************************");
    debugPrintLevels(20, " 2. PaginaFotosPropiedad initState");
    debugPrintLevels(20, " **************************************************");

    // Inicialización de variables
    buttonSelectOpcionFotos = [true, false, false];

    tabControllerOpcionesFotos = TabController(
      vsync: this,
      length: buttonSelectOpcionFotos.length,
    );

    // OPTIMIZACIÓN: El listener es crucial para detectar swipes, no solo taps.
    tabControllerOpcionesFotos.addListener(_handleTabSelection);

    // Datos de la propiedad
    idFoto = widget.propiedad.espacioscasa.fotoprincipal;
    idUsuario = widget.propiedad.espacioscasa.idusuario;
    idPropiedad = widget.propiedad.espacioscasa.idPropiedad;
  }

  //-----------------------------------------------------------------------------
  // Ciclo de vida: Se mantienen los prints solicitados para depuración
  @override
  void didChangeDependencies() {
    debugPrintLevels(20, " PaginaFotosPropiedad didChangeDependencies");
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(covariant PaginaFotosPropiedad oldWidget) {
    debugPrintLevels(20, " PaginaFotosPropiedad didUpdateWidget");
    super.didUpdateWidget(oldWidget);
  }

  @override
  void deactivate() {
    debugPrintLevels(20, " PaginaFotosPropiedad deactivate");
    super.deactivate();
  }

  @override
  void dispose() {
    debugPrintLevels(20, " PaginaFotosPropiedad dispose");
    // CORRECCIÓN: Es fundamental hacer dispose del controller para evitar fugas de memoria.
    tabControllerOpcionesFotos.removeListener(_handleTabSelection);
    tabControllerOpcionesFotos.dispose();
    super.dispose();
  }

  //-----------------------------------------------------------------------------

  // OPTIMIZACIÓN: Lógica centralizada para actualizar la UI tanto por Tap como por Swipe
  void _handleTabSelection() {
    if (tabControllerOpcionesFotos.indexIsChanging ||
        tabControllerOpcionesFotos.index !=
            buttonSelectOpcionFotos.indexOf(true)) {
      setState(() {
        for (int i = 0; i < buttonSelectOpcionFotos.length; i++) {
          buttonSelectOpcionFotos[i] = (i == tabControllerOpcionesFotos.index);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    debugPrintLevels(20, " **************************************************");
    debugPrintLevels(20, " 3. PaginaFotosPropiedad build");
    debugPrintLevels(20, " **************************************************");

    // Nota: El uso de variables globales para screenWidth/Height no es ideal,
    // pero se mantiene para respetar la estructura solicitada.
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      key: scaffoldKeyFotosPropiedad, // CORRECCIÓN: Asignación de la key
      appBar: AppBar(
        toolbarHeight: 40.0,
        centerTitle: true,
        titleSpacing: 0,
        backgroundColor: appTheme.primary,
        iconTheme: IconThemeData(size: 14, color: appTheme.onPrimary),

        title: Text(
          "Manejo de Fotos de la Propiedad",
          style: TextStyle(
            color: appTheme.onPrimary,
            fontWeight: FontWeight.normal,
            fontSize: 12,
          ),
        ),

        leading: IconButton(
          icon: Icon(Symbols.arrow_back, color: appTheme.onPrimary),
          onPressed: () {
            Navigator.pop(context);
          },
        ),

        bottom: TabBar(
          controller: tabControllerOpcionesFotos,
          isScrollable: true,
          tabAlignment: TabAlignment.center,
          indicatorColor: appTheme
              .primary, // Color del indicador nativo (oculto visualmente por el diseño custom)
          labelColor: appTheme.primary,
          unselectedLabelColor: appTheme.primary,
          indicatorSize: TabBarIndicatorSize.tab,
          padding: const EdgeInsets.fromLTRB(3, 3, 3, 6),
          // Estilo del texto global para las tabs
          labelStyle: TextStyle(
            color: appTheme.primary,
            fontWeight: FontWeight.normal,
          ),
          // Decoración "activa" que envuelve al Tab
          indicator: BoxDecoration(
            color: appTheme.onPrimary,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: appTheme.primary, width: 1),
          ),

          // NOTA: El onTap ya no necesita setState manual, el _handleTabSelection lo hace.
          // Sin embargo, si quieres feedback instantáneo antes de la animación, puedes dejarlo,
          // pero he limpiado la lógica redundante.
          onTap: (index) {
            // El listener se encarga de la lógica visual
          },

          tabs: List<Widget>.generate(buttonSelectOpcionFotos.length, (
            int index,
          ) {
            String etiqueta = "";
            IconData icono = Symbols.home;

            // Definición de etiquetas e iconos
            switch (index) {
              case 0:
                etiqueta = "Cargar";
                icono = Symbols.view_comfy_alt;
                break;
              case 1:
                etiqueta = "Ordenar";
                icono = Symbols.list;
                break;
              case 2:
                etiqueta = "Mostrar";
                icono = Symbols.view_carousel;
                break;
              default:
                etiqueta = "Mostrar";
                icono = Symbols.view_comfy_alt;
                break;
            }

            final bool isSelected = buttonSelectOpcionFotos[index];

            return Tab(
              height: 30,
              child: Container(
                height: 28,
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  // Lógica de color inverso según selección
                  color: isSelected ? appTheme.onPrimary : appTheme.primary,
                  borderRadius: BorderRadius.circular(
                    6,
                  ), // Opcional: suavizar bordes de tabs inactivos
                ),
                child: Row(
                  children: [
                    Icon(
                      icono,
                      size: 20,
                      color: isSelected ? appTheme.primary : appTheme.onPrimary,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      etiqueta,
                      style: TextStyle(
                        fontSize: 12,
                        color: isSelected
                            ? appTheme.primary
                            : appTheme.onPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
      body: TabBarView(
        controller: tabControllerOpcionesFotos,
        children: [
          PropiedadesMiniFotoListaPromotor(widget.propiedad),
          PropiedadesListaFotosPromotor(widget.propiedad),
          PaginaCarouselFotosWidget(widget.propiedad),
          // PropiedadesListaPaginada(widget.propiedad), // Comentado en original
        ],
      ),
    );
  }
}

/*
class PaginaFotosPropiedad extends ConsumerStatefulWidget {
  final ValueEspaciosCasaGet propiedad;

  const PaginaFotosPropiedad(this.propiedad, {super.key});

  @override
  // ignore: no_logic_in_create_state
  ConsumerState createState() {
    debugPrintLevels(20, " **************************************************");
    debugPrintLevels(20, " 1. PaginaFotosPropiedad createState");
    debugPrintLevels(20, " **************************************************");
    return PaginaFotosPropiedadState();
  }
}

class PaginaFotosPropiedadState extends ConsumerState<PaginaFotosPropiedad>
    with TickerProviderStateMixin {
  final scaffoldKeyFotosPropiedad = GlobalKey<ScaffoldState>();

  late TabController tabControllerOpcionesFotos;

  List<bool> buttonSelectOpcionFotos = [true, false, false];

  String idUsuario = "";
  String idPropiedad = "";
  String idFoto = "";
  bool principalbool = false;

  @override
  void initState() {
    super.initState();
    debugPrintLevels(20, " **************************************************");
    debugPrintLevels(20, " 2. PaginaFotosPropiedad initState");
    debugPrintLevels(20, " **************************************************");
    buttonSelectOpcionFotos[0] = true;
    buttonSelectOpcionFotos[1] = false;
    buttonSelectOpcionFotos[2] = false;

    tabControllerOpcionesFotos = TabController(
      vsync: this,
      length: buttonSelectOpcionFotos.length,
    ); // numero de elementos
    tabControllerOpcionesFotos.addListener(_handleTabSelection);

    //-----------------------------------------------------------------------------
    idFoto = widget.propiedad.espacioscasa.fotoprincipal;
    idUsuario = widget.propiedad.espacioscasa.idusuario;
    idPropiedad = widget.propiedad.espacioscasa.idPropiedad;
  }

  //-----------------------------------------------------------------------------
  @override
  void didChangeDependencies() {
    debugPrintLevels(20, " PaginaFotosPropiedad didChangeDependencies");
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(covariant PaginaFotosPropiedad oldWidget) {
    debugPrintLevels(20, " PaginaFotosPropiedad didUpdateWidget");
    super.didUpdateWidget(oldWidget);
  }

  @override
  void deactivate() {
    debugPrintLevels(20, " PaginaFotosPropiedad deactivate");
    super.deactivate();
  }

  @override
  void dispose() {
    debugPrintLevels(20, " PaginaFotosPropiedad dispose");
    //  tabControllerOpcionesFotos.dispose();
    super.dispose();
  }
  //-----------------------------------------------------------------------------

  void _handleTabSelection() {}

  @override
  Widget build(BuildContext context) {
    debugPrintLevels(20, " **************************************************");
    debugPrintLevels(20, " 3. PaginaFotosPropiedad build");
    debugPrintLevels(20, " **************************************************");
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    String etiqueta = "";
    IconData icono = Symbols.home;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 40.0, // default kToolbarHeight = 56.0
        centerTitle: true,
        titleSpacing: 0,
        backgroundColor: appTheme.primary,

        iconTheme: IconThemeData(size: 14, color: appTheme.onPrimary),

        title: Text(
          "Manejo de Fotos de la Propiedad",
          style: TextStyle(
            color: appTheme.onPrimary,
            fontWeight: FontWeight.normal,
            fontSize: 12,
          ),
        ),

        leading: IconButton(
          icon: Icon(Symbols.arrow_back, color: appTheme.onPrimary),
          onPressed: () {
            Navigator.pop(context);
          },
        ),

        bottom: TabBar(
          controller: tabControllerOpcionesFotos,
          isScrollable: true,
          tabAlignment: TabAlignment.center,
          indicatorColor: appTheme.primary,
          labelColor: appTheme.primary,
          unselectedLabelColor: appTheme.primary,
          indicatorSize: TabBarIndicatorSize.tab,
          padding: const EdgeInsets.fromLTRB(3, 3, 3, 6),
          labelStyle: TextStyle(
            color: appTheme.primary,
            fontWeight: FontWeight.normal,
          ),
          indicator: BoxDecoration(
            color: appTheme.onPrimary,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: appTheme.primary, width: 1),
          ),

          /*
          indicatorColor: appTheme.primary,
          automaticIndicatorColorAdjustment: true,
          indicatorWeight: 1.0,
          isScrollable: true,
          tabAlignment: TabAlignment.center,
          labelColor: appTheme.primary,
          unselectedLabelColor: appTheme.onPrimary,
          padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
          */
          onTap: (index) {
            setState(() {
              //  debugPrintLevels(2, "onTap: $index");
              buttonSelectOpcionFotos[0] = false;
              buttonSelectOpcionFotos[1] = false;
              buttonSelectOpcionFotos[2] = false;
              buttonSelectOpcionFotos[index] = true;
            });
          },
          tabs: List<Widget>.generate(buttonSelectOpcionFotos.length, (
            int index,
          ) {
            switch (index) {
              case 0:
                etiqueta = "Cargar";
                icono = Symbols.view_comfy_alt;
                break;
              case 1:
                etiqueta = "Ordenar";
                icono = Symbols.list;
                break;
              case 2:
                etiqueta = "Mostrar";
                icono = Symbols.view_carousel;
                break;
              default:
                etiqueta = "Mostrar";
                icono = Symbols.view_comfy_alt;
                break;
            }
            return Tab(
              height: 30,
              child: Container(
                height: 28,
                alignment: Alignment.center,
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                decoration: BoxDecoration(
                  color: buttonSelectOpcionFotos[index]
                      ? appTheme.onPrimary
                      : appTheme.primary,
                ),
                child: Row(
                  children: [
                    Icon(
                      icono,
                      size: 20,
                      color: buttonSelectOpcionFotos[index]
                          ? appTheme.primary
                          : appTheme.onPrimary,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      etiqueta, // 1
                      style: TextStyle(
                        fontSize: 12,
                        color: buttonSelectOpcionFotos[index]
                            ? appTheme.primary
                            : appTheme.onPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
      body: TabBarView(
        controller: tabControllerOpcionesFotos,
        children: [
          PropiedadesMiniFotoListaPromotor(widget.propiedad),
          PropiedadesListaFotosPromotor(widget.propiedad),
          PaginaCarouselFotosWidget(widget.propiedad),
          // PropiedadesListaPaginada(widget.propiedad),
        ],
        //listaPaginasFotosPropiedad,
      ),
    );
  }
}
*/
