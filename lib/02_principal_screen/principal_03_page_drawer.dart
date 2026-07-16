import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';
import '../01_splash_screen/versiones.dart';
import '../07_routes/app_routes.dart';
import '../20_var_globales/var_color_themes.dart';
import '../42_sistema_operativo/detecta_os.dart';
import '../60_global_widgets/debugprint.dart';
import '../60_global_widgets/dialogbox_mensaje_general.dart';

Future<void> exitApp() async {
  const AppExitType exitType = AppExitType.required;
  await ServicesBinding.instance.exitApplication(exitType);
}

class MenuDrawer extends ConsumerWidget {
  const MenuDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    debugPrintLevels(1, " **************************************************");
    debugPrintLevels(1, " ---- 1. MenuDrawer");
    debugPrintLevels(1, " **************************************************");

    return Drawer(
      width: 250,
      backgroundColor: appTheme.surface,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          _createHeader(),
          _createDrawerItem(
            icon: Symbols.exit_to_app,
            text: 'Salir',
            onTap: () => exitApp(),
          ),
          _createDrawerItem(
            icon: Symbols.home,
            text: 'Principal',
            onTap: () {
              Navigator.of(context).pop();
            },
            /* => Navigator.pushNamed(
              context,
              AppRoutes.principal,
              arguments: "",
            ),*/
          ),
          Divider(
            color: appTheme.secondary,
            height: 15,
            indent: 14,
            endIndent: 30,
          ),
          /*
          _createDrawerItem(
            icon: Symbols.perm_identity,
            text: 'Casas en venta',
            onTap: () => Navigator.of(context).pushNamed(
              '/principal',
              arguments: "",
            ),
          ),
          _createDrawerItem(
            icon: Symbols.map,
            text: 'Casas en renta',
            onTap: () => Navigator.of(context).pushNamed(
              '/buscalocalidad',
              arguments: "",
            ),
          ),
          _createDrawerItem(
            icon: Symbols.groups,
            text: 'Departamentos en venta',
            onTap: () => Navigator.of(context).pushNamed(
              '/principal',
              arguments: "",
            ),
          ),
          _createDrawerItem(
            icon: Symbols.view_list,
            text: 'Departamentos en renta',
            onTap: () => Navigator.of(context).pushNamed(
              '/principal',
              arguments: "",
            ),
          ),
          _createDrawerItem(
            icon: Symbols.view_list,
            text: 'Otros inmuebles en venta',
            onTap: () => Navigator.of(context).pushNamed(
              '/principal',
              arguments: "",
            ),
          ),
          _createDrawerItem(
            icon: Symbols.view_list,
            text: 'Otros inmuebles en renta',
            onTap: () => Navigator.of(context).pushNamed(
              '/principal',
              arguments: "",
            ),
          ),
          */
          _createDrawerItem(
            icon: Symbols.star,
            text: 'Favoritos',
            onTap: () {
              Navigator.of(context).pop();
            },
          ),
          _createDrawerItem(
            icon: Symbols.bookmark,
            text: 'Ver después',
            onTap: () {
              Navigator.of(context).pop();
            },
          ),
          Divider(
            color: appTheme.secondary,
            height: 15,
            indent: 14,
            endIndent: 30,
          ),
          _createDrawerItem(
            icon: Symbols.manage_accounts,
            text: 'Preferencias',
            onTap: () {
              Navigator.pushNamed(
                context,
                AppRoutes.preferencias,
                arguments: "",
              );
            },
          ),
          _createDrawerItem(
            icon: Symbols.settings,
            text: 'Configuración',
            onTap: () {
              setCheckPlataformaProvider(ref);
              Navigator.pushNamed(context, AppRoutes.plataforma, arguments: "");
            },
          ),
          _createDrawerAbout(
            icon: "assets/images/logobuscobientazul.pngs",
            text: 'Acerda de...',
            onTap: () async {
              await showMessageDialog(
                context,
                "Acerca de buscobien",
                "Plataforma de promoción inmobiliaria\n$versionActual",
                appTheme.primary,
                TextAlign.center,
                "Salir",
              );
            },
          ),
          _createDrawerItem(
            icon: Symbols.forum,
            text: 'Contacto',
            onTap: () async {
              await showMessageDialog(
                context,
                "Contacto",
                "Contactanos en el correo electrónico: contacto@buscobien.info.\nSíguenos en X: @buscobien.",
                appTheme.primary,
                TextAlign.left,
                "Salir",
              );
            },
          ),
        ],
      ),
    );
  }
}

Widget _createDrawerItem({
  IconData? icon,
  String text = "",
  GestureTapCallback? onTap,
}) {
  return ListTile(
    horizontalTitleGap: 10,
    title: Text(text, style: TextStyle(color: appTheme.onPrimaryContainer)),
    dense: true,
    leading: Icon(icon, color: appTheme.onPrimaryContainer),
    onTap: onTap,
  );
}

Widget _createDrawerAbout({
  String? icon,
  String text = "",
  GestureTapCallback? onTap,
}) {
  return ListTile(
    horizontalTitleGap: 10,
    title: Text(text, style: TextStyle(color: appTheme.onPrimaryContainer)),
    dense: true,
    leading: CircleAvatar(
      radius: 12,
      backgroundColor: appTheme.onPrimaryContainer,
      backgroundImage: const AssetImage(
        "assets/images/logobuscobientblanco.png",
      ),
    ),
    onTap: onTap,
  );
}

Widget _createHeader() {
  return SizedBox(
    height: 100.0,
    child: DrawerHeader(
      //margin: const EdgeInsets.only(top: 6.0, bottom: 6.0),
      //padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(color: appTheme.primary),
      child: Container(
        color: appTheme.primary,
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: appTheme.onPrimary,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(6.0),
                      bottomRight: Radius.circular(6.0),
                    ),
                  ),
                  alignment: Alignment.center,
                ),
                Container(
                  width: 44,
                  height: 32,
                  decoration: BoxDecoration(
                    color: appTheme.onPrimary,
                    borderRadius: const BorderRadius.all(Radius.circular(1.0)),
                    /*
                      topLeft: Radius.circular(6.0),
                      bottomRight: Radius.circular(6.0),
                    ),*/
                  ),
                  alignment: Alignment.center,
                ),
                Image.asset(
                  "assets/images/logobuscobientazul.png",
                  width: 40,
                  height: 40,
                ),
              ],
            ),
            const SizedBox(width: 6),
            Text(
              "buscobien",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: appTheme.onPrimary,
                fontSize: 16,
                fontFamily: "Comfortaa",
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
