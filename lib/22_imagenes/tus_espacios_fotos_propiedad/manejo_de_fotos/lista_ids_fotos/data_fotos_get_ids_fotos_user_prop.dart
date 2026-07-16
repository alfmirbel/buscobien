// To parse this JSON data, do
//
//     final getIdsFotosUserProp = getIdsFotosUserPropFromJson(jsonString);

import 'dart:convert';

GetIdsFotosUserProp getIdsFotosUserPropFromJson(String str) =>
    GetIdsFotosUserProp.fromJson(json.decode(str));

String getIdsFotosUserPropToJson(GetIdsFotosUserProp data) =>
    json.encode(data.toJson());

class GetIdsFotosUserProp {
  int totalRows;
  int offset;
  List<RowIdsFotos> rows;

  GetIdsFotosUserProp({
    required this.totalRows,
    required this.offset,
    required this.rows,
  });

  factory GetIdsFotosUserProp.fromJson(Map<String, dynamic> json) =>
      GetIdsFotosUserProp(
        totalRows: json["total_rows"],
        offset: json["offset"],
        rows: List<RowIdsFotos>.from(
            json["rows"].map((x) => RowIdsFotos.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "total_rows": totalRows,
        "offset": offset,
        "rows": List<dynamic>.from(rows.map((x) => x.toJson())),
      };
}

class RowIdsFotos {
  String id;
  List<String> key;
  String value;

  RowIdsFotos({
    required this.id,
    required this.key,
    required this.value,
  });

  factory RowIdsFotos.fromJson(Map<String, dynamic> json) => RowIdsFotos(
        id: json["id"],
        key: List<String>.from(json["key"].map((x) => x)),
        value: json["value"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "key": List<dynamic>.from(key.map((x) => x)),
        "value": value,
      };
}
