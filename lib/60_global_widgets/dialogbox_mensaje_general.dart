import 'package:flutter/material.dart';

import '../../20_var_globales/var_color_themes.dart';

//-------------------------------------------------------------

// ignore: strict_top_level_inference
showMessageDialog(
  BuildContext context,
  String title,
  String message,
  Color? color,
  TextAlign alineacion,
  String boton,
) => showDialog(
  context: context,
  builder: (context) => AlertDialog(
    backgroundColor: color,
    elevation: 6,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(3)),
    ),
    titleTextStyle: TextStyle(
      color: appTheme.onPrimary,
      //backgroundColor: lightINE.onTertiary,
      fontSize: 12,
      fontFamily: "Comfortaa",
      fontWeight: FontWeight.bold,
    ),
    contentTextStyle: TextStyle(
      color: appTheme.onPrimaryContainer,
      backgroundColor: appTheme.onSecondary,
      fontSize: 12,
      //fontFamily: "Comfortaa",
      fontWeight: FontWeight.normal,
    ),
    titlePadding: const EdgeInsets.fromLTRB(6, 12, 6, 6),
    contentPadding: const EdgeInsets.all(3),
    actionsPadding: const EdgeInsets.all(6),
    title: Text(
      title,
      textAlign: TextAlign.center,
      style: TextStyle(color: appTheme.onPrimary),
    ),
    content: Container(
      width: 250,
      padding: const EdgeInsets.all(6),
      color: appTheme.onSecondary,
      child: Text(message, textAlign: alineacion),
    ),
    actions: [
      ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.all(3),
          backgroundColor: appTheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        child: Text(
          boton,
          style: TextStyle(
            color: appTheme.onPrimaryContainer,
            //backgroundColor: appTheme.onTertiary,
            fontSize: 10,
            fontFamily: "Comfortaa",
            fontWeight: FontWeight.bold,
          ),
        ),
        onPressed: () => Navigator.of(context).pop(),
      ),
    ],
  ),
);
//-------------------------------------------------------------
