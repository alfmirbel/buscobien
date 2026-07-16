import 'dart:convert';
import 'dart:core';
import 'dart:math';
import 'package:http/http.dart' as http;

import '../../../../10_user_login/usuario_login/provider_session.dart';
import '../../../../40_security/direccionip.dart';
import '../../../../40_security/generate_hash.dart';
import '../../../../40_security/urls_endpoints_espacios.dart';
import '../../../ubicacion/data_sepomex_localidades.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../60_global_widgets/debugprint.dart';
import 'data_compra_espacios.dart';
import 'data_compra_espacios_get.dart';
import '../../../inicio/data_espacios_casas.dart';

CompraEspacio initialCompraDeEspacio = CompraEspacio(
  versiondelformato: "0.00.00", // hash
  idUsuario: "",
  idTransaccion: "",
  noDeEspaciosNormales: 0,
  noDeEspaciosDestacados: 0,
  noDeEspaciosSuperdestacados: 0,
  noDeEspaciosOportunidades: 0,
  noDeEspaciosRemates: 0,

  fechaDeCompra: FechaDe(dia: 0, mes: 0, anio: 0),
  fechaDePago: FechaDe(dia: 0, mes: 0, anio: 0),

  medioDePago: "",
  referenciaDePago: "",
  mesesContratados: 0,
  vencimiento: "",
  vigente: 0,
  totalEspacioNormal: 0,
  totalEspacioDestacado: 0,
  totalEspacioSuperdestacado: 0,
  totalEspaciosOportunidades: 0,
  totalEspaciosRemates: 0,
  impuestos: 0,
  granTotal: 0,
  timestamp: "",
);

CompraEspacioGet initialGetCompraDeEspacio = CompraEspacioGet(
  totalRows: 0,
  offset: 0,
  rows: [
    RowCompraEspacio(
      id: "",
      key: "",
      value: ValueCompraEspacio(
        id: "",
        rev: "",
        espacio: CompraEspacio(
          versiondelformato: "0.00.00", // hash
          idUsuario: "",
          idTransaccion: "",
          noDeEspaciosNormales: 0,
          noDeEspaciosDestacados: 0,
          noDeEspaciosSuperdestacados: 0,
          noDeEspaciosOportunidades: 0,
          noDeEspaciosRemates: 0,

          fechaDeCompra: FechaDe(dia: 0, mes: 0, anio: 0),
          fechaDePago: FechaDe(dia: 0, mes: 0, anio: 0),

          medioDePago: "",
          referenciaDePago: "",
          mesesContratados: 0,
          vencimiento: "",
          vigente: 0,
          totalEspacioNormal: 0,
          totalEspacioDestacado: 0,
          totalEspacioSuperdestacado: 0,
          totalEspaciosOportunidades: 0,
          totalEspaciosRemates: 0,
          impuestos: 0,
          granTotal: 0,
          timestamp: "",
        ),
      ),
    ),
  ],
);

//------------------------------------------------------------------------------
final compraDeEspaciosProvider =
    NotifierProvider<ClassCompraEspaciosNotifierProvider, CompraEspacio>(() {
      return ClassCompraEspaciosNotifierProvider();
    });
//--

class ClassCompraEspaciosNotifierProvider extends Notifier<CompraEspacio> {
  // initial value
  @override
  CompraEspacio build() {
    return CompraEspacio(
      versiondelformato: "0.00.00", // hash
      idUsuario: "",
      idTransaccion: "",
      noDeEspaciosNormales: 0,
      noDeEspaciosDestacados: 0,
      noDeEspaciosSuperdestacados: 0,
      noDeEspaciosOportunidades: 0,
      noDeEspaciosRemates: 0,

      fechaDeCompra: FechaDe(dia: 0, mes: 0, anio: 0),
      fechaDePago: FechaDe(dia: 0, mes: 0, anio: 0),

      medioDePago: "",
      referenciaDePago: "",
      mesesContratados: 0,
      vencimiento: "",
      vigente: 0,
      totalEspacioNormal: 0,
      totalEspacioDestacado: 0,
      totalEspacioSuperdestacado: 0,
      totalEspaciosOportunidades: 0,
      totalEspaciosRemates: 0,
      impuestos: 0,
      granTotal: 0,
      timestamp: "",
    );
  }
  //------------------------------------------------------------------------------

  Future<int> writeCompraEspaciosToCouchDB(WidgetRef ref) async {
    DateTime timeStamp = DateTime.now();
    int resultado = 0;
    debugPrintLevels(2, "01. writeCompraEspaciosToCouchDB");
    //
    String compraJson = "";
    //
    String idTransaccion =
        state.idUsuario +
        timeStamp.toString() +
        (1000 + Random().nextInt(999)).toString();
    debugPrintLevels(2, "idTransaccion $idTransaccion");

    idTransaccion = generateSHA1Hash(idTransaccion);

    setCampoEspacioCompra(
      ref,
      "idUsuario",
      ref
          .read(sessionProvider.notifier)
          .getSessionVarValue("idUsuario"),
    );
    setCampoEspacioCompra(ref, "idTransaccion", idTransaccion);
    debugPrintLevels(
      2,
      "02. writeCompraEspaciosToCouchDB clave idTransaccion $idTransaccion",
    );
    // ----------------------------------------------------------------------------
    setCampoEspacioCompra(ref, "timestamp", timeStamp.toString());
    //-----------------------------------------------------------------------------
    compraJson = compraEspacioToJson(ref.watch(compraDeEspaciosProvider));
    debugPrintLevels(2, "03. writeCompraEspaciosToCouchDB Compra: $compraJson");

    String basicAuth =
        'Basic ${base64Encode(utf8.encode('$username:$password'))}';
    Map<String, String> headers = {
      'Authorization': basicAuth,
      'Content-Type': 'application/json',
    };
    //-----------------------------------------------------------------------------

    String url = '$direccionip/buscobien_compra_espacios';

    http.post(Uri.parse(url), headers: headers, body: compraJson).then((
      response,
    ) {
      if (response.statusCode == 201) {
        debugPrintLevels(
          2,
          '04. writeCompraEspaciosToCouchDB Data written to CouchDB successfully!',
        );
        resultado = 200;
        debugPrintLevels(2, "05. writeCompraEspaciosToCouchDB Genera Espacios");
        creaEspacioCompradoToCouchDB(ref, "normales").then((onValue) {
          debugPrintLevels(2, 'Termina de genera espacios normales');
          creaEspacioCompradoToCouchDB(ref, "destacados").then((onValue) {
            debugPrintLevels(2, 'Termina de genera espacios destacados');
            creaEspacioCompradoToCouchDB(ref, "superdestacados").then((
              onValue,
            ) {
              debugPrintLevels(2, 'Termina de genera espacios superdestacados');
              creaEspacioCompradoToCouchDB(ref, "oportunidades").then((
                onValue,
              ) {
                debugPrintLevels(2, 'Termina de genera oportunidades');
                creaEspacioCompradoToCouchDB(ref, "remates").then((onValue) {
                  debugPrintLevels(
                    2,
                    '05. writeCompraEspaciosToCouchDB Termina de genear remates',
                  );
                });
              });
            });
          });
        });
      } else {
        debugPrintLevels(
          2,
          'Error writing data to CouchDB: ${response.statusCode}',
        );
        resultado = 400;
      }
    });
    //---------------
    return resultado;
  }
  //-----------------------------------------------------------------------------

  Future<int> creaEspacioCompradoToCouchDB(
    WidgetRef ref,
    String tipoDeEspacio,
  ) async {
    DateTime timeStamp = DateTime.now();
    int resultado = 0;
    //
    String propiedadJson = "";
    String url = '';
    String idpropiedadbase = "";
    int numerodeespacios = 0;
    EspaciosCasa datosPropiedadCrear = EspaciosCasa(
      versiondelformato: "01.00",
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
        longitudDecimal: "",
      ),
      fechadepublicacioncasa: Fechadecasa(dia: 0, mes: 0, anio: 0),
      fechadecierrecasa: Fechadecasa(dia: 0, mes: 0, anio: 0),
      activa: 1,
      timestampcasa: "",
    );

    String basicAuth =
        'Basic ${base64Encode(utf8.encode('$username:$password'))}';
    Map<String, String> headers = {
      'Authorization': basicAuth,
      'Content-Type': 'application/json',
    };
    //-----------------------------------------------------------------------------
    switch (tipoDeEspacio) {
      case "normales":
        url = '$direccionip/${endpointsCaptura["Normales"]}';
        numerodeespacios = state.noDeEspaciosNormales;
        break;
      case "destacados":
        url = '$direccionip/${endpointsCaptura["Destacados"]}';
        numerodeespacios = state.noDeEspaciosDestacados;
        break;
      case "superdestacados":
        url = '$direccionip/${endpointsCaptura["Superdestacados"]}';
        numerodeespacios = state.noDeEspaciosSuperdestacados;
        break;
      case "oportunidades":
        url = '$direccionip/${endpointsCaptura["Oportunidades"]}';
        numerodeespacios = state.noDeEspaciosOportunidades;
        break;
      case "remates":
        url = '$direccionip/${endpointsCaptura["Remates"]}';
        numerodeespacios = state.noDeEspaciosRemates;
        break;
      default:
        numerodeespacios = 0;
    }
    // ref.read(espaciosCasaConListaFotosGetProvider.notifier).resetEspaciosCasasGet();
    //
    for (var i = 0; i < numerodeespacios; i++) {
      // ref.read(espaciosCasaConListaFotosGetProvider.notifier).setIndexEspaciosCasas(i);

      idpropiedadbase =
          getCampoEspacioCompra(ref, "idTransaccion") +
          timeStamp.toString() +
          (1000 + Random().nextInt(999)).toString();

      String idDeLaPropiedad = generateSHA1Hash(idpropiedadbase);

      datosPropiedadCrear.idPropiedad = idDeLaPropiedad;
      debugPrintLevels(2, "idPropiedad $idDeLaPropiedad");
      // ----------------------------------------------------------------------------
      String clavepropiedad = idDeLaPropiedad.substring(1, 2);
      clavepropiedad += idDeLaPropiedad.substring(5, 6);
      clavepropiedad += idDeLaPropiedad.substring(10, 11);
      clavepropiedad += idDeLaPropiedad.substring(15, 16);
      clavepropiedad += idDeLaPropiedad.substring(20, 21);
      clavepropiedad += idDeLaPropiedad.substring(25, 26);
      clavepropiedad += idDeLaPropiedad.substring(30, 31);
      clavepropiedad += idDeLaPropiedad.substring(35, 36);

      datosPropiedadCrear.clavedelapropiedad = clavepropiedad;
      datosPropiedadCrear.idusuario = ref
          .read(sessionProvider.notifier)
          .getSessionVarValue("idUsuario");
      datosPropiedadCrear.idTransaccion = getCampoEspacioCompra(
        ref,
        "idTransaccion",
      );
      datosPropiedadCrear.tipodeanuncio = tipoDeEspacio;

      datosPropiedadCrear.clavedelapropiedad = clavepropiedad;

      datosPropiedadCrear.fechadepublicacioncasa.dia = timeStamp.day;
      datosPropiedadCrear.fechadepublicacioncasa.mes = timeStamp.month;
      datosPropiedadCrear.fechadepublicacioncasa.anio = timeStamp.year;
      datosPropiedadCrear.activa = 0;
      datosPropiedadCrear.timestampcasa = timeStamp.toString();
      //-----------------------------------------------------------------------------
      propiedadJson =
          '{"espacioscasa": ${espaciosCasaToJson(datosPropiedadCrear)}}';

      //     propiedadJson = espaciosCasaToJson(
      //         ref.read(espaciosCasaConListaFotosGetProvider).rows[0].value.espacioscasa);

      http.post(Uri.parse(url), headers: headers, body: propiedadJson).then((
        response,
      ) {
        if (response.statusCode == 201) {
          debugPrintLevels(
            2,
            '01. creaEspacioCompradoToCouchDB Data written to CouchDB successfully!',
          );
          resultado = 200;
        } else {
          // debugPrintLevels(2, 'Error writing data to CouchDB: ${response.statusCode}');
          resultado = 400;
        }
      });
    }
    //---------------
    return resultado;
  }

  //-----------------------------------------------------------------------------
  void resetCampoEspacioCompra() {
    state.versiondelformato = "0.00.00";
    state.idUsuario = "";
    state.idTransaccion = "";
    state.noDeEspaciosNormales = 0;
    state.noDeEspaciosDestacados = 0;
    state.noDeEspaciosSuperdestacados = 0;
    state.noDeEspaciosOportunidades = 0;
    state.noDeEspaciosRemates = 0;
    state.fechaDeCompra.dia = 0;
    state.fechaDeCompra.mes = 0;
    state.fechaDeCompra.anio = 0;
    state.fechaDePago.dia = 0;
    state.fechaDePago.mes = 0;
    state.fechaDePago.anio = 0;
    state.medioDePago = "";
    state.referenciaDePago = "";
    state.mesesContratados = 0;
    state.vencimiento = "";
    state.totalEspacioNormal = 0;
    state.totalEspacioDestacado = 0;
    state.totalEspacioSuperdestacado = 0;
    state.totalEspaciosOportunidades = 0;
    state.totalEspaciosRemates = 0;
    state.impuestos = 0;
    state.granTotal = 0;
    state.timestamp = "";
  }

  void setCampoEspacioCompra(WidgetRef ref, String campo, String valor) {
    switch (campo) {
      case "versiondelformato":
        state.versiondelformato = valor;
        break;
      case "idUsuario":
        state.idUsuario = valor;
        break;
      case "idTransaccion":
        state.idTransaccion = valor;
        break;
      case "noDeEspaciosNormales":
        state.noDeEspaciosNormales = int.parse(valor);
        break;
      case "noDeEspaciosDestacados":
        state.noDeEspaciosDestacados = int.parse(valor);
        break;

      case "noDeEspaciosSuperdestacados":
        state.noDeEspaciosSuperdestacados = int.parse(valor);
        break;

      case "noDeEspaciosOportunidades":
        state.noDeEspaciosOportunidades = int.parse(valor);
        break;

      case "noDeEspaciosRemates":
        state.noDeEspaciosRemates = int.parse(valor);
        break;

      case "fechaDeCompraDia":
        state.fechaDeCompra.dia = int.parse(valor);
        break;
      case "fechaDeCompraMes":
        state.fechaDeCompra.mes = int.parse(valor);
        break;
      case "fechaDeCompraAnio":
        state.fechaDeCompra.anio = int.parse(valor);
        break;

      case "fechaDePagoDia":
        state.fechaDePago.dia = int.parse(valor);
        break;
      case "fechaDePagoMes":
        state.fechaDePago.mes = int.parse(valor);
        break;
      case "fechaDePagoAnio":
        state.fechaDePago.anio = int.parse(valor);
        break;

      case "medioDePago":
        state.medioDePago = valor;
        break;
      case "referenciaDePago":
        state.referenciaDePago = valor;
        break;

      case "mesesContratados":
        state.mesesContratados = int.parse(valor);
        break;
      case "vencimiento":
        state.vencimiento = valor;
        break;
      case "totalEspacioNormal":
        state.totalEspacioNormal = double.parse(valor);
        break;
      case "totalEspacioDestacado":
        state.totalEspacioDestacado = double.parse(valor);
        break;
      case "totalEspacioSuperdestacado":
        state.totalEspacioSuperdestacado = double.parse(valor);
        break;
      case "totalEspaciosOportunidades":
        state.totalEspaciosOportunidades = double.parse(valor);
        break;
      case "totalEspaciosRemates":
        state.totalEspaciosRemates = double.parse(valor);
        break;
      case "impuestos":
        state.impuestos = double.parse(valor);
        break;
      case "granTotal":
        state.granTotal = double.parse(valor);
        break;

      case "timestamp":
        state.timestamp = valor;
        break;
    }
  }

  String getCampoEspacioCompra(WidgetRef ref, String campo) {
    switch (campo) {
      case "versiondelformato":
        return state.versiondelformato;
      case "idUsuario":
        return state.idUsuario;
      case "idTransaccion":
        return state.idTransaccion;

      case "noDeEspaciosNormales":
        return state.noDeEspaciosNormales.toString();
      case "noDeEspaciosDestacados":
        return state.noDeEspaciosDestacados.toString();
      case "noDeEspaciosSuperdestacados":
        return state.noDeEspaciosSuperdestacados.toString();
      case "noDeEspaciosOportunidades":
        return state.noDeEspaciosOportunidades.toString();
      case "noDeEspaciosRemates":
        return state.noDeEspaciosRemates.toString();

      case "fechaDeCompraDia":
        return state.fechaDeCompra.dia.toStringAsFixed(0);
      case "fechaDeCompraMes":
        return state.fechaDeCompra.mes.toStringAsFixed(0);
      case "fechaDeCompraAnio":
        return state.fechaDeCompra.anio.toStringAsFixed(0);

      case "fechaDePagoDia":
        return state.fechaDePago.dia.toStringAsFixed(0);
      case "fechaDePagoMes":
        return state.fechaDePago.mes.toStringAsFixed(0);
      case "fechaDePagoAnio":
        return state.fechaDePago.anio.toStringAsFixed(0);

      case "medioDePago":
        return state.medioDePago;
      case "referenciaDePago":
        return state.referenciaDePago;

      case "mesesContratados":
        return state.mesesContratados.toStringAsFixed(0);
      case "vencimiento":
        return state.vencimiento;

      case "totalEspacioNormal":
        return state.totalEspacioNormal.toStringAsFixed(0);
      case "totalEspacioDestacado":
        return state.totalEspacioDestacado.toStringAsFixed(0);
      case "totalEspacioSuperdestacado":
        return state.totalEspacioSuperdestacado.toStringAsFixed(0);
      case "totalEspaciosOportunidades":
        return state.totalEspaciosOportunidades.toStringAsFixed(0);
      case "totalEspaciosRemates":
        return state.totalEspaciosRemates.toStringAsFixed(0);
      case "impuestos":
        return state.impuestos.toStringAsFixed(0);
      case "granTotal":
        return state.granTotal.toStringAsFixed(0);
      case "timestamp":
        return state.timestamp;
      default:
        return "";
    }
  }

  String getNombreDelCampoCompraEspacio(String nombreDelCampo) {
    String variableRegreso = "";
    switch (nombreDelCampo) {
      case "versiondelformato":
        return variableRegreso = "Version del formato";
      case "idUsuario":
        return variableRegreso = "Identificador del Usuario";
      case "idTransaccion":
        return variableRegreso = "Identificador de la transacción";
      case "noDeEspaciosNormales":
        return variableRegreso = "Número de espacios Normales";
      case "noDeEspaciosDestacados":
        return variableRegreso = "Número de espacios Destacados";
      case "noDeEspaciosSuperdestacados":
        return variableRegreso = "Número de espacios Superdestacados";
      case "noDeEspaciosOportunidades":
        return variableRegreso = "Número de espacios Oportunidades";
      case "noDeEspaciosRemates":
        return variableRegreso = "Número de espacios Remates";

      case "fechaDeCompraDia":
        return variableRegreso = "Día de la compra";
      case "fechaDeCompraMes":
        return variableRegreso = "Mes de la compra";
      case "fechaDeCompraAnio":
        return variableRegreso = "Año de la compra";

      case "fechaDePagoDia":
        return variableRegreso = "Día del Pago";
      case "fechaDePagoMes":
        return variableRegreso = "Mes del Pago";
      case "fechaDePagoAnio":
        return variableRegreso = "Año del Pago";

      case "medioDePago":
        return variableRegreso = "Medio de Pago";
      case "referenciaDePago":
        return variableRegreso = "Referencia del Pago";

      case "mesesContratados":
        return variableRegreso = "Meses contratados";
      case "vencimiento":
        return variableRegreso = "Vencimiento";
      case "totalEspacioNormal":
        return variableRegreso = "Total por los espacios Normales";
      case "totalEspacioDestacado":
        return variableRegreso = "Total por los espacios Destacados";
      case "totalEspacioSuperdestacado":
        return variableRegreso = "Total por los espacios SuperdestacadoS";
      case "totalEspaciosOportunidades":
        return variableRegreso = "Total por los espacios para Oportunidades";
      case "totalEspaciosRemates":
        return variableRegreso = "Total por los espacios para Remates";
      case "impuestos":
        return variableRegreso = "IVA";
      case "granTotal":
        return variableRegreso = "Gran Total";
      case "timestamp":
        return variableRegreso = "Estampa de tiempo";
    }
    return variableRegreso;
  }
}

//------------------------------------------------------------------------------
final getCompraEspaciosFutureProvider = FutureProvider<int>((ref) async {
  return await ref
      .read(compraDeEspaciosProvider.notifier)
      .writeCompraEspaciosToCouchDB(ref as WidgetRef);
});
