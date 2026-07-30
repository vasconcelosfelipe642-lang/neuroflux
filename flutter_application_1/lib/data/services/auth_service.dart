import 'dart:convert';
import 'dart:io';

import '../../core/errors/app_exception.dart';
import '../../domain/models/user_model.dart';
import 'api_client.dart';
import 'token_storage_service.dart';

/// Responsavel por login, cadastro, restauracao e renovacao de sessao.
class AuthService {
  AuthService._() {
    _client.refreshSession = refreshAccessToken;
  }

  static final instance = AuthService._();

  final _client = ApiClient.instance;
  UserModel? _currentUser;

  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final json = await _client.post(
        '/login',
        {
          'email': email,
          'senha': password,
        },
        retryOnUnauthorized: false,
      );
      return _persistAuthResponse(json);
    } on SocketException {
      throw AppException.network();
    }
  }

  Future<UserModel> register({
    required String nome,
    required String email,
    required String password,
    required String role,
  }) async {
    try {
      final json = await _client.post(
        '/register',
        {
          'nome': nome,
          'email': email,
          'senha': password,
          'role': role,
        },
        retryOnUnauthorized: false,
      );
      return _persistAuthResponse(json);
    } on SocketException {
      throw AppException.network();
    }
  }

  Future<void> logout() async {
    final refreshToken = await TokenStorageService.getRefreshToken();

    try {
      if (refreshToken != null) {
        await _client.postEmpty(
          '/logout',
          {'refreshToken': refreshToken},
          retryOnUnauthorized: false,
        );
      }
    } catch (_) {
      // Logout local continua mesmo que a API esteja indisponivel.
    } finally {
      await _clearLocalSession();
    }
  }

  Future<UserModel?> restoreSession() async {
    final accessToken = await TokenStorageService.getAccessToken();
    final refreshToken = await TokenStorageService.getRefreshToken();

    if (accessToken != null && !_isTokenExpired(accessToken)) {
      _client.setToken(accessToken);
      _currentUser = _decodeUserFromToken(accessToken);
      return _currentUser;
    }

    if (refreshToken == null) {
      await _clearLocalSession();
      return null;
    }

    final refreshed = await refreshAccessToken();
    return refreshed ? _currentUser : null;
  }

  Future<bool> refreshAccessToken() async {
    final refreshToken = await TokenStorageService.getRefreshToken();
    if (refreshToken == null) return false;

    try {
      final json = await _client.post(
        '/refresh-token',
        {'refreshToken': refreshToken},
        retryOnUnauthorized: false,
      );
      _currentUser = await _persistAuthResponse(json);
      return true;
    } catch (_) {
      await _clearLocalSession();
      return false;
    }
  }

  Future<UserModel> _persistAuthResponse(Map<String, dynamic> json) async {
    final accessToken = json['accessToken'] as String?;
    final refreshToken = json['refreshToken'] as String?;

    if (accessToken == null || refreshToken == null) {
      throw const AppException(message: 'Resposta de autenticacao invalida');
    }

    await TokenStorageService.saveAuthTokens(
      accessToken: accessToken,
      refreshToken: refreshToken,
    );
    _client.setToken(accessToken);

    final userJson = json['user'];
    final user = userJson is Map<String, dynamic>
        ? UserModel.fromJson(userJson)
        : _decodeUserFromToken(accessToken);

    _currentUser = user;
    return user;
  }

  Future<void> _clearLocalSession() async {
    _currentUser = null;
    _client.clearToken();
    await TokenStorageService.clearAuthTokens();
  }

  bool _isTokenExpired(String token) {
    try {
      final payload = _decodeJwtPayload(token);
      final exp = payload['exp'];
      if (exp is! int) return true;

      final expiresAt = DateTime.fromMillisecondsSinceEpoch(exp * 1000);
      return DateTime.now().isAfter(expiresAt);
    } catch (_) {
      return true;
    }
  }

  Map<String, dynamic> _decodeJwtPayload(String token) {
    final parts = token.split('.');
    if (parts.length != 3) {
      throw const AppException(message: 'Token invalido');
    }

    final normalized = base64Url.normalize(parts[1]);
    final decoded = utf8.decode(base64Url.decode(normalized));
    return jsonDecode(decoded) as Map<String, dynamic>;
  }

  UserModel _decodeUserFromToken(String token) {
    final map = _decodeJwtPayload(token);

    return UserModel(
      id: map['id'].toString(),
      nome: map['nome'] as String? ?? '',
      email: map['email'] as String? ?? '',
      role: UserRoles.normalize(map['role'] as String?),
    );
  }
}
