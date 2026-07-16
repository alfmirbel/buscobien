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

/*
class GestionAvatares extends ConsumerStatefulWidget {
  const GestionAvatares({super.key});

  @override
  ConsumerState createState() {
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

  // filesGet servirá para la previsualización local
  Uint8List filesGet = Uint8List.fromList([]);

  @override
  void initState() {
    super.initState();
    // Lectura inicial segura (read es correcto en initState)
    final userPass = ref.read(sessionProvider);
    if (userPass.rows.isNotEmpty) {
      parametroUserID = userPass.rows[0].value.userId;
    }

    debugPrintLevels(6, "01 GestionAvatares initState: $parametroUserID");

    // Inicialización basada en datos existentes
    final currentAvatar = ref.read(classUserAvatarProvider);
    if (currentAvatar.rows.isNotEmpty &&
        currentAvatar.rows[0].value.id != "" &&
        currentAvatar.rows[0].value.avatar != "") {
      debugPrintLevels(
        6,
        "02 GestionAvatares initState con avatar: $parametroUserID",
      );
      filesGet = convierteData2Imagen(currentAvatar.rows[0].value.avatar);
    } else {
      debugPrintLevels(
        6,
        "02 GestionAvatares initState sin avatar: $parametroUserID",
      );
      filesGet = Uint8List.fromList([]);
    }
  }

  late FilePickerResult result;

  @override
  Widget build(BuildContext context) {
    // 1. AJUSTE: Usamos ref.watch para escuchar cambios en el avatar.
    // Si el provider se actualiza (ej. después de subir foto), este widget se reconstruye solo.
    final avatarState = ref.watch(classUserAvatarProvider);
    final avatarData = avatarState.rows.isNotEmpty
        ? avatarState.rows[0].value
        : null;

    // Lógica para determinar qué imagen mostrar:
    // Si filesGet tiene datos (carga inicial o selección local), usalos.
    // Si no, intenta usar lo que venga del provider.
    bool showImage = false;
    if (filesGet.isNotEmpty) {
      showImage = true;
    } else if (avatarData != null && avatarData.avatar.isNotEmpty) {
      // Si el provider trajo datos nuevos y filesGet estaba vacío, actualizamos filesGet visualmente
      filesGet = convierteData2Imagen(avatarData.avatar);
      showImage = true;
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
        // Agregado para evitar desbordamientos en pantallas chicas
        child: Column(
          children: [
            const SizedBox(height: 20),

            // Lógica de visualización de imagen
            (showImage)
                ? Material(
                    elevation: 3.0,
                    color: appTheme.onPrimary,
                    borderRadius: BorderRadius.circular(4),
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    child: InkWell(
                      onTap: () async {
                        // Selección de archivo
                        FilePickerResult? picked = await FilePicker.platform
                            .pickFiles();

                        if (picked == null || picked.count == 0) {
                          if (!context.mounted) return;
                          Dialogs.yesAbortDialog(
                            context,
                            "Aviso",
                            "No se encontraron archivos.",
                            DialogType.aviso,
                          );
                        } else {
                          debugPrintLevels(
                            6,
                            "04 GestionAvatares FilePicker seleccionado",
                          );

                          platformFile = picked.files.first;
                          filePath = platformFile.path!;

                          // 2. AJUSTE: Lectura asíncrona para no congelar la UI
                          List<int> fileBytes = await File(
                            filePath,
                          ).readAsBytes();

                          fileContent = base64Encode(fileBytes);

                          // Actualizamos la vista previa local
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
                        // Asumimos iconUser e iconSizeFiltros definidos globalmente
                        child: Icon(Symbols.person, size: 50),
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

            // Botón Seleccionar Imagen (Texto simple)
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: appTheme.primary,
                ),
                onPressed: () async {
                  FilePickerResult? picked = await FilePicker.platform
                      .pickFiles();

                  if (picked == null) {
                    if (!context.mounted) return;
                    Dialogs.yesAbortDialog(
                      context,
                      "Aviso",
                      "No se encontraron archivos.",
                      DialogType.aviso,
                    );
                  } else {
                    platformFile = picked.files.first;
                    filePath = platformFile.path!;

                    // Lectura Asíncrona
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

            const SizedBox(height: 20),
            if (platformFile.path != null && platformFile.path!.isNotEmpty)
              Text("Imagen seleccionada: ${platformFile.name}"),
            const SizedBox(height: 20),

            // Lógica de Botones: Guardar (Nuevo) vs Actualizar (Existente)
            // Usamos avatarData (del watch) para decidir, es más seguro que ref.read
            (avatarData == null || avatarData.id == "")
                ? Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: appTheme.primary,
                      ),
                      onPressed: () async {
                        if (platformFile.path == null ||
                            platformFile.path!.isEmpty) {
                          // Validación simple
                          return;
                        }

                        // 3. AJUSTE: Uso de async/await lineal en lugar de .then()
                        // 4. AJUSTE: No pasamos 'ref' al notifier (según corrección anterior)
                        /*
                        int onValue = await ref
                            .read(classUserAvatarProvider.notifier)
                            .guardaArchivoAvatar(platformFile, parametroUserID);
*/
                        // Recuperamos datos frescos
                        int statusRecuperacion = await ref
                            .read(classUserAvatarProvider.notifier)
                            .recuperaDatosDelAvatar(
                              parametroUserID,
                              ref,
                            ); // Asumimos userID se obtiene internamente o se pasa string

                        // 5. AJUSTE: Verificar mounted antes de usar context
                        if (!context.mounted) return;

                        debugPrintLevels(
                          6,
                          "15 GestionAvatares build recuperaImagenDelAvatar",
                        );

                        await showMessageDialog(
                          context,
                          "Guarda Avatar",
                          codigoCouchDB[statusRecuperacion]?.label ??
                              "Operación finalizada",
                          appTheme.primary,
                          TextAlign.center,
                        );

                        // No es necesario setState, el ref.watch actualizará la UI
                      },
                      child: Text(
                        'Guardar imagen como avatar',
                        style: TextStyle(color: appTheme.onPrimary),
                      ),
                    ),
                  )
                : Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: appTheme.primary,
                      ),
                      onPressed: () async {
                        if (platformFile.path == null ||
                            platformFile.path!.isEmpty)
                          return;

                        // Actualizar archivo existente
                        int onValue = await ref
                            .read(classUserAvatarProvider.notifier)
                            .updateUserAvatarFile(
                              avatarData.id,
                              filePath,
                              platformFile,
                              avatarData.rev,
                              avatarData.idFoto,
                              avatarData.idUsuario,
                            );

                        if (!context.mounted) return;

                        await showMessageDialog(
                          context,
                          "Actualiza Avatar",
                          codigoCouchDB[onValue]?.label ??
                              "Operación finalizada",
                          appTheme.primary,
                          TextAlign.center,
                        );

                        if (onValue == 201) {
                          // Refrescamos datos
                          int statusRecup = await ref
                              .read(classUserAvatarProvider.notifier)
                              .recuperaDatosDelAvatar(
                                avatarData.idUsuario,
                                ref,
                              );

                          if (!context.mounted) return;

                          await showMessageDialog(
                            context,
                            "Recupera Imagen del Avatar",
                            codigoCouchDB[statusRecup]?.label ?? "Ok",
                            appTheme.primary,
                            TextAlign.center,
                          );

                          if (!context.mounted) return;
                          Navigator.pushNamed(
                            context,
                            AppRoutes.principal, // Asumimos AppRoutes definido
                            arguments: "",
                          );
                        }
                      },
                      child: Text(
                        'Cambiar avatar del perfil',
                        style: TextStyle(color: appTheme.onPrimary),
                      ),
                    ),
                  ),

            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: appTheme.primary,
                ),
                child: Text(
                  "Recupera avatar",
                  style: TextStyle(color: appTheme.onPrimary),
                ),
                onPressed: () async {
                  int onValue = await ref
                      .read(classUserAvatarProvider.notifier)
                      .recuperaDatosDelAvatar(
                        parametroUserID,
                        ref,
                      ); // No pasamos ref

                  debugPrintLevels(6, "15 GestionAvatares recuperación manual");

                  if (!context.mounted) return;

                  await showMessageDialog(
                    context,
                    "Recupera Avatar",
                    codigoCouchDB[onValue]?.label ?? "Finalizado",
                    appTheme.primary,
                    TextAlign.center,
                  );
                  // El ref.watch actualizará la UI si los datos cambiaron
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void openFile(PlatformFile file) {
    if (file.path != null) {
      OpenFile.open(file.path!);
    }
  }
}

*/

/*
class GestionAvatares extends ConsumerStatefulWidget {
  const GestionAvatares({super.key});

  @override
  // ignore: no_logic_in_create_state
  ConsumerState createState() {
    // debugPrintLevels(6, "**************************************************");
    debugPrintLevels(6, "1. GestionAvatares createState");
    // debugPrintLevels(6, "**************************************************");
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
    debugPrintLevels(
      6,
      "01 GestionAvatares initState: ${ref.read(sessionProvider).rows[0].value.userId}",
    );
    parametroUserID = ref.read(sessionProvider).rows[0].value.userId;

    if ((ref.read(classUserAvatarProvider).rows[0].value.id != "") &&
        (ref.read(classUserAvatarProvider).rows[0].value.avatar != "")) {
      debugPrintLevels(
        6,
        "02 GestionAvatares initState con avatar: $parametroUserID",
      );
      //"02 GestionAvatares initState ${ref.read(classUserAvatarProvider).rows[0].value.avatar}");
      filesGet = convierteData2Imagen(
        ref.read(classUserAvatarProvider).rows[0].value.avatar,
      );
    } else {
      debugPrintLevels(
        6,
        "02 GestionAvatares initState sin avatar: $parametroUserID",
      );
      filesGet = Uint8List.fromList([]);
      //debugPrintLevels(6, "02 GestionAvatares initState sin avatar: $filesGet - ${filesGet.length}");
    }
  }

  late FilePickerResult result;
  @override
  Widget build(BuildContext context) {
    //debugPrintLevels(6, "02 GestionAvatares build");

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 40.0, // default kToolbarHeight = 56.0
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
      body: Column(
        children: [
          const SizedBox(height: 20),
          (ref.read(classUserAvatarProvider).rows[0].value.avatar != "" ||
                  // ignore: prefer_is_empty
                  filesGet.length != 0)
              ? Material(
                  elevation: 3.0,
                  color: appTheme.onPrimary,
                  borderRadius: BorderRadius.circular(4),
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  child: InkWell(
                    onTap: () async {
                      result = (await FilePicker.platform.pickFiles())!;

                      if (result.count == 0) {
                        Dialogs.yesAbortDialog(
                          context,
                          "Aviso",
                          "No se encotraron archivos.",
                          DialogType.aviso,
                        );
                      } else {
                        debugPrintLevels(
                          6,
                          "04 GestionAvatares build FilePicker.platform.pickFiles",
                        );

                        //------------------------------------------------------------------------------
                        platformFile = result.files.first;
                        filePath = platformFile.path!;
                        List<int> fileBytes = File(filePath).readAsBytesSync();
                        fileContent = base64Encode(fileBytes);
                        filesGet = convierteData2Imagen(fileContent);

                        setState(() {
                          //openFile(platformFile);
                          //debugPrintLevels(6, "05 GestionAvatares build Archivo: ${platformFile.toString()}");
                        });
                      }
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Ink.image(
                          width: 150,
                          height: 150,
                          fit: BoxFit
                              .fitHeight, // https://api.flutter.dev/flutter/painting/BoxFit.html
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
              //Image.memory(filesGet)
              : Column(
                  children: [
                    Container(
                      color: appTheme.surface,
                      height: 150.0,
                      width: 150.0,
                      child: Icon(iconUser, size: iconSizeFiltros * 5),
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
          Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: appTheme.primary,
              ),
              onPressed: () async {
                debugPrintLevels(
                  6,
                  "06 GestionAvatares build 01 ID: ${ref.read(classUserAvatarProvider).rows[0].value.id}",
                );
                //debugPrintLevels(6, "07 GestionAvatares build 02 idUser: ${ref.read(classUserAvatarProvider).rows[0].value.idUsuario}");
                result = (await FilePicker.platform.pickFiles())!;
                // ignore: unnecessary_null_comparison, dead_code
                if (result == null) {
                  Dialogs.yesAbortDialog(
                    context,
                    "Aviso",
                    "No se encotraron archivos.",
                    DialogType.aviso,
                  );
                } else {
                  //debugPrintLevels(6, "07 GestionAvatares build 09 platformFile: ${result.files})}");
                  //------------------------------------------------------------------------------
                  platformFile = result.files.first;
                  filePath = platformFile.path!;
                  List<int> fileBytes = File(filePath).readAsBytesSync();
                  fileContent = base64Encode(fileBytes);
                  filesGet = convierteData2Imagen(fileContent);
                  debugPrintLevels(
                    6,
                    "07 GestionAvatares build 09 filesGet: ${filesGet.length})}",
                  );
                  setState(() {
                    //openFile(platformFile);
                    //debugPrintLevels(6, "07 GestionAvatares build 09 Archivo: ${platformFile.toString()}");
                  });
                }
              },
              child: Text(
                "Selecciona una imagen",
                style: TextStyle(color: appTheme.onPrimary),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text("Imagen seleccionada: ${platformFile.path}"),
          const SizedBox(height: 20),

          (ref.read(classUserAvatarProvider).rows[0].value.id == "")
              ? Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: appTheme.primary,
                    ),
                    onPressed: () async {
                      // Ruta del archivo local
                      filePath = platformFile.path!;
                      //debugPrintLevels(6, "10 GestionAvatares build filePath: ${platformFile.path!}");
                      // Subir el archivo-------------------------------------------------------------
                      // ignore: unused_local_variable
                      String fileUrl = "";
                      await ref
                          .read(classUserAvatarProvider.notifier)
                          .guardaArchivoAvatar(platformFile, parametroUserID)
                          .then((onValue) {
                            // if (onValue == 201) {}
                            ref
                                .read(classUserAvatarProvider.notifier)
                                .recuperaDatosDelAvatar(
                                  ref
                                      .read(sessionProvider)
                                      .rows[0]
                                      .value
                                      .userId,
                                  ref,
                                )
                                .then((onValue) async {
                                  debugPrintLevels(
                                    6,
                                    "15 GestionAvatares build recuperaImagenDelAvatar",
                                  );
                                  await showMessageDialog(
                                    context,
                                    "Guarda Avatar",
                                    codigoCouchDB[onValue]!.label,
                                    appTheme.primary,
                                    TextAlign.center,
                                  );
                                  setState(() {});
                                });
                          });
                      // Subir el archivo-------------------------------------------------------------
                      //debugPrintLevels(6, "11 GestionAvatares build guardaArchivoAvatar fileUrl: $fileUrl");
                    },
                    child: Text(
                      'Guardar imagen como avatar',
                      style: TextStyle(color: appTheme.onPrimary),
                    ),
                  ),
                )
              //------------------------------------------------------------------------------
              : Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: appTheme.primary,
                    ),
                    onPressed: () async {
                      // Ruta del archivo local
                      filePath = platformFile.path!;
                      //debugPrintLevels(6, "12 GestionAvatares build filePath: $filePath");
                      //debugPrintLevels(6, "13 GestionAvatares build platformFile: $platformFile");
                      // Actualizar el archivo-------------------------------------------------------------
                      //ref.read(classUserAvatarProvider).rows[0].value.id;
                      //ref.read(classUserAvatarProvider).rows[0].value.idUsuario;
                      //String recordId, String filePath,PlatformFile file, String rev, String idUsuario)
                      ref
                          .read(classUserAvatarProvider.notifier)
                          .updateUserAvatarFile(
                            ref.read(classUserAvatarProvider).rows[0].value.id,
                            filePath,
                            platformFile,
                            ref.read(classUserAvatarProvider).rows[0].value.rev,
                            ref
                                .read(classUserAvatarProvider)
                                .rows[0]
                                .value
                                .idFoto,
                            ref
                                .read(classUserAvatarProvider)
                                .rows[0]
                                .value
                                .idUsuario,
                          )
                          .then((onValue) async {
                            //debugPrintLevels(6, "14 GestionAvatares build updateUserAvatarFile resultado: ${onValue.toString()}");
                            await showMessageDialog(
                              context,
                              "Actualiza Avatar",
                              codigoCouchDB[onValue]!.label,
                              appTheme.primary,
                              TextAlign.center,
                            );
                            if (onValue == 201) {
                              ref
                                  .read(classUserAvatarProvider.notifier)
                                  .recuperaDatosDelAvatar(
                                    ref
                                        .read(classUserAvatarProvider)
                                        .rows[0]
                                        .value
                                        .idUsuario,
                                    ref,
                                  )
                                  .then((onValue) async {
                                    await showMessageDialog(
                                      context,
                                      "Recupera Imagen del Avatar",
                                      codigoCouchDB[onValue]!.label,
                                      appTheme.primary,
                                      TextAlign.center,
                                    );
                                    Navigator.pushNamed(
                                      context,
                                      AppRoutes.principal,
                                      arguments: "",
                                    );
                                  });
                            }
                          });
                      // Subir el archivo-------------------------------------------------------------
                    },
                    child: Text(
                      'Cambiar avatar del perfil',
                      style: TextStyle(color: appTheme.onPrimary),
                    ),
                  ),
                ),

          // Llamar a la función para recuperar el archivo adjunto-----------------------
          const SizedBox(height: 20),
          Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: appTheme.primary,
              ),
              child: Text(
                "Recupera avatar",
                style: TextStyle(color: appTheme.onPrimary),
              ),
              onPressed: () async {
                ref
                    .read(classUserAvatarProvider.notifier)
                    .recuperaDatosDelAvatar(
                      ref.read(sessionProvider).rows[0].value.userId,
                      ref,
                    )
                    .then((onValue) async {
                      debugPrintLevels(
                        6,
                        "15 GestionAvatares build recuperaImagenDelAvatar Sin Archivo de Avatar",
                      );
                      await showMessageDialog(
                        context,
                        "Recupera Avatar",
                        // ignore: collection_methods_unrelated_type
                        codigoCouchDB[onValue]!.label,
                        appTheme.primary,
                        TextAlign.center,
                      );
                      // ignore: prefer_is_empty
                      setState(() {});
                    });
              },
            ),
          ),
        ],
      ),
    );
  }

  void openFile(PlatformFile file) {
    OpenFile.open(file.path!);
  }
}

Uint8List convierteData2Imagen(String avatar) {
  String fileContentBase64 = avatar;
  List<int> fileBytes = base64Decode(fileContentBase64);
  Uint8List filesMemory = Uint8List.fromList(fileBytes);
  return filesMemory;
}
*/
