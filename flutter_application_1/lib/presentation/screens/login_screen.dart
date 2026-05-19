import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/app_sizes.dart';
import '../../domain/models/auth_form_model.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/neuroflux_logo.dart';

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
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();

  bool _isLoading = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    try {
      await widget.onLogin(LoginFormModel(
        email: _emailCtrl.text.trim(),
        password: _passwordCtrl.text,
      ));
    } catch (e) {
      if (mounted) {
        // Exibe a mensagem personalizada para erro de credenciais
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Usuário ou senha são inválidos'),
            backgroundColor: Colors.red.shade700,
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(AppSizes.lg),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSizes.radiusMd)),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: AppSizes.xl),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 48),
                const Center(child: NeuroFluxLogo(size: 90)),
                const SizedBox(height: 40),
                _SectionHeader(
                  title: AppStrings.loginTitle,
                  subtitle: AppStrings.loginSubtitle,
                ),
                const SizedBox(height: AppSizes.xxl),
                AuthTextField(
                  label: AppStrings.emailLabel,
                  hint: AppStrings.emailHint,
                  controller: _emailCtrl,
                  focusNode: _emailFocus,
                  keyboardType: TextInputType.emailAddress,
                  validator: _validateEmail,
                  onEditingComplete: () => _passwordFocus.requestFocus(),
                ),
                const SizedBox(height: AppSizes.lg),
                AuthTextField(
                  label: AppStrings.passwordLabel,
                  hint: AppStrings.passwordHint,
                  controller: _passwordCtrl,
                  focusNode: _passwordFocus,
                  isPassword: true,
                  textInputAction: TextInputAction.done,
                  validator: _validatePassword,
                  onEditingComplete: _submit,
                ),
                const SizedBox(height: AppSizes.xxl),
                _LoginButton(isLoading: _isLoading, onPressed: _submit),
                const SizedBox(height: AppSizes.xl),
                _SignUpPrompt(onTap: widget.onNavigateToRegister),
                const SizedBox(height: AppSizes.xxl),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) return 'Informe o e-mail';
    if (!value.contains('@')) return 'E-mail inválido';
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Informe a senha';
    if (value.length < 6) return 'Mínimo 6 caracteres';
    return null;
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final String subtitle;

  const _SectionHeader({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppTextStyles.authTitle),
        const SizedBox(height: 6),
        Text(subtitle, style: AppTextStyles.authSubtitle),
      ],
    );
  }
}

class _LoginButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onPressed;

  const _LoginButton({required this.isLoading, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      child: isLoading
          ? const SizedBox(
              height: 22,
              width: 22,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                color: Colors.white,
              ),
            )
          : Text(AppStrings.loginButton, style: AppTextStyles.fabLabel),
    );
  }
}

class _SignUpPrompt extends StatelessWidget {
  final VoidCallback onTap;

  const _SignUpPrompt({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: AppStrings.noAccount,
              style: AppTextStyles.authBodySmall,
            ),
            WidgetSpan(
              child: GestureDetector(
                onTap: onTap,
                child: const Text(AppStrings.signUpLink, style: AppTextStyles.authLink),
              ),
            ),
          ],
        ),
      ),
    );
  }
}