import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../20_var_globales/var_color_themes.dart';
import '../../../20_var_globales/variables_globales.dart';
import 'page_mis_contactos.dart';
import 'page_invitaciones.dart';
import 'page_descubrir_usuarios.dart';

class ConocidosView extends StatefulWidget {
  final String currentUserId;
  final String currentUserName;

  const ConocidosView({
    super.key,
    required this.currentUserId,
    required this.currentUserName,
  });

  @override
  State<ConocidosView> createState() => _ConocidosViewState();
}

class _ConocidosViewState extends State<ConocidosView> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    // final cs = Theme.of(context).colorScheme;

    final List<Widget> pages = [
      PageMisContactos(currentUserId: widget.currentUserId),
      PageInvitaciones(currentUserId: widget.currentUserId),
      PageDescubrirUsuarios(
        currentUserId: widget.currentUserId,
        currentUserName: widget.currentUserName,
      ),
    ];

    return Scaffold(
      body: pages[_currentIndex],
      bottomNavigationBar: NavigationBar(
        indicatorColor: appTheme.primary,
        selectedIndex: _currentIndex,
        height: navBarHeight,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Symbols.people),
            selectedIcon: Icon(Symbols.people),
            label: 'Contactos',
          ),
          NavigationDestination(
            icon: Icon(Symbols.mail),
            selectedIcon: Icon(Symbols.mail),
            label: 'Invitaciones',
          ),
          NavigationDestination(
            icon: Icon(Symbols.search),
            selectedIcon: Icon(Symbols.search),
            label: 'Descubrir',
          ),
        ],
      ),
    );
  }
}
