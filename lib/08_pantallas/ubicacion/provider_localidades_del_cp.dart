import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'data_sepomex_localidades.dart';
import 'data_sepomex_localidades_get_cp.dart';
import '../../../12_localidades_user/localidades_repository.dart';

//----------------------------------------------------------------------------
class ListaDeLocalidadesDelCP {
  final int codigoPostal;
  final int localidadSeleccionada;
  final LocalidadesGet localidades;

  ListaDeLocalidadesDelCP({
    required this.codigoPostal,
    required this.localidadSeleccionada,
    required this.localidades,
  });

  ListaDeLocalidadesDelCP copyWith({
    int? codigoPostal,
    int? localidadSeleccionada,
    LocalidadesGet? localidades,
  }) {
    return ListaDeLocalidadesDelCP(
      codigoPostal: codigoPostal ?? this.codigoPostal,
      localidadSeleccionada:
          localidadSeleccionada ?? this.localidadSeleccionada,
      localidades: localidades ?? this.localidades,
    );
  }
}

final ListaDeLocalidadesDelCP iniciaLocalidades = ListaDeLocalidadesDelCP(
  codigoPostal: 0,
  localidadSeleccionada: 0,
  localidades: LocalidadesGet(
    totalRows: 0,
    offset: 0,
    rows: [
      RowLocalidadesGet(
        id: "",
        key: 0,
        value: ValueLocalidadesGet(
          id: "",
          rev: "",
          localidadCp: LocalidadCp(
            idEstado: 0,
            estado: "",
            idMunicipio: 0,
            municipio: "",
            ciudad: "",
            zona: "",
            cp: 0,
            asentamiento: "",
            tipo: "",
          ),
        ),
      ),
    ],
  ),
);

//----------------------------------------------------------------------------
final localidadesPorCodigoPostalProvider =
    NotifierProvider<ClassLocalidadesNotifierProvider, ListaDeLocalidadesDelCP>(
      () {
        return ClassLocalidadesNotifierProvider();
      },
    );

//-----------------------------------------------------------------------------
class ClassLocalidadesNotifierProvider
    extends Notifier<ListaDeLocalidadesDelCP> {
  @override
  ListaDeLocalidadesDelCP build() => iniciaLocalidades;

  LocalidadesRepository get _repo => ref.read(localidadesRepositoryProvider);

  //----------------------------------------------------------------------------
  Future<int> fetchLocaliadesCodigoPostal() async {
    final result = await _repo.fetchByCodigoPostal(state.codigoPostal);
    state = state.copyWith(localidades: result);
    return result.rows.isNotEmpty ? 200 : 404;
  }

  //----------------------------------------------------------------------------
  void setCodigoPostal(int cp) {
    state = state.copyWith(codigoPostal: cp);
  }

  int getCodigoPostal() => state.codigoPostal;

  //----------------------------------------------------------------------------
  void setLocalidadActual(int posicion) {
    state = state.copyWith(localidadSeleccionada: posicion);
  }

  int getLocalidadActual() => state.localidadSeleccionada;

  void resetLocalidadesCodigoPostal() {
    state = iniciaLocalidades;
  }
}

//----------------------------------------------------------------------------
final getLocalidadesDelCPFutureProvider = FutureProvider<int>((ref) async {
  return ref
      .read(localidadesPorCodigoPostalProvider.notifier)
      .fetchLocaliadesCodigoPostal();
});
