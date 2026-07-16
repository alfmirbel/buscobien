import 'dart:core';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../60_global_widgets/debugprint.dart';
import '../../../data_models/data_fotos_casa.dart';
import '../../../data_models/data_fotos_casa_get_ids.dart';

//------------------------------------------------------------------------------
// OPTIMIZADO

final getListaFotosCasaProviderId =
    NotifierProvider<ClassListaFotosCasaNotifierProvider, FotosCasaGetIDs>(() {
      return ClassListaFotosCasaNotifierProvider();
    });

class ClassListaFotosCasaNotifierProvider extends Notifier<FotosCasaGetIDs> {
  // initial value
  @override
  FotosCasaGetIDs build() {
    return FotosCasaGetIDs(totalRows: 0, offset: 0, rows: []);
  }

  //------------------------------------------------------------------------------

  // Reemplaza el estado completo. Correcto para Riverpod.
  void setListaDeFotosPropiedad(FotosCasaGetIDs listaFotos) {
    debugPrintLevels(7, "setListaDeFotosPropiedad");
    state = listaFotos;
  }

  int getLengthListaDeFotosPropiedad() {
    debugPrintLevels(7, "getLengthListaDeFotosPropiedad");
    return state.rows.length;
  }

  // OPTIMIZACIÓN: Lógica inmutable.
  void addEspacioVacioFotosProvider() {
    debugPrintLevels(7, "addEspacioVacioFotosEspacioProvider");

    // 1. Crear una copia de la lista actual
    final newRows = List<RowFotosCasaGetIDs>.from(state.rows);

    // 2. Agregar el nuevo elemento a la copia
    newRows.add(
      RowFotosCasaGetIDs(
        id: "",
        key: ["", ""],
        value: ValueFotosCasaGetIDs(
          id: "",
          rev: "",
          fotosCasa: FotosCasaClass(
            idFoto: "",
            idUsuario: "",
            idPropiedad: "",
            foto: "",
            filaname: "",
            path: "",
            size: 0,
            identifier: "",
            contentType: "",
            timestamp: "",
          ),
        ),
      ),
    );

    // 3. Reasignar el estado con un NUEVO objeto para notificar a los listeners
    state = FotosCasaGetIDs(
      totalRows: newRows.length, // Actualizamos el contador
      offset: state.offset,
      rows: newRows,
    );
  }

  // OPTIMIZACIÓN: Lógica inmutable.
  // Nota: 'ref' no se usa dentro, pero se mantiene para no romper llamadas externas.
  void addEspacioFotoListaDeFotosPropiedad(
    WidgetRef ref,
    FotosCasaClass fotosCasa,
  ) {
    debugPrintLevels(
      10,
      "**** addEspacioFotoListaDeFotosPropiedad START length: ${state.rows.length}",
    );

    // 1. Crear copia de la lista
    final newRows = List<RowFotosCasaGetIDs>.from(state.rows);

    // 2. Agregar el objeto
    newRows.add(
      RowFotosCasaGetIDs(
        id: "",
        key: ["", ""],
        value: ValueFotosCasaGetIDs(
          id: "",
          rev: "",
          fotosCasa: FotosCasaClass(
            idFoto: fotosCasa.idFoto,
            idUsuario: fotosCasa.idUsuario,
            idPropiedad: fotosCasa.idPropiedad,
            filaname: fotosCasa.filaname,
            path: fotosCasa.path,
            size: fotosCasa.size,
            identifier: fotosCasa.identifier,
            foto: fotosCasa.foto,
            contentType: fotosCasa.contentType,
            timestamp: fotosCasa.timestamp,
          ),
        ),
      ),
    );

    // 3. Actualizar estado y notificar UI
    state = FotosCasaGetIDs(
      totalRows: newRows.length,
      offset: state.offset,
      rows: newRows,
    );

    debugPrintLevels(
      10,
      "**** addEspacioFotoListaDeFotosPropiedad END length: ${state.rows.length}",
    );
  }

  //------------------------------------------------------------------------------
}

//------------------------------------------------------------------------------
/*

final getListaFotosCasaProviderId =
    NotifierProvider<ClassListaFotosCasaNotifierProvider, FotosCasaGetIDs>(() {
  return ClassListaFotosCasaNotifierProvider();
});

class ClassListaFotosCasaNotifierProvider extends Notifier<FotosCasaGetIDs> {
  // initial value
  @override
  FotosCasaGetIDs build() {
    return FotosCasaGetIDs(
      totalRows: 0,
      offset: 0,
      rows: [
        /*
        RowFotosCasaGetIDs(
          id: "",
          key: ["", ""],
          value: ValueFotosCasaGetIDs(
            id: "",
            rev: "",
            fotosCasa: FotosCasaClass(
              idFoto: "", // hash
              idUsuario: "", // hash
              idPropiedad: "", // hash
              foto: "",
              filaname: "",
              path: "",
              size: 0,
              identifier: "",
              contentType: "",
              timestamp: "",
            ),
          ),
        )
        */
      ],
    );
  }

  //------------------------------------------------------------------------------

  void setListaDeFotosPropiedad(FotosCasaGetIDs listaFotos) {
    debugPrintLevels(7, "setListaDeFotosPropiedad");
    state = listaFotos;
  }

  int getLengthListaDeFotosPropiedad() {
    debugPrintLevels(7, "getLengthListaDeFotosPropiedad");
    return state.rows.length;
  }

  void addEspacioVacioFotosProvider() {
    debugPrintLevels(7, "addEspacioVacioFotosEspacioProvider");
    state.rows.add(
      RowFotosCasaGetIDs(
        id: "",
        key: ["", ""],
        value: ValueFotosCasaGetIDs(
          id: "",
          rev: "",
          fotosCasa: FotosCasaClass(
            idFoto: "", // hash
            idUsuario: "", // hash
            idPropiedad: "", // hash
            foto: "",
            filaname: "",
            path: "",
            size: 0,
            identifier: "",
            contentType: "",
            timestamp: "",
          ),
        ),
      ),
    );
  }

  void addEspacioFotoListaDeFotosPropiedad(
      WidgetRef ref, FotosCasaClass fotosCasa) {
    /*if (state.rows.length < index) {
       int numfotos = index - state.rows.length;
      for (var i = 0; i < numfotos; i++) {
        */
    debugPrintLevels(10,
        "**** addEspacioFotoListaDeFotosPropiedad state.rows.length: ${state.rows.length}");
    state.rows.add(
      RowFotosCasaGetIDs(
        id: "",
        key: ["", ""],
        value: ValueFotosCasaGetIDs(
          id: "",
          rev: "",
          fotosCasa: FotosCasaClass(
            idFoto: fotosCasa.idFoto, // hash
            idUsuario: fotosCasa.idUsuario, // hash
            idPropiedad: fotosCasa.idPropiedad, // hash
            filaname: fotosCasa.filaname,
            path: fotosCasa.path,
            size: fotosCasa.size,
            identifier: fotosCasa.identifier,
            foto: fotosCasa.foto,
            contentType: fotosCasa.contentType,
            timestamp: fotosCasa.timestamp,
          ),
        ),
      ),
    );
    debugPrintLevels(10,
        "**** addEspacioFotoListaDeFotosPropiedad state.rows.length: ${state.rows.length}");
    // }
    //}
/*
    state.rows[state.rows.length].value.fotosCasa.idFoto = fotosCasa.idFoto;
    state.rows[state.rows.length].value.fotosCasa.idUsuario =
        fotosCasa.idUsuario;
    state.rows[state.rows.length].value.fotosCasa.idPropiedad =
        fotosCasa.idPropiedad;

    state.rows[state.rows.length].value.fotosCasa.filaname = fotosCasa.filaname;
    state.rows[state.rows.length].value.fotosCasa.path = fotosCasa.path;
    state.rows[state.rows.length].value.fotosCasa.size = fotosCasa.size;
    state.rows[state.rows.length].value.fotosCasa.identifier =
        fotosCasa.identifier;
    state.rows[state.rows.length].value.fotosCasa.foto = fotosCasa.foto;

    state.rows[state.rows.length].value.fotosCasa.contentType =
        fotosCasa.contentType;
    state.rows[state.rows.length].value.fotosCasa.timestamp =
        fotosCasa.timestamp;
        */
  }

//------------------------------------------------------------------------------
}
*/
