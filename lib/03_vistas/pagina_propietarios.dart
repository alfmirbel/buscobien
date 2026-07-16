import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../01_home/home_navigation_provider.dart';
import '../02_principal_screen/00_principales_opciones.dart';
import '../05_provider_menus/provider_menu_inicial.dart';
import '../05_provider_menus/provider_menu_principal.dart';
import '../05_provider_menus/provider_menu_tipo_espacio.dart';
import '../05_provider_menus/provider_menu_tu_cuenta.dart';
import '../05_provider_menus/variables_menus.dart';
import '../07_routes/app_routes.dart';
import '../20_var_globales/var_color_themes.dart';

class LandingPropietariosPage extends ConsumerWidget {
  const LandingPropietariosPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Colores corporativos (Mismos tonos para consistencia)
    final primaryColor = const Color(0xFF1E3A8A); // Azul oscuro
    final secondaryColor = const Color(0xFF3B82F6); // Azul más claro
    final ctaColor = const Color(
      0xFFEF4444,
    ); // Rojo/Naranja para urgencia (Call to Action)

    return Scaffold(
      backgroundColor: appTheme.onPrimary,
      appBar: AppBar(
        backgroundColor: appTheme.primary,
        centerTitle: false,
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
            const SizedBox(width: 10),
            Icon(menuOpciones[2].icono),
            const SizedBox(width: 10),
            Text(
              "Propietarios",
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
            onPressed: () {
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
            child: Text(
              "Acceder",
              style: TextStyle(color: appTheme.onPrimary, fontSize: 14),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 1. HERO SECTION: Enfoque en el beneficio principal
            _buildHeroSection(context, ref, primaryColor, ctaColor),

            // 2. SOCIAL PROOF (Estadísticas rápidas)
            _buildStatsBar(primaryColor),

            const SizedBox(height: 40),

            // 3. BENEFICIOS PRINCIPALES (Grid)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  Text(
                    "¿Por qué publicar con nosotros?",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Diseñado para dueños, no solo para agentes.",
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 30),
                  _buildBeneficiosGrid(secondaryColor),
                ],
              ),
            ),

            const SizedBox(height: 50),

            // 4. PASO A PASO (Cómo funciona)
            Container(
              color: Colors.grey[50],
              padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
              child: Column(
                children: [
                  Text(
                    "Es más fácil de lo que crees",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                  const SizedBox(height: 30),
                  _buildPaso(
                    1,
                    "Crea tu cuenta gratis",
                    "Solo necesitas tu correo y teléfono.",
                    Symbols.person_add_alt,
                  ),
                  _buildLineaConectora(),
                  _buildPaso(
                    2,
                    "Sube tus fotos",
                    "Toma fotos con tu celular y súbelas al instante.",
                    Symbols.add_a_photo,
                  ),
                  _buildLineaConectora(),
                  _buildPaso(
                    3,
                    "Recibe interesados",
                    "Habla directamente con compradores potenciales.",
                    Symbols.chat_bubble_outline,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // 5. TESTIMONIO
            _buildTestimonio(),

            const SizedBox(height: 40),

            // 6. FINAL CTA
            _buildFinalCTA(primaryColor, ctaColor),

            const SizedBox(height: 30),
            Center(
              child: Text(
                "© 2026 Buscobien. Todos los derechos reservados.",
                style: TextStyle(color: appTheme.primary, fontSize: 12),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // --- WIDGETS DE LA PÁGINA ---

  Widget _buildHeroSection(
    BuildContext context,
    WidgetRef ref,
    Color primary,
    Color cta,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
      decoration: BoxDecoration(
        color: appTheme.secondary,
        image: DecorationImage(
          image: AssetImage(menuOpciones[2].imagePath),
          /*
          image: const NetworkImage(
            "https://images.unsplash.com/photo-1560518883-ce09059eeffa?ixlib=rb-1.2.1&auto=format&fit=crop&w=1000&q=80",
          ),
          */
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            appTheme.secondary.withValues(alpha: 0.85),
            BlendMode.darken,
          ),
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: appTheme.secondary,
              border: Border.all(color: appTheme.inversePrimary),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              "Sin intermediarios obligatorios",
              style: TextStyle(
                color: appTheme.onSecondary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            "Vende o Renta tu Propiedad\nTú Mismo",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 36,
              fontWeight: FontWeight.w800,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 15),
          const Text(
            "Toma el control total de tu anuncio. Ahorra en comisiones y conecta directo con miles de interesados.",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white70, fontSize: 18),
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: () {
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
            style: ElevatedButton.styleFrom(
              backgroundColor: cta,
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 18),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              elevation: 5,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Text(
                  "Publicar Gratis Ahora",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                //   SizedBox(width: 10),
                //   Icon(Symbols.arrow_forward, color: Colors.white),
              ],
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            "No requiere tarjeta de crédito",
            style: TextStyle(color: Colors.white54, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsBar(Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _statItem("+50k", "Compradores", color),
          _statItem("100%", "Control Tuyo", color),
          _statItem("24/7", "Visibilidad", color),
        ],
      ),
    );
  }

  Widget _statItem(String numero, String label, Color color) {
    return Column(
      children: [
        Text(
          numero,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }

  Widget _buildBeneficiosGrid(Color accent) {
    return Column(
      children: [
        // Usamos una columna de Cards para asegurar legibilidad en móviles
        _beneficioCard(
          icon: Symbols.savings,
          titulo: "Ahorra Comisiones",
          desc:
              "Olvídate de pagar el 5% o 6% de comisión. Publicar aquí tiene un costo fijo o gratuito.",
          color: accent,
        ),
        const SizedBox(height: 15),
        _beneficioCard(
          icon: Symbols.dashboard_customize,
          titulo: "Panel de Control",
          desc:
              "Edita el precio, cambia las fotos y actualiza la descripción cuando tú quieras.",
          color: accent,
        ),

        const SizedBox(height: 15),
        _beneficioCard(
          icon: Symbols.real_estate_agent,
          titulo: "Busca Promotores",
          desc: "Si prefieres, busca un promotor en tu zona.",
          color: accent,
        ),
        const SizedBox(height: 15),
        _beneficioCard(
          icon: Symbols.security,
          titulo: "Seguridad de Datos",
          desc:
              "Tus datos de contacto están protegidos. Tú decides cuándo compartirlos.",
          color: accent,
        ),
      ],
    );
  }

  Widget _beneficioCard({
    required IconData icon,
    required String titulo,
    required String desc,
    required Color color,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 30),
            ),
            const SizedBox(width: 15),
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
                    style: TextStyle(color: Colors.grey[600], height: 1.4),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaso(int numero, String titulo, String desc, IconData icon) {
    return Row(
      children: [
        Container(
          width: 50,
          height: 50,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey.shade300),
            shape: BoxShape.circle,
          ),
          child: Text(
            "$numero",
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon, size: 20, color: Colors.blueGrey),
                  const SizedBox(width: 8),
                  Text(
                    titulo,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(desc, style: const TextStyle(color: Colors.grey)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLineaConectora() {
    return Container(
      margin: const EdgeInsets.only(left: 24, top: 5, bottom: 5),
      height: 30,
      width: 2,
      color: Colors.grey.shade300,
    );
  }

  Widget _buildTestimonio() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF7ED), // Fondo naranja muy suave
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: const [
          Icon(Symbols.format_quote, size: 40, color: Colors.orange),
          SizedBox(height: 10),
          Text(
            "Al principio dudaba si podría hacerlo sola, pero la app me guió paso a paso. Vendí mi departamento en 3 semanas y el trato fue directo.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
          ),
          SizedBox(height: 20),
          Text(
            "- Laura G., Propietaria en CDMX",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildFinalCTA(Color primary, Color cta) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(40),
      color: primary,
      child: Column(
        children: [
          const Text(
            "No dejes que tu propiedad espere",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            "Únete a miles de propietarios que tomaron el control.",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white70),
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: Text(
              "Comenzar a Publicar",
              style: TextStyle(
                fontSize: 16,
                color: primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
