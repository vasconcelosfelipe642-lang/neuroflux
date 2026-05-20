import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

class BrainRibbonPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;

    final darkPaint = Paint()
      ..color = const Color(0xFF2D2D3A)
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.045
      ..strokeCap = StrokeCap.round;

    final orangeFill = Paint()
      ..color = AppColors.primary
      ..style = PaintingStyle.fill;

    final rayPaint = Paint()
      ..color = AppColors.primary
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.045
      ..strokeCap = StrokeCap.round;

    final rays = [
      [cx, cy * 0.08, cx, cy * 0.18],
      [cx * 0.28, cy * 0.18, cx * 0.38, cy * 0.26],
      [cx * 1.72, cy * 0.18, cx * 1.62, cy * 0.26],
    ];
    for (final r in rays) {
      canvas.drawLine(Offset(r[0], r[1]), Offset(r[2], r[3]), rayPaint);
    }

    final brainPath = Path();
    final r = size.width * 0.36;
    brainPath.moveTo(cx, cy + r * 0.55);
    brainPath.cubicTo(
      cx - r * 0.1, cy + r * 0.6,
      cx - r * 0.8, cy + r * 0.5,
      cx - r * 0.85, cy,
    );
    brainPath.cubicTo(
      cx - r * 0.9, cy - r * 0.5,
      cx - r * 0.5, cy - r * 0.85,
      cx - r * 0.1, cy - r * 0.75,
    );
    brainPath.lineTo(cx, cy - r * 0.5);
    brainPath.lineTo(cx, cy + r * 0.55);

    brainPath.moveTo(cx, cy - r * 0.5);
    brainPath.cubicTo(
      cx + r * 0.1, cy - r * 0.75,
      cx + r * 0.5, cy - r * 0.85,
      cx + r * 0.85, cy - r * 0.3,
    );
    brainPath.cubicTo(
      cx + r * 0.95, cy + r * 0.1,
      cx + r * 0.8, cy + r * 0.5,
      cx + r * 0.1, cy + r * 0.6,
    );
    brainPath.lineTo(cx, cy + r * 0.55);

    final sulcoPaint = Paint()
      ..color = const Color(0xFF2D2D3A)
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.03
      ..strokeCap = StrokeCap.round;

    canvas.drawPath(brainPath, darkPaint);

    final sulcoL = Path()
      ..moveTo(cx - r * 0.5, cy - r * 0.55)
      ..cubicTo(cx - r * 0.6, cy - r * 0.1, cx - r * 0.4, cy + r * 0.15, cx - r * 0.55, cy + r * 0.4);
    canvas.drawPath(sulcoL, sulcoPaint);

    final sulcoR = Path()
      ..moveTo(cx + r * 0.5, cy - r * 0.45)
      ..cubicTo(cx + r * 0.6, cy - r * 0.1, cx + r * 0.35, cy + r * 0.2, cx + r * 0.5, cy + r * 0.45);
    canvas.drawPath(sulcoR, sulcoPaint);

    final ribTop = cy - r * 0.15;
    final ribMid = cy + r * 0.3;
    final ribBot = cy + r * 0.75;

    final loopL = Path()
      ..moveTo(cx, ribTop)
      ..cubicTo(cx - r * 0.55, ribTop - r * 0.35, cx - r * 0.6, ribMid, cx, ribMid);
    canvas.drawPath(loopL, Paint()
      ..color = AppColors.primary
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.11
      ..strokeCap = StrokeCap.round);

    final loopR = Path()
      ..moveTo(cx, ribTop)
      ..cubicTo(cx + r * 0.55, ribTop - r * 0.35, cx + r * 0.6, ribMid, cx, ribMid);
    canvas.drawPath(loopR, Paint()
      ..color = AppColors.primary
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.11
      ..strokeCap = StrokeCap.round);

    final tailL = Path()
      ..moveTo(cx, ribMid)
      ..cubicTo(cx - r * 0.15, ribMid + r * 0.2, cx - r * 0.3, ribBot - r * 0.1, cx - r * 0.2, ribBot);
    canvas.drawPath(tailL, Paint()
      ..color = AppColors.primary
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.1
      ..strokeCap = StrokeCap.round);

    final tailR = Path()
      ..moveTo(cx, ribMid)
      ..cubicTo(cx + r * 0.15, ribMid + r * 0.2, cx + r * 0.3, ribBot - r * 0.1, cx + r * 0.2, ribBot);
    canvas.drawPath(tailR, Paint()
      ..color = AppColors.primary
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.1
      ..strokeCap = StrokeCap.round);

    canvas.drawCircle(Offset(cx, ribMid), size.width * 0.055, orangeFill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
