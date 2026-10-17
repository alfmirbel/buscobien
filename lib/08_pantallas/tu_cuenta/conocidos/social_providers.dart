import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../../../40_security/direccionip.dart';

// =============================================================================
// 3. PROVIDERS (LÓGICA DE NEGOCIO Y COUCHDB)
// =============================================================================

// Helper para Auth
Map<String, String> get _authHeaders => {
  'Authorization': 'Basic ${base64Encode(utf8.encode('$username:$password'))}',
  'Content-Type': 'application/json',
};

// --- A. PROVIDER DE USUARIOS (Simulado para listar usuarios a invitar) ---
final usersListProvider = FutureProvider<List<Map<String, dynamic>>>((
  ref,
) async {
  // Aquí llamas a tu vista de CouchDB que devuelve los usuarios registrados.
  // Ejemplo simplificado usando _find:
  final url = Uri.parse('$direccionip/buscobien_usuarios/_find');
  final body = jsonEncode({
    "selector": {
      "usuario.nombreusuario": {"\$exists": true},
    },
    "limit": 50,
  });

  final response = await http.post(url, headers: _authHeaders, body: body);
  if (response.statusCode == 200) {
    final data = jsonDecode(utf8.decode(response.bodyBytes));
    return List<Map<String, dynamic>>.from(data['docs']);
  }
  return [];
});

// --- A. PROVIDER DE USUARIOS (Simulado para listar usuarios a invitar) ---
final usersPromotoresListProvider = FutureProvider<List<Map<String, dynamic>>>((
  ref,
) async {
  // Aquí llamas a tu vista de CouchDB que devuelve los usuarios registrados.
  // Ejemplo simplificado usando _find:
  final url = Uri.parse('$direccionip/buscobien_usuarios_promotores/_find');
  final body = jsonEncode({
    "selector": {
      "usuario.nombreusuario": {"\$exists": true},
    },
    "limit": 50,
  });

  final response = await http.post(url, headers: _authHeaders, body: body);
  if (response.statusCode == 200) {
    final data = jsonDecode(utf8.decode(response.bodyBytes));
    return List<Map<String, dynamic>>.from(data['docs']);
  }
  return [];
});
