import 'dart:convert';

PublicacionGrupoModel publicacionGrupoModelFromJson(String str) =>
    PublicacionGrupoModel.fromJson(json.decode(str));
String publicacionGrupoModelToJson(PublicacionGrupoModel data) =>
    json.encode(data.toJson());

// Documento en buscobien_grupos_publicaciones.
// Referencia a una propiedad que un miembro decidió compartir con el grupo.
class PublicacionGrupoModel {
  String id;
  String rev;
  String grupoId;
  String propiedadId;
  String propiedadNombre;
  String tipodeespacio;
  String autorId;
  String autorNombre;
  String timestamp;

  PublicacionGrupoModel({
    this.id = '',
    this.rev = '',
    required this.grupoId,
    required this.propiedadId,
    required this.propiedadNombre,
    required this.tipodeespacio,
    required this.autorId,
    required this.autorNombre,
    required this.timestamp,
  });

  factory PublicacionGrupoModel.fromJson(Map<String, dynamic> json) =>
      PublicacionGrupoModel(
        id: json['_id'] as String? ?? '',
        rev: json['_rev'] as String? ?? '',
        grupoId: json['grupoId'] as String? ?? '',
        propiedadId: json['propiedadId'] as String? ?? '',
        propiedadNombre: json['propiedadNombre'] as String? ?? '',
        tipodeespacio: json['tipodeespacio'] as String? ?? '',
        autorId: json['autorId'] as String? ?? '',
        autorNombre: json['autorNombre'] as String? ?? '',
        timestamp: json['timestamp'] as String? ?? '',
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'grupoId': grupoId,
      'propiedadId': propiedadId,
      'propiedadNombre': propiedadNombre,
      'tipodeespacio': tipodeespacio,
      'autorId': autorId,
      'autorNombre': autorNombre,
      'timestamp': timestamp,
      'type': 'publicacion_grupo',
    };
    if (id.isNotEmpty) map['_id'] = id;
    if (rev.isNotEmpty) map['_rev'] = rev;
    return map;
  }
}
