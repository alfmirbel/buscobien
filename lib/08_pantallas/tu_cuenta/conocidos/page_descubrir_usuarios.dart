import 'package:buscobien/60_global_widgets/debugprint.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../20_var_globales/var_color_themes.dart';
import '../../../20_var_globales/variables_globales.dart';
import 'providers/conocidos_notifier.dart';
import 'social_providers.dart'; // Para navegación o lectura de usuarios

// OPTIMIZADO 2025 03 19

class PageDescubrirUsuarios extends ConsumerWidget {
  final String currentUserId;
  final String currentUserName;

  const PageDescubrirUsuarios({
    super.key,
    required this.currentUserId,
    required this.currentUserName,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncUsers = ref.watch(usersListProvider);
    final asyncPromotores = ref.watch(usersPromotoresListProvider);

    return Scaffold(
      backgroundColor: appTheme.surface,
      appBar: AppBar(
        automaticallyImplyLeading: false, // Elimina la flecha automática
        toolbarHeight: 30.0,
        centerTitle: true,
        titleSpacing: 0,
        backgroundColor: appTheme.primary,
        iconTheme: IconThemeData(size: 12, color: appTheme.onPrimary),
        title: Text(
          "Descubrir",
          style: TextStyle(
            color: appTheme.onPrimary,
            fontWeight: FontWeight.normal,
            fontSize: 14,
          ),
        ),
      ),
      body: asyncPromotores.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text("Error: $err")),
        data: (promotores) {
          return asyncUsers.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, _) => Center(child: Text("Error: $err")),
            data: (users) {
              final fUsers = users
                  .where((u) => u['usuario']['id_usuario'] != currentUserId)
                  .toList();
              final fPromotores = promotores
                  .where((p) => p['usuario']['idUsuario'] != currentUserId)
                  .toList();

              return CustomScrollView(
                slivers: [
                  if (fPromotores.isNotEmpty) ...[
                    _buildHeader("Promotores"),
                    _buildSliverList(fPromotores, ref, context, true),
                  ],
                  if (fUsers.isNotEmpty) ...[
                    _buildHeader("Usuarios"),
                    _buildSliverList(fUsers, ref, context, false),
                  ],
                ],
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildHeader(String title) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 3.0),
        child: Text(
          title,
          style: TextStyle(
            color: appTheme.onPrimaryContainer,
            fontSize: fontSizeTituloPagina,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildSliverList(
    List<Map<String, dynamic>> lista,
    WidgetRef ref,
    BuildContext context,
    bool isPromo,
  ) {
    return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
        final user = lista[index]['usuario'];
        String targetId = user['id_usuario'];
        String targetName =
            "${user['nombres']} ${user['apellidopaterno']}".trim();
        debugPrintLevels(12, "_buildSliverList. lista: ${lista[index]}");
        debugPrintLevels(12, "_buildSliverList. targetName: $targetName");

        return Card(
          color: appTheme.surface,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: appTheme.secondary,
              foregroundColor: appTheme.onSecondary,
              child: Text(targetName.isNotEmpty ? targetName[0] : "?"),
            ),
            title: Text(
              targetName,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: appTheme.onPrimaryContainer,
              ),
            ),
            trailing: OutlinedButton.icon(
              style: FilledButton.styleFrom(
                backgroundColor: appTheme.secondary,
                foregroundColor: appTheme.onSecondary,
              ),
              icon: const Icon(Symbols.mail, size: 16),
              label: const Text("Invitar"),
              onPressed: () async {
                debugPrintLevels(
                  12,
                  "Envia invitación: currentUserId: $currentUserId",
                );
                debugPrintLevels(12, "Envia invitación: targetId: $targetId");
                final success =
                    await ref.read(conocidosProvider.notifier).enviarInvitacion(
                          currentUserId,
                          currentUserName,
                          targetId,
                          targetName,
                        );
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor:
                          success ? appTheme.primary : appTheme.error,
                      content: Text(
                        success ? "Enviada a $targetName" : "Error al enviar",
                        style: TextStyle(
                          color:
                              success ? appTheme.onPrimary : appTheme.onError,
                        ),
                      ),
                    ),
                  );
                }
              },
            ),
          ),
        );
      }, childCount: lista.length),
    );
  }
}
