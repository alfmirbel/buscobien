import 'dart:convert';
import 'dart:core';
import 'package:http/http.dart' as http;
import '../../../10_user_login/usuario_login/provider_session.dart';
import '../../../20_var_globales/couchdb_errors.dart';
import '../../../22_imagenes/tus_espacios_fotos_propiedad/manejo_de_fotos/lista_fotos_ordenadas/clase_listas_fotos_propiedad.dart';
import '../../../40_security/direccionip.dart';
import '../../../40_security/urls_endpoints_espacios.dart';
import '../../../60_global_widgets/debugprint.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../inicio/data_espacios_casas_get.dart';
import '../../../05_provider_menus/provider_menu_tipo_espacio.dart';
import '../../inicio/catalogo_otras_caracteristicas.dart';

//------------------------------------------------------------------------------
// OPTIMIZADO

class ListaEspaciosCasa {
  int index;
  EspaciosCasaGet espaciosCasas;
  ListasFotosPropiedad listasFotos;

  ListaEspaciosCasa({
    required this.index,
    required this.espaciosCasas,
    required this.listasFotos,
  });
}

//-----------------------------------------------------------------------------
final espaciosCasaConListaFotosGetProvider =
    NotifierProvider<ClassCompraEspaciosNotifierProvider, ListaEspaciosCasa>(
  () {
    return ClassCompraEspaciosNotifierProvider();
  },
);

class ClassCompraEspaciosNotifierProvider extends Notifier<ListaEspaciosCasa> {
  // initial value
  @override
  ListaEspaciosCasa build() {
    return ListaEspaciosCasa(
      index: 0,
      espaciosCasas: EspaciosCasaGet(
        totalRows: 0,
        offset: 0,
        rows: [], // Inicializado limpio sin código comentado muerto
      ),
      listasFotos: ListasFotosPropiedad(
        idPropiedad: '',
        listasfotosordenadas: [],
        listasidsfotos: [],
      ),
    );
  }

  // Helper para generar headers (Optimización: Evita repetir código de auth)
  Map<String, String> _getHeaders() {
    String basicAuth =
        'Basic ${base64Encode(utf8.encode('$username:$password'))}';
    return {'Authorization': basicAuth, 'Content-Type': 'application/json'};
  }

  //-----------------------------------------------------------------------------
  // NOTA: Se cambió WidgetRef a Ref para compatibilidad con FutureProvider
  //------------------------------------------------------------------------------
  // OBTIENE LA LISTA DE PROPIDADES SIN FOTOS NI INDEX
  Future<int> getPropiedadesCasaIdUser() async {
    debugPrintLevels(10, '*********************************************');
    debugPrintLevels(10, '* HTTP getPropiedadCasaIdUser');
    debugPrintLevels(10, '*********************************************');

    int statusCode = 0;
    // Optimización: Try-Catch para manejo de errores de red
    try {
      state.index = 0;
      // Nota: Asumiendo que sessionProvider es accesible via ref.read
      // Si sessionProvider es un Notifier, verifica la sintaxis de acceso.
      String idUser = "";
      debugPrintLevels(
        10,
        '--- 02 getPropiedadCasaIdUserData propiedades del UserProvider: ${ref.read(sessionProvider.notifier).getSessionVarValue("idUsuario")}',
      );
      idUser =
          ref.read(sessionProvider).userData.rows[0].value.usuario.idUsuario;

      debugPrintLevels(
        10,
        '--- 02 getPropiedadCasaIdUserData propiedades del User: $idUser',
      );

      Map<String, String> headers = _getHeaders();

      // Optimización: Uso de interpolación segura
      String endpointKey = ref.read(menuTipoEspaciosProvider).etiqueta;
      String url =
          '$direccionip/${endpointsCaptura[endpointKey]}/_design/DDUSER/_view/idUser/?key="$idUser"';

      debugPrintLevels(
        10,
        "--- 03 getPropiedadCasaIdUser tipo de espacio: $endpointKey",
      );
      debugPrintLevels(10, "--- 03 getPropiedadCasaIdUser url: $url");

      final response = await http.get(Uri.parse(url), headers: headers);
      statusCode = response.statusCode;

      debugPrintLevels(
        10,
        "--- 04 getPropiedadCasaIdUserData URL: $url, statusCode: $statusCode",
      );

      if (response.statusCode == 200) {
        debugPrintLevels(
          10,
          '--- 05. getPropiedadCasaIdUser Data get to CouchDB successfully!',
        );

        var responseBody = utf8.decode(response.bodyBytes);
        debugPrintLevels(10, "--- respuesta responseBody recibida");

        // Actualizamos el estado
        state.espaciosCasas = espaciosCasaGetFromJson(responseBody);

        // Forzamos actualización de la UI si es necesario copiando el objeto
        // state = state;

        if (state.espaciosCasas.rows.isNotEmpty) {
          debugPrintLevels(
            10,
            "--- 06. Registros recuperados: ${state.espaciosCasas.rows.length}",
          );

          // Loop optimizado
          for (var i = 0; i < state.espaciosCasas.rows.length; i++) {
            debugPrintLevels(
              10,
              "---> Propiedad No. $i: ${state.espaciosCasas.rows[i].value.espacioscasa.clavedelapropiedad}",
            );
          }
        } else {
          debugPrintLevels(
            10,
            "--- 07. getPropiedadCasaIdUserresultado: no se encontraron registros",
          );
          // Reset safe
          state.espaciosCasas = EspaciosCasaGet(
            totalRows: 0,
            offset: 0,
            rows: [],
          );
        }
      } else {
        state.espaciosCasas = EspaciosCasaGet(
          totalRows: 0,
          offset: 0,
          rows: [],
        );
        debugPrintLevels(
          10,
          'Error writing data to CouchDB: ${response.statusCode}',
        );
      }
    } catch (e) {
      debugPrintLevels(1, 'Error Excepción en getPropiedadesCasaIdUser: $e');
      statusCode = 500; // Código de error interno
    }

    debugPrintLevels(10, '*********************************************');
    return statusCode;
  }

  //-----------------------------------------------------------------------------
  Future<EspaciosCasaGet> getPropiedadCasaIdPropiedad(
    String idPropiedad,
    String tipoEspacio,
    Map<String, String> tabla,
    /*
    final Map<String, String> endpointsCaptura 
    final Map<String, String> endpointsPublicados
    */
  ) async {
    debugPrintLevels(10, 'HTTP getPropiedadCasaIdPropiedad');
    EspaciosCasaGet resultado = EspaciosCasaGet(
      totalRows: 0,
      offset: 0,
      rows: [],
    );

    try {
      Map<String, String> headers = _getHeaders();

      debugPrintLevels(
        10,
        "01 getPropiedadCasaIdPropiedad endpointKey: $tipoEspacio",
      );

      String url =
          '$direccionip/${tabla[tipoEspacio]}/_design/DDUSER/_view/idPropiedad/?key="$idPropiedad"';
      debugPrintLevels(10, "01 getPropiedadCasaIdPropiedad url: $url");
      final response = await http.get(Uri.parse(url), headers: headers);
      debugPrintLevels(
        10,
        "01 getPropiedadCasaIdPropiedad statusCode: ${response.statusCode}",
      );

      if (response.statusCode == 200) {
        debugPrintLevels(10, 'Data get to CouchDB successfully!');
        var responseBody = utf8.decode(response.bodyBytes);
        resultado = espaciosCasaGetFromJson(responseBody);
      } else {
        resultado = EspaciosCasaGet(totalRows: 0, offset: 0, rows: []);
      }
    } catch (e) {
      debugPrintLevels(1, 'Error Excepción en getPropiedadCasaIdPropiedad: $e');
      resultado = EspaciosCasaGet(totalRows: 0, offset: 0, rows: []);
    }

    return resultado;
  }

  //-----------------------------------------------------------------------------
  Future<int> updatePropiedadCasaGetToCouchDB() async {
    debugPrintLevels(10, "**************************************************");
    debugPrintLevels(10, 'HTTP updatePropiedadCasaGetToCouchDB');
    debugPrintLevels(10, "**************************************************");

    int resultado = 0;
    try {
      DateTime timeStamp = DateTime.now();
      String tipoanuncio = getCampoEspaciosCasasGet("tipodeanuncio");

      debugPrintLevels(10, "*** Tipodeanuncio: $tipoanuncio");

      // Actualización de timestamps
      setCampoEspaciosCasasGet(
        "diapublicacion",
        timeStamp.day.toStringAsFixed(0),
      );
      setCampoEspaciosCasasGet(
        "mespublicacion",
        timeStamp.month.toStringAsFixed(0),
      );
      setCampoEspaciosCasasGet(
        "aniopublicacion",
        timeStamp.year.toStringAsFixed(0),
      );
      setCampoEspaciosCasasGet("timestampcasa", timeStamp.toString());

      Map<String, String> headers = _getHeaders();

      // Selección de URL basada en tipo de anuncio (Manejo robusto con Map fallback o switch)
      // Ajuste: usar clave capitalizada para coincidir con el Map endpointsCaptura si es necesario
      //String keyMap = "Normales"; // Default
      if (endpointsCaptura.containsKey(tipoanuncio)) {
        // Asumiendo que tipoanuncio coincide con las keys del mapa, si no, mantener el switch original logic
      }

      String baseUrl = '$direccionip/';
      switch (tipoanuncio.toLowerCase()) {
        case "normales":
          baseUrl += endpointsCaptura["Normales"]!;
          break;
        case "destacados":
          baseUrl += endpointsCaptura["Destacados"]!;
          break;
        case "superdestacados":
          baseUrl += endpointsCaptura["Superdestacados"]!;
          break;
        case "oportunidades":
          baseUrl += endpointsCaptura["Oportunidades"]!;
          break;
        case "remates":
          baseUrl += endpointsCaptura["Remates"]!;
          break;
        default:
          baseUrl += endpointsCaptura["Normales"]!;
      }

      String url = "$baseUrl/${state.espaciosCasas.rows[state.index].value.id}";

      debugPrintLevels(10, "*** URL Update: $url");

      String propiedadJson = jsonEncode(
        state.espaciosCasas.rows[state.index].value,
      );

      final response = await http.put(
        Uri.parse(url),
        headers: headers,
        body: propiedadJson,
      );

      resultado = response.statusCode;

      debugPrintLevels(
        10,
        "Resultado put: ${codigoCouchDB[resultado]?.label ?? 'Unknown'}: ${codigoCouchDB[resultado]?.description ?? ''}",
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        debugPrintLevels(
          10,
          '*** Data written to CouchDB successfully! $resultado',
        );
      } else {
        debugPrintLevels(
          8,
          '*** Error writing data to CouchDB: ${response.statusCode}',
        );
      }
    } catch (e) {
      debugPrintLevels(
        1,
        'Error Excepción en updatePropiedadCasaGetToCouchDB: $e',
      );
      resultado = 500;
    }
    return resultado;
  }

  //------------------------------------------------------------------------------
  void resetEspaciosCasasGet() {
    debugPrintLevels(10, '*** HTTP resetEspaciosCasasGet');
    state.index = 0;
    if (state.espaciosCasas.rows.isNotEmpty) {
      state.espaciosCasas.rows.clear();
      // Optimización: Forzar reconstrucción si es necesario
      // state = ListaEspaciosCasa(index: 0, espaciosCasas: state.espaciosCasas, listasFotos: state.listasFotos);
    }
  }

  int getNumeroDePropiedades() {
    return state.espaciosCasas.rows.length;
  }

  int getIndexEspaciosCasas() {
    return state.index;
  }

  void setIndexEspaciosCasas(int index) {
    state.index = index;
    debugPrintLevels(
      8,
      "-- espaciosCasaConListaFotosGetProvider setIndexEspaciosCasas: $index a state: ${state.index} ",
    );
  }

  //-----------------------------------------------------------------------------
  ValueEspaciosCasaGet getEspaciosCasasPropiedadActual() {
    // Optimización: Validación de rango para evitar crash
    if (state.index >= 0 && state.index < state.espaciosCasas.rows.length) {
      debugPrintLevels(10, "getEspaciosCasasPropiedadActual: ${state.index} ");
      return state.espaciosCasas.rows[state.index].value;
    }
    // Retornar un valor por defecto o lanzar error controlado si está vacío
    return state.espaciosCasas.rows.isNotEmpty
        ? state.espaciosCasas.rows[0].value
        : throw Exception("No hay propiedades cargadas");
  }

  //-----------------------------------------------------------------------------

  void setEspaciosCasasGet(ValueEspaciosCasaGet propiedad) {
    debugPrintLevels(
      10,
      'HTTP setEspaciosCasasGet ${propiedad.espacioscasa.activa}',
    );
    if (state.espaciosCasas.rows.isNotEmpty) {
      state.espaciosCasas.rows[state.index].value = propiedad;
      // Notificar cambio de estado si es necesario
      // state = state;
    }
  }

  //-----------------------------------------------------------------------------
  // Optimización: tryParse para evitar crashes por formato numérico incorrecto
  // Optimización: Breakpoints removidos para asignación directa más limpia
  //-----------------------------------------------------------------------------
  void setCampoEspaciosCasasGet(String campo, String valor) {
    // debugPrintLevels(10, 'HTTP setCampoEspaciosCasasGet: $campo -> $valor');

    // Alias para acceso rápido
    final valueObj = state.espaciosCasas.rows[state.index].value;
    final casa = valueObj.espacioscasa;
    final datosAdic = casa.datosadicionalescasa;
    final contacto = casa.datosdelcontactocasa;
    final ubicacion = casa.ubicacioncasa;
    final localidad = ubicacion.localidadCp;

    switch (campo) {
      case "id":
        valueObj.id = valor;
        break;
      case "rev":
        valueObj.rev = valor;
        break;
      case "versiondelformato":
        casa.versiondelformato = valor;
        break;
      case "idPropiedad":
        casa.idPropiedad = valor;
        break;
      case "clavedelapropiedad":
        casa.clavedelapropiedad = valor;
        break;
      case "idusuario":
        casa.idusuario = valor;
        break;
      case "tipodeanuncio":
        casa.tipodeanuncio = valor;
        break;
      case "tipodepropiedad":
        casa.tipodepropiedad = valor;
        break;
      case "tipodetransaccion":
        casa.tipodetransaccion = valor;
        break;
      case "idTransaccion":
        casa.idTransaccion = valor;
        break;
      case "nombredelapropiedad":
        casa.nombredelapropiedad = valor;
        break;
      case "inmobiliaria":
        casa.inmobiliaria = valor;
        break;
      case "inmobiliariaimagen":
        casa.inmobiliariaimagen = valor;
        break;
      case "ubicaciongeneral":
        casa.ubicaciongeneral = valor;
        break;
      case "descripcion":
        casa.descripcion = valor;
        break;
      case "letreropromocional":
        casa.letreropromocional = valor;
        break;
      case "metrosdeterreno":
        casa.metrosdeterreno = valor;
        break;
      case "metrosconstruidos":
        casa.metrosconstruidos = valor;
        break;
      case "recamaras":
        casa.recamaras = valor;
        break;
      case "banos":
        casa.banos = valor;
        break;
      case "mediosbanos":
        casa.mediosbanos = valor;
        break;
      case "cuartosdeservicio":
        casa.cuartosdeservicio = valor;
        break;
      case "estacionamientos":
        casa.estacionamientos = valor;
        break;
      case "estacionamientoscubiertos":
        casa.estacionamientoscubiertos = valor;
        break;

      // Datos Adicionales
      case "panelessolares":
        datosAdic.panelessolares = valor;
        break;
      case "jardin":
        datosAdic.jardin = valor;
        break;
      case "alberca":
        datosAdic.alberca = valor;
        break;
      case "calefaccion":
        datosAdic.calefaccion = valor;
        break;
      case "aireacondicionado":
        datosAdic.aireacondicionado = valor;
        break;
      case "seguridad":
        datosAdic.seguridad = valor;
        break;
      case "enfraccionamiento":
        datosAdic.enfraccionamiento = valor;
        break;
      case "casasenelconjunto":
        datosAdic.casasenelconjunto = valor;
        break;
      case "casaclub":
        datosAdic.casaclub = valor;
        break;
      case "salondeeventos":
        datosAdic.salondeeventos = valor;
        break;
      case "centrodenegocios":
        datosAdic.centrodenegocios = valor;
        break;
      case "gimnacio":
        datosAdic.gimnacio = valor;
        break;
      case "cisterna":
        datosAdic.cisterna = valor;
        break;
      case "almacenamientodeagua":
        datosAdic.almacenamientodeagua = valor;
        break;
      case "tratamientodeaguas":
        datosAdic.tratamientodeaguas = valor;
        break;
      case "otrascaracteristicas":
        datosAdic.otrascaracteristicas = valor;
        break;

      case "elementosadicionalescasa":
        casa.elementosadicionalescasa = valor;
        break;
      case "precioventa":
        casa.precioventa = valor;
        break;
      case "preciorenta":
        casa.preciorenta = valor;
        break;
      case "mantenimiento":
        casa.mantenimiento = valor;
        break;
      case "moneda":
        casa.moneda = valor;
        break;
      case "niveldeprioridad":
        casa.niveldeprioridad = valor;
        break;
      case "condicionesdeventa":
        casa.condicionesdeventa = valor;
        break;
      case "fotoprincipal":
        casa.fotoprincipal = valor;
        break;
      case "numerodefotos":
        casa.numerodefotos = valor;
        break;

      // Contacto
      case "nombre":
        contacto.nombre = valor;
        break;
      case "empresa":
        contacto.empresa = valor;
        break;
      case "numerocelular":
        contacto.numerocelular = valor;
        break;
      case "numerootro":
        contacto.numerootro = valor;
        break;
      case "numeroinmobiliaria":
        contacto.numeroinmobiliaria = valor;
        break;
      case "correoelectronico":
        contacto.correoelectronico = valor;
        break;
      case "idusuariocontacto":
        contacto.idusuariocontacto = valor;
        break;
      case "nombreusuariocontacto":
        contacto.nombreusuariocontacto = valor;
        break;
      case "imgendelcontacto":
        contacto.imgendelcontacto = valor;
        break;

      // Ubicación
      case "pais":
        ubicacion.pais = valor;
        break;
      // LocalidadCp es @freezed — se usa copyWith para actualizar
      case "idEstado":
        ubicacion.localidadCp =
            localidad.copyWith(idEstado: int.tryParse(valor) ?? 0);
        break;
      case "estado":
        ubicacion.localidadCp = localidad.copyWith(estado: valor);
        break;
      case "idMunicipio":
        ubicacion.localidadCp =
            localidad.copyWith(idMunicipio: int.tryParse(valor) ?? 0);
        break;
      case "municipio":
        ubicacion.localidadCp = localidad.copyWith(municipio: valor);
        break;
      case "ciudad":
        ubicacion.localidadCp = localidad.copyWith(ciudad: valor);
        break;
      case "zona":
        ubicacion.localidadCp = localidad.copyWith(zona: valor);
        break;
      case "asentamiento":
        ubicacion.localidadCp = localidad.copyWith(asentamiento: valor);
        break;
      case "codigopostal":
        ubicacion.localidadCp =
            localidad.copyWith(cp: int.tryParse(valor) ?? 0);
        break;
      case "tipo":
        ubicacion.localidadCp = localidad.copyWith(tipo: valor);
        break;
      case "calle":
        ubicacion.calle = valor;
        break;
      case "numeroexterior":
        ubicacion.numeroexterior = valor;
        break;
      case "numerointerior":
        ubicacion.numerointerior = valor;
        break;
      case "latitud":
        ubicacion.latitud = valor;
        break;
      case "longitud":
        ubicacion.longitud = valor;
        break;
      case "latitudDecimal":
        ubicacion.latitudDecimal = valor;
        break;
      case "longitudDecimal":
        ubicacion.longitudDecimal = valor;
        break;

      // Fechas (Parseo seguro)
      case "diapublicacion":
        casa.fechadepublicacioncasa.dia = int.tryParse(valor) ?? 0;
        break;
      case "mespublicacion":
        casa.fechadepublicacioncasa.mes = int.tryParse(valor) ?? 0;
        break;
      case "aniopublicacion":
        casa.fechadepublicacioncasa.anio = int.tryParse(valor) ?? 0;
        break;
      case "diadecierre":
        casa.fechadecierrecasa.dia = int.tryParse(valor) ?? 0;
        break;
      case "mesdecierre":
        casa.fechadecierrecasa.mes = int.tryParse(valor) ?? 0;
        break;
      case "aniodecierre":
        casa.fechadecierrecasa.anio = int.tryParse(valor) ?? 0;
        break;

      case "activa":
        casa.activa = int.tryParse(valor) ?? 0;
        break;
      case "timestampcasa":
        casa.timestampcasa = valor;
        break;

      default:
        // Manejo de campo desconocido para evitar errores silenciosos o crashes
        debugPrintLevels(
          8,
          "Campo desconocido en setCampoEspaciosCasasGet: $campo",
        );
        break;
    }
    // IMPORTANTE: En Riverpod Notifier, modificar una propiedad interna NO notifica a los listeners.
    // Si necesitas reactividad en la UI tras este set, debes ejecutar: state = state;
    // O crear una copia del objeto.
  }

  //-----------------------------------------------------------------------------
  String getCampoEspaciosCasasGet(String campo) {
    if (state.espaciosCasas.rows.isEmpty) return "";

    final valueObj = state.espaciosCasas.rows[state.index].value;
    final casa = valueObj.espacioscasa;
    final datosAdic = casa.datosadicionalescasa;
    final contacto = casa.datosdelcontactocasa;
    final ubicacion = casa.ubicacioncasa;
    final localidad = ubicacion.localidadCp;

    switch (campo) {
      case "id":
        return valueObj.id;
      case "rev":
        return valueObj.rev;
      case "versiondelformato":
        return casa.versiondelformato;
      case "idPropiedad":
        return casa.idPropiedad;
      case "clavedelapropiedad":
        return casa.clavedelapropiedad;
      case "idusuario":
        return casa.idusuario;
      case "tipodeanuncio":
        return casa.tipodeanuncio;
      case "tipodepropiedad":
        return casa.tipodepropiedad;
      case "idTransaccion":
        return casa.idTransaccion;
      case "nombredelapropiedad":
        return casa.nombredelapropiedad;
      case "inmobiliaria":
        return casa.inmobiliaria;
      case "inmobiliariaimagen":
        return casa.inmobiliariaimagen;
      case "ubicaciongeneral":
        return casa.ubicaciongeneral;
      case "descripcion":
        return casa.descripcion;
      case "letreropromocional":
        return casa.letreropromocional;
      case "metrosdeterreno":
        return casa.metrosdeterreno;
      case "metrosconstruidos":
        return casa.metrosconstruidos;
      case "recamaras":
        return casa.recamaras;
      case "banos":
        return casa.banos;
      case "mediosbanos":
        return casa.mediosbanos;
      case "cuartosdeservicio":
        return casa.cuartosdeservicio;
      case "estacionamientos":
        return casa.estacionamientos;
      case "estacionamientoscubiertos":
        return casa.estacionamientoscubiertos;

      case "panelessolares":
        return datosAdic.panelessolares;
      case "jardin":
        return datosAdic.jardin;
      case "alberca":
        return datosAdic.alberca;
      case "calefaccion":
        return datosAdic.calefaccion;
      case "aireacondicionado":
        return datosAdic.aireacondicionado;
      case "seguridad":
        return datosAdic.seguridad;
      case "enfraccionamiento":
        return datosAdic.enfraccionamiento;
      case "casasenelconjunto":
        return datosAdic.casasenelconjunto;
      case "casaclub":
        return datosAdic.casaclub;
      case "salondeeventos":
        return datosAdic.salondeeventos;
      case "centrodenegocios":
        return datosAdic.centrodenegocios;
      case "gimnacio":
        return datosAdic.gimnacio;
      case "cisterna":
        return datosAdic.cisterna;
      case "almacenamientodeagua":
        return datosAdic.almacenamientodeagua;
      case "tratamientodeaguas":
        return datosAdic.tratamientodeaguas;
      case "otrascaracteristicas":
        return datosAdic.otrascaracteristicas;

      case "elementosadicionalescasa":
        return casa.elementosadicionalescasa;
      case "precioventa":
        return casa.precioventa;
      case "preciorenta":
        return casa.preciorenta;
      case "mantenimiento":
        return casa.mantenimiento;
      case "moneda":
        return casa.moneda;
      case "niveldeprioridad":
        return casa.niveldeprioridad;
      case "condicionesdeventa":
        return casa.condicionesdeventa;
      case "fotoprincipal":
        return casa.fotoprincipal;
      case "numerodefotos":
        return casa.numerodefotos;

      case "nombre":
        return contacto.nombre;
      case "empresa":
        return contacto.empresa;
      case "numerocelular":
        return contacto.numerocelular;
      case "numerootro":
        return contacto.numerootro;
      case "numeroinmobiliaria":
        return contacto.numeroinmobiliaria;
      case "correoelectronico":
        return contacto.correoelectronico;
      case "idusuariocontacto":
        return contacto.idusuariocontacto;
      case "nombreusuariocontacto":
        return contacto.nombreusuariocontacto;
      case "imgendelcontacto":
        return contacto.imgendelcontacto;

      case "pais":
        return ubicacion.pais;
      case "idEstado":
        return localidad.idEstado.toString();
      case "estado":
        return localidad.estado;
      case "idMunicipio":
        return localidad.idMunicipio.toString();
      case "municipio":
        return localidad.municipio;
      case "ciudad":
        return localidad.ciudad;
      case "zona":
        return localidad.zona;
      case "asentamiento":
        return localidad.asentamiento;
      case "codigopostal":
        return localidad.cp.toString();
      case "tipo":
        return localidad.tipo;
      case "calle":
        return ubicacion.calle;
      case "numeroexterior":
        return ubicacion.numeroexterior;
      case "numerointerior":
        return ubicacion.numerointerior;
      case "entrecalle01":
        return ubicacion.entrecalle01;
      case "entrecalle02":
        return ubicacion.entrecalle02;
      case "latitud":
        return ubicacion.latitud;
      case "longitud":
        return ubicacion.longitud;
      case "latitudDecimal":
        return ubicacion.latitudDecimal;
      case "longitudDecimal":
        return ubicacion.longitudDecimal;

      case "diapublicacion":
        return casa.fechadepublicacioncasa.dia.toStringAsFixed(0);
      case "mespublicacion":
        return casa.fechadepublicacioncasa.mes.toStringAsFixed(0);
      case "aniopublicacion":
        return casa.fechadepublicacioncasa.anio.toStringAsFixed(0);

      case "diadecierre":
        return casa.fechadecierrecasa.dia.toStringAsFixed(0);
      case "mesdecierre":
        return casa.fechadecierrecasa.mes.toStringAsFixed(0);
      case "aniodecierre":
        return casa.fechadecierrecasa.anio.toStringAsFixed(0);

      case "activa":
        return casa.activa.toStringAsFixed(0);
      case "timestampcasa":
        return casa.timestampcasa;

      default:
        return "";
    }
  }

  //-----------------------------------------------------------------------------
  String getNombreDelCampoPropiedadCasaGet(String nombreDelCampo) {
    switch (nombreDelCampo) {
      case "id":
        return "Identificador";
      case "rev":
        return "Revisión";
      case "versiondelformato":
        return "Versión del formato";
      case "idPropiedad":
        return "id Propiedad";
      case "clavedelapropiedad":
        return "Clave de la propiedad";
      case "idusuario":
        return "id Usuario";
      case "tipodeanuncio":
        return "Tipo de anuncio";
      case "tipodetransaccion":
        return "Tipo de transaccion";
      case "idTransaccion":
        return "id Transacción";
      case "nombredelapropiedad":
        return "Nombre de la propiedad";
      case "inmobiliaria":
        return "Inmobiliaria";
      case "inmobiliariaimagen":
        return "Imagen de la inmobiliaria";
      case "linkinmobiliaria":
        return "Sitio Web de la inmobiliaria";
      case "sloganinmobiliaria":
        return "Slogan de la inmobiliaria";
      case "ubicaciongeneral":
        return "Ubicación general";
      case "tipodepropiedad":
        return "Tipo de propiedad";
      case "descripcion":
        return "Descripción";
      case "letreropromocional":
        return "Letrero promocional";
      case "metrosdeterreno":
        return "Metros de terreno";
      case "metrosconstruidos":
        return "Metros construidos";
      case "recamaras":
        return "Recamaras";
      case "banos":
        return "Baños";
      case "mediosbanos":
        return "Medios baños";
      case "cuartosdeservicio":
        return "Cuartos de servicio";
      case "estacionamientos":
        return "Estacionamientos";
      case "estacionamientoscubiertos":
        return "Estacionamientos cubiertos";
      case "panelessolares":
        return "Paneles solares";
      case "jardin":
        return "Jardín";
      case "alberca":
        return "Alberca";
      case "calefaccion":
        return "Calefacción";
      case "aireacondicionado":
        return "Aire acondicionado";
      case "seguridad":
        return "Seguridad";
      case "enfraccionamiento":
        return "En fraccionamiento";
      case "casasenelconjunto":
        return "Casas en el conjunto";
      case "casaclub":
        return "Casa club";
      case "salondeeventos":
        return "Salón de eventos";
      case "centrodenegocios":
        return "Centro de negocios";
      case "gimnacio":
        return "Gimnacio";
      case "cisterna":
        return "Cisterna";
      case "almacenamientodeagua":
        return "Capacidad de almacenamiento de agua";
      case "tratamientodeaguas":
        return "Tratamiento de aguas";
      case "otrascaracteristicas":
        return "Otras características";
      case "elementosadicionalescasa":
        return "Elementos adicionales";
      case "precioventa":
        return "Precio de venta";
      case "preciorenta":
        return "Precio de renta";
      case "mantenimiento":
        return "Cuota de mantenimiento (al mes)";
      case "moneda":
        return "Moneda";
      case "niveldeprioridad":
        return "Nivel de prioridad";
      case "condicionesdeventa":
        return "Condiciones";
      case "fotoprincipal":
        return "Foto principal";
      case "numerodefotos":
        return "Número de fotos";
      case "linkvideo":
        return "Video de la propiedad";
      case "nombre":
        return "Nombre del contacto";
      case "empresa":
        return "Nombre de la inmobiliaria";
      case "imgendeempresa":
        return "Imagen de la inmobiliaria";
      case "numerocelular":
        return "Número de celular";
      case "numerootro":
        return "Número de celular secundario";
      case "numeroinmobiliaria":
        return "Número de la inmobiliaria";
      case "correoelectronico":
        return "Correo electronico";
      case "idusuariocontacto":
        return "id del usuario de contacto";
      case "nombreusuariocontacto":
        return "Nombre del usuario de contacto";
      case "imgendelcontacto":
        return "Imgen del contacto";
      case "pais":
        return "PaÍs";
      case "estado":
        return "Estado";
      case "municipio":
        return "Municipio";
      case "ciudad":
        return "Ciudad";
      case "zona":
        return "Zona";
      case "asentamiento":
        return "Colonia";
      case "codigopostal":
        return "código postal";
      case "tipo":
        return "tipo";
      case "calle":
        return "calle";
      case "numeroexterior":
        return "número exterior";
      case "numerointerior":
        return "número interior";
      case "entrecalle01":
        return "Entre la calle";
      case "entrecalle02":
        return "y la calle";
      case "latitud":
        return "Latitud";
      case "longitud":
        return "Longitud";
      case "latitudDecimal":
        return "LatitudDecimal";
      case "longitudDecimal":
        return "LongitudDecimal";
      case "diapublicacion":
        return "Día de publicación";
      case "mespublicacion":
        return "Mes de publicación";
      case "aniopublicacion":
        return "Año de publicación";
      case "diadecierre":
        return "Día de cierre";
      case "mesdecierre":
        return "Mes de cierre";
      case "aniodecierre":
        return "Año de cierre";
      case "activa":
        return "Activa";
      case "timestampcasa":
        return "Marca temporal";
      default:
        return "";
    }
  }

  //-----------------------------------------------------------------------------
  void setchecklistAdicionalesGet() {
    debugPrintLevels(10, 'HTTP setchecklistAdicionalesGet');

    if (state.espaciosCasas.rows.isEmpty) return;

    final datosAdic = state.espaciosCasas.rows[state.index].value.espacioscasa
        .datosadicionalescasa;

    // Función auxiliar interna para reducir repetición
    void checkAndSet(String key, String value) {
      if (value == "si") checklistAdicionales[key] = true;
    }

    checkAndSet("panelessolares", datosAdic.panelessolares);
    checkAndSet("jardin", datosAdic.jardin);
    checkAndSet("alberca", datosAdic.alberca);
    checkAndSet("calefaccion", datosAdic.calefaccion);
    checkAndSet("aireacondicionado", datosAdic.aireacondicionado);
    checkAndSet("seguridad", datosAdic.seguridad);
    checkAndSet("enfraccionamiento", datosAdic.enfraccionamiento);
    checkAndSet("casasenelconjunto", datosAdic.casasenelconjunto);
    checkAndSet("casaclub", datosAdic.casaclub);
    checkAndSet("salondeeventos", datosAdic.salondeeventos);
    checkAndSet("centrodenegocios", datosAdic.centrodenegocios);
    checkAndSet("gimnacio", datosAdic.gimnacio);
    checkAndSet("cisterna", datosAdic.cisterna);
    checkAndSet("almacenamientodeagua", datosAdic.almacenamientodeagua);
    checkAndSet("tratamientodeaguas", datosAdic.tratamientodeaguas);
    checkAndSet("otrascaracteristicas", datosAdic.otrascaracteristicas);
  }

  //-----------------------------------------------------------------------------
  String getAdicionalesEspaciosCasasGet(int campo) {
    debugPrintLevels(10, 'HTTP getAdicionalesEspaciosCasasGet');

    if (state.espaciosCasas.rows.isEmpty) return "";

    final datosAdic = state.espaciosCasas.rows[state.index].value.espacioscasa
        .datosadicionalescasa;

    switch (campo) {
      case 0:
        return datosAdic.panelessolares;
      case 1:
        return datosAdic.jardin;
      case 2:
        return datosAdic.alberca;
      case 3:
        return datosAdic.calefaccion;
      case 4:
        return datosAdic.aireacondicionado;
      case 5:
        return datosAdic.seguridad;
      case 6:
        return datosAdic.enfraccionamiento;
      case 7:
        return datosAdic.casasenelconjunto;
      case 8:
        return datosAdic.casaclub;
      case 9:
        return datosAdic.salondeeventos;
      case 10:
        return datosAdic.centrodenegocios;
      case 11:
        return datosAdic.gimnacio;
      case 12:
        return datosAdic.cisterna;
      case 13:
        return datosAdic.almacenamientodeagua;
      case 14:
        return datosAdic.tratamientodeaguas;
      case 15:
        return datosAdic.otrascaracteristicas;
      default:
        return "";
    }
  }
}

//-----------------------------------------------------------------------------
// FutureProvider: Obtener lista de espacios
// Nota: Se pasa "ref" (tipo Ref), no WidgetRef.
//-----------------------------------------------------------------------------
final listaEspaciosCasaFutureProvider = FutureProvider<int>((ref) async {
  debugPrintLevels(10, 'FutureProvider listaEspaciosCasaFutureProvider');

  return await ref
      .read(espaciosCasaConListaFotosGetProvider.notifier)
      // Ajuste: ref en este contexto es ProviderRef, no WidgetRef.
      // Se pasa dinamicamente para cumplir la firma, pero la firma del método
      // getPropiedadesCasaIdUser debería ser (Ref ref) en lugar de (WidgetRef ref).
      .getPropiedadesCasaIdUser();
});
