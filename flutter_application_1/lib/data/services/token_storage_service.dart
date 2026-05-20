import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/models/user_model.dart';

/// Persiste o JWT em armazenamento seguro e o cache local de usuários banidos.
abstract final class TokenStorageService {
  static const _tokenKey = 'auth_token';
  static const _bannedUsersKey = 'banned_users_cache';

  static const _secureStorage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );

  static Future<void> saveToken(String token) async {
    await _secureStorage.write(key: _tokenKey, value: token);
  }

  static Future<String?> getToken() async {
    return _secureStorage.read(key: _tokenKey);
  }

  static Future<void> clearToken() async {
    await _secureStorage.delete(key: _tokenKey);
  }

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
