// To parse this JSON data, do
//
//     final findLocalidadXcp = findLocalidadXcpFromJson(jsonString);

import 'dart:convert';

import 'data_sepomex_localidades.dart';

FindLocalidadXcp findLocalidadXcpFromJson(String str) =>
    FindLocalidadXcp.fromJson(json.decode(str));

String findLocalidadXcpToJson(FindLocalidadXcp data) =>
    json.encode(data.toJson());

class FindLocalidadXcp {
  List<Doc> docs;
  String bookmark;

  FindLocalidadXcp({required this.docs, required this.bookmark});

  factory FindLocalidadXcp.fromJson(Map<String, dynamic> json) =>
      FindLocalidadXcp(
        docs: List<Doc>.from(json["docs"].map((x) => Doc.fromJson(x))),
        bookmark: json["bookmark"],
      );

  Map<String, dynamic> toJson() => {
    "docs": List<dynamic>.from(docs.map((x) => x.toJson())),
    "bookmark": bookmark,
  };
}

class Doc {
  LocalidadCp localidadCp;

  Doc({required this.localidadCp});

  factory Doc.fromJson(Map<String, dynamic> json) =>
      Doc(localidadCp: LocalidadCp.fromJson(json["localidadCp"]));

  Map<String, dynamic> toJson() => {"localidadCp": localidadCp.toJson()};
}
