// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data_sepomex_localidades.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_LocalidadCp _$LocalidadCpFromJson(Map<String, dynamic> json) => _LocalidadCp(
      idEstado: (json['idEstado'] as num).toInt(),
      estado: json['estado'] as String,
      idMunicipio: (json['idMunicipio'] as num).toInt(),
      municipio: json['municipio'] as String,
      ciudad: json['ciudad'] as String,
      zona: json['zona'] as String,
      cp: (json['cp'] as num).toInt(),
      asentamiento: json['asentamiento'] as String,
      tipo: json['tipo'] as String,
    );

Map<String, dynamic> _$LocalidadCpToJson(_LocalidadCp instance) =>
    <String, dynamic>{
      'idEstado': instance.idEstado,
      'estado': instance.estado,
      'idMunicipio': instance.idMunicipio,
      'municipio': instance.municipio,
      'ciudad': instance.ciudad,
      'zona': instance.zona,
      'cp': instance.cp,
      'asentamiento': instance.asentamiento,
      'tipo': instance.tipo,
    };
