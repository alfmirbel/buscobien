# language: es
Característica: Seguridad, Encriptación y Endpoints Tipados

  Como arquitecto de Buscobien
  Quiero que Flutter nunca tenga credenciales de base de datos
  Y que passwords/tokens usen algoritmos seguros

  Antecedentes:
    Dado que credenciales CouchDB se inyectan via --dart-define-from-file=defines.json
    Y Flutter accede vía String.fromEnvironment() en direccionip.dart
    Y Node.js API (repo separado) es única puerta a CouchDB

  Escenario: Credenciales CouchDB nunca en código Flutter
    Dado que defines.json tiene COUCHDB_USER, COUCHDB_PASSWORD, COUCHDB_URL
    Cuando flutter run --dart-define-from-file=defines.json compila
    Entonces direccionip.dart expone username/password/direccionip via String.fromEnvironment()
    Y NO hay credenciales hardcoded en repo

  Escenario: Validación password con SHA-256
    Dado que usuario ingresa password en login
    Cuando generate_hash.dart validaPassword(password, hashAlmacenado)
    Entonces computa SHA-256(password) y compara con hash
    Y NUNCA almacena password en texto plano

  Escenario: Token recuperación password (UUIDv4 → SHA-256 + 1h expiry)
    Dado que usuario solicita recuperación
    Cuando generateResetToken() ejecuta
    Entonces genera UUID v4 → SHA-256 hex string
    Y expiry = DateTime.now().toUtc().add(Duration(hours: 1)) → ISO8601
    Y guarda en buscobien_recuperacion_contrasena

  Escenario: Validación token expiración UTC
    Dado que usuario accede a /cambiopassword?token=X
    Cuando isTokenValid(tokenExpiry) evalúa
    Entonces parsea ISO8601 UTC y compara con DateTime.now().toUtc()
    Y retorna true solo si now < expiry

  Escenario: 5 tipos de espacio → 10 DBs CouchDB tipadas
    Dado que urls_endpoints_espacios.dart define maps
    Cuando tipo = "Destacados" en captura
    Entonces endpoint = "buscobien_casas_comprados_destacados"
    Cuando tipo = "destacados" en publicados
    Entonces endpoint = "buscobien_publicados_destacados"
    Y 5 tipos: Normales, Destacados, Superdestacados, Oportunidades, Remates

  Escenario: AES-256 DEPRECADO (migración a secure_storage)
    Dado que encriptar.dart tiene funciones @Deprecated
    Cuando se usa encryptWithAES/decryptWithAES
    Entonces usa Key.fromSecureRandom(32) + IV.fromSecureRandom(16)
    PERO ivString hardcoded y SharedPreferences — NO seguro producción

  Escenario: MD5/SHA1 disponibles pero NO para passwords
    Dado que generate_hash.dart expone generateMD5Hash/generateSHA1Hash
    Cuando desarrollador usa para passwords
    Entonces VIOLA política — solo SHA-256 permitido para credenciales