// To parse this JSON data, do
//
//     final listaPropertyListModel = listaPropertyListModelFromMap(jsonString);

import 'dart:convert';

// OPTIMIZADO 25 02 11
// CAMBIOS DE FETCH Y DELETE

// -----------------------------------------------------------------------------
// MODELO: ListaPropertyListModel (Para Alta / Estructura Individual)
// -----------------------------------------------------------------------------

ListaPropertyListModel listaPropertyListModelFromMap(String str) =>
    ListaPropertyListModel.fromMap(json.decode(str));

String listaPropertyListModelToMap(ListaPropertyListModel data) =>
    json.encode(data.toMap());

class ListaPropertyListModel {
  Listapropiedad listapropiedad;

  ListaPropertyListModel({required this.listapropiedad});

  factory ListaPropertyListModel.fromMap(Map<String, dynamic> json) =>
      ListaPropertyListModel(
        listapropiedad: Listapropiedad.fromMap(json["listapropiedad"]),
      );

  Map<String, dynamic> toMap() => {"listapropiedad": listapropiedad.toMap()};
}

class Listapropiedad {
  String listapropiedadId; // ID del documento en CouchDB
  String userId;
  String listaId;
  String propertyId;
  String tipodeespacio;
  String type;
  String timestamp;

  Listapropiedad({
    required this.listapropiedadId,
    required this.userId,
    required this.listaId,
    required this.propertyId,
    required this.tipodeespacio,
    required this.type,
    required this.timestamp,
  });

  factory Listapropiedad.fromMap(Map<String, dynamic> json) => Listapropiedad(
    listapropiedadId: json["listapropiedadId"],
    userId: json["userId"],
    listaId: json["listaId"],
    propertyId: json["propertyId"],
    tipodeespacio: json["tipodeespacio"],
    type: json["type"],
    timestamp: json["timestamp"],
  );

  Map<String, dynamic> toMap() => {
    "listapropiedadId": listapropiedadId,
    "userId": userId,
    "listaId": listaId,
    "propertyId": propertyId,
    "tipodeespacio": tipodeespacio,
    "type": type,
    "timestamp": timestamp,
  };
}

/*
import 'dart:convert';

ListaPropertyListModel listaPropertyListModelFromMap(String str) =>
    ListaPropertyListModel.fromMap(json.decode(str));

String listaPropertyListModelToMap(ListaPropertyListModel data) =>
    json.encode(data.toMap());

class ListaPropertyListModel {
  Listapropiedad listapropiedad;

  ListaPropertyListModel({required this.listapropiedad});

  factory ListaPropertyListModel.fromMap(Map<String, dynamic> json) =>
      ListaPropertyListModel(
        listapropiedad: Listapropiedad.fromMap(json["listapropiedad"]),
      );

  Map<String, dynamic> toMap() => {"listapropiedad": listapropiedad.toMap()};
}

class Listapropiedad {
  String listapropiedadId;
  String userId;
  String listaId;
  String propertyId;
  String tipodeespacio;
  String type;
  String timestamp;

  Listapropiedad({
    required this.listapropiedadId,
    required this.userId,
    required this.listaId,
    required this.propertyId,
    required this.tipodeespacio,
    required this.type,
    required this.timestamp,
  });

  factory Listapropiedad.fromMap(Map<String, dynamic> json) => Listapropiedad(
    listapropiedadId: json["listapropiedadId"],
    userId: json["userId"],
    listaId: json["listaId"],
    propertyId: json["propertyId"],
    tipodeespacio: json["tipodeespacio"],
    type: json["type"],
    timestamp: json["timestamp"],
  );

  Map<String, dynamic> toMap() => {
    "listapropiedadId": listapropiedadId,
    "userId": userId,
    "listaId": listaId,
    "propertyId": propertyId,
    "tipodeespacio": tipodeespacio,
    "type": type,
    "timestamp": timestamp,
  };
}
*/
/*
// To parse this JSON data, do
//
//     final listaPropertyListModel = listaPropertyListModelFromMap(jsonString);

import 'dart:convert';

ListaPropertyListModel listaPropertyListModelFromMap(String str) =>
    ListaPropertyListModel.fromMap(json.decode(str));

String listaPropertyListModelToMap(ListaPropertyListModel data) =>
    json.encode(data.toMap());

class ListaPropertyListModel {
  Listapropiedad listapropiedad;

  ListaPropertyListModel({required this.listapropiedad});

  factory ListaPropertyListModel.fromMap(Map<String, dynamic> json) =>
      ListaPropertyListModel(
        listapropiedad: Listapropiedad.fromMap(json["listapropiedad"]),
      );

  Map<String, dynamic> toMap() => {"listapropiedad": listapropiedad.toMap()};
}

class Listapropiedad {
  String listapropiedadId;
  String userId;
  String listaId;
  String propertyId;
  String type;
  String timestamp;

  Listapropiedad({
    required this.listapropiedadId,
    required this.userId,
    required this.listaId,
    required this.propertyId,
    required this.type,
    required this.timestamp,
  });

  factory Listapropiedad.fromMap(Map<String, dynamic> json) => Listapropiedad(
    listapropiedadId: json["listapropiedadid"],
    userId: json["userId"],
    listaId: json["listaid"],
    propertyId: json["propertyId"],
    type: json["type"],
    timestamp: json["timestamp"],
  );

  Map<String, dynamic> toMap() => {
    "listapropiedadid": listapropiedadId,
    "userId": userId,
    "listaid": listaId,
    "propertyId": propertyId,
    "type": type,
    "timestamp": timestamp,
  };
}
*/
//-----------------------------------------------------------------------------
// OPTIMIZADO 25 02 09
/*
// To parse this JSON data, do
// final listaPropertyListModel = listaPropertyListModelFromMap(jsonString);

import 'dart:convert';

ListaPropertyListModel listaPropertyListModelFromMap(String str) =>
    ListaPropertyListModel.fromMap(json.decode(str));

String listaPropertyListModelToMap(ListaPropertyListModel data) =>
    json.encode(data.toMap());

class ListaPropertyListModel {
  Listapropiedad listapropiedad;

  ListaPropertyListModel({required this.listapropiedad});

  factory ListaPropertyListModel.fromMap(Map<String, dynamic> json) =>
      ListaPropertyListModel(
        listapropiedad: Listapropiedad.fromMap(json["listapropiedad"]),
      );

  Map<String, dynamic> toMap() => {"listapropiedad": listapropiedad.toMap()};
}

class Listapropiedad {
  String listapropiedadId; // IDENTIFICADOR DE LA DUPLA listaId- propertyId
  String userId; // IDENTIFICADOR DEL USUARIO
  String listaId; // IDENTIFICADOR DE LA LISTA
  String propertyId; // IDENTIFICADOR DE LA PROPIEDAD
  String type;
  String timestamp;

  Listapropiedad({
    required this.listapropiedadId,
    required this.userId,
    required this.listaId,
    required this.propertyId,
    required this.type,
    required this.timestamp,
  });

  factory Listapropiedad.fromMap(Map<String, dynamic> json) => Listapropiedad(
        listapropiedadId: json["listapropiedadid"],
        userId: json["userId"],
        listaId: json["listaid"],
        propertyId: json["propertyId"],
        type: json["type"],
        timestamp: json["timestamp"],
      );

  Map<String, dynamic> toMap() => {
        "listapropiedadid": listapropiedadId,
        "userId": userId,
        "listaid": listaId,
        "propertyId": propertyId,
        "type": type,
        "timestamp": timestamp,
      };
}
*/
