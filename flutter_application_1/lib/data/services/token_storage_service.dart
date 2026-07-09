import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/models/user_model.dart';

/// Persiste credenciais em armazenamento seguro e cache local de usuarios banidos.
abstract final class TokenStorageService {
  static const _legacyTokenKey = 'auth_token';
  static const _accessTokenKey = 'access_token';
  static const _refreshTokenKey = 'refresh_token';
  static const _bannedUsersKey = 'banned_users_cache';

  static const _secureStorage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );

  static Future<void> saveAuthTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await Future.wait([
      _secureStorage.write(key: _accessTokenKey, value: accessToken),
      _secureStorage.write(key: _refreshTokenKey, value: refreshToken),
      _secureStorage.delete(key: _legacyTokenKey),
    ]);
  }

  static Future<String?> getAccessToken() async {
    final token = await _secureStorage.read(key: _accessTokenKey);
    return token ?? _secureStorage.read(key: _legacyTokenKey);
  }

  static Future<String?> getRefreshToken() {
    return _secureStorage.read(key: _refreshTokenKey);
  }

  static Future<void> clearAuthTokens() async {
    await Future.wait([
      _secureStorage.delete(key: _accessTokenKey),
      _secureStorage.delete(key: _refreshTokenKey),
      _secureStorage.delete(key: _legacyTokenKey),
    ]);
  }

  static Future<void> saveToken(String token) async {
    await _secureStorage.write(key: _accessTokenKey, value: token);
    await _secureStorage.delete(key: _legacyTokenKey);
  }

  static Future<String?> getToken() => getAccessToken();

  static Future<void> clearToken() => clearAuthTokens();

  static Future<void> addBannedUser(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    final list = await _readBannedList(prefs);
    list.removeWhere((u) => u.id == user.id);
    list.add(user);
    await prefs.setString(
      _bannedUsersKey,
      jsonEncode(list.map((u) => u.toJson()).toList()),
    );
  }

  static Future<List<UserModel>> getBannedUsers() async {
    final prefs = await SharedPreferences.getInstance();
    return _readBannedList(prefs);
  }

  static Future<List<UserModel>> _readBannedList(SharedPreferences prefs) async {
    final raw = prefs.getString(_bannedUsersKey);
    if (raw == null || raw.isEmpty) return [];
    final decoded = jsonDecode(raw) as List<dynamic>;
    return decoded
        .map((e) => UserModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
