import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/theme_scope.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/constants/app_sizes.dart';

class DailyQuoteCard extends StatelessWidget {
  const DailyQuoteCard({super.key});

  static const _quotes = [
    'Um passo de cada vez. Seu cérebro está fazendo o melhor que pode.',
    'Começar é a parte mais difícil. Você já está aqui.',
    'Progresso, não perfeição. Isso é o que importa.',
    'Seu cérebro funciona diferente, não errado.',
    'Pequenas vitórias constroem grandes conquistas.',
    'Você não precisa fazer tudo hoje. Só o próximo passo.',
    'Foco é uma habilidade. E você está praticando agora.',
  ];

  String get _todayQuote => _quotes[DateTime.now().day % _quotes.length];

  @override
  Widget build(BuildContext context) {
    ThemeScope.watch(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.format_quote_rounded,
                color: AppColors.primary,
                size: 28,
              ),
              const SizedBox(width: AppSizes.sm),
              Text('Frase do dia', style: AppTextStyles.progressSub),
            ],
          ),
          const SizedBox(height: AppSizes.md),
          Text(
            _todayQuote,
            style: AppTextStyles.authSubtitle.copyWith(
              fontStyle: FontStyle.italic,
              height: 1.45,
            ),
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: 500.ms, curve: Curves.easeOut);
  }
}
