import 'dart:convert';
import 'package:buscobien/22_imagenes/data_models/data_fotos_casa.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';
import '../../../../05_provider_menus/provider_menu_principal.dart';
import '../../../../07_routes/routes_parameters.dart';
import '../../../../08_pantallas/inicio/data_espacios_casas_get.dart';
import '../../../../60_global_widgets/future_builder_state_widgets.dart';
import '../../../../20_var_globales/var_color_themes.dart';
import '../../../../20_var_globales/var_color_widget.dart';
import '../../../../20_var_globales/var_elementos_menus.dart';
import '../../../../20_var_globales/variables_globales.dart';
import '../../../../60_global_widgets/debugprint.dart';
import '../../../data_models/data_fotos_ordenadas.dart';
import '../../../variables_imagenes.dart';
import '../futures_y_providers/future_funciones_fotos.dart';
import '../futures_y_providers/future_recupera_ids_fotos_propiedad.dart';
import '../futures_y_providers/http_funciones_gestion_foto.dart';
import '../lista_fotos_ordenadas/data_fotos_ordenadas_get_idpropiedad.dart';
import '../futures_y_providers/future_get_fotos_by_idpr_orden.dart';
import '../lista_fotos_ordenadas/future_put_fotos_orden.dart';
import '../lista_fotos_ordenadas/future_update_fotos_orden.dart';
import '../lista_fotos_ordenadas/provider_get_lista_fotos_ordenadas.dart';

//--------------------------------------------------------------------------
// OPTIMIZADO 2.0
// Asumimos que las importaciones necesarias (modelos, providers, utilerias) están presentes externamente.

import 'dart:async';
import '../lista_ids_fotos/data_fotos_get_ids_fotos_user_prop.dart';

// Asumimos que las importaciones necesarias (modelos, providers, utilerias) están presentes externamente.

class PropiedadesListaFotosPromotor extends ConsumerStatefulWidget {
  final ValueEspaciosCasaGet valueespaciosparameter;

  const PropiedadesListaFotosPromotor(this.valueespaciosparameter, {super.key});

  @override
  ConsumerState<PropiedadesListaFotosPromotor> createState() =>
      PropiedadesListaFotosPromotorState();
}

class PropiedadesListaFotosPromotorState
    extends ConsumerState<PropiedadesListaFotosPromotor>
    with TickerProviderStateMixin {
  final scaffoldKeyFootosPromotor = GlobalKey<ScaffoldState>();
  String idUsuario = "";
  String idPropiedad = "";
  String nombrePropiedad = "";
  int numeroDeFotos = 0;

  // Lista local para manejar el orden visual antes de guardar
  List<FotosOrden> _listaVisualFotos = [];

  // Variable para manejar la carga inicial de metadatos (IDs y Orden) en paralelo
  late Future<List<dynamic>> _futuresCombinados;

  @override
  void initState() {
    debugPrintLevels(9, "* PropiedadesListaFotosPromotor initState");

    // Inicialización de parámetros
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

    // OPTIMIZACIÓN: Carga inicial de metadatos
    _cargarDatosIniciales();

    super.initState();
  }

  // OPTIMIZACIÓN: Cargamos solo IDs y el Orden. Las fotos pesadas se cargarán individualmente después.
  void _cargarDatosIniciales() {
    _futuresCombinados = Future.wait([
      // Usamos recuperaIds... en lugar de recuperaFotos... para que sea rápido
      recuperaIdsFotosDePropiedades(idUsuario, idPropiedad),
      recuperaFotosOrdenadasIdProperty(ref, idPropiedad),
    ]);
  }

  //-----------------------------------------------------------------------------
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
  }

  //-----------------------------------------------------------------------------

  refreshData() {
    debugPrintLevels(9, "* PropiedadesListaFotosPromotor refreshData");
    setState(() {
      _cargarDatosIniciales();
    });
  }

  @override
  Widget build(BuildContext context) {
    debugPrintLevels(9, "* PropiedadesListaFotosPromotor build");

    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      key: scaffoldKeyFootosPromotor,
      body: FutureBuilder<List<dynamic>>(
        future: _futuresCombinados,
        builder: (context, snapshot) {
          // 1. ESTADO DE CARGA
          if (snapshot.connectionState == ConnectionState.waiting) {
            return stateWaiting(
              widthCuadroFotoPropiedad,
              heightCuadroFotoPropiedad,
            );
          }
          if (snapshot.hasError) {
            return stateErrorFormat(
              widthCuadroFotoPropiedad,
              heightCuadroFotoPropiedad,
              snapshot.error,
            );
          }

          // 2. PROCESAMIENTO DE DATOS (Solo cuando termina el Future)
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            // Obtenemos los IDs crudos (rápido)
            final getIdsData = snapshot.data![0] as GetIdsFotosUserProp;
            // El orden se actualiza en el provider por `recuperaFotosOrdenadasIdProperty`

            numeroDeFotos = getIdsData.rows.length;

            // Procesamos la lista visual una sola vez o si cambia la data
            // Nota: _prepararListaVisual maneja la lógica de si usar orden guardado o IDs crudos
            if (_listaVisualFotos.isEmpty ||
                _listaVisualFotos.length != numeroDeFotos) {
              _listaVisualFotos = _prepararListaVisual(getIdsData);
            }

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

                // LISTA REORDENABLE
                Expanded(
                  child: _listaVisualFotos.isEmpty
                      ? const Center(child: Text("Sin fotos para mostrar"))
                      : ReorderableListView.builder(
                          itemCount: _listaVisualFotos.length,
                          onReorder: _handleReorder,
                          itemBuilder: (context, index) {
                            final fotoItem = _listaVisualFotos[index];
                            // Usamos el ID como Key para evitar problemas al reordenar
                            return _FotoItemReorderable(
                              key: ValueKey(fotoItem.idFoto),
                              index: index,
                              idFoto: fotoItem.idFoto,
                              onDelete: () async {
                                await borraFoto(
                                  context,
                                  ref,
                                  index,
                                  // refreshData(), // Pasamos null o callback vacio, refreshData se llama abajo
                                );
                                refreshData();
                              },
                            );
                          },
                        ),
                ),

                Container(color: appTheme.surface, height: 8),

                // BOTONES MENU INFERIOR
                if (ref.read(menuPrincipalProvider).etiqueta ==
                    iconoTuCuenta.etiqueta)
                  _buildMenuInferior(),
              ],
            );
          }

          return stateNone(widthCuadroFotoPropiedad, heightCuadroFotoPropiedad);
        },
      ),
    );
  }

  /// Determina el orden inicial de las fotos (Guardado vs Default)
  List<FotosOrden> _prepararListaVisual(GetIdsFotosUserProp idsData) {
    final providerOrden = ref.read(getListaFotosOrdenadasProvider);
    List<FotosOrden> listaResultado = [];

    bool usarOrdenGuardado = false;

    // Verificar si existe orden guardado y si coincide en longitud con los IDs reales
    if (providerOrden.rows.isNotEmpty) {
      final fotosOrdenadas =
          providerOrden.rows[0].value.listadefotos.fotosOrden;
      if (fotosOrdenadas.length == idsData.rows.length) {
        usarOrdenGuardado = true;
      }
    }

    if (usarOrdenGuardado) {
      // Clonamos la lista del provider para trabajar localmente
      listaResultado = List.from(
        ref
            .read(getListaFotosOrdenadasProvider)
            .rows[0]
            .value
            .listadefotos
            .fotosOrden,
      );
    } else {
      // Creamos orden basado en la lista de IDs crudos
      for (int i = 0; i < idsData.rows.length; i++) {
        listaResultado.add(
          FotosOrden(
            posicion: i,
            idFoto: idsData
                .rows[i]
                .value, // Value en GetIdsFotosUserProp es el idFoto
          ),
        );
      }
      // Limpiamos el provider ya que no es válido
      ref.read(getListaFotosOrdenadasProvider).rows.clear();
    }
    return listaResultado;
  }

  /// Maneja el evento de Drag & Drop
  void _handleReorder(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }
      final item = _listaVisualFotos.removeAt(oldIndex);
      _listaVisualFotos.insert(newIndex, item);

      // Actualizamos las posiciones internas
      for (int i = 0; i < _listaVisualFotos.length; i++) {
        _listaVisualFotos[i].posicion = i;
      }
    });
  }

  /// Menú inferior con botones
  Widget _buildMenuInferior() {
    return Container(
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
              backgroundColor: WidgetStatePropertyAll<Color>(appTheme.primary),
            ),
            onPressed: () async {
              await agregafoto(context, ref, widget.valueespaciosparameter);
              refreshData();
            },
            child: Icon(Symbols.add, size: 18, color: appTheme.onPrimary),
          ),
          const SizedBox(width: 5),
          // GUARDAR ORDEN DE FOTOS
          ElevatedButton(
            style: ButtonStyle(
              backgroundColor: WidgetStatePropertyAll<Color>(appTheme.primary),
            ),
            onPressed: () => _guardarOrden(),
            child: Icon(Symbols.save, size: 18, color: appTheme.onPrimary),
          ),
          const SizedBox(width: 5),
          // REFRESH LISTA
          ElevatedButton(
            style: ButtonStyle(
              backgroundColor: WidgetStatePropertyAll<Color>(appTheme.primary),
            ),
            onPressed: () => refreshData(),
            child: Icon(Symbols.refresh, size: 18, color: appTheme.onPrimary),
          ),
        ],
      ),
    );
  }

  /// Lógica de guardado basada en la lista visual actual
  void _guardarOrden() {
    // Estructura base
    ListaFotosOrdenadasGetIdPropiedad ordenfotos =
        ListaFotosOrdenadasGetIdPropiedad(totalRows: 0, offset: 0, rows: []);

    RowGetIdPropiedad nuevaFila = RowGetIdPropiedad(
      id: "",
      key: "",
      value: ValueGetIdPropiedad(
        id: "",
        rev: "",
        listadefotos: ListaFotosOrdenadas(
          idListaFotos: "",
          idUsuario: idUsuario,
          idPropiedad: idPropiedad,
          fotosOrden: [],
          timestamp: "",
        ),
      ),
    );

    // Si ya existe en BD, recuperamos ID y Rev para hacer UPDATE
    if (ref.read(getListaFotosOrdenadasProvider).rows.isNotEmpty) {
      var rowExistente = ref.read(getListaFotosOrdenadasProvider).rows[0];
      nuevaFila.id = rowExistente.id;
      nuevaFila.key = rowExistente.key;
      nuevaFila.value.id = rowExistente.value.id;
      nuevaFila.value.rev = rowExistente.value.rev;
      nuevaFila.value.listadefotos.idListaFotos =
          rowExistente.value.listadefotos.idListaFotos;
    }

    ordenfotos.rows.add(nuevaFila);

    // Llenamos con la lista visual actual (_listaVisualFotos) que tiene el nuevo orden
    ordenfotos.rows[0].value.listadefotos.fotosOrden.addAll(_listaVisualFotos);

    bool esActualizacion = ref
        .read(getListaFotosOrdenadasProvider)
        .rows
        .isNotEmpty;

    if (esActualizacion) {
      debugPrintLevels(10, "ACTUALIZA ORDEN");
      actualizaFotosOrdenadas(
        ordenfotos.rows[0].value,
      ).then((_) => refreshData());
    } else {
      debugPrintLevels(10, "CREA ORDEN");
      guardaFotosOrdenadas(
        ordenfotos.rows[0].value.listadefotos,
      ).then((_) => refreshData());
    }
  }
}

// -------------------------------------------------------------------------
// WIDGETS AUXILIARES (Extracción para rendimiento y carga "una a una")
// -------------------------------------------------------------------------

/// Widget que representa la fila de la lista.
/// Contiene la estructura visual pero delega la carga de imagen a `_ImagenFotoLoader`.

class _FotoItemReorderable extends StatefulWidget {
  final int index;
  final String idFoto;
  final VoidCallback onDelete;

  const _FotoItemReorderable({
    required Key key,
    required this.index,
    required this.idFoto,
    required this.onDelete,
  }) : super(key: key);

  @override
  State<_FotoItemReorderable> createState() => _FotoItemReorderableState();
}

class _FotoItemReorderableState extends State<_FotoItemReorderable> {
  // Future para cargar el OBJETO completo (Imagen + Metadatos)
  late Future<FotosCasaClass?> _futureFotoCompleta;

  @override
  void initState() {
    super.initState();
    // IMPORTANTE: Aquí debes llamar a la función que devuelve el objeto 'RowFotosCasaGetIDs'
    // usando el ID de la foto. Si 'recuperaFotoPorIdFoto' solo devuelve String, usa la función
    // de tu repositorio que devuelva la fila completa (ej. recuperaFichaFoto, recuperaObjetoFoto, etc).
    // Aquí asumo que existe 'recuperaObjetoFotoPorId'.
    _futureFotoCompleta = recuperaFotoCompletaPorIdFoto(widget.idFoto);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 0, 30, 0),
      padding: const EdgeInsets.fromLTRB(10, 0, 15, 8),
      child: ListTile(
        tileColor: appTheme.onPrimary,
        leading: CircleAvatar(
          radius: 15,
          backgroundColor: appTheme.surface,
          child: Text(
            (widget.index + 1).toString(),
            style: TextStyle(
              fontSize: 14,
              color: appTheme.onPrimaryContainer,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
        title: FutureBuilder<FotosCasaClass?>(
          future: _futureFotoCompleta,
          builder: (context, snapshot) {
            // 1. ESTADO CARGANDO
            if (snapshot.connectionState != ConnectionState.done) {
              return Row(
                children: [
                  // Placeholder imagen
                  Container(
                    width: 80,
                    height: 50,
                    color: Colors.grey[200],
                    child: const Center(
                      child: SizedBox(
                        width: 15,
                        height: 15,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Placeholder texto
                  const Text(
                    "Cargando detalles...",
                    style: TextStyle(fontSize: 10, color: Colors.grey),
                  ),
                ],
              );
            }

            // 2. ESTADO ERROR O SIN DATOS
            if (snapshot.hasError || !snapshot.hasData) {
              return const Text(
                "Error al cargar info",
                style: TextStyle(fontSize: 10, color: Colors.red),
              );
            }

            // 3. DATOS CARGADOS CORRECTAMENTE
            final dataFoto = snapshot.data!;

            return Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  // Muestra la imagen decodificando el base64 que viene en el objeto
                  child: SizedBox(
                    width: 80,
                    height: 50,
                    child: (dataFoto.foto.isNotEmpty)
                        ? Ink.image(
                            fit: BoxFit.fitHeight,
                            image: MemoryImage(base64Decode(dataFoto.foto)),
                          )
                        : const Center(
                            child: Icon(Symbols.broken_image, size: 20),
                          ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 12,
                  child: Container(
                    alignment: Alignment.centerLeft,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Archivo: ${dataFoto.filaname}", // Datos del snapshot
                          style: TextStyle(
                            color: appTheme.onPrimaryContainer,
                            fontSize: 10.0,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow:
                              TextOverflow.ellipsis, // Evita desbordamiento
                          maxLines: 1,
                        ),
                        Text(
                          "Tamaño: ${dataFoto.size} bytes", // Datos del snapshot
                          style: TextStyle(
                            color: appTheme.onPrimaryContainer,
                            fontSize: 8.0,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
        trailing: IconButton(
          hoverColor: appTheme.tertiaryContainer,
          onPressed: widget.onDelete,
          icon: Icon(Symbols.delete, color: appTheme.error),
        ),
      ),
    );
  }
}

//--------------------------------------------------------------------------
// OPTIMIZADO 1.0
//--------------------------------------------------------------------------
