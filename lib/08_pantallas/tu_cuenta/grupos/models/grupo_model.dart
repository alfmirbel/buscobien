import 'dart:convert';

GrupoModel grupoModelFromJson(String str) =>
    GrupoModel.fromJson(json.decode(str));
String grupoModelToJson(GrupoModel data) => json.encode(data.toJson());

// Modelo canónico del documento Grupo en CouchDB (buscobien_grupos).
// Unifica data_grupos.dart (legacy) y models/grupo.dart (Freezed UI).
class GrupoModel {
  String id; // _id en CouchDB
  String rev; // _rev en CouchDB
  String creadorId;
  String creadorNombre;
  String nombre;
  String descripcion;
  String objetivo;
  String privacidad; // "publica" | "privada"
  String visibilidad; // "todos" | "miembros"
  String participacion; // "abierta" | "invitacion"
  List<MiembroGrupoModel> miembros;
  String timestamp;

  GrupoModel({
    this.id = '',
    this.rev = '',
    required this.creadorId,
    required this.creadorNombre,
    required this.nombre,
    required this.descripcion,
    this.objetivo = '',
    this.privacidad = 'publica',
    this.visibilidad = 'todos',
    this.participacion = 'abierta',
    this.miembros = const [],
    required this.timestamp,
  });

  factory GrupoModel.fromJson(Map<String, dynamic> json) => GrupoModel(
    id: json['_id'] as String? ?? '',
    rev: json['_rev'] as String? ?? '',
    creadorId: json['creadorId'] as String? ?? '',
    creadorNombre: json['creadorNombre'] as String? ?? '',
    nombre: json['nombre'] as String? ?? '',
    descripcion: json['descripcion'] as String? ?? '',
    objetivo: json['objetivo'] as String? ?? '',
    privacidad: json['privacidad'] as String? ?? 'publica',
    visibilidad: json['visibilidad'] as String? ?? 'todos',
    participacion: json['participacion'] as String? ?? 'abierta',
    miembros:
        (json['miembros'] as List<dynamic>? ?? [])
            .map((e) => MiembroGrupoModel.fromJson(e as Map<String, dynamic>))
            .toList(),
    timestamp: json['timestamp'] as String? ?? '',
  );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'creadorId': creadorId,
      'creadorNombre': creadorNombre,
      'nombre': nombre,
      'descripcion': descripcion,
      'objetivo': objetivo,
      'privacidad': privacidad,
      'visibilidad': visibilidad,
      'participacion': participacion,
      'miembros': miembros.map((m) => m.toJson()).toList(),
      'timestamp': timestamp,
      'type': 'grupo',
    };
    if (id.isNotEmpty) map['_id'] = id;
    if (rev.isNotEmpty) map['_rev'] = rev;
    return map;
  }

  bool esMiembro(String userId) =>
      miembros.any((m) => m.usuarioId == userId);

  bool esAdmin(String userId) =>
      miembros.any((m) => m.usuarioId == userId && m.rol == 'admin');

  int get totalMiembros => miembros.length;
}

class MiembroGrupoModel {
  String usuarioId;
  String usuarioNombre;
  String rol; // "admin" | "miembro"
  String fechaIngreso;

  MiembroGrupoModel({
    required this.usuarioId,
    required this.usuarioNombre,
    this.rol = 'miembro',
    required this.fechaIngreso,
  });

  factory MiembroGrupoModel.fromJson(Map<String, dynamic> json) =>
      MiembroGrupoModel(
        usuarioId: json['usuarioId'] as String? ?? '',
        usuarioNombre: json['usuarioNombre'] as String? ?? '',
        rol: json['rol'] as String? ?? 'miembro',
        fechaIngreso: json['fechaIngreso'] as String? ?? '',
      );

  Map<String, dynamic> toJson() => {
    'usuarioId': usuarioId,
    'usuarioNombre': usuarioNombre,
    'rol': rol,
    'fechaIngreso': fechaIngreso,
  };
}
