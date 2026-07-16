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
  /*
  Future<String?> openDialogPublicar(BuildContext context) {
    String mensajeCentral = "¿Quiéres publicar la propiedad?";
    bool bannerConfirma = true;

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
                      // Usar async/await y try-catch para flujo lineal y seguro
                      setStateDialog(() => bannerConfirma = false);

                      try {
                        String resultado =
                            await upsertEspacioPublicadoToCouchDB(
                              widget.propiedad.espacioscasa.tipodeanuncio,
                              widget.propiedad,
                            );

                        if (resultado != "") {
                          // SE REALIZÓ LA PUBLICACIÓN Y
                          // SE PROCEDE A ACTUALIZAR LA BANDRA DE PUBLICACIÓN (ACTIVA = 1)
                          // Y EL ID DE LA PUBLICACIÓN EN FOTOPRINCIPAL EL
                          // EL ESPACIO PUBLICADO
                          widget.propiedad.espacioscasa.activa = 1;
                          widget.propiedad.espacioscasa.fotoprincipal =
                              resultado;

                          // Actualizar Riverpod
                          int index = ref
                              .read(espaciosCasaConListaFotosGetProvider)
                              .espaciosCasas
                              .rows
                              .indexWhere(
                                (p) =>
                                    p.value.espacioscasa.idPropiedad ==
                                    widget.propiedad.espacioscasa.idPropiedad,
                              );

                          if (index != -1) {
                            // SE ENCONTRO EN LA LISTA LA PROPIEDAD
                            // ACTUALIZA EL INDICE DE LA LISTA
                            ref
                                .read(
                                  espaciosCasaConListaFotosGetProvider.notifier,
                                )
                                .setIndexEspaciosCasas(index);
                            // ACTUALIZA LA BANDERA DE PUBLICACIÓN (ACTIVA)
                            // GUARDA EL ID DE LA PUBLICACIÓN EN FOTOPRINCIPAL
                            widget.propiedad.espacioscasa.activa = 1;
                            widget.propiedad.espacioscasa.fotoprincipal =
                                resultado;
                            ref
                                .read(
                                  espaciosCasaConListaFotosGetProvider.notifier,
                                )
                                .setEspaciosCasasGet(widget.propiedad);

                            // Guardar en DB ACTUALIZACION DEL ESPACIO
                            final dbResult = await ref
                                .read(
                                  espaciosCasaConListaFotosGetProvider.notifier,
                                )
                                .updatePropiedadCasaGetToCouchDB();

                            if (dbResult == 200 ||
                                dbResult == 201 ||
                                dbResult == 202) {
                              // AVISO QUE SE HIZO LA PUBLICACIÓN Y
                              // QUE SE ACTUALIZÓ EL ESPACIO
                              if (context.mounted) {
                                setStateDialog(
                                  () => mensajeCentral =
                                      "Se publicó la propiedad.",
                                );
                              } else {
                                // Rollback NO SE PUDO ACTUALIZAR EL ESPACIO
                                // SE BORRA LA PUBLICACIÓN
                                int borraPublicacion =
                                    await deleteEspacioPublicadoToCouchDB(
                                      widget
                                          .propiedad
                                          .espacioscasa
                                          .tipodeanuncio,
                                      widget
                                          .propiedad
                                          .espacioscasa
                                          .fotoprincipal,
                                    );
                                if (borraPublicacion == 200 ||
                                    borraPublicacion == 201 ||
                                    borraPublicacion == 202) {
                                  // NO SE PUDO BORRAR LA PUBLICACIÓN
                                  // SE QUEDA PUBLICACIÓN SIN PADRE EN ESPACIOS
                                  // SE NECESITA BORRAR LA PUBLICACIÓN POR FUERA
                                  widget.propiedad.espacioscasa.activa = 0;
                                  widget.propiedad.espacioscasa.fotoprincipal =
                                      "";
                                  ref
                                      .read(
                                        espaciosCasaConListaFotosGetProvider
                                            .notifier,
                                      )
                                      .setEspaciosCasasGet(widget.propiedad);
                                  if (context.mounted) {
                                    setStateDialog(
                                      () => mensajeCentral =
                                          "Error: no se pudo actualizar el espacio.",
                                    );
                                  }
                                } else {
                                  // SE BORRÓ LA PUBLICACIÓN
                                  // POR NO PODER ACTUALIZAR BANDERA DE PUBLICACIÓN
                                  // EN ESPACIOS
                                  widget.propiedad.espacioscasa.activa = 0;
                                  widget.propiedad.espacioscasa.fotoprincipal =
                                      "";
                                  ref
                                      .read(
                                        espaciosCasaConListaFotosGetProvider
                                            .notifier,
                                      )
                                      .setEspaciosCasasGet(widget.propiedad);

                                  if (context.mounted) {
                                    setStateDialog(
                                      () => mensajeCentral =
                                          "Error: no se pudo publicar.",
                                    );
                                  }
                                }
                              }
                              widget.propiedad.espacioscasa.activa = 0;
                              widget.propiedad.espacioscasa.fotoprincipal = "";
                              if (context.mounted) {
                                setStateDialog(
                                  () => mensajeCentral =
                                      "Error: no se pudo publicar.",
                                );
                              }
                            }
                          }
                        } else {
                          widget.propiedad.espacioscasa.activa = 0;
                          widget.propiedad.espacioscasa.fotoprincipal = "";
                          if (context.mounted) {
                            setStateDialog(
                              () => mensajeCentral =
                                  "Error: no se pudo publicar.",
                            );
                          }
                        }
                      } catch (e) {
                        if (context.mounted) {
                          setStateDialog(
                            () => mensajeCentral = "Error de conexión.",
                          );
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
  */
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

  /*
  Future<String?> openDialogBorraPublicacion(BuildContext context) {
    String mensajeCentral = "¿Quiéres eliminar la publicación?";
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
                "Publicaciones",
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
                        var resultado = await deleteEspacioPublicadoToCouchDB(
                          widget.propiedad.espacioscasa.tipodeanuncio,
                          widget.propiedad.espacioscasa.fotoprincipal,
                        );

                        if (context.mounted) {
                          setStateDialog(() {
                            bannerConfirma = false;
                            if (resultado == 200 || resultado == 202) {
                              mensajeCentral = "Se eliminó la publicación.";

                              int index = ref
                                  .read(espaciosCasaConListaFotosGetProvider)
                                  .espaciosCasas
                                  .rows
                                  .indexWhere(
                                    (p) =>
                                        p.value.espacioscasa.idPropiedad ==
                                        widget
                                            .propiedad
                                            .espacioscasa
                                            .idPropiedad,
                                  );
                              if (index != -1) {
                                ref
                                    .read(
                                      espaciosCasaConListaFotosGetProvider
                                          .notifier,
                                    )
                                    .setIndexEspaciosCasas(index);
                              }
                              // ACTUALIZA en DB
                              widget.propiedad.espacioscasa.activa = 0;
                              widget.propiedad.espacioscasa.fotoprincipal = "";
                              ref
                                  .read(
                                    espaciosCasaConListaFotosGetProvider
                                        .notifier,
                                  )
                                  .setEspaciosCasasGet(widget.propiedad);
                              ref
                                  .read(
                                    espaciosCasaConListaFotosGetProvider
                                        .notifier,
                                  )
                                  .updatePropiedadCasaGetToCouchDB()
                                  .then((onValue) {
                                    mensajeCentral =
                                        "Se eliminó la publicación.";
                                  });
                            } else {
                              mensajeCentral = "Error: no se pudo eliminar.";
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
*/
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
/*
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
      width: widthCuadroFotoPropiedad,
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
// Cambio a ConsumerStatefulWidget para manejar el estado del Future
// y evitar peticiones HTTP redundantes en cada build.
//------------------------------------------------------------------------------
class CreaFichaCapturaPropiedad extends ConsumerStatefulWidget {
  // Eliminamos BuildContext del constructor, no se debe almacenar.
  final int indexListaPropiedad;
  final ValueEspaciosCasaGet propiedad;
  final dynamic update;

  const CreaFichaCapturaPropiedad(
    // ignore: avoid_unused_constructor_parameters
    BuildContext
    context, // Mantenido solo para no romper firmas externas, pero no se usa.
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
    // OPTIMIZACIÓN: El Future se crea una sola vez al iniciar el widget.
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
      margin: const EdgeInsets.fromLTRB(6.0, 6.0, 6.0, 6.0),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(6, 6, 6, 6),
        child: Column(
          children: [
            SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // BOTÓN MODIFICA DATOS DE LA PROPIEDAD --------------------------------------
                GestureDetector(
                  onTap: () {
                    debugPrintLevels(
                      5,
                      "*** creaFichaCapturaPropiedad: editaespacio ficha: ${widget.propiedad.espacioscasa.idPropiedad}",
                    );
                    Navigator.pushNamed(
                      context,
                      AppRoutes.editaespacio,
                      arguments: widget.propiedad,
                    );
                    // PaginaEditaEspacio(settings.arguments as ValueEspaciosCasaGet)
                  },
                  child: Center(
                    child: Container(
                      width: 100,
                      height: 54,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.fromLTRB(3, 2, 3, 2),
                      decoration: BoxDecoration(
                        color: appTheme.primary,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: appTheme.primary, width: 2),
                      ),
                      child: Container(
                        alignment: Alignment.center,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Text(
                                "Modificar",
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                style: TextStyle(
                                  fontSize: fontSizeTextoCarta,
                                  fontWeight: FontWeight.bold,
                                  color: appTheme.onPrimary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                // BOTÓN DE PUBLICACIÓN DE LA PROPIEDAD
                GestureDetector(
                  onTap: () async {
                    await openDialogPublicar(context);
                    setState(() {});
                  },
                  child: Center(
                    child: Container(
                      width: 100,
                      height: 54,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.fromLTRB(3, 2, 3, 2),
                      decoration: BoxDecoration(
                        color: appTheme.primary,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: appTheme.primary, width: 2),
                      ),
                      child: Container(
                        alignment: Alignment.center,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Text(
                                "Publicar",
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                style: TextStyle(
                                  fontSize: fontSizeTextoCarta,
                                  fontWeight: FontWeight.bold,
                                  color:
                                      (widget.propiedad.espacioscasa.activa ==
                                          0)
                                      ? appTheme.onPrimary
                                      : appTheme.onPrimary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                // BOTÓN DE BORRADO DE LA PUBLICACIÓN DE LA PROPIEDAD
                GestureDetector(
                  onTap: (widget.propiedad.espacioscasa.activa == 0)
                      ? () {}
                      : () async {
                          debugPrintLevels(
                            5,
                            "*** creaFichaCapturaPropiedad: BORRA PUBLICACION ESPACIO: ${widget.propiedad.espacioscasa.idPropiedad}",
                          );
                          // 4. BORRA PUBLICACION en Base de Datos
                          await openDialogBorraPublicacion(context);
                          setState(() {});
                        },
                  child: Center(
                    child: Container(
                      width: 100,
                      height: 54,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.fromLTRB(3, 2, 3, 2),
                      decoration: BoxDecoration(
                        color: (widget.propiedad.espacioscasa.activa == 0)
                            ? appTheme.secondary
                            : appTheme.primary,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: (widget.propiedad.espacioscasa.activa == 0)
                              ? appTheme.secondary
                              : appTheme.primary,
                          width: 2,
                        ),
                      ),
                      child: Container(
                        alignment: Alignment.center,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Text(
                                "Dejar de publicar",
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                style: TextStyle(
                                  fontSize: fontSizeTextoCarta,
                                  fontWeight:
                                      (widget.propiedad.espacioscasa.activa ==
                                          0)
                                      ? FontWeight.normal
                                      : FontWeight.bold,
                                  color:
                                      (widget.propiedad.espacioscasa.activa ==
                                          0)
                                      ? appTheme.primaryContainer
                                      : appTheme.onPrimary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            //------------------------------------------------------------------------
            // BORRAR ESPACIO
            // BOTÓN DE BORRADO DE LA PUBLICACIÓN DE LA PROPIEDAD
            SizedBox(height: 6),
            GestureDetector(
              onTap: () async {
                await openDialogBorraEspacio(context);
                setState(() {});
              },
              child: Container(
                width: 500,
                alignment: Alignment.center,
                padding: const EdgeInsets.fromLTRB(6, 6, 6, 6),
                decoration: BoxDecoration(
                  color: appTheme.error,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: appTheme.error, width: 2),
                ),
                child: Container(
                  alignment: Alignment.center,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
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
                    ],
                  ),
                ),
              ),
            ),
            //------------------------------------------------------------------------
            const SizedBox(height: 10),
            // LETRERO PROMOCIONAL -----------------------------------------
            /// NOMBRE DE LA PROPIEDAD
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
                        debugPrintLevels(6, "*** call carouselfotospropiedad");
                        Navigator.pushNamed(
                          context,
                          AppRoutes.fotospropiedad,
                          arguments: widget.propiedad,
                        );
                      },
                      child: Center(
                        child: FutureBuilder<GetIdsFotosUserProp>(
                          future:
                              _futureIdsFotos, // Usamos la variable de estado
                          builder: (context, snapshotIdsFotos) {
                            debugPrintLevels(7, "** _recuperaFotoPorIdFoto");

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
                              GetIdsFotosUserProp? listaIdsFotos =
                                  snapshotIdsFotos.data;

                              if (listaIdsFotos!.rows.isEmpty) {
                                // CASO: PROPIEDAD SIN FOTOS
                                return Container(
                                  width: 350,
                                  height: 250,
                                  color: appTheme.primaryContainer,
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      "Agrega foto principal",
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
                  // Barra de datos de la imagen -----------------------
                  //-------------------------------
                  // FONDO GRIS AMPLIAR
                  Align(
                    alignment: Alignment.topRight,
                    child: Container(
                      height: 40,
                      width: 40,
                      color: Colors.black.withValues(alpha: 0.3),
                    ),
                  ),
                  // ICONO DE AMPLIAR DATOS
                  Align(
                    alignment: Alignment.topRight,
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
                            builder: (context) =>
                                PaginaDetalleWidget(widget.propiedad),
                          ),
                        );
                      },
                    ),
                  ),
                  /*
                //-------------------------------
                // FONDO GRIS GUARDAR
                Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    height: 40,
                    width: 40,
                    color: Colors.black.withValues(alpha: 0.3),
                  ),
                ),
                // ICONO DE GUARDAR
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    icon: const Icon(Symbols.playlist_add),
                    iconSize: 20,
                    splashRadius: 5,
                    color: Colors.white,
                    tooltip: 'Guardar',
                    onPressed: () {},
                  ),
                ),
                */
                  //-------------------------------
                  // FONDO GRIS PUBLICAR
                  Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                      height: 40,
                      width: 130,
                      color: Colors.black.withValues(alpha: 0.3),
                    ),
                  ),
                  // ICONO DE PUBLICAR DATOS
                  Align(
                    alignment: Alignment.topLeft,
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
                        (widget.propiedad.espacioscasa.activa == 0)
                            ? Text(
                                "SIN PUBLICAR",
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: appTheme.onPrimary,
                                  letterSpacing: -0.3,
                                ),
                              )
                            : Text(
                                "PUBLICADA",
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
                  //-------------------------------
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
            // DATOS DE LA PROPIEDAD
            Container(
              width: 350,
              padding: const EdgeInsets.fromLTRB(5.0, 3, 3, 5),
              alignment: Alignment.centerLeft,
              color: appTheme.surface,
              child: Text(
                "${widget.propiedad.espacioscasa.ubicacioncasa.localidadCp.asentamiento}, ${widget.propiedad.espacioscasa.ubicacioncasa.localidadCp.municipio}, C.P. ${widget.propiedad.espacioscasa.ubicacioncasa.localidadCp.cp.toString()}",
                maxLines: 3,
                overflow: TextOverflow.visible,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.normal,
                  color: appTheme.onPrimaryContainer,
                ),
              ),
            ),

            // Barras Desplegable ----------------------
            // CARACTERISTICAS DE LA PROPIEDAD
            SizedBox(
              width: 350,
              child: ExpansionTile(
                textColor: appTheme.primary,
                backgroundColor: appTheme.surface,
                collapsedTextColor: appTheme.onPrimary,
                collapsedBackgroundColor: appTheme.primary,
                collapsedIconColor: appTheme.onPrimary,
                title: const Text(
                  "Características",
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
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
                            widget.propiedad.espacioscasa.mediosbanos,
                          ),
                        ],
                      ),
                    ],
                  ),
                  // UBICACION
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
                    widget
                        .propiedad
                        .espacioscasa
                        .ubicacioncasa
                        .localidadCp
                        .estado,
                  ),
                  UbicacionEspacioRow(
                    "Estado",
                    widget.propiedad.espacioscasa.ubicacioncasa.pais,
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
                    widget
                        .propiedad
                        .espacioscasa
                        .ubicacioncasa
                        .localidadCp
                        .zona,
                  ),
                  UbicacionEspacioRow(
                    "C.P.",
                    widget.propiedad.espacioscasa.ubicacioncasa.localidadCp.cp
                        .toString(),
                  ),
                  UbicacionEspacioRow(
                    "Colonia",
                    widget
                        .propiedad
                        .espacioscasa
                        .ubicacioncasa
                        .localidadCp
                        .asentamiento,
                  ),
                  UbicacionEspacioRow(
                    "Tipo",
                    widget
                        .propiedad
                        .espacioscasa
                        .ubicacioncasa
                        .localidadCp
                        .tipo,
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
            ),
            // BARRA DE DATOS DEL CONTACTO
            SizedBox(
              width: 350,
              child: ExpansionTile(
                textColor: appTheme.primary,
                backgroundColor: appTheme.surface,
                collapsedTextColor: appTheme.onPrimary,
                collapsedBackgroundColor: appTheme.primary,
                collapsedIconColor: appTheme.onPrimary,
                title: const Text(
                  "Datos del contacto",
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
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
            ),
            // BARRA DE DATOS ADICIONALES
            SizedBox(
              width: 350,
              child: ExpansionTile(
                textColor: appTheme.primary,
                backgroundColor: appTheme.surface,
                collapsedTextColor: appTheme.onPrimary,
                collapsedBackgroundColor: appTheme.primary,
                collapsedIconColor: appTheme.onPrimary,
                title: const Text(
                  "Datos adicionales",
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
                children: List<Widget>.generate(listaAdicionales.length, (
                  int index2,
                ) {
                  String variableRegreso = _obtenerValorAdicional(index2);
                  return (variableRegreso != "")
                      ? UbicacionEspacioRow(listaAdicionales[index2], "")
                      : const SizedBox.shrink(); // Optimización: Widget vacío constante
                }),
              ),
            ),
            // fin ----------------
          ],
        ),
      ),
    );
  }

  // OPTIMIZACIÓN: Lógica extraída para limpiar el método build
  String _obtenerValorAdicional(int index) {
    // Referencia corta para legibilidad
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
  //----------------------------------------------------------------------------

  Future<String?> openDialogPublicar(BuildContext context) {
    String mensajeCentral = "¿Quiéres publicar la propiedad?";
    bool bannerConfirma = true;

    return showDialog<String>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
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
                style: TextStyle(color: appTheme.onPrimary),
              ),
              content: Container(
                color: appTheme.onSecondary,
                height: 80,
                padding: const EdgeInsets.all(6),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("", maxLines: 1),
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
                    const Text("", maxLines: 1),
                  ],
                ),
              ),
              actions: [
                if (bannerConfirma)
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
                        //backgroundColor: appTheme.onTertiary,
                        fontSize: 10,
                        fontFamily: "Comfortaa",
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: () async {
                      // 4. Guardar en Base de Datos
                      bannerConfirma = false;

                      await upsertEspacioPublicadoToCouchDB(
                        widget.propiedad.espacioscasa.tipodeanuncio,
                        widget.propiedad,
                      ).then((resultado) async {
                        debugPrintLevels(
                          5,
                          "06. PaginaEditaEspacio Resultado de PUBLICAR espacio: $resultado",
                        );
                        if (resultado != "") {
                          mensajeCentral = "Se publicó la propiedad.";

                          widget.propiedad.espacioscasa.activa = 1;
                          widget.propiedad.espacioscasa.fotoprincipal =
                              resultado;
                          //--------------
                          // 2. Buscar índice basado en ID (por seguridad)
                          int index = ref
                              .read(espaciosCasaConListaFotosGetProvider)
                              .espaciosCasas
                              .rows
                              .indexWhere(
                                (propiedadEnLista) =>
                                    propiedadEnLista
                                        .value
                                        .espacioscasa
                                        .idPropiedad ==
                                    widget.propiedad.espacioscasa.idPropiedad,
                              );
                          // EL INDICE ES LA PROPIEDAD ACTUAL EN LA LISTA
                          // REGRESA -1 SI NO SE ENCONTRO LA POSICIÓN
                          // SI LA ENCONTRO, ACTUALIZA EL INDICE CON SU POSICIÓN
                          if (index != -1) {
                            ref
                                .read(
                                  espaciosCasaConListaFotosGetProvider.notifier,
                                )
                                .setIndexEspaciosCasas(index);
                          }
                          // 3. ACTUALIZAR EL ESTADO EN RIVERPOD
                          // COPIANDO TODA LA PROPIEDAD EN LA POSICIÓN INDEX
                          ref
                              .read(
                                espaciosCasaConListaFotosGetProvider.notifier,
                              )
                              .setEspaciosCasasGet(ref, widget.propiedad);

                          debugPrintLevels(
                            5,
                            "05. PaginaEditaEspacio Guarda cambios ",
                          );
                          // 4. Guardar en Base de Datos
                          await ref
                              .read(
                                espaciosCasaConListaFotosGetProvider.notifier,
                              )
                              .updatePropiedadCasaGetToCouchDB()
                              .then((resultado) async {
                                // Restaurar índice si es necesario
                                debugPrintLevels(
                                  5,
                                  "06. PaginaEditaEspacio Resultado de Update espacio: $resultado",
                                );
                                if (resultado == 200 || resultado == 202) {
                                  mensajeCentral = "Se publicó la propiedad.";
                                } else {
                                  mensajeCentral =
                                      "Error: no se pudo publicar la propiedad.";
                                  widget.propiedad.espacioscasa.activa = 0;
                                  widget.propiedad.espacioscasa.fotoprincipal =
                                      "";
                                  // BORRA PUBLICACION REALIZADA
                                  await deleteEspacioPublicadoToCouchDB(
                                    widget.propiedad.espacioscasa.tipodeanuncio,
                                    widget.propiedad,
                                  ).then((resultado) async {
                                    debugPrintLevels(
                                      5,
                                      "06. PaginaEditaEspacio Resultado de BORRADO PUBLICACION: $resultado",
                                    );

                                    if (resultado == 200 || resultado == 202) {
                                      mensajeCentral =
                                          "Se publicó la propiedad.";
                                    } else {
                                      mensajeCentral =
                                          "Error: no se pudo eliminar la publicación.";
                                    }
                                  });
                                }
                              });
                          //--------
                        } else {
                          mensajeCentral =
                              "Error: no se pudo publicar la propiedad.";
                          widget.propiedad.espacioscasa.activa = 0;
                          widget.propiedad.espacioscasa.fotoprincipal = "";
                        }
                        setState(() {});
                      });
                    },
                  ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.fromLTRB(3, 0, 3, 0),
                    backgroundColor: appTheme.surface,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: Text(
                    (bannerConfirma) ? "No" : "Salir",
                    style: TextStyle(
                      color: appTheme.onPrimaryContainer,
                      //backgroundColor: appTheme.onTertiary,
                      fontSize: 10,
                      fontFamily: "Comfortaa",
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    //});
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<String?> openDialogBorraPublicacion(BuildContext context) {
    String mensajeCentral = "¿Quiéres eliminar la publicación?";
    bool bannerConfirma = true;

    return showDialog<String>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
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
                style: TextStyle(color: appTheme.onPrimary),
              ),
              content: Container(
                color: appTheme.onSecondary,
                height: 80,
                padding: const EdgeInsets.all(6),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("", maxLines: 1),
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
                    const Text("", maxLines: 1),
                  ],
                ),
              ),
              actions: [
                if (bannerConfirma)
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
                        //backgroundColor: appTheme.onTertiary,
                        fontSize: 10,
                        fontFamily: "Comfortaa",
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: () async {
                      await deleteEspacioPublicadoToCouchDB(
                        widget.propiedad.espacioscasa.tipodeanuncio,
                        widget.propiedad,
                      ).then((resultado) async {
                        debugPrintLevels(
                          5,
                          "06. PaginaEditaEspacio Resultado de BORRADO PUBLICACION: $resultado",
                        );
                        setState(() {
                          bannerConfirma = false;
                          if (resultado == 200 || resultado == 202) {
                            mensajeCentral = "Se eliminó la publicación.";
                          } else {
                            mensajeCentral =
                                "Error: no se pudo eliminar la publicación.";
                          }
                        });
                      });
                      //Navigator.of(context).pop();
                    },
                  ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.fromLTRB(3, 0, 3, 0),
                    backgroundColor: appTheme.surface,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: Text(
                    (bannerConfirma) ? "No" : "Salir",
                    style: TextStyle(
                      color: appTheme.onPrimaryContainer,
                      //backgroundColor: appTheme.onTertiary,
                      fontSize: 10,
                      fontFamily: "Comfortaa",
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    //});
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<String?> openDialogBorraEspacio(BuildContext context) {
    String mensajeCentral = "¿Quiéres eliminar el espacio?";
    bool bannerConfirma = true;

    return showDialog<String>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
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
                "Espacios",
                textAlign: TextAlign.center,
                style: TextStyle(color: appTheme.onPrimary),
              ),
              content: Container(
                color: appTheme.onSecondary,
                height: 80,
                padding: const EdgeInsets.all(6),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("", maxLines: 1),
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
                    const Text("", maxLines: 1),
                  ],
                ),
              ),
              actions: [
                if (bannerConfirma)
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
                        //backgroundColor: appTheme.onTertiary,
                        fontSize: 10,
                        fontFamily: "Comfortaa",
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: () async {
                      debugPrintLevels(
                        5,
                        "*** creaFichaCapturaPropiedad: BORRA ESPACIO: ${widget.propiedad.espacioscasa.idPropiedad}",
                      );
                      // 4. BORRA ESPACIO en Base de Datos
                      await deleteEspacioToCouchDB(
                        widget.propiedad.espacioscasa.tipodeanuncio,
                        widget.propiedad,
                      ).then((resultado) async {
                        debugPrintLevels(
                          5,
                          "06. PaginaEditaEspacio Resultado de BORRADO ESPACIO: $resultado",
                        );
                        setState(() {
                          bannerConfirma = false;
                          if (resultado == 200 || resultado == 202) {
                            mensajeCentral = "Se borro el espacio de promoción";
                          } else {
                            mensajeCentral =
                                "Error: no se puedo borrar el espacio.";
                          }
                        });
                      });
                    },
                  ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.fromLTRB(3, 0, 3, 0),
                    backgroundColor: appTheme.surface,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: Text(
                    (bannerConfirma) ? "No" : "Salir",
                    style: TextStyle(
                      color: appTheme.onPrimaryContainer,
                      //backgroundColor: appTheme.onTertiary,
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
*/
//------------------------------------------------------------------------------

/*
// ignore: must_be_immutable
class ConceptoEspacioRow extends StatelessWidget {
  int index;
  String concepto;
  String valor;

  ConceptoEspacioRow(this.index, this.concepto, this.valor, {super.key});

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
              // width: 175,
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
              // width: 175,
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

// ignore: must_be_immutable
class UbicacionEspacioRow extends StatelessWidget {
  String concepto;
  String valor;

  UbicacionEspacioRow(this.concepto, this.valor, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: appTheme.onPrimary,
      width: widthCuadroFotoPropiedad,
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              height: 20,
              // width: 175,
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
              // width: 175,
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

// ignore: must_be_immutable
class CreaFichaCapturaPropiedad extends StatelessWidget {
  BuildContext context;
  WidgetRef ref;
  int indexListaPropiedad;
  ValueEspaciosCasaGet propiedad;
  dynamic update;

  CreaFichaCapturaPropiedad(
    this.context,
    this.ref,
    this.indexListaPropiedad,
    this.propiedad,
    this.update, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // debugPrintLevels(5, '*********************************************');
    debugPrintLevels(5, '** CREA FICHA CAPTURA PROPIEDAD');
    // debugPrintLevels(5, '*********************************************');

    debugPrintLevels(
      5,
      "*** No. $indexListaPropiedad creaFichaCapturaPropiedad Genera Card: ${propiedad.espacioscasa.idPropiedad}",
    );

    // ignore: no_leading_underscores_for_local_identifiers
    Future<GetIdsFotosUserProp> _recuperaIdsFotosDePropiedades =
        recuperaIdsFotosDePropiedades(
          ref,
          propiedad.espacioscasa.idusuario,
          propiedad.espacioscasa.idPropiedad,
        );

    Widget widgetresponse;

    return Card(
      color: appTheme.primary,
      shadowColor: appTheme.secondary,
      elevation: 6.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6),
        side: BorderSide(
          color: appTheme.primary,
          width: 1,
          style: BorderStyle.solid,
        ),
      ),
      margin: const EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
      child: Column(
        children: [
          // MODIFICA DATOS DE LA PROPIEDAD --------------------------------------
          GestureDetector(
            onTap: () {
              // *****************************************************************
              debugPrintLevels(
                5,
                "*** creaFichaCapturaPropiedad: editaespacio ficha: ${propiedad.espacioscasa.idPropiedad}",
              );
              Navigator.pushNamed(
                context,
                AppRoutes
                    .editaespacio, // PaginaEditaEspacio(), form_update_espacio_comprado.dart
                arguments: propiedad,
              );
              // *****************************************************************
            },
            child: Center(
              child: Container(
                width: 500,
                //height: 40,
                alignment: Alignment.center,
                padding: const EdgeInsets.fromLTRB(6, 6, 6, 6),
                decoration: BoxDecoration(
                  color: appTheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: appTheme.primary, width: 2),
                ),
                child: Container(
                  alignment: Alignment.center,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text(
                          "Modifica datos de la propiedad",
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          style: TextStyle(
                            fontSize: fontSizeSubtituloPagina,
                            fontWeight: FontWeight.bold,
                            color: appTheme.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 5),
          // LETRERO PROMOCIONAL -----------------------------------------
          /// NOMBRE DE LA PROPIEDAD
          Container(
            width: 350,
            // height: 32,
            padding: const EdgeInsets.fromLTRB(5.0, 1, 1.5, 5),
            alignment: Alignment.topLeft,
            child: Text(
              propiedad.espacioscasa.nombredelapropiedad,
              maxLines: 3,
              overflow: TextOverflow.visible,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.normal,
                color: appTheme.onPrimary,
              ),
            ),
          ),
          /*
        Container(
          width: 350,
          height: 26,
          padding: const EdgeInsets.fromLTRB(5.0, 1, 1.5, 1),
          alignment: Alignment.centerLeft,
          color: appTheme.surface,
          child: Text(
            propiedad.espacioscasa.idPropiedad,
            maxLines: 3,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.normal,
              color: appTheme.primary,
            ),
          ),
        ),
        */
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
                  // color: appTheme.outline,
                  child: InkWell(
                    child: Center(
                      child: FutureBuilder<GetIdsFotosUserProp>(
                        future: // OBTIENE DE LA BD LA LISTA DE PROPIEDADES
                            _recuperaIdsFotosDePropiedades,
                        builder: (context, snapshotIdsFotos) {
                          debugPrintLevels(7, "** _recuperaFotoPorIdFoto");
                          switch (snapshotIdsFotos.connectionState) {
                            case ConnectionState.none:
                              return stateNone(350, 250);
                            case ConnectionState.waiting:
                              return stateWaiting(350, 250);
                            case ConnectionState.active:
                              return stateActive(350, 250);
                            case ConnectionState.done:
                              if (snapshotIdsFotos.hasError) {
                                return stateErrorFormat(
                                  350,
                                  250,
                                  snapshotIdsFotos.error,
                                );
                              } else {
                                debugPrintLevels(
                                  7,
                                  "** FutureBuilder recuperaFotoPorIdFoto: done",
                                );
                                GetIdsFotosUserProp? listaIdsFotos =
                                    snapshotIdsFotos.data;

                                (listaIdsFotos!.rows.isEmpty)
                                    ? // CASO: PROPIEDAD SIN FOTOS
                                      widgetresponse = Container(
                                        width: 350,
                                        height: 250,
                                        color: appTheme.primaryContainer,
                                        child: Align(
                                          alignment: Alignment
                                              .center, // Or Alignment.topLeft, Alignment.bottomRight, etc.
                                          child: Text(
                                            "Agrega foto principal",
                                            style: TextStyle(
                                              fontSize: 12,
                                              color:
                                                  appTheme.onPrimaryContainer,
                                            ),
                                          ),
                                        ),
                                      )
                                    : // CASO: PROPIEDAD CON FOTO PRINCIPAL
                                      (listaIdsFotos.rows[0].value == "")
                                    ? widgetresponse = const Text(
                                        "No se encontró foto",
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.white,
                                        ),
                                      )
                                    : widgetresponse = Container(
                                        alignment: Alignment.topCenter,
                                        child: FutureBuilder<String>(
                                          // OBTIENE DE LA BD LA LISTA DE PROPIEDADES
                                          future: recuperaFotoPorIdFoto(
                                            snapshotIdsFotos
                                                .data!
                                                .rows[0]
                                                .value,
                                          ),
                                          builder: (context, snapshotFoto) {
                                            debugPrintLevels(
                                              9,
                                              ">>  PaginaCarouselFotosWidget recuperaFotoPorIdFoto",
                                            );
                                            switch (snapshotFoto
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
                                                if (snapshotFoto.hasError) {
                                                  return stateErrorFormat(
                                                    widthCuadroFotoPropiedad,
                                                    heightCuadroFotoPropiedad,
                                                    snapshotFoto.error,
                                                  );
                                                } else {
                                                  debugPrintLevels(
                                                    9,
                                                    "FutureBuilder recuperaFotoPorIdFoto: done",
                                                  );

                                                  String? fotoprincipal =
                                                      snapshotFoto.data;

                                                  return (snapshotFoto.data ==
                                                          "")
                                                      ? const Text(
                                                          "No se encontro foto",
                                                          style: TextStyle(
                                                            fontSize: 12,
                                                            color: Colors.white,
                                                          ),
                                                        )
                                                      : Ink.image(
                                                          fit: BoxFit
                                                              .fitHeight, // https://api.flutter.dev/flutter/painting/BoxFit.html
                                                          image: MemoryImage(
                                                            base64Decode(
                                                              fotoprincipal!,
                                                            ),
                                                          ),
                                                        );
                                                }
                                            }
                                          },
                                        ),
                                      );

                                /*
                                        widgetresponse = Ink.image(
                                            fit: BoxFit
                                                .fill, // https://api.flutter.dev/flutter/painting/BoxFit.html
                                            image: MemoryImage(base64Decode(
                                                fotoprincipal.rows[0].value)),
                                          );
                                          */
                              }
                              return widgetresponse;
                          }
                        },
                      ),
                    ),
                    onTap: () {
                      // debugPrintLevels(6, "***********************************");
                      debugPrintLevels(6, "*** call carouselfotospropiedad");
                      // debugPrintLevels(6, "***********************************");
                      Navigator.pushNamed(
                        context,
                        AppRoutes.fotospropiedad,
                        // pagina_fotos_propiedad.dart
                        // PaginaFotosPropiedad
                        arguments: propiedad,
                      );
                    },
                  ),
                ),
                // Barra de datos de la imagen -----------------------
                Align(
                  alignment: Alignment.bottomRight,
                  child: Container(
                    height: 40,
                    width: 40,
                    color: Colors.black.withValues(alpha: 0.3),
                  ),
                ),
                // LETRERO DE LA INMOBILIARIA
                /*
              Container(
                padding: const EdgeInsets.all(12.0),
                alignment: Alignment.bottomLeft,
                child: Text(
                  "Inmobiliaria: ${propiedad.espacioscasa.inmobiliaria}",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
              */
                // ICONO DE AMPLIAR DATOS
                Align(
                  alignment: Alignment.bottomRight,
                  child: IconButton(
                    icon: const Icon(Symbols.fullscreen),
                    iconSize: 20,
                    splashRadius: 5,
                    color: Colors.white,
                    tooltip: 'Ampliar',
                    onPressed: () {
                      // ROUTES CHECK
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PaginaDetalleWidget(propiedad),
                        ),
                      );
                      //
                      // const paginaPublicacionesGrupo()));
                    },
                  ),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    height: 40,
                    width: 40,
                    color: Colors.black.withValues(alpha: 0.3),
                  ),
                ),
                // ICONO DE GUARDAR
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    icon: const Icon(Symbols.playlist_add),
                    iconSize: 20,
                    splashRadius: 5,
                    color: Colors.white,
                    tooltip: 'Guardar',
                    onPressed: () {},
                  ),
                ),
              ],
            ),
          ),
          // PRECIO
          Container(
            height: 40,
            width: 350,
            color: appTheme.surface,
            padding: const EdgeInsets.all(1.5),
            alignment: Alignment.center,
            child: letrerprecio(propiedad),
            /*
          Text(
            "Precio: ${propiedad.espacioscasa.precio} ${propiedad.espacioscasa.moneda}",
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: appTheme.onPrimaryContainer,
            ),
          ),
          */
          ),
          // DATOS DE LA PROPIEDAD
          Container(
            width: 350,
            //height: 26,
            padding: const EdgeInsets.fromLTRB(5.0, 3, 3, 5),
            alignment: Alignment.centerLeft,
            child: Text(
              "${propiedad.espacioscasa.ubicacioncasa.localidadCp.asentamiento}, ${propiedad.espacioscasa.ubicacioncasa.localidadCp.municipio}, C.P. ${propiedad.espacioscasa.ubicacioncasa.localidadCp.cp.toString()}",
              maxLines: 3,
              overflow: TextOverflow.visible,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.normal,
                color: appTheme.onPrimary,
              ),
            ),
          ),

          // Barras Desplegable  ----------------------
          // CARACTERISTICAS DE LA PROPIEDAD
          SizedBox(
            width: 350,
            child: ExpansionTile(
              textColor: appTheme.primary,
              backgroundColor: appTheme.surface,
              collapsedTextColor: appTheme.onPrimary,
              collapsedBackgroundColor: appTheme.primary,
              collapsedIconColor: appTheme.onPrimary,
              title: const Text(
                "Características",
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
              children: [
                UbicacionEspacioRow(
                  "Mantenimiento",
                  propiedad.espacioscasa.mantenimiento,
                ),
                Column(
                  children: [
                    Row(
                      children: [
                        ConceptoEspacioRow(
                          0,
                          "Terreno",
                          propiedad.espacioscasa.metrosdeterreno,
                        ),
                        ConceptoEspacioRow(
                          0,
                          "Construcción",
                          propiedad.espacioscasa.metrosconstruidos,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        ConceptoEspacioRow(
                          0,
                          "Recamaras",
                          propiedad.espacioscasa.recamaras,
                        ),
                        ConceptoEspacioRow(
                          0,
                          "Cuarto de Servicio",
                          propiedad.espacioscasa.cuartosdeservicio,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        ConceptoEspacioRow(
                          0,
                          "Baños",
                          propiedad.espacioscasa.banos,
                        ),
                        ConceptoEspacioRow(
                          0,
                          "Medios Baños",
                          propiedad.espacioscasa.mediosbanos,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        ConceptoEspacioRow(
                          0,
                          "Estacionamientos",
                          propiedad.espacioscasa.estacionamientos,
                        ),
                        ConceptoEspacioRow(
                          0,
                          "Cubiertos",
                          propiedad.espacioscasa.mediosbanos,
                        ),
                      ],
                    ),
                  ],
                ),
                // UBICACION
                UbicacionEspacioRow(
                  "Ubicación",
                  propiedad.espacioscasa.ubicacioncasa.localidadCp.asentamiento,
                ),
                UbicacionEspacioRow(
                  "Pais",
                  propiedad.espacioscasa.ubicacioncasa.localidadCp.estado,
                ),
                UbicacionEspacioRow(
                  "Estado",
                  propiedad.espacioscasa.ubicacioncasa.pais,
                ),
                UbicacionEspacioRow(
                  "Municipio",
                  propiedad.espacioscasa.ubicacioncasa.localidadCp.municipio,
                ),
                UbicacionEspacioRow(
                  "Ciudad",
                  propiedad.espacioscasa.ubicacioncasa.localidadCp.ciudad,
                ),
                UbicacionEspacioRow(
                  "Zona",
                  propiedad.espacioscasa.ubicacioncasa.localidadCp.zona,
                ),
                UbicacionEspacioRow(
                  "C.P.",
                  propiedad.espacioscasa.ubicacioncasa.localidadCp.cp
                      .toString(),
                ),
                UbicacionEspacioRow(
                  "Colonia",
                  propiedad.espacioscasa.ubicacioncasa.localidadCp.asentamiento,
                ),
                UbicacionEspacioRow(
                  "Tipo",
                  propiedad.espacioscasa.ubicacioncasa.localidadCp.tipo,
                ),
                UbicacionEspacioRow(
                  "Calle",
                  propiedad.espacioscasa.ubicacioncasa.calle,
                ),
                Row(
                  children: [
                    ConceptoEspacioRow(
                      0,
                      "Num. Exterior",
                      propiedad.espacioscasa.ubicacioncasa.numeroexterior,
                    ),
                    ConceptoEspacioRow(
                      0,
                      "Num. Interior",
                      propiedad.espacioscasa.ubicacioncasa.numerointerior,
                    ),
                  ],
                ),
              ],
            ),
          ),
          // BARRA DE DATOS DEL CONTACTO
          SizedBox(
            width: 350,
            child: ExpansionTile(
              textColor: appTheme.primary,
              backgroundColor: appTheme.surface,
              collapsedTextColor: appTheme.onPrimary,
              collapsedBackgroundColor: appTheme.primary,
              collapsedIconColor: appTheme.onPrimary,
              title: const Text(
                "Datos del contacto",
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
              children: [
                UbicacionEspacioRow(
                  "Nombre",
                  propiedad.espacioscasa.datosdelcontactocasa.nombre,
                ),
                UbicacionEspacioRow(
                  "Compañia",
                  propiedad.espacioscasa.datosdelcontactocasa.empresa,
                ),
                UbicacionEspacioRow(
                  "Teléfono",
                  propiedad.espacioscasa.datosdelcontactocasa.numerocelular,
                ),
                UbicacionEspacioRow(
                  "Correo",
                  propiedad.espacioscasa.datosdelcontactocasa.correoelectronico,
                ),
              ],
            ),
          ),
          // BARRA DE DATOS ADICIONALES
          SizedBox(
            width: 350,
            child: ExpansionTile(
              textColor: appTheme.primary,
              backgroundColor: appTheme.surface,
              collapsedTextColor: appTheme.onPrimary,
              collapsedBackgroundColor: appTheme.primary,
              collapsedIconColor: appTheme.onPrimary,
              title: const Text(
                "Datos adicionales",
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
              children: List<Widget>.generate(listaAdicionales.length, (
                int index2,
              ) {
                String variableRegreso = "";
                switch (index2) {
                  case 0:
                    variableRegreso = propiedad
                        .espacioscasa
                        .datosadicionalescasa
                        .panelessolares;
                  case 1:
                    variableRegreso =
                        propiedad.espacioscasa.datosadicionalescasa.jardin;
                  case 2:
                    variableRegreso =
                        propiedad.espacioscasa.datosadicionalescasa.alberca;
                  case 3:
                    variableRegreso =
                        propiedad.espacioscasa.datosadicionalescasa.calefaccion;
                  case 4:
                    variableRegreso = propiedad
                        .espacioscasa
                        .datosadicionalescasa
                        .aireacondicionado;
                  case 5:
                    variableRegreso =
                        propiedad.espacioscasa.datosadicionalescasa.seguridad;
                  case 6:
                    variableRegreso = propiedad
                        .espacioscasa
                        .datosadicionalescasa
                        .enfraccionamiento;
                  case 7:
                    variableRegreso = propiedad
                        .espacioscasa
                        .datosadicionalescasa
                        .casasenelconjunto;
                  case 8:
                    variableRegreso =
                        propiedad.espacioscasa.datosadicionalescasa.casaclub;
                  case 9:
                    variableRegreso = propiedad
                        .espacioscasa
                        .datosadicionalescasa
                        .salondeeventos;
                  case 10:
                    variableRegreso = propiedad
                        .espacioscasa
                        .datosadicionalescasa
                        .centrodenegocios;
                  case 11:
                    variableRegreso =
                        propiedad.espacioscasa.datosadicionalescasa.gimnacio;
                  case 12:
                    variableRegreso =
                        propiedad.espacioscasa.datosadicionalescasa.cisterna;
                  case 13:
                    variableRegreso = propiedad
                        .espacioscasa
                        .datosadicionalescasa
                        .almacenamientodeagua;
                  case 14:
                    variableRegreso = propiedad
                        .espacioscasa
                        .datosadicionalescasa
                        .tratamientodeaguas;
                  case 15:
                    variableRegreso = propiedad
                        .espacioscasa
                        .datosadicionalescasa
                        .otrascaracteristicas;
                  default:
                    variableRegreso = "";
                }

                return (variableRegreso != "")
                    ? UbicacionEspacioRow(listaAdicionales[index2], "")
                    : Container(width: 1);
              }),
            ),
          ),
          // fin ----------------
        ],
      ),
    );
  }
}
*/
//------------------------------------------------------------------------------
/*
Future<Card> creaFichaCapturaPropiedad(BuildContext context, WidgetRef ref,
    int indexListaPropiedad, ValueEspaciosCasaGet propiedad, update) async {
  // debugPrintLevels(5, '*********************************************');
  debugPrintLevels(5, '** CREA FICHA CAPTURA PROPIEDAD');
  // debugPrintLevels(5, '*********************************************');

  // ignore: no_leading_underscores_for_local_identifiers
  // GUARDA LA POSICION DE LA PROPIEDAD EN LA LISTA DE PROPIEDADES
  parameterGestionFoto["indice"] = indexListaPropiedad;
  debugPrintLevels(5,
      "*** No. $indexListaPropiedad creaFichaCapturaPropiedad Genera Card: ${propiedad.espacioscasa.idPropiedad}");

  // ignore: no_leading_underscores_for_local_identifiers
  Future<GetIdsFotosUserProp> _recuperaIdsFotosDePropiedades =
      recuperaIdsFotosDePropiedades(ref, propiedad.espacioscasa.idusuario,
          propiedad.espacioscasa.idPropiedad);
  /*
  _recuperaFotoPorIdFoto =
      recuperaFotoPorIdFoto(propiedad.espacioscasa.fotoprincipal);
  */
  Widget widgetresponse;

//CAMBIAR RECUPERAFOTO
  return Card(
    color: appTheme.primary,
    shadowColor: appTheme.secondary,
    elevation: 6.0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(6),
      side: BorderSide(
        color: appTheme.primary,
        width: 1,
        style: BorderStyle.solid,
      ),
    ),
    margin: const EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
    child: Column(
      children: [
        // MODIFICA DATOS DE LA PROPIEDAD --------------------------------------
        GestureDetector(
          onTap: () {
            // *****************************************************************
            debugPrintLevels(5,
                "*** creaFichaCapturaPropiedad: editaespacio ficha: ${propiedad.espacioscasa.idPropiedad}");
            Navigator.pushNamed(
              context,
              AppRoutes
                  .editaespacio, // PaginaEditaEspacio(), form_update_espacio_comprado.dart
              arguments: propiedad,
            );
            // *****************************************************************
          },
          child: Center(
            child: Container(
              width: 500,
              //height: 40,
              alignment: Alignment.center,
              padding: const EdgeInsets.fromLTRB(6, 6, 6, 6),
              decoration: BoxDecoration(
                color: appTheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: appTheme.primary,
                  width: 2,
                ),
              ),
              child: Container(
                alignment: Alignment.center,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        "Modifica datos del espacio",
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        style: TextStyle(
                          fontSize: fontSizeSubtituloPagina,
                          fontWeight: FontWeight.bold,
                          color: appTheme.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        // LETRERO PROMOCIONAL -----------------------------------------
        /// NOMBRE DE LA PROPIEDAD
        Container(
          width: 350,
          // height: 32,
          padding: const EdgeInsets.fromLTRB(5.0, 1, 1.5, 5),
          alignment: Alignment.topLeft,
          child: Text(
            propiedad.espacioscasa.nombredelapropiedad,
            maxLines: 3,
            overflow: TextOverflow.visible,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.normal,
              color: appTheme.onPrimary,
            ),
          ),
        ),
        /*
        Container(
          width: 350,
          height: 26,
          padding: const EdgeInsets.fromLTRB(5.0, 1, 1.5, 1),
          alignment: Alignment.centerLeft,
          color: appTheme.surface,
          child: Text(
            propiedad.espacioscasa.idPropiedad,
            maxLines: 3,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.normal,
              color: appTheme.primary,
            ),
          ),
        ),
        */
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
                // color: appTheme.outline,
                child: InkWell(
                  child: Center(
                    child: FutureBuilder<GetIdsFotosUserProp>(
                      future: // OBTIENE DE LA BD LA LISTA DE PROPIEDADES
                          _recuperaIdsFotosDePropiedades,
                      builder: (context, snapshot) {
                        debugPrintLevels(7, "** _recuperaFotoPorIdFoto");
                        switch (snapshot.connectionState) {
                          case ConnectionState.none:
                            return stateNone(350, 250);
                          case ConnectionState.waiting:
                            return stateWaiting(350, 250);
                          case ConnectionState.active:
                            return stateActive(350, 250);
                          case ConnectionState.done:
                            if (snapshot.hasError) {
                              return stateErrorFormat(350, 250, snapshot.error);
                            } else {
                              debugPrintLevels(7,
                                  "** FutureBuilder recuperaFotoPorIdFoto: done");
                              GetIdsFotosUserProp? fotoprincipal =
                                  snapshot.data;

                              (fotoprincipal!.rows.isEmpty)
                                  ? // CASO: PROPIEDAD SIN FOTOS
                                  widgetresponse = Container(
                                      width: 350,
                                      height: 250,
                                      color: appTheme.primaryContainer,
                                      child: Align(
                                        alignment: Alignment
                                            .center, // Or Alignment.topLeft, Alignment.bottomRight, etc.
                                        child: Text(
                                          "Agrega foto principal",
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: appTheme.onPrimaryContainer,
                                          ),
                                        ),
                                      ),
                                    )
                                  : // CASO: PROPIEDAD CON FOTO PRINCIPAL

                                  (snapshot.data!.rows[0].value == "")
                                      ? widgetresponse = const Text(
                                          "No se encontró foto",
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.white,
                                          ),
                                        )
                                      : widgetresponse = Ink.image(
                                          fit: BoxFit
                                              .fill, // https://api.flutter.dev/flutter/painting/BoxFit.html
                                          image: MemoryImage(
                                              base64Decode(fotoprincipal)),
                                        );
                            }
                            return widgetresponse;
                        }
                      },
                    ),
                  ),
                  onTap: () {
                    // debugPrintLevels(6, "***********************************");
                    debugPrintLevels(6, "*** call carouselfotospropiedad");
                    // debugPrintLevels(6, "***********************************");
                    Navigator.pushNamed(
                      context,
                      AppRoutes.fotospropiedad,
                      // pagina_fotos_propiedad.dart
                      // PaginaFotosPropiedad
                      arguments: propiedad,
                    );
                  },
                ),
              ),
              // Barra de datos de la imagen -----------------------
              Align(
                alignment: Alignment.bottomRight,
                child: Container(
                    height: 40,
                    width: 40,
                    color: Colors.black.withValues(alpha: 0.3)),
              ),
              // LETRERO DE LA INMOBILIARIA
              /*
              Container(
                padding: const EdgeInsets.all(12.0),
                alignment: Alignment.bottomLeft,
                child: Text(
                  "Inmobiliaria: ${propiedad.espacioscasa.inmobiliaria}",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
              */
              // ICONO DE AMPLIAR DATOS
              Align(
                alignment: Alignment.bottomRight,
                child: IconButton(
                  icon: const Icon(Symbols.fullscreen),
                  iconSize: 20,
                  splashRadius: 5,
                  color: Colors.white,
                  tooltip: 'Ampliar',
                  onPressed: () {
                    // ROUTES CHECK
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PaginaDetalleWidget(),
                      ),
                    );
                    //
                    // const paginaPublicacionesGrupo()));
                  },
                ),
              ),
              Align(
                alignment: Alignment.topRight,
                child: Container(
                    height: 40,
                    width: 40,
                    color: Colors.black.withValues(alpha: 0.3)),
              ),
              // ICONO DE GUARDAR
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: const Icon(Symbols.playlist_add),
                  iconSize: 20,
                  splashRadius: 5,
                  color: Colors.white,
                  tooltip: 'Guardar',
                  onPressed: () {},
                ),
              ),
            ],
          ),
        ),
        // PRECIO
        Container(
          height: 40,
          width: 350,
          color: appTheme.surface,
          padding: const EdgeInsets.all(1.5),
          alignment: Alignment.center,
          child: letrerprecio(propiedad),
          /*
          Text(
            "Precio: ${propiedad.espacioscasa.precio} ${propiedad.espacioscasa.moneda}",
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: appTheme.onPrimaryContainer,
            ),
          ),
          */
        ),
        // DATOS DE LA PROPIEDAD
        Container(
          width: 350,
          //height: 26,
          padding: const EdgeInsets.fromLTRB(5.0, 3, 3, 5),
          alignment: Alignment.centerLeft,
          child: Text(
            "${propiedad.espacioscasa.ubicacioncasa.localidadCp.asentamiento}, ${propiedad.espacioscasa.ubicacioncasa.localidadCp.municipio}, C.P. ${propiedad.espacioscasa.ubicacioncasa.localidadCp.cp.toString()}",
            maxLines: 3,
            overflow: TextOverflow.visible,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.normal,
              color: appTheme.onPrimary,
            ),
          ),
        ),

        // Barras Desplegable  ----------------------
        // CARACTERISTICAS DE LA PROPIEDAD
        SizedBox(
          width: 350,
          child: ExpansionTile(
            textColor: appTheme.primary,
            backgroundColor: appTheme.surface,
            collapsedTextColor: appTheme.onPrimary,
            collapsedBackgroundColor: appTheme.primary,
            collapsedIconColor: appTheme.onPrimary,
            title: const Text(
              "Características",
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
            children: [
              UbicacionEspacioRow(
                  "Mantenimiento", propiedad.espacioscasa.mantenimiento),
              Column(
                children: [
                  Row(
                    children: [
                      ConceptoEspacioRow(
                          0, "Terreno", propiedad.espacioscasa.metrosdeterreno),
                      ConceptoEspacioRow(0, "Construcción",
                          propiedad.espacioscasa.metrosconstruidos),
                    ],
                  ),
                  Row(
                    children: [
                      ConceptoEspacioRow(
                          0, "Recamaras", propiedad.espacioscasa.recamaras),
                      ConceptoEspacioRow(0, "Cuarto de Servicio",
                          propiedad.espacioscasa.cuartosdeservicio),
                    ],
                  ),
                  Row(
                    children: [
                      ConceptoEspacioRow(
                          0, "Baños", propiedad.espacioscasa.banos),
                      ConceptoEspacioRow(0, "Medios Baños",
                          propiedad.espacioscasa.mediosbanos),
                    ],
                  ),
                  Row(
                    children: [
                      ConceptoEspacioRow(0, "Estacionamientos",
                          propiedad.espacioscasa.estacionamientos),
                      ConceptoEspacioRow(
                          0, "Cubiertos", propiedad.espacioscasa.mediosbanos),
                    ],
                  ),
                ],
              ),
              // UBICACION
              UbicacionEspacioRow(
                  "Ubicación",
                  propiedad
                      .espacioscasa.ubicacioncasa.localidadCp.asentamiento),
              UbicacionEspacioRow("Pais",
                  propiedad.espacioscasa.ubicacioncasa.localidadCp.estado),
              UbicacionEspacioRow(
                  "Estado", propiedad.espacioscasa.ubicacioncasa.pais),
              UbicacionEspacioRow("Municipio",
                  propiedad.espacioscasa.ubicacioncasa.localidadCp.municipio),
              UbicacionEspacioRow("Ciudad",
                  propiedad.espacioscasa.ubicacioncasa.localidadCp.ciudad),
              UbicacionEspacioRow("Zona",
                  propiedad.espacioscasa.ubicacioncasa.localidadCp.zona),
              UbicacionEspacioRow(
                  "C.P.",
                  propiedad.espacioscasa.ubicacioncasa.localidadCp.cp
                      .toString()),
              UbicacionEspacioRow(
                  "Colonia",
                  propiedad
                      .espacioscasa.ubicacioncasa.localidadCp.asentamiento),
              UbicacionEspacioRow("Tipo",
                  propiedad.espacioscasa.ubicacioncasa.localidadCp.tipo),
              UbicacionEspacioRow(
                  "Calle", propiedad.espacioscasa.ubicacioncasa.calle),
              Row(
                children: [
                  ConceptoEspacioRow(0, "Num. Exterior",
                      propiedad.espacioscasa.ubicacioncasa.numeroexterior),
                  ConceptoEspacioRow(0, "Num. Interior",
                      propiedad.espacioscasa.ubicacioncasa.numerointerior),
                ],
              ),
            ],
          ),
        ),
        // BARRA DE DATOS DEL CONTACTO
        SizedBox(
          width: 350,
          child: ExpansionTile(
            textColor: appTheme.primary,
            backgroundColor: appTheme.surface,
            collapsedTextColor: appTheme.onPrimary,
            collapsedBackgroundColor: appTheme.primary,
            collapsedIconColor: appTheme.onPrimary,
            title: const Text(
              "Datos del contacto",
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
            children: [
              UbicacionEspacioRow(
                  "Nombre", propiedad.espacioscasa.datosdelcontactocasa.nombre),
              UbicacionEspacioRow("Compañia",
                  propiedad.espacioscasa.datosdelcontactocasa.empresa),
              UbicacionEspacioRow("Teléfono",
                  propiedad.espacioscasa.datosdelcontactocasa.numerocelular),
              UbicacionEspacioRow(
                  "Correo",
                  propiedad
                      .espacioscasa.datosdelcontactocasa.correoelectronico),
            ],
          ),
        ),
        // BARRA DE DATOS ADICIONALES
        SizedBox(
          width: 350,
          child: ExpansionTile(
            textColor: appTheme.primary,
            backgroundColor: appTheme.surface,
            collapsedTextColor: appTheme.onPrimary,
            collapsedBackgroundColor: appTheme.primary,
            collapsedIconColor: appTheme.onPrimary,
            title: const Text(
              "Datos adicionales",
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
            children: List<Widget>.generate(
              listaAdicionales.length,
              (int index2) {
                String variableRegreso = "";
                switch (index2) {
                  case 0:
                    variableRegreso = propiedad
                        .espacioscasa.datosadicionalescasa.panelessolares;
                  case 1:
                    variableRegreso =
                        propiedad.espacioscasa.datosadicionalescasa.jardin;
                  case 2:
                    variableRegreso =
                        propiedad.espacioscasa.datosadicionalescasa.alberca;
                  case 3:
                    variableRegreso =
                        propiedad.espacioscasa.datosadicionalescasa.calefaccion;
                  case 4:
                    variableRegreso = propiedad
                        .espacioscasa.datosadicionalescasa.aireacondicionado;
                  case 5:
                    variableRegreso =
                        propiedad.espacioscasa.datosadicionalescasa.seguridad;
                  case 6:
                    variableRegreso = propiedad
                        .espacioscasa.datosadicionalescasa.enfraccionamiento;
                  case 7:
                    variableRegreso = propiedad
                        .espacioscasa.datosadicionalescasa.casasenelconjunto;
                  case 8:
                    variableRegreso =
                        propiedad.espacioscasa.datosadicionalescasa.casaclub;
                  case 9:
                    variableRegreso = propiedad
                        .espacioscasa.datosadicionalescasa.salondeeventos;
                  case 10:
                    variableRegreso = propiedad
                        .espacioscasa.datosadicionalescasa.centrodenegocios;
                  case 11:
                    variableRegreso =
                        propiedad.espacioscasa.datosadicionalescasa.gimnacio;
                  case 12:
                    variableRegreso =
                        propiedad.espacioscasa.datosadicionalescasa.cisterna;
                  case 13:
                    variableRegreso = propiedad
                        .espacioscasa.datosadicionalescasa.almacenamientodeagua;
                  case 14:
                    variableRegreso = propiedad
                        .espacioscasa.datosadicionalescasa.tratamientodeaguas;
                  case 15:
                    variableRegreso = propiedad
                        .espacioscasa.datosadicionalescasa.otrascaracteristicas;
                  default:
                    variableRegreso = "";
                }

                return (variableRegreso != "")
                    ? UbicacionEspacioRow(listaAdicionales[index2], "")
                    : Container(
                        width: 1,
                      );
              },
            ),
          ),
        ),
        // fin ----------------
      ],
    ),
  );
}
*/
