// To parse this JSON data, do
//
//     final gcdUserPromotorData = gcdUserPromotorDataFromJson(jsonString);

import 'dart:convert';

UserDataPromotor gcdUserPromotorDataFromJson(String str) =>
    UserDataPromotor.fromJson(json.decode(str));

String gcdUserPromotorDataToJson(UserDataPromotor data) =>
    json.encode(data.toJson());

class UserDataPromotor {
  String tipodeusuario;
  String rfc;
  String numerodecliente;
  String inmobiliaria;
  int espacionormal;
  int espaciodestacados;
  int espaciosuperdestacados;
  int espaciosoportunidad;
  int espaciosremate;

  UserDataPromotor({
    required this.tipodeusuario,
    required this.rfc,
    required this.numerodecliente,
    required this.inmobiliaria,
    required this.espacionormal,
    required this.espaciodestacados,
    required this.espaciosuperdestacados,
    required this.espaciosoportunidad,
    required this.espaciosremate,
  });

  factory UserDataPromotor.fromJson(Map<String, dynamic> json) =>
      UserDataPromotor(
        tipodeusuario: json["rfc"],
        rfc: json["rfc"],
        numerodecliente: json["numerodecliente"],
        inmobiliaria: json["inmobiliaria"],
        espacionormal: json["espacionormal"],
        espaciodestacados: json["espaciodestacados"],
        espaciosuperdestacados: json["espaciosuperdestacados"],
        espaciosoportunidad: json["espaciosoportunidad"],
        espaciosremate: json["espaciosremate"],
      );

  Map<String, dynamic> toJson() => {
        "tipodeusuario": tipodeusuario,
        "rfc": rfc,
        "numerodecliente": numerodecliente,
        "inmobiliaria": inmobiliaria,
        "espacionormal": espacionormal,
        "espaciodestacados": espaciodestacados,
        "espaciosuperdestacados": espaciosuperdestacados,
        "espaciosoportunidad": espaciosoportunidad,
        "espaciosremate": espaciosremate,
      };
}
