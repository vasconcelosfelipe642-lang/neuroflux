import 'package:flutter/material.dart';

import '../../core/constants/app_strings.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class NeurofluxTagline extends StatelessWidget {
  const NeurofluxTagline({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _dot(),
        const SizedBox(width: 6),
        Text(
          AppStrings.appTagline.toUpperCase(),
          style: AppTextStyles.authTagline,
        ),
        const SizedBox(width: 6),
        _dot(),
      ],
    );
  }

  Widget _dot() => Container(
        width: 4,
        height: 4,
        decoration: const BoxDecoration(
          color: AppColors.primary,
          shape: BoxShape.circle,
        ),
      );
}
