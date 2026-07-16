import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class SessionStorage {
  Future<void> write({required String key, required String value});
  Future<String?> read({required String key});
  Future<void> deleteAll();
}

class MobileSessionStorage implements SessionStorage {
  const MobileSessionStorage();

  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  @override
  Future<void> deleteAll() => _storage.deleteAll();

  @override
  Future<String?> read({required String key}) => _storage.read(key: key);

  @override
  Future<void> write({required String key, required String value}) =>
      _storage.write(key: key, value: value);
}

class WebSessionStorage implements SessionStorage {
  const WebSessionStorage();

  Future<SharedPreferences> _getPrefs() => SharedPreferences.getInstance();

  @override
  Future<void> deleteAll() async {
    final prefs = await _getPrefs();
    await prefs.clear();
  }

  @override
  Future<String?> read({required String key}) async {
    final prefs = await _getPrefs();
    return prefs.getString(key);
  }

  @override
  Future<void> write({required String key, required String value}) async {
    final prefs = await _getPrefs();
    await prefs.setString(key, value);
  }
}

SessionStorage createSessionStorage() {
  if (kIsWeb) {
    return const WebSessionStorage();
  }
  return const MobileSessionStorage();
}
