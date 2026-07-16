import 'package:buscobien/60_global_widgets/debugprint.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../02_principal_screen/principal_sliver_screen_menus_inicio.dart';
import '../08_pantallas/tu_cuenta/tus_espacios/tabla_tipopropiedad_vs_campos.dart';
import '../20_var_globales/var_color_themes.dart';
import 'variables_menus.dart';

// Definición del tipo de función para el callback
typedef ValueChangeCallback = void Function(String value);

// ignore: must_be_immutable
class DropdownButtonPropiedad extends ConsumerStatefulWidget {
  WidgetRef ref;
  int index;
  final String valorInicial;
  final ValueChangeCallback onChangedCallback;
  bool listaamostrar;

  DropdownButtonPropiedad(
    this.ref,
    this.index,
    this.valorInicial,
    this.onChangedCallback,
    this.listaamostrar, {
    super.key,
  });

  @override
  // ignore: no_logic_in_create_state
  ConsumerState<DropdownButtonPropiedad> createState() {
    debugPrintLevels(1, " **************************************************");
    debugPrintLevels(1, " 1. DropdownButtonPropiedad createState");
    debugPrintLevels(1, " **************************************************");
    return DropdownButtonPropiedadState();
  }
}

class DropdownButtonPropiedadState
    extends ConsumerState<DropdownButtonPropiedad> {
  // ignore: unused_field
  String? _currentValue;
  List<String> listaDeTiposDeInmueble = [];

  @override
  void initState() {
    debugPrintLevels(1, " **************************************************");
    debugPrintLevels(1, " 1. DropdownButtonPropiedad initState");
    debugPrintLevels(1, " **************************************************");
    super.initState();
    _currentValue = widget.valorInicial;

    if (widget.listaamostrar) {
      listaDeTiposDeInmueble = listaTipoInmuebles; // LISTA COMPLETA
    } else {
      listaDeTiposDeInmueble = otrosTiposDeInmueble;
    }
  }

  // Se usa didUpdateWidget para asegurar que si el padre cambia valorInicial,
  //el hijo también lo refleje.
  @override
  void didUpdateWidget(covariant DropdownButtonPropiedad oldWidget) {
    debugPrintLevels(1, " **************************************************");
    debugPrintLevels(1, " 1. DropdownButtonPropiedad didUpdateWidget");
    debugPrintLevels(1, " **************************************************");
    super.didUpdateWidget(oldWidget);
    if (widget.valorInicial != oldWidget.valorInicial) {
      _currentValue = widget.valorInicial;
    }
  }

  @override
  Widget build(BuildContext context) {
    debugPrintLevels(1, " **************************************************");
    debugPrintLevels(1, " 1. DropdownButtonPropiedad build");
    debugPrintLevels(1, " **************************************************");
    return DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        //itemHeight: menuToolbarHeight,
        dropdownColor: appTheme.onPrimary,
        value: selectedDropDownMenuPrincipalValue,
        icon: Icon(
          Symbols.arrow_drop_down,
          size: menuTabIconSize * 2,
          color: appTheme.primary,
        ),
        //style: TextStyle(backgroundColor: appTheme.onPrimary),
        selectedItemBuilder: (BuildContext context) {
          debugPrintLevels(
            2,
            "DropdownButton value: $selectedDropDownMenuPrincipalValue",
          );
          return listaDeTiposDeInmueble.map<Widget>((String item) {
            return Container(
              alignment: AlignmentGeometry.bottomCenter,
              // color: appTheme.onPrimary,
              padding: EdgeInsets.fromLTRB(15, 0, 0, 5),
              child: Text(
                item,
                style: TextStyle(
                  color: appTheme.primary, // Different color when selected
                  fontWeight: FontWeight.bold,
                  fontSize: menuTabLabelSize,
                ),
              ),
            );
          }).toList();
        },
        items: listaDeTiposDeInmueble.map<DropdownMenuItem<String>>((
          String value,
        ) {
          return DropdownMenuItem<String>(
            alignment: AlignmentGeometry.centerLeft,
            value: value,
            child: SizedBox(
              //color: appTheme.onPrimary,
              height: 20.0, // Altura personalizada para la fila
              child: Text(
                value,
                style: TextStyle(
                  fontSize: menuTabLabelSize,
                  fontWeight: FontWeight.bold,
                  color: appTheme.primary,
                ),
              ),
            ),
          );
        }).toList(),
        onChanged: (String? newValue) {
          // This is called when the user selects an item.
          debugPrintLevels(
            10,
            "*************** INVALIDA PROVIDERS MENU PRINCIPAL ************",
          );

          if (newValue != null) {
            setState(() {
              _currentValue = newValue;
              selectedDropDownMenuPrincipalValue = newValue;
              debugPrintLevels(
                2,
                "Drodown chage: $selectedDropDownMenuPrincipalValue",
              );
            });
          }
          widget.onChangedCallback(newValue!);
          //  widget.onChangedCallback(value!);
        },
        isExpanded: false,
      ),
    );
  }
}
