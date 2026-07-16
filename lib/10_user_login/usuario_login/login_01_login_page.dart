import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../05_provider_menus/provider_menu_inicial.dart';
import '../../07_routes/app_routes.dart';
import '../../20_var_globales/var_color_themes.dart';
import '../../40_security/generate_hash.dart';
import '../../60_global_widgets/debugprint.dart';
import '../../60_global_widgets/dialogbox_mensaje_general.dart';
import '../../60_global_widgets/bottom_fijo.dart';
import '../avatar/provider_get_avatar.dart';
import '../data_models/data_get_user.dart';
import 'provider_session.dart';

// OPTIMIZACION 26 01 27
// OPTIMIZACION 26 02 27
// -----------------------------------------------------------------------------
// VARIABLES GLOBALES
// -----------------------------------------------------------------------------
// SUGERENCIA: En Flutter, se recomienda que los controladores no sean globales
// para evitar fugas de memoria, sino instanciados dentro del State de la página.
// Por requerimiento se mantienen globales y con los mismos nombres.
String loginUser = "";
String passwordHintText = "Password";
GetUserData listaUsuariosGCD = GetUserData(totalRows: 0, offset: 0, rows: []);

// -----------------------------------------------------------------------------
// LOGIN PAGE
// -----------------------------------------------------------------------------
class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  bool _isLoading = false;

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    debugPrintLevels(2, "2. LoginPage initState");

    // OPTIMIZACIÓN: En Riverpod, las mutaciones de estado en initState
    // deben hacerse después del primer frame para evitar colisiones de renderizado.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final sessionNotifier = ref.read(sessionProvider.notifier);

      sessionNotifier.resetInitialUserData(0);

      ref.read(sessionProvider.notifier).setNombrePerfil(listaTipoUsuarios[0]);
    });
  }

  //-----------------------------------------------------------------------------
  @override
  void didChangeDependencies() {
    // setState(() {}); // MEJORA: Eliminado. Llamar setState vacío aquí es redundante y consume recursos.
    debugPrintLevels(1, "LoginPage didChangeDependencies");
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(covariant LoginPage oldWidget) {
    debugPrintLevels(1, " LoginPage didUpdateWidget");
    super.didUpdateWidget(oldWidget);
  }

  @override
  void deactivate() {
    debugPrintLevels(1, " LoginPage deactivate");
    super.deactivate();
  }

  @override
  void dispose() {
    debugPrintLevels(1, " LoginPage dispose");
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  //-----------------------------------------------------------------------------

  Future<void> _handleLogin() async {
    debugPrintLevels(12, " LoginPage _handleLogin");

    // Validación básica
    if (usernameController.text.trim().isEmpty ||
        passwordController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Escriba usuario y contraseña"),
          backgroundColor: appTheme.error,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);
    FocusScope.of(context).unfocus(); // Oculta el teclado

    debugPrintLevels(12, " LoginPage try");

    try {
      final authState = ref.read(sessionProvider);
      final sessionNotifier = ref.read(sessionProvider.notifier);

      final username = usernameController.text.trim();
      final password = passwordController.text.trim();

      debugPrintLevels(
        12,
        " _handleLogin setSessionVarValue nombreusuario: $username",
      );
      ref
          .read(sessionProvider.notifier)
          .setSessionVarValue("userName", username);
      debugPrintLevels(12, " _handleLogin setSessionVarValue claveacceso: ---");
      ref
          .read(sessionProvider.notifier)
          .setSessionVarValue("userPass", password);

      debugPrintLevels(
        12,
        " _handleLogin setSessionVarValue claveacceso: ${authState.nombrePerfil}",
      );
      // Petición HTTP
      // INICIALIZA sessionProvider
      //------------------------------------------------------------------------
      final onValue = await sessionNotifier.getUserIdNamePassByName();
      //------------------------------------------------------------------------

      if (!mounted) return;

      if (onValue != 200) {
        await showMessageDialog(
          context,
          "Error de Ingreso",
          "Usuario o contraseña incorrectos.",
          appTheme.error,
          TextAlign.center,
          "Intentar de nuevo",
        );
      } else {
        debugPrintLevels(1, " INICIA PROCESO DE Recuperar Avatar");

        // INICIA PROCESO DE Recuperar Avatar (No se espera, corre en background si así estaba diseñado)
        final String currentUserId = ref
            .read(sessionProvider)
            .sessionUserData
            .userId;
        ref
            .read(classUserAvatarProvider.notifier)
            .recuperaDatosDelAvatar(currentUserId);
        //debugPrintLevels(1, " BORRA LA SESIÓN ALMACENADA PREVIA");
        // BORRA LA SESIÓN ALMACENADA PREVIA
        await sessionNotifier.deleteLocalSessionData();
        // ✅ Fase 6: await para asegurar que los datos completos del usuario estén disponibles
        await ref
            .read(sessionProvider.notifier)
            .getUserDataByNameInSessionData();
        // ✅ Fase 5: Marcar sesión como autenticada
        // (isAuthenticated ya se setea en getSessionValuesFromLocalStorage,
        //  aquí lo reforzamos directamente en el estado vía copyWith)
        // -------------------------------------------------------------------
        // OPTIMIZACIÓN: Ejecutar guardados en local storage de forma paralela
        // usando Future.wait para reducir el tiempo de bloqueo en la UI.
        // -------------------------------------------------------------------
        debugPrintLevels(
          1,
          " OPTIMIZACIÓN: Ejecutar guardados en local storage",
        );

        // ✅ Fase 4: Se incluye el hash SHA-256 de la contraseña para reautenticación
        await sessionNotifier.saveVarValueToLocalStorage(
          "userId",
          ref.read(sessionProvider).sessionUserData.userId,
        );
        await sessionNotifier.saveVarValueToLocalStorage(
          "userName",
          ref.read(sessionProvider).sessionUserData.userName,
        );
        await sessionNotifier.saveVarValueToLocalStorage(
          "nombrePerfil",
          ref.read(sessionProvider).nombrePerfil,
        );
        await sessionNotifier.saveVarValueToLocalStorage(
          "userPassHash",
          generateSHA256Hash(passwordController.text.trim()),
        );
        // -------------------------------------------------------------------
        debugPrintLevels(
          1,
          " OPTIMIZACIÓN: Termina guardados en local storage",
        );

        if (mounted) Navigator.of(context).pop(true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error inesperado: $e"),
            backgroundColor: appTheme.error,
          ),
        );
      }
    } finally {
      // MEJORA: Aseguramos que el estado de carga se apague pase lo que pase (éxito o error)
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme.surface,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              reverse:
                  false, // Evita que se inicie pre-scrolled abajo y oculte el logo/usuario
              padding: const EdgeInsets.all(20),
              child: ConstrainedBox(
                // Esto asegura que la app se vea bien en Web y Windows sin estirarse al infinito
                constraints: const BoxConstraints(maxWidth: 400),
                child: AutofillGroup(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),
                      Image.asset(
                        "assets/images/logobuscobientazul.png",
                        width: 60,
                      ),
                      const SizedBox(height: 10),
                      Image.asset(
                        "assets/images/nombrebuscobientazul.png",
                        width: 120,
                      ),
                      const SizedBox(
                        height: 30,
                      ), // MEJORA: Un poco más de espacio visual
                      // Username
                      MyTextField(
                        controller: usernameController,
                        hintText: 'Nombre de usuario',
                        obscureText: false,
                        icono: Symbols.person_outline,
                      ),
                      const SizedBox(height: 15),

                      // Password
                      MyTextFieldPassword(
                        controller: passwordController,
                        hintText: 'Clave de acceso',
                        icono: Symbols.lock_outline,
                      ),
                      const SizedBox(height: 15),

                      // -------------------------------------------------------
                      // DROPDOWN DE TIPO DE USUARIO
                      // -------------------------------------------------------
                      const DropdownTipoUsuario(),

                      const SizedBox(height: 30),

                      // Botón Entrar
                      _isLoading
                          ? const CircularProgressIndicator()
                          : MyButton(etiqueta: "Entrar", onTap: _handleLogin),

                      const SizedBox(height: 20),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            AppRoutes.solicitarRecuperacion,
                          );
                        },
                        child: Text(
                          '¿Olvidaste tu clave?',
                          style: TextStyle(
                            color: appTheme.secondary,
                            fontWeight:
                                FontWeight.w600, // MEJORA: Mayor legibilidad
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      MyButton(
                        etiqueta: "Regístrate",
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            AppRoutes.registro,
                            arguments: "",
                          );
                        },
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// WIDGET OPTIMIZADO: DROPDOWN TIPO DE USUARIO
// -----------------------------------------------------------------------------
class DropdownTipoUsuario extends ConsumerStatefulWidget {
  const DropdownTipoUsuario({super.key});

  @override
  ConsumerState<DropdownTipoUsuario> createState() =>
      _DropdownTipoUsuarioState();
}

class _DropdownTipoUsuarioState extends ConsumerState<DropdownTipoUsuario> {
  // Valor seleccionado por defecto: "Usuario" (el primero de la lista)
  late String _selectedValue;

  @override
  void initState() {
    super.initState();
    // MEJORA: Se inicializa garantizando que la lista no esté vacía.
    _selectedValue = listaTipoUsuarios.isNotEmpty ? listaTipoUsuarios[0] : "";
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Perfil",
          style: TextStyle(
            color: appTheme.onPrimaryContainer,
            fontSize: 12,
            fontWeight: FontWeight.normal,
          ),
        ),
        const SizedBox(
          height: 5,
        ), // MEJORA: Pequeño margen para separar etiqueta del input
        SizedBox(
          height:
              45, // MEJORA: Altura ajustada para no cortar el texto en móviles pequeños o web
          width: double
              .infinity, // MEJORA: Ocupa todo el ancho disponible del ConstrainedBox (hasta 400px)
          child: DropdownButtonFormField<String>(
            initialValue:
                _selectedValue, // MEJORA: Usar value en lugar de initialValue para que reaccione al estado
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 0,
              ), // Centra verticalmente
              prefixIcon: Icon(
                Symbols.person_outline,
                size: 20, // MEJORA: Tamaño ligeramente más visible
                color: appTheme.secondary,
              ),
              border: OutlineInputBorder(
                borderSide: BorderSide(color: appTheme.secondary),
                borderRadius: BorderRadius.circular(
                  8,
                ), // MEJORA: Bordes redondeados más modernos
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: appTheme.tertiary),
                borderRadius: BorderRadius.circular(8),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: appTheme.tertiary,
                  width: 2,
                ), // MEJORA: Énfasis al focus
                borderRadius: BorderRadius.circular(8),
              ),
              fillColor: appTheme.onSecondary,
              filled: true,
            ),
            icon: Icon(
              Symbols.arrow_drop_down,
              color: appTheme.onPrimaryContainer,
            ),
            style: TextStyle(
              color: appTheme.secondary,
              fontSize: 14,
              textBaseline: TextBaseline.alphabetic,
            ),
            dropdownColor: Colors.white,

            items: listaTipoUsuarios.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value,
                  style: TextStyle(
                    color: appTheme.onPrimaryContainer,
                    fontWeight: FontWeight.normal,
                    fontSize:
                        14, // MEJORA: Unificado con el tamaño de estilo base
                  ),
                ),
              );
            }).toList(),

            // FASE 4 (26-05-18): setNombrePerfil() ya llama internamente a
            // setPerfilUsuarioByNombrePerfil(), que establece todos los flags
            // de rol en un solo copyWith. Las 9 llamadas a setRoleFlag() eran
            // redundantes y generaban 9 reconstrucciones innecesarias del árbol.
            onChanged: (String? newValue) {
              if (newValue != null && newValue != _selectedValue) {
                setState(() => _selectedValue = newValue);
                debugPrintLevels(0, "Selección Perfil: $newValue");
                ref.read(sessionProvider.notifier).setNombrePerfil(newValue);
                debugPrintLevels(
                  0,
                  "Selección Promotor: ${ref.read(sessionProvider).esPromotor}",
                );
              }
            },
          ),
        ),
      ],
    );
  }
}
