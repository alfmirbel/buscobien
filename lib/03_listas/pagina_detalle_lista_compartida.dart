import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../08_pantallas/inicio/data_espacios_casas_get.dart';
import '../08_pantallas/inicio/widget_wrap_modern_card.dart';
import '../08_pantallas/tu_cuenta/tus_espacios/provider_espacios_casa_get.dart';
import '../20_var_globales/var_color_themes.dart';
import '../40_security/urls_endpoints_espacios.dart';
import '../60_global_widgets/debugprint.dart';
import 'models/lista_compartida_model.dart';
import 'provider_listas_compartidas.dart';

class PageDetalleListaCompartida extends ConsumerStatefulWidget {
  final ListaCompartidaModel listaCompartida;

  const PageDetalleListaCompartida(this.listaCompartida, {super.key});

  @override
  ConsumerState<PageDetalleListaCompartida> createState() =>
      _PageDetalleListaCompartidaState();
}

class _PageDetalleListaCompartidaState
    extends ConsumerState<PageDetalleListaCompartida> {
  late Future<List<Map<String, dynamic>>> _propsFuture;

  @override
  void initState() {
    super.initState();
    _propsFuture = ref
        .read(listasCompartidasProvider.notifier)
        .fetchPropiedadesListaCompartida(widget.listaCompartida.id);
  }

  Future<EspaciosCasaGet> _getPropiedad(
    String propertyId,
    String tipodeespacio,
  ) async {
    if (tipodeespacio.isNotEmpty) {
      return ref
          .read(espaciosCasaConListaFotosGetProvider.notifier)
          .getPropiedadCasaIdPropiedad(
            propertyId,
            tipodeespacio,
            endpointsPublicados,
          );
    }
    // Fallback: intenta todos los endpoints hasta encontrar la propiedad
    for (final tipo in endpointsPublicados.keys) {
      final resultado = await ref
          .read(espaciosCasaConListaFotosGetProvider.notifier)
          .getPropiedadCasaIdPropiedad(propertyId, tipo, endpointsPublicados);
      if (resultado.rows.isNotEmpty) return resultado;
    }
    return EspaciosCasaGet(totalRows: 0, offset: 0, rows: []);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme.surface,
      appBar: AppBar(
        toolbarHeight: 50.0, // Altura estándar recomendada
        centerTitle: true,
        backgroundColor: appTheme.primary,
        iconTheme: IconThemeData(color: appTheme.onPrimary),
        title: Text(
          widget.listaCompartida.listaNombre,
          style: TextStyle(
            color: appTheme.onPrimary,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _propsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error al cargar: ${snapshot.error}',
                style: TextStyle(color: appTheme.error),
              ),
            );
          }

          final props = snapshot.data ?? [];
          if (props.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Symbols.folder_open,
                    size: 80,
                    color: appTheme.primary.withValues(alpha: 0.5),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    'Esta lista no tiene propiedades.',
                    style: TextStyle(
                      color: appTheme.primary,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: props.length,
            separatorBuilder: (_, __) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final prop = props[index];
              final propertyId = prop['propertyId'] as String? ?? '';
              final tipodeespacio = prop['tipodeespacio'] as String? ?? '';

              debugPrintLevels(
                12,
                'DetalleListaCompartida [$index] propertyId=$propertyId tipo=$tipodeespacio',
              );

              return FutureBuilder<EspaciosCasaGet>(
                future: _getPropiedad(propertyId, tipodeespacio),
                builder: (context, snap) {
                  if (snap.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snap.data == null || snap.data!.rows.isEmpty) {
                    return Center(
                      child: Text(
                        'No se encontró la propiedad.',
                        style: TextStyle(color: appTheme.onSurfaceVariant),
                      ),
                    );
                  }
                  return Center(
                    child: WrapModernCardPropiedades(0, snap.data!),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
