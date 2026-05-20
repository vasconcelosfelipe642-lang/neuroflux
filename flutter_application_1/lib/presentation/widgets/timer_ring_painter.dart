import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

class TimerRingPainter extends CustomPainter {
  final double progress;

  TimerRingPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 8;

    final track = Paint()
      ..color = AppColors.divider
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10
      ..strokeCap = StrokeCap.round;

    final progressPaint = Paint()
      ..color = AppColors.primary
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, track);

    final sweep = 2 * 3.1415926535 * progress.clamp(0.0, 1.0);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -3.1415926535 / 2,
      sweep,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(TimerRingPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
