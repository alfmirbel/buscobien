import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';

// -----------------------------------------------------------------------------
// IMPORTACIONES
// Ajusta estas rutas según tu estructura de carpetas
// -----------------------------------------------------------------------------
import '../60_global_widgets/future_builder_state_widgets.dart';
import '../20_var_globales/var_color_themes.dart';
import '../22_imagenes/variables_imagenes.dart';
import '../60_global_widgets/debugprint.dart';
import 'provider_listas_propiedades.dart';
import 'provider_user_lists.dart'; // Provider para guardar la relación (dupla)

class DialogSelectorListas extends ConsumerStatefulWidget {
  final String userId;
  final String propertyId;
  final String tipoDeEspacio;

  const DialogSelectorListas({
    super.key,
    required this.userId,
    required this.propertyId,
    required this.tipoDeEspacio,
  });

  @override
  ConsumerState<DialogSelectorListas> createState() =>
      _DialogSelectorListasState();
}

class _DialogSelectorListasState extends ConsumerState<DialogSelectorListas> {
  // Almacena los IDs de las listas seleccionadas
  final Set<String> _selectedListIds = {};
  bool _isSaving = false;

  @override
  Widget build(BuildContext context) {
    // Escuchamos el provider que trae los nombres de las listas (Headers)
    // userListsHeaderProvider debe estar definido en user_lists_provider.dart
    final asyncListHeaders = ref.watch(userListsProvider.notifier);
    debugPrintLevels(
      10,
      "DialogSelectorListas: ${widget.userId} - ${widget.propertyId}",
    );

    return AlertDialog(
      backgroundColor: appTheme.surface,
      elevation: 5,
      contentPadding: EdgeInsets.zero,
      titlePadding: EdgeInsets.zero,
      actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),

      // Borde redondeado solicitado
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
        side: BorderSide(
          color: appTheme.primary.withValues(alpha: 0.1),
          width: 1,
        ),
      ),

      // -----------------------------------------------------------------------
      // 1. CABECERA (Título + Botón Crear Nueva Lista)
      // -----------------------------------------------------------------------
      title: Container(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 15),
        decoration: BoxDecoration(
          color: appTheme.primary, // Fondo distintivo para la cabecera
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
        child: Column(
          children: [
            Text(
              "Guardar en mis listas",
              style: TextStyle(
                color: appTheme.onPrimary,
                fontFamily: 'Plus Jakarta Sans',
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 15),

            // Botón para Crear Nueva Lista dentro del header
            Material(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
              child: InkWell(
                onTap: () => _mostrarDialogoCrearLista(context),
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 16,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Symbols.add_circle_outline,
                        color: appTheme.onPrimary,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "Crear nueva lista",
                        style: TextStyle(
                          color: appTheme.onPrimary,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),

      // -----------------------------------------------------------------------
      // 2. CONTENIDO (Listado de Checkboxes)
      // -----------------------------------------------------------------------
      content: SizedBox(
        width: double.maxFinite,
        height: 300, // Altura fija para permitir scroll
        child:
            //-------------
            FutureBuilder<int>(
              future: asyncListHeaders.fetchUserLists(widget.userId),
              builder: (context, snapshotLista) {
                switch (snapshotLista.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                    return stateWaiting(
                      widthCuadroFotoPropiedad,
                      heightCuadroFotoPropiedad,
                    );
                  case ConnectionState.active:
                    return stateActive(
                      widthCuadroFotoPropiedad,
                      heightCuadroFotoPropiedad,
                    );
                  case ConnectionState.done:
                    if (snapshotLista.hasError) {
                      return stateErrorFormat(
                        widthCuadroFotoPropiedad,
                        heightCuadroFotoPropiedad,
                        snapshotLista.error,
                      );
                    } else {
                      //------------
                      /*
                    asyncListHeaders.when(
                      loading: () => const Center(child: CircularProgressIndicator()),
                      error: (err, stack) => Center(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            "Error al cargar listas: $err",
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      */
                      if (ref.read(userListsProvider).rows.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Symbols.folder_off,
                                size: 48,
                                color: Colors.grey[400],
                              ),
                              const SizedBox(height: 10),
                              Text(
                                "No tienes listas creadas.",
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                            ],
                          ),
                        );
                      } else {
                        return ListView.separated(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          itemCount: ref.read(userListsProvider).rows.length,
                          separatorBuilder: (ctx, index) => const Divider(
                            height: 1,
                            indent: 20,
                            endIndent: 20,
                          ),
                          itemBuilder: (context, index) {
                            final lista = ref
                                .read(userListsProvider)
                                .rows[index]
                                .value;
                            final isSelected = _selectedListIds.contains(
                              lista.listaId,
                            );

                            return CheckboxListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 0,
                              ),
                              activeColor: appTheme.secondary,
                              checkColor: Colors.white,
                              dense: true,
                              title: Text(
                                lista.listName,
                                style: TextStyle(
                                  fontFamily: 'Plus Jakarta Sans',
                                  fontSize: 15,
                                  fontWeight: isSelected
                                      ? FontWeight.w600
                                      : FontWeight.normal,
                                  color: isSelected
                                      ? appTheme.primary
                                      : Colors.black87,
                                ),
                              ),
                              secondary: Icon(
                                isSelected
                                    ? Symbols.folder
                                    : Symbols.folder_open,
                                color: isSelected
                                    ? appTheme.secondary
                                    : Colors.grey[500],
                              ),
                              value: isSelected,
                              onChanged: (bool? value) {
                                setState(() {
                                  if (value == true) {
                                    _selectedListIds.add(lista.listaId);
                                  } else {
                                    _selectedListIds.remove(lista.listaId);
                                  }
                                });
                              },
                            );
                          },
                        );
                      }
                    }
                }
              },
            ),
      ),

      // -----------------------------------------------------------------------
      // 3. ACCIONES (Botones Cancelar / Guardar)
      // -----------------------------------------------------------------------
      actions: [
        Row(
          children: [
            // Botón Cancelar
            Expanded(
              child: OutlinedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  side: BorderSide(
                    color: appTheme.primary.withValues(alpha: 0.3),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  "Cancelar",
                  style: TextStyle(
                    color: appTheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),

            // Botón Guardar
            Expanded(
              child: ElevatedButton(
                // Deshabilitado si no hay selección o está guardando
                onPressed: (_selectedListIds.isEmpty || _isSaving)
                    ? null
                    : () => _guardarSeleccion(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: appTheme.secondary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 2,
                ),
                child: _isSaving
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
                        "Guardar",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // LÓGICA: GUARDAR EN LISTAS SELECCIONADAS
  // ---------------------------------------------------------------------------
  Future<void> _guardarSeleccion(BuildContext context) async {
    setState(() => _isSaving = true);

    int exitoCount = 0;

    // Iteramos sobre las listas seleccionadas y llamamos a la API
    for (String listaId in _selectedListIds) {
      final success = await ref
          .read(listaPropiedadesProvider.notifier)
          .addPropiedadALista(
            listaId: listaId,
            propertyId: widget.propertyId,
            userId: widget.userId,
            tipoDeEspacio: widget.tipoDeEspacio,
          );
      if (success) exitoCount++;
    }

    if (!mounted) return;

    setState(() => _isSaving = false);
    Navigator.of(context).pop(); // Cerrar diálogo

    // Feedback al usuario
    if (exitoCount > 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Propiedad guardada en $exitoCount lista(s)."),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Error al guardar. Verifica tu conexión."),
          backgroundColor: appTheme.error,
        ),
      );
    }
  }

  // ---------------------------------------------------------------------------
  // LÓGICA: CREAR NUEVA LISTA (Dialog Anidado)
  // ---------------------------------------------------------------------------
  void _mostrarDialogoCrearLista(BuildContext parentContext) {
    final txtController = TextEditingController();

    showDialog(
      context: parentContext,
      builder: (ctx) => AlertDialog(
        elevation: 6,
        backgroundColor: appTheme.primary,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(6)),
        ),
        titleTextStyle: TextStyle(
          color: appTheme.onPrimary,
          fontSize: 14,
          fontFamily: "Comfortaa",
          fontWeight: FontWeight.bold,
        ),
        contentTextStyle: TextStyle(
          color: appTheme.tertiary,
          backgroundColor: appTheme.onSecondary,
          fontSize: 12,
          fontWeight: FontWeight.normal,
        ),
        titlePadding: const EdgeInsets.fromLTRB(6, 12, 6, 6),
        contentPadding: const EdgeInsets.all(3),
        actionsPadding: const EdgeInsets.all(6),
        title: Text("Nueva Lista", textAlign: TextAlign.center),
        content: Container(
          padding: const EdgeInsets.all(6),
          color: appTheme.onSecondary,
          //   height: 80,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 10),
              const Text("Ingresa un nombre para tu nueva lista:"),
              const SizedBox(height: 10),
              TextField(
                style: TextStyle(
                  color: appTheme.onPrimaryContainer,
                  fontSize: 12,
                  fontFamily: "Comfortaa",
                  fontWeight: FontWeight.bold,
                ),
                controller: txtController,
                autofocus: true,
                maxLength: 60,
                decoration: InputDecoration(
                  //hintText: "Ej. Favoritos Playa",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: appTheme.secondary, width: 2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 14,
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
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Cancelar"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.fromLTRB(3, 0, 3, 0),
              backgroundColor: appTheme.onPrimary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            onPressed: () async {
              if (txtController.text.trim().isNotEmpty) {
                // Crear lista usando el ControllerProvider
                // userListsControllerProvider debe estar definido en user_lists_provider.dart
                final success = await ref
                    .read(userListsProvider.notifier)
                    .createList(widget.userId, txtController.text.trim());

                if (success) {
                  // Refrescar el provider de headers para que la nueva lista aparezca inmediatamente
                  // ignore: unused_result
                  ref.refresh(userListsProvider);
                  //(widget.userId));

                  if (mounted) {
                    Navigator.pop(ctx); // Cerrar diálogo pequeño
                    setState(() {
                      // Feedback rápido
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Lista creada"),
                          duration: Duration(seconds: 1),
                        ),
                      );
                    });
                  }
                }
              }
            },
            child: Text("Crear", style: TextStyle(color: appTheme.primary)),
          ),
        ],
      ),
    );
  }
}
