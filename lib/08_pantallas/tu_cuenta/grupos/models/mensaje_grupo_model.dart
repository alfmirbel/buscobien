import 'dart:convert';

MensajeGrupoModel mensajeGrupoModelFromJson(String str) =>
    MensajeGrupoModel.fromJson(json.decode(str));
String mensajeGrupoModelToJson(MensajeGrupoModel data) =>
    json.encode(data.toJson());

// Documento de mensaje del chat grupal en buscobien_grupos_mensajes.
// Espejo de mensaje_model.dart de conocidos, con grupoId en lugar de receiverId.
class MensajeGrupoModel {
  String id;
  String rev;
  String senderId;
  String senderName;
  String grupoId;
  String content;
  String timestamp;
  bool leido;
  String tipo;
  String propiedadId;
  String listaCompartidaId;

  MensajeGrupoModel({
    this.id = '',
    this.rev = '',
    required this.senderId,
    required this.senderName,
    required this.grupoId,
    required this.content,
    required this.timestamp,
    this.leido = false,
    this.tipo = 'texto',
    this.propiedadId = '',
    this.listaCompartidaId = '',
  });

  factory MensajeGrupoModel.fromJson(Map<String, dynamic> json) =>
      MensajeGrupoModel(
        id: json['_id'] as String? ?? '',
        rev: json['_rev'] as String? ?? '',
        senderId: json['senderId'] as String? ?? '',
        senderName: json['senderName'] as String? ?? '',
        grupoId: json['grupoId'] as String? ?? '',
        content: json['content'] as String? ?? '',
        timestamp: json['timestamp'] as String? ?? '',
        leido: json['leido'] as bool? ?? false,
        tipo: json['tipo'] as String? ?? 'texto',
        propiedadId: json['propiedadId'] as String? ?? '',
        listaCompartidaId: json['listaCompartidaId'] as String? ?? '',
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'senderId': senderId,
      'senderName': senderName,
      'grupoId': grupoId,
      'content': content,
      'timestamp': timestamp,
      'leido': leido,
      'tipo': tipo,
      'propiedadId': propiedadId,
      'listaCompartidaId': listaCompartidaId,
      'type': 'mensaje_grupo',
    };
    if (id.isNotEmpty) map['_id'] = id;
    if (rev.isNotEmpty) map['_rev'] = rev;
    return map;
  }
}
