import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _realizarCadastro() {
    if (_formKey.currentState!.validate()) {
      // Implemente a chamada para a sua API/Backend aqui
      debugPrint('Cadastro - Nome: ${_nameController.text}');
      debugPrint('Cadastro - E-mail: ${_emailController.text}');
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
                    Icons.person_add_rounded,
                    size: 64,
                    color: AppColors.primary,
                  ),
                  const SizedBox(height: 24),

                  // --- Títulos ---
                  const Text(
                    'Criar Conta',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.statNumber,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Preencha os dados abaixo para começar',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.greetingSmall,
                  ),
                  const SizedBox(height: 48),

                  // --- Campo de Nome ---
                  const Text('Nome', style: AppTextStyles.fieldLabel),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _nameController,
                    keyboardType: TextInputType.name,
                    style: const TextStyle(color: AppColors.textPrimary),
                    decoration: const InputDecoration(
                      hintText: 'Digite seu nome completo',
                      prefixIcon: Icon(Icons.person_outline, color: AppColors.textHint),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) return 'Insira seu nome.';
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),

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
                      hintText: 'Crie uma senha',
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
                      if (value == null || value.isEmpty) return 'Insira uma senha.';
                      if (value.length < 6) return 'A senha deve ter no mínimo 6 caracteres.';
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),

                  // --- Campo de Confirmar Senha ---
                  const Text('Confirmar Senha', style: AppTextStyles.fieldLabel),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _confirmPasswordController,
                    obscureText: !_isConfirmPasswordVisible,
                    style: const TextStyle(color: AppColors.textPrimary),
                    decoration: InputDecoration(
                      hintText: 'Repita sua senha',
                      prefixIcon: const Icon(Icons.lock_outline, color: AppColors.textHint),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isConfirmPasswordVisible ? Icons.visibility_off : Icons.visibility,
                          color: AppColors.textHint,
                        ),
                        onPressed: () {
                          setState(() {
                            _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                          });
                        },
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Confirme sua senha.';
                      // Validação crucial para tela de cadastro:
                      if (value != _passwordController.text) return 'As senhas não coincidem.';
                      return null;
                    },
                  ),
                  const SizedBox(height: 40),

                  // --- Botão Cadastrar ---
                  ElevatedButton(
                    onPressed: _realizarCadastro,
                    child: const Text(
                      'Cadastrar',
                      style: AppTextStyles.fabLabel,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // --- Botão de Voltar para Login ---
                  TextButton(
                    onPressed: () {
                    
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.textSecondary,
                    ),
                    child: const Text('Já tem uma conta? Faça login'),
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