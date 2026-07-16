import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../01_home/home_navigation_provider.dart';
import '../02_principal_screen/00_principales_opciones.dart';
import '../05_provider_menus/variables_menus.dart';
import '../60_global_widgets/derechos_reservados.dart';
import '../20_var_globales/var_color_themes.dart';

class LandingMarketPage extends ConsumerWidget {
  const LandingMarketPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Paleta: Violeta (Creatividad/Lujo) y Ámbar (Comercio/Atención)
    final brandColor = const Color(0xFF4C1D95); // Violeta profundo
    final accentColor = const Color(0xFFFBBF24); // Ámbar brillante
    final darkText = const Color(0xFF111827);

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
            Icon(menuOpciones[4].icono),
            const SizedBox(width: 10),
            Text(
              "Tienda",
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
            padding: const EdgeInsets.only(right: 16.0),
            child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: appTheme.onPrimary),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                "Ingresa",
                style: TextStyle(color: appTheme.onPrimary),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 1. HERO: Inspiración y Aspiración
            _buildShowroomHero(brandColor, accentColor),

            // 2. CATEGORÍAS (Qué se puede vender)
            _buildCategories(darkText),

            // 3. LA TECNOLOGÍA (Publicidad Contextual)
            _buildContextualFeature(brandColor),

            // 4. BENEFICIOS RETAIL
            _buildRetailBenefits(brandColor),

            // 5. MARCAS ASOCIADAS (Social Proof)
            // _buildBrandPartners(),

            // 6. CTA FINAL
            _buildFooter(brandColor, accentColor),

            derechosReservadosObscuro(),
          ],
        ),
      ),
    );
  }

  // --- WIDGETS ---

  Widget _buildShowroomHero(Color primary, Color accent) {
    return Container(
      width: double.infinity,
      height: 550,
      decoration: BoxDecoration(
        color: primary,
        image: DecorationImage(
          // Imagen de interiorismo de alta calidad
          image: AssetImage(menuOpciones[4].imagePath),
          /*
          image: const NetworkImage(
            "https://images.unsplash.com/photo-1618221195710-dd6b41faaea6?ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80",
          ),
          */
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            appTheme.primary.withValues(alpha: 0.85),
            BlendMode.multiply,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                border: Border.all(color: accent),
                borderRadius: BorderRadius.circular(50),
              ),
              child: Text(
                "PROXIMAMENTE", //PARA PERSONAS, TIENDAS Y FABRICANTES
                style: TextStyle(
                  color: accent,
                  letterSpacing: 2,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
            const SizedBox(height: 25),
            const Text(
              "No solo vendas productos.\nInspira nuevos hogares.",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 38,
                fontWeight: FontWeight.w800,
                height: 1.1,
              ),
            ),
            const SizedBox(height: 20),
            const SizedBox(
              width: 600,
              child: Text(
                "Promociona muebles, materiales y acabados, para compradores que están diseñando su futuro espacio en este momento.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white70, fontSize: 18),
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: accent,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 20,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text(
                "AQUÍ PODRAS SUBIR TÚ CATÁLOGO",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategories(Color darkText) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 20),
      child: Column(
        children: [
          Text(
            "Tu inventario, en el lugar correcto",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: darkText,
            ),
          ),
          const SizedBox(height: 30),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _productCatCard(
                  "Mobiliario",
                  "Salas, comedores...",
                  "https://images.unsplash.com/photo-1555041469-a586c61ea9bc?auto=format&fit=crop&w=300&q=80",
                ),
                _productCatCard(
                  "Materiales",
                  "Pisos, pintura...",
                  "https://images.unsplash.com/photo-1589939705384-5185137a7f0f?auto=format&fit=crop&w=300&q=80",
                ),
                _productCatCard(
                  "Electrodomesticos",
                  "Línea blanca...",
                  "https://images.unsplash.com/photo-1556911220-e15b29be8c8f?auto=format&fit=crop&w=300&q=80",
                ),
                _productCatCard(
                  "Smart Home",
                  "Seguridad, luces...",
                  "https://images.unsplash.com/photo-1558002038-109177381793?auto=format&fit=crop&w=300&q=80",
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _productCatCard(String title, String sub, String imgUrl) {
    return Container(
      width: 180,
      margin: const EdgeInsets.only(right: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        image: DecorationImage(image: NetworkImage(imgUrl), fit: BoxFit.cover),
      ),
      child: Container(
        height: 220,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          gradient: LinearGradient(
            colors: [Colors.transparent, Colors.black.withValues(alpha: 0.8)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: const EdgeInsets.all(15),
        alignment: Alignment.bottomLeft,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            Text(
              sub,
              style: const TextStyle(color: Colors.white70, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContextualFeature(Color brand) {
    return Container(
      color: Colors.grey[50],
      padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 20),
      child: Column(
        children: [
          Text(
            "PUBLICIDAD CONTEXTUAL INTELIGENTE",
            style: TextStyle(
              color: brand,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 15),
          const Text(
            "El producto exacto en el momento exacto",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 40),
          Row(
            children: [
              Expanded(
                child: _contextCard(
                  Symbols.kitchen,
                  "Si el usuario ve una Cocina...",
                  "...mostramos tu Refrigerador",
                  brand,
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Icon(Symbols.arrow_forward, color: Colors.grey),
              ),
              Expanded(
                child: _contextCard(
                  Symbols.deck,
                  "Si el usuario ve un Jardín...",
                  "...mostramos tu Asador",
                  brand,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _contextCard(
    IconData icon,
    String ifText,
    String thenText,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.grey.withValues(alpha: 0.1), blurRadius: 10),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, size: 40, color: color),
          const SizedBox(height: 10),
          Text(
            ifText,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 5),
          Text(
            thenText,
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildRetailBenefits(Color brand) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 20),
      child: Column(
        children: [
          _benefitRow(
            Symbols.link,
            "Contacto Directo",
            "Enlace directo al vendedor o a la página de producto de tu E-commerce.",
            brand,
          ),
          const SizedBox(height: 30),
          _benefitRow(
            Symbols.qr_code_scanner,
            "Promociones Digitales",
            "Ofrece descuentos de bienvenida a nuevos propietarios.",
            brand,
          ),
          const SizedBox(height: 30),
          _benefitRow(
            Symbols.view_in_ar,
            "Visualización",
            "Permite que vean el producto en varias perspectivas.",
            brand,
          ),
        ],
      ),
    );
  }

  Widget _benefitRow(IconData icon, String title, String desc, Color color) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 28),
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
              const SizedBox(height: 5),
              Text(
                desc,
                style: TextStyle(color: Colors.grey[600], height: 1.4),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /*
  Widget _buildBrandPartners() {
    return Container(
      width: double.infinity,
      color: Colors.grey[100],
      padding: const EdgeInsets.symmetric(vertical: 30),
      child: Column(
        children: [
          const Text(
            "Impulsando ventas de marcas líderes",
            style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 30,
            children: [
              _brandText("Comex"),
              _brandText("Interceramic"),
              _brandText("Liverpool"),
              _brandText("Gaia"),
            ],
          ),
        ],
      ),
    );
  }
*/
  /*
  Widget _brandText(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w900,
        color: Colors.grey[400],
      ),
    );
  }
*/
  Widget _buildFooter(Color primary, Color accent) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(40),
      color: primary,
      child: Column(
        children: [
          const Icon(Symbols.storefront, color: Colors.white, size: 50),
          const SizedBox(height: 20),
          const Text(
            "Abre tu sucursal en línea.",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: accent,
              foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: const Text(
              "PROXIMAMENTE",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}


/*
Esta página se enfoca en Retailers, Fabricantes y Distribuidores.

El concepto clave aquí es el "Contextual Commerce". La propuesta de valor es que los productos no aparecen en un banner genérico, sino integrados en la experiencia de búsqueda.Ejemplo: Si el usuario ve una cocina, le mostramos refrigeradores. Si ve un jardín, le mostramos muebles de exterior.

El diseño debe ser altamente visual (tipo Revista/Catálogo) y aspiracional.

Aquí tienes el código para LandingProductosPage.dart:

Características distintivas de esta página:
Estética de Showroom: El color violeta oscuro (Deep Purple) se asocia a menudo con la creatividad, el diseño de interiores y el lujo accesible. Las imágenes juegan un papel crucial.

Enfoque en el Producto: Se usa terminología como "Catálogo", "Inventario" y "E-commerce".

Diferenciador Tecnológico (Contextual): Se explica visualmente cómo funciona la publicidad: No es un banner molesto, es una sugerencia útil basada en lo que el usuario está viendo (Cocina -> Refri).

Integración E-commerce: Se menciona explícitamente el "Tráfico directo", que es la métrica que más le importa a un gerente de marketing digital de una tienda.

Esta estructura completa el ecosistema de tu aplicación:

Compradores: Buscan casa.

Propietarios: Venden casa.

Agentes: Gestionan la venta.

Servicios: Arreglan la casa.

Productos (Esta página): Amueblan la casa.
*/