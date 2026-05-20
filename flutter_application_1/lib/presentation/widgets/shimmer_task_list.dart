import 'package:flutter/material.dart';

import '../../core/constants/app_sizes.dart';
import 'shimmer_task_card.dart';

class ShimmerTaskList extends StatelessWidget {
  const ShimmerTaskList({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        ShimmerTaskCard(),
        SizedBox(height: AppSizes.md),
        ShimmerTaskCard(),
        SizedBox(height: AppSizes.md),
        ShimmerTaskCard(),
      ],
    );
  }
}
