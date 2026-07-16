import 'package:freezed_annotation/freezed_annotation.dart';
import '../08_pantallas/ubicacion/data_sepomex_localidades.dart';

part 'data_user_localidad.freezed.dart';
part 'data_user_localidad.g.dart';

@freezed
abstract class UsuarioLocalidades with _$UsuarioLocalidades {
  const factory UsuarioLocalidades({
    @JsonKey(name: 'id_codigopostal') required String idCodigopostal,
    @JsonKey(name: 'id_usuario') required String idUsuario,
    @Default('México') String pais,
    @JsonKey(name: 'localidadesCp') required LocalidadCp localidadCp,
    @Default('') String calle,
    @Default('') String seccionine,
    @Default('') String latitud,
    @Default('') String longitud,
    @Default('') String latDecimal,
    @Default('') String lonDecimal,
    @Default('') String timestamp,
  }) = _UsuarioLocalidades;

  factory UsuarioLocalidades.fromJson(Map<String, dynamic> json) =>
      _$UsuarioLocalidadesFromJson(json);
}
