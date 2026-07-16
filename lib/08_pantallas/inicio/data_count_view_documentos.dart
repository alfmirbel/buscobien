// To parse this JSON data, do
//
//     final countViewDoctos = countViewDoctosFromJson(jsonString);

import 'dart:convert';

CountViewDoctos countViewDoctosFromJson(String str) =>
    CountViewDoctos.fromJson(json.decode(str));

String countViewDoctosToJson(CountViewDoctos data) =>
    json.encode(data.toJson());

class CountViewDoctos {
  List<RowCountViewDoctos> rows;

  CountViewDoctos({
    required this.rows,
  });

  factory CountViewDoctos.fromJson(Map<String, dynamic> json) =>
      CountViewDoctos(
        rows: List<RowCountViewDoctos>.from(
            json["rows"].map((x) => RowCountViewDoctos.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "rows": List<dynamic>.from(rows.map((x) => x.toJson())),
      };
}

class RowCountViewDoctos {
  dynamic key;
  int value;

  RowCountViewDoctos({
    required this.key,
    required this.value,
  });

  factory RowCountViewDoctos.fromJson(Map<String, dynamic> json) =>
      RowCountViewDoctos(
        key: json["key"],
        value: json["value"],
      );

  Map<String, dynamic> toJson() => {
        "key": key,
        "value": value,
      };
}
