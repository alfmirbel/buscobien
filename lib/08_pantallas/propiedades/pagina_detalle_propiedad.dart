import 'dart:convert';
import 'package:buscobien/20_var_globales/variables_globales.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../60_global_widgets/future_builder_state_widgets.dart';
import '../../20_var_globales/var_color_themes.dart';
import '../../20_var_globales/var_color_widget.dart';
import '../../22_imagenes/data_models/data_fotos_ordenadas.dart';
import '../../22_imagenes/tus_espacios_fotos_propiedad/manejo_de_fotos/futures_y_providers/http_funciones_gestion_foto.dart';
import '../../22_imagenes/tus_espacios_fotos_propiedad/manejo_de_fotos/futures_y_providers/future_get_fotos_by_idpr_orden.dart';
import '../../22_imagenes/tus_espacios_fotos_propiedad/manejo_de_fotos/lista_fotos_ordenadas/provider_get_lista_fotos_ordenadas.dart';
import '../../22_imagenes/tus_espacios_fotos_propiedad/manejo_de_fotos/lista_ids_fotos/data_fotos_get_ids_fotos_user_prop.dart';
import '../../22_imagenes/tus_espacios_fotos_propiedad/manejo_de_fotos/futures_y_providers/future_recupera_ids_fotos_propiedad.dart';
import '../../22_imagenes/variables_imagenes.dart';
import '../../60_global_widgets/debugprint.dart';
import '../inicio/data_espacios_casas.dart';
import '../inicio/data_espacios_casas_get.dart';
import '../../10_user_login/usuario_login/provider_session.dart';
import '../../10_user_login/usuario_login/dialogbox_login.dart';
import '../../03_listas/provider_me_gusta.dart';
import '../../03_listas/provider_user_lists.dart';

//------------------------------------------------------------------------------
// OPTIMIZADO

class PaginaDetalleWidget extends ConsumerStatefulWidget {
  final ValueEspaciosCasaGet propiedad;
  final GetIdsFotosUserProp listaIdsFotos;
  // Si se pasa desde un chat, activa el botón "Guardar en lista".
  final String? fromChatUserId;

  const PaginaDetalleWidget(
    this.propiedad,
    this.listaIdsFotos, {
    super.key,
    this.fromChatUserId,
  });

  @override
  ConsumerState createState() {
    debugPrintLevels(1, " **************************************************");
    debugPrintLevels(1, "  1. PaginaDetalleWidget createState");
    debugPrintLevels(1, " **************************************************");
    return PaginaDetalleWidgetState();
  }
}

class PaginaDetalleWidgetState extends ConsumerState<PaginaDetalleWidget> {
  final scaffoldDetalleKey = GlobalKey<ScaffoldState>();

  // Variables de configuración UI
  final List<String> valoresVacios = ["", "0"];
  final double iconSizeBanner = 16.0;
  final double textSizeBanner = 10.0;
  final double espacioEntreDato = 8.0;

  @override
  void initState() {
    super.initState();
    debugPrintLevels(1, " **************************************************");
    debugPrintLevels(1, " - 2. PaginaDetalleWidget initState");
    debugPrintLevels(1, " **************************************************");
  }

  @override
  Widget build(BuildContext context) {
    debugPrintLevels(1, " **************************************************");
    debugPrintLevels(1, " - 3. PaginaDetalleWidget build");
    debugPrintLevels(1, " **************************************************");

    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    // Simplificación de acceso a datos para legibilidad
    final espacios = widget.propiedad.espacioscasa;
    final ubicacion = espacios.ubicacioncasa;
    final contacto = espacios.datosdelcontactocasa;
    final listamasdatos = widget.propiedad.espacioscasa.datosadicionalescasa;
    int indexMasDatos = 0;
    String etiquetaMasDatos = "";

    double padMargenL = 90;
    double padMargenR = 90;
    double padMargenT = 50;
    double padMargenB = 50;

    return LayoutBuilder(
      builder: (context, constraints) {
        final isNarrow = constraints.maxWidth < smallScreenMin;
        final padMargenL = isNarrow ? 15.0 : 40.0;
        final padMargenT = isNarrow ? 10.0 : 50.0;
        final padMargenR = isNarrow ? 15.0 : 40.0;
        final padMargenB = isNarrow ? 10.0 : 50.0;

        return SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(
            padMargenL,
            padMargenT,
            padMargenR,
            padMargenB,
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: desktopContentMaxWidth,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 10),
                  Text(
                    espacios.letreropromocional,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: appTheme.onPrimaryContainer,
                      fontSize: fontSizeTituloPagina,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Comfortaa',
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    alignment: Alignment.topLeft,
                    child: Text(
                      espacios.descripcion,
                      style: TextStyle(
                        fontSize: fontSizeSubtituloPagina,
                        color: appTheme.onPrimaryContainer,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  _buildFotoPrincipalYIconos(espacios),
                  const SizedBox(height: 15),
                  Container(
                    padding: const EdgeInsets.all(12.0),
                    alignment: Alignment.topLeft,
                    child: Text(
                      espacios.inmobiliaria,
                      style: TextStyle(
                        fontSize: 14,
                        color: appTheme.onPrimaryContainer,
                      ),
                    ),
                  ),
                  _buildPrecioFila('Precio venta', espacios.precioventa),
                  _buildPrecioFila('Precio renta', espacios.preciorenta),
                  const SizedBox(height: 10),
                  _buildTituloSeccion('Datos de la Propiedad'),
                  const SizedBox(height: 5),
                  Wrap(
                    spacing: 10,
                    runSpacing: 5,
                    children: [
                      _buildFilaDato('Terreno', espacios.metrosdeterreno, 250),
                      _buildFilaDato(
                          'Construcción', espacios.metrosconstruidos, 250),
                      _buildFilaDato('Recamaras', espacios.recamaras, 250),
                      _buildFilaDato('Cuartos de servicio',
                          espacios.cuartosdeservicio.toString(), 250),
                      _buildFilaDato('Baños', espacios.banos.toString(), 250),
                      _buildFilaDato(
                          'Medios baños', espacios.mediosbanos.toString(), 250),
                      _buildFilaDato(
                          'Estacionamientos', espacios.estacionamientos, 250),
                      _buildFilaDato(
                          'Cubiertos', espacios.estacionamientoscubiertos, 250),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _buildTituloSeccion('Ubicación', fontSize: 18),
                  Wrap(
                    spacing: 10,
                    runSpacing: 5,
                    children: [
                      _buildFilaDato(
                          'Dirección',
                          '${ubicacion.calle}, ${ubicacion.numeroexterior} - ${ubicacion.numerointerior}',
                          700),
                      _buildFilaDato(
                          'Colonia', ubicacion.localidadCp.asentamiento, 350),
                      _buildFilaDato(
                          'Ciudad', ubicacion.localidadCp.ciudad, 350),
                      _buildFilaDato(
                          'Municipio', ubicacion.localidadCp.municipio, 350),
                      _buildFilaDato(
                          'C.P.', ubicacion.localidadCp.cp.toString(), 350),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _buildTituloSeccion('Datos del contacto'),
                  const SizedBox(height: 5),
                  _buildDatoContacto('Nombre', contacto.nombre),
                  _buildDatoContacto('Teléfono', contacto.numerocelular),
                  _buildDatoContacto('Correo', contacto.correoelectronico),
                  const SizedBox(height: 20),
                  _buildTituloSeccion('Más datos de la propiedad'),
                  const SizedBox(height: 10),
                  _buildListaMasDatos(espacios),
                  const SizedBox(height: 20),
                  _buildTituloSeccion('Fotos propiedad'),
                  const SizedBox(height: 10),
                  _buildGaleriaFotos(espacios.idusuario, espacios.idPropiedad),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildListaMasDatos(EspaciosCasa espacios) {
    final listamasdatos = espacios.datosadicionalescasa;
    final items = <String>[];
    if (listamasdatos.panelessolares.isNotEmpty)
      items.add('Paneles solares: ${listamasdatos.panelessolares}');
    if (listamasdatos.jardin.isNotEmpty)
      items.add('Jardín: ${listamasdatos.jardin}');
    if (listamasdatos.alberca.isNotEmpty)
      items.add('Alberca: ${listamasdatos.alberca}');
    if (listamasdatos.calefaccion.isNotEmpty)
      items.add('Calefacción: ${listamasdatos.calefaccion}');
    if (listamasdatos.aireacondicionado.isNotEmpty)
      items.add('Aire acondicionado: ${listamasdatos.aireacondicionado}');
    if (listamasdatos.seguridad.isNotEmpty)
      items.add('Seguridad: ${listamasdatos.seguridad}');
    if (listamasdatos.enfraccionamiento.isNotEmpty)
      items.add('En fraccionamiento: ${listamasdatos.enfraccionamiento}');
    if (listamasdatos.casasenelconjunto.isNotEmpty)
      items.add('Casas en el conjunto: ${listamasdatos.casasenelconjunto}');
    if (listamasdatos.casaclub.isNotEmpty)
      items.add('Casa club: ${listamasdatos.casaclub}');
    if (listamasdatos.salondeeventos.isNotEmpty)
      items.add('Salón de eventos: ${listamasdatos.salondeeventos}');
    if (listamasdatos.centrodenegocios.isNotEmpty)
      items.add('Centro de negocios: ${listamasdatos.centrodenegocios}');
    if (listamasdatos.gimnacio.isNotEmpty)
      items.add('Gimnasio: ${listamasdatos.gimnacio}');
    if (listamasdatos.cisterna.isNotEmpty)
      items.add('Cisterna: ${listamasdatos.cisterna}');
    if (listamasdatos.almacenamientodeagua.isNotEmpty)
      items
          .add('Almacenamiento de agua: ${listamasdatos.almacenamientodeagua}');
    if (listamasdatos.tratamientodeaguas.isNotEmpty)
      items.add('Tratamiento de aguas: ${listamasdatos.tratamientodeaguas}');
    if (listamasdatos.otrascaracteristicas.isNotEmpty)
      items.add('Otras características: ${listamasdatos.otrascaracteristicas}');

    if (items.isEmpty) {
      return const SizedBox.shrink();
    }

    return Wrap(
      spacing: 8.0,
      runSpacing: 6.0,
      children: items
          .map((item) => Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: appTheme.surface,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: appTheme.outline),
                ),
                child: Text(item,
                    style: TextStyle(
                        color: appTheme.onSurface,
                        fontSize: fontSizeSubtituloPagina)),
              ))
          .toList(),
    );
  }

  Widget _buildTituloSeccion(String titulo, {double fontSize = 0}) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 350),
      padding: const EdgeInsets.fromLTRB(5.0, 1, 1.5, 8),
      alignment: Alignment.center,
      child: Text(
        titulo,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: fontSize > 0 ? fontSize : fontSizeTituloPagina,
          fontWeight: FontWeight.bold,
          color: appTheme.onPrimaryContainer,
        ),
      ),
    );
  }

  Widget _buildPrecioFila(String label, String valor) {
    if (valoresVacios.contains(valor)) return const SizedBox.shrink();
    return Container(
      height: 30,
      color: appTheme.surface,
      margin: const EdgeInsets.only(bottom: 2),
      alignment: Alignment.center,
      child: Text(
        '$label: $valor',
        style: TextStyle(
          fontSize: fontSizeSubtituloPagina,
          fontWeight: FontWeight.bold,
          color: appTheme.onPrimaryContainer,
        ),
      ),
    );
  }

  Widget _buildFilaDato(
    String label,
    String valor,
    double maxWidth, {
    bool fullWidth = false,
  }) {
    if (valoresVacios.contains(valor)) return const SizedBox.shrink();

    Widget contenido = Container(
      decoration: BoxDecoration(
        color: appTheme.surface,
        border: Border.all(color: appTheme.secondary, width: 1.0),
        borderRadius: BorderRadius.circular(3.0),
      ),
      padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
      alignment: Alignment.topLeft,
      child: Text(
        '$label: $valor',
        style: TextStyle(
          fontSize: fontSizeTextoCarta,
          fontWeight: FontWeight.normal,
          color: appTheme.onSurface,
        ),
      ),
    );

    return fullWidth
        ? Container(margin: const EdgeInsets.only(bottom: 2), child: contenido)
        : ConstrainedBox(
            constraints: BoxConstraints(minWidth: 140, maxWidth: maxWidth),
            child: contenido,
          );
  }

  Widget _buildDatoContacto(String label, String valor) {
    if (valor.isEmpty) return const SizedBox.shrink();
    return Align(
      alignment: Alignment.topLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 3.0, horizontal: 6.0),
        child: Text(
          '$label: $valor',
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildFotoPrincipalYIconos(EspaciosCasa espacios) {
    String idFotoPrincipal = '';
    if (widget.listaIdsFotos.rows.isNotEmpty) {
      idFotoPrincipal = widget.listaIdsFotos.rows[0].value;
    }

    return Column(
      children: [
        SizedBox(
          width: 350,
          height: 250,
          child: idFotoPrincipal.isEmpty
              ? const Center(child: Text('Sin foto'))
              : FutureBuilder<String>(
                  future: recuperaFotoPorIdFoto(idFotoPrincipal),
                  builder: (context, snapshotFoto) {
                    if (snapshotFoto.connectionState ==
                        ConnectionState.waiting) {
                      return stateWaiting(
                          widthCuadroFotoPropiedad, heightCuadroFotoPropiedad);
                    } else if (snapshotFoto.hasError) {
                      return stateErrorFormat(widthCuadroFotoPropiedad,
                          heightCuadroFotoPropiedad, snapshotFoto.error);
                    } else if (snapshotFoto.hasData &&
                        snapshotFoto.data != '') {
                      return Container(
                        width: 350,
                        height: 200,
                        decoration: BoxDecoration(
                          border: Border.all(
                              width: 3, color: appTheme.outlineVariant),
                          borderRadius: BorderRadius.circular(15),
                          image: DecorationImage(
                              image:
                                  MemoryImage(base64Decode(snapshotFoto.data!)),
                              fit: BoxFit.cover),
                        ),
                      );
                    } else {
                      return Container(
                        color: appTheme.surface,
                        alignment: Alignment.center,
                        child: Icon(Symbols.broken_image,
                            color: appTheme.onSurface),
                      );
                    }
                  },
                ),
        ),
        Container(
          width: widthCuadroFotoPropiedad,
          padding: const EdgeInsets.fromLTRB(5, 8, 3, 5),
          alignment: Alignment.centerLeft,
          child: Wrap(
            spacing: espacioEntreDato,
            runSpacing: 5,
            children: [
              _buildIconoDato(
                  Symbols.width_full, espacios.metrosdeterreno, 'mts.'),
              _buildIconoDato(
                  Symbols.home_work, espacios.metrosconstruidos, 'mts.'),
              _buildIconoDato(Symbols.bed, espacios.recamaras.toString(), ''),
              _buildIconoDato(Symbols.shower, espacios.banos.toString(), ''),
              _buildIconoDato(
                  Symbols.directions_car, espacios.estacionamientos, ''),
              _buildIconoDato(
                  Symbols.garage, espacios.estacionamientoscubiertos, ''),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildIconoDato(IconData icon, String valor, String sufijo) {
    if (valoresVacios.contains(valor)) return const SizedBox.shrink();
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: appTheme.onPrimaryContainer, size: iconSizeBanner),
        const SizedBox(width: 3),
        Text(
          '$valor $sufijo'.trim(),
          style: TextStyle(
              fontSize: textSizeBanner, color: appTheme.onPrimaryContainer),
        ),
      ],
    );
  }

  Widget _buildGaleriaFotos(String idUsuario, String idPropiedad) {
    return FutureBuilder<GetIdsFotosUserProp>(
      future: recuperaIdsFotosDePropiedades(idUsuario, idPropiedad),
      builder: (context, snapshotIdFotos) {
        if (snapshotIdFotos.connectionState == ConnectionState.waiting) {
          return stateWaiting(
              widthCuadroFotoPropiedad, heightCuadroFotoPropiedad);
        } else if (snapshotIdFotos.hasError) {
          return stateErrorFormat(widthCuadroFotoPropiedad,
              heightCuadroFotoPropiedad, snapshotIdFotos.error);
        }
        if (!snapshotIdFotos.hasData || snapshotIdFotos.data!.rows.isEmpty) {
          return const Center(child: Text('No se encontraron fotos'));
        }

        final listaIds = snapshotIdFotos.data!;

        return FutureBuilder<int>(
          future: recuperaFotosOrdenadasIdProperty(ref, idPropiedad),
          builder: (context, snapshotOrden) {
            if (snapshotOrden.connectionState == ConnectionState.waiting) {
              return stateWaiting(
                  widthCuadroFotoPropiedad, heightCuadroFotoPropiedad);
            }

            List<FotosOrden> fotosParaMostrar = [];
            final fotosProvider = ref.read(getListaFotosOrdenadasProvider);

            final usarProvider = snapshotOrden.data == 200 &&
                fotosProvider.rows.isNotEmpty &&
                fotosProvider.rows[0].value.listadefotos.fotosOrden.isNotEmpty;

            if (usarProvider) {
              fotosParaMostrar =
                  fotosProvider.rows[0].value.listadefotos.fotosOrden;
            } else {
              for (int i = 0; i < listaIds.rows.length; i++) {
                fotosParaMostrar.add(
                    FotosOrden(posicion: i, idFoto: listaIds.rows[i].value));
              }
            }

            return Wrap(
              spacing: 10.0,
              runSpacing: 10.0,
              children: fotosParaMostrar
                  .map((fotoItem) => _FotoItemWidget(idFoto: fotoItem.idFoto))
                  .toList(),
            );
          },
        );
      },
    );
  }
}

// -----------------------------------------------------------------------
// WIDGET INDEPENDIENTE PARA CADA FOTO
// -----------------------------------------------------------------------

class _FotoItemWidget extends StatelessWidget {
  final String idFoto;

  const _FotoItemWidget({required this.idFoto});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: recuperaFotoPorIdFoto(idFoto),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return stateWaiting(150, 100);
        }
        if (snapshot.hasError || !snapshot.hasData || snapshot.data == '') {
          return Container(
            width: 150,
            height: 100,
            color: appTheme.surface,
            child: Icon(Symbols.broken_image, color: appTheme.onSurface),
          );
        }

        return SizedBox(
          width: 150,
          height: 100,
          child: Ink.image(
            fit: BoxFit.cover,
            image: MemoryImage(base64Decode(snapshot.data!)),
            child: InkWell(onTap: () {}),
          ),
        );
      },
    );
  }
}

//------------------------------------------------------------------------------

// EXCEPCION_COLOR_ESPECIFICO: brand rojo favorito en icono de heart
// ARCHIVO: lib/08_pantallas/propiedades/pagina_detalle_propiedad.dart
// FECHA: 2026-07-14
// ignore: unused_element
class _MeGustaButtonFicha extends ConsumerWidget {
  final String propiedadId;
  const _MeGustaButtonFicha({required this.propiedadId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tieneGusta = ref
            .watch(meGustaProvider)
            .asData
            ?.value
            .any((m) => m.propiedadId == propiedadId) ??
        false;

    return IconButton(
      padding: EdgeInsets.zero,
      tooltip: tieneGusta ? 'Quitar de favoritos' : 'Agregar a favoritos',
      icon: Icon(
        tieneGusta ? Symbols.favorite : Symbols.favorite_border,
        color: tieneGusta ? const Color(0xFFE91E63) : appTheme.onPrimary,
        size: 20,
      ),
      onPressed: () {
        final session = ref.read(sessionProvider).sessionUserData;
        if (session.userId.isEmpty) {
          dialogBoxFichaLogin(context, ref);
          return;
        }
        ref.read(meGustaProvider.notifier).toggleMeGusta(
              usuarioId: session.userId,
              propiedadId: propiedadId,
              userListsNotifier: ref.read(userListsProvider.notifier),
            );
      },
    );
  }
}
