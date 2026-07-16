import 'package:buscobien/05_provider_menus/provider_menu_nivel_gobierno.dart';
import 'package:buscobien/05_provider_menus/provider_menu_tipo_espacio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../01_home/home_navigation_provider.dart';
import '../02_principal_screen/00_principales_opciones.dart';
import '../02_principal_screen/principal_00_inicio.dart';
import '../05_provider_menus/provider_menu_inicial.dart';
import '../05_provider_menus/provider_menu_principal.dart';
import '../05_provider_menus/provider_menu_tipo_de_transaccion.dart';
import '../05_provider_menus/variables_menus.dart';
import '../07_routes/app_routes.dart';
import '../08_pantallas/inicio/data_espacios_casas.dart';
import '../08_pantallas/inicio/data_espacios_casas_get.dart';
import '../08_pantallas/inicio/http_find_propiedades_10en10.dart';
import '../08_pantallas/inicio/inicio_propiedades_providers.dart';
import '../20_var_globales/var_color_themes.dart';
import '../22_imagenes/inicio_fotos_usuario/pagina_carousel_fotos_usuario_mini.dart';

// 1. DEFINICIÓN DE LA VARIABLE GLOBAL (PROVIDER)
// Esto permite acceder al valor desde cualquier otro widget usando ref.read(codigoPostalBusquedaProvider)

class LandingBusquedaPage extends ConsumerWidget {
  const LandingBusquedaPage({super.key});

  // Constantes de diseño movidas a static const o finales para evitar recreación
  static const double iconSizeBanner = 16.0;
  static const double textSizeBanner = 10.0;
  static const double espacioEntreDato = 8.0;
  static const List<String> valoresString = ["", "0"];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Definimos colores de marca para esta página
    final primaryColor = const Color(0xFF1E3A8A); // Azul oscuro confiable
    final accentColor = const Color(0xFFF59E0B); // Ámbar para botones (CTA)

    return Scaffold(
      backgroundColor: appTheme.onPrimary,
      // AppBar transparente superpuesto o simple blanco
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
            Icon(menuOpciones[0].icono),
            const SizedBox(width: 10),
            Text(
              "Buscar",
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
              // await dialogBoxFichaLogin(context, ref);
              ref
                  .read(menuInicialProvider.notifier)
                  .asignaNuevaOpcionSeleccionada(ref, 1);
              ref.read(homeNavigationProvider.notifier).actualizarInicial(1);

              ref
                  .read(menuPrincipalProvider.notifier)
                  .asignaNuevaOpcionSeleccionada(ref, 0);
              ref.read(homeNavigationProvider.notifier).actualizarPrincipal(0);

              ref
                  .read(menuNivelDeGobiernoProvider.notifier)
                  .asignaNuevaOpcionSeleccionada(ref, 0);
              ref
                  .read(homeNavigationProvider.notifier)
                  .actualizarNivelGobierno(0);

              ref
                  .read(menuTipoEspaciosProvider.notifier)
                  .asignaNuevaOpcionSeleccionada(ref, 0);
              ref
                  .read(homeNavigationProvider.notifier)
                  .actualizarTipoEspacio(0);

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
            child: Text("Iniciar", style: TextStyle(color: appTheme.onPrimary)),
          ),
          const SizedBox(width: 10),
          ElevatedButton(
            onPressed: () {
              ref
                  .read(menuInicialProvider.notifier)
                  .asignaNuevaOpcionSeleccionada(ref, 1);
              ref.read(homeNavigationProvider.notifier).actualizarInicial(1);
              ref
                  .read(menuPrincipalProvider.notifier)
                  .asignaNuevaOpcionSeleccionada(ref, 5);
              ref.read(homeNavigationProvider.notifier).actualizarPrincipal(5);

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
              //  Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: Text(
              "Publicar",
              style: TextStyle(color: appTheme.onPrimary),
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. HERO SECTION (Buscador Principal)
            _buildHeroSection(context, ref, primaryColor, accentColor),
            const SizedBox(height: 30),
            // 2. CATEGORÍAS RÁPIDAS
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: const Text(
                  "¿Qué estás buscando?",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 15),
            _buildCategorias(),
            const SizedBox(height: 30),

            // 3. PROPIEDADES SOBRESALIENTES (Carrusel)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Wrap(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Propiedades Sobresalientes",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(width: 20),

                  TextButton(
                    onPressed: () {
                      ref
                          .read(menuInicialProvider.notifier)
                          .asignaNuevaOpcionSeleccionada(ref, 1);
                      ref
                          .read(homeNavigationProvider.notifier)
                          .actualizarInicial(1);

                      ref
                          .read(menuPrincipalProvider.notifier)
                          .asignaNuevaOpcionSeleccionada(ref, 0);
                      ref
                          .read(homeNavigationProvider.notifier)
                          .actualizarPrincipal(0);

                      ref
                          .read(menuNivelDeGobiernoProvider.notifier)
                          .asignaNuevaOpcionSeleccionada(ref, 0);
                      ref
                          .read(homeNavigationProvider.notifier)
                          .actualizarNivelGobierno(0);

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
                    style: TextButton.styleFrom(
                      //  foregroundColor: Colors.green.shade700, // Sets the text and icon color
                      backgroundColor: appTheme.onSurface,
                    ),
                    child: Text(
                      "Ver todas",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: appTheme.onPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            _buildCarruselDestacados(ref),

            const SizedBox(height: 40),

            // 4. SECCIÓN DE VALOR (Why us?)
            _buildSeccionValor(primaryColor),

            const SizedBox(height: 40),

            // 5. FOOTER / CALL TO ACTION
            _buildFooter(context, ref, primaryColor, accentColor),

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

  // --- WIDGETS INTERNOS ---

  Widget _buildHeroSection(
    BuildContext context,
    WidgetRef ref,
    Color primary,
    Color accent,
  ) {
    // Variable local para validar la longitud antes de guardar en el global
    // Nota: Si este método está dentro de un método build, se reiniciará al reconstruir.
    // Lo ideal es que _buildHeroSection sea parte de un StatefulWidget o usar un Controller externo.
    // Para este ejemplo, usaremos el provider para guardar el estado mientras se escribe.
    return Stack(
      children: [
        // Imagen de Fondo (Placeholder)
        Container(
          height: 350,
          width: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(menuOpciones[0].imagePath),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                appTheme.primary.withValues(alpha: 0.9),
                BlendMode.multiply,
              ),
            ),
          ),
        ),
        // Gradiente oscuro para que el texto resalte
        Container(
          height: 350,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.black.withValues(alpha: 0.7), Colors.transparent],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
          ),
        ),
        // Contenido del Hero
        Positioned.fill(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Encuentra el espacio\nadecuado a tus necesidades",
                  style: TextStyle(
                    color: appTheme.onPrimary,
                    fontSize: 30,
                    fontWeight: FontWeight.w800,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "Cientos de propiedades en venta y renta te esperan.",
                  style: TextStyle(color: appTheme.onSecondary, fontSize: 16),
                ),
                const SizedBox(height: 25),
                // Barra de Búsqueda Flotante
                Container(
                  width: 500,
                  height: 60,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: appTheme.onPrimary,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: Icon(Symbols.search, color: appTheme.secondary),
                      ),
                      Expanded(
                        child: TextField(
                          // 2. CONFIGURACIÓN DEL INPUT (SOLO NÚMEROS, MAX 5)
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter
                                .digitsOnly, // Solo enteros
                            LengthLimitingTextInputFormatter(
                              5,
                            ), // Máximo 5 dígitos
                          ],
                          onChanged: (value) {
                            // Actualizamos el provider en tiempo real o guardamos en variable temporal.
                            // Aquí guardamos null si no es un número válido.
                            if (value.isNotEmpty) {
                              ref
                                  .read(codigoPostalBusquedaProvider.notifier)
                                  .state = int.tryParse(
                                value,
                              );
                            } else {
                              ref
                                      .read(
                                        codigoPostalBusquedaProvider.notifier,
                                      )
                                      .state =
                                  null;
                            }
                          },
                          decoration: InputDecoration(
                            labelStyle: TextStyle(
                              color: appTheme.primary,
                              fontSize: 30,
                              fontWeight: FontWeight.w800,
                              // height: 1.2,
                            ),
                            hintText: "Código Postal (Ej. 06600)...",
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          //----------------
                          // 3. VALIDACIÓN FINAL ANTES DE NAVEGAR
                          final cpCapturado = ref.read(
                            codigoPostalBusquedaProvider,
                          );
                          // Validamos que exista y tenga longitud 5 (si es int y tiene 4 digitos ej 04000,
                          // al pasarlo a string podría perder el 0 inicial, pero la longitud del input visual es lo que importa.
                          // Para validación estricta de longitud visual, se requeriría un Controller,
                          // pero basándonos en valor entero:)
                          if (cpCapturado != null &&
                              cpCapturado.toString().length >= 4 &&
                              cpCapturado.toString().length <= 5) {
                            // NOTA: CP 04000 se guarda como int 4000.
                            // Si necesitas validar estrictamente que el usuario escribió 5 caracteres,
                            // necesitarías guardar un String en el provider, no un int.
                            // Asumiendo requerimiento estricto de "5 dígitos capturados":
                            // Lo mejor es validar rango de CP en México (1000 a 99999).

                            if (cpCapturado < 1000 || cpCapturado > 99999) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    "Por favor captura un CP válido de 5 dígitos.",
                                  ),
                                  backgroundColor: appTheme.error,
                                ),
                              );
                              return;
                            }
                            // ACCIONES DE NAVEGACIÓN EXITOSA
                            //-----------------
                            ref
                                .read(menuInicialProvider.notifier)
                                .asignaNuevaOpcionSeleccionada(ref, 1);
                            ref
                                .read(homeNavigationProvider.notifier)
                                .actualizarInicial(1);
                            //--------
                            ref
                                .read(menuPrincipalProvider.notifier)
                                .asignaNuevaOpcionSeleccionada(ref, 4);
                            ref
                                .read(homeNavigationProvider.notifier)
                                .actualizarPrincipal(4);

                            // 4. Navegar
                            Navigator.pushReplacementNamed(
                              context,
                              AppRoutes.localidades,
                              arguments: "",
                            );

                            //---------------------
                          } else {
                            // MENSAJE DE ERROR
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  "El Código Postal debe ser de 5 dígitos.\Escribe el valor correctamente.\n",
                                ),
                                backgroundColor: appTheme.error,
                              ),
                            );
                          }
                          //---------------------
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: appTheme.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 15,
                          ),
                        ),
                        child: Text(
                          "Buscar",
                          style: TextStyle(
                            color: appTheme.onPrimary,
                            fontWeight: FontWeight.bold,
                          ),
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

  Widget _buildCategorias() {
    // Lista simple de categorías
    final cats = [
      {"icon": Symbols.home, "label": "Casas"},
      {"icon": Symbols.apartment, "label": "Depas"},
      {"icon": Symbols.storefront, "label": "Locales"},
      {"icon": Symbols.landscape, "label": "Terrenos"},
    ];

    return SizedBox(
      height: 90,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        itemCount: cats.length,
        itemBuilder: (ctx, i) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: appTheme.secondary,
                  child: Icon(
                    cats[i]['icon'] as IconData,
                    color: appTheme.onSecondary,
                    size: 28,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  cats[i]['label'] as String,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  //---------------------
  // -----------------------------------------------------------------------
  // WIDGET: CARRUSEL HORIZONTAL CONECTADO A BD
  // -----------------------------------------------------------------------
  Widget _buildCarruselDestacados(WidgetRef ref) {
    // 1. Consumir el provider real (Solicitamos 6 propiedades)
    final listaAsync = ref.watch(
      findPropiedadesEstadosde10en10Provider(
        paramSkipFind: 0,
        paramLimitFind: 6,
        valueQry: ref.watch(currentQueryProvider),
      ),
    );

    // 2. Envolvemos en SizedBox para dar altura al scroll horizontal
    return SizedBox(
      height: 340, // Altura total del carrusel (tarjeta + sombras)
      child: listaAsync.when(
        // Estado de Carga
        loading: () => const Center(child: CircularProgressIndicator()),
        // Estado de Error
        error: (err, stack) => Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text("Error: No se pudieron cargar datos.\n$err"),
          ),
        ),
        // Estado de Datos (Éxito)
        data: (data) {
          if (data.rows.isEmpty) {
            return const Center(child: Text("No hay propiedades destacadas."));
          }

          // 3. ListView Horizontal
          return ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
            ), // Padding inicial/final
            itemCount: data.rows.length,
            separatorBuilder: (ctx, i) =>
                const SizedBox(width: 15), // Espacio entre cards
            itemBuilder: (context, index) {
              final propiedad = data.rows[index].value;

              // -----------------------------------------------------------
              // 4. LÓGICA DE IMAGEN (Prioridad: Ordenadas > Normales)
              // -----------------------------------------------------------

              // Precios
              String precioMostrar = "";
              if (propiedad.espacioscasa.precioventa != "0") {
                precioMostrar = "${propiedad.espacioscasa.precioventa}";
                if (propiedad.espacioscasa.preciorenta != "0") {
                  precioMostrar += "/${propiedad.espacioscasa.preciorenta}";
                }
              } else {
                if (propiedad.espacioscasa.preciorenta != "0") {
                  precioMostrar = "${propiedad.espacioscasa.preciorenta}";
                } else {
                  precioMostrar = "Sin información";
                }
              }

              // Ubicación
              String ubicacionMostrar =
                  "${propiedad.espacioscasa.ubicacioncasa.localidadCp}, ${propiedad.espacioscasa.ubicacioncasa.localidadCp.estado}";

              return _cardPropiedadHorizontal(
                propiedad,
                propiedad.espacioscasa.letreropromocional,
                precioMostrar,
                ubicacionMostrar,
              );
            },
          );
        },
      ),
    );
  }

  // -----------------------------------------------------------------------
  // WIDGET: TARJETA DISEÑADA PARA CARRUSEL HORIZONTAL
  // -----------------------------------------------------------------------
  Widget _cardPropiedadHorizontal(
    ValueEspaciosCasaGet propiedad,
    String titulo,
    String precio,
    String ubicacion,
  ) {
    EspaciosCasa itemCasa = propiedad.espacioscasa;

    return Container(
      width:
          widthCuadroFotoPropiedadLocal, // ANCHO FIJO: Necesario para scroll horizontal
      margin: const EdgeInsets.only(
        bottom: 10,
        top: 5,
      ), // Margen vertical para la sombra
      child: Card(
        elevation: 4,
        shadowColor: Colors.black26,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Foto
            SizedBox(
              child: Column(
                spacing: 6.0,
                verticalDirection: VerticalDirection.down,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // RECUADRO DE LAS FOTOS
                  SizedBox(
                    width: widthCuadroFotoPropiedadLocal,
                    height:
                        heightCuadroFotoPropiedadLocal +
                        40, // Asumiendo variable global
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: PaginaCarouselFotosMini(propiedad),
                    ),
                  ),
                ],
              ),
            ),
            /*
            Expanded(
              // La imagen ocupa el espacio restante arriba
              flex: 3,
              child: Image.network(
                imgUrl,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey.shade200,
                    child: Center(
                      child: Icon(
                        Symbols.image_not_supported,
                        size: 40,
                        color: Colors.grey.shade400,
                      ),
                    ),
                  );
                },
              ),
            ),
            */
            // Datos
            Expanded(
              // El contenido ocupa la parte inferior
              //flex: 2,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(6, 0, 6, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      precio,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: appTheme.onPrimaryContainer,
                        letterSpacing: -0.8,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      titulo,
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    /*
                        Icon(
                          Symbols.location_on,
                          size: 14,
                          color: appTheme.secondary,
                        ),
                      */
                    // UBICACION DE LA PROPIEDAD
                    Container(
                      width: widthCuadroFotoPropiedadLocal,
                      padding: const EdgeInsets.fromLTRB(5, 3, 3, 5),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "${itemCasa.ubicacioncasa.localidadCp.asentamiento}, ${itemCasa.ubicacioncasa.localidadCp.municipio}, ${itemCasa.ubicacioncasa.localidadCp.estado}, C.P. ${itemCasa.ubicacioncasa.localidadCp.cp}",
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          letterSpacing: -0.2,
                          fontSize: 10,
                          fontWeight: FontWeight.normal,
                          color: appTheme.onPrimaryContainer,
                        ),
                      ),
                    ),
                    // DATOS DE LA PROPIEDAD (Iconos)
                    Container(
                      width: 250,
                      padding: const EdgeInsets.fromLTRB(5, 3, 3, 5),
                      alignment: Alignment.centerLeft,
                      child: Wrap(
                        crossAxisAlignment: WrapCrossAlignment
                            .center, // Alinea iconos y texto verticalmente
                        children: [
                          _buildFeatureItem(
                            Symbols.width_full,
                            itemCasa.metrosdeterreno,
                            suffix: " mts.",
                          ),
                          _buildFeatureItem(
                            Symbols.home_work,
                            itemCasa.metrosconstruidos,
                            suffix: " mts.",
                          ),
                          _buildFeatureItem(Symbols.bed, itemCasa.recamaras),
                          _buildFeatureItem(Symbols.shower, itemCasa.banos),
                          _buildFeatureItem(
                            Symbols.directions_car,
                            itemCasa.estacionamientos,
                          ),
                          _buildFeatureItem(
                            Symbols.garage,
                            itemCasa.estacionamientoscubiertos,
                            isLastItem:
                                true, // Para evitar el espaciado final si se desea
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// OPTIMIZACIÓN: Método helper para generar los items de características (Icono + Valor).
  /// Reduce drásticamente la repetición de código `if (!valoresString.contains...)`.
  Widget _buildFeatureItem(
    IconData icon,
    String value, {
    String suffix = "",
    bool isLastItem = false,
  }) {
    // Si el valor está en la lista de exclusión ("" o "0"), no mostramos nada.
    if (valoresString.contains(value)) {
      return const SizedBox.shrink();
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: appTheme.onPrimaryContainer, size: iconSizeBanner),
        const SizedBox(width: 3),
        Text(
          "$value$suffix",
          maxLines: 1,
          overflow: TextOverflow.visible,
          style: TextStyle(
            letterSpacing: -0.4,
            fontSize: textSizeBanner,
            fontWeight: FontWeight.normal,
            color: appTheme.onPrimaryContainer,
          ),
        ),
        // Agrega espacio a la derecha si no es el último item visualmente (opcional, ajustado a tu lógica original)
        if (!isLastItem) SizedBox(width: espacioEntreDato),
      ],
    );
  }

  //--------------------
  /*
  Widget _buildCarruselDestacados() {
    return SizedBox(
      height: 280,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        children: [
          _cardPropiedad(
            "Casa Moderna",
            "\$4,500,000",
            "Jardines del Valle",
            "https://images.unsplash.com/photo-1580587771525-78b9dba3b91d?auto=format&fit=crop&w=600&q=80",
          ),
          _cardPropiedad(
            "Loft Industrial",
            "\$18,000 / mes",
            "Centro Histórico",
            "https://images.unsplash.com/photo-1560448204-e02f11c3d0e2?auto=format&fit=crop&w=600&q=80",
          ),
          _cardPropiedad(
            "Penthouse Lujo",
            "\$12,000,000",
            "Lomas Altas",
            "https://images.unsplash.com/photo-1512917774080-9991f1c4c750?auto=format&fit=crop&w=600&q=80",
          ),
        ],
      ),
    );
  }

  Widget _cardPropiedad(
    String titulo,
    String precio,
    String ubicacion,
    String imgUrl,
  ) {
    return Container(
      width: 220,
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Foto
            Image.network(
              imgUrl,
              height: 140,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            // Datos
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    precio,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    titulo,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        Symbols.location_on,
                        size: 14,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          ubicacion,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                          maxLines: 1,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
*/
  Widget _buildSeccionValor(Color primary) {
    return Container(
      color: Colors.blue.withValues(alpha: 0.05),
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      child: Column(
        children: [
          const Text(
            "¿Por qué buscobien?",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 25),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _valorItem(Symbols.verified_user, "Seguro", primary),
              _valorItem(Symbols.flash_on, "Rápido", primary),
              _valorItem(Symbols.support_agent, "Soporte", primary),
            ],
          ),
        ],
      ),
    );
  }

  Widget _valorItem(IconData icon, String texto, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: appTheme.onPrimary,
            shape: BoxShape.circle,
            border: Border.all(color: color.withValues(alpha: 0.2)),
          ),
          child: Icon(icon, size: 30, color: color),
        ),
        const SizedBox(height: 10),
        Text(texto, style: const TextStyle(fontWeight: FontWeight.w600)),
      ],
    );
  }

  Widget _buildFooter(
    BuildContext context,
    WidgetRef ref,
    Color primary,
    Color accent,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: primary,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: Column(
        children: [
          Text(
            "¿Listo para buscar?",
            style: TextStyle(
              color: appTheme.onPrimary,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
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
            style: ElevatedButton.styleFrom(
              backgroundColor: appTheme.surface,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: Text(
              "Empezar Ahora",
              style: TextStyle(
                fontSize: 16,
                color: appTheme.onPrimaryContainer,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            "Proximamente descarga nuestra app.",
            style: TextStyle(color: appTheme.onTertiary),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
