/// URL base de buscobien-api (autenticación, compras, usuarios). Se puede cambiar con
/// `--dart-define=API_BASE_URL=...` (por ejemplo, para otro ambiente).
const String apiBaseUrl = String.fromEnvironment(
  'API_BASE_URL',
  defaultValue: 'https://api.buscobien.net',
);

/// CouchDB a través de nginx y con el token de la sesión (ver `couch_http.dart`).
const String dbBaseUrl = '$apiBaseUrl/db';
