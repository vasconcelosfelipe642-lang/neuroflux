import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../core/constants/app_sizes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import 'onboarding_page_data.dart';

class OnboardingPage extends StatelessWidget {
  final OnboardingPageData data;
  final int pageIndex;

  const OnboardingPage({
    super.key,
    required this.data,
    required this.pageIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.xxl),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(data.icon, size: 80, color: AppColors.primary),
          const SizedBox(height: AppSizes.xxl),
          Text(
            data.title,
            textAlign: TextAlign.center,
            style: AppTextStyles.authTitle.copyWith(fontSize: 26),
          ),
          const SizedBox(height: AppSizes.md),
          Text(
            data.subtitle,
            textAlign: TextAlign.center,
            style: AppTextStyles.authSubtitle.copyWith(height: 1.5),
          ),
        ],
      ),
    )
        .animate(key: ValueKey(pageIndex))
        .fadeIn(duration: 400.ms, curve: Curves.easeOut)
        .slideY(begin: 0.06, end: 0, duration: 400.ms, curve: Curves.easeOutCubic);
  }
}
