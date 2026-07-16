import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import '../20_var_globales/var_color_themes.dart';
import 'debugprint.dart';

class MyButton extends StatelessWidget {
  final String etiqueta;
  final Function()? onTap;

  const MyButton({super.key, required this.etiqueta, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap,
      child: Material(
        elevation: 6.0,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          height: 40,
          width: 200,
          decoration: BoxDecoration(
            color: appTheme.primary,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              etiqueta,
              style: TextStyle(
                color: appTheme.onSecondary,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class MyTextField extends StatelessWidget {
  // ignore: strict_top_level_inference, prefer_typing_uninitialized_variables
  final controller;
  final String hintText;
  final bool obscureText;
  final IconData icono;

  const MyTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
    required this.icono,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          hintText,
          style: TextStyle(
            color: appTheme.onPrimaryContainer,
            fontSize: 12,
            fontWeight: FontWeight.normal,
          ),
        ),
        //const SizedBox(height: 10),
        SizedBox(
          height: 40,
          width: 200,
          child: TextField(
            controller: controller,
            obscureText: obscureText,
            textAlignVertical: TextAlignVertical.top,
            textAlign: TextAlign.left,
            style: TextStyle(
              color: appTheme.secondary,
              fontSize: 14,
              textBaseline: TextBaseline.alphabetic,
            ),
            decoration: InputDecoration(
              prefixIcon: Icon(
                icono,
                size: 16,
                color: appTheme.onPrimaryContainer,
              ),
              border: OutlineInputBorder(
                borderSide: BorderSide(color: appTheme.secondary),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: appTheme.tertiary),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: appTheme.tertiary),
              ),
              fillColor: appTheme.onSecondary,
              filled: true,
            ),
          ),
        ),
      ],
    );
  }
}

class SquareTile extends StatelessWidget {
  final String imagePath;
  const SquareTile({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(0),
      decoration: BoxDecoration(
        border: Border.all(color: appTheme.onPrimary),
        borderRadius: BorderRadius.circular(8),
        color: appTheme.onPrimary,
      ),
      child: Image.asset(imagePath, height: 100),
    );
  }
}

class MyTextFieldPassword extends StatefulWidget {
  const MyTextFieldPassword({
    super.key,
    required this.controller,
    required this.hintText,
    required this.icono,
  });

  final TextEditingController controller;
  final String hintText;
  final IconData icono;

  @override
  // ignore: no_logic_in_create_state
  State createState() {
    debugPrintLevels(1, " **************************************************");
    debugPrintLevels(1, " 1. MyTextFieldPassword createState");
    debugPrintLevels(1, " **************************************************");
    return MyTextFieldPasswordState();
  }
}

bool isHidden = true;
bool isHiddenCampoUser = false;
bool isHiddenValidaClave = true;
bool isHiddenClaveUser = true;

class MyTextFieldPasswordState extends State<MyTextFieldPassword> {
  @override
  void initState() {
    super.initState();
    isHidden = true;
  }

  //-----------------------------------------------------------------------------
  @override
  void didChangeDependencies() {
    debugPrintLevels(1, " MyTextFieldPassword didChangeDependencies");
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(covariant MyTextFieldPassword oldWidget) {
    debugPrintLevels(1, " MyTextFieldPassword didUpdateWidget");
    super.didUpdateWidget(oldWidget);
  }

  @override
  void deactivate() {
    debugPrintLevels(1, " MyTextFieldPassword deactivate");
    super.deactivate();
  }

  @override
  void dispose() {
    debugPrintLevels(1, " MyTextFieldPassword dispose");
    //  widget.controller.dispose();
    super.dispose();
  }

  //-----------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.hintText,
          style: TextStyle(
            color: appTheme.onPrimaryContainer,
            fontSize: 12,
            textBaseline: TextBaseline.alphabetic,
          ),
        ),
        SizedBox(
          height: 40,
          width: 200,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0.0),
            child: TextField(
              controller: widget.controller,
              obscureText: isHidden,
              textAlignVertical: TextAlignVertical.top,
              textAlign: TextAlign.left,
              style: TextStyle(
                color: appTheme.onPrimaryContainer,
                fontSize: 14,
                textBaseline: TextBaseline.alphabetic,
              ),
              decoration: InputDecoration(
                prefixIcon: Icon(
                  widget.icono,
                  size: 18,
                  color: appTheme.onPrimaryContainer,
                ),
                suffixIcon: IconButton(
                  icon: isHidden
                      ? Icon(
                          Symbols.visibility_off,
                          size: 18,
                          color: appTheme.onPrimaryContainer,
                        )
                      : Icon(
                          Symbols.visibility,
                          size: 18,
                          color: appTheme.onPrimaryContainer,
                        ),
                  onPressed: () {
                    setState(() {
                      isHidden = !isHidden;
                    });
                  },
                  iconSize: 18,
                  color: appTheme.secondary,
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: appTheme.secondary),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: appTheme.tertiary),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: appTheme.tertiary),
                ),
                fillColor: appTheme.onSecondary,
                filled: true,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
