import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:material_symbols_icons/symbols.dart';

import 'package:buscobien/20_var_globales/format_chat_timestamp.dart';
import 'package:buscobien/20_var_globales/var_de_estilo_widgets.dart';
import 'package:buscobien/20_var_globales/var_color_themes.dart';
import 'package:buscobien/20_var_globales/variables_globales.dart';

import 'package:buscobien/40_security/direccionip.dart';
import 'package:buscobien/60_global_widgets/debugprint.dart';
import 'package:buscobien/08_pantallas/inicio/data_espacios_casas_get.dart';
import 'package:buscobien/22_imagenes/tus_espacios_fotos_propiedad/manejo_de_fotos/lista_ids_fotos/data_fotos_get_ids_fotos_user_prop.dart';
import 'package:buscobien/08_pantallas/propiedades/pagina_detalle_propiedad.dart';
import 'package:buscobien/03_listas/models/lista_compartida_model.dart';
import 'package:buscobien/03_listas/pagina_detalle_lista_compartida.dart';
import 'models/mensaje_grupo_model.dart';
import 'providers/grupos_mensajes_provider.dart';

class PageChatGrupo extends ConsumerStatefulWidget {
  final String grupoId;
  final String grupoNombre;
  final String currentUserId;
  final String currentUserName;

  const PageChatGrupo({
    super.key,
    required this.grupoId,
    required this.grupoNombre,
    required this.currentUserId,
    required this.currentUserName,
  });

  @override
  ConsumerState<PageChatGrupo> createState() => _PageChatGrupoState();
}

class _PageChatGrupoState extends ConsumerState<PageChatGrupo> {
  final _textController = TextEditingController();

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
    await ref
        .read(mensajesGrupoProvider(widget.grupoId).notifier)
        .enviar(
          senderId: widget.currentUserId,
          senderName: widget.currentUserName,
          content: text,
        );
  }

  @override
  Widget build(BuildContext context) {
    final asyncMensajes = ref.watch(mensajesGrupoProvider(widget.grupoId));

    return Scaffold(
      backgroundColor: appTheme.surface,
      appBar: AppBar(
        toolbarHeight: socialAppBarHeight,
        centerTitle: true,
        titleSpacing: 0,
        backgroundColor: appTheme.primary,
        iconTheme: IconThemeData(size: 14, color: appTheme.onPrimary),
        title: Text(
          widget.grupoNombre,
          style: TextStyle(
            color: appTheme.onPrimary,
            fontWeight: FontWeight.normal,
            fontSize: fontSizeTituloPagina,
          ),
        ),
        foregroundColor: appTheme.onPrimary,
        actions: const [
          IconButton(icon: Icon(Symbols.refresh), onPressed: null),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: asyncMensajes.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => const Center(child: Text('Error')),
              data: (mensajes) {
                if (mensajes.isEmpty) {
                  return Center(
                    child: Text(
                      'Envía el primer mensaje al grupo.',
                      style: TextStyle(color: appTheme.onSurfaceVariant),
                    ),
                  );
                }
                return ListView.builder(
                  reverse: true,
                  padding: const EdgeInsets.all(12),
                  itemCount: mensajes.length,
                  itemBuilder: (context, index) =>
                      _BurbujaMensaje(msg: mensajes[index]),
                );
              },
            ),
          ),
          _BarraInput(controller: _textController, onSend: _send),
        ],
      ),
    );
  }
}

class _BurbujaMensaje extends StatelessWidget {
  final MensajeGrupoModel msg;

  const _BurbujaMensaje({required this.msg});

  @override
  Widget build(BuildContext context) {
    final isMe = false;
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        child: Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: isMe ? appTheme.secondary : appTheme.onInverseSurface,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(18),
              topRight: Radius.circular(18),
              bottomLeft: Radius.circular(2),
              bottomRight: Radius.circular(2),
            ),
          ),
          child: Column(
            crossAxisAlignment: isMe
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            children: [
              if (!isMe)
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text(
                    msg.senderName,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: appTheme.primary,
                    ),
                  ),
                ),
              if (msg.tipo == 'propiedad')
                _BurbujaPropiedad(propiedadId: msg.propiedadId, nombre: msg.content)
              else if (msg.tipo == 'lista')
                _BurbujaLista(listaCompartidaId: msg.listaCompartidaId, nombre: msg.content)
              else
                Text(
                  msg.content,
                  style: TextStyle(
                    color: isMe
                        ? appTheme.onSecondary
                        : appTheme.onPrimaryContainer,
                    fontSize: 14,
                  ),
                ),
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
    return const SizedBox.shrink();
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
    return const SizedBox.shrink();
  }
}

class _BarraInput extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;

  const _BarraInput({required this.controller, required this.onSend});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 8),
      decoration: BoxDecoration(
        color: appTheme.primary,
        border: Border(top: BorderSide(color: appTheme.onPrimaryContainer)),
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
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
                onSubmitted: (_) => onSend(),
              ),
            ),
            const SizedBox(width: 8),
            CircleAvatar(
              backgroundColor: appTheme.onPrimary,
              child: IconButton(
                icon: Icon(Symbols.send, color: appTheme.primary, size: 18),
                onPressed: onSend,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Embeddable chat widget.

class ChatGrupoEmbebido extends ConsumerStatefulWidget {
  final String grupoId;
  final String currentUserId;
  final String currentUserName;

  const ChatGrupoEmbebido({
    super.key,
    required this.grupoId,
    required this.currentUserId,
    required this.currentUserName,
  });

  @override
  ConsumerState<ChatGrupoEmbebido> createState() => _ChatGrupoEmbebidoState();
}

class _ChatGrupoEmbebidoState extends ConsumerState<ChatGrupoEmbebido> {
  final _textController = TextEditingController();

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
    await ref
        .read(mensajesGrupoProvider(widget.grupoId).notifier)
        .enviar(
          senderId: widget.currentUserId,
          senderName: widget.currentUserName,
          content: text,
        );
  }

  @override
  Widget build(BuildContext context) {
    final asyncMensajes = ref.watch(mensajesGrupoProvider(widget.grupoId));

    return Column(
      key: const Key('chat-embebido-column'),
      children: [
        Expanded(
          child: asyncMensajes.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(
              child: Text('Error', style: TextStyle(color: appTheme.error)),
            ),
            data: (mensajes) {
              if (mensajes.isEmpty) {
                return Center(
                  child: Text(
                    'Envía el primer mensaje al grupo.',
                    style: TextStyle(color: appTheme.onSurfaceVariant),
                  ),
                );
              }
              return ListView.builder(
                reverse: true,
                padding: const EdgeInsets.all(12),
                itemCount: mensajes.length,
                itemBuilder: (context, index) =>
                    _BurbujaMensaje(msg: mensajes[index]),
              );
            },
          ),
        ),
        _BarraInput(controller: _textController, onSend: _send),
      ],
    );
  }
}
