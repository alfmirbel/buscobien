import 'dart:convert';

// =============================================================================
// 1. MODELOS DE INVITACIONES
// =============================================================================

InvitacionModel invitacionModelFromJson(String str) =>
    InvitacionModel.fromJson(json.decode(str));
String invitacionModelToJson(InvitacionModel data) =>
    json.encode(data.toJson());

class InvitacionModel {
  String id;
  String rev;
  String senderId;
  String senderName;
  String receiverId;
  String receiverName;
  String status; // "pending", "accepted", "rejected"
  String timestamp;

  InvitacionModel({
    this.id = "",
    this.rev = "",
    required this.senderId,
    required this.senderName,
    required this.receiverId,
    required this.receiverName,
    this.status = "pending",
    required this.timestamp,
  });

  factory InvitacionModel.fromJson(Map<String, dynamic> json) =>
      InvitacionModel(
        id: json["_id"] ?? "",
        rev: json["_rev"] ?? "",
        senderId: json["senderId"] ?? "",
        senderName: json["senderName"] ?? "Usuario",
        receiverId: json["receiverId"] ?? "",
        receiverName: json["receiverName"] ?? "Usuario",
        status: json["status"] ?? "pending",
        timestamp: json["timestamp"] ?? "",
      );

  Map<String, dynamic> toJson() {
    final map = {
      "senderId": senderId,
      "senderName": senderName,
      "receiverId": receiverId,
      "receiverName": receiverName,
      "status": status,
      "timestamp": timestamp,
      "type": "invitacion_social", // Para identificar el doc en DB
    };
    if (id.isNotEmpty) map["_id"] = id;
    if (rev.isNotEmpty) map["_rev"] = rev;
    return map;
  }
}
