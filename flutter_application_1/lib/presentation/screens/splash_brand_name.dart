import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/theme_provider.dart';

class SplashBrandName extends StatelessWidget {
  const SplashBrandName({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeProvider.instance.isDark;
    final darkText = isDark ? const Color(0xFFF0F0F5) : const Color(0xFF2D2D3A);

    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: 'Neuro ',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: darkText,
              letterSpacing: -0.5,
            ),
          ),
          const TextSpan(
            text: 'Flux',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: AppColors.primary,
              letterSpacing: -0.5,
            ),
          ),
        ],
      ),
    );
  }
}
