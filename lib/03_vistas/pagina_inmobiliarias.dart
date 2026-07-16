import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../01_home/home_navigation_provider.dart';
import '../02_principal_screen/00_principales_opciones.dart';
import '../05_provider_menus/variables_menus.dart';
import '../60_global_widgets/derechos_reservados.dart';
import '../20_var_globales/var_color_themes.dart';

class LandingInmobiliariasPage extends ConsumerWidget {
  const LandingInmobiliariasPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Colores "Enterprise"
    // Un azul acero más corporativo y un verde "growth" para el éxito/dinero
    final corporateBlue = const Color(0xFF2C3E50);
    final growthGreen = const Color(0xFF27AE60);
    final lightBackground = const Color(0xFFF8F9FA);

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
            Icon(menuOpciones[8].icono),
            const SizedBox(width: 10),
            Text(
              "Inmobiliarias",
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
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: TextButton(
              onPressed: () {},
              child: Text(
                "Acceso",
                style: TextStyle(
                  color: appTheme.onPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 1. HERO SECTION: Enfoque en Gestión de Equipos
            _buildEnterpriseHero(corporateBlue, growthGreen),

            // 2. CLIENTES / CONFIANZA
            _buildTrustedBy(),

            // 3. PROBLEMA VS SOLUCIÓN (El "Control Center")
            _buildControlCenterSection(lightBackground, corporateBlue),

            // 4. FUNCIONALIDADES PARA EQUIPOS (Grid)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 60),
              child: Column(
                children: [
                  Text(
                    "Todo el inventario. Todo el equipo.\nUn solo lugar.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: corporateBlue,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildFeaturesGrid(corporateBlue),
                ],
              ),
            ),

            // 5. BANNER DE INTEGRACIÓN API (Crucial para inmobiliarias grandes)
            //_buildApiBanner(corporateBlue),

            // 6. FORMULARIO DE CONTACTO B2B
            _buildContactFormSection(growthGreen, corporateBlue),

            // 7. FOOTER SIMPLE
            derechosReservadosObscuro(),
          ],
        ),
      ),
    );
  }

  // --- WIDGETS ---

  Widget _buildEnterpriseHero(Color primary, Color accent) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 80),
      decoration: BoxDecoration(
        color: primary,
        image: DecorationImage(
          // Imagen de convención, apretón de manos o auditorio
          image: AssetImage(menuOpciones[8].imagePath),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            primary.withValues(alpha: 0.9),
            BlendMode.multiply,
          ),
        ),
        /*
        // Un degradado sutil para dar profundidad
        gradient: LinearGradient(
          colors: [primary, const Color(0xFF34495E)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        */
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: Colors.white24),
            ),
            child: const Text(
              "PROXIMAMENTE PARA AGENCIAS Y DESARROLLADORAS",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(height: 30),
          const Text(
            "Promueba su oferta inmobiliaria",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 42,
              fontWeight: FontWeight.w900,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 20),
          const SizedBox(
            width: 700,
            child: Text(
              "Potencie a sus promotores, controle la calidad de sus publicaciones y de seguimiento a promotores y propiedades.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white70, fontSize: 18),
            ),
          ),
          const SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: () {},
                //icon: const Icon(Symbols.calendar_month, color: Colors.white),
                label: const Text(
                  "PROXIMAMENTE REGISTRO",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: accent,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 20,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              /*
              const SizedBox(width: 20),
              OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.white54),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 20,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  "Ver Video Tour",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              */
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTrustedBy() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 30),
      child: Column(
        children: [
          Text(
            "Sitios de interés",
            style: TextStyle(
              color: Colors.grey[400],
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 40,
            runSpacing: 20,
            alignment: WrapAlignment.center,
            children: [
              _fakeLogo("Century22"),
              _fakeLogo("ReMaxi"),
              _fakeLogo("KellerW"),
              _fakeLogo("TecnoCasa"),
              _fakeLogo("Rayo"),
              _fakeLogo("..."),
            ],
          ),
        ],
      ),
    );
  }

  Widget _fakeLogo(String text) {
    return Text(
      text,
      style: TextStyle(
        color: Colors.grey[400],
        fontSize: 22,
        fontWeight: FontWeight.w900,
        fontStyle: FontStyle.italic,
      ),
    );
  }

  Widget _buildControlCenterSection(Color bg, Color primary) {
    return Container(
      color: bg,
      padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 20),
      child: Row(
        children: [
          // En mobile esto debería ser un Column, aquí simplificamos para el ejemplo
          Expanded(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.only(right: 30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /*
                  Text(
                    "CONTROL TOTAL",
                    style: TextStyle(
                      color: primary,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                  */
                  const SizedBox(height: 15),
                  Text(
                    "Administre promotores y propiedades sin perder la propiedad de los datos",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: primary,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _checkItem("Asigne leads a sus agentes."),
                  _checkItem("Seguimiento de llamadas y correos recibidos."),
                  _checkItem("Proteja su información."),
                  _checkItem("Precios especiales."),
                  _checkItem("Confidencialidad y protección de datos."),
                ],
              ),
            ),
          ),
          // Placeholder de una imagen del Dashboard
          /*
          Expanded(
            flex: 5,
            child: Container(
              height: 350,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Symbols.pie_chart,
                      size: 80,
                      color: Colors.blueGrey[100],
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "Dashboard Administrativo",
                      style: TextStyle(
                        color: Colors.blueGrey[300],
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          */
        ],
      ),
    );
  }

  Widget _checkItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          const Icon(Symbols.check_circle, color: Color(0xFF27AE60), size: 20),
          const SizedBox(width: 10),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 16))),
        ],
      ),
    );
  }

  Widget _buildFeaturesGrid(Color primary) {
    return LayoutBuilder(
      builder: (context, constraints) {
        int crossCount = constraints.maxWidth > 800 ? 3 : 1;
        return GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: crossCount,
          crossAxisSpacing: 30,
          mainAxisSpacing: 30,
          childAspectRatio: 1.5,
          children: [
            _featureCard(
              Symbols.supervisor_account,
              "Gestión de Agentes",
              "Cree cuentas ilimitadas para sus promotores y monitoree su actividad en tiempo real.",
              primary,
            ),
            _featureCard(
              Symbols.branding_watermark,
              "Micrositio",
              "Personalice las fichas de propiedad con el logo y colores de tu inmobiliaria.",
              primary,
            ),
            /*
            _featureCard(
              Symbols.insights,
              "Business Intelligence",
              "Reportes de mercado: precio por m² en su zona, demanda y competencia.",
              primary,
            ),
            */
            _featureCard(
              Symbols.upload_file,
              "Carga Masiva",
              "Suba propiedades en minutos vía archivos.",
              primary,
            ),
            /*
            _featureCard(
              Symbols.chat_bubble,
              "Bot de WhatsApp",
              "Respuestas automáticas 24/7 para no perder leads fuera de horario.",
              primary,
            ),
            */
            /*
            _featureCard(
              Symbols.gavel,
              "Legal Tech",
              "Generación de contratos pre-llenados con un clic.",
              primary,
            ),
            */
          ],
        );
      },
    );
  }

  Widget _featureCard(IconData icon, String title, String desc, Color primary) {
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: primary, size: 28),
          ),
          const SizedBox(height: 15),
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(desc, style: TextStyle(color: Colors.grey[600], height: 1.4)),
        ],
      ),
    );
  }

  /*
  Widget _buildApiBanner(Color primary) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(20),
        image: const DecorationImage(
          image: NetworkImage(
            "https://www.transparenttextures.com/patterns/circuit-board.png",
          ), // Textura sutil
          opacity: 0.1,
          repeat: ImageRepeat.repeat,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "API-FIRST",
                  style: TextStyle(
                    color: Colors.tealAccent,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "¿Ya usa un CRM interno?",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Conecte su sistema con nuestra API REST. Sincronización bidireccional de inventario y leads sin intervención humana.",
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
              ],
            ),
          ),
          const SizedBox(width: 40),
          Expanded(
            child: Center(
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: primary,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 20,
                  ),
                ),
                child: const Text("Leer Documentación Técnica"),
              ),
            ),
          ),
        ],
      ),
    );
  }
*/
  Widget _buildContactFormSection(Color accent, Color primary) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 20),
      color: Colors.white,
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Column(
            children: [
              Text(
                "Escalemos su negocio inmobiliario",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: primary,
                ),
              ),
              const SizedBox(height: 10),
              /*
              const Text(
                "Déjenos sus datos y un especialista en cuentas corporativas le contactará hoy mismo.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 40),
              */
              // Formulario Simulado
              /*
              TextFormField(
                decoration: const InputDecoration(
                  labelText: "Nombre de la Inmobiliaria",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 15),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(
                        labelText: "Nombre de contacto",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(
                        labelText: "Teléfono",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: "Número de Agentes (Aprox)",
                  border: OutlineInputBorder(),
                ),
              ),
              */
              const SizedBox(height: 25),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: appTheme.primary,
                    padding: const EdgeInsets.symmetric(vertical: 20),
                  ),
                  child: const Text(
                    "PROXIMAMENTE REGISTRO CORPORATIVO",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
