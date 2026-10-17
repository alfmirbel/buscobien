import 'dart:convert';

import '../10_user_login/usuario_login/session_storage.dart';

/// Fecha de expiración (`exp`) de un JWT, o `null` si el token no se puede leer.
/// Solo decodifica el contenido; la validez la comprueba el servidor.
DateTime? expiracionDeJwt(String token) {
  try {
    final partes = token.split('.');
    if (partes.length != 3) return null;
    final contenido = utf8.decode(base64Url.decode(base64Url.normalize(partes[1])));
    final exp = (jsonDecode(contenido) as Map<String, dynamic>)['exp'];
    if (exp is! num) return null;
    return DateTime.fromMillisecondsSinceEpoch(exp.toInt() * 1000, isUtc: true);
  } catch (_) {
    return null;
  }
}

/// Tokens de la sesión con buscobien-api.
///
/// - El token de acceso (15 min) vive **solo en memoria**.
/// - El token de renovación (30 días) se guarda en el almacenamiento seguro de la plataforma
///   (`flutter_secure_storage` en móvil y escritorio; `shared_preferences` en Web).
class TokenStore {
  TokenStore(this._storage, {DateTime Function()? ahora}) : _ahora = ahora ?? DateTime.now;

  static const claveRenovacion = 'refreshToken';

  final SessionStorage _storage;
  final DateTime Function() _ahora;

  String _acceso = '';
  DateTime? _expira;
  String _renovacion = '';
  bool _cargado = false;

  /// Lee el token de renovación guardado (una sola vez por ejecución).
  Future<void> cargar() async {
    if (_cargado) return;
    _renovacion = await _storage.read(key: claveRenovacion) ?? '';
    _cargado = true;
  }

  String get accessToken => _acceso;
  String get refreshToken => _renovacion;
  bool get haySesion => _renovacion.isNotEmpty;

  /// El token de acceso existe y le quedan más de 30 s de vida.
  bool get accesoVigente =>
      _acceso.isNotEmpty &&
      _expira != null &&
      _expira!.isAfter(_ahora().toUtc().add(const Duration(seconds: 30)));

  /// Cabecera `Authorization` lista para usar (vacía si no hay token de acceso).
  Map<String, String> get authHeaders =>
      _acceso.isEmpty ? const {} : {'Authorization': 'Bearer $_acceso'};

  Future<void> guardar({required String accessToken, required String refreshToken}) async {
    _acceso = accessToken;
    _expira = expiracionDeJwt(accessToken);
    _renovacion = refreshToken;
    _cargado = true;
    await _storage.write(key: claveRenovacion, value: refreshToken);
  }

  Future<void> limpiar() async {
    _acceso = '';
    _expira = null;
    _renovacion = '';
    _cargado = true;
    await _storage.delete(key: claveRenovacion);
  }
}

/// Instancia única de la app (en pruebas se crea otro [TokenStore] con un almacén falso).
final TokenStore tokenStore = TokenStore(createSessionStorage());
