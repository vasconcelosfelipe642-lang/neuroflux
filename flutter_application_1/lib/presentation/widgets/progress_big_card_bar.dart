import 'package:flutter/material.dart';

import '../../core/constants/app_sizes.dart';

class ProgressBigCardBar extends StatelessWidget {
  final double progress;

  const ProgressBigCardBar({super.key, required this.progress});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppSizes.radiusFull),
      child: LinearProgressIndicator(
        value: progress,
        minHeight: AppSizes.progressBarHeight,
        backgroundColor: Colors.white30,
        valueColor: const AlwaysStoppedAnimation(Colors.white60),
      ),
    );
  }
}
