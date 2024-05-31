import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageHelper {
  static const storage = FlutterSecureStorage();

  static Future<String?> get(String key) async {
    return storage.read(key: key);
  }
  static Future<Map<String, String>> getAllValues() {
    return storage.readAll();
  }
  static delete(String key) {
    return storage.delete(key: key);
  }
  static deleteAll() {
    return storage.deleteAll();
  }
  static write(String key, String value) {
    return storage.write(key: key, value: value);
  }
}