// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data_user_localidad.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UsuarioLocalidades _$UsuarioLocalidadesFromJson(Map<String, dynamic> json) =>
    _UsuarioLocalidades(
      idCodigopostal: json['id_codigopostal'] as String,
      idUsuario: json['id_usuario'] as String,
      pais: json['pais'] as String? ?? 'México',
      localidadCp:
          LocalidadCp.fromJson(json['localidadesCp'] as Map<String, dynamic>),
      calle: json['calle'] as String? ?? '',
      seccionine: json['seccionine'] as String? ?? '',
      latitud: json['latitud'] as String? ?? '',
      longitud: json['longitud'] as String? ?? '',
      latDecimal: json['latDecimal'] as String? ?? '',
      lonDecimal: json['lonDecimal'] as String? ?? '',
      timestamp: json['timestamp'] as String? ?? '',
    );

Map<String, dynamic> _$UsuarioLocalidadesToJson(_UsuarioLocalidades instance) =>
    <String, dynamic>{
      'id_codigopostal': instance.idCodigopostal,
      'id_usuario': instance.idUsuario,
      'pais': instance.pais,
      'localidadesCp': instance.localidadCp,
      'calle': instance.calle,
      'seccionine': instance.seccionine,
      'latitud': instance.latitud,
      'longitud': instance.longitud,
      'latDecimal': instance.latDecimal,
      'lonDecimal': instance.lonDecimal,
      'timestamp': instance.timestamp,
    };
