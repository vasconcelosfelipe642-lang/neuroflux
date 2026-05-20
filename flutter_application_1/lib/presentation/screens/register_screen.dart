import 'package:flutter/material.dart';

import '../../domain/models/register_form_model.dart';
import 'register_screen_state.dart';

/// Callback que o backend irá implementar.
typedef OnRegister = Future<void> Function(RegisterFormModel form);

class RegisterScreen extends StatefulWidget {
  final OnRegister onRegister;
  final VoidCallback onNavigateToLogin;

  const RegisterScreen({
    super.key,
    required this.onRegister,
    required this.onNavigateToLogin,
  });

  @override
  State<RegisterScreen> createState() => RegisterScreenState();
}
