import 'package:flutter/material.dart';

import '../../core/constants/app_sizes.dart';
import '../../core/theme/app_colors.dart';

class ShimmerPainter extends CustomPainter {
  final double progress;

  ShimmerPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final base = AppColors.border;
    final highlight = AppColors.surface;

    final gradient = LinearGradient(
      begin: Alignment(-1.5 + progress * 3, 0),
      end: Alignment(-0.5 + progress * 3, 0),
      colors: [
        base,
        highlight.withValues(alpha: 0.85),
        base,
      ],
      stops: const [0.25, 0.5, 0.75],
    );

    final paint = Paint()
      ..shader = gradient.createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final rrect = RRect.fromRectAndRadius(
      Offset.zero & size,
      const Radius.circular(AppSizes.radiusLg),
    );
    canvas.drawRRect(rrect, paint);
  }

  @override
  bool shouldRepaint(ShimmerPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
