// home_state.dart
import 'package:freezed_annotation/freezed_annotation.dart';

// Es indispensable incluir también el archivo .g.dart si planeas
// usar serialización (JSON) o algunas funciones de Riverpod Generator
part 'home_state.freezed.dart';

@freezed
class HomeState with _$HomeState {
  const factory HomeState({
    @Default(0) int indiceInicial,
    @Default(0) int indicePrincipal,
    @Default(0) int indiceNivelGobierno,
    @Default(0) int indiceTipoEspacio,
    @Default(0) int indiceTipoTransaccion,
    @Default(0) int indiceMiCuenta,
    @Default(0) int indiceMiCuentaUsuario,
    @Default(0) int version,
  }) = _HomeState;

  // Si necesitas agregar métodos o getters personalizados (calculados),
  // debes usar un constructor privado vacío:
  const HomeState._();

  @override
  int get indiceInicial => throw UnimplementedError();

  @override
  int get indicePrincipal => throw UnimplementedError();

  @override
  int get indiceNivelGobierno => throw UnimplementedError();

  @override
  int get indiceTipoEspacio => throw UnimplementedError();

  @override
  int get indiceTipoTransaccion => throw UnimplementedError();

  @override
  int get indiceMiCuenta => throw UnimplementedError();

  @override
  int get indiceMiCuentaUsuario => throw UnimplementedError();

  @override
  int get version => throw UnimplementedError();
}
