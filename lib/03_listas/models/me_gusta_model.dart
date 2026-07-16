import 'dart:convert';

MeGustaModel meGustaModelFromJson(String str) =>
    MeGustaModel.fromJson(json.decode(str));
String meGustaModelToJson(MeGustaModel data) => json.encode(data.toJson());

// Documento en buscobien_megusta_propiedades.
// Registra que un usuario marcó una propiedad como "Me gusta".
class MeGustaModel {
  String id;
  String rev;
  String usuarioId;
  String propiedadId;
  String timestamp;

  MeGustaModel({
    this.id = '',
    this.rev = '',
    required this.usuarioId,
    required this.propiedadId,
    required this.timestamp,
  });

  factory MeGustaModel.fromJson(Map<String, dynamic> json) => MeGustaModel(
    id: json['_id'] as String? ?? '',
    rev: json['_rev'] as String? ?? '',
    usuarioId: json['usuarioId'] as String? ?? '',
    propiedadId: json['propiedadId'] as String? ?? '',
    timestamp: json['timestamp'] as String? ?? '',
  );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'usuarioId': usuarioId,
      'propiedadId': propiedadId,
      'timestamp': timestamp,
      'type': 'me_gusta',
    };
    if (id.isNotEmpty) map['_id'] = id;
    if (rev.isNotEmpty) map['_rev'] = rev;
    return map;
  }
}
