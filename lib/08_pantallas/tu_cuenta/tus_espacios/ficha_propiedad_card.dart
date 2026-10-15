import 'dart:convert';

import 'package:buscobien/08_pantallas/inicio/data_espacios_casas_get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../07_routes/app_routes.dart';
import '../../../60_global_widgets/future_builder_state_widgets.dart';
import '../../../20_var_globales/var_color_themes.dart';
import '../../../20_var_globales/variables_globales.dart';
import '../../../22_imagenes/tus_espacios_fotos_propiedad/manejo_de_fotos/futures_y_providers/foto_por_id_provider.dart';
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

part 'ficha_propiedad_dialogos.dart';
part 'ficha_propiedad_filas.dart';

//------------------------------------------------------------------------------
// OPTIMIZADO 2.0
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// WIDGET PRINCIPAL
//------------------------------------------------------------------------------
class FichaPropiedadCard extends ConsumerStatefulWidget {
  final int indexListaPropiedad;
  final ValueEspaciosCasaGet propiedad;
  final dynamic update;

  const FichaPropiedadCard(
    // ignore: avoid_unused_constructor_parameters
    BuildContext context,
    this.indexListaPropiedad,
    this.propiedad,
    this.update, {
    super.key,
  });

  @override
  ConsumerState<FichaPropiedadCard> createState() => _FichaPropiedadCardState();
}

class _FichaPropiedadCardState extends ConsumerState<FichaPropiedadCard> {
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
                                    child: FotoBuilder(idFoto: listaIdsFotos.rows[0].value, builder: (context, snapshotFoto) {
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
                                          return Semantics(
                                            image: true,
                                            label: 'Foto de la propiedad',
                                            child: Ink.image(
                                              fit: BoxFit.fitHeight,
                                              image: MemoryImage(
                                                base64Decode(
                                                  snapshotFoto.data!,
                                                ),
                                              ),
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
                              .propiedad.espacioscasa.estacionamientoscubiertos,
                        ), // Corregido el campo (estaba repetido mediosbanos en original)
                      ],
                    ),
                  ],
                ),
                // Ubicación detallada
                UbicacionEspacioRow(
                  "Ubicación",
                  widget.propiedad.espacioscasa.ubicacioncasa.localidadCp
                      .asentamiento,
                ),
                UbicacionEspacioRow(
                  "Pais",
                  widget.propiedad.espacioscasa.ubicacioncasa.pais,
                ), // Ajustado: Pais estaba mapeando a Estado en original? Corregido según nombre variable
                UbicacionEspacioRow(
                  "Estado",
                  widget
                      .propiedad.espacioscasa.ubicacioncasa.localidadCp.estado,
                ),
                UbicacionEspacioRow(
                  "Municipio",
                  widget.propiedad.espacioscasa.ubicacioncasa.localidadCp
                      .municipio,
                ),
                UbicacionEspacioRow(
                  "Ciudad",
                  widget
                      .propiedad.espacioscasa.ubicacioncasa.localidadCp.ciudad,
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
                          .propiedad.espacioscasa.ubicacioncasa.numeroexterior,
                    ),
                    ConceptoEspacioRow(
                      0,
                      "Num. Interior",
                      widget
                          .propiedad.espacioscasa.ubicacioncasa.numerointerior,
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
                  widget.propiedad.espacioscasa.datosdelcontactocasa
                      .numerocelular,
                ),
                UbicacionEspacioRow(
                  "Correo",
                  widget.propiedad.espacioscasa.datosdelcontactocasa
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
        collapsedShape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
}
//------------------------------------------------------------------------------
// OPTIMIZADO
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// OPTIMIZADO 01
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
