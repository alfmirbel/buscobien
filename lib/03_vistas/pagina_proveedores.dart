import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../01_home/home_navigation_provider.dart';
import '../02_principal_screen/00_principales_opciones.dart';
import '../05_provider_menus/variables_menus.dart';
import '../20_var_globales/var_color_themes.dart';

class LandingProveedoresPage01 extends ConsumerWidget {
  const LandingProveedoresPage01({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Paleta: Morado (Creatividad/Premium) y Magenta (Retail/Shopping)
    final brandPurple = const Color(0xFF5B21B6);
    final shopPink = const Color(0xFFDB2777);
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
            Icon(menuOpciones[6].icono),
            const SizedBox(width: 10),
            Text(
              "Proveedores",
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
            child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: appTheme.onPrimary),
              ),
              child: Text(
                "Iniciar",
                style: TextStyle(color: appTheme.onPrimary),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 1. HERO: El concepto de "Showroom Digital"
            _buildRetailHero(brandPurple, shopPink),

            // 2. CATEGORÍAS DE PRODUCTOS
            _buildProductCategories(),

            // 3. LA ESTRATEGIA ("Shop the Look")
            _buildStrategySection(darkText, brandPurple),

            // 4. HERRAMIENTAS DE MARKETING
            _buildMarketingTools(brandPurple),

            // 5. BANNER DE CUPONES (El gancho para el usuario final)
            // _buildCouponConcept(shopPink),

            // 6. BRANDS CAROUSEL
            //  _buildBrandsTicker(),

            // 7. CTA FINAL
            _buildFooter(brandPurple, shopPink),

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

  Widget _buildRetailHero(Color primary, Color accent) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: 550,
          decoration: BoxDecoration(
            color: primary,
            image: DecorationImage(
              image: AssetImage(menuOpciones[6].imagePath),
              /*
              image: const NetworkImage(
                "https://images.unsplash.com/photo-1560518883-ce09059eeffa?ixlib=rb-1.2.1&auto=format&fit=crop&w=1000&q=80",
              ),
              */
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                primary.withValues(alpha: 0.85),
                BlendMode.darken,
              ),
            ),
          ),
          child:
              // Fondo con imagen de interiorismo
              Column(
                children: [
                  // Gradiente para legibilidad
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            primary.withValues(alpha: 0.9),
                            Colors.transparent,
                          ],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                      ),
                    ),
                  ),
                  // Contenido
                  Padding(
                    padding: const EdgeInsets.all(40.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          color: Colors.white,
                          child: Text(
                            "PROXIMAMENTE PARA TIENDAS Y FABRICANTES",
                            style: TextStyle(
                              color: primary,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          "Convierte casas vacías\nen tu mejor escaparate",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 40,
                            fontWeight: FontWeight.w800,
                            height: 1.1,
                          ),
                        ),
                        const SizedBox(height: 20),
                        const SizedBox(
                          width: 500,
                          child: Text(
                            "Integra tu catálogo de productos directamente en las fichas de las propiedades. Cuando ellos compran la casa, tú les vendes lo que va adentro.",
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        ),
                        const SizedBox(height: 40),
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: accent,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 40,
                              vertical: 20,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          child: const Text(
                            "PROXIMAMENTE SUBIR MI CATÁLOGO",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
        ),
      ],
    );
  }

  Widget _buildProductCategories() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 20),
      color: Colors.grey[50],
      child: Column(
        children: [
          const Text(
            "¿Qué buscan los nuevos propietarios?",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 30),
          Wrap(
            spacing: 15,
            runSpacing: 15,
            alignment: WrapAlignment.center,
            children: [
              _catChip("Muebles", Symbols.chair),
              _catChip("Iluminación", Symbols.light_mode),
              _catChip("Pisos y Baños", Symbols.bathtub),
              _catChip("Domótica", Symbols.sensors),
              _catChip("Electrodomésticos", Symbols.kitchen),
              _catChip("Seguridad", Symbols.lock_outline),
              _catChip("Decoración", Symbols.local_florist),
              _catChip("Materiales", Symbols.construction),
            ],
          ),
        ],
      ),
    );
  }

  Widget _catChip(String label, IconData icon) {
    return Chip(
      avatar: Icon(icon, size: 18, color: Colors.grey[800]),
      label: Text(label),
      backgroundColor: Colors.white,
      elevation: 2,
      padding: const EdgeInsets.all(10),
    );
  }

  Widget _buildStrategySection(Color text, Color primary) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 20),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              height: 300,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                image: const DecorationImage(
                  image: NetworkImage(
                    "https://images.unsplash.com/photo-1556228453-efd6c1ff04f6?ixlib=rb-1.2.1&auto=format&fit=crop&w=1000&q=80",
                  ),
                  fit: BoxFit.cover,
                ),
              ),
              // Simulación de "Tags" de compra sobre la imagen
              child: Stack(
                children: [
                  _shoppingTag(50, 100, "\$ Sofa"),
                  _shoppingTag(180, 200, "\$ Lámpara"),
                ],
              ),
            ),
          ),
          const SizedBox(width: 40),
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /*
                Text(
                  "SHOP THE LOOK",
                  style: TextStyle(
                    color: primary,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
                */
                const SizedBox(height: 5),
                Text(
                  "Vende en el contexto exacto",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: appTheme.primary,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  "No pongas un anuncio perdido en un banner lateral. Con nuestra solución, tus productos aparecerán en conjunto con las fotos de la propiedad.",
                  style: TextStyle(
                    fontSize: 16,
                    color: appTheme.secondary,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 20),
                ListTile(
                  leading: Icon(Symbols.ads_click, color: primary),
                  title: const Text("Clic directo a tu Sitio de ventas"),
                  subtitle: const Text(
                    "Redireccionamos al usuario a la página de compra del producto.",
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _shoppingTag(double top, double left, String label) {
    return Positioned(
      top: top,
      left: left,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.9),
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 4)],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Symbols.circle, size: 8, color: Colors.pink),
            const SizedBox(width: 5),
            Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMarketingTools(Color primary) {
    return Container(
      color: const Color(0xFFF3E8FF), // Lila muy suave
      padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 20),
      child: Column(
        children: [
          const Text(
            "Herramientas de Venta",
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _toolItem(
                Symbols.qr_code_2,
                "Links",
                "En las visitas físicas a la propiedad.",
              ),
              _toolItem(
                Symbols.card_giftcard,
                "Oferta",
                "Tu marca en la busqueda de propiedades.",
              ),
              _toolItem(
                Symbols.analytics,
                "Información",
                "Qué estilos prefieren en cada zona.",
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _toolItem(IconData icon, String title, String desc) {
    return SizedBox(
      width: 250,
      child: Column(
        children: [
          Icon(icon, size: 50, color: Colors.deepPurple),
          const SizedBox(height: 15),
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 10),
          Text(
            desc,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey[700]),
          ),
        ],
      ),
    );
  }

  /*
  Widget _buildCouponConcept(Color accent) {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [accent, Colors.orangeAccent]),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          const Icon(Symbols.local_offer, size: 60, color: Colors.white),
          const SizedBox(width: 20),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "CUPONERA DEL NUEVO VECINO",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  "Ofrece descuentos exclusivos (ej. 15% en Pinturas) para quienes acaban de firmar contrato. La conversión más alta del mercado.",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
*/
  /*
  Widget _buildBrandsTicker() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Column(
        children: [
          Text(
            "Partners que ya venden aquí",
            style: TextStyle(
              color: Colors.grey[400],
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _brandLogo("HomeDepot"),
                _brandLogo("Interceramic"),
                _brandLogo("Comex"),
                _brandLogo("Gaia Design"),
                _brandLogo("Helvex"),
                _brandLogo("Samsung"),
              ],
            ),
          ),
        ],
      ),
    );
  }
*/
  /*
  Widget _brandLogo(String name) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Text(
        name,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.grey[300],
        ),
      ),
    );
  }
*/
  Widget _buildFooter(Color primary, Color accent) {
    return Container(
      width: double.infinity,
      color: const Color(0xFF111827),
      padding: const EdgeInsets.all(50),
      child: Column(
        children: [
          const Text(
            "Posiciona tu marca en el momento de buscar",
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
              backgroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            child: Text(
              "PROXIMAMENTE REGISTRA TU MARCA O TIENDA",
              style: TextStyle(color: primary, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 20),
          /*
          const Text(
            "Planes especiales para PyMES locales",
            style: TextStyle(color: Colors.white54),
          ),
          */
        ],
      ),
    );
  }
}

/*
Esta página está dirigida a Tiendas, Marcas y Fabricantes (Mueblerías, Casas de Materiales, Tiendas de Decoración, Domótica, etc.).

El enfoque aquí es el "Contextual Commerce" (Comercio Contextual). La propuesta de valor es: "Tu producto no debe estar en un espectacular en la calle, debe estar dentro de la foto de la casa que el usuario quiere comprar".

El diseño debe sentirse como un E-commerce moderno y visual, usando colores que inciten a la compra y den sensación de "Catálogo Premium".

Aquí tienes el código para LandingProveedoresPage.dart:

Elementos Diferenciadores:
Shop the Look: La imagen central simula etiquetas sobre los objetos ($ Sofa). Esto comunica instantáneamente que la plataforma permite "etiquetar" productos en las fotos de las casas.

Enfoque Retail: Uso de términos como Catálogo, E-commerce, Cuponera.

Momento de Verdad: Se explota el hecho de que cuando alguien compra casa, necesita todo nuevo.

Colores: El Morado (DeepPurple) se usa mucho en branding creativo y de lujo, mientras que el Rosa/Magenta es el color estándar para botones de "Compra" o "Oferta" en UI moderna, diferenciándose del azul corporativo o el verde de servicios.

*/
