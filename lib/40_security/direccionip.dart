const String username    = String.fromEnvironment('COUCHDB_USER');
const String password    = String.fromEnvironment('COUCHDB_PASSWORD');
const String direccionip = String.fromEnvironment('COUCHDB_URL');

/// URL base de buscobien-api (autenticación, compras, usuarios). Se puede cambiar con
/// `--dart-define=API_BASE_URL=...` (por ejemplo, para otro ambiente).
const String apiBaseUrl = String.fromEnvironment(
  'API_BASE_URL',
  defaultValue: 'https://api.buscobien.net',
);
