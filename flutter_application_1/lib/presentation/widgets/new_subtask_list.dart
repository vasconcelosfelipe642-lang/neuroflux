import 'package:flutter/material.dart';

import '../../core/constants/app_sizes.dart';
import '../../core/theme/app_colors.dart';

class NewSubtaskList extends StatelessWidget {
  final List<String> titles;
  final ValueChanged<int> onRemove;

  const NewSubtaskList({super.key, required this.titles, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: titles.asMap().entries.map((entry) {
        return Padding(
          padding: const EdgeInsets.only(bottom: AppSizes.xs),
          child: Row(
            children: [
              Icon(Icons.drag_handle, size: 16, color: AppColors.textHint),
              const SizedBox(width: AppSizes.sm),
              Expanded(
                child: Text(
                  entry.value,
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => onRemove(entry.key),
                child: Icon(Icons.close, size: 16, color: AppColors.textHint),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
