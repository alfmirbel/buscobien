import 'dart:convert';

AvisoGrupoModel avisoGrupoModelFromJson(String str) =>
    AvisoGrupoModel.fromJson(json.decode(str));
String avisoGrupoModelToJson(AvisoGrupoModel data) =>
    json.encode(data.toJson());

// Documento en buscobien_grupos_avisos.
class AvisoGrupoModel {
  String id;
  String rev;
  String grupoId;
  String autorId;
  String autorNombre;
  String contenido; // máximo 250 caracteres
  String timestamp;

  AvisoGrupoModel({
    this.id = '',
    this.rev = '',
    required this.grupoId,
    required this.autorId,
    required this.autorNombre,
    required this.contenido,
    required this.timestamp,
  });

  factory AvisoGrupoModel.fromJson(Map<String, dynamic> json) =>
      AvisoGrupoModel(
        id: json['_id'] as String? ?? '',
        rev: json['_rev'] as String? ?? '',
        grupoId: json['grupoId'] as String? ?? '',
        autorId: json['autorId'] as String? ?? '',
        autorNombre: json['autorNombre'] as String? ?? '',
        contenido: json['contenido'] as String? ?? '',
        timestamp: json['timestamp'] as String? ?? '',
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'grupoId': grupoId,
      'autorId': autorId,
      'autorNombre': autorNombre,
      'contenido': contenido,
      'timestamp': timestamp,
      'type': 'aviso_grupo',
    };
    if (id.isNotEmpty) map['_id'] = id;
    if (rev.isNotEmpty) map['_rev'] = rev;
    return map;
  }
}
