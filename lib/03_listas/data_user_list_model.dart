// To parse this JSON data, do
//
//     final userPropertyListModel = userPropertyListModelFromMap(jsonString);

import 'dart:convert';

UserPropertyListModel userPropertyListModelFromMap(String str) =>
    UserPropertyListModel.fromMap(json.decode(str));

String userPropertyListModelToMap(UserPropertyListModel data) =>
    json.encode(data.toMap());

class UserPropertyListModel {
  Lista value;

  UserPropertyListModel({required this.value});

  factory UserPropertyListModel.fromMap(Map<String, dynamic> json) =>
      UserPropertyListModel(value: Lista.fromMap(json["lista"]));

  Map<String, dynamic> toMap() => {"lista": value.toMap()};
}

class Lista {
  String listaId;
  String userId;
  String listName;
  String type;
  String timestamp;

  Lista({
    required this.listaId,
    required this.userId,
    required this.listName,
    required this.type,
    required this.timestamp,
  });

  factory Lista.fromMap(Map<String, dynamic> json) => Lista(
    listaId: json["listaId"],
    userId: json["userId"],
    listName: json["listName"],
    type: json["type"],
    timestamp: json["timestamp"],
  );

  Map<String, dynamic> toMap() => {
    "listaId": listaId,
    "userId": userId,
    "listName": listName,
    "type": type,
    "timestamp": timestamp,
  };
}
