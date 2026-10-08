import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../03_listas/lista_select_lista_save_propiedad.dart';
import '../../03_listas/page_compartir_con_conocido.dart';
import '../../03_listas/page_compartir_con_grupo.dart';
import '../../10_user_login/usuario_login/dialogbox_login.dart';
import '../../10_user_login/usuario_login/provider_session.dart';
import '../../20_var_globales/var_color_themes.dart';
import '../../22_imagenes/tus_espacios_fotos_propiedad/manejo_de_fotos/futures_y_providers/future_recupera_ids_fotos_propiedad.dart';
import '../../22_imagenes/tus_espacios_fotos_propiedad/manejo_de_fotos/lista_ids_fotos/data_fotos_get_ids_fotos_user_prop.dart';
import '../../60_global_widgets/debugprint.dart';
import '../inicio/data_espacios_casas.dart';
import '../inicio/data_espacios_casas_get.dart';
import '../tu_cuenta/conocidos/provider_mensajes.dart';
import '../tu_cuenta/conocidos/providers/conocidos_notifier.dart';
import 'pagina_detalle_propiedad_pdf.dart';

// Acciones reutilizables sobre una propiedad (contactar, guardar en lista,
// compartir y exportar a PDF). Las usan la tarjeta del catálogo y la ficha.

bool get _esMovil =>
    !kIsWeb &&
    (defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS);

void _aviso(BuildContext context, String texto, {bool error = false}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: error ? appTheme.error : appTheme.primary,
      content: Text(
        texto,
        style: TextStyle(color: error ? appTheme.onError : appTheme.onPrimary),
      ),
    ),
  );
}

// --------------------------------------------------------------------------
// Contacto
// --------------------------------------------------------------------------

void mostrarDialogContacto(
    BuildContext context, Datosdelcontactocasa contacto) {
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
            _filaContacto("Nombre", contacto.nombreusuariocontacto),
            _filaContacto("Empresa", contacto.empresa),
            _filaContacto("Celular", contacto.numerocelular),
            _filaContacto("Otro", contacto.numerootro),
            _filaContacto("Inmobiliaria", contacto.numeroinmobiliaria),
            _filaContacto("Correo", contacto.correoelectronico),
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

Widget _filaContacto(String label, String value) {
  if (value.isEmpty || value == "0") return const SizedBox.shrink();
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 2),
    child: Text(
      "$label: $value",
      style: TextStyle(fontSize: 12, color: appTheme.secondary),
    ),
  );
}

Future<void> llamarAlPromotor(
    BuildContext context, Datosdelcontactocasa contacto) async {
  final numero = contacto.numerocelular.trim();
  if (numero.isEmpty || numero == "0") {
    _aviso(context, "La propiedad no tiene teléfono de contacto.", error: true);
    return;
  }
  final uri = Uri(scheme: 'tel', path: numero);
  if (await canLaunchUrl(uri)) await launchUrl(uri);
}

Future<void> escribirAlPromotor(
    BuildContext context, Datosdelcontactocasa contacto) async {
  final correo = contacto.correoelectronico.trim();
  if (correo.isEmpty) {
    _aviso(context, "La propiedad no tiene correo de contacto.", error: true);
    return;
  }
  final uri = Uri(scheme: 'mailto', path: correo);
  if (await canLaunchUrl(uri)) await launchUrl(uri);
}

Future<void> enviarMensajeAlPromotor(
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
    _aviso(context, "Este promotor no tiene cuenta de usuario registrada.",
        error: true);
    return;
  }

  // Nombre completo desde userData; respaldo: userName de la sesión
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

  final contactoAgregado =
      await ref.read(conocidosProvider.notifier).agregarContactoAceptado(
            session.sessionUserData.userId,
            session.sessionUserData.userName,
            contacto.idusuariocontacto,
            contacto.nombreusuariocontacto,
          );
  if (!context.mounted) return;

  if (!contactoAgregado) {
    _aviso(context, "Error al agregar el contacto. Intenta de nuevo.",
        error: true);
    return;
  }

  final enviado = await enviarMensajeDirecto(
    senderId: session.sessionUserData.userId,
    receiverId: contacto.idusuariocontacto,
    content: mensaje,
  );
  if (!context.mounted) return;

  _aviso(
    context,
    enviado
        ? "Mensaje enviado a ${contacto.nombreusuariocontacto}"
        : "Error al enviar el mensaje",
    error: !enviado,
  );
}

// --------------------------------------------------------------------------
// Guardar en lista y compartir
// --------------------------------------------------------------------------

Future<void> guardarEnLista(
    BuildContext context, WidgetRef ref, EspaciosCasa e) async {
  final session = ref.read(sessionProvider).sessionUserData;
  if (session.userId.isEmpty) {
    dialogBoxFichaLogin(context, ref);
    return;
  }
  await Navigator.of(context).push(
    MaterialPageRoute<void>(
      builder: (_) => DialogSelectorListas(
        userId: session.userId,
        propertyId: e.idPropiedad,
        tipoDeEspacio: e.tipodeanuncio,
      ),
    ),
  );
}

Future<void> compartirPropiedad(
    BuildContext context, WidgetRef ref, EspaciosCasa e) async {
  final session = ref.read(sessionProvider).sessionUserData;
  if (session.userId.isEmpty) {
    dialogBoxFichaLogin(context, ref);
    return;
  }
  final destino = await showModalBottomSheet<String>(
    context: context,
    backgroundColor: appTheme.surface,
    builder: (ctx) => SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: Icon(Symbols.person, color: appTheme.primary),
            title: const Text('Compartir con un conocido'),
            onTap: () => Navigator.of(ctx).pop('conocido'),
          ),
          ListTile(
            leading: Icon(Symbols.groups, color: appTheme.primary),
            title: const Text('Compartir en un grupo'),
            onTap: () => Navigator.of(ctx).pop('grupo'),
          ),
        ],
      ),
    ),
  );
  if (destino == null || !context.mounted) return;

  await Navigator.of(context).push(
    MaterialPageRoute<void>(
      builder: (_) => destino == 'conocido'
          ? PageCompartirConConocido(
              propiedadId: e.idPropiedad,
              propiedadNombre: e.nombredelapropiedad,
              tipodeespacio: e.tipodeanuncio,
              currentUserId: session.userId,
              currentUserName: session.userName,
            )
          : PageCompartirConGrupo(
              propiedadId: e.idPropiedad,
              propiedadNombre: e.nombredelapropiedad,
              tipodeespacio: e.tipodeanuncio,
              currentUserId: session.userId,
              currentUserName: session.userName,
            ),
    ),
  );
}

// --------------------------------------------------------------------------
// Exportar a PDF
// --------------------------------------------------------------------------

/// Genera la ficha técnica en PDF. Si [ids] viene vacío (p. ej. al llegar desde
/// un chat) consulta los ids de las fotos de la propiedad.
Future<void> exportarFichaPdf(
  BuildContext context,
  ValueEspaciosCasaGet propiedad,
  GetIdsFotosUserProp ids,
) async {
  final mensajero = ScaffoldMessenger.of(context);
  mensajero.showSnackBar(
    SnackBar(
      backgroundColor: appTheme.primary,
      duration: const Duration(seconds: 4),
      content:
          Text('Generando PDF…', style: TextStyle(color: appTheme.onPrimary)),
    ),
  );
  try {
    var lista = ids;
    final e = propiedad.espacioscasa;
    if (lista.rows.isEmpty) {
      lista = await recuperaIdsFotosDePropiedades(e.idusuario, e.idPropiedad);
    }
    final idsFotos = lista.rows.map((r) => r.value).toList();
    await PdfGeneratorService.generarYDescargarPDF(
      propiedad,
      idsFotos.isNotEmpty ? idsFotos.first : '',
      idsFotos,
    );
  } catch (err) {
    debugPrintLevels(0, 'exportarFichaPdf error: $err');
    mensajero.showSnackBar(
      SnackBar(
        backgroundColor: appTheme.error,
        content: Text(
          'No se pudo generar el PDF. Revisa tu conexión e inténtalo de nuevo.',
          style: TextStyle(color: appTheme.onError),
        ),
      ),
    );
  }
}

// --------------------------------------------------------------------------
// Barra de acciones de la ficha
// --------------------------------------------------------------------------

class BarraAccionesPropiedad extends ConsumerWidget {
  final ValueEspaciosCasaGet propiedad;
  final GetIdsFotosUserProp listaIdsFotos;

  const BarraAccionesPropiedad({
    super.key,
    required this.propiedad,
    required this.listaIdsFotos,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final e = propiedad.espacioscasa;
    final contacto = e.datosdelcontactocasa;
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 4,
      runSpacing: 4,
      children: [
        BotonAccionPropiedad(
          icono: Symbols.contact_mail,
          titulo: 'Contacto',
          tooltip: 'Ver datos del promotor',
          onTap: () => mostrarDialogContacto(context, contacto),
        ),
        if (_esMovil)
          BotonAccionPropiedad(
            icono: Symbols.phone,
            titulo: 'Teléfono',
            tooltip: 'Llamar al promotor',
            onTap: () => llamarAlPromotor(context, contacto),
          ),
        BotonAccionPropiedad(
          icono: Symbols.mail,
          titulo: 'Correo',
          tooltip: 'Enviar correo al promotor',
          onTap: () => escribirAlPromotor(context, contacto),
        ),
        BotonAccionPropiedad(
          icono: Symbols.forum,
          titulo: 'Mensaje',
          tooltip: 'Enviar mensaje al promotor',
          onTap: () => enviarMensajeAlPromotor(context, ref, e),
        ),
        BotonAccionPropiedad(
          icono: Symbols.playlist_add,
          titulo: 'Guardar',
          tooltip: 'Guardar en una lista',
          onTap: () => guardarEnLista(context, ref, e),
        ),
        BotonAccionPropiedad(
          icono: Symbols.share,
          titulo: 'Compartir',
          tooltip: 'Compartir con un conocido o grupo',
          onTap: () => compartirPropiedad(context, ref, e),
        ),
        BotonAccionPropiedad(
          icono: Symbols.picture_as_pdf,
          titulo: 'PDF',
          tooltip: 'Exportar ficha en PDF',
          onTap: () => exportarFichaPdf(context, propiedad, listaIdsFotos),
        ),
      ],
    );
  }
}

class BotonAccionPropiedad extends StatelessWidget {
  final IconData icono;
  final String titulo;
  final String tooltip;
  final VoidCallback onTap;

  const BotonAccionPropiedad({
    super.key,
    required this.icono,
    required this.titulo,
    required this.tooltip,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(4),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icono, size: 22.0, color: appTheme.onPrimaryContainer),
              const SizedBox(height: 3),
              Text(
                titulo,
                style: TextStyle(
                  fontSize: 10.0,
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
}
