import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../20_var_globales/var_color_themes.dart';

/// Tipo de dato que captura un campo de texto. Define teclado, filtro de
/// entrada y validación (ver [Validadores]).
enum TipoCampo {
  texto,
  entero,
  decimal,
  dinero,
  telefono,
  correo,
  url,
  codigoPostal,
  latitud,
  longitud,
}

/// Validaciones puras (sin Flutter) para los formularios de captura.
/// Todas devuelven `null` cuando el valor es válido. Un valor vacío es válido
/// salvo que el campo sea obligatorio.
class Validadores {
  static final _entero = RegExp(r'^\d+$');
  static final _decimal = RegExp(r'^\d+(\.\d+)?$');
  static final _dinero = RegExp(r'^\$?\s*\d{1,3}(,?\d{3})*(\.\d{1,2})?$|^\$?\s*\d+(\.\d{1,2})?$');
  static final _correo = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]{2,}$');
  static final _numerico = RegExp(r'^-?\d+(\.\d+)?$');

  static String? obligatorio(String? v, [String campo = 'Este campo']) =>
      (v == null || v.trim().isEmpty) ? '$campo es obligatorio' : null;

  static String? entero(String? v) {
    final t = (v ?? '').trim();
    if (t.isEmpty) return null;
    return _entero.hasMatch(t) ? null : 'Escribe solo números enteros';
  }

  static String? decimal(String? v) {
    final t = (v ?? '').trim();
    if (t.isEmpty) return null;
    return _decimal.hasMatch(t) ? null : 'Escribe un número (ej. 120 o 120.5)';
  }

  static String? dinero(String? v) {
    final t = (v ?? '').trim();
    if (t.isEmpty) return null;
    return _dinero.hasMatch(t) ? null : 'Escribe una cantidad (ej. 1500000 o 1,500,000.00)';
  }

  static String? telefono(String? v) {
    final t = (v ?? '').trim();
    if (t.isEmpty) return null;
    if (!RegExp(r'^[\d\s()+\-]+$').hasMatch(t)) return 'Usa solo números, espacios, + , - y paréntesis';
    final digitos = t.replaceAll(RegExp(r'\D'), '').length;
    return (digitos >= 7 && digitos <= 15) ? null : 'El teléfono debe tener entre 7 y 15 dígitos';
  }

  static String? correo(String? v) {
    final t = (v ?? '').trim();
    if (t.isEmpty) return null;
    return _correo.hasMatch(t) ? null : 'Escribe un correo válido (nombre@dominio.com)';
  }

  static String? url(String? v) {
    final t = (v ?? '').trim();
    if (t.isEmpty) return null;
    final uri = Uri.tryParse(t);
    final ok = uri != null && (uri.scheme == 'http' || uri.scheme == 'https') && uri.host.contains('.');
    return ok ? null : 'Escribe un enlace que empiece con http:// o https://';
  }

  static String? codigoPostal(String? v) {
    final t = (v ?? '').trim();
    if (t.isEmpty) return null;
    return RegExp(r'^\d{5}$').hasMatch(t) ? null : 'El código postal tiene 5 dígitos';
  }

  static String? _rango(String? v, double min, double max, String nombre) {
    final t = (v ?? '').trim();
    if (t.isEmpty) return null;
    if (!_numerico.hasMatch(t)) return 'Escribe un número decimal';
    final n = double.parse(t);
    return (n >= min && n <= max) ? null : '$nombre debe estar entre $min y $max';
  }

  static String? latitud(String? v) => _rango(v, -90, 90, 'La latitud');
  static String? longitud(String? v) => _rango(v, -180, 180, 'La longitud');

  /// Validación según el [tipo]; si [esObligatorio] antepone la regla de obligatorio.
  static String? validar(TipoCampo tipo, String? v, {bool esObligatorio = false, String etiqueta = 'Este campo'}) {
    if (esObligatorio) {
      final e = obligatorio(v, etiqueta);
      if (e != null) return e;
    }
    switch (tipo) {
      case TipoCampo.texto:
        return null;
      case TipoCampo.entero:
        return entero(v);
      case TipoCampo.decimal:
        return decimal(v);
      case TipoCampo.dinero:
        return dinero(v);
      case TipoCampo.telefono:
        return telefono(v);
      case TipoCampo.correo:
        return correo(v);
      case TipoCampo.url:
        return url(v);
      case TipoCampo.codigoPostal:
        return codigoPostal(v);
      case TipoCampo.latitud:
        return latitud(v);
      case TipoCampo.longitud:
        return longitud(v);
    }
  }
}

extension TipoCampoEntrada on TipoCampo {
  TextInputType get teclado {
    switch (this) {
      case TipoCampo.entero:
      case TipoCampo.codigoPostal:
        return TextInputType.number;
      case TipoCampo.decimal:
      case TipoCampo.dinero:
        return const TextInputType.numberWithOptions(decimal: true);
      case TipoCampo.latitud:
      case TipoCampo.longitud:
        return const TextInputType.numberWithOptions(decimal: true, signed: true);
      case TipoCampo.telefono:
        return TextInputType.phone;
      case TipoCampo.correo:
        return TextInputType.emailAddress;
      case TipoCampo.url:
        return TextInputType.url;
      case TipoCampo.texto:
        return TextInputType.text;
    }
  }

  /// Filtra lo que se puede escribir (no impide pegar un valor, que se valida al guardar).
  List<TextInputFormatter> get filtros {
    switch (this) {
      case TipoCampo.entero:
      case TipoCampo.codigoPostal:
        return [FilteringTextInputFormatter.digitsOnly];
      case TipoCampo.decimal:
        return [FilteringTextInputFormatter.allow(RegExp(r'[\d.]'))];
      case TipoCampo.dinero:
        return [FilteringTextInputFormatter.allow(RegExp(r'[\d.,$ ]'))];
      case TipoCampo.latitud:
      case TipoCampo.longitud:
        return [FilteringTextInputFormatter.allow(RegExp(r'[\d.\-]'))];
      case TipoCampo.telefono:
        return [FilteringTextInputFormatter.allow(RegExp(r'[\d\s()+\-]'))];
      case TipoCampo.correo:
      case TipoCampo.url:
        return [FilteringTextInputFormatter.deny(RegExp(r'\s'))];
      case TipoCampo.texto:
        return const [];
    }
  }

  /// Longitud máxima razonable cuando el formulario no define una propia.
  int get longitudPorDefecto {
    switch (this) {
      case TipoCampo.entero:
        return 6;
      case TipoCampo.codigoPostal:
        return 5;
      case TipoCampo.decimal:
        return 12;
      case TipoCampo.dinero:
        return 18;
      case TipoCampo.latitud:
      case TipoCampo.longitud:
        return 14;
      case TipoCampo.telefono:
        return 20;
      case TipoCampo.correo:
        return 80;
      case TipoCampo.url:
        return 200;
      case TipoCampo.texto:
        return 80;
    }
  }
}

/// Campo de texto de los formularios de captura: teclado, filtro y validación
/// según su [tipo]. Valida al salir del campo (después del primer cambio).
class CampoTexto extends StatelessWidget {
  final String etiqueta;
  final String valorInicial;
  final TipoCampo tipo;
  final bool obligatorio;
  final int? maxLength;
  final int maxLines;
  final ValueChanged<String> onChanged;

  const CampoTexto({
    super.key,
    required this.etiqueta,
    required this.valorInicial,
    required this.onChanged,
    this.tipo = TipoCampo.texto,
    this.obligatorio = false,
    this.maxLength,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: valorInicial,
      style: TextStyle(color: appTheme.primary, fontSize: 14),
      keyboardType: maxLines > 1 ? TextInputType.multiline : tipo.teclado,
      inputFormatters: tipo.filtros,
      minLines: 1,
      maxLines: maxLines,
      maxLength: maxLength ?? tipo.longitudPorDefecto,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
        border: const OutlineInputBorder(gapPadding: 1.0),
        filled: true,
        fillColor: appTheme.onPrimary,
        labelText: obligatorio ? '$etiqueta *' : etiqueta,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        isDense: true,
        contentPadding: const EdgeInsets.fromLTRB(10, 15, 10, 15),
      ),
      validator: (v) => Validadores.validar(tipo, v, esObligatorio: obligatorio, etiqueta: etiqueta),
      onChanged: onChanged,
    );
  }
}
