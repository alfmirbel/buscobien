import '../../40_security/api_client.dart';

/// Sesión devuelta por buscobien-api al iniciar sesión o registrarse.
class SesionApi {
  const SesionApi({
    required this.accessToken,
    required this.refreshToken,
    required this.userId,
    required this.nombre,
    required this.foto,
    required this.perfil,
  });

  final String accessToken;
  final String refreshToken;
  final String userId;
  final String nombre;
  final String foto;
  final String perfil;

  static SesionApi? desdeJson(Map<String, dynamic>? j) {
    final usuario = j?['user'];
    if (j == null || usuario is! Map<String, dynamic>) return null;
    final acceso = j['accessToken'];
    final renovacion = j['refreshToken'];
    final id = usuario['id'];
    if (acceso is! String || renovacion is! String || id is! String) return null;
    return SesionApi(
      accessToken: acceso,
      refreshToken: renovacion,
      userId: id,
      nombre: (usuario['nombre'] as String?) ?? '',
      foto: (usuario['foto'] as String?) ?? '',
      perfil: (usuario['perfil'] as String?) ?? '',
    );
  }
}

/// Resultado de una operación de autenticación, con un mensaje listo para mostrar al usuario.
class ResultadoAuth<T> {
  const ResultadoAuth.exito([this.dato])
      : ok = true,
        code = '',
        mensaje = '';
  const ResultadoAuth.error(this.code, this.mensaje)
      : ok = false,
        dato = null;

  final bool ok;
  final String code;
  final String mensaje;
  final T? dato;
}

/// Operaciones de cuenta contra buscobien-api (sin tocar CouchDB).
class AuthApi {
  AuthApi(this._api);

  final ApiClient _api;

  /// Mensaje para el usuario según el código del servicio; si el servicio mandó un texto
  /// propio (política de contraseña, nombre repetido...) se usa ese.
  static String mensajeDe(ApiResponse r) {
    switch (r.code) {
      case 'NETWORK':
        return 'No hay conexión con el servidor. Revisa tu internet e inténtalo de nuevo.';
      case 'INVALID_CREDENTIALS':
        // En el cambio de contraseña el servidor dice «la contraseña actual no es correcta»
        return r.mensaje.contains('actual') ? r.mensaje : 'Usuario o contraseña incorrectos.';
      case 'TOO_MANY_ATTEMPTS':
        return 'Demasiados intentos. Espera unos minutos e inténtalo de nuevo.';
      case 'INVALID_RESET_TOKEN':
        return 'El enlace de recuperación no es válido o ya expiró.';
      case 'INTERNAL':
        return 'El servidor tuvo un problema. Inténtalo más tarde.';
    }
    if (r.mensaje.isNotEmpty) return r.mensaje;
    return r.status >= 500 ? 'El servidor no está disponible por ahora.' : 'No se pudo completar la operación.';
  }

  ResultadoAuth<T> _error<T>(ApiResponse r) => ResultadoAuth<T>.error(r.code, mensajeDe(r));

  /// Inicia sesión. NO guarda los tokens: lo hace quien llama cuando decide que la sesión es válida.
  Future<ResultadoAuth<SesionApi>> login({
    required String usuario,
    required String password,
    required String perfil,
  }) async {
    final r = await _api.post(
      '/auth/login',
      cuerpo: {'nombreusuario': usuario, 'password': password, 'perfil': perfil},
      auth: false,
    );
    final sesion = r.ok ? SesionApi.desdeJson(r.json) : null;
    if (sesion != null) return ResultadoAuth.exito(sesion);
    return r.ok ? const ResultadoAuth.error('BAD_RESPONSE', 'Respuesta inesperada del servidor.') : _error(r);
  }

  /// Crea la cuenta. El servidor también abre una sesión, que aquí se cierra de inmediato:
  /// el usuario inicia sesión después desde la pantalla de acceso.
  Future<ResultadoAuth<void>> registrar(Map<String, dynamic> cuerpo) async {
    final r = await _api.post('/auth/register', cuerpo: cuerpo, auth: false);
    if (!r.ok) return _error(r);
    final renovacion = r.json?['refreshToken'];
    if (renovacion is String) {
      await _api.post('/auth/logout', cuerpo: {'refreshToken': renovacion}, auth: false);
    }
    return const ResultadoAuth.exito();
  }

  /// Revoca la sesión en el servidor (si hay red) y olvida los tokens locales.
  Future<void> cerrarSesion() async {
    final tokens = _api.tokens;
    await tokens.cargar();
    final renovacion = tokens.refreshToken;
    if (renovacion.isNotEmpty) {
      await _api.post('/auth/logout', cuerpo: {'refreshToken': renovacion}, auth: false);
    }
    await tokens.limpiar();
  }

  /// Pide el correo de recuperación. El servidor responde igual exista o no la cuenta.
  Future<ResultadoAuth<void>> solicitarRecuperacion({required String correo, required String perfil}) async {
    final r = await _api.post(
      '/auth/recover/request',
      cuerpo: {'correoelectronico': correo, 'perfil': perfil},
      auth: false,
    );
    return r.ok ? const ResultadoAuth.exito() : _error(r);
  }

  Future<ResultadoAuth<void>> confirmarRecuperacion({
    required String token,
    required String perfil,
    required String password,
  }) async {
    final r = await _api.post(
      '/auth/recover/confirm',
      cuerpo: {'token': token, 'perfil': perfil, 'password': password},
      auth: false,
    );
    return r.ok ? const ResultadoAuth.exito() : _error(r);
  }

  Future<ResultadoAuth<void>> cambiarPassword({required String actual, required String nueva}) async {
    final r = await _api.post('/auth/password', cuerpo: {'actual': actual, 'nueva': nueva});
    return r.ok ? const ResultadoAuth.exito() : _error(r);
  }
}

/// Instancia única de la app.
final AuthApi authApi = AuthApi(apiClient);
