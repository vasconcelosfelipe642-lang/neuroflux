/// Exceção tipada para toda a aplicação.
/// Centraliza o tratamento de erros de API e de rede.
class AppException implements Exception {
  final String message;
  final int? statusCode;

  const AppException({required this.message, this.statusCode});

  factory AppException.fromStatusCode({
    required int statusCode,
    required String message,
  }) {
    return switch (statusCode) {
      401 => AppException(message: 'Sessão expirada. Faça login novamente.', statusCode: statusCode),
      403 => AppException(message: 'Você não tem permissão para isso.', statusCode: statusCode),
      404 => AppException(message: 'Recurso não encontrado.', statusCode: statusCode),
      409 => AppException(message: message, statusCode: statusCode), // email em uso
      _ => AppException(message: message, statusCode: statusCode),
    };
  }

  factory AppException.network() =>
      const AppException(message: 'Sem conexão. Verifique sua internet.');

  bool get isUnauthorized => statusCode == 401;

  @override
  String toString() => 'AppException($statusCode): $message';
}
