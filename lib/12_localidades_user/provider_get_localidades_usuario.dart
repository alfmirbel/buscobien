import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../10_user_login/usuario_login/provider_session.dart';
import '../08_pantallas/ubicacion/data_sepomex_localidades.dart';
import '../08_pantallas/ubicacion/data_sepomex_localidades_get_cp.dart';
import 'data_user_localidad.dart';
import 'data_user_localidad_get.dart';
import 'localidades_repository.dart';

//------------------------------------------------------------------------------
final userLocalidadesProvider =
    NotifierProvider<ClassUserLocalNotifierProvider, UsuarioLocalidadesGet>(() {
      return ClassUserLocalNotifierProvider();
    });
//------------------------------------------------------------------------------

// Estado vacío reutilizable
UsuarioLocalidadesGet _emptyState() => const UsuarioLocalidadesGet(
  totalRows: 0,
  offset: 0,
  rows: [],
);

class ClassUserLocalNotifierProvider extends Notifier<UsuarioLocalidadesGet> {
  @override
  UsuarioLocalidadesGet build() => _emptyState();

  LocalidadesRepository get _repo =>
      ref.read(localidadesRepositoryProvider);

  int localidadSeleccionada = 0;

  //----------------------------------------------------------------------------
  Future<int> fetchLocalidadesDeUsuario() async {
    final userData = ref.read(sessionProvider).userData;
    if (userData.rows.isEmpty) return 500;
    final userID = userData.rows[0].value.usuario.idUsuario;
    if (userID.isEmpty) return 500;

    final result = await _repo.fetchUserLocalidades(userID);
    state = result;
    localidadSeleccionada = 0;
    return result.rows.isNotEmpty ? 200 : 404;
  }

  //----------------------------------------------------------------------------
  Future<int> gdtLocalidadUsuario(String asentamiento) async {
    final userData = ref.read(sessionProvider).userData;
    if (userData.rows.isEmpty) return 500;
    final userID = userData.rows[0].value.usuario.idUsuario;

    final result = await _repo.fetchUserLocalidad(userID, asentamiento);
    state = result;
    localidadSeleccionada = 0;
    return result.rows.isNotEmpty ? 200 : 404;
  }

  //----------------------------------------------------------------------------
  Future<int> writeUserLocalidadToCouchDB(UsuarioLocalidades userLocal) async {
    final userID = ref
        .read(sessionProvider)
        .userData
        .rows[0]
        .value
        .usuario
        .idUsuario;

    final localidadActualizada = userLocal.copyWith(
      timestamp: DateTime.now().toString(),
      idUsuario: userID,
    );

    return _repo.saveUserLocalidad(localidadActualizada);
  }

  //----------------------------------------------------------------------------
  Future<bool> deleteUserLocalidadFromCouchDB(String id) async {
    final success = await _repo.deleteUserLocalidad(id);
    if (success) {
      await fetchLocalidadesDeUsuario();
    }
    return success;
  }

  //----------------------------------------------------------------------------
  void setLocalidadSeleccionada(int index) {
    localidadSeleccionada = index;
  }

  //----------------------------------------------------------------------------
  void setUserLocalSelectedFromLocalidades(
    LocalidadesGet localidadSeleccionada,
    int index,
  ) {
    final idUsuario = ref
        .read(sessionProvider)
        .userData
        .rows[0]
        .value
        .usuario
        .idUsuario;
    final locData = localidadSeleccionada.rows[index].value;

    final nueva = UsuarioLocalidades(
      idCodigopostal: localidadSeleccionada.rows[index].id,
      idUsuario: idUsuario,
      localidadCp: locData.localidadCp,
      calle: state.rows.isNotEmpty ? state.rows[0].value.calle : "",
      seccionine: state.rows.isNotEmpty ? state.rows[0].value.seccionine : "",
      latitud: state.rows.isNotEmpty ? state.rows[0].value.latitud : "",
      longitud: state.rows.isNotEmpty ? state.rows[0].value.longitud : "",
      latDecimal: state.rows.isNotEmpty ? state.rows[0].value.latDecimal : "",
      lonDecimal: state.rows.isNotEmpty ? state.rows[0].value.lonDecimal : "",
      timestamp: state.rows.isNotEmpty ? state.rows[0].value.timestamp : "",
    );

    state = UsuarioLocalidadesGet(
      totalRows: state.totalRows,
      offset: state.offset,
      rows: [
        RowsUserLocal(
          id: state.rows.isNotEmpty ? state.rows[0].id : "",
          key: state.rows.isNotEmpty ? state.rows[0].key : "",
          value: nueva,
        ),
      ],
    );

    ref.read(sessionProvider.notifier).updateLocalidadEnSesion(locData.localidadCp);
  }

  //----------------------------------------------------------------------------
  void setUserLocalFromUserLocalGet(UsuarioLocalidadesGet localidadSeleccionada) {
    final idUsuario = ref
        .read(sessionProvider)
        .userData
        .rows[0]
        .value
        .usuario
        .idUsuario;
    final locData = localidadSeleccionada.rows[0].value;

    final nueva = UsuarioLocalidades(
      idCodigopostal: locData.idCodigopostal,
      idUsuario: idUsuario,
      localidadCp: locData.localidadCp,
      calle: state.rows.isNotEmpty ? state.rows[0].value.calle : "",
      seccionine: state.rows.isNotEmpty ? state.rows[0].value.seccionine : "",
      latitud: state.rows.isNotEmpty ? state.rows[0].value.latitud : "",
      longitud: state.rows.isNotEmpty ? state.rows[0].value.longitud : "",
      latDecimal: state.rows.isNotEmpty ? state.rows[0].value.latDecimal : "",
      lonDecimal: state.rows.isNotEmpty ? state.rows[0].value.lonDecimal : "",
      timestamp: state.rows.isNotEmpty ? state.rows[0].value.timestamp : "",
    );

    state = UsuarioLocalidadesGet(
      totalRows: state.totalRows,
      offset: state.offset,
      rows: [
        RowsUserLocal(
          id: state.rows.isNotEmpty ? state.rows[0].id : "",
          key: state.rows.isNotEmpty ? state.rows[0].key : "",
          value: nueva,
        ),
      ],
    );

    ref.read(sessionProvider.notifier).updateLocalidadEnSesion(locData.localidadCp);
  }

  //----------------------------------------------------------------------------
  void resetUsuarioLocalidadesGet(LocalidadesGet localidadSeleccionada, int index) {
    final idUsuario = ref
        .read(sessionProvider)
        .userData
        .rows[0]
        .value
        .usuario
        .idUsuario;
    final locData = localidadSeleccionada.rows[index].value;

    state = UsuarioLocalidadesGet(
      totalRows: 0,
      offset: 0,
      rows: [
        RowsUserLocal(
          id: "",
          key: "",
          value: UsuarioLocalidades(
            idCodigopostal: localidadSeleccionada.rows[index].id,
            idUsuario: idUsuario,
            localidadCp: locData.localidadCp,
          ),
        ),
      ],
    );

    ref.read(sessionProvider.notifier).updateLocalidadEnSesion(LocalidadCp(
      idEstado: 0, estado: "", idMunicipio: 0, municipio: "",
      ciudad: "", zona: "", cp: 0, asentamiento: "", tipo: "",
    ));
  }

  //----------------------------------------------------------------------------
  void resetlistaLocalidadesUsuario() {
    state = _emptyState();
  }

  //----------------------------------------------------------------------------
  void addLocalidad2UserLocalidad(LocalidadCp localidad) {
    final nuevaRow = RowsUserLocal(
      id: "",
      key: "",
      value: UsuarioLocalidades(
        idCodigopostal: "",
        idUsuario: "",
        localidadCp: localidad,
      ),
    );

    final isPlaceholder = state.rows.length == 1 &&
        state.rows[0].value.localidadCp.cp == 0 &&
        state.rows[0].value.localidadCp.asentamiento.isEmpty;

    final List<RowsUserLocal> newRows;
    if (state.rows.isEmpty || isPlaceholder) {
      newRows = [nuevaRow];
    } else {
      newRows = [...state.rows, nuevaRow];
    }

    state = state.copyWith(rows: newRows);
  }
}

//------------------------------------------------------------------------------
final getUserLocalidadesFutureProvider = FutureProvider<int>((ref) async {
  return ref.read(userLocalidadesProvider.notifier).fetchLocalidadesDeUsuario();
});
