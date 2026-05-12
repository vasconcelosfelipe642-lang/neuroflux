import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _realizarLogin() {
    if (_formKey.currentState!.validate()) {
      debugPrint('Login: ${_emailController.text}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // --- Ícone ou Logo ---
                  const Icon(
                    Icons.lock_person_rounded,
                    size: 64,
                    color: AppColors.primary,
                  ),
                  const SizedBox(height: 24),

                  // --- Títulos ---
                  const Text(
                    'Bem-vindo!',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.statNumber, 
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Faça login para continuar',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.greetingSmall, 
                  ),
                  const SizedBox(height: 48),

                  // --- Campo de E-mail ---
                  const Text('E-mail', style: AppTextStyles.fieldLabel),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    style: const TextStyle(color: AppColors.textPrimary),
                    
                    decoration: const InputDecoration(
                      hintText: 'Digite seu e-mail',
                      prefixIcon: Icon(Icons.email_outlined, color: AppColors.textHint),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Insira seu e-mail.';
                      if (!value.contains('@')) return 'E-mail inválido.';
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),

                  // --- Campo de Senha ---
                  const Text('Senha', style: AppTextStyles.fieldLabel),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: !_isPasswordVisible,
                    style: const TextStyle(color: AppColors.textPrimary),
                    decoration: InputDecoration(
                      hintText: 'Digite sua senha',
                      prefixIcon: const Icon(Icons.lock_outline, color: AppColors.textHint),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
                          color: AppColors.textHint,
                        ),
                        onPressed: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Insira sua senha.';
                      if (value.length < 6) return 'A senha deve ter no mínimo 6 caracteres.';
                      return null;
                    },
                  ),
                  const SizedBox(height: 40),

                  // --- Botão Entrar ---
                  
                  ElevatedButton(
                    onPressed: _realizarLogin,
                    child: const Text(
                      'Entrar',
                      style: AppTextStyles.fabLabel, 
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}