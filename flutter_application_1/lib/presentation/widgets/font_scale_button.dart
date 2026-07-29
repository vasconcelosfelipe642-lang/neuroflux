import 'package:flutter/material.dart';

import '../../core/constants/app_sizes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/theme_provider.dart';

/// Abre um bottom sheet para ajustar a fonte com preview em tempo real.
class FontScaleButton extends StatelessWidget {
  const FontScaleButton({super.key});

  Future<void> _showFontSheet(BuildContext context) async {
    final themeProvider = ThemeProvider.instance;

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(AppSizes.radiusXl),
                ),
              ),
              padding: const EdgeInsets.fromLTRB(
                AppSizes.xl,
                AppSizes.lg,
                AppSizes.xl,
                AppSizes.xl,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 44,
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppColors.border,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSizes.lg),
                  Text(
                    'Que tal deixar tudo mais confortável?',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                  ),
                  const SizedBox(height: AppSizes.sm),
                  Text(
                    'Use os botões abaixo e veja o tamanho da fonte mudar em tempo real.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                  ),
                  const SizedBox(height: AppSizes.xl),
                  Row(
                    children: [
                      Semantics(
                        button: true,
                        label: 'Diminuir fonte',
                        child: SizedBox(
                          width: 44,
                          height: 44,
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(22),
                              onTap: themeProvider.canDecreaseFont
                                  ? () async {
                                      await themeProvider.setFontScale(
                                        themeProvider.fontScale - 0.1,
                                      );
                                      setState(() {});
                                    }
                                  : null,
                              child: Center(
                                child: Text(
                                  'A',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    color: themeProvider.canDecreaseFont
                                        ? AppColors.primary
                                        : AppColors.textHint,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSizes.md),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: AppSizes.md,
                            horizontal: AppSizes.lg,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.muted,
                            borderRadius: BorderRadius.circular(AppSizes.radiusLg),
                          ),
                          child: Center(
                            child: Text(
                              'Exemplo de leitura',
                              style: TextStyle(
                                fontSize: 16 * themeProvider.fontScale,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSizes.md),
                      Semantics(
                        button: true,
                        label: 'Aumentar fonte',
                        child: SizedBox(
                          width: 44,
                          height: 44,
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(22),
                              onTap: themeProvider.canIncreaseFont
                                  ? () async {
                                      await themeProvider.setFontScale(
                                        themeProvider.fontScale + 0.1,
                                      );
                                      setState(() {});
                                    }
                                  : null,
                              child: Center(
                                child: Text(
                                  'A',
                                  style: TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.w700,
                                    color: themeProvider.canIncreaseFont
                                        ? AppColors.primary
                                        : AppColors.textHint,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSizes.xl),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Escala atual: ${themeProvider.fontScale.toStringAsFixed(1)}x',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: AppColors.textSecondary,
                              ),
                        ),
                      ),
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Pronto'),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = ThemeProvider.instance;

    return ListenableBuilder(
      listenable: themeProvider,
      builder: (context, _) {
        return IconButton(
          tooltip: 'Ajustar fonte',
          onPressed: () => _showFontSheet(context),
          icon: Icon(
            Icons.settings_outlined,
            color: AppColors.primary,
          ),
        );
      },
    );
  }
}
