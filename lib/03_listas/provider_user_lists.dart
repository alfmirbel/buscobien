import 'dart:convert';
import 'dart:math';
import 'package:buscobien/40_security/generate_hash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../40_security/direccionip.dart';
import '../60_global_widgets/debugprint.dart';
import 'data_user_list_model.dart';
import 'data_user_list_model_get.dart';

// Importa tus modelos y variables globales aquí
// import '../20_var_globales/var_globales.dart';

// -----------------------------------------------------------------------------
// STATE: Lista de Listas del Usuario
// -----------------------------------------------------------------------------

final userListsProvider =
    NotifierProvider<UserListsNotifier, GetUserPropertyListModel>(() {
      return UserListsNotifier();
    });

class UserListsNotifier extends Notifier<GetUserPropertyListModel> {
  // initial value
  @override
  GetUserPropertyListModel build() {
    return GetUserPropertyListModel(totalRows: 0, offset: 0, rows: []);
  }

  // Headers de Autenticación CouchDB

  // ---------------------------------------------------------------------------
  // 1. OBTENER LISTAS DEL USUARIO
  // ---------------------------------------------------------------------------
  Future<int> fetchUserLists(String userId) async {
    debugPrintLevels(10, "HTTP fetchUserLists: userId=$userId");

    int resultado = 0;
    try {
      String basicAuth =
          'Basic ${base64Encode(utf8.encode('$username:$password'))}';
      Map<String, String> headers = {
        'Authorization': basicAuth,
        'Content-Type': 'application/json',
      };

      String url =
          '$direccionip/buscobien_usuarios_listas/_design/DDUSER/_view/vistaUserID/?key="$userId"';
      debugPrintLevels(10, "HTTP fetchUserLists: url=$url");

      final response = await http.get(Uri.parse(url), headers: headers);

      /*
      // Usamos _find (Mango Query) para buscar por userId
      final url = Uri.parse('$direccionip/buscobien_usuarios_listas/_find');
      final body = jsonEncode({
        // "selector": {"userId": userId, "type": "user_property_list"},
        "selector": {"userId": userId},
      });
      final response = await http.post(url, headers: _headers, body: body);
      */
      resultado = response.statusCode;
      debugPrintLevels(10, "HTTP fetchUserLists: statusCode=$resultado");

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(utf8.decode(response.bodyBytes));
        debugPrintLevels(
          10,
          "HTTP fetchUserLists: responseBody = $responseBody",
        );

        GetUserPropertyListModel listas = GetUserPropertyListModel.fromMap(
          responseBody,
        );

        // Favoritas siempre al principio
        final rows = [...listas.rows];
        final favIndex = rows.indexWhere(
          (r) => r.value.listName == 'Favoritas',
        );
        if (favIndex > 0) {
          final fav = rows.removeAt(favIndex);
          rows.insert(0, fav);
          listas = GetUserPropertyListModel(
            totalRows: listas.totalRows,
            offset: listas.offset,
            rows: rows,
          );
        }

        debugPrintLevels(
          10,
          "HTTP listas: valor = ${listas.rows[0].value.listName}",
        );

        state = listas;
        /*
        final List<dynamic> rows = data['docs'];

        final lists = rows
            .map((e) => UserPropertyListModel.fromJson(e))
            .toList();
        state = AsyncValue.data(lists);
        */
      } else {
        state = GetUserPropertyListModel(totalRows: 0, offset: 0, rows: []);
        debugPrintLevels(10, "HTTP fetchUserLists: Error = $resultado");
      }
    } catch (e) {
      state = GetUserPropertyListModel(totalRows: 0, offset: 0, rows: []);
      debugPrintLevels(10, "HTTP fetchUserLists: catch Error=$e");
    }
    return resultado;
  }

  // ---------------------------------------------------------------------------
  // 2. CREAR NUEVA LISTA
  // ---------------------------------------------------------------------------
  Future<bool> createList(String userId, String listName) async {
    if (listName.length > 60) return false; // Validación longitud

    try {
      DateTime timeStamp = DateTime.now();
      //
      String idDeLaLista = generateSHA1Hash(
        listName + timeStamp.toString() + Random().nextInt(2500).toString(),
      );

      final newList = GetUserPropertyListModel(
        totalRows: 0,
        offset: 0,
        rows: [
          RowGetUserPropertyList(
            id: "",
            key: "",
            value: Lista(
              listaId: idDeLaLista,
              userId: userId,
              listName: listName,
              type: 'lista',
              timestamp: timeStamp.toString(),
            ),
          ),
        ],
      );

      final url = Uri.parse('$direccionip/buscobien_usuarios_listas');
      String basicAuth =
          'Basic ${base64Encode(utf8.encode('$username:$password'))}';
      Map<String, String> headers = {
        'Authorization': basicAuth,
        'Content-Type': 'application/json',
      };

      debugPrintLevels(10, "HTTP createList: url = $url");
      Map<String, dynamic> listanueva = (newList.rows[0].value).toMap();
      debugPrintLevels(10, "HTTP createList: listanueva = $listanueva");

      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(listanueva),
      );

      debugPrintLevels(
        10,
        "HTTP createList: statusCode = ${response.statusCode}",
      );

      if (response.statusCode == 201) {
        // Recargar listas para actualizar UI
        await fetchUserLists(userId);
        return true;
      }
      return false;
    } catch (e) {
      debugPrint("Error creando lista: $e");
      return false;
    }
  }

  // ---------------------------------------------------------------------------
  // 5. ELIMINAR LISTA
  // Obtiene el _rev internamente (GET previo) y refresca la UI al éxito.
  // ---------------------------------------------------------------------------
  Future<bool> deleteLista(String docId, String userId) async {
    try {
      debugPrintLevels(10, "Intentando borrar lista: docId=$docId");

      String basicAuth =
          'Basic ${base64Encode(utf8.encode('$username:$password'))}';
      Map<String, String> headers = {
        'Authorization': basicAuth,
        'Content-Type': 'application/json',
      };

      // GET para obtener el _rev actual del documento en CouchDB
      final docUrl = Uri.parse(
        '$direccionip/buscobien_usuarios_listas/$docId',
      );
      final getResponse = await http.get(docUrl, headers: headers);
      if (getResponse.statusCode != 200) {
        debugPrintLevels(
          10,
          "Error al obtener documento para borrar: ${getResponse.statusCode}",
        );
        return false;
      }
      final docData = jsonDecode(utf8.decode(getResponse.bodyBytes));
      final rev = docData['_rev'] as String?;
      if (rev == null) {
        debugPrintLevels(10, "No se encontró _rev en el documento");
        return false;
      }

      // PUT con _deleted: true (evita problemas de CORS con DELETE)
      final bodyJson = jsonEncode({
        '_id': docId,
        '_rev': rev,
        '_deleted': true,
      });
      final response = await http.put(docUrl, headers: headers, body: bodyJson);

      if (response.statusCode == 200 ||
          response.statusCode == 201 ||
          response.statusCode == 202) {
        debugPrint("Lista eliminada con éxito.");
        // Refresca la lista del usuario para que la UI refleje el borrado
        await fetchUserLists(userId);
        return true;
      } else {
        debugPrintLevels(
          10,
          "Error al eliminar: ${response.statusCode} - ${response.body}",
        );
        return false;
      }
    } catch (e) {
      debugPrintLevels(10, "Excepción al eliminar: $e");
      return false;
    }
  }
}

// -----------------------------------------------------------------------------
// PROVIDER AUXILIAR: TRAER DETALLES DE PROPIEDADES (Bulk Fetch simluado)
// -----------------------------------------------------------------------------
// Este provider recibe una lista de IDs y devuelve los objetos Propiedad completos
final propertiesDetailsProvider =
    FutureProvider.family<List<dynamic>, List<String>>((ref, ids) async {
      if (ids.isEmpty) return [];

      // Opción Optimizada: Usar _all_docs con keys o _find con operador $in
      // Aquí usamos _find con $in para obtener solo las necesarias
      final url = Uri.parse('$direccionip/buscobien_propiedades/_find');
      final body = jsonEncode({
        "selector": {
          "_id": {"\$in": ids},
        },
      });

      Map<String, String> headers = {
        'Authorization':
            'Basic ${base64Encode(utf8.encode('$username:$password'))}',
        'Content-Type': 'application/json',
      };

      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        // Retornamos la lista de documentos crudos (o mapeados a tu clase Propiedad)
        return data['docs'] as List<dynamic>;
      }
      return [];
    });
