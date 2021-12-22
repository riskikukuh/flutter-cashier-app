import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SessionHelper {
  final _secureStorage = const FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
  );

  Future<void> cleaUserLogin() async {
    await _secureStorage.delete(key: '_userId');
    await _secureStorage.delete(key: '_username');
    await _secureStorage.delete(key: '_nama');
  }

  Future<String?> isAlreadyLogin() async {
    return await _secureStorage.read(key: '_userId');
  }

  Future<void> setUserLogin(String userId, String nama, String username) async {
    await _secureStorage.write(key: '_userId', value: userId);
    await _secureStorage.write(key: '_nama', value: nama);
    await _secureStorage.write(key: '_username', value: username);
  }
}
