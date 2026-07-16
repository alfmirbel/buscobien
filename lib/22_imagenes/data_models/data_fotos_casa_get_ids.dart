// To parse this JSON data, do
//
//     final fotosCasaGetIDs = fotosCasaGetIDsFromJson(jsonString);

import 'dart:convert';

import 'data_fotos_casa.dart';

FotosCasaGetIDs fotosCasaGetIDsFromJson(String str) =>
    FotosCasaGetIDs.fromJson(json.decode(str));

String fotosCasaGetIDsToJson(FotosCasaGetIDs data) =>
    json.encode(data.toJson());

class FotosCasaGetIDs {
  int totalRows;
  int offset;
  List<RowFotosCasaGetIDs> rows;

  FotosCasaGetIDs({
    required this.totalRows,
    required this.offset,
    required this.rows,
  });

  factory FotosCasaGetIDs.fromJson(Map<String, dynamic> json) =>
      FotosCasaGetIDs(
        totalRows: json["total_rows"],
        offset: json["offset"],
        rows: List<RowFotosCasaGetIDs>.from(
            json["rows"].map((x) => RowFotosCasaGetIDs.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "total_rows": totalRows,
        "offset": offset,
        "rows": List<dynamic>.from(rows.map((x) => x.toJson())),
      };
}

class RowFotosCasaGetIDs {
  String id;
  List<String> key;
  ValueFotosCasaGetIDs value;

  RowFotosCasaGetIDs({
    required this.id,
    required this.key,
    required this.value,
  });

  factory RowFotosCasaGetIDs.fromJson(Map<String, dynamic> json) =>
      RowFotosCasaGetIDs(
        id: json["id"],
        key: List<String>.from(json["key"].map((x) => x)),
        value: ValueFotosCasaGetIDs.fromJson(json["value"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "key": List<dynamic>.from(key.map((x) => x)),
        "value": value.toJson(),
      };
}

class ValueFotosCasaGetIDs {
  String id;
  String rev;
  FotosCasaClass fotosCasa;

  ValueFotosCasaGetIDs({
    required this.id,
    required this.rev,
    required this.fotosCasa,
  });

  factory ValueFotosCasaGetIDs.fromJson(Map<String, dynamic> json) =>
      ValueFotosCasaGetIDs(
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
