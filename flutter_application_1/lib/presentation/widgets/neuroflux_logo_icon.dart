import 'package:flutter/material.dart';

import 'brain_ribbon_painter.dart';

class NeurofluxLogoIcon extends StatelessWidget {
  final double size;

  const NeurofluxLogoIcon({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(painter: BrainRibbonPainter()),
    );
  }
}
