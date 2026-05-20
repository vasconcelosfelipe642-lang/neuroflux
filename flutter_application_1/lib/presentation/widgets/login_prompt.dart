import 'package:flutter/material.dart';

import '../../core/constants/app_strings.dart';
import '../../core/theme/app_text_styles.dart';

class LoginPrompt extends StatelessWidget {
  final VoidCallback onTap;

  const LoginPrompt({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Wrap(
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Text(AppStrings.hasAccount, style: AppTextStyles.authBodySmall),
          TextButton(
            onPressed: onTap,
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(AppStrings.loginLink, style: AppTextStyles.authLink),
          ),
        ],
      ),
    );
  }
}
