import 'dart:convert';

import 'package:buscobien/07_routes/routes_parameters.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';
import '../../../../07_routes/app_routes.dart';
import '../../../../60_global_widgets/future_builder_state_widgets.dart';
import '../../../../60_global_widgets/debugprint.dart';
import '../../../data_models/data_fotos_ordenadas.dart';
import '../../../variables_imagenes.dart';
import '../futures_y_providers/future_get_fotos_by_idpr_orden.dart';
import '../lista_fotos_ordenadas/provider_get_lista_fotos_ordenadas.dart';
import '../lista_ids_fotos/data_fotos_get_ids_fotos_user_prop.dart';
import '../../../../20_var_globales/var_color_themes.dart';
import '../../../../20_var_globales/var_color_widget.dart';
import '../../../../20_var_globales/variables_globales.dart';
import '../../../../08_pantallas/inicio/data_espacios_casas_get.dart';

import '../futures_y_providers/http_funciones_gestion_foto.dart';
import '../futures_y_providers/future_recupera_ids_fotos_propiedad.dart';

// OPTIMIZADO

import 'package:carousel_slider/carousel_slider.dart'; // NECESARIO

class PaginaCarouselFotosWidget extends ConsumerStatefulWidget {
  final ValueEspaciosCasaGet valueespaciosparameter;

  const PaginaCarouselFotosWidget(this.valueespaciosparameter, {super.key});

  @override
  ConsumerState<PaginaCarouselFotosWidget> createState() =>
      PaginaCarouselFotosWidgetState();
}

class PaginaCarouselFotosWidgetState
    extends ConsumerState<PaginaCarouselFotosWidget> {
  final scaffoldKeyListaFotos = GlobalKey<ScaffoldState>();
  String idUsuario = "";
  String idPropiedad = "";
  String nombrePropiedad = "";
  int indiceFotos = 0;
  int numeroDeFotos = 0;

  // Usamos CarouselSliderController para mayor control
  final CarouselSliderController controllerCarousel =
      CarouselSliderController();

  // Futuro unificado para cargar orden y datos
  late Future<void> _futureCargaDatos;

  // Estructura principal para manejar las fotos (Ordenada)
  ListaFotosOrdenadas listaIdFotosOrden = ListaFotosOrdenadas(
    idListaFotos: '',
    idUsuario: '',
    idPropiedad: '',
    fotosOrden: [],
    timestamp: '',
  );

  // Respaldo de IDs crudos
  GetIdsFotosUserProp listaIdsCrudos = GetIdsFotosUserProp(
    totalRows: 0,
    offset: 0,
    rows: [],
  );

  @override
  void initState() {
    debugPrintLevels(9, "* PaginaCarouselFotosWidget initState");

    // Inicialización de variables locales
    final espacios = widget.valueespaciosparameter.espacioscasa;
    idUsuario = espacios.idusuario;
    idPropiedad = espacios.idPropiedad;
    nombrePropiedad = espacios.nombredelapropiedad;

    // Inicializar parámetros de gestión
    parameterGestionFoto.addAll({
      "idUsuario": idUsuario,
      "idPropiedad": idPropiedad,
      "idFoto": espacios.fotoprincipal,
      "propiedad": widget.valueespaciosparameter,
      "fotoprincipal": espacios.fotoprincipal,
      "indice": 0,
    });

    // Cargar datos (IDs y Orden)
    _futureCargaDatos = _cargarDatosYOrden();

    super.initState();
  }

  /// Lógica centralizada para obtener IDs y luego el Orden
  Future<void> _cargarDatosYOrden() async {
    try {
      // 1. Obtener IDs crudos (para saber cuántas hay y validar)
      listaIdsCrudos = await recuperaIdsFotosDePropiedades(
        idUsuario,
        idPropiedad,
      );

      if (listaIdsCrudos.rows.isEmpty) {
        numeroDeFotos = 0;
        return;
      }

      numeroDeFotos = listaIdsCrudos.rows.length;

      // 2. Intentar obtener el orden guardado
      final statusOrden = await recuperaFotosOrdenadasIdProperty(
        ref,
        idPropiedad,
      );
      final listaOrdenProvider = ref.read(getListaFotosOrdenadasProvider);

      bool usarOrdenGuardado = false;

      // Validamos si la petición fue exitosa y si la lista tiene datos
      if (statusOrden == 200 && listaOrdenProvider.rows.isNotEmpty) {
        // Validamos integridad: ¿El número de fotos ordenadas coincide con las reales?
        // Si difieren, es mejor usar los IDs crudos para evitar errores de índice.
        if (listaOrdenProvider.rows[0].value.listadefotos.fotosOrden.length ==
            numeroDeFotos) {
          usarOrdenGuardado = true;
        }
      }

      if (usarOrdenGuardado) {
        debugPrintLevels(9, "Usando Lista Ordenada Guardada");
        listaIdFotosOrden = listaOrdenProvider.rows[0].value.listadefotos;
      } else {
        debugPrintLevels(9, "Usando Lista Cruda (Generando Orden Default)");
        // Generamos una estructura de orden "al vuelo" basada en los IDs crudos
        listaIdFotosOrden = ListaFotosOrdenadas(
          idListaFotos: '',
          idUsuario: idUsuario,
          idPropiedad: idPropiedad,
          fotosOrden: [],
          timestamp: '',
        );

        for (var i = 0; i < listaIdsCrudos.rows.length; i++) {
          listaIdFotosOrden.fotosOrden.add(
            FotosOrden(posicion: i, idFoto: listaIdsCrudos.rows[i].value),
          );
        }
      }
    } catch (e) {
      debugPrintLevels(0, "Error cargando datos: $e");
      numeroDeFotos = 0;
    }
  }

  @override
  void dispose() {
    debugPrintLevels(1, " PaginaCarouselFotosWidget dispose");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrintLevels(9, "* PaginaCarouselFotosWidget build");

    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: FutureBuilder<void>(
        future: _futureCargaDatos,
        builder: (context, snapshot) {
          // ESTADOS DE CARGA Y ERROR
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Text(
                "",
                style: TextStyle(color: appTheme.primary, fontSize: 14),
              ),
            );
          }
          if (snapshot.hasError) {
            return stateErrorFormat(
              widthCuadroFotoPropiedad,
              heightCuadroFotoPropiedad,
              snapshot.error.toString(),
            );
          }

          // CONTENIDO PRINCIPAL
          return SingleChildScrollView(
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                const SizedBox(height: 10),

                // TITULO
                Text(
                  'Fotos de la propiedad: $numeroDeFotos',
                  style: TextStyle(
                    color: appTheme.primary,
                    fontSize: fontSizeSubtituloPagina,
                    fontWeight: FontWeight.bold,
                    fontFamily: "Comfortaa",
                  ),
                ),
                const SizedBox(height: 10),

                // AREA DEL CAROUSEL
                Center(
                  child: SizedBox(
                    height: (screenHeight > screenWidth)
                        ? screenWidth / 1.6
                        : screenHeight * 0.65,
                    width: (screenHeight > screenWidth)
                        ? screenWidth * 1
                        : screenHeight * 1.6,
                    child: (numeroDeFotos == 0)
                        ? _buildBotonAgregarFoto(context)
                        : _buildCarouselSlider(),
                  ),
                ),

                const SizedBox(height: 10),

                // BOTONES DE NAVEGACIÓN
                (numeroDeFotos > 0)
                    ? buildButtons()
                    : const SizedBox(height: 1),

                const SizedBox(height: 30),
              ],
            ),
          );
        },
      ),
    );
  }

  // Widget para el Carousel Slider (Lista Ordenada)
  Widget _buildCarouselSlider() {
    return CarouselSlider.builder(
      carouselController: controllerCarousel,
      itemCount: numeroDeFotos,
      itemBuilder: (BuildContext context, int index, int realIndex) {
        // Obtenemos el ID de la foto basándonos en la lista ordenada
        final String idFotoActual = listaIdFotosOrden.fotosOrden[index].idFoto;
        return _buildFotoItem(idFotoActual, index);
      },
      options: CarouselOptions(
        // Ocupa toda la altura del contenedor padre
        aspectRatio: (screenHeight > screenWidth) ? 16 / 9 : 4 / 3,
        viewportFraction: 1.0, // Una foto a la vez
        initialPage: indiceFotos,
        enableInfiniteScroll:
            false, // Importante para controlar botones next/prev manualmente
        scrollPhysics: const BouncingScrollPhysics(),
        onPageChanged: (index, reason) {
          // Sincronizamos el índice cuando el usuario desliza con el dedo
          setState(() {
            indiceFotos = index;
          });
        },
      ),
    );
  }

  // Widget individual para cada foto (Lazy Loading)
  Widget _buildFotoItem(String idFoto, int index) {
    return GestureDetector(
      onTap: () {
        _navegarAGestionFotos(context, index, idFoto);
      },
      child: FutureBuilder<String>(
        future: recuperaFotoPorIdFoto(idFoto),
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
                "No se encontró foto",
                style: TextStyle(fontSize: 12, color: appTheme.error),
              ),
            );
          }

          return Container(
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              image: DecorationImage(
                image: MemoryImage(base64Decode(snapshot.data!)),
                fit: BoxFit.contain, // Ajuste para ver la foto completa
              ),
            ),
          );
        },
      ),
    );
  }

  // Botón para cuando no hay fotos
  Widget _buildBotonAgregarFoto(BuildContext context) {
    return Container(
      color: appTheme.onSecondary,
      alignment: Alignment.topCenter,
      child: Center(
        child: InkWell(
          onTap: () => _navegarAGestionFotos(context, 0, ""),
          child: Container(
            color: appTheme.surface,
            width: 65,
            height: 65,
            child: Center(
              child: Icon(Symbols.add, size: 60, color: appTheme.primary),
            ),
          ),
        ),
      ),
    );
  }

  // Función helper para navegación
  void _navegarAGestionFotos(BuildContext context, int index, String idFoto) {
    parameterGestionFoto["idUsuario"] = idUsuario;
    parameterGestionFoto["idPropiedad"] = idPropiedad;
    parameterGestionFoto["idFoto"] = idFoto;
    parameterGestionFoto["propiedad"] = widget.valueespaciosparameter;
    parameterGestionFoto["indice"] = index;
    // Si es el índice 0, asumimos que es principal, o según lógica de negocio
    parameterGestionFoto["fotoprincipal"] = (index == 0);

    Navigator.pushNamed(
      context,
      AppRoutes.agregafotopropiedad,
      arguments: parameterGestionFoto,
    );
  }

  // Botones de control y texto indicador
  Widget buildButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // BOTON ATRAS
        ElevatedButton(
          style: ButtonStyle(
            backgroundColor: WidgetStatePropertyAll<Color>(appTheme.primary),
          ),
          child: Icon(Symbols.arrow_back, size: 18, color: appTheme.onPrimary),
          onPressed: () {
            if (numeroDeFotos > 0 && (indiceFotos - 1) >= 0) {
              // Animamos el carrusel. El setState se hace en onPageChanged
              controllerCarousel.animateToPage(
                indiceFotos - 1,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            }
          },
        ),

        // INDICADOR DE TEXTO (Foto X - Total)
        Column(
          children: [
            Text(
              '${indiceFotos + 1} - $numeroDeFotos',
              style: TextStyle(
                color: appTheme.primary,
                fontSize: 12,
                fontWeight: FontWeight.bold,
                fontFamily: "Comfortaa",
              ),
            ),
            if (indiceFotos == 0)
              Text(
                'Foto principal',
                style: TextStyle(
                  color: appTheme.primary,
                  fontSize: 10, // Un poco más pequeño
                  fontWeight: FontWeight.bold,
                  fontFamily: "Comfortaa",
                ),
              ),
          ],
        ),

        // BOTON ADELANTE
        ElevatedButton(
          style: ButtonStyle(
            backgroundColor: WidgetStatePropertyAll<Color>(appTheme.primary),
          ),
          child: Icon(
            Symbols.arrow_forward,
            size: 18,
            color: appTheme.onPrimary,
          ),
          onPressed: () {
            if (numeroDeFotos > 0 && (indiceFotos + 1) < numeroDeFotos) {
              // Animamos el carrusel. El setState se hace en onPageChanged
              controllerCarousel.animateToPage(
                indiceFotos + 1,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            }
          },
        ),
      ],
    );
  }
}

//----------------------------------------------------------------------------
