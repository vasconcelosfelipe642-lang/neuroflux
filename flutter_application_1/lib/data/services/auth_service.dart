import 'dart:convert';
import 'dart:io';
import '../../domain/models/user_model.dart';
import '../../core/errors/app_exception.dart';
import 'api_client.dart';
import 'token_storage_service.dart';

/// Responsável por login e cadastro.
/// Após autenticação, injeta o token no ApiClient automaticamente.
class AuthService {
  AuthService._();
  static final instance = AuthService._();

  final _client = ApiClient.instance;

  /// POST /login → { email, senha } → salva accessToken e retorna UserModel
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final json = await _client.post('/login', {
        'email': email,
        'senha': password,
      });
      // Backend retorna { message, accessToken, expiresIn }
      final token = json['accessToken'] as String;
      await _persistToken(token);
      return _decodeUserFromToken(token);
    } on SocketException {
      throw AppException.network();
    }
  }

  /// POST /register → { nome, email, senha } → salva token e retorna UserModel
  Future<UserModel> register({
    required String nome,
    required String email,
    required String password,
  }) async {
    try {
      final json = await _client.post('/register', {
        'nome': nome,
        'email': email,
        'senha': password,
      });

      // Backend retorna { message, token }
      final token = json['token'] as String;
      await _persistToken(token);
      return _decodeUserFromToken(token);
    } on SocketException {
      throw AppException.network();
    }
  }

  /// POST /usuarios/forgot-password → { email } → dispara e-mail com código
  Future<void> forgotPassword({required String email}) async {
    try {
      await _client.post('/usuarios/forgot-password', {
        'email': email,
      });
    } on SocketException {
      throw AppException.network();
    }
  }

  /// POST /usuarios/reset-password → { email, token, novaSenha }
  Future<void> resetPassword({
    required String email,
    required String token,
    required String novaSenha,
  }) async {
    try {
      await _client.post('/usuarios/reset-password', {
        'email': email,
        'token': token,
        'novaSenha': novaSenha,
      });
    } on SocketException {
      throw AppException.network();
    }
  }

  Future<void> logout() async {
    _client.clearToken();
    await TokenStorageService.clearToken();
  }

  /// Restaura sessão salva (token em disco). Retorna null se não houver sessão.
  Future<UserModel?> restoreSession() async {
    final token = await TokenStorageService.getToken();
    if (token == null) return null;
    _client.setToken(token);
    try {
      return _decodeUserFromToken(token);
    } catch (_) {
      await logout();
      return null;
    }
  }

  Future<void> _persistToken(String token) async {
    _client.setToken(token);
    await TokenStorageService.saveToken(token);
  }

  /// Decodifica o payload do JWT localmente para obter id, nome e role.
  /// Payload: { id, nome, role, iat, exp }
  UserModel _decodeUserFromToken(String token) {
    final parts = token.split('.');
    if (parts.length != 3) {
      throw const AppException(message: 'Token inválido');
    }
    final normalized = base64Url.normalize(parts[1]);
    final decoded = utf8.decode(base64Url.decode(normalized));
    final map = jsonDecode(decoded) as Map<String, dynamic>;

    return UserModel(
      id: map['id'].toString(),
      nome: map['nome'] as String? ?? '',
      email: '', // não vem no JWT — ok para uso inicial
      role: map['role'] as String? ?? 'user',
    );
  }
}
