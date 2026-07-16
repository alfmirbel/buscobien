// To parse this JSON data, do
//
//     final fotosCasaGet = fotosCasaGetFromJson(jsonString);

import 'dart:convert';

import 'data_fotos_casa.dart';

FotosCasaGet fotosCasaGetFromJson(String str) =>
    FotosCasaGet.fromJson(json.decode(str));

String fotosCasaGetToJson(FotosCasaGet data) => json.encode(data.toJson());

class FotosCasaGet {
  int totalRows;
  int offset;
  List<RowFotosCasaGet> rows;

  FotosCasaGet({
    required this.totalRows,
    required this.offset,
    required this.rows,
  });

  factory FotosCasaGet.fromJson(Map<String, dynamic> json) => FotosCasaGet(
        totalRows: json["total_rows"],
        offset: json["offset"],
        rows: List<RowFotosCasaGet>.from(
            json["rows"].map((x) => RowFotosCasaGet.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "total_rows": totalRows,
        "offset": offset,
        "rows": List<dynamic>.from(rows.map((x) => x.toJson())),
      };
}

class RowFotosCasaGet {
  String id;
  String key;
  ValueFotosCasaGet value;

  RowFotosCasaGet({
    required this.id,
    required this.key,
    required this.value,
  });

  factory RowFotosCasaGet.fromJson(Map<String, dynamic> json) =>
      RowFotosCasaGet(
        id: json["id"],
        key: json["key"],
        value: ValueFotosCasaGet.fromJson(json["value"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "key": key,
        "value": value.toJson(),
      };
}

class ValueFotosCasaGet {
  String id;
  String rev;
  FotosCasaClass fotosCasa;

  ValueFotosCasaGet({
    required this.id,
    required this.rev,
    required this.fotosCasa,
  });

  factory ValueFotosCasaGet.fromJson(Map<String, dynamic> json) =>
      ValueFotosCasaGet(
        id: json["_id"],
        rev: json["_rev"],
        fotosCasa: FotosCasaClass.fromJson(json["fotosCasa"]),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "_rev": rev,
        "fotosCasa": fotosCasa.toJson(),
      };
}
