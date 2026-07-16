import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../05_provider_menus/provider_menu_inicial.dart';
import '../../20_var_globales/var_color_themes.dart';
import '../../40_security/generate_reset_token.dart';
import '../../60_global_widgets/bottom_fijo.dart';
import '../../60_global_widgets/dialogbox_mensaje_general.dart';
import 'password_recovery_repository.dart';

class PageSolicitarRecuperacion extends ConsumerStatefulWidget {
  const PageSolicitarRecuperacion({super.key});

  @override
  ConsumerState<PageSolicitarRecuperacion> createState() =>
      _PageSolicitarRecuperacionState();
}

class _PageSolicitarRecuperacionState
    extends ConsumerState<PageSolicitarRecuperacion> {
  final _formKey = GlobalKey<FormState>();
  final _correoController = TextEditingController();
  String _perfilSeleccionado = listaTipoUsuarios[0];
  bool _isLoading = false;

  @override
  void dispose() {
    _correoController.dispose();
    super.dispose();
  }

  Future<void> _enviarEnlace() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    FocusScope.of(context).unfocus();

    final correo = _correoController.text.trim();
    final perfil = _perfilSeleccionado;

    // 1. Buscar usuario por correo en la DB del perfil
    final usuario = await buscarUsuarioPorCorreo(correo, perfil);

    if (!mounted) return;

    if (usuario == null) {
      setState(() => _isLoading = false);
      await showMessageDialog(
        context,
        'Sin resultado',
        'No se encontró una cuenta con ese correo y perfil.\n'
            'Verifica los datos e intenta de nuevo.',
        appTheme.error,
        TextAlign.center,
        'Entendido',
      );
      return;
    }

    // 2. Generar token y expiry
    final token = generateResetToken();
    final expiry = generateTokenExpiry();

    // 3. Persistir token en CouchDB
    final guardado = await guardarTokenRecuperacion(
      usuario.docId,
      perfil,
      token,
      expiry,
    );

    if (!mounted) return;

    if (!guardado) {
      setState(() => _isLoading = false);
      await showMessageDialog(
        context,
        'Error',
        'No fue posible procesar la solicitud. Intenta más tarde.',
        appTheme.error,
        TextAlign.center,
        'Entendido',
      );
      return;
    }

    // 4. Enviar correo
    final enviado = await enviarCorreoRecuperacion(
      email: correo,
      nombreUsuario: usuario.nombre,
      resetToken: token,
      perfil: perfil,
    );

    if (!mounted) return;

    setState(() => _isLoading = false);

    if (!enviado) {
      await showMessageDialog(
        context,
        'Advertencia',
        'El enlace fue generado pero no se pudo enviar el correo. '
            'Contacta a soporte.',
        appTheme.secondary,
        TextAlign.center,
        'Entendido',
      );
      return;
    }

    // 5. Éxito
    await showMessageDialog(
      context,
      'Enlace enviado',
      'Revisa tu correo.\nSi la cuenta existe, recibirás un enlace '
          'para restablecer tu contraseña (válido 1 hora).',
      appTheme.primary,
      TextAlign.center,
      'Aceptar',
    );

    if (!mounted) return;
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme.surface,
      appBar: AppBar(
        backgroundColor: appTheme.primary,
        foregroundColor: appTheme.onPrimary,
        title: Text(
          '¿Olvidaste tu contraseña?',
          style: TextStyle(
            color: appTheme.onPrimary,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 400),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 12),
                      Image.asset(
                        'assets/images/logobuscobientazul.png',
                        width: 56,
                      ),
                      const SizedBox(height: 10),
                      Image.asset(
                        'assets/images/nombrebuscobientazul.png',
                        width: 110,
                      ),
                      const SizedBox(height: 28),
                      Text(
                        'Te enviaremos un enlace a tu correo para\n'
                        'que puedas crear una nueva contraseña.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: appTheme.onPrimaryContainer,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 28),

                      // ── Correo ──────────────────────────────────────────
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Correo electrónico',
                          style: TextStyle(
                            color: appTheme.onPrimaryContainer,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      SizedBox(
                        height: 48,
                        width: double.infinity,
                        child: TextFormField(
                          controller: _correoController,
                          keyboardType: TextInputType.emailAddress,
                          autofillHints: const [AutofillHints.email],
                          style: TextStyle(
                            color: appTheme.secondary,
                            fontSize: 14,
                          ),
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              Symbols.email,
                              size: 18,
                              color: appTheme.onPrimaryContainer,
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: appTheme.secondary),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: appTheme.tertiary),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: appTheme.tertiary,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            fillColor: appTheme.onSecondary,
                            filled: true,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 0,
                            ),
                          ),
                          validator: (v) {
                            if (v == null || v.trim().isEmpty) {
                              return 'Escribe tu correo';
                            }
                            final emailRx = RegExp(
                              r'^[\w.+-]+@[\w-]+\.[a-zA-Z]{2,}$',
                            );
                            if (!emailRx.hasMatch(v.trim())) {
                              return 'Formato de correo inválido';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: 20),

                      // ── Perfil ──────────────────────────────────────────
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Perfil',
                          style: TextStyle(
                            color: appTheme.onPrimaryContainer,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      SizedBox(
                        height: 48,
                        width: double.infinity,
                        child: DropdownButtonFormField<String>(
                          initialValue: _perfilSeleccionado,
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              Symbols.person_outline,
                              size: 18,
                              color: appTheme.onPrimaryContainer,
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: appTheme.secondary),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: appTheme.tertiary),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: appTheme.tertiary,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            fillColor: appTheme.onSecondary,
                            filled: true,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 0,
                            ),
                          ),
                          icon: Icon(
                            Symbols.arrow_drop_down,
                            color: appTheme.onPrimaryContainer,
                          ),
                          dropdownColor: Colors.white,
                          style: TextStyle(
                            color: appTheme.secondary,
                            fontSize: 14,
                          ),
                          items: listaTipoUsuarios
                              .map(
                                (p) => DropdownMenuItem<String>(
                                  value: p,
                                  child: Text(
                                    p,
                                    style: TextStyle(
                                      color: appTheme.onPrimaryContainer,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                          onChanged: (v) {
                            if (v != null) {
                              setState(() => _perfilSeleccionado = v);
                            }
                          },
                        ),
                      ),
                      const SizedBox(height: 36),

                      // ── Botón ───────────────────────────────────────────
                      _isLoading
                          ? const CircularProgressIndicator()
                          : MyButton(
                              etiqueta: 'Enviar enlace',
                              onTap: _enviarEnlace,
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
