import 'package:flutter/material.dart';
// import 'package:lottie/lottie.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/theme_scope.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/constants/app_sizes.dart';

class TaskListEmpty extends StatelessWidget {
  final VoidCallback onCreateTask;

  const TaskListEmpty({super.key, required this.onCreateTask});

  @override
  Widget build(BuildContext context) {
    ThemeScope.watch(context);

    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: 200),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        border: Border.all(
          color: AppColors.border,
          width: 1.5,
        ),
      ),
      padding: const EdgeInsets.all(AppSizes.xxl),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _EmptyIllustration(),
          const SizedBox(height: AppSizes.lg),
          Text(
            'Nenhuma tarefa ainda',
            style: AppTextStyles.emptyTitle,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSizes.xs),
          Text(
            'Adicionar tarefas pequenas ajuda o cérebro '
            'a focar. Que tal começar com algo simples?',
            style: AppTextStyles.emptySubtitle.copyWith(height: 1.45),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSizes.lg),
          OutlinedButton.icon(
            onPressed: onCreateTask,
            icon: const Icon(Icons.add_task, size: 18),
            label: const Text('Criar primeira tarefa'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primary,
              side: const BorderSide(color: AppColors.primary, width: 1.5),
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.lg,
                vertical: AppSizes.md,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSizes.radiusFull),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyIllustration extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Quando assets/animations/empty_state.json existir, use:
    // return Lottie.asset(
    //   'assets/animations/empty_state.json',
    //   width: 140,
    //   height: 140,
    //   fit: BoxFit.contain,
    //   errorBuilder: (_, __, ___) => _fallbackIcon(),
    // );
    return _fallbackIcon();
  }

  Widget _fallbackIcon() {
    return Container(
      width: 88,
      height: 88,
      decoration: BoxDecoration(
        color: AppColors.primaryLightTint,
        shape: BoxShape.circle,
      ),
      child: const Icon(
        Icons.checklist_rounded,
        size: 44,
        color: AppColors.primary,
      ),
    );
  }
}
