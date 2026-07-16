import 'package:buscobien/03_listas/data_lista_propiedad.dart';
import 'package:buscobien/03_listas/data_lista_propiedad_get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';
import '../08_pantallas/inicio/data_espacios_casas_get.dart';
import '../08_pantallas/inicio/widget_wrap_modern_card.dart';
import '../08_pantallas/tu_cuenta/tus_espacios/provider_espacios_casa_get.dart';
import '../20_var_globales/var_color_themes.dart';
import '../40_security/urls_endpoints_espacios.dart';
import '../60_global_widgets/debugprint.dart';
import 'data_user_list_model.dart';
import 'provider_listas_propiedades.dart';

// OPTIMIZADO 25 02 11
// CAMBIOS DE FETCH Y DELETE
// -----------------------------------------------------------------------------

// Asegúrate de importar tus archivos de configuración y providers
// import '../20_var_globales/var_globales.dart';
// import 'provider_listas_propiedades.dart';
// import 'data_user_list_model.dart';

class PageDetalleLista extends ConsumerStatefulWidget {
  final Lista lista;
  /*
  class Lista {
    String listaId;
    String userId;
    String listName;
    String type;
    String timestamp;
  */
  // Ajustado al modelo que usas en el provider
  /*
  class Listapropiedad {
    String listapropiedadId; // ID del documento en CouchDB
    String userId;
    String listaId;
    String propertyId;
    String tipodeespacio;
    String type;
    String timestamp;
  */

  const PageDetalleLista(this.lista, {super.key});

  @override
  ConsumerState<PageDetalleLista> createState() => _PageDetalleListaState();
}

class _PageDetalleListaState extends ConsumerState<PageDetalleLista> {
  // Variable para controlar el estado de carga inicial
  late Future<int> _initialLoadFuture;

  String propertyId = "";
  String listapropiedadId = "";

  // Busca la propiedad en todos los endpoints cuando tipodeespacio está vacío
  // (ocurre con entradas antiguas de Favoritas que no almacenaron tipodeespacio).
  Future<EspaciosCasaGet> _getPropiedadFallback(String idPropiedad) async {
    for (final tipo in endpointsPublicados.keys) {
      final resultado = await ref
          .read(espaciosCasaConListaFotosGetProvider.notifier)
          .getPropiedadCasaIdPropiedad(idPropiedad, tipo, endpointsPublicados);
      if (resultado.rows.isNotEmpty) return resultado;
    }
    return EspaciosCasaGet(totalRows: 0, offset: 0, rows: []);
  }

  RowListaProperty rowListProperty = RowListaProperty(
    id: '',
    key: '',
    listapropiedad: Listapropiedad(
      listapropiedadId: "",
      userId: "",
      listaId: "",
      propertyId: "",
      tipodeespacio: "",
      type: "",
      timestamp: "",
    ),
  );

  @override
  void initState() {
    super.initState();
    // OPTIMIZACIÓN: Iniciamos la carga aquí para evitar re-fetching en cada build
    // Usamos el ID de la lista para cargar las relaciones

    listapropiedadId = widget.lista.listaId;
    _initialLoadFuture = ref
        .read(listaPropiedadesProvider.notifier)
        .getListaPropiedad(widget.lista);
  }

  // FUNCIÓN SOLICITADA: Borrar propiedad de la lista usando listapropiedadId
  Future<bool> _borrarPropiedad(String listapropiedadId) async {
    // Llamamos a la función del provider (asumiendo que la agregaste en el paso anterior)
    return await ref
        .read(listaPropiedadesProvider.notifier)
        .borrarListapropiedadPorId(listapropiedadId);
  }

  @override
  Widget build(BuildContext context) {
    // Escuchamos el estado del provider para redibujar si hay cambios (ej. borrado)
    final listaProvider = ref.watch(listaPropiedadesProvider);

    return Scaffold(
      backgroundColor: appTheme.surface,
      appBar: AppBar(
        toolbarHeight: 50.0, // Altura estándar recomendada
        centerTitle: true,
        backgroundColor: appTheme.primary,
        iconTheme: IconThemeData(color: appTheme.onPrimary),
        title: Text(
          "Lista: ${widget.lista.listName}",
          style: TextStyle(
            color: appTheme.onPrimary,
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
      ),
      body: FutureBuilder<int>(
        future: _initialLoadFuture,
        // ref.read(listaPropiedadesProvider.notifier).getListaPropiedad(widget.lista);
        builder: (context, snapshot) {
          // Manejo de Estados de Conexión
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Puedes usar tu widget stateWaiting personalizado aquí
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error al cargar: ${snapshot.error}"));
          }
          // Validación de Lista Vacía
          if (listaProvider.rows.isEmpty) {
            debugPrintLevels(
              12,
              "Detalle lista provider, vacia: ${listaProvider.rows.length}",
            );

            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Symbols.folder_open,
                    size: 80,
                    color: appTheme.primary.withValues(alpha: 0.5),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    "Esta lista está vacía.",
                    style: TextStyle(
                      color: appTheme.primary,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            );
          } else {
            // OPTIMIZACIÓN: ListView.builder lineal (sin Wrap anidado)
            debugPrintLevels(
              12,
              "Detalle lista, no vacia, PROPIEDADES: ${listaProvider.rows.length}",
            );
            for (int i = 0; i < listaProvider.rows.length; i++) {
              debugPrintLevels(
                12,
                "Mis Listas, propiedad: $i, ID: ${listaProvider.rows[i].listapropiedad.propertyId}",
              );
            }
            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: listaProvider.rows.length,
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                //rowListProperty = listaProvider.rows[index];
                // Datos de la relación (Tabla intermedia)
                //listapropiedadId =
                //    rowListProperty.listapropiedad.listapropiedadId;
                //propertyId = rowListProperty.listapropiedad.propertyId;
                debugPrintLevels(
                  12,
                  "Detalle lista, ListView $index propertyId: ${listaProvider.rows[index].listapropiedad.propertyId}",
                );
                debugPrintLevels(12, "Detalle FutureBuilder go");
                return Dismissible(
                  key: Key(
                    listaProvider.rows[index].listapropiedad.propertyId,
                  ), // Llave única para el widget
                  direction: DismissDirection.endToStart,
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    decoration: BoxDecoration(
                      color: appTheme.error,
                      borderRadius: BorderRadius.circular(9),
                    ),
                    child: Icon(
                      Symbols.delete,
                      color: appTheme.onError,
                      size: 30,
                    ),
                  ),
                  confirmDismiss: (direction) async {
                    return await showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) => AlertDialog(
                        backgroundColor: appTheme.primary,
                        elevation: 6,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(6)),
                        ),
                        titlePadding: const EdgeInsets.fromLTRB(6, 12, 6, 6),
                        contentPadding: const EdgeInsets.all(3),
                        actionsPadding: const EdgeInsets.all(6),
                        title: Text(
                          "Quitar propiedad",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: appTheme.onPrimary,
                            fontSize: 14,
                            fontFamily: 'Comfortaa',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        content: SizedBox(
                          height: 80,
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12.0,
                              ),
                              child: Text(
                                "¿Deseas quitar esta propiedad de la lista?",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: appTheme.onPrimary,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                        ),
                        actions: [
                          TextButton(
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.fromLTRB(3, 0, 3, 0),
                              backgroundColor: appTheme.surface,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed: () => Navigator.of(context).pop(false),
                            child: Text(
                              "Cancelar",
                              style: TextStyle(
                                color: appTheme.primary,
                                fontSize: 12,
                                fontFamily: 'Comfortaa',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.fromLTRB(3, 0, 3, 0),
                              backgroundColor: appTheme.error,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed: () => Navigator.of(context).pop(true),
                            child: Text(
                              "Eliminar",
                              style: TextStyle(
                                color: appTheme.onError,
                                fontSize: 12,
                                fontFamily: 'Comfortaa',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  onDismissed: (direction) async {
                    // Fix: usar el listapropiedadId correcto de la fila actual
                    final lpId = listaProvider
                        .rows[index]
                        .listapropiedad
                        .listapropiedadId;
                    final success = await _borrarPropiedad(lpId);
                    if (!mounted) return;
                    if (success) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Propiedad eliminada de la lista"),
                        ),
                      );
                      // No necesitamos setState manual porque el Provider debería actualizar
                      // la lista 'rows' y el ref.watch disparará el rebuild.
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text("Error al eliminar"),
                          backgroundColor: appTheme.error,
                        ),
                      );
                      // Si falla, idealmente recargamos la lista para restaurar el item visualmente
                      // setState(() {});
                    }
                  },
                  // Widget auxiliar para cargar los detalles (Foto, Precio) de la propiedad
                  child: FutureBuilder<EspaciosCasaGet>(
                    future: listaProvider
                            .rows[index]
                            .listapropiedad
                            .tipodeespacio
                            .isEmpty
                        ? _getPropiedadFallback(
                            listaProvider
                                .rows[index]
                                .listapropiedad
                                .propertyId,
                          )
                        : ref
                            .read(
                              espaciosCasaConListaFotosGetProvider.notifier,
                            )
                            .getPropiedadCasaIdPropiedad(
                              listaProvider
                                  .rows[index]
                                  .listapropiedad
                                  .propertyId,
                              listaProvider
                                  .rows[index]
                                  .listapropiedad
                                  .tipodeespacio,
                              endpointsPublicados,
                            ),
                    builder: (context, snapshotPropiedad) {
                      // Manejo de Estados de Conexión
                      if (snapshotPropiedad.connectionState ==
                          ConnectionState.waiting) {
                        // Puedes usar tu widget stateWaiting personalizado aquí
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (snapshotPropiedad.hasError) {
                        return Center(
                          child: Text(
                            "Error al cargar datos de la propiedad: ${snapshotPropiedad.error}",
                          ),
                        );
                      }
                      // Validación de Lista Vacía
                      if (snapshotPropiedad.data!.rows.isEmpty) {
                        debugPrintLevels(
                          12,
                          "Detalle lista, vacia: ${listaProvider.rows.length}",
                        );
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Symbols.folder_open,
                                size: 80,
                                color: appTheme.primary.withValues(alpha: 0.5),
                              ),
                              const SizedBox(height: 15),
                              Text(
                                "No se encontro la propiedad.",
                                style: TextStyle(
                                  color: appTheme.primary,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        );
                      } else {
                        // DATOS DE LA PROPIEDAD ENCONTRADOS
                        debugPrintLevels(
                          12,
                          "Detalle lista, getPropiedadCasaIdPropiedad datosPropiedad $index idPropiedad: ${snapshotPropiedad.data!.rows[0].value.espacioscasa.idPropiedad}",
                        );
                        // Widget Dismissible para borrar deslizando
                        return Center(
                          child: WrapModernCardPropiedades(
                            0,
                            snapshotPropiedad.data!,
                          ),
                        );
                      }
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
