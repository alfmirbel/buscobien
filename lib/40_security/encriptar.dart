// https://github.com/leocavalcante/encrypt
//https://blog.stackademic.com/flutter-security-mastery-secure-your-data-with-aes-256-rsa-keys-sha-256-9d5b73d2989c

import 'package:encrypt/encrypt.dart';
import 'package:shared_preferences/shared_preferences.dart';

/*
const String iv = "aRandomStringForEncryption";
const String key = "aRandomStringForEncryption";
*/
Key key32 = Key.fromSecureRandom(32);
IV iv16 = IV.fromSecureRandom(16);

Encrypter encrypter = Encrypter(AES(key32));
const String ivString = "12345678901234567890123456789012";

Encrypted encrypted = encrypter.encrypt("plainText", iv: iv16);
String decrypted = encrypter.decrypt(encrypted, iv: iv16);

//-----------------------------------------------------------------------------

@Deprecated('Usa flutter_secure_storage en su lugar')
String ivAES = "66a05e9b32ca56e7";

@Deprecated('Usa flutter_secure_storage en su lugar')
String keyAES = "ab23c6dc3272de8afb68b18a5869b16f";
//"66a05e9b32ca56e7 fe47fa7e8b3e1da8";
//"1234567890123456 7890123456789012"

@Deprecated('Usa flutter_secure_storage en su lugar')
String decryptWithAES(String key, Encrypted encryptedData) {
  final cipherKey = Key.fromUtf8(key);
  final encryptService = Encrypter(AES(cipherKey, mode: AESMode.cbc));
  final initVector = IV.fromUtf8(ivAES);
  return encryptService.decrypt(encryptedData, iv: initVector);
}

@Deprecated('Usa flutter_secure_storage en su lugar')
Encrypted encryptWithAES(String key, String plainText) {
  final cipherKey = Key.fromUtf8(key);
  final encryptService = Encrypter(AES(cipherKey, mode: AESMode.cbc));
  final initVector = IV.fromUtf8(ivAES);
  Encrypted encryptedData = encryptService.encrypt(plainText, iv: initVector);
  return encryptedData;
}

@Deprecated('Usa flutter_secure_storage en su lugar')
void initStringLocalStorage(String varName, String valueToSave) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setString(varName, valueToSave);
}

/*

*/
