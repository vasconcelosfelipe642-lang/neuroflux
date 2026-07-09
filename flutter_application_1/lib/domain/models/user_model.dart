import 'package:flutter/material.dart';

abstract final class UserRoles {
  static const common = 'common';
  static const child = 'child';
  static const guardian = 'guardian';
  static const admin = 'admin';

  static const publicSignUpRoles = [common, child, guardian];

  static String normalize(String? role) {
    final value = role?.trim().toLowerCase();
    return switch (value) {
      'user' => common,
      'comum' => common,
      'crianca' => child,
      'responsavel' => guardian,
      'adm' => admin,
      String value when value.isNotEmpty => value,
      _ => common,
    };
  }

  static String labelOf(String role) {
    return switch (normalize(role)) {
      common => 'Comum',
      child => 'Crianca',
      guardian => 'Responsavel',
      admin => 'Administrador',
      _ => 'Comum',
    };
  }
}

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
      email: json['email'] as String? ?? '',
      role: UserRoles.normalize(json['role'] as String?),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'nome': nome,
        'email': email,
        'role': role,
      };

  bool get isAdmin => role == UserRoles.admin;
  String get roleLabel => UserRoles.labelOf(role);

  Color get avatarColor {
    const colors = [
      Color.fromARGB(255, 255, 143, 95),
      Color(0xFF6C63FF),
      Color(0xFF2EC4B6),
      Color(0xFFE71D36),
      Color(0xFF4CAF50),
      Color(0xFF2196F3),
      Color.fromARGB(255, 255, 143, 95),
    ];
    final index = nome.codeUnits.fold(0, (sum, c) => sum + c) % colors.length;
    return colors[index];
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
