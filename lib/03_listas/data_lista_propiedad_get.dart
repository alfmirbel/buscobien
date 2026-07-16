// To parse this JSON data, do
//
//     final getListaPropertyListModel = getListaPropertyListModelFromMap(jsonString);
import 'dart:convert';

import 'data_lista_propiedad.dart';
// OPTIMIZADO 25 02 11
// CAMBIOS DE FETCH Y DELETE

// -----------------------------------------------------------------------------
// MODELO: GetListaPropertyListModel (Para Respuesta de Vistas/Consultas)
// -----------------------------------------------------------------------------

GetListaPropertyListModel getListaPropertyListModelFromMap(String str) =>
    GetListaPropertyListModel.fromMap(json.decode(str));

String getListaPropertyListModelToMap(GetListaPropertyListModel data) =>
    json.encode(data.toMap());

class GetListaPropertyListModel {
  int totalRows;
  int offset;
  List<RowListaProperty> rows;

  GetListaPropertyListModel({
    required this.totalRows,
    required this.offset,
    required this.rows,
  });

  factory GetListaPropertyListModel.fromMap(
    Map<String, dynamic> json,
  ) => GetListaPropertyListModel(
    // Ajuste: CouchDB a veces regresa 'total_rows' fuera, pero en _find o vistas custom
    // podría variar. Se asume estructura estándar de vista.
    totalRows: json["total_rows"] ?? 0,
    offset: json["offset"] ?? 0,
    rows: List<RowListaProperty>.from(
      (json["rows"] ?? []).map((x) => RowListaProperty.fromMap(x)),
    ),
  );

  Map<String, dynamic> toMap() => {
    "total_rows": totalRows,
    "offset": offset,
    "rows": List<dynamic>.from(rows.map((x) => x.toMap())),
  };
}

class RowListaProperty {
  String id;
  String key;
  Listapropiedad listapropiedad;

  RowListaProperty({
    required this.id,
    required this.key,
    required this.listapropiedad,
  });

  factory RowListaProperty.fromMap(
    Map<String, dynamic> json,
  ) => RowListaProperty(
    id: json["id"] ?? "",
    key: json["key"] ?? "",
    // Ajuste: A veces la vista devuelve el objeto en "value", a veces en la raiz
    // dependiendo de la definición de la vista en CouchDB.
    // Asumimos que viene directo o dentro de "value".
    listapropiedad: Listapropiedad.fromMap(
      json["listapropiedad"] ?? json["value"]?["listapropiedad"] ?? {},
    ),
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "key": key,
    "listapropiedad": listapropiedad.toMap(),
  };
}

/*
import 'dart:convert';

import 'data_lista_propiedad.dart';

GetListaPropertyListModel getListaPropertyListModelFromMap(String str) =>
    GetListaPropertyListModel.fromMap(json.decode(str));

String getListaPropertyListModelToMap(GetListaPropertyListModel data) =>
    json.encode(data.toMap());

class GetListaPropertyListModel {
  int totalRows;
  int offset;
  List<RowListaProperty> rows;

  GetListaPropertyListModel({
    required this.totalRows,
    required this.offset,
    required this.rows,
  });

  factory GetListaPropertyListModel.fromMap(Map<String, dynamic> json) =>
      GetListaPropertyListModel(
        totalRows: json["total_rows"],
        offset: json["offset"],
        rows: List<RowListaProperty>.from(
          json["rows"].map((x) => RowListaProperty.fromMap(x)),
        ),
      );

  Map<String, dynamic> toMap() => {
    "total_rows": totalRows,
    "offset": offset,
    "rows": List<dynamic>.from(rows.map((x) => x.toMap())),
  };
}

class RowListaProperty {
  String id;
  String key;
  Listapropiedad listapropiedad;

  RowListaProperty({
    required this.id,
    required this.key,
    required this.listapropiedad,
  });

  factory RowListaProperty.fromMap(Map<String, dynamic> json) =>
      RowListaProperty(
        id: json["id"],
        key: json["key"],
        listapropiedad: Listapropiedad.fromMap(json["listapropiedad"]),
      );

  Map<String, dynamic> toMap() => {
    "id": id,
    "key": key,
    "listapropiedad": listapropiedad.toMap(),
  };
}
*/
//-----------------------------------------------------------------------------
// OPTIMIZADO 25 02 09
/*
// To parse this JSON data, do
// final getListaPropertyListModel = getListaPropertyListModelFromMap(jsonString);

import 'dart:convert';
import 'data_lista_propiedad.dart';

GetListaPropertyListModel getListaPropertyListModelFromMap(String str) =>
    GetListaPropertyListModel.fromMap(json.decode(str));

String getListaPropertyListModelToMap(GetListaPropertyListModel data) =>
    json.encode(data.toMap());

class GetListaPropertyListModel {
  int totalRows;
  int offset;
  List<RowListaProperty> rows;

  GetListaPropertyListModel({
    required this.totalRows,
    required this.offset,
    required this.rows,
  });

  factory GetListaPropertyListModel.fromMap(Map<String, dynamic> json) =>
      GetListaPropertyListModel(
        totalRows: json["total_rows"] ?? 0, // Protección nulos
        offset: json["offset"] ?? 0,
        rows: json["rows"] == null
            ? []
            : List<RowListaProperty>.from(
                json["rows"].map((x) => RowListaProperty.fromMap(x)),
              ),
      );

  Map<String, dynamic> toMap() => {
        "total_rows": totalRows,
        "offset": offset,
        "rows": List<dynamic>.from(rows.map((x) => x.toMap())),
      };
}

class RowListaProperty {
  String id;
  String key;
  Listapropiedad listapropiedad;

  RowListaProperty({
    required this.id,
    required this.key,
    required this.listapropiedad,
  });

  factory RowListaProperty.fromMap(Map<String, dynamic> json) {
    // Nota: Dependiendo de tu Vista en CouchDB, los datos pueden venir en "value"
    // o directamente mapeados. Asumimos que tu vista retorna el objeto dentro de "listapropiedad"
    // o que el "value" de la vista tiene esa estructura.
    
    // Si tu vista retorna { "listapropiedad": {...} } dentro del 'value', ajusta aquí:
    var data = json["value"] != null && json["value"]["listapropiedad"] != null 
        ? json["value"]["listapropiedad"] 
        : (json["listapropiedad"] ?? json["value"]);

    return RowListaProperty(
      id: json["id"] ?? "",
      key: json["key"] ?? "",
      listapropiedad: Listapropiedad.fromMap(data ?? {}),
    );
  }

  Map<String, dynamic> toMap() => {
        "id": id,
        "key": key,
        "listapropiedad": listapropiedad.toMap(),
      };
}

*/
