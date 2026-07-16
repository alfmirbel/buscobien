// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'grupo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MiembroGrupo _$MiembroGrupoFromJson(Map<String, dynamic> json) =>
    _MiembroGrupo(
      usuarioId: json['usuarioId'] as String,
      rol: $enumDecodeNullable(_$RolGrupoEnumMap, json['rol']) ??
          RolGrupo.miembro,
      fechaIngreso: DateTime.parse(json['fechaIngreso'] as String),
    );

Map<String, dynamic> _$MiembroGrupoToJson(_MiembroGrupo instance) =>
    <String, dynamic>{
      'usuarioId': instance.usuarioId,
      'rol': _$RolGrupoEnumMap[instance.rol]!,
      'fechaIngreso': instance.fechaIngreso.toIso8601String(),
    };

const _$RolGrupoEnumMap = {
  RolGrupo.admin: 'admin',
  RolGrupo.miembro: 'miembro',
};

_Grupo _$GrupoFromJson(Map<String, dynamic> json) => _Grupo(
      id: json['id'] as String,
      nombre: json['nombre'] as String,
      descripcion: json['descripcion'] as String,
      creadorId: json['creadorId'] as String,
      miembros: (json['miembros'] as List<dynamic>)
          .map((e) => MiembroGrupo.fromJson(e as Map<String, dynamic>))
          .toList(),
      fechaCreacion: DateTime.parse(json['fechaCreacion'] as String),
    );

Map<String, dynamic> _$GrupoToJson(_Grupo instance) => <String, dynamic>{
      'id': instance.id,
      'nombre': instance.nombre,
      'descripcion': instance.descripcion,
      'creadorId': instance.creadorId,
      'miembros': instance.miembros,
      'fechaCreacion': instance.fechaCreacion.toIso8601String(),
    };
