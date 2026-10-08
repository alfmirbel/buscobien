import 'dart:convert';

import 'package:buscobien/08_pantallas/inicio/data_espacios_casas_get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../07_routes/app_routes.dart';
import '../../../60_global_widgets/future_builder_state_widgets.dart';
import '../../../20_var_globales/var_color_themes.dart';
import '../../../20_var_globales/variables_globales.dart';
import '../../../22_imagenes/tus_espacios_fotos_propiedad/manejo_de_fotos/futures_y_providers/http_funciones_gestion_foto.dart';
import '../../../22_imagenes/tus_espacios_fotos_propiedad/manejo_de_fotos/lista_ids_fotos/data_fotos_get_ids_fotos_user_prop.dart';
import '../../../22_imagenes/tus_espacios_fotos_propiedad/manejo_de_fotos/futures_y_providers/future_recupera_ids_fotos_propiedad.dart';
import '../../../22_imagenes/variables_imagenes.dart';
import '../../../60_global_widgets/debugprint.dart';
import '../../../60_global_widgets/dialogbox_mensaje_general.dart';
import '../../inicio/catalogo_otras_caracteristicas.dart';
import '../../propiedades/pagina_detalle_propiedad.dart';
import '../../widgets_comunes/widget_letrero_tipo_transaccion.dart';
import 'http_publica_propiedad.dart';
import 'provider_espacios_casa_get.dart';

//------------------------------------------------------------------------------
// OPTIMIZADO 2.0
//------------------------------------------------------------------------------

class ConceptoEspacioRow extends StatelessWidget {
  final int index;
  final String concepto;
  final String valor;

  const ConceptoEspacioRow(this.index, this.concepto, this.valor, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: appTheme.onPrimary,
      width: 170,
      child: Row(
        children: [
          Expanded(
            flex: 7,
            child: Container(
              height: 20,
              color: appTheme.onPrimary,
              padding: const EdgeInsets.all(3),
              alignment: Alignment.centerLeft,
              child: Text(
                "$concepto:",
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.normal,
                  color: appTheme.onSurface,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Container(
              height: 20,
              color: appTheme.surface,
              padding: const EdgeInsets.all(1.5),
              alignment: Alignment.centerLeft,
              child: Text(
                valor,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.normal,
                  color: appTheme.onSurface,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class UbicacionEspacioRow extends StatelessWidget {
  final String concepto;
  final String valor;

  const UbicacionEspacioRow(this.concepto, this.valor, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: appTheme.onPrimary,
      width:
          widthCuadroFotoPropiedad, // Asegúrate que esta variable global sea constante o reactiva
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              height: 20,
              color: appTheme.surface,
              padding: const EdgeInsets.all(3),
              alignment: Alignment.centerLeft,
              child: Text(
                "$concepto:",
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.normal,
                  color: appTheme.onSurface,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              height: 20,
              color: appTheme.surface,
              padding: const EdgeInsets.all(1.5),
              alignment: Alignment.centerLeft,
              child: Text(
                valor,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.normal,
                  color: appTheme.onSurface,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

//------------------------------------------------------------------------------
// WIDGET PRINCIPAL
//------------------------------------------------------------------------------
class CreaFichaCapturaPropiedad extends ConsumerStatefulWidget {
  final int indexListaPropiedad;
  final ValueEspaciosCasaGet propiedad;
  final dynamic update;

  const CreaFichaCapturaPropiedad(
    // ignore: avoid_unused_constructor_parameters
    BuildContext context,
    this.indexListaPropiedad,
    this.propiedad,
    this.update, {
    super.key,
  });

  @override
  ConsumerState<CreaFichaCapturaPropiedad> createState() =>
      _CreaFichaCapturaPropiedadState();
}

class _CreaFichaCapturaPropiedadState
    extends ConsumerState<CreaFichaCapturaPropiedad> {
  late Future<GetIdsFotosUserProp> _futureIdsFotos;

  @override
  void initState() {
    super.initState();
    // Inicializamos el Future aquí para evitar recargas innecesarias al hacer setState
    _futureIdsFotos = recuperaIdsFotosDePropiedades(
      widget.propiedad.espacioscasa.idusuario,
      widget.propiedad.espacioscasa.idPropiedad,
    );
  }

  @override
  Widget build(BuildContext context) {
    debugPrintLevels(5, '** CREA FICHA CAPTURA PROPIEDAD');
    debugPrintLevels(
      5,
      "*** No. ${widget.indexListaPropiedad} creaFichaCapturaPropiedad id Genera Card: ${widget.propiedad.id}",
    );
    debugPrintLevels(
      10,
      '*** FOTO PRINCIPAL: ${widget.propiedad.espacioscasa.fotoprincipal}',
    );
    debugPrintLevels(10, '*** ACTIVA: ${widget.propiedad.espacioscasa.activa}');

    GetIdsFotosUserProp listaIdsFotos = GetIdsFotosUserProp(
      offset: 0,
      totalRows: 0,
      rows: [],
    );

    return Card(
      color: appTheme.surface,
      shadowColor: appTheme.secondary,
      elevation: 12.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6),
        side: BorderSide(
          color: appTheme.secondary,
          width: 1,
          style: BorderStyle.solid,
        ),
      ),
      margin: const EdgeInsets.all(6.0),
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: Column(
          children: [
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // BOTÓN MODIFICA DATOS DE LA PROPIEDAD --------------------------------------
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.editaespacio,
                      arguments: widget.propiedad,
                    );
                  },
                  child: _buildActionButton(
                    text: "Modificar",
                    bgColor: appTheme.primary,
                    textColor: appTheme.onPrimary,
                  ),
                ),

                // BOTÓN DE PUBLICACIÓN DE LA PROPIEDAD
                GestureDetector(
                  onTap: () async {
                    await openDialogPublicar(context);
                    if (mounted) setState(() {});
                  },
                  child: _buildActionButton(
                    text: "Publicar",
                    bgColor: appTheme.primary,
                    textColor: (widget.propiedad.espacioscasa.activa == 0)
                        ? appTheme.onPrimary
                        : appTheme
                              .onPrimary, // Optimización: lógica simplificada visualmente
                  ),
                ),

                // BOTÓN DE BORRADO DE LA PUBLICACIÓN DE LA PROPIEDAD
                GestureDetector(
                  onTap: (widget.propiedad.espacioscasa.activa == 0)
                      ? null // Deshabilita el onTap si no está activa
                      : () async {
                          await openDialogBorraPublicacion(context);
                          if (mounted) setState(() {});
                        },
                  child: _buildActionButton(
                    text: "Dejar de publicar",
                    bgColor: (widget.propiedad.espacioscasa.activa == 0)
                        ? appTheme.secondary
                        : appTheme.primary,
                    textColor: (widget.propiedad.espacioscasa.activa == 0)
                        ? appTheme.primaryContainer
                        : appTheme.onPrimary,
                    fontWeight: (widget.propiedad.espacioscasa.activa == 0)
                        ? FontWeight.normal
                        : FontWeight.bold,
                  ),
                ),
              ],
            ),

            // BORRAR ESPACIO
            const SizedBox(height: 6),
            GestureDetector(
              onTap: (widget.propiedad.espacioscasa.activa == 0)
                  ? () async {
                      await openDialogBorraEspacio(context);
                      if (mounted) setState(() {});
                    }
                  : () async {
                      await showMessageDialog(
                        context,
                        "Aviso",
                        "Para borrar el especio debes\ndejar de publicarlo.",
                        appTheme.error,
                        TextAlign.center,
                        "Salir",
                      );
                    },
              child: Container(
                width: 500,
                alignment: Alignment.center,
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: appTheme.error,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: appTheme.error, width: 2),
                ),
                child: Text(
                  "Eliminar el espacio de publicación",
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  style: TextStyle(
                    fontSize: fontSizeSubtituloPagina,
                    fontWeight: FontWeight.normal,
                    color: appTheme.onError,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10),
            // TIPO DE PROPIEDAD
            Container(
              width: 350,
              padding: const EdgeInsets.fromLTRB(5.0, 1, 1.5, 5),
              color: appTheme.onSecondary,
              alignment: Alignment.center,
              child: Text(
                widget.propiedad.espacioscasa.tipodepropiedad,
                maxLines: 3,
                overflow: TextOverflow.visible,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: appTheme.onPrimaryContainer,
                ),
              ),
            ),
            const SizedBox(height: 10),

            // NOMBRE DE LA PROPIEDAD
            Container(
              width: 350,
              padding: const EdgeInsets.fromLTRB(5.0, 1, 1.5, 5),
              color: appTheme.onPrimary,
              alignment: Alignment.topLeft,
              child: Text(
                widget.propiedad.espacioscasa.nombredelapropiedad,
                maxLines: 3,
                overflow: TextOverflow.visible,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.normal,
                  color: appTheme.onPrimaryContainer,
                ),
              ),
            ),

            // CUADRO DE LA FOTO PRINCIPAL -----------------------------------------
            SizedBox(
              width: 350,
              height: 250,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // CARGA FOTO PRINCIPAL
                  Container(
                    alignment: Alignment.topCenter,
                    child: InkWell(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          AppRoutes.fotospropiedad,
                          arguments: widget.propiedad,
                        );
                      },
                      child: Center(
                        child: FutureBuilder<GetIdsFotosUserProp>(
                          future: _futureIdsFotos,
                          builder: (context, snapshotIdsFotos) {
                            if (snapshotIdsFotos.connectionState ==
                                ConnectionState.waiting) {
                              return stateWaiting(350, 250);
                            } else if (snapshotIdsFotos.hasError) {
                              return stateErrorFormat(
                                350,
                                250,
                                snapshotIdsFotos.error,
                              );
                            } else if (snapshotIdsFotos.hasData) {
                              listaIdsFotos = snapshotIdsFotos.data!;

                              // if (listaIdsFotos == null ||
                              if (listaIdsFotos.rows.isEmpty) {
                                // CASO: PROPIEDAD SIN FOTOS
                                return Container(
                                  width: 350,
                                  height: 250,
                                  color: appTheme.primaryContainer,
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      "Agrega fotos",
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: appTheme.onPrimaryContainer,
                                      ),
                                    ),
                                  ),
                                );
                              } else {
                                // CASO: PROPIEDAD CON FOTOS
                                if (listaIdsFotos.rows[0].value == "") {
                                  return const Text(
                                    "No se encontró foto",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.white,
                                    ),
                                  );
                                } else {
                                  // Nested FutureBuilder para obtener la imagen real
                                  return Container(
                                    alignment: Alignment.topCenter,
                                    child: FutureBuilder<String>(
                                      future: recuperaFotoPorIdFoto(
                                        listaIdsFotos.rows[0].value,
                                      ),
                                      builder: (context, snapshotFoto) {
                                        if (snapshotFoto.connectionState ==
                                            ConnectionState.waiting) {
                                          return stateWaiting(
                                            widthCuadroFotoPropiedad,
                                            heightCuadroFotoPropiedad,
                                          );
                                        } else if (snapshotFoto.hasError) {
                                          return stateErrorFormat(
                                            widthCuadroFotoPropiedad,
                                            heightCuadroFotoPropiedad,
                                            snapshotFoto.error,
                                          );
                                        } else if (snapshotFoto.hasData &&
                                            snapshotFoto.data != "") {
                                          return Ink.image(
                                            fit: BoxFit.fitHeight,
                                            image: MemoryImage(
                                              base64Decode(snapshotFoto.data!),
                                            ),
                                          );
                                        } else {
                                          return const Text(
                                            "No se encontró foto",
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.white,
                                            ),
                                          );
                                        }
                                      },
                                    ),
                                  );
                                }
                              }
                            }
                            return stateNone(350, 250);
                          },
                        ),
                      ),
                    ),
                  ),

                  // ICONO DE AMPLIAR DATOS (Full Screen)
                  Align(
                    alignment: Alignment.topRight,
                    child: Container(
                      height: 40,
                      width: 40,
                      color: Colors.black.withValues(alpha: 0.3),
                      child: IconButton(
                        icon: const Icon(Symbols.fullscreen),
                        iconSize: 20,
                        splashRadius: 5,
                        color: Colors.white,
                        tooltip: 'Ampliar',
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PaginaDetalleWidget(
                                widget.propiedad,
                                listaIdsFotos,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),

                  // INDICADOR DE PUBLICACIÓN
                  Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                      height: 40,
                      width: 130,
                      color: Colors.black.withValues(alpha: 0.3),
                      child: Row(
                        children: [
                          IconButton(
                            icon: (widget.propiedad.espacioscasa.activa == 0)
                                ? const Icon(Symbols.visibility_off)
                                : const Icon(Symbols.visibility),
                            iconSize: 18,
                            splashRadius: 5,
                            color: appTheme.onPrimary,
                            tooltip: 'Publicación',
                            onPressed: () {},
                          ),
                          Text(
                            (widget.propiedad.espacioscasa.activa == 0)
                                ? "SIN PUBLICAR"
                                : "PUBLICADA",
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: appTheme.onPrimary,
                              letterSpacing: -0.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // PRECIO
            Container(
              width: 350,
              color: appTheme.surface,
              padding: const EdgeInsets.all(1.5),
              alignment: Alignment.center,
              child: letrerprecio(widget.propiedad),
            ),

            // DATOS DE LA UBICACIÓN
            Container(
              width: 350,
              padding: const EdgeInsets.fromLTRB(5.0, 3, 3, 5),
              alignment: Alignment.centerLeft,
              color: appTheme.surface,
              child: Text(
                "${widget.propiedad.espacioscasa.ubicacioncasa.localidadCp.asentamiento}, ${widget.propiedad.espacioscasa.ubicacioncasa.localidadCp.municipio}, C.P. ${widget.propiedad.espacioscasa.ubicacioncasa.localidadCp.cp}",
                maxLines: 3,
                overflow: TextOverflow.visible,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.normal,
                  color: appTheme.onPrimaryContainer,
                ),
              ),
            ),

            // CARACTERISTICAS
            _buildExpansionTile(
              title: "Características",
              children: [
                UbicacionEspacioRow(
                  "Mantenimiento",
                  widget.propiedad.espacioscasa.mantenimiento,
                ),
                Column(
                  children: [
                    Row(
                      children: [
                        ConceptoEspacioRow(
                          0,
                          "Terreno",
                          widget.propiedad.espacioscasa.metrosdeterreno,
                        ),
                        ConceptoEspacioRow(
                          0,
                          "Construcción",
                          widget.propiedad.espacioscasa.metrosconstruidos,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        ConceptoEspacioRow(
                          0,
                          "Recamaras",
                          widget.propiedad.espacioscasa.recamaras,
                        ),
                        ConceptoEspacioRow(
                          0,
                          "Cuarto de Servicio",
                          widget.propiedad.espacioscasa.cuartosdeservicio,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        ConceptoEspacioRow(
                          0,
                          "Baños",
                          widget.propiedad.espacioscasa.banos,
                        ),
                        ConceptoEspacioRow(
                          0,
                          "Medios Baños",
                          widget.propiedad.espacioscasa.mediosbanos,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        ConceptoEspacioRow(
                          0,
                          "Estacionamientos",
                          widget.propiedad.espacioscasa.estacionamientos,
                        ),
                        ConceptoEspacioRow(
                          0,
                          "Cubiertos",
                          widget
                              .propiedad
                              .espacioscasa
                              .estacionamientoscubiertos,
                        ), // Corregido el campo (estaba repetido mediosbanos en original)
                      ],
                    ),
                  ],
                ),
                // Ubicación detallada
                UbicacionEspacioRow(
                  "Ubicación",
                  widget
                      .propiedad
                      .espacioscasa
                      .ubicacioncasa
                      .localidadCp
                      .asentamiento,
                ),
                UbicacionEspacioRow(
                  "Pais",
                  widget.propiedad.espacioscasa.ubicacioncasa.pais,
                ), // Ajustado: Pais estaba mapeando a Estado en original? Corregido según nombre variable
                UbicacionEspacioRow(
                  "Estado",
                  widget
                      .propiedad
                      .espacioscasa
                      .ubicacioncasa
                      .localidadCp
                      .estado,
                ),
                UbicacionEspacioRow(
                  "Municipio",
                  widget
                      .propiedad
                      .espacioscasa
                      .ubicacioncasa
                      .localidadCp
                      .municipio,
                ),
                UbicacionEspacioRow(
                  "Ciudad",
                  widget
                      .propiedad
                      .espacioscasa
                      .ubicacioncasa
                      .localidadCp
                      .ciudad,
                ),
                UbicacionEspacioRow(
                  "Zona",
                  widget.propiedad.espacioscasa.ubicacioncasa.localidadCp.zona,
                ),
                UbicacionEspacioRow(
                  "C.P.",
                  widget.propiedad.espacioscasa.ubicacioncasa.localidadCp.cp
                      .toString(),
                ),
                UbicacionEspacioRow(
                  "Calle",
                  widget.propiedad.espacioscasa.ubicacioncasa.calle,
                ),
                Row(
                  children: [
                    ConceptoEspacioRow(
                      0,
                      "Num. Exterior",
                      widget
                          .propiedad
                          .espacioscasa
                          .ubicacioncasa
                          .numeroexterior,
                    ),
                    ConceptoEspacioRow(
                      0,
                      "Num. Interior",
                      widget
                          .propiedad
                          .espacioscasa
                          .ubicacioncasa
                          .numerointerior,
                    ),
                  ],
                ),
              ],
            ),

            // DATOS DEL CONTACTO
            _buildExpansionTile(
              title: "Datos del contacto",
              children: [
                UbicacionEspacioRow(
                  "Nombre",
                  widget.propiedad.espacioscasa.datosdelcontactocasa.nombre,
                ),
                UbicacionEspacioRow(
                  "Compañia",
                  widget.propiedad.espacioscasa.datosdelcontactocasa.empresa,
                ),
                UbicacionEspacioRow(
                  "Teléfono",
                  widget
                      .propiedad
                      .espacioscasa
                      .datosdelcontactocasa
                      .numerocelular,
                ),
                UbicacionEspacioRow(
                  "Correo",
                  widget
                      .propiedad
                      .espacioscasa
                      .datosdelcontactocasa
                      .correoelectronico,
                ),
              ],
            ),

            // DATOS ADICIONALES
            _buildExpansionTile(
              title: "Datos adicionales",
              children: List<Widget>.generate(listaAdicionales.length, (
                int index2,
              ) {
                String variableRegreso = _obtenerValorAdicional(index2);
                return (variableRegreso != "")
                    ? UbicacionEspacioRow(listaAdicionales[index2], "")
                    : const SizedBox.shrink();
              }),
            ),
          ],
        ),
      ),
    );
  }

  // --- HELPERS DE UI PARA REDUCIR CÓDIGO REPETIDO ---

  Widget _buildActionButton({
    required String text,
    required Color bgColor,
    required Color textColor,
    FontWeight fontWeight = FontWeight.bold,
  }) {
    return Center(
      child: Container(
        width: 100,
        height: 54,
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 3),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: bgColor, width: 2),
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          maxLines: 2,
          style: TextStyle(
            fontSize: fontSizeTextoCarta,
            fontWeight: fontWeight,
            color: textColor,
          ),
        ),
      ),
    );
  }

  Widget _buildExpansionTile({
    required String title,
    required List<Widget> children,
  }) {
    return SizedBox(
      width: 350,
      child: ExpansionTile(
        textColor: appTheme.primary,
        backgroundColor: appTheme.surface,
        collapsedTextColor: appTheme.onPrimary,
        collapsedBackgroundColor: appTheme.primary,
        collapsedIconColor: appTheme.onPrimary,
        tilePadding: const EdgeInsets.symmetric(horizontal: 14),
        childrenPadding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        collapsedShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Text(
          title,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        ),
        children: children,
      ),
    );
  }

  String _obtenerValorAdicional(int index) {
    final datos = widget.propiedad.espacioscasa.datosadicionalescasa;
    switch (index) {
      case 0:
        return datos.panelessolares;
      case 1:
        return datos.jardin;
      case 2:
        return datos.alberca;
      case 3:
        return datos.calefaccion;
      case 4:
        return datos.aireacondicionado;
      case 5:
        return datos.seguridad;
      case 6:
        return datos.enfraccionamiento;
      case 7:
        return datos.casasenelconjunto;
      case 8:
        return datos.casaclub;
      case 9:
        return datos.salondeeventos;
      case 10:
        return datos.centrodenegocios;
      case 11:
        return datos.gimnacio;
      case 12:
        return datos.cisterna;
      case 13:
        return datos.almacenamientodeagua;
      case 14:
        return datos.tratamientodeaguas;
      case 15:
        return datos.otrascaracteristicas;
      default:
        return "";
    }
  }

  // --- DIALOGS CON ASYNC/AWAIT ---
  //OPTIMIZADO
  Future<String?> openDialogPublicar(BuildContext context) {
    String mensajeCentral = "¿Quiéres publicar la propiedad?";
    bool bannerConfirma = true;
    // NUEVO: Variable para controlar el estado de carga
    bool isProcessing = false;

    return showDialog<String>(
      context: context,
      barrierDismissible: false, // Evitar cierre accidental
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              elevation: 6,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(6)),
              ),
              titleTextStyle: TextStyle(
                color: appTheme.onPrimary,
                fontSize: 10,
                fontFamily: "Comfortaa",
                fontWeight: FontWeight.bold,
              ),
              contentTextStyle: TextStyle(
                color: appTheme.secondary,
                backgroundColor: appTheme.onSecondary,
                fontSize: 12,
                fontWeight: FontWeight.normal,
              ),
              titlePadding: const EdgeInsets.fromLTRB(6, 12, 6, 6),
              contentPadding: const EdgeInsets.all(3),
              actionsPadding: const EdgeInsets.all(3),
              backgroundColor: appTheme.primary,
              title: Text(
                "Publicaciones",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: appTheme.onPrimary,
                  fontSize: 10,
                  fontFamily: "Comfortaa",
                  fontWeight: FontWeight.bold,
                ),
              ),
              // OPTIMIZACIÓN: Se elimina altura fija y se permite ajuste dinámico
              content: Container(
                color: appTheme.onSecondary,
                padding: const EdgeInsets.all(6),
                child: Column(
                  mainAxisSize: MainAxisSize.min, // Ajustar al contenido
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // UX: Mostrar indicador de carga si se está procesando
                    if (isProcessing)
                      const Padding(
                        padding: EdgeInsets.all(10.0),
                        child: CircularProgressIndicator(),
                      )
                    else
                      Text(
                        mensajeCentral,
                        textAlign: TextAlign.center,
                        maxLines:
                            4, // Aumentado para permitir mensajes de error más largos
                        style: TextStyle(
                          color: appTheme.onPrimaryContainer,
                          fontSize: fontSizeCard,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                  ],
                ),
              ),
              actions: [
                // Botón "Sí" (Oculto si ya se confirmó o está procesando)
                if (bannerConfirma && !isProcessing)
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.fromLTRB(3, 0, 3, 0),
                      backgroundColor: appTheme.surface,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: Text(
                      "Si",
                      style: TextStyle(
                        color: appTheme.onPrimaryContainer,
                        fontSize: 10,
                        fontFamily: "Comfortaa",
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: () async {
                      // Actualizar UI a estado de carga
                      setStateDialog(() {
                        isProcessing = true;
                        bannerConfirma = false;
                      });

                      String idPublicacion =
                          widget.propiedad.espacioscasa.fotoprincipal;
                      int publicacionActiva =
                          widget.propiedad.espacioscasa.activa;

                      try {
                        // 1. Intentar publicar en CouchDB LA PROPIEDAD
                        String resultado =
                            await upsertEspacioPublicadoToCouchDB(
                              widget.propiedad.espacioscasa.tipodeanuncio,
                              widget.propiedad,
                            );

                        debugPrintLevels(
                          10,
                          '*** PUBLICACIÓN EXITOSA. ID PUBLICACIÓN: $resultado',
                        );
                        if (resultado != "") {
                          // REFERENCIA CACHEADA PARA OPTIMIZACIÓN
                          // 2. Actualizar objeto local ESPACIO
                          // SOLO SI NO HA SIDO PUBLICADO
                          debugPrintLevels(
                            10,
                            '*** FOTO PRINCIPAL: ${widget.propiedad.espacioscasa.fotoprincipal}',
                          );
                          debugPrintLevels(
                            10,
                            '*** ACTIVA: ${widget.propiedad.espacioscasa.activa}',
                          );
                          if ((idPublicacion == "") ||
                              (publicacionActiva == 0)) {
                            debugPrintLevels(
                              10,
                              '*** PUBLICACIÓN PRIMERA VEZ: $resultado',
                            );
                            widget.propiedad.espacioscasa.activa = 1;
                            widget.propiedad.espacioscasa.fotoprincipal =
                                resultado;

                            // 3. Actualizar índice en Riverpod
                            int index = ref
                                .read(espaciosCasaConListaFotosGetProvider)
                                .espaciosCasas
                                .rows
                                .indexWhere(
                                  (p) =>
                                      p.value.espacioscasa.idPropiedad ==
                                      widget.propiedad.espacioscasa.idPropiedad,
                                );
                            int dbResult = 0;
                            if (index != -1) {
                              ref
                                  .read(
                                    espaciosCasaConListaFotosGetProvider
                                        .notifier,
                                  )
                                  .setIndexEspaciosCasas(index);

                              // 4. Actualizar estado global
                              ref
                                  .read(
                                    espaciosCasaConListaFotosGetProvider
                                        .notifier,
                                  )
                                  .setEspaciosCasasGet(widget.propiedad);

                              // 5. Guardar actualización del espacio en DB
                              dbResult = await ref
                                  .read(
                                    espaciosCasaConListaFotosGetProvider
                                        .notifier,
                                  )
                                  .updatePropiedadCasaGetToCouchDB();

                              debugPrintLevels(
                                10,
                                '*** RESULTADO ACTUALIZA ESPACIO: $dbResult',
                              );
                            }
                            if ((dbResult == 200 ||
                                    dbResult == 201 ||
                                    dbResult == 202) &&
                                (index != -1)) {
                              // ÉXITO TOTAL
                              debugPrintLevels(
                                10,
                                '*** UPDATE DEL ESPACIO: $dbResult',
                              );
                              if (context.mounted) {
                                setStateDialog(() {
                                  isProcessing = false;
                                  mensajeCentral = "Se publicó la propiedad.";
                                });
                              }
                            } else {
                              // FALLO EN UPDATE DEL ESPACIO -> ROLLBACK
                              // Intentar borrar la publicación huérfana
                              String errorMsg = "";
                              debugPrintLevels(
                                10,
                                '*** FALLO EN UPDATE DEL ESPACIO -> ROLLBACK: $dbResult',
                              );
                              int borraPublicacion =
                                  await deleteEspacioPublicadoToCouchDB(
                                    widget.propiedad.espacioscasa.tipodeanuncio,
                                    widget.propiedad.espacioscasa.fotoprincipal,
                                  );
                              if (borraPublicacion != 200 &&
                                  borraPublicacion != 201 &&
                                  borraPublicacion != 202) {
                                // Revertir cambios locales
                                widget.propiedad.espacioscasa.activa = 0;
                                widget.propiedad.espacioscasa.fotoprincipal =
                                    "";
                                ref
                                    .read(
                                      espaciosCasaConListaFotosGetProvider
                                          .notifier,
                                    )
                                    .setEspaciosCasasGet(widget.propiedad);

                                errorMsg =
                                    "Error: no se pudo actualizar el espacio.";

                                errorMsg +=
                                    "\nNota: La publicación se creó pero no se vinculó correctamente al espacio.";
                              }

                              if (context.mounted) {
                                setStateDialog(() {
                                  isProcessing = false;
                                  mensajeCentral = errorMsg;
                                });
                              }
                            }
                          } else {
                            debugPrintLevels(
                              10,
                              '*** ACTUALIZACIÓN DE LA PUBLICACIÓN ',
                            );
                            if (context.mounted) {
                              setStateDialog(() {
                                isProcessing = false;
                                mensajeCentral = "Se actualizó la publicación.";
                              });
                            }
                          }
                        } else {
                          // FALLO AL OBTENER RESULTADO DE PUBLICACIÓN
                          debugPrintLevels(
                            10,
                            '*** PUBLICACIÓN PRIMERA VEZ: $resultado',
                          );
                          widget.propiedad.espacioscasa.activa = 0;
                          widget.propiedad.espacioscasa.fotoprincipal = "";

                          if (context.mounted) {
                            setStateDialog(() {
                              isProcessing = false;
                              mensajeCentral =
                                  "Error: no se pudo publicar la propiedad.";
                            });
                          }
                        }
                      } catch (e) {
                        // MANEJO DE EXCEPCIONES GENERALES
                        // Revertir estado local por seguridad visual
                        widget.propiedad.espacioscasa.activa = 0;
                        widget.propiedad.espacioscasa.fotoprincipal = "";

                        if (context.mounted) {
                          setStateDialog(() {
                            isProcessing = false;
                            mensajeCentral = "Error de conexión o inesperado.";
                          });
                        }
                      }
                    },
                  ),

                // Botón "No" / "Salir"
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: appTheme.surface,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  // Bloquear botón si está procesando
                  onPressed: isProcessing
                      ? null
                      : () {
                          Navigator.of(context).pop();
                        },
                  child: Text(
                    (bannerConfirma) ? "No" : "Salir",
                    style: TextStyle(
                      // Cambiar color si está deshabilitado
                      color: isProcessing
                          ? Colors.grey
                          : appTheme.onPrimaryContainer,
                      fontSize: 10,
                      fontFamily: "Comfortaa",
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // OPTIMIZADO
  Future<String?> openDialogBorraPublicacion(BuildContext context) {
    String mensajeCentral = "¿Quiéres eliminar la publicación?";
    bool bannerConfirma = true;
    // NUEVO: Variable para controlar el estado de carga y evitar múltiples clics
    bool isProcessing = false;

    return showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              elevation: 6,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(6)),
              ),
              titleTextStyle: TextStyle(
                color: appTheme.onPrimary,
                //backgroundColor: lightINE.onTertiary,
                fontSize: 10,
                fontFamily: "Comfortaa",
                fontWeight: FontWeight.bold,
              ),
              contentTextStyle: TextStyle(
                color: appTheme.secondary,
                backgroundColor: appTheme.onSecondary,
                fontSize: 12,
                //fontFamily: "Comfortaa",
                fontWeight: FontWeight.normal,
              ),
              titlePadding: const EdgeInsets.fromLTRB(6, 12, 6, 6),
              contentPadding: const EdgeInsets.all(3),
              actionsPadding: const EdgeInsets.all(3),
              backgroundColor: appTheme.primary,
              title: Text(
                "Publicaciones",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: appTheme.onPrimary,
                  fontSize: 10,
                  fontFamily: "Comfortaa",
                  fontWeight: FontWeight.bold,
                ),
              ),
              // OPTIMIZACIÓN: Layout flexible para evitar overflow de texto
              content: Container(
                color: appTheme.onSecondary,
                padding: const EdgeInsets.all(6),
                child: Column(
                  mainAxisSize: MainAxisSize.min, // Se ajusta al contenido
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // LÓGICA UI: Si está procesando, muestra loader, si no, el texto
                    if (isProcessing)
                      const Padding(
                        padding: EdgeInsets.all(10.0),
                        child: CircularProgressIndicator(),
                      )
                    else
                      Text(
                        mensajeCentral,
                        textAlign: TextAlign.center,
                        maxLines: 3, // Aumentado ligeramente por seguridad
                        style: TextStyle(
                          color: appTheme.onPrimaryContainer,
                          fontSize: fontSizeCard,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                  ],
                ),
              ),
              actions: [
                // Botón "Sí" (Solo visible si bannerConfirma es true y no está cargando)
                if (bannerConfirma && !isProcessing)
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: appTheme.surface,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: Text(
                      "Si",
                      style: TextStyle(
                        color: appTheme.onPrimaryContainer,
                        fontSize: 10,
                        fontFamily: "Comfortaa",
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: () async {
                      // 1. Activar estado de carga
                      setStateDialog(() {
                        isProcessing = true;
                      });

                      try {
                        // 2. Llamada asíncrona para eliminar
                        var resultado = await deleteEspacioPublicadoToCouchDB(
                          widget.propiedad.espacioscasa.tipodeanuncio,
                          widget.propiedad.espacioscasa.fotoprincipal,
                        );

                        // Verificamos si el contexto sigue montado antes de continuar
                        if (!context.mounted) return;

                        if (resultado == 200 ||
                            resultado == 201 ||
                            resultado == 202) {
                          // 3. Lógica de negocio (Riverpod) simplificada
                          // Obtenemos el notifier una sola vez
                          final espaciosNotifier = ref.read(
                            espaciosCasaConListaFotosGetProvider.notifier,
                          );

                          // Obtenemos la data actual para buscar el índice
                          final espaciosData = ref.read(
                            espaciosCasaConListaFotosGetProvider,
                          );

                          int index = espaciosData.espaciosCasas.rows
                              .indexWhere(
                                (p) =>
                                    p.value.espacioscasa.idPropiedad ==
                                    widget.propiedad.espacioscasa.idPropiedad,
                              );

                          if (index != -1) {
                            espaciosNotifier.setIndexEspaciosCasas(index);
                          }

                          // Actualización local de la propiedad
                          widget.propiedad.espacioscasa.activa = 0;
                          widget.propiedad.espacioscasa.fotoprincipal = "";

                          // Actualizar estado en Riverpod
                          espaciosNotifier.setEspaciosCasasGet(
                            widget.propiedad,
                          );

                          // 4. Segunda llamada asíncrona (Actualizar DB)
                          // Usamos await en lugar de .then para mantener el flujo limpio
                          await espaciosNotifier
                              .updatePropiedadCasaGetToCouchDB();

                          // 5. Actualizar UI con éxito
                          if (context.mounted) {
                            setStateDialog(() {
                              isProcessing = false;
                              bannerConfirma = false;
                              mensajeCentral = "Se eliminó la publicación.";
                            });
                          }
                        } else {
                          // Manejo de error de respuesta (no excepción)
                          if (context.mounted) {
                            setStateDialog(() {
                              isProcessing = false;
                              // bannerConfirma se mantiene true para
                              // permitir reintentar o cancelar
                              mensajeCentral = "Error: no se pudo eliminar.";
                            });
                          }
                        }
                      } catch (e) {
                        // Manejo de excepciones
                        if (context.mounted) {
                          setStateDialog(() {
                            isProcessing = false;
                            bannerConfirma =
                                false; // Ocultamos el 'Sí' para obligar a salir
                            mensajeCentral = "Error de conexión o inesperado.";
                          });
                        }
                      }
                    },
                  ),

                // Botón "No" / "Salir" (Deshabilitado visualmente si está procesando)
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: appTheme.surface,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  // Bloqueamos el botón si está procesando
                  onPressed: isProcessing
                      ? null
                      : () {
                          Navigator.of(context).pop();
                        },
                  child: Text(
                    (bannerConfirma) ? "No" : "Salir",
                    style: TextStyle(
                      // Cambiamos el color si está deshabilitado para feedback visual
                      color: isProcessing
                          ? Colors.grey
                          : appTheme.onPrimaryContainer,
                      fontSize: 10,
                      fontFamily: "Comfortaa",
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  //----------------------------------------------------------------------------
  Future<String?> openDialogBorraEspacio(BuildContext context) {
    String mensajeCentral = "¿Quiéres eliminar el espacio?";
    bool bannerConfirma = true;

    return showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              elevation: 6,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(6)),
              ),
              backgroundColor: appTheme.primary,
              title: Text(
                "Espacios",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: appTheme.onPrimary,
                  fontSize: 10,
                  fontFamily: "Comfortaa",
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: Container(
                color: appTheme.onSecondary,
                height: 80,
                padding: const EdgeInsets.all(6),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      mensajeCentral,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      style: TextStyle(
                        color: appTheme.onPrimaryContainer,
                        fontSize: fontSizeCard,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                if (bannerConfirma)
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: appTheme.surface,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: Text(
                      "Si",
                      style: TextStyle(
                        color: appTheme.onPrimaryContainer,
                        fontSize: 10,
                        fontFamily: "Comfortaa",
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: () async {
                      try {
                        var resultado = await deleteEspacioToCouchDB(
                          widget.propiedad.espacioscasa.tipodeanuncio,
                          widget.propiedad,
                        );

                        if (context.mounted) {
                          setStateDialog(() {
                            bannerConfirma = false;
                            if (resultado == 200 || resultado == 202) {
                              mensajeCentral = "Se borro el espacio.";
                            } else {
                              mensajeCentral = "Error: no se pudo borrar.";
                            }
                          });
                        }
                      } catch (e) {
                        if (context.mounted) {
                          setStateDialog(() {
                            bannerConfirma = false;
                            mensajeCentral = "Error de conexión";
                          });
                        }
                      }
                    },
                  ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: appTheme.surface,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: Text(
                    (bannerConfirma) ? "No" : "Salir",
                    style: TextStyle(
                      color: appTheme.onPrimaryContainer,
                      fontSize: 10,
                      fontFamily: "Comfortaa",
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }
}
//------------------------------------------------------------------------------
// OPTIMIZADO
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// OPTIMIZADO 01
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
