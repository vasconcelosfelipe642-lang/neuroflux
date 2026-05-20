import 'package:flutter/material.dart';

import '../../domain/models/login_form_model.dart';
import 'login_screen_state.dart';

/// Callback que o backend irá implementar.
/// Recebe o modelo preenchido e retorna Future para tratar loading/erro.
typedef OnLogin = Future<void> Function(LoginFormModel form);

class LoginScreen extends StatefulWidget {
  final OnLogin onLogin;
  final VoidCallback onNavigateToRegister;

  const LoginScreen({
    super.key,
    required this.onLogin,
    required this.onNavigateToRegister,
  });

  @override
  State<LoginScreen> createState() => LoginScreenState();
}
