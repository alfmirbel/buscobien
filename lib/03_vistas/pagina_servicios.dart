import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../01_home/home_navigation_provider.dart';
import '../02_principal_screen/00_principales_opciones.dart';
import '../05_provider_menus/variables_menus.dart';
import '../20_var_globales/var_color_themes.dart';

class LandingServiciosPage extends ConsumerWidget {
  const LandingServiciosPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Paleta: Turquesa (Renovación/Limpieza) y Naranja (Construcción/Actividad)
    final primaryColor = const Color(0xFF0D9488); // Teal / Turquesa fuerte
    final secondaryColor = const Color(0xFFF97316); // Naranja vibrante
    final darkText = const Color(0xFF1F2937);

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
            Icon(menuOpciones[5].icono),
            const SizedBox(width: 10),
            Text(
              "Servicios",
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
          /*
          TextButton(
            onPressed: () {},
            child: Text("Iniciar", style: TextStyle(color: darkText)),
          ),
          */
          const SizedBox(width: 10),
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: appTheme.onPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Text(
                "Iniciar",
                style: TextStyle(color: appTheme.onPrimaryContainer),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 1. HERO SECTION: El momento de necesidad
            _buildHero(primaryColor, secondaryColor),

            // 2. CATEGORÍAS ACEPTADAS (Grid Visual)
            _buildCategoriesSection(darkText),

            // 3. PROPUESTA DE VALOR (Timing)
            _buildValueProp(primaryColor),

            // 4. CÓMO FUNCIONA (Pasos)
            _buildHowItWorks(primaryColor),

            // 5. TESTIMONIO / ÉXITO
            //  _buildSuccessStory(),

            // 6. CTA FINAL
            _buildFooter(primaryColor, secondaryColor),

            const SizedBox(height: 30),
            Text(
              "© 2026 Buscobien. Todos los derechos reservados.",
              style: TextStyle(color: appTheme.primary, fontSize: 12),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // --- WIDGETS ---

  Widget _buildHero(Color primary, Color accent) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 60),
      decoration: BoxDecoration(
        color: const Color(0xFFF0FDFA), // Fondo muy suave turquesa
        image: DecorationImage(
          // Imagen de alguien pintando o arreglando, con opacidad
          image: AssetImage(menuOpciones[5].imagePath),
          /*
          image: NetworkImage(
            "https://images.unsplash.com/photo-1581578731117-10d52b43c12c?ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80",
          ),
          */
          fit: BoxFit.cover,
          opacity: 0.15,
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: accent,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              "PROXIMAMENTE",
              //"PARA ARQUITECTOS, MUDANZAS Y TÉCNICOS",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 10,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            "Consigue clientes que\nacaban de firmar contrato",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: const Color(0xFF134E4A), // Turquesa muy oscuro
              fontSize: 34,
              fontWeight: FontWeight.w900,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 15),
          SizedBox(
            width: 600,
            child: Text(
              "Ofrece tus servicios de remodelación, mantenimiento y mudanza con personas que tienen la necesidad inmediata de habilitar su nuevo hogar.",
              textAlign: TextAlign.center,
              style: TextStyle(color: appTheme.secondary, fontSize: 18),
            ),
          ),
          const SizedBox(height: 30),
          ElevatedButton.icon(
            onPressed: () {},
            //icon: const Icon(Symbols.check_circle_outline, color: Colors.white),
            label: const Text(
              "OFRECER MIS SERVICIOS",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: primary,
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 18),
              elevation: 4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoriesSection(Color darkText) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 20),
      child: Column(
        children: [
          Text(
            "Busco experto en...",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: darkText,
            ),
          ),
          const SizedBox(height: 30),
          Wrap(
            spacing: 20,
            runSpacing: 20,
            alignment: WrapAlignment.center,
            children: [
              _serviceCard(
                Symbols.local_shipping,
                "Mudanzas",
                "Fletes y logística",
              ),
              _serviceCard(
                Symbols.format_paint,
                "Remodelación",
                "Pintura, pisos y acabados",
              ),
              _serviceCard(
                Symbols.design_services,
                "Interiorismo",
                "Diseño y decoración",
              ),
              _serviceCard(
                Symbols.plumbing,
                "Mantenimiento",
                "Plomería, gas y electricidad",
              ),
              _serviceCard(Symbols.kitchen, "Carpintería", "Cocinas y closets"),
              _serviceCard(
                Symbols.cleaning_services,
                "Limpieza",
                "Limpieza profunda pre-mudanza",
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _serviceCard(IconData icon, String title, String subtitle) {
    return Container(
      width: 160,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: appTheme.secondary),
        boxShadow: [
          BoxShadow(
            color: appTheme.secondary,
            blurRadius: 5,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          CircleAvatar(
            backgroundColor: appTheme.primary,
            radius: 25,
            child: Icon(icon, color: appTheme.onPrimary, size: 28),
          ),
          const SizedBox(height: 15),
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 5),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, color: appTheme.secondary),
          ),
        ],
      ),
    );
  }

  Widget _buildValueProp(Color primary) {
    return Container(
      color: Colors.grey[50],
      padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /*
                Text(
                  "EL PROBLEMA ACTUAL",
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
                */
                const SizedBox(height: 10),
                Text(
                  "Oferta directa",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: appTheme.secondary,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "Promocionamos cuando el cliente está viendo la propiedad.",
                  style: TextStyle(fontSize: 16, color: appTheme.secondary),
                ),
              ],
            ),
          ),
          const SizedBox(width: 20),
          Container(height: 60, width: 1, color: appTheme.primary), // Separador
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /*
                Text(
                  "LA SOLUCIÓN",
                  style: TextStyle(
                    color: primary,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
                */
                const SizedBox(height: 10),
                Text(
                  "Leads Calificados",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: appTheme.secondary,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "Promoción directa  desde la ficha de la propiedad que les interesa.",
                  style: TextStyle(fontSize: 16, color: appTheme.secondary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHowItWorks(Color primary) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 20),
      child: Column(
        children: [
          const Text(
            "¿Cómo obtengo trabajos?",
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 40),
          _stepRow(
            "1",
            "Crea tu perfil de Proveedor",
            "Sube fotos de tus trabajos anteriores y certificaciones.",
            appTheme.primary,
          ),
          _stepLine(),
          _stepRow(
            "2",
            "Define tu zona de cobertura",
            "Elige en qué ciudades o colonias puedes trabajar.",
            appTheme.primary,
          ),
          _stepLine(),
          _stepRow(
            "3",
            "Recibe alertas de oportunidades",
            "Te notificamos cuando alguien compra una casa que requiere tus servicios.",
            appTheme.primary,
          ),
        ],
      ),
    );
  }

  Widget _stepRow(String num, String title, String desc, Color color) {
    return Row(
      children: [
        CircleAvatar(
          radius: 25,
          backgroundColor: color,
          child: Text(
            num,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(desc, style: TextStyle(color: appTheme.secondary)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _stepLine() {
    return Container(
      margin: const EdgeInsets.only(left: 25, top: 5, bottom: 5),
      height: 30,
      width: 2,
      color: Colors.grey[200],
    );
  }

  /*
  Widget _buildSuccessStory() {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: const Color(0xFF2C3E50),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          const Icon(Symbols.star, color: Colors.amber, size: 40),
          const SizedBox(height: 20),
          const Text(
            "\"Antes dependía de recomendaciones boca a boca. Con buscobien, llené mi agenda de remodelaciones porque los clientes me encuentran antes de mudarse.\"",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            "- Arq. Miguel S., Renovaciones Urbanas",
            style: TextStyle(
              color: Colors.white70,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
*/
  Widget _buildFooter(Color primary, Color accent) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 20),
      child: Column(
        children: [
          const Text(
            "Empieza a crecer tu negocio hoy",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: accent,
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              elevation: 5,
            ),
            child: const Text(
              "PROXIMAMENTE CREAR TU PERFIL GRATUITO",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 20),
          /*
          TextButton(
            onPressed: () {},
            child: Text(
              "Ver tarifas para proveedores Premium",
              style: TextStyle(color: primary),
            ),
          ),
          */
        ],
      ),
    );
  }
}
