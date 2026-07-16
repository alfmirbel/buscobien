import 'package:buscobien/60_global_widgets/debugprint.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../10_user_login/usuario_login/dialogbox_login.dart';
import '../10_user_login/usuario_login/provider_session.dart';
import '../60_global_widgets/future_builder_state_widgets.dart';
import '../20_var_globales/var_color_themes.dart';
import '../20_var_globales/var_elementos_menus.dart';
import '../20_var_globales/variables_globales.dart';
import '../22_imagenes/variables_imagenes.dart';
import 'data_user_list_model.dart';
import 'pagina_detalle_listas.dart';
import 'provider_user_lists.dart';
import 'provider_listas_compartidas.dart';
import 'package:buscobien/08_pantallas/tu_cuenta/conocidos/providers/conocidos_notifier.dart';
import 'package:buscobien/08_pantallas/tu_cuenta/conocidos/models/conocido.dart';
import 'models/lista_compartida_model.dart';
import 'pagina_detalle_lista_compartida.dart';

class PageMisListas extends ConsumerStatefulWidget {
  const PageMisListas({super.key});

  @override
  ConsumerState<PageMisListas> createState() => _PageMisListasState();
}

class _PageMisListasState extends ConsumerState<PageMisListas>
    with TickerProviderStateMixin {
  String _idUsuario = '';
  String _nombreUsuario = '';
  bool _cargando = true; // controla el estado de carga inicial
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    final session = ref.read(sessionProvider).sessionUserData;
    if (session.userId.isNotEmpty) {
      _idUsuario = session.userId;
      _nombreUsuario = session.userName;
      Future.microtask(() async {
        await ref.read(userListsProvider.notifier).fetchUserLists(_idUsuario);
        await ref
            .read(listasCompartidasProvider.notifier)
            .fetchListasCompartidas(_idUsuario);
        // Carga real de conocidos (conocidosAceptadosProvider es un Provider.family derivado
        // que no dispara ninguna carga; la carga la hace conocidosProvider directamente)
        ref.read(conocidosProvider.notifier).cargar(_idUsuario);
        if (mounted) setState(() => _cargando = false);
      });
    } else {
      _cargando = false;
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // ── Dialog: Crear lista ─────────────────────────────────────────────────────

  void _mostrarDialogoCrearLista() {
    final txtController = TextEditingController();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return AlertDialog(
          elevation: 6,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(6)),
          ),
          titleTextStyle: TextStyle(
            color: appTheme.onPrimary,
            fontSize: fontSizeDialogTitulo, // var global (14)
            fontFamily: 'Comfortaa',
            fontWeight: FontWeight.bold,
          ),
          contentTextStyle: TextStyle(
            color: appTheme.onPrimary,
            fontSize: fontSizeDialogCampo,
            fontWeight: FontWeight.normal,
          ),
          titlePadding: const EdgeInsets.fromLTRB(6, 12, 6, 6),
          contentPadding: const EdgeInsets.all(3),
          actionsPadding: const EdgeInsets.all(3),
          backgroundColor: appTheme.primary,
          title: Text(
            'Nueva Lista',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: appTheme.onPrimary,
              fontSize: fontSizeDialogTitulo,
              fontFamily: 'Comfortaa',
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Container(
            color: appTheme.onSecondary,
            height: 90,
            padding: const EdgeInsets.all(6),
            child: TextField(
              style: TextStyle(
                color: appTheme.onPrimaryContainer,
                fontSize: 12,
                fontFamily: 'Comfortaa',
                fontWeight: FontWeight.bold,
              ),
              controller: txtController,
              maxLength: 60,
              decoration: InputDecoration(
                hintText: 'Ej. Casas para...',
                hintStyle: TextStyle(
                  color: appTheme.onPrimaryContainer,
                  fontSize: 11,
                  fontFamily: 'Comfortaa',
                  fontWeight: FontWeight.normal,
                ),
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
                if (txtController.text.isNotEmpty) {
                  final success = await ref
                      .read(userListsProvider.notifier)
                      .createList(_idUsuario, txtController.text);
                  if (!mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: success
                          ? appTheme.primary
                          : appTheme.error,
                      content: Text(
                        success ? 'Lista creada' : 'Error al crear lista',
                        style: TextStyle(
                          color: success
                              ? appTheme.onPrimary
                              : appTheme.onError,
                        ),
                      ),
                    ),
                  );
                  Navigator.pop(ctx);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: appTheme.error,
                      content: Text(
                        'Escribe el nombre de la lista.',
                        style: TextStyle(color: appTheme.onError),
                      ),
                    ),
                  );
                }
              },
              child: Text('Crear', style: TextStyle(color: appTheme.primary)),
            ),
            const SizedBox(width: 5),
          ],
        );
      },
    );
  }

  // ── Dialog: Compartir lista ─────────────────────────────────────────────────

  _dialogCompartir(String listaId, String listaNombre) {
    final asyncConocidos = ref.read(conocidosAceptadosProvider(_idUsuario));
    final contactos = asyncConocidos.value ?? [];

    if (contactos.isEmpty) return; // botón ya debería estar disabled

    final seleccionados = <String>{};
    const maxSel = 5;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setDlgState) {
            return SizedBox(
              width: 300,
              child: AlertDialog(
                elevation: 6,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(6)),
                ),
                backgroundColor: appTheme.primary,
                titlePadding: const EdgeInsets.fromLTRB(6, 12, 6, 6),
                contentPadding: const EdgeInsets.all(0),
                actionsPadding: const EdgeInsets.all(6),
                title: Text(
                  'Compartir lista',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: appTheme.onPrimary,
                    fontSize: fontSizeDialogTitulo,
                    fontFamily: 'Comfortaa',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                content: SizedBox(
                  width: double.maxFinite,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.maxFinite,
                        color: appTheme.onSecondary,
                        padding: const EdgeInsets.fromLTRB(12, 10, 12, 4),
                        child: Text(
                          'Selecciona hasta $maxSel conocidos:',
                          style: TextStyle(
                            color: appTheme.onPrimaryContainer,
                            fontSize: 11,
                          ),
                        ),
                      ),
                      ConstrainedBox(
                        constraints: BoxConstraints(
                          maxHeight: MediaQuery.of(context).size.height * 0.4,
                        ),
                        child: SizedBox(
                          width: double.maxFinite,
                          child: Material(
                            color: appTheme.onSecondary,
                            child: ListView(
                              shrinkWrap: true,
                              children: contactos.map((c) {
                                final otherId = c.solicitanteId == _idUsuario
                                    ? c.receptorId
                                    : c.solicitanteId;
                                final otherName = c.solicitanteId == _idUsuario
                                    ? c.receptorNombre
                                    : c.solicitanteNombre;
                                final sel = seleccionados.contains(c.id);
                                final bloqueado =
                                    !sel && seleccionados.length >= maxSel;

                                return CheckboxListTile(
                                  dense: true,
                                  value: sel,
                                  onChanged: bloqueado
                                      ? null
                                      : (v) {
                                          setDlgState(() {
                                            if (v == true) {
                                              seleccionados.add(c.id);
                                            } else {
                                              seleccionados.remove(c.id);
                                            }
                                          });
                                        },
                                  title: Text(
                                    otherName.isNotEmpty ? otherName : otherId,
                                    style: TextStyle(
                                      color: bloqueado
                                          ? appTheme.onSurfaceVariant
                                          : appTheme.onPrimaryContainer,
                                      fontSize: 12,
                                    ),
                                  ),
                                  activeColor: appTheme.primary,
                                  checkColor: appTheme.onPrimary,
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ),
                    ],
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
                      backgroundColor: seleccionados.isEmpty
                          ? appTheme.onSurfaceVariant
                          : appTheme.onPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: seleccionados.isEmpty
                        ? null
                        : () {
                            Navigator.pop(ctx);
                            _dialogConfirmarCompartir(
                              listaId: listaId,
                              listaNombre: listaNombre,
                              seleccionados: Set.from(seleccionados),
                              contactos: contactos,
                            );
                          },
                    child: Text(
                      'Enviar',
                      style: TextStyle(color: appTheme.primary),
                    ),
                  ),
                  const SizedBox(width: 5),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // ── Dialog: Confirmación antes de compartir ────────────────────────────────

  void _dialogConfirmarCompartir({
    required String listaId,
    required String listaNombre,
    required Set<String> seleccionados,
    required List<Conocido> contactos,
  }) {
    final nombres = seleccionados
        .map((id) {
          final c = contactos.firstWhere((x) => x.id == id);
          return c.solicitanteId == _idUsuario
              ? c.receptorNombre
              : c.solicitanteNombre;
        })
        .join('\n');

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        backgroundColor: appTheme.primary,
        elevation: 6,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(6)),
        ),
        titlePadding: const EdgeInsets.fromLTRB(6, 12, 6, 6),
        contentPadding: const EdgeInsets.all(3),
        actionsPadding: const EdgeInsets.all(6),
        title: Text(
          'Confirmar',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: appTheme.onPrimary,
            fontSize: fontSizeDialogTitulo,
            fontFamily: 'Comfortaa',
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Container(
            color: appTheme.surface,
          width: double.maxFinite,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '¿Compartir la lista',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: appTheme.primary,
                  fontSize: fontSizeDialogCampo,
                ),
              ),
              Text(
                '"$listaNombre"',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: appTheme.primary,
                  fontSize: fontSizeDialogCampo,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Comfortaa',
                ),
              ),
              Text(
                'con:',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: appTheme.primary,
                  fontSize: fontSizeDialogCampo,
                ),
              ),
              Text(
                "$nombres?",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: appTheme.primary,
                  fontSize: fontSizeDialogCampo,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.fromLTRB(3, 0, 3, 0),
              backgroundColor: appTheme.surface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'Cancelar',
              style: TextStyle(
                color: appTheme.primary,
                fontSize: fontSizeDialogCampo,
                fontFamily: 'Comfortaa',
                fontWeight: FontWeight.bold,
              ),
            ),
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
              Navigator.pop(ctx);
              await _ejecutarCompartir(
                listaId: listaId,
                listaNombre: listaNombre,
                seleccionados: seleccionados,
                contactos: contactos,
              );
            },
            child: Text(
              'Compartir',
              style: TextStyle(
                color: appTheme.primary,
                fontSize: fontSizeDialogCampo,
                fontFamily: 'Comfortaa',
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 5),
        ],
      ),
    );
  }

  Future<void> _ejecutarCompartir({
    required String listaId,
    required String listaNombre,
    required Set<String> seleccionados,
    required List<Conocido> contactos,
  }) async {
    int exitosos = 0;
    int duplicados = 0;

    for (final docId in seleccionados) {
      final c = contactos.firstWhere((x) => x.id == docId);
      final destinoId = c.solicitanteId == _idUsuario
          ? c.receptorId
          : c.solicitanteId;
      final destinoNombre = c.solicitanteId == _idUsuario
          ? c.receptorNombre
          : c.solicitanteNombre;

      final resultado = await ref
          .read(listasCompartidasProvider.notifier)
          .compartirLista(
            listaOrigenId: listaId,
            listaNombreOrigen: listaNombre,
            usuarioOrigenId: _idUsuario,
            usuarioOrigenNombre: _nombreUsuario,
            usuarioDestinoId: destinoId,
            usuarioDestinoNombre: destinoNombre,
          );
      if (resultado == 1) exitosos++;
      if (resultado == -1) duplicados++;
      debugPrintLevels(
        2,
        'compartirLista → $destinoNombre: resultado=$resultado',
      );
    }

    if (!mounted) return;

    final String mensaje;
    final Color bgColor;
    final Color txtColor;

    if (exitosos > 0) {
      final extra = duplicados > 0 ? ' ($duplicados ya recibidas)' : '';
      mensaje =
          'Lista compartida con $exitosos conocido${exitosos > 1 ? 's' : ''}$extra';
      bgColor = appTheme.primary;
      txtColor = appTheme.onPrimary;
    } else if (duplicados > 0) {
      mensaje =
          'Ya habías compartido esta lista con ${duplicados > 1 ? 'esos conocidos' : 'ese conocido'}';
      bgColor = appTheme.secondary;
      txtColor = appTheme.onSecondary;
    } else {
      mensaje = 'No se pudo compartir la lista';
      bgColor = appTheme.error;
      txtColor = appTheme.onError;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: bgColor,
        content: Text(mensaje, style: TextStyle(color: txtColor)),
      ),
    );
  }

  // ── Build ───────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    // Escucha cambios de sesión: refresca listas cuando el usuario hace Login
    ref.listen(sessionProvider, (previous, next) {
      final newUserId = next.sessionUserData.userId;
      final prevUserId = previous?.sessionUserData.userId ?? '';
      if (newUserId != prevUserId && newUserId.isNotEmpty) {
        setState(() {
          _idUsuario = newUserId;
          _nombreUsuario = next.sessionUserData.userName;
          _cargando = true;
        });
        ref.read(userListsProvider.notifier).fetchUserLists(newUserId).then((
          _,
        ) {
          if (mounted) setState(() => _cargando = false);
        });
        ref
            .read(listasCompartidasProvider.notifier)
            .fetchListasCompartidas(newUserId);
        ref.read(conocidosProvider.notifier).cargar(newUserId);
      }
    });

    return Scaffold(
      backgroundColor: appTheme.surface,
      floatingActionButton: SizedBox(
        width: 100,
        height: 30,
        child: FloatingActionButton.extended(
          backgroundColor: appTheme.primary,
          foregroundColor: appTheme.onPrimary,
          label: Text(
            'Crea lista',
            style: TextStyle(color: appTheme.onPrimary, fontSize: 12),
          ),
          onPressed: _mostrarDialogoCrearLista,
          icon: Icon(Symbols.add, color: appTheme.onPrimary, size: 20),
        ),
      ),
      body: (_idUsuario.isEmpty)
          ? _vistaInvitado()
          : Column(
              children: [
                // TabBar
                Container(
                  color: appTheme.primary,
                  child: TabBar(
                    controller: _tabController,
                    labelColor: appTheme.onPrimary,
                    unselectedLabelColor: appTheme.onPrimary.withValues(
                      alpha: 0.6,
                    ),
                    indicatorColor: appTheme.onPrimary,
                    tabs: const [
                      Tab(text: 'Propias'),
                      Tab(text: 'Recibidas'),
                      Tab(text: 'Enviadas'),
                    ],
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [_tabPropias(), _tabRecibidas(), _tabEnviadas()],
                  ),
                ),
                SizedBox(height: 30),
              ],
            ),
    );
  }

  // ── Tab Propias ─────────────────────────────────────────────────────

  Widget _tabPropias() {
    // Reactivo: se reconstruye automáticamente cuando fetchUserLists actualiza el estado
    final rows = ref.watch(userListsProvider).rows;
    final asyncConocidos = ref.watch(conocidosAceptadosProvider(_idUsuario));
    final tieneContactos = (asyncConocidos.value ?? []).isNotEmpty;

    if (_cargando) {
      return stateWaiting(widthCuadroFotoPropiedad, heightCuadroFotoPropiedad);
    }

    if (rows.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Symbols.format_list_bulleted,
              size: 60,
              color: appTheme.primary,
            ),
            const SizedBox(height: 10),
            Text(
              'No tienes listas creadas.',
              style: TextStyle(color: appTheme.primary),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: rows.length,
      itemBuilder: (context, index) {
        final lista = rows[index].value;
        final docId = rows[index].id; // CouchDB _id del documento
        return Card(
            color: appTheme.surface,
          margin: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.fromLTRB(9, 0, 4, 0),
            leading: CircleAvatar(
              radius: 18,
              backgroundColor: appTheme.secondary,
              child: Icon(
                Symbols.format_list_bulleted,
                color: appTheme.onSecondary,
              ),
            ),
            title: Text(
              lista.listName,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: appTheme.onPrimaryContainer,
              ),
            ),
            subtitle: Text(
              'Propiedades guardadas',
              style: TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 12,
                color: appTheme.onPrimaryContainer,
              ),
            ),
            trailing: SizedBox(
              width: 88,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // Compartir
                  IconButton(
                    iconSize: 20,
                    icon: Icon(
                      Symbols.share,
                      color: tieneContactos
                          ? appTheme.primary
                          : appTheme.onSurfaceVariant,
                    ),
                    tooltip: tieneContactos
                        ? 'Compartir'
                        : 'Sin conocidos para compartir',
                    onPressed: tieneContactos
                        ? () => SizedBox(
                            width: 300,
                            child: _dialogCompartir(
                              lista.listaId,
                              lista.listName,
                            ),
                          )
                        : null,
                  ),
                  // Eliminar
                  IconButton(
                    iconSize: 20,
                    icon: Icon(Symbols.delete_outline, color: appTheme.error),
                    tooltip: 'Borrar lista',
                    onPressed: () => _dialogBorrarLista(lista, docId),
                  ),
                ],
              ),
            ),
            onTap: () {
              debugPrintLevels(12, 'Mis Listas tap: ${lista.listName}');
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => PageDetalleLista(lista)),
              ).then((_) {
                // Refresca la lista al regresar del detalle de lista
                ref.read(userListsProvider.notifier).fetchUserLists(_idUsuario);
              });
            },
          ),
        );
      },
    );
  }

  // ── Dialog: Borrar lista ───────────────────────────────────────────────

  void _dialogBorrarLista(Lista lista, String docId) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: appTheme.primary,
          elevation: 6,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(6)),
          ),
          titlePadding: const EdgeInsets.fromLTRB(6, 12, 6, 6),
          contentPadding: const EdgeInsets.all(3),
          actionsPadding: const EdgeInsets.all(6),
          title: Text(
            'Borrar lista',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: appTheme.onPrimary,
              fontSize: fontSizeDialogTitulo,
              fontFamily: 'Comfortaa',
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Container(
              color: appTheme.surface,
            height: 90,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Text(
                  '¿Deseas eliminar la lista "${lista.listName}"?\nEsta acción no se puede deshacer.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: appTheme.primary,
                    fontSize: fontSizeDialogCampo,
                  ),
                ),
              ),
            ),
          ),
          actions: [
            TextButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.fromLTRB(3, 0, 3, 0),
                backgroundColor: appTheme.surface,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () => Navigator.pop(ctx),
              child: Text(
                'Cancelar',
                style: TextStyle(
                  color: appTheme.primary,
                  fontSize: fontSizeDialogCampo,
                  fontFamily: 'Comfortaa',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 5),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.fromLTRB(3, 0, 3, 0),
                backgroundColor: appTheme.error,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () async {
                Navigator.pop(ctx);
                final ok = await ref
                    .read(userListsProvider.notifier)
                    .deleteLista(docId, _idUsuario);
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: ok ? appTheme.primary : appTheme.error,
                    content: Text(
                      ok ? 'Lista eliminada' : 'Error al eliminar la lista',
                      style: TextStyle(
                        color: ok ? appTheme.onPrimary : appTheme.onError,
                      ),
                    ),
                  ),
                );
              },
              child: Text(
                'Eliminar',
                style: TextStyle(
                  color: appTheme.onError,
                  fontSize: fontSizeDialogCampo,
                  fontFamily: 'Comfortaa',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 5),
          ],
        );
      },
    );
  }

  // ── Tab Recibidas ───────────────────────────────────────────────────────────

  Widget _tabRecibidas() {
    final async = ref.watch(listasCompartidasProvider);

    return async.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(
        child: Text(
          'Error al cargar listas recibidas',
          style: TextStyle(color: appTheme.error),
        ),
      ),
      data: (listas) {
        final recibidas = listas
            .where((l) => l.usuarioDestinoId == _idUsuario)
            .toList();

        if (recibidas.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Symbols.move_to_inbox,
                    size: 60,
                    color: appTheme.primary,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'No has recibido listas compartidas.',
                    style: TextStyle(color: appTheme.primary),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: recibidas.length,
          itemBuilder: (context, index) {
            final l = recibidas[index];
            return Card(
                color: appTheme.surface,
              margin: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
              elevation: 1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.fromLTRB(9, 0, 4, 0),
                leading: CircleAvatar(
                  radius: 18,
                  backgroundColor: appTheme.secondary,
                  child: Icon(
                    Symbols.move_to_inbox,
                    color: appTheme.onSecondary,
                  ),
                ),
                title: Text(
                  l.listaNombre,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: appTheme.onPrimaryContainer,
                  ),
                ),
                subtitle: Text(
                  'De ${l.usuarioOrigenNombre}',
                  style: TextStyle(
                    fontSize: 12,
                    color: appTheme.onPrimaryContainer,
                  ),
                ),
                trailing: IconButton(
                  iconSize: 20,
                  icon: Icon(Symbols.delete_outline, color: appTheme.error),
                  tooltip: 'Quitar lista',
                  onPressed: () => _dialogDejarDeCompartir(l),
                ),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => PageDetalleListaCompartida(l),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  // ── Dialog: Dejar de compartir ──────────────────────────────────────────────

  void _dialogDejarDeCompartir(ListaCompartidaModel modelo) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: appTheme.primary,
          elevation: 6,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(6)),
          ),
          titlePadding: const EdgeInsets.fromLTRB(6, 12, 6, 6),
          contentPadding: const EdgeInsets.all(3),
          actionsPadding: const EdgeInsets.all(6),
          title: Text(
            'Dejar de compartir',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: appTheme.onPrimary,
              fontSize: fontSizeDialogTitulo,
              fontFamily: 'Comfortaa',
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Container(
              color: appTheme.surface,
            height: 90,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Text(
                  '¿Dejar de compartir "${modelo.listaNombre}" con ${modelo.usuarioDestinoNombre}?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: appTheme.onPrimaryContainer,
                    fontSize: fontSizeDialogCampo,
                  ),
                ),
              ),
            ),
          ),
          actions: [
            TextButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.fromLTRB(3, 0, 3, 0),
                backgroundColor: appTheme.surface,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () => Navigator.pop(ctx),
              child: Text(
                'Cancelar',
                style: TextStyle(
                  color: appTheme.primary,
                  fontSize: fontSizeDialogCampo,
                  fontFamily: 'Comfortaa',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 5),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.fromLTRB(3, 0, 3, 0),
                backgroundColor: appTheme.error,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () async {
                Navigator.pop(ctx);
                final ok = await ref
                    .read(listasCompartidasProvider.notifier)
                    .dejarDeCompartir(modelo, _idUsuario);
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: ok ? appTheme.primary : appTheme.error,
                    content: Text(
                      ok
                          ? 'Lista dejada de compartir'
                          : 'Error al dejar de compartir',
                      style: TextStyle(
                        color: ok ? appTheme.onPrimary : appTheme.onError,
                      ),
                    ),
                  ),
                );
              },
              child: Text(
                'Confirmar',
                style: TextStyle(
                  color: appTheme.onError,
                  fontSize: fontSizeDialogCampo,
                  fontFamily: 'Comfortaa',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 5),
          ],
        );
      },
    );
  }

  // ── Tab Enviadas ─────────────────────────────────────────────────────────────

  Widget _tabEnviadas() {
    final async = ref.watch(listasCompartidasProvider);

    return async.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(
        child: Text(
          'Error al cargar listas enviadas',
          style: TextStyle(color: appTheme.error),
        ),
      ),
      data: (listas) {
        final enviadas = listas
            .where((l) => l.usuarioOrigenId == _idUsuario)
            .toList();

        if (enviadas.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Symbols.outbox, size: 60, color: appTheme.primary),
                  const SizedBox(height: 10),
                  Text(
                    'No has compartido listas con nadie.',
                    style: TextStyle(color: appTheme.primary),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: enviadas.length,
          itemBuilder: (context, index) {
            final l = enviadas[index];
            return Card(
                color: appTheme.surface,
              margin: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
              elevation: 1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.fromLTRB(9, 0, 4, 0),
                leading: CircleAvatar(
                  radius: 18,
                  backgroundColor: appTheme.secondary,
                  child: Icon(Symbols.outbox, color: appTheme.onSecondary),
                ),
                title: Text(
                  l.listaNombre,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: appTheme.onPrimaryContainer,
                  ),
                ),
                subtitle: Text(
                  'Para ${l.usuarioDestinoNombre}',
                  style: TextStyle(
                    fontSize: 12,
                    color: appTheme.onPrimaryContainer,
                  ),
                ),
                trailing: IconButton(
                  iconSize: 20,
                  icon: Icon(Symbols.link_off, color: appTheme.error),
                  tooltip: 'Dejar de compartir',
                  onPressed: () => _dialogDejarDeCompartir(l),
                ),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => PageDetalleListaCompartida(l),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  // ── Vista invitado ──────────────────────────────────────────────────────────

  Widget _vistaInvitado() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 20),
        Text(
          'No hay listas que mostrar',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Outfit',
            color: appTheme.secondary,
            fontSize: fontSizeTituloPagina,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 30),
        GestureDetector(
          onTap: () {
            // Sin setState: ref.listen en build() actualiza _idUsuario post-login
            dialogBoxFichaLogin(context, ref);
          },
          child: Center(
            child: Container(
              width: 500,
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: appTheme.onPrimary,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: appTheme.primary, width: 2),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(iconoUsuario.icono, size: 23, color: appTheme.primary),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Ingresa como usuario o promotor para crear listas',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: fontSizeSubtituloPagina,
                        fontWeight: FontWeight.bold,
                        color: appTheme.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
