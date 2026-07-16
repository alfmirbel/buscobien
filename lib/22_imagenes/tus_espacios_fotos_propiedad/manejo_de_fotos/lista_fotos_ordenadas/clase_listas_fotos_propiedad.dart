//------------------------------------------------------------------------------
import 'package:buscobien/22_imagenes/tus_espacios_fotos_propiedad/manejo_de_fotos/lista_ids_fotos/data_fotos_get_ids_fotos_user_prop.dart';

import 'data_fotos_ordenadas_get_idpropiedad.dart';

class ListasFotosPropiedad {
  late String idPropiedad;
  late List<ListaFotosOrdenadasGetIdPropiedad> listasfotosordenadas;
  late List<GetIdsFotosUserProp> listasidsfotos;

  ListasFotosPropiedad({
    required this.idPropiedad,
    required this.listasfotosordenadas,
    required this.listasidsfotos,
  });
}
