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
/*
final getListaFotosOrdenadasProvider =
    NotifierProvider<
      ClassListaFotosCasaNotifierProvider,
      ListaFotosOrdenadasGetIdPropiedad
    >(() {
      return ClassListaFotosCasaNotifierProvider();
    });

class ClassListaFotosCasaNotifierProvider
    extends Notifier<ListaFotosOrdenadasGetIdPropiedad> {
  // initial value
  @override
  ListaFotosOrdenadasGetIdPropiedad build() {
    return ListaFotosOrdenadasGetIdPropiedad(
      totalRows: 0,
      offset: 0,
      rows: [
        /*
        RowGetIdPropiedad(
          id: '',
          key: '',
          value: ValueGetIdPropiedad(
            id: '',
            rev: '',
            listadefotos: ListaFotosOrdenadas(
              idListaFotos: '',
              idUsuario: '',
              idPropiedad: '',
              fotosOrden: [
                FotosOrden(
                  posicion: 0,
                  idFoto: "",
                ),
              ],
              timestamp: '',
            ),
          ),
        ),
      */
      ],
    );
  }

  //------------------------------------------------------------------------------
  void clearFotoListaPosiciones() {
    state.rows.clear();
    /*state = ListaFotosOrdenadasGetIdPropiedad(
      totalRows: 0,
      offset: 0,
      rows: [],
    );*/
  }

  void setFotoListaPosiciones(ListaFotosOrdenadasGetIdPropiedad lista) {
    state = lista;
  }

  //------------------------------------------------------------------------------
  void agregaFotoListaPosiciones() {
    if (state.rows.isNotEmpty) {
      state.rows[0].value.listadefotos.fotosOrden.add(
        FotosOrden(
          posicion: ref.read(getListaFotosCasaProviderId).rows.length,
          idFoto: ref
              .read(getListaFotosCasaProviderId)
              .rows
              .last
              .value
              .fotosCasa
              .idFoto,
        ),
      );
    }
  }

  //------------------------------------------------------------------------------
  /*
  Future<int> recuperaOrdenFotosIdUserIdProperty(
      String idUsuario, String idPropiedad) async {
    debugPrintLevels(7, "HTTP recuperaOrdenFotosIdUserIdProperty");
    ListaFotosIdsPropiedadGet listaOrdenFotos =
        ListaFotosIdsPropiedadGet(totalRows: 0, offset: 0, rows: []);
    clearFotoListaPosiciones();

    // Realizar la solicitud HTTP GET para recuperar el archivo adjunto
    int statusCode = 0;
    // URL de tu servidor CouchDB
    //DDLISTAFOTOS/_view/userproperty?
    //key=["...","..."]
    String baseUrl =
        '$direccionip/buscobien_fotos_ordenadas/_design/DDLISTAFOTOS/_view/userproperty?key=["$idUsuario", "$idPropiedad"]';
    debugPrintLevels(7,
        "recuperaOrdenFotosIdUserIdProperty URL DE LISTA FOTOS RECUPERADAS: $baseUrl");

    String basicAuth =
        'Basic ${base64Encode(utf8.encode('$username:$password'))}';

    Map<String, String> headers = {
      'Authorization': basicAuth,
      'Content-Type': "application/json", // tipo de contenido
    };

    var response = await http.get(Uri.parse(baseUrl), headers: headers);
    statusCode = response.statusCode;

    debugPrintLevels(7,
        "recuperaOrdenFotosIdUserIdProperty statusCode DE FOTOS USER PROP RECUPERADAS: $statusCode");

    if (response.statusCode == 200) {
      debugPrintLevels(6,
          "recuperaOrdenFotosIdUserIdProperty NUMERO DE LISTAS FOTOS RECUPERADAS: ${state.rows.length}");

      listaOrdenFotos =
          ListaFotosIdsPropiedadGet.fromJson(jsonDecode(response.body));

      // Decodificar el contenido del archivo recuperado
      // state = ListaFotosOrdenadasGetIdPropiedad
      state.rows[0].id = listaOrdenFotos.rows[0].id;
      state.rows[0].key = listaOrdenFotos.rows[0].key[1];

      state.totalRows = listaOrdenFotos.totalRows;
      state.offset = listaOrdenFotos.offset;
      for (int i = 0; i < listaOrdenFotos.rows.length; i++) {
        state.rows[0].value.listadefotos.idListaFotos = "";
        state.rows[0].value.listadefotos.idUsuario =
            listaOrdenFotos.rows[i].key[0];
        state.rows[0].value.listadefotos.idPropiedad =
            listaOrdenFotos.rows[i].key[1];
        state.rows[0].value.listadefotos.fotosOrden.add(FotosOrden(
            posicion: i, idFoto: listaOrdenFotos.rows[i].value.idFoto));
      }

      statusCode = response.statusCode;

      if (state.rows.isEmpty) {
        debugPrintLevels(
            7, 'recuperaOrdenFotosIdUserIdProperty Sin fotos en CouchDB.');
        statusCode = 500;
      } else {
        debugPrintLevels(7,
            'recuperaOrdenFotosIdUserIdProperty Archivos recuperado exitosamente de CouchDB.');
      }
    } else {
      debugPrintLevels(7,
          'recuperaOrdenFotosIdUserIdProperty Error al recuperar el archivo adjunto de CouchDB. Código de estado: ${response.statusCode}');
    }
    return response.statusCode;
  }
*/
  //------------------------------------------------------------------------------
  /*
  Future<int> recuperaFotosOrdenadasIdProperty(String idPropiedad) async {
    debugPrintLevels(7, "HTTP recuperaFotosOrdenadasIdProperty");
    // LIMPIA LISTA DE ORDEN DE FOTOS
    state.rows.clear();
    // Realizar la solicitud HTTP GET para recuperar lista de fotos
    int statusCode = 0;
    // URL de tu servidor CouchDB
    String baseUrl =
        '$direccionip/buscobien_fotos_ordenadas/_design/DDLISTAFOTOS/_view/idpropiedad?key="$idPropiedad"';
    debugPrintLevels(7, "recuperaFotosOrdenadasIdProperty URL DE: $baseUrl");

    String basicAuth =
        'Basic ${base64Encode(utf8.encode('$username:$password'))}';

    Map<String, String> headers = {
      'Authorization': basicAuth,
      'Content-Type': "application/json", // tipo de contenido
    };

    var response = await http.get(Uri.parse(baseUrl), headers: headers);
    statusCode = response.statusCode;
    debugPrintLevels(
        7, "recuperaFotosOrdenadasIdProperty statusCode: $statusCode");

    if (statusCode == 200) {
      // Decodificar el contenido del archivo recuperado
      debugPrintLevels(7,
          "recuperaFotosOrdenadasIdProperty response.body: ${response.body}");
      ListaFotosOrdenadasGetIdPropiedad resultado =
          ListaFotosOrdenadasGetIdPropiedad.fromJson(jsonDecode(response.body));
      debugPrintLevels(6,
          "recuperaFotosOrdenadasIdProperty FOTOS RECUPERADAS: ${resultado.rows.length}");
      if (resultado.rows.isEmpty) {
        debugPrintLevels(
            7, 'recuperaFotosOrdenadasIdProperty LISTA VACIA en CouchDB.');
        statusCode = 500;
      } else {
        state = resultado;
        debugPrintLevels(7,
            'recuperaFotosOrdenadasIdProperty LISTA ORDEN recuperada exitosamente de CouchDB.');
      }
    } else {
      debugPrintLevels(7,
          'recuperaFotosOrdenadasIdProperty Error. Código de estado: $statusCode');
    }
    return statusCode;
  }

//------------------------------------------------------------------------------

  Future<CouchDbReturnValue> guardaFotosOrdenadas(
      ListaFotosOrdenadas listaFotos) async {
    debugPrintLevels(7, "HTTP guardaFotosOrdenadas");

    // Realizar la solicitud HTTP GET para recuperar el archivo adjunto
    int statusCode = 0;
    // URL de tu servidor CouchDB
    String baseUrl = '$direccionip/buscobien_fotos_ordenadas';
    debugPrintLevels(7,
        "guardaFotosOrdenadasURL GUARDAR: $baseUrl: ${listaFotosOrdenadasToJson(listaFotos)}");

    listaFotos.timestamp = DateTime.now().toString();
    listaFotos.idListaFotos = generateSHA256Hash(listaFotos.idUsuario +
        listaFotos.idPropiedad +
        listaFotos.timestamp +
        Random().nextInt(999).toString());

    String basicAuth =
        'Basic ${base64Encode(utf8.encode('$username:$password'))}';

    Map<String, String> headers = {
      'Authorization': basicAuth,
      'Content-Type': "application/json", // tipo de contenido
    };

    String jsonContent = listaFotosOrdenadasToJson(listaFotos);
    jsonContent = '{"listadefotos": $jsonContent}';
    debugPrintLevels(7,
        "guardaFotosOrdenadas jsonContent DE GUARDA LISTA FOTOS : $jsonContent");

    // CREA NUEVO DOCUMENTO FOTO DE LA PROPIEDAD
    var response = await http.post(Uri.parse(baseUrl),
        headers: headers, body: jsonContent);

    CouchDbReturnValue returnValue = couchDbReturnValueFromJson(response.body);
    statusCode = response.statusCode;

    debugPrintLevels(7,
        "guardaFotosOrdenadas statusCode DE GUARDA LISTA FOTOS : $statusCode");

    if (statusCode == 201) {
      //   registroGuardado = fotosCasaFromJson(response.body);
      debugPrintLevels(9,
          '07 guardaFotosOrdenadas SE GUARDO EL  documento en CouchDB. Id: ${listaFotos.idListaFotos}');
    } else {
      debugPrintLevels(9,
          '09 guardaFotosOrdenadas Error al GUARDAR documento en CouchDB. Código de estado: $statusCode');
    }
    return returnValue;
  }

//------------------------------------------------------------------------------

  Future<int> actualizaFotosOrdenadas(ValueGetIdPropiedad listaFotos) async {
    debugPrintLevels(7, "HTTP actualizaFotosOrdenadas");

    // Realizar la solicitud HTTP GET para recuperar el archivo adjunto
    int statusCode = 0;
    // URL de tu servidor CouchDB
    String baseUrl = '$direccionip/buscobien_fotos_ordenadas';
    debugPrintLevels(7,
        "actualizaFotosOrdenadas GUARDAR: $baseUrl: ${listaFotosOrdenadasToJson(listaFotos.listadefotos)}");

    listaFotos.listadefotos.timestamp = DateTime.now().toString();
    listaFotos.listadefotos.idListaFotos = generateSHA256Hash(
        listaFotos.listadefotos.idUsuario +
            listaFotos.listadefotos.idPropiedad +
            listaFotos.listadefotos.timestamp +
            Random().nextInt(999).toString());

    String basicAuth =
        'Basic ${base64Encode(utf8.encode('$username:$password'))}';

    Map<String, String> headers = {
      'Authorization': basicAuth,
      'Content-Type': "application/json", // tipo de contenido
    };

    String jsonContent = jsonEncode(listaFotos);
    baseUrl = "$baseUrl/${listaFotos.id}";

    debugPrintLevels(7,
        "actualizaFotosOrdenadas jsonContent DE ACTUALIZA LISTA FOTOS : $jsonContent");

    // ACTUALIZA FOTO DE LA PROPIEDAD
    var response =
        await http.put(Uri.parse(baseUrl), headers: headers, body: jsonContent);
    debugPrintLevels(7,
        "actualizaFotosOrdenadas statusCode DE ACTUALIZA LISTA FOTOS : ${response.body}");
    statusCode = response.statusCode;
    //  CouchDbReturnValue returnValue = CouchDbReturnValue(ok: false, id: '', rev: '');
    // returnValue = couchDbReturnValueFromJson(response.body);

    debugPrintLevels(7,
        "actualizaFotosOrdenadas statusCode DE ACTUALIZA LISTA FOTOS : $statusCode");

    if (statusCode == 201) {
      //   registroGuardado = fotosCasaFromJson(response.body);
      debugPrintLevels(9,
          '07 actualizaFotosOrdenadas SE ACTUALIZO EL documento en CouchDB. Id: ${listaFotos.listadefotos}');
    } else {
      debugPrintLevels(9,
          '09 actualizaFotosOrdenadas Error al ACTUALIZAR documento en CouchDB. Código de estado: $statusCode');
    }
    return statusCode;
  }
*/
  //------------------------------------------------------------------------------
}
*/
