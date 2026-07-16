import 'dart:async';
import 'package:buscobien/42_sistema_operativo/detecta_os.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../07_routes/app_routes.dart';
//import '../14_geolocalizacion/provider_actual_place.dart';
import '../20_var_globales/var_color_widget.dart';
import '../41_connectivity/connectivitycheck_provider.dart';
//import '../08_pantallas/ubicacion/provider_localidades_del_cp.dart';
import 'glass_objects.dart';
import 'versiones.dart';

/*
El motivo por el cual el SplashScreen tarda más de 3 segundos en pasar a la 
página principal es porque los procesos se están ejecutando de manera secuencial 
(uno tras otro) en lugar de paralela.

El problema actual:

El código inicia un temporizador de 3 segundos (_startSplashTimer).

Espera a que terminen esos 3 segundos.

Recién ahí llama a _attemptNavigation, el cual llama a _initializeLocation.

_initializeLocation realiza tareas pesadas (obtener GPS, llamar API).

Resultado: El tiempo total es 3 segundos + Tiempo de carga de ubicación.

La solución: Debemos iniciar la carga de datos (_initializeLocation) al mismo 
tiempo que corre el temporizador de 3 segundos (en cuanto se detecte internet). 
De esta forma, cuando pasen los 3 segundos, la ubicación ya se habrá cargado 
(o habrá avanzado), haciendo que la transición sea inmediata.
*/

class SplashPage extends ConsumerStatefulWidget {
  final int duration;
  final Widget goToPage;

  const SplashPage(
    int i, {
    super.key,
    required this.duration,
    required this.goToPage,
  });

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage> {
  bool _isNavigating = false;
  bool _minDurationPassed = false;

  // Variable para asegurar que la ubicación solo se pida una vez,
  // aunque ya no esperaremos a que termine.
  //bool _locationRequested = false; PASA A PRINCIPAL

  @override
  void initState() {
    super.initState();
    // 1. Iniciamos el temporizador visual (3 segundos).
    _startSplashTimer();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setCheckPlataformaProvider(ref);

      // Intentamos iniciar la carga de ubicación en segundo plano si hay red,
      // pero NO detenemos el flujo por esto.
      final connectionState = ref.read(checaConeccionesProvider);
      if (connectionState.hasValue &&
          connectionState.value!.etiqueta == "Conectado") {
        //     _triggerLocationUpdate();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _startSplashTimer() async {
    await Future.delayed(Duration(seconds: widget.duration));
    if (mounted) {
      setState(() {
        _minDurationPassed = true;
      });
      // Al terminar el tiempo, intentamos navegar de inmediato.
      _attemptNavigation();
    }
  }

  // Lógica de navegación
  void _attemptNavigation() {
    // Si ya estamos navegando, o falta tiempo, o el widget murió, no hacemos nada.
    if (_isNavigating || !_minDurationPassed || !mounted) return;

    final connectionState = ref.read(checaConeccionesProvider);

    // Si hay conexión, nos vamos.
    if (connectionState.hasValue &&
        connectionState.value!.etiqueta == "Conectado") {
      _isNavigating = true;

      // CAMBIO IMPORTANTE:
      // Aseguramos que se haya disparado la petición de ubicación por si acaso,
      // pero NO usamos 'await'. Dejamos que corra en segundo plano mientras cambiamos de pantalla.
      // PASA A PRINCIPAL _triggerLocationUpdate();

      // Navegamos inmediatamente
      Navigator.pushReplacementNamed(
        context,
        AppRoutes.principal,
        arguments: "",
      );
    } else {
      // Si pasó el tiempo y no hay internet, error.
      if (_minDurationPassed) {
        _navigateToErrorPage();
      }
    }
  }

  void _navigateToErrorPage() {
    if (!mounted) return;
    Navigator.pushNamed(
      context,
      AppRoutes.sinconeccion,
      arguments: "No se detectó conexión a Internet.",
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    screenWidth = size.width;
    screenHeight = size.height;

    ref.listen(checaConeccionesProvider, (previous, next) {
      next.when(
        data: (connection) {
          if (connection.etiqueta == "Conectado") {
            // Si llega internet, disparamos la ubicación en background
            //   _triggerLocationUpdate();
            // E intentamos navegar si el tiempo ya pasó
            _attemptNavigation();
          } else {
            if (_minDurationPassed) {
              _navigateToErrorPage();
            }
          }
        },
        error: (_, __) => _navigateToErrorPage(),
        loading: () {},
      );
    });

    return Scaffold(
      body: Stack(
        children: [
          buildBackgroundShapes(context),
          Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: GlassMorphismContainer2(
                      width: 300 * 0.75,
                      height: 300 * 0.75,
                      borderRadius: 30,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 10),
                          Image.asset(
                            "assets/images/logobuscobientblanco.png",
                            width: 150,
                          ),
                          Image.asset(
                            "assets/images/nombrebuscobientblanco.png",
                            width: 300,
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  _buildText("Bienvenido", isBold: true, size: 18, alpha: 0.9),
                  _buildText("al mejor lugar de", size: 14, alpha: 0.7),
                  _buildText(
                    "Bienes Raíces",
                    isBold: true,
                    size: 18,
                    alpha: 0.7,
                  ),
                  _buildText("para encontrar", size: 14, alpha: 0.7),
                  _buildText(
                    "el espacio que necesitas",
                    isBold: true,
                    size: 14,
                    alpha: 0.7,
                  ),
                  const SizedBox(height: 30),
                  const CircularProgressIndicator(color: Colors.white),
                  const SizedBox(height: 30),
                  _buildText("SITIO DE PRUEBAS Y DEMO", size: 16, alpha: 1),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: _buildText("V.$versionActual", size: 10, alpha: 0.8),
          ),
        ],
      ),
    );
  }

  Widget _buildText(
    String text, {
    bool isBold = false,
    double size = 18,
    double alpha = 1.0,
  }) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(
        color: Colors.white.withValues(alpha: alpha),
        fontSize: size,
        fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }
}

/*
Como se debe modificar el SplashScreen con estos cambios para incorporar 
la versión de conectividad mejorada:

Para integrar la versión mejorada del proveedor de conectividad 
(AsyncNotifierProvider) en tu SplashPage, debemos hacer una refactorización 
clave: eliminar la gestión manual de Streams y pasar a un modelo reactivo usando ref.listen.

Aquí tienes el código modificado. He mantenido tu estructura visual y nombres, 
pero he limpiado la lógica interna para que funcione con el nuevo provider optimizado.

Cambios Clave Realizados:
Eliminación de Streams: Se eliminó _connectivitySubscription y el initState 
complejo. Ahora el provider se encarga de eso.

Uso de ref.listen: En lugar de comprobar manualmente, el widget "escucha" 
cambios en checaConeccionesProvider. Si se detecta internet, intenta navegar. 
Si se va el internet, muestra el diálogo.

Sincronización de Tiempo: La navegación ahora requiere que se cumplan dos 
condiciones: que haya pasado el tiempo del Splash (widget.duration) Y que haya internet.

Dart
*/
