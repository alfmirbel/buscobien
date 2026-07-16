import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../05_provider_menus/variables_menus.dart';
import '../../../20_var_globales/var_color_themes.dart';
import '../../../20_var_globales/variables_globales.dart';
import 'providers/conocidos_notifier.dart';
import 'models/conocido.dart';

class PageInvitaciones extends ConsumerWidget {
  final String currentUserId;
  const PageInvitaciones({super.key, required this.currentUserId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncRecibidas = ref.watch(
      invitacionesRecibidasProvider(currentUserId),
    );
    final asyncEnviadas = ref.watch(
      invitacionesEnviadasProvider(currentUserId),
    );

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: appTheme.surface,
        appBar: AppBar(
          automaticallyImplyLeading: false, // Elimina la flecha automática
          toolbarHeight: 30.0,
          centerTitle: true,
          titleSpacing: 0,
          backgroundColor: appTheme.primary,
          iconTheme: IconThemeData(size: 12, color: appTheme.onPrimary),
          title: Text(
            "Invitaciones",
            style: TextStyle(
              color: appTheme.onPrimary,
              fontWeight: FontWeight.normal,
              fontSize: fontSizeTituloPagina,
            ),
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(20),
            child: TabBar(
              labelColor: appTheme.onPrimary,
              unselectedLabelColor: appTheme.onPrimary.withValues(alpha: 0.6),
              indicatorColor: appTheme.onPrimary,
              labelStyle: TextStyle(fontSize: menuTabSmallLabelSize),
              unselectedLabelStyle: TextStyle(fontSize: menuTabSmallLabelSize),
              tabs: [
                Tab(text: "Recibidas", height: 25),
                Tab(text: "Enviadas", height: 25),
              ],
            ),
          ),
        ),
        body: TabBarView(
          children: [
            _buildListState(context, ref, asyncRecibidas, isReceived: true),
            _buildListState(context, ref, asyncEnviadas, isReceived: false),
          ],
        ),
      ),
    );
  }

  Widget _buildListState(
    BuildContext context,
    WidgetRef ref,
    AsyncValue<List<Conocido>> asyncData, {
    required bool isReceived,
  }) {
    return asyncData.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, _) => Center(child: Text("Error: $err")),
      data: (lista) {
        if (lista.isEmpty)
          return const Center(child: Text("No hay solicitudes aquí."));
        return ListView.builder(
          itemCount: lista.length,
          itemBuilder: (context, index) {
            final inv = lista[index];
            final nameToShow =
                isReceived ? inv.solicitanteNombre : inv.receptorNombre;

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
                  child: const Icon(Symbols.person),
                ),
                title: Text(
                  nameToShow,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: appTheme.onPrimaryContainer,
                    fontSize: fontSizeSubtituloPagina,
                  ),
                ),
                subtitle: Text(
                  "Estado: ${inv.estado.name.toUpperCase()}",
                  style: TextStyle(
                    color: appTheme.onSurfaceVariant,
                    fontSize: fontSizeDialogCampo,
                  ),
                ),
                trailing: (isReceived &&
                        inv.estado == InvitacionEstado.pendiente)
                    ? Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(
                              Symbols.check_circle,
                              color: appTheme.primary,
                            ),
                            onPressed: () => _updateStatus(
                              ref,
                              inv,
                              InvitacionEstado.aceptado,
                            ),
                          ),
                          IconButton(
                            icon: Icon(Symbols.cancel, color: appTheme.error),
                            onPressed: () => _updateStatus(
                              ref,
                              inv,
                              InvitacionEstado.rechazado,
                            ),
                          ),
                        ],
                      )
                    : Icon(
                        inv.estado == InvitacionEstado.aceptado
                            ? Symbols.handshake
                            : (inv.estado == InvitacionEstado.rechazado
                                ? Symbols.block
                                : Symbols.access_time),
                        color: inv.estado == InvitacionEstado.aceptado
                            ? appTheme.primary
                            : appTheme.onSurfaceVariant,
                      ),
              ),
            );
          },
        );
      },
    );
  }

  void _updateStatus(WidgetRef ref, Conocido inv, InvitacionEstado status) {
    ref.read(conocidosProvider.notifier).responderInvitacion(inv.id, status);
  }
}
