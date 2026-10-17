import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../07_routes/app_routes.dart';
import '../../../../20_var_globales/var_color_themes.dart';
import '../../../../60_global_widgets/dialogbox_mensaje_general.dart';
import 'compras_api.dart';

/// Compra de espacios: se eligen cantidades y meses, y el pago se hace en Stripe.
/// Los importes de esta pantalla son informativos; el servidor calcula el cobro real.
class PaginaCompraEspacios extends ConsumerStatefulWidget {
  const PaginaCompraEspacios({super.key, ComprasApi? api}) : _api = api;

  final ComprasApi? _api;

  @override
  ConsumerState<PaginaCompraEspacios> createState() => PaginaCompraEspaciosState();
}

class PaginaCompraEspaciosState extends ConsumerState<PaginaCompraEspacios> {
  late final ComprasApi _api = widget._api ?? comprasApi;

  PreciosCompra? _precios;
  String? _errorPrecios;
  final Map<String, int> _cantidades = {for (final t in tiposDeEspacio) t: 0};
  int _meses = 1;
  bool _comprando = false; // evita iniciar dos pagos a la vez

  @override
  void initState() {
    super.initState();
    _cargarPrecios();
  }

  Future<void> _cargarPrecios() async {
    setState(() => _errorPrecios = null);
    final r = await _api.precios();
    if (!mounted) return;
    setState(() {
      if (r.ok) {
        _precios = r.dato;
      } else {
        _errorPrecios = r.mensaje;
      }
    });
  }

  void _cambiar(String tipo, int delta) {
    final maximo = _precios?.maximoPorTipo ?? 0;
    setState(() => _cantidades[tipo] = ((_cantidades[tipo] ?? 0) + delta).clamp(0, maximo));
  }

  Future<void> _pagar() async {
    final precios = _precios;
    if (precios == null || _comprando || calcularVistaPrevia(precios, _cantidades, _meses).vacia) return;
    setState(() => _comprando = true);

    final r = await _api.iniciarPago(meses: _meses, cantidades: _cantidades);
    if (!mounted) return;
    if (!r.ok) {
      setState(() => _comprando = false);
      await showMessageDialog(context, 'Compra de espacios', r.mensaje, appTheme.error, TextAlign.center, 'Cerrar');
      return;
    }
    final inicio = r.dato!;
    final abierto = await launchUrl(
      Uri.parse(inicio.checkoutUrl),
      webOnlyWindowName: '_self',
    );
    if (!mounted) return;
    if (!abierto) {
      setState(() => _comprando = false);
      await showMessageDialog(
        context,
        'Compra de espacios',
        'No se pudo abrir la página de pago.',
        appTheme.error,
        TextAlign.center,
        'Cerrar',
      );
      return;
    }
    // En Web la misma pestaña ya navegó a Stripe; en móvil/escritorio se espera aquí la confirmación.
    if (kIsWeb) return;
    await Navigator.of(context).pushReplacementNamed(AppRoutes.estadoCompra, arguments: inicio.compraId);
  }

  @override
  Widget build(BuildContext context) {
    final precios = _precios;
    return Scaffold(
      backgroundColor: appTheme.surface,
      appBar: AppBar(
        toolbarHeight: 40.0,
        centerTitle: true,
        titleSpacing: 0,
        backgroundColor: appTheme.primary,
        iconTheme: IconThemeData(size: 14, color: appTheme.onPrimary),
        title: Text(
          'Compra de Espacios',
          style: TextStyle(color: appTheme.onPrimary, fontWeight: FontWeight.bold, fontSize: 14),
        ),
        leading: IconButton(
          tooltip: 'Regresar',
          color: appTheme.onPrimary,
          icon: const Icon(Symbols.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: precios == null ? _cargando() : _formulario(precios),
        ),
      ),
    );
  }

  Widget _cargando() {
    if (_errorPrecios == null) return const CircularProgressIndicator();
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(_errorPrecios!, textAlign: TextAlign.center, style: TextStyle(color: appTheme.error)),
          const SizedBox(height: 12),
          FilledButton(onPressed: _cargarPrecios, child: const Text('Reintentar')),
        ],
      ),
    );
  }

  Widget _formulario(PreciosCompra precios) {
    final vista = calcularVistaPrevia(precios, _cantidades, _meses);
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text('Elige tus espacios', style: _titulo()),
        const SizedBox(height: 12),
        for (final tipo in tiposDeEspacio) _renglonTipo(precios, tipo),
        const SizedBox(height: 16),
        Text('Duración', style: _titulo()),
        const SizedBox(height: 8),
        DropdownButtonFormField<int>(
          initialValue: _meses,
          decoration: const InputDecoration(labelText: 'Meses contratados', border: OutlineInputBorder()),
          items: [
            for (var m = 1; m <= precios.mesesMaximo; m++)
              DropdownMenuItem(value: m, child: Text(m == 1 ? '1 mes' : '$m meses')),
          ],
          onChanged: (v) => setState(() => _meses = v ?? _meses),
        ),
        const SizedBox(height: 16),
        Text('Resumen', style: _titulo()),
        const SizedBox(height: 8),
        _linea('Subtotal', formatoDinero(vista.subtotalCentavos)),
        _linea('IVA (${(precios.iva * 100).round()} %)', formatoDinero(vista.impuestosCentavos)),
        const Divider(),
        _linea('Total', formatoDinero(vista.totalCentavos), fuerte: true),
        const SizedBox(height: 4),
        Text(
          'El pago se realiza en la página segura de Stripe. Tus espacios se crean cuando el pago se confirma.',
          style: TextStyle(color: appTheme.onSurfaceVariant, fontSize: 12),
        ),
        const SizedBox(height: 20),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 20,
          runSpacing: 10,
          children: [
            OutlinedButton(
              style: OutlinedButton.styleFrom(minimumSize: const Size(150, 40)),
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            FilledButton.icon(
              style: FilledButton.styleFrom(backgroundColor: appTheme.primary, minimumSize: const Size(150, 40)),
              onPressed: (_comprando || vista.vacia) ? null : _pagar,
              icon: _comprando
                  ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                  : const Icon(Symbols.lock),
              label: const Text('Pagar con Stripe'),
            ),
          ],
        ),
        const SizedBox(height: 30),
      ],
    );
  }

  TextStyle _titulo() => TextStyle(
        fontFamily: 'Outfit',
        color: appTheme.secondary,
        fontSize: 16,
        fontWeight: FontWeight.bold,
      );

  Widget _linea(String etiqueta, String valor, {bool fuerte = false}) {
    final estilo = TextStyle(fontWeight: fuerte ? FontWeight.bold : FontWeight.normal, fontSize: fuerte ? 16 : 14);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [Text(etiqueta, style: estilo), Text(valor, style: estilo)],
      ),
    );
  }

  Widget _renglonTipo(PreciosCompra precios, String tipo) {
    final cantidad = _cantidades[tipo] ?? 0;
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(precios.nombres[tipo] ?? tipo, style: const TextStyle(fontWeight: FontWeight.w600)),
                  Text(
                    '${formatoDinero(precios.precioMensualCentavos[tipo] ?? 0)} al mes por espacio',
                    style: TextStyle(color: appTheme.onSurfaceVariant, fontSize: 12),
                  ),
                ],
              ),
            ),
            IconButton(
              tooltip: 'Quitar uno',
              onPressed: cantidad > 0 ? () => _cambiar(tipo, -1) : null,
              icon: const Icon(Symbols.remove_circle),
            ),
            SizedBox(width: 28, child: Text('$cantidad', textAlign: TextAlign.center)),
            IconButton(
              tooltip: 'Agregar uno',
              onPressed: cantidad < precios.maximoPorTipo ? () => _cambiar(tipo, 1) : null,
              icon: const Icon(Symbols.add_circle),
            ),
          ],
        ),
      ),
    );
  }
}
