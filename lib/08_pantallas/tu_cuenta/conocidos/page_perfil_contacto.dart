import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:material_symbols_icons/symbols.dart';

import '../../../20_var_globales/var_color_themes.dart';
import '../../../20_var_globales/var_de_estilo_widgets.dart';
import '../../propiedades/buscar_propiedad.dart';

// Propiedades publicadas del contacto (bases buscobien_publicados_*)
final propiedadesContactoProvider = FutureProvider.family<List<dynamic>, String>(
  (ref, userId) => propiedadesPublicadasDeUsuario(userId),
);

class PagePerfilContacto extends ConsumerWidget {
  final String contactoId;
  final String contactoName;

  const PagePerfilContacto({
    super.key,
    required this.contactoId,
    required this.contactoName,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncProps = ref.watch(propiedadesContactoProvider(contactoId));

    return Scaffold(
      appBar: appBarSecondPage("Perfil: $contactoName"),
      body: Column(
        children: [
          // Cabecera Perfil
          Container(
            padding: const EdgeInsets.all(20),
            width: double.infinity,
            color: appTheme.primary.withValues(alpha: 0.05),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: appTheme.secondary,
                  child: Text(
                    contactoName[0],
                    style: TextStyle(fontSize: 30, color: appTheme.onPrimary),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  contactoName,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: appTheme.primary,
                  ),
                ),
              ],
            ),
          ),
          const Divider(),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              "Publicaciones del contacto",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),

          // Lista de Propiedades
          Expanded(
            child: asyncProps.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, _) => Center(child: Text("Error: $err")),
              data: (propiedades) {
                if (propiedades.isEmpty)
                  return const Center(
                    child: Text(
                      "Este usuario no tiene propiedades publicadas.",
                    ),
                  );

                return GridView.builder(
                  padding: const EdgeInsets.all(10),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: propiedades.length,
                  itemBuilder: (context, index) {
                    final p = propiedades[index]['espacioscasa'] ?? {};
                    return Card(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            child: Container(
                              color: appTheme.surfaceContainerHighest,
                              child: Icon(
                                Symbols.home,
                                size: 50,
                                color: appTheme.outline,
                              ),
                              // Reemplaza con NetworkImage si tienes la URL real
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              p['letreropromocional'] ?? "Propiedad",
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8, bottom: 8),
                            child: Text(
                              "\$${p['precioventa'] ?? '0'}",
                              style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
