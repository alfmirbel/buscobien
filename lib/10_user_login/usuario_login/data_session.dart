// To parse this JSON data, do
//
//     final sessionData = sessionDataFromJson(jsonString);

import 'dart:convert';

SessionData sessionDataFromJson(String str) =>
    SessionData.fromJson(json.decode(str));

String sessionDataToJson(SessionData data) => json.encode(data.toJson());

class SessionData {
  // FASE 1 (26-05-18): Todos los campos son final para respetar la
  // inmutabilidad que exige Riverpod. Usa copyWith() para actualizar.
  final String key;
  final String varName;
  final String valueToSave;
  final String userId;
  final String userName;
  final String userPass;
  final String esUsuarioComprador;
  final String esUsuarioPromotor;
  final String esUsuarioEspecialista;
  final bool boolUsuarioComprador;
  final bool boolUsuarioPromotor;
  final bool boolUsuarioEspecialista;

  const SessionData({
    required this.key,
    required this.varName,
    required this.valueToSave,
    required this.userId,
    required this.userName,
    required this.userPass,
    required this.esUsuarioComprador,
    required this.esUsuarioPromotor,
    required this.esUsuarioEspecialista,
    required this.boolUsuarioComprador,
    required this.boolUsuarioPromotor,
    required this.boolUsuarioEspecialista,
  });

  /// Crea una nueva instancia modificando sólo los campos indicados.
  SessionData copyWith({
    String? key,
    String? varName,
    String? valueToSave,
    String? userId,
    String? userName,
    String? userPass,
    String? esUsuarioComprador,
    String? esUsuarioPromotor,
    String? esUsuarioEspecialista,
    bool? boolUsuarioComprador,
    bool? boolUsuarioPromotor,
    bool? boolUsuarioEspecialista,
  }) => SessionData(
    key: key ?? this.key,
    varName: varName ?? this.varName,
    valueToSave: valueToSave ?? this.valueToSave,
    userId: userId ?? this.userId,
    userName: userName ?? this.userName,
    userPass: userPass ?? this.userPass,
    esUsuarioComprador: esUsuarioComprador ?? this.esUsuarioComprador,
    esUsuarioPromotor: esUsuarioPromotor ?? this.esUsuarioPromotor,
    esUsuarioEspecialista: esUsuarioEspecialista ?? this.esUsuarioEspecialista,
    boolUsuarioComprador: boolUsuarioComprador ?? this.boolUsuarioComprador,
    boolUsuarioPromotor: boolUsuarioPromotor ?? this.boolUsuarioPromotor,
    boolUsuarioEspecialista:
        boolUsuarioEspecialista ?? this.boolUsuarioEspecialista,
  );

  factory SessionData.fromJson(Map<String, dynamic> json) => SessionData(
    key: json["key"],
    varName: json["varName"],
    valueToSave: json["valueToSave"],
    userId: json["userID"],
    userName: json["userName"],
    userPass: json["userPass"],
    esUsuarioComprador: json["esUsuarioComprador"],
    esUsuarioPromotor: json["esUsuarioPromotor"],
    esUsuarioEspecialista: json["esUsuarioEspecialista"],
    boolUsuarioComprador: json["boolUsuarioComprador"],
    boolUsuarioPromotor: json["boolUsuarioPromotor"],
    boolUsuarioEspecialista: json["boolUsuarioEspecialista"],
  );

  Map<String, dynamic> toJson() => {
    "key": key,
    "varName": varName,
    "valueToSave": valueToSave,
    "userID": userId,
    "userName": userName,
    "userPass": userPass,
    "esUsuarioComprador": esUsuarioComprador,
    "esUsuarioPromotor": esUsuarioPromotor,
    "esUsuarioEspecialista": esUsuarioEspecialista,
    "boolUsuarioComprador": boolUsuarioComprador,
    "boolUsuarioPromotor": boolUsuarioPromotor,
    "boolUsuarioEspecialista": boolUsuarioEspecialista,
  };
}
