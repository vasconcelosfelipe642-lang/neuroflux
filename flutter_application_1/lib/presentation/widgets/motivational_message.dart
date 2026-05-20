import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/theme_scope.dart';
import '../../core/theme/app_text_styles.dart';
class MotivationalMessage extends StatelessWidget {
  final int completedTasks;
  final int totalTasks;

  const MotivationalMessage({
    super.key,
    required this.completedTasks,
    required this.totalTasks,
  });

  double get _progress =>
      totalTasks == 0 ? 0 : completedTasks / totalTasks;

  int get _percent => (_progress * 100).round();

  String get _message {
    if (_percent >= 100 && totalTasks > 0) {
      return 'Você conseguiu! Seu cérebro trabalhou duro hoje 🎉';
    }
    if (_percent >= 50) {
      return 'Incrível! Você está na metade. O fim está perto!';
    }
    if (_percent >= 1) {
      return 'Você já começou, e isso é o mais difícil! Continue.';
    }
    if (totalTasks == 0) {
      return 'Pronto para começar? Cada pequena etapa conta 💛';
    }
    return 'Sem pressa. Escolha uma tarefa e dê o primeiro passo.';
  }

  @override
  Widget build(BuildContext context) {
    ThemeScope.watch(context);

    return Text(
      _message,
      key: ValueKey(_message),
      textAlign: TextAlign.center,
      style: AppTextStyles.progressSub.copyWith(
        color: AppColors.textSecondary,
        fontSize: 14,
        height: 1.4,
      ),
    )
        .animate(key: ValueKey('motiv-$_message'))
        .fadeIn(duration: 400.ms, curve: Curves.easeOut);
  }
}
