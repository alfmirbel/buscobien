import 'dart:convert';

InvitacionGrupoModel invitacionGrupoModelFromJson(String str) =>
    InvitacionGrupoModel.fromJson(json.decode(str));
String invitacionGrupoModelToJson(InvitacionGrupoModel data) =>
    json.encode(data.toJson());

// Documento de invitación a un grupo en buscobien_grupos_invitaciones.
// Espejo de invitacion_model.dart de conocidos, extendido con grupoId/grupoNombre.
class InvitacionGrupoModel {
  String id;
  String rev;
  String senderId;
  String senderName;
  String receiverId;
  String receiverName;
  String grupoId;
  String grupoNombre;
  String status; // "pending" | "accepted" | "rejected"
  String timestamp;
  String timestampRespuesta;

  InvitacionGrupoModel({
    this.id = '',
    this.rev = '',
    required this.senderId,
    required this.senderName,
    required this.receiverId,
    required this.receiverName,
    required this.grupoId,
    required this.grupoNombre,
    this.status = 'pending',
    required this.timestamp,
    this.timestampRespuesta = '',
  });

  factory InvitacionGrupoModel.fromJson(Map<String, dynamic> json) =>
      InvitacionGrupoModel(
        id: json['_id'] as String? ?? '',
        rev: json['_rev'] as String? ?? '',
        senderId: json['senderId'] as String? ?? '',
        senderName: json['senderName'] as String? ?? '',
        receiverId: json['receiverId'] as String? ?? '',
        receiverName: json['receiverName'] as String? ?? '',
        grupoId: json['grupoId'] as String? ?? '',
        grupoNombre: json['grupoNombre'] as String? ?? '',
        status: json['status'] as String? ?? 'pending',
        timestamp: json['timestamp'] as String? ?? '',
        timestampRespuesta: json['timestampRespuesta'] as String? ?? '',
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'senderId': senderId,
      'senderName': senderName,
      'receiverId': receiverId,
      'receiverName': receiverName,
      'grupoId': grupoId,
      'grupoNombre': grupoNombre,
      'status': status,
      'timestamp': timestamp,
      'timestampRespuesta': timestampRespuesta,
      'type': 'invitacion_grupo',
    };
    if (id.isNotEmpty) map['_id'] = id;
    if (rev.isNotEmpty) map['_rev'] = rev;
    return map;
  }
}
