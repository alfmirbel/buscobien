// To parse this JSON data, do
//
//     final listaFotosOrdenadasGetIdPropiedad = listaFotosOrdenadasGetIdPropiedadFromJson(jsonString);

import 'dart:convert';

import '../../../data_models/data_fotos_ordenadas.dart';

ListaFotosOrdenadasGetIdPropiedad listaFotosOrdenadasGetIdPropiedadFromJson(
        String str) =>
    ListaFotosOrdenadasGetIdPropiedad.fromJson(json.decode(str));

String listaFotosOrdenadasGetIdPropiedadToJson(
        ListaFotosOrdenadasGetIdPropiedad data) =>
    json.encode(data.toJson());

class ListaFotosOrdenadasGetIdPropiedad {
  int totalRows;
  int offset;
  List<RowGetIdPropiedad> rows;

  ListaFotosOrdenadasGetIdPropiedad({
    required this.totalRows,
    required this.offset,
    required this.rows,
  });

  factory ListaFotosOrdenadasGetIdPropiedad.fromJson(
          Map<String, dynamic> json) =>
      ListaFotosOrdenadasGetIdPropiedad(
        totalRows: json["total_rows"],
        offset: json["offset"],
        rows: List<RowGetIdPropiedad>.from(
            json["rows"].map((x) => RowGetIdPropiedad.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "total_rows": totalRows,
        "offset": offset,
        "rows": List<dynamic>.from(rows.map((x) => x.toJson())),
      };
}

class RowGetIdPropiedad {
  String id;
  String key;
  ValueGetIdPropiedad value;

  RowGetIdPropiedad({
    required this.id,
    required this.key,
    required this.value,
  });

  factory RowGetIdPropiedad.fromJson(Map<String, dynamic> json) =>
      RowGetIdPropiedad(
        id: json["id"],
        key: json["key"],
        value: ValueGetIdPropiedad.fromJson(json["value"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "key": key,
        "value": value.toJson(),
      };
}

class ValueGetIdPropiedad {
  String id;
  String rev;
  ListaFotosOrdenadas listadefotos;

  ValueGetIdPropiedad({
    required this.id,
    required this.rev,
    required this.listadefotos,
  });

  factory ValueGetIdPropiedad.fromJson(Map<String, dynamic> json) =>
      ValueGetIdPropiedad(
        id: json["_id"],
        rev: json["_rev"],
        listadefotos: ListaFotosOrdenadas.fromJson(json["listadefotos"]),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "_rev": rev,
        "listadefotos": listadefotos.toJson(),
      };
}
