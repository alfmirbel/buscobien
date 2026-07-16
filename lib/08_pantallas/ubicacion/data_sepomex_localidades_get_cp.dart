// To parse this JSON data, do
//
//     final localidadesGet = localidadesGetFromJson(jsonString);
//
// D:\buscobien\lib\00_data_model\data_sepomex_cp.json

import 'dart:convert';

import 'data_sepomex_localidades.dart';

LocalidadesGet localidadesGetFromJson(String str) =>
    LocalidadesGet.fromJson(json.decode(str));

String localidadesGetToJson(LocalidadesGet data) => json.encode(data.toJson());

class LocalidadesGet {
  int totalRows;
  int offset;
  List<RowLocalidadesGet> rows;

  LocalidadesGet({
    required this.totalRows,
    required this.offset,
    required this.rows,
  });

  factory LocalidadesGet.fromJson(Map<String, dynamic> json) => LocalidadesGet(
        totalRows: json["total_rows"],
        offset: json["offset"],
        rows: List<RowLocalidadesGet>.from(
            json["rows"].map((x) => RowLocalidadesGet.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "total_rows": totalRows,
        "offset": offset,
        "rows": List<dynamic>.from(rows.map((x) => x.toJson())),
      };
}

class RowLocalidadesGet {
  String id;
  int key;
  ValueLocalidadesGet value;

  RowLocalidadesGet({
    required this.id,
    required this.key,
    required this.value,
  });

  factory RowLocalidadesGet.fromJson(Map<String, dynamic> json) =>
      RowLocalidadesGet(
        id: json["id"],
        key: json["key"],
        value: ValueLocalidadesGet.fromJson(json["value"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "key": key,
        "value": value.toJson(),
      };
}

class ValueLocalidadesGet {
  String id;
  String rev;
  LocalidadCp localidadCp;

  ValueLocalidadesGet({
    required this.id,
    required this.rev,
    required this.localidadCp,
  });

  factory ValueLocalidadesGet.fromJson(Map<String, dynamic> json) =>
      ValueLocalidadesGet(
        id: json["_id"],
        rev: json["_rev"],
        localidadCp: LocalidadCp.fromJson(json["localidadCp"]),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "_rev": rev,
        "localidadCp": localidadCp.toJson(),
      };
}
