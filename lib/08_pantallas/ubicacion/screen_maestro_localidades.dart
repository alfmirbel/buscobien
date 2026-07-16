import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../07_routes/app_routes.dart';
import '../../10_user_login/usuario_login/provider_session.dart';
import '../../12_localidades_user/data_user_localidad.dart';
import '../../12_localidades_user/provider_get_localidades_usuario.dart';
import '../../20_var_globales/var_color_themes.dart';
import '../../20_var_globales/variables_globales.dart';
import '../../41_connectivity/pagina_sin_coneccion.dart';
import 'provider_localidades_del_cp.dart';
import '../../60_global_widgets/debugprint.dart';
import 'data_sepomex_localidades_get_cp.dart';

LocalidadesGet futureCotizaList = LocalidadesGet(
  totalRows: 0,
  offset: 0,
  rows: [],
);

late TextEditingController celdaControllerDialog;

// MAESTRO DE LOCALIDADES
// ruta: '/listalocalidades'
class LocalidadesListScreen extends ConsumerStatefulWidget {
  const LocalidadesListScreen(this.codigoP, {super.key});
  final int codigoP;

  @override
  // ignore: no_logic_in_create_state
  ConsumerState createState() {
    debugPrintLevels(1, " **************************************************");
    debugPrintLevels(1, " 1. LocalidadesListScreen createState");
    debugPrintLevels(1, " **************************************************");
    return LocalidadesListScreenState();
  }
}

class LocalidadesListScreenState extends ConsumerState<LocalidadesListScreen> {
  @override
  void initState() {
    // inicializaFolio(ref);
    celdaControllerDialog = TextEditingController();
    super.initState();
    debugPrintLevels(1, " **************************************************");
    debugPrintLevels(1, " 1. LocalidadesListScreen initState");
    debugPrintLevels(1, " **************************************************");
  }

  //-----------------------------------------------------------------------------
  @override
  void didChangeDependencies() {
    debugPrintLevels(1, " LocalidadesListScreen didChangeDependencies");
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(covariant LocalidadesListScreen oldWidget) {
    debugPrintLevels(1, " LocalidadesListScreen didUpdateWidget");
    super.didUpdateWidget(oldWidget);
  }

  @override
  void deactivate() {
    debugPrintLevels(1, " LocalidadesListScreen deactivate");
    super.deactivate();
  }

  @override
  void dispose() {
    debugPrintLevels(1, " LocalidadesListScreen dispose");
    //  celdaControllerDialog.dispose();
    super.dispose();
  }

  //-----------------------------------------------------------------------------

  Future<String?> openDialogGuardaUserLocal(
    BuildContext context,
    UsuarioLocalidades userLocal,
  ) {
    debugPrintLevels(
      0,
      "--- LocalidadesListScreen openDialogGuardaUserLocal",
    );
    return showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          // ── Estilos M3 alineados a dialogBoxFichaLogin ──────────────────
          backgroundColor: appTheme.primary,
          elevation: 6,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(6)),
          ),
          titleTextStyle: TextStyle(
            color: appTheme.onPrimary,
            fontSize: fontSizeDialogTitulo,
            fontFamily: "Comfortaa",
            fontWeight: FontWeight.bold,
          ),
          contentTextStyle: TextStyle(
            color: appTheme.onPrimary,
            fontSize: fontSizeDialogCampo,
            fontWeight: FontWeight.normal,
          ),
          titlePadding: const EdgeInsets.fromLTRB(6, 12, 6, 6),
          contentPadding: const EdgeInsets.all(3),
          actionsPadding: const EdgeInsets.all(6),
          // ────────────────────────────────────────────────────────────────
          title: const Text("Mis Localidades", textAlign: TextAlign.center),
          content: SizedBox(
            height: 100,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Text(
                  "¿Deseas agregar esta localidad a tu lista?",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: appTheme.onPrimary,
                    fontSize: fontSizeDialogCampo,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
            ),
          ),
          actions: [
            // Botón NO (secundario) — mismo patrón que dialogBoxFichaLogin
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(3),
                backgroundColor: appTheme.surface,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: Text(
                "No",
                style: TextStyle(
                  color: appTheme.primary,
                  fontSize: fontSizeDialogCampo,
                  fontFamily: "Comfortaa",
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pushReplacementNamed(
                  AppRoutes.principal,
                  arguments: "",
                );
              },
            ),
            // Botón SÍ (acción afirmativa primaria)
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(3),
                backgroundColor: appTheme.onPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: Text(
                "Sí, guardar",
                style: TextStyle(
                  color: appTheme.primary,
                  fontSize: fontSizeDialogCampo,
                  fontFamily: "Comfortaa",
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () async {
                final result = await ref
                    .read(userLocalidadesProvider.notifier)
                    .writeUserLocalidadToCouchDB(userLocal);

                if (result == 200) {
                  // Refresca la lista completa del usuario desde CouchDB
                  // para que la localidad recién guardada aparezca sin
                  // sobrescribir las demás localidades en memoria.
                  await ref
                      .read(userLocalidadesProvider.notifier)
                      .fetchLocalidadesDeUsuario();
                }

                if (context.mounted) {
                  Navigator.of(context).pushReplacementNamed(
                    AppRoutes.principal,
                    arguments: "",
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  generaLista() {
    final listaLocalidadesProvider = ref.read(
      localidadesPorCodigoPostalProvider,
    );
    debugPrintLevels(0, "--- LocalidadesListScreen generaLista");

    return ListView.builder(
      itemCount: listaLocalidadesProvider.localidades.rows.length,
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.all(10),
          color: appTheme.surface,
          shadowColor: appTheme.onPrimaryContainer,
          elevation: 10,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                color: appTheme.primary,
                child: ListTile(
                  title: Text(
                    listaLocalidadesProvider
                        .localidades
                        .rows[index]
                        .value
                        .localidadCp
                        .asentamiento,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  subtitle: Text(
                    listaLocalidadesProvider
                        .localidades
                        .rows[index]
                        .value
                        .localidadCp
                        .cp
                        .toString(),
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  trailing: Icon(
                    Symbols.arrow_forward_ios,
                    color: appTheme.onPrimary,
                  ),
                  onTap: () async {
                    // 1. Marca cuál índice del catálogo está activo
                    ref
                        .read(localidadesPorCodigoPostalProvider.notifier)
                        .setLocalidadActual(index);

                    final session = ref.read(sessionProvider);
                    final locData =
                        listaLocalidadesProvider.localidades.rows[index].value;

                    // 2. Actualiza la sesión global para que los filtros de
                    //    búsqueda usen esta localidad sin importar si hay sesión
                    ref
                        .read(sessionProvider.notifier)
                        .updateLocalidadEnSesion(locData.localidadCp);

                    if (session.sessionUserData.userId.isNotEmpty) {
                      // 3. Verifica si la localidad ya está guardada (anti-duplicado)
                      final isDuplicate = await ref
                          .read(userLocalidadesProvider.notifier)
                          .gdtLocalidadUsuario(
                            locData.localidadCp.asentamiento,
                          );
                      // gdtLocalidadUsuario: 200 = encontrada, 404 = no existe

                      if (!context.mounted) return;

                      if (isDuplicate == 200) {
                        // Ya existe: informar al usuario y navegar sin duplicar
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              "'${locData.localidadCp.asentamiento}' ya está en tu lista de localidades.",
                              style: TextStyle(color: appTheme.onPrimary),
                            ),
                            backgroundColor: appTheme.secondary,
                            duration: const Duration(seconds: 3),
                          ),
                        );
                        await Future.delayed(const Duration(seconds: 3));
                        if (context.mounted) {
                          Navigator.pushReplacementNamed(
                            context,
                            AppRoutes.principal,
                            arguments: "",
                          );
                        }
                      } else {
                        // No existe: construir objeto y mostrar diálogo de guardado
                        final userLocal = UsuarioLocalidades(
                          idCodigopostal:
                              listaLocalidadesProvider.localidades.rows[index].id,
                          idUsuario: session.sessionUserData.userId,
                          localidadCp: locData.localidadCp,
                        );
                        openDialogGuardaUserLocal(context, userLocal);
                      }
                    } else {
                      // Sin sesión: navegar a principal directamente
                      Navigator.pushReplacementNamed(
                        context,
                        AppRoutes.principal,
                        arguments: "",
                      );
                    }
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(6.0, 6.0, 6.0, 0.0),
                child: Text(
                  "Localidad: ${listaLocalidadesProvider.localidades.rows[index].value.localidadCp.asentamiento}",
                  style: TextStyle(
                    color: appTheme.onPrimaryContainer,
                    fontSize: 14.0,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(6.0, 0.0, 6.0, 0.0),
                child: Text(
                  "Código Postal: ${listaLocalidadesProvider.localidades.rows[index].value.localidadCp.cp.toString()}",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: appTheme.onPrimaryContainer,
                    fontSize: 14.0,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(6.0, 0.0, 6.0, 0.0),
                child: Text(
                  "Estado: ${listaLocalidadesProvider.localidades.rows[index].value.localidadCp.estado}",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: appTheme.onPrimaryContainer,
                    fontSize: 14.0,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(6.0, 0.0, 6.0, 0.0),
                child: Text(
                  "Municipio: ${listaLocalidadesProvider.localidades.rows[index].value.localidadCp.municipio}",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: appTheme.onPrimaryContainer,
                    fontSize: 14.0,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(6.0, 0.0, 6.0, 0.0),
                child: Text(
                  "Ciudad: ${listaLocalidadesProvider.localidades.rows[index].value.localidadCp.ciudad}",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: appTheme.onPrimaryContainer,
                    fontSize: 14.0,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(6.0, 0.0, 6.0, 0.0),
                child: Text(
                  "Zona: ${listaLocalidadesProvider.localidades.rows[index].value.localidadCp.zona}",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: appTheme.onPrimaryContainer,
                    fontSize: 14.0,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(6.0, 0.0, 6.0, 6.0),
                child: Text(
                  "Tipo: ${listaLocalidadesProvider.localidades.rows[index].value.localidadCp.tipo}",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: appTheme.onPrimaryContainer,
                    fontSize: 14.0,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // debugPrintLevels(0, "--------------------------------------------------------");
    debugPrintLevels(0, "4. LocalidadesListScreen build");

    return Scaffold(
      appBar: AppBar(
        backgroundColor: appTheme.primary,
        centerTitle: true,
        titleSpacing: 0,
        iconTheme: IconThemeData(size: 14, color: appTheme.onPrimary),
        title: Text(
          "Localidades del CP ${ref.read(localidadesPorCodigoPostalProvider.notifier).getCodigoPostal().toString()}",
          style: TextStyle(color: appTheme.onPrimary, fontSize: 14),
        ),
      ),
      body: ref
          .watch(getLocalidadesDelCPFutureProvider)
          .when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, stack) => const PaginaSinConeccion(
              "No se pueden obtener las localidades.",
            ),
            // const PaginaSinConeccion(),
            // Error: $errS
            data: (userData) {
              debugPrintLevels(0, "--3. PrincipalPageState generaLista");
              return generaLista();
            },
          ),
    );
  }
}
