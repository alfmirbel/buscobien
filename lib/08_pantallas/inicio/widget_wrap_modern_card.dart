//------------------------------------------------------------------------------
import 'package:buscobien/08_pantallas/inicio/data_espacios_casas_get.dart';
import 'package:flutter/foundation.dart'
    show kIsWeb, defaultTargetPlatform, TargetPlatform;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../02_principal_screen/principal_sliver_screen_menus_inicio.dart';
import '../../05_provider_menus/provider_menu_principal.dart';
import '../../10_user_login/usuario_login/dialogbox_login.dart';
import '../../10_user_login/usuario_login/provider_session.dart';
import '../../20_var_globales/var_color_themes.dart';
import '../../22_imagenes/inicio_fotos_usuario/pagina_carousel_fotos_usuario.dart';
import '../../22_imagenes/variables_imagenes.dart';
import '../../03_listas/provider_me_gusta.dart';
import '../../03_listas/provider_user_lists.dart';
import '../tu_cuenta/conocidos/provider_mensajes.dart';
import '../tu_cuenta/conocidos/providers/conocidos_notifier.dart';
import 'data_espacios_casas.dart';

// OPTIMIZADO

// Asumiendo que estas variables/clases existen globalmente o se importan:
// widthCuadroFotoPropiedad, heightCuadroFotoPropiedad, appTheme,
// EspaciosCasaGet, PaginaCarouselFotosUsuario, menuPrincipalProvider,
// selectedDropDownMenuPrincipalValue.

class WrapModernCardPropiedades extends ConsumerWidget {
  final int index;
  final EspaciosCasaGet listaSeleccionadas;

  // OPTIMIZACIÓN: Se eliminaron context y ref del constructor.
  // 'ref' se obtiene del ConsumerWidget y 'context' del método build.
  // Se usa 'const' para mejorar el rendimiento de reconstrucción.
  const WrapModernCardPropiedades(
    this.index,
    this.listaSeleccionadas, {
    super.key,
  });

  // Constantes de diseño movidas a static const o finales para evitar recreación
  static const double iconSizeBanner = 16.0;
  static const double textSizeBanner = 10.0;
  static const double espacioEntreDato = 8.0;
  static const List<String> valoresString = ["", "0"];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // OPTIMIZACIÓN: Alias local para evitar la cadena larga de acceso a datos repetidamente.
    // Esto mejora la lectura y reduce la posibilidad de errores tipográficos.
    final rowValue = listaSeleccionadas.rows[index].value;
    final itemCasa = rowValue.espacioscasa;

    // Lógica para el tipo de propiedad
    String tipodepropiedad = ref.read(menuPrincipalProvider).etiqueta;
    if (tipodepropiedad == "Otros") {
      tipodepropiedad =
          selectedDropDownMenuPrincipalValue; // Asumiendo variable global
    } else if (tipodepropiedad == "Casas") {
      tipodepropiedad = "Casa";
    } else if (tipodepropiedad == "Departamentos") {
      tipodepropiedad = "Departamento";
    } else if (tipodepropiedad == "Inicio") {
      tipodepropiedad = itemCasa.tipodepropiedad;
    }

    return Column(
      children: [
        // TIPO DE INMUEBLE
        Container(
          width: widthCuadroFotoPropiedad, // Asumiendo variable global
            color: appTheme.surface,
          padding: const EdgeInsets.all(1.5),
          alignment: Alignment.centerLeft,
          child: Text(
            "Anuncios ${itemCasa.tipodeanuncio}",
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.normal,
              color: appTheme.onPrimaryContainer,
            ),
          ),
        ),

        // LETRERO PROMOCIONAL DE LA PROPIEDAD
        Container(
          width: widthCuadroFotoPropiedad,
          padding: const EdgeInsets.fromLTRB(3, 5, 3, 5),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  itemCasa.letreropromocional,
                  maxLines: 3,
                  overflow: TextOverflow.visible,
                  style: TextStyle(
                    letterSpacing: -0.2,
                    fontSize: 12,
                    fontWeight: FontWeight.normal,
                    color: appTheme.onPrimaryContainer,
                  ),
                ),
              ),
              _MeGustaButton(propiedadId: itemCasa.idPropiedad),
            ],
          ),
        ),

        // TARJETA DE LAS FOTOS
        Card(
            color: appTheme.surface,
          shadowColor: appTheme.outline,
          elevation: 6.0,
          shape: RoundedRectangleBorder(
            side: BorderSide(color: appTheme.outline, width: 0.5),
            borderRadius: BorderRadius.circular(12),
          ),
          child: SizedBox(
            width: widthCuadroFotoPropiedad,
            child: Column(
              spacing: 6.0,
              verticalDirection: VerticalDirection.down,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // RECUADRO DE LAS FOTOS
                SizedBox(
                  width: widthCuadroFotoPropiedad,
                  height:
                      heightCuadroFotoPropiedad +
                      40, // Asumiendo variable global
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: PaginaCarouselFotosUsuario(rowValue),
                  ),
                ),
              ],
            ),
          ),
        ),

        // PRECIO
        Container(
          width: widthCuadroFotoPropiedad,
            color: appTheme.surface,
          padding: const EdgeInsets.all(1.5),
          alignment: Alignment.topLeft,
          child: _buildPrecio(tipodepropiedad, itemCasa),
        ),

        // UBICACION DE LA PROPIEDAD
        Container(
          width: widthCuadroFotoPropiedad,
          padding: const EdgeInsets.fromLTRB(5, 3, 3, 5),
          alignment: Alignment.centerLeft,
          child: Text(
            "${itemCasa.ubicacioncasa.localidadCp.asentamiento}, ${itemCasa.ubicacioncasa.localidadCp.municipio}, ${itemCasa.ubicacioncasa.localidadCp.estado}, C.P. ${itemCasa.ubicacioncasa.localidadCp.cp}",
            maxLines: 3,
            overflow: TextOverflow.visible,
            style: TextStyle(
              letterSpacing: -0.2,
              fontSize: 12,
              fontWeight: FontWeight.normal,
              color: appTheme.onPrimaryContainer,
            ),
          ),
        ),

        // DATOS DE LA PROPIEDAD (Iconos)
        Container(
          width: widthCuadroFotoPropiedad,
          padding: const EdgeInsets.fromLTRB(5, 3, 3, 5),
          alignment: Alignment.centerLeft,
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment
                .center, // Alinea iconos y texto verticalmente
            children: [
              _buildFeatureItem(
                Symbols.width_full,
                itemCasa.metrosdeterreno,
                suffix: " mts.",
              ),
              _buildFeatureItem(
                Symbols.home_work,
                itemCasa.metrosconstruidos,
                suffix: " mts.",
              ),
              _buildFeatureItem(Symbols.bed, itemCasa.recamaras),
              _buildFeatureItem(Symbols.shower, itemCasa.banos),
              _buildFeatureItem(
                Symbols.directions_car,
                itemCasa.estacionamientos,
              ),
              _buildFeatureItem(
                Symbols.garage,
                itemCasa.estacionamientoscubiertos,
                isLastItem: true, // Para evitar el espaciado final si se desea
              ),
            ],
          ),
        ),

        // ACCIONES DE LA PROPIEDAD
        Card(
            color: appTheme.surface,
          shadowColor: appTheme.outline,
          elevation: 6.0,
          shape: RoundedRectangleBorder(
            side: BorderSide(color: appTheme.outline, width: 0.8),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Container(
            padding: EdgeInsetsDirectional.all(3),
            width: widthCuadroFotoPropiedad,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                _buildBotonAccion(
                  icono: Symbols.contact_mail,
                  titulo: "Contacto",
                  tooltip: "Ver datos del promotor",
                  onTap: () => _mostrarDialogContacto(
                    context,
                    itemCasa.datosdelcontactocasa,
                  ),
                ),
                if (!kIsWeb &&
                    (defaultTargetPlatform == TargetPlatform.android ||
                        defaultTargetPlatform == TargetPlatform.iOS))
                  _buildBotonAccion(
                    icono: Symbols.phone,
                    titulo: "Teléfono",
                    tooltip: "Llamar al promotor",
                    onTap: () async {
                      final uri = Uri(
                        scheme: 'tel',
                        path: itemCasa.datosdelcontactocasa.numerocelular,
                      );
                      if (await canLaunchUrl(uri)) launchUrl(uri);
                    },
                  ),
                _buildBotonAccion(
                  icono: Symbols
                      .mail, // 0xe22a — rango clásico, compatible web/WASM
                  titulo: "Correo",
                  tooltip: "Enviar correo al promotor",
                  onTap: () async {
                    final uri = Uri(
                      scheme: 'mailto',
                      path: itemCasa.datosdelcontactocasa.correoelectronico,
                    );
                    if (await canLaunchUrl(uri)) launchUrl(uri);
                  },
                ),
                _buildBotonAccion(
                  icono: Symbols
                      .forum, // 0xe2c3 — rango clásico, compatible web/WASM
                  titulo: "Mensaje",
                  tooltip: "Enviar mensaje al promotor",
                  onTap: () => _enviarMensajeAlPromotor(context, ref, itemCasa),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 25),
      ],
    );
  }

  /// OPTIMIZACIÓN: Método helper para construir el widget de precio y evitar el switch gigante en build.
  Widget _buildPrecio(String tipodepropiedad, dynamic espacioscasa) {
    String text = "";
    final moneda = espacioscasa.moneda;

    switch (espacioscasa.tipodetransaccion) {
      case "Venta":
        text = "$tipodepropiedad en Venta: ${espacioscasa.precioventa} $moneda";
        break;
      case "Renta":
        text = "$tipodepropiedad en Renta: ${espacioscasa.preciorenta} $moneda";
        break;
      case "Venta/Renta":
        text =
            "$tipodepropiedad en Venta/Renta: ${espacioscasa.precioventa}/${espacioscasa.preciorenta} $moneda";
        break;
      case "Traspaso":
        text =
            "$tipodepropiedad en Traspaso: ${espacioscasa.precioventa} $moneda";
        break;
      case "Otras":
        text = "Otras: ${espacioscasa.precioventa} $moneda";
        break;
      default:
        text = "";
    }

    return Text(
      text,
      style: TextStyle(
        letterSpacing: -0.2,
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: appTheme.onPrimaryContainer,
      ),
    );
  }

  /// OPTIMIZACIÓN: Método helper para generar los items de características (Icono + Valor).
  /// Reduce drásticamente la repetición de código `if (!valoresString.contains...)`.
  Widget _buildFeatureItem(
    IconData icon,
    String value, {
    String suffix = "",
    bool isLastItem = false,
  }) {
    // Si el valor está en la lista de exclusión ("" o "0"), no mostramos nada.
    if (valoresString.contains(value)) {
      return const SizedBox.shrink();
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: appTheme.onPrimaryContainer, size: iconSizeBanner),
        const SizedBox(width: 3),
        Text(
          "$value$suffix",
          maxLines: 1,
          overflow: TextOverflow.visible,
          style: TextStyle(
            letterSpacing: -0.4,
            fontSize: textSizeBanner,
            fontWeight: FontWeight.normal,
            color: appTheme.onPrimaryContainer,
          ),
        ),
        // Agrega espacio a la derecha si no es el último item visualmente (opcional, ajustado a tu lógica original)
        if (!isLastItem) SizedBox(width: espacioEntreDato),
      ],
    );
  }

  Widget _buildBotonAccion({
    required IconData icono,
    required String titulo,
    required String tooltip,
    required Function() onTap,
  }) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(4),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 3.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icono,
                size:
                    20.0, // Tamaño claro, sin restricciones de tamaño del IconButton
                color: appTheme.onPrimaryContainer,
              ),
              const SizedBox(height: 3),
              Text(
                titulo,
                style: TextStyle(
                  fontSize: 10.0, // Tamaño de letra altamente legible
                  fontFamily: "Urbanist",
                  fontWeight: FontWeight.bold,
                  height: 1.1,
                  color: appTheme.onPrimaryContainer,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _mostrarDialogContacto(
    BuildContext context,
    Datosdelcontactocasa contacto,
  ) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: appTheme.primary,
        elevation: 6,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(3)),
        ),
        titleTextStyle: TextStyle(
          color: appTheme.onPrimary,
          fontSize: 14,
          fontFamily: "Comfortaa",
          fontWeight: FontWeight.bold,
        ),
        titlePadding: const EdgeInsets.fromLTRB(6, 12, 6, 6),
        contentPadding: const EdgeInsets.all(3),
        actionsPadding: const EdgeInsets.all(6),
        title: const Text("Datos del Contacto", textAlign: TextAlign.center),
        content: Container(
          width: 250,
          padding: const EdgeInsets.all(6),
          color: appTheme.onPrimary,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildFilaContacto("Nombre", contacto.nombreusuariocontacto),
              _buildFilaContacto("Empresa", contacto.empresa),
              _buildFilaContacto("Celular", contacto.numerocelular),
              _buildFilaContacto("Otro", contacto.numerootro),
              _buildFilaContacto("Inmobiliaria", contacto.numeroinmobiliaria),
              _buildFilaContacto("Correo", contacto.correoelectronico),
            ],
          ),
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.all(3),
              backgroundColor: appTheme.surface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Cerrar',
              style: TextStyle(
                color: appTheme.primary,
                fontSize: 12,
                fontFamily: "Comfortaa",
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilaContacto(String label, String value) {
    if (value.isEmpty || value == "0") return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Text(
        "$label: $value",
        style: TextStyle(fontSize: 12, color: appTheme.secondary),
      ),
    );
  }

  Future<void> _enviarMensajeAlPromotor(
    BuildContext context,
    WidgetRef ref,
    EspaciosCasa itemCasa,
  ) async {
    final session = ref.read(sessionProvider);
    if (session.sessionUserData.userId.isEmpty) {
      if (!context.mounted) return;
      dialogBoxFichaLogin(context, ref);
      return;
    }

    final contacto = itemCasa.datosdelcontactocasa;
    if (contacto.idusuariocontacto.isEmpty) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: appTheme.error,
          content: Text(
            "Este promotor no tiene cuenta de usuario registrada.",
            style: TextStyle(color: appTheme.onError),
          ),
        ),
      );
      return;
    }

    // Nombre completo desde userData; fallback a userName de sesión
    final usuario = session.userData.rows.isNotEmpty
        ? session.userData.rows[0].value.usuario
        : null;
    final nombreCompleto = (usuario != null && usuario.nombres.isNotEmpty)
        ? '${usuario.nombres} ${usuario.apellidopaterno} ${usuario.apellidomaterno}'
              .trim()
        : session.sessionUserData.userName;

    final loc = itemCasa.ubicacioncasa.localidadCp;
    final mensaje =
        'Soy el usuario $nombreCompleto, estoy interesado en la propiedad '
        '${itemCasa.nombredelapropiedad}, ubicada en '
        '${loc.asentamiento}, ${loc.municipio}, ${loc.estado}, C.P. ${loc.cp}.';

    final contactoAgregado = await ref
        .read(conocidosProvider.notifier)
        .agregarContactoAceptado(
          session.sessionUserData.userId,
          session.sessionUserData.userName,
          contacto.idusuariocontacto,
          contacto.nombreusuariocontacto,
        );
    if (!context.mounted) return;

    if (!contactoAgregado) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: appTheme.error,
          content: Text(
            "Error al agregar el contacto. Intenta de nuevo.",
            style: TextStyle(color: appTheme.onError),
          ),
        ),
      );
      return;
    }

    final enviado = await enviarMensajeDirecto(
      senderId: session.sessionUserData.userId,
      receiverId: contacto.idusuariocontacto,
      content: mensaje,
    );
    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: enviado ? appTheme.primary : appTheme.error,
        content: Text(
          enviado
              ? "Mensaje enviado a ${contacto.nombreusuariocontacto}"
              : "Error al enviar el mensaje",
          style: TextStyle(
            color: enviado ? appTheme.onPrimary : appTheme.onError,
          ),
        ),
      ),
    );
  }
}

// Botón de "Me gusta" — ConsumerStatefulWidget para init + loading state
class _MeGustaButton extends ConsumerStatefulWidget {
  final String propiedadId;
  const _MeGustaButton({required this.propiedadId});

  @override
  ConsumerState<_MeGustaButton> createState() => _MeGustaButtonState();
}

class _MeGustaButtonState extends ConsumerState<_MeGustaButton> {
  bool _toggling = false;

  @override
  void initState() {
    super.initState();
    // Carga los me-gustas del usuario activo al montar el primer botón
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final userId = ref.read(sessionProvider).sessionUserData.userId;
      if (userId.isNotEmpty) {
        ref.read(meGustaProvider.notifier).init(userId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Reacciona a cambios de sesión (login / logout)
    ref.listen(sessionProvider, (prev, next) {
      final userId = next.sessionUserData.userId;
      if (userId.isEmpty) {
        ref.read(meGustaProvider.notifier).clear();
      } else if (prev?.sessionUserData.userId != userId) {
        ref.read(meGustaProvider.notifier).init(userId);
      }
    });

    final tieneGusta =
        ref
            .watch(meGustaProvider)
            .asData
            ?.value
            .any((m) => m.propiedadId == widget.propiedadId) ??
        false;

    if (_toggling) {
      return const SizedBox(
        width: 32,
        height: 32,
        child: Padding(
          padding: EdgeInsets.all(7),
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      );
    }

    return IconButton(
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(),
      tooltip: tieneGusta ? 'Quitar de favoritos' : 'Agregar a favoritos',
      icon: Icon(
        tieneGusta ? Symbols.favorite : Symbols.favorite_border,
        color: tieneGusta ? appTheme.error : appTheme.onSurfaceVariant,
        weight: 500.0,
        fill: tieneGusta ? 1.0 : 0.0,
        size: 20,
      ),
      onPressed: () async {
        final session = ref.read(sessionProvider).sessionUserData;
        if (session.userId.isEmpty) {
          dialogBoxFichaLogin(context, ref);
          return;
        }
        setState(() => _toggling = true);
        await ref
            .read(meGustaProvider.notifier)
            .toggleMeGusta(
              usuarioId: session.userId,
              propiedadId: widget.propiedadId,
              userListsNotifier: ref.read(userListsProvider.notifier),
            );
        if (mounted) setState(() => _toggling = false);
      },
    );
  }
}

//------------------------------------------------------------------------------
