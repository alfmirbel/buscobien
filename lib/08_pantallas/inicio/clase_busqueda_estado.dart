import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'clase_busqueda_estado.g.dart';

// Maneja la paginación (paramSkip)
@riverpod
class BusquedaPaginacion extends _$BusquedaPaginacion {
  @override
  int build() => 0;

  void setSkip(int value) => state = value;
  void reset() => state = 0;
}

// Opcional: Si quieres que el término de búsqueda sea reactivo
@riverpod
class SearchTerm extends _$SearchTerm {
  @override
  String build() => "";
  void update(String value) => state = value;
}
