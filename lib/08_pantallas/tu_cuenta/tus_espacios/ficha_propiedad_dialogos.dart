part of 'ficha_propiedad_card.dart';

// Diálogos de la ficha: publicar, dejar de publicar y eliminar el espacio.
// Se mantienen como extensión del estado de la tarjeta para no cambiar su comportamiento.
extension _DialogosFicha on _FichaPropiedadCardState {
  // --- DIALOGS CON ASYNC/AWAIT ---
  //OPTIMIZADO
  Future<String?> openDialogPublicar(BuildContext context) {
    String mensajeCentral = "¿Quiéres publicar la propiedad?";
    bool bannerConfirma = true;
    // NUEVO: Variable para controlar el estado de carga
    bool isProcessing = false;

    return showDialog<String>(
      context: context,
      barrierDismissible: false, // Evitar cierre accidental
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              elevation: 6,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(6)),
              ),
              titleTextStyle: TextStyle(
                color: appTheme.onPrimary,
                fontSize: 10,
                fontFamily: "Comfortaa",
                fontWeight: FontWeight.bold,
              ),
              contentTextStyle: TextStyle(
                color: appTheme.secondary,
                backgroundColor: appTheme.onSecondary,
                fontSize: 12,
                fontWeight: FontWeight.normal,
              ),
              titlePadding: const EdgeInsets.fromLTRB(6, 12, 6, 6),
              contentPadding: const EdgeInsets.all(3),
              actionsPadding: const EdgeInsets.all(3),
              backgroundColor: appTheme.primary,
              title: Text(
                "Publicaciones",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: appTheme.onPrimary,
                  fontSize: 10,
                  fontFamily: "Comfortaa",
                  fontWeight: FontWeight.bold,
                ),
              ),
              // OPTIMIZACIÓN: Se elimina altura fija y se permite ajuste dinámico
              content: Container(
                color: appTheme.onSecondary,
                padding: const EdgeInsets.all(6),
                child: Column(
                  mainAxisSize: MainAxisSize.min, // Ajustar al contenido
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // UX: Mostrar indicador de carga si se está procesando
                    if (isProcessing)
                      const Padding(
                        padding: EdgeInsets.all(10.0),
                        child: CircularProgressIndicator(),
                      )
                    else
                      Text(
                        mensajeCentral,
                        textAlign: TextAlign.center,
                        maxLines:
                            4, // Aumentado para permitir mensajes de error más largos
                        style: TextStyle(
                          color: appTheme.onPrimaryContainer,
                          fontSize: fontSizeCard,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                  ],
                ),
              ),
              actions: [
                // Botón "Sí" (Oculto si ya se confirmó o está procesando)
                if (bannerConfirma && !isProcessing)
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.fromLTRB(3, 0, 3, 0),
                      backgroundColor: appTheme.surface,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: Text(
                      "Si",
                      style: TextStyle(
                        color: appTheme.onPrimaryContainer,
                        fontSize: 10,
                        fontFamily: "Comfortaa",
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: () async {
                      // Actualizar UI a estado de carga
                      setStateDialog(() {
                        isProcessing = true;
                        bannerConfirma = false;
                      });

                      String idPublicacion =
                          widget.propiedad.espacioscasa.fotoprincipal;
                      int publicacionActiva =
                          widget.propiedad.espacioscasa.activa;

                      try {
                        // 1. Intentar publicar en CouchDB LA PROPIEDAD
                        String resultado =
                            await upsertEspacioPublicadoToCouchDB(
                          widget.propiedad.espacioscasa.tipodeanuncio,
                          widget.propiedad,
                        );

                        debugPrintLevels(
                          10,
                          '*** PUBLICACIÓN EXITOSA. ID PUBLICACIÓN: $resultado',
                        );
                        if (resultado != "") {
                          // REFERENCIA CACHEADA PARA OPTIMIZACIÓN
                          // 2. Actualizar objeto local ESPACIO
                          // SOLO SI NO HA SIDO PUBLICADO
                          debugPrintLevels(
                            10,
                            '*** FOTO PRINCIPAL: ${widget.propiedad.espacioscasa.fotoprincipal}',
                          );
                          debugPrintLevels(
                            10,
                            '*** ACTIVA: ${widget.propiedad.espacioscasa.activa}',
                          );
                          if ((idPublicacion == "") ||
                              (publicacionActiva == 0)) {
                            debugPrintLevels(
                              10,
                              '*** PUBLICACIÓN PRIMERA VEZ: $resultado',
                            );
                            widget.propiedad.espacioscasa.activa = 1;
                            widget.propiedad.espacioscasa.fotoprincipal =
                                resultado;

                            // 3. Actualizar índice en Riverpod
                            int index = ref
                                .read(espaciosCasaConListaFotosGetProvider)
                                .espaciosCasas
                                .rows
                                .indexWhere(
                                  (p) =>
                                      p.value.espacioscasa.idPropiedad ==
                                      widget.propiedad.espacioscasa.idPropiedad,
                                );
                            int dbResult = 0;
                            if (index != -1) {
                              ref
                                  .read(
                                    espaciosCasaConListaFotosGetProvider
                                        .notifier,
                                  )
                                  .setIndexEspaciosCasas(index);

                              // 4. Actualizar estado global
                              ref
                                  .read(
                                    espaciosCasaConListaFotosGetProvider
                                        .notifier,
                                  )
                                  .setEspaciosCasasGet(widget.propiedad);

                              // 5. Guardar actualización del espacio en DB
                              dbResult = await ref
                                  .read(
                                    espaciosCasaConListaFotosGetProvider
                                        .notifier,
                                  )
                                  .updatePropiedadCasaGetToCouchDB();

                              debugPrintLevels(
                                10,
                                '*** RESULTADO ACTUALIZA ESPACIO: $dbResult',
                              );
                            }
                            if ((dbResult == 200 ||
                                    dbResult == 201 ||
                                    dbResult == 202) &&
                                (index != -1)) {
                              // ÉXITO TOTAL
                              debugPrintLevels(
                                10,
                                '*** UPDATE DEL ESPACIO: $dbResult',
                              );
                              if (context.mounted) {
                                setStateDialog(() {
                                  isProcessing = false;
                                  mensajeCentral = "Se publicó la propiedad.";
                                });
                              }
                            } else {
                              // FALLO EN UPDATE DEL ESPACIO -> ROLLBACK
                              // Intentar borrar la publicación huérfana
                              String errorMsg = "";
                              debugPrintLevels(
                                10,
                                '*** FALLO EN UPDATE DEL ESPACIO -> ROLLBACK: $dbResult',
                              );
                              int borraPublicacion =
                                  await deleteEspacioPublicadoToCouchDB(
                                widget.propiedad.espacioscasa.tipodeanuncio,
                                widget.propiedad.espacioscasa.fotoprincipal,
                              );
                              if (borraPublicacion != 200 &&
                                  borraPublicacion != 201 &&
                                  borraPublicacion != 202) {
                                // Revertir cambios locales
                                widget.propiedad.espacioscasa.activa = 0;
                                widget.propiedad.espacioscasa.fotoprincipal =
                                    "";
                                ref
                                    .read(
                                      espaciosCasaConListaFotosGetProvider
                                          .notifier,
                                    )
                                    .setEspaciosCasasGet(widget.propiedad);

                                errorMsg =
                                    "Error: no se pudo actualizar el espacio.";

                                errorMsg +=
                                    "\nNota: La publicación se creó pero no se vinculó correctamente al espacio.";
                              }

                              if (context.mounted) {
                                setStateDialog(() {
                                  isProcessing = false;
                                  mensajeCentral = errorMsg;
                                });
                              }
                            }
                          } else {
                            debugPrintLevels(
                              10,
                              '*** ACTUALIZACIÓN DE LA PUBLICACIÓN ',
                            );
                            if (context.mounted) {
                              setStateDialog(() {
                                isProcessing = false;
                                mensajeCentral = "Se actualizó la publicación.";
                              });
                            }
                          }
                        } else {
                          // FALLO AL OBTENER RESULTADO DE PUBLICACIÓN
                          debugPrintLevels(
                            10,
                            '*** PUBLICACIÓN PRIMERA VEZ: $resultado',
                          );
                          widget.propiedad.espacioscasa.activa = 0;
                          widget.propiedad.espacioscasa.fotoprincipal = "";

                          if (context.mounted) {
                            setStateDialog(() {
                              isProcessing = false;
                              mensajeCentral =
                                  "Error: no se pudo publicar la propiedad.";
                            });
                          }
                        }
                      } catch (e) {
                        // MANEJO DE EXCEPCIONES GENERALES
                        // Revertir estado local por seguridad visual
                        widget.propiedad.espacioscasa.activa = 0;
                        widget.propiedad.espacioscasa.fotoprincipal = "";

                        if (context.mounted) {
                          setStateDialog(() {
                            isProcessing = false;
                            mensajeCentral = "Error de conexión o inesperado.";
                          });
                        }
                      }
                    },
                  ),

                // Botón "No" / "Salir"
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: appTheme.surface,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  // Bloquear botón si está procesando
                  onPressed: isProcessing
                      ? null
                      : () {
                          Navigator.of(context).pop();
                        },
                  child: Text(
                    (bannerConfirma) ? "No" : "Salir",
                    style: TextStyle(
                      // Cambiar color si está deshabilitado
                      color: isProcessing
                          ? Colors.grey
                          : appTheme.onPrimaryContainer,
                      fontSize: 10,
                      fontFamily: "Comfortaa",
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // OPTIMIZADO
  Future<String?> openDialogBorraPublicacion(BuildContext context) {
    String mensajeCentral = "¿Quiéres eliminar la publicación?";
    bool bannerConfirma = true;
    // NUEVO: Variable para controlar el estado de carga y evitar múltiples clics
    bool isProcessing = false;

    return showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              elevation: 6,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(6)),
              ),
              titleTextStyle: TextStyle(
                color: appTheme.onPrimary,
                //backgroundColor: lightINE.onTertiary,
                fontSize: 10,
                fontFamily: "Comfortaa",
                fontWeight: FontWeight.bold,
              ),
              contentTextStyle: TextStyle(
                color: appTheme.secondary,
                backgroundColor: appTheme.onSecondary,
                fontSize: 12,
                //fontFamily: "Comfortaa",
                fontWeight: FontWeight.normal,
              ),
              titlePadding: const EdgeInsets.fromLTRB(6, 12, 6, 6),
              contentPadding: const EdgeInsets.all(3),
              actionsPadding: const EdgeInsets.all(3),
              backgroundColor: appTheme.primary,
              title: Text(
                "Publicaciones",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: appTheme.onPrimary,
                  fontSize: 10,
                  fontFamily: "Comfortaa",
                  fontWeight: FontWeight.bold,
                ),
              ),
              // OPTIMIZACIÓN: Layout flexible para evitar overflow de texto
              content: Container(
                color: appTheme.onSecondary,
                padding: const EdgeInsets.all(6),
                child: Column(
                  mainAxisSize: MainAxisSize.min, // Se ajusta al contenido
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // LÓGICA UI: Si está procesando, muestra loader, si no, el texto
                    if (isProcessing)
                      const Padding(
                        padding: EdgeInsets.all(10.0),
                        child: CircularProgressIndicator(),
                      )
                    else
                      Text(
                        mensajeCentral,
                        textAlign: TextAlign.center,
                        maxLines: 3, // Aumentado ligeramente por seguridad
                        style: TextStyle(
                          color: appTheme.onPrimaryContainer,
                          fontSize: fontSizeCard,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                  ],
                ),
              ),
              actions: [
                // Botón "Sí" (Solo visible si bannerConfirma es true y no está cargando)
                if (bannerConfirma && !isProcessing)
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: appTheme.surface,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: Text(
                      "Si",
                      style: TextStyle(
                        color: appTheme.onPrimaryContainer,
                        fontSize: 10,
                        fontFamily: "Comfortaa",
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: () async {
                      // 1. Activar estado de carga
                      setStateDialog(() {
                        isProcessing = true;
                      });

                      try {
                        // 2. Llamada asíncrona para eliminar
                        var resultado = await deleteEspacioPublicadoToCouchDB(
                          widget.propiedad.espacioscasa.tipodeanuncio,
                          widget.propiedad.espacioscasa.fotoprincipal,
                        );

                        // Verificamos si el contexto sigue montado antes de continuar
                        if (!context.mounted) return;

                        if (resultado == 200 ||
                            resultado == 201 ||
                            resultado == 202) {
                          // 3. Lógica de negocio (Riverpod) simplificada
                          // Obtenemos el notifier una sola vez
                          final espaciosNotifier = ref.read(
                            espaciosCasaConListaFotosGetProvider.notifier,
                          );

                          // Obtenemos la data actual para buscar el índice
                          final espaciosData = ref.read(
                            espaciosCasaConListaFotosGetProvider,
                          );

                          int index =
                              espaciosData.espaciosCasas.rows.indexWhere(
                            (p) =>
                                p.value.espacioscasa.idPropiedad ==
                                widget.propiedad.espacioscasa.idPropiedad,
                          );

                          if (index != -1) {
                            espaciosNotifier.setIndexEspaciosCasas(index);
                          }

                          // Actualización local de la propiedad
                          widget.propiedad.espacioscasa.activa = 0;
                          widget.propiedad.espacioscasa.fotoprincipal = "";

                          // Actualizar estado en Riverpod
                          espaciosNotifier.setEspaciosCasasGet(
                            widget.propiedad,
                          );

                          // 4. Segunda llamada asíncrona (Actualizar DB)
                          // Usamos await en lugar de .then para mantener el flujo limpio
                          await espaciosNotifier
                              .updatePropiedadCasaGetToCouchDB();

                          // 5. Actualizar UI con éxito
                          if (context.mounted) {
                            setStateDialog(() {
                              isProcessing = false;
                              bannerConfirma = false;
                              mensajeCentral = "Se eliminó la publicación.";
                            });
                          }
                        } else {
                          // Manejo de error de respuesta (no excepción)
                          if (context.mounted) {
                            setStateDialog(() {
                              isProcessing = false;
                              // bannerConfirma se mantiene true para
                              // permitir reintentar o cancelar
                              mensajeCentral = "Error: no se pudo eliminar.";
                            });
                          }
                        }
                      } catch (e) {
                        // Manejo de excepciones
                        if (context.mounted) {
                          setStateDialog(() {
                            isProcessing = false;
                            bannerConfirma =
                                false; // Ocultamos el 'Sí' para obligar a salir
                            mensajeCentral = "Error de conexión o inesperado.";
                          });
                        }
                      }
                    },
                  ),

                // Botón "No" / "Salir" (Deshabilitado visualmente si está procesando)
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: appTheme.surface,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  // Bloqueamos el botón si está procesando
                  onPressed: isProcessing
                      ? null
                      : () {
                          Navigator.of(context).pop();
                        },
                  child: Text(
                    (bannerConfirma) ? "No" : "Salir",
                    style: TextStyle(
                      // Cambiamos el color si está deshabilitado para feedback visual
                      color: isProcessing
                          ? Colors.grey
                          : appTheme.onPrimaryContainer,
                      fontSize: 10,
                      fontFamily: "Comfortaa",
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  //----------------------------------------------------------------------------
  Future<String?> openDialogBorraEspacio(BuildContext context) {
    String mensajeCentral = "¿Quiéres eliminar el espacio?";
    bool bannerConfirma = true;

    return showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              elevation: 6,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(6)),
              ),
              backgroundColor: appTheme.primary,
              title: Text(
                "Espacios",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: appTheme.onPrimary,
                  fontSize: 10,
                  fontFamily: "Comfortaa",
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: Container(
                color: appTheme.onSecondary,
                height: 80,
                padding: const EdgeInsets.all(6),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      mensajeCentral,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      style: TextStyle(
                        color: appTheme.onPrimaryContainer,
                        fontSize: fontSizeCard,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                if (bannerConfirma)
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: appTheme.surface,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: Text(
                      "Si",
                      style: TextStyle(
                        color: appTheme.onPrimaryContainer,
                        fontSize: 10,
                        fontFamily: "Comfortaa",
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: () async {
                      try {
                        var resultado = await deleteEspacioToCouchDB(
                          widget.propiedad.espacioscasa.tipodeanuncio,
                          widget.propiedad,
                        );

                        if (context.mounted) {
                          setStateDialog(() {
                            bannerConfirma = false;
                            if (resultado == 200 || resultado == 202) {
                              mensajeCentral = "Se borro el espacio.";
                            } else {
                              mensajeCentral = "Error: no se pudo borrar.";
                            }
                          });
                        }
                      } catch (e) {
                        if (context.mounted) {
                          setStateDialog(() {
                            bannerConfirma = false;
                            mensajeCentral = "Error de conexión";
                          });
                        }
                      }
                    },
                  ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: appTheme.surface,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: Text(
                    (bannerConfirma) ? "No" : "Salir",
                    style: TextStyle(
                      color: appTheme.onPrimaryContainer,
                      fontSize: 10,
                      fontFamily: "Comfortaa",
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }
}
