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
                        /*
                        Text(
                          "ID: ${widget.idFoto}",
                          style: TextStyle(
                            color: appTheme.onPrimaryContainer,
                            fontSize: 8.0,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        */
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

/*
class _FotoItemReorderable extends StatelessWidget {
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
            (index + 1).toString(),
            style: TextStyle(
              fontSize: 14,
              color: appTheme.onPrimaryContainer,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              // AQUÍ ESTA LA CLAVE: Cargamos la imagen independientemente
              child: _ImagenFotoLoader(idFoto: idFoto),
            ),
            const SizedBox(width: 8),
            // Detalles del archivo (Cargamos texto genérico ya que no tenemos metadata completa al inicio)
            // Si se requiere nombre/tamaño, se tendría que hacer fetch de metadata extra o asumirlo al cargar la foto.
            Expanded(
              flex: 12,
              child: Container(
                alignment: Alignment.centerLeft,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Archivo: ${fichaPropiedad[0].value.fotosCasa.filaname}",
                      style: TextStyle(
                        color: appTheme.onPrimaryContainer,
                        fontSize: 10.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Tamaño: ${fichaPropiedad[0].value.fotosCasa.size.toString()} bytes",
                      style: TextStyle(
                        color: appTheme.onPrimaryContainer,
                        fontSize: 8.0,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    Text(
                      "ID: ${idFoto.substring(idFoto.length > 5 ? idFoto.length - 5 : 0)}",
                      style: TextStyle(
                        color: appTheme.onPrimaryContainer,
                        fontSize: 10.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        trailing: IconButton(
          hoverColor: appTheme.tertiaryContainer,
          onPressed: onDelete,
          icon: Icon(Symbols.delete, color: appTheme.error),
        ),
      ),
    );
  }
}
*/
/*
/// Widget encargado de descargar la foto específica.
/// Muestra un loader mientras descarga, logrando el efecto "una a una".
class _ImagenFotoLoader extends StatelessWidget {
  final String idFoto;

  const _ImagenFotoLoader({required this.idFoto});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: recuperaFotoPorIdFoto(idFoto),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return SizedBox(
            width: 80,
            height: 50,
            child: Center(
              child: SizedBox(
                width: 15,
                height: 15,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: appTheme.primary,
                ),
              ),
            ),
          );
        }

        if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
          return SizedBox(
            width: 100,
            height: 50,
            child: Center(
              child: Text(
                "Sin foto",
                style: TextStyle(
                  fontSize: 10,
                  color: appTheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        }

        // Renderizar imagen decodificada
        return SizedBox(
          width: 80,
          height: 50,
          child: Ink.image(
            fit: BoxFit.fitHeight,
            image: MemoryImage(base64Decode(snapshot.data!)),
          ),
        );
      },
    );
  }
}
*/
//--------------------------------------------------------------------------
// OPTIMIZADO 1.0
/*
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

  // OPTIMIZACIÓN: Usaremos una sola variable Future para manejar ambas cargas en paralelo.
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

    debugPrintLevels(
      9,
      "PropiedadesListaFotosPromotor idusuario: $idUsuario, idPropiedad: $idPropiedad",
    );

    // OPTIMIZACIÓN: Carga inicial centralizada
    _cargarDatosIniciales();

    super.initState();
  }

  // OPTIMIZACIÓN: Método para cargar datos en paralelo usando Future.wait
  void _cargarDatosIniciales() {
    _futuresCombinados = Future.wait([
      recuperaFotosDePropiedades(ref, idUsuario, idPropiedad),
      recuperaFotosOrdenadasIdProperty(ref, idPropiedad),
    ]);
  }

  //-----------------------------------------------------------------------------
  // Ciclos de vida (Se mantienen igual, limpiando logs excesivos si se desea)
  /*
  @override
  void didChangeAppLifecycleState() {
    debugPrintLevels(
      1,
      " PropiedadesListaFotosPromotor didChangeAppLifecycleState",
    );
  }
  */

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(covariant PropiedadesListaFotosPromotor oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  void deactivate() {
    super.deactivate();
  }

  @override
  void dispose() {
    super.dispose();
  }
  //-----------------------------------------------------------------------------

  CuentaFotos cuentaFotos = CuentaFotos(rows: []);

  // OPTIMIZACIÓN: refreshData simplificado para recargar los Futures
  refreshData() {
    debugPrintLevels(9, "* PropiedadesListaFotosPromotor refreshData");
    setState(() {
      _cargarDatosIniciales();
    });
  }

  @override
  Widget build(BuildContext context) {
    debugPrintLevels(9, "* PaginaCarouselFotosWidget build");

    // OPTIMIZACIÓN: Asignar dimensiones una sola vez.
    // IMPORTANTE: Se eliminó setState(() {}) de aquí para evitar bucles infinitos.
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      key: scaffoldKeyFootosPromotor,
      // Se mantiene el AppBar comentado según código original
      body: FutureBuilder<List<dynamic>>(
        future: _futuresCombinados,
        builder: (context, snapshot) {
          // Manejo de estados de conexión unificados
          if (snapshot.connectionState == ConnectionState.waiting) {
            return stateWaiting(
              widthCuadroFotoPropiedad,
              heightCuadroFotoPropiedad,
            );
          } else if (snapshot.hasError) {
            return stateErrorFormat(
              widthCuadroFotoPropiedad,
              heightCuadroFotoPropiedad,
              snapshot.error,
            );
          } else if (snapshot.connectionState == ConnectionState.done) {
            // Procesamiento de resultados del primer Future (Fotos)
            final statusFotos = snapshot.data?[0] as int;

            if (statusFotos != 200) {
              numeroDeFotos = 0;
            } else {
              numeroDeFotos = ref.read(getListaFotosCasaProviderId).rows.length;
            }

            // Validación de consistencia de listas
            _validarConsistenciaListas();

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
                Expanded(child: _buildReorderableList()),

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

  /// OPTIMIZACIÓN: Método auxiliar para validar lógica de negocio antes de renderizar
  void _validarConsistenciaListas() {
    List<RowFotosCasaGetIDs> listaidfotos = [];
    List<FotosOrden> fotosordenadas = [];

    if (ref.read(getListaFotosCasaProviderId).rows.isNotEmpty) {
      listaidfotos = ref.read(getListaFotosCasaProviderId).rows;
    } else {
      ref.read(getListaFotosOrdenadasProvider).rows.clear();
    }

    if (ref.read(getListaFotosOrdenadasProvider).rows.isNotEmpty) {
      fotosordenadas = ref
          .read(getListaFotosOrdenadasProvider)
          .rows[0]
          .value
          .listadefotos
          .fotosOrden;
    }

    // Si la cantidad no coincide, limpiar el orden para forzar regeneración
    if (fotosordenadas.length != listaidfotos.length) {
      ref.read(getListaFotosOrdenadasProvider).rows.clear();
    }
  }

  /// OPTIMIZACIÓN: Extracción de la lista reordenable para limpieza del build
  Widget _buildReorderableList() {
    // Determinar si usamos la lista ordenada guardada o la lista por defecto
    bool usarOrdenGuardado =
        ref.read(getListaFotosOrdenadasProvider).rows.isNotEmpty &&
        (ref
            .read(getListaFotosOrdenadasProvider)
            .rows[0]
            .value
            .listadefotos
            .fotosOrden
            .isNotEmpty) &&
        (ref
                .read(getListaFotosOrdenadasProvider)
                .rows[0]
                .value
                .listadefotos
                .fotosOrden
                .length ==
            ref.read(getListaFotosCasaProviderId).rows.length);

    int itemCount = usarOrdenGuardado
        ? ref
              .read(getListaFotosOrdenadasProvider)
              .rows[0]
              .value
              .listadefotos
              .fotosOrden
              .length
        : ref.read(getListaFotosCasaProviderId).rows.length;

    return ReorderableListView.builder(
      itemCount: itemCount,
      onReorder: (oldIndex, newIndex) => _handleReorder(oldIndex, newIndex),
      itemBuilder: (context, index) {
        // Obtenemos los datos de la foto según el modo (Ordenado vs Default)
        RowFotosCasaGetIDs? fotoData;
        String keyString;

        if (usarOrdenGuardado) {
          var idFotoOrdenada = ref
              .read(getListaFotosOrdenadasProvider)
              .rows[0]
              .value
              .listadefotos
              .fotosOrden[index]
              .idFoto;

          // Buscamos la data real en la lista de fotos usando el ID
          try {
            fotoData = ref
                .read(getListaFotosCasaProviderId)
                .rows
                .firstWhere(
                  (element) => element.value.fotosCasa.idFoto == idFotoOrdenada,
                );
          } catch (e) {
            fotoData = null; // No encontrada
          }
          keyString = idFotoOrdenada; // Key única
        } else {
          fotoData = ref.read(getListaFotosCasaProviderId).rows[index];
          keyString = fotoData.value.fotosCasa.idFoto; // Key única
        }

        return _buildFotoItem(index, fotoData, ValueKey(keyString));
      },
    );
  }

  /// OPTIMIZACIÓN: Lógica de reordenamiento centralizada
  void _handleReorder(int oldIndex, int newIndex) {
    setState(() {
      int index = (newIndex > oldIndex) ? newIndex - 1 : newIndex;

      bool tieneOrdenPrevio = ref
          .read(getListaFotosOrdenadasProvider)
          .rows
          .isNotEmpty;

      if (tieneOrdenPrevio) {
        final listaOrden = ref
            .read(getListaFotosOrdenadasProvider)
            .rows[0]
            .value
            .listadefotos
            .fotosOrden;
        final item = listaOrden.removeAt(oldIndex);
        listaOrden.insert(index, item);

        // Actualizar indices internos si es necesario para consistencia
        for (int i = 0; i < listaOrden.length; i++) {
          listaOrden[i].posicion = i;
        }
      } else {
        // Trabajamos sobre la lista default si no hay orden guardado aun
        final listaDefault = ref.read(getListaFotosCasaProviderId).rows;
        final item = listaDefault.removeAt(oldIndex);
        listaDefault.insert(index, item);
      }
    });
  }

  /// OPTIMIZACIÓN: Widget extraído para evitar código duplicado (DRY)
  Widget _buildFotoItem(int index, RowFotosCasaGetIDs? data, Key key) {
    bool existeFoto = data != null && data.value.fotosCasa.foto != "";
    String fileName = existeFoto
        ? data.value.fotosCasa.filaname
        : "No encontrado";
    String sizeInfo = existeFoto ? "${data.value.fotosCasa.size} bytes" : "";

    return Container(
      key: key,
      margin: const EdgeInsets.fromLTRB(0, 0, 30, 0),
      padding: const EdgeInsets.fromLTRB(10, 0, 15, 8),
      child: ListTile(
        tileColor: appTheme.onPrimary,
        leading: CircleAvatar(
          radius: 15,
          backgroundColor: appTheme.surface,
          child: Text(
            (index + 1).toString(),
            style: TextStyle(
              fontSize: 14,
              color: appTheme.onPrimaryContainer,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: !existeFoto
                  ? SizedBox(
                      width: 100,
                      height: 50,
                      child: Center(
                        child: Text(
                          "No se encontró foto",
                          style: TextStyle(
                            fontSize: 10,
                            color: appTheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    )
                  : SizedBox(
                      width: 80,
                      height: 50,
                      child: Ink.image(
                        fit: BoxFit.fitHeight,
                        image: MemoryImage(
                          base64Decode(data.value.fotosCasa.foto),
                        ),
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
                      "Archivo: $fileName",
                      style: TextStyle(
                        color: appTheme.onPrimaryContainer,
                        fontSize: 10.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (existeFoto)
                      Text(
                        "Tamaño: $sizeInfo",
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
        ),
        trailing: IconButton(
          hoverColor: appTheme.tertiaryContainer,
          onPressed: () async {
            await borraFoto(
              context,
              ref,
              index,
              refreshData(), // Se pasa el resultado de la función, asumiendo firma original
            );
          },
          icon: Icon(Symbols.delete, color: appTheme.error),
        ),
        onTap: () async {},
      ),
    );
  }

  /// OPTIMIZACIÓN: Extracción del menú inferior para legibilidad
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

  /// OPTIMIZACIÓN: Lógica de guardado extraída
  void _guardarOrden() {
    ListaFotosOrdenadasGetIdPropiedad ordenfotos =
        ListaFotosOrdenadasGetIdPropiedad(totalRows: 0, offset: 0, rows: []);

    // Preparación del objeto a guardar
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

    // Si ya existe una lista, preservamos IDs y revisiones para actualizar
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

    // Generar la lista de orden basada en el estado actual del Provider
    // NOTA: Si estamos en modo "sin orden previo", el usuario ordenó la lista default.
    // Aquí asumimos que el drag&drop actualizó la lista correcta en _handleReorder.

    // Si no habia orden previo, debemos tomar los IDs de la lista default (getListaFotosCasaProviderId)
    // que fue modificada visualmente en el reorder, pero ojo: el ReorderableListView modifica
    // visualmente, nosotros actualizamos el provider en _handleReorder.

    bool estabaUsandoOrden = ref
        .read(getListaFotosOrdenadasProvider)
        .rows
        .isNotEmpty;
    int totalFotos = ref.read(getListaFotosCasaProviderId).rows.length;

    for (int i = 0; i < totalFotos; i++) {
      String idFotoActual;
      if (estabaUsandoOrden) {
        idFotoActual = ref
            .read(getListaFotosOrdenadasProvider)
            .rows[0]
            .value
            .listadefotos
            .fotosOrden[i]
            .idFoto;
      } else {
        // Si no habia orden, usamos el orden actual de la lista de fotos
        idFotoActual = ref
            .read(getListaFotosCasaProviderId)
            .rows[i]
            .value
            .fotosCasa
            .idFoto;
      }

      ordenfotos.rows[0].value.listadefotos.fotosOrden.add(
        FotosOrden(posicion: i, idFoto: idFotoActual),
      );
    }

    // Decidir si es Update o Create
    if (estabaUsandoOrden) {
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
*/
//--------------------------------------------------------------------------
/*
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
  //
  final scaffoldKeyFootosPromotor = GlobalKey<ScaffoldState>();
  String idUsuario = "";
  String idPropiedad = "";
  String nombrePropiedad = "";
  int numeroDeFotos = 0;

  late Future<int> _recuperaFotosDePropiedades;
  late Future<int> _recuperaListaFotosOrden;

  @override
  void initState() {
    // debugPrintLevels(9, "****************************************");
    debugPrintLevels(9, "* PropiedadesListaFotosPromotor initState");
    // debugPrintLevels(9, "****************************************");

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
      "PropiedadesListaFotosPromotor idusuario: ${widget.valueespaciosparameter.espacioscasa.idusuario}",
    );
    debugPrintLevels(
      9,
      "PropiedadesListaFotosPromotor idPropiedad: ${widget.valueespaciosparameter.espacioscasa.idPropiedad}",
    );
    debugPrintLevels(9, "* PropiedadesListaFotosPromotor initState end");
    //-----------------------------------------------------------------------------
    _recuperaFotosDePropiedades = recuperaFotosDePropiedades(
      ref,
      idUsuario,
      idPropiedad,
    );

    _recuperaListaFotosOrden = recuperaFotosOrdenadasIdProperty(
      ref,
      idPropiedad,
    );
    //-----------------------------------------------------------------------------
    super.initState();
  }

  //-----------------------------------------------------------------------------
  void didChangeAppLifecycleState() {
    debugPrintLevels(
      1,
      " PropiedadesListaFotosPromotor didChangeAppLifecycleState",
    );
  }

  @override
  void didChangeDependencies() {
    debugPrintLevels(1, " PropiedadesListaFotosPromotor didChangeDependencies");
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(covariant PropiedadesListaFotosPromotor oldWidget) {
    debugPrintLevels(1, " PropiedadesListaFotosPromotor didUpdateWidget");
    super.didUpdateWidget(oldWidget);
  }

  @override
  void deactivate() {
    debugPrintLevels(1, " PropiedadesListaFotosPromotor deactivate");
    super.deactivate();
  }

  @override
  void dispose() {
    debugPrintLevels(1, " PropiedadesListaFotosPromotor dispose");
    super.dispose();
  }
  //-----------------------------------------------------------------------------

  // GUARDA LA LISTA DE IDS DE LAS FOTOS EN LA LISTA DE LA PROPIEDAD

  // GUARDA EL NUMERO DE FOTOS DE LA PROPIEDAD
  CuentaFotos cuentaFotos = CuentaFotos(rows: []);

  // ignore: strict_top_level_inference
  refreshData() {
    debugPrintLevels(
      9,
      "* PropiedadesListaFotosPromotor _recuperaFotosDePropiedades",
    );

    _recuperaFotosDePropiedades = recuperaFotosDePropiedades(
      ref,
      idUsuario,
      idPropiedad,
    ); // Assign a new future to trigger refresh

    debugPrintLevels(
      9,
      "* PropiedadesListaFotosPromotor _recuperaListaFotosOrden",
    );

    if (ref.read(getListaFotosOrdenadasProvider).rows.isNotEmpty) {
      _recuperaListaFotosOrden = recuperaFotosOrdenadasIdProperty(
        ref,
        idPropiedad,
      );
    }

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
    setState(() {});

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
          "Fotos de la Propiedad",
          style: TextStyle(
            color: Theme.of(context).colorScheme.onPrimary,
            fontWeight: FontWeight.normal,
            fontSize: 12,
          ),
        ),
      ),
      */
      body: FutureBuilder<int>(
        // OBTIENE EL NUMERO DE FOTOS DE LA PROPIEDAD Y EL USUARIO
        future: _recuperaFotosDePropiedades,
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
                // CHECA QUE LA LISTA NO ESTE VACIA
                if (snapshotNumImagenes.data! != 200) {
                  debugPrintLevels(9, "** numero de fotos vacio");
                  numeroDeFotos = 0;
                } else {
                  debugPrintLevels(
                    9,
                    "** numero de fotos recuperadas: ${ref.read(getListaFotosCasaProviderId).rows.length}",
                  );
                  numeroDeFotos = ref
                      .read(getListaFotosCasaProviderId)
                      .rows
                      .length;
                }
                //------------------------------------------------------
                return FutureBuilder<int>(
                  // OBTIENE LA LISTA DE LAS FOTOS
                  future: _recuperaListaFotosOrden,
                  builder: (context, snapshotOrdenFotos) {
                    switch (snapshotOrdenFotos.connectionState) {
                      case ConnectionState.none:
                        debugPrintLevels(
                          9,
                          "FutureBuilder _recuperaListaFotosOrden: none",
                        );
                        return const Text("Sin resultados");
                      case ConnectionState.waiting:
                        debugPrintLevels(
                          9,
                          "FutureBuilder _recuperaListaFotosOrden: CircularProgressIndicator",
                        );
                        return Center(
                          child: CircularProgressIndicator(
                            color: appTheme.primary,
                          ),
                        );
                      case ConnectionState.active:
                        debugPrintLevels(
                          9,
                          "FutureBuilder _recuperaListaFotosOrden: active",
                        );
                        return const Center(child: Text("Esperando datos"));
                      case ConnectionState.done:
                        if (snapshotOrdenFotos.hasError) {
                          debugPrintLevels(
                            9,
                            "FutureBuilder _recuperaListaFotosOrden: done Error",
                          );
                          return Center(
                            child: Text("Error: ${snapshotOrdenFotos.error}"),
                          );
                        }
                        // CHECA QUE LA LISTA NO ESTE VACIA
                        //----------------------------------------------------------------
                        debugPrintLevels(
                          9,
                          "FutureBuilder _recuperaListaFotosOrden length: ${ref.read(getListaFotosOrdenadasProvider).rows.length}",
                        );
                        List<RowFotosCasaGetIDs> listaidfotos = [];
                        List<FotosOrden> fotosordenadas = [];
                        if (ref
                            .read(getListaFotosCasaProviderId)
                            .rows
                            .isNotEmpty) {
                          listaidfotos = ref
                              .read(getListaFotosCasaProviderId)
                              .rows;
                          for (
                            int i = 0;
                            i <
                                ref
                                    .read(getListaFotosCasaProviderId)
                                    .rows
                                    .length;
                            i++
                          ) {
                            debugPrintLevels(
                              10,
                              "LISTA FOTOS getListaFotosCasaProviderId: POS:$i: ID:${listaidfotos[i].value.fotosCasa.idFoto}",
                            );
                          }
                        } else {
                          debugPrintLevels(10, "LISTA DE FOTOS VACIA");
                          ref.read(getListaFotosOrdenadasProvider).rows.clear();
                        }
                        if (ref
                            .read(getListaFotosOrdenadasProvider)
                            .rows
                            .isNotEmpty) {
                          fotosordenadas = ref
                              .read(getListaFotosOrdenadasProvider)
                              .rows[0]
                              .value
                              .listadefotos
                              .fotosOrden;
                          for (
                            int i = 0;
                            i <
                                ref
                                    .read(getListaFotosOrdenadasProvider)
                                    .rows[0]
                                    .value
                                    .listadefotos
                                    .fotosOrden
                                    .length;
                            i++
                          ) {
                            debugPrintLevels(
                              10,
                              "LISTA ORDENADA getListaFotosOrdenadasProvider: POS:${fotosordenadas[i].posicion}: ID:${fotosordenadas[i].idFoto}",
                            );
                          }
                        } else {
                          debugPrintLevels(10, "LISTA DE FOTOS ORDENADA VACIA");
                        }
                        if (fotosordenadas.length != listaidfotos.length) {
                          ref.read(getListaFotosOrdenadasProvider).rows.clear();
                        }

                        //------------------------------------------------------
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
                            // GENERA CONTENEDOR DE LA LISTA DE FOTOS
                            Container(color: appTheme.surface, height: 8),
                            Expanded(
                              child: ReorderableListView(
                                //  onReorderStart: () {},
                                //  padding: const EdgeInsets.all(8),
                                onReorder: (oldIndex, newIndex) {
                                  (ref
                                          .read(getListaFotosOrdenadasProvider)
                                          .rows
                                          .isNotEmpty)
                                      ? setState(() {
                                          final index = (newIndex > oldIndex)
                                              ? newIndex - 1
                                              : newIndex;
                                          final espacio = ref
                                              .read(
                                                getListaFotosOrdenadasProvider,
                                              )
                                              .rows[0]
                                              .value
                                              .listadefotos
                                              .fotosOrden
                                              .removeAt(oldIndex);
                                          ref
                                              .read(
                                                getListaFotosOrdenadasProvider,
                                              )
                                              .rows[0]
                                              .value
                                              .listadefotos
                                              .fotosOrden
                                              .insert(index, espacio);
                                        })
                                      : setState(() {
                                          final index = (newIndex > oldIndex)
                                              ? newIndex - 1
                                              : newIndex;
                                          final espacio = ref
                                              .read(getListaFotosCasaProviderId)
                                              .rows
                                              .removeAt(oldIndex);
                                          ref
                                              .read(getListaFotosCasaProviderId)
                                              .rows
                                              .insert(index, espacio);
                                        });
                                },
                                children:
                                    (ref
                                        .read(getListaFotosOrdenadasProvider)
                                        .rows
                                        .isEmpty)
                                    ? // CASO: NO TIENE LISTA DE ORDEN
                                      List.generate(
                                        ref
                                            .read(getListaFotosCasaProviderId)
                                            .rows
                                            .length,
                                        (index) {
                                          return Container(
                                            key: ValueKey(
                                              ref
                                                  .read(
                                                    getListaFotosCasaProviderId,
                                                  )
                                                  .rows[index]
                                                  .value,
                                            ),
                                            margin: const EdgeInsets.fromLTRB(
                                              0,
                                              0,
                                              30,
                                              0,
                                            ),
                                            padding: const EdgeInsets.fromLTRB(
                                              10,
                                              0,
                                              15,
                                              8,
                                            ),
                                            child: ListTile(
                                              tileColor: appTheme.onPrimary,
                                              //contentPadding: const EdgeInsets.all(8),
                                              leading: CircleAvatar(
                                                radius: 15,
                                                backgroundColor:
                                                    appTheme.surface,
                                                child: Text(
                                                  (index + 1).toString(),
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    color: appTheme
                                                        .onPrimaryContainer,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                  ),
                                                ),
                                              ),
                                              style: ListTileStyle.list,
                                              title: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child:
                                                        (ref
                                                                .read(
                                                                  getListaFotosCasaProviderId,
                                                                )
                                                                .rows[index]
                                                                .value
                                                                .fotosCasa
                                                                .foto ==
                                                            "")
                                                        ? SizedBox(
                                                            width: 100,
                                                            height: 50,
                                                            child: Center(
                                                              child: Text(
                                                                "No se encontro foto",
                                                                style: TextStyle(
                                                                  fontSize: 10,
                                                                  color: appTheme
                                                                      .primary,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                              ),
                                                            ),
                                                          )
                                                        : SizedBox(
                                                            width: 80,
                                                            height: 50,
                                                            child: Ink.image(
                                                              fit: BoxFit
                                                                  .fitHeight, // https://api.flutter.dev/flutter/painting/BoxFit.html
                                                              image: MemoryImage(
                                                                base64Decode(
                                                                  ref
                                                                      .read(
                                                                        getListaFotosCasaProviderId,
                                                                      )
                                                                      .rows[index]
                                                                      .value
                                                                      .fotosCasa
                                                                      .foto,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                  ),
                                                  const SizedBox(width: 8),
                                                  Expanded(
                                                    flex: 12,
                                                    child: Container(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            "Archivo: ${ref.read(getListaFotosCasaProviderId).rows[index].value.fotosCasa.filaname}",
                                                            style: TextStyle(
                                                              color: appTheme
                                                                  .onPrimaryContainer,
                                                              fontSize: 10.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                          Text(
                                                            "Tamaño: ${ref.read(getListaFotosCasaProviderId).rows[index].value.fotosCasa.size.toString()} bytes",
                                                            style: TextStyle(
                                                              color: appTheme
                                                                  .onPrimaryContainer,
                                                              fontSize: 8.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              // BOTON DE BORRADO FOTO
                                              trailing: IconButton(
                                                hoverColor:
                                                    appTheme.tertiaryContainer,
                                                onPressed: () async {
                                                  await borraFoto(
                                                    context,
                                                    ref,
                                                    index,
                                                    refreshData(),
                                                  );
                                                },
                                                icon: Icon(
                                                  Symbols.delete,
                                                  color: appTheme.error,
                                                ),
                                              ),

                                              // ONTAP TILEVIEW
                                              onTap: () async {},
                                            ),
                                          );
                                        },
                                      )
                                    : ((ref
                                              .read(
                                                getListaFotosOrdenadasProvider,
                                              )
                                              .rows[0]
                                              .value
                                              .listadefotos
                                              .fotosOrden
                                              .isNotEmpty) &&
                                          (ref
                                                  .read(
                                                    getListaFotosOrdenadasProvider,
                                                  )
                                                  .rows[0]
                                                  .value
                                                  .listadefotos
                                                  .fotosOrden
                                                  .length ==
                                              ref
                                                  .read(
                                                    getListaFotosCasaProviderId,
                                                  )
                                                  .rows
                                                  .length))
                                    ? // CASO: TIENE LISTA CON ORDEN DE FOTOS
                                      List.generate(
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
                                          List<RowFotosCasaGetIDs>
                                          fichaPropiedad = ref
                                              .read(getListaFotosCasaProviderId)
                                              .rows
                                              .where(
                                                (test) =>
                                                    test
                                                        .value
                                                        .fotosCasa
                                                        .idFoto ==
                                                    ref
                                                        .read(
                                                          getListaFotosOrdenadasProvider,
                                                        )
                                                        .rows[0]
                                                        .value
                                                        .listadefotos
                                                        .fotosOrden[index]
                                                        .idFoto,
                                              )
                                              .toList();
                                          if (fichaPropiedad.isNotEmpty) {
                                            debugPrintLevels(
                                              10,
                                              "fichaPropiedad: ${fichaPropiedad[0].value.fotosCasa.idFoto}",
                                            );
                                          } else {
                                            debugPrintLevels(
                                              10,
                                              "fichaPropiedad: VACIAs",
                                            );
                                          }
                                          return Container(
                                            key: ValueKey(
                                              ref
                                                  .read(
                                                    getListaFotosOrdenadasProvider,
                                                  )
                                                  .rows[0]
                                                  .value
                                                  .listadefotos
                                                  .fotosOrden[index],
                                            ),
                                            margin: const EdgeInsets.fromLTRB(
                                              0,
                                              0,
                                              30,
                                              0,
                                            ),
                                            padding: const EdgeInsets.fromLTRB(
                                              10,
                                              0,
                                              15,
                                              8,
                                            ),
                                            child: ListTile(
                                              tileColor: appTheme.onPrimary,
                                              //contentPadding: const EdgeInsets.all(8),
                                              // CIRCULO CON LA POSICION
                                              leading: CircleAvatar(
                                                radius: 15,
                                                backgroundColor:
                                                    appTheme.surface,
                                                child: Text(
                                                  (index + 1).toString(),
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    color: appTheme
                                                        .onPrimaryContainer,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                  ),
                                                ),
                                              ),
                                              style: ListTileStyle.list,
                                              // FOTO, TITULO Y SUBTITULO
                                              title: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child:
                                                        (fichaPropiedad[0]
                                                                .value
                                                                .fotosCasa
                                                                .foto ==
                                                            "")
                                                        ? // CASO: FOTO VACIA
                                                          SizedBox(
                                                            width: 100,
                                                            height: 50,
                                                            child: Center(
                                                              child: Text(
                                                                "No se encontro foto",
                                                                style: TextStyle(
                                                                  fontSize: 10,
                                                                  color: appTheme
                                                                      .primary,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                              ),
                                                            ),
                                                          )
                                                        : // CASO: FOTO
                                                          SizedBox(
                                                            width: 80,
                                                            height: 50,
                                                            child: Ink.image(
                                                              fit: BoxFit
                                                                  .fitHeight, // https://api.flutter.dev/flutter/painting/BoxFit.html
                                                              image: MemoryImage(
                                                                base64Decode(
                                                                  fichaPropiedad[0]
                                                                      .value
                                                                      .fotosCasa
                                                                      .foto,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                  ),
                                                  //  ),
                                                  const SizedBox(width: 8),
                                                  // DATOS DE LA FOTO
                                                  Expanded(
                                                    flex: 12,
                                                    child: Container(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                        // LETRERO
                                                          Text(
                                                            "Archivo: ${fichaPropiedad[0].value.fotosCasa.filaname}",
                                                            style: TextStyle(
                                                              color: appTheme
                                                                  .onPrimaryContainer,
                                                              fontSize: 10.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                          Text(
                                                            "Tamaño: ${fichaPropiedad[0].value.fotosCasa.size.toString()} bytes",
                                                            style: TextStyle(
                                                              color: appTheme
                                                                  .onPrimaryContainer,
                                                              fontSize: 8.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              // BOTOM DE BORRADO FOTO
                                              trailing: IconButton(
                                                hoverColor:
                                                    appTheme.tertiaryContainer,
                                                onPressed: () async {
                                                  await borraFoto(
                                                    context,
                                                    ref,
                                                    index,
                                                    refreshData(),
                                                  );
                                                },
                                                icon: Icon(
                                                  Symbols.delete,
                                                  color: appTheme.error,
                                                ),
                                              ),
                                              // ONTAP TILEVIEW
                                              onTap: () async {},
                                            ),
                                          );
                                        },
                                      )
                                    : // CASO: NO TIENE LISTA DE ORDEN O NO COINCIDE TAMAÑO
                                      List.generate(
                                        ref
                                            .read(getListaFotosCasaProviderId)
                                            .rows
                                            .length,
                                        (index) {
                                          //    ref.read(getListaFotosOrdenadasProvider).rows.clear();
                                          return Container(
                                            key: ValueKey(
                                              ref
                                                  .read(
                                                    getListaFotosCasaProviderId,
                                                  )
                                                  .rows[index]
                                                  .value,
                                            ),
                                            margin: const EdgeInsets.fromLTRB(
                                              0,
                                              0,
                                              30,
                                              0,
                                            ),
                                            padding: const EdgeInsets.fromLTRB(
                                              10,
                                              0,
                                              15,
                                              8,
                                            ),
                                            child: ListTile(
                                              tileColor: appTheme.onPrimary,
                                              //contentPadding: const EdgeInsets.all(8),
                                              leading: CircleAvatar(
                                                radius: 15,
                                                backgroundColor:
                                                    appTheme.surface,
                                                child: Text(
                                                  (index + 1).toString(),
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    color: appTheme
                                                        .onPrimaryContainer,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                  ),
                                                ),
                                              ),
                                              style: ListTileStyle.list,
                                              title: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child:
                                                        (ref
                                                                .read(
                                                                  getListaFotosCasaProviderId,
                                                                )
                                                                .rows[index]
                                                                .value
                                                                .fotosCasa
                                                                .foto ==
                                                            "")
                                                        ? SizedBox(
                                                            width: 100,
                                                            height: 50,
                                                            child: Center(
                                                              child: Text(
                                                                "No se encontro foto",
                                                                style: TextStyle(
                                                                  fontSize: 10,
                                                                  color: appTheme
                                                                      .primary,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                              ),
                                                            ),
                                                          )
                                                        : SizedBox(
                                                            width: 80,
                                                            height: 50,
                                                            child: Ink.image(
                                                              fit: BoxFit
                                                                  .fitHeight, // https://api.flutter.dev/flutter/painting/BoxFit.html
                                                              image: MemoryImage(
                                                                base64Decode(
                                                                  ref
                                                                      .read(
                                                                        getListaFotosCasaProviderId,
                                                                      )
                                                                      .rows[index]
                                                                      .value
                                                                      .fotosCasa
                                                                      .foto,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                  ),
                                                  const SizedBox(width: 8),
                                                  Expanded(
                                                    flex: 12,
                                                    child: Container(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            "Archivo: ${ref.read(getListaFotosCasaProviderId).rows[index].value.fotosCasa.filaname}",
                                                            style: TextStyle(
                                                              color: appTheme
                                                                  .onPrimaryContainer,
                                                              fontSize: 10.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                          Text(
                                                            "Tamaño: ${ref.read(getListaFotosCasaProviderId).rows[index].value.fotosCasa.size.toString()} bytes",
                                                            style: TextStyle(
                                                              color: appTheme
                                                                  .onPrimaryContainer,
                                                              fontSize: 8.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              // BOTON DE BORRADO FOTO
                                              trailing: IconButton(
                                                hoverColor:
                                                    appTheme.tertiaryContainer,
                                                onPressed: () async {
                                                  await borraFoto(
                                                    context,
                                                    ref,
                                                    index,
                                                    refreshData(),
                                                  );
                                                },
                                                icon: Icon(
                                                  Symbols.delete,
                                                  color: appTheme.error,
                                                ),
                                              ),
                                              // ONTAP TILEVIEW
                                              onTap: () async {},
                                            ),
                                          );
                                        },
                                      ),
                              ),
                            ),
                            Container(color: appTheme.surface, height: 8),
                            // BOTONES MENU INFERIOR
                            if (ref.read(menuPrincipalProvider).etiqueta ==
                                iconoTuCuenta.etiqueta)
                              Container(
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
                                              appTheme.primary,
                                            ),
                                      ),
                                      child: Icon(
                                        Symbols.add,
                                        size: 18,
                                        color: appTheme.onPrimary,
                                      ),
                                      onPressed: () async {
                                        await agregafoto(
                                          context,
                                          ref,
                                          widget.valueespaciosparameter,
                                        );
                                        setState(() {
                                          refreshData();
                                        });
                                      },
                                    ),
                                    const SizedBox(width: 5),
                                    // GUARDAR ORDEN DE FOTOS
                                    ElevatedButton(
                                      style: ButtonStyle(
                                        backgroundColor:
                                            WidgetStatePropertyAll<Color>(
                                              appTheme.primary,
                                            ),
                                      ),
                                      child: Icon(
                                        Symbols.save,
                                        size: 18,
                                        color: appTheme.onPrimary,
                                      ),
                                      onPressed: () {
                                        // guarda orden de las fotos
                                        ListaFotosOrdenadasGetIdPropiedad
                                        ordenfotos =
                                            ListaFotosOrdenadasGetIdPropiedad(
                                              totalRows: 0,
                                              offset: 0,
                                              rows: [],
                                            );
                                        if (ref
                                            .read(
                                              getListaFotosOrdenadasProvider,
                                            )
                                            .rows
                                            .isNotEmpty) {
                                          // CASO LISTA ORDENADA
                                          // ASIGNA ID Y REV A LA LISTA
                                          ordenfotos.rows.add(
                                            RowGetIdPropiedad(
                                              id: "",
                                              key: "",
                                              value: ValueGetIdPropiedad(
                                                id: "",
                                                rev: "",
                                                listadefotos:
                                                    ListaFotosOrdenadas(
                                                      idListaFotos: "",
                                                      idUsuario: idUsuario,
                                                      idPropiedad: idPropiedad,
                                                      fotosOrden: [],
                                                      timestamp: "",
                                                    ),
                                              ),
                                            ),
                                          );
                                          ordenfotos.rows[0].id = ref
                                              .read(
                                                getListaFotosOrdenadasProvider,
                                              )
                                              .rows[0]
                                              .id;
                                          ordenfotos.rows[0].key = ref
                                              .read(
                                                getListaFotosOrdenadasProvider,
                                              )
                                              .rows[0]
                                              .key;
                                          ordenfotos.rows[0].value.id = ref
                                              .read(
                                                getListaFotosOrdenadasProvider,
                                              )
                                              .rows[0]
                                              .value
                                              .id;
                                          ordenfotos.rows[0].value.rev = ref
                                              .read(
                                                getListaFotosOrdenadasProvider,
                                              )
                                              .rows[0]
                                              .value
                                              .rev;
                                          ordenfotos
                                              .rows[0]
                                              .value
                                              .listadefotos
                                              .idListaFotos = ref
                                              .read(
                                                getListaFotosOrdenadasProvider,
                                              )
                                              .rows[0]
                                              .value
                                              .listadefotos
                                              .idListaFotos;
                                          ordenfotos
                                                  .rows[0]
                                                  .value
                                                  .listadefotos
                                                  .idUsuario =
                                              idUsuario;
                                          ordenfotos
                                                  .rows[0]
                                                  .value
                                                  .listadefotos
                                                  .idPropiedad =
                                              idPropiedad;

                                          for (
                                            int i = 0;
                                            i <
                                                ref
                                                    .read(
                                                      getListaFotosOrdenadasProvider,
                                                    )
                                                    .rows[0]
                                                    .value
                                                    .listadefotos
                                                    .fotosOrden
                                                    .length;
                                            i++
                                          ) {
                                            ordenfotos
                                                .rows[0]
                                                .value
                                                .listadefotos
                                                .fotosOrden
                                                .add(
                                                  FotosOrden(
                                                    posicion: i,
                                                    idFoto: ref
                                                        .read(
                                                          getListaFotosOrdenadasProvider,
                                                        )
                                                        .rows[0]
                                                        .value
                                                        .listadefotos
                                                        .fotosOrden[i]
                                                        .idFoto,
                                                  ),
                                                );
                                          }
                                        } else {
                                          // CASO LISTA ORDENADA VACIA
                                          ordenfotos.rows.add(
                                            RowGetIdPropiedad(
                                              id: "",
                                              key: "",
                                              value: ValueGetIdPropiedad(
                                                id: "",
                                                rev: "",
                                                listadefotos:
                                                    ListaFotosOrdenadas(
                                                      idListaFotos: '',
                                                      idUsuario: '',
                                                      idPropiedad: '',
                                                      fotosOrden: [],
                                                      timestamp: '',
                                                    ),
                                              ),
                                            ),
                                          );
                                          ordenfotos
                                                  .rows[0]
                                                  .value
                                                  .listadefotos
                                                  .idUsuario =
                                              idUsuario;
                                          ordenfotos
                                                  .rows[0]
                                                  .value
                                                  .listadefotos
                                                  .idPropiedad =
                                              idPropiedad;
                                          for (
                                            int i = 0;
                                            i <
                                                ref
                                                    .read(
                                                      getListaFotosCasaProviderId,
                                                    )
                                                    .rows
                                                    .length;
                                            i++
                                          ) {
                                            ordenfotos
                                                .rows[0]
                                                .value
                                                .listadefotos
                                                .fotosOrden
                                                .add(
                                                  FotosOrden(
                                                    posicion: i,
                                                    idFoto: ref
                                                        .read(
                                                          getListaFotosCasaProviderId,
                                                        )
                                                        .rows[i]
                                                        .value
                                                        .fotosCasa
                                                        .idFoto,
                                                  ),
                                                );
                                          }
                                        }
                                        if (ref
                                            .read(
                                              getListaFotosOrdenadasProvider,
                                            )
                                            .rows
                                            .isNotEmpty) {
                                          // LISTA ORDENADA EXISTENTE
                                          debugPrintLevels(
                                            10,
                                            "ACTUALIZA: actualizaFotosOrdenadas:${ordenfotos.rows[0].value}",
                                          );
                                          actualizaFotosOrdenadas(
                                            ordenfotos.rows[0].value,
                                          ).then((onValue) {
                                            return refreshData();
                                          });
                                        } else {
                                          // LISTA ORDENADA VACIA
                                          debugPrintLevels(
                                            10,
                                            "CREA: actualizaFotosOrdenadas:${ordenfotos.rows[0].value.listadefotos}",
                                          );
                                          guardaFotosOrdenadas(
                                            ordenfotos
                                                .rows[0]
                                                .value
                                                .listadefotos,
                                          ).then((onValue) {
                                            return refreshData();
                                          });
                                        }
                                        //  Navigator.of(context).pop();
                                      },
                                    ),
                                    const SizedBox(width: 5),
                                    // REFRESH LISTA
                                    ElevatedButton(
                                      style: ButtonStyle(
                                        backgroundColor:
                                            WidgetStatePropertyAll<Color>(
                                              appTheme.primary,
                                            ),
                                      ),
                                      child: Icon(
                                        Symbols.refresh,
                                        size: 18,
                                        color: appTheme.onPrimary,
                                      ),
                                      onPressed: () {
                                        refreshData();
                                      },
                                    ),
                                  ],
                                ),
                              ),
                          ],
                          //),
                        );
                    }
                  },
                );
              }
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: appTheme.primary,
        onPressed: () async {
          await agregafoto(context, ref, widget.valueespaciosparameter);
          setState(() {
            refreshData();
          });
        },
        child: Icon(Symbols.add, size: 18, color: appTheme.onPrimary),
      ),
    );
  }
}
*/
