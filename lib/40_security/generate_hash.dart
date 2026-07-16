import 'package:crypto/crypto.dart';
import 'dart:convert';

String generateMD5Hash(String input) {
  var bytes = utf8.encode(input);
  var md5Hash = md5.convert(bytes);
  return md5Hash.toString();
}

String generateSHA1Hash(String input) {
  var bytes = utf8.encode(input);
  var sha1Hash = sha1.convert(bytes);
  return sha1Hash.toString();
}

String generateSHA256Hash(String input) {
  var bytes = utf8.encode(input);
  var sha256Hash = sha256.convert(bytes);
  return sha256Hash.toString();
}

bool validaPassword(String password, String hashPassword) {
  String hashAValidar = generateSHA256Hash(password);
//   debugPrintLevels(0, "05.1 fetchPassword: $hashAValidar");

  if (hashAValidar == hashPassword) {
    //  debugPrintLevels(0, "hashAValidar == hashPassword");
    return true;
  } else {
    return false;
  }
}

/*
String myText = "Hola, mundo!";
String hash = generateMD5Hash(myText);
print(hash);
*/
