import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_strategy/url_strategy.dart';

import 'package:buscobien/07_routes/app_routes.dart';
import 'package:buscobien/07_routes/deep_link_handler.dart';
import 'package:buscobien/20_var_globales/var_color_themes.dart';
import 'package:buscobien/20_var_globales/var_login.dart';
import 'package:buscobien/20_var_globales/variables_globales.dart';
import 'package:buscobien/20_var_globales/var_de_estilo_widgets.dart';
import 'package:buscobien/60_global_widgets/debugprint.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setPathUrlStrategy();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  lcwc = 0;
  debugPrintLevels(1, "Fase 3 almacenamiento: inicializando storage");
  debugPrintLevels(1, "1. BuscoBienApp runApp");
  runApp(const ProviderScope(child: BuscoBienApp()));
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class BuscoBienApp extends StatefulWidget {
  const BuscoBienApp({super.key});

  @override
  State<BuscoBienApp> createState() => _BuscoBienAppState();
}

class _BuscoBienAppState extends State<BuscoBienApp> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initDeepLinkHandler(navigatorKey);
    });
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    debugPrintLevels(1, "**************************************************");
    debugPrintLevels(1, "2. BuscoBienApp build");
    debugPrintLevels(1, "**************************************************");

    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        //colorScheme: appTheme,
        brightness: Brightness.light,
        navigationBarTheme: NavigationBarThemeData(
          iconTheme: WidgetStateProperty.resolveWith<IconThemeData>((
            Set<WidgetState> states,
          ) {
            if (states.contains(WidgetState.selected)) {
              return IconThemeData(color: appTheme.onPrimary);
            } else {
              return IconThemeData(color: appTheme.primary);
            }
          }),
          labelTextStyle: WidgetStateTextStyle.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return TextStyle(
                color: appTheme.primary,
                fontWeight: FontWeight.bold,
                fontSize: fontSizeMenuBar,
              );
            } else {
              return TextStyle(
                color: appTheme.primary,
                fontWeight: FontWeight.normal,
                fontSize: fontSizeMenuBar,
              );
            }
          }),
        ),
        iconTheme: IconThemeData(
          color: appTheme.onPrimaryContainer,
          fill: 0,
          weight: 400,
          opticalSize: 24,
          size: 24,
        ),
        //  tabBarTheme: tabBarTheme,
      ),

      title: appName,
      initialRoute: AppRoutes.main, // AppRoutes.splash
      onGenerateRoute: (route) {
        debugPrintLevels(1, "3. BuscoBienApp onGenerateRoute(): $route");
        return routeGenerate(route);
      },
    );
  }
}
