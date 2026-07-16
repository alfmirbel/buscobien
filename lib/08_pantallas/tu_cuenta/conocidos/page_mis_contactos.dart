import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context) {
    final asyncContactos = ref.watch(
      conocidosAceptadosProvider(widget.currentUserId),
    );

    return Scaffold(
      backgroundColor: appTheme.surface,
      //appBar: appBarSecondPage("Mis Contactos"),
      body: asyncContactos.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Symbols.cloud_off, size: 48, color: appTheme.error),
              const SizedBox(height: 12),
              Text(
                'Error al cargar contactos',
                style: TextStyle(color: appTheme.error),
              ),
              const SizedBox(height: 8),
              FilledButton.tonal(
                onPressed: () => ref
                    .read(conocidosProvider.notifier)
                    .cargar(widget.currentUserId),
                child: const Text('Reintentar'),
              ),
            ],
          ),
        ),
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
                final targetName = isSender
                    ? inv.receptorNombre
                    : inv.solicitanteNombre;

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
                        IconButton(
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
