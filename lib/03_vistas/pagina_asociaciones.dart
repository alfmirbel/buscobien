import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../01_home/home_navigation_provider.dart';
import '../02_principal_screen/00_principales_opciones.dart';
import '../05_provider_menus/variables_menus.dart';
import '../60_global_widgets/derechos_reservados.dart';
import '../20_var_globales/var_color_themes.dart';

class LandingAsociacionesPage extends ConsumerWidget {
  const LandingAsociacionesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Paleta: Burdeos/Vino (Institucional/Seriedad) y Dorado (Excelencia)
    final primaryColor = const Color(0xFF881337); // Rojo Vino profundo
    //final secondaryColor = const Color(0xFFBE123C); // Rojo más brillante
    final goldColor = const Color(0xFFD97706); // Dorado para certificaciones
    final lightBg = const Color(0xFFFFF1F2); // Fondo rosado muy pálido

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
            Icon(menuOpciones[7].icono, color: appTheme.onPrimary),
            const SizedBox(width: 10),
            Text(
              "Asociaciones",
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
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: TextButton.icon(
              onPressed: () {},
              icon: Icon(Symbols.person_outline, color: primaryColor),
              label: Text(
                "Registro",
                style: TextStyle(color: primaryColor),
              ),
            ),
          ),
          */
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 1. HERO: El poder del gremio
            _buildInstitutionalHero(primaryColor, goldColor),

            // 2. DIRECTORIO DE ASOCIACIONES (Logos)
            _buildAssociationsGrid(),

            // 3. BENEFICIOS PARA LA ASOCIACIÓN (Por qué unirse)
            _buildValueProp(lightBg, primaryColor),

            // 4. CERTIFICACIÓN DIGITAL (El "Sello")
            //_buildCertificationBadgeSection(goldColor),

            // 5. EVENTOS Y CAPACITACIÓN
            _buildEventsSection(primaryColor),

            // 6. CTA FINAL
            _buildFooter(primaryColor),
            // FOOTER
            derechosReservadosObscuro(),
          ],
        ),
      ),
    );
  }

  // --- WIDGETS ---

  Widget _buildInstitutionalHero(Color primary, Color gold) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 60),
      decoration: BoxDecoration(
        color: primary,
        image: DecorationImage(
          // Imagen de convención, apretón de manos o auditorio
          image: AssetImage(menuOpciones[7].imagePath),
          /*
          image: const NetworkImage(
            "https://images.unsplash.com/photo-1556761175-5973dc0f32e7?ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80",
          ),
          */
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            primary.withValues(alpha: 0.9),
            BlendMode.multiply,
          ),
        ),
      ),
      child: Column(
        children: [
          Icon(Symbols.balance, size: 50, color: gold),
          const SizedBox(height: 20),
          const Text(
            "Fortaleciendo el Sector Inmobiliario",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 36,
              fontWeight: FontWeight.w900,
              fontFamily: 'Serif', // Fuente más clásica/seria
            ),
          ),
          const SizedBox(height: 20),
          const SizedBox(
            width: 700,
            child: Text(
              "La plataforma que digitaliza y da visibilidad a las Asociaciones, Colegios y Cámaras Inmobiliarias más prestigiosas del país.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white70, fontSize: 18),
            ),
          ),
          const SizedBox(height: 40),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: gold,
              foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 18),
            ),
            child: const Text(
              "Proximamente Registro de Asociaciones",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAssociationsGrid() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      child: Column(
        children: [
          const Text(
            "Aliados Estratégicos",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 30),
          Wrap(
            spacing: 40,
            runSpacing: 40,
            alignment: WrapAlignment.center,
            children: [
              _associationLogo("AMPI", Colors.green),
              _associationLogo("APCI", Colors.blue),
              _associationLogo("UPIM", Colors.orange),
              _associationLogo("MIO", Colors.red),
              _associationLogo("SUMA", Colors.purple),
            ],
          ),
        ],
      ),
    );
  }

  Widget _associationLogo(String text, Color color) {
    // Placeholder para logotipos reales
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.grey.shade200),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade100,
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Text(
            text,
            style: TextStyle(
              fontWeight: FontWeight.w900,
              color: color,
              fontSize: 18,
            ),
          ),
        ),
        const SizedBox(height: 8),
        /*
        Text(
          "Asoc. $text",
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
        */
      ],
    );
  }

  Widget _buildValueProp(Color bg, Color primary) {
    return Container(
      color: bg,
      padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 20),
      child: Column(
        children: [
          Text(
            "Beneficios para el Gremio",
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: primary,
            ),
          ),
          const SizedBox(height: 40),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _benefitItem(
                  Symbols.verified_user,
                  "Membresía",
                  "Proporcione información  sobre el proceso de afiliación y sus beneficios.",
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: _benefitItem(
                  Symbols.campaign,
                  "Difusión de Eventos",
                  "Publicite sus foros, desayunos y capacitaciones directamente en el dashboard de los agentes.",
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: _benefitItem(
                  Symbols.menu_book,
                  "Bolsa Inmobiliaria",
                  "Cree una bolsa exclusiva para compartir propiedades eentre sus afiliados.",
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _benefitItem(IconData icon, String title, String desc) {
    return Column(
      children: [
        Icon(icon, size: 40, color: const Color(0xFF881337)),
        const SizedBox(height: 15),
        Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        const SizedBox(height: 10),
        Text(
          desc,
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey[700], height: 1.4),
        ),
      ],
    );
  }

  Widget _buildEventsSection(Color primary) {
    return Container(
      width: double.infinity,
      color: Colors.grey[50],
      padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              "Publicación de Eventos del Sector",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: primary,
              ),
            ),
          ),
          const SizedBox(height: 20),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _eventCard("Foros 2026", "Fecha", "Lugar", primary),
                _eventCard("Desayuno de Networking", "Fecha", "Lugar", primary),
                _eventCard("Certificación EC0110", "Fecha", "Lugar", primary),
                _eventCard("Congreso Nacional", "Fecha", "Lugar", primary),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _eventCard(String title, String date, String location, Color color) {
    return Container(
      width: 250,
      margin: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 100,
            decoration: BoxDecoration(
              color: color,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
            ),
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    date,
                    style: TextStyle(
                      color: color,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
                const Icon(Symbols.event, color: Colors.white38, size: 40),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    const Icon(
                      Symbols.location_on,
                      size: 14,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      location,
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(Color primary) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(40),
      color: const Color(0xFF1E293B), // Dark slate
      child: Column(
        children: [
          const Text(
            "¿Representa a una Asociación?",
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 15),
          const Text(
            "Digitalice su padrón y ofrezca más valor a sus agremiados hoy mismo.",
            style: TextStyle(color: Colors.white54),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: primary,
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            ),
            child: const Text(
              "Proximamente información de convenios",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
