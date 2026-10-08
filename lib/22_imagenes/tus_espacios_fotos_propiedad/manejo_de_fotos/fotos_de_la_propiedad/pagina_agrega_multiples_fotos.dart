import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:open_filex/open_filex.dart';

import '../../../../08_pantallas/inicio/data_espacios_casas.dart';
import '../../../../08_pantallas/inicio/data_espacios_casas_get.dart';
import '../../../../08_pantallas/ubicacion/data_sepomex_localidades.dart';
import '../../../../20_var_globales/var_color_themes.dart';
import '../../../../42_sistema_operativo/detecta_os.dart';
import '../../../../60_global_widgets/debugprint.dart';
import '../../../../60_global_widgets/dialogbox_mensaje_general.dart';
import '../../funciones_compress_image.dart';
import '../../image_file_structure.dart';
import '../futures_y_providers/http_funciones_gestion_foto.dart';

// Llamar a la función para recuperar el archivo adjunto
/*
https://citigov.digital:6984/buscobien_avatares/_design/DDUSER/_view/vistaUserID?key="c1bf4828863f215d9281122501d2c34add3d290ca739edbd9cdb8ad96fea4403"
*/

// ignore: must_be_immutable
class AgregaMultiplesFotos extends ConsumerStatefulWidget {
  Map<String, dynamic> parametros;
  AgregaMultiplesFotos(this.parametros, {super.key});

  @override
  // ignore: no_logic_in_create_state
  ConsumerState createState() {
    debugPrintLevels(10, "1. AgregaMultiplesFotos createState");
    return AgregaMultiplesFotosState();
  }
}

class AgregaMultiplesFotosState extends ConsumerState<AgregaMultiplesFotos> {
  // Lista principal de fotos procesadas
  List<PlatformFileNoFinal> listadefotos = [];

  String idUsuario = "";
  String idPropiedad = "";
  String idFoto = "";

  // Variable para controlar el estado de carga (loading spinner)
  bool _isLoading = false;

  // Objeto propiedad (Mantenido según original)
  ValueEspaciosCasaGet propiedad = ValueEspaciosCasaGet(
    id: "",
    rev: "",
    espacioscasa: EspaciosCasa(
      versiondelformato: "01.00",
      idPropiedad: "",
      clavedelapropiedad: "",
      idusuario: "",
      tipodeanuncio: "",
      tipodepropiedad: "",
      tipodetransaccion: "",
      idTransaccion: "",
      nombredelapropiedad: "",
      inmobiliaria: "",
      inmobiliariaimagen: "",
      linkinmobiliaria: "",
      sloganinmobiliaria: "",
      ubicaciongeneral: "",
      descripcion: "",
      letreropromocional: "",
      metrosdeterreno: "",
      metrosconstruidos: "",
      recamaras: "",
      banos: "",
      mediosbanos: "",
      cuartosdeservicio: "",
      estacionamientos: "",
      estacionamientoscubiertos: "",
      datosadicionalescasa: Datosadicionalescasa(
        panelessolares: "",
        jardin: "",
        alberca: "",
        calefaccion: "",
        aireacondicionado: "",
        seguridad: "",
        enfraccionamiento: "",
        casasenelconjunto: "",
        casaclub: "",
        salondeeventos: "",
        centrodenegocios: "",
        gimnacio: "",
        cisterna: "",
        almacenamientodeagua: "",
        tratamientodeaguas: "",
        otrascaracteristicas: "",
      ),
      elementosadicionalescasa: "",
      precioventa: "",
      preciorenta: "",
      mantenimiento: "",
      moneda: "",
      niveldeprioridad: "",
      condicionesdeventa: "",
      fotoprincipal: "",
      numerodefotos: "",
      linkvideo: "",
      datosdelcontactocasa: Datosdelcontactocasa(
        nombre: "",
        empresa: "",
        imgendeempresa: "",
        numerocelular: "",
        numerootro: "",
        numeroinmobiliaria: "",
        correoelectronico: "",
        idusuariocontacto: "",
        nombreusuariocontacto: "",
        imgendelcontacto: "",
      ),
      ubicacioncasa: Ubicacioncasa(
        pais: "",
        localidadCp: LocalidadCp(
          idEstado: 0,
          estado: "",
          idMunicipio: 0,
          municipio: "",
          ciudad: "",
          zona: "",
          cp: 0,
          asentamiento: "",
          tipo: "",
        ),
        calle: "",
        numeroexterior: "",
        numerointerior: "",
        entrecalle01: "",
        entrecalle02: "",
        latitud: "",
        longitud: "",
        latitudDecimal: "",
        longitudDecimal: "",
      ),
      fechadepublicacioncasa: Fechadecasa(dia: 0, mes: 0, anio: 0),
      fechadecierrecasa: Fechadecasa(dia: 0, mes: 0, anio: 0),
      activa: 1,
      timestampcasa: "",
    ),
  );

  String seleccionada = "";
  bool principalbool = false;
  bool botonGuardaFotosActive = false;

  @override
  void initState() {
    super.initState();
    debugPrintLevels(10, "1. AgregaMultiplesFotos parameters");

    // Extracción segura de parámetros
    if (widget.parametros.isNotEmpty) {
      idFoto = widget.parametros["idFoto"] ?? "";
      idUsuario = widget.parametros["idUsuario"] ?? "";
      idPropiedad = widget.parametros["idPropiedad"] ?? "";
      if (widget.parametros["propiedad"] != null) {
        propiedad = widget.parametros["propiedad"];
      }
      principalbool = widget.parametros["fotoprincipal"] ?? false;
    }

    debugPrintLevels(
      10,
      "AgregaMultiplesFotosState Params -> ID: $idUsuario, Prop: $idPropiedad",
    );
  }

  // Métodos del ciclo de vida (Mantenidos según instrucción)
  @override
  void didChangeDependencies() {
    debugPrintLevels(1, " AgregaMultiplesFotos didChangeDependencies");
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(covariant AgregaMultiplesFotos oldWidget) {
    debugPrintLevels(1, " AgregaMultiplesFotos didUpdateWidget");
    super.didUpdateWidget(oldWidget);
  }

  @override
  void deactivate() {
    debugPrintLevels(1, " AgregaMultiplesFotos deactivate");
    super.deactivate();
  }

  @override
  void dispose() {
    debugPrintLevels(1, " AgregaMultiplesFotos dispose");
    super.dispose();
  }

  // OPTIMIZACIÓN: Función auxiliar para procesar una sola foto
  // Esto permite usar Future.wait para paralelismo
  Future<PlatformFileNoFinal?> _procesarArchivo(PlatformFile file) async {
    try {
      final plataforma = ref.read(checaPlataformaProvider).nombrePlataforma;

      // ---------------------------------------------------------
      // LOGICA WINDOWS/LINUX/MACOS (Usa Path)
      // ---------------------------------------------------------
      if (plataformasCompressWin.contains(plataforma)) {
        if (file.path == null) return null;

        // Aquí fotoCompressListWin redimensiona a 800px, está bien para escritorio.
        final compressedBytes = await fotoCompressListWin(file.path!);

        return PlatformFileNoFinal(
          path: file.path!,
          name: file.name,
          size: compressedBytes.length,
          bytes: compressedBytes,
        );
      }
      // ---------------------------------------------------------
      // LOGICA WEB/MOVIL (Usa Bytes)
      // ---------------------------------------------------------
      else if (plataformasCompressWeb.contains(plataforma)) {
        Uint8List? bytesToCompress = file.bytes;

        // MEJORA DE SEGURIDAD PARA MOVIL:
        // En Web 'path' es null, pero en Móvil 'bytes' puede ser null.
        // Si no hay bytes pero hay path (caso Android/iOS nativo), los leemos.
        if (bytesToCompress == null && file.path != null) {
          final File fileIo = File(file.path!);
          bytesToCompress = await fileIo.readAsBytes();
        }

        if (bytesToCompress != null) {
          // CAMBIO REALIZADO AQUÍ: Usamos fotoCompressListWebP
          // Reducimos a ~620px para que sea una miniatura ligera.
          final compressedBytes = await fotoCompressListWebP(
            bytesToCompress,
            20,
          );

          return PlatformFileNoFinal(
            path: file.path ?? "",
            name: file.name,
            size: compressedBytes
                .length, // Ya no es nullable porque fotoCompressListWebP retorna Uint8List
            bytes: compressedBytes,
          );
        }
      }
      return null;
    } catch (e) {
      debugPrintLevels(0, "Error procesando archivo ${file.name}: $e");
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    debugPrintLevels(10, "1. AgregaMultiplesFotos build");

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 40.0,
        centerTitle: true,
        titleSpacing: 0,
        backgroundColor: appTheme.primary,
        iconTheme: IconThemeData(size: 14, color: appTheme.onPrimary),
        title: Text(
          "Agrega fotos de la propiedad",
          style: TextStyle(
            color: appTheme.onPrimary,
            fontWeight: FontWeight.normal,
            fontSize: 14,
          ),
        ),
      ),
      // Stack para sobreponer el indicador de carga
      body: Stack(
        children: [
          Column(
            children: [
              // BOTÓN SELECCIONAR FOTOS
              Container(
                color: appTheme.onPrimary,
                height: 60,
                child: Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: appTheme.primary,
                    ),
                    onPressed: _isLoading
                        ? null
                        : () async {
                            setState(() {
                              botonGuardaFotosActive = false;
                              _isLoading = true; // Activar loading
                            });

                            listadefotos.clear();
                            debugPrintLevels(
                              10,
                              "**** Selecciona FilePicker.platform",
                            );

                            try {
                              final result = await FilePicker.platform.pickFiles(
                                type: FileType.image,
                                allowMultiple: true,
                                compressionQuality: 0,
                                withData:
                                    true, // Asegura bytes en Web/Desktop si es necesario
                              );

                              if (result == null || result.files.isEmpty) {
                                if (mounted) {
                                  setState(() {
                                    _isLoading = false;
                                  });
                                  await showMessageDialog(
                                    context,
                                    "Aviso",
                                    "No se seleccionaron fotos",
                                    appTheme.primary,
                                    TextAlign.center,
                                    "Salir",
                                  );
                                }
                                return;
                              }

                              debugPrintLevels(
                                10,
                                "Archivos seleccionados: ${result.files.length}",
                              );

                              // OPTIMIZACIÓN: Procesamiento en paralelo
                              final futures = result.files.map(
                                (file) => _procesarArchivo(file),
                              );
                              final processedFiles = await Future.wait(futures);

                              // Filtrar nulos (errores) y agregar a la lista
                              listadefotos.addAll(
                                processedFiles.whereType<PlatformFileNoFinal>(),
                              );

                              if (mounted) {
                                setState(() {
                                  botonGuardaFotosActive =
                                      listadefotos.isNotEmpty;
                                  _isLoading = false; // Desactivar loading
                                });
                              }
                            } catch (e) {
                              debugPrintLevels(0, "Error en picker: $e");
                              if (mounted) setState(() => _isLoading = false);
                            }
                          },
                    child: _isLoading
                        ? SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: appTheme.onPrimary,
                              strokeWidth: 2,
                            ),
                          )
                        : Text(
                            "Agrega fotos",
                            style: TextStyle(color: appTheme.onPrimary),
                          ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // VISTA PREVIA DE FOTOS
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Wrap(
                      spacing: 10.0,
                      runSpacing: 10.0,
                      direction: Axis.horizontal,
                      children: List.generate(listadefotos.length, (index) {
                        return SizedBox(
                          width: 150,
                          height: 100,
                          child: listadefotos[index].bytes != null
                              ? Ink.image(
                                  fit: BoxFit.cover, // Cover suele verse mejor
                                  image: MemoryImage(
                                    listadefotos[index].bytes!,
                                  ),
                                )
                              : const Center(child: Icon(Symbols.error)),
                        );
                      }),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // BARRA INFERIOR (GUARDAR / CANCELAR)
              Container(
                color: appTheme.onPrimary,
                height: 60,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // BOTON GUARDAR
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll<Color>(
                          botonGuardaFotosActive
                              ? appTheme.primary
                              : appTheme.tertiary,
                        ),
                      ),
                      onPressed: (botonGuardaFotosActive && !_isLoading)
                          ? () async {
                              setState(() => _isLoading = true);

                              try {
                                // OPTIMIZACIÓN: Guardado en paralelo
                                // Creamos una lista de futuros para guardar todas a la vez
                                final uploadFutures = listadefotos.map((foto) {
                                  final seleccionadaLocal = base64Encode(
                                    List<int>.from(foto.bytes as Iterable),
                                  );

                                  return guardaFotoEnFotosDeLaPropiedad(
                                    foto,
                                    seleccionadaLocal,
                                    idUsuario,
                                    idPropiedad,
                                  );
                                });

                                // Esperamos a que todas terminen
                                final results = await Future.wait(
                                  uploadFutures,
                                );
                                debugPrintLevels(
                                  10,
                                  "Se guardaron ${results.length} fotos.",
                                );

                                if (mounted) {
                                  // Mostrar mensaje final
                                  String mensaje = results.length == 1
                                      ? "Se guardó una foto"
                                      : "Se guardaron ${results.length} fotos";

                                  await showMessageDialog(
                                    context,
                                    "Aviso",
                                    mensaje,
                                    appTheme.primary,
                                    TextAlign.center,
                                    "Salir",
                                  );

                                  if (mounted) Navigator.of(context).pop();
                                }
                              } catch (e) {
                                debugPrintLevels(
                                  0,
                                  "Error guardando fotos: $e",
                                );
                                if (mounted) {
                                  showMessageDialog(
                                    context,
                                    "Error",
                                    "Error al guardar: $e",
                                    appTheme.error,
                                    TextAlign.center,
                                    "Salir",
                                  );
                                }
                              } finally {
                                if (mounted) setState(() => _isLoading = false);
                              }
                            }
                          : null,
                      child: Icon(
                        Symbols.save,
                        size: 18,
                        color: appTheme.onPrimary,
                      ),
                    ),
                    const SizedBox(width: 10),
                    // BOTON CANCELAR
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll<Color>(
                          appTheme.primary,
                        ),
                      ),
                      onPressed: () {
                        if (!_isLoading) Navigator.of(context).pop();
                      },
                      child: Icon(
                        Symbols.cancel,
                        size: 18,
                        color: appTheme.onPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // INDICADOR DE CARGA GLOBAL (OVERLAY)
          if (_isLoading)
            Container(
              color: Colors.black.withValues(alpha: 0.5),
              child: Center(
                child: CircularProgressIndicator(color: appTheme.primary),
              ),
            ),
        ],
      ),
    );
  }

  void openFile(PlatformFile file) {
    if (file.path != null) {
      OpenFilex.open(file.path!);
    }
  }
}

//-------------------------------------------------------------------------
