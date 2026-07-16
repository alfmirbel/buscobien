import 'dart:convert';

ListaCompartidaModel listaCompartidaModelFromJson(String str) =>
    ListaCompartidaModel.fromJson(json.decode(str));
String listaCompartidaModelToJson(ListaCompartidaModel data) =>
    json.encode(data.toJson());

// Documento en buscobien_listas_compartidas_usuarios.
// Representa una lista compartida entre dos usuarios.
class ListaCompartidaModel {
  String id;
  String rev;
  String listaOrigenId;
  String listaNombre; // "Compartida por [nombre]"
  String usuarioOrigenId;
  String usuarioOrigenNombre;
  String usuarioDestinoId;
  String usuarioDestinoNombre;
  String timestamp;

  ListaCompartidaModel({
    this.id = '',
    this.rev = '',
    required this.listaOrigenId,
    required this.listaNombre,
    required this.usuarioOrigenId,
    required this.usuarioOrigenNombre,
    required this.usuarioDestinoId,
    required this.usuarioDestinoNombre,
    required this.timestamp,
  });

  factory ListaCompartidaModel.fromJson(Map<String, dynamic> json) =>
      ListaCompartidaModel(
        id: json['_id'] as String? ?? '',
        rev: json['_rev'] as String? ?? '',
        listaOrigenId: json['listaOrigenId'] as String? ?? '',
        listaNombre: json['listaNombre'] as String? ?? '',
        usuarioOrigenId: json['usuarioOrigenId'] as String? ?? '',
        usuarioOrigenNombre: json['usuarioOrigenNombre'] as String? ?? '',
        usuarioDestinoId: json['usuarioDestinoId'] as String? ?? '',
        usuarioDestinoNombre: json['usuarioDestinoNombre'] as String? ?? '',
        timestamp: json['timestamp'] as String? ?? '',
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'listaOrigenId': listaOrigenId,
      'listaNombre': listaNombre,
      'usuarioOrigenId': usuarioOrigenId,
      'usuarioOrigenNombre': usuarioOrigenNombre,
      'usuarioDestinoId': usuarioDestinoId,
      'usuarioDestinoNombre': usuarioDestinoNombre,
      'timestamp': timestamp,
      'type': 'lista_compartida',
    };
    if (id.isNotEmpty) map['_id'] = id;
    if (rev.isNotEmpty) map['_rev'] = rev;
    return map;
  }
}
