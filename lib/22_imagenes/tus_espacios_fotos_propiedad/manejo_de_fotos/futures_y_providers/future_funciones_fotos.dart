import 'package:buscobien/07_routes/app_routes.dart';
import 'package:buscobien/07_routes/routes_parameters.dart';
import 'package:buscobien/08_pantallas/inicio/data_espacios_casas_get.dart';
import 'package:buscobien/20_var_globales/couchdb_errors.dart';
import 'package:buscobien/20_var_globales/var_color_themes.dart';
import 'package:buscobien/20_var_globales/variables_globales.dart';
import 'package:buscobien/60_global_widgets/debugprint.dart';
import 'package:buscobien/60_global_widgets/dialogbox_mensaje_general.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../lista_fotos_ordenadas/future_update_fotos_orden.dart';
import '../lista_fotos_ordenadas/provider_get_lista_fotos_ordenadas.dart';
import 'http_funciones_gestion_foto.dart';
import 'provider_get_fotos_ids_user_propiedad.dart';

//------------------------------------------------------------------------------
// OPTIMIZADO

//------------------------------------------------------------------------------
// DIÁLOGO DE CONFIRMACIÓN
//------------------------------------------------------------------------------
Future<bool> dialogConfirmaBorradoFoto(BuildContext context) async {
  // OPTIMIZACIÓN: Se simplificó el retorno. Si el usuario toca fuera (barrierDismissible), devuelve false.
  final bool? seleccion = await showDialog<bool>(
    context: context,
    barrierDismissible: false, // Obliga a elegir Si o No
    builder: (context) {
      return AlertDialog(
        elevation: 6,
        backgroundColor: appTheme.error,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(6)),
        ),
        titlePadding: const EdgeInsets.fromLTRB(6, 12, 6, 6),
        contentPadding: const EdgeInsets.all(3),
        actionsPadding: const EdgeInsets.all(6),
        title: Text(
          "Eliminar Foto",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: appTheme.onPrimary,
            fontSize: 14,
            fontFamily: "Comfortaa",
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Container(
          color: appTheme.onSecondary,
          height: 80,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 10),
              Expanded(
                child: Text(
                  "¿Quieres borrar la foto?",
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  style: TextStyle(
                    color: appTheme.secondary,
                    fontSize: fontSizeCard,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
        actions: [
          // BOTÓN NO
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.all(3),
              backgroundColor: appTheme.onPrimary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            child: Text(
              "No",
              style: TextStyle(
                color: appTheme.primary,
                fontSize: 12,
                fontFamily: "Comfortaa",
                fontWeight: FontWeight.bold,
              ),
            ),
            onPressed: () {
              Navigator.of(context).pop(false);
            },
          ),
          // BOTÓN SI
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.all(3),
              backgroundColor: appTheme.onPrimary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            child: Text(
              "Si",
              style: TextStyle(
                color: appTheme.primary,
                fontSize: 12,
                fontFamily: "Comfortaa",
                fontWeight: FontWeight.bold,
              ),
            ),
            onPressed: () {
              Navigator.of(context).pop(true);
            },
          ),
        ],
      );
    },
  );

  // Si es null (por cierre inesperado), devolvemos false
  return seleccion ?? false;
}

//------------------------------------------------------------------------------
// FUNCIÓN BORRAR FOTO
//------------------------------------------------------------------------------
Future<void> borraFoto(
  BuildContext context,
  WidgetRef ref,
  int index,
  // Function refreshData,
) async {
  // 1. Confirmación de usuario
  bool borrar = await dialogConfirmaBorradoFoto(context);
  if (!borrar) return;

  // 2. Obtención de datos seguros antes de la llamada asíncrona
  final listaFotosProvider = ref.read(getListaFotosCasaProviderId);

  // Validación de seguridad para evitar crash por índice fuera de rango
  if (index < 0 || index >= listaFotosProvider.rows.length) {
    debugPrintLevels(1, "Error: Índice $index fuera de rango en borraFoto");
    return;
  }

  final String idFoto = listaFotosProvider.rows[index].value.id;
  final String revFoto = listaFotosProvider.rows[index].value.rev;

  // 3. Llamada al servicio de borrado (HTTP)
  int resultado = await deleteFotoPorIdFoto(idFoto, revFoto);

  // 4. Verificación de montaje del widget (Evita errores si el usuario salió de la pantalla)
  if (!context.mounted) return;

  // 5. Manejo de respuesta UI
  if (resultado == 200 || resultado == 202 || resultado == 404) {
    // Éxito o ya no existe
    await showMessageDialog(
      context,
      "Aviso",
      "Se eliminó la foto correctamente",
      appTheme.primary,
      TextAlign.center,
      "Salir",
    );

    // 6. Actualización del Estado Local (Riverpod)
    // Diagrama mental: Borrar de la BD -> Borrar de la Lista Local -> Borrar de la Lista de Orden -> Actualizar BD Orden

    final listaOrdenadaProvider = ref.read(getListaFotosOrdenadasProvider);

    if (listaOrdenadaProvider.rows.isNotEmpty) {
      // Buscar la foto en la lista de orden para removerla también de allí
      final listaFotosOrden =
          listaOrdenadaProvider.rows[0].value.listadefotos.fotosOrden;

      // Encontrar índice en la lista de orden que corresponde a esta foto
      // Nota: El 'index' recibido es de la lista visual, aquí buscamos por ID para estar seguros
      int indiceEnListaOrden = listaFotosOrden.indexWhere(
        (fotoOrden) => fotoOrden.idFoto == idFoto,
      );

      if (indiceEnListaOrden != -1) {
        // Remover de la lista de orden
        listaFotosOrden.removeAt(indiceEnListaOrden);

        // Remover de la lista general de fotos (Provider ID)
        // Nota: Asumimos que el 'index' pasado a la función coincide,
        // pero por seguridad usamos removeWhere o verificamos
        if (index < ref.read(getListaFotosCasaProviderId).rows.length) {
          ref.read(getListaFotosCasaProviderId).rows.removeAt(index);
        }

        // 7. Guardar el nuevo orden en la Base de Datos
        await actualizaFotosOrdenadas(listaOrdenadaProvider.rows[0].value);
      }
    }

    // 8. Refrescar la UI
    // refreshData();
  } else {
    // Error
    await showMessageDialog(
      context,
      "Error",
      "No se pudo eliminar: ${codigoCouchDB[resultado]?.label ?? 'Error desconocido ($resultado)'}",
      appTheme.error,
      TextAlign.center,
      "Salir",
    );
  }
}

//------------------------------------------------------------------------------
// FUNCIÓN AGREGAR FOTO (Individual)
//------------------------------------------------------------------------------
Future<void> agregafoto(
  BuildContext context,
  WidgetRef ref,
  ValueEspaciosCasaGet valueespaciosparameter,
) async {
  // Configuración de parámetros
  parameterGestionFoto["idUsuario"] =
      valueespaciosparameter.espacioscasa.idusuario;
  parameterGestionFoto["idPropiedad"] =
      valueespaciosparameter.espacioscasa.idPropiedad;
  parameterGestionFoto["idFoto"] = "";
  parameterGestionFoto["propiedad"] = valueespaciosparameter;

  // Calcular índice
  int currentLength = ref.read(getListaFotosCasaProviderId).rows.length;
  parameterGestionFoto["indice"] = currentLength + 1;

  // Definir si es foto principal (si la lista está vacía, la primera es principal)
  parameterGestionFoto["fotoprincipal"] = (currentLength == 0);

  debugPrintLevels(10, "CALL AppRoutes.fotosagregafotoalista");

  // Navegación asíncrona
  final seagregofoto = await Navigator.pushNamed(
    context,
    AppRoutes.fotosagregafotoalista,
    arguments: parameterGestionFoto,
  );

  // Actualización si se agregó algo
  if (seagregofoto != null) {
    debugPrintLevels(10, "Foto agregada, actualizando orden...");

    // Notificar al provider que agregue la foto a la lista de posiciones
    ref
        .read(getListaFotosOrdenadasProvider.notifier)
        .agregaFotoListaPosiciones();

    // Sincronizar con la BD si hay datos
    final listaOrdenada = ref.read(getListaFotosOrdenadasProvider);
    if (listaOrdenada.rows.isNotEmpty) {
      await actualizaFotosOrdenadas(listaOrdenada.rows[0].value);
    }
  }
}

//------------------------------------------------------------------------------
// FUNCIÓN AGREGAR FOTOS (Múltiples)
//------------------------------------------------------------------------------
Future<void> agregamultiplesfotos(
  BuildContext context,
  WidgetRef ref,
  ValueEspaciosCasaGet valueespaciosparameter,
) async {
  // Nota: La lógica es idéntica a 'agregafoto' porque ambas rutas parecen manejar
  // la lógica interna de múltiple/simple, pero se mantiene separada según solicitud.

  parameterGestionFoto["idUsuario"] =
      valueespaciosparameter.espacioscasa.idusuario;
  parameterGestionFoto["idPropiedad"] =
      valueespaciosparameter.espacioscasa.idPropiedad;
  parameterGestionFoto["idFoto"] = "";
  parameterGestionFoto["propiedad"] = valueespaciosparameter;

  int currentLength = ref.read(getListaFotosCasaProviderId).rows.length;
  parameterGestionFoto["indice"] = currentLength + 1;

  parameterGestionFoto["fotoprincipal"] = (currentLength == 0);

  debugPrintLevels(10, "CALL AppRoutes.fotosagregafotoalista (Multiple)");

  final seagregofoto = await Navigator.pushNamed(
    context,
    AppRoutes.fotosagregafotoalista,
    arguments: parameterGestionFoto,
  );

  if (seagregofoto != null) {
    ref
        .read(getListaFotosOrdenadasProvider.notifier)
        .agregaFotoListaPosiciones();

    final listaOrdenada = ref.read(getListaFotosOrdenadasProvider);
    if (listaOrdenada.rows.isNotEmpty) {
      await actualizaFotosOrdenadas(listaOrdenada.rows[0].value);
    }
  }
}

//------------------------------------------------------------------------------
/*
Future<bool> dialogConfirmaBorradoFoto(BuildContext context) async {
  bool seleccion = false;
  await showDialog<bool>(
    //terminar sesión
    context: context,
    builder: (context) {
      return AlertDialog(
        elevation: 6,
        backgroundColor: appTheme.error,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(6)),
        ),
        titleTextStyle: TextStyle(
          color: appTheme.onPrimary,
          //backgroundColor: appTheme.onTertiary,
          fontSize: 14,
          fontFamily: "Comfortaa",
          fontWeight: FontWeight.bold,
        ),
        contentTextStyle: TextStyle(
          color: appTheme.tertiary,
          backgroundColor: appTheme.onSecondary,
          fontSize: 12,
          //fontFamily: "Comfortaa",
          fontWeight: FontWeight.normal,
        ),
        titlePadding: const EdgeInsets.fromLTRB(6, 12, 6, 6),
        contentPadding: const EdgeInsets.all(3),
        actionsPadding: const EdgeInsets.all(6),
        title: const Text("Eliminar Foto", textAlign: TextAlign.center),
        content: Container(
          color: appTheme.onSecondary,
          height: 80,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("", maxLines: 1),
              Expanded(
                child: Text(
                  "¿Quiéres borrar la foto?",
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  style: TextStyle(
                    color: appTheme.secondary,
                    fontSize: fontSizeCard,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
              const Text("", maxLines: 1),
            ],
          ),
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.all(3),
              backgroundColor: appTheme.onPrimary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            child: Text(
              "No",
              style: TextStyle(
                color: appTheme.primary,
                //backgroundColor: appTheme.onTertiary,
                fontSize: 12,
                fontFamily: "Comfortaa",
                fontWeight: FontWeight.bold,
              ),
            ),
            onPressed: () {
              seleccion = false;
              debugPrintLevels(10, "dialogConfirmaBorradoFoto: $seleccion");
              Navigator.of(context).pop(seleccion);
            },
          ),
          // ----------------------------------------------------------------------------
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.all(3),
              backgroundColor: appTheme.onPrimary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            child: Text(
              "Si",
              style: TextStyle(
                color: appTheme.primary,
                //backgroundColor: appTheme.onTertiary,
                fontSize: 12,
                fontFamily: "Comfortaa",
                fontWeight: FontWeight.bold,
              ),
            ),
            onPressed: () async {
              seleccion = true;
              debugPrintLevels(10, "dialogConfirmaBorradoFoto: $seleccion");
              Navigator.of(context).pop(seleccion);
            },
          ),
        ],
      );
    },
  );
  return seleccion;
}

Future<Null> borraFoto(
  BuildContext context,
  WidgetRef ref,
  int index,
  refreshData,
) async {
  return await dialogConfirmaBorradoFoto(context).then((borrar) async {
    if (borrar) {
      await deleteFotoPorIdFoto(
        // ignore: use_build_context_synchronously
        ref.read(getListaFotosCasaProviderId).rows[index].value.id,
        ref.read(getListaFotosCasaProviderId).rows[index].value.rev,
      ).then((resultado) async {
        (resultado == 200)
            // ignore: use_build_context_synchronously
            ? await showMessageDialog(
                context,
                "Aviso",
                "Se eliminó la foto",
                appTheme.primary,
                TextAlign.center,
              )
            : await showMessageDialog(
                // ignore: use_build_context_synchronously
                context,
                "Error",
                "Error ${resultado.toString()}: ${codigoCouchDB[resultado]?.label}",
                appTheme.error,
                TextAlign.center,
              );
        if (ref.read(getListaFotosOrdenadasProvider).rows.isNotEmpty) {
          int indiceFoto = ref
              .read(getListaFotosCasaProviderId)
              .rows
              .indexWhere(
                (test) =>
                    test.value.fotosCasa.idFoto ==
                    ref
                        .read(getListaFotosOrdenadasProvider)
                        .rows[0]
                        .value
                        .listadefotos
                        .fotosOrden[index]
                        .idFoto,
              );
          ref
              .read(getListaFotosOrdenadasProvider)
              .rows[0]
              .value
              .listadefotos
              .fotosOrden
              .removeAt(index);
          ref.read(getListaFotosCasaProviderId).rows.removeAt(indiceFoto);
        }
        actualizaFotosOrdenadas(
          ref.read(getListaFotosOrdenadasProvider).rows[0].value,
        ).then((onValue) {
          return refreshData();
        });
      });
    }
  });
}

Future<void> agregafoto(
  BuildContext context,
  WidgetRef ref,
  ValueEspaciosCasaGet valueespaciosparameter,
) async {
  parameterGestionFoto["idUsuario"] =
      valueespaciosparameter.espacioscasa.idusuario;
  parameterGestionFoto["idPropiedad"] =
      valueespaciosparameter.espacioscasa.idPropiedad;
  parameterGestionFoto["idFoto"] = "";
  parameterGestionFoto["indice"] =
      ref.read(getListaFotosCasaProviderId).rows.length + 1;
  parameterGestionFoto["propiedad"] = valueespaciosparameter;

  (ref.read(getListaFotosCasaProviderId).rows.isEmpty)
      ? parameterGestionFoto["fotoprincipal"] = true
      : parameterGestionFoto["fotoprincipal"] = false;

  debugPrintLevels(10, "pagina_lista call AppRoutes.fotosagregafotoalista");
  final seagregofoto = await Navigator.pushNamed(
    // ignore: use_build_context_synchronously
    context,
    AppRoutes.fotosagregafotoalista,
    arguments: parameterGestionFoto,
  );

  if (seagregofoto != null) {
    ref
        .read(getListaFotosOrdenadasProvider.notifier)
        .agregaFotoListaPosiciones();
    if (ref.read(getListaFotosOrdenadasProvider).rows.isNotEmpty) {
      await actualizaFotosOrdenadas(
        ref.read(getListaFotosOrdenadasProvider).rows[0].value,
      ).then((onValue) {});
    }
  }

  debugPrintLevels(10, "pagina_lista back AppRoutes.fotosagregafotoalista");
}

Future<void> agregamultiplesfotos(
  BuildContext context,
  WidgetRef ref,
  ValueEspaciosCasaGet valueespaciosparameter,
) async {
  parameterGestionFoto["idUsuario"] =
      valueespaciosparameter.espacioscasa.idusuario;
  parameterGestionFoto["idPropiedad"] =
      valueespaciosparameter.espacioscasa.idPropiedad;
  parameterGestionFoto["idFoto"] = "";
  parameterGestionFoto["indice"] =
      ref.read(getListaFotosCasaProviderId).rows.length + 1;
  parameterGestionFoto["propiedad"] = valueespaciosparameter;

  (ref.read(getListaFotosCasaProviderId).rows.isEmpty)
      ? parameterGestionFoto["fotoprincipal"] = true
      : parameterGestionFoto["fotoprincipal"] = false;

  debugPrintLevels(10, "pagina_lista call AppRoutes.fotosagregafotoalista");
  final seagregofoto = await Navigator.pushNamed(
    // ignore: use_build_context_synchronously
    context,
    AppRoutes.fotosagregafotoalista,
    arguments: parameterGestionFoto,
  );

  if (seagregofoto != null) {
    ref
        .read(getListaFotosOrdenadasProvider.notifier)
        .agregaFotoListaPosiciones();
    if (ref.read(getListaFotosOrdenadasProvider).rows.isNotEmpty) {
      await actualizaFotosOrdenadas(
        ref.read(getListaFotosOrdenadasProvider).rows[0].value,
      ).then((onValue) {});
    }
  }

  debugPrintLevels(10, "pagina_lista back AppRoutes.fotosagregafotoalista");
}
*/
