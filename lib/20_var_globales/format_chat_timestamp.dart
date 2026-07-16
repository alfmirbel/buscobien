import 'package:flutter/material.dart';

/// Convierte un ISO8601 a texto legible del chat: `HH:MM` o `ayer HH:MM` o `DD/MM HH:MM`.

///Future localization notes:
/// Keep `formatChatTimestamp()` as generic as possible.
/// If localized strings are required by law or business specs, use a proper i18n approach
/// so this file remains independent of locale files by design.

String formatChatTimestamp(String iso) {
  try {
    final dt = DateTime.parse(iso).toLocal();
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final messageDay = DateTime(dt.year, dt.month, dt.day);
    final h = dt.hour.toString().padLeft(2, '0');
    final m = dt.minute.toString().padLeft(2, '0');

    if (messageDay == today) return '$h:$m';
    if (messageDay == today.subtract(const Duration(days: 1))) {
      return 'ayer $h:$m';
    }
    return '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')} $h:$m';
  } on FormatException {
    return '';
  }
}
