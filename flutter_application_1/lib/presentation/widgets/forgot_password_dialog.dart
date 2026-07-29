import 'package:flutter/material.dart';
import '../../data/services/auth_service.dart';
import '../../core/errors/app_exception.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/constants/app_strings.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class ForgotPasswordDialog extends StatefulWidget {
  final String? Function(String?) validator;

  const ForgotPasswordDialog({
    super.key,
    required this.validator,
  });

  static Future<bool?> show(
    BuildContext context, {
    required String? Function(String?) validator,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (_) => ForgotPasswordDialog(validator: validator),
    );
  }

  @override
  State<ForgotPasswordDialog> createState() => _ForgotPasswordDialogState();
}

class _ForgotPasswordDialogState extends State<ForgotPasswordDialog> {
  late final TextEditingController _recoverEmailCtrl;
  late final GlobalKey<FormState> _recoverFormKey;

  @override
  void initState() {
    super.initState();
    _recoverEmailCtrl = TextEditingController();
    _recoverFormKey = GlobalKey<FormState>();
  }

  @override
  void dispose() {
    _recoverEmailCtrl.dispose();
    super.dispose();
  }

  void _handleCancel() {
    FocusScope.of(context).unfocus();
    Navigator.of(context).pop(false);
  }

  bool _isLoading = false;

  Future<void> _handleConfirm() async {
    if (!(_recoverFormKey.currentState?.validate() ?? false)) return;

    setState(() => _isLoading = true);
    try {
      await AuthService.instance.forgotPassword(
        email: _recoverEmailCtrl.text.trim(),
      );
      if (!mounted) return;
      FocusScope.of(context).unfocus();
      Navigator.of(context).pop(true);
    } on AppException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message),
          backgroundColor: Colors.red.shade700,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
      ),
      titlePadding: const EdgeInsets.fromLTRB(
        AppSizes.xl,
        AppSizes.xl,
        AppSizes.xl,
        AppSizes.sm,
      ),
      contentPadding: const EdgeInsets.fromLTRB(
        AppSizes.xl,
        0,
        AppSizes.xl,
        AppSizes.xl,
      ),
      title: Text(
        AppStrings.forgotPasswordTitle,
        style: AppTextStyles.modalTitle,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.forgotPasswordSubtitle,
            style: AppTextStyles.authSubtitle,
          ),
          const SizedBox(height: AppSizes.lg),
          Form(
            key: _recoverFormKey,
            child: TextFormField(
              controller: _recoverEmailCtrl,
              keyboardType: TextInputType.emailAddress,
              validator: widget.validator,
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
        AppSizes.lg,
        0,
        AppSizes.lg,
        AppSizes.lg,
      ),
      actions: [
        TextButton(
          onPressed: _handleCancel,
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
              horizontal: AppSizes.lg,
              vertical: AppSizes.sm,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSizes.radiusMd),
            ),
          ),
          onPressed: _handleConfirm,
          child: Text(AppStrings.forgotPasswordButton),
        ),
      ],
    );
  }
}
