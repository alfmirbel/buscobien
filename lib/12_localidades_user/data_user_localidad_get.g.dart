// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data_user_localidad_get.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UsuarioLocalidadesGet _$UsuarioLocalidadesGetFromJson(
        Map<String, dynamic> json) =>
    _UsuarioLocalidadesGet(
      totalRows: (json['total_rows'] as num).toInt(),
      offset: (json['offset'] as num).toInt(),
      rows: (json['rows'] as List<dynamic>)
          .map((e) => RowsUserLocal.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$UsuarioLocalidadesGetToJson(
        _UsuarioLocalidadesGet instance) =>
    <String, dynamic>{
      'total_rows': instance.totalRows,
      'offset': instance.offset,
      'rows': instance.rows,
    };

_RowsUserLocal _$RowsUserLocalFromJson(Map<String, dynamic> json) =>
    _RowsUserLocal(
      id: json['id'] as String,
      key: json['key'] as String,
      value: UsuarioLocalidades.fromJson(json['value'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$RowsUserLocalToJson(_RowsUserLocal instance) =>
    <String, dynamic>{
      'id': instance.id,
      'key': instance.key,
      'value': instance.value,
    };
