// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'conocido.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Conocido _$ConocidoFromJson(Map<String, dynamic> json) => _Conocido(
      id: json['id'] as String,
      solicitanteId: json['solicitanteId'] as String,
      solicitanteNombre: json['solicitanteNombre'] as String? ?? '',
      receptorId: json['receptorId'] as String,
      receptorNombre: json['receptorNombre'] as String? ?? '',
      estado: $enumDecodeNullable(_$InvitacionEstadoEnumMap, json['estado']) ??
          InvitacionEstado.pendiente,
      fechaActualizacion: DateTime.parse(json['fechaActualizacion'] as String),
    );

Map<String, dynamic> _$ConocidoToJson(_Conocido instance) => <String, dynamic>{
      'id': instance.id,
      'solicitanteId': instance.solicitanteId,
      'solicitanteNombre': instance.solicitanteNombre,
      'receptorId': instance.receptorId,
      'receptorNombre': instance.receptorNombre,
      'estado': _$InvitacionEstadoEnumMap[instance.estado]!,
      'fechaActualizacion': instance.fechaActualizacion.toIso8601String(),
    };

const _$InvitacionEstadoEnumMap = {
  InvitacionEstado.pendiente: 'pendiente',
  InvitacionEstado.aceptado: 'aceptado',
  InvitacionEstado.rechazado: 'rechazado',
  InvitacionEstado.bloqueado: 'bloqueado',
};
