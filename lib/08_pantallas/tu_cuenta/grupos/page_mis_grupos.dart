import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:buscobien/20_var_globales/var_color_themes.dart';
import 'package:buscobien/20_var_globales/variables_globales.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'models/grupo_model.dart';
import 'page_detalle_grupo.dart';
import 'providers/grupos_notifier.dart';

class PageMisGrupos extends ConsumerStatefulWidget {
  final String currentUserId;
  final String currentUserName;

  const PageMisGrupos({
    super.key,
    required this.currentUserId,
    required this.currentUserName,
  });

  @override
  ConsumerState<PageMisGrupos> createState() => _PageMisGruposState();
}

class _PageMisGruposState extends ConsumerState<PageMisGrupos> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(gruposProvider.notifier).cargarMisGrupos(widget.currentUserId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final gruposAsync = ref.watch(gruposProvider);

    return Scaffold(
      backgroundColor: appTheme.surface,
      // appBar: appBarSecondPage('Mis Grupos'),
      body: gruposAsync.when(
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
                onPressed: () => ref
                    .read(gruposProvider.notifier)
                    .cargarMisGrupos(widget.currentUserId),
                child: const Text('Reintentar'),
              ),
            ],
          ),
        ),
        data: (grupos) {
          if (grupos.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Symbols.groups,
                    size: 72,
                    color: appTheme.outlineVariant,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Aún no perteneces a ningún grupo.',
                    style: TextStyle(
                      color: appTheme.onSurfaceVariant,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Crea uno o busca grupos en Descubrir.',
                    style: TextStyle(color: appTheme.outline, fontSize: 13),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () => ref
                .read(gruposProvider.notifier)
                .cargarMisGrupos(widget.currentUserId),
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: grupos.length,
              itemBuilder: (context, index) => _GrupoCard(
                grupo: grupos[index],
                currentUserId: widget.currentUserId,
                currentUserName: widget.currentUserName,
              ),
            ),
          );
        },
      ),
      floatingActionButton: SizedBox(
        width: 110, // Ancho fijo
        height: 30,
        child: FloatingActionButton.extended(
          backgroundColor: appTheme.primary,
          foregroundColor: appTheme.onPrimary,
          icon: Icon(Symbols.add, color: appTheme.onPrimary, size: 20),
          label: Text(
            'Crea grupo',
            style: TextStyle(color: appTheme.onPrimary, fontSize: 12),
          ),
          onPressed: () => _dialogCrearGrupo(context),
        ),
      ),
    );
  }

  void _dialogCrearGrupo(BuildContext context) {
    final nombreCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    final objetivoCtrl = TextEditingController();
    String privacidad = 'publica';
    String participacion = 'abierta';

    final labelStyle = TextStyle(
      fontSize: fontSizeSubtituloPagina,
      color: appTheme.onSurfaceVariant,
    );
    final inputStyle = TextStyle(
      fontSize: fontSizeDialogCampo,
      color: appTheme.onSurface,
    );
    final seccionStyle = TextStyle(
      fontSize: fontSizeSubtituloPagina,
      color: appTheme.onPrimaryContainer,
      fontWeight: FontWeight.bold,
    );
    final botonStyle = TextStyle(
      fontSize: fontSizeSubtituloPagina,
      fontFamily: 'Comfortaa',
      fontWeight: FontWeight.bold,
    );
    const inputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(3)),
    );

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setLocalState) => AlertDialog(
          backgroundColor: appTheme.primary,
          elevation: 6,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(3)),
          ),
          titleTextStyle: TextStyle(
            color: appTheme.onPrimary,
            fontSize: fontSizeDialogTitulo,
            fontFamily: 'Comfortaa',
            fontWeight: FontWeight.bold,
          ),
          contentTextStyle: TextStyle(
            color: appTheme.onPrimaryContainer,
            fontSize: fontSizeDialogCampo,
            fontWeight: FontWeight.normal,
          ),
          titlePadding: const EdgeInsets.fromLTRB(6, 12, 6, 6),
          contentPadding: const EdgeInsets.all(3),
          actionsPadding: const EdgeInsets.all(6),
          title: const Text('Nuevo grupo', textAlign: TextAlign.center),
          content: Container(
            width: 340,
            padding: const EdgeInsets.all(6),
            color: appTheme.onSecondary,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: nombreCtrl,
                    style: inputStyle,
                    decoration: InputDecoration(
                      labelText: 'Nombre *',
                      labelStyle: labelStyle,
                      border: inputBorder,
                      isDense: true,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: descCtrl,
                    maxLines: 2,
                    style: inputStyle,
                    decoration: InputDecoration(
                      labelText: 'Descripción',
                      labelStyle: labelStyle,
                      border: inputBorder,
                      isDense: true,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: objetivoCtrl,
                    style: inputStyle,
                    decoration: InputDecoration(
                      labelText: 'Objetivo del grupo',
                      labelStyle: labelStyle,
                      border: inputBorder,
                      isDense: true,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text('Privacidad', style: seccionStyle),
                  const SizedBox(height: 4),
                  SegmentedButton<String>(
                    segments: [
                      ButtonSegment(
                        value: 'publica',
                        label: Text(
                          'Público',
                          style: TextStyle(fontSize: fontSizeSubtituloPagina),
                        ),
                        icon: const Icon(Symbols.public, size: iconSizeFiltros),
                      ),
                      ButtonSegment(
                        value: 'privada',
                        label: Text(
                          'Privado',
                          style: TextStyle(fontSize: fontSizeSubtituloPagina),
                        ),
                        icon: const Icon(Symbols.lock, size: iconSizeFiltros),
                      ),
                    ],
                    selected: {privacidad},
                    onSelectionChanged: (v) =>
                        setLocalState(() => privacidad = v.first),
                  ),
                  const SizedBox(height: 10),
                  Text('Participación', style: seccionStyle),
                  const SizedBox(height: 4),
                  SegmentedButton<String>(
                    segments: [
                      ButtonSegment(
                        value: 'abierta',
                        label: Text(
                          'Abierto',
                          style: TextStyle(fontSize: fontSizeSubtituloPagina),
                        ),
                        icon: const Icon(
                          Symbols.meeting_room,
                          size: iconSizeFiltros,
                        ),
                      ),
                      ButtonSegment(
                        value: 'invitacion',
                        label: Text(
                          'Por invitación',
                          style: TextStyle(fontSize: fontSizeSubtituloPagina),
                        ),
                        icon: const Icon(
                          Symbols.mail_outline,
                          size: iconSizeFiltros,
                        ),
                      ),
                    ],
                    selected: {participacion},
                    onSelectionChanged: (v) =>
                        setLocalState(() => participacion = v.first),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(3),
                backgroundColor: appTheme.surface,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () => Navigator.of(ctx).pop(),
              child: Text(
                'Cancelar',
                style: botonStyle.copyWith(color: appTheme.onPrimaryContainer),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(3),
                backgroundColor: appTheme.secondary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () async {
                final nombre = nombreCtrl.text.trim();
                if (nombre.isEmpty) return;

                final ok = await ref
                    .read(gruposProvider.notifier)
                    .crearGrupo(
                      creadorId: widget.currentUserId,
                      creadorNombre: widget.currentUserName,
                      nombre: nombre,
                      descripcion: descCtrl.text.trim(),
                      objetivo: objetivoCtrl.text.trim(),
                      privacidad: privacidad,
                      participacion: participacion,
                    );

                if (ctx.mounted) {
                  Navigator.of(ctx).pop();
                  if (!ok && context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Error al crear el grupo'),
                        backgroundColor: appTheme.error,
                      ),
                    );
                  }
                }
              },
              child: Text(
                'Crear',
                style: botonStyle.copyWith(color: appTheme.onSecondary),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Card de grupo
// ---------------------------------------------------------------------------

class _GrupoCard extends StatelessWidget {
  final GrupoModel grupo;
  final String currentUserId;
  final String currentUserName;

  const _GrupoCard({
    required this.grupo,
    required this.currentUserId,
    required this.currentUserName,
  });

  @override
  Widget build(BuildContext context) {
    final esAdmin = grupo.esAdmin(currentUserId);

    return Card(
        color: appTheme.surface,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => PageDetalleGrupo(
              grupo: grupo,
              currentUserId: currentUserId,
              currentUserName: currentUserName,
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              CircleAvatar(
                radius: 26,
                backgroundColor: appTheme.secondary,
                child: Icon(
                  Symbols.groups,
                  color: appTheme.onSecondary,
                  size: 28,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            grupo.nombre,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: appTheme.onPrimaryContainer,
                              fontSize: 15,
                            ),
                          ),
                        ),
                        if (esAdmin)
                          Chip(
                            label: Text(
                              'Admin',
                              style: TextStyle(
                                fontSize: 11,
                                color: appTheme.onPrimary,
                              ),
                            ),
                            backgroundColor: appTheme.primary,
                            padding: EdgeInsets.zero,
                            visualDensity: VisualDensity.compact,
                          ),
                      ],
                    ),
                    if (grupo.descripcion.isNotEmpty) ...[
                      const SizedBox(height: 3),
                      Text(
                        grupo.descripcion,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: appTheme.onPrimaryContainer,
                          fontSize: 13,
                        ),
                      ),
                    ],
                    const SizedBox(height: 6),
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
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Icon(
                          grupo.privacidad == 'publica'
                              ? Symbols.public
                              : Symbols.lock,
                          size: 14,
                          color: appTheme.onPrimaryContainer,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          grupo.privacidad == 'publica' ? 'Público' : 'Privado',
                          style: TextStyle(
                            color: appTheme.onPrimaryContainer,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Icon(Symbols.chevron_right, color: appTheme.primary),
            ],
          ),
        ),
      ),
    );
  }
}
