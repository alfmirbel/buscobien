import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../40_security/direccionip.dart';
import '../../40_security/urls_endpoints_espacios.dart';
import '../../60_global_widgets/debugprint.dart';
import '../inicio/data_espacios_casas_get.dart';

Map<String, String> get _cabeceras => {
  'Authorization': 'Basic ${base64Encode(utf8.encode('$username:$password'))}',
  'Content-Type': 'application/json',
};

/// Busca una propiedad publicada por su `idPropiedad` en las cinco bases
/// `buscobien_publicados_*` (la propiedad está en la que corresponde a su tipo
/// de anuncio). Devuelve `null` si no existe o no se pudo consultar.
Future<ValueEspaciosCasaGet?> buscarPropiedadPublicada(
  String idPropiedad,
) async {
  if (idPropiedad.isEmpty) return null;
  final clave = Uri.encodeComponent('"$idPropiedad"');
  for (final base in endpointsPublicados.values) {
    try {
      final respuesta = await http
          .get(
            Uri.parse('$direccionip/$base/_design/DDUSER/_view/idPropiedad/?key=$clave'),
            headers: _cabeceras,
          )
          .timeout(const Duration(seconds: 10));
      if (respuesta.statusCode != 200) continue;
      final resultado = espaciosCasaGetFromJson(utf8.decode(respuesta.bodyBytes));
      if (resultado.rows.isNotEmpty) return resultado.rows.first.value;
    } catch (e) {
      debugPrintLevels(1, 'buscarPropiedadPublicada($base) exception: $e');
    }
  }
  return null;
}

/// Propiedades publicadas de un usuario (para el perfil de un contacto), como
/// documentos crudos `{ espacioscasa: {...} }`.
Future<List<Map<String, dynamic>>> propiedadesPublicadasDeUsuario(
  String idUsuario,
) async {
  final documentos = <Map<String, dynamic>>[];
  for (final base in endpointsPublicados.values) {
    try {
      final respuesta = await http
          .post(
            Uri.parse('$direccionip/$base/_find'),
            headers: _cabeceras,
            body: jsonEncode({
              'selector': {'espacioscasa.idusuario': idUsuario},
              'limit': 50,
            }),
          )
          .timeout(const Duration(seconds: 10));
      if (respuesta.statusCode != 200) continue;
      final docs = jsonDecode(utf8.decode(respuesta.bodyBytes))['docs'] as List;
      documentos.addAll(docs.cast<Map<String, dynamic>>());
    } catch (e) {
      debugPrintLevels(1, 'propiedadesPublicadasDeUsuario($base) exception: $e');
    }
  }
  return documentos;
}
