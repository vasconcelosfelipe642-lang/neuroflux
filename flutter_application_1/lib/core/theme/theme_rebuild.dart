import 'package:flutter/material.dart';
import 'theme_provider.dart';

/// Reconstrói a subárvore inteira quando o tema muda.
/// Use em telas/scaffolds que ainda ficam com cores antigas após o toggle.
class ThemeRebuild extends StatelessWidget {
  final WidgetBuilder builder;

  const ThemeRebuild({super.key, required this.builder});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: ThemeProvider.instance,
      builder: (context, _) => builder(context),
    );
  }
}
