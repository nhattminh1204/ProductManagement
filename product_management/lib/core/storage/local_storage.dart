import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LocalStorage {
  static const _storage = FlutterSecureStorage();
  
  static const String _tokenKey = 'auth_token';
  static const String _userIdKey = 'user_id';
  static const String _userEmailKey = 'user_email';

  /// Save authentication token
  static Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  /// Get authentication token
  static Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

  /// Delete authentication token
  static Future<void> deleteToken() async {
    await _storage.delete(key: _tokenKey);
  }

  /// Save user basic info
  static Future<void> saveUserInfo(String id, String email) async {
    await _storage.write(key: _userIdKey, value: id);
    await _storage.write(key: _userEmailKey, value: email);
  }

  /// Get user info
  static Future<Map<String, String?>> getUserInfo() async {
    final id = await _storage.read(key: _userIdKey);
    final email = await _storage.read(key: _userEmailKey);
    return {
      'id': id,
      'email': email,
    };
  }

  /// Clear all data (logout)
  static Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}
