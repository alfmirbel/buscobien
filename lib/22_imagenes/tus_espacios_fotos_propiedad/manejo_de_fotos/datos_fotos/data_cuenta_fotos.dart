// To parse this JSON data, do
//
//     final cuentaFotos = cuentaFotosFromJson(jsonString);

import 'dart:convert';

CuentaFotos cuentaFotosFromJson(String str) =>
    CuentaFotos.fromJson(json.decode(str));

String cuentaFotosToJson(CuentaFotos data) => json.encode(data.toJson());

class CuentaFotos {
  List<RowCuentaFotos> rows;

  CuentaFotos({
    required this.rows,
  });

  factory CuentaFotos.fromJson(Map<String, dynamic> json) => CuentaFotos(
        rows: List<RowCuentaFotos>.from(
            json["rows"].map((x) => RowCuentaFotos.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "rows": List<dynamic>.from(rows.map((x) => x.toJson())),
      };
}

class RowCuentaFotos {
  dynamic key;
  int value;

  RowCuentaFotos({
    required this.key,
    required this.value,
  });

  factory RowCuentaFotos.fromJson(Map<String, dynamic> json) => RowCuentaFotos(
        key: json["key"],
        value: json["value"],
      );

  Map<String, dynamic> toJson() => {
        "key": key,
        "value": value,
      };
}
