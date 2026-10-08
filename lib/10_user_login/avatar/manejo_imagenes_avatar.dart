// ignore_for_file: use_build_context_synchronously
// https://yawarosman.medium.com/
// uploading-images-videos-and-files-to-an-api-in-flutter-best-practices-and-methods-a07bcc6c37be
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:file_picker/file_picker.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'dart:convert';
import 'dart:io';
import '../../20_var_globales/couchdb_errors.dart';
import '../../60_global_widgets/debugprint.dart';
import '../../60_global_widgets/dialogbox_mensaje_general.dart';
import '../usuario_login/provider_session.dart';
import 'provider_get_avatar.dart';
import '../../20_var_globales/var_color_themes.dart';

// Importa el archivo donde definiste el provider generado

// Asumimos que Dialogs, appTheme, debugPrintLevels, etc., están definidos externamente.

class GestionAvatares extends ConsumerStatefulWidget {
  const GestionAvatares({super.key});

  @override
  ConsumerState<GestionAvatares> createState() {
    debugPrintLevels(6, "1. GestionAvatares createState");
    return GestionAvataresState();
  }
}

class GestionAvataresState extends ConsumerState<GestionAvatares> {
  PlatformFile platformFile = PlatformFile(
    name: "",
    path: "",
    bytes: null,
    size: 0,
    identifier: "",
    readStream: null,
  );

  String filePath = "";
  String fileContent = "";
  String parametroUserID = "";
  Uint8List filesGet = Uint8List.fromList([]);

  @override
  void initState() {
    super.initState();

    // 1. Obtención del ID de usuario
    final userPass = ref.read(sessionProvider).initialIdUserPass;
    if (userPass.rows.isNotEmpty) {
      parametroUserID = userPass.rows[0].value.userId;
    }

    debugPrintLevels(6, "01 GestionAvatares initState: $parametroUserID");

    // 2. Inicialización visual basada en el estado actual del provider generado
    final currentAvatar = ref.read(classUserAvatarProvider);
    if (currentAvatar.rows.isNotEmpty &&
        currentAvatar.rows[0].value.id != "" &&
        currentAvatar.rows[0].value.avatar != "") {
      filesGet = convierteData2Imagen(currentAvatar.rows[0].value.avatar);
    }
  }

  @override
  Widget build(BuildContext context) {
    // 3. Escuchamos el nuevo provider generado
    final avatarState = ref.watch(classUserAvatarProvider);
    final avatarData = avatarState.rows.isNotEmpty
        ? avatarState.rows[0].value
        : null;

    // Sincronizar previsualización si el provider cambia (ej: después de descargar)
    if (filesGet.isEmpty &&
        avatarData != null &&
        avatarData.avatar.isNotEmpty) {
      filesGet = convierteData2Imagen(avatarData.avatar);
    }

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 40.0,
        centerTitle: true,
        titleSpacing: 0,
        backgroundColor: appTheme.primary,
        iconTheme: IconThemeData(size: 14, color: appTheme.onPrimary),
        title: Text(
          "Avatar de tu perfil",
          style: TextStyle(
            color: appTheme.onPrimary,
            fontWeight: FontWeight.normal,
            fontSize: 14,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),

            // Lógica de visualización de imagen
            (filesGet.isNotEmpty)
                ? Material(
                    elevation: 3.0,
                    color: appTheme.onPrimary,
                    borderRadius: BorderRadius.circular(4),
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    child: InkWell(
                      onTap: () async {
                        FilePickerResult? picked = await FilePicker.platform
                            .pickFiles();

                        if (picked != null && picked.files.isNotEmpty) {
                          platformFile = picked.files.first;
                          filePath = platformFile.path!;

                          // Lectura asíncrona corregida
                          List<int> fileBytes = await File(
                            filePath,
                          ).readAsBytes();
                          fileContent = base64Encode(fileBytes);

                          setState(() {
                            filesGet = convierteData2Imagen(fileContent);
                          });
                        }
                      },
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Ink.image(
                            width: 150,
                            height: 150,
                            fit: BoxFit.fitHeight,
                            image: MemoryImage(filesGet),
                          ),
                          Container(
                            padding: const EdgeInsets.all(3),
                            child: Text(
                              'Cambia tu avatar',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: appTheme.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : Column(
                    children: [
                      Container(
                        color: appTheme.surface,
                        height: 150.0,
                        width: 150.0,
                        child: const Icon(Symbols.person, size: 50),
                      ),
                      Container(
                        padding: const EdgeInsets.all(3),
                        child: Text(
                          'Sin avatar',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: appTheme.primary,
                          ),
                        ),
                      ),
                    ],
                  ),

            const SizedBox(height: 20),

            // Botón Seleccionar Imagen
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: appTheme.primary,
                ),
                onPressed: () async {
                  FilePickerResult? picked = await FilePicker.platform
                      .pickFiles();
                  if (picked != null) {
                    platformFile = picked.files.first;
                    filePath = platformFile.path!;
                    List<int> fileBytes = await File(filePath).readAsBytes();
                    fileContent = base64Encode(fileBytes);
                    setState(() {
                      filesGet = convierteData2Imagen(fileContent);
                    });
                  }
                },
                child: Text(
                  "Selecciona una imagen",
                  style: TextStyle(color: appTheme.onPrimary),
                ),
              ),
            ),

            const SizedBox(height: 10),
            if (platformFile.name.isNotEmpty)
              Text(
                "Seleccionado: ${platformFile.name}",
                style: const TextStyle(fontSize: 10),
              ),

            const SizedBox(height: 20),

            // Lógica de Guardar / Actualizar usando el nuevo Notifier
            (avatarData == null || avatarData.id == "")
                ? ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: appTheme.primary,
                    ),
                    onPressed: () async {
                      if (platformFile.path == null) return;

                      // 4. Uso del notifier generado
                      final notifier = ref.read(
                        classUserAvatarProvider.notifier,
                      );

                      int status = await notifier.guardaArchivoAvatar(
                        platformFile,
                        parametroUserID,
                      );

                      if (status == 201) {
                        await notifier.recuperaDatosDelAvatar(parametroUserID);
                      }

                      if (!context.mounted) return;
                      await showMessageDialog(
                        context,
                        "Guarda Avatar",
                        codigoCouchDB[status]?.label ?? "Operación finalizada",
                        appTheme.primary,
                        TextAlign.center,
                        "Salir",
                      );
                    },
                    child: Text(
                      'Guardar imagen como avatar',
                      style: TextStyle(color: appTheme.onPrimary),
                    ),
                  )
                : ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: appTheme.primary,
                    ),
                    onPressed: () async {
                      if (platformFile.path == null) return;

                      final notifier = ref.read(
                        classUserAvatarProvider.notifier,
                      );

                      // Actualización (asumiendo que updateUserAvatarFile está en tu notifier)
                      int status = await notifier.updateUserAvatarFile(
                        avatarData.id,
                        platformFile.path!,
                        platformFile,
                        avatarData.rev,
                        avatarData.idFoto,
                        avatarData.idUsuario,
                      );

                      if (status == 201) {
                        await notifier.recuperaDatosDelAvatar(parametroUserID);
                      }

                      if (!context.mounted) return;
                      await showMessageDialog(
                        context,
                        "Actualiza Avatar",
                        codigoCouchDB[status]?.label ?? "Operación finalizada",
                        appTheme.primary,
                        TextAlign.center,
                        "Salir",
                      );
                    },
                    child: Text(
                      'Cambiar avatar del perfil',
                      style: TextStyle(color: appTheme.onPrimary),
                    ),
                  ),

            const SizedBox(height: 20),

            // Recuperación Manual
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: appTheme.primary,
              ),
              child: Text(
                "Recupera avatar",
                style: TextStyle(color: appTheme.onPrimary),
              ),
              onPressed: () async {
                final notifier = ref.read(classUserAvatarProvider.notifier);
                int status = await notifier.recuperaDatosDelAvatar(
                  parametroUserID,
                );

                if (!context.mounted) return;
                await showMessageDialog(
                  context,
                  "Recupera Avatar",
                  codigoCouchDB[status]?.label ?? "Finalizado",
                  appTheme.primary,
                  TextAlign.center,
                  "Salir",
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

// Función auxiliar (mantenida igual)
Uint8List convierteData2Imagen(String avatar) {
  if (avatar.isEmpty) return Uint8List.fromList([]);
  try {
    String fileContentBase64 = avatar;
    List<int> fileBytes = base64Decode(fileContentBase64);
    Uint8List filesMemory = Uint8List.fromList(fileBytes);
    return filesMemory;
  } catch (e) {
    return Uint8List.fromList([]);
  }
}


