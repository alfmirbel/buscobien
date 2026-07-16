// To parse this JSON data, do
//
//     final espaciosCasaGet = espaciosCasaGetFromJson(jsonString);

import 'dart:convert';

import 'data_espacios_casas.dart';

EspaciosCasaGet espaciosCasaGetFromJson(String str) =>
    EspaciosCasaGet.fromJson(json.decode(str));

String espaciosCasaGetToJson(EspaciosCasaGet data) =>
    json.encode(data.toJson());

class EspaciosCasaGet {
  int totalRows;
  int offset;
  List<RowEspaciosCasaGet> rows;

  EspaciosCasaGet({
    required this.totalRows,
    required this.offset,
    required this.rows,
  });

  factory EspaciosCasaGet.fromJson(Map<String, dynamic> json) =>
      EspaciosCasaGet(
        totalRows: json["total_rows"],
        offset: json["offset"],
        rows: List<RowEspaciosCasaGet>.from(
          json["rows"].map((x) => RowEspaciosCasaGet.fromJson(x)),
        ),
      );

  Map<String, dynamic> toJson() => {
    "total_rows": totalRows,
    "offset": offset,
    "rows": List<dynamic>.from(rows.map((x) => x.toJson())),
  };
}

class RowEspaciosCasaGet {
  String id;
  String key;
  ValueEspaciosCasaGet value;

  RowEspaciosCasaGet({
    required this.id,
    required this.key,
    required this.value,
  });

  factory RowEspaciosCasaGet.fromJson(Map<String, dynamic> json) =>
      RowEspaciosCasaGet(
        id: json["id"],
        key: json["key"],
        value: ValueEspaciosCasaGet.fromJson(json["value"]),
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "key": key,
    "value": value.toJson(),
  };
}

class ValueEspaciosCasaGet {
  String id;
  String rev;
  EspaciosCasa espacioscasa;

  ValueEspaciosCasaGet({
    required this.id,
    required this.rev,
    required this.espacioscasa,
  });

  factory ValueEspaciosCasaGet.fromJson(Map<String, dynamic> json) =>
      ValueEspaciosCasaGet(
        id: json["_id"],
        rev: json["_rev"],
        espacioscasa: EspaciosCasa.fromJson(json["espacioscasa"]),
      );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "_rev": rev,
    "espacioscasa": espacioscasa.toJson(),
  };
}
