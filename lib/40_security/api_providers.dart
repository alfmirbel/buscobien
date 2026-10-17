import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../10_user_login/usuario_login/auth_api.dart';
import 'api_client.dart';
import 'token_store.dart';

// Puntos de acceso a la capa de red con la API. En la app apuntan a las instancias únicas;
// las pruebas los sustituyen con `overrideWithValue` para usar un almacén y un cliente falsos.
final tokenStoreProvider = Provider<TokenStore>((ref) => tokenStore);
final apiClientProvider = Provider<ApiClient>((ref) => apiClient);
final authApiProvider = Provider<AuthApi>((ref) => authApi);
