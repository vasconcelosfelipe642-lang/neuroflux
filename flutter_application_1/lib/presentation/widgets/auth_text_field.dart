import 'package:flutter/material.dart';

import 'auth_text_field_state.dart';

/// Campo de texto padronizado para as telas de autenticação.
/// Reutilizável em Login e Cadastro.
class AuthTextField extends StatefulWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final bool isPassword;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final String? Function(String?)? validator;
  final FocusNode? focusNode;
  final VoidCallback? onEditingComplete;

  const AuthTextField({
    super.key,
    required this.label,
    required this.hint,
    required this.controller,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.validator,
    this.focusNode,
    this.onEditingComplete,
  });

  @override
  State<AuthTextField> createState() => AuthTextFieldState();
}
