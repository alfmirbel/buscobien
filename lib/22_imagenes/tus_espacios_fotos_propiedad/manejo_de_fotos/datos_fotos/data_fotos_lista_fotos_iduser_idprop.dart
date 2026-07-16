// To parse this JSON data, do
//
//     final listaIdsUserPropertyFotoGet = listaIdsUserPropertyFotoGetFromJson(jsonString);

import 'dart:convert';

ListaFotosIdsPropiedadGet listaIdsUserPropertyFotoGetFromJson(String str) =>
    ListaFotosIdsPropiedadGet.fromJson(json.decode(str));

String listaIdsUserPropertyFotoGetToJson(ListaFotosIdsPropiedadGet data) =>
    json.encode(data.toJson());

class ListaFotosIdsPropiedadGet {
  int totalRows;
  int offset;
  List<RowListaFotosIds> rows;

  ListaFotosIdsPropiedadGet({
    required this.totalRows,
    required this.offset,
    required this.rows,
  });

  factory ListaFotosIdsPropiedadGet.fromJson(Map<String, dynamic> json) =>
      ListaFotosIdsPropiedadGet(
        totalRows: json["total_rows"],
        offset: json["offset"],
        rows: List<RowListaFotosIds>.from(
            json["rows"].map((x) => RowListaFotosIds.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "total_rows": totalRows,
        "offset": offset,
        "rows": List<dynamic>.from(rows.map((x) => x.toJson())),
      };
}

class RowListaFotosIds {
  String id;
  List<String> key;
  ValueListaFotosIds value;

  RowListaFotosIds({
    required this.id,
    required this.key,
    required this.value,
  });

  factory RowListaFotosIds.fromJson(Map<String, dynamic> json) =>
      RowListaFotosIds(
        id: json["id"],
        key: List<String>.from(json["key"].map((x) => x)),
        value: ValueListaFotosIds.fromJson(json["value"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "key": List<dynamic>.from(key.map((x) => x)),
        "value": value.toJson(),
      };
}

class ValueListaFotosIds {
  String idUsuario;
  String idPropiedad;
  String idFoto;

  ValueListaFotosIds({
    required this.idUsuario,
    required this.idPropiedad,
    required this.idFoto,
  });

  factory ValueListaFotosIds.fromJson(Map<String, dynamic> json) =>
      ValueListaFotosIds(
        idUsuario: json["idUsuario"],
        idPropiedad: json["idPropiedad"],
        idFoto: json["idFoto"],
      );

  Map<String, dynamic> toJson() => {
        "idUsuario": idUsuario,
        "idPropiedad": idPropiedad,
        "idFoto": idFoto,
      };
}
