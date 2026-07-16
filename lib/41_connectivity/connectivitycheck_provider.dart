import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../20_var_globales/var_color_themes.dart';
import '../60_global_widgets/debugprint.dart';

// Asumo que estas variables/funciones existen en tu contexto global o importaciones
// ya que pediste no cambiar nombres, las declaro aquí para que el código compile si faltan.
// Si ya las tienes importadas, ignora este bloque dummy.
// -----------------------------------------------------------------------------
// 1. CLASE DE DATOS (Mantenida igual, pero usada de forma inmutable)
// -----------------------------------------------------------------------------

class ElementoDeConeccion {
  int index = 0;
  String etiqueta = "";
  IconData icono = Symbols.wifi_off;
  List<bool> boolEstadoConeccion = [
    false, // mobile
    false, // wifi
    false, // ethernet
    false, // vpn
    false, // bluetooth
    false, // other
    false, // none
  ];
  String estadoDeLaConeccion = "";

  ElementoDeConeccion(
    this.index,
    this.etiqueta,
    this.icono,
    this.boolEstadoConeccion,
    this.estadoDeLaConeccion,
  );
}

// -----------------------------------------------------------------------------
// 2. VARIABLES GLOBALES Y CONSTANTES (Mantenidas)
// -----------------------------------------------------------------------------

List<String> nombreConecciones = [
  "mobile",
  "wifi",
  "ethernet",
  "vpn",
  "bluetooth",
  "otras",
  "ninguna",
  "No se pudo verificar",
];

// Variable global que se actualiza (Side effect mantenido por compatibilidad)
String rutaConectividad = "";

// Datos iniciales simulados para mantener estructura
class ElementoDatos {
  String etiqueta;
  IconData icono;
  ElementoDatos(this.etiqueta, this.icono);
}

List<ElementoDatos> elementosConeccionAInternet = [
  ElementoDatos("Conectado", Symbols.wifi),
  ElementoDatos("Sin conexión", Symbols.wifi_off),
];

// -----------------------------------------------------------------------------
// 3. NUEVO ASYNC NOTIFIER PROVIDER (Optimización)
// -----------------------------------------------------------------------------

// Definición del Notifier
class ChecaConeccionesNotifier extends AsyncNotifier<ElementoDeConeccion> {
  // Método build: Inicializa y escucha cambios
  @override
  Future<ElementoDeConeccion> build() async {
    final connectivity = Connectivity();

    // 1. Suscribirse al stream de cambios para actualización en tiempo real
    final subscription = connectivity.onConnectivityChanged.listen((
      List<ConnectivityResult> results,
    ) {
      // Actualizamos el estado con la nueva lista de resultados
      state = AsyncData(_logicaAsignaConectividad(results));
    });

    // Limpiamos la suscripción cuando el provider se destruye
    ref.onDispose(() => subscription.cancel());

    // 2. Chequeo inicial
    final result = await connectivity.checkConnectivity();
    return _logicaAsignaConectividad(result);
  }

  // Lógica centralizada y convertida para retornar una NUEVA instancia (Inmutabilidad)
  // Reemplaza la función void 'asignaConectividad' anterior que mutaba el estado.
  ElementoDeConeccion _logicaAsignaConectividad(
    List<ConnectivityResult> value,
  ) {
    debugPrintLevels(0, "1. Notifier logic checkConnectivity valor $value");

    // Valores por defecto (Reset)
    int newIndex = 6; // none
    String newEtiqueta = elementosConeccionAInternet[1].etiqueta;
    IconData newIcono = elementosConeccionAInternet[1].icono;
    String newEstadoDescripcion = "Sin conexión.";

    // Nueva lista de boleanos limpia
    List<bool> newBoolEstado = [
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
    ];

    // Lógica del Switch original adaptada
    // Nota: ConnectivityResult ahora devuelve una lista, tomamos el primero o priorizamos
    final resultToCheck = value.isNotEmpty
        ? value.first
        : ConnectivityResult.none;

    switch (resultToCheck) {
      case ConnectivityResult.mobile:
        debugPrintLevels(0, "2. asignaConectividad Mobile");
        newEstadoDescripcion = "Uso de datos moviles.";
        newIndex = 0;
        newEtiqueta = elementosConeccionAInternet[0].etiqueta;
        newIcono = elementosConeccionAInternet[0].icono;
        rutaConectividad = "/principal"; // Side effect global
        newBoolEstado[0] = true;
        break;

      case ConnectivityResult.wifi:
        debugPrintLevels(0, "3. asignaConectividad WiFi");
        newEstadoDescripcion = "Uso de Wi-Fi.";
        newIndex = 1;
        newEtiqueta = elementosConeccionAInternet[0].etiqueta;
        newIcono = elementosConeccionAInternet[0].icono;
        rutaConectividad = "/principal";
        newBoolEstado[1] = true;
        break;

      case ConnectivityResult.ethernet:
        debugPrintLevels(0, "4. asignaConectividad ethernet");
        newEstadoDescripcion = "Uso de red.";
        newIndex = 2;
        newEtiqueta = elementosConeccionAInternet[0].etiqueta;
        newIcono = elementosConeccionAInternet[0].icono;
        rutaConectividad = "/principal";
        newBoolEstado[2] = true;
        break;

      case ConnectivityResult.vpn:
        debugPrintLevels(0, "5. asignaConectividad VPN");
        newEstadoDescripcion = "Uso de VPN.";
        newIndex = 3;
        newEtiqueta = elementosConeccionAInternet[0].etiqueta;
        newIcono = elementosConeccionAInternet[0].icono;
        rutaConectividad = "/principal";
        newBoolEstado[3] = true;
        break;

      case ConnectivityResult.bluetooth:
        debugPrintLevels(0, "6. asignaConectividad Bluetooths");
        newEstadoDescripcion = "Uso de Bluetooth.";
        newIndex = 4;
        newEtiqueta = elementosConeccionAInternet[0].etiqueta;
        newIcono = elementosConeccionAInternet[0].icono;
        rutaConectividad = "/principal";
        newBoolEstado[4] = true;
        break;

      case ConnectivityResult.other:
        debugPrintLevels(0, "7. asignaConectividad Otro");
        newEstadoDescripcion = "Otro tipo de conexión.";
        newIndex = 5;
        newEtiqueta = elementosConeccionAInternet[0].etiqueta;
        newIcono = elementosConeccionAInternet[0].icono;
        rutaConectividad = "/principal";
        newBoolEstado[5] = true;
        break;

      case ConnectivityResult.satellite:
        debugPrintLevels(0, "8. asignaConectividad Satellite");
        newEstadoDescripcion = "Uso de conexión satelital.";
        newIndex = 5;
        newEtiqueta = elementosConeccionAInternet[0].etiqueta;
        newIcono = elementosConeccionAInternet[0].icono;
        rutaConectividad = "/principal";
        newBoolEstado[5] = true;
        break;

      case ConnectivityResult.none:
        debugPrintLevels(0, "9. asignaConectividad Sin conexión");
        newEstadoDescripcion = "Sin conexión.";
        newIndex = 6;
        newEtiqueta = elementosConeccionAInternet[1].etiqueta;
        newIcono = elementosConeccionAInternet[1].icono;
        rutaConectividad = "/sinconeccion";
        newBoolEstado[6] = true;
        break;
    }

    // Retornamos una nueva instancia
    return ElementoDeConeccion(
      newIndex,
      newEtiqueta,
      newIcono,
      newBoolEstado,
      newEstadoDescripcion,
    );
  }
}

// Definición del Provider usando AsyncNotifier
final checaConeccionesProvider =
    AsyncNotifierProvider<ChecaConeccionesNotifier, ElementoDeConeccion>(() {
      return ChecaConeccionesNotifier();
    });

// -----------------------------------------------------------------------------
// 4. FUNCIONES DE AYUDA (Mantenidas por compatibilidad o deprecadas)
// -----------------------------------------------------------------------------

final Connectivity connectivity = Connectivity();

// Esta función ya no es necesaria con AsyncNotifier, pero se mantiene la firma
// para no romper código existente, aunque ahora retorna un Future dummy.
Future<List<ConnectivityResult>> initConnectivity(WidgetRef ref) async {
  // El provider se inicializa solo.
  return [];
}

// Esta función se mantiene pero ya no se debería usar manualmente para mutar estado.
void asignaConectividad(WidgetRef ref, List<ConnectivityResult> value) {
  // Deprecado: El AsyncNotifier maneja esto internamente.
  debugPrintLevels(
    0,
    "asignaConectividad llamada externamente (Ignorada por optimización AsyncNotifier)",
  );
}

Future<void> updateConnectionStatus(List<ConnectivityResult> result) async {
  if (result.contains(ConnectivityResult.mobile)) {
    // Mobile network available.
  } else if (result.contains(ConnectivityResult.wifi)) {
    // Wi-fi is available.
    // Note for Android:
    // When both mobile and Wi-Fi are turned on system will return Wi-Fi only as active network type
  } else if (result.contains(ConnectivityResult.ethernet)) {
    // Ethernet connection available.
  } else if (result.contains(ConnectivityResult.vpn)) {
    // Vpn connection active.
    // Note for iOS and macOS:
    // There is no separate network interface type for [vpn].
    // It returns [other] on any device (also simulator)
  } else if (result.contains(ConnectivityResult.bluetooth)) {
    // Bluetooth connection available.
  } else if (result.contains(ConnectivityResult.other)) {
    // Connected to a network which is not in the above mentioned networks.
  } else if (result.contains(ConnectivityResult.none)) {
    // No available network types
  }
  // //debugPrintLevels(0, 'Connectivity detected: $result');
}

// -----------------------------------------------------------------------------
// 5. WIDGET UI (Actualizado para usar AsyncValue)
// -----------------------------------------------------------------------------

class PaginaChecaInternet extends ConsumerStatefulWidget {
  final Map<String, dynamic> parametros;
  const PaginaChecaInternet(this.parametros, {super.key});

  @override
  ConsumerState<PaginaChecaInternet> createState() {
    debugPrintLevels(0, "1. PaginaChecaInternet createState");
    return PaginaChecaInternetState();
  }
}

class PaginaChecaInternetState extends ConsumerState<PaginaChecaInternet> {
  @override
  void initState() {
    super.initState();
    debugPrintLevels(0, "2. PaginaChecaInternet initState");
    // Ya no es necesario llamar a initConnectivity aquí,
    // el 'ref.watch' en el build iniciará el provider automáticamente.
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrintLevels(0, "3. PaginaChecaInternet build");

    // Observamos el provider asíncrono
    final asyncConnectivityState = ref.watch(checaConeccionesProvider);

    return Scaffold(
      backgroundColor: appTheme.surface,
      appBar: AppBar(
        toolbarHeight: 40.0,
        centerTitle: true,
        titleSpacing: 0,
        backgroundColor: appTheme.error,
        automaticallyImplyLeading: false,
        title: Text(
          'conexión',
          style: TextStyle(
            color: appTheme.onError,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        elevation: 4,
      ),
      body: Center(
        child: asyncConnectivityState.when(
          // ESTADO: CARGANDO
          loading: () => const CircularProgressIndicator(),

          // ESTADO: ERROR
          error: (err, stack) => Text('Error: $err'),

          // ESTADO: DATOS LISTOS
          data: (elementoConeccion) {
            return SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Estado de las conecciones',
                    style: TextStyle(
                      color: appTheme.error,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(3),
                      color: appTheme.surface,
                    width: 300,
                    child: ListView(
                      shrinkWrap: true,
                      // Usamos la longitud de la lista dentro del objeto data
                      children: List.generate(
                        elementoConeccion.boolEstadoConeccion.length - 1,
                        (index) => Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Text(
                                nombreConecciones[index],
                                style: TextStyle(
                                  color: appTheme.error,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 14,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              flex: 1,
                              child: Text(
                                // Leemos directamente del objeto inmutable
                                (elementoConeccion.boolEstadoConeccion[index])
                                    ? "Activada"
                                    : "Desctivada",
                                style: TextStyle(
                                  color: appTheme.error,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 14,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  SizedBox(
                    width: 200,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(3),
                        backgroundColor: appTheme.error,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      child: Text(
                        'Regresar',
                        style: TextStyle(
                          color: appTheme.onError,
                          fontSize: 12,
                          fontFamily: "Comfortaa",
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                  // Mostrar descripción extra si es necesario
                  const SizedBox(height: 10),
                  Text(elementoConeccion.estadoDeLaConeccion),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
