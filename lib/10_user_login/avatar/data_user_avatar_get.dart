// To parse this JSON data, do
//
//     final getUserAvatar = getUserAvatarFromJson(jsonString);

import 'dart:convert';

GetUserAvatar getUserAvatarFromJson(String str) =>
    GetUserAvatar.fromJson(json.decode(str));

String getUserAvatarToJson(GetUserAvatar data) => json.encode(data.toJson());

class GetUserAvatar {
  int totalRows;
  int offset;
  List<RowGetUserAvatar> rows;

  GetUserAvatar({
    required this.totalRows,
    required this.offset,
    required this.rows,
  });

  factory GetUserAvatar.fromJson(Map<String, dynamic> json) => GetUserAvatar(
        totalRows: json["total_rows"],
        offset: json["offset"],
        rows: List<RowGetUserAvatar>.from(
            json["rows"].map((x) => RowGetUserAvatar.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "total_rows": totalRows,
        "offset": offset,
        "rows": List<dynamic>.from(rows.map((x) => x.toJson())),
      };
}

class RowGetUserAvatar {
  String id;
  String key;
  ValueGetUserAvatar value;

  RowGetUserAvatar({
    required this.id,
    required this.key,
    required this.value,
  });

  factory RowGetUserAvatar.fromJson(Map<String, dynamic> json) =>
      RowGetUserAvatar(
        id: json["id"],
        key: json["key"],
        value: ValueGetUserAvatar.fromJson(json["value"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "key": key,
        "value": value.toJson(),
      };
}

class ValueGetUserAvatar {
  String id;
  String rev;
  String idFoto;
  String idUsuario;
  String filaname;
  String path;
  int size;
  dynamic identifier;
  String avatar;
  String contentType;
  String timestamp;

  ValueGetUserAvatar({
    required this.id,
    required this.rev,
    required this.idFoto,
    required this.idUsuario,
    required this.filaname,
    required this.path,
    required this.size,
    required this.identifier,
    required this.avatar,
    required this.contentType,
    required this.timestamp,
  });

  factory ValueGetUserAvatar.fromJson(Map<String, dynamic> json) =>
      ValueGetUserAvatar(
        id: json["_id"],
        rev: json["_rev"],
        idFoto: json["idFoto"],
        idUsuario: json["idUsuario"],
        filaname: json["filaname"],
        path: json["path"],
        size: json["size"],
        identifier: json["identifier"],
        avatar: json["avatar"],
        contentType: json["content_type"],
        timestamp: json["timestamp"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "_rev": rev,
        "idFoto": idFoto,
        "idUsuario": idUsuario,
        "filaname": filaname,
        "path": path,
        "size": size,
        "identifier": identifier,
        "avatar": avatar,
        "content_type": contentType,
        "timestamp": timestamp,
      };
}
