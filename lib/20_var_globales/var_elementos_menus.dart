import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

//------------------------------------------------------------------------------

class ElementosMenus {
  String etiqueta;
  IconData icono;

  ElementosMenus(this.etiqueta, this.icono);
}

class ElementoSeleccionado {
  int index = 0;
  String etiqueta;
  IconData icono;
  List<bool> buttonSelectOpcion;

  ElementoSeleccionado(
    this.index,
    this.etiqueta,
    this.icono,
    this.buttonSelectOpcion,
  );
}

//------------------------------------------------------------------------------
List<String> etiquetasMenuInicial = [
  "¿Qué tipo de propiedad estás buscando?", // Notas
  "¿Qué tipo de propiedad estás buscando?", // Notas
  "¿Qué tipo de propiedad estás buscando?", // Notas
  "¿Qué tipo de propiedad estás buscando?", // Notas
  "¿Qué tipo de propiedad estás buscando?", // Notas
  "¿Qué tipo de propiedad estás buscando?", // Notas
];
/*
Tipo de operación
Rentar
Comprar
Remates
Temporal/Vacacional
Desarrollos
Traspaso

Tipo de inmueble
Departamento
Casa
Terreno
Lote
Casa en condominio
Local comercial
Bodega comercial
Casa uso de suelo
Departamento compartido
Desarrollo horizontal
Desarrollo horizontal/vertical
Desarrollo vertical
Dúplex
Edificio
Huerta
Inmueble productivo urbano
Local en centro comercial
Nave industrial
Oficina
Quinta
Rancho
Terreno comercial
Terreno industrial
Villa
*/
// Menu Inicial ---------------------------------------------------------------
// Inicio
// "Propiedades"
// "Particulares"
// "Promotores"
// "Tienda"
// "Productos"
// "Servicios"
// "Inmobiliarias"

// Lista de opciones basada en las Landing Pages que desarrollamos
ElementosMenus iconoInicio = ElementosMenus("Inicio", Symbols.home);
// Index 0: Búsqueda (LandingBusquedaPage)
/*
ElementosMenus iconoPropiedades = ElementosMenus(
  "Propiedades",
  Symbols.home_work,
);*/
ElementosMenus iconoVerPropiedades = ElementosMenus(
  "Propiedades",
  Symbols.person_search,
);
// Index 1: Propietarios (LandingPropietariosPage)
ElementosMenus iconoPropietarios = ElementosMenus(
  "Propietarios",
  Symbols.co_present,
);
ElementosMenus iconoHospedaje = ElementosMenus("Anfitriones", Symbols.key);
// Index 2: Agentes (LandingAgentesPage)
ElementosMenus iconoPromotores = ElementosMenus(
  "Promotores",
  Symbols.real_estate_agent,
);
// Index 6: Productos (LandingProductosPage02)
ElementosMenus iconoTienda = ElementosMenus("Tienda", Symbols.shopping_bag);

// Index 4: Servicios (LandingServiciosPage)
ElementosMenus iconoServicios = ElementosMenus("Servicios", Symbols.handyman);
// Index 5: Proveedores (LandingProveedoresPage01 - Hub de Aliados)
ElementosMenus iconoProveedores = ElementosMenus(
  "Proveedores",
  Symbols.storefront,
);
// Index 3: Asociaciones (LandingInmobiliariasPage)
ElementosMenus iconoAsociaciones = ElementosMenus(
  "Asociaciones",
  Symbols.groups,
);
// Index 3: Inmobiliarias (LandingInmobiliariasPage)
ElementosMenus iconoInmobiliarias = ElementosMenus(
  "Inmobiliarias",
  Symbols.domain,
);

// Menu Principal ---------------------------------------------------------------
// "Principal"
// "Casas"
// "Departamentos"
// "Otros inmuebles"
// "Localidad"
// "Perfil"
/*
List<ElementosMenus> elementosMenuPrincipal = [
  iconoTuCuenta,
  iconoCasas, // menu principal
  iconoDepartamentos,
  iconoOtrosInmuebles,
  iconoLocalidad,
  iconoPerfil,
];
*/
ElementosMenus iconoTuCuenta = ElementosMenus(
  "Mi cuenta",
  Symbols.account_circle,
);
ElementosMenus iconoTodasPropiedades = ElementosMenus(
  "Todas",
  Symbols.home_work,
);
ElementosMenus iconoPropiedades = ElementosMenus(
  "Propiedades",
  Symbols.home_work,
);
ElementosMenus iconoCasas = ElementosMenus("Casas", Symbols.house);
ElementosMenus iconoDepartamentos = ElementosMenus(
  "Departamentos",
  Symbols.apartment,
);
ElementosMenus iconoOtros = ElementosMenus("Otros", Symbols.warehouse);
ElementosMenus iconoUbicacion = ElementosMenus("Ubicación", Symbols.pin_drop);
ElementosMenus iconoPerfil = ElementosMenus("Perfil", Symbols.manage_accounts);
//------------------------------------------------------------------------------
ElementosMenus iconoTusPropiedades = ElementosMenus(
  "Mis Propiedades",
  Symbols.account_circle,
);
//------------------------------------------------------------------------------

ElementosMenus iconoPrincipal = ElementosMenus("Principal", Symbols.home);
ElementosMenus iconoMenu = ElementosMenus("Menu", Symbols.menu);

// Menu Inicial --------------------------------------
// "Casas"
// "Departamentos"
// "Oficinas"
// "Locales"
// "Terrenos"
// "Otros"

List<ElementosMenus> elementosMenuTipoDePropiedades = [
  iconoCasas,
  iconoDepartamentos,
  iconoOficinas,
  iconoLocales,
  iconoTerrenos,
  iconoOtrosInmuebles,
];
/*
ElementosMenus iconoCasas = ElementosMenus(
  "Casas",
  Symbols.house,
);
ElementosMenus iconoDepartamentos = ElementosMenus(
  "Departamentos",
  Symbols.apartment,
);
*/

ElementosMenus iconoOficinas = ElementosMenus("Oficinas", Symbols.business);
ElementosMenus iconoLocales = ElementosMenus("Locales", Symbols.warehouse);
ElementosMenus iconoTerrenos = ElementosMenus("Terrenos", Symbols.layers);
ElementosMenus iconoOtrosInmuebles = ElementosMenus("Otros", Symbols.warehouse);
// Menu de inicio -------------------------------------------------------------
/*List<ElementosMenus> elementosMenuTusPropiedades = [
  iconoTusPropiedades, // menu principal
  iconoTusGrupos,
  iconoTusConocidos,
];
*/
ElementosMenus iconoTusEspacios = ElementosMenus(
  "Mis Espacios",
  Symbols.account_circle,
);
ElementosMenus iconoTusListas = ElementosMenus("Mis Listas", Symbols.list);
ElementosMenus iconoTusGrupos = ElementosMenus("Mis Grupos", Symbols.group);
ElementosMenus iconoTusConocidos = ElementosMenus(
  "Mis Conocidos",
  Symbols.person,
);

List<String> etiquetasMenuTuCuenta = [
  "Espacios",
  "Listas",
  "Grupos", // menu principal
  "Conocidos",
];

// Menu de tipo de espacios -------------------------------------------------------------
/*
List<ElementosMenus> elementosMenuTipoDeEspacio = [
  iconoNormales, // menu principal
  iconoDestacados,
  iconoSuperdestacados,
  iconoOportunidades,
  iconoRemates,
];
*/
ElementosMenus iconoNormales = ElementosMenus(
  "Normales",
  // Symbols.add_shopping_cart,
  Symbols.ad_units,
);
ElementosMenus iconoDestacados = ElementosMenus("Destacados", Symbols.star);
ElementosMenus iconoSuperdestacados = ElementosMenus(
  "Superdestacados",
  Symbols.hotel_class,
);
ElementosMenus iconoOportunidades = ElementosMenus(
  "Oportunidades",
  Symbols.recommend,
);
ElementosMenus iconoRemates = ElementosMenus("Remates", Symbols.paid);
/*
List<String> etiquetasMenuTipoDeEspacio = [
  "Normales",
  "Destacados", // menu principal
  "Superdestacados",
  "Oportunidades",
  "Remates",
];
*/
// Menu de Casas --------------------------------------
/*
List<ElementosMenus> elementosMenuTipoDePublicacion = [
  iconoTodas,
  iconoVenta,
  iconoRenta,
  iconoVentaRenta,
  iconoTraspaso,
  iconoPreventa,
  // iconoBuscar
];
*/
ElementosMenus iconoTodas = ElementosMenus("Todas", Symbols.real_estate_agent);
ElementosMenus iconoVenta = ElementosMenus("Venta", Symbols.sell);
ElementosMenus iconoRenta = ElementosMenus("Renta", Symbols.key);
ElementosMenus iconoVentaRenta = ElementosMenus("Venta/Renta", Symbols.flip);
ElementosMenus iconoTraspaso = ElementosMenus(
  "Traspaso",
  Symbols.swap_horizontal_circle,
);

ElementosMenus iconoTodasSolid = ElementosMenus(
  "Todas",
  Symbols.real_estate_agent,
);
ElementosMenus iconoVentaSolid = ElementosMenus("Venta", Symbols.sell);
ElementosMenus iconoRentaSolid = ElementosMenus("Renta", Symbols.key);
ElementosMenus iconoVentaRentaSolid = ElementosMenus(
  "Venta/Renta",
  Symbols.flip,
);
ElementosMenus iconoTraspasoSolid = ElementosMenus(
  "Traspaso",
  Symbols.swap_horizontal_circle,
);
/*
ElementosMenus iconoPreventa = ElementosMenus(
  "Preventa",
  Symbols.deck,
);
*/
// Menu de Conocidos --------------------------------------
List<ElementosMenus> elementosMenuConocidos = [
  iconoConocidos, //
  iconoListaConocidos,
  iconoSolicitudConocido,
  iconoInvitacionConocido,
  iconoChat,
  // iconoBuscarConocido,
];

// Menu de Grupos --------------------------------------
List<ElementosMenus> elementosMenuGrupos = [
  iconoMenuGrupos, // menu principal
  iconoGrupos,
  iconoSolicitudGrupo,
  iconoInvitacionesGrupo,
  iconoEliminarGrupo,
  iconoBuscarGrupo,
];

// Menu de Solicitudes --------------------------------------
List<ElementosMenus> elementosMenuSolicitudes = [
  iconoSolicitud, // menu principal
  iconoSolicitudGrupo, // 2
  iconoInvitacionesGrupo, // 3
  iconoSolicitudConocido, // 6
  iconoInvitacionConocido, // 7
];

//-----------------------------------------------------------------------------
//- Conectividad ---------------------------------------------------------------

List<ElementosMenus> elementosConeccionAInternet = [
  iconoWiFi, // menu principal
  iconoNoWiFi,
];

ElementosMenus iconoWiFi = ElementosMenus("Conectado", Symbols.wifi);
ElementosMenus iconoNoWiFi = ElementosMenus("Sin conexión", Symbols.wifi_off);

//- Plataforma -----------------------------------------------------------------
/*
false, // android
    false, // fuchsia
    false, // iOS
    false, // linux
    false, // macOS
    false, // windows
    false, // No se pudo verificar
*/
List<ElementosMenus> elementosPlataforma = [
  iconoAndroid,
  iconoFuchsia,
  iconoIOS,
  iconoLinux,
  iconoMacOS,
  iconoWindows,
  iconoWeb,
];

ElementosMenus iconoAndroid = ElementosMenus("Android", Symbols.android);
ElementosMenus iconoFuchsia = ElementosMenus("Fuchsia", Symbols.computer);
ElementosMenus iconoIOS = ElementosMenus("IOs", Symbols.ios);
ElementosMenus iconoLinux = ElementosMenus("Linux", Symbols.laptop_windows);
ElementosMenus iconoMacOS = ElementosMenus("macOS", Symbols.ios);
ElementosMenus iconoWindows = ElementosMenus("Windows", Symbols.window);
ElementosMenus iconoWeb = ElementosMenus("Web", Symbols.web);

//------------------------------------------------------------------------------
// Menu Niveles de Gobierno
ElementosMenus iconoServiciosMunicipal = ElementosMenus(
  "Servicios Municipales",
  Symbols.home,
);
ElementosMenus iconoServiciosEstatal = ElementosMenus(
  "Servicios Estatales",
  Symbols.commute,
);
ElementosMenus iconoServiciosFederales = ElementosMenus(
  "Servicios Federales",
  Symbols.home,
);

ElementosMenus iconoSolucionarProblemas = ElementosMenus(
  "Solucionar problemas",
  Symbols.troubleshoot,
);
ElementosMenus iconoIdeas = ElementosMenus(
  "Ideas y recomendaciones",
  Symbols.tips_and_updates,
);
ElementosMenus iconoCalendario = ElementosMenus("Calendario", Symbols.today);
ElementosMenus iconoEstilo = ElementosMenus("Estilo", Symbols.style);
ElementosMenus iconoInformacion = ElementosMenus("Información", Symbols.info);

// Conocidos
ElementosMenus iconoListaConocidos = ElementosMenus(
  "Conocidos",
  Symbols.list_alt,
);
ElementosMenus iconoRed = ElementosMenus("Red", Symbols.hub);
ElementosMenus iconoPrivado = ElementosMenus("Privado", Symbols.lock_outline);
ElementosMenus iconoPublico = ElementosMenus("Público", Symbols.lock_open);

ElementosMenus iconoProblemas = ElementosMenus(
  "Problemas",
  Symbols.report_problem,
);
/*
ElementosMenus iconoServicios = ElementosMenus(
  "Servicios",
  //Symbols.contact_emergency,
  Symbols.check_box,
);
*/
ElementosMenus iconoReportes = ElementosMenus("Resportes", Symbols.report);
ElementosMenus iconoQuejas = ElementosMenus(
  "Quejas",
  Symbols.compass_calibration,
);
ElementosMenus iconoProyectos = ElementosMenus("Proyectos", Symbols.panorama);

ElementosMenus iconoMiCanal = ElementosMenus("Mi canal", Symbols.perm_identity);
//-----------------------------------------------------------------------------
//--- UBICACION ---------------------------------------------------------------
ElementosMenus iconoLocalidad = ElementosMenus(
  "Asentamiento",
  Symbols.location_on,
);
/*
List<ElementosMenus> elementoElementoMenuUbicacion = [
  iconoColonia,
  iconoCP,
  iconoMunicipio,
  iconoEstado,
  iconoNacional,
];
*/
ElementosMenus iconoColonia = ElementosMenus("Colonia", Symbols.location_on);
//ElementosMenus iconoColonia = ElementosMenus("Zona", Symbols.my_location);
ElementosMenus iconoCP = ElementosMenus("C.P.", Symbols.markunread_mailbox);
ElementosMenus iconoMunicipio = ElementosMenus(
  "Municipio",
  Symbols.account_balance,
);
ElementosMenus iconoEstado = ElementosMenus("Estado", Symbols.outlined_flag);
ElementosMenus iconoNacional = ElementosMenus("País", Symbols.flag_circle);
//------------------------------------------------------------------------------
ElementosMenus iconoMiLocalidad = ElementosMenus(
  "Ubicaciones",
  Symbols.person_pin_circle,
);

ElementosMenus iconoMapa = ElementosMenus("Mapa", Symbols.map);

//------------------------------------------------------------------------------
ElementosMenus iconoFiltro = ElementosMenus("Filtro", Symbols.filter_list);
ElementosMenus iconoNotificacion = ElementosMenus(
  "Notificación",
  Symbols.notifications,
);
ElementosMenus iconoNotificacionPendiente = ElementosMenus(
  "Notificación pendiente",
  Symbols.notifications_active,
);
ElementosMenus iconoBuscar = ElementosMenus("Buscar", Symbols.manage_search);
ElementosMenus iconoAyuda = ElementosMenus("Ayuda", Symbols.help);
ElementosMenus iconoContacto = ElementosMenus("Contacto", Symbols.forum);
ElementosMenus iconoCrear = ElementosMenus("Crear", Symbols.add);
ElementosMenus iconoComprarEspacio = ElementosMenus(
  "Comprar",
  Symbols.add_home_sharp,
);
//------------------------------------------------------------------------------
ElementosMenus iconoConUsuario = ElementosMenus(
  "Usuario",
  Symbols.account_circle,
);
ElementosMenus iconoSinCuenta = ElementosMenus(
  "Sin cuenta",
  Symbols.no_accounts,
);
/*
ElementosMenus iconoPerfil = ElementosMenus(
  "Perfil",
  Symbols.manage_accounts,
);
*/
//------------------------------------------------------------------------------

ElementosMenus iconoTemas = ElementosMenus("Temas", Symbols.library_books);
ElementosMenus iconoListas = ElementosMenus("Todas", Symbols.view_list);
ElementosMenus iconoFavoritos = ElementosMenus("Favoritos", Symbols.star);
ElementosMenus iconoVerDespues = ElementosMenus(
  "Ver despúes",
  Symbols.bookmark,
);
ElementosMenus iconoPreferencias = ElementosMenus(
  "Preferencias",
  Symbols.manage_accounts,
);
ElementosMenus iconoConfigurar = ElementosMenus("Configurar", Symbols.settings);
//------------------------------------------------------------------------------
ElementosMenus iconoUsuario = ElementosMenus("Usuario", Symbols.person);
// Menu de grupos
//---------------------------------------
ElementosMenus iconoMenuGrupos = ElementosMenus("Grupos", Symbols.groups);
ElementosMenus iconoGrupos = ElementosMenus("Grupos", Symbols.group);

ElementosMenus iconoAgregaGrupo = ElementosMenus("Crear", Symbols.group_add);
ElementosMenus iconoEliminarGrupo = ElementosMenus(
  "Grupos Eliminados",
  Symbols.group_remove,
);
ElementosMenus iconoBuscarGrupo = ElementosMenus("Buscar", Symbols.search);
// Menu de Solicitudes --------------------------------------
ElementosMenus iconoSolicitudGrupo = ElementosMenus(
  "Solicitudes a Grupos",
  Symbols.groups_2,
);
ElementosMenus iconoInvitacionesGrupo = ElementosMenus(
  "Invitaciones de Grupos",
  Symbols.group,
);
//******************************
ElementosMenus iconoSolicitudConocido = ElementosMenus(
  "Solicitudes",
  Symbols.contact_mail,
);
ElementosMenus iconoInvitacionConocido = ElementosMenus(
  "Invitaciones",
  Symbols.mail_outline,
);
ElementosMenus iconoSolicitud = ElementosMenus(
  "Solicitudes",
  Symbols.contact_mail,
);
ElementosMenus iconoChat = ElementosMenus("Chat", Symbols.chat);

//-----------------------------------------------------------------------------

ElementosMenus iconoInvitarConocido = ElementosMenus(
  "Invitar a conocido",
  Symbols.person_add,
);
ElementosMenus iconoAgregaConocido = ElementosMenus(
  "Agregar",
  Symbols.person_sharp,
);
ElementosMenus iconoEliminarConocido = ElementosMenus(
  "Eliminar",
  Symbols.person_remove,
);
ElementosMenus iconoBuscarConocido = ElementosMenus(
  "Buscar",
  Symbols.person_search,
);
ElementosMenus iconoConocidos = ElementosMenus(
  "Usuarios",
  Symbols.recent_actors,
);
ElementosMenus iconoMandarInvitacionConocido = ElementosMenus(
  "Enviar",
  Symbols.mark_email_read,
);

// group_remove
ElementosMenus iconoAceptadosGrupo = ElementosMenus(
  "Aceptados",
  Symbols.group_add_sharp,
);
ElementosMenus iconoRechazadosGrupo = ElementosMenus(
  "Rechazados",
  Symbols.group_off,
);
ElementosMenus iconoListaSolicitudes = ElementosMenus(
  "Todas",
  Symbols.view_list,
);
ElementosMenus iconoAceptarSolicitud = ElementosMenus(
  "Aceptados",
  Symbols.person_add,
);
ElementosMenus iconoRechazarSolicitud = ElementosMenus(
  "Rechazados",
  Symbols.person_off,
);
ElementosMenus iconoMandarInvitacionGrupo = ElementosMenus(
  "Enviar",
  Symbols.mark_email_read,
);
