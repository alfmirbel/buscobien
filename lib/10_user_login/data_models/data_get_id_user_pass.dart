// To parse this JSON data, do
//
//     final getIdUserPass = getIdUserPassFromJson(jsonString);

import 'dart:convert';

GetIdUserPass getIdUserPassFromJson(String str) =>
    GetIdUserPass.fromJson(json.decode(str));

String getIdUserPassToJson(GetIdUserPass data) => json.encode(data.toJson());

class GetIdUserPass {
  int totalRows;
  int offset;
  List<RowIdUserPass> rows;

  GetIdUserPass({
    required this.totalRows,
    required this.offset,
    required this.rows,
  });

  factory GetIdUserPass.fromJson(Map<String, dynamic> json) => GetIdUserPass(
    totalRows: json["total_rows"],
    offset: json["offset"],
    rows: List<RowIdUserPass>.from(
      json["rows"].map((x) => RowIdUserPass.fromJson(x)),
    ),
  );

  Map<String, dynamic> toJson() => {
    "total_rows": totalRows,
    "offset": offset,
    "rows": List<dynamic>.from(rows.map((x) => x.toJson())),
  };
}

class RowIdUserPass {
  String id;
  String key;
  ValueIdUserPass value;

  RowIdUserPass({required this.id, required this.key, required this.value});

  factory RowIdUserPass.fromJson(Map<String, dynamic> json) => RowIdUserPass(
    id: json["id"],
    key: json["key"],
    value: ValueIdUserPass.fromJson(json["value"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "key": key,
    "value": value.toJson(),
  };
}

class ValueIdUserPass {
  String userId;
  String userName;
  String userPass;
  String idFoto;

  ValueIdUserPass({
    required this.userId,
    required this.userName,
    required this.userPass,
    required this.idFoto,
  });

  factory ValueIdUserPass.fromJson(Map<String, dynamic> json) =>
      ValueIdUserPass(
        userId: json["userID"],
        userName: json["userName"],
        userPass: json["userPass"],
        idFoto: json["idFoto"],
      );

  Map<String, dynamic> toJson() => {
    "userID": userId,
    "userName": userName,
    "userPass": userPass,
    "idFoto": idFoto,
  };
}
