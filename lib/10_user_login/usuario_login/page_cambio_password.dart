import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../07_routes/app_routes.dart';
import '../../20_var_globales/var_color_themes.dart';
import '../../60_global_widgets/dialogbox_mensaje_general.dart';
import 'password_recovery_repository.dart';

class PageCambioPassword extends ConsumerStatefulWidget {
  const PageCambioPassword({
    super.key,
    required this.token,
    required this.perfil,
  });

  final String token;
  final String perfil;

  @override
  ConsumerState<PageCambioPassword> createState() => _PageCambioPasswordState();
}

class _PageCambioPasswordState extends ConsumerState<PageCambioPassword> {
  final _formKey = GlobalKey<FormState>();
  final _passController = TextEditingController();
  final _confirmController = TextEditingController();

  bool _obscurePass = true;
  bool _obscureConfirm = true;
  bool _isLoading = true;
  bool _tokenValido = false;
  String? _docId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _validarToken());
  }

  @override
  void dispose() {
    _passController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _validarToken() async {
    final resultado = await validarToken(widget.token, widget.perfil);

    if (!mounted) return;

    if (resultado == null) {
      setState(() => _isLoading = false);
      await showMessageDialog(
        context,
        'Enlace inválido',
        'El enlace de recuperación no es válido o ya expiró.\n'
            'Solicita uno nuevo desde la pantalla de inicio de sesión.',
        appTheme.error,
        TextAlign.center,
        'Ir al inicio',
      );
      if (!mounted) return;
      Navigator.of(
        context,
      ).pushNamedAndRemoveUntil(AppRoutes.login, (route) => false);
    } else {
      _docId = resultado.docId;
      setState(() {
        _isLoading = false;
        _tokenValido = true;
      });
    }
  }

  int _calcularFortaleza(String pass) {
    if (pass.length < 6) return 0;
    int score = 0;
    if (pass.length >= 8) score++;
    if (pass.length >= 12) score++;
    if (RegExp(r'[A-Z]').hasMatch(pass)) score++;
    if (RegExp(r'[0-9]').hasMatch(pass)) score++;
    if (RegExp(r'[!@#\$%^&*(),.?":{}|<>]').hasMatch(pass)) score++;
    return score.clamp(0, 3);
  }

  Future<void> _guardar() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    FocusScope.of(context).unfocus();

    final hash = sha256
        .convert(utf8.encode(_passController.text.trim()))
        .toString();

    final ok = await actualizarPassword(_docId!, widget.perfil, hash);

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (!ok) {
      await showMessageDialog(
        context,
        'Error',
        'No fue posible actualizar la contraseña. Intenta de nuevo.',
        appTheme.error,
        TextAlign.center,
        'Entendido',
      );
      return;
    }

    await showMessageDialog(
      context,
      'Listo',
      'Tu contraseña ha sido actualizada correctamente.\n'
          'Inicia sesión con tu nueva contraseña.',
      appTheme.primary,
      TextAlign.center,
      'Iniciar sesión',
    );

    if (!mounted) return;
    Navigator.of(
      context,
    ).pushNamedAndRemoveUntil(AppRoutes.login, (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: appTheme.surface,
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (!_tokenValido) return const SizedBox.shrink();

    final fortaleza = _calcularFortaleza(_passController.text);
    final fortalezaLabel = ['Muy corta', 'Débil', 'Media', 'Fuerte'][fortaleza];
    final fortalezaColor = [
      appTheme.error,
      appTheme.error,
      appTheme.secondary,
      Colors.green,
    ][fortaleza];

    return Scaffold(
      backgroundColor: appTheme.surface,
      appBar: AppBar(
        backgroundColor: appTheme.primary,
        foregroundColor: appTheme.onPrimary,
        title: Text(
          'Nueva contraseña',
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
                        'Crea una contraseña segura para tu cuenta.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: appTheme.onPrimaryContainer,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 28),

                      // ── Nueva contraseña ────────────────────────────────
                      _buildPasswordField(
                        label: 'Nueva contraseña',
                        controller: _passController,
                        obscure: _obscurePass,
                        onToggle: () =>
                            setState(() => _obscurePass = !_obscurePass),
                        onChanged: (_) => setState(() {}),
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) {
                            return 'Escribe una contraseña';
                          }
                          if (v.trim().length < 8) {
                            return 'Mínimo 8 caracteres';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 8),

                      // Indicador de fortaleza
                      Row(
                        children: [
                          Expanded(
                            child: LinearProgressIndicator(
                              value: fortaleza / 3,
                              color: fortalezaColor,
                              backgroundColor: appTheme.onSecondary,
                              minHeight: 4,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            fortalezaLabel,
                            style: TextStyle(
                              fontSize: 11,
                              color: fortalezaColor,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // ── Confirmar contraseña ────────────────────────────
                      _buildPasswordField(
                        label: 'Confirmar contraseña',
                        controller: _confirmController,
                        obscure: _obscureConfirm,
                        onToggle: () =>
                            setState(() => _obscureConfirm = !_obscureConfirm),
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) {
                            return 'Confirma tu contraseña';
                          }
                          if (v.trim() != _passController.text.trim()) {
                            return 'Las contraseñas no coinciden';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 36),

                      // ── Botón ───────────────────────────────────────────
                      SizedBox(
                        width: 200,
                        height: 44,
                        child: ElevatedButton(
                          onPressed: _guardar,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: appTheme.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            'Guardar',
                            style: TextStyle(
                              color: appTheme.onPrimary,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
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

  Widget _buildPasswordField({
    required String label,
    required TextEditingController controller,
    required bool obscure,
    required VoidCallback onToggle,
    String? Function(String?)? validator,
    void Function(String)? onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(color: appTheme.onPrimaryContainer, fontSize: 12),
        ),
        const SizedBox(height: 4),
        SizedBox(
          height: 48,
          width: double.infinity,
          child: TextFormField(
            controller: controller,
            obscureText: obscure,
            onChanged: onChanged,
            style: TextStyle(color: appTheme.secondary, fontSize: 14),
            decoration: InputDecoration(
              prefixIcon: Icon(
                Symbols.lock_outline,
                size: 18,
                color: appTheme.onPrimaryContainer,
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  obscure ? Symbols.visibility_off : Symbols.visibility,
                  size: 18,
                  color: appTheme.onPrimaryContainer,
                ),
                onPressed: onToggle,
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
                borderSide: BorderSide(color: appTheme.tertiary, width: 2),
                borderRadius: BorderRadius.circular(8),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: appTheme.error),
                borderRadius: BorderRadius.circular(8),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: appTheme.error, width: 2),
                borderRadius: BorderRadius.circular(8),
              ),
              fillColor: appTheme.onSecondary,
              filled: true,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 0,
              ),
            ),
            validator: validator,
          ),
        ),
      ],
    );
  }
}
