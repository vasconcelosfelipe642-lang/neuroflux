import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/errors/app_exception.dart';
import '../../domain/models/auth_form_model.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/neuroflux_logo.dart';

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
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();

  final _nameFocus = FocusNode();
  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();
  final _confirmFocus = FocusNode();

  bool _isLoading = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmCtrl.dispose();
    _nameFocus.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    _confirmFocus.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    try {
      await widget.onRegister(RegisterFormModel(
        name: _nameCtrl.text.trim(),
        email: _emailCtrl.text.trim(),
        password: _passwordCtrl.text,
        confirmPassword: _confirmCtrl.text,
      ));
    } on AppException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.message),
            backgroundColor: Colors.red.shade700,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(AppStrings.genericError),
            backgroundColor: Colors.red.shade700,
            behavior: SnackBarBehavior.floating,
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
                const SizedBox(height: 32),
                const Center(
                  child: NeuroFluxLogo(size: 72, showTagline: false),
                ),
                const SizedBox(height: 28),
                _SectionHeader(
                  title: AppStrings.registerTitle,
                  subtitle: AppStrings.registerSubtitle,
                ),
                const SizedBox(height: AppSizes.xxl),
                AuthTextField(
                  label: AppStrings.nameLabel,
                  hint: AppStrings.nameHint,
                  controller: _nameCtrl,
                  focusNode: _nameFocus,
                  keyboardType: TextInputType.name,
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'Informe seu nome' : null,
                  onEditingComplete: () => _emailFocus.requestFocus(),
                ),
                const SizedBox(height: AppSizes.lg),
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
                  validator: _validatePassword,
                  onEditingComplete: () => _confirmFocus.requestFocus(),
                ),
                const SizedBox(height: AppSizes.lg),
                AuthTextField(
                  label: AppStrings.confirmPasswordLabel,
                  hint: AppStrings.confirmPasswordHint,
                  controller: _confirmCtrl,
                  focusNode: _confirmFocus,
                  isPassword: true,
                  textInputAction: TextInputAction.done,
                  validator: _validateConfirm,
                  onEditingComplete: _submit,
                ),
                const SizedBox(height: AppSizes.xxl),
                _RegisterButton(isLoading: _isLoading, onPressed: _submit),
                const SizedBox(height: AppSizes.lg),
                _TermsText(),
                const SizedBox(height: AppSizes.xl),
                _LoginPrompt(onTap: widget.onNavigateToLogin),
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

  String? _validateConfirm(String? value) {
    if (value == null || value.isEmpty) return 'Confirme sua senha';
    if (value != _passwordCtrl.text) return 'As senhas não coincidem';
    return null;
  }
}

// ── Subwidgets privados ──────────────────────────────────────

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

class _RegisterButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onPressed;

  const _RegisterButton({required this.isLoading, required this.onPressed});

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
          : Text(AppStrings.registerButton, style: AppTextStyles.fabLabel),
    );
  }
}

class _TermsText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        AppStrings.termsText,
        style: AppTextStyles.authTerms,
        textAlign: TextAlign.center,
      ),
    );
  }
}

class _LoginPrompt extends StatelessWidget {
  final VoidCallback onTap;

  const _LoginPrompt({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: AppStrings.hasAccount,
              style: AppTextStyles.authBodySmall,
            ),
            WidgetSpan(
              child: GestureDetector(
                onTap: onTap,
                child: Text(AppStrings.loginLink, style: AppTextStyles.authLink),
              ),
            ),
          ],
        ),
      ),
    );
  }
}