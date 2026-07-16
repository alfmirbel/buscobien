// To parse this JSON data, do
//
//     final couchDbReturnValue = couchDbReturnValueFromJson(jsonString);

import 'dart:convert';

CouchDbReturnValue couchDbReturnValueFromJson(String str) =>
    CouchDbReturnValue.fromJson(json.decode(str));

String couchDbReturnValueToJson(CouchDbReturnValue data) =>
    json.encode(data.toJson());

class CouchDbReturnValue {
  bool ok;
  String id;
  String rev;

  CouchDbReturnValue({
    required this.ok,
    required this.id,
    required this.rev,
  });

  factory CouchDbReturnValue.fromJson(Map<String, dynamic> json) =>
      CouchDbReturnValue(
        ok: json["ok"],
        id: json["id"],
        rev: json["rev"],
      );

  Map<String, dynamic> toJson() => {
        "ok": ok,
        "id": id,
        "rev": rev,
      };
}
