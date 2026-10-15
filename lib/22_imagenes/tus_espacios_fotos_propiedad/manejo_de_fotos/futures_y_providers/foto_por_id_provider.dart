import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'http_funciones_gestion_foto.dart';

/// Foto (base64) por id, con caché: reconstruir la pantalla no vuelve a pedirla
/// a CouchDB. Se conserva 2 minutos después de que nadie la usa.
/// Tras agregar, reemplazar o borrar una foto, invalidar con
/// `ref.invalidate(fotoPorIdProvider(idFoto))`.
final fotoPorIdProvider = FutureProvider.autoDispose.family<String, String>(
  (ref, idFoto) async {
    final enlace = ref.keepAlive();
    final temporizador = Timer(const Duration(minutes: 2), enlace.close);
    ref.onDispose(temporizador.cancel);
    return recuperaFotoPorIdFoto(idFoto);
  },
  retry: (reintentos, error) => null, // sin reintentos automáticos: el error se muestra
);

/// Sustituto de `FutureBuilder<String>(future: recuperaFotoPorIdFoto(id))`:
/// mismo `builder` con un [AsyncSnapshot], pero con la foto en caché.
class FotoBuilder extends ConsumerWidget {
  final String idFoto;
  final Widget Function(BuildContext context, AsyncSnapshot<String> snapshot)
  builder;

  const FotoBuilder({super.key, required this.idFoto, required this.builder});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshot = ref
        .watch(fotoPorIdProvider(idFoto))
        .when(
          loading: () => const AsyncSnapshot<String>.waiting(),
          error: (e, st) =>
              AsyncSnapshot<String>.withError(ConnectionState.done, e, st),
          data: (d) =>
              AsyncSnapshot<String>.withData(ConnectionState.done, d),
        );
    return builder(context, snapshot);
  }
}
