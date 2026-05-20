import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

class NeurofluxLogoName extends StatelessWidget {
  const NeurofluxLogoName({super.key});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: const TextSpan(
        children: [
          TextSpan(
            text: 'Neuro ',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: Color(0xFF2D2D3A),
              letterSpacing: -0.5,
            ),
          ),
          TextSpan(
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
