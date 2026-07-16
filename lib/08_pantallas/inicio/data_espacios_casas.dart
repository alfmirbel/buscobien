// To parse this JSON data, do
//
//     final espaciosCasa = espaciosCasaFromJson(jsonString);

import 'dart:convert';

import '../ubicacion/data_sepomex_localidades.dart';

EspaciosCasa espaciosCasaFromJson(String str) =>
    EspaciosCasa.fromJson(json.decode(str));

String espaciosCasaToJson(EspaciosCasa data) => json.encode(data.toJson());

class EspaciosCasa {
  String versiondelformato;
  String idPropiedad;
  String clavedelapropiedad;
  String idusuario;
  String tipodeanuncio;
  String tipodepropiedad;
  String tipodetransaccion;
  String idTransaccion;
  String nombredelapropiedad;
  String inmobiliaria;
  String inmobiliariaimagen;
  String linkinmobiliaria;
  String sloganinmobiliaria;
  String ubicaciongeneral;
  String descripcion;
  String letreropromocional;
  String metrosdeterreno;
  String metrosconstruidos;
  String recamaras;
  String banos;
  String mediosbanos;
  String cuartosdeservicio;
  String estacionamientos;
  String estacionamientoscubiertos;
  Datosadicionalescasa datosadicionalescasa;
  String elementosadicionalescasa;
  String precioventa;
  String preciorenta;
  String mantenimiento;
  String moneda;
  String niveldeprioridad;
  String condicionesdeventa;
  String fotoprincipal;
  String numerodefotos;
  String linkvideo;
  Datosdelcontactocasa datosdelcontactocasa;
  Ubicacioncasa ubicacioncasa;
  Fechadecasa fechadepublicacioncasa;
  Fechadecasa fechadecierrecasa;
  int activa;
  String timestampcasa;

  EspaciosCasa({
    required this.versiondelformato,
    required this.idPropiedad,
    required this.clavedelapropiedad,
    required this.idusuario,
    required this.tipodeanuncio,
    required this.tipodepropiedad,
    required this.tipodetransaccion,
    required this.idTransaccion,
    required this.nombredelapropiedad,
    required this.inmobiliaria,
    required this.inmobiliariaimagen,
    required this.linkinmobiliaria,
    required this.sloganinmobiliaria,
    required this.ubicaciongeneral,
    required this.descripcion,
    required this.letreropromocional,
    required this.metrosdeterreno,
    required this.metrosconstruidos,
    required this.recamaras,
    required this.banos,
    required this.mediosbanos,
    required this.cuartosdeservicio,
    required this.estacionamientos,
    required this.estacionamientoscubiertos,
    required this.datosadicionalescasa,
    required this.elementosadicionalescasa,
    required this.precioventa,
    required this.preciorenta,
    required this.mantenimiento,
    required this.moneda,
    required this.niveldeprioridad,
    required this.condicionesdeventa,
    required this.fotoprincipal,
    required this.numerodefotos,
    required this.linkvideo,
    required this.datosdelcontactocasa,
    required this.ubicacioncasa,
    required this.fechadepublicacioncasa,
    required this.fechadecierrecasa,
    required this.activa,
    required this.timestampcasa,
  });

  factory EspaciosCasa.fromJson(Map<String, dynamic> json) => EspaciosCasa(
    versiondelformato: json["versiondelformato"],
    idPropiedad: json["idPropiedad"],
    clavedelapropiedad: json["clavedelapropiedad"],
    idusuario: json["idusuario"],
    tipodeanuncio: json["tipodeanuncio"],
    tipodepropiedad: json["tipodepropiedad"],
    tipodetransaccion: json["tipodetransaccion"],
    idTransaccion: json["idTransaccion"],
    nombredelapropiedad: json["nombredelapropiedad"],
    inmobiliaria: json["inmobiliaria"],
    inmobiliariaimagen: json["inmobiliariaimagen"],
    linkinmobiliaria: json["linkinmobiliaria"],
    sloganinmobiliaria: json["sloganinmobiliaria"],
    ubicaciongeneral: json["ubicaciongeneral"],
    descripcion: json["descripcion"],
    letreropromocional: json["letreropromocional"],
    metrosdeterreno: json["metrosdeterreno"],
    metrosconstruidos: json["metrosconstruidos"],
    recamaras: json["recamaras"],
    banos: json["banos"],
    mediosbanos: json["mediosbanos"],
    cuartosdeservicio: json["cuartosdeservicio"],
    estacionamientos: json["estacionamientos"],
    estacionamientoscubiertos: json["estacionamientoscubiertos"],
    datosadicionalescasa: Datosadicionalescasa.fromJson(
      json["datosadicionalescasa"],
    ),
    elementosadicionalescasa: json["elementosadicionalescasa"],
    precioventa: json["precioventa"],
    preciorenta: json["preciorenta"],
    mantenimiento: json["mantenimiento"],
    moneda: json["moneda"],
    niveldeprioridad: json["niveldeprioridad"],
    condicionesdeventa: json["condicionesdeventa"],
    fotoprincipal: json["fotoprincipal"],
    numerodefotos: json["numerodefotos"],
    linkvideo: json["linkvideo"],
    datosdelcontactocasa: Datosdelcontactocasa.fromJson(
      json["datosdelcontactocasa"],
    ),
    ubicacioncasa: Ubicacioncasa.fromJson(json["ubicacioncasa"]),
    fechadepublicacioncasa: Fechadecasa.fromJson(
      json["fechadepublicacioncasa"],
    ),
    fechadecierrecasa: Fechadecasa.fromJson(json["fechadecierrecasa"]),
    activa: json["activa"],
    timestampcasa: json["timestampcasa"],
  );

  Map<String, dynamic> toJson() => {
    "versiondelformato": versiondelformato,
    "idPropiedad": idPropiedad,
    "clavedelapropiedad": clavedelapropiedad,
    "idusuario": idusuario,
    "tipodeanuncio": tipodeanuncio,
    "tipodepropiedad": tipodepropiedad,
    "tipodetransaccion": tipodetransaccion,
    "idTransaccion": idTransaccion,
    "nombredelapropiedad": nombredelapropiedad,
    "inmobiliaria": inmobiliaria,
    "inmobiliariaimagen": inmobiliariaimagen,
    "linkinmobiliaria": linkinmobiliaria,
    "sloganinmobiliaria": sloganinmobiliaria,
    "ubicaciongeneral": ubicaciongeneral,
    "descripcion": descripcion,
    "letreropromocional": letreropromocional,
    "metrosdeterreno": metrosdeterreno,
    "metrosconstruidos": metrosconstruidos,
    "recamaras": recamaras,
    "banos": banos,
    "mediosbanos": mediosbanos,
    "cuartosdeservicio": cuartosdeservicio,
    "estacionamientos": estacionamientos,
    "estacionamientoscubiertos": estacionamientoscubiertos,
    "datosadicionalescasa": datosadicionalescasa.toJson(),
    "elementosadicionalescasa": elementosadicionalescasa,
    "precioventa": precioventa,
    "preciorenta": preciorenta,
    "mantenimiento": mantenimiento,
    "moneda": moneda,
    "niveldeprioridad": niveldeprioridad,
    "condicionesdeventa": condicionesdeventa,
    "fotoprincipal": fotoprincipal,
    "numerodefotos": numerodefotos,
    "linkvideo": linkvideo,
    "datosdelcontactocasa": datosdelcontactocasa.toJson(),
    "ubicacioncasa": ubicacioncasa.toJson(),
    "fechadepublicacioncasa": fechadepublicacioncasa.toJson(),
    "fechadecierrecasa": fechadecierrecasa.toJson(),
    "activa": activa,
    "timestampcasa": timestampcasa,
  };
}

class Datosadicionalescasa {
  String panelessolares;
  String jardin;
  String alberca;
  String calefaccion;
  String aireacondicionado;
  String seguridad;
  String enfraccionamiento;
  String casasenelconjunto;
  String casaclub;
  String salondeeventos;
  String centrodenegocios;
  String gimnacio;
  String cisterna;
  String almacenamientodeagua;
  String tratamientodeaguas;
  String otrascaracteristicas;

  Datosadicionalescasa({
    required this.panelessolares,
    required this.jardin,
    required this.alberca,
    required this.calefaccion,
    required this.aireacondicionado,
    required this.seguridad,
    required this.enfraccionamiento,
    required this.casasenelconjunto,
    required this.casaclub,
    required this.salondeeventos,
    required this.centrodenegocios,
    required this.gimnacio,
    required this.cisterna,
    required this.almacenamientodeagua,
    required this.tratamientodeaguas,
    required this.otrascaracteristicas,
  });

  factory Datosadicionalescasa.fromJson(Map<String, dynamic> json) =>
      Datosadicionalescasa(
        panelessolares: json["panelessolares"],
        jardin: json["jardin"],
        alberca: json["alberca"],
        calefaccion: json["calefaccion"],
        aireacondicionado: json["aireacondicionado"],
        seguridad: json["seguridad"],
        enfraccionamiento: json["enfraccionamiento"],
        casasenelconjunto: json["casasenelconjunto"],
        casaclub: json["casaclub"],
        salondeeventos: json["salondeeventos"],
        centrodenegocios: json["centrodenegocios"],
        gimnacio: json["gimnacio"],
        cisterna: json["cisterna"],
        almacenamientodeagua: json["almacenamientodeagua"],
        tratamientodeaguas: json["tratamientodeaguas"],
        otrascaracteristicas: json["otrascaracteristicas"],
      );

  Map<String, dynamic> toJson() => {
    "panelessolares": panelessolares,
    "jardin": jardin,
    "alberca": alberca,
    "calefaccion": calefaccion,
    "aireacondicionado": aireacondicionado,
    "seguridad": seguridad,
    "enfraccionamiento": enfraccionamiento,
    "casasenelconjunto": casasenelconjunto,
    "casaclub": casaclub,
    "salondeeventos": salondeeventos,
    "centrodenegocios": centrodenegocios,
    "gimnacio": gimnacio,
    "cisterna": cisterna,
    "almacenamientodeagua": almacenamientodeagua,
    "tratamientodeaguas": tratamientodeaguas,
    "otrascaracteristicas": otrascaracteristicas,
  };
}

class Datosdelcontactocasa {
  String nombre;
  String empresa;
  String imgendeempresa;
  String numerocelular;
  String numerootro;
  String numeroinmobiliaria;
  String correoelectronico;
  String idusuariocontacto;
  String nombreusuariocontacto;
  String imgendelcontacto;

  Datosdelcontactocasa({
    required this.nombre,
    required this.empresa,
    required this.imgendeempresa,
    required this.numerocelular,
    required this.numerootro,
    required this.numeroinmobiliaria,
    required this.correoelectronico,
    required this.idusuariocontacto,
    required this.nombreusuariocontacto,
    required this.imgendelcontacto,
  });

  factory Datosdelcontactocasa.fromJson(Map<String, dynamic> json) =>
      Datosdelcontactocasa(
        nombre: json["nombre"],
        empresa: json["empresa"],
        imgendeempresa: json["imgendeempresa"],
        numerocelular: json["numerocelular"],
        numerootro: json["numerootro"],
        numeroinmobiliaria: json["numeroinmobiliaria"],
        correoelectronico: json["correoelectronico"],
        idusuariocontacto: json["idusuariocontacto"],
        nombreusuariocontacto: json["nombreusuariocontacto"],
        imgendelcontacto: json["imgendelcontacto"],
      );

  Map<String, dynamic> toJson() => {
    "nombre": nombre,
    "empresa": empresa,
    "imgendeempresa": imgendeempresa,
    "numerocelular": numerocelular,
    "numerootro": numerootro,
    "numeroinmobiliaria": numeroinmobiliaria,
    "correoelectronico": correoelectronico,
    "idusuariocontacto": idusuariocontacto,
    "nombreusuariocontacto": nombreusuariocontacto,
    "imgendelcontacto": imgendelcontacto,
  };
}

class Fechadecasa {
  int dia;
  int mes;
  int anio;

  Fechadecasa({required this.dia, required this.mes, required this.anio});

  factory Fechadecasa.fromJson(Map<String, dynamic> json) =>
      Fechadecasa(dia: json["dia"], mes: json["mes"], anio: json["anio"]);

  Map<String, dynamic> toJson() => {"dia": dia, "mes": mes, "anio": anio};
}

class Ubicacioncasa {
  String pais;
  LocalidadCp localidadCp;
  String calle;
  String numeroexterior;
  String numerointerior;
  String entrecalle01;
  String entrecalle02;
  String latitud;
  String longitud;
  String latitudDecimal;
  String longitudDecimal;

  Ubicacioncasa({
    required this.pais,
    required this.localidadCp,
    required this.calle,
    required this.numeroexterior,
    required this.numerointerior,
    required this.entrecalle01,
    required this.entrecalle02,
    required this.latitud,
    required this.longitud,
    required this.latitudDecimal,
    required this.longitudDecimal,
  });

  factory Ubicacioncasa.fromJson(Map<String, dynamic> json) => Ubicacioncasa(
    pais: json["pais"],
    localidadCp: LocalidadCp.fromJson(json["localidadCp"]),
    calle: json["calle"],
    numeroexterior: json["numeroexterior"],
    numerointerior: json["numerointerior"],
    entrecalle01: json["entrecalle01"],
    entrecalle02: json["entrecalle02"],
    latitud: json["latitud"],
    longitud: json["longitud"],
    latitudDecimal: json["latitudDecimal"],
    longitudDecimal: json["longitudDecimal"],
  );

  Map<String, dynamic> toJson() => {
    "pais": pais,
    "localidadCp": localidadCp.toJson(),
    "calle": calle,
    "numeroexterior": numeroexterior,
    "numerointerior": numerointerior,
    "entrecalle01": entrecalle01,
    "entrecalle02": entrecalle02,
    "latitud": latitud,
    "longitud": longitud,
    "latitudDecimal": latitudDecimal,
    "longitudDecimal": longitudDecimal,
  };
}
