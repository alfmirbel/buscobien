import '../../60_global_widgets/campo_texto.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../20_var_globales/couchdb_errors.dart';
import '../../20_var_globales/var_color_themes.dart';
import '../../20_var_globales/var_color_widget.dart';
import '../../20_var_globales/variables_globales.dart';
import '../../40_security/generate_hash.dart';
import '../../60_global_widgets/debugprint.dart';
import '../../60_global_widgets/dialogbox_mensaje_general.dart';
import '../../60_global_widgets/bottom_fijo.dart';
import 'provider_session.dart';
import 'textos_tc_ap.dart';

String hashPasswd = "";
bool aceptoTerminosCondiciones = false;
bool aceptoAvisoPrivacidad = false;
bool camposcompletos = false;

class RegisterScreenUsers extends ConsumerStatefulWidget {
  const RegisterScreenUsers({super.key});

  @override
  // ignore: no_logic_in_create_state
  ConsumerState createState() {
    debugPrintLevels(1, " **************************************************");
    debugPrintLevels(1, " 1. RegisterScreenUsers createState");
    debugPrintLevels(1, " **************************************************");
    return RegisterScreenUsersState();
  }
}

class RegisterScreenUsersState extends ConsumerState<RegisterScreenUsers> {
  String _validaclavedeacceso = "";
  String codigopostal = "";
  String rfc = "";

  final GlobalKey<FormState> _formKeyRegistroUsers = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    debugPrintLevels(1, " **************************************************");
    debugPrintLevels(1, " 1. RegisterScreenUsers build");
    debugPrintLevels(1, " **************************************************");

    screenWidth = MediaQuery.of(context).size.width * 0.8;
    screenHeight = MediaQuery.of(context).size.height;

    setState(() {
      screenWidth = MediaQuery.of(context).size.width * 0.8;
      screenHeight = MediaQuery.of(context).size.height;
    });

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 40.0, // default kToolbarHeight = 56.0
        centerTitle: true,
        titleSpacing: 0,
        backgroundColor: appTheme.primary,
        iconTheme: IconThemeData(size: 14, color: appTheme.onPrimary),
        title: Text(
          "Registro de ${ref.read(sessionProvider).nombrePerfil}",
          // (ref.read(sessionProvider.notifier).getEsPromotorIdUserPass())
          //   ? "Registro de promotores"
          // : "Registro de usuarios",
          style: TextStyle(color: appTheme.onPrimary, fontSize: 14),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.center,
          margin: const EdgeInsets.all(24),
          child: Form(
            key: _formKeyRegistroUsers,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                renglonDeCaptura(
                  "nombreusuario",
                  "Nombre de usuario",
                  Alignment.topLeft,
                  300,
                ),
                renglonDeCaptura(
                  "claveacceso",
                  "Clave de acceso",
                  Alignment.topLeft,
                  300,
                ),
                renglonValidaClave(
                  "Valida clave de acceso",
                  Alignment.topLeft,
                  300,
                ),
                renglonDeCaptura(
                  "correoelectronico",
                  "Correo electronico",
                  Alignment.topLeft,
                  300,
                ),
                renglonDeCaptura(
                  "numerocelular",
                  "Número de celular",
                  Alignment.topLeft,
                  300,
                ),
                renglonDeCaptura("nombres", "Nombres", Alignment.topLeft, 300),
                renglonDeCaptura(
                  "apellidopaterno",
                  "Apellido paterno",
                  Alignment.topLeft,
                  300,
                ),
                renglonDeCaptura(
                  "apellidomaterno",
                  "Apellido materno",
                  Alignment.topLeft,
                  300,
                ),

                (ref.read(sessionProvider).esPromotor)
                    ? renglonDeCaptura("rfc", "RFC", Alignment.topLeft, 300)
                    : const SizedBox(height: 0),
                const SizedBox(height: 20),
                SizedBox(
                  width: 500,
                  child: aceptarTyCmasAdeP(),
                  /*
                    CheckboxTerminoCondiciones(ref),
                    const SizedBox(width: 3),
                    Text(
                      '"He leído y acepto los Términos y Condiciones"',
                      style: TextStyle(color: appTheme.secondary, fontSize: 12),
                      softWrap: false,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis, //
                    ),
                    */
                ),
                SizedBox(height: 5),
                SizedBox(height: 15),

                TextButton(
                  onPressed:
                      (aceptoTerminosCondiciones && aceptoAvisoPrivacidad)
                      ? () async {
                          _formKeyRegistroUsers.currentState!.save();
                          if (!_formKeyRegistroUsers.currentState!.validate()) {
                            return;
                          } else {
                            //----------------------
                            ref
                                .read(sessionProvider.notifier)
                                .writeUserToCouchDB(
                                  ref,
                                  ref
                                      .read(sessionProvider)
                                      .userData
                                      .rows[0]
                                      .value
                                      .usuario,
                                )
                                .then((onValue) async {
                                  await showMessageDialog(
                                    // ignore: use_build_context_synchronously
                                    context,
                                    "Registra Usuario",
                                    codigoCouchDB[onValue]!.label,
                                    appTheme.primary,
                                    TextAlign.center,
                                    "Salir",
                                  );
                                  _validaclavedeacceso = "";
                                  rfc = "";
                                });
                          }
                        }
                      : null,
                  child: Material(
                    elevation: 6.0,
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      height: 40,
                      width: 300,
                      decoration: BoxDecoration(
                        color:
                            (aceptoTerminosCondiciones && aceptoAvisoPrivacidad)
                            ? appTheme.primary
                            : appTheme.secondary,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          "Crear cuenta",
                          style: TextStyle(
                            color: appTheme.onPrimary,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  //----------------------------------------------------------------------------
  // --- LÓGICA 1: ABRIR EL DIÁLOGO DE LECTURA ---
  void _mostrarDialogoLectura(String titulo, List<String> message) {
    showDialog(
      context: context,
      builder: (context) {
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
          title: Text(titulo, textAlign: TextAlign.center),
          content: SizedBox(
            height: 500,
            width: 500, // Ocupar ancho disponible
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: SizedBox(
                width: double.maxFinite, // Ocupar ancho disponible
                height: 400, // Altura fija para hacer scroll
                // AQUÍ LLAMAS AL WIDGET QUE ACABAMOS DE CREAR
                child: VisorTerminosWidget(message),
              ),
            ),
          ),
          /*
        Scrollbar(
          thumbVisibility: true,
          child: SingleChildScrollView(
            child: const Text(
              "Aquí va todo el texto legal largo...\n\n"
              "1. Aceptación: Al usar BuscoBien...\n"
              "2. Privacidad: Sus datos son...\n"
              "3. Responsabilidad: ...\n\n"
              "(Este texto puede ser tan largo como necesites)",
              textAlign: TextAlign.justify,
            ),
          ),
        ),
        */
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
              onPressed: () => Navigator.pop(context),
            ),
          ],
        );
      },
    );
  }

  // --- LÓGICA 2: DESCARGAR PDF ---
  Future<void> abrirPdfDesdeAssets(
    String assetPath,
    String nombreArchivo,
  ) async {
    try {
      // ---------------------------------------------------------
      // OPCIÓN A: ESTRATEGIA PARA WEB
      // ---------------------------------------------------------
      if (kIsWeb) {
        // En Web, los assets se sirven como archivos estáticos.
        // Generalmente Flutter los coloca en una carpeta 'assets/' relativa.
        // Construimos la URL completa.

        // Nota: A veces Flutter Web duplica el prefijo 'assets',
        // probamos primero con la ruta directa.
        final path = '$assetPath';

        // Abrimos el PDF en una nueva pestaña del navegador
        final Uri uri = Uri.parse(path);
        await launchUrl(uri);
        return; // ¡IMPORTANTE! Salimos de la función aquí para no ejecutar código de Móvil
      }

      // ---------------------------------------------------------
      // OPCIÓN B: ESTRATEGIA PARA MÓVIL (Android / iOS)
      // ---------------------------------------------------------
      // 1. Cargar el asset como bytes (datos crudos)
      final byteData = await rootBundle.load(assetPath);

      // 2. Obtener el directorio temporal del dispositivo
      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/$nombreArchivo');

      // 3. Escribir los bytes en el archivo físico
      // (flush: true asegura que se escriba todo antes de continuar)
      await file.writeAsBytes(byteData.buffer.asUint8List(), flush: true);

      // 4. Abrir el archivo que acabamos de crear
      final result = await OpenFilex.open(file.path);

      if (result.type != ResultType.done) {
        print("Error abriendo el archivo: ${result.message}");
      }
    } catch (e) {
      print("Error general: $e");
    }
  }

  void _descargarPDF(String assetPath, String nombreArchivo) async {
    // AQUÍ LLAMAS A TU SERVICIO DE PDF QUE HICIMOS ANTES
    // 1. PRIMERO mostramos el mensaje (Feedback inmediato al usuario)

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Symbols.download_done, color: appTheme.onPrimary),
            SizedBox(width: 10),
            Text("Recupera documento..."),
          ],
        ),
        backgroundColor: appTheme.primary, // O usa appTheme.primary
        duration: const Duration(seconds: 2),
      ),
    );

    await abrirPdfDesdeAssets(assetPath, nombreArchivo);
    // Simulación visual
  }

  Widget aceptarTyCmasAdeP() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: appTheme.surfaceContainerLow, // Fondo suave para destacar la sección
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: appTheme.outlineVariant),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start, // Alinear arriba
            children: [
              // 2. CHECKBOX A LA DERECHA
              Transform.scale(
                scale: 1.2, // Hacemos el checkbox un poco más grande
                child: Checkbox(
                  value: aceptoTerminosCondiciones,
                  activeColor: appTheme.primary, // Tu color corporativo (Azul)
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  onChanged: (bool? value) {
                    setState(() {
                      aceptoTerminosCondiciones = value ?? false;
                    });
                    // Avisamos al padre (Formulario de registro)
                    //  widget.onChanged(aceptoTerminosCondiciones);
                  },
                ),
              ),
              // 1. COLUMNA IZQUIERDA (Texto + Botones)
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // El Texto Principal
                    Text(
                      "He leído y acepto los términos y condiciones.",
                      style: TextStyle(
                        fontSize: 12,
                        color: appTheme.onPrimaryContainer,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Fila de Botones (Ver y Descargar)
                    Wrap(
                      children: [
                        // Botón Ver (Ojo)
                        Container(
                          width: 110,
                          child: InkWell(
                            onTap: () {
                              _mostrarDialogoLectura(
                                "Términos y Condiciones",
                                textoTerminosCondiciones,
                              );
                            },
                            child: Row(
                              children: [
                                Icon(
                                  Symbols.visibility,
                                  size: 16,
                                  color: appTheme.primary,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  "Leer aquí",
                                  style: TextStyle(
                                    color: appTheme.primary,
                                    decoration: TextDecoration.underline,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 20), // Separador
                        // Botón Descargar (PDF)
                        Container(
                          width: 110,
                          child: InkWell(
                            onTap: () {
                              _descargarPDF(
                                'assets/terminos_condiciones.pdf', // Ruta en tu proyecto
                                'buscobien_terminos_condiciones.pdf', // Nombre temporal para el sistema
                              );
                            },
                            child: Row(
                              children: [
                                Icon(
                                  Symbols.picture_as_pdf,
                                  size: 16,
                                  color: appTheme.error,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  "Descargar PDF",
                                  style: TextStyle(
                                    color: appTheme.error,
                                    decoration: TextDecoration.underline,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
            ],
          ),
          SizedBox(height: 6),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start, // Alinear arriba
            children: [
              // 2. CHECKBOX A LA DERECHA
              Transform.scale(
                scale: 1.2, // Hacemos el checkbox un poco más grande
                child: Checkbox(
                  value: aceptoAvisoPrivacidad,
                  activeColor: appTheme.primary, // Tu color corporativo (Azul)
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  onChanged: (bool? value) {
                    setState(() {
                      aceptoAvisoPrivacidad = value ?? false;
                    });
                  },
                ),
              ),
              // 1. COLUMNA IZQUIERDA (Texto + Botones)
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // El Texto Principal
                    Text(
                      "He leído y acepto el aviso de privacidad.",
                      style: TextStyle(
                        fontSize: 12,
                        color: appTheme.onPrimaryContainer,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Fila de Botones (Ver y Descargar)
                    Wrap(
                      children: [
                        // Botón Ver (Ojo)
                        Container(
                          width: 110,
                          child: InkWell(
                            onTap: () {
                              _mostrarDialogoLectura(
                                "Aviso de privacidad",
                                textoaAcuerdoPrivacidad,
                              );
                            },
                            child: Row(
                              children: [
                                Icon(
                                  Symbols.visibility,
                                  size: 16,
                                  color: appTheme.primary,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  "Leer aquí",
                                  style: TextStyle(
                                    color: appTheme.primary,
                                    decoration: TextDecoration.underline,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 20), // Separador
                        // Botón Descargar (PDF)
                        Container(
                          width: 110,
                          child: InkWell(
                            onTap: () {
                              _descargarPDF(
                                'assets/aviso_privacidad.pdf', // Ruta en tu proyecto
                                'buscobien_aviso_privacidad.pdf', // Nombre temporal para el sistema
                              );
                            },
                            child: Row(
                              children: [
                                Icon(
                                  Symbols.picture_as_pdf,
                                  size: 16,
                                  color: appTheme.error,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  "Descargar PDF",
                                  style: TextStyle(
                                    color: appTheme.error,
                                    decoration: TextDecoration.underline,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 10),
            ],
          ),
        ],
      ),
    );
  }

  //------------------------------------------------------------------------------
  // Función para mostrar el diálogo
  //------------------------------------------------------------------------------

  SizedBox renglonDeCaptura(
    String nombreVariable,
    String etiqueta,
    AlignmentGeometry alineacion,
    double ancho,
  ) {
    return SizedBox(
      // WidgetRef ref, String nombreVariable, String expRegular)
      // height: 65,
      width: (screenWidth < smallScreenMin) ? screenWidth : screenWidth * 0.7,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 5),
          SizedBox(
            height: 25,
            child: Text(
              "* $etiqueta",
              style: TextStyle(
                color: appTheme.secondary,
                fontSize: 11,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
          Container(
            //  height: 35,
            alignment: alineacion,
            child: buildCampoFormUser(nombreVariable, ""),
          ),
        ],
      ),
    );
  }

  //------------------------------------------------------------------------------
  bool isEmpty(input) {
    if (input.length == 0) {
      return true;
    } else {
      return false;
    }
  }

  bool isTooLong(input) {
    if (input.length > 20) {
      return true;
    } else {
      return false;
    }
  }

  bool isTooShort(input) {
    if (input.length < 8) {
      return true;
    } else {
      return false;
    }
  }

  TipoCampo _tipoRegistro(String nombreVariable) {
    switch (nombreVariable) {
      case "correoelectronico":
        return TipoCampo.correo;
      case "numerocelular":
        return TipoCampo.telefono;
      default:
        return TipoCampo.texto;
    }
  }

  /// Todos los campos del registro son obligatorios; la clave exige 8 a 20 caracteres.
  String? _validaRegistro(String nombreVariable, String? value) {
    final error = Validadores.validar(
      _tipoRegistro(nombreVariable),
      value,
      esObligatorio: true,
      etiqueta: 'El campo',
    );
    if (error != null) return error;
    final largo = value!.trim().length;
    if (nombreVariable == "claveacceso") {
      if (largo < 8) return 'La clave debe tener al menos 8 caracteres';
      if (largo > 20) return 'La clave debe tener máximo 20 caracteres';
    } else if (largo > 80) {
      return 'El campo es muy largo.';
    }
    return null;
  }

  Widget buildCampoFormUser(String nombreVariable, String expReg) {
    // debugPrintLevels(2, "buildCampoFormUser $nombreVariable");
    return SizedBox(
      height: 60,
      child: TextFormField(
        style: TextStyle(
          color: appTheme.onPrimaryContainer,
          fontSize: 12,
          fontWeight: FontWeight.normal,
        ),
        initialValue: ref
            .read(sessionProvider.notifier)
            .getCampoUserData(ref, nombreVariable),

        obscureText: (nombreVariable == "claveacceso")
            ? isHiddenClaveUser
            : isHiddenCampoUser,
        //maxLines: 2,
        //maxLength: numchar,
        decoration: InputDecoration(
          hintText: ref
              .read(sessionProvider.notifier)
              .getCampoUserData(ref, nombreVariable),
          fillColor: appTheme.onSecondary,
          border: OutlineInputBorder(
            borderSide: BorderSide(color: appTheme.secondary),
            borderRadius: BorderRadius.circular(9),
          ),
          filled: true,
          prefix: const Text(""),
          //labelText: 'Ingrese la dirección',
          contentPadding: const EdgeInsets.only(
            left: 8,
            right: 8,
            bottom: 15.0,
          ),
          labelStyle: TextStyle(
            decoration: TextDecoration.none,
            fontSize: tamanoLetra,
          ),

          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: appTheme.tertiary),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: appTheme.secondary),
          ),

          suffixIcon: IconButton(tooltip: 'Mostrar u ocultar', 
            icon: (nombreVariable == "claveacceso")
                ? isHidden
                      ? const Icon(Symbols.visibility_off)
                      : const Icon(Symbols.visibility)
                : const Icon(Symbols.edit),
            onPressed: () {
              setState(() {
                //  debugPrintLevels(2,
                //      "buildCampoFormUser: muestra o esconde clave-campo: $nombreVariable - $isHiddenClaveUser - $isHiddenCampoUser");
                (nombreVariable == "claveacceso")
                    ? isHiddenClaveUser = !isHiddenClaveUser
                    : isHiddenCampoUser = isHiddenCampoUser;
                //  debugPrintLevels(2,
                //      "buildCampoFormUser: muestra o esconde clave: $nombreVariable - $isHidden");
              });
            },
            iconSize: 18,
            color: appTheme.secondary,
          ),
        ),
        autovalidateMode: AutovalidateMode.always,
        textAlignVertical: TextAlignVertical.bottom,
        //style: TextStyle(color: appTheme.primary, fontSize: tamanoLetra),
        keyboardType: _tipoRegistro(nombreVariable).teclado,
        inputFormatters: _tipoRegistro(nombreVariable).filtros,
        validator: (String? value) => _validaRegistro(nombreVariable, value),
        onChanged: (String? value) {
          ref
              .read(sessionProvider.notifier)
              .setCampoUserData(ref, nombreVariable, value!);
          //ref.read(folioProvider).clavefoliodeventa = value!;
        },
      ),
    );
  }

  //------------------------------------------------------------------------------
  SizedBox renglonValidaClave(
    String etiqueta,
    AlignmentGeometry alineacion,
    double ancho,
  ) {
    return SizedBox(
      // WidgetRef ref, String nombreVariable, String expRegular)
      height: 65,
      width: (screenWidth < smallScreenMin) ? screenWidth : screenWidth * 0.7,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 5),
          SizedBox(
            height: 25,
            child: Text(
              etiqueta,
              style: TextStyle(
                color: appTheme.secondary,
                fontSize: 11,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
          Container(
            height: 35,
            alignment: alineacion,
            child: _buildValidaClave(),
          ),
        ],
      ),
    );
  }

  Widget _buildValidaClave() {
    return TextFormField(
      obscureText: isHiddenValidaClave,
      style: TextStyle(
        color: appTheme.onPrimaryContainer,
        fontSize: 12,
        fontWeight: FontWeight.normal,
      ),
      decoration: InputDecoration(
        //labelText: 'Ingrese la dirección',
        contentPadding: const EdgeInsets.only(left: 8, right: 8, bottom: 15.0),
        labelStyle: TextStyle(
          decoration: TextDecoration.none,
          fontSize: tamanoLetra,
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
        suffixIcon: IconButton(tooltip: 'Mostrar u ocultar', 
          icon: isHiddenValidaClave
              ? const Icon(Symbols.visibility_off)
              : const Icon(Symbols.visibility),
          onPressed: () {
            setState(() {
              isHiddenValidaClave = !isHiddenValidaClave;
            });
          },
          iconSize: 18,
          color: appTheme.secondary,
        ),
      ),
      textAlignVertical: TextAlignVertical.bottom,
      validator: (String? value) {
        if (value!.isEmpty) {
          return 'Repite la clave para validación.';
        }
        if (!RegExp(r'^(?=.*[A-Za-z])[A-Za-z0-9]{6,}$').hasMatch(value)) {
          return 'Iniciar con letra de míninmo 6 caracteres';
        }
        if (ref
                .read(sessionProvider.notifier)
                .getCampoUserData(ref, "userPass") !=
            value) {
          return 'Las claves no coinciden.';
        }
        return null;
      },
      onChanged: (String? value) {
        _validaclavedeacceso = value!;
        hashPasswd = generateSHA256Hash(_validaclavedeacceso);
        _validaclavedeacceso = hashPasswd;
      },
    );
  }
}

//-------------------------------------------------------------------------

// ignore: must_be_immutable
class CheckboxTerminoCondiciones extends StatefulWidget {
  WidgetRef ref;
  CheckboxTerminoCondiciones(this.ref, {super.key});

  @override
  // ignore: no_logic_in_create_state
  State createState() {
    debugPrintLevels(1, " **************************************************");
    debugPrintLevels(1, " 1. CheckboxTerminoCondicionesState createState");
    debugPrintLevels(1, " **************************************************");
    return CheckboxTerminoCondicionesState();
  }
}

class CheckboxTerminoCondicionesState
    extends State<CheckboxTerminoCondiciones> {
  @override
  Widget build(BuildContext context) {
    Color getColor(Set<WidgetState> states) {
      const Set<WidgetState> interactiveStates = <WidgetState>{
        WidgetState.pressed,
        WidgetState.hovered,
        WidgetState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return appTheme.secondary;
      }
      return appTheme.primary;
    }

    return Checkbox(
      checkColor: appTheme.onPrimary,
      fillColor: WidgetStateProperty.resolveWith(getColor),
      value: aceptoTerminosCondiciones,
      onChanged: (bool? value) {
        debugPrintLevels(
          0,
          "1. CheckboxTerminoCondicionesState Checkbox: $value",
        );
        setState(() {
          aceptoTerminosCondiciones = value!;
        });
      },
    );
  }
}

//-------------------------------------------------------------------------
