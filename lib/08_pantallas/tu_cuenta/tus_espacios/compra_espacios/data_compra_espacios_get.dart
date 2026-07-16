// To parse this JSON data, do
//
//     final compraEspacioGet = compraEspacioGetFromJson(jsonString);

import 'dart:convert';

import 'data_compra_espacios.dart';

CompraEspacioGet compraEspacioGetFromJson(String str) =>
    CompraEspacioGet.fromJson(json.decode(str));

String compraEspacioGetToJson(CompraEspacioGet data) =>
    json.encode(data.toJson());

class CompraEspacioGet {
  int totalRows;
  int offset;
  List<RowCompraEspacio> rows;

  CompraEspacioGet({
    required this.totalRows,
    required this.offset,
    required this.rows,
  });

  factory CompraEspacioGet.fromJson(Map<String, dynamic> json) =>
      CompraEspacioGet(
        totalRows: json["total_rows"],
        offset: json["offset"],
        rows: List<RowCompraEspacio>.from(
            json["rows"].map((x) => RowCompraEspacio.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "total_rows": totalRows,
        "offset": offset,
        "rows": List<dynamic>.from(rows.map((x) => x.toJson())),
      };
}

class RowCompraEspacio {
  String id;
  String key;
  ValueCompraEspacio value;

  RowCompraEspacio({
    required this.id,
    required this.key,
    required this.value,
  });

  factory RowCompraEspacio.fromJson(Map<String, dynamic> json) =>
      RowCompraEspacio(
        id: json["id"],
        key: json["key"],
        value: ValueCompraEspacio.fromJson(json["value"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "key": key,
        "value": value.toJson(),
      };
}

class ValueCompraEspacio {
  String id;
  String rev;
  CompraEspacio espacio;

  ValueCompraEspacio({
    required this.id,
    required this.rev,
    required this.espacio,
  });

  factory ValueCompraEspacio.fromJson(Map<String, dynamic> json) =>
      ValueCompraEspacio(
        id: json["_id"],
        rev: json["_rev"],
        espacio: CompraEspacio.fromJson(json["espacio"]),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "_rev": rev,
        "espacio": espacio.toJson(),
      };
}
