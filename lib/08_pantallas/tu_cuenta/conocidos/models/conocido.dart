import 'package:freezed_annotation/freezed_annotation.dart';

part 'conocido.freezed.dart';
part 'conocido.g.dart';

enum InvitacionEstado {
  pendiente,
  aceptado,
  rechazado,
  bloqueado,
}

@freezed
abstract class Conocido with _$Conocido {
  const factory Conocido({
    required String id,
    required String solicitanteId,
    @Default('') String solicitanteNombre,
    required String receptorId,
    @Default('') String receptorNombre,
    @Default(InvitacionEstado.pendiente) InvitacionEstado estado,
    required DateTime fechaActualizacion,
  }) = _Conocido;

  factory Conocido.fromJson(Map<String, dynamic> json) => _$ConocidoFromJson(json);
}
