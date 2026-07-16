import 'package:flutter/material.dart';

import '../20_var_globales/var_color_themes.dart';

Widget derechosReservadosClaro() {
  return Column(
    children: [
      const SizedBox(height: 60),
      Text(
        "© 2026 Buscobien®. Todos los derechos reservados.",
        style: TextStyle(color: appTheme.surface, fontSize: 10),
      ),
      const SizedBox(height: 20),
    ],
  );
}

Widget derechosReservadosObscuro() {
  return Column(
    children: [
      const SizedBox(height: 60),
      Text(
        "© 2026 Buscobien®. Todos los derechos reservados.",
        style: TextStyle(color: appTheme.onSurface, fontSize: 10),
      ),
      const SizedBox(height: 20),
    ],
  );
}
