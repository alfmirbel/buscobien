// To parse this JSON data, do
//
//     final getUserData = getUserDataFromJson(jsonString);

import 'dart:convert';

import 'data_usuarios.dart';

GetUserData getUserDataFromJson(String str) =>
    GetUserData.fromJson(json.decode(str));

String getUserDataToJson(GetUserData data) => json.encode(data.toJson());

class GetUserData {
  int totalRows;
  int offset;
  List<RowGetUserData> rows;

  GetUserData({
    required this.totalRows,
    required this.offset,
    required this.rows,
  });

  factory GetUserData.fromJson(Map<String, dynamic> json) => GetUserData(
    totalRows: json["total_rows"],
    offset: json["offset"],
    rows: List<RowGetUserData>.from(
      json["rows"].map((x) => RowGetUserData.fromJson(x)),
    ),
  );

  Map<String, dynamic> toJson() => {
    "total_rows": totalRows,
    "offset": offset,
    "rows": List<dynamic>.from(rows.map((x) => x.toJson())),
  };
}

class RowGetUserData {
  String id;
  String key;
  ValueGetUserData value;

  RowGetUserData({required this.id, required this.key, required this.value});

  factory RowGetUserData.fromJson(Map<String, dynamic> json) => RowGetUserData(
    id: json["id"],
    key: json["key"],
    value: ValueGetUserData.fromJson(json["value"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "key": key,
    "value": value.toJson(),
  };
}

class ValueGetUserData {
  String id;
  String rev;
  Usuario usuario;

  ValueGetUserData({
    required this.id,
    required this.rev,
    required this.usuario,
  });

  factory ValueGetUserData.fromJson(Map<String, dynamic> json) =>
      ValueGetUserData(
        id: json["_id"],
        rev: json["_rev"],
        usuario: Usuario.fromJson(json["usuario"]),
      );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "_rev": rev,
    "usuario": usuario.toJson(),
  };
}
