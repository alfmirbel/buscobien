import 'package:flutter/foundation.dart';

import '../../08_pantallas/ubicacion/data_sepomex_localidades.dart';
import '../usuario_login/data_session.dart';
import 'data_get_id_user_pass.dart';
import 'data_get_user.dart';
import 'data_user_promotor.dart';
import 'data_usuarios.dart';

/// Modelo inmutable que representa el estado de autenticación y sesión
@immutable
class AuthState {
  // Datos Anidados Anteriores
  final SessionData sessionUserData;
  final GetIdUserPass initialIdUserPass;
  final GetUserData userData;

  // Flags y Strings Anteriores
  final bool esUsuario;
  final bool esPromotor;
  final bool esPropietario;
  final bool esAnfrition;
  final bool esVendedor;
  final bool esEspecialista;
  final bool esProveedor;
  final bool esAsociacion;
  final bool esInmobiliaria;
  final String nombrePerfil;

  // Campos Antiguos de AuthState
  final bool isAuthenticated;
  /// true cuando getUserDataByNameInSessionData() completó con éxito al
  /// menos una vez. Permite que PaginaPerfilWidget evite peticiones HTTP
  /// redundantes si los datos ya están en caché (Fase 5).
  final bool isUserDataLoaded;
  final String? userId;
  final String? userName;
  final String? userPass;
  final String? jwtToken;
  final String perfilActual;
  final bool esUsuarioComprador;
  final bool esUsuarioPromotor;
  final bool esUsuarioEspecialista;

  const AuthState({
    // Obligatorios de SessionAndUserData
    required this.sessionUserData,
    required this.initialIdUserPass,
    required this.userData,
    this.esUsuario = false,
    this.esPromotor = false,
    this.esPropietario = false,
    this.esAnfrition = false,
    this.esVendedor = false,
    this.esEspecialista = false,
    this.esProveedor = false,
    this.esAsociacion = false,
    this.esInmobiliaria = false,
    this.nombrePerfil = "",

    // Opcionales de AuthState original
    this.isAuthenticated = false,
    this.isUserDataLoaded = false,
    this.userId,
    this.userName,
    this.userPass,
    this.jwtToken,
    this.perfilActual = "",
    this.esUsuarioComprador = false,
    this.esUsuarioPromotor = false,
    this.esUsuarioEspecialista = false,
  });

  /// Factory para estado inicial
  factory AuthState.initial() => AuthState(
    sessionUserData: SessionData(
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
    ),
    initialIdUserPass: GetIdUserPass(
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
    ),
    userData: GetUserData(
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
    ),
  );

  /// Método copyWith para mantener inmutabilidad
  AuthState copyWith({
    SessionData? sessionUserData,
    GetIdUserPass? initialIdUserPass,
    GetUserData? userData,
    bool? esUsuario,
    bool? esPromotor,
    bool? esPropietario,
    bool? esAnfrition,
    bool? esVendedor,
    bool? esEspecialista,
    bool? esProveedor,
    bool? esAsociacion,
    bool? esInmobiliaria,
    String? nombrePerfil,
    bool? isAuthenticated,
    bool? isUserDataLoaded,
    String? userId,
    String? userName,
    String? userPass,
    String? jwtToken,
    String? perfilActual,
    bool? esUsuarioComprador,
    bool? esUsuarioPromotor,
    bool? esUsuarioEspecialista,
  }) {
    return AuthState(
      sessionUserData: sessionUserData ?? this.sessionUserData,
      initialIdUserPass: initialIdUserPass ?? this.initialIdUserPass,
      userData: userData ?? this.userData,
      esUsuario: esUsuario ?? this.esUsuario,
      esPromotor: esPromotor ?? this.esPromotor,
      esPropietario: esPropietario ?? this.esPropietario,
      esAnfrition: esAnfrition ?? this.esAnfrition,
      esVendedor: esVendedor ?? this.esVendedor,
      esEspecialista: esEspecialista ?? this.esEspecialista,
      esProveedor: esProveedor ?? this.esProveedor,
      esAsociacion: esAsociacion ?? this.esAsociacion,
      esInmobiliaria: esInmobiliaria ?? this.esInmobiliaria,
      nombrePerfil: nombrePerfil ?? this.nombrePerfil,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      isUserDataLoaded: isUserDataLoaded ?? this.isUserDataLoaded,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      userPass: userPass ?? this.userPass,
      jwtToken: jwtToken ?? this.jwtToken,
      perfilActual: perfilActual ?? this.perfilActual,
      esUsuarioComprador: esUsuarioComprador ?? this.esUsuarioComprador,
      esUsuarioPromotor: esUsuarioPromotor ?? this.esUsuarioPromotor,
      esUsuarioEspecialista:
          esUsuarioEspecialista ?? this.esUsuarioEspecialista,
    );
  }
}
