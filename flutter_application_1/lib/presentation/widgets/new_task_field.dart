import 'package:flutter/material.dart';

import '../../core/constants/app_sizes.dart';
import '../../core/constants/app_strings.dart';
import '../../core/theme/app_text_styles.dart';

class NewTaskField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;

  const NewTaskField({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(AppStrings.taskFieldLabel, style: AppTextStyles.fieldLabel),
        const SizedBox(height: AppSizes.sm),
        TextField(
          controller: controller,
          focusNode: focusNode,
          onChanged: onChanged,
          textCapitalization: TextCapitalization.sentences,
          decoration: const InputDecoration(hintText: AppStrings.taskFieldHint),
        ),
      ],
    );
  }
}
