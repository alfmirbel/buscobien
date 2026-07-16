import 'package:buscobien/20_var_globales/var_color_themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../20_var_globales/variables_globales.dart';
import 'page_descubrir_grupos.dart';
import 'page_invitaciones_grupo.dart';
import 'page_mis_grupos.dart';
import 'providers/grupos_invitaciones_provider.dart';

// Vista raíz del módulo Mis Grupos.
// Espejo de ConocidosView: NavigationBar con 3 destinos.
class GruposView extends ConsumerStatefulWidget {
  final String currentUserId;
  final String currentUserName;

  const GruposView({
    super.key,
    required this.currentUserId,
    required this.currentUserName,
  });

  @override
  ConsumerState<GruposView> createState() => _GruposViewState();
}

class _GruposViewState extends ConsumerState<GruposView> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    // Carga invitaciones al montar para mostrar badge con pendientes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(gruposInvitacionesProvider.notifier)
          .fetchInvitaciones(widget.currentUserId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final pendientes = ref
        .watch(invitacionesGrupoRecibidasProvider(widget.currentUserId))
        .length;

    final pages = [
      PageMisGrupos(
        currentUserId: widget.currentUserId,
        currentUserName: widget.currentUserName,
      ),
      PageInvitacionesGrupo(
        currentUserId: widget.currentUserId,
        currentUserName: widget.currentUserName,
      ),
      PageDescubrirGrupos(
        currentUserId: widget.currentUserId,
        currentUserName: widget.currentUserName,
      ),
    ];

    return Column(
      children: [
        Expanded(child: pages[_currentIndex]),
        NavigationBar(
          indicatorColor: appTheme.primary,
          selectedIndex: _currentIndex,
          height: navBarHeight,
          onDestinationSelected: (index) =>
              setState(() => _currentIndex = index),
          destinations: [
            const NavigationDestination(
              icon: Icon(Symbols.groups),
              selectedIcon: Icon(Symbols.groups),
              label: 'Mis Grupos',
            ),
            NavigationDestination(
              icon: Badge(
                isLabelVisible: pendientes > 0,
                label: Text('$pendientes'),
                child: const Icon(Symbols.mail),
              ),
              selectedIcon: Badge(
                isLabelVisible: pendientes > 0,
                label: Text('$pendientes'),
                child: const Icon(Symbols.mail),
              ),
              label: 'Invitaciones',
            ),
            const NavigationDestination(
              icon: Icon(Symbols.search),
              selectedIcon: Icon(Symbols.search),
              label: 'Descubrir',
            ),
          ],
        ),
      ],
    );
  }
}
