import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:uuid/uuid.dart';

String generateResetToken() {
  final uuid = const Uuid().v4();
  final hash = sha256.convert(utf8.encode(uuid));
  return hash.toString();
}

String generateTokenExpiry() {
  final expiry = DateTime.now().toUtc().add(const Duration(hours: 1));
  return expiry.toIso8601String();
}

bool isTokenValid(String tokenExpiry) {
  try {
    final expiry = DateTime.parse(tokenExpiry);
    return DateTime.now().toUtc().isBefore(expiry);
  } catch (_) {
    return false;
  }
}
