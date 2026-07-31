import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../../core/errors/app_exception.dart';

/// Cliente HTTP centralizado.
/// Todas as chamadas passam por aqui: baseUrl, headers, retry de sessao e erros.
class ApiClient {
  ApiClient._();
  static final instance = ApiClient._();

  static const _baseUrl = 'http://localhost:3000';

  String? _token;
  Future<bool>? _refreshFuture;

  Future<bool> Function()? refreshSession;

  void setToken(String token) => _token = token;
  void clearToken() => _token = null;
  bool get isAuthenticated => _token != null;

  Map<String, String> get _headers => {
        HttpHeaders.contentTypeHeader: 'application/json',
        'x-app-client': 'true',
        if (_token != null) HttpHeaders.authorizationHeader: 'Bearer $_token',
      };

  Uri _uri(String path) => Uri.parse('$_baseUrl$path');

  Future<http.Response> _sendWithRefreshRetry(
    Future<http.Response> Function() request,
  ) async {
    final response = await request();

    if (response.statusCode != 401 || refreshSession == null) {
      return response;
    }

    _refreshFuture ??= refreshSession!().whenComplete(() {
      _refreshFuture = null;
    });

    final refreshed = await _refreshFuture!;
    if (!refreshed) return response;

    return request();
  }

  Map<String, dynamic> _decodeMap(http.Response res) {
    final body = utf8.decode(res.bodyBytes);
    if (body.isEmpty) return {};
    return jsonDecode(body) as Map<String, dynamic>;
  }

  Map<String, dynamic> _handleMap(http.Response res) {
    final json = _decodeMap(res);
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
    final json = body.isEmpty
        ? <String, dynamic>{}
        : jsonDecode(body) as Map<String, dynamic>;
    throw AppException.fromStatusCode(
      statusCode: res.statusCode,
      message: json['error'] ?? json['message'] ?? 'Erro desconhecido',
    );
  }

  void _handleEmpty(http.Response res) {
    if (res.statusCode < 200 || res.statusCode >= 300) {
      final body = utf8.decode(res.bodyBytes);
      final json = body.isEmpty
          ? <String, dynamic>{}
          : jsonDecode(body) as Map<String, dynamic>;
      throw AppException.fromStatusCode(
        statusCode: res.statusCode,
        message: json['error'] ?? json['message'] ?? 'Erro desconhecido',
      );
    }
  }

  Future<Map<String, dynamic>> get(String path) async {
    final res = await _sendWithRefreshRetry(
      () => http.get(_uri(path), headers: _headers),
    );
    return _handleMap(res);
  }

  Future<List<dynamic>> getList(String path) async {
    final res = await _sendWithRefreshRetry(
      () => http.get(_uri(path), headers: _headers),
    );
    return _handleList(res);
  }

  Future<Map<String, dynamic>> post(
    String path,
    Map<String, dynamic> body, {
    bool retryOnUnauthorized = true,
  }) async {
    Future<http.Response> request() {
      return http.post(
        _uri(path),
        headers: _headers,
        body: jsonEncode(body),
      );
    }

    final res = retryOnUnauthorized
        ? await _sendWithRefreshRetry(request)
        : await request();
    return _handleMap(res);
  }

  Future<void> postEmpty(
    String path,
    Map<String, dynamic> body, {
    bool retryOnUnauthorized = true,
  }) async {
    Future<http.Response> request() {
      return http.post(
        _uri(path),
        headers: _headers,
        body: jsonEncode(body),
      );
    }

    final res = retryOnUnauthorized
        ? await _sendWithRefreshRetry(request)
        : await request();
    _handleEmpty(res);
  }

  Future<Map<String, dynamic>> put(String path, Map<String, dynamic> body) async {
    final res = await _sendWithRefreshRetry(
      () => http.put(_uri(path), headers: _headers, body: jsonEncode(body)),
    );
    return _handleMap(res);
  }

  Future<void> delete(String path) async {
    final res = await _sendWithRefreshRetry(
      () => http.delete(_uri(path), headers: _headers),
    );
    _handleEmpty(res);
  }
}
