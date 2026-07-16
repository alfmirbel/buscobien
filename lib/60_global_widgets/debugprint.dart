import 'package:flutter/material.dart';

bool level00 = true; //true;
bool level01 = true; //true; // CICLO DE VIDA DEL WIDGET
bool level02 = false;
bool level03 = false; // TU CUENTA
bool level04 = false;
bool level05 = false; // TUS ESPACIOS
bool level06 = false; // IMAGENES
bool level07 = false; // MANEJO DE FOTOS
bool level08 = false; //GESTION FOTO
bool level09 = false; //
bool level10 = true; //true; //
bool level11 = false; //
bool level12 = true; //
bool level13 = false; //
bool level14 = false; //
bool level15 = false; //
bool level16 = false; //
bool level17 = false; //
bool level18 = false; //
bool level19 = false; //
bool level20 = false; //true; //

int lcwc = 0;

// debugPrintLevels(0,  mensaje) {
void debugPrintLevels(int level, String mensaje) {
  lcwc++;
  //debugPrint("$lcwc | $level | $mensaje");
  switch (level) {
    case 0:
      if (level00) {
        debugPrint("$lcwc | $level | $mensaje");
      }
      break;
    case 1:
      if (level01) {
        debugPrint("$lcwc | $level | LYFECYCLE: $mensaje");
      }
      break;
    case 2:
      if (level02) {
        debugPrint("$lcwc | $level | $mensaje");
      }
      break;
    case 3:
      if (level03) {
        debugPrint("$lcwc | $level | $mensaje");
      }
      break;
    case 4:
      if (level04) {
        debugPrint("$lcwc | $level | $mensaje");
      }
      break;
    case 5:
      if (level05) {
        debugPrint("$lcwc | $level | $mensaje");
      }
      break;
    case 6:
      if (level06) {
        debugPrint("$lcwc | $level | $mensaje");
      }
      break;
    case 7:
      if (level07) {
        debugPrint("$lcwc | $level | $mensaje");
      }
      break;
    case 8:
      if (level08) {
        debugPrint("$lcwc | $level | $mensaje");
      }
      break;
    case 9:
      if (level09) {
        debugPrint("$lcwc | $level | $mensaje");
      }
      break;
    case 10:
      if (level10) {
        debugPrint("$lcwc | $level | $mensaje");
      }
      break;
    case 11:
      if (level11) {
        debugPrint("$lcwc | $level | $mensaje");
      }
      break;
    case 12:
      if (level12) {
        debugPrint("$lcwc | $level | $mensaje");
      }
      break;
    case 13:
      if (level13) {
        debugPrint("$lcwc | $level | $mensaje");
      }
      break;
    case 14:
      if (level14) {
        debugPrint("$lcwc | $level | $mensaje");
      }
      break;
    case 15:
      if (level15) {
        debugPrint("$lcwc | $level | $mensaje");
      }
      break;
    case 16:
      if (level16) {
        debugPrint("$lcwc | $level | $mensaje");
      }
      break;
    case 17:
      if (level17) {
        debugPrint("$lcwc | $level | $mensaje");
      }
      break;
    case 18:
      if (level18) {
        debugPrint("$lcwc | $level | $mensaje");
      }
      break;
    case 19:
      if (level19) {
        debugPrint("$lcwc | $level | $mensaje");
      }
      break;
    case 20:
      if (level20) {
        debugPrint("$lcwc | $level | $mensaje");
      }
      break;
    default:
      debugPrint("$lcwc | $level | $mensaje");
  }
}
