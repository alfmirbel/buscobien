import 'dart:convert';

import 'package:buscobien/20_var_globales/variables_globales.dart';
import 'package:buscobien/22_imagenes/variables_imagenes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../../05_provider_menus/provider_menu_principal.dart';
import '../../../../07_routes/app_routes.dart';
import '../../../../07_routes/routes_parameters.dart';
import '../../../../08_pantallas/inicio/data_espacios_casas_get.dart';
import '../../../../60_global_widgets/future_builder_state_widgets.dart';
import '../../../../20_var_globales/var_color_themes.dart';
import '../../../../20_var_globales/var_color_widget.dart';
import '../../../../20_var_globales/var_elementos_menus.dart';
import '../../../../60_global_widgets/debugprint.dart';

import '../datos_fotos/data_cuenta_fotos.dart';
import '../lista_fotos_ordenadas/data_fotos_ordenadas_get_idpropiedad.dart';
import '../futures_y_providers/future_get_fotos_by_idpr_orden.dart';
import '../lista_fotos_ordenadas/provider_get_lista_fotos_ordenadas.dart';
import '../lista_ids_fotos/data_fotos_get_ids_fotos_user_prop.dart';
import '../../../data_models/data_fotos_ordenadas.dart';
import '../futures_y_providers/http_funciones_gestion_foto.dart';
import '../futures_y_providers/future_recupera_ids_fotos_propiedad.dart';

//--------------------------------------------------------------------------
// OPTIMIZADO

class PropiedadesMiniFotoListaPromotor extends ConsumerStatefulWidget {
  final ValueEspaciosCasaGet valueespaciosparameter;

  const PropiedadesMiniFotoListaPromotor(
    this.valueespaciosparameter, {
    super.key,
  });

  @override
  ConsumerState<PropiedadesMiniFotoListaPromotor> createState() =>
      PropiedadesMiniFotoListaPromotorState();
}

class PropiedadesMiniFotoListaPromotorState
    extends ConsumerState<PropiedadesMiniFotoListaPromotor>
    with TickerProviderStateMixin {
  //
  final scaffoldKeyMinisFotos = GlobalKey<ScaffoldState>();
  String idUsuario = "";
  String idPropiedad = "";
  String nombrePropiedad = "";
  int indiceFotos = 0;
  int numeroDeFotos = 0;
  late ValueEspaciosCasaGet propiedad;

  bool botonAgregarActive = true;
  bool botonGuardarActive = false;
  bool botonReloadActive = false;
  int numFotosAgregadas = 0;

  GetIdsFotosUserProp listaidsfotos = GetIdsFotosUserProp(
    rows: [],
    totalRows: 0,
    offset: 0,
  );

  //--------------
  // FUTURES
  late Future<CuentaFotos> _numeroDeImagenesIdUserPropiedad;
  late Future<GetIdsFotosUserProp> _recuperaIdsFotosDePropiedades;
  late Future<int> _recuperaListaFotosOrden;

  //--------------

  @override
  void initState() {
    super.initState();
    propiedad = widget.valueespaciosparameter;
    idUsuario = propiedad.espacioscasa.idusuario;
    idPropiedad = propiedad.espacioscasa.idPropiedad;

    debugPrintLevels(9, "* PaginaCapturaFotosWidget initState");

    // INICIALIZA PARAMETROS GESTION FOTO
    parameterGestionFoto["idUsuario"] =
        widget.valueespaciosparameter.espacioscasa.idusuario;
    parameterGestionFoto["idPropiedad"] =
        widget.valueespaciosparameter.espacioscasa.idPropiedad;
    parameterGestionFoto["idFoto"] =
        widget.valueespaciosparameter.espacioscasa.fotoprincipal;
    parameterGestionFoto["propiedad"] = widget.valueespaciosparameter;
    parameterGestionFoto["fotoprincipal"] = false;
    parameterGestionFoto["indice"] = 0;

    nombrePropiedad =
        widget.valueespaciosparameter.espacioscasa.nombredelapropiedad;

    debugPrintLevels(
      9,
      "PaginaCapturaFotosWidget idusuario: ${widget.valueespaciosparameter.espacioscasa.idusuario}",
    );
    debugPrintLevels(9, "* PaginaCapturaFotosWidget initState end");

    // Inicialización de Futures
    _cargarFutures();
  }

  // OPTIMIZACIÓN: Método helper para recargar futures, usado en initState y refreshData
  void _cargarFutures() {
    _numeroDeImagenesIdUserPropiedad = numeroDeImagenesIdUserPropiedad(
      ref,
      idUsuario,
      idPropiedad,
    );
    _recuperaIdsFotosDePropiedades = recuperaIdsFotosDePropiedades(
      idUsuario,
      idPropiedad,
    );
    _recuperaListaFotosOrden = recuperaFotosOrdenadasIdProperty(
      ref,
      idPropiedad,
    );
  }

  //-----------------------------------------------------------------------------
  @override
  void didChangeDependencies() {
    debugPrintLevels(
      1,
      " PropiedadesMiniFotoListaPromotor didChangeDependencies",
    );
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(covariant PropiedadesMiniFotoListaPromotor oldWidget) {
    debugPrintLevels(1, " PropiedadesMiniFotoListaPromotor didUpdateWidget");
    super.didUpdateWidget(oldWidget);
  }

  @override
  void deactivate() {
    debugPrintLevels(1, " PropiedadesMiniFotoListaPromotor deactivate");
    super.deactivate();
  }

  @override
  void dispose() {
    debugPrintLevels(1, " PropiedadesMiniFotoListaPromotor dispose");
    super.dispose();
  }

  //-----------------------------------------------------------------------------

  void refreshData() {
    debugPrintLevels(9, "* PropiedadesListaFotosPromotor refreshData");
    setState(() {
      _cargarFutures();
    });
    debugPrintLevels(9, "* PropiedadesListaFotosPromotor refreshData END");
  }

  @override
  Widget build(BuildContext context) {
    debugPrintLevels(9, "* PaginaCarouselFotosWidget build");

    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    ListaFotosOrdenadasGetIdPropiedad providerState = ref.read(
      getListaFotosOrdenadasProvider,
    );
    // OPTIMIZACIÓN: Evitar borrar el provider en cada build si no es estrictamente necesario.
    // Si la lógica de negocio requiere limpiar siempre al redibujar, se mantiene.
    // De lo contrario, mover al initState o refreshData.
    // ref.read(getListaFotosOrdenadasProvider.notifier).clearFotoListaPosiciones();

    return Scaffold(
      key: scaffoldKeyMinisFotos, // CORRECCIÓN: Asignar la Key
      body: FutureBuilder<CuentaFotos>(
        future: _numeroDeImagenesIdUserPropiedad,
        builder: (context, snapshotNumImagenes) {
          switch (snapshotNumImagenes.connectionState) {
            case ConnectionState.none:
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
              if (snapshotNumImagenes.hasError) {
                return stateErrorFormat(
                  widthCuadroFotoPropiedad,
                  heightCuadroFotoPropiedad,
                  snapshotNumImagenes.error,
                );
              } else {
                numeroDeFotos = snapshotNumImagenes.data!.rows.isNotEmpty
                    ? snapshotNumImagenes.data!.rows[0].value
                    : 0;

                // 2. FUTURE BUILDER IDS
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    // TITULO DEL CONTENIDO
                    Container(
                      color: appTheme.onPrimary,
                      height: 40,
                      child: Center(
                        child: Text(
                          'Número de fotos: $numeroDeFotos',
                          style: TextStyle(
                            fontFamily: 'Outfit',
                            color: appTheme.secondary,
                            fontSize: fontSizeSubtituloPagina,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Container(color: appTheme.surface, height: 8),

                    FutureBuilder<GetIdsFotosUserProp>(
                      future: _recuperaIdsFotosDePropiedades,
                      builder: (context, snapshotIdFotos) {
                        if (snapshotIdFotos.connectionState !=
                            ConnectionState.done) {
                          return stateWaiting(
                            widthCuadroFotoPropiedad,
                            heightCuadroFotoPropiedad,
                          );
                        }

                        if (snapshotIdFotos.hasError) {
                          return stateErrorFormat(
                            widthCuadroFotoPropiedad,
                            heightCuadroFotoPropiedad,
                            snapshotIdFotos.error,
                          );
                        }

                        listaidsfotos = snapshotIdFotos.data!;
                        debugPrintLevels(
                          9,
                          "FutureBuilder IDs length: ${listaidsfotos.rows.length}",
                        );

                        if (listaidsfotos.rows.isEmpty) {
                          return const Expanded(
                            child: Center(
                              child: Text("No se encontraron fotos"),
                            ),
                          );
                        }

                        // 3. FUTURE BUILDER ORDEN
                        return FutureBuilder<int>(
                          future: _recuperaListaFotosOrden,
                          builder: (context, snapshotOrdenFotos) {
                            if (snapshotOrdenFotos.connectionState !=
                                ConnectionState.done) {
                              return stateWaiting(
                                widthCuadroFotoPropiedad,
                                heightCuadroFotoPropiedad,
                              );
                            }

                            if (snapshotOrdenFotos.hasError) {
                              return stateErrorFormat(
                                widthCuadroFotoPropiedad,
                                heightCuadroFotoPropiedad,
                                snapshotOrdenFotos.error,
                              );
                            }

                            // LOGICA DE SINCRONIZACIÓN CORREGIDA
                            // Evitamos modificar el provider durante el build.
                            // Creamos una lista local para renderizar.

                            final providerFotos = ref.read(
                              getListaFotosOrdenadasProvider,
                            );
                            List<FotosOrden> listaParaRenderizar = [];
                            //bool usarProvider = true;

                            int? resultado = snapshotOrdenFotos.data;

                            // Condición: Si falla la carga del orden o está vacío o no coincide el tamaño
                            if ((resultado != 200) ||
                                (providerFotos.rows.isEmpty) ||
                                (listaidsfotos.rows.length !=
                                    providerFotos.rows.length)) {
                              //usarProvider = false;
                              debugPrintLevels(
                                9,
                                "Detectada desincronización en orden. Usando IDs base.",
                              );

                              // Generamos la lista localmente para mostrar YA, sin esperar al provider
                              for (
                                int i = 0;
                                i < listaidsfotos.rows.length;
                                i++
                              ) {
                                listaParaRenderizar.add(
                                  FotosOrden(
                                    posicion: i,
                                    idFoto: listaidsfotos.rows[i].value,
                                  ),
                                );
                              }

                              // REPARACIÓN DEL ESTADO: Programamos la actualización del provider para DESPUÉS del build
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                // Aquí es seguro modificar el estado

                                // Nota: Asume que el notifier tiene métodos para limpiar/agregar o accede directo a rows si es mutable
                                // Como no puedo ver el notifier, simulo la lógica original sobre el objeto ref

                                // Limpiamos si es necesario o agregamos la estructura base si no existe
                                if (providerState.rows.isEmpty) {
                                  providerState.rows.add(
                                    RowGetIdPropiedad(
                                      id: '',
                                      key: '',
                                      value: ValueGetIdPropiedad(
                                        id: '',
                                        rev: '',
                                        listadefotos: ListaFotosOrdenadas(
                                          idListaFotos: '',
                                          idUsuario: '',
                                          idPropiedad: '',
                                          fotosOrden: [],
                                          timestamp: '',
                                        ),
                                      ),
                                    ),
                                  );
                                }

                                // Actualizamos los valores
                                var target =
                                    providerState.rows[0].value.listadefotos;
                                target.idUsuario = listaidsfotos.rows.isNotEmpty
                                    ? listaidsfotos.rows[0].key[0]
                                    : '';
                                target.idPropiedad =
                                    listaidsfotos.rows.isNotEmpty
                                    ? listaidsfotos.rows[0].key[1]
                                    : '';
                                target.fotosOrden.clear();
                                target.fotosOrden.addAll(listaParaRenderizar);

                                // Importante: Si esto fuera un StateNotifier inmutable, deberías usar:
                                // ref.read(provider.notifier).state = nuevoEstado;
                              });
                            } else {
                              // El orden existe y es correcto, usamos el provider
                              listaParaRenderizar = providerFotos
                                  .rows[0]
                                  .value
                                  .listadefotos
                                  .fotosOrden;
                            }

                            botonReloadActive = true;

                            // RENDERIZADO DE LA GRILLA
                            return Expanded(
                              child: SingleChildScrollView(
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Wrap(
                                    spacing: 10.0,
                                    runSpacing: 10.0,
                                    children: List.generate(
                                      listaParaRenderizar.length,
                                      (index) {
                                        final fotoItem =
                                            listaParaRenderizar[index];

                                        // 4. FUTURE BUILDER IMAGEN INDIVIDUAL
                                        return FutureBuilder<String>(
                                          future: recuperaFotoPorIdFoto(
                                            fotoItem.idFoto,
                                          ),
                                          builder: (context, snapshotGetFoto) {
                                            if (snapshotGetFoto
                                                    .connectionState !=
                                                ConnectionState.done) {
                                              return stateWaiting(
                                                150,
                                                100,
                                              ); // Tamaño hardcoded original
                                            }

                                            if (snapshotGetFoto.hasError) {
                                              return stateErrorFormat(
                                                150,
                                                100,
                                                snapshotGetFoto.error,
                                              );
                                            }

                                            final base64String =
                                                snapshotGetFoto.data;

                                            return SizedBox(
                                              width: 150,
                                              height: 100,
                                              child:
                                                  (base64String == null ||
                                                      base64String.isEmpty)
                                                  ? const Center(
                                                      child: Text(
                                                        "No se encontró foto",
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                          color: Colors.grey,
                                                        ),
                                                      ),
                                                    )
                                                  : Ink.image(
                                                      fit: BoxFit
                                                          .cover, // Cambiado a cover para mejor aspecto, volver a fitHeight si se requiere estricto
                                                      image: MemoryImage(
                                                        base64Decode(
                                                          base64String,
                                                        ),
                                                      ),
                                                    ),
                                            );
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),

                    Container(color: appTheme.surface, height: 8),

                    // BOTONES MENU INFERIOR
                    _buildBottomBar(),
                  ],
                );
              }
          }
        },
      ),
    );
  }

  // OPTIMIZACIÓN: Extracción de la barra inferior para legibilidad
  Widget _buildBottomBar() {
    bool esTuCuenta =
        ref.read(menuPrincipalProvider).etiqueta == iconoTuCuenta.etiqueta;

    return Container(
      color: appTheme.onPrimary,
      height: 60,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: esTuCuenta
            ? [
                // BOTON AGREGAR
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll<Color>(
                      botonAgregarActive ? appTheme.primary : appTheme.outline,
                    ),
                  ),
                  onPressed: botonAgregarActive
                      ? () async {
                          numFotosAgregadas = numeroDeFotos;
                          setState(() {
                            // Actualizar UI visualmente
                            botonGuardarActive = true;
                            botonReloadActive =
                                false; // Desactivar mientras procesa
                          });

                          debugPrintLevels(9, "CALL agregamultiplesfotos GO");

                          ref
                              .read(getListaFotosOrdenadasProvider.notifier)
                              .clearFotoListaPosiciones();

                          await Navigator.pushNamed(
                            context,
                            AppRoutes.agregamultiplesfotos,
                            arguments: parameterGestionFoto,
                          );

                          refreshData(); // Recargar al volver
                          debugPrintLevels(9, "CALL agregamultiplesfotos END");
                        }
                      : null,
                  child: Icon(Symbols.add, size: 18, color: appTheme.onPrimary),
                ),
                const SizedBox(width: 5),

                // BOTON REFRESCAR
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll<Color>(
                      botonReloadActive ? appTheme.primary : appTheme.outline,
                    ),
                  ),
                  onPressed: botonReloadActive ? () => refreshData() : null,
                  child: Icon(
                    Symbols.refresh,
                    size: 18,
                    color: appTheme.onPrimary,
                  ),
                ),
              ]
            : [
                // BOTON CANCELAR (Solo visualización)
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll<Color>(
                      appTheme.primary,
                    ),
                  ),
                  child: Icon(
                    Symbols.cancel,
                    size: 18,
                    color: appTheme.onPrimary,
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
      ),
    );
  }
}
//--------------------------------------------------------------------------
/*
class PropiedadesMiniFotoListaPromotor extends ConsumerStatefulWidget {
  final ValueEspaciosCasaGet valueespaciosparameter;

  const PropiedadesMiniFotoListaPromotor(
    this.valueespaciosparameter, {
    super.key,
  });

  @override
  ConsumerState<PropiedadesMiniFotoListaPromotor> createState() =>
      PropiedadesMiniFotoListaPromotorState();
}

class PropiedadesMiniFotoListaPromotorState
    extends ConsumerState<PropiedadesMiniFotoListaPromotor>
    with TickerProviderStateMixin {
  //
  final scaffoldKeyMinisFotos = GlobalKey<ScaffoldState>();
  String idUsuario = "";
  String idPropiedad = "";
  String nombrePropiedad = "";
  int indiceFotos = 0;
  int numeroDeFotos = 0;
  late ValueEspaciosCasaGet propiedad;

  bool botonAgregarActive = true;
  bool botonGuardarActive = false;
  bool botonReloadActive = false;
  int numFotosAgregadas = 0;

  GetIdsFotosUserProp listaidsfotos = GetIdsFotosUserProp(
    rows: [],
    totalRows: 0,
    offset: 0,
  );

  //--------------
  // CUENTA EL NUMERO DE FOTOS
  late Future<CuentaFotos> _numeroDeImagenesIdUserPropiedad;
  // RECUPERA LOS IDS DE LAS FOTOS
  late Future<GetIdsFotosUserProp> _recuperaIdsFotosDePropiedades;
  // RECUPERA LA LISTA DE FOTOS ORDENADAS
  late Future<int> _recuperaListaFotosOrden;
  // RECUPERA UNA FOTO POR EL ID FOTO
  //  late Future<FotosCasaGet> _recuperaFotoPorIdFoto;
  //--------------
  @override
  void initState() {
    propiedad = widget.valueespaciosparameter;
    idUsuario = propiedad.espacioscasa.idusuario;
    idPropiedad = propiedad.espacioscasa.idPropiedad;
    // debugPrintLevels(9, "****************************************");
    debugPrintLevels(9, "* PaginaCapturaFotosWidget initState");
    // debugPrintLevels(9, "****************************************");
    // INICIALIZA QUE NO ES LA FOTO PRINCIPAL Y parameterGestionFoto
    parameterGestionFoto["idUsuario"] =
        widget.valueespaciosparameter.espacioscasa.idusuario;
    parameterGestionFoto["idPropiedad"] =
        widget.valueespaciosparameter.espacioscasa.idPropiedad;
    parameterGestionFoto["idFoto"] =
        widget.valueespaciosparameter.espacioscasa.fotoprincipal;
    parameterGestionFoto["propiedad"] = widget.valueespaciosparameter;
    parameterGestionFoto["fotoprincipal"] = false;
    parameterGestionFoto["indice"] = 0;

    idUsuario = widget.valueespaciosparameter.espacioscasa.idusuario;
    idPropiedad = widget.valueespaciosparameter.espacioscasa.idPropiedad;
    nombrePropiedad =
        widget.valueespaciosparameter.espacioscasa.nombredelapropiedad;
    //  fotoPrincipal = widget.valueespaciosparameter.espacioscasa.fotoprincipal;

    debugPrintLevels(
      9,
      "PaginaCapturaFotosWidget idusuario: ${widget.valueespaciosparameter.espacioscasa.idusuario}",
    );
    debugPrintLevels(
      9,
      "PaginaCapturaFotosWidget idPropiedad: ${widget.valueespaciosparameter.espacioscasa.idPropiedad}",
    );
    debugPrintLevels(9, "* PaginaCapturaFotosWidget initState end");
    //-----------------------------------------------------------------------------
    // CUENTA EL NUMERO DE FOTOS
    _numeroDeImagenesIdUserPropiedad = numeroDeImagenesIdUserPropiedad(
      ref,
      idUsuario,
      idPropiedad,
    );
    // RECUPERA LOS IDS DE LAS FOTOS
    _recuperaIdsFotosDePropiedades = recuperaIdsFotosDePropiedades(
      idUsuario,
      idPropiedad,
    );
    // RECUPERA LA LISTA DE FOTOS ORDENADAS
    _recuperaListaFotosOrden = recuperaFotosOrdenadasIdProperty(
      ref,
      idPropiedad,
    );

    //-----------------------------------------------------------------------------
    super.initState();
  }

  //-----------------------------------------------------------------------------
  @override
  void didChangeDependencies() {
    debugPrintLevels(
      1,
      " PropiedadesMiniFotoListaPromotor didChangeDependencies",
    );
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(covariant PropiedadesMiniFotoListaPromotor oldWidget) {
    debugPrintLevels(1, " PropiedadesMiniFotoListaPromotor didUpdateWidget");
    super.didUpdateWidget(oldWidget);
  }

  @override
  void deactivate() {
    debugPrintLevels(1, " PropiedadesMiniFotoListaPromotor deactivate");
    super.deactivate();
  }

  @override
  void dispose() {
    debugPrintLevels(1, " PropiedadesMiniFotoListaPromotor dispose");
    super.dispose();
  }
  //-----------------------------------------------------------------------------

  void refreshData() {
    debugPrintLevels(
      9,
      "* PropiedadesListaFotosPromotor _recuperaFotosDePropiedades",
    );
    // CUENTA EL NUMERO DE FOTOS
    _numeroDeImagenesIdUserPropiedad = numeroDeImagenesIdUserPropiedad(
      ref,
      idUsuario,
      idPropiedad,
    );
    // RECUPERA LOS IDS DE LAS FOTOS
    _recuperaIdsFotosDePropiedades = recuperaIdsFotosDePropiedades(
      idUsuario,
      idPropiedad,
    );
    // RECUPERA LA LISTA DE FOTOS ORDENADAS
    _recuperaListaFotosOrden = recuperaFotosOrdenadasIdProperty(
      ref,
      idPropiedad,
    );
    // RECUPERA UNA FOTO POR EL ID FOTO
    //    _recuperaFotoPorIdFoto = recuperaFotoPorIdFoto(
    //        widget.valueespaciosparameter.espacioscasa.fotoprincipal);
    setState(() {});
    debugPrintLevels(
      9,
      "* PropiedadesListaFotosPromotor _recuperaListaFotosOrden END",
    );
  }

  @override
  Widget build(BuildContext context) {
    // debugPrintLevels(9, "****************************************");
    debugPrintLevels(9, "* PaginaCarouselFotosWidget build");
    //  debugPrintLevels(9, "****************************************");

    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    ref
        .read(getListaFotosOrdenadasProvider.notifier)
        .clearFotoListaPosiciones();

    return Scaffold(
      /*
      appBar: AppBar(
        backgroundColor: appTheme.primary,
        toolbarHeight: 40,
        centerTitle: true,
        titleSpacing: 0,
        iconTheme: IconThemeData(
          size: 14,
          color: appTheme.onPrimary,
        ),
        title: Text(
          "Fotos de la Propiedad Mini",
          style: TextStyle(
            color: Theme.of(context).colorScheme.onPrimary,
            fontWeight: FontWeight.normal,
            fontSize: 12,
          ),
        ),
      ),
      */
      body: FutureBuilder<CuentaFotos>(
        // CUENTA EL NUMERO DE FOTOS
        future: _numeroDeImagenesIdUserPropiedad,
        builder: (context, snapshotNumImagenes) {
          switch (snapshotNumImagenes.connectionState) {
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
              if (snapshotNumImagenes.hasError) {
                return stateErrorFormat(
                  widthCuadroFotoPropiedad,
                  heightCuadroFotoPropiedad,
                  snapshotNumImagenes.error,
                );
              } else {
                numeroDeFotos = snapshotNumImagenes.data!.rows[0].value;
                //------------------------------------------------------
                // RECUPERA LOS IDS DE LAS FOTOS
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    // TITULO DEL CONTENIDO
                    Container(
                      color: appTheme.onPrimary,
                      height: 40,
                      child: Center(
                        child: Text(
                          'Número de fotos: $numeroDeFotos',
                          style: TextStyle(
                            fontFamily: 'Outfit',
                            color: appTheme.secondary,
                            fontSize: fontSizeSubtituloPagina,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Container(color: appTheme.surface, height: 8),

                    FutureBuilder<GetIdsFotosUserProp>(
                      future: _recuperaIdsFotosDePropiedades,
                      builder: (context, snapshotIdFotos) {
                        switch (snapshotIdFotos.connectionState) {
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
                            if (snapshotIdFotos.hasError) {
                              return stateErrorFormat(
                                widthCuadroFotoPropiedad,
                                heightCuadroFotoPropiedad,
                                snapshotIdFotos.error,
                              );
                            } else {
                              listaidsfotos = snapshotIdFotos.data!;
                              debugPrintLevels(
                                9,
                                "FutureBuilder _recuperaIdsFotosDePropiedades length: ${listaidsfotos.rows.length}",
                              );

                              //CASO LISTA VACIA
                              if (listaidsfotos.rows.isEmpty) {
                                return Expanded(
                                  child: Center(
                                    child: Text("No se encotraron fotos"),
                                  ),
                                );
                              } else {
                                // CASO LISTA CON DATOS
                                // BUSCA LA LISTA DE FOTOS ORDENADAS
                                return FutureBuilder<int>(
                                  future: _recuperaListaFotosOrden,
                                  builder: (context, snapshotOrdenFotos) {
                                    switch (snapshotOrdenFotos
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
                                        if (snapshotOrdenFotos.hasError) {
                                          return stateErrorFormat(
                                            widthCuadroFotoPropiedad,
                                            heightCuadroFotoPropiedad,
                                            snapshotOrdenFotos.error,
                                          );
                                        } else {
                                          debugPrintLevels(
                                            9,
                                            "FutureBuilder _recuperaListaFotosOrden length: ${ref.read(getListaFotosOrdenadasProvider).rows.length}",
                                          );
                                          int? resultado =
                                              snapshotOrdenFotos.data;
                                          // CHECA SI HAY LISTA ORDENADA
                                          if ((resultado != 200) ||
                                              (ref
                                                  .read(
                                                    getListaFotosOrdenadasProvider,
                                                  )
                                                  .rows
                                                  .isEmpty) ||
                                              (listaidsfotos.rows.length !=
                                                  ref
                                                      .read(
                                                        getListaFotosOrdenadasProvider,
                                                      )
                                                      .rows
                                                      .length)) {
                                            // NO TIENE LISTA ORDENADA
                                            // LIMPIA LISTA ORDENADA
                                            // CREA LA LISTA ORDENADA CON LA LISTA DE IDS
                                            ref
                                                .read(
                                                  getListaFotosOrdenadasProvider,
                                                )
                                                .rows
                                                .add(
                                                  RowGetIdPropiedad(
                                                    id: '',
                                                    key: '',
                                                    value: ValueGetIdPropiedad(
                                                      id: '',
                                                      rev: '',
                                                      listadefotos:
                                                          ListaFotosOrdenadas(
                                                            idListaFotos: '',
                                                            idUsuario: '',
                                                            idPropiedad: '',
                                                            fotosOrden: [
                                                              /*
                                                      FotosOrden(
                                                        posicion: 0,
                                                        idFoto: "",
                                                      ),
                                                      */
                                                            ],
                                                            timestamp: '',
                                                          ),
                                                    ),
                                                  ),
                                                );
                                            // COPIA LA LISTA NO ORDENADA A LA ORDENADA
                                            for (
                                              int i = 0;
                                              i < listaidsfotos.rows.length;
                                              i++
                                            ) {
                                              ref
                                                  .read(
                                                    getListaFotosOrdenadasProvider,
                                                  )
                                                  .rows[0]
                                                  .value
                                                  .listadefotos
                                                  .idUsuario = listaidsfotos
                                                  .rows[0]
                                                  .key[0];
                                              ref
                                                  .read(
                                                    getListaFotosOrdenadasProvider,
                                                  )
                                                  .rows[0]
                                                  .value
                                                  .listadefotos
                                                  .idPropiedad = listaidsfotos
                                                  .rows[0]
                                                  .key[1];
                                              ref
                                                  .read(
                                                    getListaFotosOrdenadasProvider,
                                                  )
                                                  .rows[0]
                                                  .value
                                                  .listadefotos
                                                  .fotosOrden
                                                  .add(
                                                    FotosOrden(
                                                      posicion: i,
                                                      idFoto: listaidsfotos
                                                          .rows[i]
                                                          .value,
                                                    ),
                                                  );
                                            }
                                          }
                                          //------------------------------------------------------
                                          // GENERA CONTENEDOR DE LA LISTA DE FOTOS
                                          botonReloadActive = true;
                                          // DESDE LA LISTA ORDENADA
                                          return Expanded(
                                            child: SingleChildScrollView(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsetsGeometry.all(
                                                      10,
                                                    ),
                                                child: Wrap(
                                                  spacing:
                                                      10.0, // Space between children
                                                  runSpacing: 10.0,
                                                  children: List.generate(
                                                    ref
                                                        .read(
                                                          getListaFotosOrdenadasProvider,
                                                        )
                                                        .rows[0]
                                                        .value
                                                        .listadefotos
                                                        .fotosOrden
                                                        .length,
                                                    (index) {
                                                      return FutureBuilder<
                                                        String
                                                      >(
                                                        // OBTIENE DE LA BD LA LISTA DE PROPIEDADES
                                                        future: recuperaFotoPorIdFoto(
                                                          ref
                                                              .read(
                                                                getListaFotosOrdenadasProvider,
                                                              )
                                                              .rows[0]
                                                              .value
                                                              .listadefotos
                                                              .fotosOrden[index]
                                                              .idFoto,
                                                        ),
                                                        builder:
                                                            (
                                                              context,
                                                              snapshotGetFoto,
                                                            ) {
                                                              debugPrintLevels(
                                                                9,
                                                                ">>  PaginaCarouselFotosWidget recuperaFotoPorIdFoto}",
                                                              );
                                                              switch (snapshotGetFoto
                                                                  .connectionState) {
                                                                case ConnectionState
                                                                    .none:
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
                                                                case ConnectionState
                                                                    .done:
                                                                  if (snapshotGetFoto
                                                                      .hasError) {
                                                                    return stateErrorFormat(
                                                                      widthCuadroFotoPropiedad,
                                                                      heightCuadroFotoPropiedad,
                                                                      snapshotGetFoto
                                                                          .error,
                                                                    );
                                                                  } else {
                                                                    debugPrintLevels(
                                                                      9,
                                                                      "FutureBuilder recuperaFotoPorIdFoto: done",
                                                                    );

                                                                    return SizedBox(
                                                                      width:
                                                                          150,
                                                                      height:
                                                                          100,
                                                                      child:
                                                                          (snapshotGetFoto.data ==
                                                                              "")
                                                                          ? const Text(
                                                                              "No se encontro foto",
                                                                              style: TextStyle(
                                                                                fontSize: 12,
                                                                                color: Colors.white,
                                                                              ),
                                                                            )
                                                                          : Ink.image(
                                                                              fit: BoxFit.fitHeight, // https://api.flutter.dev/flutter/painting/BoxFit.html
                                                                              image: MemoryImage(
                                                                                base64Decode(
                                                                                  snapshotGetFoto.data!,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                    );
                                                                  }
                                                              }
                                                            },
                                                      );
                                                    },
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        }
                                    }
                                  },
                                );
                              }
                            }
                        }
                      },
                    ),

                    Container(color: appTheme.surface, height: 8),

                    // BOTONES MENU INFERIOR
                    (ref.read(menuPrincipalProvider).etiqueta ==
                            iconoTuCuenta.etiqueta)
                        ? Container(
                            color: appTheme.onPrimary,
                            height: 60,
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // AGREGA FOTO
                                ElevatedButton(
                                  style: ButtonStyle(
                                    backgroundColor:
                                        WidgetStatePropertyAll<Color>(
                                          botonAgregarActive
                                              ? appTheme.primary
                                              : appTheme.outline,
                                        ),
                                  ),
                                  onPressed: botonAgregarActive
                                      ? () async {
                                          numFotosAgregadas = numeroDeFotos;
                                          botonGuardarActive = true;
                                          botonReloadActive = true;
                                          debugPrintLevels(
                                            9,
                                            "CALL  agregamultiplesfotos GO",
                                          );
                                          Navigator.pushNamed(
                                            // ignore: use_build_context_synchronously
                                            context,
                                            AppRoutes
                                                .agregamultiplesfotos, //  AgregaMultiplesFotos
                                            arguments: parameterGestionFoto,
                                          );
                                          ref
                                              .read(
                                                getListaFotosOrdenadasProvider
                                                    .notifier,
                                              )
                                              .clearFotoListaPosiciones();
                                          setState(() {
                                            refreshData();
                                          });
                                          debugPrintLevels(
                                            9,
                                            "CALL  agregamultiplesfotos END",
                                          );
                                        }
                                      : null,
                                  child: Icon(
                                    Symbols.add,
                                    size: 18,
                                    color: appTheme.onPrimary,
                                  ),
                                ),
                                const SizedBox(width: 5),
                                // RECARGA FOTOS
                                ElevatedButton(
                                  style: ButtonStyle(
                                    backgroundColor:
                                        WidgetStatePropertyAll<Color>(
                                          botonReloadActive
                                              ? appTheme.primary
                                              : appTheme.outline,
                                        ),
                                  ),
                                  onPressed: botonReloadActive
                                      ? () {
                                          refreshData();
                                        }
                                      : null,
                                  child: Icon(
                                    Symbols.refresh,
                                    size: 18,
                                    color: appTheme.onPrimary,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : Container(
                            color: appTheme.onPrimary,
                            height: 60,
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // BOTON DE CANCELAR
                                ElevatedButton(
                                  style: ButtonStyle(
                                    backgroundColor:
                                        WidgetStatePropertyAll<Color>(
                                          appTheme.primary,
                                        ),
                                  ),
                                  child: Icon(
                                    Symbols.cancel,
                                    size: 18,
                                    color: appTheme.onPrimary,
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            ),
                          ),
                  ],
                );
              }
          }
        },
      ),
    );
  }
}
*/
