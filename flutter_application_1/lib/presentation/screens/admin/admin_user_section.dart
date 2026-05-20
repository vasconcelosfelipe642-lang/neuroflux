import 'package:flutter/material.dart';

import '../../../core/constants/app_sizes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class AdminUserSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const AdminUserSection({super.key, required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTextStyles.adminUserMeta),
          const SizedBox(height: AppSizes.md),
          if (children.isEmpty)
            Text('Nenhum usuário encontrado.',
                style: AppTextStyles.adminUserMeta)
          else
            ...children,
        ],
      ),
    );
  }
}
