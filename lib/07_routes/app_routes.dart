//
import 'package:buscobien/08_pantallas/inicio/data_espacios_casas_get.dart';
import 'package:flutter/material.dart';

import '../01_splash_screen/splash_page.dart';
import '../02_principal_screen/principal_sliver_screen_menus_inicio.dart';
import '../03_listas/pagina_mis_listas.dart';
import '../08_pantallas/tu_cuenta/tus_espacios/compra_espacios/form_compra_espacios.dart';
import '../08_pantallas/tu_cuenta/tus_espacios/form_update_espacio_comprado.dart';
import '../04_provider/pagina_colores.dart';
import '../08_pantallas/perfil/pagina_perfil.dart';
import '../08_pantallas/ubicacion/pagina_busca_localidades_gmaps.dart';
import '../14_geolocalizacion/google_map_mapa_propiedades.dart';
import '../22_imagenes/tus_espacios_fotos_propiedad/manejo_de_fotos/fotos_de_la_propiedad/pagina_agrega_multiples_fotos.dart';
import '../22_imagenes/tus_espacios_fotos_propiedad/manejo_de_fotos/opciones_menu_fotos/pagina_lista_fotos_listado.dart';
import '../22_imagenes/tus_espacios_fotos_propiedad/manejo_de_fotos/opciones_menu_fotos/pagina_lista_fotos_carousel.dart';
import '../10_user_login/usuario_login/login_03_form_register_user.dart';
import '../10_user_login/usuario_login/page_solicitar_recuperacion.dart';
import '../10_user_login/usuario_login/page_cambio_password.dart';
import '../10_user_login/avatar/manejo_imagenes_avatar.dart';
import '../22_imagenes/tus_espacios_fotos_propiedad/manejo_de_fotos/opciones_menu_fotos/pagina_fotos_menu_opciones.dart';
//import '../22_imagenes/pagina_gestion_fotos_agrega.dart';
import '../41_connectivity/connectivitycheck_provider.dart';
import '../41_connectivity/pagina_sin_coneccion.dart';
import '../42_sistema_operativo/detecta_os.dart';
//import '../08_pantallas/ubicacion/presentation_pages/pagina_busca_localidades_gmaps.dart';
import '../08_pantallas/ubicacion/screen_maestro_localidades.dart';
import '../60_global_widgets/debugprint.dart';

class AppRoutes {
  static const main = "/";
  static const home = "/home";
  static const splash = "/splash";
  static const login = "/login";
  static const principal = "/principal";
  static const plataforma = "/plataforma";
  static const opciones = "/opciones";
  static const sinconeccion = "/sinconeccion";
  static const checaconeccion = "/checaconeccion";
  static const loginuser = "/loginuser";
  static const registro = "/registro";
  // static const buscalocalidad = "/buscalocalidad";
  static const listalocalidades = "/listalocalidades";
  static const localidades = "/localidades";
  static const localidad = "/localidad";
  static const editaespacio = "/editaespacio";
  static const perfil = "/perfil";
  static const preferencias = "/preferencias";
  static const gestionavatar = "/gestionavatar";

  static const compraespacios = "/compraespacios";

  static const carouselfotospropiedad = "/carouselfotospropiedad";
  static const gestionfotopropiedad = "/gestionfotopropiedad";

  static const agregafotopropiedad = "/agregafotopropiedad";
  static const fotospropiedad = "/fotospropiedad";

  static const catalogotipotransaccion = "/catalogotipotransaccion";
  //-----------------------------------------------------------------------------
  static const filtrapropiedades = "/filtrapropiedades";
  static const buscapropiedades = "/buscapropiedades";

  static const generadatapropiedades = "/generadatapropiedades";
  static const generadatausuarios = "/generadatausuarios";
  static const generadatapromotores = "/generadatapromotores";
  //-----------------------------------------------------------------------------

  static const gestionfotoscasa = "/gestionfotoscasa";
  static const fotospropiedadpaginada = "/fotospropiedadpaginada";
  static const fotospropiedadminiaturas = "/fotospropiedadminiaturas";

  static const fotosagregafotoalista = "/fotosagregafotoalista";
  static const agregamultiplesfotos = "/agregamultiplesfotos";

  //-----------------------------------------------------------------------------
  static const mapapropiedades = "/mapapropiedades";
  static const listaspropiedades = "/listaspropiedades";

  //-----------------------------------------------------------------------------
  static const solicitarRecuperacion = "/solicitarrecuperacion";
  static const cambioPassword = "/cambiopassword";
  //-----------------------------------------------------------------------------
}

// agregar en pagina_01_principal.dart, Set<String> rutas = {
// agregar en varialbes_opciones dart, List<FuncionesPrincpales> listaDeServiciosFacturacion

MaterialPageRoute navigateToRoute(
  Widget screen, {
  required RouteSettings settings,
}) {
  debugPrintLevels(2, "AppRoutes navigateToRoute: ${settings.name}");
  return MaterialPageRoute(
    settings: settings,
    builder: (BuildContext context) {
      return screen;
    },
  );
}

//  Object? arguments
Route? routeGenerate(RouteSettings settings) {
  //
  debugPrintLevels(1, "routeGenerate RouteSettings: ${settings.name}");
  debugPrintLevels(1, "routeGenerate settings: ${settings.arguments}");

  switch (settings.name) {
    case AppRoutes.main:
      return navigateToRoute(
        SplashPage(
          3,
          duration: 3,
          goToPage: const PrincipalSliversMenuInicial(),
        ),
        // SplashPage(3, duration: 3, goToPage: const HomeScreen()),
        settings: settings,
      );

    case AppRoutes.splash:
      return navigateToRoute(
        SplashPage(
          3,
          duration: 3,
          goToPage: const PrincipalSliversMenuInicial(),
          // goToPage: const HomeScreen(),
        ),
        settings: settings,
      );

    case AppRoutes.principal:
      return navigateToRoute(
        const PrincipalSliversMenuInicial(),
        // const HomeScreen(),
        settings: settings,
      );

    case AppRoutes.plataforma:
      return navigateToRoute(
        const PaginaDetectaPlataforma(),
        settings: settings,
      );

    case AppRoutes.sinconeccion:
      return navigateToRoute(
        PaginaSinConeccion(settings.arguments as String),
        settings: settings,
      );

    case AppRoutes.checaconeccion:
      return navigateToRoute(
        PaginaChecaInternet(settings.arguments as Map<String, dynamic>),
        settings: settings,
      );

    case AppRoutes.registro:
      return navigateToRoute(const RegisterScreenUsers(), settings: settings);
    //

    case AppRoutes.listalocalidades:
      debugPrintLevels(3, "appRoute listalocalidades: $settings");
      return navigateToRoute(
        LocalidadesListScreen(settings.arguments as int),
        settings: settings,
      );

    /*  LocalidadesListScreen(settings.arguments as FindLocalidadXcp),
          settings: settings);*/

    case AppRoutes.localidades:
      return navigateToRoute(
        //  LocalidadDetailsScreen(settings.arguments as LocalidadCp),
        PaginaBuscaLocalidadGMaps(),
        settings: settings,
      );

    //

    case AppRoutes.editaespacio:
      debugPrintLevels(3, "appRoute editaespacio: $settings");
      return navigateToRoute(
        PaginaEditaEspacio(settings.arguments as ValueEspaciosCasaGet),
        settings: settings,
      );

    case AppRoutes.perfil:
      return navigateToRoute(const PaginaPerfilWidget(), settings: settings);

    case AppRoutes.preferencias:
      return navigateToRoute(
        PaginaColores(settings.arguments as String),
        settings: settings,
      );

    case AppRoutes.gestionavatar:
      return navigateToRoute(const GestionAvatares(), settings: settings);

    case AppRoutes.compraespacios:
      debugPrintLevels(3, "Call AppRoutes.compraespacios");
      return navigateToRoute(const PaginaCompraEspacios(), settings: settings);

    case AppRoutes.carouselfotospropiedad:
      return navigateToRoute(
        PaginaCarouselFotosWidget(settings.arguments as ValueEspaciosCasaGet),
        settings: settings,
      );

    case AppRoutes.fotospropiedad:
      return navigateToRoute(
        PaginaFotosPropiedad(settings.arguments as ValueEspaciosCasaGet),
        settings: settings,
      );

    // AppRoutes.localidad,
    // ------------------------------------------------
    case AppRoutes.fotospropiedadpaginada:
      return navigateToRoute(
        PropiedadesListaFotosPromotor(
          settings.arguments as ValueEspaciosCasaGet,
        ),
        settings: settings,
      );
    /*
    case AppRoutes.fotosagregafotoalista:
      return navigateToRoute(
          GestionFotosAgrega(settings.arguments as Map<String, dynamic>),
          settings: settings);
    */
    case AppRoutes.agregamultiplesfotos:
      return navigateToRoute(
        AgregaMultiplesFotos(settings.arguments as Map<String, dynamic>),
        settings: settings,
      );

    case AppRoutes.mapapropiedades:
      return navigateToRoute(
        PaginaMapaPropiedades(
          listaPropiedadesVar: settings.arguments as EspaciosCasaGet,
        ),
        settings: settings,
      );

    case AppRoutes.listaspropiedades:
      return navigateToRoute(PageMisListas(), settings: settings);

    case AppRoutes.solicitarRecuperacion:
      return navigateToRoute(
        const PageSolicitarRecuperacion(),
        settings: settings,
      );

    case AppRoutes.cambioPassword:
      final args = settings.arguments as Map<String, String>;
      return navigateToRoute(
        PageCambioPassword(token: args['token']!, perfil: args['perfil']!),
        settings: settings,
      );

    default:
      return null;
  }
}
