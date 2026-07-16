import 'dart:convert';

// =============================================================================
// 2. MODELOS DE MENSAJES
// =============================================================================

MensajeModel mensajeModelFromJson(String str) =>
    MensajeModel.fromJson(json.decode(str));
String mensajeModelToJson(MensajeModel data) => json.encode(data.toJson());

class MensajeModel {
  String id;
  String rev;
  String senderId;
  String receiverId;
  String content;
  String timestamp;
  String tipo;
  String propiedadId;
  String listaCompartidaId;

  MensajeModel({
    this.id = "",
    this.rev = "",
    required this.senderId,
    required this.receiverId,
    required this.content,
    required this.timestamp,
    this.tipo = "texto",
    this.propiedadId = "",
    this.listaCompartidaId = "",
  });

  factory MensajeModel.fromJson(Map<String, dynamic> json) => MensajeModel(
    id: json["_id"] ?? "",
    rev: json["_rev"] ?? "",
    senderId: json["senderId"] ?? "",
    receiverId: json["receiverId"] ?? "",
    content: json["content"] ?? "",
    timestamp: json["timestamp"] ?? "",
    tipo: json["tipo"] as String? ?? "texto",
    propiedadId: json["propiedadId"] as String? ?? "",
    listaCompartidaId: json["listaCompartidaId"] as String? ?? "",
  );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      "senderId": senderId,
      "receiverId": receiverId,
      "content": content,
      "timestamp": timestamp,
      "tipo": tipo,
      "propiedadId": propiedadId,
      "listaCompartidaId": listaCompartidaId,
      "type": "chat_mensaje",
    };
    if (id.isNotEmpty) map["_id"] = id;
    if (rev.isNotEmpty) map["_rev"] = rev;
    return map;
  }
}
