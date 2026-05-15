class UserModel {
  final String id;
  final String nome;
  final String email;
  final String role;

  const UserModel({
    required this.id,
    required this.nome,
    required this.email,
    required this.role,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'].toString(),
      nome: json['nome'] as String,
      email: json['email'] as String,
      role: json['role'] as String? ?? 'user',
    );
  }

  /// Iniciais para o avatar (ex: "Maria Silva" → "MS")
  String get initials {
    final parts = nome.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
    }
    return nome.substring(0, parts.first.length >= 2 ? 2 : 1).toUpperCase();
  }

  /// Saudação dinâmica por horário
  String get greeting {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Bom dia,';
    if (hour < 18) return 'Boa tarde,';
    return 'Boa noite,';
  }
}
