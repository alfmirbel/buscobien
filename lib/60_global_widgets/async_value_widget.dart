import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../20_var_globales/var_color_themes.dart';

/// Estados de carga y error uniformes para un [AsyncValue]; la pantalla solo
/// define cómo se dibuja el dato. Con [onReintentar] muestra el botón «Reintentar».
class AsyncValueWidget<T> extends StatelessWidget {
  final AsyncValue<T> value;
  final Widget Function(T data) data;
  final String mensajeError;
  final VoidCallback? onReintentar;

  const AsyncValueWidget({
    super.key,
    required this.value,
    required this.data,
    this.mensajeError = 'Error al cargar',
    this.onReintentar,
  });

  @override
  Widget build(BuildContext context) {
    return value.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Symbols.cloud_off, size: 48, color: appTheme.error),
            const SizedBox(height: 12),
            Text(mensajeError, style: TextStyle(color: appTheme.error)),
            if (onReintentar != null) ...[
              const SizedBox(height: 8),
              FilledButton.tonal(
                onPressed: onReintentar,
                child: const Text('Reintentar'),
              ),
            ],
          ],
        ),
      ),
      data: data,
    );
  }
}
