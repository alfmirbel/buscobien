import 'package:buscobien/05_provider_menus/provider_menu_tipo_espacio.dart';
import 'package:buscobien/05_provider_menus/provider_menu_tu_cuenta.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../01_home/home_navigation_provider.dart';
import '../02_principal_screen/00_principales_opciones.dart';
import '../05_provider_menus/provider_menu_inicial.dart';
import '../05_provider_menus/provider_menu_principal.dart';
import '../05_provider_menus/provider_menu_tipo_de_transaccion.dart';
import '../05_provider_menus/variables_menus.dart';
import '../07_routes/app_routes.dart';
import '../10_user_login/usuario_login/dialogbox_login.dart';
import '../20_var_globales/var_color_themes.dart';
import '../20_var_globales/var_color_widget.dart';

class LandingAgentesPage extends ConsumerWidget {
  const LandingAgentesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Paleta de colores "Premium/Business"
    final darkNavy = const Color(0xFF0F172A); // Fondo oscuro profesional
    final goldAccent = const Color(
      0xFFD97706,
    ); // Dorado/Bronce para denotar valor
    final softGray = const Color(0xFFF1F5F9); // Fondo secciones claras

    return Scaffold(
      backgroundColor: appTheme.onPrimary,
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
            const SizedBox(width: 10),
            Icon(menuOpciones[1].icono),
            const SizedBox(width: 10),
            Text(
              "Promotores",
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
              await dialogBoxFichaLogin(context, ref);
              ref
                  .read(menuInicialProvider.notifier)
                  .asignaNuevaOpcionSeleccionada(ref, 1);
              ref.read(homeNavigationProvider.notifier).actualizarInicial(1);

              ref
                  .read(menuPrincipalProvider.notifier)
                  .asignaNuevaOpcionSeleccionada(ref, 0);
              ref.read(homeNavigationProvider.notifier).actualizarPrincipal(0);

              Navigator.pushReplacementNamed(
                context,
                AppRoutes.principal,
                arguments: "",
              );
            },
            child: Text("Iniciar", style: TextStyle(color: appTheme.onPrimary)),
          ),
          const SizedBox(width: 10),
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: ElevatedButton(
              onPressed: () {
                ref
                    .read(menuInicialProvider.notifier)
                    .asignaNuevaOpcionSeleccionada(ref, 1);
                ref.read(homeNavigationProvider.notifier).actualizarInicial(1);
                ref
                    .read(menuPrincipalProvider.notifier)
                    .asignaNuevaOpcionSeleccionada(ref, 5);
                ref
                    .read(homeNavigationProvider.notifier)
                    .actualizarPrincipal(5);

                ref
                    .read(menuTipoDeTransaccionProvider.notifier)
                    .asignaNuevaOpcionSeleccionada(ref, 0);
                ref
                    .read(homeNavigationProvider.notifier)
                    .actualizarTipoTransaccion(0);

                Navigator.pushReplacementNamed(
                  context,
                  AppRoutes.principal,
                  arguments: "",
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: appTheme.secondary,
                foregroundColor: appTheme.onPrimary,
              ),
              child: const Text("Publicar"),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 1. HERO SECTION: Propuesta de Valor de Negocio
            _buildProfessionalHero(context, ref, darkNavy, goldAccent),

            // 2. DASHBOARD PREVIEW / NUMBERS
            _buildEfficiencyStats(softGray, darkNavy),

            const SizedBox(height: 50),

            // 3. HERRAMIENTAS PRO (Grid de características)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  Text(
                    "Funcionalidades diseñadas para agilizar tus publicaciones.",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: darkNavy,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    "No pierdas tiempo en tareas manuales. Automatiza tu captación y seguimiento.",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 40),
                  _buildToolsGrid(darkNavy, goldAccent),
                ],
              ),
            ),

            const SizedBox(height: 60),

            // 4. PLANES / INTEGRACIÓN
            _buildIntegracionSection(darkNavy),

            const SizedBox(height: 60),

            // 5. CTA FINAL
            _buildFooterPro(darkNavy, goldAccent),

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

  // --- WIDGETS ---

  Widget _buildProfessionalHero(
    BuildContext context,
    WidgetRef ref,
    Color bg,
    Color accent,
  ) {
    return Container(
      width: double.infinity,
      // Altura un poco mayor para impacto
      height: 500,
      decoration: BoxDecoration(
        color: appTheme.secondary,
        image: DecorationImage(
          image: AssetImage(menuOpciones[1].imagePath),
          // Imagen de oficina moderna/rascacielos, oscurecida
          //  image: const NetworkImage(
          //    "https://images.unsplash.com/photo-1486406146926-c627a92ad1ab?ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80",
          // ),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            appTheme.secondary.withValues(alpha: 0.9),
            BlendMode.darken,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: appTheme.secondary,
                border: Border.all(color: appTheme.inversePrimary),
                borderRadius: BorderRadius.circular(50),
              ),
              child: Text(
                "Servicio para Promotores Inmobiliarios",
                style: TextStyle(
                  color: appTheme.onSecondary,
                  letterSpacing: 1.5,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
            const SizedBox(height: 25),
            Text(
              "Multiplica tus Leads.\nOptimiza tu Cartera.",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: appTheme.onPrimary,
                fontSize: 40,
                fontWeight: FontWeight.w900,
                height: 1.1,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 600,
              child: Text(
                "Plataforma de gestión inmobiliaria con publicaciones segmentadas, analítica y posicionamiento prioritario en búsquedas.",
                textAlign: TextAlign.center,
                style: TextStyle(color: appTheme.inversePrimary, fontSize: 18),
              ),
            ),
            const SizedBox(height: 40),
            Wrap(
              spacing: 20,
              runSpacing: 20,
              alignment: WrapAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    //--------------
                    ref
                        .read(menuInicialProvider.notifier)
                        .asignaNuevaOpcionSeleccionada(ref, 1);
                    ref
                        .read(homeNavigationProvider.notifier)
                        .actualizarInicial(1);
                    ref
                        //--------------
                        .read(menuPrincipalProvider.notifier)
                        .asignaNuevaOpcionSeleccionada(ref, 5);
                    ref
                        .read(homeNavigationProvider.notifier)
                        .actualizarPrincipal(5);
                    //--------------
                    ref
                        .read(menuTuCuentaProvider.notifier)
                        .asignaNuevaOpcionSeleccionada(ref, 0);
                    ref
                        .read(homeNavigationProvider.notifier)
                        .actualizarMiCuenta(0);
                    //--------------
                    ref
                        .read(menuTipoEspaciosProvider.notifier)
                        .asignaNuevaOpcionSeleccionada(ref, 0);
                    ref
                        .read(homeNavigationProvider.notifier)
                        .actualizarTipoEspacio(0);
                    //--------------
                    Navigator.pushReplacementNamed(
                      context,
                      AppRoutes.principal,
                      arguments: "",
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: accent,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 20,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  child: const Text(
                    "Prueba Gratis",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                /*
                OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.white),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 20,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  child: const Text(
                    "Agendar Demo",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                */
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEfficiencyStats(Color bg, Color text) {
    return Container(
      color: bg,
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _statPro("Vistas", "Más visualizaciones", text),
          _statPro("Precio", "El mejor precio por espcios", text),
          _statPro(
            "Multiplataforma",
            "Sube propiedades desde cualquier dispositivo",
            text,
          ),
        ],
      ),
    );
  }

  Widget _statPro(String val, String desc, Color text) {
    return Column(
      children: [
        Text(
          val,
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: text,
          ),
        ),
        Text(
          desc,
          style: TextStyle(
            fontSize: 14,
            color: appTheme.primary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildToolsGrid(Color primary, Color accent) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Adaptativo básico
        int crossAxisCount = constraints.maxWidth > 600 ? 3 : 1;
        double aspect = constraints.maxWidth > 600 ? 1.3 : 2.5;
        double fontsizeTitulo = 18;
        double fontsizeSubtitulo = 14;

        if ((constraints.maxWidth > 0) &&
            (constraints.maxWidth <= (xSmallScreenMax / 2))) {
          crossAxisCount = 1;
          aspect = 1.6;

          fontsizeTitulo = 14;
          fontsizeSubtitulo = 10;
        }
        if ((constraints.maxWidth > xSmallScreenMax / 2) &&
            (constraints.maxWidth <= xSmallScreenMax)) {
          crossAxisCount = 1;
          aspect = 2.0;

          fontsizeTitulo = 14;
          fontsizeSubtitulo = 10;
        }
        if ((constraints.maxWidth >= smallScreenMin) &&
            (constraints.maxWidth < smallScreenMax)) {
          crossAxisCount = 2;

          aspect = 1.7;
          fontsizeTitulo = 16;
          fontsizeSubtitulo = 12;
        }
        if ((constraints.maxWidth >= mediumScreenMin) &&
            (constraints.maxWidth < mediumScreenMax)) {
          crossAxisCount = 3;
          aspect = 1.2;

          fontsizeTitulo = 17;
          fontsizeSubtitulo = 13;
        }
        if ((constraints.maxWidth >= largeScreenMin)) {
          crossAxisCount = 4;
          aspect = 1.2;
          fontsizeTitulo = 18;
          fontsizeSubtitulo = 14;
        }

        /*
var screenWidth = 0.0;
        var screenHeight = 0.0;

        var xSmallScreenMin = 0.0;
        var xSmallScreenMax = 599.0;

        var smallScreenMin = 600.0;
        var smallScreenMax = 904.0;

        var mediumScreenMin = 904.0;
        var mediumScreenMax = 1239.0;

        var largeScreenMin = 1240.0;
        var largeScreenMax = 1439.0;

        var xLargeScreeMin = 1440.0;
        */
        return GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
          childAspectRatio: aspect,
          children: [
            _toolCard(
              Symbols.analytics,
              "Analítica de Mercado",
              "Descubre quién ve tus propiedades y ajusta precios con el mercado.",
              primary,
              fontsizeTitulo,
              fontsizeSubtitulo,
            ),
            _toolCard(
              Symbols.people_alt,
              "Gestión de Leads",
              "Centraliza mensajes, agenda, correos y llamadas.",
              primary,
              fontsizeTitulo,
              fontsizeSubtitulo,
            ),
            _toolCard(
              Symbols.rocket_launch,
              "Posicionamiento",
              "Tus propiedades aparecen primero, en las búsquedas de tu zona.",
              primary,
              fontsizeTitulo,
              fontsizeSubtitulo,
            ),
            _toolCard(
              Symbols.verified_user,
              "Perfil Verificado",
              "Genera confianza inmediata con el sello de Agente Certificado.",
              primary,
              fontsizeTitulo,
              fontsizeSubtitulo,
            ),
            _toolCard(
              Symbols.api,
              "Proximamente API & XML",
              "Sincroniza tu inventario automáticamente desde tu CRM actual.",
              primary,
              fontsizeTitulo,
              fontsizeSubtitulo,
            ),
            /*
            _toolCard(
              Symbols.campaign,
              "Marketing Auto",
              "Generamos flyers y posts de redes sociales de tus propiedades.",
              primary,
            ),*/
          ],
        );
      },
    );
  }

  Widget _toolCard(
    IconData icon,
    String title,
    String desc,
    Color primary,
    double sizeTitulo,
    double sizeSubtitulo,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(
          8,
        ), // Bordes más rectos para look pro
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: appTheme.secondary,
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: primary, size: 35),
          const SizedBox(height: 15),
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: sizeTitulo,
              color: primary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            desc,
            style: TextStyle(
              color: appTheme.tertiary,
              fontSize: sizeSubtitulo,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIntegracionSection(Color bg) {
    return Container(
      width: double.infinity,
      color: const Color(0xFFF8FAFC),
      padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 20),
      child: Column(
        children: [
          const Text(
            "Proximamente compatible con otros ecosistemas",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 30),
          // Logos simulados de CRMs o software inmobiliario
          Wrap(
            spacing: 30,
            runSpacing: 20,
            alignment: WrapAlignment.center,
            children: [
              _logoPlaceholder("EasyBroker"),
              _logoPlaceholder("Wasi"),
              _logoPlaceholder("Tokko"),
              _logoPlaceholder("Salesforce"),
              _logoPlaceholder("InmoFactory"),
            ],
          ),
          const SizedBox(height: 30),
          TextButton.icon(
            onPressed: () {},
            icon: const Icon(Symbols.download),
            label: const Text(
              "Contaremos con API para interrcambio de información",
            ),
          ),
        ],
      ),
    );
  }

  Widget _logoPlaceholder(String name) {
    return Opacity(
      opacity: 0.5,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(color: appTheme.secondary),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }

  Widget _buildFooterPro(Color bg, Color accent) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(50),
      color: bg,
      child: Column(
        children: [
          const Text(
            "Únete a las mejores agencias del país",
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 15),
          const Text(
            "Planes corporativos disponibles para equipos de +5 agentes.",
            style: TextStyle(color: Colors.white54),
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: accent,
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            child: const Text(
              "CONTACTAR VENTAS",
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
                letterSpacing: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
