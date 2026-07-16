import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../40_security/direccionip.dart';
import '../../08_pantallas/ubicacion/data_sepomex_localidades.dart';
import '../../60_global_widgets/debugprint.dart';
import '../data_models/data_get_user.dart';
import '../data_models/data_user_promotor.dart';
import '../data_models/data_usuarios.dart';
import '../data_models/data_get_id_user_pass.dart';
import '../data_models/auth_state.dart';
import 'data_session.dart';
import 'session_repository.dart';
import 'session_storage.dart';

part 'provider_session.g.dart';

@riverpod
SessionStorage sessionStorage(Ref ref) {
  return createSessionStorage();
}

@riverpod
class SessionNotifier extends _$SessionNotifier {
  SessionStorage get _storage => ref.read(sessionStorageProvider);

  Map<String, String> get _authHeaders {
    String basicAuth =
        'Basic ${base64Encode(utf8.encode('$username:$password'))}';
    return {'Authorization': basicAuth, 'Content-Type': 'application/json'};
  }

  @override
  AuthState build() {
    return AuthState.initial();
  }

  void resetInitialUserData(int seccion) {
    var newSession = state.sessionUserData;
    var newInitialId = state.initialIdUserPass;
    var newUserData = state.userData;

    if (seccion == 0 || seccion == 1) {
      newSession = SessionData(
        key: "",
        varName: "",
        valueToSave: "",
        userId: "",
        userName: "",
        userPass: "",
        esUsuarioComprador: "",
        esUsuarioPromotor: "",
        esUsuarioEspecialista: "",
        boolUsuarioComprador: false,
        boolUsuarioPromotor: false,
        boolUsuarioEspecialista: false,
      );
    }
    if (seccion == 0 || seccion == 2) {
      newInitialId = GetIdUserPass(
        totalRows: 0,
        offset: 0,
        rows: [
          RowIdUserPass(
            id: "",
            key: "",
            value: ValueIdUserPass(
              userId: "",
              userName: "",
              userPass: "",
              idFoto: "",
            ),
          ),
        ],
      );
    }
    if (seccion == 0 || seccion == 3) {
      newUserData = GetUserData(
        totalRows: 0,
        offset: 0,
        rows: [
          RowGetUserData(
            id: "",
            key: "",
            value: ValueGetUserData(
              id: "",
              rev: "",
              usuario: Usuario(
                idUsuario: "",
                avatar: "",
                nombres: "",
                apellidopaterno: "",
                apellidomaterno: "",
                numerocelular: "",
                correoelectronico: "",
                nombreusuario: "",
                claveacceso: "",
                ubicacionUserData: UbicacionUserData(
                  pais: "México",
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
                  calle: "",
                  seccionine: "",
                  latitud: "",
                  longitud: "",
                  latDecimal: "",
                  lonDecimal: "",
                ),
                fechaDeNacimiento: FechaDeNacimiento(dia: 0, mes: 0, anio: 0),
                timestamp: "",
                datospromotor: UserDataPromotor(
                  tipodeusuario: "",
                  rfc: "",
                  numerodecliente: "",
                  inmobiliaria: "",
                  espacionormal: 0,
                  espaciodestacados: 0,
                  espaciosuperdestacados: 0,
                  espaciosoportunidad: 0,
                  espaciosremate: 0,
                ),
              ),
            ),
          ),
        ],
      );
    }
    state = state.copyWith(
      sessionUserData: newSession,
      initialIdUserPass: newInitialId,
      userData: newUserData,
      esUsuario: false,
      esPromotor: false,
      esPropietario: false,
      esAnfrition: false,
      esVendedor: false,
      esEspecialista: false,
      esProveedor: false,
      esAsociacion: false,
      esInmobiliaria: false,
      nombrePerfil: "",
      isAuthenticated: false,
      isUserDataLoaded: false, // FASE 5: resetear caché al cerrar sesión
    );
  }

  Future<void> saveVarValueToLocalStorage(
    String varName,
    String valueToSave,
  ) async {
    debugPrintLevels(1, " STORAGE: Guardando $varName -> $valueToSave");
    await _storage.write(key: varName, value: valueToSave);
  }

  Future<String?> getVarValueFromLocalStorage(String varName) async {
    final val = await _storage.read(key: varName) ?? "";
    debugPrintLevels(1, " STORAGE: Leyendo $varName -> $val");
    return val;
  }

  Future<void> getSessionValuesFromLocalStorage() async {
    debugPrintLevels(
      1,
      " STORAGE: Iniciando getSessionValuesFromLocalStorage()",
    );
    final userId = await _storage.read(key: "userId") ?? "";
    final userName = await _storage.read(key: "userName") ?? "";
    final nombre = await _storage.read(key: "nombrePerfil") ?? "";
    final userPassHash = await _storage.read(key: "userPassHash") ?? "";

    debugPrintLevels(1, " STORAGE: userId recuperado: $userId");
    debugPrintLevels(1, " STORAGE: userName recuperado: $userName");
    debugPrintLevels(1, " STORAGE: nombrePerfil recuperado: $nombre");

    // Si no hay sesión guardada, no hacer nada
    if (userId.isEmpty && userName.isEmpty) {
      debugPrintLevels(
        1,
        " STORAGE: No hay sesión guardada. Deteniendo recuperación.",
      );
      return;
    }

    // ✅ Crear nueva instancia (no mutar la existente) para respetar inmutabilidad de Riverpod
    final updatedSession = SessionData(
      key: "",
      varName: "",
      valueToSave: "",
      userId: userId,
      userName: userName,
      userPass:
          userPassHash, // hash SHA-256; nunca se persiste la clave en texto plano
      esUsuarioComprador: "",
      esUsuarioPromotor: "",
      esUsuarioEspecialista: "",
      boolUsuarioComprador: false,
      boolUsuarioPromotor: false,
      boolUsuarioEspecialista: false,
    );

    state = state.copyWith(
      sessionUserData: updatedSession,
      nombrePerfil: nombre,
      isAuthenticated: true,
    );

    debugPrintLevels(1, " STORAGE: Sesión marcada como autenticada.");

    // Actualizar los flags de rol según el perfil recuperado
    if (nombre.isNotEmpty) {
      setPerfilUsuarioByNombrePerfil();
    }
  }

  Future<bool> deleteLocalSessionData() async {
    await _storage.deleteAll();
    return true;
  }

  // FASE 2 (26-05-18): Reemplaza mutaciones directas en SessionData
  // por instancias nuevas vía copyWith, respetando la inmutabilidad de Riverpod.
  void setPerfilUsuarioByNombrePerfil() {
    // Variables locales — se asignan según el perfil activo
    String esComprador = "";
    bool boolComprador = false;
    String esPromotorStr = "";
    bool boolPromotor = false;
    String esEspecialistaStr = "";
    bool boolEspecialista = false;

    bool esUsuario = false;
    bool esPromotor = false;
    bool esPropietario = false;
    bool esAnfrition = false;
    bool esVendedor = false;
    bool esEspecialista = false;
    bool esProveedor = false;
    bool esAsociacion = false;
    bool esInmobiliaria = false;

    switch (state.nombrePerfil) {
      case "Usuario":
        esUsuario = true;
        esComprador = state.nombrePerfil;
        boolComprador = true;
        break;
      case "Promotor":
        esPromotor = true;
        esPromotorStr = state.nombrePerfil;
        boolPromotor = true;
        break;
      case "Propietario":
        esPropietario = true;
        break;
      case "Anfitrión":
        esAnfrition = true;
        break;
      case "Vendedor":
        esVendedor = true;
        break;
      case "Especialista":
        esEspecialista = true;
        esEspecialistaStr = state.nombrePerfil;
        boolEspecialista = true;
        break;
      case "Proveedor":
        esProveedor = true;
        break;
      case "Asociación":
        esAsociacion = true;
        break;
      case "Inmobiliaria":
        esInmobiliaria = true;
        break;
    }

    // Nueva instancia inmutable de SessionData — no se muta el objeto existente
    final updatedSession = state.sessionUserData.copyWith(
      esUsuarioComprador: esComprador,
      boolUsuarioComprador: boolComprador,
      esUsuarioPromotor: esPromotorStr,
      boolUsuarioPromotor: boolPromotor,
      esUsuarioEspecialista: esEspecialistaStr,
      boolUsuarioEspecialista: boolEspecialista,
    );

    state = state.copyWith(
      sessionUserData: updatedSession,
      esUsuario: esUsuario,
      esPromotor: esPromotor,
      esPropietario: esPropietario,
      esAnfrition: esAnfrition,
      esVendedor: esVendedor,
      esEspecialista: esEspecialista,
      esProveedor: esProveedor,
      esAsociacion: esAsociacion,
      esInmobiliaria: esInmobiliaria,
    );
  }

  // FASE 2 (26-05-18): Crea nueva instancia de SessionData via copyWith
  // en lugar de mutar el objeto referenciado desde state.
  void setSessionVarValue(String varName, dynamic value) {
    SessionData? updated;
    switch (varName) {
      case "userId":
        updated = state.sessionUserData.copyWith(userId: value as String);
        break;
      case "userName":
        updated = state.sessionUserData.copyWith(userName: value as String);
        break;
      case "userPass":
        updated = state.sessionUserData.copyWith(userPass: value as String);
        break;
      case "esUsuarioComprador":
        updated = state.sessionUserData.copyWith(
          esUsuarioComprador: value as String,
        );
        break;
      case "esUsuarioPromotor":
        updated = state.sessionUserData.copyWith(
          esUsuarioPromotor: value as String,
        );
        break;
      case "esUsuarioEspecialista":
        updated = state.sessionUserData.copyWith(
          esUsuarioEspecialista: value as String,
        );
        break;
      case "boolUsuarioComprador":
        updated = state.sessionUserData.copyWith(
          boolUsuarioComprador: value as bool,
        );
        break;
      case "boolUsuarioPromotor":
        updated = state.sessionUserData.copyWith(
          boolUsuarioPromotor: value as bool,
        );
        break;
      case "boolUsuarioEspecialista":
        updated = state.sessionUserData.copyWith(
          boolUsuarioEspecialista: value as bool,
        );
        break;
    }
    if (updated != null) state = state.copyWith(sessionUserData: updated);
  }

  void setNombrePerfil(String nombre) {
    state = state.copyWith(nombrePerfil: nombre);
    setPerfilUsuarioByNombrePerfil();
  }

  void setRoleFlag(String varName, bool value) {
    switch (varName) {
      case "esUsuario":
        state = state.copyWith(esUsuario: value);
        break;
      case "esPromotor":
        state = state.copyWith(esPromotor: value);
        break;
      case "esPropietario":
        state = state.copyWith(esPropietario: value);
        break;
      case "esAnfrition":
        state = state.copyWith(esAnfrition: value);
        break;
      case "esVendedor":
        state = state.copyWith(esVendedor: value);
        break;
      case "esEspecialista":
        state = state.copyWith(esEspecialista: value);
        break;
      case "esProveedor":
        state = state.copyWith(esProveedor: value);
        break;
      case "esAsociacion":
        state = state.copyWith(esAsociacion: value);
        break;
      case "esInmobiliaria":
        state = state.copyWith(esInmobiliaria: value);
        break;
    }
  }

  dynamic getSessionVarValue(String varName) {
    switch (varName) {
      case "userId":
        return state.sessionUserData.userId;
      case "userName":
        return state.sessionUserData.userName;
      case "userPass":
        return state.sessionUserData.userPass;
      case "Usuario":
        return state.esUsuario;
      case "Promotor":
        return state.esPromotor;
      case "Propietario":
        return state.esPropietario;
      case "Anfitrión":
        return state.esAnfrition;
      case "Vendedor":
        return state.esVendedor;
      case "Especialista":
        return state.esEspecialista;
      case "Proveedor":
        return state.esProveedor;
      case "Asociación":
        return state.esAsociacion;
      case "Inmobiliaria":
        return state.esInmobiliaria;
      case "esUsuarioComprador":
        return state.sessionUserData.esUsuarioComprador;
      case "esUsuarioPromotor":
        return state.sessionUserData.esUsuarioPromotor;
      case "esUsuarioEspecialista":
        return state.sessionUserData.esUsuarioEspecialista;
      case "boolUsuarioComprador":
        return state.sessionUserData.boolUsuarioComprador;
      case "boolUsuarioPromotor":
        return state.sessionUserData.boolUsuarioPromotor;
      case "boolUsuarioEspecialista":
        return state.sessionUserData.boolUsuarioEspecialista;
      default:
        return null;
    }
  }

  void setUserData(WidgetRef ref, ValueGetUserData usuarioSession) {
    var newUserData = state.userData;
    newUserData.rows[0].value = usuarioSession;
    state = state.copyWith(userData: newUserData);
  }

  void setCampoUserData(WidgetRef ref, String campo, String valor) {
    int parseIntSafe(String v) => int.tryParse(v) ?? 0;

    var newUserData = state.userData;
    var row = newUserData.rows[0];
    var user = row.value.usuario;
    var ubi = user.ubicacionUserData;
    var loc = ubi.localidadCp;
    var promo = user.datospromotor;

    switch (campo) {
      case "totalRows":
        newUserData.totalRows = parseIntSafe(valor);
        break;
      case "offset":
        newUserData.offset = parseIntSafe(valor);
        break;
      case "id":
        row.id = valor;
        break;
      case "key":
        row.key = valor;
        break;
      case "value.id":
        row.value.id = valor;
        break;
      case "value.rev":
        row.value.rev = valor;
        break;
      case "idUsuario":
        user.idUsuario = valor;
        break;
      case "avatar":
        user.avatar = valor;
        break;
      case "nombres":
        user.nombres = valor;
        break;
      case "apellidopaterno":
        user.apellidopaterno = valor;
        break;
      case "apellidomaterno":
        user.apellidomaterno = valor;
        break;
      case "numerocelular":
        user.numerocelular = valor;
        break;
      case "correoelectronico":
        user.correoelectronico = valor;
        break;
      case "nombreusuario":
        user.nombreusuario = valor;
        break;
      case "claveacceso":
        user.claveacceso = valor;
        break;
      case "pais":
        ubi.pais = valor;
        break;
      case "calle":
        ubi.calle = valor;
        break;
      case "seccionine":
        ubi.seccionine = valor;
        break;
      case "latitud":
        ubi.latitud = valor;
        break;
      case "longitud":
        ubi.longitud = valor;
        break;
      case "latDecimal":
        ubi.latDecimal = valor;
        break;
      case "lonDecimal":
        ubi.lonDecimal = valor;
        break;
      // LocalidadCp es @freezed — se usa copyWith para actualizar
      case "idEstado":
        ubi.localidadCp = loc.copyWith(idEstado: parseIntSafe(valor));
        break;
      case "estado":
        ubi.localidadCp = loc.copyWith(estado: valor);
        break;
      case "versidMunicipioion":
      case "idMunicipio":
        ubi.localidadCp = loc.copyWith(idMunicipio: parseIntSafe(valor));
        break;
      case "municipio":
        ubi.localidadCp = loc.copyWith(municipio: valor);
        break;
      case "ciudad":
        ubi.localidadCp = loc.copyWith(ciudad: valor);
        break;
      case "zona":
        ubi.localidadCp = loc.copyWith(zona: valor);
        break;
      case "cp":
        ubi.localidadCp = loc.copyWith(cp: parseIntSafe(valor));
        break;
      case "asentamiento":
        ubi.localidadCp = loc.copyWith(asentamiento: valor);
        break;
      case "tipo":
        ubi.localidadCp = loc.copyWith(tipo: valor);
        break;
      case "dia":
        user.fechaDeNacimiento.dia = parseIntSafe(valor);
        break;
      case "mes":
        user.fechaDeNacimiento.mes = parseIntSafe(valor);
        break;
      case "anio":
        user.fechaDeNacimiento.anio = parseIntSafe(valor);
        break;
      case "timestamp":
        user.timestamp = valor;
        break;
      case "tipodeusuario":
        promo.tipodeusuario = valor;
        break;
      case "rfc":
        promo.rfc = valor;
        break;
      case "numerodecliente":
        promo.numerodecliente = valor;
        break;
      case "inmobiliaria":
        promo.inmobiliaria = valor;
        break;
      case "espacionormal":
        promo.espacionormal = parseIntSafe(valor);
        break;
      case "espaciodestacados":
        promo.espaciodestacados = parseIntSafe(valor);
        break;
      case "espaciosuperdestacados":
        promo.espaciosuperdestacados = parseIntSafe(valor);
        break;
      case "espaciosoportunidad":
        promo.espaciosoportunidad = parseIntSafe(valor);
        break;
      case "espaciosremate":
        promo.espaciosremate = parseIntSafe(valor);
        break;
    }
    state = state.copyWith(userData: newUserData);
  }

  void updateLocalidadEnSesion(LocalidadCp loc) {
    if (state.userData.rows.isEmpty) return;
    // LocalidadCp es @freezed — asignamos la nueva instancia directamente
    state.userData.rows[0].value.usuario.ubicacionUserData.localidadCp = loc;
    state = state.copyWith(userData: state.userData);
  }

  String getCampoUserData(WidgetRef ref, String campo) {
    if (state.userData.rows.isEmpty) return "";
    var row = state.userData.rows[0];
    var user = row.value.usuario;
    var ubi = user.ubicacionUserData;
    var loc = ubi.localidadCp;
    var promo = user.datospromotor;
    switch (campo) {
      case "totalRows":
        return state.userData.totalRows.toString();
      case "offset":
        return state.userData.offset.toString();
      case "id":
        return row.id;
      case "key":
        return row.key;
      case "value.id":
        return row.value.id;
      case "value.rev":
        return row.value.rev;
      case "idUsuario":
        return user.idUsuario;
      case "avatar":
        return user.avatar;
      case "nombres":
        return user.nombres;
      case "apellidopaterno":
        return user.apellidopaterno;
      case "apellidomaterno":
        return user.apellidomaterno;
      case "numerocelular":
        return user.numerocelular;
      case "correoelectronico":
        return user.correoelectronico;
      case "nombreusuario":
        return user.nombreusuario;
      case "claveacceso":
        return user.claveacceso;
      case "pais":
        return ubi.pais;
      case "idEstado":
        return loc.idEstado.toString();
      case "estado":
        return loc.estado;
      case "versidMunicipioion":
        return loc.idMunicipio.toString();
      case "municipio":
        return loc.municipio;
      case "ciudad":
        return loc.ciudad;
      case "zona":
        return loc.zona;
      case "cp":
        return loc.cp.toString();
      case "asentamiento":
        return loc.asentamiento;
      case "tipo":
        return loc.tipo;
      case "calle":
        return ubi.calle;
      case "seccionine":
        return ubi.seccionine;
      case "latitud":
        return ubi.latitud;
      case "longitud":
        return ubi.longitud;
      case "latDecimal":
        return ubi.latDecimal;
      case "lonDecimal":
        return ubi.lonDecimal;
      case "dia":
        return user.fechaDeNacimiento.dia.toString();
      case "mes":
        return user.fechaDeNacimiento.mes.toString();
      case "anio":
        return user.fechaDeNacimiento.anio.toString();
      case "timestamp":
        return user.timestamp;
      case "tipodeusuario":
        return promo.tipodeusuario;
      case "rfc":
        return promo.rfc;
      case "numerodecliente":
        return promo.numerodecliente;
      case "inmobiliaria":
        return promo.inmobiliaria;
      case "espacionormal":
        return promo.espacionormal.toString();
      case "espaciodestacados":
        return promo.espaciodestacados.toString();
      case "espaciosuperdestacados":
        return promo.espaciosuperdestacados.toString();
      case "espaciosoportunidad":
        return promo.espaciosoportunidad.toString();
      case "espaciosremate":
        return promo.espaciosremate.toString();
      default:
        return "";
    }
  }

  Future<int> getUserDataByNameInSessionData() async {
    final repo = ref.read(sessionRepositoryProvider);
    final (statusCode, userData) = await repo.getUserDataByName(
      userName: state.sessionUserData.userName,
      nombrePerfil: state.nombrePerfil,
      authHeaders: _authHeaders,
    );
    if (userData != null) {
      // FASE 5: marcar datos como cargados para evitar peticiones redundantes
      state = state.copyWith(userData: userData, isUserDataLoaded: true);
    }
    return statusCode;
  }

  Future<int> getUserIdNamePassByName() async {
    final repo = ref.read(sessionRepositoryProvider);
    final (statusCode, initialId) = await repo.getUserIdNamePassByName(
      userName: state.sessionUserData.userName,
      nombrePerfil: state.nombrePerfil,
      authHeaders: _authHeaders,
    );

    if (initialId != null) {
      state = state.copyWith(initialIdUserPass: initialId);

      // ✅ Fase 5: Crear nueva instancia en lugar de mutar
      final SessionData newSession;
      if (initialId.rows.isEmpty) {
        newSession = SessionData(
          key: "",
          varName: "",
          valueToSave: "",
          userId: "",
          userName: state.sessionUserData.userName,
          userPass: "",
          esUsuarioComprador: "",
          esUsuarioPromotor: "",
          esUsuarioEspecialista: "",
          boolUsuarioComprador: false,
          boolUsuarioPromotor: false,
          boolUsuarioEspecialista: false,
        );
        state = state.copyWith(
          sessionUserData: newSession,
          isAuthenticated: false, // credenciales inválidas
        );
      } else {
        newSession = SessionData(
          key: "",
          varName: "",
          valueToSave: "",
          userId: initialId.rows[0].value.userId,
          userName: initialId.rows[0].value.userName,
          userPass: initialId.rows[0].value.userPass,
          esUsuarioComprador: "",
          esUsuarioPromotor: "",
          esUsuarioEspecialista: "",
          boolUsuarioComprador: false,
          boolUsuarioPromotor: false,
          boolUsuarioEspecialista: false,
        );
        state = state.copyWith(
          sessionUserData: newSession,
          isAuthenticated: true, // ✅ login exitoso
        );
      }
    }
    return statusCode;
  }

  Future<int> getUserIdNamePassByNameID() async {
    final repo = ref.read(sessionRepositoryProvider);
    final (statusCode, initialId) = await repo.getUserIdNamePassByNameID(
      userId: state.sessionUserData.userId,
      esPromotor: state.esPromotor,
      authHeaders: _authHeaders,
    );

    if (initialId != null) {
      state = state.copyWith(initialIdUserPass: initialId);
      if (initialId.rows.isNotEmpty) {
        // FASE 2 (26-05-18): resetInitialUserData(0) ya crea nuevas instancias
        // inmutables para sessionUserData e initialIdUserPass — no hay que mutar.
        resetInitialUserData(0);
      }
    }
    return statusCode;
  }

  Future<int> writeUserToCouchDB(WidgetRef uiref, Usuario nvoUsuario) async {
    final repo = ref.read(sessionRepositoryProvider);
    return await repo.writeUserToCouchDB(
      nvoUsuario: nvoUsuario,
      esPromotor: state.esPromotor,
      authHeaders: _authHeaders,
    );
  }
}
