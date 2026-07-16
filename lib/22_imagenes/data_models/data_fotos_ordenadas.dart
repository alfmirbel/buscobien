// To parse this JSON data, do
//
//     final listaFotosOrdenadas = listaFotosOrdenadasFromJson(jsonString);

import 'dart:convert';

ListaFotosOrdenadas listaFotosOrdenadasFromJson(String str) =>
    ListaFotosOrdenadas.fromJson(json.decode(str));

String listaFotosOrdenadasToJson(ListaFotosOrdenadas data) =>
    json.encode(data.toJson());

class ListaFotosOrdenadas {
  String idListaFotos;
  String idUsuario;
  String idPropiedad;
  List<FotosOrden> fotosOrden;
  String timestamp;

  ListaFotosOrdenadas({
    required this.idListaFotos,
    required this.idUsuario,
    required this.idPropiedad,
    required this.fotosOrden,
    required this.timestamp,
  });

  factory ListaFotosOrdenadas.fromJson(Map<String, dynamic> json) =>
      ListaFotosOrdenadas(
        idListaFotos: json["idListaFotos"],
        idUsuario: json["idUsuario"],
        idPropiedad: json["idPropiedad"],
        fotosOrden: List<FotosOrden>.from(
            json["fotosOrden"].map((x) => FotosOrden.fromJson(x))),
        timestamp: json["timestamp"],
      );

  Map<String, dynamic> toJson() => {
        "idListaFotos": idListaFotos,
        "idUsuario": idUsuario,
        "idPropiedad": idPropiedad,
        "fotosOrden": List<dynamic>.from(fotosOrden.map((x) => x.toJson())),
        "timestamp": timestamp,
      };
}

class FotosOrden {
  int posicion;
  String idFoto;

  FotosOrden({
    required this.posicion,
    required this.idFoto,
  });

  factory FotosOrden.fromJson(Map<String, dynamic> json) => FotosOrden(
        posicion: json["posicion"],
        idFoto: json["idFoto"],
      );

  Map<String, dynamic> toJson() => {
        "posicion": posicion,
        "idFoto": idFoto,
      };
}
