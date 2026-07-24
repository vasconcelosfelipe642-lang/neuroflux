import 'package:flutter/material.dart';

import '../../core/constants/app_sizes.dart';
import '../../core/constants/app_strings.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/theme_scope.dart';
import '../../domain/models/login_form_model.dart';
import '../widgets/auth_section_header.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/font_scale_button.dart';
import '../widgets/login_button.dart';
import '../widgets/neuroflux_logo.dart';
import '../widgets/sign_up_prompt.dart';
import '../widgets/theme_toggle_button.dart';
import 'login_screen.dart';

class LoginScreenState extends State<LoginScreen> {
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Usuário ou senha são inválidos'),
            backgroundColor: Colors.red.shade700,
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(AppSizes.lg),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSizes.radiusMd)),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _showForgotPasswordDialog() async {
    final recoverEmailCtrl = TextEditingController();
    final recoverFormKey = GlobalKey<FormState>();

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: AppColors.surface,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSizes.radiusLg)),
          titlePadding: const EdgeInsets.fromLTRB(
              AppSizes.xl, AppSizes.xl, AppSizes.xl, AppSizes.sm),
          contentPadding: const EdgeInsets.fromLTRB(
              AppSizes.xl, 0, AppSizes.xl, AppSizes.xl),
          title: Text(AppStrings.forgotPasswordTitle,
              style: AppTextStyles.modalTitle),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(AppStrings.forgotPasswordSubtitle,
                  style: AppTextStyles.authSubtitle),
              const SizedBox(height: AppSizes.lg),
              Form(
                key: recoverFormKey,
                child: TextFormField(
                  controller: recoverEmailCtrl,
                  keyboardType: TextInputType.emailAddress,
                  validator: _validateEmail,
                  decoration: InputDecoration(
                    hintText: AppStrings.emailHint,
                    filled: true,
                    fillColor: AppColors.inputFill,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                      borderSide: BorderSide(color: AppColors.border),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                      borderSide: BorderSide(color: AppColors.border),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                      borderSide: BorderSide(color: AppColors.primary),
                    ),
                  ),
                ),
              ),
            ],
          ),
          actionsPadding: const EdgeInsets.fromLTRB(
              AppSizes.lg, 0, AppSizes.lg, AppSizes.lg),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: Text(
                AppStrings.forgotPasswordCancel,
                style: TextStyle(color: AppColors.textSecondary),
              ),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.lg, vertical: AppSizes.sm),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSizes.radiusMd)),
              ),
              onPressed: () {
                if (!(recoverFormKey.currentState?.validate() ?? false)) return;
                Navigator.of(dialogContext).pop(true);
              },
              child: Text(AppStrings.forgotPasswordButton),
            ),
          ],
        );
      },
    );

    recoverEmailCtrl.dispose();

    if (confirmed == true && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(AppStrings.forgotPasswordSuccess),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(AppSizes.lg),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSizes.radiusMd)),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeScope.watch(context);

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
                const SizedBox(height: 24),
                Align(
                  alignment: Alignment.centerRight,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: const [
                      FontScaleButton(),
                      ThemeToggleButton(),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                const Center(child: NeuroFluxLogo(size: 90)),
                const SizedBox(height: 40),
                AuthSectionHeader(
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
                const SizedBox(height: AppSizes.xl),
                LoginButton(isLoading: _isLoading, onPressed: _submit),
                const SizedBox(height: AppSizes.xl),
                SignUpPrompt(onTap: widget.onNavigateToRegister),
                const SizedBox(height: AppSizes.sm),
                Center(
                  child: TextButton(
                    onPressed: _showForgotPasswordDialog,
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        vertical: AppSizes.xs,
                        horizontal: AppSizes.sm,
                      ),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      AppStrings.forgotPasswordLink,
                      style: AppTextStyles.authBodySmall.copyWith(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
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
