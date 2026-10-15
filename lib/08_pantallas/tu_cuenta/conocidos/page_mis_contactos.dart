import 'package:flutter/material.dart';
import 'package:buscobien/60_global_widgets/async_value_widget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../20_var_globales/var_color_themes.dart';
import 'providers/conocidos_notifier.dart';
import 'page_chat_privado.dart';
import 'page_perfil_contacto.dart';

class PageMisContactos extends ConsumerStatefulWidget {
  final String currentUserId;
  const PageMisContactos({super.key, required this.currentUserId});

  @override
  ConsumerState<PageMisContactos> createState() => _PageMisContactosState();
}

class _PageMisContactosState extends ConsumerState<PageMisContactos> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(conocidosProvider.notifier).cargar(widget.currentUserId);
    });
  }

  Future<void> _confirmarEliminar(String documentoId, String nombre) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Eliminar contacto'),
        content: Text('¿Eliminar a $nombre de tus contactos?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
    if (confirmar != true || !mounted) return;

    final ok = await ref
        .read(conocidosProvider.notifier)
        .eliminarContacto(documentoId);
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: ok ? appTheme.primary : appTheme.error,
        content: Text(
          ok
              ? '$nombre ya no está en tus contactos.'
              : 'No se pudo eliminar el contacto. Inténtalo de nuevo.',
          style: TextStyle(color: ok ? appTheme.onPrimary : appTheme.onError),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final asyncContactos = ref.watch(
      conocidosAceptadosProvider(widget.currentUserId),
    );

    return Scaffold(
      backgroundColor: appTheme.surface,
      //appBar: appBarSecondPage("Mis Contactos"),
      body: AsyncValueWidget(
        value: asyncContactos,
        mensajeError: 'Error al cargar contactos',
        onReintentar: () => ref.read(conocidosProvider.notifier).cargar(widget.currentUserId),
        data: (contactos) {
          if (contactos.isEmpty) {
            return const Center(
              child: Text("Aún no tienes contactos confirmados."),
            );
          }
          return RefreshIndicator(
            onRefresh: () => ref
                .read(conocidosProvider.notifier)
                .cargar(widget.currentUserId),
            child: ListView.builder(
              itemCount: contactos.length,
              itemBuilder: (context, index) {
                final inv = contactos[index];
                final isSender = inv.solicitanteId == widget.currentUserId;
                final targetId = isSender ? inv.receptorId : inv.solicitanteId;
                final targetName =
                    isSender ? inv.receptorNombre : inv.solicitanteNombre;

                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 6,
                  ),
                  color: appTheme.surface,
                  elevation: 1,
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: appTheme.secondary,
                      foregroundColor: appTheme.onSecondary,
                      child: Text(targetName.isNotEmpty ? targetName[0] : '?'),
                    ),
                    title: Text(
                      targetName,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: appTheme.onSurface,
                      ),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(tooltip: 'Buscar usuarios', 
                          icon: Icon(
                            Symbols.person_search,
                            color: appTheme.primary,
                          ),
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => PagePerfilContacto(
                                contactoId: targetId,
                                contactoName: targetName,
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                          tooltip: 'Eliminar contacto',
                          icon: Icon(
                            Symbols.person_remove,
                            color: appTheme.error,
                          ),
                          onPressed: () =>
                              _confirmarEliminar(inv.id, targetName),
                        ),
                        IconButton(tooltip: 'Abrir chat', 
                          icon: Icon(Symbols.chat, color: appTheme.primary),
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => PageChatPrivado(
                                currentUserId: widget.currentUserId,
                                targetUserId: targetId,
                                targetName: targetName,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
