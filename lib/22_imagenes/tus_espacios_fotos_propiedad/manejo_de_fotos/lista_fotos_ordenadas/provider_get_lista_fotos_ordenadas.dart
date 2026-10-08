import 'dart:core';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../60_global_widgets/debugprint.dart';
import '../../../data_models/data_fotos_ordenadas.dart';
import 'data_fotos_ordenadas_get_idpropiedad.dart';
import '../futures_y_providers/provider_get_fotos_ids_user_propiedad.dart';

//----------------------------------------------------------------------------
// OPTIMIZADO

final getListaFotosOrdenadasProvider =
    NotifierProvider<
      ClassListaFotosCasaNotifierProvider,
      ListaFotosOrdenadasGetIdPropiedad
    >(() {
      return ClassListaFotosCasaNotifierProvider();
    });

class ClassListaFotosCasaNotifierProvider
    extends Notifier<ListaFotosOrdenadasGetIdPropiedad> {
  // VALOR INICIAL
  @override
  ListaFotosOrdenadasGetIdPropiedad build() {
    return ListaFotosOrdenadasGetIdPropiedad(totalRows: 0, offset: 0, rows: []);
  }

  //------------------------------------------------------------------------------
  // LIMPIAR ESTADO
  //------------------------------------------------------------------------------
  void clearFotoListaPosiciones() {
    // Correcto: Reemplazar el estado con un objeto nuevo vacío
    state = ListaFotosOrdenadasGetIdPropiedad(
      totalRows: 0,
      offset: 0,
      rows: [],
    );
  }

  //------------------------------------------------------------------------------
  // ESTABLECER ESTADO COMPLETO
  //------------------------------------------------------------------------------
  void setFotoListaPosiciones(ListaFotosOrdenadasGetIdPropiedad lista) {
    debugPrintLevels(
      7,
      'setFotoListaPosiciones LISTA NO FOTOS: ${lista.rows[0].value.listadefotos.fotosOrden.length}.',
    );
    state = lista;
    debugPrintLevels(
      7,
      'setFotoListaPosiciones STATE NO FOTOS: ${state.rows[0].value.listadefotos.fotosOrden.length}.',
    );
  }

  //------------------------------------------------------------------------------
  // AGREGAR FOTO A LA LISTA DE POSICIONES
  //------------------------------------------------------------------------------
  void agregaFotoListaPosiciones() {
    // 1. Validaciones de seguridad
    if (state.rows.isEmpty) {
      // Si no hay lista de orden creada, no podemos agregar una posición a nada.
      // Aquí podrías decidir crear una estructura inicial si fuera necesario.
      return;
    }

    final fotosProvider = ref.read(getListaFotosCasaProviderId);
    if (fotosProvider.rows.isEmpty) {
      return; // No hay fotos reales para referenciar
    }

    // 2. Obtener la última foto agregada (la que queremos posicionar)
    final ultimaFoto = fotosProvider.rows.last.value.fotosCasa;

    // 3. Crear copias para inmutabilidad (Deep Copy parcial necesaria)
    // Copiamos la lista de filas del estado actual
    final newRows = List<RowGetIdPropiedad>.from(state.rows);

    // Obtenemos la primera fila (asumiendo que es la lista de orden activa)
    final activeRow = newRows[0];

    // Copiamos la lista interna de fotosOrden
    final newFotosOrden = List<FotosOrden>.from(
      activeRow.value.listadefotos.fotosOrden,
    );

    // 4. Agregar la nueva foto al orden
    newFotosOrden.add(
      FotosOrden(
        posicion: fotosProvider.rows.length, // O newFotosOrden.length + 1
        idFoto: ultimaFoto.idFoto,
      ),
    );

    // 5. Reconstruir la estructura anidada (Si los modelos no tienen copyWith, asignamos manualmente)
    // Nota: Esto es necesario porque Riverpod compara referencias de objetos.

    // Actualizamos la lista de orden dentro de la estructura
    activeRow.value.listadefotos.fotosOrden = newFotosOrden;

    // (Opcional) Actualizar timestamp si el modelo lo permite
    // activeRow.value.listadefotos.timestamp = DateTime.now().toString();

    // 6. Emitir nuevo estado
    state = ListaFotosOrdenadasGetIdPropiedad(
      totalRows: state.totalRows,
      offset: state.offset,
      rows: newRows,
    );
  }
}

//----------------------------------------------------------------------------
