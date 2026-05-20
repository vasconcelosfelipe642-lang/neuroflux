import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/constants/app_sizes.dart';

class ShimmerTaskCard extends StatefulWidget {
  const ShimmerTaskCard({super.key});

  @override
  State<ShimmerTaskCard> createState() => _ShimmerTaskCardState();
}

class _ShimmerTaskCardState extends State<ShimmerTaskCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: _ShimmerPainter(progress: _controller.value),
          child: child,
        );
      },
      child: Container(
        height: 72,
        decoration: BoxDecoration(
          color: AppColors.border,
          borderRadius: BorderRadius.circular(AppSizes.radiusLg),
          border: Border.all(color: AppColors.border.withValues(alpha: 0.6)),
        ),
        padding: const EdgeInsets.all(AppSizes.md),
        child: Row(
          children: [
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                color: AppColors.surface.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(width: AppSizes.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 12,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.surface.withValues(alpha: 0.4),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(height: AppSizes.sm),
                  Container(
                    height: 10,
                    width: 120,
                    decoration: BoxDecoration(
                      color: AppColors.surface.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ShimmerPainter extends CustomPainter {
  final double progress;

  _ShimmerPainter({required this.progress});

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
  bool shouldRepaint(_ShimmerPainter oldDelegate) =>
      oldDelegate.progress != progress;
}

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
