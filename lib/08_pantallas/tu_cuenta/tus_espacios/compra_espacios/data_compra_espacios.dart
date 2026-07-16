// To parse this JSON data, do
//
//     final compraEspacio = compraEspacioFromJson(jsonString);

import 'dart:convert';

CompraEspacio compraEspacioFromJson(String str) =>
    CompraEspacio.fromJson(json.decode(str));

String compraEspacioToJson(CompraEspacio data) => json.encode(data.toJson());

class CompraEspacio {
  String versiondelformato;
  String idUsuario;
  String idTransaccion;
  int noDeEspaciosNormales;
  int noDeEspaciosDestacados;
  int noDeEspaciosSuperdestacados;
  int noDeEspaciosOportunidades;
  int noDeEspaciosRemates;
  FechaDe fechaDeCompra;
  FechaDe fechaDePago;
  String medioDePago;
  String referenciaDePago;
  int mesesContratados;
  String vencimiento;
  int vigente;
  double totalEspacioNormal;
  double totalEspacioDestacado;
  double totalEspacioSuperdestacado;
  double totalEspaciosOportunidades;
  double totalEspaciosRemates;
  double impuestos;
  double granTotal;
  String timestamp;

  CompraEspacio({
    required this.versiondelformato,
    required this.idUsuario,
    required this.idTransaccion,
    required this.noDeEspaciosNormales,
    required this.noDeEspaciosDestacados,
    required this.noDeEspaciosSuperdestacados,
    required this.noDeEspaciosOportunidades,
    required this.noDeEspaciosRemates,
    required this.fechaDeCompra,
    required this.fechaDePago,
    required this.medioDePago,
    required this.referenciaDePago,
    required this.mesesContratados,
    required this.vencimiento,
    required this.vigente,
    required this.totalEspacioNormal,
    required this.totalEspacioDestacado,
    required this.totalEspacioSuperdestacado,
    required this.totalEspaciosOportunidades,
    required this.totalEspaciosRemates,
    required this.impuestos,
    required this.granTotal,
    required this.timestamp,
  });

  factory CompraEspacio.fromJson(Map<String, dynamic> json) => CompraEspacio(
        versiondelformato: json["versiondelformato"],
        idUsuario: json["idUsuario"],
        idTransaccion: json["idTransaccion"],
        noDeEspaciosNormales: json["noDeEspaciosNormales"],
        noDeEspaciosDestacados: json["noDeEspaciosDestacados"],
        noDeEspaciosSuperdestacados: json["noDeEspaciosSuperdestacados"],
        noDeEspaciosOportunidades: json["noDeEspaciosOportunidades"],
        noDeEspaciosRemates: json["noDeEspaciosRemates"],
        fechaDeCompra: FechaDe.fromJson(json["fechaDeCompra"]),
        fechaDePago: FechaDe.fromJson(json["fechaDePago"]),
        medioDePago: json["medioDePago"],
        referenciaDePago: json["referenciaDePago"],
        mesesContratados: json["mesesContratados"],
        vencimiento: json["vencimiento"],
        vigente: json["vigente"],
        totalEspacioNormal: json["totalEspacioNormal"],
        totalEspacioDestacado: json["totalEspacioDestacado"],
        totalEspacioSuperdestacado: json["totalEspacioSuperdestacado"],
        totalEspaciosOportunidades: json["totalEspaciosOportunidades"],
        totalEspaciosRemates: json["totalEspaciosRemates"],
        impuestos: json["impuestos"],
        granTotal: json["granTotal"],
        timestamp: json["timestamp"],
      );

  Map<String, dynamic> toJson() => {
        "versiondelformato": versiondelformato,
        "idUsuario": idUsuario,
        "idTransaccion": idTransaccion,
        "noDeEspaciosNormales": noDeEspaciosNormales,
        "noDeEspaciosDestacados": noDeEspaciosDestacados,
        "noDeEspaciosSuperdestacados": noDeEspaciosSuperdestacados,
        "noDeEspaciosOportunidades": noDeEspaciosOportunidades,
        "noDeEspaciosRemates": noDeEspaciosRemates,
        "fechaDeCompra": fechaDeCompra.toJson(),
        "fechaDePago": fechaDePago.toJson(),
        "medioDePago": medioDePago,
        "referenciaDePago": referenciaDePago,
        "mesesContratados": mesesContratados,
        "vencimiento": vencimiento,
        "vigente": vigente,
        "totalEspacioNormal": totalEspacioNormal,
        "totalEspacioDestacado": totalEspacioDestacado,
        "totalEspacioSuperdestacado": totalEspacioSuperdestacado,
        "totalEspaciosOportunidades": totalEspaciosOportunidades,
        "totalEspaciosRemates": totalEspaciosRemates,
        "impuestos": impuestos,
        "granTotal": granTotal,
        "timestamp": timestamp,
      };
}

class FechaDe {
  int dia;
  int mes;
  int anio;

  FechaDe({
    required this.dia,
    required this.mes,
    required this.anio,
  });

  factory FechaDe.fromJson(Map<String, dynamic> json) => FechaDe(
        dia: json["dia"],
        mes: json["mes"],
        anio: json["anio"],
      );

  Map<String, dynamic> toJson() => {
        "dia": dia,
        "mes": mes,
        "anio": anio,
      };
}
