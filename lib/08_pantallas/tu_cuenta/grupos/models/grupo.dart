import 'package:freezed_annotation/freezed_annotation.dart';

part 'grupo.freezed.dart';
part 'grupo.g.dart';

enum RolGrupo {
  admin,
  miembro,
}

@freezed
abstract class MiembroGrupo with _$MiembroGrupo {
  const factory MiembroGrupo({
    required String usuarioId,
    @Default(RolGrupo.miembro) RolGrupo rol,
    required DateTime fechaIngreso,
  }) = _MiembroGrupo;

  factory MiembroGrupo.fromJson(Map<String, dynamic> json) => _$MiembroGrupoFromJson(json);
}

@freezed
abstract class Grupo with _$Grupo {
  const factory Grupo({
    required String id,
    required String nombre,
    required String descripcion,
    required String creadorId,
    required List<MiembroGrupo> miembros,
    required DateTime fechaCreacion,
  }) = _Grupo;

  factory Grupo.fromJson(Map<String, dynamic> json) => _$GrupoFromJson(json);
}
