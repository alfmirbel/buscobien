
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';

import 'package:buscobien/20_var_globales/var_color_themes.dart';
import 'package:buscobien/20_var_globales/format_chat_timestamp.dart';
import 'package:buscobien/20_var_globales/variables_globales.dart';
import '../burbujas_chat.dart';
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
                          color: isMe
                              ? appTheme.secondary
                              : appTheme.onInverseSurface,
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
                              BurbujaPropiedadChat(
                                propiedadId: msg.propiedadId,
                                nombre: msg.content,
                              )
                            else if (msg.tipo == 'lista')
                              BurbujaListaChat(
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
                                      ? appTheme.onSecondary
                                          .withValues(alpha: 0.75)
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
                        hintStyle:
                            TextStyle(color: appTheme.onPrimaryContainer),
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
                      icon:
                          Icon(Symbols.send, color: appTheme.primary, size: 18),
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
