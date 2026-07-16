// home_navigation_provider.dart
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../60_global_widgets/debugprint.dart';
import 'home_state.dart'; // Importa el modelo de arriba

part 'home_navigation_provider.g.dart';

// home_navigation_provider.dart
@riverpod
class HomeNavigation extends _$HomeNavigation {
  @override
  HomeState build() {
    return const HomeState(indiceInicial: 0); // Inicio por defecto
  }

  void setInicial(int i) => state = state.copyWith(indiceInicial: i);
  void setPrincipal(int i) => state = state.copyWith(indicePrincipal: i);
  void setGobierno(int i) => state = state.copyWith(indiceNivelGobierno: i);
  void setEspacio(int i) => state = state.copyWith(indiceTipoEspacio: i);
  void setTransaccion(int i) =>
      state = state.copyWith(indiceTipoTransaccion: i);
  void setMiCuenta(int i) => state = state.copyWith(indiceMiCuenta: i);
  void setMiCuentaUsuario(int i) =>
      state = state.copyWith(indiceMiCuentaUsuario: i);

  void actualizarInicial(int index) {
    debugPrintLevels(
      10,
      "*************** ACTUALIZA PROVIDERS MENU INICIAL $index ************",
    );
    state = state.copyWith(indiceInicial: index, version: state.version + 1);
  }

  void actualizarPrincipal(int index) {
    debugPrintLevels(
      10,
      "*************** ACTUALIZA PROVIDERS MENU PRINCIPAL $index ************",
    );
    state = state.copyWith(indicePrincipal: index, version: state.version + 1);
  }

  void actualizarNivelGobierno(int index) {
    debugPrintLevels(
      10,
      "*************** ACTUALIZA PROVIDERS NIVEL GOBIERNO $index ************",
    );
    state = state.copyWith(
      indiceNivelGobierno: index,
      version: state.version + 1,
    );
  }

  void actualizarTipoEspacio(int index) {
    debugPrintLevels(
      10,
      "*************** ACTUALIZA PROVIDERS TIPO ESPACIO $index ************",
    );
    state = state.copyWith(
      indiceTipoEspacio: index,
      version: state.version + 1,
    );
  }

  void actualizarTipoTransaccion(int index) {
    debugPrintLevels(
      10,
      "*************** ACTUALIZA PROVIDERS TIPO TRANSACCIÓN $index ************",
    );
    state = state.copyWith(
      indiceTipoTransaccion: index,
      version: state.version + 1,
    );
  }

  void actualizarMiCuenta(int index) {
    debugPrintLevels(
      10,
      "*************** ACTUALIZA PROVIDERS MI CUENTA $index ************",
    );
    state = state.copyWith(indiceMiCuenta: index, version: state.version + 1);
  }

  void actualizarMiCuentaUsuario(int index) {
    debugPrintLevels(
      10,
      "*************** ACTUALIZA PROVIDERS MI CUENTA USUARIO $index ************",
    );
    state = state.copyWith(
      indiceMiCuentaUsuario: index,
      version: state.version + 1,
    );
  }
}

/*
@riverpod
class HomeNavigation extends _$HomeNavigation {
  @override
  HomeState build() {
    return const HomeState();
  }

  void actualizarPrincipal(int index) {
    state = state.copyWith(indicePrincipal: index, version: state.version + 1);
  }

  void actualizarNivelGobierno(int index) {
    state = state.copyWith(
      indiceNivelGobierno: index,
      version: state.version + 1,
    );
  }

  void actualizarTipoEspacio(int index) {
    state = state.copyWith(
      indiceTipoEspacio: index,
      version: state.version + 1,
    );
  }

  void actualizarTipoTransaccion(int index) {
    state = state.copyWith(
      indiceTipoTransaccion: index,
      version: state.version + 1,
    );
  }
}
*/
