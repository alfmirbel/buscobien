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

//------------------------------------------------------------------------------

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
  // Index 1: Agentes (LandingAgentesPage)
  MenuOption(
    nombreCorto: "Promotores",
    nombreLargo: "Publica propiedades",
    descripcion:
        "Promociona propiedades, gestiona tus leads y analiza el mercado.",
    icono: iconoPromotores.icono,
    imagePath: 'assets/images/fondo_opcion_3.jpg',
  ),
  // Index 2: Propietarios (LandingPropietariosPage)
  MenuOption(
    nombreCorto: "Propietarios",
    nombreLargo: "Vende o renta por tu cuenta",
    descripcion: "Publica tu propiedad sin intermediarios y sin comisiones.",
    icono: iconoPropietarios.icono,
    imagePath: 'assets/images/fondo_opcion_2.jpg',
    //Symbols.home_work,
  ),
];
