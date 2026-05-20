import 'package:flutter/material.dart';

import 'neuroflux_logo_icon.dart';
import 'neuroflux_logo_name.dart';
import 'neuroflux_tagline.dart';

/// Logo completa do NeuroFlux.
/// [size] controla a escala geral do ícone.
/// [showTagline] exibe a tagline abaixo do nome.
class NeuroFluxLogo extends StatelessWidget {
  final double size;
  final bool showName;
  final bool showTagline;

  const NeuroFluxLogo({
    super.key,
    this.size = 80,
    this.showName = true,
    this.showTagline = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        NeurofluxLogoIcon(size: size),
        if (showName) ...[
          const SizedBox(height: 16),
          const NeurofluxLogoName(),
        ],
        if (showTagline) ...[
          const SizedBox(height: 6),
          const NeurofluxTagline(),
        ],
      ],
    );
  }
}
