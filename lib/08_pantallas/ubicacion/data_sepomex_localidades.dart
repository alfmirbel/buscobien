// lib/08_pantallas/ubicacion/data_sepomex_localidades.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'data_sepomex_localidades.freezed.dart';
part 'data_sepomex_localidades.g.dart';

@freezed
abstract class LocalidadCp with _$LocalidadCp {
  const factory LocalidadCp({
    required int idEstado,
    required String estado,
    required int idMunicipio,
    required String municipio,
    required String ciudad,
    required String zona,
    required int cp,
    required String asentamiento,
    required String tipo,
  }) = _LocalidadCp;

  factory LocalidadCp.fromJson(Map<String, dynamic> json) =>
      _$LocalidadCpFromJson(json);
}
