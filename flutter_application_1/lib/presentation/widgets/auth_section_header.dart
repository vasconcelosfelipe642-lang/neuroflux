import 'package:flutter/material.dart';

import '../../core/theme/app_text_styles.dart';

class AuthSectionHeader extends StatelessWidget {
  final String title;
  final String subtitle;

  const AuthSectionHeader({super.key, required this.title, required this.subtitle});

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
