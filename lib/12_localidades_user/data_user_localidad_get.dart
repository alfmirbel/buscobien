import 'dart:convert';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'data_user_localidad.dart';

part 'data_user_localidad_get.freezed.dart';
part 'data_user_localidad_get.g.dart';

UsuarioLocalidadesGet usuarioLocalidadesGetFromJson(String str) =>
    UsuarioLocalidadesGet.fromJson(json.decode(str) as Map<String, dynamic>);

@freezed
abstract class UsuarioLocalidadesGet with _$UsuarioLocalidadesGet {
  const factory UsuarioLocalidadesGet({
    @JsonKey(name: 'total_rows') required int totalRows,
    required int offset,
    required List<RowsUserLocal> rows,
  }) = _UsuarioLocalidadesGet;

  factory UsuarioLocalidadesGet.fromJson(Map<String, dynamic> json) =>
      _$UsuarioLocalidadesGetFromJson(json);
}

@freezed
abstract class RowsUserLocal with _$RowsUserLocal {
  const factory RowsUserLocal({
    required String id,
    required String key,
    required UsuarioLocalidades value,
  }) = _RowsUserLocal;

  factory RowsUserLocal.fromJson(Map<String, dynamic> json) =>
      _$RowsUserLocalFromJson(json);
}
