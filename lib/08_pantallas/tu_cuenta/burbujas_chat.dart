import 'package:flutter/material.dart';
import '../propiedades/buscar_propiedad.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:buscobien/20_var_globales/var_color_themes.dart';
import 'package:buscobien/22_imagenes/tus_espacios_fotos_propiedad/manejo_de_fotos/lista_ids_fotos/data_fotos_get_ids_fotos_user_prop.dart';
import 'package:buscobien/08_pantallas/propiedades/pagina_detalle_propiedad.dart';
import 'package:buscobien/03_listas/models/lista_compartida_model.dart';
import 'package:buscobien/03_listas/pagina_detalle_lista_compartida.dart';

// Burbujas de los mensajes de tipo «propiedad» y «lista» compartidas en un chat.
// Las usan el chat privado (conocidos) y el chat de grupo.

class BurbujaPropiedadChat extends StatelessWidget {
  final String propiedadId;
  final String nombre;

  const BurbujaPropiedadChat({
    required this.propiedadId,
    required this.nombre,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _verPropiedad(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Symbols.home,
                size: 14,
                color: appTheme.onSecondaryContainer,
              ),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  nombre,
                  style: TextStyle(
                    color: appTheme.onSecondaryContainer,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Toca para ver la ficha',
            style: TextStyle(
              color: appTheme.primary.withValues(alpha: 0.75),
              fontSize: 11,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _verPropiedad(BuildContext context) async {
    if (propiedadId.isEmpty) return;
    final propiedad = await buscarPropiedadPublicada(propiedadId);
    if (!context.mounted) return;
    if (propiedad == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Esta propiedad ya no está publicada.')),
      );
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PaginaDetalleWidget(
          propiedad,
          GetIdsFotosUserProp(totalRows: 0, offset: 0, rows: []),
        ),
      ),
    );
  }
}

class BurbujaListaChat extends StatelessWidget {
  final String listaCompartidaId;
  final String nombre;

  const BurbujaListaChat({
    required this.listaCompartidaId,
    required this.nombre,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _verLista(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Symbols.format_list_bulleted,
                size: 14,
                color: appTheme.onSecondaryContainer,
              ),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  nombre,
                  style: TextStyle(
                    color: appTheme.onSecondaryContainer,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Toca para ver las propiedades',
            style: TextStyle(
              color: appTheme.primary.withValues(alpha: 0.75),
              fontSize: 11,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  void _verLista(BuildContext context) {
    if (listaCompartidaId.isEmpty) return;
    final modelo = ListaCompartidaModel(
      id: listaCompartidaId,
      listaOrigenId: '',
      listaNombre: nombre,
      usuarioOrigenId: '',
      usuarioOrigenNombre: '',
      usuarioDestinoId: '',
      usuarioDestinoNombre: '',
      timestamp: '',
    );
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PageDetalleListaCompartida(modelo),
      ),
    );
  }
}
