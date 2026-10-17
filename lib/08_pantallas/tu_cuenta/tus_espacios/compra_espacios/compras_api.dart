import '../../../../10_user_login/usuario_login/auth_api.dart';
import '../../../../40_security/api_client.dart';

/// Tipos de espacio, en el orden en que se muestran. La clave es la misma que usa buscobien-api.
const List<String> tiposDeEspacio = [
  'normales',
  'destacados',
  'superdestacados',
  'oportunidades',
  'remates',
];

/// Precios que usa el servidor (`GET /compras/precios`). Todo en centavos enteros.
class PreciosCompra {
  const PreciosCompra({
    required this.moneda,
    required this.iva,
    required this.mesesMaximo,
    required this.maximoPorTipo,
    required this.nombres,
    required this.precioMensualCentavos,
  });

  final String moneda;
  final double iva;
  final int mesesMaximo;
  final int maximoPorTipo;
  final Map<String, String> nombres;
  final Map<String, int> precioMensualCentavos;

  static PreciosCompra? desdeJson(Map<String, dynamic>? j) {
    try {
      final tipos = j!['tipos'] as Map<String, dynamic>;
      return PreciosCompra(
        moneda: j['moneda'] as String,
        iva: (j['iva'] as num).toDouble(),
        mesesMaximo: j['mesesMaximo'] as int,
        maximoPorTipo: j['maximoPorTipo'] as int,
        nombres: {for (final t in tiposDeEspacio) t: (tipos[t]['nombre'] as String)},
        precioMensualCentavos: {for (final t in tiposDeEspacio) t: (tipos[t]['precioMensualCentavos'] as int)},
      );
    } catch (_) {
      return null;
    }
  }
}

/// Importes calculados en el teléfono **solo para mostrarlos**: el cobro lo calcula el servidor.
class VistaPreviaCompra {
  const VistaPreviaCompra({required this.subtotalCentavos, required this.impuestosCentavos});

  final int subtotalCentavos;
  final int impuestosCentavos;
  int get totalCentavos => subtotalCentavos + impuestosCentavos;
  bool get vacia => subtotalCentavos == 0;
}

/// Misma fórmula que el servidor: precio mensual × cantidad × meses, más IVA redondeado al centavo.
VistaPreviaCompra calcularVistaPrevia(PreciosCompra precios, Map<String, int> cantidades, int meses) {
  var subtotal = 0;
  for (final tipo in tiposDeEspacio) {
    subtotal += (precios.precioMensualCentavos[tipo] ?? 0) * (cantidades[tipo] ?? 0) * meses;
  }
  return VistaPreviaCompra(subtotalCentavos: subtotal, impuestosCentavos: (subtotal * precios.iva).round());
}

/// Texto de dinero en pesos con separador de miles: 123456 centavos → `$1,234.56`.
String formatoDinero(int centavos) {
  final negativo = centavos < 0;
  final c = centavos.abs();
  final enteros = (c ~/ 100).toString().replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (_) => ',');
  final dec = (c % 100).toString().padLeft(2, '0');
  return '${negativo ? '-' : ''}\$$enteros.$dec';
}

/// Resultado de iniciar el pago.
class InicioPago {
  const InicioPago({required this.compraId, required this.checkoutUrl});
  final String compraId;
  final String checkoutUrl;
}

/// Estado de una compra (`GET /compras/:id`).
class EstadoCompra {
  const EstadoCompra({required this.id, required this.estado, required this.espaciosCreados, required this.total});

  final String id;

  /// `pendiente`, `pagada`, `fallida`, `expirada` o `inconsistente`.
  final String estado;
  final bool espaciosCreados;
  final double total;

  bool get pagada => estado == 'pagada';
  bool get terminadaSinPago => estado == 'fallida' || estado == 'expirada' || estado == 'inconsistente';

  static EstadoCompra? desdeJson(Map<String, dynamic>? j) {
    if (j == null || j['id'] is! String || j['estado'] is! String) return null;
    return EstadoCompra(
      id: j['id'] as String,
      estado: j['estado'] as String,
      espaciosCreados: j['espaciosCreados'] == true,
      total: (j['total'] as num?)?.toDouble() ?? 0,
    );
  }
}

/// Compras de espacios contra buscobien-api (requiere sesión).
class ComprasApi {
  ComprasApi({ApiClient? api}) : _api = api ?? apiClient;

  final ApiClient _api;

  static String _mensaje(ApiResponse r) {
    switch (r.code) {
      case 'PAYMENTS_UNAVAILABLE':
      case 'PRICES_UNAVAILABLE':
        return 'Los pagos no están disponibles por ahora. Inténtalo más tarde.';
      case 'PAYMENT_PROVIDER_ERROR':
        return 'No se pudo iniciar el pago. Inténtalo más tarde.';
      case 'NOT_FOUND':
        return 'No se encontró la compra.';
    }
    return AuthApi.mensajeDe(r);
  }

  Future<ResultadoAuth<PreciosCompra>> precios() async {
    final r = await _api.get('/compras/precios');
    final p = r.ok ? PreciosCompra.desdeJson(r.json) : null;
    if (p != null) return ResultadoAuth.exito(p);
    return ResultadoAuth.error(r.code, r.ok ? 'Respuesta inesperada del servidor.' : _mensaje(r));
  }

  Future<ResultadoAuth<InicioPago>> iniciarPago({required int meses, required Map<String, int> cantidades}) async {
    final r = await _api.post(
      '/compras/checkout',
      cuerpo: {
        'meses': meses,
        'cantidades': {for (final e in cantidades.entries) if (e.value > 0) e.key: e.value},
      },
    );
    final id = r.json?['compraId'];
    final url = r.json?['checkoutUrl'];
    if (r.ok && id is String && url is String) return ResultadoAuth.exito(InicioPago(compraId: id, checkoutUrl: url));
    return ResultadoAuth.error(r.code, r.ok ? 'Respuesta inesperada del servidor.' : _mensaje(r));
  }

  Future<ResultadoAuth<EstadoCompra>> estado(String compraId) async {
    final r = await _api.get('/compras/${Uri.encodeComponent(compraId)}');
    final e = r.ok ? EstadoCompra.desdeJson(r.json) : null;
    if (e != null) return ResultadoAuth.exito(e);
    return ResultadoAuth.error(r.code, r.ok ? 'Respuesta inesperada del servidor.' : _mensaje(r));
  }
}

/// Instancia única de la app.
final ComprasApi comprasApi = ComprasApi();
