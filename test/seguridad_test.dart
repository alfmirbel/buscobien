import 'package:flutter_test/flutter_test.dart';

import 'package:buscobien/40_security/generate_hash.dart';
import 'package:buscobien/40_security/generate_reset_token.dart';

void main() {
  group('generate_hash', () {
    test('MD5, SHA1 y SHA256 de "abc" coinciden con los vectores conocidos', () {
      expect(generateMD5Hash('abc'), '900150983cd24fb0d6963f7d28e17f72');
      expect(generateSHA1Hash('abc'), 'a9993e364706816aba3e25717850c26c9cd0d89d');
      expect(
        generateSHA256Hash('abc'),
        'ba7816bf8f01cfea414140de5dae2223b00361a396177a9cb410ff61f20015ad',
      );
    });

    test('validaPassword acepta la contraseña correcta y rechaza otra', () {
      final hash = generateSHA256Hash('secreto');
      expect(validaPassword('secreto', hash), isTrue);
      expect(validaPassword('otra', hash), isFalse);
    });
  });

  group('generate_reset_token', () {
    test('el token es un SHA-256 hexadecimal de 64 caracteres y cambia en cada llamada', () {
      final a = generateResetToken();
      final b = generateResetToken();
      expect(a, matches(RegExp(r'^[0-9a-f]{64}$')));
      expect(a, isNot(b));
    });

    test('la expiración generada es válida y cae aproximadamente una hora después', () {
      final expiry = DateTime.parse(generateTokenExpiry());
      final minutos = expiry.difference(DateTime.now().toUtc()).inMinutes;
      expect(minutos, inInclusiveRange(58, 60));
      expect(isTokenValid(generateTokenExpiry()), isTrue);
    });

    test('isTokenValid rechaza fechas vencidas y textos inválidos', () {
      final vencida = DateTime.now().toUtc().subtract(const Duration(minutes: 1));
      expect(isTokenValid(vencida.toIso8601String()), isFalse);
      expect(isTokenValid('no es una fecha'), isFalse);
      expect(isTokenValid(''), isFalse);
    });
  });
}
