import 'package:flutter/material.dart';

import '../../core/constants/app_sizes.dart';
import '../../core/constants/app_strings.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class NewSubtaskField extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onAdd;

  const NewSubtaskField({super.key, required this.controller, required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(AppStrings.subtaskFieldLabel, style: AppTextStyles.fieldLabel),
        const SizedBox(height: AppSizes.sm),
        TextField(
          controller: controller,
          textCapitalization: TextCapitalization.sentences,
          decoration: InputDecoration(
            hintText: AppStrings.subtaskFieldHint,
            suffixIcon: IconButton(
              onPressed: onAdd,
              icon: const Icon(Icons.add_circle_outline, color: AppColors.primary),
            ),
          ),
          onSubmitted: (_) => onAdd(),
        ),
      ],
    );
  }
}
