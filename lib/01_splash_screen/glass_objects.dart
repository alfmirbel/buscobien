import 'package:flutter/material.dart';
import 'dart:ui';

import '../20_var_globales/var_color_widget.dart';

// Widget para las formas de fondo que dan el efecto borroso
Widget buildBackgroundShapes(BuildContext context) {
  screenWidth = MediaQuery.of(context).size.width;
  screenHeight = MediaQuery.of(context).size.height;
  double factor = 1.0;
  if (screenWidth < smallScreenMin) factor = 0.75;

  return Stack(
    children: [
      // Degradado principal de fondo
      /*
      Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF595E72), //  Colors.deepPurple.shade900,
              Color(0xFF415AA9), // appTheme.primary,
              Color(0xFF415AA9), // appTheme.primary,
              Color(0xFF745470), //   Colors.teal.shade900,
            ],
          ),
        ),
      ),
      */
      Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.deepPurple.shade900,
              Colors.blue.shade900,
              Colors.purple.shade700,
            ],
          ),
        ),
      ),

      // Formas cuadradas redondeadas flotantes para el efecto blur
      Positioned(
        top: 30,
        right: (screenWidth / 2) + 50,
        child: Container(
          width: 150 * factor,
          height: 150 * factor,
          decoration: BoxDecoration(
            color: Colors.cyan.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(40),
            image: DecorationImage(
              image: AssetImage(
                'assets/images/casa_comedor.jpeg',
              ), // Your asset path
              fit: BoxFit.cover, // How the image should be inscribed in the box
              colorFilter: ColorFilter.mode(
                Colors.black.withValues(alpha: 0.3), // Adjust the opacity value
                BlendMode
                    .srcOver, // This blend mode applies the color filter over the image
              ),
            ),
          ),
        ),
      ),

      Positioned(
        bottom: screenHeight / 4,
        right: 60 * (-factor / 2.5),
        child: Container(
          width: 90 * factor,
          height: 90 * factor,
          decoration: BoxDecoration(
            color: Colors.blueAccent.withValues(alpha: 0.4),
            borderRadius: BorderRadius.circular(30),
            image: DecorationImage(
              image: AssetImage(
                'assets/images/casa_estudio2.jpg',
              ), // Your asset path
              fit: BoxFit.cover, // How the image should be inscribed in the box
              colorFilter: ColorFilter.mode(
                Colors.black.withValues(alpha: 0.3), // Adjust the opacity value
                BlendMode
                    .srcOver, // This blend mode applies the color filter over the image
              ),
            ),
          ),
        ),
      ),
      Positioned(
        bottom: 20,
        left: 80,
        child: Container(
          width: 200 * factor,
          height: 100 * factor,
          decoration: BoxDecoration(
            color: Colors.purple.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(60),
            image: DecorationImage(
              image: AssetImage(
                'assets/images/casa_jardin.jpeg',
              ), // Your asset path
              fit: BoxFit.cover, // How the image should be inscribed in the box
              colorFilter: ColorFilter.mode(
                Colors.black.withValues(alpha: 0.3), // Adjust the opacity value
                BlendMode
                    .srcOver, // This blend mode applies the color filter over the image
              ),
            ),
          ),
        ),
      ),
      Positioned(
        bottom: screenHeight / 3,
        left: -20,
        child: Container(
          width: 150 * factor,
          height: 100 * factor,
          decoration: BoxDecoration(
            color: Colors.blueAccent.withValues(alpha: 0.4),
            borderRadius: BorderRadius.circular(30),
            image: DecorationImage(
              image: AssetImage(
                'assets/images/casa_pasillo.jpeg',
              ), // Your asset path
              fit: BoxFit.cover, // How the image should be inscribed in the box
              colorFilter: ColorFilter.mode(
                Colors.black.withValues(alpha: 0.3), // Adjust the opacity value
                BlendMode
                    .srcOver, // This blend mode applies the color filter over the image
              ),
            ),
          ),
        ),
      ),
      // Decoración circular de fondo para notar el desenfoque
      Positioned(
        top: 100,
        right: -50,
        child: Container(
          width: 200 * factor,
          height: 200 * factor,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.blueAccent.withValues(alpha: 0.4),
            image: DecorationImage(
              image: AssetImage(
                'assets/images/casa_panoramica.jpg',
              ), // Your asset path
              fit: BoxFit.cover, // How the image should be inscribed in the box
              colorFilter: ColorFilter.mode(
                Colors.black.withValues(alpha: 0.3), // Adjust the opacity value
                BlendMode
                    .srcOver, // This blend mode applies the color filter over the image
              ),
            ),
          ),
        ),
      ),
    ],
  );
}

//--------------------------------------
// Widget reutilizable para el efecto Glassmorphism
class GlassMorphismContainer2 extends StatelessWidget {
  final double width;
  final double height;
  final Widget child;
  final double borderRadius;
  final double blurStrength;

  const GlassMorphismContainer2({
    super.key,
    required this.width,
    required this.height,
    required this.child,
    this.borderRadius = 25.0,
    this.blurStrength = 15.0,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius), // 25
      child: BackdropFilter(
        // Efecto de desenfoque
        filter: ImageFilter.blur(
          sigmaX: blurStrength, // 25
          sigmaY: blurStrength, // 15
        ),
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: Colors.white30,
            /*
            gradient: const LinearGradient(
              colors: [Colors.white60, Colors.white30],
            ),
            */
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(width: 2, color: Colors.white30),
          ),
          child: child,
        ),
      ),
      // Degradado interno y borde para simular el vidrio
    );
  }
}

// Widget reutilizable para el efecto Glassmorphism
class GlassMorphismContainer extends StatelessWidget {
  final double width;
  final double height;
  final Widget child;
  final double borderRadius;
  final double blurStrength;

  const GlassMorphismContainer({
    super.key,
    required this.width,
    required this.height,
    required this.child,
    this.borderRadius = 16.0,
    this.blurStrength = 15.0,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: SizedBox(
        width: width,
        height: height,
        child: Stack(
          children: [
            // Efecto de desenfoque
            BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: blurStrength,
                sigmaY: blurStrength,
              ),
              child:
                  Container(), // Un contenedor vacío para que el filtro actúe sobre el fondo
            ),
            // Degradado interno y borde para simular el vidrio
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(borderRadius),
                border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white.withValues(alpha: 0.15),
                    Colors.white.withValues(alpha: 0.05),
                  ],
                ),
              ),
            ),
            // Contenido del Glassmorphism Container
            child,
          ],
        ),
      ),
    );
  }
}

//--------------------------------------

// 3. El Widget Componente de Glassmorphism
class GlassBox extends StatelessWidget {
  final double width;
  final double height;
  final Widget child;

  const GlassBox({
    super.key,
    required this.width,
    required this.height,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: SizedBox(
        width: width,
        height: height,
        child: Stack(
          children: [
            // Efecto de desenfoque
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
              child: Container(),
            ),
            // Degradado del borde y opacidad de la caja
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white.withValues(alpha: 0.15),
                    Colors.white.withValues(alpha: 0.05),
                  ],
                ),
              ),
            ),
            // El contenido real
            child,
          ],
        ),
      ),
    );
  }
}
