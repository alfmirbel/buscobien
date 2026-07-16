import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../20_var_globales/var_color_themes.dart';
import '../../../20_var_globales/variables_globales.dart';
import 'models/grupo_model.dart';
import 'page_detalle_grupo.dart';
import 'providers/grupos_invitaciones_provider.dart';
import 'providers/grupos_notifier.dart';

class PageDescubrirGrupos extends ConsumerWidget {
  final String currentUserId;
  final String currentUserName;

  const PageDescubrirGrupos({
    super.key,
    required this.currentUserId,
    required this.currentUserName,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncGrupos = ref.watch(gruposPublicosProvider);

    return Scaffold(
      backgroundColor: appTheme.surface,
      appBar: AppBar(
        toolbarHeight: socialAppBarHeight,
        centerTitle: true,
        titleSpacing: 0,
        backgroundColor: appTheme.primary,
        iconTheme: IconThemeData(size: 14, color: appTheme.onPrimary),
        title: Text(
          'Descubrir Grupos',
          style: TextStyle(
            color: appTheme.onPrimary,
            fontWeight: FontWeight.normal,
            fontSize: fontSizeTituloPagina,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Symbols.refresh),
            tooltip: 'Actualizar',
            onPressed: () => ref.invalidate(gruposPublicosProvider),
          ),
        ],
      ),
      body: asyncGrupos.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Symbols.cloud_off, size: 48, color: appTheme.error),
              const SizedBox(height: 12),
              Text(
                'Error al cargar grupos',
                style: TextStyle(color: appTheme.error),
              ),
              const SizedBox(height: 8),
              FilledButton.tonal(
                onPressed: () => ref.invalidate(gruposPublicosProvider),
                child: const Text('Reintentar'),
              ),
            ],
          ),
        ),
        data: (grupos) {
          // Filtra los grupos donde el usuario ya es miembro
          final gruposDisponibles =
              grupos.where((g) => !g.esMiembro(currentUserId)).toList();

          if (gruposDisponibles.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Symbols.search_off,
                    size: 72,
                    color: appTheme.outlineVariant,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No hay grupos públicos disponibles.',
                    style: TextStyle(
                      color: appTheme.onSurfaceVariant,
                      fontSize: fontSizeTituloPagina,
                    ),
                  ),
                ],
              ),
            );
          }

          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
                  child: Text(
                    '${gruposDisponibles.length} grupo(s) disponible(s)',
                    style: TextStyle(
                      color: appTheme.onPrimaryContainer,
                      fontSize: fontSizeSubtituloPagina,
                    ),
                  ),
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => _GrupoDescubrirCard(
                    grupo: gruposDisponibles[index],
                    currentUserId: currentUserId,
                    currentUserName: currentUserName,
                  ),
                  childCount: gruposDisponibles.length,
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 24)),
            ],
          );
        },
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Card de grupo para descubrir
// ---------------------------------------------------------------------------

class _GrupoDescubrirCard extends ConsumerWidget {
  final GrupoModel grupo;
  final String currentUserId;
  final String currentUserName;

  const _GrupoDescubrirCard({
    required this.grupo,
    required this.currentUserId,
    required this.currentUserName,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      color: appTheme.surface,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundColor: appTheme.secondary,
                  child: Icon(
                    Symbols.groups,
                    color: appTheme.onSecondary,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        grupo.nombre,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: appTheme.onPrimaryContainer,
                          fontSize: 15,
                        ),
                      ),
                      if (grupo.objetivo.isNotEmpty)
                        Text(
                          grupo.objetivo,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: appTheme.onPrimaryContainer,
                            fontSize: fontSizeDialogCampo,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
            if (grupo.descripcion.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                grupo.descripcion,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: appTheme.onPrimaryContainer,
                  fontSize: fontSizeDialogCampo,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
            const SizedBox(height: 10),
            Row(
              children: [
                Icon(
                  Symbols.person,
                  size: 14,
                  color: appTheme.onPrimaryContainer,
                ),
                const SizedBox(width: 4),
                Text(
                  '${grupo.totalMiembros} miembro(s)',
                  style: TextStyle(
                    color: appTheme.onPrimaryContainer,
                    fontSize: fontSizeDialogCampo,
                  ),
                ),
                const Spacer(),
                // Acción principal según tipo de participación
                if (grupo.participacion == 'abierta')
                  FilledButton.tonal(
                    onPressed: () => _unirse(context, ref),
                    style: FilledButton.styleFrom(
                      backgroundColor: appTheme.secondary,
                      foregroundColor: appTheme.onSecondary,
                    ),
                    child: const Text('Unirse'),
                  )
                else
                  OutlinedButton.icon(
                    style: FilledButton.styleFrom(
                      backgroundColor: appTheme.secondary,
                      foregroundColor: appTheme.onSecondary,
                    ),
                    icon: const Icon(Symbols.mail, size: 16),
                    label: const Text('Solicitar'),
                    onPressed: () => _solicitarInvitacion(context, ref),
                  ),
                const SizedBox(width: 8),
                // Ver detalle (sin ser miembro)
                OutlinedButton.icon(
                  style: FilledButton.styleFrom(
                    backgroundColor: appTheme.secondary,
                    foregroundColor: appTheme.onSecondary,
                  ),
                  icon: const Icon(Symbols.mail, size: 16),
                  label: const Text('Ver'),
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => PageDetalleGrupo(
                        grupo: grupo,
                        currentUserId: currentUserId,
                        currentUserName: currentUserName,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Unirse directamente (grupo abierto): agrega al usuario como miembro
  Future<void> _unirse(BuildContext context, WidgetRef ref) async {
    final nuevo = MiembroGrupoModel(
      usuarioId: currentUserId,
      usuarioNombre: currentUserName,
      fechaIngreso: DateTime.now().toIso8601String(),
    );

    final ok =
        await ref.read(gruposProvider.notifier).agregarMiembro(grupo.id, nuevo);

    if (context.mounted) {
      final cs = Theme.of(context).colorScheme;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(ok ? 'Te uniste a ${grupo.nombre}' : 'Error al unirse'),
          backgroundColor: ok ? cs.primary : cs.error,
        ),
      );
      // Recargar la lista pública para que desaparezca el grupo unido
      if (ok) ref.invalidate(gruposPublicosProvider);
    }
  }

  // Solicitar ingreso (grupo por invitación): envía solicitud al creador
  Future<void> _solicitarInvitacion(BuildContext context, WidgetRef ref) async {
    final ok =
        await ref.read(gruposInvitacionesProvider.notifier).enviarInvitacion(
              senderId: currentUserId,
              senderName: currentUserName,
              receiverId: grupo.creadorId,
              receiverName: grupo.creadorNombre,
              grupoId: grupo.id,
              grupoNombre: grupo.nombre,
            );

    if (context.mounted) {
      final cs = Theme.of(context).colorScheme;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            ok
                ? 'Solicitud enviada al administrador'
                : 'Ya tienes una solicitud pendiente',
          ),
          backgroundColor: ok ? cs.primary : cs.secondary,
        ),
      );
    }
  }
}
