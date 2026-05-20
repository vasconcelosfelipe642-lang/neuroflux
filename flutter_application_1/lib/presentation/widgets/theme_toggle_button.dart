import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/theme_provider.dart';

/// Alternância de tema claro/escuro (sol/lua animado).
class ThemeToggleButton extends StatelessWidget {
  const ThemeToggleButton({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = ThemeProvider.instance;

    return ListenableBuilder(
      listenable: themeProvider,
      builder: (context, _) {
        final isDark = themeProvider.isDark;
        return IconButton(
          onPressed: themeProvider.toggle,
          tooltip: isDark ? 'Tema claro' : 'Tema escuro',
          icon: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (child, animation) {
              return RotationTransition(
                turns: Tween<double>(begin: 0.75, end: 1).animate(animation),
                child: FadeTransition(opacity: animation, child: child),
              );
            },
            child: Icon(
              isDark ? Icons.wb_sunny_outlined : Icons.nightlight_round,
              key: ValueKey(isDark),
              color: AppColors.primary,
            ),
          ),
        );
      },
    );
  }
}
