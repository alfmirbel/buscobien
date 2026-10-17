import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../../07_routes/app_routes.dart';
import '../../../../20_var_globales/var_color_themes.dart';
import 'compras_api.dart';

/// Espera la confirmación de un pago: el servidor crea los espacios solo cuando Stripe lo confirma.
/// Consulta el estado cada pocos segundos y también al volver a la app desde el navegador.
class PaginaEstadoCompra extends ConsumerStatefulWidget {
  const PaginaEstadoCompra({
    super.key,
    required this.compraId,
    ComprasApi? api,
    this.intervalo = const Duration(seconds: 3),
    this.maximoConsultas = 100,
  }) : _api = api;

  final String compraId;
  final ComprasApi? _api;
  final Duration intervalo;

  /// Con 3 s entre consultas, 100 consultas son ≈ 5 minutos.
  final int maximoConsultas;

  @override
  ConsumerState<PaginaEstadoCompra> createState() => _PaginaEstadoCompraState();
}

class _PaginaEstadoCompraState extends ConsumerState<PaginaEstadoCompra> with WidgetsBindingObserver {
  late final ComprasApi _api = widget._api ?? comprasApi;
  Timer? _reloj;
  EstadoCompra? _estado;
  String? _error;
  int _consultas = 0;
  bool _consultando = false;

  bool get _terminada => _estado != null && (_estado!.pagada || _estado!.terminadaSinPago);
  bool get _agotada => !_terminada && _consultas >= widget.maximoConsultas;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _consultar();
    _reloj = Timer.periodic(widget.intervalo, (_) => _consultar());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _reloj?.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // El pago ocurre en el navegador: al volver a la app se revisa de inmediato.
    if (state == AppLifecycleState.resumed) _consultar(forzar: true);
  }

  Future<void> _consultar({bool forzar = false}) async {
    if (_consultando || _terminada || (_agotada && !forzar)) return;
    _consultando = true;
    final r = await _api.estado(widget.compraId);
    _consultando = false;
    if (!mounted) return;
    if (forzar) _consultas = 0;
    setState(() {
      _consultas += 1;
      if (r.ok) {
        _estado = r.dato;
        _error = null;
      } else {
        _error = r.mensaje;
      }
    });
    if (_terminada || _agotada) _reloj?.cancel();
    if (forzar && !_terminada) {
      _reloj?.cancel();
      _reloj = Timer.periodic(widget.intervalo, (_) => _consultar());
    }
  }

  void _salir() {
    Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.principal, (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    final e = _estado;
    final IconData icono;
    final Color color;
    final String titulo;
    final String detalle;
    var cargando = false;

    if (e != null && e.pagada) {
      icono = Symbols.check_circle;
      color = appTheme.primary;
      titulo = 'Pago confirmado';
      detalle = e.espaciosCreados
          ? 'Tus espacios ya están disponibles en «Tus Espacios».'
          : 'Estamos creando tus espacios; aparecerán en «Tus Espacios» en unos segundos.';
    } else if (e != null && e.terminadaSinPago) {
      icono = Symbols.error;
      color = appTheme.error;
      titulo = e.estado == 'expirada'
          ? 'La sesión de pago venció'
          : e.estado == 'inconsistente'
              ? 'No pudimos validar el pago'
              : 'El pago no se completó';
      detalle = e.estado == 'inconsistente'
          ? 'Si ya te cobraron, contacta a soporte con este folio: ${widget.compraId}.'
          : 'No se hizo ningún cobro. Puedes intentarlo de nuevo.';
    } else if (_agotada) {
      icono = Symbols.schedule;
      color = appTheme.secondary;
      titulo = 'Seguimos esperando la confirmación';
      detalle = 'Si ya pagaste, tus espacios aparecerán en unos minutos. Puedes revisar de nuevo.';
    } else {
      icono = Symbols.hourglass_top;
      color = appTheme.primary;
      titulo = 'Esperando la confirmación del pago';
      detalle = 'Termina el pago en la página de Stripe. Esta pantalla se actualiza sola.';
      cargando = true;
    }

    return Scaffold(
      backgroundColor: appTheme.surface,
      appBar: AppBar(
        backgroundColor: appTheme.primary,
        iconTheme: IconThemeData(color: appTheme.onPrimary),
        title: Text('Estado de la compra', style: TextStyle(color: appTheme.onPrimary, fontSize: 14)),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                cargando ? const CircularProgressIndicator() : Icon(icono, size: 64, color: color),
                const SizedBox(height: 20),
                Text(titulo, textAlign: TextAlign.center, style: TextStyle(color: color, fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                Text(detalle, textAlign: TextAlign.center, style: TextStyle(color: appTheme.onSurfaceVariant)),
                if (_error != null && !_terminada) ...[
                  const SizedBox(height: 10),
                  Text(_error!, textAlign: TextAlign.center, style: TextStyle(color: appTheme.error, fontSize: 12)),
                ],
                const SizedBox(height: 28),
                if (_agotada)
                  FilledButton(onPressed: () => _consultar(forzar: true), child: const Text('Revisar de nuevo')),
                if (_terminada || _agotada)
                  TextButton(onPressed: _salir, child: Text(e?.pagada == true ? 'Ir a Tus Espacios' : 'Salir')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
