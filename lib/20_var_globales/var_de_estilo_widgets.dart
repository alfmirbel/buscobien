import 'package:flutter/material.dart';

import '../20_var_globales/variables_globales.dart';
import '../05_provider_menus/variables_menus.dart';
import 'var_color_themes.dart';

// appBar Menu  ButtonsTabBar

TextStyle ButtonsTabBarLabelStyle = TextStyle(
  color: appTheme.onPrimary,
  fontSize: menuTabLabelSize,
  letterSpacing: -0.15,
  fontWeight: FontWeight.bold,
);

TextStyle ButtonsTabBarUnselectedLabelStyle = TextStyle(
  color: appTheme.primary,
  fontSize: menuTabLabelSize,
  letterSpacing: -0.15,
  fontWeight: FontWeight.normal,
);

// LANDDINGPAGES STYLES
// HERO SECTION

AppBar appBarSecondPage(String titulo) {
  return AppBar(
    toolbarHeight: socialAppBarHeight,
    centerTitle: true,
    titleSpacing: 0,
    backgroundColor: appTheme.primary,
    iconTheme: IconThemeData(size: 14, color: appTheme.onPrimary),
    title: Text(
      titulo,
      style: TextStyle(
        color: appTheme.onPrimary,
        fontWeight: FontWeight.normal,
        fontSize: fontSizeTituloPagina,
      ),
    ),
  );
}

AppBar appBarSecondPageBottons(String titulo, TabBar bottons) {
  return AppBar(
    toolbarHeight: 40.0,
    centerTitle: true,
    titleSpacing: 0,
    backgroundColor: appTheme.primary,
    iconTheme: IconThemeData(size: 14, color: appTheme.onPrimary),
    title: Text(
      titulo,
      style: TextStyle(
        color: appTheme.onPrimary,
        fontWeight: FontWeight.normal,
        fontSize: fontSizeTituloPagina,
      ),
    ),
    bottom: bottons,
  );
}

AppBar appBarSecondPageActions(String titulo, List<Widget> accions) {
  return AppBar(
    toolbarHeight: 40.0,
    centerTitle: true,
    titleSpacing: 0,
    backgroundColor: appTheme.primary,
    iconTheme: IconThemeData(size: 14, color: appTheme.onPrimary),
    title: Text(
      titulo,
      style: TextStyle(
        color: appTheme.onPrimary,
        fontWeight: FontWeight.normal,
        fontSize: fontSizeTituloPagina,
      ),
    ),
  );
}
