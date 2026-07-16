//-----------------------------------------------------------------------------
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../40_security/direccionip.dart';
import '../60_global_widgets/debugprint.dart';
import 'data_lista_propiedad.dart';
import 'data_lista_propiedad_get.dart';

import 'package:uuid/uuid.dart';

import 'data_user_list_model.dart';

// import 'data_user_list_model.dart'; // Si se usa para el parámetro de entrada original

// OPTIMIZADO 25 02 09
// OPCION B
// OPTIMIZADO 25 02 11
// CAMBIOS DE FETCH Y DELETE
// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------
// PROVIDER: provider_listas_propiedades.dart
// -----------------------------------------------------------------------------

final listaPropiedadesProvider =
    NotifierProvider<ClassListaPropiedadesProvider, GetListaPropertyListModel>(
      () {
        return ClassListaPropiedadesProvider();
      },
    );

class ClassListaPropiedadesProvider
    extends Notifier<GetListaPropertyListModel> {
  // Utilidad para generar IDs únicos
  final _uuid = const Uuid();

  // Headers de Autenticación
  Map<String, String> get _headers => {
    'Authorization':
        'Basic ${base64Encode(utf8.encode('$username:$password'))}',
    'Content-Type': 'application/json',
  };

  @override
  GetListaPropertyListModel build() {
    return GetListaPropertyListModel(totalRows: 0, offset: 0, rows: []);
  }

  // ---------------------------------------------------------------------------
  // 1. RECUPERAR RELACIONES DE UNA LISTA
  // ---------------------------------------------------------------------------
  // Nota: Cambié el tipo de parámetro a ListaPropertyListModel para coincidir
  // con el modelo proporcionado en el prompt, pero mantengo la lógica.
  Future<int> getListaPropiedad(Lista idLista) async {
    // Corrección: Accedemos a listapropiedad.listaId
    String listaIdTarget = idLista.listaId;

    debugPrintLevels(10, 'HTTP getListaPropiedad, ID = $listaIdTarget');
    int codeState = 0;

    try {
      // URL de la vista que devuelve los items de una lista específica
      String url =
          '$direccionip/buscobien_listas_propiedades/_design/DDLOCAL/_view/vistaListaID?key="$listaIdTarget"';
      debugPrintLevels(10, 'HTTP getListaPropiedad, url = $url');

      final response = await http.get(Uri.parse(url), headers: _headers);
      debugPrintLevels(
        0,
        "01 getListaPropiedad Status: ${response.statusCode}",
      );

      if (response.statusCode == 200) {
        debugPrintLevels(10, 'Data get from CouchDB successfully!');
        codeState = response.statusCode;

        var responseBody = utf8.decode(response.bodyBytes);
        state = getListaPropertyListModelFromMap(responseBody);
      } else {
        state = GetListaPropertyListModel(totalRows: 0, offset: 0, rows: []);
        codeState = response.statusCode;
        debugPrintLevels(10, 'Error reading data: ${response.statusCode}');
      }
    } catch (e) {
      debugPrintLevels(1, 'Exception in getListaPropiedad: $e');
      codeState = 500;
    }

    return codeState;
  }

  // ---------------------------------------------------------------------------
  // 2. ALTA DE DUPLA LISTA-PROPIEDAD
  // ---------------------------------------------------------------------------
  Future<bool> addPropiedadALista({
    required String listaId,
    required String propertyId,
    required String userId,
    required String tipoDeEspacio,
  }) async {
    debugPrintLevels(10, 'HTTP addPropiedadALista');

    try {
      String relacionId = _uuid.v4();
      String timestamp = DateTime.now().toIso8601String();

      final nuevaRelacion = Listapropiedad(
        listapropiedadId: relacionId,
        userId: userId,
        listaId: listaId,
        propertyId: propertyId,
        tipodeespacio: tipoDeEspacio,
        type: "lista_propiedad_item",
        timestamp: timestamp,
      );

      final dataModel = ListaPropertyListModel(listapropiedad: nuevaRelacion);
      final bodyJson = listaPropertyListModelToMap(dataModel);

      // Usamos la DB de relaciones
      String url = '$direccionip/buscobien_listas_propiedades';

      final response = await http.post(
        Uri.parse(url),
        headers: _headers,
        body: bodyJson,
      );

      if (response.statusCode == 201) {
        debugPrintLevels(10, 'Propiedad agregada exitosamente.');
        return true;
      } else {
        debugPrintLevels(1, 'Error al agregar: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      debugPrintLevels(1, 'Excepción en addPropiedadALista: $e');
      return false;
    }
  }

  // ---------------------------------------------------------------------------
  // 3. BORRAR PROPIEDAD POR LISTA + PROPIEDAD ID (Función existente mejorada)
  // ---------------------------------------------------------------------------
  Future<bool> borrarPropiedadDeLista({
    required String listaId,
    required String propertyId,
  }) async {
    debugPrintLevels(10, 'HTTP borrarPropiedadDeLista (Búsqueda)');

    try {
      // 1. Buscamos el documento por la combinación de IDs
      String findUrl = '$direccionip/buscobien_listas_propiedades/_find';
      final findBody = jsonEncode({
        "selector": {
          "listapropiedad.listaId":
              listaId, // Corrección camelCase según modelo
          "listapropiedad.propertyId": propertyId,
        },
        "limit": 1,
      });

      final findResponse = await http.post(
        Uri.parse(findUrl),
        headers: _headers,
        body: findBody,
      );

      if (findResponse.statusCode != 200) return false;

      final findData = jsonDecode(utf8.decode(findResponse.bodyBytes));
      List docs = findData['docs'];

      if (docs.isEmpty) return false;

      // 2. Obtenemos ID y Rev para borrar
      String docId = docs[0]['_id'];
      String docRev = docs[0]['_rev'];

      return await _ejecutarBorrado(docId, docRev);
    } catch (e) {
      debugPrintLevels(1, 'Excepción en borrarPropiedadDeLista: $e');
      return false;
    }
  }

  // ---------------------------------------------------------------------------
  // 4. NUEVA FUNCIONALIDAD: BORRAR POR ID DE DOCUMENTO (listapropiedadId)
  // ---------------------------------------------------------------------------
  // Permite borrar directamente si ya conocemos el ID del documento de relación
  // (útil si estamos listando las relaciones y tenemos el objeto RowListaProperty).
  Future<bool> borrarListapropiedadPorId(String listapropiedadId) async {
    debugPrintLevels(10, 'HTTP borrarListapropiedadPorId: $listapropiedadId');

    try {
      // Paso 1: Necesitamos el _rev actual. Consultamos el documento por ID.
      // En CouchDB, el listapropiedadId que generamos (UUID) podría ser el _id
      // si lo asignamos al crear, o estar dentro del body.
      // Asumiremos que al crear NO asignamos el _id manualmente igual al UUID,
      // por lo que debemos buscarlo. Si lo asignaste como _id, usa GET directo.

      // Opción A: Búsqueda por selector (más segura si listapropiedadId es un campo interno)
      String findUrl = '$direccionip/buscobien_listas_propiedades/_find';
      final findBody = jsonEncode({
        "selector": {"listapropiedad.listapropiedadId": listapropiedadId},
        "limit": 1,
      });

      final findResponse = await http.post(
        Uri.parse(findUrl),
        headers: _headers,
        body: findBody,
      );

      if (findResponse.statusCode != 200) return false;

      final findData = jsonDecode(utf8.decode(findResponse.bodyBytes));
      List docs = findData['docs'];

      if (docs.isEmpty) {
        debugPrintLevels(1, 'Documento no encontrado para borrar.');
        return false;
      }

      String docId = docs[0]['_id'];
      String docRev = docs[0]['_rev'];

      return await _ejecutarBorrado(docId, docRev);
    } catch (e) {
      debugPrintLevels(1, 'Excepción en borrarListapropiedadPorId: $e');
      return false;
    }
  }

  // Método auxiliar privado para no repetir lógica de borrado
  Future<bool> _ejecutarBorrado(String docId, String docRev) async {
    String deleteUrl =
        '$direccionip/buscobien_listas_propiedades/$docId';

    final deleteResponse = await http.put(
      Uri.parse(deleteUrl),
      headers: _headers,
      body: jsonEncode({
        '_id': docId,
        '_rev': docRev,
        '_deleted': true,
      }),
    );

    if (deleteResponse.statusCode == 200 || deleteResponse.statusCode == 201 || deleteResponse.statusCode == 202) {
      debugPrintLevels(10, 'Documento eliminado.');

      // Optimización: Actualizar estado local para UI reactiva
      if (state.rows.isNotEmpty) {
        final updatedRows = state.rows.where((row) => row.id != docId).toList();
        state = GetListaPropertyListModel(
          totalRows: updatedRows.length,
          offset: state.offset,
          rows: updatedRows,
        );
      }
      return true;
    }
    return false;
  }

  // ---------------------------------------------------------------------------
  // 5. NUEVA FUNCIONALIDAD: OBTENER DATOS COMPLETOS DE PROPIEDADES
  // ---------------------------------------------------------------------------
  // Obtiene los detalles completos (fotos, precios) de la base de datos de
  // propiedades basándose en el listaId proporcionado.
  Future<List<Map<String, dynamic>>> getPropiedadesDetallesPorListaId(
    String listaId,
  ) async {
    debugPrintLevels(
      10,
      'HTTP getPropiedadesDetallesPorListaId para Lista: $listaId',
    );
    List<Map<String, dynamic>> propiedadesCompletas = [];

    try {
      // Paso 1: Obtener los IDs de las propiedades en esta lista
      // Reutilizamos la lógica de consulta de IDs
      String urlIds =
          '$direccionip/buscobien_listas_propiedades/_design/DDLOCAL/_view/vistaListaID?key="$listaId"';
      final responseIds = await http.get(Uri.parse(urlIds), headers: _headers);

      if (responseIds.statusCode != 200) {
        debugPrintLevels(1, 'Error obteniendo IDs de lista');
        return [];
      }

      var dataIds = getListaPropertyListModelFromMap(
        utf8.decode(responseIds.bodyBytes),
      );

      // Extraemos la lista de IDs de propiedades (propertyId)
      List<String> idsPropiedades = dataIds.rows
          .map((row) => row.listapropiedad.propertyId)
          .toList();

      if (idsPropiedades.isEmpty) return [];

      // Paso 2: Consulta masiva (Bulk Fetch) a la base de datos de PROPIEDADES
      // Usamos el operador $in de CouchDB Mango Query para traerlas todas en 1 request

      String urlProps =
          '$direccionip/buscobien_propiedades/_find'; // Ajusta el nombre de tu DB de propiedades

      final bodyProps = jsonEncode({
        "selector": {
          "_id": {"\$in": idsPropiedades},
        },
        "limit": idsPropiedades.length,
      });

      final responseProps = await http.post(
        Uri.parse(urlProps),
        headers: _headers,
        body: bodyProps,
      );

      if (responseProps.statusCode == 200) {
        var jsonProps = jsonDecode(utf8.decode(responseProps.bodyBytes));
        List<dynamic> docs = jsonProps['docs'];

        // Convertimos a una lista de Mapas para que la UI la consuma
        propiedadesCompletas = docs.cast<Map<String, dynamic>>();

        debugPrintLevels(
          10,
          'Recuperadas ${propiedadesCompletas.length} propiedades completas.',
        );
      } else {
        debugPrintLevels(
          1,
          'Error recuperando detalles de propiedades: ${responseProps.statusCode}',
        );
      }
    } catch (e) {
      debugPrintLevels(1, 'Excepción en getPropiedadesDetallesPorListaId: $e');
    }

    return propiedadesCompletas;
  }
}
