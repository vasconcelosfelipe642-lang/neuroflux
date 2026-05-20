import 'package:flutter/material.dart';

import '../../core/constants/app_sizes.dart';

class GradientProgressBar extends StatelessWidget {
  final double progress;

  const GradientProgressBar({super.key, required this.progress});

  static const _trackColor = Color(0x4DFFFFFF);
  static const _gradientStart = Color(0xFFFFB347);
  static const _gradientEnd = Colors.white;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(end: progress),
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOutCubic,
      builder: (context, value, _) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(AppSizes.radiusFull),
          child: SizedBox(
            height: AppSizes.progressBarHeight,
            child: Stack(
              fit: StackFit.expand,
              children: [
                const ColoredBox(color: _trackColor),
                FractionallySizedBox(
                  widthFactor: value.clamp(0.0, 1.0),
                  alignment: Alignment.centerLeft,
                  child: ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      colors: [_gradientStart, _gradientEnd],
                    ).createShader(bounds),
                    child: const ColoredBox(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
