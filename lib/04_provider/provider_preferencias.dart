import 'dart:core';
import 'package:flutter_riverpod/legacy.dart';

final coloresProvider = StateProvider<SelectColorProvider>((ref) {
  return iniciaColor;
});

SelectColorProvider iniciaColor = SelectColorProvider(0, "Rosa");

class SelectColorProvider {
  int color = 0;
  String etiqueta = "";

  SelectColorProvider(this.color, this.etiqueta);
}
