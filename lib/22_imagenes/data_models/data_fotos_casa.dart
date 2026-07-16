// To parse this JSON data, do
//     final fotosCasa = fotosCasaFromJson(jsonString);

import 'dart:convert';

FotosCasa fotosCasaFromJson(String str) => FotosCasa.fromJson(json.decode(str));

String fotosCasaToJson(FotosCasa data) => json.encode(data.toJson());

class FotosCasa {
  FotosCasaClass fotosCasa;

  FotosCasa({
    required this.fotosCasa,
  });

  factory FotosCasa.fromJson(Map<String, dynamic> json) => FotosCasa(
        fotosCasa: FotosCasaClass.fromJson(json["fotosCasa"]),
      );

  Map<String, dynamic> toJson() => {
        "fotosCasa": fotosCasa.toJson(),
      };
}

class FotosCasaClass {
  String idFoto;
  String idUsuario;
  String idPropiedad;
  String filaname;
  String path;
  int size;
  dynamic identifier;
  String foto;
  String contentType;
  String timestamp;

  FotosCasaClass({
    required this.idFoto,
    required this.idUsuario,
    required this.idPropiedad,
    required this.filaname,
    required this.path,
    required this.size,
    required this.identifier,
    required this.foto,
    required this.contentType,
    required this.timestamp,
  });

  factory FotosCasaClass.fromJson(Map<String, dynamic> json) => FotosCasaClass(
        idFoto: json["idFoto"],
        idUsuario: json["idUsuario"],
        idPropiedad: json["idPropiedad"],
        filaname: json["filaname"],
        path: json["path"],
        size: json["size"],
        identifier: json["identifier"],
        foto: json["foto"],
        contentType: json["content_type"],
        timestamp: json["timestamp"],
      );

  Map<String, dynamic> toJson() => {
        "idFoto": idFoto,
        "idUsuario": idUsuario,
        "idPropiedad": idPropiedad,
        "filaname": filaname,
        "path": path,
        "size": size,
        "identifier": identifier,
        "foto": foto,
        "content_type": contentType,
        "timestamp": timestamp,
      };
}
