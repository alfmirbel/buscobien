import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:material_symbols_icons/symbols.dart';
// Importa tus archivos de variables globales y widgets
import '../60_global_widgets/derechos_reservados.dart';
import '../20_var_globales/var_color_themes.dart';
import '../20_var_globales/var_color_widget.dart';
import '00_principales_opciones.dart';

// OPTIMIZADO 23 01 25
// OPTIMIZADO 025 01 25
final codigoPostalBusquedaProvider = StateProvider<int?>((ref) => null);
final warningApp = StateProvider<bool?>((ref) => true);

// -----------------------------------------------------------------------------
// PÁGINA DE INICIO - LANDING PAGE GENERAL
// -----------------------------------------------------------------------------

class PageInicio extends ConsumerStatefulWidget {
  const PageInicio({super.key});

  @override
  ConsumerState createState() => PageInicioState();
}

class PageInicioState extends ConsumerState<PageInicio> {
  // Controlador para efectos de scroll si fuera necesario
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    // Usamos la primera imagen del menú como fondo global, o una imagen genérica de la marca
    final String backgroundImage = menuOpciones.isNotEmpty
        ? menuOpciones[0].imagePath
        : 'assets/images/default_bg.jpg';

    return Scaffold(
      backgroundColor: appTheme.surface,
      body: Container(
        width: screenWidth,
        child: Stack(
          children: [
            // 1. IMAGEN DE FONDO (HERO)
            Positioned.fill(
              child: Image.asset(backgroundImage, fit: BoxFit.cover),
            ),

            // 2. GRADIENTE OSCURO (Para legibilidad)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.black.withValues(
                        alpha: 0.85,
                      ), // Arriba oscuro para texto
                      Colors.black.withValues(
                        alpha: 0.60,
                      ), // Centro semi-transparente
                      Colors.black.withValues(alpha: 0.90), // Abajo oscuro
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ),

            // 3. CONTENIDO SCROLLABLE
            Center(
              child: SafeArea(
                child: ScrollConfiguration(
                  behavior: ScrollConfiguration.of(
                    context,
                  ).copyWith(scrollbars: false),
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 20,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 30),

                        // --- ENCABEZADO ---
                        _buildHeader(
                          "Bienvenido",
                          "Selecciona el perfil que mejor se adapte a tus necesidades",
                        ),

                        const SizedBox(height: 40),

                        // --- GRID DE OPCIONES ---
                        _buildMenuGrid(context),
                        // --- FOOTER SIMPLE (Opcional) ---
                        derechosReservadosClaro(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // WIDGET: Encabezado de Texto
  Widget _buildHeader(String titulo, String subtitulo) {
    return Column(
      children: [
        // Logo o Icono de Marca (Opcional)
        /*
        Icon(
          Symbols.real_estate_agent, 
          size: 60, 
          color: appTheme.onPrimary
        ),
        const SizedBox(height: 20),
        */
        Text(
          titulo,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Outfit',
            color: Colors.white70,
            fontSize: 20, // Tamaño Hero
            fontWeight: FontWeight.w800,
            letterSpacing: 0.5,
            shadows: [
              Shadow(
                offset: Offset(0, 2),
                blurRadius: 4,
                color: Colors.black45,
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Text(
          subtitulo,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Plus Jakarta Sans',
            color: Colors.white, // Color claro sobre fondo oscuro
            fontSize: 28,
            fontWeight: FontWeight.w500,
            //  height: 1.5,
            letterSpacing: -0.8,
          ),
        ),
      ],
    );
  }

  // WIDGET: Grid de Opciones
  Widget _buildMenuGrid(BuildContext context) {
    return Wrap(
      direction: Axis.horizontal,
      spacing: 20.0,
      runSpacing: 25.0,
      alignment: WrapAlignment.center,
      children: List<Widget>.generate(menuOpciones.length, (int index) {
        // Lógica de navegación
        void handleNavigation() {
          if (index < listaLandingPages.length) {
            // Navegación fluida
            Navigator.of(context).push(
              PageRouteBuilder(
                pageBuilder: (c, a1, a2) => listaLandingPages[index],
                transitionsBuilder: (c, anim, a2, child) =>
                    FadeTransition(opacity: anim, child: child),
                transitionDuration: const Duration(milliseconds: 400),
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text("Próximamente disponible."),
                backgroundColor: appTheme.secondary,
              ),
            );
          }
        }

        // Renderizado Responsivo
        if (screenWidth < smallScreenMin) {
          // Versión Móvil
          return customCardServicios(
            icon: menuOpciones[index].icono,
            title: menuOpciones[index].nombreCorto,
            description: menuOpciones[index].descripcion,
            imagePath: menuOpciones[index].imagePath,
            onTap: handleNavigation,
          );
        } else {
          // Versión Desktop/Tablet
          return customCardServicios(
            icon: menuOpciones[index].icono,
            title: menuOpciones[index].nombreCorto,
            description: menuOpciones[index].descripcion,
            imagePath: menuOpciones[index].imagePath,
            onTap: handleNavigation,
          );
        }
      }),
    );
  }

  // ---------------------------------------------------------------------------
  // CARD GRANDE (Estilo Acorde a Landing Pages)
  // ---------------------------------------------------------------------------
  Widget customCardServicios({
    required IconData icon,
    required String title,
    required String description,
    required String imagePath,
    required VoidCallback onTap,
  }) {
    // Aumentamos ligeramente el ancho para mayor presencia
    double cardWidth = widthFicha + 20;

    return _HoverScaleCard(
      onTap: onTap,
      child: Container(
        width: cardWidth,
        decoration: BoxDecoration(
          color: appTheme.surface,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          children: [
            // 1. Header de la Card (Icono + Título)
            Container(
              height: 50, // Altura fija para uniformidad
              //--------------------
              padding: const EdgeInsets.fromLTRB(12, 3, 12, 3),
              decoration: BoxDecoration(
                color: appTheme.surface,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
                border: Border(
                  bottom: BorderSide(
                    color: appTheme.primary.withValues(alpha: 0.1),
                  ),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: appTheme.primary.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Icon(
                      icon,
                      color: appTheme.onPrimaryContainer.withValues(alpha: 0.8),
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      title,
                      style: TextStyle(
                        color: appTheme.onPrimaryContainer.withValues(
                          alpha: 0.8,
                        ),
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Outfit',
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Icon(
                    Symbols.arrow_forward_ios,
                    size: 14,
                    color: appTheme.secondary,
                  ),
                ],
              ),
            ),
            Container(
              color: appTheme.onPrimaryContainer.withValues(alpha: 0.9),
              height: 6,
            ),
            // 2. Cuerpo de la Card (Imagen + Descripción Overlay)
            Stack(
              children: [
                // Imagen
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(12),
                    bottomRight: Radius.circular(12),
                  ),
                  child: Image.asset(
                    imagePath,
                    height: 160,
                    width: cardWidth,
                    fit: BoxFit.cover,
                  ),
                ),
                // Gradiente sobre imagen
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(12),
                        bottomRight: Radius.circular(12),
                      ),
                      gradient: LinearGradient(
                        colors: [
                          //   Colors.transparent,
                          appTheme.onPrimaryContainer.withValues(alpha: 0.7),
                          appTheme.onPrimaryContainer.withValues(alpha: 0.9),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ),
                // Descripción Texto
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      description,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        //height: 1.4,
                        fontWeight: FontWeight.w500,
                        letterSpacing: -0.1,
                      ),
                      maxLines: 5,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // CARD PEQUEÑA (Móvil)
  // ---------------------------------------------------------------------------
  Widget customCardSmallServicios({
    required IconData icon,
    required String title,
    required String description,
    required String imagePath,
    required VoidCallback onTap,
  }) {
    double cardSize = 160.0;

    return _HoverScaleCard(
      onTap: onTap,
      child: Container(
        width: cardSize,
        height: cardSize + 20,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.4),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
          image: DecorationImage(
            image: AssetImage(imagePath),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withValues(alpha: 0.5), // Oscurecer fondo
              BlendMode.darken,
            ),
          ),
        ),
        // Efecto Glassmorphism sutil para el contenido
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              // Gradiente adicional para legibilidad
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.black.withValues(alpha: 0.3),
                        appTheme.primary.withValues(alpha: 0.8),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ),

              // Contenido
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white30, width: 1),
                      ),
                      child: Icon(icon, color: Colors.white, size: 26),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      title,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        shadows: [Shadow(blurRadius: 2, color: Colors.black)],
                      ),
                    ),
                  ],
                ),
              ),

              // Ripple
              Positioned.fill(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(onTap: onTap, splashColor: Colors.white24),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// WIDGET AUXILIAR: ANIMACIÓN HOVER
// -----------------------------------------------------------------------------
class _HoverScaleCard extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;

  const _HoverScaleCard({required this.child, required this.onTap});

  @override
  State<_HoverScaleCard> createState() => _HoverScaleCardState();
}

class _HoverScaleCardState extends State<_HoverScaleCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
      lowerBound: 0.0,
      upperBound: 0.04,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => _controller.forward(),
      onExit: (_) => _controller.reverse(),
      child: GestureDetector(
        onTapDown: (_) => _controller.forward(),
        onTapUp: (_) {
          _controller.reverse();
          widget.onTap();
        },
        onTapCancel: () => _controller.reverse(),
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Transform.scale(
              scale: 1.0 + _controller.value,
              child: widget.child,
            );
          },
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
