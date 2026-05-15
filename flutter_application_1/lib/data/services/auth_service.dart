import 'dart:convert';
import 'dart:io';
import '../../domain/models/user_model.dart';
import '../../core/errors/app_exception.dart';
import 'api_client.dart';

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
      _client.setToken(token);
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
      _client.setToken(token);
      return _decodeUserFromToken(token);
    } on SocketException {
      throw AppException.network();
    }
  }

  void logout() => _client.clearToken();

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
      email: '',  // não vem no JWT — ok para uso inicial
      role: map['role'] as String? ?? 'user',
    );
  }
}
