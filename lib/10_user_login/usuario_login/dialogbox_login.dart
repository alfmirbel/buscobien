import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../02_principal_screen/principal_00_inicio.dart';
import '../../20_var_globales/var_color_themes.dart';
import '../../60_global_widgets/dialogbox_mensaje_general.dart';
import 'login_01_login_page.dart';
import 'provider_session.dart';

dynamic dialogBoxFichaLogin(BuildContext context, WidgetRef ref) async {
  if (ref.read(warningApp) == true) {
    ref.read(warningApp.notifier).state = false;
    await showMessageDialog(
      context,
      "AVISO IMPORTANTE",
      "El presente Sitio es de prueba y demostración.\nLos datos que ingrese pueden ser borrados en cualquier momento.\nAl usarlo acepta y entiende dichas condiciones.",
      appTheme.error,
      TextAlign.left,
      "Enterado",
    );
  }

  return await showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: appTheme.primary,
        elevation: 6,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(6)),
        ),
        titleTextStyle: TextStyle(
          color: appTheme.onPrimary,
          fontSize: 12,
          fontFamily: "Comfortaa",
          fontWeight: FontWeight.bold,
        ),
        contentTextStyle: TextStyle(
          color: appTheme.onPrimary,
          fontSize: 10,
          fontWeight: FontWeight.normal,
        ),
        titlePadding: const EdgeInsets.fromLTRB(6, 12, 6, 6),
        contentPadding: const EdgeInsets.all(3),
        actionsPadding: const EdgeInsets.all(6),
        title: const Text("Acceso", textAlign: TextAlign.center),
        content: SizedBox(
          height: 500,
          width: 300,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: SizedBox(
              width: double.maxFinite, // Ocupar ancho disponible
              height: 500,
              // AQUÍ LLAMAS AL WIDGET QUE ACABAMOS DE CREAR
              child: LoginPage(),
            ),
          ),
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
              'Salir',
              style: TextStyle(
                color: appTheme.primary,
                //backgroundColor: appTheme.onTertiary,
                fontSize: 12,
                fontFamily: "Comfortaa",
                fontWeight: FontWeight.bold,
              ),
            ),
            // checar regreso
            onPressed: () {
              ref.read(sessionProvider.notifier).resetInitialUserData(0);
              // _showLogoutDialog(context, ref);
              Navigator.of(context).pop(false);
            },
          ),
        ],
      );
    },
  );
}
