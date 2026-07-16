import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:buscobien/20_var_globales/var_color_themes.dart';
import 'package:buscobien/60_global_widgets/debugprint.dart';
import 'package:buscobien/08_pantallas/tu_cuenta/conocidos/models/conocido.dart';
import 'package:buscobien/08_pantallas/tu_cuenta/conocidos/providers/conocidos_notifier.dart';
import 'package:buscobien/08_pantallas/tu_cuenta/conocidos/provider_mensajes.dart';
import 'package:buscobien/03_listas/provider_propiedades_compartidas_conocidos.dart';

// Pantalla secundaria: selecciona hasta 5 conocidos y comparte una propiedad.
// Envía un mensaje de tipo "propiedad" al chat privado y registra la compartición.
class PageCompartirConConocido extends ConsumerStatefulWidget {
  final String propiedadId;
  final String propiedadNombre;
  final String tipodeespacio;
  final String currentUserId;
  final String currentUserName;

  const PageCompartirConConocido({
    super.key,
    required this.propiedadId,
    required this.propiedadNombre,
    required this.tipodeespacio,
    required this.currentUserId,
    required this.currentUserName,
  });

  @override
  ConsumerState<PageCompartirConConocido> createState() =>
      _PageCompartirConConocidoState();
}

class _PageCompartirConConocidoState
    extends ConsumerState<PageCompartirConConocido> {
  final Set<String> _seleccionados = {}; // IDs de Conocido (doc id)
  bool _enviando = false;

  static const int _maxSeleccion = 5;

  @override
  Widget build(BuildContext context) {
    final asyncConocidos =
        ref.watch(conocidosAceptadosProvider(widget.currentUserId));

    return Scaffold(
      backgroundColor: appTheme.surface,
      appBar: AppBar(
        backgroundColor: appTheme.primary,
        foregroundColor: appTheme.onPrimary,
        title: Text(
          'Compartir con conocido',
          style: TextStyle(color: appTheme.onPrimary, fontSize: 16),
        ),
        actions: [
          if (_seleccionados.isNotEmpty)
            TextButton(
              onPressed: _enviando ? null : _compartir,
              child: _enviando
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: appTheme.onPrimary,
                      ),
                    )
                  : Text(
                      'Enviar',
                      style: TextStyle(
                        color: appTheme.onPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
        ],
      ),
      body: asyncConocidos.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) =>
            Center(child: Text('Error al cargar conocidos: $e')),
        data: (conocidos) {
          if (conocidos.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Text(
                  'Aún no tienes conocidos aceptados.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: appTheme.onSurfaceVariant),
                ),
              ),
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Text(
                  'Selecciona hasta $_maxSeleccion conocidos:',
                  style: TextStyle(
                    color: appTheme.onSurface,
                    fontSize: 13,
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: conocidos.length,
                  itemBuilder: (context, index) {
                    final conocido = conocidos[index];
                    final otroId = _otroId(conocido);
                    final otroNombre = _otroNombre(conocido);
                    final seleccionado = _seleccionados.contains(conocido.id);
                    final bloqueado =
                        !seleccionado && _seleccionados.length >= _maxSeleccion;

                    return CheckboxListTile(
                      value: seleccionado,
                      onChanged: bloqueado
                          ? null
                          : (v) {
                              setState(() {
                                if (v == true) {
                                  _seleccionados.add(conocido.id);
                                } else {
                                  _seleccionados.remove(conocido.id);
                                }
                              });
                            },
                      title: Text(
                        otroNombre,
                        style: TextStyle(
                          color: bloqueado
                              ? appTheme.onSurfaceVariant
                              : appTheme.onSurface,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      subtitle: Text(
                        otroId,
                        style: TextStyle(
                          color: appTheme.onSurfaceVariant,
                          fontSize: 11,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      activeColor: appTheme.primary,
                      checkColor: appTheme.onPrimary,
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  String _otroId(Conocido c) => c.solicitanteId == widget.currentUserId
      ? c.receptorId
      : c.solicitanteId;

  String _otroNombre(Conocido c) => c.solicitanteId == widget.currentUserId
      ? c.receptorNombre
      : c.solicitanteNombre;

  Future<void> _compartir() async {
    if (_seleccionados.isEmpty) return;
    setState(() => _enviando = true);

    final conocidos = ref
        .read(conocidosAceptadosProvider(widget.currentUserId))
        .value ?? [];

    int exitosos = 0;

    for (final docId in _seleccionados) {
      final conocido = conocidos.firstWhere(
        (c) => c.id == docId,
        orElse: () => conocidos.first,
      );
      final destinoId = _otroIdFromConocido(conocido);
      final destinoNombre = _otroNombreFromConocido(conocido);

      // Registrar en la DB de propiedades compartidas
      final ok = await ref
          .read(propiedadesCompartidasConocidosProvider.notifier)
          .compartirPropiedad(
            origenId: widget.currentUserId,
            origenNombre: widget.currentUserName,
            destinoId: destinoId,
            destinoNombre: destinoNombre,
            propiedadId: widget.propiedadId,
            propiedadNombre: widget.propiedadNombre,
            tipodeespacio: widget.tipodeespacio,
          );

      // Enviar mensaje al chat privado
      final chatKey = '${widget.currentUserId}@@$destinoId';
      await ref.read(mensajesChatProvider(chatKey).notifier).enviar(
        widget.propiedadNombre,
        tipo: 'propiedad',
        propiedadId: widget.propiedadId,
      );

      if (ok) exitosos++;
      debugPrintLevels(2, 'Compartido con $destinoNombre: ok=$ok');
    }

    if (!mounted) return;
    setState(() => _enviando = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          exitosos > 0
              ? 'Propiedad compartida con $exitosos conocido${exitosos > 1 ? 's' : ''}'
              : 'No se pudo compartir con los conocidos seleccionados',
        ),
        backgroundColor:
            exitosos > 0 ? appTheme.primary : appTheme.error,
      ),
    );

    if (exitosos > 0) Navigator.of(context).pop();
  }

  String _otroIdFromConocido(Conocido c) =>
      c.solicitanteId == widget.currentUserId ? c.receptorId : c.solicitanteId;

  String _otroNombreFromConocido(Conocido c) =>
      c.solicitanteId == widget.currentUserId
          ? c.receptorNombre
          : c.solicitanteNombre;
}
