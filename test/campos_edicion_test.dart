import 'package:flutter_test/flutter_test.dart';

import 'package:buscobien/07_routes/routes_parameters.dart';
import 'package:buscobien/08_pantallas/tu_cuenta/tus_espacios/edicion/acceso_campos.dart';
import 'package:buscobien/08_pantallas/tu_cuenta/tus_espacios/edicion/campos_edicion.dart';
import 'package:buscobien/60_global_widgets/campo_texto.dart';

void main() {
  group('campos de edición', () {
    test('definen los 68 campos del formulario sin nombres repetidos', () {
      expect(todosLosCampos.length, 68);
      expect(todosLosCampos.map((c) => c.nombre).toSet().length, 68);
    });

    test('cada campo se guarda y se lee por su propio nombre (sin pisar a otro)', () {
      final p = inicializaValueGetCasa;
      for (final c in todosLosCampos.where((c) => c.editable)) {
        setCampoEspaciosCasasGet(p, c.nombre, c.nombre == 'codigopostal' ? '03100' : '__${c.nombre}__');
      }
      final fallidos = [
        for (final c in todosLosCampos.where((c) => c.editable))
          if (getCampoEspaciosCasasGet(p, c.nombre) != (c.nombre == 'codigopostal' ? '03100' : '__${c.nombre}__')) '${c.nombre} -> ${getCampoEspaciosCasasGet(p, c.nombre)}',
      ];
      expect(fallidos, isEmpty);
    });

    test('los campos numéricos y de contacto tienen su tipo de dato', () {
      TipoCampo tipoDe(String n) => todosLosCampos.firstWhere((c) => c.nombre == n).tipo;
      expect(tipoDe('recamaras'), TipoCampo.entero);
      expect(tipoDe('metrosdeterreno'), TipoCampo.decimal);
      expect(tipoDe('precioventa'), TipoCampo.dinero);
      expect(tipoDe('numerocelular'), TipoCampo.telefono);
      expect(tipoDe('correoelectronico'), TipoCampo.correo);
      expect(tipoDe('linkvideo'), TipoCampo.url);
      expect(tipoDe('codigopostal'), TipoCampo.codigoPostal);
      expect(todosLosCampos.where((c) => c.obligatorio).map((c) => c.nombre), ['nombredelapropiedad']);
    });

    test('los precios dependen del tipo de transacción', () {
      final venta = camposVisibles(camposPrecio, 'Casa', 'Venta').map((c) => c.nombre);
      final renta = camposVisibles(camposPrecio, 'Casa', 'Renta').map((c) => c.nombre);
      expect(venta, contains('precioventa'));
      expect(venta, isNot(contains('preciorenta')));
      expect(renta, contains('preciorenta'));
      expect(renta, isNot(contains('precioventa')));
    });
  });
}
