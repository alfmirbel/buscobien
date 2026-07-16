import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import 'package:buscobien/20_var_globales/var_color_themes.dart';
import 'package:buscobien/40_security/direccionip.dart';
import 'package:buscobien/60_global_widgets/debugprint.dart';
import 'package:buscobien/08_pantallas/inicio/data_espacios_casas_get.dart';
import 'package:buscobien/22_imagenes/tus_espacios_fotos_propiedad/manejo_de_fotos/lista_ids_fotos/data_fotos_get_ids_fotos_user_prop.dart';
import 'package:buscobien/08_pantallas/propiedades/pagina_detalle_propiedad.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'models/grupo_model.dart';
import 'page_chat_grupo.dart';
import 'providers/grupos_invitaciones_provider.dart';
import 'providers/publicaciones_grupo_provider.dart';
import 'providers/avisos_grupo_provider.dart';
import 'models/publicacion_grupo_model.dart';
import 'models/aviso_grupo_model.dart';

class PageDetalleGrupo extends ConsumerStatefulWidget {
  final GrupoModel grupo;
  final String currentUserId;
  final String currentUserName;

  const PageDetalleGrupo({
    super.key,
    required this.grupo,
    required this.currentUserId,
    required this.currentUserName,
  });

  @override
  ConsumerState<PageDetalleGrupo> createState() => _PageDetalleGrupoState();
}

class _PageDetalleGrupoState extends ConsumerState<PageDetalleGrupo>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  late GrupoModel _grupo;

  @override
  void initState() {
    super.initState();
    _grupo = widget.grupo;
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final esAdmin = _grupo.esAdmin(widget.currentUserId);

    return Scaffold(
      backgroundColor: appTheme.surface,
      appBar: AppBar(
        toolbarHeight: 44,
        backgroundColor: appTheme.primary,
        foregroundColor: appTheme.onPrimary,
        centerTitle: true,
        titleSpacing: 2,
        title: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _grupo.nombre,
              style: TextStyle(
                color: appTheme.onPrimary,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            Text(
              '${_grupo.totalMiembros} miembro(s)',
              style: TextStyle(
                color: appTheme.onPrimary.withValues(alpha: 0.75),
                fontSize: 11,
              ),
            ),
          ],
        ),
        actions: [
          if (esAdmin)
            IconButton(
              color: appTheme.onPrimary,
              icon: const Icon(Symbols.person_add, size: 18),
              tooltip: 'Invitar miembro',
              onPressed: () => _dialogInvitar(context),
            ),
          PopupMenuButton<String>(
            icon: const Icon(Symbols.more_vert, size: 18),
            tooltip: 'Opciones del grupo',
            onSelected: (v) => _onMenuSelected(v, context),
            itemBuilder: (_) => [
              const PopupMenuItem(
                value: 'info',
                child: ListTile(
                  leading: Icon(Symbols.info),
                  title: Text('Info del grupo'),
                  dense: true,
                ),
              ),
              if (esAdmin)
                const PopupMenuItem(
                  value: 'editar',
                  child: ListTile(
                    leading: Icon(Symbols.edit),
                    title: Text('Editar grupo'),
                    dense: true,
                  ),
                ),
            ],
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: appTheme.onPrimary,
          unselectedLabelColor: appTheme.onPrimary.withValues(alpha: 0.6),
          indicatorWeight: 1,
          isScrollable: true,
          tabAlignment: TabAlignment.center,
          labelStyle: const TextStyle(fontSize: 11),
          unselectedLabelStyle: const TextStyle(fontSize: 11),
          tabs: const [
            Tab(icon: Icon(Symbols.article, size: 18), text: 'Publicaciones'),
            Tab(icon: Icon(Symbols.people, size: 18), text: 'Miembros'),
            Tab(icon: Icon(Symbols.chat, size: 18), text: 'Chat'),
            Tab(icon: Icon(Symbols.notifications, size: 18), text: 'Avisos'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _TabPublicaciones(grupo: _grupo, currentUserId: widget.currentUserId),
          _TabMiembros(
            grupo: _grupo,
            currentUserId: widget.currentUserId,
            esAdmin: esAdmin,
          ),
          ChatGrupoEmbebido(
            grupoId: _grupo.id,
            currentUserId: widget.currentUserId,
            currentUserName: widget.currentUserName,
          ),
          _TabAvisos(
            grupo: _grupo,
            currentUserId: widget.currentUserId,
            currentUserName: widget.currentUserName,
          ),
        ],
      ),
    );
  }

  void _onMenuSelected(String value, BuildContext context) {
    if (value == 'info') _mostrarInfoDialog(context);
  }

  void _mostrarInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(_grupo.nombre),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _InfoRow('Objetivo', _grupo.objetivo),
            _InfoRow('Descripción', _grupo.descripcion),
            _InfoRow(
              'Privacidad',
              _grupo.privacidad == 'publica' ? 'Público' : 'Privado',
            ),
            _InfoRow(
              'Participación',
              _grupo.participacion == 'abierta' ? 'Abierta' : 'Por invitación',
            ),
            _InfoRow('Creador', _grupo.creadorNombre),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  // ── Dialog invitar — CheckboxList + Enviar ──────────────────────────────────

  void _dialogInvitar(BuildContext context) {
    final futureUsuarios = ref.read(usuariosParaInvitarProvider.future);
    final futurePromotores = ref.read(promotoresParaInvitarProvider.future);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        final seleccionados = <String>{};
        final nombres = <String, String>{};

        return StatefulBuilder(
          builder: (ctx, setDlgState) {
            return AlertDialog(
              elevation: 6,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(6)),
              ),
              backgroundColor: appTheme.primary,
              titlePadding: const EdgeInsets.fromLTRB(6, 12, 6, 6),
              contentPadding: EdgeInsets.zero,
              actionsPadding: const EdgeInsets.all(6),
              title: Text(
                'Invitar a ${_grupo.nombre}',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: appTheme.onPrimary,
                  fontSize: 12,
                  fontFamily: 'Comfortaa',
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: Container(
                constraints: const BoxConstraints(maxHeight: 360),
                child: Material(
                  color: appTheme.onSecondary,
                  child: FutureBuilder<List<List<Map<String, dynamic>>>>(
                  future: Future.wait([futureUsuarios, futurePromotores]),
                  builder: (context, snap) {
                    if (snap.connectionState == ConnectionState.waiting) {
                      return const SizedBox(
                        height: 80,
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }
                    final todos = [
                      ...(snap.data?[0] ?? []),
                      ...(snap.data?[1] ?? []),
                    ];
                    // Filtrar: no el usuario actual ni miembros actuales
                    final disponibles = todos.where((u) {
                      final id = (u['usuario']?['id_usuario'] ?? '') as String;
                      return id.isNotEmpty &&
                          id != widget.currentUserId &&
                          !_grupo.esMiembro(id);
                    }).toList();

                    if (disponibles.isEmpty) {
                      return const Padding(
                        padding: EdgeInsets.all(16),
                        child: Text(
                          'No hay usuarios disponibles para invitar.',
                        ),
                      );
                    }

                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: disponibles.length,
                      itemBuilder: (context, index) {
                        final u =
                            disponibles[index]['usuario']
                                as Map<String, dynamic>;
                        final id = (u['id_usuario'] ?? '') as String;
                        final nombre =
                            '${u['nombres'] ?? ''} ${u['apellidopaterno'] ?? ''}'
                                .trim();
                        nombres[id] = nombre;
                        final sel = seleccionados.contains(id);

                        return CheckboxListTile(
                          dense: true,
                          value: sel,
                          onChanged: (v) {
                            setDlgState(() {
                              if (v == true) {
                                seleccionados.add(id);
                              } else {
                                seleccionados.remove(id);
                              }
                            });
                          },
                          title: Text(
                            nombre.isNotEmpty ? nombre : id,
                            style: TextStyle(
                              color: appTheme.onPrimaryContainer,
                              fontSize: 12,
                            ),
                          ),
                          activeColor: appTheme.primary,
                          checkColor: appTheme.onPrimary,
                        );
                      },
                    );
                  },
                ),
              ),
            ),
            actions: [
                TextButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.fromLTRB(3, 0, 3, 0),
                    backgroundColor: appTheme.onPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () => Navigator.of(ctx).pop(),
                  child: const Text('Cancelar'),
                ),
                const SizedBox(width: 5),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.fromLTRB(3, 0, 3, 0),
                    backgroundColor: seleccionados.isEmpty
                        ? appTheme.onSurfaceVariant
                        : appTheme.onPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: seleccionados.isEmpty
                      ? null
                      : () async {
                          Navigator.of(ctx).pop();
                          int ok = 0;
                          for (final id in seleccionados) {
                            final enviado = await ref
                                .read(gruposInvitacionesProvider.notifier)
                                .enviarInvitacion(
                                  senderId: widget.currentUserId,
                                  senderName: widget.currentUserName,
                                  receiverId: id,
                                  receiverName: nombres[id] ?? '',
                                  grupoId: _grupo.id,
                                  grupoNombre: _grupo.nombre,
                                );
                            if (enviado) ok++;
                          }
                          if (!mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                ok > 0
                                    ? 'Invitación${ok > 1 ? 'es' : ''} enviada${ok > 1 ? 's' : ''} ($ok)'
                                    : 'Error al enviar invitaciones',
                              ),
                              backgroundColor: ok > 0
                                  ? appTheme.primary
                                  : appTheme.error,
                            ),
                          );
                        },
                  child: Text(
                    'Enviar',
                    style: TextStyle(color: appTheme.primary),
                  ),
                ),
                const SizedBox(width: 5),
              ],
            );
          },
        );
      },
    );
  }
}

// ---------------------------------------------------------------------------
// Tab: Publicaciones
// ---------------------------------------------------------------------------

class _TabPublicaciones extends ConsumerWidget {
  final GrupoModel grupo;
  final String currentUserId;

  const _TabPublicaciones({required this.grupo, required this.currentUserId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(publicacionesGrupoProvider(grupo.id));
    final notifier = ref.read(publicacionesGrupoProvider(grupo.id).notifier);

    return async.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(
        child: Text(
          'Error al cargar publicaciones',
          style: TextStyle(color: appTheme.error),
        ),
      ),
      data: (pubs) {
        if (pubs.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Symbols.article, size: 56, color: appTheme.primary),
                  const SizedBox(height: 12),
                  Text(
                    'Aún no hay propiedades compartidas en este grupo.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: appTheme.onSurfaceVariant),
                  ),
                ],
              ),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          itemCount: pubs.length + 1,
          itemBuilder: (context, index) {
            if (index == pubs.length) {
              if (!notifier.hayMas) return const SizedBox.shrink();
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Center(
                  child: TextButton.icon(
                    icon: const Icon(Symbols.expand_more),
                    label: const Text('Cargar más'),
                    onPressed: () => notifier.cargarMas(),
                  ),
                ),
              );
            }

            final pub = pubs[index];
            return _TarjetaPublicacion(
              pub: pub,
              currentUserId: currentUserId,
              grupoId: grupo.id,
            );
          },
        );
      },
    );
  }
}

class _TarjetaPublicacion extends ConsumerWidget {
  final PublicacionGrupoModel pub;
  final String currentUserId;
  final String grupoId;

  const _TarjetaPublicacion({
    required this.pub,
    required this.currentUserId,
    required this.grupoId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final esAutor = pub.autorId == currentUserId;

    return Card(
        color: appTheme.surface,
      margin: const EdgeInsets.symmetric(vertical: 5),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 8, 8, 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icono tipo propiedad
            Icon(Symbols.home, color: appTheme.primary, size: 28),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    pub.propiedadNombre,
                    style: TextStyle(
                      color: appTheme.onPrimaryContainer,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (pub.tipodeespacio.isNotEmpty)
                    Text(
                      pub.tipodeespacio,
                      style: TextStyle(
                        color: appTheme.onSurfaceVariant,
                        fontSize: 11,
                      ),
                    ),
                  const SizedBox(height: 2),
                  Text(
                    'Compartido por ${pub.autorNombre}',
                    style: TextStyle(
                      color: appTheme.onPrimaryContainer,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(
                    Symbols.open_in_new,
                    color: appTheme.primary,
                    size: 18,
                  ),
                  tooltip: 'Ver propiedad',
                  onPressed: () => _verPropiedad(context, pub.propiedadId),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
                if (esAutor)
                  IconButton(
                    icon: Icon(
                      Symbols.remove_circle_outline,
                      color: appTheme.error,
                      size: 18,
                    ),
                    tooltip: 'Dejar de compartir',
                    onPressed: () => ref
                        .read(publicacionesGrupoProvider(grupoId).notifier)
                        .quitarPublicacion(pub),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _verPropiedad(BuildContext context, String propiedadId) async {
    if (propiedadId.isEmpty) return;
    try {
      final authHeaders = {
        'Authorization':
            'Basic ${base64Encode(utf8.encode('$username:$password'))}',
        'Content-Type': 'application/json',
      };
      final resp = await http.get(
        Uri.parse('$direccionip/buscobien_espacios/$propiedadId'),
        headers: authHeaders,
      );
      if (resp.statusCode == 200) {
        final doc =
            jsonDecode(utf8.decode(resp.bodyBytes)) as Map<String, dynamic>;
        final propiedad = ValueEspaciosCasaGet.fromJson(doc);
        if (!context.mounted) return;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => PaginaDetalleWidget(
              propiedad,
              GetIdsFotosUserProp(totalRows: 0, offset: 0, rows: []),
            ),
          ),
        );
      } else {
        debugPrintLevels(1, '_verPropiedad error: ${resp.statusCode}');
      }
    } catch (e) {
      debugPrintLevels(1, '_verPropiedad exception: $e');
    }
  }
}

// ---------------------------------------------------------------------------
// Tab: Miembros (funcional — sin cambios)
// ---------------------------------------------------------------------------

class _TabMiembros extends StatelessWidget {
  final GrupoModel grupo;
  final String currentUserId;
  final bool esAdmin;

  const _TabMiembros({
    required this.grupo,
    required this.currentUserId,
    required this.esAdmin,
  });

  @override
  Widget build(BuildContext context) {
    if (grupo.miembros.isEmpty) {
      return Center(
        child: Text(
          'No hay miembros registrados.',
          style: TextStyle(color: appTheme.onPrimary),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: grupo.miembros.length,
      itemBuilder: (context, index) {
        final m = grupo.miembros[index];
        final isMe = m.usuarioId == currentUserId;

        return ListTile(
          leading: CircleAvatar(
            backgroundColor: m.rol == 'admin'
                ? appTheme.primaryContainer
                : appTheme.secondaryContainer,
            foregroundColor: m.rol == 'admin'
                ? appTheme.onPrimaryContainer
                : appTheme.onSecondaryContainer,
            child: Text(
              m.usuarioNombre.isNotEmpty
                  ? m.usuarioNombre[0].toUpperCase()
                  : '?',
            ),
          ),
          title: Row(
            children: [
              Text(
                m.usuarioNombre,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: appTheme.onPrimary,
                ),
              ),
              if (isMe) ...[
                const SizedBox(width: 6),
                Chip(
                  label: Text(
                    'Tú',
                    style: TextStyle(fontSize: 10, color: appTheme.onPrimary),
                  ),
                  backgroundColor: appTheme.surfaceContainerHighest,
                  padding: EdgeInsets.zero,
                  visualDensity: VisualDensity.compact,
                ),
              ],
            ],
          ),
          subtitle: Text(
            m.rol == 'admin' ? 'Administrador' : 'Miembro',
            style: TextStyle(
              color: m.rol == 'admin' ? appTheme.primary : appTheme.onPrimary,
              fontSize: 12,
            ),
          ),
          trailing: m.rol == 'admin'
              ? Icon(Symbols.star, color: appTheme.primary, size: 18)
              : null,
        );
      },
    );
  }
}

// ---------------------------------------------------------------------------
// Tab: Avisos
// ---------------------------------------------------------------------------

class _TabAvisos extends ConsumerStatefulWidget {
  final GrupoModel grupo;
  final String currentUserId;
  final String currentUserName;

  const _TabAvisos({
    required this.grupo,
    required this.currentUserId,
    required this.currentUserName,
  });

  @override
  ConsumerState<_TabAvisos> createState() => _TabAvisosState();
}

class _TabAvisosState extends ConsumerState<_TabAvisos> {
  void _dialogPublicarAviso() {
    final ctrl = TextEditingController();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return AlertDialog(
          elevation: 6,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(6)),
          ),
          backgroundColor: appTheme.primary,
          titlePadding: const EdgeInsets.fromLTRB(6, 12, 6, 6),
          contentPadding: const EdgeInsets.all(3),
          actionsPadding: const EdgeInsets.all(6),
          title: Text(
            'Nuevo aviso',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: appTheme.onPrimary,
              fontSize: 12,
              fontFamily: 'Comfortaa',
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Container(
            color: appTheme.onSecondary,
            padding: const EdgeInsets.all(8),
            child: TextField(
              controller: ctrl,
              maxLength: 250,
              maxLines: 4,
              style: TextStyle(
                color: appTheme.onPrimaryContainer,
                fontSize: 13,
              ),
              decoration: InputDecoration(
                hintText: 'Escribe el aviso...',
                hintStyle: TextStyle(
                  color: appTheme.onSurfaceVariant,
                  fontSize: 12,
                ),
                border: InputBorder.none,
              ),
            ),
          ),
          actions: [
            TextButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.fromLTRB(3, 0, 3, 0),
                backgroundColor: appTheme.onPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancelar'),
            ),
            const SizedBox(width: 5),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.fromLTRB(3, 0, 3, 0),
                backgroundColor: appTheme.onPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () async {
                final texto = ctrl.text.trim();
                if (texto.isEmpty || texto.length > 250) return;
                final ok = await ref
                    .read(avisosGrupoProvider(widget.grupo.id).notifier)
                    .publicarAviso(
                      autorId: widget.currentUserId,
                      autorNombre: widget.currentUserName,
                      contenido: texto,
                    );
                if (!mounted) return;
                Navigator.pop(ctx);
                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(ok ? 'Aviso publicado' : 'Error al publicar'),
                    backgroundColor: ok ? appTheme.primary : appTheme.error,
                  ),
                );
              },
              child: Text(
                'Publicar',
                style: TextStyle(color: appTheme.primary),
              ),
            ),
            const SizedBox(width: 5),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final async = ref.watch(avisosGrupoProvider(widget.grupo.id));

    return Stack(
      children: [
        async.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(
            child: Text(
              'Error al cargar avisos',
              style: TextStyle(color: appTheme.error),
            ),
          ),
          data: (avisos) {
            if (avisos.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Symbols.notifications,
                        size: 56,
                        color: appTheme.primary,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Aún no hay avisos en este grupo.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: appTheme.onSurfaceVariant),
                      ),
                    ],
                  ),
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.fromLTRB(
                12,
                8,
                12,
                80,
              ), // espacio para FAB
              itemCount: avisos.length,
              itemBuilder: (context, index) {
                return _TarjetaAviso(
                  aviso: avisos[index],
                  currentUserId: widget.currentUserId,
                  grupoId: widget.grupo.id,
                );
              },
            );
          },
        ),

        // FAB
        Positioned(
          right: 16,
          bottom: 16,
          child: FloatingActionButton.extended(
            heroTag: 'fab_aviso_${widget.grupo.id}',
            backgroundColor: appTheme.primary,
            foregroundColor: appTheme.onPrimary,
            icon: Icon(Symbols.add, color: appTheme.onPrimary, size: 20),
            label: Text(
              'Publicar aviso',
              style: TextStyle(color: appTheme.onPrimary, fontSize: 12),
            ),
            onPressed: _dialogPublicarAviso,
          ),
        ),
      ],
    );
  }
}

class _TarjetaAviso extends ConsumerWidget {
  final AvisoGrupoModel aviso;
  final String currentUserId;
  final String grupoId;

  const _TarjetaAviso({
    required this.aviso,
    required this.currentUserId,
    required this.grupoId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final esAutor = aviso.autorId == currentUserId;

    return Card(
        color: appTheme.surface,
      margin: const EdgeInsets.symmetric(vertical: 5),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Container(
            color: appTheme.primary,
            padding: const EdgeInsets.fromLTRB(12, 6, 8, 6),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    aviso.autorNombre,
                    style: TextStyle(
                      color: appTheme.onPrimary,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (esAutor)
                  GestureDetector(
                    onTap: () => ref
                        .read(avisosGrupoProvider(grupoId).notifier)
                        .eliminarAviso(aviso),
                    child: Icon(
                      Symbols.delete_outline,
                      color: appTheme.onPrimary,
                      size: 18,
                    ),
                  ),
              ],
            ),
          ),
          // Body
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Publicado por ${aviso.autorNombre}',
                  style: TextStyle(
                    color: appTheme.onPrimaryContainer,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  aviso.contenido,
                  style: TextStyle(
                    color: appTheme.onPrimaryContainer,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Widget auxiliar para filas de información
// ---------------------------------------------------------------------------

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  const _InfoRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    if (value.isEmpty) return const SizedBox.shrink();
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 90,
            child: Text(
              '$label:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: cs.onSurfaceVariant,
                fontSize: 13,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(color: cs.onSurface, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}
