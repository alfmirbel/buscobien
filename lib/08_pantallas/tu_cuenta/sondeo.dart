import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Consulta periódica de novedades (chat). Evita solapar consultas: si la anterior sigue en curso,
/// se salta el turno.
///
/// Sustituye al feed continuo de CouchDB: el servidor ya no expone las bases de mensajes y un
/// `GET ...?desde=` cada pocos segundos funciona igual en Web, móvil y escritorio y se recupera solo
/// de cortes de red y de la renovación del token.
class Sondeo {
  Sondeo(this._consulta, {this.intervalo = const Duration(seconds: 3)});

  final Future<void> Function() _consulta;
  final Duration intervalo;
  Timer? _reloj;
  bool _ocupado = false;

  bool _sinOyentes = false;

  bool get activo => _reloj != null;

  /// Ata el sondeo al ciclo de vida de un provider: se detiene al destruirlo o cuando ninguna
  /// pantalla lo escucha, y se reanuda al volver a escucharlo.
  void atarA(Ref ref) {
    ref.onDispose(pausar);
    ref.onCancel(() {
      _sinOyentes = true;
      pausar();
    });
    ref.onResume(() {
      _sinOyentes = false;
      iniciar();
    });
  }

  /// Arranca el sondeo salvo que, mientras se cargaba, la pantalla ya se haya ido.
  void iniciarSiHayOyentes() {
    if (!_sinOyentes) iniciar();
  }

  void iniciar() {
    if (_reloj != null) return;
    _reloj = Timer.periodic(intervalo, (_) => _tick());
  }

  void pausar() {
    _reloj?.cancel();
    _reloj = null;
  }

  Future<void> _tick() async {
    if (_ocupado) return;
    _ocupado = true;
    try {
      await _consulta();
    } catch (_) {
      // un fallo puntual no detiene el sondeo
    } finally {
      _ocupado = false;
    }
  }
}
