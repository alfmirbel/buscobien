// To parse this JSON data, do
//
//     final getUserPropertyListModel = getUserPropertyListModelFromMap(jsonString);

import 'dart:convert';

import 'data_user_list_model.dart';

GetUserPropertyListModel getUserPropertyListModelFromMap(String str) =>
    GetUserPropertyListModel.fromMap(json.decode(str));

String getUserPropertyListModelToMap(GetUserPropertyListModel data) =>
    json.encode(data.toMap());

class GetUserPropertyListModel {
  int totalRows;
  int offset;
  List<RowGetUserPropertyList> rows;

  GetUserPropertyListModel({
    required this.totalRows,
    required this.offset,
    required this.rows,
  });

  factory GetUserPropertyListModel.fromMap(Map<String, dynamic> json) =>
      GetUserPropertyListModel(
        totalRows: json["total_rows"],
        offset: json["offset"],
        rows: List<RowGetUserPropertyList>.from(
          json["rows"].map((x) => RowGetUserPropertyList.fromMap(x)),
        ),
      );

  Map<String, dynamic> toMap() => {
    "total_rows": totalRows,
    "offset": offset,
    "rows": List<dynamic>.from(rows.map((x) => x.toMap())),
  };
}

class RowGetUserPropertyList {
  String id;
  String key;
  Lista value;

  RowGetUserPropertyList({
    required this.id,
    required this.key,
    required this.value,
  });

  factory RowGetUserPropertyList.fromMap(Map<String, dynamic> json) =>
      RowGetUserPropertyList(
        id: json["id"],
        key: json["key"],
        value: Lista.fromMap(json["value"]),
      );

  Map<String, dynamic> toMap() => {
    "id": id,
    "key": key,
    "lista": value.toMap(),
  };
}

