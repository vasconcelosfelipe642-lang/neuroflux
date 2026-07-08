import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../core/constants/app_sizes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/theme_scope.dart';
import '../../domain/models/subtask_model.dart';
import '../../domain/models/task_model.dart';
import '../widgets/theme_toggle_button.dart';
import 'focus_screen.dart';

class FocusScreenState extends State<FocusScreen> {
  late List<TaskModel> _pending;
  int _currentIndex = 0;
  int _slideKey = 0;
  bool _isBusy = false;

  @override
  void initState() {
    super.initState();
    _pending = List.from(widget.pendingTasks);
  }

  TaskModel? get _currentTask =>
      _pending.isEmpty || _currentIndex >= _pending.length
          ? null
          : _pending[_currentIndex];

  int get _total => widget.pendingTasks.length;

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xFF3D3D5C),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(AppSizes.lg),
      ),
    );
  }

  Future<void> _toggleSubtask(SubtaskModel sub) async {
    final task = _currentTask;
    if (task == null || _isBusy) return;

    setState(() => _isBusy = true);
    try {
      final updated = await widget.onToggleSubtask(task, sub);
      if (!mounted) return;
      HapticFeedback.lightImpact();
      setState(() {
        _pending[_currentIndex] = updated;
      });
    } finally {
      if (mounted) setState(() => _isBusy = false);
    }
  }

  Future<void> _completeAndAdvance() async {
    final task = _currentTask;
    if (task == null || _isBusy) return;

    if (!task.canComplete) {
      _showMessage('Marque todas as subtarefas antes de concluir a tarefa.');
      return;
    }

    setState(() => _isBusy = true);
    try {
      await widget.onToggleTask(task);
      HapticFeedback.mediumImpact();

      if (!mounted) return;

      setState(() {
        _pending.removeAt(_currentIndex);
        if (_currentIndex >= _pending.length && _pending.isNotEmpty) {
          _currentIndex = 0;
        }
        _slideKey++;
      });
    } finally {
      if (mounted) setState(() => _isBusy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final task = _currentTask;
    final themeProvider = ThemeScope.watch(context);
    final isDark = themeProvider.isDark;
    final focusBackground = isDark
        ? const Color.fromARGB(255, 100, 100, 179)
        : const Color(0xFFF3F1FF);
    final headerIconColor = isDark ? Colors.white70 : const Color(0xFF5B5673);
    final headerTextColor = isDark ? Colors.white70 : const Color(0xFF5B5673);
    final progressBackgroundColor = isDark ? Colors.white24 : Colors.black12;

    return Scaffold(
      backgroundColor: focusBackground,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.pagePadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.close, color: headerIconColor),
                    tooltip: 'Sair do Foco',
                  ),
                  const Spacer(),
                  const ThemeToggleButton(),
                  if (_pending.isNotEmpty)
                    Text(
                      'Tarefa ${_currentIndex + 1} de $_total',
                      style: TextStyle(
                        color: headerTextColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                ],
              ),
              if (_pending.isNotEmpty) ...[
                const SizedBox(height: AppSizes.sm),
                ClipRRect(
                  borderRadius: BorderRadius.circular(AppSizes.radiusFull),
                  child: LinearProgressIndicator(
                    value: (_currentIndex + 1) / _total,
                    minHeight: 6,
                    backgroundColor: progressBackgroundColor,
                    valueColor: const AlwaysStoppedAnimation(AppColors.primary),
                  ),
                ),
              ],
              Expanded(
                child: _pending.isEmpty
                    ? _buildCongrats()
                    : _buildTaskFocus(task!, _slideKey),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCongrats() {
    final themeProvider = ThemeScope.watch(context);
    final isDark = themeProvider.isDark;
    final titleColor = isDark ? Colors.white : const Color(0xFF2D2A47);
    final bodyColor = isDark ? Colors.white70 : const Color(0xFF6A6782);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.celebration_rounded,
              size: 72, color: AppColors.primary),
          const SizedBox(height: AppSizes.lg),
          Text(
            'Parabéns!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: titleColor,
            ),
          ),
          const SizedBox(height: AppSizes.md),
          Text(
            'Você concluiu todas as tarefas pendentes no Modo Foco.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: bodyColor,
              height: 1.45,
            ),
          ),
          const SizedBox(height: AppSizes.xxl),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(200, 48),
            ),
            child: const Text('Voltar'),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskFocus(TaskModel task, int slideKey) {
    final themeProvider = ThemeScope.watch(context);
    final isDark = themeProvider.isDark;
    final titleColor = isDark ? Colors.white : const Color(0xFF2D2A47);
    final hintColor = isDark
        ? const Color.fromARGB(255, 255, 183, 77)
        : const Color(0xFFC96A00);
    final canComplete = task.canComplete;
    final hasSubtasks = task.hasSubtasks;

    return Column(
      key: ValueKey(slideKey),
      children: [
        Expanded(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                const SizedBox(height: AppSizes.lg),
                Text(
                  task.title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: titleColor,
                    height: 1.3,
                  ),
                ).animate().fadeIn(duration: 350.ms).slideX(
                      begin: 0.08,
                      end: 0,
                      duration: 350.ms,
                      curve: Curves.easeOutCubic,
                    ),
                if (hasSubtasks) ...[
                  const SizedBox(height: AppSizes.xl),
                  _buildSubtasksPanel(task),
                ],
              ],
            ),
          ),
        ),
        if (hasSubtasks && !canComplete)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSizes.md),
            child: Text(
              'Conclua ${task.completedSubtasks} de ${task.subtasks.length} subtarefas para avançar',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: hintColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: (_isBusy || !canComplete) ? null : _completeAndAdvance,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              disabledBackgroundColor:
                  AppColors.primary.withValues(alpha: 0.35),
              minimumSize: const Size(double.infinity, 52),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSizes.radiusFull),
              ),
            ),
            child: _isBusy
                ? const SizedBox(
                    height: 22,
                    width: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: Colors.white,
                    ),
                  )
                : Text(
                    hasSubtasks
                        ? 'Concluir tarefa e avançar'
                        : 'Concluir e avançar',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w700),
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildSubtasksPanel(TaskModel task) {
    final themeProvider = ThemeScope.watch(context);
    final isDark = themeProvider.isDark;
    final panelColor =
        isDark ? const Color.fromARGB(255, 116, 116, 170) : Colors.white;
    final panelBorderColor = isDark
        ? const Color.fromARGB(255, 122, 122, 248)
        : const Color(0xFFE0DDFC);
    final titleColor = isDark ? Colors.white : const Color(0xFF2D2A47);
    final progressBackgroundColor = isDark ? Colors.white12 : Colors.black12;
    final done = task.completedSubtasks;
    final total = task.subtasks.length;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSizes.lg),
      decoration: BoxDecoration(
        color: panelColor,
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        border: Border.all(color: panelBorderColor, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.checklist_rounded,
                  color: AppColors.primary, size: 22),
              const SizedBox(width: AppSizes.sm),
              Text(
                'Subtarefas',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: titleColor,
                ),
              ),
              const Spacer(),
              Text(
                '$done de $total',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.sm),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppSizes.radiusFull),
            child: LinearProgressIndicator(
              value: total == 0 ? 0 : done / total,
              minHeight: 4,
              backgroundColor: progressBackgroundColor,
              valueColor: const AlwaysStoppedAnimation(AppColors.primary),
            ),
          ),
          const SizedBox(height: AppSizes.md),
          ...task.subtasks.map(_buildSubtaskTile),
        ],
      ),
    );
  }

  Widget _buildSubtaskTile(SubtaskModel sub) {
    final themeProvider = ThemeScope.watch(context);
    final isDark = themeProvider.isDark;
    final titleColor = isDark ? Colors.white : const Color(0xFF2D2A47);
    final completedColor =
        isDark ? const Color(0xFF9A9AB0) : const Color(0xFF7D7A90);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: _isBusy ? null : () => _toggleSubtask(sub),
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        child: Padding(
          padding:
              const EdgeInsets.symmetric(vertical: AppSizes.sm, horizontal: 4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 34,
                height: 34,
                child: Checkbox(
                  value: sub.isCompleted,
                  onChanged: _isBusy ? null : (_) => _toggleSubtask(sub),
                  activeColor: AppColors.primary,
                  checkColor: Colors.white,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  visualDensity: VisualDensity.compact,
                  side: const BorderSide(color: Color(0xFF8A8AA8), width: 2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ),
              const SizedBox(width: AppSizes.sm),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    sub.title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      height: 1.35,
                      color: sub.isCompleted ? completedColor : titleColor,
                      decoration:
                          sub.isCompleted ? TextDecoration.lineThrough : null,
                      decorationColor: completedColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
