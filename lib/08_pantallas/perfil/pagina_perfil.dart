import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../01_home/home_navigation_provider.dart';
import '../../05_provider_menus/provider_menu_inicial.dart';
import '../../05_provider_menus/provider_menu_nivel_gobierno.dart';
import '../../05_provider_menus/provider_menu_principal.dart';
import '../../05_provider_menus/provider_menu_tipo_de_transaccion.dart';
import '../../10_user_login/usuario_login/provider_session.dart';
import '../../10_user_login/avatar/provider_get_avatar.dart';
import '../../07_routes/app_routes.dart';
import '../../10_user_login/usuario_login/dialogbox_login.dart';
import '../../60_global_widgets/future_builder_state_widgets.dart';
import '../../20_var_globales/var_color_themes.dart';
import '../../10_user_login/avatar/manejo_imagenes_avatar.dart';
import '../../20_var_globales/variables_globales.dart';
import '../../22_imagenes/variables_imagenes.dart';
import '../../60_global_widgets/bottom_fijo.dart';
import '../../60_global_widgets/debugprint.dart';

// OPTIMIZADO 25 01 27
// Asumimos que las demás clases (AppRoutes, appTheme, dialogBoxFichaLogin, etc.) están definidas.

// -----------------------------------------------------------------------------
// WIDGET DE PERFIL REDISEÑADO
// -----------------------------------------------------------------------------
class PaginaPerfilWidget extends ConsumerStatefulWidget {
  const PaginaPerfilWidget({super.key});

  @override
  ConsumerState createState() => PaginaPerfilWidgetState();
}

class PaginaPerfilWidgetState extends ConsumerState<PaginaPerfilWidget> {
  final scaffoldPerfilKey = GlobalKey<ScaffoldState>();

  late Future<int> _gatDatosCompletosUsuario;
  bool isUserLoggedIn = false;

  @override
  void initState() {
    super.initState();
    debugPrintLevels(10, "1. PaginaPerfilWidget parameters");

    // FASE 5 (26-05-18): Si principal_sliver_screen_menus_inicio ya precargó
    // los datos del usuario (isUserDataLoaded = true), reutilizamos el caché
    // y evitamos una petición HTTP extra. Solo se recarga si es necesario.
    final isLoaded = ref.read(sessionProvider).isUserDataLoaded;
    if (!isLoaded) {
      _gatDatosCompletosUsuario = ref
          .read(sessionProvider.notifier)
          .getUserDataByNameInSessionData();
    } else {
      _gatDatosCompletosUsuario = Future.value(200);
    }

    debugPrintLevels(0, "PAGINA PERFIL isUserLoggedIn: $isUserLoggedIn");
  }

  // Métodos del ciclo de vida (Mantenidos según instrucción)
  @override
  void didChangeDependencies() {
    debugPrintLevels(1, " PaginaPerfilWidget didChangeDependencies");
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(covariant PaginaPerfilWidget oldWidget) {
    debugPrintLevels(1, " PaginaPerfilWidget didUpdateWidget");
    super.didUpdateWidget(oldWidget);
  }

  @override
  void deactivate() {
    debugPrintLevels(1, " PaginaPerfilWidget deactivate");
    super.deactivate();
  }

  @override
  void dispose() {
    debugPrintLevels(1, " PaginaPerfilWidget dispose");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Escuchamos los cambios en el provider de datos
    final userDataProvider = ref.watch(sessionProvider).sessionUserData;

    debugPrintLevels(0, "PAGINA PERFIL ID: ${userDataProvider.userId}");
    debugPrintLevels(0, "PAGINA PERFIL USER: ${userDataProvider.userName}");

    // Verificamos si hay un usuario cargado
    isUserLoggedIn =
        ((userDataProvider.userId != "") && (userDataProvider.userName != ""))
        ? true
        : false;
    debugPrintLevels(0, "PAGINA PERFIL isUserLoggedIn: $isUserLoggedIn");

    // usuario.idUsuario.isNotEmpty;
    //..userId.isNotEmpty;

    return Scaffold(
      key: scaffoldPerfilKey,
      backgroundColor: appTheme.surface, // Fondo claro/oscuro según tema

      body: SafeArea(
        child: isUserLoggedIn
            ? FutureBuilder<int>(
                future: _gatDatosCompletosUsuario,
                builder: (context, snapshotDatosUsuarioCompletos) {
                  switch (snapshotDatosUsuarioCompletos.connectionState) {
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
                      if (snapshotDatosUsuarioCompletos.hasError) {
                        return stateErrorFormat(
                          widthCuadroFotoPropiedad,
                          heightCuadroFotoPropiedad,
                          snapshotDatosUsuarioCompletos.error,
                        );
                      } else {
                        if (ref.watch(sessionProvider).userData.rows.isEmpty) {
                          debugPrintLevels(9, "** Sin datos del usuario");
                          return _buildNoUserView(context);
                        } else {
                          return _buildUserProfileView(context);
                        }

                        // 2. FUTURE BUILDER IDS
                      }
                  }
                },
              )
            : _buildNoUserView(context),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // VISTA 1: USUARIO NO LOGUEADO (Login Prompt)
  // ---------------------------------------------------------------------------
  Widget _buildNoUserView(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: appTheme.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Symbols.person_off_rounded,
                size: 60,
                color: appTheme.primary,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "No has iniciado sesión",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: appTheme.primary,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Ingresa a tu cuenta para gestionar tus propiedades y datos personales.",
              textAlign: TextAlign.center,
              style: TextStyle(color: appTheme.secondary, fontSize: 14),
            ),
            const SizedBox(height: 30),
            MyButton(
              etiqueta: "Iniciar Sesión",
              onTap: () {
                dialogBoxFichaLogin(context, ref);
                setState(() {});
              },
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // VISTA 2: PERFIL DE USUARIO COMPLETO
  // ---------------------------------------------------------------------------
  Widget _buildUserProfileView(BuildContext context) {
    // Acceso directo a los datos del modelo
    final userRow = ref.watch(sessionProvider).userData.rows[0].value.usuario;
    final sessionData = ref.watch(sessionProvider);
    final avatarRow = ref.watch(classUserAvatarProvider).rows;

    // Construcción del Nombre Completo
    final String nombreCompleto =
        "${userRow.nombres} ${userRow.apellidopaterno} ${userRow.apellidomaterno}";

    // Determinar Rol a mostrar
    final String rolUsuario = sessionData.nombrePerfil;
    /*
        ? (userRow.datospromotor.inmobiliaria.isNotEmpty
              ? "Inmobiliaria"
              : "Promotor")
        : sessionData.nombrePerfil;
    */
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.only(bottom: 40),
      child: Column(
        children: [
          // --- HEADER (Fondo + Avatar) ---
          _buildHeaderSection(
            context,
            userRow,
            avatarRow,
            nombreCompleto,
            rolUsuario,
          ),

          const SizedBox(height: 20),

          // --- SECCIÓN 1: INFORMACIÓN DE CUENTA ---
          _buildSectionTitle("Información Personal"),
          _buildInfoCard([
            _buildProfileRow(
              Symbols.person_outline,
              "Nombre Usuario",
              userRow.nombreusuario,
            ),
            _buildDivider(),
            _buildProfileRow(
              Symbols.email,
              "Correo",
              userRow.correoelectronico,
            ),
            _buildDivider(),
            _buildProfileRow(
              Symbols.phone_android,
              "Celular",
              userRow.numerocelular,
            ),
            _buildDivider(),
            _buildProfileRow(
              Symbols.cake,
              "Fecha Nacimiento",
              "${userRow.fechaDeNacimiento.dia}/${userRow.fechaDeNacimiento.mes}/${userRow.fechaDeNacimiento.anio}",
            ),
          ]),

          // --- SECCIÓN 2: UBICACIÓN ---
          _buildSectionTitle("Dirección Registrada"),
          _buildInfoCard([
            _buildProfileRow(
              Symbols.map,
              "Estado / Municipio",
              "${userRow.ubicacionUserData.localidadCp.estado}, ${userRow.ubicacionUserData.localidadCp.municipio}",
            ),
            _buildDivider(),
            _buildProfileRow(
              Symbols.location_city,
              "Colonia / Asentamiento",
              "${userRow.ubicacionUserData.localidadCp.asentamiento} (CP: ${userRow.ubicacionUserData.localidadCp.cp})",
            ),
            _buildDivider(),
            _buildProfileRow(
              Symbols.add_road,
              "Calle y Número",
              userRow.ubicacionUserData.calle,
            ),
          ]),

          // --- SECCIÓN 3: DATOS PROFESIONALES (Solo si es Promotor/Inmobiliaria) ---
          if (sessionData.esPromotor) ...[
            _buildSectionTitle("Perfil Profesional"),
            _buildInfoCard([
              _buildProfileRow(
                Symbols.business,
                "Inmobiliaria",
                userRow.datospromotor.inmobiliaria.isEmpty
                    ? "Independiente"
                    : userRow.datospromotor.inmobiliaria,
              ),
              _buildDivider(),
              _buildProfileRow(Symbols.badge, "RFC", userRow.datospromotor.rfc),
              _buildDivider(),
              _buildProfileRow(
                Symbols.confirmation_number,
                "No. Cliente",
                userRow.datospromotor.numerodecliente,
              ),
            ]),
          ],

          const SizedBox(height: 30),

          // --- BOTÓN CERRAR SESIÓN ---
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ElevatedButton.icon(
              onPressed: () async => await _showLogoutDialog(context, ref),
              icon: const Icon(Symbols.logout, color: Colors.white),
              label: const Text(
                "Cerrar Sesión Actual",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: appTheme.error,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // WIDGETS AUXILIARES DE DISEÑO
  // ---------------------------------------------------------------------------

  Widget _buildHeaderSection(
    BuildContext context,
    dynamic userRow,
    dynamic avatarRow,
    String nombre,
    String rol,
  ) {
    bool tieneAvatar =
        avatarRow.isNotEmpty && avatarRow[0].value.avatar.isNotEmpty;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: appTheme.primary,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      padding: const EdgeInsets.only(bottom: 30, top: 10),
      child: Column(
        children: [
          const SizedBox(height: 20),
          // Avatar
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 3),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: CircleAvatar(
                  radius: 55,
                  backgroundColor: Colors.grey[200],
                  backgroundImage: tieneAvatar
                      ? MemoryImage(
                          convierteData2Imagen(avatarRow[0].value.avatar),
                        )
                      : null,
                  child: !tieneAvatar
                      ? Icon(Symbols.person, size: 60, color: Colors.grey[400])
                      : null,
                ),
              ),
              // Botón editar foto
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    AppRoutes.gestionavatar,
                    arguments: "",
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: appTheme.secondary,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: const Icon(
                    Symbols.edit,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          // Nombre y Rol
          Text(
            nombre.isEmpty ? "Usuario Sin Nombre" : nombre,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 5),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              rol,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
      child: Row(
        children: [
          Text(
            title,
            style: TextStyle(
              color: appTheme.secondary,
              fontSize: 14,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Divider(color: appTheme.secondary.withValues(alpha: 0.2)),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(List<Widget> children) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white, // appTheme.surface
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(children: children),
    );
  }

  Widget _buildProfileRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: appTheme.primary.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: appTheme.primary, size: 20),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  (value.isEmpty || value == "0") ? "No registrado" : value,
                  style: TextStyle(
                    color: appTheme.onSurface,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      thickness: 1,
      color: Colors.grey.shade100,
      indent: 60,
    );
  }
}

// -----------------------------------------------------------------------------
// DIÁLOGO DE CERRAR SESIÓN (Mantenido y Limpio)
// -----------------------------------------------------------------------------

Future<void> _showLogoutDialog(BuildContext context, WidgetRef ref) async {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
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
        title: const Text("Termina sesión", textAlign: TextAlign.center),
        content: Container(
          color: appTheme.onSecondary,
          height: 80,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("", maxLines: 1),
              Expanded(
                child: Text(
                  "¿Quiéres salir de la sesión?",
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
                fontSize: 12,
                fontFamily: "Comfortaa",
                fontWeight: FontWeight.bold,
              ),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
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
            onPressed: () async {
              debugPrintLevels(
                0,
                "*** appBarPrincipal Usuario onPressed cierra sesión",
              );
              // 1. Borrar sesión local (await + () son obligatorios para que se ejecute)
              await ref.read(sessionProvider.notifier).deleteLocalSessionData();
              // 2. Resetear variables de usuario
              ref.read(sessionProvider.notifier).resetInitialUserData(0);
              // 3. Resetear Avatar (Corregido para usar el provider generado y el método correcto)
              // Nota: El método definido en el provider anterior era 'resetGetUserAvatarProvider'
              ref
                  .read(classUserAvatarProvider.notifier)
                  .resetclassUserAvatarProvider();
              // 4. CERRAR DIALOGO Y REINICIAR NAVEGACIÓN A "INICIO"
              // Esto cierra el alert, limpia el historial y recarga la página principal
              // forzando que se muestre la vista por defecto (Inicio).
              //--------------
              ref
                  .read(menuInicialProvider.notifier)
                  .asignaNuevaOpcionSeleccionada(ref, 1);
              ref.read(homeNavigationProvider.notifier).actualizarInicial(1);
              //--------------
              ref
                  .read(menuPrincipalProvider.notifier)
                  .asignaNuevaOpcionSeleccionada(ref, 0);
              ref.read(homeNavigationProvider.notifier).actualizarPrincipal(0);
              //--------------
              ref
                  .read(menuNivelDeGobiernoProvider.notifier)
                  .asignaNuevaOpcionSeleccionada(ref, 0);
              ref
                  .read(homeNavigationProvider.notifier)
                  .actualizarNivelGobierno(0);
              //--------------
              ref
                  .read(menuTipoDeTransaccionProvider.notifier)
                  .asignaNuevaOpcionSeleccionada(ref, 0);
              ref
                  .read(homeNavigationProvider.notifier)
                  .actualizarTipoTransaccion(0);
              //--------------
              // Navigator.of(context).pop();
              Navigator.pushReplacementNamed(
                context,
                AppRoutes.principal,
                arguments: "",
              );
            },
          ),
        ],
      );
    },
  );
}


//------------------------------------------------------------------------------

