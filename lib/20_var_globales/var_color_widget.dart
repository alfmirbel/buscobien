//import 'package:flutter/material.dart';
//import 'var_color_themes.dart';

var screenWidth = 0.0;
var screenHeight = 0.0;

// Breakpoints responsivos M3
//
// xs: <600
// sm: 600-903
// md: 904-1239
// lg: 1240-1439
// xl: >=1440
//
// Regla general:
// - Móvil/tablet: usar `NavigationRail` lateral + layouts apilados.
// - Desktop/WASM: limitar `maxWidth` en columnas principales y grids de tarjetas
//   para evitar `Unbounded width/height`.
const double xSmallScreenMax = 599.0;
const double smallScreenMin = 600.0;
const double smallScreenMax = 903.0;
const double mediumScreenMin = 904.0;
const double mediumScreenMax = 1239.0;
const double largeScreenMin = 1240.0;
const double largeScreenMax = 1439.0;
const double desktopContentMaxWidth = 1280.0;

bool isMobileWidth(double width) => width < smallScreenMin;
bool isTabletWidth(double width) =>
    width >= smallScreenMin && width < mediumScreenMin;
bool isDesktopWidth(double width) => width >= mediumScreenMin;

isMobile(context) => screenWidth < smallScreenMin;
isTablet(context) => screenWidth > smallScreenMin;
