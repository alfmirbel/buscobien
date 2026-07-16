import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:material_symbols_icons/symbols.dart';

import 'package:buscobien/20_var_globales/var_color_themes.dart';
import 'package:buscobien/20_var_globales/format_chat_timestamp.dart';
import 'package:buscobien/40_security/direccionip.dart';
import 'package:buscobien/60_global_widgets/debugprint.dart';
import 'package:buscobien/08_pantallas/inicio/data_espacios_casas_get.dart';
import 'package:buscobien/22_imagenes/tus_espacios_fotos_propiedad/manejo_de_fotos/lista_ids_fotos/data_fotos_get_ids_fotos_user_prop.dart';
import 'package:buscobien/08_pantallas/propiedades/pagina_detalle_propiedad.dart';
import 'package:buscobien/03_listas/models/lista_compartida_model.dart';
import 'package:buscobien/03_listas/pagina_detalle_lista_compartida.dart';
import 'package:buscobien/20_var_globales/variables_globales.dart';
import 'provider_mensajes.dart';

class PageChatPrivado extends ConsumerStatefulWidget {
  final String currentUserId;
  final String targetUserId;
  final String targetName;

  const PageChatPrivado({
    super.key,
    required this.currentUserId,
    required this.targetUserId,
    required this.targetName,
  });

  @override
  ConsumerState<PageChatPrivado> createState() => _PageChatPrivadoState();
}

class _PageChatPrivadoState extends ConsumerState<PageChatPrivado> {
  final _textController = TextEditingController();
  late final String _chatKey;

  @override
  void initState() {
    super.initState();
    _chatKey = chatProviderKey(widget.currentUserId, widget.targetUserId);
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    final text = _textController.text.trim();
    if (text.isEmpty) return;
    _textController.clear();
    FocusScope.of(context).unfocus();
    await ref.read(mensajesChatProvider(_chatKey).notifier).enviar(text);
  }

  @override
  Widget build(BuildContext context) {
    final asyncChat = ref.watch(mensajesChatProvider(_chatKey));

    return Scaffold(
      backgroundColor: appTheme.surface,
      appBar: AppBar(
        toolbarHeight: socialAppBarHeight,
        centerTitle: true,
        titleSpacing: 0,
        backgroundColor: appTheme.primary,
        iconTheme: IconThemeData(size: 14, color: appTheme.onPrimary),
        title: Text(
          widget.targetName,
          style: TextStyle(
            color: appTheme.onPrimary,
            fontWeight: FontWeight.normal,
            fontSize: fontSizeTituloPagina,
          ),
        ),
        foregroundColor: appTheme.onPrimary,
        actions: [
          IconButton(
            icon: const Icon(Symbols.refresh),
            onPressed: () => ref.invalidate(mensajesChatProvider(_chatKey)),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: asyncChat.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, _) => Center(child: Text('Error: $err')),
              data: (mensajes) {
                if (mensajes.isEmpty) {
                  return const Center(child: Text('Envía el primer mensaje.'));
                }
                return ListView.builder(
                  reverse: true,
                  padding: const EdgeInsets.all(14),
                  itemCount: mensajes.length,
                  itemBuilder: (context, index) {
                    final msg = mensajes[index];
                    final isMe = msg.senderId == widget.currentUserId;

                    return Align(
                      alignment:
                          isMe ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color:
                              isMe ? appTheme.secondary : appTheme.onInverseSurface,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(18),
                            topRight: Radius.circular(18),
                            bottomLeft: Radius.circular(2),
                            bottomRight: Radius.circular(2),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: appTheme.shadow.withValues(alpha: 0.06),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: isMe
                              ? CrossAxisAlignment.end
                              : CrossAxisAlignment.start,
                          children: [
                            if (msg.tipo == 'propiedad')
                              _BurbujaPropiedad(
                                propiedadId: msg.propiedadId,
                                nombre: msg.content,
                              )
                            else if (msg.tipo == 'lista')
                              _BurbujaLista(
                                listaCompartidaId: msg.listaCompartidaId,
                                nombre: msg.content,
                              )
                            else
                              Text(
                                msg.content,
                                style: TextStyle(
                                  color: isMe
                                      ? appTheme.onSecondary
                                      : appTheme.onSecondaryContainer,
                                  fontSize: fontSizeSubtituloPagina,
                                ),
                              ),
                            if (msg.tipo != 'texto') ...[
                              const SizedBox(height: 4),
                              Text(
                                'Toca para ver detalles',
                                style: TextStyle(
                                  color: isMe
                                      ? appTheme.onSecondary.withValues(alpha: 0.75)
                                      : appTheme.primary,
                                  fontSize: 10,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ],
                            const SizedBox(height: 3),
                            Text(
                              formatChatTimestamp(msg.timestamp),
                              style: TextStyle(
                                fontSize: 10,
                                color: isMe
                                    ? appTheme.onSecondary
                                    : appTheme.onPrimaryContainer,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 8),
            decoration: BoxDecoration(
              color: appTheme.primary,
              border: Border(
                top: BorderSide(color: appTheme.onPrimaryContainer),
              ),
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _textController,
                      minLines: 1,
                      maxLines: 10,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: InputDecoration(
                        hintText: 'Escribe un mensaje...',
                        hintStyle: TextStyle(color: appTheme.onPrimaryContainer),
                        filled: true,
                        fillColor: appTheme.surface,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 8,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(9),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onSubmitted: (_) => _send(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  CircleAvatar(
                    backgroundColor: appTheme.onPrimary,
                    child: IconButton(
                      icon: Icon(Symbols.send, color: appTheme.primary, size: 18),
                      onPressed: _send,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BurbujaPropiedad extends StatelessWidget {
  final String propiedadId;
  final String nombre;

  const _BurbujaPropiedad({
    required this.propiedadId,
    required this.nombre,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _verPropiedad(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Symbols.home,
                size: 14,
                color: appTheme.onSecondaryContainer,
              ),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  nombre,
                  style: TextStyle(
                    color: appTheme.onSecondaryContainer,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Toca para ver la ficha',
            style: TextStyle(
              color: appTheme.primary.withValues(alpha: 0.75),
              fontSize: 11,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _verPropiedad(BuildContext context) async {
    if (propiedadId.isEmpty) return;
    try {
      final authHeaders = {
        'Authorization':
            'Basic ${base64Encode(utf8.encode('$username:$password'))}',
        'Content-Type': 'application/json',
      };
      final resp = await http.get(
        Uri.parse('$direccionip/buscobien_espacios/$propiedadId'),
        headers: authHeaders,
      );
      if (resp.statusCode == 200) {
        final doc = jsonDecode(utf8.decode(resp.bodyBytes)) as Map<String, dynamic>;
        final propiedad = ValueEspaciosCasaGet.fromJson(doc);
        if (!context.mounted) return;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => PaginaDetalleWidget(
              propiedad,
              GetIdsFotosUserProp(totalRows: 0, offset: 0, rows: []),
            ),
          ),
        );
      } else {
        debugPrintLevels(1, '_BurbujaPropiedad error: ${resp.statusCode}');
      }
    } catch (e) {
      debugPrintLevels(1, '_BurbujaPropiedad exception: $e');
    }
  }
}

class _BurbujaLista extends StatelessWidget {
  final String listaCompartidaId;
  final String nombre;

  const _BurbujaLista({
    required this.listaCompartidaId,
    required this.nombre,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _verLista(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Symbols.format_list_bulleted,
                size: 14,
                color: appTheme.onSecondaryContainer,
              ),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  nombre,
                  style: TextStyle(
                    color: appTheme.onSecondaryContainer,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Toca para ver las propiedades',
            style: TextStyle(
              color: appTheme.primary.withValues(alpha: 0.75),
              fontSize: 11,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  void _verLista(BuildContext context) {
    if (listaCompartidaId.isEmpty) return;
    final modelo = ListaCompartidaModel(
      id: listaCompartidaId,
      listaOrigenId: '',
      listaNombre: nombre,
      usuarioOrigenId: '',
      usuarioOrigenNombre: '',
      usuarioDestinoId: '',
      usuarioDestinoNombre: '',
      timestamp: '',
    );
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PageDetalleListaCompartida(modelo),
      ),
    );
  }
}
