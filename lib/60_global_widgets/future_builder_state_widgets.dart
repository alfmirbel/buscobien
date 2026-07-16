import 'package:flutter/material.dart';

import 'debugprint.dart';
import '../20_var_globales/var_color_themes.dart';

Container stateNone(double w, double l) {
  debugPrintLevels(9, "FutureBuilder: none");
  return Container(
    width: w,
    height: l,
    padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
    color: appTheme.primaryContainer,
    child: Center(
      child: Text(
        "Sin resultados",
        maxLines: 5,
        overflow: TextOverflow.visible,
        style: TextStyle(fontSize: 10, color: appTheme.onPrimaryContainer),
      ),
    ),
  );
}

Center stateWaiting(double w, double l) {
  debugPrintLevels(9, "FutureBuilder: waiting");
  return Center(
    child: Container(
      width: w - 3,
      height: l - 3,
      padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
        color: appTheme.surface,
      child: Center(
        child: CircularProgressIndicator(color: appTheme.onPrimaryContainer),
      ),
    ),
  );
}

Container stateActive(double w, double l) {
  debugPrintLevels(9, "FutureBuilder: active");
  return Container(
    width: w,
    height: l,
    padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
      color: appTheme.surface,
    child: Center(
      child: Text(
        "Esperando datos",
        maxLines: 5,
        overflow: TextOverflow.visible,
        style: TextStyle(fontSize: 10, color: appTheme.onPrimaryContainer),
      ),
    ),
  );
}

Container stateError(double w, double l, dynamic error) {
  debugPrintLevels(9, "FutureBuilder: done Error");
  return Container(
    width: w,
    height: l,
    padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
      color: appTheme.surface,
    child: Center(
      child: Text(
        "Error: $error",
        maxLines: 5,
        overflow: TextOverflow.visible,
        style: TextStyle(fontSize: 10, color: appTheme.onPrimaryContainer),
      ),
    ),
  );
}

Container stateErrorFormat(double w, double l, dynamic error) {
  debugPrintLevels(9, "FutureBuilder: done Error");
  return Container(
    width: w,
    height: l,
    padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
      color: appTheme.surface,
    child: Center(
      child: Text(
        "Error: $error",
        maxLines: 5,
        overflow: TextOverflow.visible,
        style: TextStyle(fontSize: 10, color: appTheme.onPrimaryContainer),
      ),
    ),
  );
}

//**********************************************

Widget stateNoneFS() {
  debugPrintLevels(9, "FutureBuilder: none");
  return Center(
    child: Text(
      "Sin resultados",
      overflow: TextOverflow.visible,
      style: TextStyle(fontSize: 14, color: appTheme.onPrimaryContainer),
    ),
  );
}

Widget stateWaitingFS() {
  debugPrintLevels(9, "FutureBuilder: waiting");
  return Center(
    child: CircularProgressIndicator(color: appTheme.onPrimaryContainer),
  );
}

Widget stateActiveFS() {
  debugPrintLevels(9, "FutureBuilder: active");
  return Center(
    child: Text(
      "Esperando datos",
      maxLines: 5,
      overflow: TextOverflow.visible,
      style: TextStyle(fontSize: 10, color: appTheme.onPrimaryContainer),
    ),
  );
}

Widget stateErrorFS(dynamic error) {
  debugPrintLevels(9, "FutureBuilder: done Error");
  return Center(
    child: Text(
      "Error: $error",
      maxLines: 5,
      overflow: TextOverflow.visible,
      style: TextStyle(fontSize: 10, color: appTheme.onPrimaryContainer),
    ),
  );
}

Widget stateErrorFormatFS(dynamic error) {
  debugPrintLevels(9, "FutureBuilder: done Error");
  return Center(
    child: Text(
      "Error: $error",
      maxLines: 5,
      overflow: TextOverflow.visible,
      style: TextStyle(fontSize: 10, color: appTheme.onPrimaryContainer),
    ),
  );
}
