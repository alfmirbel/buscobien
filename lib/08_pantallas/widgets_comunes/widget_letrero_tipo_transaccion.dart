import 'package:buscobien/08_pantallas/inicio/data_espacios_casas_get.dart';
import 'package:flutter/material.dart';

import '../../20_var_globales/var_color_themes.dart';

Widget letrerprecio(ValueEspaciosCasaGet listaSeleccionadas) {
  Widget letreroprecio = Text("");
  switch (listaSeleccionadas.espacioscasa.tipodetransaccion) {
    case "Venta":
      letreroprecio = Text(
        "Venta: ${listaSeleccionadas.espacioscasa.precioventa} ${listaSeleccionadas.espacioscasa.moneda}",
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: appTheme.onPrimaryContainer,
        ),
      );
      break;
    case "Renta":
      letreroprecio = Text(
        "Renta: ${listaSeleccionadas.espacioscasa.preciorenta} ${listaSeleccionadas.espacioscasa.moneda}",
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: appTheme.onPrimaryContainer,
        ),
      );
      break;
    case "Venta/Renta":
      letreroprecio = Text(
        "Venta/Renta: ${listaSeleccionadas.espacioscasa.preciorenta}/${listaSeleccionadas.espacioscasa.precioventa} ${listaSeleccionadas.espacioscasa.moneda}",
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: appTheme.onPrimaryContainer,
        ),
      );
      break;
    case "Traspaso":
      letreroprecio = Text(
        "Traspaso: ${listaSeleccionadas.espacioscasa.precioventa} ${listaSeleccionadas.espacioscasa.moneda}",
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: appTheme.onPrimaryContainer,
        ),
      );
  }
  return letreroprecio;
}
