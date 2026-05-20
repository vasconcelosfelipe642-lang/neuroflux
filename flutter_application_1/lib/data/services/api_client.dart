import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../../core/errors/app_exception.dart';

/// Cliente HTTP centralizado.
/// Todas as chamadas passam por aqui — único lugar para trocar
/// baseUrl, adicionar headers globais e tratar erros de rede.
class ApiClient {
  ApiClient._();
  static final instance = ApiClient._();

  // Troque pela URL de produção via .env quando for ao ar
  static const _baseUrl = 'http://localhost:3000';

  String? _token;

  void setToken(String token) => _token = token;
  void clearToken() => _token = null;
  bool get isAuthenticated => _token != null;

  // ── Headers ───────────────────────────────────────────────

  Map<String, String> get _headers => {
        HttpHeaders.contentTypeHeader: 'application/json',
        if (_token != null)
          HttpHeaders.authorizationHeader: 'Bearer $_token',
      };

  Uri _uri(String path) => Uri.parse('$_baseUrl$path');

  // ── Response handlers ─────────────────────────────────────

  Map<String, dynamic> _handleMap(http.Response res) {
    final body = utf8.decode(res.bodyBytes);
    final json = jsonDecode(body) as Map<String, dynamic>;
    if (res.statusCode >= 200 && res.statusCode < 300) return json;
    throw AppException.fromStatusCode(
      statusCode: res.statusCode,
      message: json['error'] ?? json['message'] ?? 'Erro desconhecido',
    );
  }

  List<dynamic> _handleList(http.Response res) {
    final body = utf8.decode(res.bodyBytes);
    if (res.statusCode >= 200 && res.statusCode < 300) {
      return jsonDecode(body) as List<dynamic>;
    }
    final json = jsonDecode(body) as Map<String, dynamic>;
    throw AppException.fromStatusCode(
      statusCode: res.statusCode,
      message: json['error'] ?? json['message'] ?? 'Erro desconhecido',
    );
  }

  void _handleEmpty(http.Response res) {
    if (res.statusCode < 200 || res.statusCode >= 300) {
      final json =
          jsonDecode(utf8.decode(res.bodyBytes)) as Map<String, dynamic>;
      throw AppException.fromStatusCode(
        statusCode: res.statusCode,
        message: json['error'] ?? json['message'] ?? 'Erro desconhecido',
      );
    }
  }

  // ── Métodos HTTP ──────────────────────────────────────────

  Future<Map<String, dynamic>> get(String path) async {
    final res = await http.get(_uri(path), headers: _headers);
    return _handleMap(res);
  }

  Future<List<dynamic>> getList(String path) async {
    final res = await http.get(_uri(path), headers: _headers);
    return _handleList(res);
  }

  Future<Map<String, dynamic>> post(String path, Map<String, dynamic> body) async {
    final res = await http.post(_uri(path), headers: _headers, body: jsonEncode(body));
    return _handleMap(res);
  }

  Future<Map<String, dynamic>> put(String path, Map<String, dynamic> body) async {
    final res = await http.put(_uri(path), headers: _headers, body: jsonEncode(body));
    return _handleMap(res);
  }

  Future<void> delete(String path) async {
    final res = await http.delete(_uri(path), headers: _headers);
    _handleEmpty(res);
  }
}
