import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStorageService {
  final _secureStorage = const FlutterSecureStorage();
  static const _keyAuthToken = 'auth_token';

  Future<void> saveToken(String token) async {
    await _secureStorage.write(key: _keyAuthToken, value: token);
  }

  Future<String?> readToken() async {
    return await _secureStorage.read(key: _keyAuthToken);
  }

  Future<void> deleteToken() async {
    await _secureStorage.delete(key: _keyAuthToken);
  }
}
