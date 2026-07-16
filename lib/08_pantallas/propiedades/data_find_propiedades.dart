// To parse this JSON data, do
//
//     final findPropiedades = findPropiedadesFromJson(jsonString);

import 'dart:convert';

import '../inicio/data_espacios_casas.dart';

FindPropiedades findPropiedadesFromJson(String str) =>
    FindPropiedades.fromJson(json.decode(str));

String findPropiedadesToJson(FindPropiedades data) =>
    json.encode(data.toJson());

class FindPropiedades {
  List<Doc> docs;
  String bookmark;

  FindPropiedades({
    required this.docs,
    required this.bookmark,
  });

  factory FindPropiedades.fromJson(Map<String, dynamic> json) =>
      FindPropiedades(
        docs: List<Doc>.from(json["docs"].map((x) => Doc.fromJson(x))),
        bookmark: json["bookmark"],
      );

  Map<String, dynamic> toJson() => {
        "docs": List<dynamic>.from(docs.map((x) => x.toJson())),
        "bookmark": bookmark,
      };
}

class Doc {
  String id;
  String rev;
  EspaciosCasa espacioscasa;

  Doc({
    required this.id,
    required this.rev,
    required this.espacioscasa,
  });

  factory Doc.fromJson(Map<String, dynamic> json) => Doc(
        id: json["_id"],
        rev: json["_rev"],
        espacioscasa: EspaciosCasa.fromJson(json["espacioscasa"]),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "_rev": rev,
        "espacioscasa": espacioscasa.toJson(),
      };
}
