// To parse this JSON data, do
//
//     final userData = userDataFromJson(jsonString);

import 'dart:convert';

import '../../08_pantallas/ubicacion/data_sepomex_localidades.dart';
import 'data_user_promotor.dart';

UserData userDataFromJson(String str) => UserData.fromJson(json.decode(str));

String userDataToJson(UserData data) => json.encode(data.toJson());

class UserData {
  Usuario usuario;

  UserData({required this.usuario});

  factory UserData.fromJson(Map<String, dynamic> json) =>
      UserData(usuario: Usuario.fromJson(json["usuario"]));

  Map<String, dynamic> toJson() => {"usuario": usuario.toJson()};
}

class Usuario {
  String idUsuario;
  String avatar;
  String nombres;
  String apellidopaterno;
  String apellidomaterno;
  String numerocelular;
  String correoelectronico;
  String nombreusuario;
  String claveacceso;
  UbicacionUserData ubicacionUserData;
  FechaDeNacimiento fechaDeNacimiento;
  String timestamp;
  UserDataPromotor datospromotor;

  Usuario({
    required this.idUsuario,
    required this.avatar,
    required this.nombres,
    required this.apellidopaterno,
    required this.apellidomaterno,
    required this.numerocelular,
    required this.correoelectronico,
    required this.nombreusuario,
    required this.claveacceso,
    required this.ubicacionUserData,
    required this.fechaDeNacimiento,
    required this.timestamp,
    required this.datospromotor,
  });

  factory Usuario.fromJson(Map<String, dynamic> json) => Usuario(
    idUsuario: json["id_usuario"],
    avatar: json["avatar"],
    nombres: json["nombres"],
    apellidopaterno: json["apellidopaterno"],
    apellidomaterno: json["apellidomaterno"],
    numerocelular: json["numerocelular"],
    correoelectronico: json["correoelectronico"],
    nombreusuario: json["nombreusuario"],
    claveacceso: json["claveacceso"],
    ubicacionUserData: UbicacionUserData.fromJson(json["ubicacionUserData"]),
    fechaDeNacimiento: FechaDeNacimiento.fromJson(json["fecha_de_nacimiento"]),
    timestamp: json["timestamp"],
    datospromotor: UserDataPromotor.fromJson(json["datospromotor"]),
  );

  Map<String, dynamic> toJson() => {
    "id_usuario": idUsuario,
    "avatar": avatar,
    "nombres": nombres,
    "apellidopaterno": apellidopaterno,
    "apellidomaterno": apellidomaterno,
    "numerocelular": numerocelular,
    "correoelectronico": correoelectronico,
    "nombreusuario": nombreusuario,
    "claveacceso": claveacceso,
    "ubicacionUserData": ubicacionUserData.toJson(),
    "fecha_de_nacimiento": fechaDeNacimiento.toJson(),
    "timestamp": timestamp,
    "datospromotor": datospromotor.toJson(),
  };
}

class FechaDeNacimiento {
  int dia;
  int mes;
  int anio;

  FechaDeNacimiento({required this.dia, required this.mes, required this.anio});

  factory FechaDeNacimiento.fromJson(Map<String, dynamic> json) =>
      FechaDeNacimiento(dia: json["dia"], mes: json["mes"], anio: json["anio"]);

  Map<String, dynamic> toJson() => {"dia": dia, "mes": mes, "anio": anio};
}

class UbicacionUserData {
  String pais;
  LocalidadCp localidadCp;
  String calle;
  String seccionine;
  String latitud;
  String longitud;
  String latDecimal;
  String lonDecimal;

  UbicacionUserData({
    required this.pais,
    required this.localidadCp,
    required this.calle,
    required this.seccionine,
    required this.latitud,
    required this.longitud,
    required this.latDecimal,
    required this.lonDecimal,
  });

  factory UbicacionUserData.fromJson(Map<String, dynamic> json) =>
      UbicacionUserData(
        pais: json["pais"],
        localidadCp: LocalidadCp.fromJson(json["localidadCp"]),
        calle: json["calle"],
        seccionine: json["seccionine"],
        latitud: json["latitud"],
        longitud: json["longitud"],
        latDecimal: json["latDecimal"],
        lonDecimal: json["lonDecimal"],
      );

  Map<String, dynamic> toJson() => {
    "pais": pais,
    "localidadCp": localidadCp.toJson(),
    "calle": calle,
    "seccionine": seccionine,
    "latitud": latitud,
    "longitud": longitud,
    "latDecimal": latDecimal,
    "lonDecimal": lonDecimal,
  };
}
