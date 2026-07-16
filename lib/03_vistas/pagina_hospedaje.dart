import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';

// Imports de tu arquitectura
import '../01_home/home_navigation_provider.dart';
import '../02_principal_screen/00_principales_opciones.dart';
import '../05_provider_menus/provider_menu_inicial.dart';
import '../05_provider_menus/provider_menu_principal.dart';
import '../05_provider_menus/provider_menu_tipo_espacio.dart';
import '../05_provider_menus/provider_menu_tu_cuenta.dart';
import '../05_provider_menus/variables_menus.dart';
import '../07_routes/app_routes.dart';
import '../60_global_widgets/derechos_reservados.dart';
import '../20_var_globales/var_color_themes.dart';

class LandingHospedajePage extends ConsumerWidget {
  const LandingHospedajePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Colores específicos para esta landing (Azul confianza y Naranja/Dorado dinero)
    final primaryColor = const Color(0xFF1E3A8A);
    final accentColor = const Color(0xFFF59E0B);

    return Scaffold(
      backgroundColor: appTheme.surface,
      // --- APP BAR (Consistente con las otras páginas) ---
      appBar: AppBar(
        backgroundColor: appTheme.primary,
        centerTitle: true,
        titleSpacing: 0,
        iconTheme: IconThemeData(size: 22, color: appTheme.onPrimary),
        elevation: 0,
        toolbarHeight: menuToolbarHeight,
        automaticallyImplyLeading: false,
        leading: (ref.watch(homeNavigationProvider).indiceInicial != 0)
            ? null
            : IconButton(
                icon: const Icon(Symbols.arrow_back, size: 18),
                tooltip: 'Regresar', // Your custom tooltip message
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
        title: Row(
          children: [
            // Usamos el icono de "Propietarios" o "Casa"
            const SizedBox(width: 5),
            Icon(menuOpciones[3].icono),
            const SizedBox(width: 10),
            Text(
              "Anfitriones",
              style: TextStyle(
                color: appTheme.onPrimary,
                fontSize: 12,
                letterSpacing: 0.5,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () async {
              //--------------
              ref
                  .read(menuInicialProvider.notifier)
                  .asignaNuevaOpcionSeleccionada(ref, 1);
              ref.read(homeNavigationProvider.notifier).actualizarInicial(1);
              ref
                  //--------------
                  .read(menuPrincipalProvider.notifier)
                  .asignaNuevaOpcionSeleccionada(ref, 5);
              ref.read(homeNavigationProvider.notifier).actualizarPrincipal(5);
              //--------------
              ref
                  .read(menuTuCuentaProvider.notifier)
                  .asignaNuevaOpcionSeleccionada(ref, 0);
              ref.read(homeNavigationProvider.notifier).actualizarMiCuenta(0);
              //--------------
              ref
                  .read(menuTipoEspaciosProvider.notifier)
                  .asignaNuevaOpcionSeleccionada(ref, 0);
              ref
                  .read(homeNavigationProvider.notifier)
                  .actualizarTipoEspacio(0);

              Navigator.pushReplacementNamed(
                context,
                AppRoutes.principal,
                arguments: "",
              );
            },
            child: Text("Inicia", style: TextStyle(color: appTheme.onPrimary)),
          ),
          const SizedBox(width: 10),
        ],
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            // 1. HERO SECTION (Imagen impactante + CTA Principal)
            _buildHeroSection(context, ref, accentColor),

            // 2. BENEFICIOS CLAVE (Seguridad, Pagos, Flexibilidad)
            _buildBeneficiosSection(),

            // 3. CÓMO FUNCIONA (Pasos 1, 2, 3)
            _buildComoFuncionaSection(primaryColor),

            // 4. BANNER DE INGRESOS (Motivacional)
            //_buildBannerIngresos(context, ref, accentColor),

            // 5. FOOTER
            _buildFooter(context, ref, primaryColor),

            derechosReservadosObscuro(),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // LOGICA DE NAVEGACIÓN A "PUBLICAR"
  // ---------------------------------------------------------------------------
  void _irAPublicar(WidgetRef ref, BuildContext context) {
    // 1. Cambiamos al flujo de la App Principal
    //--------------
    ref
        .read(menuInicialProvider.notifier)
        .asignaNuevaOpcionSeleccionada(ref, 1);
    ref.read(homeNavigationProvider.notifier).actualizarInicial(1);
    ref
        //--------------
        .read(menuPrincipalProvider.notifier)
        .asignaNuevaOpcionSeleccionada(ref, 5);
    ref.read(homeNavigationProvider.notifier).actualizarPrincipal(5);
    //--------------
    ref
        .read(menuTuCuentaProvider.notifier)
        .asignaNuevaOpcionSeleccionada(ref, 0);
    ref.read(homeNavigationProvider.notifier).actualizarMiCuenta(0);
    //--------------
    ref
        .read(menuTipoEspaciosProvider.notifier)
        .asignaNuevaOpcionSeleccionada(ref, 0);
    ref.read(homeNavigationProvider.notifier).actualizarTipoEspacio(0);
    // 4. Navegamos
    Navigator.pushReplacementNamed(context, AppRoutes.principal, arguments: "");
  }

  // ---------------------------------------------------------------------------
  // 1. HERO SECTION
  // ---------------------------------------------------------------------------
  Widget _buildHeroSection(
    BuildContext context,
    WidgetRef ref,
    Color accentColor,
  ) {
    return Stack(
      children: [
        // Imagen de Fondo (Interior acogedor)
        Container(
          height: 500,
          width: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(menuOpciones[3].imagePath),
              /*
              // Usa una imagen de tus assets o una URL de ejemplo
              image: NetworkImage(
                'https://images.unsplash.com/photo-1556912172-45b7abe8b7e1?auto=format&fit=crop&w=1350&q=80',
              ),
              */
              fit: BoxFit.cover,
            ),
          ),
        ),
        // Gradiente Oscuro
        Container(
          height: 500,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.black.withValues(alpha: 0.8),
                Colors.black.withValues(alpha: 0.4),
                Colors.black.withValues(alpha: 0.8),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        // Texto y CTA
        Positioned.fill(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: accentColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    "RENTA POR DÍAS O SEMANAS",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                Text(
                  "Convierte tu espacio\nen ingresos extras",
                  style: TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 42,
                    height: 1.1,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    shadows: [Shadow(blurRadius: 10, color: Colors.black)],
                  ),
                ),
                const SizedBox(height: 15),
                const Text(
                  "Publica tu casa o departamento de forma segura y llega a miles de viajeros buscando un lugar como el tuyo.",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white70,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 35),
                ElevatedButton(
                  onPressed: () => _irAPublicar(ref, context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: accentColor,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 20,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 5,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Symbols.add_home, color: Colors.white),
                      const SizedBox(width: 10),
                      const Text(
                        "Publicar mi Propiedad",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // 2. BENEFICIOS
  // ---------------------------------------------------------------------------
  Widget _buildBeneficiosSection() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 20),
      color: appTheme.surface,
      child: Column(
        children: [
          Text(
            "¿Por qué ser anfitrión en buscobien?",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: appTheme.primary,
            ),
          ),
          const SizedBox(height: 40),
          Wrap(
            spacing: 30,
            runSpacing: 30,
            alignment: WrapAlignment.center,
            children: [
              _beneficioCard(
                Symbols.verified_user,
                "Huéspedes Verificados",
                "Seguridad primero. Valida la identidad de quienes reservan.",
              ),
              _beneficioCard(
                Symbols.calendar_month,
                "Control Total",
                "Decide las fechas, los precios y las reglas de tu casa.",
              ),
              _beneficioCard(
                Symbols.monetization_on,
                "Pagos Seguros",
                "Recibe tu dinero puntualmente vía transferencia bancaria.",
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _beneficioCard(IconData icon, String titulo, String desc) {
    return SizedBox(
      width: 300,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: appTheme.primary.withValues(alpha: 0.05),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 40, color: appTheme.primary),
          ),
          const SizedBox(height: 20),
          Text(
            titulo,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: appTheme.onSurface,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            desc,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: appTheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // 3. CÓMO FUNCIONA
  // ---------------------------------------------------------------------------
  Widget _buildComoFuncionaSection(Color primaryColor) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 20),
      color: primaryColor.withValues(alpha: 0.03), // Fondo sutil
      child: Column(
        children: [
          const Text(
            "Es muy fácil empezar",
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 40),
          // Pasos
          _pasoRow(
            "1",
            "Publica tu anuncio",
            "Sube fotos, describe tu espacio y establece tu precio.",
          ),
          _pasoRow(
            "2",
            "Recibe reservaciones",
            "Acepta solicitudes y comunícate con tus huéspedes.",
          ),
          _pasoRow(
            "3",
            "Recibe a tus huéspedes",
            "Entrega las llaves y bríndales una gran experiencia.",
          ),
          _pasoRow(
            "4",
            "Recibe tu pago",
            "Transferimos tus ganancias automáticamente.",
          ),
        ],
      ),
    );
  }

  Widget _pasoRow(String numero, String titulo, String desc) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 30),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: appTheme.primary,
              shape: BoxShape.circle,
            ),
            child: Text(
              numero,
              style: TextStyle(
                color: appTheme.onPrimary,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titulo,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  desc,
                  style: TextStyle(
                    fontSize: 15,
                    color: appTheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // 4. BANNER INGRESOS
  // ---------------------------------------------------------------------------
  /*
  Widget _buildBannerIngresos(
    BuildContext context,
    WidgetRef ref,
    Color accent,
  ) {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        image: DecorationImage(
          image: NetworkImage(
            "https://images.unsplash.com/photo-1560518883-ce09059eeffa?auto=format&fit=crop&w=1000&q=80",
          ),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            appTheme.primary.withValues(alpha: 0.85),
            BlendMode.srcOver,
          ),
        ),
      ),
      child: Column(
        children: [
          const Icon(Symbols.savings, color: Colors.white, size: 50),
          const SizedBox(height: 20),
          const Text(
            "¿Cuánto podrías ganar?",
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            "Descubre el potencial de tu propiedad con nuestra calculadora de ingresos.",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white70, fontSize: 16),
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: () => _irAPublicar(ref, context),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: appTheme.primary,
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: const Text(
              "Calcular Ingresos",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
  */
  // ---------------------------------------------------------------------------
  // 5. FOOTER
  // ---------------------------------------------------------------------------
  Widget _buildFooter(BuildContext context, WidgetRef ref, Color primary) {
    return Container(
      width: double.infinity,
      color: primary,
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      child: Column(
        children: [
          Text(
            "Únete a la comunidad de anfitriones",
            style: TextStyle(
              color: appTheme.onPrimary,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          OutlinedButton(
            onPressed: () => _irAPublicar(ref, context),
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: appTheme.onPrimary),
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              "Empezar Ahora",
              style: TextStyle(
                color: appTheme.onPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
