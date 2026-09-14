// Enumerated type
import 'package:flutter/material.dart';

import '../03_vistas/pagina_asociaciones.dart';
import '../03_vistas/pagina_hospedaje.dart';
import '../03_vistas/pagina_inmobiliarias.dart';
import '../03_vistas/pagina_propietarios.dart';
import '../03_vistas/pagina_servicios.dart';
import '../03_vistas/pagina_promotores.dart';
import '../03_vistas/pagina_proveedores.dart';
import '../03_vistas/pagina_market.dart';
import '../03_vistas/pagina_usuarios.dart';
import '../20_var_globales/var_elementos_menus.dart';

//------------------------------------------------------------------------------
List<Widget> listaLandingPages = [
  LandingBusquedaPage(),
  LandingAgentesPage(),
  LandingPropietariosPage(),
  LandingHospedajePage(),
  LandingMarketPage(),
  LandingServiciosPage(),
  LandingProveedoresPage01(),
  LandingAsociacionesPage(),
  LandingInmobiliariasPage(),
];

// -----------------------------------------------------------------------------
// MODELO DE DATOS LOCAL (Para mapear las opciones del menú)
// -----------------------------------------------------------------------------
class MenuOption {
  final String nombreCorto;
  final String nombreLargo; // Usado como descripción corta en la card grande
  final String descripcion; // Descripción detallada
  final IconData icono;
  final String imagePath;

  const MenuOption({
    required this.nombreCorto,
    required this.nombreLargo,
    required this.descripcion,
    required this.icono,
    required this.imagePath,
  });
}

// Lista de opciones basada en las Landing Pages que desarrollamos
final List<MenuOption> menuOpciones = [
  // Index 0: Búsqueda (LandingBusquedaPage)
  MenuOption(
    nombreCorto: "Buscar",
    nombreLargo: "Encuentra tu espacio",
    descripcion:
        "Conoce la oferta de compra o renta de casas, departamentos y otros tipos de propiedades.",
    icono: iconoVerPropiedades.icono,
    imagePath: 'assets/images/fondo_opcion_1.jpg',
  ),
  // Index 2: Agentes (LandingAgentesPage)
  MenuOption(
    nombreCorto: "Promotores",
    nombreLargo: "Publica propiedades",
    descripcion:
        "Promociona propiedades, gestiona tus leads y analiza el mercado.",
    icono: iconoPromotores.icono,
    imagePath: 'assets/images/fondo_opcion_3.jpg',
  ),
  // Index 1: Propietarios (LandingPropietariosPage)
  MenuOption(
    nombreCorto: "Propietarios",
    nombreLargo: "Vende o renta por tu cuenta",
    descripcion: "Publica tu propiedad sin intermediarios y sin comisiones.",
    icono: iconoPropietarios.icono,
    imagePath: 'assets/images/fondo_opcion_2.jpg',
    //Icons.home_work_outlined,
  ),
  // Index 1: Propietarios (Hospedajes - LandingPropietariosPage)
  MenuOption(
    nombreCorto: "Anfitriones",
    nombreLargo: "Ofrece tu propiedad para hospedajes por días o semanas.",
    descripcion:
        "Publica tu propiedad para ofrecer hospedaje por días o semanas.",
    icono: iconoHospedaje.icono,
    imagePath: 'assets/images/fondo_opcion_9.jpg',
    //Icons.home_work_outlined,
  ),
  // Index 3: Productos (LandingProductosPage02)
  MenuOption(
    nombreCorto: "Tienda",
    nombreLargo: "Vende y compra",
    descripcion:
        "Ofrece o busca los bienes muebles y materiales que necesitas para mejorar tu espacio.",
    icono: iconoTienda.icono,
    imagePath: 'assets/images/fondo_opcion_4.jpg',
  ),
  // Index 4: Servicios (LandingServiciosPage)
  MenuOption(
    nombreCorto: "Servicios",
    nombreLargo: "Ofrece tus servicios",
    descripcion:
        "Ofrece tus servicios para el hogar, como mantenimientos, mudanzas, pintura, remodelación y técnicos.",
    icono: iconoServicios.icono,
    imagePath: 'assets/images/fondo_opcion_5.jpg',
  ),
  // Index 5: Proveedores (LandingProveedoresPage01 - Hub de Aliados)
  MenuOption(
    nombreCorto: "Proveedores",
    nombreLargo: "Oferta tus productos",
    descripcion:
        "El espacio central para los socios comerciales que ofrecen los insumos que requieres.",
    icono: iconoProveedores.icono,
    imagePath: 'assets/images/fondo_opcion_6.jpg',
  ),

  // Index 6: Asociaciones de Promotores (LandingInmobiliariasPage)
  MenuOption(
    nombreCorto: "Asociaciones",
    nombreLargo: "Asociaciones de Promotores",
    descripcion:
        "Sitios de interés\nConoce las asociaciones de promotores inmobiliarios.",
    icono: iconoAsociaciones.icono,
    imagePath: 'assets/images/fondo_opcion_7.jpg',
  ),

  // Index 7: Inmobiliarias (LandingInmobiliariasPage)
  MenuOption(
    nombreCorto: "Inmobiliarias",
    nombreLargo: "Principales Inmobiliarias",
    descripcion:
        "Sitios de interés\nConoce las principales inmobiliarias en el país.",
    icono: iconoInmobiliarias.icono,
    imagePath: 'assets/images/fondo_opcion_8.jpg',
  ),
];

/*
class FuncionesPrincipales {
  int indice;
  String nombreCorto;
  String nombreLargo;
  String descripcion;
  IconData icono;
  String ruta;

  FuncionesPrincipales(
    this.indice,
    this.nombreCorto,
    this.nombreLargo,
    this.descripcion,
    this.icono,
    this.ruta,
  );
}

List<FuncionesPrincipales> listaDeServiciosMenu = [
  FuncionesPrincipales(
    1,
    "Usuarios",
    "Usuarios en busca de Bienes Inmuebles",
    "Usuarios en busca de Bienes Inmuebles",
    Icons.person_search_outlined,
    "",
    // AppRoutes.listaPropiedades10, // PropiedadesListaPaginada()
  ),
  FuncionesPrincipales(
    2,
    "Propietarios",
    "Propietarios que desean promover su propiedad.",
    "Propietarios que desean promover su propiedad.",
    Icons.record_voice_over_outlined,
    "",
    // AppRoutes.listaPropiedades10, // PropiedadesListaPaginada()
  ),
  //
  FuncionesPrincipales(
    3,
    "Promotores Individuales",
    "Promotores Inmobiliarios que desean promover propiedades",
    "Promotores Inmobiliarios que desean promover propiedades",
    Icons.real_estate_agent_outlined,
    "",
    // AppRoutes.localidadpaginada, //  CodigosPostalesListaPaginada()
  ),
  //
  FuncionesPrincipales(
    4,
    "Inmobiliarias",
    "Inmobiliarias que desean publicar propiedades",
    "Inmobiliarias que desean publicar propiedades",
    Icons.corporate_fare_outlined,
    "",
    // AppRoutes.localidades, // FormLocationScreen()
  ),
  //
  FuncionesPrincipales(
    5,
    "Prestadores de Servicios",
    "Prestadores de sercivios que desean promover sus servicios.",
    "Prestadores de sercivios que desean promover sus servicios.",
    Icons.handyman_outlined,
    "",
    // AppRoutes.listalocalidades, // LocalidadesListScreen(settings.arguments as FindLocalidadXcp)
  ),
  //
  FuncionesPrincipales(
    6,
    "Proveedores",
    "Proveedores de productos relacionados a la construcción, mantenimiento y mudansas.",
    "Proveedores de productos relacionados a la construcción, mantenimiento y mudansas.",
    Icons.storefront_outlined,
    "",
    // AppRoutes.generadatausuarios, // PaginaGeneraUsuarios()
  ),
  FuncionesPrincipales(
    7,
    "Productos",
    "Proveedores de productos relacionados a la construcción, mantenimiento y mudansas.",
    "Proveedores de productos relacionados a la construcción, mantenimiento y mudansas.",
    Icons.shopping_bag_outlined,
    "",
    // AppRoutes.generadatausuarios, // PaginaGeneraUsuarios()
  ),
  //
];
*/
//------------------------------------------------------------------------------

/*

// -----------------------------------------------------------------------------
// MODELO DE DATOS LOCAL (Para mapear las opciones del menú)
// -----------------------------------------------------------------------------
class MenuOption {
  final String nombreCorto;
  final String nombreLargo; // Usado como descripción corta en la card grande
  final String descripcion; // Descripción detallada
  final IconData icono;

  const MenuOption({
    required this.nombreCorto,
    required this.nombreLargo,
    required this.descripcion,
    required this.icono,
  });
}

// Lista de opciones basada en las Landing Pages que desarrollamos
final List<MenuOption> menuOpciones = [
  // Index 0: Búsqueda (LandingBusquedaPage)
  const MenuOption(
    nombreCorto: "Buscar",
    nombreLargo: "Encontrar Propiedad",
    descripcion: "Compra o renta casas, departamentos y terrenos.",
    icono: Icons.search,
  ),
  // Index 1: Propietarios (LandingPropietariosPage)
  const MenuOption(
    nombreCorto: "Propietario",
    nombreLargo: "Vende por tu cuenta",
    descripcion: "Publica tu propiedad sin intermediarios y ahorra comisiones.",
    icono: Icons.home_work_outlined,
  ),
  // Index 2: Agentes (LandingAgentesPage)
  const MenuOption(
    nombreCorto: "Agente Promotores",
    nombreLargo: "Herramientas para Agentes",
    descripcion: "CRM, gestión de leads y analítica de mercado.",
    icono: Icons.person_pin_circle_outlined,
  ),
  // Index 3: Inmobiliarias (LandingInmobiliariasPage)
  const MenuOption(
    nombreCorto: "Enterprise",
    nombreLargo: "Soluciones Corporativas",
    descripcion: "Control total para agencias y desarrolladoras.",
    icono: Icons.domain,
  ),
  // Index 4: Servicios (LandingServiciosPage)
  const MenuOption(
    nombreCorto: "Servicios",
    nombreLargo: "Hogar y Mantenimiento",
    descripcion: "Mudanzas, pintura, remodelación y técnicos.",
    icono: Icons.handyman_outlined,
  ),
  // Index 5: Proveedores (LandingProveedoresPage01 - Hub de Aliados)
  const MenuOption(
    nombreCorto: "Aliados",
    nombreLargo: "Portal de Partners",
    descripcion: "El hub central para todos nuestros socios comerciales.",
    icono: Icons.hub_outlined,
  ),
  // Index 6: Productos (LandingProductosPage02)
  const MenuOption(
    nombreCorto: "Market",
    nombreLargo: "Tienda y Decoración",
    descripcion: "Muebles y materiales con publicidad contextual.",
    icono: Icons.shopping_bag_outlined,
  ),
];

*/
