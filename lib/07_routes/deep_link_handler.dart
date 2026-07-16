import 'package:app_links/app_links.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'app_routes.dart';

// Inicializa el handler de deep links para todas las plataformas.
// Llamar una sola vez después del primer frame en BuscoBienApp.
void initDeepLinkHandler(GlobalKey<NavigatorState> navigatorKey) {
  if (kIsWeb) {
    _handleWebInitialUri(navigatorKey);
  } else {
    _handleMobileDeepLinks(navigatorKey);
  }
}

// En Web: parsea la URL actual al arrancar (ej: buscobien.net/recuperar?token=X&perfil=Y)
void _handleWebInitialUri(GlobalKey<NavigatorState> navigatorKey) {
  final uri = Uri.base;
  _navigateIfRecovery(uri, navigatorKey);
}

// En Mobile/Desktop: escucha enlaces entrantes vía app_links
void _handleMobileDeepLinks(GlobalKey<NavigatorState> navigatorKey) {
  final appLinks = AppLinks();

  // Enlace que abrió la app por primera vez (cold start)
  appLinks.getInitialLink().then((uri) {
    if (uri != null) _navigateIfRecovery(uri, navigatorKey);
  });

  // Enlace mientras la app ya está activa (warm start)
  appLinks.uriLinkStream.listen((uri) {
    _navigateIfRecovery(uri, navigatorKey);
  });
}

void _navigateIfRecovery(
  Uri uri,
  GlobalKey<NavigatorState> navigatorKey,
) {
  // Acepta /recuperar tanto en buscobien.net como en localhost (desarrollo web)
  if (!uri.path.contains('/recuperar')) return;

  final token = uri.queryParameters['token'];
  final perfil = uri.queryParameters['perfil'];

  if (token == null || token.isEmpty || perfil == null || perfil.isEmpty) {
    return;
  }

  navigatorKey.currentState?.pushNamed(
    AppRoutes.cambioPassword,
    arguments: {'token': token, 'perfil': perfil},
  );
}
