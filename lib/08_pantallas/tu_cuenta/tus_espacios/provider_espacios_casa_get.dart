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
      idUser = ref
          .read(sessionProvider)
          .userData
          .rows[0]
          .value
          .usuario
          .idUsuario;

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
        ubicacion.localidadCp = localidad.copyWith(idEstado: int.tryParse(valor) ?? 0);
        break;
      case "estado":
        ubicacion.localidadCp = localidad.copyWith(estado: valor);
        break;
      case "idMunicipio":
        ubicacion.localidadCp = localidad.copyWith(idMunicipio: int.tryParse(valor) ?? 0);
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
        ubicacion.localidadCp = localidad.copyWith(cp: int.tryParse(valor) ?? 0);
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

    final datosAdic = state
        .espaciosCasas
        .rows[state.index]
        .value
        .espacioscasa
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

    final datosAdic = state
        .espaciosCasas
        .rows[state.index]
        .value
        .espacioscasa
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



//------------------------------------------------------------------------------
/*
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
        rows: [
          /*  RowEspaciosCasaGet(
          id: "",
          key: "",
          value: ValueEspaciosCasaGet(
            id: "",
            rev: "",
            espacioscasa: EspaciosCasa(
              versiondelformato: "01.00",
              idPropiedad: "",
              clavedelapropiedad: "",
              idusuario: "",
              tipodeanuncio: "",
              tipodepropiedad: "",
              idTransaccion: "",
              nombredelapropiedad: "",
              inmobiliaria: "",
              inmobiliariaimagen: "",
              ubicaciongeneral: "",
              descripcion: "",
              letreropromocional: "",
              metrosdeterreno: "",
              metrosconstruidos: "",
              recamaras: "",
              banos: "",
              mediosbanos: "",
              cuartosdeservicio: "",
              estacionamientos: "",
              estacionamientoscubiertos: "",
              datosadicionalescasa: Datosadicionalescasa(
                panelessolares: "",
                jardin: "",
                alberca: "",
                calefaccion: "",
                aireacondicionado: "",
                seguridad: "",
                enfraccionamiento: "",
                casasenelconjunto: "",
                casaclub: "",
                salondeeventos: "",
                centrodenegocios: "",
                gimnacio: "",
                cisterna: "",
                almacenamientodeagua: "",
                tratamientodeaguas: "",
                otrascaracteristicas: "",
              ),
              elementosadicionalescasa: "",
              precio: "",
              mantenimiento: "",
              moneda: "",
              niveldeprioridad: "",
              condicionesdeventa: "",
              fotoprincipal: "",
              numerodefotos: "",
              datosdelcontactocasa: Datosdelcontactocasa(
                nombre: "Juan Alfonso Mireles Belmonte",
                empresa: "",
                numerocelular: "5529553701",
                numerootro: "5529553701",
                numeroinmobiliaria: "5529553701",
                correoelectronico: "amirelesb@gmail.com",
                idusuariocontacto: "",
                nombreusuariocontacto: "",
                imgendelcontacto: "",
              ),
              ubicacioncasa: Ubicacioncasa(
                  pais: "",
                  localidadCp: LocalidadCp(
                    idEstado: 0,
                    estado: "",
                    idMunicipio: 0,
                    municipio: "",
                    ciudad: "",
                    zona: "",
                    cp: 0,
                    asentamiento: "",
                    tipo: "",
                  ),
                  calle: "",
                  numeroexterior: "",
                  numerointerior: "",
                  entrecalle01: "",
                  entrecalle02: "",
                  latitud: "",
                  longitud: "",
                  latitudDecimal: "",
                  longitudDecimal: ""),
              fechadepublicacioncasa: Fechadecasa(dia: 0, mes: 0, anio: 0),
              fechadecierrecasa: Fechadecasa(dia: 0, mes: 0, anio: 0),
              activa: 1,
              timestampcasa: "",
            ),
          ),
        ),
      */
        ],
      ),
      listasFotos: ListasFotosPropiedad(
        idPropiedad: '',
        listasfotosordenadas: [],
        listasidsfotos: [],
      ),
    );
  }

  //-----------------------------------------------------------------------------
  //------------------------------------------------------------------------------
  Future<int> getPropiedadesCasaIdUser(WidgetRef ref) async {
    debugPrintLevels(10, '*********************************************');
    debugPrintLevels(10, '* HTTP getPropiedadCasaIdUser');
    debugPrintLevels(10, '*********************************************');

    int statusCode = 0;
    state.index = 0;
    String idUser = ref
        .read(sessionProvider.notifier)
        .getCampoIdUserPass("idUsuario");

    debugPrintLevels(
      10,
      '--- 02 getPropiedadCasaIdUserData propiedades del User: $idUser',
    );

    String basicAuth =
        'Basic ${base64Encode(utf8.encode('$username:$password'))}';
    Map<String, String> headers = {
      'Authorization': basicAuth,
      'Content-Type': 'application/json',
    };

    String url =
        '$direccionip/${endpointsCaptura[ref.read(menuTipoEspaciosProvider).etiqueta]}/_design/DDUSER/_view/idUser/?key="$idUser"';

    debugPrintLevels(
      10,
      "--- 03 getPropiedadCasaIdUser tipo de especio: ${ref.read(menuTipoEspaciosProvider).etiqueta}",
    );
    /*
    switch (ref.read(menuTipoEspaciosProvider).etiqueta.toLowerCase()) {
      case "normales":
        url =
            '$direccionip/${endpointsCaptura[0]}/_design/DDUSER/_view/idUser/?key="$idUser"';
        break;
      case "destacados":
        url =
            '$direccionip/${endpointsCaptura[1]}/_design/DDUSER/_view/idUser/?key="$idUser"';
        break;
      case "superdestacados":
        url =
            '$direccionip/${endpointsCaptura[2]}/_design/DDUSER/_view/idUser/?key="$idUser"';
        break;
      case "oportunidades":
        url =
            '$direccionip/${endpointsCaptura[3]}/_design/DDUSER/_view/idUser/?key="$idUser"';
        break;
      case "remates":
        url =
            '$direccionip/${endpointsCaptura[4]}/_design/DDUSER/_view/idUser/?key="$idUser"';
        break;
      default:
    }
    */
    debugPrintLevels(10, "--- 03 getPropiedadCasaIdUser url: $url");

    final response = await http.get(Uri.parse(url), headers: headers);
    statusCode = response.statusCode;

    debugPrintLevels(
      10,
      "--- 04 getPropiedadCasaIdUserData URL: $url, statusCode: $statusCode",
    );

    // ignore: prefer_is_empty
    if ((response.statusCode == 200)) {
      debugPrintLevels(
        10,
        '--- 05. getPropiedadCasaIdUser Data get to CouchDB successfully!',
      );

      var responseBody = utf8.decode(response.bodyBytes);
      // EspaciosCasaGet futureResponse = espaciosCasaGetFromJson(responseBody);
      debugPrintLevels(10, "--- respuesta responseBody ");

      state.espaciosCasas = espaciosCasaGetFromJson(responseBody);

      if (state.espaciosCasas.rows.isNotEmpty) {
        debugPrintLevels(
          10,
          "--- 06. getPropiedadCasaIdUserresultado, recuoera datos de espacios: ${state.espaciosCasas.rows.length.toString()}",
        );

        for (var i = 0; i < state.espaciosCasas.rows.length; i++) {
          debugPrintLevels(
            10,
            "---> getPropiedadCasaIdUser Clave Propiedad No. $i: ${state.espaciosCasas.rows[i].value.espacioscasa.clavedelapropiedad}",
          );
        }
      } else {
        debugPrintLevels(
          10,
          "--- 07. getPropiedadCasaIdUserresultado: no se encontraron registros",
        );
        state.espaciosCasas = EspaciosCasaGet(
          totalRows: 0,
          offset: 0,
          rows: [],
        );
      }
    } else {
      state.espaciosCasas = EspaciosCasaGet(totalRows: 0, offset: 0, rows: []);
      debugPrintLevels(
        10,
        'Error writing data to CouchDB: ${response.statusCode}',
      );
    }
    //---------------
    debugPrintLevels(10, '*********************************************');
    return statusCode;
  }

  //-----------------------------------------------------------------------------
  Future<EspaciosCasaGet> getPropiedadCasaIdPropiedad(
    String idPropiedad,
  ) async {
    debugPrintLevels(10, 'HTTP getPropiedadCasaIdPropiedad');

    EspaciosCasaGet resultado;

    String basicAuth =
        'Basic ${base64Encode(utf8.encode('$username:$password'))}';
    Map<String, String> headers = {
      'Authorization': basicAuth,
      'Content-Type': 'application/json',
    };

    String url =
        '$direccionip/${endpointsCaptura[ref.read(menuTipoEspaciosProvider).etiqueta]}/_design/DDIDP/_view/idPropiedad/?key="$idPropiedad"';
    /*
    switch (ref.read(menuTipoEspaciosProvider).etiqueta.toLowerCase()) {
      case "normales":
        url =
            '$direccionip/${endpointsCaptura[0]}/_design/DDIDP/_view/idPropiedad/?key="$idPropiedad"';
        break;
      case "destacados":
        url =
            '$direccionip/${endpointsCaptura[1]}/_design/DDIDP/_view/idPropiedad/?key="$idPropiedad"';
      case "superdestacados":
        url =
            '$direccionip/${endpointsCaptura[2]}/_design/DDIDP/_view/idPropiedad/?key="$idPropiedad"';
        break;
      case "oportunidades":
        url =
            '$direccionip/${endpointsCaptura[3]}/_design/DDIDP/_view/idPropiedad/?key="$idPropiedad"';
        break;
      case "remates":
        url =
            '$direccionip/${endpointsCaptura[4]}/_design/DDIDP/_view/idPropiedad/?key="$idPropiedad"';
        break;
      default:
    }
*/
    final response = await http.get(Uri.parse(url), headers: headers);
    debugPrintLevels(
      0,
      "01 getPropiedadCasaIdPropiedad: ${response.statusCode}",
    );

    if (response.statusCode == 200) {
      debugPrintLevels(10, 'Data get to CouchDB successfully!');

      var responseBody = utf8.decode(response.bodyBytes);
      resultado = espaciosCasaGetFromJson(responseBody);
    } else {
      resultado = EspaciosCasaGet(totalRows: 0, offset: 0, rows: []);
      // //debugPrintLevels(10, 'Error writing data to CouchDB: ${response.statusCode}');
    }
    //---------------
    return resultado;
  }

  //-----------------------------------------------------------------------------

  Future<int> updatePropiedadCasaGetToCouchDB() async {
    debugPrintLevels(10, "**************************************************");
    debugPrintLevels(10, 'HTTP updatePropiedadCasaGetToCouchDB');
    debugPrintLevels(10, "**************************************************");

    int resultado = 0;
    DateTime timeStamp = DateTime.now();
    //
    String propiedadJson = "";
    String tipoanuncio = getCampoEspaciosCasasGet("tipodeanuncio");
    //
    debugPrintLevels(
      10,
      "*** updatePropiedadCasaGetToCouchDB getCampoEspaciosCasasGet tipodeanuncio: $tipoanuncio",
    );

    // debugPrintLevels(10, "IP: ${future.clientIp.toString()}");
    // //debugPrintLevels(10, "Date Time: ${future.datetime.toString()}");
    // ----------------------------------------------------------------------------
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
    setCampoEspaciosCasasGet("activa", "0");
    setCampoEspaciosCasasGet("timestampcasa", timeStamp.toString());
    //-----------------------------------------------------------------------------

    String basicAuth =
        'Basic ${base64Encode(utf8.encode('$username:$password'))}';

    Map<String, String> headers = {
      'Authorization': basicAuth,
      'Content-Type': 'application/json',
    };
    //-----------------------------------------------------------------------------
    String url = '$direccionip/${endpointsCaptura["Normales"]}';

    switch (tipoanuncio) {
      case "normales":
        url = '$direccionip/${endpointsCaptura["Normales"]}';
        break;
      case "destacados":
        url = '$direccionip/${endpointsCaptura["Destacados"]}';
        break;
      case "superdestacados":
        url = '$direccionip/${endpointsCaptura["Superdestacados"]}';
        break;
      case "oportunidades":
        url = '$direccionip/${endpointsCaptura["Oportunidades"]}';
        break;
      case "remates":
        url = '$direccionip/${endpointsCaptura["Remates"]}';
        break;
      default:
    }

    url = "$url/${state.espaciosCasas.rows[state.index].value.id}";
    debugPrintLevels(10, "**************************************************");
    debugPrintLevels(10, "*** updatePropiedadCasaGetToCouchDB url: $url");
    debugPrintLevels(10, "**************************************************");

    debugPrintLevels(10, "**************************************************");
    propiedadJson = jsonEncode(state.espaciosCasas.rows[state.index].value);
    debugPrintLevels(
      10,
      "*** updatePropiedadCasaGetToCouchDB propiedad: $propiedadJson",
    );
    debugPrintLevels(10, "**************************************************");
    final response = await http.put(
      Uri.parse(url),
      headers: headers,
      body: propiedadJson,
    );
    resultado = response.statusCode;
    //debugPrintLevels(10, "**************************************************");
    debugPrintLevels(
      10,
      "Resultado put: ${codigoCouchDB[resultado]?.label}: ${codigoCouchDB[resultado]?.description}",
    );
    //debugPrintLevels(10, "**************************************************");
    resultado = response.statusCode;
    if (response.statusCode == 201) {
      //debugPrintLevels(10, "**************************************************");
      debugPrintLevels(
        10,
        '*** updatePropiedadCasaGetToCouchDB Data written to CouchDB successfully! $resultado',
      );
      //debugPrintLevels(10, "**************************************************");
    } else {
      //debugPrintLevels(10, "**************************************************");
      debugPrintLevels(
        8,
        '*** updatePropiedadCasaGetToCouchDB Error writing data to CouchDB: ${response.statusCode}',
      );
      //debugPrintLevels(10, "**************************************************");
    }
    //---------------
    return resultado;
  }

  /*
//-----------------------------------------------------------------------------
  Future<int> updateFotoPrincipalPropiedad(
      String idFoto, ValueEspaciosCasaGet propiedad) async {
    debugPrintLevels(10, '*******************************************');
    debugPrintLevels(10, 'HTTP updateFotoPrincipalPropiedad');
    debugPrintLevels(10, '*******************************************');

    int resultado = 0;
    DateTime timeStamp = DateTime.now();
    //
    String tipoanuncio = propiedad.espacioscasa.tipodeanuncio;
    //
    debugPrintLevels(
        10, "*** updateFotoPrincipalPropiedad tipodeanuncio: $tipoanuncio");

    // debugPrintLevels(10, "IP: ${future.clientIp.toString()}");
    // //debugPrintLevels(10, "Date Time: ${future.datetime.toString()}");
    // ----------------------------------------------------------------------------
    propiedad.espacioscasa.fechadepublicacioncasa.dia = timeStamp.day;
    propiedad.espacioscasa.fechadepublicacioncasa.mes = timeStamp.month;
    propiedad.espacioscasa.fechadepublicacioncasa.anio = timeStamp.year;
    propiedad.espacioscasa.activa = 0;
    propiedad.espacioscasa.timestampcasa = timeStamp.toString();
    //-----------------------------------------------------------------------------
    propiedad.espacioscasa.fotoprincipal = idFoto;
    debugPrintLevels(10, "*** updateFotoPrincipalPropiedad idFoto: $idFoto");
    //-----------------------------------------------------------------------------

    String basicAuth =
        'Basic ${base64Encode(utf8.encode('$username:$password'))}';
    Map<String, String> headers = {
      'Authorization': basicAuth,
      'Content-Type': 'application/json',
    };
    //-----------------------------------------------------------------------------
    String url = "";

    switch (tipoanuncio) {
      case "normales":
        url = '$direccionip/buscobien_casas_comprados_normal';
        break;
      case "destacados":
        url = '$direccionip/buscobien_casas_comprados_destacado';
        break;
      case "superdestacados":
        url = '$direccionip/buscobien_casas_comprados_super';
        break;
      case "oportunidades":
        url = '$direccionip/buscobien_casas_comprados_oportunidad';
        break;
      case "remates":
        url = '$direccionip/buscobien_casas_comprados_remate';
        break;
      default:
    }

    url = "$url/${propiedad.id}";
    //debugPrintLevels(10, "**************************************************");
    debugPrintLevels(10, "*** updateFotoPrincipalPropiedad url: $url");
    //debugPrintLevels(10, "**************************************************");

    String propiedadJson = jsonEncode(propiedad);

    debugPrintLevels(10,
        "*** updateFotoPrincipalPropiedad propiedad length: $propiedadJson");
    //debugPrintLevels(10, "**************************************************");
    await http.put(Uri.parse(url), headers: headers, body: propiedadJson).then(
      (response) {
        resultado = response.statusCode;
        debugPrintLevels(10, "Respuesta: $resultado");
        debugPrintLevels(
            10, "**************************************************");

        debugPrintLevels(10,
            "Resultado put: ${codigoCouchDB[resultado]?.label}: ${codigoCouchDB[resultado]?.description}");
        debugPrintLevels(
            10, "**************************************************");
        resultado = response.statusCode;
        if (response.statusCode == 201) {
          //debugPrintLevels(10, "**************************************************");
          debugPrintLevels(10,
              '*** updatePropiedadCasaGetToCouchDB Data written to CouchDB successfully! $resultado');
          //debugPrintLevels(10, "**************************************************");
        } else {
          //debugPrintLevels(10, "**************************************************");
          debugPrintLevels(8,
              '*** updatePropiedadCasaGetToCouchDB Error writing data to CouchDB: ${response.statusCode}');
          //debugPrintLevels(10, "**************************************************");
        }
      },
    );

    //---------------
    debugPrintLevels(10, '*******************************************');
    return resultado;
  }
*/
  //-----------------------------------------------------------------------------
  //------------------------------------------------------------------------------
  /*
  Future<int> writePropiedadCasaToCouchDB() async {
    debugPrintLevels(10, 'HTTP writePropiedadCasaToCouchDB');

    int resultado = 0;
//  EspaciosCasa propiedad
    EspaciosCasa propiedad =
        state.espaciosCasas.rows[state.index].value.espacioscasa;
    DateTime timeStamp = DateTime.now();
//
    String propiedadJson = "";
//
    // debugPrintLevels(10, "IP: ${future.clientIp.toString()}");
    // debugPrintLevels(10, "Date Time: ${future.datetime.toString()}");

    String idDeLaPropiedad = generateSHA1Hash(
        getCampoEspaciosCasasGet("idTransaccion") +
            timeStamp.toString() +
            Random().nextInt(2500).toString());
    setCampoEspaciosCasasGet("idPropiedad", idDeLaPropiedad);

    //debugPrintLevels(10, "writePropiedadCasaToCouchDB idPropiedad $idDeLaPropiedad");
// ----------------------------------------------------------------------------
    final varEspaciosCasasGetProvider = ref
        .read(espaciosCasaConListaFotosGetProvider)
        .espaciosCasas
        .rows[state.index]
        .value
        .espacioscasa;

    String clavepropiedad =
        varEspaciosCasasGetProvider.idPropiedad.substring(1, 2);
    clavepropiedad += varEspaciosCasasGetProvider.idPropiedad.substring(5, 6);
    clavepropiedad += varEspaciosCasasGetProvider.idPropiedad.substring(10, 11);
    clavepropiedad += varEspaciosCasasGetProvider.idPropiedad.substring(15, 16);
    clavepropiedad += varEspaciosCasasGetProvider.idPropiedad.substring(20, 21);
    clavepropiedad += varEspaciosCasasGetProvider.idPropiedad.substring(25, 26);
    clavepropiedad += varEspaciosCasasGetProvider.idPropiedad.substring(30, 31);
    clavepropiedad += varEspaciosCasasGetProvider.idPropiedad.substring(35, 36);

    setCampoEspaciosCasasGet("clavedelapropiedad", clavepropiedad);
    setCampoEspaciosCasasGet(
        "diapublicacion", timeStamp.day.toStringAsFixed(0));
    setCampoEspaciosCasasGet(
        "mespublicacion", timeStamp.month.toStringAsFixed(0));
    setCampoEspaciosCasasGet(
        "aniopublicacion", timeStamp.year.toStringAsFixed(0));
    setCampoEspaciosCasasGet("activa", "1");
    setCampoEspaciosCasasGet("timestampcasa", timeStamp.toString());
//-----------------------------------------------------------------------------
    propiedadJson = '{"espacioscasa": ${espaciosCasaToJson(propiedad)}}';
    // propiedadJson = espaciosCasaToJson(propiedad);

    String basicAuth =
        'Basic ${base64Encode(utf8.encode('$username:$password'))}';
    Map<String, String> headers = {
      'Authorization': basicAuth,
      'Content-Type': 'application/json',
    };
//-----------------------------------------------------------------------------
    String url = "";
    await http
        .post(Uri.parse(url), headers: headers, body: propiedadJson)
        .then((response) {
      resultado = response.statusCode;
      if (response.statusCode == 201) {
        debugPrintLevels(
            10, 'Data written to CouchDB successfully! $resultado');
      } else {
        debugPrintLevels(
            0, 'Error writing data to CouchDB: ${response.statusCode}');
      }
    });
    //---------------
    return resultado;
  }
*/
  //------------------------------------------------------------------------------
  void resetEspaciosCasasGet() {
    debugPrintLevels(10, '*** HTTP resetEspaciosCasasGet');
    state.index = 0;
    // ignore: prefer_is_empty
    if (state.espaciosCasas.rows.length != 0) {
      state.espaciosCasas.rows.clear();
      /*
      state.espaciosCasas.rows.add(
        RowEspaciosCasaGet(
          id: "",
          key: "",
          value: ValueEspaciosCasaGet(
            id: "",
            rev: "",
            espacioscasa: EspaciosCasa(
              versiondelformato: "01.00",
              idPropiedad: "",
              clavedelapropiedad: "",
              idusuario: "",
              tipodeanuncio: "",
              tipodetransaccion: "",
              tipodepropiedad: "",
              idTransaccion: "",
              nombredelapropiedad: "",
              inmobiliaria: "",
              inmobiliariaimagen: "",
              ubicaciongeneral: "",
              descripcion: "",
              letreropromocional: "",
              metrosdeterreno: "",
              metrosconstruidos: "",
              recamaras: "",
              banos: "",
              mediosbanos: "",
              cuartosdeservicio: "",
              estacionamientos: "",
              estacionamientoscubiertos: "",
              datosadicionalescasa: Datosadicionalescasa(
                panelessolares: "",
                jardin: "",
                alberca: "",
                calefaccion: "",
                aireacondicionado: "",
                seguridad: "",
                enfraccionamiento: "",
                casasenelconjunto: "",
                casaclub: "",
                salondeeventos: "",
                centrodenegocios: "",
                gimnacio: "",
                cisterna: "",
                almacenamientodeagua: "",
                tratamientodeaguas: "",
                otrascaracteristicas: "",
              ),
              elementosadicionalescasa: "",
              precio: "",
              mantenimiento: "",
              moneda: "",
              niveldeprioridad: "",
              condicionesdeventa: "",
              fotoprincipal: "",
              numerodefotos: "",
              datosdelcontactocasa: Datosdelcontactocasa(
                nombre: "",
                empresa: "",
                numerocelular: "",
                numerootro: "",
                numeroinmobiliaria: "",
                correoelectronico: "",
                idusuariocontacto: "",
                nombreusuariocontacto: "",
                imgendelcontacto: "",
              ),
              ubicacioncasa: Ubicacioncasa(
                  pais: "",
                  localidadCp: LocalidadCp(
                    idEstado: 0,
                    estado: "",
                    idMunicipio: 0,
                    municipio: "",
                    ciudad: "",
                    zona: "",
                    cp: 0,
                    asentamiento: "",
                    tipo: "",
                  ),
                  calle: "",
                  numeroexterior: "",
                  numerointerior: "",
                  entrecalle01: "",
                  entrecalle02: "",
                  latitud: "",
                  longitud: "",
                  latitudDecimal: "",
                  longitudDecimal: ""),
              fechadepublicacioncasa: Fechadecasa(dia: 0, mes: 0, anio: 0),
              fechadecierrecasa: Fechadecasa(dia: 0, mes: 0, anio: 0),
              activa: 1,
              timestampcasa: "",
            ),
          ),
        ),
      );
      /*
    state.espaciosCasas.rows[state.index].value.id = valor;
    state.espaciosCasas.rows[state.index].value.rev = valor;
    state.espaciosCasas.rows[state.index].value.espacioscasa.versiondelformato = valor;
    state.espaciosCasas.rows[state.index].value.espacioscasa.idPropiedad = valor;
    state.espaciosCasas.rows[state.index].value.espacioscasa.clavedelapropiedad = valor;
    state.espaciosCasas.rows[state.index].value.espacioscasa.idusuario = valor;

    state.espaciosCasas.rows[state.index].value.espacioscasa.tipodeanuncio = valor;
    state.espaciosCasas.rows[state.index].value.espacioscasa.tipodepropiedad = valor;
    state.espaciosCasas.rows[state.index].value.espacioscasa.idTransaccion = valor;

    state.espaciosCasas.rows[state.index].value.espacioscasa.nombredelapropiedad = valor;
    state.espaciosCasas.rows[state.index].value.espacioscasa.inmobiliaria = valor;
    state.espaciosCasas.rows[state.index].value.espacioscasa.inmobiliariaimagen = valor;
    state.espaciosCasas.rows[state.index].value.espacioscasa.ubicaciongeneral = valor;
    state.espaciosCasas.rows[state.index].value.espacioscasa.descripcion = valor;
    state.espaciosCasas.rows[state.index].value.espacioscasa.letreropromocional = valor;
    state.espaciosCasas.rows[state.index].value.espacioscasa.metrosdeterreno = valor;
    state.espaciosCasas.rows[state.index].value.espacioscasa.metrosconstruidos = valor;
    state.espaciosCasas.rows[state.index].value.espacioscasa.recamaras = valor;
    state.espaciosCasas.rows[state.index].value.espacioscasa.banos = valor;
    state.espaciosCasas.rows[state.index].value.espacioscasa.mediosbanos = valor;
    state.espaciosCasas.rows[state.index].value.espacioscasa.cuartosdeservicio = valor;
    state.espaciosCasas.rows[state.index].value.espacioscasa.estacionamientos = valor;
    state.espaciosCasas.rows[state.index].value.espacioscasa.estacionamientoscubiertos = valor;

    state.espaciosCasas.rows[state.index].value.espacioscasa.datosadicionalescasa.panelessolares =
        valor;
    state.espaciosCasas.rows[state.index].value.espacioscasa.datosadicionalescasa.jardin = valor;
    state.espaciosCasas.rows[state.index].value.espacioscasa.datosadicionalescasa.alberca = valor;
    state.espaciosCasas.rows[state.index].value.espacioscasa.datosadicionalescasa.calefaccion = valor;
    state.espaciosCasas.rows[state.index].value.espacioscasa.datosadicionalescasa.aireacondicionado =
        valor;
    state.espaciosCasas.rows[state.index].value.espacioscasa.datosadicionalescasa.seguridad = valor;
    state.espaciosCasas.rows[state.index].value.espacioscasa.datosadicionalescasa.enfraccionamiento =
        valor;
    state.espaciosCasas.rows[state.index].value.espacioscasa.datosadicionalescasa.casasenelconjunto =
        valor;
    state.espaciosCasas.rows[state.index].value.espacioscasa.datosadicionalescasa.casaclub = valor;
    state.espaciosCasas.rows[state.index].value.espacioscasa.datosadicionalescasa.salondeeventos =
        valor;
    state.espaciosCasas.rows[state.index].value.espacioscasa.datosadicionalescasa.centrodenegocios =
        valor;
    state.espaciosCasas.rows[state.index].value.espacioscasa.datosadicionalescasa.gimnacio = valor;
    state.espaciosCasas.rows[state.index].value.espacioscasa.datosadicionalescasa.cisterna = valor;
    state.espaciosCasas.rows[state.index].value.espacioscasa.datosadicionalescasa.almacenamientodeagua =
        valor;
    state.espaciosCasas.rows[state.index].value.espacioscasa.datosadicionalescasa.tratamientodeaguas =
        valor;
    state.espaciosCasas.rows[state.index].value.espacioscasa.datosadicionalescasa.otrascaracteristicas =
        valor;

    state.espaciosCasas.rows[state.index].value.espacioscasa.elementosadicionalescasa = valor;
    state.espaciosCasas.rows[state.index].value.espacioscasa.precio = valor;
    state.espaciosCasas.rows[state.index].value.espacioscasa.mantenimiento = valor;
    state.espaciosCasas.rows[state.index].value.espacioscasa.moneda = valor;
    state.espaciosCasas.rows[state.index].value.espacioscasa.niveldeprioridad = valor;
    state.espaciosCasas.rows[state.index].value.espacioscasa.condicionesdeventa = valor;
    state.espaciosCasas.rows[state.index].value.espacioscasa.fotoprincipal = valor;
    state.espaciosCasas.rows[state.index].value.espacioscasa.numerodefotos = valor;

    state.espaciosCasas.rows[state.index].value.espacioscasa.datosdelcontactocasa.nombre = valor;
    state.espaciosCasas.rows[state.index].value.espacioscasa.datosdelcontactocasa.empresa = valor;
    state.espaciosCasas.rows[state.index].value.espacioscasa.datosdelcontactocasa.numerocelular = valor;
    state.espaciosCasas.rows[state.index].value.espacioscasa.datosdelcontactocasa.numerootro = valor;
    state.espaciosCasas.rows[state.index].value.espacioscasa.datosdelcontactocasa.numeroinmobiliaria =
        valor;
    state.espaciosCasas.rows[state.index].value.espacioscasa.datosdelcontactocasa.correoelectronico =
        valor;
    state.espaciosCasas.rows[state.index].value.espacioscasa.datosdelcontactocasa.idusuariocontacto =
        valor;
    state.espaciosCasas.rows[state.index].value.espacioscasa.datosdelcontactocasa
        .nombreusuariocontacto = valor;
    state.espaciosCasas.rows[state.index].value.espacioscasa.datosdelcontactocasa.imgendelcontacto =
        valor;

    state.espaciosCasas.rows[state.index].value.espacioscasa.ubicacioncasa.pais = valor;
    // LocalidadCp es @freezed — asignamos una nueva instancia
    state.espaciosCasas.rows[state.index].value.espacioscasa.ubicacioncasa.localidadCp =
        const LocalidadCp(
          idEstado: 0, estado: '', idMunicipio: 0, municipio: '',
          ciudad: '', zona: '', cp: 0, asentamiento: '', tipo: '',
        );

    state.espaciosCasas.rows[state.index].value.espacioscasa.ubicacioncasa.calle = valor;
    state.espaciosCasas.rows[state.index].value.espacioscasa.ubicacioncasa.numeroexterior = valor;
    state.espaciosCasas.rows[state.index].value.espacioscasa.ubicacioncasa.numerointerior = valor;
    state.espaciosCasas.rows[state.index].value.espacioscasa.ubicacioncasa.latitud = valor;
    state.espaciosCasas.rows[state.index].value.espacioscasa.ubicacioncasa.longitud = valor;
    state.espaciosCasas.rows[state.index].value.espacioscasa.ubicacioncasa.latitudDecimal = valor;
    state.espaciosCasas.rows[state.index].value.espacioscasa.ubicacioncasa.longitudDecimal = valor;

    state.espaciosCasas.rows[state.index].value.espacioscasa.fechadepublicacioncasa.dia = 0;
    state.espaciosCasas.rows[state.index].value.espacioscasa.fechadepublicacioncasa.mes = 0;
    state.espaciosCasas.rows[state.index].value.espacioscasa.fechadepublicacioncasa.anio = 0;

    state.espaciosCasas.rows[state.index].value.espacioscasa.fechadecierrecasa.dia = 0;
    state.espaciosCasas.rows[state.index].value.espacioscasa.fechadecierrecasa.mes = 0;
    state.espaciosCasas.rows[state.index].value.espacioscasa.fechadecierrecasa.anio = 0;

    state.espaciosCasas.rows[state.index].value.espacioscasa.activa = 0;
    state.espaciosCasas.rows[state.index].value.espacioscasa.timestampcasa = valor;
    */
   */
    }
  }

  int getNumeroDePropiedades() {
    // For an empty list, the length property will return 0.
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
    debugPrintLevels(10, "getEspaciosCasasPropiedadActual: ${state.index} ");
    return state.espaciosCasas.rows[state.index].value;
  }

  /*
  int intIndexEspaciosCasas(ValueEspaciosCasaGet propiedadID) {
    return ref.read(espaciosCasaConListaFotosGetProvider).espaciosCasas.rows.indexWhere(
        (propiedad) =>
            propiedad.value.espacioscasa.idPropiedad ==
            propiedadID.espacioscasa.idPropiedad);
  }
*/
  //-----------------------------------------------------------------------------
  void setEspaciosCasasGet(WidgetRef ref, ValueEspaciosCasaGet propiedad) {
    debugPrintLevels(10, 'HTTP setEspaciosCasasGet');
    state.espaciosCasas.rows[state.index].value = propiedad;
    /*
    state.espaciosCasas.rows[state.index].value.id = propiedad.id;
    state.espaciosCasas.rows[state.index].value.rev = propiedad.rev;
    state.espaciosCasas.rows[state.index].value.espacioscasa.versiondelformato =
        propiedad.espacioscasa.versiondelformato;
    state.espaciosCasas.rows[state.index].value.espacioscasa.idPropiedad =
        propiedad.espacioscasa.idPropiedad;
    state.espaciosCasas.rows[state.index].value.espacioscasa
        .clavedelapropiedad = propiedad.espacioscasa.clavedelapropiedad;
    state.espaciosCasas.rows[state.index].value.espacioscasa.idusuario = ref
        .read(sessionProvider.notifier)
        .getCampoIdUserPass(ref, "idUsuario");

    state.espaciosCasas.rows[state.index].value.espacioscasa.tipodeanuncio =
        propiedad.espacioscasa.tipodeanuncio;
    state.espaciosCasas.rows[state.index].value.espacioscasa.tipodepropiedad =
        propiedad.espacioscasa.tipodepropiedad;
    state.espaciosCasas.rows[state.index].value.espacioscasa.idTransaccion =
        propiedad.espacioscasa.idTransaccion;

    state.espaciosCasas.rows[state.index].value.espacioscasa
        .nombredelapropiedad = propiedad.espacioscasa.nombredelapropiedad;
    state.espaciosCasas.rows[state.index].value.espacioscasa.inmobiliaria =
        propiedad.espacioscasa.inmobiliaria;
    state.espaciosCasas.rows[state.index].value.espacioscasa
        .inmobiliariaimagen = propiedad.espacioscasa.inmobiliariaimagen;
    state.espaciosCasas.rows[state.index].value.espacioscasa.ubicaciongeneral =
        propiedad.espacioscasa.ubicaciongeneral;

    state.espaciosCasas.rows[state.index].value.espacioscasa.descripcion =
        propiedad.espacioscasa.descripcion;
    state.espaciosCasas.rows[state.index].value.espacioscasa
        .letreropromocional = propiedad.espacioscasa.letreropromocional;
    state.espaciosCasas.rows[state.index].value.espacioscasa.recamaras =
        propiedad.espacioscasa.recamaras;
    state.espaciosCasas.rows[state.index].value.espacioscasa.banos =
        propiedad.espacioscasa.banos;
    state.espaciosCasas.rows[state.index].value.espacioscasa.mediosbanos =
        propiedad.espacioscasa.mediosbanos;
    state.espaciosCasas.rows[state.index].value.espacioscasa.cuartosdeservicio =
        propiedad.espacioscasa.cuartosdeservicio;
    state.espaciosCasas.rows[state.index].value.espacioscasa.estacionamientos =
        propiedad.espacioscasa.estacionamientos;
    state.espaciosCasas.rows[state.index].value.espacioscasa
            .estacionamientoscubiertos =
        propiedad.espacioscasa.estacionamientoscubiertos;

    state.espaciosCasas.rows[state.index].value.espacioscasa
            .datosadicionalescasa.panelessolares =
        propiedad.espacioscasa.datosadicionalescasa.panelessolares;
    state
        .espaciosCasas
        .rows[state.index]
        .value
        .espacioscasa
        .datosadicionalescasa
        .jardin = propiedad.espacioscasa.datosadicionalescasa.jardin;
    state
        .espaciosCasas
        .rows[state.index]
        .value
        .espacioscasa
        .datosadicionalescasa
        .alberca = propiedad.espacioscasa.datosadicionalescasa.alberca;
    state
        .espaciosCasas
        .rows[state.index]
        .value
        .espacioscasa
        .datosadicionalescasa
        .calefaccion = propiedad.espacioscasa.datosadicionalescasa.calefaccion;
    state.espaciosCasas.rows[state.index].value.espacioscasa
            .datosadicionalescasa.aireacondicionado =
        propiedad.espacioscasa.datosadicionalescasa.aireacondicionado;
    state
        .espaciosCasas
        .rows[state.index]
        .value
        .espacioscasa
        .datosadicionalescasa
        .seguridad = propiedad.espacioscasa.datosadicionalescasa.seguridad;
    state.espaciosCasas.rows[state.index].value.espacioscasa
            .datosadicionalescasa.enfraccionamiento =
        propiedad.espacioscasa.datosadicionalescasa.enfraccionamiento;
    state.espaciosCasas.rows[state.index].value.espacioscasa
            .datosadicionalescasa.casasenelconjunto =
        propiedad.espacioscasa.datosadicionalescasa.casasenelconjunto;
    state
        .espaciosCasas
        .rows[state.index]
        .value
        .espacioscasa
        .datosadicionalescasa
        .casaclub = propiedad.espacioscasa.datosadicionalescasa.casaclub;
    state.espaciosCasas.rows[state.index].value.espacioscasa
            .datosadicionalescasa.salondeeventos =
        propiedad.espacioscasa.datosadicionalescasa.salondeeventos;
    state.espaciosCasas.rows[state.index].value.espacioscasa
            .datosadicionalescasa.centrodenegocios =
        propiedad.espacioscasa.datosadicionalescasa.centrodenegocios;
    state
        .espaciosCasas
        .rows[state.index]
        .value
        .espacioscasa
        .datosadicionalescasa
        .gimnacio = propiedad.espacioscasa.datosadicionalescasa.gimnacio;
    state
        .espaciosCasas
        .rows[state.index]
        .value
        .espacioscasa
        .datosadicionalescasa
        .cisterna = propiedad.espacioscasa.datosadicionalescasa.cisterna;
    state.espaciosCasas.rows[state.index].value.espacioscasa
            .datosadicionalescasa.almacenamientodeagua =
        propiedad.espacioscasa.datosadicionalescasa.almacenamientodeagua;
    state.espaciosCasas.rows[state.index].value.espacioscasa
            .datosadicionalescasa.tratamientodeaguas =
        propiedad.espacioscasa.datosadicionalescasa.tratamientodeaguas;
    state.espaciosCasas.rows[state.index].value.espacioscasa
            .datosadicionalescasa.otrascaracteristicas =
        propiedad.espacioscasa.datosadicionalescasa.otrascaracteristicas;

    state.espaciosCasas.rows[state.index].value.espacioscasa
            .elementosadicionalescasa =
        propiedad.espacioscasa.elementosadicionalescasa;

    state.espaciosCasas.rows[state.index].value.espacioscasa.precioventa =
        propiedad.espacioscasa.precioventa;
    state.espaciosCasas.rows[state.index].value.espacioscasa.preciorenta =
        propiedad.espacioscasa.preciorenta;
    state.espaciosCasas.rows[state.index].value.espacioscasa.mantenimiento =
        propiedad.espacioscasa.mantenimiento;
    state.espaciosCasas.rows[state.index].value.espacioscasa.moneda =
        propiedad.espacioscasa.moneda;
    state.espaciosCasas.rows[state.index].value.espacioscasa.niveldeprioridad =
        propiedad.espacioscasa.niveldeprioridad;
    state.espaciosCasas.rows[state.index].value.espacioscasa
        .condicionesdeventa = propiedad.espacioscasa.condicionesdeventa;
    state.espaciosCasas.rows[state.index].value.espacioscasa.fotoprincipal =
        propiedad.espacioscasa.fotoprincipal;
    state.espaciosCasas.rows[state.index].value.espacioscasa.numerodefotos =
        propiedad.espacioscasa.numerodefotos;

    state
        .espaciosCasas
        .rows[state.index]
        .value
        .espacioscasa
        .datosdelcontactocasa
        .nombre = propiedad.espacioscasa.datosdelcontactocasa.nombre;
    state
        .espaciosCasas
        .rows[state.index]
        .value
        .espacioscasa
        .datosdelcontactocasa
        .empresa = propiedad.espacioscasa.datosdelcontactocasa.empresa;
    state.espaciosCasas.rows[state.index].value.espacioscasa
            .datosdelcontactocasa.numerocelular =
        propiedad.espacioscasa.datosdelcontactocasa.numerocelular;
    state
        .espaciosCasas
        .rows[state.index]
        .value
        .espacioscasa
        .datosdelcontactocasa
        .numerootro = propiedad.espacioscasa.datosdelcontactocasa.numerootro;
    state.espaciosCasas.rows[state.index].value.espacioscasa
            .datosdelcontactocasa.numeroinmobiliaria =
        propiedad.espacioscasa.datosdelcontactocasa.numeroinmobiliaria;
    state.espaciosCasas.rows[state.index].value.espacioscasa
            .datosdelcontactocasa.correoelectronico =
        propiedad.espacioscasa.datosdelcontactocasa.correoelectronico;
    state.espaciosCasas.rows[state.index].value.espacioscasa
            .datosdelcontactocasa.idusuariocontacto =
        propiedad.espacioscasa.datosdelcontactocasa.idusuariocontacto;
    state.espaciosCasas.rows[state.index].value.espacioscasa
            .datosdelcontactocasa.nombreusuariocontacto =
        propiedad.espacioscasa.datosdelcontactocasa.nombreusuariocontacto;
    state.espaciosCasas.rows[state.index].value.espacioscasa
            .datosdelcontactocasa.imgendelcontacto =
        propiedad.espacioscasa.datosdelcontactocasa.imgendelcontacto;

    state.espaciosCasas.rows[state.index].value.espacioscasa.ubicacioncasa
        .pais = propiedad.espacioscasa.ubicacioncasa.pais;

    // LocalidadCp es @freezed — asignamos la instancia completa desde la fuente
    state.espaciosCasas.rows[state.index].value.espacioscasa.ubicacioncasa
        .localidadCp = propiedad.espacioscasa.ubicacioncasa.localidadCp;

    state.espaciosCasas.rows[state.index].value.espacioscasa.ubicacioncasa
        .calle = propiedad.espacioscasa.ubicacioncasa.calle;
    state.espaciosCasas.rows[state.index].value.espacioscasa.ubicacioncasa
        .numeroexterior = propiedad.espacioscasa.ubicacioncasa.numeroexterior;
    state.espaciosCasas.rows[state.index].value.espacioscasa.ubicacioncasa
        .numerointerior = propiedad.espacioscasa.ubicacioncasa.numerointerior;
    state.espaciosCasas.rows[state.index].value.espacioscasa.ubicacioncasa
        .latitud = propiedad.espacioscasa.ubicacioncasa.latitud;
    state.espaciosCasas.rows[state.index].value.espacioscasa.ubicacioncasa
        .longitud = propiedad.espacioscasa.ubicacioncasa.longitud;
    state.espaciosCasas.rows[state.index].value.espacioscasa.ubicacioncasa
        .latitudDecimal = propiedad.espacioscasa.ubicacioncasa.latitudDecimal;
    state.espaciosCasas.rows[state.index].value.espacioscasa.ubicacioncasa
        .longitudDecimal = propiedad.espacioscasa.ubicacioncasa.longitudDecimal;

    state
        .espaciosCasas
        .rows[state.index]
        .value
        .espacioscasa
        .fechadepublicacioncasa
        .dia = propiedad.espacioscasa.fechadepublicacioncasa.dia;
    state
        .espaciosCasas
        .rows[state.index]
        .value
        .espacioscasa
        .fechadepublicacioncasa
        .mes = propiedad.espacioscasa.fechadepublicacioncasa.mes;
    state
        .espaciosCasas
        .rows[state.index]
        .value
        .espacioscasa
        .fechadepublicacioncasa
        .anio = propiedad.espacioscasa.fechadepublicacioncasa.anio;

    state.espaciosCasas.rows[state.index].value.espacioscasa.fechadecierrecasa
        .dia = propiedad.espacioscasa.fechadecierrecasa.dia;
    state.espaciosCasas.rows[state.index].value.espacioscasa.fechadecierrecasa
        .mes = propiedad.espacioscasa.fechadecierrecasa.mes;
    state.espaciosCasas.rows[state.index].value.espacioscasa.fechadecierrecasa
        .anio = propiedad.espacioscasa.fechadecierrecasa.anio;

    state.espaciosCasas.rows[state.index].value.espacioscasa.activa =
        propiedad.espacioscasa.activa;

    state.espaciosCasas.rows[state.index].value.espacioscasa.timestampcasa =
        propiedad.espacioscasa.timestampcasa;
        */
  }

  //-----------------------------------------------------------------------------
  void setCampoEspaciosCasasGet(String campo, String valor) {
    debugPrintLevels(10, 'HTTP setCampoEspaciosCasasGet');

    switch (campo) {
      case "id":
        state.espaciosCasas.rows[state.index].value.id = valor;
        break;
      case "rev":
        state.espaciosCasas.rows[state.index].value.rev = valor;
        break;

      case "versiondelformato":
        state
                .espaciosCasas
                .rows[state.index]
                .value
                .espacioscasa
                .versiondelformato =
            valor;
        break;
      case "idPropiedad":
        state.espaciosCasas.rows[state.index].value.espacioscasa.idPropiedad =
            valor;
        break;
      case "clavedelapropiedad":
        state
                .espaciosCasas
                .rows[state.index]
                .value
                .espacioscasa
                .clavedelapropiedad =
            valor;
        break;
      case "idusuario":
        state.espaciosCasas.rows[state.index].value.espacioscasa.idusuario =
            valor;
        break;

      case "tipodeanuncio":
        state.espaciosCasas.rows[state.index].value.espacioscasa.tipodeanuncio =
            valor;
        break;
      case "tipodepropiedad":
        state
                .espaciosCasas
                .rows[state.index]
                .value
                .espacioscasa
                .tipodepropiedad =
            valor;
        break;

      case "tipodetransaccion":
        state
                .espaciosCasas
                .rows[state.index]
                .value
                .espacioscasa
                .tipodetransaccion =
            valor;
        break;

      case "idTransaccion":
        state.espaciosCasas.rows[state.index].value.espacioscasa.idTransaccion =
            valor;
        break;

      case "nombredelapropiedad":
        state
                .espaciosCasas
                .rows[state.index]
                .value
                .espacioscasa
                .nombredelapropiedad =
            valor;
        break;
      case "inmobiliaria":
        state.espaciosCasas.rows[state.index].value.espacioscasa.inmobiliaria =
            valor;
        break;
      case "inmobiliariaimagen":
        state
                .espaciosCasas
                .rows[state.index]
                .value
                .espacioscasa
                .inmobiliariaimagen =
            valor;
        break;
      case "ubicaciongeneral":
        state
                .espaciosCasas
                .rows[state.index]
                .value
                .espacioscasa
                .ubicaciongeneral =
            valor;
        break;

      case "descripcion":
        state.espaciosCasas.rows[state.index].value.espacioscasa.descripcion =
            valor;
        break;
      case "letreropromocional":
        state
                .espaciosCasas
                .rows[state.index]
                .value
                .espacioscasa
                .letreropromocional =
            valor;
        break;
      case "metrosdeterreno":
        state
                .espaciosCasas
                .rows[state.index]
                .value
                .espacioscasa
                .metrosdeterreno =
            valor;
        break;
      case "metrosconstruidos":
        state
                .espaciosCasas
                .rows[state.index]
                .value
                .espacioscasa
                .metrosconstruidos =
            valor;
        break;
      case "recamaras":
        state.espaciosCasas.rows[state.index].value.espacioscasa.recamaras =
            valor;
        break;
      case "banos":
        state.espaciosCasas.rows[state.index].value.espacioscasa.banos = valor;
        break;
      case "mediosbanos":
        state.espaciosCasas.rows[state.index].value.espacioscasa.mediosbanos =
            valor;
        break;
      case "cuartosdeservicio":
        state
                .espaciosCasas
                .rows[state.index]
                .value
                .espacioscasa
                .cuartosdeservicio =
            valor;
        break;
      case "estacionamientos":
        state
                .espaciosCasas
                .rows[state.index]
                .value
                .espacioscasa
                .estacionamientos =
            valor;
        break;
      case "estacionamientoscubiertos":
        state
                .espaciosCasas
                .rows[state.index]
                .value
                .espacioscasa
                .estacionamientoscubiertos =
            valor;
        break;
      case "panelessolares":
        // debugPrintLevels(10, "cambia valor = $valor");
        state
                .espaciosCasas
                .rows[state.index]
                .value
                .espacioscasa
                .datosadicionalescasa
                .panelessolares =
            valor;

        break;
      case "jardin":
        state
                .espaciosCasas
                .rows[state.index]
                .value
                .espacioscasa
                .datosadicionalescasa
                .jardin =
            valor;
        break;
      case "alberca":
        state
                .espaciosCasas
                .rows[state.index]
                .value
                .espacioscasa
                .datosadicionalescasa
                .alberca =
            valor;
        break;
      case "calefaccion":
        state
                .espaciosCasas
                .rows[state.index]
                .value
                .espacioscasa
                .datosadicionalescasa
                .calefaccion =
            valor;
        break;
      case "aireacondicionado":
        state
                .espaciosCasas
                .rows[state.index]
                .value
                .espacioscasa
                .datosadicionalescasa
                .aireacondicionado =
            valor;
        break;
      case "seguridad":
        state
                .espaciosCasas
                .rows[state.index]
                .value
                .espacioscasa
                .datosadicionalescasa
                .seguridad =
            valor;
        break;
      case "enfraccionamiento":
        state
                .espaciosCasas
                .rows[state.index]
                .value
                .espacioscasa
                .datosadicionalescasa
                .enfraccionamiento =
            valor;
        break;
      case "casasenelconjunto":
        state
                .espaciosCasas
                .rows[state.index]
                .value
                .espacioscasa
                .datosadicionalescasa
                .casasenelconjunto =
            valor;
        break;
      case "casaclub":
        state
                .espaciosCasas
                .rows[state.index]
                .value
                .espacioscasa
                .datosadicionalescasa
                .casaclub =
            valor;
        break;
      case "salondeeventos":
        state
                .espaciosCasas
                .rows[state.index]
                .value
                .espacioscasa
                .datosadicionalescasa
                .salondeeventos =
            valor;
        break;
      case "centrodenegocios":
        state
                .espaciosCasas
                .rows[state.index]
                .value
                .espacioscasa
                .datosadicionalescasa
                .centrodenegocios =
            valor;
        break;
      case "gimnacio":
        state
                .espaciosCasas
                .rows[state.index]
                .value
                .espacioscasa
                .datosadicionalescasa
                .gimnacio =
            valor;
        break;
      case "cisterna":
        state
                .espaciosCasas
                .rows[state.index]
                .value
                .espacioscasa
                .datosadicionalescasa
                .cisterna =
            valor;
        break;
      case "almacenamientodeagua":
        state
                .espaciosCasas
                .rows[state.index]
                .value
                .espacioscasa
                .datosadicionalescasa
                .almacenamientodeagua =
            valor;
        break;
      case "tratamientodeaguas":
        state
                .espaciosCasas
                .rows[state.index]
                .value
                .espacioscasa
                .datosadicionalescasa
                .tratamientodeaguas =
            valor;
        break;
      case "otrascaracteristicas":
        state
                .espaciosCasas
                .rows[state.index]
                .value
                .espacioscasa
                .datosadicionalescasa
                .otrascaracteristicas =
            valor;

      case "elementosadicionalescasa":
        state
                .espaciosCasas
                .rows[state.index]
                .value
                .espacioscasa
                .elementosadicionalescasa =
            valor;
        break;

      case "precioventa":
        state.espaciosCasas.rows[state.index].value.espacioscasa.precioventa =
            valor;
      case "preciorenta":
        state.espaciosCasas.rows[state.index].value.espacioscasa.preciorenta =
            valor;
        break;
      case "mantenimiento":
        state.espaciosCasas.rows[state.index].value.espacioscasa.mantenimiento =
            valor;
        break;
      case "moneda":
        state.espaciosCasas.rows[state.index].value.espacioscasa.moneda = valor;
        break;

      case "niveldeprioridad":
        state
                .espaciosCasas
                .rows[state.index]
                .value
                .espacioscasa
                .niveldeprioridad =
            valor;
        break;
      case "condicionesdeventa":
        state
                .espaciosCasas
                .rows[state.index]
                .value
                .espacioscasa
                .condicionesdeventa =
            valor;
        break;
      case "fotoprincipal":
        state.espaciosCasas.rows[state.index].value.espacioscasa.fotoprincipal =
            valor;
        break;
      case "numerodefotos":
        state.espaciosCasas.rows[state.index].value.espacioscasa.numerodefotos =
            valor;
        break;

      case "nombre":
        state
                .espaciosCasas
                .rows[state.index]
                .value
                .espacioscasa
                .datosdelcontactocasa
                .nombre =
            valor;
        break;
      case "empresa":
        state
                .espaciosCasas
                .rows[state.index]
                .value
                .espacioscasa
                .datosdelcontactocasa
                .empresa =
            valor;
        break;
      case "numerocelular":
        state
                .espaciosCasas
                .rows[state.index]
                .value
                .espacioscasa
                .datosdelcontactocasa
                .numerocelular =
            valor;
        break;
      case "numerootro":
        state
                .espaciosCasas
                .rows[state.index]
                .value
                .espacioscasa
                .datosdelcontactocasa
                .numerootro =
            valor;
        break;
      case "numeroinmobiliaria":
        state
                .espaciosCasas
                .rows[state.index]
                .value
                .espacioscasa
                .datosdelcontactocasa
                .numeroinmobiliaria =
            valor;
        break;
      case "correoelectronico":
        state
                .espaciosCasas
                .rows[state.index]
                .value
                .espacioscasa
                .datosdelcontactocasa
                .correoelectronico =
            valor;
        break;
      case "idusuariocontacto":
        state
                .espaciosCasas
                .rows[state.index]
                .value
                .espacioscasa
                .datosdelcontactocasa
                .idusuariocontacto =
            valor;
        break;
      case "nombreusuariocontacto":
        state
                .espaciosCasas
                .rows[state.index]
                .value
                .espacioscasa
                .datosdelcontactocasa
                .nombreusuariocontacto =
            valor;
        break;
      case "imgendelcontacto":
        state
                .espaciosCasas
                .rows[state.index]
                .value
                .espacioscasa
                .datosdelcontactocasa
                .imgendelcontacto =
            valor;
        break;

      case "pais":
        state
                .espaciosCasas
                .rows[state.index]
                .value
                .espacioscasa
                .ubicacioncasa
                .pais =
            valor;
        break;

      case "idEstado":
        state.espaciosCasas.rows[state.index].value.espacioscasa.ubicacioncasa.localidadCp =
            state.espaciosCasas.rows[state.index].value.espacioscasa.ubicacioncasa.localidadCp
                .copyWith(idEstado: int.tryParse(valor) ?? 0);
        break;
      case "estado":
        state.espaciosCasas.rows[state.index].value.espacioscasa.ubicacioncasa.localidadCp =
            state.espaciosCasas.rows[state.index].value.espacioscasa.ubicacioncasa.localidadCp
                .copyWith(estado: valor);
        break;
      case "idMunicipio":
        state.espaciosCasas.rows[state.index].value.espacioscasa.ubicacioncasa.localidadCp =
            state.espaciosCasas.rows[state.index].value.espacioscasa.ubicacioncasa.localidadCp
                .copyWith(idMunicipio: int.tryParse(valor) ?? 0);
        break;
      case "municipio":
        state.espaciosCasas.rows[state.index].value.espacioscasa.ubicacioncasa.localidadCp =
            state.espaciosCasas.rows[state.index].value.espacioscasa.ubicacioncasa.localidadCp
                .copyWith(municipio: valor);
        break;
      case "ciudad":
        state.espaciosCasas.rows[state.index].value.espacioscasa.ubicacioncasa.localidadCp =
            state.espaciosCasas.rows[state.index].value.espacioscasa.ubicacioncasa.localidadCp
                .copyWith(ciudad: valor);
        break;
      case "zona":
        state.espaciosCasas.rows[state.index].value.espacioscasa.ubicacioncasa.localidadCp =
            state.espaciosCasas.rows[state.index].value.espacioscasa.ubicacioncasa.localidadCp
                .copyWith(zona: valor);
        break;
      case "asentamiento":
        state.espaciosCasas.rows[state.index].value.espacioscasa.ubicacioncasa.localidadCp =
            state.espaciosCasas.rows[state.index].value.espacioscasa.ubicacioncasa.localidadCp
                .copyWith(asentamiento: valor);
        break;
      case "codigopostal":
        state.espaciosCasas.rows[state.index].value.espacioscasa.ubicacioncasa.localidadCp =
            state.espaciosCasas.rows[state.index].value.espacioscasa.ubicacioncasa.localidadCp
                .copyWith(cp: int.tryParse(valor) ?? 0);
        break;
      case "tipo":
        state.espaciosCasas.rows[state.index].value.espacioscasa.ubicacioncasa.localidadCp =
            state.espaciosCasas.rows[state.index].value.espacioscasa.ubicacioncasa.localidadCp
                .copyWith(tipo: valor);
        break;

      case "calle":
        state
                .espaciosCasas
                .rows[state.index]
                .value
                .espacioscasa
                .ubicacioncasa
                .calle =
            valor;
        break;
      case "numeroexterior":
        state
                .espaciosCasas
                .rows[state.index]
                .value
                .espacioscasa
                .ubicacioncasa
                .numeroexterior =
            valor;
        break;
      case "numerointerior":
        state
                .espaciosCasas
                .rows[state.index]
                .value
                .espacioscasa
                .ubicacioncasa
                .numerointerior =
            valor;
        break;

      case "latitud":
        state
                .espaciosCasas
                .rows[state.index]
                .value
                .espacioscasa
                .ubicacioncasa
                .latitud =
            valor;
        break;
      case "longitud":
        state
                .espaciosCasas
                .rows[state.index]
                .value
                .espacioscasa
                .ubicacioncasa
                .longitud =
            valor;
        break;
      case "latitudDecimal":
        state
                .espaciosCasas
                .rows[state.index]
                .value
                .espacioscasa
                .ubicacioncasa
                .latitudDecimal =
            valor;
        break;
      case "longitudDecimal":
        state
                .espaciosCasas
                .rows[state.index]
                .value
                .espacioscasa
                .ubicacioncasa
                .longitudDecimal =
            valor;
        break;

      case "diapublicacion":
        state
            .espaciosCasas
            .rows[state.index]
            .value
            .espacioscasa
            .fechadepublicacioncasa
            .dia = int.parse(
          valor,
        );
        break;
      case "mespublicacion":
        state
            .espaciosCasas
            .rows[state.index]
            .value
            .espacioscasa
            .fechadepublicacioncasa
            .mes = int.parse(
          valor,
        );
        break;
      case "aniopublicacion":
        state
            .espaciosCasas
            .rows[state.index]
            .value
            .espacioscasa
            .fechadepublicacioncasa
            .anio = int.parse(
          valor,
        );
        break;

      case "diadecierre":
        state
            .espaciosCasas
            .rows[state.index]
            .value
            .espacioscasa
            .fechadecierrecasa
            .dia = int.parse(
          valor,
        );
        break;
      case "mesdecierre":
        state
            .espaciosCasas
            .rows[state.index]
            .value
            .espacioscasa
            .fechadecierrecasa
            .mes = int.parse(
          valor,
        );
        break;
      case "aniodecierre":
        state
            .espaciosCasas
            .rows[state.index]
            .value
            .espacioscasa
            .fechadecierrecasa
            .anio = int.parse(
          valor,
        );
        break;

      case "activa":
        state.espaciosCasas.rows[state.index].value.espacioscasa.activa =
            int.parse(valor);
        break;
      case "timestampcasa":
        state.espaciosCasas.rows[state.index].value.espacioscasa.timestampcasa =
            valor;
        break;
    }
  }

  //-----------------------------------------------------------------------------
  String getCampoEspaciosCasasGet(String campo) {
    // debugPrintLevels(10, 'HTTP getCampoEspaciosCasasGet');

    String variableRegreso = "";
    final varEspaciosCasasGetProvider =
        state.espaciosCasas.rows[state.index].value;

    switch (campo) {
      case "id":
        return variableRegreso = varEspaciosCasasGetProvider.id;
      case "rev":
        return variableRegreso = varEspaciosCasasGetProvider.rev;

      case "versiondelformato":
        return variableRegreso =
            varEspaciosCasasGetProvider.espacioscasa.versiondelformato;
      case "idPropiedad":
        return variableRegreso =
            varEspaciosCasasGetProvider.espacioscasa.idPropiedad;
      case "clavedelapropiedad":
        return variableRegreso =
            varEspaciosCasasGetProvider.espacioscasa.clavedelapropiedad;
      case "idusuario":
        return variableRegreso =
            varEspaciosCasasGetProvider.espacioscasa.idusuario;

      case "tipodeanuncio":
        return variableRegreso =
            varEspaciosCasasGetProvider.espacioscasa.tipodeanuncio;
      case "tipodepropiedad":
        return variableRegreso =
            varEspaciosCasasGetProvider.espacioscasa.tipodepropiedad;
      case "idTransaccion":
        return variableRegreso =
            varEspaciosCasasGetProvider.espacioscasa.idTransaccion;

      case "nombredelapropiedad":
        return variableRegreso =
            varEspaciosCasasGetProvider.espacioscasa.nombredelapropiedad;
      case "inmobiliaria":
        return variableRegreso =
            varEspaciosCasasGetProvider.espacioscasa.inmobiliaria;
      case "inmobiliariaimagen":
        return variableRegreso =
            varEspaciosCasasGetProvider.espacioscasa.inmobiliariaimagen;
      case "ubicaciongeneral":
        return variableRegreso =
            varEspaciosCasasGetProvider.espacioscasa.ubicaciongeneral;

      case "descripcion":
        return variableRegreso =
            varEspaciosCasasGetProvider.espacioscasa.descripcion;
      case "letreropromocional":
        return variableRegreso =
            varEspaciosCasasGetProvider.espacioscasa.letreropromocional;
      case "metrosdeterreno":
        return variableRegreso =
            varEspaciosCasasGetProvider.espacioscasa.metrosdeterreno;
      case "metrosconstruidos":
        return variableRegreso =
            varEspaciosCasasGetProvider.espacioscasa.metrosconstruidos;
      case "recamaras":
        return variableRegreso =
            varEspaciosCasasGetProvider.espacioscasa.recamaras;
      case "banos":
        return variableRegreso = varEspaciosCasasGetProvider.espacioscasa.banos;
      case "mediosbanos":
        return variableRegreso =
            varEspaciosCasasGetProvider.espacioscasa.mediosbanos;
      case "cuartosdeservicio":
        return variableRegreso =
            varEspaciosCasasGetProvider.espacioscasa.cuartosdeservicio;
      case "estacionamientos":
        return variableRegreso =
            varEspaciosCasasGetProvider.espacioscasa.estacionamientos;
      case "estacionamientoscubiertos":
        return variableRegreso =
            varEspaciosCasasGetProvider.espacioscasa.estacionamientoscubiertos;

      case "panelessolares":
        variableRegreso = varEspaciosCasasGetProvider
            .espacioscasa
            .datosadicionalescasa
            .panelessolares;
      case "jardin":
        return variableRegreso = varEspaciosCasasGetProvider
            .espacioscasa
            .datosadicionalescasa
            .jardin;
      case "alberca":
        return variableRegreso = varEspaciosCasasGetProvider
            .espacioscasa
            .datosadicionalescasa
            .alberca;
      case "calefaccion":
        return variableRegreso = varEspaciosCasasGetProvider
            .espacioscasa
            .datosadicionalescasa
            .calefaccion;
      case "aireacondicionado":
        variableRegreso = varEspaciosCasasGetProvider
            .espacioscasa
            .datosadicionalescasa
            .aireacondicionado;
      case "seguridad":
        return variableRegreso = varEspaciosCasasGetProvider
            .espacioscasa
            .datosadicionalescasa
            .seguridad;
      case "enfraccionamiento":
        variableRegreso = varEspaciosCasasGetProvider
            .espacioscasa
            .datosadicionalescasa
            .enfraccionamiento;
      case "casasenelconjunto":
        variableRegreso = varEspaciosCasasGetProvider
            .espacioscasa
            .datosadicionalescasa
            .casasenelconjunto;
      case "casaclub":
        return variableRegreso = varEspaciosCasasGetProvider
            .espacioscasa
            .datosadicionalescasa
            .casaclub;
      case "salondeeventos":
        variableRegreso = varEspaciosCasasGetProvider
            .espacioscasa
            .datosadicionalescasa
            .salondeeventos;
      case "centrodenegocios":
        variableRegreso = varEspaciosCasasGetProvider
            .espacioscasa
            .datosadicionalescasa
            .centrodenegocios;
      case "gimnacio":
        return variableRegreso = varEspaciosCasasGetProvider
            .espacioscasa
            .datosadicionalescasa
            .gimnacio;
      case "cisterna":
        return variableRegreso = varEspaciosCasasGetProvider
            .espacioscasa
            .datosadicionalescasa
            .cisterna;
      case "almacenamientodeagua":
        variableRegreso = varEspaciosCasasGetProvider
            .espacioscasa
            .datosadicionalescasa
            .almacenamientodeagua;
      case "tratamientodeaguas":
        variableRegreso = varEspaciosCasasGetProvider
            .espacioscasa
            .datosadicionalescasa
            .tratamientodeaguas;
      case "otrascaracteristicas":
        variableRegreso = varEspaciosCasasGetProvider
            .espacioscasa
            .datosadicionalescasa
            .otrascaracteristicas;

      case "elementosadicionalescasa":
        return variableRegreso =
            varEspaciosCasasGetProvider.espacioscasa.elementosadicionalescasa;

      case "precioventa":
        return variableRegreso =
            varEspaciosCasasGetProvider.espacioscasa.precioventa;
      case "preciorenta":
        return variableRegreso =
            varEspaciosCasasGetProvider.espacioscasa.preciorenta;
      case "mantenimiento":
        return variableRegreso =
            varEspaciosCasasGetProvider.espacioscasa.mantenimiento;
      case "moneda":
        return variableRegreso =
            varEspaciosCasasGetProvider.espacioscasa.moneda;
      case "niveldeprioridad":
        return variableRegreso =
            varEspaciosCasasGetProvider.espacioscasa.niveldeprioridad;
      case "condicionesdeventa":
        return variableRegreso =
            varEspaciosCasasGetProvider.espacioscasa.condicionesdeventa;
      case "fotoprincipal":
        return variableRegreso =
            varEspaciosCasasGetProvider.espacioscasa.fotoprincipal;
      case "numerodefotos":
        return variableRegreso =
            varEspaciosCasasGetProvider.espacioscasa.numerodefotos;

      case "nombre":
        return variableRegreso = varEspaciosCasasGetProvider
            .espacioscasa
            .datosdelcontactocasa
            .nombre;
      case "empresa":
        return variableRegreso = varEspaciosCasasGetProvider
            .espacioscasa
            .datosdelcontactocasa
            .empresa;
      case "numerocelular":
        return variableRegreso = varEspaciosCasasGetProvider
            .espacioscasa
            .datosdelcontactocasa
            .numerocelular;
      case "numerootro":
        return variableRegreso = varEspaciosCasasGetProvider
            .espacioscasa
            .datosdelcontactocasa
            .numerootro;
      case "numeroinmobiliaria":
        return variableRegreso = varEspaciosCasasGetProvider
            .espacioscasa
            .datosdelcontactocasa
            .numeroinmobiliaria;
      case "correoelectronico":
        return variableRegreso = varEspaciosCasasGetProvider
            .espacioscasa
            .datosdelcontactocasa
            .correoelectronico;
      case "idusuariocontacto":
        return variableRegreso = varEspaciosCasasGetProvider
            .espacioscasa
            .datosdelcontactocasa
            .idusuariocontacto;
      case "nombreusuariocontacto":
        return variableRegreso = varEspaciosCasasGetProvider
            .espacioscasa
            .datosdelcontactocasa
            .nombreusuariocontacto;
      case "imgendelcontacto":
        return variableRegreso = varEspaciosCasasGetProvider
            .espacioscasa
            .datosdelcontactocasa
            .imgendelcontacto;

      case "pais":
        return variableRegreso =
            varEspaciosCasasGetProvider.espacioscasa.ubicacioncasa.pais;

      case "idEstado":
        return variableRegreso = varEspaciosCasasGetProvider
            .espacioscasa
            .ubicacioncasa
            .localidadCp
            .idEstado
            .toString();
      case "estado":
        return variableRegreso = varEspaciosCasasGetProvider
            .espacioscasa
            .ubicacioncasa
            .localidadCp
            .estado;
      case "idMunicipio":
        return variableRegreso = varEspaciosCasasGetProvider
            .espacioscasa
            .ubicacioncasa
            .localidadCp
            .idMunicipio
            .toString();
      case "municipio":
        return variableRegreso = varEspaciosCasasGetProvider
            .espacioscasa
            .ubicacioncasa
            .localidadCp
            .municipio;
      case "ciudad":
        return variableRegreso = varEspaciosCasasGetProvider
            .espacioscasa
            .ubicacioncasa
            .localidadCp
            .ciudad;
      case "zona":
        return variableRegreso = varEspaciosCasasGetProvider
            .espacioscasa
            .ubicacioncasa
            .localidadCp
            .zona;
      case "asentamiento":
        return variableRegreso = varEspaciosCasasGetProvider
            .espacioscasa
            .ubicacioncasa
            .localidadCp
            .asentamiento;
      case "codigopostal":
        return variableRegreso = varEspaciosCasasGetProvider
            .espacioscasa
            .ubicacioncasa
            .localidadCp
            .cp
            .toString();
      case "tipo":
        return variableRegreso = varEspaciosCasasGetProvider
            .espacioscasa
            .ubicacioncasa
            .localidadCp
            .tipo;

      case "calle":
        return variableRegreso =
            varEspaciosCasasGetProvider.espacioscasa.ubicacioncasa.calle;
      case "numeroexterior":
        return variableRegreso = varEspaciosCasasGetProvider
            .espacioscasa
            .ubicacioncasa
            .numeroexterior;
      case "numerointerior":
        return variableRegreso = varEspaciosCasasGetProvider
            .espacioscasa
            .ubicacioncasa
            .numerointerior;
      case "entrecalle01":
        return variableRegreso =
            varEspaciosCasasGetProvider.espacioscasa.ubicacioncasa.entrecalle01;
      case "entrecalle02":
        return variableRegreso =
            varEspaciosCasasGetProvider.espacioscasa.ubicacioncasa.entrecalle02;

      case "latitud":
        return variableRegreso =
            varEspaciosCasasGetProvider.espacioscasa.ubicacioncasa.latitud;
      case "longitud":
        return variableRegreso =
            varEspaciosCasasGetProvider.espacioscasa.ubicacioncasa.longitud;
      case "latitudDecimal":
        return variableRegreso = varEspaciosCasasGetProvider
            .espacioscasa
            .ubicacioncasa
            .latitudDecimal;
      case "longitudDecimal":
        return variableRegreso = varEspaciosCasasGetProvider
            .espacioscasa
            .ubicacioncasa
            .longitudDecimal;

      case "diapublicacion":
        return variableRegreso = varEspaciosCasasGetProvider
            .espacioscasa
            .fechadepublicacioncasa
            .dia
            .toStringAsFixed(0);
      case "mespublicacion":
        return variableRegreso = varEspaciosCasasGetProvider
            .espacioscasa
            .fechadepublicacioncasa
            .mes
            .toStringAsFixed(0);
      case "aniopublicacion":
        return variableRegreso = varEspaciosCasasGetProvider
            .espacioscasa
            .fechadepublicacioncasa
            .anio
            .toStringAsFixed(0);

      case "diadecierre":
        return variableRegreso = varEspaciosCasasGetProvider
            .espacioscasa
            .fechadecierrecasa
            .dia
            .toStringAsFixed(0);
      case "mesdecierre":
        return variableRegreso = varEspaciosCasasGetProvider
            .espacioscasa
            .fechadecierrecasa
            .mes
            .toStringAsFixed(0);
      case "aniodecierre":
        return variableRegreso = varEspaciosCasasGetProvider
            .espacioscasa
            .fechadecierrecasa
            .anio
            .toStringAsFixed(0);

      case "activa":
        return variableRegreso = varEspaciosCasasGetProvider.espacioscasa.activa
            .toStringAsFixed(0);
      case "timestampcasa":
        return variableRegreso =
            varEspaciosCasasGetProvider.espacioscasa.timestampcasa;
    }
    //debugPrintLevels(10, "----- getCampoEspaciosCasasGet campo = $campo, valor: $variableRegreso");
    return variableRegreso;
  }

  //-----------------------------------------------------------------------------
  String getNombreDelCampoPropiedadCasaGet(String nombreDelCampo) {
    //debugPrintLevels(10, 'HTTP getNombreDelCampoPropiedadCasaGet');

    String variableRegreso = "";
    switch (nombreDelCampo) {
      case "id":
        return variableRegreso = "Identificador";
      case "rev":
        return variableRegreso = "Revisión";
      case "versiondelformato":
        return variableRegreso = "Versión del formato";
      case "idPropiedad":
        return variableRegreso = "id Propiedad";
      case "clavedelapropiedad":
        return variableRegreso = "Clave de la propiedad";
      case "idusuario":
        return variableRegreso = "id Usuario";

      case "tipodeanuncio":
        return variableRegreso = "Tipo de anuncio";
      case "tipodetransaccion":
        return variableRegreso = "Tipo de transaccion";
      case "idTransaccion":
        return variableRegreso = "id Transacción";

      case "nombredelapropiedad":
        return variableRegreso = "Nombre de la propiedad";
      case "inmobiliaria":
        return variableRegreso = "Inmobiliaria";
      case "inmobiliariaimagen":
        return variableRegreso = "Imagen de la inmobiliaria";
      case "linkinmobiliaria":
        return variableRegreso = "Sitio Web de la inmobiliaria";
      case "sloganinmobiliaria":
        return variableRegreso = "Slogan de la inmobiliaria";
      case "ubicaciongeneral":
        return variableRegreso = "Ubicación general";

      case "tipodepropiedad":
        return variableRegreso = "Tipo de propiedad";

      case "descripcion":
        return variableRegreso = "Descripción";
      case "letreropromocional":
        return variableRegreso = "Letrero promocional";
      case "metrosdeterreno":
        return variableRegreso = "Metros de terreno";
      case "metrosconstruidos":
        return variableRegreso = "Metros construidos";
      case "recamaras":
        return variableRegreso = "Recamaras";
      case "banos":
        return variableRegreso = "Baños";
      case "mediosbanos":
        return variableRegreso = "Medios baños";
      case "cuartosdeservicio":
        return variableRegreso = "Cuartos de servicio";
      case "estacionamientos":
        return variableRegreso = "Estacionamientos";
      case "estacionamientoscubiertos":
        return variableRegreso = "Estacionamientos cubiertos";

      case "panelessolares":
        return variableRegreso = "Paneles solares";
      case "jardin":
        return variableRegreso = "Jardín";
      case "alberca":
        return variableRegreso = "Alberca";
      case "calefaccion":
        return variableRegreso = "Calefacción";
      case "aireacondicionado":
        variableRegreso = "Aire acondicionado";
      case "seguridad":
        return variableRegreso = "Seguridad";
      case "enfraccionamiento":
        variableRegreso = "En fraccionamiento";
      case "casasenelconjunto":
        variableRegreso = "Casas en el conjunto";
      case "casaclub":
        return variableRegreso = "Casa club";
      case "salondeeventos":
        variableRegreso = "Salón de eventos";
      case "centrodenegocios":
        variableRegreso = "Centro de negocios";
      case "gimnacio":
        return variableRegreso = "Gimnacio";
      case "cisterna":
        return variableRegreso = "Cisterna";
      case "almacenamientodeagua":
        variableRegreso = "Capacidad de almacenamiento de agua";
      case "tratamientodeaguas":
        variableRegreso = "Tratamiento de aguas";
      case "otrascaracteristicas":
        variableRegreso = "Otras características";

      case "elementosadicionalescasa":
        return variableRegreso = "Elementos adicionales";

      case "precioventa":
        return variableRegreso = "Precio de venta";
      case "preciorenta":
        return variableRegreso = "Precio de renta";
      case "mantenimiento":
        return variableRegreso = "Cuota de mantenimiento (al mes)";
      case "moneda":
        return variableRegreso = "Moneda";

      case "niveldeprioridad":
        return variableRegreso = "Nivel de prioridad";
      case "condicionesdeventa":
        return variableRegreso = "Condiciones";
      case "fotoprincipal":
        return variableRegreso = "Foto principal";
      case "numerodefotos":
        return variableRegreso = "Número de fotos";
      case "linkvideo":
        return variableRegreso = "Video de la propiedad";

      case "nombre":
        return variableRegreso = "Nombre del contacto";
      case "empresa":
        return variableRegreso = "Nombre de la inmobiliaria";
      case "imgendeempresa":
        return variableRegreso = "Imagen de la inmobiliaria";
      case "numerocelular":
        return variableRegreso = "Número de celular";
      case "numerootro":
        return variableRegreso = "Número de celular secundario";
      case "numeroinmobiliaria":
        return variableRegreso = "Número de la inmobiliaria";
      case "correoelectronico":
        return variableRegreso = "Correo electronico";
      case "idusuariocontacto":
        return variableRegreso = "id del usuario de contacto";
      case "nombreusuariocontacto":
        return variableRegreso = "Nombre del usuario de contacto";
      case "imgendelcontacto":
        return variableRegreso = "Imgen del contacto";

      case "pais":
        return variableRegreso = "PaÍs";
      case "estado":
        return variableRegreso = "Estado";
      case "municipio":
        return variableRegreso = "Municipio";
      case "ciudad":
        return variableRegreso = "Ciudad";
      case "zona":
        return variableRegreso = "Zona";
      case "asentamiento":
        return variableRegreso = "Colonia";
      case "codigopostal":
        return variableRegreso = "código postal";
      case "tipo":
        return variableRegreso = "tipo";
      case "calle":
        return variableRegreso = "calle";
      case "numeroexterior":
        return variableRegreso = "número exterior";
      case "numerointerior":
        return variableRegreso = "número interior";
      case "entrecalle01":
        return variableRegreso = "Entre la calle";
      case "entrecalle02":
        return variableRegreso = "y la calle";
      case "latitud":
        return variableRegreso = "Latitud";
      case "longitud":
        return variableRegreso = "Longitud";
      case "latitudDecimal":
        return variableRegreso = "LatitudDecimal";
      case "longitudDecimal":
        return variableRegreso = "LongitudDecimal";

      case "diapublicacion":
        return variableRegreso = "Día de publicación";
      case "mespublicacion":
        return variableRegreso = "Mes de publicación";
      case "aniopublicacion":
        return variableRegreso = "Año de publicación";

      case "diadecierre":
        return variableRegreso = "Día de cierre";
      case "mesdecierre":
        return variableRegreso = "Mes de cierre";
      case "aniodecierre":
        return variableRegreso = "Año de cierre";
      case "activa":
        return variableRegreso = "Activa";
      case "timestampcasa":
        return variableRegreso = "Marca temporal";
    }
    return variableRegreso;
  }

  //-----------------------------------------------------------------------------
  void setchecklistAdicionalesGet() {
    debugPrintLevels(10, 'HTTP setchecklistAdicionalesGet');

    if (state
            .espaciosCasas
            .rows[state.index]
            .value
            .espacioscasa
            .datosadicionalescasa
            .panelessolares ==
        "si") {
      checklistAdicionales["panelessolares"] = true;
    }

    if (state
            .espaciosCasas
            .rows[state.index]
            .value
            .espacioscasa
            .datosadicionalescasa
            .jardin ==
        "si") {
      checklistAdicionales["jardin"] = true;
    }
    if (state
            .espaciosCasas
            .rows[state.index]
            .value
            .espacioscasa
            .datosadicionalescasa
            .alberca ==
        "si") {
      checklistAdicionales["alberca"] = true;
    }
    if (state
            .espaciosCasas
            .rows[state.index]
            .value
            .espacioscasa
            .datosadicionalescasa
            .calefaccion ==
        "si") {
      checklistAdicionales["calefaccion"] = true;
    }
    if (state
            .espaciosCasas
            .rows[state.index]
            .value
            .espacioscasa
            .datosadicionalescasa
            .aireacondicionado ==
        "si") {
      checklistAdicionales["aireacondicionado"] = true;
    }
    if (state
            .espaciosCasas
            .rows[state.index]
            .value
            .espacioscasa
            .datosadicionalescasa
            .seguridad ==
        "si") {
      checklistAdicionales["seguridad"] = true;
    }
    if (state
            .espaciosCasas
            .rows[state.index]
            .value
            .espacioscasa
            .datosadicionalescasa
            .enfraccionamiento ==
        "si") {
      checklistAdicionales["enfraccionamiento"] = true;
    }
    if (state
            .espaciosCasas
            .rows[state.index]
            .value
            .espacioscasa
            .datosadicionalescasa
            .casasenelconjunto ==
        "si") {
      checklistAdicionales["casasenelconjunto"] = true;
    }
    if (state
            .espaciosCasas
            .rows[state.index]
            .value
            .espacioscasa
            .datosadicionalescasa
            .casaclub ==
        "si") {
      checklistAdicionales["casaclub"] = true;
    }
    if (state
            .espaciosCasas
            .rows[state.index]
            .value
            .espacioscasa
            .datosadicionalescasa
            .salondeeventos ==
        "si") {
      checklistAdicionales["salondeeventos"] = true;
    }
    if (state
            .espaciosCasas
            .rows[state.index]
            .value
            .espacioscasa
            .datosadicionalescasa
            .centrodenegocios ==
        "si") {
      checklistAdicionales["centrodenegocios"] = true;
    }
    if (state
            .espaciosCasas
            .rows[state.index]
            .value
            .espacioscasa
            .datosadicionalescasa
            .gimnacio ==
        "si") {
      checklistAdicionales["gimnacio"] = true;
    }
    if (state
            .espaciosCasas
            .rows[state.index]
            .value
            .espacioscasa
            .datosadicionalescasa
            .cisterna ==
        "si") {
      checklistAdicionales["cisterna"] = true;
    }
    if (state
            .espaciosCasas
            .rows[state.index]
            .value
            .espacioscasa
            .datosadicionalescasa
            .almacenamientodeagua ==
        "si") {
      checklistAdicionales["almacenamientodeagua"] = true;
    }
    if (state
            .espaciosCasas
            .rows[state.index]
            .value
            .espacioscasa
            .datosadicionalescasa
            .tratamientodeaguas ==
        "si") {
      checklistAdicionales["tratamientodeaguas"] = true;
    }
    if (state
            .espaciosCasas
            .rows[state.index]
            .value
            .espacioscasa
            .datosadicionalescasa
            .otrascaracteristicas ==
        "si") {
      checklistAdicionales["otrascaracteristicas"] = true;
    }
  }

  //-----------------------------------------------------------------------------
  String getAdicionalesEspaciosCasasGet(int campo) {
    debugPrintLevels(10, 'HTTP getAdicionalesEspaciosCasasGet');

    String variableRegreso = "";

    final varEspaciosCasasGetProvider =
        state.espaciosCasas.rows[state.index].value.espacioscasa;

    switch (campo) {
      case 0:
        variableRegreso =
            varEspaciosCasasGetProvider.datosadicionalescasa.panelessolares;
      case 1:
        return variableRegreso =
            varEspaciosCasasGetProvider.datosadicionalescasa.jardin;
      case 2:
        return variableRegreso =
            varEspaciosCasasGetProvider.datosadicionalescasa.alberca;
      case 3:
        return variableRegreso =
            varEspaciosCasasGetProvider.datosadicionalescasa.calefaccion;
      case 4:
        variableRegreso =
            varEspaciosCasasGetProvider.datosadicionalescasa.aireacondicionado;
      case 5:
        return variableRegreso =
            varEspaciosCasasGetProvider.datosadicionalescasa.seguridad;
      case 6:
        variableRegreso =
            varEspaciosCasasGetProvider.datosadicionalescasa.enfraccionamiento;
      case 7:
        variableRegreso =
            varEspaciosCasasGetProvider.datosadicionalescasa.casasenelconjunto;
      case 8:
        return variableRegreso =
            varEspaciosCasasGetProvider.datosadicionalescasa.casaclub;
      case 9:
        variableRegreso =
            varEspaciosCasasGetProvider.datosadicionalescasa.salondeeventos;
      case 10:
        variableRegreso =
            varEspaciosCasasGetProvider.datosadicionalescasa.centrodenegocios;
      case 11:
        return variableRegreso =
            varEspaciosCasasGetProvider.datosadicionalescasa.gimnacio;
      case 12:
        return variableRegreso =
            varEspaciosCasasGetProvider.datosadicionalescasa.cisterna;
      case 13:
        variableRegreso = varEspaciosCasasGetProvider
            .datosadicionalescasa
            .almacenamientodeagua;
      case 14:
        variableRegreso =
            varEspaciosCasasGetProvider.datosadicionalescasa.tratamientodeaguas;
      case 15:
        variableRegreso = varEspaciosCasasGetProvider
            .datosadicionalescasa
            .otrascaracteristicas;
      default:
        variableRegreso = "";
    }
    return variableRegreso;
  }
}

//-----------------------------------------------------------------------------
//------------------------------------------------------------------------------
/*
final setEspaciosCasaFutureProvider = FutureProvider<int>(
  (ref) async {
    debugPrintLevels(10, 'FutureProvider setEspaciosCasaFutureProvider');

    return await ref
        .read(espaciosCasaConListaFotosGetProvider.notifier)
        .writePropiedadCasaToCouchDB();
  },
);
*/
//-----------------------------------------------------------------------------
/*
final saveEspaciosCasaFutureProvider = FutureProvider<int>(
  (ref) async {
    debugPrintLevels(10, 'FutureProvider saveEspaciosCasaFutureProvider');
    String idFoto = "";
    ValueEspaciosCasaGet propiedad = ValueEspaciosCasaGet(
      id: "",
      rev: '',
      espacioscasa: EspaciosCasa(
          versiondelformato: "",
          idPropiedad: "",
          clavedelapropiedad: "",
          idusuario: "",
          tipodeanuncio: "",
          tipodepropiedad: "",
          tipodetransaccion: "",
          idTransaccion: "",
          nombredelapropiedad: "",
          inmobiliaria: "",
          inmobiliariaimagen: "",
          linkinmobiliaria: "",
          sloganinmobiliaria: "",
          ubicaciongeneral: "",
          descripcion: "",
          letreropromocional: "",
          metrosdeterreno: "",
          metrosconstruidos: "",
          recamaras: "",
          banos: "",
          mediosbanos: "",
          cuartosdeservicio: "",
          estacionamientos: "",
          estacionamientoscubiertos: "",
          datosadicionalescasa: Datosadicionalescasa(
            panelessolares: '',
            jardin: '',
            alberca: '',
            calefaccion: '',
            aireacondicionado: '',
            seguridad: '',
            enfraccionamiento: '',
            casasenelconjunto: '',
            casaclub: '',
            salondeeventos: '',
            centrodenegocios: '',
            gimnacio: '',
            cisterna: '',
            almacenamientodeagua: '',
            tratamientodeaguas: '',
            otrascaracteristicas: '',
          ),
          elementosadicionalescasa: "",
          precioventa: "",
          preciorenta: "",
          mantenimiento: "",
          moneda: "",
          niveldeprioridad: "",
          condicionesdeventa: "",
          fotoprincipal: "",
          numerodefotos: "",
          linkvideo: "",
          datosdelcontactocasa: Datosdelcontactocasa(
            nombre: "",
            empresa: "",
            imgendeempresa: "",
            numerocelular: "",
            numerootro: "",
            numeroinmobiliaria: "",
            correoelectronico: "",
            idusuariocontacto: "",
            nombreusuariocontacto: "",
            imgendelcontacto: "",
          ),
          ubicacioncasa: Ubicacioncasa(
              pais: "",
              localidadCp: LocalidadCp(
                idEstado: 0,
                estado: "",
                idMunicipio: 0,
                municipio: "",
                ciudad: "",
                zona: "",
                cp: 0,
                asentamiento: "",
                tipo: "",
              ),
              calle: "",
              numeroexterior: "",
              numerointerior: "",
              entrecalle01: "",
              entrecalle02: "",
              latitud: "",
              longitud: "",
              latitudDecimal: "",
              longitudDecimal: ""),
          fechadepublicacioncasa: Fechadecasa(dia: 0, mes: 0, anio: 0),
          fechadecierrecasa: Fechadecasa(dia: 0, mes: 0, anio: 0),
          activa: 0,
          timestampcasa: ""),
    );
    return await ref
        .read(espaciosCasaConListaFotosGetProvider.notifier)
        .updateFotoPrincipalPropiedad(idFoto, propiedad);
  },
);
*/
//-----------------------------------------------------------------------------
final listaEspaciosCasaFutureProvider = FutureProvider<int>((ref) async {
  debugPrintLevels(10, 'FutureProvider listaEspaciosCasaFutureProvider');

  return await ref
      .read(espaciosCasaConListaFotosGetProvider.notifier)
      .getPropiedadesCasaIdUser(ref as WidgetRef);
});
*/