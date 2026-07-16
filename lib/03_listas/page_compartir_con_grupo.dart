import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:buscobien/20_var_globales/var_color_themes.dart';
import 'package:buscobien/60_global_widgets/debugprint.dart';
import 'package:buscobien/08_pantallas/tu_cuenta/grupos/providers/grupos_notifier.dart';
import 'package:buscobien/08_pantallas/tu_cuenta/grupos/providers/publicaciones_grupo_provider.dart';
import 'package:buscobien/08_pantallas/tu_cuenta/grupos/providers/grupos_mensajes_provider.dart';

// Pantalla secundaria: selecciona grupos y comparte una propiedad.
// Envía un mensaje de tipo "propiedad" al chat grupal y registra la publicación.
class PageCompartirConGrupo extends ConsumerStatefulWidget {
  final String propiedadId;
  final String propiedadNombre;
  final String tipodeespacio;
  final String currentUserId;
  final String currentUserName;

  const PageCompartirConGrupo({
    super.key,
    required this.propiedadId,
    required this.propiedadNombre,
    required this.tipodeespacio,
    required this.currentUserId,
    required this.currentUserName,
  });

  @override
  ConsumerState<PageCompartirConGrupo> createState() =>
      _PageCompartirConGrupoState();
}

class _PageCompartirConGrupoState extends ConsumerState<PageCompartirConGrupo> {
  final Set<String> _seleccionados = {};
  bool _enviando = false;

  @override
  Widget build(BuildContext context) {
    final asyncGrupos = ref.watch(gruposProvider);

    return Scaffold(
      backgroundColor: appTheme.surface,
      appBar: AppBar(
        backgroundColor: appTheme.primary,
        foregroundColor: appTheme.onPrimary,
        title: Text(
          'Compartir con grupo',
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
      body: asyncGrupos.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error al cargar grupos: $e')),
        data: (grupos) {
          if (grupos.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Text(
                  'No perteneces a ningún grupo todavía.',
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
                  'Selecciona los grupos donde quieres compartir:',
                  style: TextStyle(
                    color: appTheme.onSurface,
                    fontSize: 13,
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: grupos.length,
                  itemBuilder: (context, index) {
                    final grupo = grupos[index];
                    final seleccionado = _seleccionados.contains(grupo.id);
                    return CheckboxListTile(
                      value: seleccionado,
                      onChanged: (v) {
                        setState(() {
                          if (v == true) {
                            _seleccionados.add(grupo.id);
                          } else {
                            _seleccionados.remove(grupo.id);
                          }
                        });
                      },
                      title: Text(
                        grupo.nombre,
                        style: TextStyle(
                          color: appTheme.onSurface,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      subtitle: grupo.descripcion.isNotEmpty
                          ? Text(
                              grupo.descripcion,
                              style: TextStyle(
                                color: appTheme.onSurfaceVariant,
                                fontSize: 12,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            )
                          : null,
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

  Future<void> _compartir() async {
    if (_seleccionados.isEmpty) return;
    setState(() => _enviando = true);

    final grupos = ref.read(gruposProvider).value ?? [];
    int exitosos = 0;

    for (final grupoId in _seleccionados) {
      final grupo = grupos.firstWhere(
        (g) => g.id == grupoId,
        orElse: () => grupos.first,
      );

      // Registrar publicación en la base de propiedades del grupo
      final pubOk = await ref
          .read(publicacionesGrupoProvider(grupoId).notifier)
          .compartirPropiedad(
            propiedadId: widget.propiedadId,
            propiedadNombre: widget.propiedadNombre,
            tipodeespacio: widget.tipodeespacio,
            autorId: widget.currentUserId,
            autorNombre: widget.currentUserName,
          );

      // Enviar mensaje al chat del grupo
      await ref.read(mensajesGrupoProvider(grupoId).notifier).enviar(
        senderId: widget.currentUserId,
        senderName: widget.currentUserName,
        content: widget.propiedadNombre,
        tipo: 'propiedad',
        propiedadId: widget.propiedadId,
      );

      if (pubOk) exitosos++;
      debugPrintLevels(2, 'Compartido en ${grupo.nombre}: pubOk=$pubOk');
    }

    if (!mounted) return;
    setState(() => _enviando = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          exitosos > 0
              ? 'Propiedad compartida en $exitosos grupo${exitosos > 1 ? 's' : ''}'
              : 'No se pudo compartir en los grupos seleccionados',
        ),
        backgroundColor:
            exitosos > 0 ? appTheme.primary : appTheme.error,
      ),
    );

    if (exitosos > 0) Navigator.of(context).pop();
  }
}
