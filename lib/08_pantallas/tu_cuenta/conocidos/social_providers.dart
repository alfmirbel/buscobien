import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'usuarios_api.dart';

// =============================================================================
// Usuarios que se pueden invitar (vía buscobien-api: solo nombre, foto y perfil)
// =============================================================================

final usersListProvider = FutureProvider<List<Map<String, dynamic>>>(
  (ref) => buscarUsuariosPublicos(perfil: 'Usuario'),
);

final usersPromotoresListProvider = FutureProvider<List<Map<String, dynamic>>>(
  (ref) => buscarUsuariosPublicos(perfil: 'Promotor'),
);
