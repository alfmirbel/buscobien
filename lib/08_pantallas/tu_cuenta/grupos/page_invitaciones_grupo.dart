import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../20_var_globales/var_color_themes.dart';
import '../../../20_var_globales/variables_globales.dart';
import '../../../05_provider_menus/variables_menus.dart';
import 'models/grupo_model.dart';
import 'models/invitacion_grupo_model.dart';
import 'providers/grupos_invitaciones_provider.dart';
import 'providers/grupos_notifier.dart';

class PageInvitacionesGrupo extends ConsumerStatefulWidget {
  final String currentUserId;
  final String currentUserName;

  const PageInvitacionesGrupo({
    super.key,
    required this.currentUserId,
    required this.currentUserName,
  });

  @override
  ConsumerState<PageInvitacionesGrupo> createState() =>
      _PageInvitacionesGrupoState();
}

class _PageInvitacionesGrupoState extends ConsumerState<PageInvitacionesGrupo> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(gruposInvitacionesProvider.notifier)
          .fetchInvitaciones(widget.currentUserId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final asyncInv = ref.watch(gruposInvitacionesProvider);
    final recibidas = ref.watch(
      invitacionesGrupoRecibidasProvider(widget.currentUserId),
    );
    final enviadas = ref.watch(
      invitacionesGrupoEnviadasProvider(widget.currentUserId),
    );

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false, // Elimina la flecha automática
          toolbarHeight: socialAppBarHeight,
          centerTitle: true,
          titleSpacing: 0,
          backgroundColor: appTheme.primary,
          iconTheme: IconThemeData(size: 12, color: appTheme.onPrimary),
          title: Text(
            'Invitaciones a Grupos',
            style: TextStyle(
              color: appTheme.onPrimary,
              fontWeight: FontWeight.normal,
              fontSize: fontSizeTituloPagina,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Symbols.refresh, size: 14),
              onPressed: () => ref
                  .read(gruposInvitacionesProvider.notifier)
                  .fetchInvitaciones(widget.currentUserId),
            ),
          ],
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
        body: asyncInv.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(
            child: Text('Error: $e', style: TextStyle(color: appTheme.error)),
          ),
          data: (_) => TabBarView(
            children: [
              _ListaInvitaciones(
                lista: recibidas,
                isReceived: true,
                currentUserId: widget.currentUserId,
                currentUserName: widget.currentUserName,
              ),
              _ListaInvitaciones(
                lista: enviadas,
                isReceived: false,
                currentUserId: widget.currentUserId,
                currentUserName: widget.currentUserName,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Lista de invitaciones (recibidas o enviadas)
// ---------------------------------------------------------------------------

class _ListaInvitaciones extends ConsumerWidget {
  final List<InvitacionGrupoModel> lista;
  final bool isReceived;
  final String currentUserId;
  final String currentUserName;

  const _ListaInvitaciones({
    required this.lista,
    required this.isReceived,
    required this.currentUserId,
    required this.currentUserName,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (lista.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isReceived ? Symbols.inbox : Symbols.outbox,
              size: 56,
              color: appTheme.outlineVariant,
            ),
            const SizedBox(height: 12),
            Text(
              isReceived
                  ? 'No tienes invitaciones recibidas.'
                  : 'No has enviado invitaciones.',
              style: TextStyle(color: appTheme.onSurfaceVariant),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: lista.length,
      itemBuilder: (context, index) {
        final inv = lista[index];
        return _InvitacionCard(
          inv: inv,
          isReceived: isReceived,
          currentUserId: currentUserId,
          currentUserName: currentUserName,
        );
      },
    );
  }
}

// ---------------------------------------------------------------------------
// Card individual de invitación
// ---------------------------------------------------------------------------

class _InvitacionCard extends ConsumerWidget {
  final InvitacionGrupoModel inv;
  final bool isReceived;
  final String currentUserId;
  final String currentUserName;

  const _InvitacionCard({
    required this.inv,
    required this.isReceived,
    required this.currentUserId,
    required this.currentUserName,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nombreMostrado = isReceived ? inv.senderName : inv.receiverName;

    return Card(
        color: appTheme.surface,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: appTheme.secondary,
                  foregroundColor: appTheme.onSecondary,
                  child: const Icon(Symbols.groups),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        inv.grupoNombre,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: appTheme.onPrimaryContainer,
                          fontSize: fontSizeTituloPagina,
                        ),
                      ),
                      Text(
                        isReceived
                            ? 'Invitado por: $nombreMostrado'
                            : 'Enviado a: $nombreMostrado',
                        style: TextStyle(
                          color: appTheme.onSurfaceVariant,
                          fontSize: fontSizeDialogCampo,
                        ),
                      ),
                    ],
                  ),
                ),
                _StatusBadge(status: inv.status),
              ],
            ),
            // Botones de respuesta (solo recibidas pendientes)
            if (isReceived && inv.status == 'pending') ...[
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton.icon(
                    icon: Icon(
                      Symbols.close,
                      size: 14,
                      color: appTheme.onError,
                    ),
                    label: Text(
                      'Rechazar',
                      style: TextStyle(color: appTheme.onError, fontSize: fontSizeDialogCampo),
                    ),
                    style: FilledButton.styleFrom(
                      backgroundColor: appTheme.error,
                      foregroundColor: appTheme.onError,
                    ),
                    onPressed: () => _responder(context, ref, 'rejected'),
                  ),
                  const SizedBox(width: 10),
                  FilledButton.icon(
                    style: FilledButton.styleFrom(
                      backgroundColor: appTheme.primary,
                      foregroundColor: appTheme.onPrimary,
                    ),
                    icon: const Icon(Symbols.check, size: 14),
                    label: Text(
                      'Aceptar',
                      style: TextStyle(color: appTheme.onError, fontSize: 12),
                    ),
                    onPressed: () => _responder(context, ref, 'accepted'),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _responder(
    BuildContext context,
    WidgetRef ref,
    String status,
  ) async {
    final notifier = ref.read(gruposInvitacionesProvider.notifier);
    final ok = await notifier.responderInvitacion(inv, status, currentUserId);

    // Si aceptó, agregarse como miembro del grupo
    if (ok && status == 'accepted') {
      await ref
          .read(gruposProvider.notifier)
          .agregarMiembro(
            inv.grupoId,
            MiembroGrupoModel(
              usuarioId: currentUserId,
              usuarioNombre: currentUserName,
              fechaIngreso: DateTime.now().toIso8601String(),
            ),
          );
      // Refresca la lista de mis grupos
      ref.read(gruposProvider.notifier).cargarMisGrupos(currentUserId);
    }

    if (context.mounted) {
      final msg = status == 'accepted'
          ? 'Te uniste a ${inv.grupoNombre}'
          : 'Invitación rechazada';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(msg),
          backgroundColor: status == 'accepted'
              ? appTheme.primary
              : appTheme.secondary,
        ),
      );
    }
  }
}

// ---------------------------------------------------------------------------
// Badge de estado
// ---------------------------------------------------------------------------

class _StatusBadge extends StatelessWidget {
  final String status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final (label, color, icon) = switch (status) {
      'accepted' => ('Aceptada', appTheme.primary, Symbols.handshake),
      'rejected' => ('Rechazada', appTheme.error, Symbols.block),
      _ => ('Pendiente', appTheme.onPrimaryContainer, Symbols.access_time),
    };

    return Chip(
      avatar: Icon(icon, size: 14, color: appTheme.onPrimaryContainer),
      label: Text(
        label,
        style: TextStyle(fontSize: 12, color: appTheme.onPrimaryContainer),
      ),
      backgroundColor: appTheme.surface,
      side: BorderSide(color: appTheme.onPrimaryContainer),
      padding: EdgeInsets.zero,
      visualDensity: VisualDensity.compact,
    );
  }
}
