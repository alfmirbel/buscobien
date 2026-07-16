import 'package:buscobien/14_geolocalizacion/provider_actual_place.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../02_principal_screen/principal_00_inicio.dart';
import '../../07_routes/app_routes.dart';
import '../../20_var_globales/var_color_themes.dart';
import 'provider_localidades_del_cp.dart';
import '../../60_global_widgets/debugprint.dart';
import '../../60_global_widgets/bottom_fijo.dart';

//-----------------------------------------------------------------------------

//-----------------------------------------------------------------------------
// ruta: '/buscalocalidad'
// Asumiendo que MyButton, debugPrintLevels, appTheme, widthFicha, etc.
//existen en tu contexto global.

class PaginaBuscaLocalidadGMaps extends ConsumerStatefulWidget {
  const PaginaBuscaLocalidadGMaps({super.key});

  @override
  // ignore: no_logic_in_create_state
  ConsumerState createState() {
    debugPrintLevels(1, " **************************************************");
    debugPrintLevels(1, " 1. PaginaBuscaLocalidadGMaps createState");
    debugPrintLevels(1, " **************************************************");
    return PaginaBuscaLocalidadGMapsState();
  }
}

class PaginaBuscaLocalidadGMapsState
    extends ConsumerState<PaginaBuscaLocalidadGMaps> {
  // Variables de estado local
  int valorActualProvider = 0;
  String localidad = "Aguas";
  final GlobalKey<FormState> _formKeyBuscaUbicacion = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    debugPrintLevels(1, " **************************************************");
    debugPrintLevels(1, " 1. PaginaBuscaLocalidadGMaps initState");
    debugPrintLevels(1, " **************************************************");

    // Inicializamos cp con el valor actual del provider (una sola vez)
    // Dentro de un ConsumerWidget o ConsumerState
    // cp será un int? (puede ser null)

    if (ref.read(codigoPostalBusquedaProvider) == null) {
      valorActualProvider = ref
          .read(localidadesPorCodigoPostalProvider)
          .codigoPostal;
    } else {
      valorActualProvider = ref.read(codigoPostalBusquedaProvider)!.toInt();
    }
  }

  //-----------------------------------------------------------------------------
  @override
  void didChangeDependencies() {
    debugPrintLevels(1, " PaginaBuscaLocalidadGMaps didChangeDependencies");
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(covariant PaginaBuscaLocalidadGMaps oldWidget) {
    debugPrintLevels(1, " PaginaBuscaLocalidadGMaps didUpdateWidget");
    super.didUpdateWidget(oldWidget);
  }

  @override
  void deactivate() {
    debugPrintLevels(1, " PaginaBuscaLocalidadGMaps deactivate");
    super.deactivate();
  }

  @override
  void dispose() {
    debugPrintLevels(1, " PaginaBuscaLocalidadGMaps dispose");
    ref.read(ubicacionActualProvider.notifier).disposeMapController();
    super.dispose();
  }
  //-----------------------------------------------------------------------------

  Widget buildCP() {
    // Optimización: Obtenemos el valor para mostrar, pero no asignamos a la variable
    // global 'cp' aquí para evitar efectos secundarios durante el renderizado.

    if (ref.read(codigoPostalBusquedaProvider) == null) {
      valorActualProvider = ref
          .read(localidadesPorCodigoPostalProvider.notifier)
          .getCodigoPostal();
    } else {
      valorActualProvider = ref.read(codigoPostalBusquedaProvider)!.toInt();
    }

    debugPrintLevels(0, "buildCP provider value: $valorActualProvider");

    // CORRECCIÓN CRÍTICA: El TextFormField debe estar dentro de un Form
    // para que la key y el método save() funcionen.
    return Form(
      key: _formKeyBuscaUbicacion,
      child: Center(
        child: SizedBox(
          width: widthFicha,
          child: TextFormField(
            // Usamos el valor del provider como inicial si cp es 0, o el local
            initialValue: valorActualProvider == 0
                ? null
                : valorActualProvider.toString(),
            keyboardType: TextInputType.number, // Recomendado para CPs
            decoration: InputDecoration(
              labelText: 'Código Postal',
              labelStyle: TextStyle(
                color: appTheme.primary,
                fontSize: 12,
                fontWeight: FontWeight.bold,
                fontFamily: "Comfortaa",
              ),
              hintStyle: TextStyle(
                color: appTheme.primary,
                fontSize: 12,
                fontWeight: FontWeight.bold,
                fontFamily: "Comfortaa",
              ),
            ),
            style: TextStyle(
              color: appTheme.primary,
              fontSize: 12,
              fontWeight: FontWeight.bold,
              fontFamily: "Comfortaa",
            ),
            minLines: 1,
            maxLines: 1,
            maxLength: 5,
            validator: (String? value) {
              if ((value == null || value.isEmpty)) {
                return 'Proporciona un código postal';
              }
              return null;
            },
            onSaved: (String? value) {
              if (value != null) {
                valorActualProvider = int.tryParse(value) ?? 0;
                debugPrintLevels(0, "buildCP onSaved: $valorActualProvider");
              }
            },
            onChanged: (String? value) {
              // Opcional: Actualizar localmente si se desea reactividad inmediata
              // cp = int.tryParse(value!) ?? 0;
            },
          ),
        ),
      ),
    );
  }
  //------------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    debugPrintLevels(0, "4. PaginaBuscaLocalidadGMaps build");

    // Optimización: Usamos 'watch' para que la UI se actualice si cambia la ubicación
    // Esto es vital para que el texto de latitud/longitud cambie.
    final ubicacionActual = ref.watch(ubicacionActualProvider);

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 40.0,
        centerTitle: true,
        titleSpacing: 0,
        backgroundColor: appTheme.primary,
        iconTheme: IconThemeData(size: 14, color: appTheme.onPrimary),
        title: Text(
          "Busca ubicación por Código Postal",
          style: TextStyle(
            color: appTheme.onPrimary,
            fontWeight: FontWeight.normal,
            fontSize: 14,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Container(margin: const EdgeInsets.all(6), child: buildCP()),
            const SizedBox(height: 5),

            // Ahora este texto se actualizará automáticamente gracias a ref.watch
            MyButton(
              etiqueta: "Busca ubicaciones",
              onTap: () {
                // 1. Validar y guardar el formulario
                if (_formKeyBuscaUbicacion.currentState?.validate() ?? false) {
                  _formKeyBuscaUbicacion.currentState?.save();

                  debugPrintLevels(
                    0,
                    "fetchLocaliadesCodigoPostal Guardado CP: $valorActualProvider",
                  );

                  // 2. Actualizar el estado del provider
                  ref
                      .read(localidadesPorCodigoPostalProvider.notifier)
                      .setCodigoPostal(valorActualProvider);

                  // 3. Refrescar el servicio
                  // ignore: unused_result
                  ref.refresh(getLocalidadesDelCPFutureProvider);

                  // 4. Navegar
                  Navigator.pushNamed(
                    context,
                    AppRoutes.listalocalidades,
                    arguments: valorActualProvider,
                  );
                }
              },
            ),
            const SizedBox(height: 10),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  width: 500,
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                  alignment: Alignment.center,
                  //height: 40,
                  child: Text(
                    "Ubicación actual: ${ubicacionActual.addressGM}",
                    maxLines: 2,
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  width: 500,
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                  alignment: Alignment.center,
                  //height: 40,
                  child: Text(
                    'Latitud: ${ubicacionActual.latitud}, Longitud: ${ubicacionActual.longitud}',
                    maxLines: 2,
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  height: 300,
                  width: 300,
                  padding: const EdgeInsets.all(
                    3,
                  ), // Espacio entre el contenido y el borde
                  decoration: BoxDecoration(
                    color: appTheme.onPrimary, // Color de fondo del contenedor
                    border: Border.all(
                      color: appTheme.primary, // Color del borde
                      width: 1.5, // Grosor del borde
                    ),
                    borderRadius: BorderRadius.circular(
                      5,
                    ), // Opcional: Bordes redondeados
                  ),
                  child: GoogleMap(
                    onMapCreated: (mapController) {
                      ref.read(ubicacionActualProvider.notifier).onMapCreated(mapController);
                    },
                    initialCameraPosition: ubicacionActual.posicionCamara,
                    markers: ubicacionActual.marcadores,
                    mapType: MapType.normal,
                    myLocationEnabled: true,
                    compassEnabled: true,
                  ),
                  /*GoogleMap(
                    onMapCreated: (GoogleMapController controller) {
                      // Asignamos el controlador.
                      // NOTA: Asegúrate de que 'ubicacionActualProvider' no sea null.
                      mapController = controller;
                      ref.read(ubicacionActualProvider).mapController =
                          controller;
                      // Opcional: Completa el controlador si usas un Completer en tu lógica
                      // if (!_controller.isCompleted) _controller.complete(controller);
                    },
                    initialCameraPosition: ubicacionActual.posicionCamara,
                    markers: ubicacionActual.marcadores,
                    mapType: MapType.normal,

                    // Configuraciones de UI
                    myLocationEnabled:
                        true, // Muestra el punto azul (requiere permisos)
                    myLocationButtonEnabled:
                        true, // Botón para centrar en mi ubicación
                    compassEnabled: true, // Brújula
                    zoomControlsEnabled:
                        true, // Botones +/- (útil en Web/Android)
                    mapToolbarEnabled:
                        true, // Barra de herramientas al tocar un marcador
                  ),
                  */
                  /*
                 
                  */
                ),
              ],
            ),
            const SizedBox(
              height: 30,
            ), // Espacio extra antes del botón inferior
            /*
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(3),
                backgroundColor: appTheme.surface,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: Text(
                'Actualizar',
                style: TextStyle(
                  color: appTheme.primary,
                  fontSize: 12,
                  fontFamily: "Comfortaa",
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                // setState redibujará el widget obteniendo los valores frescos del watch
                setState(() {
                  debugPrintLevels(
                    0,
                    "-- 5. PaginaBuscaLocalidadGMaps setState manual",
                  );
                });
              },
            ),
            */
          ],
        ),
      ),
    );
  }
}

