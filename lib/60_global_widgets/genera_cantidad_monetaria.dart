import 'dart:math';

import 'debugprint.dart';

String generaCantidad(String cantidad, int minimo, int maximo) {
  //
  debugPrintLevels(5, "Minimo: $minimo, Maximo: $maximo");
  var random = Random();
  int millones = 0;
  int miles = 0;
  int cientos = 0;
  String stmillones = "";
  String stmiles = "";
  String stcientos = "";
  String resultado = "";
  int monto = 0;
  // random.nextInt(10); // Generates an integer between 0 and 9
  switch (cantidad) {
    case "millones":
      // Generates an integer between minimo and maximo
      monto = minimo + random.nextInt(maximo - minimo + 1);
      debugPrintLevels(5, "Monto: $monto");

      millones = monto ~/ 1000000; // division entera 5 ~/ 2 evaluates to 2
      monto = monto - (millones * 1000000);
      miles = monto ~/ 1000; // division entera 5 ~/ 2 evaluates to 2
      monto = monto - (miles * 1000);
      cientos = monto;

      stmillones = "$millones";

      if (miles < 100) {
        stmiles = "0$miles";
        if (miles < 10) {
          stmiles = "00$miles";
        }
      } else {
        stmiles = "$miles";
      }

      if (cientos < 100) {
        stcientos = "0$cientos";
        if (cientos < 10) {
          stcientos = "00$cientos";
        }
      } else {
        stcientos = "$cientos";
      }
      resultado = "$millones,$miles,$cientos";
      break;
    case "miles":
      // Generates an integer between minimo and maximo
      monto = minimo + random.nextInt(maximo - minimo + 1);
      debugPrintLevels(5, "Monto: $monto");

      miles = monto ~/ 1000; // division entera 5 ~/ 2 evaluates to 2
      monto = monto - (miles * 1000);
      cientos = monto;

      if (miles > 0) {
        if (cientos < 100) {
          stcientos = "0$cientos";
          if (cientos < 10) {
            stcientos = "00$cientos";
          }
        }
        stmiles = "$miles";
        resultado = "$stmiles,$stcientos";
      } else {
        stcientos = "$cientos";
        resultado = stcientos;
      }

      break;
    case "cientos":
      // Generates an integer between minimo and maximo
      monto = minimo + random.nextInt(maximo - minimo + 1);
      debugPrintLevels(5, "Monto: $monto");

      miles = monto ~/ 1000; // division entera 5 ~/ 2 evaluates to 2
      monto = monto - (miles * 1000);

      cientos = monto;

      resultado = "$cientos";
      break;
    default:
  }
  stmillones = "$stmillones,$stmiles,$stcientos";
  return resultado;
}

String formatoCantidad(int monto) {
  //
  String cantidad = "";
  int millones = 0;
  int miles = 0;
  int cientos = 0;

  String stmillones = "";
  String stmiles = "";
  String stcientos = "";

  String resultado = "";

  if (monto > 999999) {
    cantidad = "millones";
  } else {
    if (monto > 999) {
      cantidad = "miles";
    } else {
      cantidad = "cientos";
    }
  }

  debugPrintLevels(5, "monto: $monto");
  debugPrintLevels(5, "formatoCantidad: $cantidad");

  // random.nextInt(10); // Generates an integer between 0 and 9
  switch (cantidad) {
    case "millones":
      millones = monto ~/ 1000000; // division entera 5 ~/ 2 evaluates to 2
      monto = monto - (millones * 1000000);
      miles = monto ~/ 1000; // division entera 5 ~/ 2 evaluates to 2
      monto = monto - (miles * 1000);
      cientos = monto;

      stmillones = "$millones";

      if (miles < 100) {
        stmiles = "0$miles";
        if (miles < 10) {
          stmiles = "00$miles";
        }
      } else {
        stmiles = "$miles";
      }

      if (cientos < 100) {
        stcientos = "0$cientos";
        if (cientos < 10) {
          stcientos = "00$cientos";
        }
      } else {
        stcientos = "$cientos";
      }
      resultado = "$stmillones,$stmiles,$stcientos";
      break;
    case "miles":
      miles = monto ~/ 1000; // division entera 5 ~/ 2 evaluates to 2
      monto = monto - (miles * 1000);
      cientos = monto;

      stmiles = "$miles";
      if (cientos < 100) {
        stcientos = "0$cientos";
        if (cientos < 10) {
          stcientos = "00$cientos";
        }
      } else {
        stcientos = "$cientos";
      }
      resultado = "$stmiles,$stcientos";
      break;
    case "cientos":
      cientos = monto;
      stcientos = "$cientos";
      resultado = stcientos;
      break;
    default:
  }
  debugPrintLevels(5, "resultado: $resultado");
  return resultado;
}
