import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../04_provider/provider_preferencias.dart';
import '../../20_var_globales/var_color_themes.dart';
import '../60_global_widgets/debugprint.dart';

class PaginaColores extends ConsumerStatefulWidget {
  final String backpage;

  const PaginaColores(this.backpage, {super.key});

  @override
  // ignore: no_logic_in_create_state
  ConsumerState createState() {
    debugPrintLevels(1, " **************************************************");
    debugPrintLevels(1, "  1. PaginaColores createState");
    debugPrintLevels(1, " **************************************************");
    return PaginaColoresState();
  }
}

class PaginaColoresState extends ConsumerState<PaginaColores> {
  @override
  Widget build(BuildContext context) {
    debugPrintLevels(1, " **************************************************");
    debugPrintLevels(1, " 3. PaginaColores build");
    debugPrintLevels(1, " **************************************************");
    return Scaffold(
      backgroundColor: appTheme.surface,
      appBar: AppBar(
        toolbarHeight: 40.0, // default kToolbarHeight = 56.0
        centerTitle: true,
        titleSpacing: 0,
        backgroundColor: appTheme.error,
        automaticallyImplyLeading: false,
        title: Text(
          'Esquema de Colores',
          style: TextStyle(
            color: appTheme.onError,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        elevation: 4,
      ),
      //appBar: appBarPrincipal(context, () {}, appName, ref),
      //drawer: const MenuDrawer(),
      body: Center(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
            //alignment: Alignment.center,
            padding: const EdgeInsets.all(3),
              color: appTheme.surface,
            width: 300,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Selecciona el esquema de colores',
                  style: TextStyle(
                    color: appTheme.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: Radio(
                        value: 0,
                        activeColor: appTheme.primary,
                        groupValue: ref.watch(coloresProvider).color,
                        onChanged: (value) {
                          setState(() {
                            ref.watch(coloresProvider).color = value!;
                            appTheme = lightINE;
                          });
                        },
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Text(
                        'Opción 1: Rosa',
                        style: TextStyle(
                          color: appTheme.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: Radio(
                        value: 1,
                        activeColor: appTheme.primary,
                        groupValue: ref.watch(coloresProvider).color,
                        onChanged: (value) {
                          setState(() {
                            ref.watch(coloresProvider).color = value!;
                            appTheme = lightMC;
                          });
                        },
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Text(
                        'Opción 2: Naranja',
                        style: TextStyle(
                          color: appTheme.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: Radio(
                        value: 2,
                        activeColor: appTheme.primary,
                        groupValue: ref.watch(coloresProvider).color,
                        onChanged: (value) {
                          setState(() {
                            ref.watch(coloresProvider).color = value!;
                            appTheme = lightMOR;
                          });
                        },
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Text(
                        'Opción 3: Guinda',
                        style: TextStyle(
                          color: appTheme.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: Radio(
                        value: 3,
                        activeColor: appTheme.primary,
                        groupValue: ref.watch(coloresProvider).color,
                        onChanged: (value) {
                          setState(() {
                            ref.watch(coloresProvider).color = value!;
                            appTheme = lightPAN;
                          });
                        },
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Text(
                        'Opción 4: Azul',
                        style: TextStyle(
                          color: appTheme.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: Radio(
                        value: 4,
                        activeColor: appTheme.primary,
                        groupValue: ref.watch(coloresProvider).color,
                        onChanged: (value) {
                          setState(() {
                            ref.watch(coloresProvider).color = value!;
                            appTheme = lightPRD;
                          });
                        },
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Text(
                        'Opción 5: Amarillo',
                        style: TextStyle(
                          color: appTheme.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: Radio(
                        value: 5,
                        activeColor: appTheme.primary,
                        groupValue: ref.watch(coloresProvider).color,
                        onChanged: (value) {
                          setState(() {
                            ref.watch(coloresProvider).color = value!;
                            appTheme = lightPRI;
                          });
                        },
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Text(
                        'Opción 6: Rojo',
                        style: TextStyle(
                          color: appTheme.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: Radio(
                        value: 6,
                        activeColor: appTheme.primary,
                        groupValue: ref.watch(coloresProvider).color,
                        onChanged: (value) {
                          setState(() {
                            ref.watch(coloresProvider).color = value!;
                            appTheme = lightPT;
                          });
                        },
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Text(
                        'Opción 7: Rojo Fuerte',
                        style: TextStyle(
                          color: appTheme.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: Radio(
                        value: 7,
                        activeColor: appTheme.primary,
                        groupValue: ref.watch(coloresProvider).color,
                        onChanged: (value) {
                          setState(() {
                            ref.watch(coloresProvider).color = value!;
                            appTheme = lightPVEM;
                          });
                        },
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Text(
                        'Opción 8: Verde',
                        style: TextStyle(
                          color: appTheme.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: Radio(
                        value: 8,
                        activeColor: appTheme.primary,
                        groupValue: ref.watch(coloresProvider).color,
                        onChanged: (value) {
                          setState(() {
                            ref.watch(coloresProvider).color = value!;
                            appTheme = darkINE;
                          });
                        },
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Text(
                        'Opción 9: Obscuro',
                        style: TextStyle(
                          color: appTheme.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                TextButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: appTheme.primary,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Regresar',
                    style: TextStyle(color: appTheme.onPrimary),
                    softWrap: false,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis, //
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
