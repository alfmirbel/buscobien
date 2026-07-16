import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';
import '../../07_routes/app_routes.dart';
import '../../10_user_login/usuario_login/dialogbox_login.dart';
import '../../10_user_login/usuario_login/provider_session.dart';
import '../../12_localidades_user/data_user_localidad.dart';
import '../../12_localidades_user/data_user_localidad_get.dart';
import '../../12_localidades_user/provider_get_localidades_usuario.dart';
import '../../20_var_globales/var_color_themes.dart';
import '../../20_var_globales/var_color_widget.dart';
import '../../20_var_globales/var_elementos_menus.dart';
import '../../20_var_globales/variables_globales.dart';
import '../../60_global_widgets/debugprint.dart';
import 'data_sepomex_localidades.dart';
import 'data_sepomex_localidades_get_cp.dart';

class PaginaPrincipalListaLocalidades extends ConsumerStatefulWidget {
  const PaginaPrincipalListaLocalidades({super.key});

  @override
  // ignore: no_logic_in_create_state
  ConsumerState createState() {
    //  debugPrintLevels(2, "**************************************************");
    debugPrintLevels(2, "1. PaginaPrincipalListaLocalidades createState");
    return PaginaPrincipalListaLocalidadesState();
  }
}

class PaginaPrincipalListaLocalidadesState
    extends ConsumerState<PaginaPrincipalListaLocalidades> {
  //late PerfilModel _model;

  final scaffoldListaLocalidadesKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    // debugPrintLevels(0, "--------------------------------------------------------");
    debugPrintLevels(2, "2. PaginaPrincipalListaLocalidades initState");
  }

  //-----------------------------------------------------------------------------
  @override
  void didChangeDependencies() {
    debugPrintLevels(
      1,
      "PaginaPrincipalListaLocalidades didChangeDependencies",
    );
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(covariant PaginaPrincipalListaLocalidades oldWidget) {
    debugPrintLevels(1, " PaginaPrincipalListaLocalidades didUpdateWidget");
    super.didUpdateWidget(oldWidget);
  }

  @override
  void deactivate() {
    debugPrintLevels(1, " PaginaPrincipalListaLocalidades deactivate");
    super.deactivate();
  }

  @override
  void dispose() {
    debugPrintLevels(1, " PaginaPrincipalListaLocalidades dispose");
    super.dispose();
  }

  //-----------------------------------------------------------------------------

  UsuarioLocalidades registroULEncontrada = UsuarioLocalidades(
    idCodigopostal: "",
    idUsuario: "",
    pais: "México",
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
    seccionine: "",
    latitud: "",
    longitud: "",
    latDecimal: "",
    lonDecimal: "",
    timestamp: "",
  );

  LocalidadesGet localidadesVacia = LocalidadesGet(
    totalRows: 0,
    offset: 0,
    rows: [],
  );

  @override
  Widget build(BuildContext context) {
    // debugPrintLevels(0, "--------------------------------------------------------");
    debugPrintLevels(2, "4. PaginaPrincipalListaLocalidades build ");

    List<RowsUserLocal> localidadesUsuario =
        ref.watch(userLocalidadesProvider).rows;
    final localidadesValidas = localidadesUsuario
        .where((loc) => loc.value.localidadCp.cp != 0)
        .toList();

    return Scaffold(
      backgroundColor: appTheme.surface,
      // muestra localidades
      // ignore: prefer_is_empty
      body: SingleChildScrollView(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: desktopContentMaxWidth,
            ),
            child: Column(
              children: [
                Container(
                  alignment: Alignment.topCenter,
                  color: appTheme.surface,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 20),
                      const SizedBox(height: 20),
                      Text(
                        "${iconoMiLocalidad.etiqueta} seleccionadas",
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        style: TextStyle(
                          color: appTheme.primary,
                          fontSize: fontSizeTituloPagina,
                          fontWeight: FontWeight.bold,
                          fontFamily: "Comfortaa",
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Ingresa como usuario para guardar propiedades
                      (ref
                                  .read(sessionProvider.notifier)
                                  .getSessionVarValue("userId") ==
                              "")
                          ? GestureDetector(
                              // CASO SIN USUARIO LOGUEADO
                              onTap: () {
                                dialogBoxFichaLogin(context, ref);
                              },
                              child: Center(
                                child: Container(
                                  width: 500,
                                  //height: 40,
                                  alignment: Alignment.center,
                                  padding:
                                      const EdgeInsets.fromLTRB(6, 6, 6, 6),
                                  decoration: BoxDecoration(
                                    color: appTheme.onPrimary,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: appTheme.primary,
                                      width: 2,
                                    ),
                                  ),
                                  child: Center(
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          iconoUsuario.icono,
                                          size: 25,
                                          color: appTheme.primary,
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: Text(
                                            'Ingresa como usuario para guardar propiedades',
                                            textAlign: TextAlign.center,
                                            maxLines: 2,
                                            style: TextStyle(
                                              fontSize: fontSizeSubtituloPagina,
                                              fontWeight: FontWeight.bold,
                                              color: appTheme.primary,
                                            ),
                                            overflow: TextOverflow.visible,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : SizedBox(height: 0),
                      const SizedBox(height: 10),
                      // CASO Selecciona una localidad para ver publicaciones
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            AppRoutes.localidades,
                            // PaginaBuscaLocalidadGMaps.dart
                            arguments: "",
                          );
                        },
                        child: Center(
                          child: Container(
                            width: 500,
                            //height: 40,
                            alignment: Alignment.center,
                            padding: const EdgeInsets.fromLTRB(6, 6, 6, 6),
                            decoration: BoxDecoration(
                              color: appTheme.onPrimary,
                              borderRadius: BorderRadius.circular(12),
                              border:
                                  Border.all(color: appTheme.primary, width: 2),
                            ),
                            child: Center(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    iconoLocalidad.icono,
                                    size: 25,
                                    color: appTheme.primary,
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      'Selecciona localidades para ver publicaciones de la zona',
                                      textAlign: TextAlign.center,
                                      maxLines: 2,
                                      style: TextStyle(
                                        fontSize: fontSizeSubtituloPagina,
                                        fontWeight: FontWeight.bold,
                                        color: appTheme.primary,
                                      ),
                                      overflow: TextOverflow.visible,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Lista de localidades desde localidadesPorCodigoPostalProvider
                Container(
                  alignment: Alignment.topCenter,
                  color: appTheme.surface,
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      // future provider FETCH LOCALIDADES DEL USUARIO
                      Column(
                        children:
                            List<Card>.generate(localidadesValidas.length, (
                          int index,
                        ) {
                          final loc = localidadesValidas[index];
                          final localidadCp = loc.value.localidadCp;
                          return Card(
                            margin: const EdgeInsets.all(12),
                            color: appTheme.onPrimary,
                            shadowColor: appTheme.surface,
                            elevation: 10,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Material(
                                  color: appTheme.primary,
                                  child: SizedBox(
                                    height: 60,
                                    child: ListTile(
                                      title: Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              localidadCp.asentamiento,
                                              style: TextStyle(
                                                color: appTheme.onPrimary,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14,
                                                height: 0,
                                              ),
                                            ),
                                          ),
                                          IconButton(
                                            icon: Icon(
                                              Symbols.delete,
                                              color: appTheme.onPrimary,
                                              size: 20,
                                            ),
                                            onPressed: () {
                                              showDialog(
                                                context: context,
                                                builder: (ctx) => AlertDialog(
                                                  title: const Text(
                                                    "Eliminar Ubicación",
                                                  ),
                                                  content: Text(
                                                    "¿Deseas eliminar la ubicación ${localidadCp.asentamiento}?",
                                                  ),
                                                  actions: [
                                                    TextButton(
                                                      child: const Text(
                                                          "Cancelar"),
                                                      onPressed: () =>
                                                          Navigator.of(ctx)
                                                              .pop(),
                                                    ),
                                                    TextButton(
                                                      child: const Text(
                                                          "Eliminar"),
                                                      onPressed: () async {
                                                        Navigator.of(ctx).pop();
                                                        await ref
                                                            .read(
                                                              userLocalidadesProvider
                                                                  .notifier,
                                                            )
                                                            .deleteUserLocalidadFromCouchDB(
                                                              loc.id,
                                                            );
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                      subtitle: Text(
                                        localidadCp.cp.toString(),
                                        style: TextStyle(
                                          color: appTheme.onPrimary,
                                          fontWeight: FontWeight.normal,
                                          fontSize: 12,
                                          height: 0,
                                        ),
                                      ),
                                      trailing: Icon(
                                        Symbols.arrow_forward_ios,
                                        color: appTheme.onPrimary,
                                      ),
                                      onTap: () {
                                        //-----------------------------------------------
                                        ref
                                            .read(sessionProvider.notifier)
                                            .updateLocalidadEnSesion(
                                                localidadCp);
                                        //-----------------------------------------------

                                        Navigator.pushNamed(
                                          context,
                                          AppRoutes.principal,
                                          arguments: "",
                                        );
                                      },
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(10, 3, 5, 0),
                                  child: Text(
                                    "Localidad: ${localidadCp.asentamiento}",
                                    style: TextStyle(
                                      color: appTheme.onPrimaryContainer,
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(10, 0.5, 5, 0),
                                  child: Text(
                                    "Código Postal: ${localidadCp.cp}",
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      color: appTheme.onPrimaryContainer,
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(10, 0.5, 5, 0),
                                  child: Text(
                                    "Estado: ${localidadCp.estado}",
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      color: appTheme.onPrimaryContainer,
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(10, 0.5, 5, 0),
                                  child: Text(
                                    "Municipio: ${localidadCp.municipio}",
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      color: appTheme.onPrimaryContainer,
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(10, 0.5, 5, 0),
                                  child: Text(
                                    "Ciudad: ${localidadCp.ciudad}",
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      color: appTheme.onPrimaryContainer,
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(10, 0.5, 5, 0),
                                  child: Text(
                                    "Tipo: ${localidadCp.tipo}",
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      color: appTheme.onPrimaryContainer,
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(10, 0.5, 5, 6),
                                  child: Text(
                                    "Zona: ${localidadCp.zona}",
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      color: appTheme.onPrimaryContainer,
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
